class UntangleGame
  def game_init
    @game_solved = false
    @timer_end = nil

    # Index and original position of node held by the mouse
    @node_held = nil
    @node_orig_pos = nil

    @animated_nodes = []

    generate_game

    play_sound(:game_start)
  end

  def game_tick
    run_animation
    handle_mouse_inputs
  end

  def node_count
    @difficulty[:node_count]
  end

  def max_degree
    @difficulty[:max_degree]
  end
end
