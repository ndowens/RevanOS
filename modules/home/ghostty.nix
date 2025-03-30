{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
  };
  home.file."./.config/ghostty/config".text = ''

    #theme = Aura
    theme = Dracula
    #theme = Aardvark Blue
    #theme = GruvboxDarkHard
    adjust-cell-height = 10%
    window-theme = dark
    window-height = 32
    window-width = 110
    background-opacity = 0.95
    background-blur-radius = 60
    selection-background = #2d3f76
    selection-foreground = #c8d3f5
    cursor-style = bar
    mouse-hide-while-typing = true

    # keybindings
    keybind = alt+shift+r=reload_config
    keybind = alt+shift+c=close_surface

    keybind = alt+shift+n=new_window

    # tabs
    keybind = alt+shift+c=new_tab
    keybind = alt+shift+l=next_tab
    keybind = alt+shift+h=previous_tab
    keybind = alt+shift+comma=move_tab:-1
    keybind = alt+shift+period=move_tab:1

    # quick tab switch
    keybind = alt+shift+1=goto_tab:1
    keybind = alt+shift+2=goto_tab:2
    keybind = alt+shift+3=goto_tab:3
    keybind = alt+shift+4=goto_tab:4
    keybind = alt+shift+5=goto_tab:5
    keybind = alt+shift+6=goto_tab:6
    keybind = alt+shift+7=goto_tab:7
    keybind = alt+shift+8=goto_tab:8
    keybind = alt+shift+9=goto_tab:9

    # split
    keybind = alt+shift+\=new_split:right
    keybind = alt+shift+-=new_split:down

    keybind = alt+shift+j=goto_split:bottom
    keybind = alt+shift+k=goto_split:top
    keybind = alt+shift+h=goto_split:left
    keybind = alt+shift+l=goto_split:right

    keybind = alt+shift+z=toggle_split_zoom

    keybind = alt+shift+e=equalize_splits

    # other
    #copy-on-select = clipboard

    font-size = 12
    #font-family = JetBrainsMono Nerd Font Mono
    #font-family-bold = JetBrainsMono NFM Bold
    #font-family-bold-italic = JetBrainsMono NFM Bold Italic
    #font-family-italic = JetBrainsMono NFM Italic

    font-family = BerkeleyMono Nerd Font
    #font-family = Iosevka Nerd Font
    # font-family = SFMono Nerd Font

    title = "GhosTTY"

    wait-after-command = false
    shell-integration = detect
    window-save-state = always
    gtk-single-instance = true
    unfocused-split-opacity = 0.5
    quick-terminal-position = center
    shell-integration-features = cursor,sudo
  '';
}
