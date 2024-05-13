{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.fira-code-nerdfont;
      name = "Fira Code";
      size = 12;
    };
    shellIntegration = {
      enableBashIntegration = true;
    };
  };
}
