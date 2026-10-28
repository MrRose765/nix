{ pkgs, ... }:

{
    imports = [ ./zsh-server.nix ];

    home.username = "mrrose765";
    home.homeDirectory = "/home/mrrose765";
    home.stateVersion = "23.11";

    home.sessionVariables.EDITOR = "vim";

    home.packages = with pkgs; [ eza bat btop ripgrep jq fastfetch ];

    programs.git = {
        enable = true;
        settings = {
            user.name = "Cyril Moreau";
            user.email = "cyril.moreau07@proton.me";
            core.editor = "vim";
            fetch.prune = true;
        };
    };

    programs.home-manager.enable = true;
}
