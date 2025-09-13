class Hash
  def to_best_times_str
    map { |k, v| "#{k}:#{v || 'nil'}" }.join("\n")
  end
end
