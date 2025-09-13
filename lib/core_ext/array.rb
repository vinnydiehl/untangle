class Array
  def deep_copy
    map(&:dup)
  end
end
