{ pkgs, ... }:
let
  fzf-tab-no-module = pkgs.runCommand "fzf-tab-no-module" {} ''
    cp -r --no-preserve=mode ${pkgs.zsh-fzf-tab}/share/fzf-tab $out
    rm -rf $out/modules
  '';
in
{
    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
            clears = "clear && source ~/.zshrc";

            # terminal utils
            cat = "bat";
            ls = "eza --icons --git";
            ll = "eza -l --icons --git --group-directories-first";
            la = "eza -la --icons --git --group-directories-first";

            # docker
            dc = "docker compose";
            dps = "docker ps";

            # nix utils
            nix-switch = "nix run nixpkgs#home-manager -- switch --flake ~/nix#server";
            nix-gc = "home-manager expire-generations '-30 days' && nix store gc";
        };

        initContent = ''
            # p10k theme
            [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        '';

        oh-my-zsh = {
            enable = true;
            plugins = [ "git" "sudo" "zsh-interactive-cd" "docker" "docker-compose" ];
        };

        plugins = with pkgs; [
            {
                name = "powerlevel10k";
                src = zsh-powerlevel10k;
                file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
            {
                name = "fzf-tab";
                src = fzf-tab-no-module;
                file = "fzf-tab.plugin.zsh";
            }
            {
                name = "syntax-highlighting";
                src = zsh-syntax-highlighting;
                file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
            }
            {
                name = "autosuggestions";
                src = zsh-autosuggestions;
                file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
            }
        ];
    };

    home.file.".p10k.zsh".source = ../home-manager/resources/p10k.zsh;
}
