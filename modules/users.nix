# The single user account. Set its password after install with `passwd`.
{
  # TODO: replace "thilo" with your username.
  users.users.thilo = {
    isNormalUser = true;
    description = "Thilo";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
}
