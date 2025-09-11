# Constructor and main #tick method for the game runner class which is set
# to `args.state.game` in `main.rb`.
class UntangleGame
  def initialize(args)
    @args = args
    @state = args.state

    @ticks = 0

    @screen_width = args.grid.w
    @cx = args.grid.w / 2
    @screen_height = args.grid.h
    @cy = args.grid.h / 2

    @inputs = args.inputs
    @mouse = args.inputs.mouse
    @kb = args.inputs.keyboard

    # Outputs
    @outputs = args.outputs
    @debug = args.outputs.debug
    @sounds = args.outputs.sounds
    @primitives = args.outputs.primitives

    set_scene(:start)
  end

  def set_scene(scene)
    @scene = scene
    send "#{scene}_init"
    send "render_#{scene}_init" if respond_to?("render_#{scene}_init")
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
