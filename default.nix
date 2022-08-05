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
  hist = fzfScript {
    scriptName = "hist";
    scriptSource = ./hist;
  };
  jump = fzfScript {
    scriptName = "jump";
    scriptSource = ./jump;
  };
in
  {
    inherit hist jump;
  }
