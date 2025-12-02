{
  pkgs,
  ...
}:
{
  #enables custom module/home/starship instead of programs.starship directly
  starship = {
    enable = true;
    package = pkgs.unstable.starship;
  };
}
