{ pkgs, inputs, ... }:

let
  zen-browser = inputs.zen-browser.packages.${pkgs.system}.default;
in {
  home.packages = with pkgs; [
    ### General
    #flameshot
    xdg-utils
    languagetool
    fasttext

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
}
