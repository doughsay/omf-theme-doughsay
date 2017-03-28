function fish_prompt
  set -l last_status $status

  __doughsay_user
  __doughsay_pwd
  __doughsay_vcs
  __doughsay_prompt $last_status

  set_color normal
end

function __doughsay_user
  if test "$theme_display_user" = "yes"
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

  if test $dname != "."
    set_color blue
    echo -n "$dname"
    set -l last (string sub -s -1 -l 1 $dname)
    if test "$last" != "/"
      echo -n "/"
    end
  end

  if test $bname != "/"
    set_color brblue
    echo -n $bname
  end

  echo -n " "
end

function __doughsay_vcs
  if vcs.present
    set -l branch (__doughsay_vcs_branch)
    set -l statuses (__doughsay_vcs_statuses)

    echo -n "$branch "

    if test "$statuses" != ""
      set_color blue
      echo -n "$statuses "
    end
  end
end

function __doughsay_vcs_branch
  set -l s ""
  set -l state (vcs.status)

  if vcs.touched
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

  echo -ns (vcs.branch) $s
end

function __doughsay_vcs_statuses
  if vcs.touched; and not vcs.dirty; and not vcs.staged
    echo -n "…"
  end

  if vcs.dirty
    echo -n "○"
  end

  if vcs.staged
    echo -n "●"
  end
end

function __doughsay_prompt -a last_status
  if test $last_status != 0
    set_color red
  else
    set_color brwhite
  end

  set -q theme_hood_ornament; or set theme_hood_ornament "λ"

  echo -n "$theme_hood_ornament "
end

function __doughsay_dirname
  set -l dname (dirname (prompt_pwd))
  if test $dname != "."
    echo -n $dname
  end
end
