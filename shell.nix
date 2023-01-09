{pkgs ? import <nixpkgs> {} }:

# Download Mach-Nix.
let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix";
    ref = "refs/tags/3.5.0";
  }) {};
in
let
  # Instantiate mach-nix python environment with required packages. (need to look into trying to do this recursively).
  my-python = mach-nix.mkPython {
    python = "python3";
    # requirements = builtins.readFile ./requirements.txt; ## (Alternative conofig for cross platform compatibility)
    requirements = ''
                 requests
                 scrapy
                 scrapy-playwright
                 pytest-playwright
                 numpy
                 pandas
                 python-lsp-server[all]
                 '';
  };
  # FUTURE: Add a 'shellHook' section to start the IB/TWS gateway and create a connection. (start the python trading bot).
in
pkgs.mkShell {
  buildInputs = [
    my-python # Load the my-python environment into the shell.
  ];
  shellHook = ''
            playwright install chromium
            '';
}
