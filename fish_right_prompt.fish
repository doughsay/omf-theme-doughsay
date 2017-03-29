function fish_right_prompt
  if [ "$theme_display_asdf" = "yes" ]
    set_color $fish_color_autosuggestion
    echo -n (string join (__doughsay_right_prompt_sep) (asdf-tools))
    set_color normal
  end
end

function __doughsay_right_prompt_sep
  set_color magenta
  echo -n " ∴ "
  set_color $fish_color_autosuggestion
end
