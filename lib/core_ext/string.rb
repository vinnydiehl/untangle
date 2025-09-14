class String
  def to_best_times_hash(custom: false)
    lines.map do |line|
      k, v = line.strip.split(":")

      # For custom times, the key will be a string
      k = k.to_sym unless custom

      [k, v == "nil" ? nil : v.to_i]
    end.to_h
  end
end
