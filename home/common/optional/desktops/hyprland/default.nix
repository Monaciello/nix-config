{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    # extra settings
    ./binds.nix
    ./rules.nix
    ./scripts.nix

    #hyprland utilities
    ./hyprlock.nix
    ./wlogout.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
    systemd = {
      enable = true;
      variables = [ "--all" ]; # fix for https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
    };

    settings = {
      debug = {
        disable_logs = true;
      };
      #
      # ========== Environment Vars ==========
      #
      env = [
        "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
        "MOZ_WEBRENDER, 1" # for firefox to run on wayland
        "XDG_SESSION_TYPE,wayland"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
        "QT_QPA_PLATFORM,wayland"
      ];

      #
      # ========== Monitor ==========
      #
      # parse the monitor spec defined in nix-config/home/<user>/<host>.nix
      monitor = (
        map (
          m:
          "${m.name},${
            if m.enabled then
              "${toString m.width}x${toString m.height}@${toString m.refreshRate}"
              + ",${toString m.x}x${toString m.y},1"
              + ",transform,${toString m.transform}"
              + ",vrr,${toString m.vrr}"
            else
              "disable"
          }"
        ) (config.monitors)
      );

      workspace = (
        let
          workspaceIDs = lib.flatten [
            (lib.range 1 10) # workspaces 1 through 10, Hyprland does not allow ws 0 :/
            "special" # add the special/scratchpad ws
          ];
          isPrimary = x: x ? primary && x.primary;
          primary = lib.lists.findFirst isPrimary { } config.monitors;
        in
        # workspace structure to build "[workspace], monitor:[name], default:[bool], persistent:[bool]"
        map (
          id:
          let
            id_as_string = toString id;
            # determine if the monitor is intended to display a specific workspace
            monitor = lib.lists.findFirst (
              x: x ? "workspace" && id_as_string == x.workspace
            ) primary config.monitors;
            # workspace 1 and any workspaces specific to the non-primary monitors are persistent
            persistent = if (id == 1 || !(isPrimary monitor)) then ", persistent:true" else "";
          in
          "${id_as_string}, monitor:${monitor.name}, default:true" + persistent
        ) workspaceIDs
      );
      #
      # ========== Behavior ==========
      #
      binds = {
        workspace_center_on = 1; # Whether switching workspaces should center the cursor on the workspace (0) or on the last active window for that workspace (1)
        movefocus_cycles_fullscreen = false; # If enabled, when on a fullscreen window, movefocus will cycle fullscreen, if not, it will move the focus in a direction.
      };
      input = {
        numlock_by_default = true; # numlock key disabled via keyd in nixos.nix
        follow_mouse = 2;
        # follow_mouse options:
        # 0 - Cursor movement will not change focus.
        # 1 - Cursor movement will always change focus to the window under the cursor.
        # 2 - Cursor focus will be detached from keyboard focus. Clicking on a window will move keyboard focus to that window.
        # 3 - Cursor focus will be completely separate from keyboard focus. Clicking on a window will not change keyboard focus.
        mouse_refocus = false;
        touchpad = {
          disable_while_typing = true;
        };
      };
      cursor.inactive_timeout = 10;
      misc = {
        disable_hyprland_logo = true;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        #disable_autoreload = true;
        new_window_takes_over_fullscreen = 2; # 0 - behind, 1 - takes over, 2 - unfullscreen/unmaxize
        middle_click_paste = false;
      };

      #
      # ========== Appearance ==========
      #
      general = {
        gaps_in = 6;
        gaps_out = 6;
        border_size = 0;
        resize_on_border = true;
        hover_icon_on_border = true;
        allow_tearing = true; # used to reduce latency and/or jitter in games
      };
      decoration = {
        active_opacity = 1.0;
        inactive_opacity = 0.85;
        fullscreen_opacity = 1.0;
        rounding = 15;
        rounding_power = 1;
        blur = {
          enabled = true;
          size = 4;
          passes = 2;
          new_optimizations = true;
          popups = true;
        };
        shadow = {
          enabled = true;
          range = 12;
          #offset = "3 3";
          color = lib.mkForce "0xFFFF9400";
          color_inactive = lib.mkForce "0xFF2D2D30";
        };
      };
      group = {
        "col.border_active" = lib.mkForce "0xFFFF9400";
        "col.border_inactive" = lib.mkForce "0xFF2D2D30";
        groupbar = {
          indicator_height = 0;
          gradients = true;
          gradient_rounding = 4;
          gradient_rounding_power = 1;
          font_size = 12;
          font_weight_active = "bold";
          font_weight_inactive = "bold";
          text_color = lib.mkForce "0xFF212F3D";
          text_color_inactive = lib.mkForce "0xFFD5C7A1";
          "col.active" = lib.mkForce "0xAAFF9400";
          "col.inactive" = lib.mkForce "0x55504945";
        };
      };

      #
      # ========== Auto Launch ==========
      #
      # exec-once = "${startupScript}/path";
      # To determine path, run `which foo`
      exec-once =
        if config.hostSpec.hostName == "ghost" then
          [
            "[workspace 8 silent]obsidian"
            "[workspace 8 silent]copyq"
            "[workspace 9 silent]signal-desktop"
            "[workspace 9 silent]discord"
            "[workspace 9 silent]brave"
            "[workspace 10 silent]ghostty --title=btop -e btop"
            "[workspace 10 silent]spotify"
            #"[workspace 10 silent]ghostty --title=amdgpu_top -e amdgpu_top --dark" # don't reference often enough
            #"[workspace 10 silent]virt-manager"
            "[workspace special silent]/run/current-system/sw/bin/protonvpn-app"
            "[workspace special silent]yubioath-flutter"
            "[workspace special silent]keymapp"
          ]
        else if config.hostSpec.isRoaming then
          [
            "[workspace 9 silent]signal-desktop"
            "[workspace 1 silent]copyq"
            "[workspace special silent]yubioath-flutter"
            "[workspace special silent]/run/current-system/sw/bin/protonvpn-app"
          ]
        else
          [

          ];
    };

  };

  programs.zsh.shellAliases = {
    hc = "hyprctl";
    hcc = "hyprctl clients";
    hcm = "hyprctl monitors";
  };
}
