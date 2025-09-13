class UntangleGame
  def handle_mouse_inputs
    # Don't allow mouse input if we're running an animation
    return if @animated_nodes.any?

    # If the game is solved, click anywhere to start over
    if @game_solved && @mouse.key_down?(:left) &&
       @mouse.intersect_rect?([0, 0, @screen_width, @screen_height])
      set_scene(:main_menu)
      play_sound(:return_to_main_menu)
    end

    ### Main game inputs

    if @mouse.key_down?(:left)
      if (node_clicked = node_under_mouse)
        @selection << node_clicked
        @selection_orig_pos[node_clicked] = @nodes[node_clicked]
        play_sound(:pickup)
      end
    end

    if @selection
      if @mouse.key_held?(:left)
        @selection.each { |n| move_node(n, @mouse.x, @mouse.y) }
      end

      if @mouse.key_up?(:left)
        # Check if we dragged the node off the screen
        if !@mouse.intersect_rect?([0, 0, @screen_width, @screen_height])
          @selection.each do |n|
            animate_move_node(n, @selection_orig_pos[n], RETURN_ANIMATION_DURATION)
          end
          play_sound(:rebound)
        else
          @game_solved = intersecting_edges.empty?

          # Win condition
          if @game_solved
            @timer_end ||= actual_time(@timer)

            if (best_time = @best_times[@difficulty])
              if @timer_end < best_time
                @new_best_time = true
                @best_times[@difficulty] = @timer_end
                save_best_times
              end
            else
              # No current best time, save it, but we don't want to
              # display the "new best time" message
              @best_times[@difficulty] = @timer_end
              save_best_times
            end
          end

          play_sound(@game_solved ? :win : :place)
        end

        @selection = []
        @selection_orig_pos = {}
      end
    end
  end

  def handle_keyboard_inputs
    if @kb.key_down?(:escape)
      set_scene(:pause_menu)
      play_sound(:pause)
    end

    if @kb.key_down?(:i)
      @highlight_intersecting_edges = !@highlight_intersecting_edges
    end
  end

  # Returns the index of the node under the mouse, or nil if the mouse
  # isn't over a node.
  def node_under_mouse
    @nodes.find_index { |node| @mouse.intersect_rect?(node_rect(node)) }
  end
end
