{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "shell";
  buildInputs = with pkgs; [
    ansible
  ];
}

