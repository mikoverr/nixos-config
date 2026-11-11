#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# CONFIGURATION & VARIABLES
# ==============================================================================
BASE_CONFIG_DIR="/etc/nixos"
THIS_CONFIG_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
HOST_FILE="$THIS_CONFIG_DIR/.installed_host"
FINAL_TARGET_HOST=""

# Colors for logs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # no color

# ==============================================================================
# HELPER FUNCTIONS
# ==============================================================================
log_info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

show_help() {
    echo "Usage: gonix <command> [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  install       Perform fresh installation or link existing config and rebuild"
    echo "  rebuild       Rebuild system, deploy dotfiles, or run scripts"
    echo "  help          Show this help"
    echo ""
    echo "Options for 'rebuild':"
    echo "  --targets [all|nix|dots|scripts]...   Specify which parts to deploy (default: all)"
    echo "  --users   [all|<username>]...         Specify which users to process (default: all)"
    echo ""
    echo "Examples:"
    echo "  ./gonix.sh install"
    echo "  ./gonix.sh rebuild --target nix"
    echo "  ./gonix.sh rebuild --users alek --targets dots scripts"
    exit 0
}

ensure_executable() {
    log_info "Ensuring all .sh scripts in repo are executable..."
    find "$THIS_CONFIG_DIR" -name "*.sh" -exec chmod +x {} +
    chmod +x "$THIS_CONFIG_DIR/gonix.sh"
}

fix_repo_permissions() {
    log_info "Setting read permissions for root on the repository..."
    chmod -R o+rX "$THIS_CONFIG_DIR"
    local dir="$THIS_CONFIG_DIR"
    while [[ "$dir" != "/" ]]; do
        chmod o+x "$dir" 2>/dev/null || true
        dir="$(dirname "$dir")"
    done
}

require_not_etc_nixos() {
    if [[ "$THIS_CONFIG_DIR" == "$BASE_CONFIG_DIR" || "$THIS_CONFIG_DIR" == "$BASE_CONFIG_DIR/"* ]]; then
        log_error "The repository cannot be located inside /etc/nixos."
        log_error "Please clone it to another directory (e.g., ~/nixos-config) and run from there."
        exit 1
    fi
}

get_installed_host() {
    if [[ -f "$HOST_FILE" ]]; then
        cat "$HOST_FILE"
    else
        echo ""
    fi
}

select_host_interactive() {
    local hosts_dir="$THIS_CONFIG_DIR/hosts"
    local available_hosts=()

    if [[ ! -d "$hosts_dir" ]]; then
        log_error "Hosts directory not found at $hosts_dir"
        exit 1
    fi

    for h in "$hosts_dir"/*; do
        [[ -d "$h" ]] && available_hosts+=("$(basename "$h")")
    done

    if [[ ${#available_hosts[@]} -eq 0 ]]; then
        log_error "No hosts found in $hosts_dir!"
        exit 1
    elif [[ ${#available_hosts[@]} -eq 1 ]]; then
        echo "${available_hosts[0]}"
        return 0
    fi

    echo "Available hosts:" >&2
    for i in "${!available_hosts[@]}"; do
        echo "  [$((i+1))] ${available_hosts[i]}" >&2
    done

    local choice
    while true; do
        read -rp "Select host number: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#available_hosts[@]} )); then
            echo "${available_hosts[((choice-1))]}"
            return 0
        else
            log_error "Invalid selection. Please enter a number between 1 and ${#available_hosts[@]}." >&2
        fi
    done
}

# ==============================================================================
# CUSTOMIZATION LOGIC
# ==============================================================================
customize_installation() {
    local initial_host="$1"
    local hosts_dir="$THIS_CONFIG_DIR/hosts"
    local current_host="$initial_host"

    echo ""
    log_info "=== PRE-INSTALLATION CUSTOMIZATION ==="

    # --- 1. Update System Version (Channels) ---
    local installer_version
    installer_version=$(nixos-version | grep -oE '^[0-9]+\.[0-9]+' || true)

    if [[ -z "$installer_version" ]]; then
        log_warn "Could not auto-detect NixOS version."
        read -rp "Enter NixOS version to use (e.g., 26.05): " installer_version
    else
        log_info "Detected NixOS version: $installer_version"
    fi

    read -rp "Do you want to update channel versions in config files to $installer_version? (y/N): " update_ver
    if [[ "$update_ver" =~ ^[Yy]$ ]]; then
        log_info "Updating flake.nix channels to $installer_version..."
        # Replacing nixos-XX.YY and release-XX.YY in flake.nix
        sed -i -E "s|nixos-[0-9]+\.[0-9]+|nixos-${installer_version}|g" "$THIS_CONFIG_DIR/flake.nix"
        sed -i -E "s|release-[0-9]+\.[0-9]+|release-${installer_version}|g" "$THIS_CONFIG_DIR/flake.nix"

        log_info "Updating system.stateVersion in configuration.nix..."
        sed -i -E "s|system\.stateVersion = \"[0-9]+\.[0-9]+\";|system.stateVersion = \"${installer_version}\";|g" \
            "$hosts_dir/$current_host/users/root/configuration/configuration.nix"

        # Updating flake.lock for new channels
        log_info "Updating flake.lock (this may take a minute)..."
        (cd "$THIS_CONFIG_DIR" && nix flake update)

        log_success "Versions updated to $installer_version."
    fi

    # --- 2. Rename Host (Files first) ---
    local new_host
    read -rp "Enter a custom hostname (or press Enter to keep '$current_host'): " new_host

    if [[ -n "$new_host" && "$new_host" != "$current_host" ]]; then
        if [[ ! "$new_host" =~ ^[a-zA-Z0-9_-]+$ ]]; then
            log_error "Invalid hostname. Use only letters, numbers, dashes, and underscores."
            exit 1
        fi

        log_info "Updating hostname to '$new_host' in files..."
        # Updating flake.nix
        sed -i "s/\b$current_host\b/$new_host/g" "$THIS_CONFIG_DIR/flake.nix"

        # Updating networking.nix
        local net_nix="$hosts_dir/$current_host/users/root/configuration/modules/networking.nix"
        if [[ -f "$net_nix" ]]; then
            sed -i "s/\b$current_host\b/$new_host/g" "$net_nix"
        fi

        # --- 3. Rename Host (Folder second) ---
        log_info "Renaming host directory '$current_host' -> '$new_host'..."
        mv "$hosts_dir/$current_host" "$hosts_dir/$new_host"

        current_host="$new_host"
        log_success "Host renamed to '$current_host'."
    fi

    # --- 4. Rename Users (Files first) ---
    local users_dir="$hosts_dir/$current_host/users"
    # An array for storing pairs of "old_name:new_name" to rename folders after
    local users_to_rename=()

    if [[ -d "$users_dir" ]]; then
        for u_path in "$users_dir"/*; do
            [[ -d "$u_path" ]] || continue
            local old_user
            old_user=$(basename "$u_path")

            if [[ "$old_user" == "root" ]]; then
                continue
            fi

            local new_user
            read -rp "Enter a new name for user '$old_user' (or press Enter to keep): " new_user

            if [[ -n "$new_user" && "$new_user" != "$old_user" ]]; then
                if [[ ! "$new_user" =~ ^[a-zA-Z0-9_-]+$ ]]; then
                    log_error "Invalid username. Use only letters, numbers, dashes, and underscores."
                    exit 1
                fi

                log_info "Updating username '$old_user' -> '$new_user' in targeted files..."

                # 1. root/configuration/modules/users.nix
                local root_users_nix="$users_dir/root/configuration/modules/users.nix"
                if [[ -f "$root_users_nix" ]]; then
                    sed -i "s/\b$old_user\b/$new_user/g" "$root_users_nix"
                fi

                # 2. <username>/home-manager/home.nix
                local hm_home_nix="$u_path/home-manager/home.nix"
                if [[ -f "$hm_home_nix" ]]; then
                    sed -i "s/\b$old_user\b/$new_user/g" "$hm_home_nix"
                fi

                # Saving folders for renaming
                users_to_rename+=("$old_user:$new_user")
                log_success "User config updated to '$new_user'."
            fi
        done
    fi

    # --- 5. Rename Users (Folders second) ---
    if [[ ${#users_to_rename[@]} -gt 0 ]]; then
        for pair in "${users_to_rename[@]}"; do
            local old_name="${pair%%:*}"
            local new_name="${pair##*:}"

            log_info "Renaming user directory '$old_name' -> '$new_name'..."
            mv "$users_dir/$old_name" "$users_dir/$new_name"
        done
    fi

    echo ""
    FINAL_TARGET_HOST="$current_host"
}

# ==============================================================================
# DOTFILES & SCRIPTS LOGIC (For Rebuild)
# ==============================================================================
get_users_dir() {
    local host_name="$1"
    echo "$THIS_CONFIG_DIR/hosts/$host_name/users"
}

run_user_scripts() {
    local phase="$1"
    local user="$2"
    local users_dir="$3"
    local src_scripts="$users_dir/$user/scripts/$phase"

    if [[ -d "$src_scripts" && "$(ls -A "$src_scripts" 2>/dev/null)" ]]; then
        log_info "[User: $user] Executing $phase scripts..."
        local user_home
        user_home=$(getent passwd "$user" | cut -d: -f6 || echo "/home/$user")
        [[ "$user" == "root" ]] && user_home="/root"

        for script in "$src_scripts"/*; do
            [[ -f "$script" ]] || continue
            local script_name
            script_name="$(basename "$script")"

            chmod +x "$script"
            log_info "Running $script_name..."
            # Run as a user with the correct HOME
            if sudo -u "$user" env HOME="$user_home" bash "$script"; then
                log_success "$script_name completed."
            else
                log_warn "$script_name exited with an error!"
            fi
        done
    fi
}

deploy_dotfiles() {
    local user="$1"
    local users_dir="$2"
    local src_dots="$users_dir/$user/dotfiles"

    if [[ ! -d "$src_dots" ]]; then
        return 0
    fi

    local user_home
    user_home=$(getent passwd "$user" | cut -d: -f6 || echo "")
    if [[ -z "$user_home" ]]; then
        [[ "$user" == "root" ]] && user_home="/root" || user_home="/home/$user"
    fi

    log_info "[User: $user] Deploying dotfiles..."
    local target_cfg="$user_home/.config"
    local backup_base="$user_home/.config.bkp"
    local backup_dir="$backup_base/bkp_$(date +%Y%m%d_%H%M%S)"
    local backup_created=false

    sudo mkdir -p "$target_cfg"
    sudo chown "$user" "$target_cfg"

    for item in "$src_dots"/*; do
        [[ -e "$item" ]] || continue
        local base_item
        base_item="$(basename "$item")"

        local target_item="$target_cfg/$base_item"
        local current_link=""

        if [[ -e "$target_item" ]]; then
            [[ -L "$target_item" ]] && current_link="$(readlink -f "$target_item")"

            # If this is an old symlink from the nix-store, just delete it.
            if [[ "$current_link" == /nix/store/* ]]; then
                sudo rm -rf "$target_item"
            # If this is an old symlink to our repository, delete it.
            elif [[ "$current_link" == "$item"* ]]; then
                sudo rm -rf "$target_item"
            # If it's a real file that we didn't create
            else
                if [[ "$backup_created" == false ]]; then
                    sudo mkdir -p "$backup_dir"
                    sudo chown -R "$user" "$backup_dir"
                    backup_created=true
                fi
                log_warn "Backing up existing $base_item to $backup_dir"
                sudo mv "$target_item" "$backup_dir/$base_item"
            fi
        fi

        # Creating a symlink to the repository
        sudo ln -sfn "$item" "$target_item"
        sudo chown -h "$user" "$target_item"
        echo "  [link] $target_item -> $item"
    done

    if [[ "$backup_created" == true ]]; then
        log_success "Conflicting items backed up to $backup_dir"
    fi
}

# ==============================================================================
# INSTALL COMMANDS
# ==============================================================================
do_fresh_install() {
    local target_host="$1"
    log_info "Starting FRESH installation for host '$target_host'..."

    local hw_cfg_dest="$THIS_CONFIG_DIR/hosts/$target_host/users/root/configuration/hardware-configuration.nix"

    log_info "Generating hardware configuration from /mnt..."
    sudo nixos-generate-config --root /mnt

    log_info "Copying hardware-configuration.nix to repository..."
    sudo mkdir -p "$(dirname "$hw_cfg_dest")"
    sudo cp "/mnt/etc/nixos/hardware-configuration.nix" "$hw_cfg_dest"
    sudo chown -R "$USER:$USER" "$THIS_CONFIG_DIR"

    log_info "Starting nixos-install (Flakes)..."
    cd "$THIS_CONFIG_DIR"
    git add -A || true

    sudo nixos-install --flake "$THIS_CONFIG_DIR#$target_host" --option experimental-features "nix-command flakes"

    echo "$target_host" > "$HOST_FILE"
    log_success "Fresh installation complete! Reboot to enter your new system."
}

do_reinstall() {
    local target_host="$1"
    log_info "Starting REINSTALL (overwrite) for host '$target_host'..."

    local hw_cfg_dest="$THIS_CONFIG_DIR/hosts/$target_host/users/root/configuration/hardware-configuration.nix"

    # 1. Backup /etc/nixos
    if [[ -d "$BASE_CONFIG_DIR" || -L "$BASE_CONFIG_DIR" ]]; then
        if [[ -L "$BASE_CONFIG_DIR" ]]; then
            sudo rm "$BASE_CONFIG_DIR"
        else
            log_info "Backing up $BASE_CONFIG_DIR to ${BASE_CONFIG_DIR}.bkp..."
            sudo mv "$BASE_CONFIG_DIR" "${BASE_CONFIG_DIR}.bkp"
        fi
    fi

    # 2. Copying hardware-configuration.nix
    if [[ ! -f "$hw_cfg_dest" ]]; then
        if [[ -f "${BASE_CONFIG_DIR}.bkp/hardware-configuration.nix" ]]; then
            log_info "Copying hardware-configuration.nix from backup..."
            sudo mkdir -p "$(dirname "$hw_cfg_dest")"
            sudo cp "${BASE_CONFIG_DIR}.bkp/hardware-configuration.nix" "$hw_cfg_dest"
            sudo chown -R "$USER:$USER" "$THIS_CONFIG_DIR"
        else
            log_warn "hardware-configuration.nix not found in backup. Build might fail!"
        fi
    fi

    # 3. Symlink /etc/nixos -> repo
    log_info "Creating symlink /etc/nixos -> $THIS_CONFIG_DIR..."
    sudo ln -sfn "$THIS_CONFIG_DIR" "$BASE_CONFIG_DIR"

    # 4. Build
    log_info "Running initial nixos-rebuild switch..."
    cd "$THIS_CONFIG_DIR"
    git add -A || true
    sudo nixos-rebuild switch --flake "$THIS_CONFIG_DIR#$target_host" --option experimental-features "nix-command flakes"

    echo "$target_host" > "$HOST_FILE"
    log_success "Installation complete! Host '$target_host' saved."
}

do_install() {
    require_not_etc_nixos
    ensure_executable

    local target_host
    target_host=$(select_host_interactive)
    log_info "Selected host: $target_host"

    # --- Customization step ---
    customize_installation "$target_host"
    target_host="$FINAL_TARGET_HOST"

    if [[ -d "/mnt/etc" ]]; then
        do_fresh_install "$target_host"
    elif [[ -d "$BASE_CONFIG_DIR" || -L "$BASE_CONFIG_DIR" ]]; then
        do_reinstall "$target_host"
    else
        log_error "Could not detect /mnt (fresh install) or /etc/nixos (reinstall)."
        log_error "If fresh, please mount your disks to /mnt."
        exit 1
    fi

    fix_repo_permissions
}

# ==============================================================================
# REBUILD COMMAND
# ==============================================================================
do_rebuild() {
    require_not_etc_nixos
    ensure_executable

    local current_host
    current_host="$(get_installed_host)"

    if [[ -z "$current_host" ]]; then
        log_error "Host is not defined yet (.installed_host not found)."
        log_info "Please run './gonix.sh install' first."
        exit 1
    fi

    local hw_cfg="$THIS_CONFIG_DIR/hosts/$current_host/users/root/configuration/hardware-configuration.nix"
    if [[ ! -f "$hw_cfg" ]]; then
        log_error "hardware-configuration.nix not found for host '$current_host'!"
        exit 1
    fi

    # Making sure that the /etc/nixos symlink is in place
    if [[ "$(readlink -f "$BASE_CONFIG_DIR")" != "$THIS_CONFIG_DIR" ]]; then
        log_info "Updating system symlink $BASE_CONFIG_DIR -> $THIS_CONFIG_DIR..."
        sudo ln -sfn "$THIS_CONFIG_DIR" "$BASE_CONFIG_DIR"
    fi

    # Argument parsing
    local TARGETS=()
    local USERS=()

    shift # removing "rebuild" from the arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --targets|--target)
                shift
                while [[ $# -gt 0 && ! "$1" == --* ]]; do TARGETS+=("$1"); shift; done
                ;;
            --users|--user)
                shift
                while [[ $# -gt 0 && ! "$1" == --* ]]; do USERS+=("$1"); shift; done
                ;;
            -h|--help) show_help ;;
            *) log_error "Unknown argument '$1'"; exit 1 ;;
        esac
    done

    [[ ${#TARGETS[@]} -eq 0 ]] && TARGETS=("all")
    [[ ${#USERS[@]} -eq 0 ]] && USERS=("all")

    local VALID_TARGETS=("all" "nix" "dots" "scripts")
    for t in "${TARGETS[@]}"; do
        if [[ ! " ${VALID_TARGETS[*]} " =~ " $t " ]]; then
            log_error "Invalid target '$t'. Valid: ${VALID_TARGETS[*]}"
            exit 1
        fi
    done

    local users_dir
    users_dir="$(get_users_dir "$current_host")"
    local USERS_TO_PROCESS=()

    if [[ " ${USERS[*]} " =~ " all " ]]; then
        for u in "$users_dir"/*; do
            [[ -d "$u" ]] && USERS_TO_PROCESS+=("$(basename "$u")")
        done
    else
        for u in "${USERS[@]}"; do
            if [[ -d "$users_dir/$u" ]]; then
                USERS_TO_PROCESS+=("$u")
            else
                log_error "User '$u' not found in $users_dir"
                exit 1
            fi
        done
    fi

    # --- Execute ---

    if [[ " ${TARGETS[*]} " =~ " all " || " ${TARGETS[*]} " =~ " scripts " || " ${TARGETS[*]} " =~ " dots " ]]; then
        for u in "${USERS_TO_PROCESS[@]}"; do
            if [[ " ${TARGETS[*]} " =~ " all " || " ${TARGETS[*]} " =~ " scripts " ]]; then
                run_user_scripts "pre" "$u" "$users_dir"
            fi
            if [[ " ${TARGETS[*]} " =~ " all " || " ${TARGETS[*]} " =~ " dots " ]]; then
                deploy_dotfiles "$u" "$users_dir"
            fi
        done
    fi

    if [[ " ${TARGETS[*]} " =~ " all " || " ${TARGETS[*]} " =~ " nix " ]]; then
        log_info "Starting NixOS rebuild for host '$current_host'..."
        cd "$THIS_CONFIG_DIR"
        git add -A || true
        sudo nixos-rebuild switch --flake "$THIS_CONFIG_DIR#$current_host" --option experimental-features "nix-command flakes"
        log_success "System successfully rebuilt!"
    fi

    if [[ " ${TARGETS[*]} " =~ " all " || " ${TARGETS[*]} " =~ " scripts " ]]; then
        for u in "${USERS_TO_PROCESS[@]}"; do
            run_user_scripts "post" "$u" "$users_dir"
        done
    fi

    fix_repo_permissions
    log_success "Done."
}

# ==============================================================================
# MAIN ROUTER
# ==============================================================================
run() {
    if [[ $# -eq 0 ]]; then
        show_help
    fi

    local cmd="$1"
    case "$cmd" in
        install)
            do_install "$@"
            ;;
        rebuild)
            do_rebuild "$@"
            ;;
        -h|--help|help)
            show_help
            ;;
        *)
            log_error "Unknown command '$cmd'"
            show_help
            ;;
    esac
}

run "$@"
