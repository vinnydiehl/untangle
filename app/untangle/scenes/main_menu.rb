class UntangleGame
  def main_menu_init
    choices = DIFFICULTY.keys.map.with_index do |difficulty, i|
      [
        difficulty,
        -> do
          @difficulty = difficulty
          set_scene(:game)
        end,
      ]
    end.to_h

    @menu = Menu.new(@args, choices)

    @sound_played = true
  end

  def main_menu_tick
    @menu.tick

    mcb = mouse_on_custom_button?
    if mcb && !@sound_played
      play_sound(:button_hover)
      @sound_played = true
    elsif !mcb
      @sound_played = false
    end

    if @mouse.key_down?(:left) && mouse_on_custom_button?
      set_scene(:custom_menu)
      play_sound(:menu_switch)
    end
  end

  def mouse_on_custom_button?
    mouse_pos.intersect_rect?(@custom_button_rect)
  end
end
