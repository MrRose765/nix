{ inputs, config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 11.5;
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    settings = {
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_bar_edge = "top";
      hide_window_decorations = "yes";

      enable_audio_bell = "no";
      copy_on_select = "yes";
      confirm_os_window_close = 1;
      enabled_layouts = "grid,fat,tall";

      # Tokyo Night Moon
      # https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/kitty/tokyonight_moon.conf
      background = "#222436";
      foreground = "#c8d3f5";
      selection_background = "#2d3f76";
      selection_foreground = "#c8d3f5";
      url_color = "#4fd6be";
      cursor = "#c8d3f5";
      cursor_text_color = "#222436";

      active_tab_background = "#82aaff";
      active_tab_foreground = "#1e2030";
      inactive_tab_background = "#2f334d";
      inactive_tab_foreground = "#545c7e";

      active_border_color = "#82aaff";
      inactive_border_color = "#2f334d";

      color0 = "#1b1d2b";
      color1 = "#ff757f";
      color2 = "#c3e88d";
      color3 = "#ffc777";
      color4 = "#82aaff";
      color5 = "#c099ff";
      color6 = "#86e1fc";
      color7 = "#828bb8";
      color8 = "#444a73";
      color9 = "#ff8d94";
      color10 = "#c7fb6d";
      color11 = "#ffd8ab";
      color12 = "#9ab8ff";
      color13 = "#caabff";
      color14 = "#b2ebff";
      color15 = "#c8d3f5";
      color16 = "#ff966c";
      color17 = "#c53b53";
    };

    extraConfig = ''
      tab_title_template "{index}: {title} {f'({num_windows}) [{layout_name}]' if num_windows > 1 else '''}"
      map ctrl+shift+r set_tab_title
      map ctrl+shift+space focus_visible_window
    '';
  };
}
