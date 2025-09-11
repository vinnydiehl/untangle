# A Union-Find (Disjoint Set Union) data structure with path compression and
# union by rank.
#
# This structure efficiently keeps track of disjoint sets of elements,
# supporting two main operations:
#  - union(x, y): Merge the sets containing elements x and y.
#  - find(x): Return the representative element (root) of the set containing x.
class UnionFind
  # Initializes a Union-Find structure for n elements (0..n-1)
  #
  # @param n [Integer] The number of elements in the set
  def initialize(n)
    # Each element initially points to itself
    @parent = Array.new(n) { |i| i }
    # Used for union by rank optimization
    @rank = Array.new(n, 0)
  end

  # Finds the representative (root) of the set containing x.
  # Implements path compression, so that all nodes along the path point
  # directly to the root.
  #
  # @param x [Integer] The element to find
  # @return [Integer] The root of the set containing x
  def find(x)
    @parent[x] = find(@parent[x]) if @parent[x] != x
    @parent[x]
  end

  # Unites the sets containing x and y.
  #
  # @param x [Integer] An element in the first set
  # @param y [Integer] An element in the second set
  # @return [void]
  def union(x, y)
    rx = find(x)
    ry = find(y)
    return if rx == ry

    # Use union by rank to attach the shorter tree under the taller tree,
    # keeping trees shallow.
    if @rank[rx] < @rank[ry]
      @parent[rx] = ry
    elsif @rank[rx] > @rank[ry]
      @parent[ry] = rx
    else
      @parent[ry] = rx
      @rank[rx] += 1
    end
  end

  # Checks whether elements x and y are in the same set.
  #
  # @param x [Integer] The first element
  # @param y [Integer] The second element
  # @return [Boolean] True if x and y are connected, false otherwise
  def connected?(x, y)
    find(x) == find(y)
  end
end
