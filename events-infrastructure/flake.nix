# events-infrastructure/flake.nix
#
# This file packages pythoneda-shared-code-requests/events-infrastructure as a Nix flake.
#
# Copyright (C) 2023-today rydnr's pythoneda-shared-code-requests/events-infrastructure-artifact
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
{
  description = "Infrastructure layer of pythoneda-shared-code-requests/events";
  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    pythoneda-shared-artifact-changes-shared = {
      url =
        "github:pythoneda-shared-artifact-changes/shared-artifact/0.0.1a12?dir=shared";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
    pythoneda-shared-code-requests-events = {
      url =
        "github:pythoneda-shared-code-requests/events-artifact/0.0.1a8?dir=events";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-artifact-changes-shared.follows =
        "pythoneda-shared-artifact-changes-shared";
      inputs.pythoneda-shared-code-requests-shared.follows =
        "pythoneda-shared-code-requests-shared";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
    pythoneda-shared-code-requests-shared = {
      url =
        "github:pythoneda-shared-code-requests/shared-artifact/0.0.1a8?dir=shared";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
    pythoneda-shared-pythoneda-banner = {
      url = "github:pythoneda-shared-pythoneda/banner/0.0.1a16";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    pythoneda-shared-pythoneda-domain = {
      url =
        "github:pythoneda-shared-pythoneda/domain-artifact/0.0.1a40?dir=domain";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
    };
    pythoneda-shared-pythoneda-infrastructure = {
      url =
        "github:pythoneda-shared-pythoneda/infrastructure-artifact/0.0.1a26?dir=infrastructure";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "pythoneda-shared-code-requests";
        repo = "events-infrastructure";
        version = "0.0.1a1";
        sha256 = "sha256-YWlFKWbmzlJqafe1q5lBSBFvUuKIcT4GZhTOJ/c7Aec=";
        pname = "${org}-${repo}";
        pkgs = import nixos { inherit system; };
        description =
          "Infrastructure layer of pythoneda-shared-code-requests/events";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/${org}/${repo}";
        maintainers = with pkgs.lib.maintainers;
          [ "rydnr <github@acm-sl.org>" ];
        archRole = "E";
        space = "D";
        layer = "I";
        nixosVersion = builtins.readFile "${nixos}/.version";
        nixpkgsRelease = "nixos-${nixosVersion}";
        shared = import "${pythoneda-shared-pythoneda-banner}/nix/shared.nix";
        pythoneda-shared-code-requests-events-infrastructure-for = { python
          , pythoneda-shared-code-requests-events
          , pythoneda-shared-code-requests-shared
          , pythoneda-shared-pythoneda-domain
          , pythoneda-shared-pythoneda-infrastructure }:
          let
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            pythonpackage =
              "pythoneda.shared.code_requests.events.infrastructure";
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            pyprojectTemplateFile = ./pyprojecttoml.template;
            pyprojectTemplate = pkgs.substituteAll {
              authors = builtins.concatStringsSep ","
                (map (item: ''"${item}"'') maintainers);
              desc = description;
              dbusNext = python.pkgs.dbus-next.version;
              inherit homepage pname pythonpackage version;
              pythonMajorMinor = pythonMajorMinorVersion;
              package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
              pythonedaSharedArtifactChangesShared =
                pythoneda-shared-artifact-changes-shared.version;
              pythonedaSharedCodeRequestsEvents =
                pythoneda-shared-code-requests-events.version;
              pythonedaSharedCodeRequestsShared =
                pythoneda-shared-code-requests-shared.version;
              pythonedaSharedPythonedaDomain =
                pythoneda-shared-pythoneda-domain.version;
              pythonedaSharedPythonedaInfrastructure =
                pythoneda-shared-pythoneda-infrastructure.version;
              src = pyprojectTemplateFile;
            };
            src = pkgs.fetchFromGitHub {
              owner = org;
              rev = version;
              inherit repo sha256;
            };

            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip pkgs.jq poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              dbus-next
              pythoneda-shared-artifact-changes-shared
              pythoneda-shared-code-requests-events
              pythoneda-shared-code-requests-shared
              pythoneda-shared-pythoneda-domain
              pythoneda-shared-pythoneda-infrastructure
            ];

            pythonImportsCheck = [ pythonpackage ];

            unpackPhase = ''
              cp -r ${src} .
              sourceRoot=$(ls | grep -v env-vars)
              chmod +w $sourceRoot
              cp ${pyprojectTemplate} $sourceRoot/pyproject.toml
            '';

            postInstall = ''
              pushd /build/$sourceRoot
              for f in $(find . -name '__init__.py'); do
                if [[ ! -e $out/lib/python${pythonMajorMinorVersion}/site-packages/$f ]]; then
                  cp $f $out/lib/python${pythonMajorMinorVersion}/site-packages/$f;
                fi
              done
              popd
              mkdir $out/dist
              cp dist/${wheelName} $out/dist
              jq ".url = \"$out/dist/${wheelName}\"" $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json > temp.json && mv temp.json $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default =
            pythoneda-shared-code-requests-events-infrastructure-default;
          pythoneda-shared-code-requests-events-infrastructure-default =
            pythoneda-shared-code-requests-events-infrastructure-python310;
          pythoneda-shared-code-requests-events-infrastructure-python38 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-code-requests-events-infrastructure-python38;
              python = pkgs.python38;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python38;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python38;
              inherit archRole layer nixpkgsRelease org pkgs repo space;
            };
          pythoneda-shared-code-requests-events-infrastructure-python39 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-code-requests-events-infrastructure-python39;
              python = pkgs.python39;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python39;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python39;
              inherit archRole layer nixpkgsRelease org pkgs repo space;
            };
          pythoneda-shared-code-requests-events-infrastructure-python310 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-code-requests-events-infrastructure-python310;
              python = pkgs.python310;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python310;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python310;
              inherit archRole layer nixpkgsRelease org pkgs repo space;
            };
        };
        packages = rec {
          default =
            pythoneda-shared-code-requests-events-infrastructure-default;
          pythoneda-shared-code-requests-events-infrastructure-default =
            pythoneda-shared-code-requests-events-infrastructure-python310;
          pythoneda-shared-code-requests-events-infrastructure-python38 =
            pythoneda-shared-code-requests-events-infrastructure-for {
              python = pkgs.python38;
              pythoneda-shared-artifact-changes-shared =
                pythoneda-shared-artifact-changes-shared.packages.${system}.pythoneda-shared-artifact-changes-shared-python38;
              pythoneda-shared-code-requests-events =
                pythoneda-shared-code-requests-events.packages.${system}.pythoneda-shared-code-requests-events-python38;
              pythoneda-shared-code-requests-shared =
                pythoneda-shared-code-requests-shared.packages.${system}.pythoneda-shared-code-requests-shared-python38;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python38;
              pythoneda-shared-pythoneda-infrastructure =
                pythoneda-shared-pythoneda-infrastructure.packages.${system}.pythoneda-shared-pythoneda-infrastructure-python38;
            };
          pythoneda-shared-code-requests-events-infrastructure-python39 =
            pythoneda-shared-code-requests-events-infrastructure-for {
              python = pkgs.python39;
              pythoneda-shared-artifact-changes-shared =
                pythoneda-shared-artifact-changes-shared.packages.${system}.pythoneda-shared-artifact-changes-shared-python39;
              pythoneda-shared-code-requests-events =
                pythoneda-shared-code-requests-events.packages.${system}.pythoneda-shared-code-requests-events-python39;
              pythoneda-shared-code-requests-shared =
                pythoneda-shared-code-requests-shared.packages.${system}.pythoneda-shared-code-requests-shared-python39;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python39;
              pythoneda-shared-pythoneda-infrastructure =
                pythoneda-shared-pythoneda-infrastructure.packages.${system}.pythoneda-shared-pythoneda-infrastructure-python39;
            };
          pythoneda-shared-code-requests-events-infrastructure-python310 =
            pythoneda-shared-code-requests-events-infrastructure-for {
              python = pkgs.python310;
              pythoneda-shared-artifact-changes-shared =
                pythoneda-shared-artifact-changes-shared.packages.${system}.pythoneda-shared-artifact-changes-shared-python310;
              pythoneda-shared-code-requests-events =
                pythoneda-shared-code-requests-events.packages.${system}.pythoneda-shared-code-requests-events-python310;
              pythoneda-shared-code-requests-shared =
                pythoneda-shared-code-requests-shared.packages.${system}.pythoneda-shared-code-requests-shared-python310;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python310;
              pythoneda-shared-pythoneda-infrastructure =
                pythoneda-shared-pythoneda-infrastructure.packages.${system}.pythoneda-shared-pythoneda-infrastructure-python310;
            };
        };
      });
}
