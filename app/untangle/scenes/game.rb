class UntangleGame
  def game_init
    @game_solved = false

    # Index and original position of node held by the mouse
    @node_held = nil
    @node_orig_pos = nil

    @animated_nodes = []

    generate_game
    render_game_init

    play_sound(:game_start)
  end

  def game_tick
    run_animation
    handle_mouse_inputs
  end
end
