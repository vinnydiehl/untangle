BEST_TIMES_FILE = "save_data/best_times"
CUSTOM_TIMES_FILE = "save_data/custom_best_times"

class UntangleGame
  def load_best_times
    # Read best times file (or create one if it doesn't exist)
    if (best_times_str = @args.gtk.read_file(BEST_TIMES_FILE))
      # Process this so that if difficulty levels have changed,
      # i.e. across an update, the file is updated to reflect the changes
      best_times_input = best_times_str.to_best_times_hash
      @best_times = DIFFICULTY.keys.map { |d| [d, best_times_input[d]] }.to_h
    else
      # Write a blank best times file if one doesn't exist
      @best_times = DIFFICULTY.keys.map { |d| [d, nil] }.to_h
      save_best_times
    end
  end

  def save_best_times
    @args.gtk.write_file(BEST_TIMES_FILE, @best_times.to_best_times_str)
  end

  def load_custom_times
    # Read custom best times file if it exists, otherwise this will be
    # an empty Hash which we will be able to populate if necessary
    @custom_times = if (custom_times_str = @args.gtk.read_file(CUSTOM_TIMES_FILE))
      custom_times_str.to_best_times_hash(custom: true)
    else
      {}
    end
  end

  def save_custom_times
    @args.gtk.write_file(CUSTOM_TIMES_FILE, @custom_times.to_best_times_str)
  end

  # Returns the difficulty settings as a comma-separated String in the form
  # of "node_count,max_degree,groups"
  def deserialize_difficulty(settings = @difficulty_settings)
    settings.values.map(&:to_s).join(",")
  end

  def handle_best_times_on_win
    # Keep track of best times
    if @difficulty == :custom
      diff = deserialize_difficulty

      if (custom_time = @custom_times[diff])
        if @timer_end < custom_time
          @new_best_time = true
          @custom_times[diff] = @timer_end
          save_custom_times
        end
      else
        # No current best time, save it, but we don't want to
        # display the "new best time" message
        @custom_times[diff] = @timer_end
        save_custom_times
      end
    else
      if (best_time = @best_times[@difficulty])
        if @timer_end < best_time
          @new_best_time = true
          @best_times[@difficulty] = @timer_end
          save_best_times
        end
      else
        # No current best time, save it, but we don't want to
        # display the "new best time" message
        @best_times[@difficulty] = @timer_end
        save_best_times
      end
    end
  end
end
