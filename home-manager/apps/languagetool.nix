{ pkgs, config, ... }:

let
  fasttextLidModel = pkgs.fetchurl {
    url = "https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin";
    sha256 = "0kkncb1swi2azh0ci7kq0sfg1mw559wy8jafhk3iq9mwa5afqsby";
  };
in {
  home.packages = with pkgs; [
    languagetool
    fasttext
  ];

  # Set fasttext model in ~/.local/share/fasttext/lid.176.bin
  xdg.dataFile."fasttext/lid.176.bin".source = fasttextLidModel;

  # Create the server.properties file in ~/.config/languagetool
  xdg.configFile."languagetool/server.properties".text = ''
    fasttextModel=${config.xdg.dataHome}/fasttext/lid.176.bin
    fasttextBinary=${pkgs.fasttext}/bin/fasttext
  '';

  systemd.user.services.languagetool = {
    Unit = {
      Description = "LanguageTool HTTP server";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.languagetool}/bin/languagetool-http-server --port 8081 --config ${config.xdg.configHome}/languagetool/server.properties";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
