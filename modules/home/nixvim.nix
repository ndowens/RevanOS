{
  inputs,
  pkgs,
  nixpkgs,
  khanelivim,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  programs.nixvim = {
    enable = true;
    #extraPlugins = [ pkgs.vimPlugins.catppuccin ];
    #colorscheme = "catppuccin";
  };
}
