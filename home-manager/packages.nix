{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch
    btop
    uv
    # Idea from claude
    jetbrains-mono
    (pkgs.writeShellScriptBin "ncspot" ''                                                                                                                                                           
      export ALSA_PLUGIN_DIR=${pkgs.pipewire}/lib/alsa-lib                                                                                                                                          
      export LD_LIBRARY_PATH=${pkgs.pipewire}/lib                                                                                                                                                   
      exec ${pkgs.ncspot}/bin/ncspot "$@"                                                                                                                                                           
    '')                                                                                                                                                                                             
    pkgs.pipewire 
  ];
}
