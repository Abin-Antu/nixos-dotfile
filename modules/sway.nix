{ pkgs, ... }:

let
  # Scripts + cycle helper from the dotfiles repo, with exec bits preserved so
  # the bindings can run them straight out of the store.
  swayScripts = pkgs.runCommand "sway-scripts" { } ''
    mkdir -p $out
    cp -r ${../sway/custom_scripts} $out/custom_scripts
    chmod -R u+w $out/custom_scripts
    chmod +x $out/custom_scripts/*.sh
    install -Dm755 ${../sway/sway-cycle} $out/sway-cycle
  '';
in
{
  programs.sway = {
    enable = true;

    # The first seven are the module defaults (setting extraPackages replaces
    # them), the rest are what the config actually invokes.
    extraPackages = with pkgs; [
      brightnessctl
      grim
      pulseaudio
      swayidle
      swaylock
      wmenu
      fuzzel
      mako
      networkmanagerapplet
      lf
      playerctl
      wl-clipboard
      slurp
      fd
      jq
      wlrctl
    ];

    # Matches what the config asks for in its PERFORMANCE section.
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export ELECTRON_OZONE_PLATFORM_HINT=auto
      export LIBVA_DRIVER_NAME=i965
      export VDPAU_DRIVER=va_gl
    '';
  };

  # Overrides the module's mkOptionDefault (the stock config) — this is the
  # config from dotfiles@HEAD, NixOS-adapted.
  environment.etc."sway/config".source = ../sway/config;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # The config addresses these by ~-path, so plant them in both homes.
  systemd.tmpfiles.rules = [
    "d /root/Pictures 0755 root root -"
    "d /home/abin/Pictures 0755 abin users -"
    "L+ /root/Pictures/artix-wallpaper.png - - - - ${../sway/wallpapers/artix-wallpaper.png}"
    "L+ /root/Pictures/lock_wallpaper.png - - - - ${../sway/wallpapers/lock_wallpaper.png}"
    "L+ /home/abin/Pictures/artix-wallpaper.png - - - - ${../sway/wallpapers/artix-wallpaper.png}"
    "L+ /home/abin/Pictures/lock_wallpaper.png - - - - ${../sway/wallpapers/lock_wallpaper.png}"

    "L+ /root/.config/custom_scripts - - - - ${swayScripts}/custom_scripts"
    "L+ /home/abin/.config/custom_scripts - - - - ${swayScripts}/custom_scripts"

    "d /root/.local/bin 0755 root root -"
    "L+ /root/.local/bin/sway-cycle - - - - ${swayScripts}/sway-cycle"
    "L+ /home/abin/.local/bin/sway-cycle - - - - ${swayScripts}/sway-cycle"

    "d /root/.config/swaylock 0755 root root -"
    "d /home/abin/.config/swaylock 0755 abin users -"
    "L+ /root/.config/swaylock/config - - - - ${../sway/swaylock-config}"
    "L+ /home/abin/.config/swaylock/config - - - - ${../sway/swaylock-config}"
  ];
}
