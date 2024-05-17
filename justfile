host_nix := `echo legacy/nixos/$(hostname).nix`

switch:
    sudo cp -f legacy/nixos/configuration.nix /etc/nixos/configuration.nix 
    [ -f {{host_nix}} ] && sudo cp -f {{host_nix}} /etc/nixos/local.nix
    sudo nixos-rebuild switch
