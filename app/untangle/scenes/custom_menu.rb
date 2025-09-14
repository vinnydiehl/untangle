class UntangleGame
  def custom_menu_init
    @selectors = {
      nodes: {
        setting: :node_count,
        value: 10,
        min: 4,
        max: 50,
      },
      connectivity: {
        setting: :max_degree,
        value: 4,
        min: 3,
        max: 10,
      },
      groups: {
        setting: :groups,
        value: 1,
        min: 1,
        max: 10,
      },
    }
  end

  def custom_menu_tick
    if @kb.key_down?(:escape)
      exit_menu
    end

    if @mouse.key_down?(:left)
      handle_click
    end

    handle_scroll
  end

  def handle_click
    if mouse_on_start_button?
      @difficulty = :custom
      @difficulty_settings = @selectors.map do |_, data|
        [data[:setting], data[:value]]
      end.to_h

      set_scene(:game)

      return
    end

    if mouse_on_back_button?
      exit_menu
      return
    end

    @selectors.each do |_, data|
      data[:buttons].each do |button|
        if @mouse.intersect_rect?(button)
          set_clamped_value(data, data[:value] + button[:value])
          play_sound(:button_hover)
          return
        end
      end
    end
  end

  def handle_scroll
    return unless (d = @mouse.wheel&.y)

    @selectors.each do |_, data|
      number_rect = {
        x: data[:buttons][0].x,
        y: @start_y_bottom + SELECTOR_HEIGHT,
        w: SELECTOR_WIDTH, h: SELECTOR_Y_SPACING,
      }

      next unless @mouse.intersect_rect?(number_rect)

      orig_value = data[:value]
      set_clamped_value(data, data[:value] += d)

      # Light up the top or bottom button depending on which
      # way we're scrolling (if the value has changed)
      if data[:value] != orig_value
        button_i = d > 0 ? 0 : 1
        data[:buttons][button_i][:a] = ARROW_BRIGHT_ALPHA
        play_sound(:scroll)
      end
    end
  end

  def set_clamped_value(data, value)
    data[:value] = value.clamp(data[:min], data[:max])
  end

  def exit_menu
    set_scene_back
    play_sound(:menu_switch)
  end

  def mouse_on_back_button?
    mouse_pos.intersect_rect?(@back_button_rect)
  end

  def mouse_on_start_button?
    mouse_pos.intersect_rect?(@start_button_rect)
  end
end
