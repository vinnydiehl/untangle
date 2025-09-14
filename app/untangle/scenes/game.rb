class UntangleGame
  def game_init
    @game_solved = false

    if @difficulty == :custom
      # If the custom difficulty is the same as one of the preset difficulties,
      # let's officially change the difficulty setting to that, so that if
      # we get a best time for that difficulty it will be saved there.
      @difficulty = DIFFICULTY.find do |_, settings|
        deserialize_difficulty == deserialize_difficulty(settings)
      end&.first || :custom
    else
      # We're using a preset difficulty, import that difficulty's settings
      @difficulty_settings = DIFFICULTY[@difficulty]
    end

    @timer = 0
    @timer_end = nil
    @new_best_time = false
    @time_to_beat = if @difficulty == :custom
      @custom_times[deserialize_difficulty]
    else
      @best_times[@difficulty]
    end

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
