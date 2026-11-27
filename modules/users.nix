# The single user account. Set its password after install with `passwd`.
{
  users.users.thohlt = {
    isNormalUser = true;
    description = "Thilo";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
}
