{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ pfetch ];
    sessionVariables.PF_INFO =
      "ascii title os host kernel uptime pkgs memory palette";
  };
}
