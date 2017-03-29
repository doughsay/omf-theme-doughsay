function fish_prompt
  set -l last_status $status

  __doughsay_user
  __doughsay_pwd
  __doughsay_vcs
  __doughsay_prompt $last_status

  set_color normal
end

function __doughsay_user
  if [ "$theme_display_user" = "yes" ]
    set_color $fish_color_autosuggestion
    echo -n $USER
    set_color magenta
    echo -n "@"
    set_color $fish_color_autosuggestion
    echo -n (hostname)
    echo -n " "
  end
end

function __doughsay_pwd
  set -l ppwd (prompt_pwd)
  set -l dname (dirname $ppwd)
  set -l bname (basename $ppwd)

  if [ $dname != "." ]
    set_color blue
    echo -n "$dname"
    set -l last (string sub -s -1 -l 1 $dname)
    if [ "$last" != "/" ]
      echo -n "/"
    end
  end

  if [ $bname != "/" ]
    set_color brblue
    echo -n $bname
  end

  echo -n " "
end

function __doughsay_vcs
  if vcs.present
    set -l vcs_touched (__doughsay_vcs_touched)
    set -l vcs_dirty (__doughsay_vcs_dirty)
    set -l vcs_staged (__doughsay_vcs_staged)
    set -l vcs_state (vcs.status)
    set -l vcs_branch (vcs.branch)

    set -l branch (__doughsay_vcs_branch $vcs_state, $vcs_touched, $vcs_branch)
    set -l statuses (__doughsay_vcs_statuses $vcs_touched $vcs_dirty $vcs_staged)

    echo -n "$branch "

    if [ "$statuses" != "" ]
      set_color blue
      echo -n "$statuses "
    end
  end
end

function __doughsay_vcs_branch -a state touched branch
  set -l s ""

  if [ $touched = "yes" ]
    set_color yellow
  else
    set_color green
  end

  switch "$state"
    case "ahead"
      set s "+"
    case "behind"
      set s "-"
    case "diverged"
      set s "±"
    case "detached"
      set_color red
  end

  echo -ns $branch $s
end

function __doughsay_vcs_statuses -a touched dirty staged
  if [ $touched = "yes" ]; and [ $dirty = "no" ]; and [ $staged = "no" ]
    echo -n "…"
  end

  if [ $dirty = "yes" ]
    echo -n "○"
  end

  if [ $staged = "yes" ]
    echo -n "●"
  end
end

function __doughsay_vcs_touched
  if vcs.touched; echo -n "yes"; else; echo -n "no"; end
end

function __doughsay_vcs_dirty
  if vcs.dirty; echo -n "yes"; else; echo -n "no"; end
end

function __doughsay_vcs_staged
  if vcs.staged; echo -n "yes"; else; echo -n "no"; end
end

function __doughsay_prompt -a last_status
  if [ $last_status != 0 ]
    set_color red
  else
    set_color brwhite
  end

  set -q theme_hood_ornament; or set -l theme_hood_ornament "λ"

  echo -n "$theme_hood_ornament "
end
