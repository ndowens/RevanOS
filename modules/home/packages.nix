{pkgs, ...}:
{
  home.packages = pkgs; {
    inputs.zen-browser.packages."${system}".default;
};
}
