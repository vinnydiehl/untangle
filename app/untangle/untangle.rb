# Constructor and main #tick method for the game runner class which is set
# to `args.state.game` in `main.rb`.
class UntangleGame
  def initialize(args)
    @args = args
    @state = args.state

    @ticks = 0

    @screen_width = args.grid.w
    @screen_height = args.grid.h

    @inputs = args.inputs
    @mouse = args.inputs.mouse
    @kb = args.inputs.keyboard

    # Outputs
    @outputs = args.outputs
    @debug = args.outputs.debug
    @sounds = args.outputs.sounds
    @primitives = args.outputs.primitives

    @scene_stack = []
    @scene = :game
    game_init
  end

  def tick
    @ticks = Kernel.tick_count

    # Save this so that even if the scene changes during the tick, it is
    # still rendered before switching scenes.
    scene = @scene
    send "#{scene}_tick"
    send "render_#{scene}"

    # Reset game, for development
    if @kb.key_down.backspace
      @args.gtk.reboot
    end
  end

  def play_sound(name)
    @args.audio[name] = { input: "sounds/#{name}.mp3" }
  end
end
