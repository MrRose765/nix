{ pkgs, inputs, ... }:

let
  zen-browser = inputs.zen-browser.packages.${pkgs.system}.default;
in {
  home.packages = with pkgs; [
    ### Config
    pipewire 

    ### Fonts
    jetbrains-mono
    
    ### Terminal-based
    fastfetch
    btop
    (writeShellScriptBin "ncspot" ''                                                                                                                                                           
      export ALSA_PLUGIN_DIR=${pipewire}/lib/alsa-lib                                                                                                                                          
      export LD_LIBRARY_PATH=${pipewire}/lib                                                                                                                                                   
      exec ${ncspot}/bin/ncspot "$@"                                                                                                                                                           
    '')
    eza                                                                                                                                                                                  

    ### Development
    uv


    ### Apps
    signal-desktop
    calibre
    obsidian
    # zen-browser
    # discord
    
  ];
}
