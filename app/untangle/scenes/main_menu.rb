class UntangleGame
  def main_menu_init
    choices = DIFFICULTY.keys.map.with_index do |diff, i|
      [
        diff,
        -> do
          @difficulty = DIFFICULTY[diff]
          set_scene(:game)
        end,
      ]
    end.to_h

    @menu = Menu.new(@args, choices)
  end

  def main_menu_tick
    @menu.tick
  end
end
