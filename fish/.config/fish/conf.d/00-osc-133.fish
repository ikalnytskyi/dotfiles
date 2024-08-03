if status is-interactive
  function __osc_133_prompt_marker --on-event fish_prompt
    echo -en "\e]133;A\a"
  end

  function __osc_133_command_executed_marker --on-event fish_preexec
    echo -en "\e]133;C\a"
  end

  function __osc_133_command_finished_marker --on-event fish_postexec
    echo -en "\e]133;D\a"
  end
end
