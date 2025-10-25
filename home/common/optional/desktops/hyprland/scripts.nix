{
  lib,
  config,
  pkgs,
  ...
}:
let
  #
  # ========== Arrange Tiles According to Preference ==========
  #
  arrangeTiles = pkgs.writeShellApplication {
    name = "arrangeTiles";
    text = ''
      #!/usr/bin/env bash

      function dispatch(){
          hyprctl dispatch -- "$1"
      }

      # Arrange ws 9 tiles
        # ideal signal location
        # mapped: 1
        # hidden: 1
        # at: 6,-1380
        # size: 1016,1374
        # workspace: 9 (9)
        # floating: 0
        # pseudo: 0
        # monitor: 3
        # class: signal
        # title: Signal
        # initialClass: signal
        # initialTitle: Signal
        # xwayland: 0
        # grouped: 5593f2f0fad0,5593f2f30980
      dispatch "focuswindow class:signal"
      dispatch "movewindoworgroup l"
      dispatch "movewindoworgroup l"#make sure signal starts in the left most position
      dispatch "movewindoworgroup l"
      dispatch "togglegroup"

        #TODO: detect if brave is a single window with "restore session" prompt or two windows
      dispatch "focuswindow class:brave-browser"
      dispatch "movewindoworgroup r"
      dispatch "movewindoworgroup r"
      dispatch "movewindoworgroup r"
      dispatch "togglesplit" # set up horizontal for brave windows on 'restore'

      dispatch "focuswindow class:discord"
      dispatch "movewindoworgroup l" #move discord into group

      # Arrange ws 10 tiles
      dispatch "focuswindow title:Virtual Machine Manager"
      dispatch "movewindoworgroup l"
      dispatch "resizeactive exact 500 900" #these values are fuzzy because hypr has some sort of multiple that reduces the values here
      dispatch "focuswindow title:amdgpu_top"
      dispatch "movewindoworgroup r"
      dispatch "resizeactive exact 500, 900"
      dispatch "focuswindow title:btop"
      #dispatch "resizeactive exact 1350 900"
      dispatch "focuswindow class:spotify"
      dispatch "movewindoworgroup d"
      dispatch "movewindoworgroup d" #move down twice to handle scenarios where spotify launches early than usual

      # Arrange ws special tiles
      dispatch "focuswindow title:keymapp"
      dispatch "movewindoworgroup d"
    '';
  };

  #
  # ========== Monitor Toggling ==========
  #
  primaryMonitor = lib.head (lib.filter (m: m.primary) config.monitors);

  # Toggle all monitors
  toggleMonitors = pkgs.writeShellApplication {
    name = "toggleMonitors";
    text = ''
      #!/bin/bash

      # Function to get all monitor names
      get_all_monitors() {
          hyprctl monitors -j | jq -r '.[].name'
      }

      # Function to check if all monitors are on
      all_monitors_on() {
          for monitor in $(get_all_monitors); do
              state=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor\") | .dpmsStatus")
              if [ "$state" != "true" ]; then
                  return 1
              fi
          done
          return 0
      }

      # Main logic
      if all_monitors_on; then
          # If all monitors are on, put all except primary into standby
          for monitor in $(get_all_monitors); do
             hyprctl dispatch dpms standby "$monitor"
          done
          echo "All monitors are now in standby mode."
      else
          # If not all monitors are on, turn them all on
          for monitor in $(get_all_monitors); do
              hyprctl dispatch dpms on "$monitor"
          done
          echo "All monitors are now on."
      fi    '';
  };

  # Toggle all non-primary monitors
  #dpms standby seems to be working but if monitor wakeup is too sensitive for gaming, can try suspend or off instead
  toggleMonitorsNonPrimary = pkgs.writeShellApplication {
    name = "toggleMonitorsNonPrimary";
    text = ''
      #!/bin/bash

      # Define your primary monitor (the one you want to keep on)
      PRIMARY_MONITOR="${primaryMonitor.name}"  # Replace with your primary monitor name

      # Function to get all monitor names
      get_all_monitors() {
          hyprctl monitors -j | jq -r '.[].name'
      }

      # Function to check if all monitors are on
      all_monitors_on() {
          for monitor in $(get_all_monitors); do
              state=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor\") | .dpmsStatus")
              if [ "$state" != "true" ]; then
                  return 1
              fi
          done
          return 0
      }

      # Main logic
      if all_monitors_on; then
          # If all monitors are on, put all except primary into standby
          for monitor in $(get_all_monitors); do
              if [ "$monitor" != "$PRIMARY_MONITOR" ]; then
                  hyprctl dispatch dpms standby "$monitor"
              fi
          done
          echo "All monitors except $PRIMARY_MONITOR are now in standby mode."
      else
          # If not all monitors are on, turn them all on
          for monitor in $(get_all_monitors); do
              hyprctl dispatch dpms on "$monitor"
          done
          echo "All monitors are now on."
      fi    '';
  };
in
{
  home.packages = [
    arrangeTiles
    toggleMonitors
    toggleMonitorsNonPrimary
  ];
}
