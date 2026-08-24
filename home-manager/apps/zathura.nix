{ inputs, pkgs, config, ... }:
{
  programs.zathura = {
    enable = true;

    # Tokyo Night Moon 
    options = {
      # Fonts
      font = "JetBrains Mono Nerd Font 11";

      # Base UI
      default-bg = "#222436";
      default-fg = "#c8d3f5";

      statusbar-bg = "#1e2030";
      statusbar-fg = "#c8d3f5";
      statusbar-h-padding = 8;
      statusbar-v-padding = 4;

      inputbar-bg = "#1e2030";
      inputbar-fg = "#c8d3f5";

      notification-bg = "#1e2030";
      notification-fg = "#c8d3f5";
      notification-error-bg = "#ff757f";
      notification-error-fg = "#1e2030";
      notification-warning-bg = "#ffc777";
      notification-warning-fg = "#1e2030";

      # Highlighting
      highlight-color = "#ffc777";
      highlight-active-color = "#82aaff";

      # Completion
      completion-bg = "#1e2030";
      completion-fg = "#c8d3f5";
      completion-highlight-bg = "#82aaff";
      completion-highlight-fg = "#1e2030";
      completion-group-bg = "#1e2030";
      completion-group-fg = "#82aaff";

      # Index (table of contents)
      index-bg = "#222436";
      index-fg = "#c8d3f5";
      index-active-bg = "#82aaff";
      index-active-fg = "#1e2030";

      # Recolor mode (dark reading mode for light PDFs)
      recolor = true;
      recolor-keephue = true;
      recolor-darkcolor = "#c8d3f5";
      recolor-lightcolor = "#222436";

      # Rendering / behavior
      selection-clipboard = "clipboard";
      guioptions = "s";     
      window-title-basename = true;
      window-title-page = true;
      adjust-open = "best-fit";
      pages-per-row = 1;
      page-padding = 8;
      scroll-page-aware = true;
      scroll-full-overlap = "0.01";
      scroll-step = 60;
      zoom-step = 10;
      render-loading = false;
      show-hidden = false;
      database = "sqlite";
    };

    mappings = {
      # Scrolling
      "<Up>"    = "scroll up";
      "<Down>"  = "scroll down";
      "<Left>"  = "scroll left";
      "<Right>" = "scroll right";

      # Page navigation
      "<PageUp>"   = "navigate previous";
      "<PageDown>" = "navigate next";
      "<Space>"    = "navigate next";
      "<S-Space>"  = "navigate previous";
      "<Home>"     = "goto top";
      "<End>"      = "goto bottom";

      # Find / go-to-page
      "<C-f>"  = "focus_inputbar \"/\"";
      "<C-g>"  = "focus_inputbar \":goto \"";
      "<Esc>"  = "abort";

      # View
      "<F11>" = "toggle_fullscreen";
      "<C-l>" = "recolor";           # toggle dark reading mode

      # Quit
      "<C-q>" = "quit";
    };
  };
}
