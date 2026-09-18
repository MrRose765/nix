{ inputs, config, pkgs, ... }:

{
    imports = [
        ./apps/nvchad.nix
        ./apps/kitty.nix
        ./apps/zsh.nix
        ./apps/newsboat.nix
        ./apps/languagetool.nix
        ./apps/zathura.nix
        ./packages.nix
    ];

    home.username = "odoo";
    home.homeDirectory = "/home/odoo";
    home.stateVersion = "23.11";

    # session variables
    home.sessionVariables = {
        EDITOR="nvim";
        XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
        BROWSER = "zen";
        UV_PYTHON_PREFERENCE = "only-managed";
    };

    programs.git = {
        enable = true;
        settings = {
            user.name = "Cyril Moreau";
            user.email = "cymo@odoo.com";
            core.editor = "nvim";
            fetch.prune = true; # remove remote-tracking branches that no longer exist on the remote
            maintenance.auto = false; # Avoid running git maintenance on each pull
        };
    };

    systemd.user.services.autossh-tunnel-upgrade-test = {
        Unit = {
            Description = "AutoSSH tunnel to upgrade test server";
            After = [ "network.target" ];
        };
        Service = {
            ExecStart = "${pkgs.autossh}/bin/autossh -M 0 -N -F /home/odoo/.ssh/config tunnel-upgrade-test";
            Restart = "always";
            RestartSec = 10;
            Environment = "AUTOSSH_GATETIME=0";
        };
        Install.WantedBy = [ "default.target" ];
    };

    programs.home-manager.enable = true; # let HM manage itself
}
