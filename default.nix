{
  pkgs ? import (builtins.fetchTarball {
    name = "nixpkgs-e43cf1748462c81202a32b26294e9f8eefcc3462";
    url = "https://github.com/nixos/nixpkgs/archive/e43cf1748462c81202a32b26294e9f8eefcc3462.tar.gz";
    sha256 = "13xvjdbgjgwd5j7ylyy2f590v0s9ha3zj94kl5x1fwasi0dz3ybq";
  }) {}
}:

let
  histScript = pkgs.writeScriptBin "hist" (pkgs.lib.pipe ./hist [
    builtins.readFile
    (builtins.replaceStrings ["fzf"] ["${pkgs.fzf}/bin/fzf"]) 
  ]);
in
  pkgs.stdenv.mkDerivation {
    pname = "fuzzy-scripts";
    version = "0.1.0";

    dontUnpack = true;

    buildInputs = [
      histScript
    ];

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${histScript}/bin/hist $out/bin/hist
    '';
  }
