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
        value: 3,
        min: 3,
        max: 10,
      },
      groups: {
        setting: :groups,
        value: 1,
        min: 1,
        max: 5,
      },
    }
  end

  def custom_menu_tick
    if @kb.key_down?(:escape)
      set_scene_back
      play_sound(:menu_switch)
    end

    if @mouse.key_down?(:left)
      handle_click
    end
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

    @selectors.each do |_, data|
      data[:buttons].each do |button|
        if @mouse.intersect_rect?(button)
          data[:value] = (data[:value] + button[:value]).clamp(
            data[:min], data[:max],
          )
          return
        end
      end
    end
  end

  def mouse_on_start_button?
    mouse_pos.intersect_rect?(@start_button_rect)
  end
end
