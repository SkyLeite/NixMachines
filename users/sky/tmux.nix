{ config, pkgs, lib, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    shell = "${pkgs.zsh}/bin/zsh";
    tmuxinator.enable = true;
    prefix = "C-a";
    terminal = "screen-256color";
    extraConfig = ''
      set -g mouse on
      set -g base-index 1
      setw -g pane-base-index 1
      setw -g mode-keys vi

      set-option -sg escape-time 1

      unbind '"'
      unbind %
      unbind s
      unbind v

      bind r source-file ~/.config/tmux/tmux.conf

      bind -n M-s split-window -v
      bind -n M-v split-window -h


      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Use Alt-vim keys without prefix key to switch panes
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Copy and paste 
      bind P paste-buffer
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
    '';
  };
}
