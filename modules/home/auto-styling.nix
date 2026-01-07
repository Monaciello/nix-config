{
  lib,
  osConfig,
  ...
}:
{
  config = lib.mkIf osConfig.hostSpec.isAutoStyled {
    stylix.targets.zellij.enable = true;
  };
}
