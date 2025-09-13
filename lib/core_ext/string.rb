class String
  def to_best_times_hash
    lines.map do |line|
      k, v = line.strip.split(":")
      [k.to_sym, v == "nil" ? nil : v.to_i]
    end.to_h
  end
end
