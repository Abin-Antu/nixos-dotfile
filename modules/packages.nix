{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    opencode
    cursor-cli
    neovim
    git
    stable.gh
    wget
    fastfetch
    curl
    htop
    librewolf
    firefox
    brave-origin
    alacritty
    zed-editor
  ];
}
