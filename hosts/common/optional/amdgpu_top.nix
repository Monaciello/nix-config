{ lib, pkgs, ... }:
{
  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      amdgpu_top
      ;
  };

}
