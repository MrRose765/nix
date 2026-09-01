{ pkgs, inputs, ... }:

let
  zen-browser = inputs.zen-browser.packages.${pkgs.system}.default;
in {
  home.packages = with pkgs; [
    ### General
    #flameshot
    xdg-utils
    #firejail # setuid issue :(

    ### Fonts
    jetbrains-mono

    ### Terminal-based
    fastfetch
    btop
    ncspot
    eza

    ### Development
    uv
    ripgrep
    pgcli
    harlequin
    gh
    jq

    ### Apps
    protonmail-desktop
    calibre
    signal-desktop
    obsidian
    # zen-browser
    # discord
    # ferdium
    # super-productivity

    ### Personal
    # steam
  ];

  xdg.configFile."ncspot/config.toml".text = ''
    backend = "pulseaudio"
  '';

  xdg.configFile."harlequin/config.toml".text = ''
    default_profile = "psql"

    [profiles.psql]
    theme = "tokyo-night"
    limit = 10000
    adapter = "postgres"
    keymap = ["vscode"]
  '';

  xdg.configFile."firejail/claude.profile".source = resources/claude.profile;
  xdg.configFile."firejail/code.profile".source = resources/code.profile;

  home.file.".local/bin/odoo-pr-sync" = {
    source = ./scripts/odoo-pr-sync.sh;
    executable = true;
  };
}
