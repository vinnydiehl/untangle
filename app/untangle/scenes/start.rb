class UntangleGame
  def start_init
    @choices = DIFFICULTY.keys
  end

  def start_tick
    if @mouse.key_down?(:left) && (i = mouse_box_pos)
      @difficulty = DIFFICULTY.values[i]
      set_scene(:game)
    end
  end

  # If over a choice box, return the index of that box, otherwise
  # return nil
  def mouse_box_pos
    (0...DIFFICULTY.size).to_a.find do |i|
      @mouse.intersect_rect?(choice_rect(i))
    end
  end
end
