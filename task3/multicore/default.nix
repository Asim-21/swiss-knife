{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/c1981eb51ecb109ddf23e1ff38e740626f62ec3e.tar.gz") {} }:

pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.python3.pkgs.seaborn
    pkgs.python3.pkgs.pytimeparse
  ];
}
