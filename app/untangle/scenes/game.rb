class UntangleGame
  def game_init
    @game_solved = false

    @difficulty_settings = DIFFICULTY[@difficulty] unless @difficulty == :custom

    @timer = 0
    @timer_end = nil
    @new_best_time = false
    @time_to_beat = @best_times[@difficulty]

    # Index and original position of selected nodes
    @selection = []
    @selection_orig_pos = {}
    @selection_box_origin = nil
    @mouse_orig_pos = nil
    @dragging_selection = false

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
    @difficulty_settings[:node_count]
  end

  def max_degree
    @difficulty_settings[:max_degree]
  end

  def groups
    @difficulty_settings[:groups]
  end

  # The timer is offset by the start animation
  def actual_time(ticks)
    ticks - START_ANIMATION_DURATION
  end
end
