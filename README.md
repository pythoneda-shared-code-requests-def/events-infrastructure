# events-infrastructure-artifact

Artifact space of <https://github.com/pythoneda-shared-code-requests/events-infrastructure>

## How to declare it in your flake

Check the latest tag of the artifact repository: [https://github.com/pythoneda-shared-code-requests/events-infrastructure-artifact-artifact/tags](https://github.com/pythoneda-shared-code-requests/events-infrastructure-artifact-artifact/tags) and use it instead of the `[version]` placeholder below.

```nix
{
  description = "[..]";
  inputs = rec {
    [..]
    pythoneda-shared-code-requests-events-infrastructure-artifact = {
      [optional follows]
      url =
        "github:pythoneda-shared-code-requests/events-infrastructure-artifact-artifact/[version]?dir=events-infrastructure-artifact";
    };
  };
  outputs = [..]
};
```

Should you use another PythonEDA modules, you might want to pin those also used by this project. The same applies to [nixpkgs](https://github.com/nixos/nixpkgs "nixpkgs") and [flake-utils](https://github.com/numtide/flake-utils "flake-utils").

Use the specific package depending on your system (one of `flake-utils.lib.defaultSystems`) and Python version:

- `#packages.[system].pythoneda-shared-code-requests-events-infrastructure-artifact-python38` 
- `#packages.[system].pythoneda-shared-code-requests-events-infrastructure-artifact-python39` 
- `#packages.[system].pythoneda-shared-code-requests-events-infrastructure-artifact-python310` 
- `#packages.[system].pythoneda-shared-code-requests-events-infrastructure-artifact-python311` 

The Nix flake is under the 
[infrastructure](https://github.com/pythoneda-shared-code-requests/events-infrastructure-artifact-artifact/tree/main/events-infrastructure-artifact "events-infrastructure-artifact") folder in <https://github.com/pythoneda-shared-code-requests/events-infrastructure-artifact-artifact>.

