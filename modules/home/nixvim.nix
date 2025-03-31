{inputs, pkgs, nixpkgs, khanelivim, ...}:
{
	imports = [
		inputs.nixvim.homeManagerModules.nixvim
		];
	home.packages = with pkgs; [
		inputs.khanelivim.packages.${system}.default ];
	programs.nixvim = {
		enable = false;
		#extraPlugins = [ pkgs.vimPlugins.catppuccin ];
		#colorscheme = "catppuccin";
	};
	
}
