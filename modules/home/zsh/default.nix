{
  profile,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./zshrc-personal.nix
  ];
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "ssh-agent"];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];

    initExtra = ''
      bindkey "\eh" backward-word
      bindkey "\ej" down-line-or-history
      bindkey "\ek" up-line-or-history
      bindkey "\el" forward-word
      if [ -f $HOME/.zshrc-personal ]; then
        source $HOME/.zshrc-personal
      fi
      export PATH="$HOME/.local/bin:$PATH"
      export SKIPGPGPASSPROMPT=true
      export SSHKEYSIGN="$HOME/.ssh/id_rsa"
      export EDITOR="nvim"
    '';
    shellAliases = {
      sv = "sudo nvim";
      vim = "nvim";
      am = "artix-metro";
      c = "clear";
      fc = "cd ~/.config/nixos && flake update && sudo nixos-rebuild dry-build --flake ~/.config/nixos#${profile} --upgrade-all -L";
      fr = "sudo nixos-rebuild switch --flake ~/.config/nixos#${profile} -L";
      fu = "sudo nixos-rebuild switch --flake ~/.config/nixos#${profile} --upgrade-all -L";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      cat = "bat";
      man = "batman";
      ls = "eza --icons --group-directories-first -1";
      ll = "eza --icons -lh --group-directories-first -1 --no-user --long";
      la = "eza --icons -lah --group-directories-first -1";
      tree = "eza --icons --tree --group-directories-first";
    };
  };
  programs.neovim = {
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
  };
}
