{ pkgs, ... }:

let
  gui = pkgs.writeShellScriptBin "gui" ''
    #!/bin/bash

    if [ $# -gt 0 ] ; then
      ($@ &) &>/dev/null
    else
      echo "missing argument"
    fi
  '';
in { home.packages = [ gui ]; }
