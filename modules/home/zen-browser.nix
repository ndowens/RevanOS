{
  inputs = {
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };
  outputs = {pkgs, home-manager, zen-browser,...} @ inputs:
  {
    home.packages = with pkgs; [
    inputs.zen-browser.packages."${system}".default;
    ];
  };
}
