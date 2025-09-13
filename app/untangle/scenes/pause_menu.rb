class UntangleGame
  def pause_menu_init
    choices = {
      main_menu: -> do
        set_scene(:main_menu, reset_stack: true)
        play_sound(:return_to_main_menu)
      end,
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
    play_sound(:resume)
  end
end
