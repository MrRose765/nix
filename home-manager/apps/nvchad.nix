{ inputs, config, pkgs, ... }: {

    imports = [
        inputs.nix4nvchad.homeManagerModules.default
    ];

    programs.nvchad = {
        enable = true;

        extraPlugins = ''return {
            { "nvzone/menu" },
            { "NvChad/nvterm" },
        }'';

        extraPackages = with pkgs; [
            bash-language-server
            nixd
            (python3.withPackages(ps: with ps; [
                python-lsp-server
            ]))
        ];

        chadrcConfig = ''
            local M = {}
            M.base16 = {
            theme = "gruvbox-light-medium"
            }
            return M
        '';

        hm-activation = true;

    };
}
