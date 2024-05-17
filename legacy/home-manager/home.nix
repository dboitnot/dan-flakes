{ config, pkgs, lib, ... }:

let
  fs = lib.fileset;
  confDPath = ~/.config/home-manager/conf.d;
  confDFiles = builtins.filter (f: builtins.match ".*\\.nix" f != null) (builtins.attrNames (builtins.readDir confDPath));
  importedConfs = map (f: import (confDPath + "/${f}")) confDFiles;
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

  ssmProxyScript = ./ssm-ssh-proxy.sh;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dboitnot";
  home.homeDirectory = "/home/dboitnot";

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # General

    pkgs.ripgrep pkgs.fd pkgs.fira-code pkgs.powerline-symbols
    pkgs.stow pkgs.dnsutils pkgs.jq pkgs.hunspellDicts.en_US-large
    pkgs.just pkgs.niv pkgs.bottom pkgs.tmux pkgs.delta

    # Development tools for emacs
    pkgs.cmake pkgs.clang pkgs.gnumake pkgs.terraform pkgs.irony-server
    pkgs.rustup pkgs.ansible pkgs.black pkgs.clojure-lsp pkgs.semgrep
    pkgs.hunspell 

    # Language Support
    pkgs.pipenv pkgs.nodejs_21

    # AWS
    pkgs.awscli2 pkgs.cw pkgs.ssm-session-manager-plugin

    # Probably better way to do these but I don't have time right now.
    pkgs.nushellFull
    pkgs.vagrant
    # pkgs.virtualboxWithExtpack

    unstable.logseq
    unstable.brave
    #unstable.zoom-us
    unstable.slack

    pkgs.zoom-us
    pkgs.teams-for-linux

    pkgs.pulseaudio
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dboitnot/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "vim";
    AWS_CLI_AUTO_PROMPT = "on-partial";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  # atuin provides a fuzzy finder for command line history.
  programs.atuin = {
    enable = true;
    settings = {
      search_mode = "skim";
      show_preview = true;
    };
    flags = ["--disable-up-arrow"];
    enableBashIntegration = true;
    # enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  programs.autorandr = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    historyControl = ["erasedups"];
    shellAliases = {
      ssh = "f(){ echo $TERM |grep -qi kitty && kitty +kitten ssh $* || ssh $*; unset -f f; }; f";
      top = "btm";
      emacs = "doom run";
      nix-search = "docker run --rm -it ghcr.io/peterldowns/nix-search-cli:latest";
      diff = "delta";
    };
    initExtra = "eval $(thefuck --alias drat)";
  };

  # bashmount is a tool to mount and unmount removable media from the CLI
  programs.bashmount.enable = true;

  # Carapace auto-completion
  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    # enableFishIntegration = true;
  };

  programs.chromium.enable = true;
  programs.command-not-found.enable = true;


  # "Better cat"
  programs.bat.enable = true;

  # direnv is a tool to load/unload environment variables based on the current
  # directory.
  programs.direnv = {
    enable = true; 
    enableBashIntegration = true;
    enableNushellIntegration = true;
    # enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  # eza is a modern replacement for ls.
  programs.eza = {
    enable = true;
    # enableBashIntegration = true;
    # enableFishIntegration = true;
    enableAliases = true;
    git = true;
    icons = true;
  };

  # programs.fish = {
  #   enabled = true;
  # };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    # enableFishIntegration = true;
  };

  # programs.firefox = {
  #  enable = true;
  # };

  programs.git = {
    enable = true;
    difftastic.enable = true;
    userEmail = "dboitnot@gmail.com";
    userName = "Dan Boitnott";
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
  };
  programs.gh-dash.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Fira Code Light";
      bold_font = "Fira Code Medium";
      font_size = "10";
      disable_ligatures = "always";
      cursor_shape = "underline";
      shell_integration = "no-cursor";
      cursor_underline_thickness = "1";
      enable_audio_bell = "no";

      # Dull red
      color2 = "#19cb00";
      # Bright red
      color10 = "#23fd00";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      plenary-nvim
      gruvbox-material
      mini-nvim
    ];
    coc.enable = true;
  };

  programs.pyenv = {
    enable = true;
    enableBashIntegration = true;
    # enableFishIntegration = true;
  };

  programs.ssh = {
    enable = true;
    # addKeysToAgent = true;
    forwardAgent = true;
    extraConfig = ''
      HostKeyAlgorithms +ssh-rsa
      PubkeyAcceptedKeyTypes +ssh-rsa'';
    matchBlocks = {
      "*.sig" = {
        proxyCommand = "~/.ssh/ssm-ssh-proxy.sh -r sig -f 1 -h %h -p %p -v -R us-east-1";
      };
    };
  };

  home.file.ssh-ssh-proxy = {
    executable = true;
    source = ./ssm-ssh-proxy.sh;
    target = ".ssh/ssm-ssh-proxy.sh.link";

    # SSH doesn't like this file to be a symlink so we'll "realize" it.
    onChange = "cp -f .ssh/ssm-ssh-proxy.sh.link .ssh/ssm-ssh-proxy.sh";
  };

  # tealdeer is a command line client for tldr-pages. To use it, run:
  #   $ tldr <command>
  programs.tealdeer = {
    enable = true;
    settings = {
      display.compact = false;
      updates.auto_update = true;
    };
  };

  programs.thefuck = {
    enable = true;
    enableBashIntegration = true;
    # enableFishIntegration = true;
    # enableNushellIntegration = true;
  };

  # programs.tmux = {
  #   enable = true;
  #   escapeTime = 0;
  #   sensibleOnTop = false;
  # };

  programs.watson = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.yt-dlp.enable = true;

  services.ssh-agent.enable = true;

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      focus.mouseWarping = false;
      
      keybindings = lib.mkOptionDefault {
        # Manually lock screen
        "Mod4+shift+x" = "exec i3lock --color '#000000'";

	      # change focus
        "Mod4+h" = "focus left";
        "Mod4+j" = "focus down";
        "Mod4+k" = "focus up";
        "Mod4+l" = "focus right";
	
	      # move focused window
        "Mod4+Shift+h" = "move left";
        "Mod4+Shift+j" = "move down";
        "Mod4+Shift+k" = "move up";
        "Mod4+Shift+l" = "move right";

        # split in horizontal orientation
        "Mod4+b" = "split h";

        # Use pactl to adjust volume in PulseAudio.
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status";
        "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status";
      };
    };
  };

  home.sessionVariablesExtra = lib.mkAfter ''
    export PATH="$PATH:$HOME/.emacs.d/bin";
  '';

  imports = importedConfs;
}
