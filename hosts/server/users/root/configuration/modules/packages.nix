{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    git
    iptables
    curl
    wget
    htop
    btop
    tmux
    ripgrep
    jq
    rsync
    # docker-compose # included with docker
  ];
}
