{ config, pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

  home.file.".emacs.d/init.el".source = ./init.el;
  home.file.".emacs.d/early-init.el".source = ./early-init.el;

  home.file.".emacs.d/config.org" = {
    onChange = "rm ~/.emacs.d/config.el || true";

    # Please email me if there's a shortcut function for this.
    # Patch the `config.org` file to substitute the "@FIXED-PITCH-FONT@" and
    #   "@VARIABLE-PITCH-FONT@" strings by their right value.
    source = pkgs.stdenvNoCC.mkDerivation {
      name = "config.org";
      src = ./config.org;
      phases = [ "installPhase" ];
      outputs = [ "out" ];
      installPhase = ''
        cp $src $out
        substituteInPlace $out \
          --subst-var-by FIXED-PITCH-FONT "${config.fontProfiles.monospace.family}" \
          --subst-var-by VARIABLE-PITCH-FONT "${config.fontProfiles.regular.family}"
      '';
    };
  };
}
