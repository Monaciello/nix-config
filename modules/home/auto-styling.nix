{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.hostSpec.isAutoStyled {
    stylix.targets.zellij.enable = true;
  };
}
