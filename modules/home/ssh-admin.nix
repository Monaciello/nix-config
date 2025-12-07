# FIXME(roles): This eventually should get slotted into some sort of 'role' thing
{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.hostSpec;
in
lib.mkIf cfg.isAdmin {
  sshAutoEntries = {
    enable = true;
    ykDomainHosts = [
      "genoa"
      "ghost"
      "gooey" # confirm
      "grief"
      "guppy"
      "gusto"
    ];
    ykNoDomainHosts = [
      "myth"
      cfg.networking.subnets.glade.wildcard
      cfg.networking.subnets.grove.wildcard
      cfg.networking.subnets.vm-lan.wildcard
    ]
    ++ lib.optional cfg.isWork inputs.nix-secrets.work.git.servers;
  };
  programs.ssh.matchBlocks =
    let
      # ===== non-nixos hosts on internal subnets =====

      # TODO:
      # gladeSubnetHosts= [
      # ];
      groveSubnetHosts = [
        "glass"
        "gooey"
        "guard"
      ];
      extraSubnetEntries =
        hosts: subnet:
        hosts
        |> lib.lists.map (host: {
          "${host}" = lib.hm.dag.entryAfter [ "yubikey-hosts" ] {
            match = "host ${host},${host}.${config.hostSpec.domain}";
            hostname = "${host}.${config.hostSpec.domain}";
            user = config.hostSpec.networking.subnets.${subnet}.hosts.${host}.user;
            port = config.hostSpec.networking.subnets.${subnet}.hosts.${host}.sshPort;
          };
        })
        |> lib.attrsets.mergeAttrsList;
    in
    {
      # external hosts with
      "moth" = lib.hm.dag.entryAfter [ "yubikey-hosts" ] {
        host = "moth";
        hostname = "moth.${config.hostSpec.domain}";
        user = "${config.hostSpec.username}";
        port = config.hostSpec.networking.ports.tcp.moth;
      };
      # "myth" = lib.hm.dag.entryAfter [ "yubikey-hosts" ] {
      #   host = "myth ${inputs.nix-secrets.networking.domains.myth}";
      #   hostname = "${inputs.nix-secrets.networking.domains.myth}";
      #   user = "admin";
      #   port = config.hostSpec.networking.ports.tcp.myth;
      # };
    }
    # // (extraSubnetEntries gladeSubnetHosts "glade")
    // (extraSubnetEntries groveSubnetHosts "grove");
}
