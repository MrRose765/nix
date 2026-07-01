{ pkgs, inputs, ... }:

let
  zen-browser = inputs.zen-browser.packages.${pkgs.system}.default;
in {
  home.packages = with pkgs; [
    ### Fonts
    jetbrains-mono
    
    ### Terminal-based
    fastfetch
    btop
    ncspot
    eza                                                                                                                                                                                  

    ### Development
    uv

    ### Apps
    signal-desktop
    calibre
    (obsidian.override { commandLineArgs = "--no-sandbox"; }) # Sandbox needs extra permissions, disable it for now
    # zen-browser
    # discord
    # super-productivity
    # ferdium
  ];

  xdg.configFile."ncspot/config.toml".text = ''
    backend = "pulseaudio"
  '';
}
