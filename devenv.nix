{
  pkgs,
  lib,
  config,
  ...
}:
{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    tuxedo
  ];

  # https://devenv.sh/languages/
  languages = {
    nix.enable = true;
    lua.enable = true;
  };

  ## $ devenv up
  ## integrate with `nix flake check` ?
  processes = {
    list_changes.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";
    git_add = {
      exec = "git add .";
      cwd = "${config.git.root}";
      watch = {
        paths = [ ./modules ];
        extensions = [ "nix" ];
      };
    };
  };

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  files = {
    ".editorconfig" = {
      copyMode = "copy";
      ini = {
        "*" = {
          indent_size = 2;
          indent_type = "space";
        };
        "*.py" = {
          indent_size = 4;
        };
        "*.{json{,c},toml,y{,a}ml}" = {
          charset = "utf-8";
        };
      };
    };
  };

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    hello         # Run scripts directly
    git --version # Use packages
  '';

  # https://devenv.sh/tasks/
  ## NOTE Interesting parts:
  ## git_integration ; processes-integration ; execIf ; namespace ; fav-language
  # "myproj:setup".exec = "mytool build";
  # "devenv:enterShell".after = [ "myproj:setup" ]; # INFO <- `$ devenv shell` hook

  ## INFO Lua experiment

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  #NOTE: First, add these to (devenv)inputs:
  # ```sh
  # devenv inputs add treefmt-nix github:numtide/treefmt-nix
  # devenv inputs add git-hooks github:cachix/git-hooks.nix
  # ```
  treefmt = {
    enable = true;
    config.programs = {
      nixfmt = {
        enable = true;
        package = pkgs.nixfmt-rs;
        indent = 2;
      };
      stylua = {
        enable = true;
        settings = {
          indent_width = 2;
          indent_type = "Spaces";
          collapse_simple_statement = "Always"; # TEST
          call_parentheses = "Always";
        };
      };
    }; # <- NOTE This is cleaner (See also ./modules/format.nix)
  };
  git-hooks.hooks = {
    treefmt.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
