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

    # Inputs
    @inputs = args.inputs
    @mouse = args.inputs.mouse
    @kb = args.inputs.keyboard

    # Outputs
    @outputs = args.outputs
    @debug = args.outputs.debug
    @sounds = args.outputs.sounds
    @primitives = args.outputs.primitives

    # Read best times file (or create one if it doesn't exist)
    if (best_times_str = args.gtk.read_file(BEST_TIMES_FILE))
      # Process this so that if difficulty levels have changed,
      # i.e. across an update, the file is updated to reflect the changes
      best_times_input = best_times_str.to_best_times_hash
      @best_times = DIFFICULTY.keys.map { |d| [d, best_times_input[d]] }.to_h
    else
      # Write a blank best times file if one doesn't exist
      @best_times = DIFFICULTY.keys.map { |d| [d, nil] }.to_h
      save_best_times
    end

    set_scene(:main_menu, reset_stack: true)
  end

  def set_scene(scene, reset_stack: false)
    @scene_stack = [] if reset_stack
    @scene = scene
    @scene_stack << scene

    ["#{scene}_init", "render_#{scene}_init"].each do |method|
      send method if respond_to?(method)
    end
  end

  def set_scene_back
    @scene_stack.pop
    @scene = @scene_stack.last
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

  def save_best_times
    @args.gtk.write_file(BEST_TIMES_FILE, @best_times.to_best_times_str)
  end
end
