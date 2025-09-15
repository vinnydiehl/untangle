# Groups, just like nodes, are referred to by index. For example, if we have 3
# groups of 10 nodes each, the node indices will be 0-29. Group index 0 will be
# nodes 0-9, group index 1 will be nodes 10-19, and group index 3 will be 20-29.

class UntangleGame
  # Returns the index of the group that node +i+ is located in.
  def group_index(node_i)
    (node_i / @difficulty_settings[:node_count]).floor
  end

  # Returns a list of node indices for a given group index.
  def group_nodes(group_i)
    start = group_i * @difficulty_settings[:node_count]
    (start...(start + @difficulty_settings[:node_count])).to_a
  end

  # Checks whether or not the given group is fully solved (no
  # intersections with any edge)
  def group_solved?(group_i)
    group_nodes_i = group_nodes(group_i)

    group_edges = @edges.select { |edge| edge.all? { |n| group_nodes_i.include?(n) } }

    group_edges.none? do |ge|
      @edges.any? { |e| ge != e && intersect?(ge, e, nodes: @nodes) }
    end
  end

  # Returns an array of group indices that are solved.
  def groups_solved
    (0...@difficulty_settings[:groups]).select { |i| group_solved?(i) }
  end
end
