# Layer Rules
# Layout Rules
# Window Rules
{ ... }:
{
  wayland.windowManager.hyprland.settings = {

    #
    # ========== Layer Rules ==========
    #
    layer = [
      #"blur, rofi"
      #"ignorezero, rofi"
      #"ignorezero, logout_dialog"

    ];

    #
    # ========== layout rules ==========
    #
    dwindle = {
      preserve_split = true;
      pseudotile = true;
    };

    #
    # ========== Window Rules ==========
    #
    windowrule = [
      #
      # ========== Workspace Assignments ==========
      #
      # to determine class and title for all active windows, run `hyprctl clients`
      "workspace 8, class:^(obsidian)$"
      "workspace 9, class:^(brave-browser)$"
      "workspace 9, class:^(signal)$"
      "workspace 9, class:^(discord)$"
      "workspace 10, class:^(spotify)$"
      "workspace 10, class:^(CopyQ)$"
      "workspace 10, class:^(.virt-manager-wrapped)$"
      "workspace special, title:^(Proton VPN)$"
      "workspace special, class:^(yubioath-flutter)$"
      "workspace special, class:^(keymapp)$"

      #
      # ========== Tile on launch ==========
      #
      "tile, title:^(Proton VPN)$"

      #
      # ========== Float on launch ==========
      #
      "float, class:^(galculator)$"
      "float, class:^(waypaper)$"

      # Dialog windows
      "float, title:^(Open File)(.*)$"
      "float, title:^(Select a File)(.*)$"
      "float, title:^(Choose wallpaper)(.*)$"
      "float, title:^(Open Folder)(.*)$"
      "float, title:^(Save As)(.*)$"
      "float, title:^(Library)(.*)$"
      "float, title:^(Accounts)(.*)$"
      "float, title:^(Text Import)(.*)$"
      "float, title:^(File Operation Progress)(.*)$"
      #"float, focus 0, title:^()$, class:^([Ff]irefox)"
      "float, noinitialfocus, title:^()$, class:^([Ff]irefox)"

      #
      # ========== Always opaque ==========
      #
      "opaque, class:^([Gg]imp)$"
      "opaque, class:^([Ff]lameshot)$"
      "opaque, class:^([Ii]nkscape)$"
      "opaque, class:^([Bb]lender)$"
      "opaque, class:^([Oo][Bb][Ss])$"
      "opaque, class:^([Ss]team)$"
      "opaque, class:^([Ss]team_app_*)$"
      "opaque, class:^([Vv]lc)$"
      "opaque, title:^(btop)(.*)$"
      "opaque, title:^(amdgpu_top)(.*)$"
      "opaque, title:^(Dashboard | glass*)(.*)$"
      "opaque, title:^(Live video from*)(.*)$"

      # Remove transparency from video
      "opaque, title:^(Netflix)(.*)$"
      "opaque, title:^(.*YouTube.*)$"
      "opaque, title:^(Picture-in-Picture)$"

      #
      # ========== Scratch rules ==========
      #
      #"size 80% 85%, workspace:^(special)$"
      #"center, workspace:^(special)$"

      #
      # ========== Steam rules ==========
      #
      "minsize 1 1, title:^()$,class:^([Ss]team)$"
      "immediate, class:^([Ss]team_app_*)$"
      "workspace 7, class:^([Ss]team_app_*)$"
      "monitor 0, class:^([Ss]team_app_*)$"

      #
      # ========== Fameshot rules ==========
      #
      # flameshot currently doesn't have great wayland support so needs some tweaks
      #"rounding 0, class:^([Ff]lameshot)$"
      #"noborder, class:^([Ff]lameshot)$"
      #"float, class:^([Ff]lameshot)$"
      #"move 0 0, class:^([Ff]lameshot)$"
      #"suppressevent fullscreen, class:^([Ff]lameshot)$"
      # "monitor:DP-1, ${flameshot}"
    ];
  };
}
