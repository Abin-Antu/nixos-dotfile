{
  security.sudo.wheelNeedsPassword = true;

  users.users.abin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "lp" ];
  };
}
