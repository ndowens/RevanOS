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
    extraPlugins = [ pkgs.vimPlugins.catppuccin-nvim ];
    colorscheme = "catppuccin";
    plugins.nix.enable = true;
    plugins.treesitter = {
    	enable = true;
	grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
		nix
		vim ];
	};
     };
}
