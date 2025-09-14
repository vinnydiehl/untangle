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

    if @mouse.key_down?(:left) && !@selection_box_origin
      @mouse_orig_pos = mouse_pos

      if (node_clicked = node_under_mouse)
        if @kb.key_down_or_held?(:shift)
          if @selection.include?(node_clicked)
            remove_selection(node_clicked)
          else
            add_selection(node_clicked)
          end

          play_sound(:select)
          return
        elsif (@selection.empty? || !@selection.include?(node_clicked)) &&
           !@kb.key_down_or_held?(:shift)
          # We've clicked on a node directly
          select_nodes([node_clicked])
        end

        return unless @selection.include?(node_clicked)

        @dragging_selection = true
        play_sound(:pickup)
      else
        # We've clicked on an empty spot on the screen, so
        # make a selection
        @selection_box_origin = [@mouse.x, @mouse.y]
        play_sound(:select)
      end
    end

    if @selection.any? && !@selection_box_origin
      if @mouse.key_held?(:left)
        return unless @dragging_selection

        @selection.each_with_index do |n, i|
          move_node(n, @selection_orig_pos[n].x + @mouse.x - @mouse_orig_pos.x,
                       @selection_orig_pos[n].y + @mouse.y - @mouse_orig_pos.y)
        end
      end

      if @mouse.key_up?(:left)
        all_nodes_on_screen = @selection.all? do |i|
          @nodes[i].intersect_rect?([0, 0, @screen_width, @screen_height])
        end

        if !all_nodes_on_screen
          # We've dragged node off the screen
          @selection.each do |n|
            animate_move_node(n, @selection_orig_pos[n], RETURN_ANIMATION_DURATION)
          end
          play_sound(:rebound)
        else
          # We've let go of a node (or selection of nodes)

          # Set new origin position
          @selection.each do |i|
            @selection_orig_pos[i] = @nodes[i]
          end

          @game_solved = intersecting_edges.empty?

          # Win condition
          if @game_solved
            @timer_end ||= actual_time(@timer)

            # Keep track of best time (unless on a custom difficulty)
            unless @difficulty == :custom
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
          end

          play_sound(@game_solved ? :win : :place) if @dragging_selection
        end

        @dragging_selection = false

        if @selection.size < 2 && !@kb.key_held?(:shift)
          clear_selection
        end
      end
    else
      if @mouse.key_up?(:left)
        play_sound(:select) if @selection_box_origin
        @selection_box_origin = nil
      elsif @selection_box_origin && @mouse.key_held?(:left)
        select_nodes(
          @nodes.filter_map.with_index do |node, i|
            i if node.intersect_rect?(selection_rect)
          end
        )
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

  def mouse_pos
    [@mouse.x, @mouse.y]
  end
end
