let binstall = ''
    xinstall "$@"
  ''; in {
    installPhase = ''
      install -D -m 0550 ${binstall} $out/bin/binstall
    '';
    setupHook = ./install-setup-hook.sh;
  }
