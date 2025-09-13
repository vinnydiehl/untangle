class UntangleGame
  def game_init
    @game_solved = false

    @timer = 0
    @timer_end = nil
    @new_best_time = false
    @time_to_beat = @best_times[@difficulty]

    # Index and original position of node held by the mouse
    @node_held = nil
    @node_orig_pos = nil

    @highlight_intersecting_edges = false

    @animated_nodes = []

    generate_game

    play_sound(:game_start)
  end

  def game_tick
    run_animation
    handle_mouse_inputs
    handle_keyboard_inputs

    @timer += 1
  end

  def node_count
    DIFFICULTY[@difficulty][:node_count]
  end

  def max_degree
    DIFFICULTY[@difficulty][:max_degree]
  end

  # The timer is offset by the start animation
  def actual_time(ticks)
    ticks - START_ANIMATION_DURATION
  end
end
