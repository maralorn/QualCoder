{ pkgs ? import <nixpkgs> {} }:
let
  list = builtins.attrValues;
  qualcoder = { python3Packages, fetchFromGitHub, lib, libsForQt5 }:
    let
      pname = "qualcoder";
      version = "2.5";
    in
      python3Packages.buildPythonApplication {
        inherit pname version;
        src = lib.cleanSource ./.;
        # missing:
        # - ebooklib
        # - pdfminer.six
        doCheck = false;
        dontWrapQtApps = true;

        preFixup = ''
          makeWrapperArgs+=("''${qtWrapperArgs[@]}")
        '';
        nativeBuildInputs = [ libsForQt5.qt5.wrapQtAppsHook ];
        propagatedBuildInputs = list { inherit (python3Packages) lxml ply six pdfminer chardet pyqt5 pillow openpyxl; };
      };
in
pkgs.callPackage qualcoder {}
