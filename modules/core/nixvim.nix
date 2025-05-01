{ inputs, ... }:
{
  imports = [ inputs.neve.nixvimModule ];
  programs.nixvim = {
    enable = true;
    colorscehemes.nord.enable = true;
  };
}
