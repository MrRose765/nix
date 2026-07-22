{ inputs, pkgs, ... }:
{
  programs.newsboat = {
    enable = true;
    urls = [
      {
        url = "https://mullvad.net/en/blog/feed/atom";
        tags = ["Privacy"];
        title = "The Mullvad Blog";
      }
      {
        url = "https://www.patrick-breyer.de/en/feed/";
        tags = ["Privacy"];
        title = "Patrick Breyer";
      }
      {
        url = "https://podcast.darknetdiaries.com/";
        tags = ["Podcast"];
        title = "Darknet Diaries";
      }
      {
        url = "https://www.postgresql.org/news.rss";
        tags = ["PostgreSQL"];
        title = "PostgreSQL News";
      }
      {
        url = "https://www.cybertec-postgresql.com/feed/";
        tags = ["PostgreSQL"];
        title = "Cybertec PostgreSQL Blog";
      }

      # Data engineering
      # See https://github.com/random-droid/awesome-data-engineering-feeds#quick-start
      {
        url = "https://www.dataengineeringpodcast.com/feed/";
        tags = ["Data Engineering"];
        title = "Data Engineering Podcast";
      }
      {
        url = "https://seattledataguy.substack.com/feed";
        tags = ["Data Engineering"];
        title = "Seattle Data Guy";
      }

    ];

    extraConfig = ''
      bind-key UP up
      bind-key DOWN down
      bind-key RIGHT open
      bind-key LEFT quit
      bind-key ENTER open
      bind-key BACKSPACE quit


      color background          color189 color235
      color listnormal          color189 color235
      color listnormal_unread   color111 color235
      color listfocus           color235 color111
      color listfocus_unread    color235 color147
      color info                color189 color237
      color title                color141 color235
    '';

  };
}
