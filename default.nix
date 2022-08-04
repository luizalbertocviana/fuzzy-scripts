{
  pkgs ? import (builtins.fetchTarball {
    name = "nixpkgs-e43cf1748462c81202a32b26294e9f8eefcc3462";
    url = "https://github.com/nixos/nixpkgs/archive/e43cf1748462c81202a32b26294e9f8eefcc3462.tar.gz";
    sha256 = "13xvjdbgjgwd5j7ylyy2f590v0s9ha3zj94kl5x1fwasi0dz3ybq";
  }) {}
}:

let
  fzfScript = {scriptName, scriptSource}: pkgs.writeScriptBin scriptName (pkgs.lib.pipe scriptSource [
    builtins.readFile
    (builtins.replaceStrings ["fzf"] ["${pkgs.fzf}/bin/fzf"])
  ]);
  histScript = fzfScript {
    scriptName = "hist";
    scriptSource = ./hist;
  };
  jumpScript = fzfScript {
    scriptName = "jump";
    scriptSource = ./jump;
  };
in
  pkgs.stdenv.mkDerivation {
    pname = "fuzzy-scripts";
    version = "0.1.0";

    dontUnpack = true;

    buildInputs = [
      histScript
      jumpScript
    ];

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${histScript}/bin/hist $out/bin/hist
      ln -s ${histScript}/bin/jump $out/bin/jump
    '';
  }
