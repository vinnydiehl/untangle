class UntangleGame
  def pause_menu_init
    choices = {
      :"Main menu" => -> { set_scene(:main_menu, reset_stack: true) },
      restart: -> { set_scene(:game, reset_stack: true) },
      resume: method(:resume),
    }

    @menu = Menu.new(@args, choices)
  end

  def pause_menu_tick
    resume if @kb.key_down?(:escape)
    @menu.tick
  end

  def resume
    set_scene_back
  end
end
