{ lib, pkgs, ... }:
{
  home.packages = [
    pkgs.networkmanagerapplet
  ];

  # xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      colors.background = "#2f343f";
      focus.mouseWarping = false;
      fonts = {
        names = [ "pango" "monspace" ];
        size = 8.0;
      };
      modifier = "Mod4";
      terminal = "kitty";
    };
  };

  programs.i3status = {
    enable = true;
    general = {
      colors = true;
      interval = 5;
    };
    modules = {
      "wireless _first_" = {
        position = 1;
        settings = {
          format_up = "W: (%quality at %essid) %ip";
          format_down = "W: down";
        };
      };

      "ethernet _first_" = {
        position = 2;
        settings = {
          format_up = "E: %ip (%speed)";
          format_down = "E: down";
        };
      };

      "battery all" = {
        position = 3;
        settings.format = "%status %percentage %remaining";
      };

      "disk /" = {
        position = 4;
        settings.format = "%avail";
      };

      "load" = {
        position = 5;
        settings.format = "%1min";
      };

      "memory" = {
        position = 6;
        settings = {
          format = "%used | %available";
          threshold_degraded = "1G";
          format_degraded = "MEMORY < %available";
        };
      };

      "tztime local" = {
        position = 7;
        settings.format = "%a %b %d %l:%M %p %Z  ";
      };
    };
  };

  services.picom.enable = true;
}
