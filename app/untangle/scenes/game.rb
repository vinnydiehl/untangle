class UntangleGame
  def game_init
    @nodes = [[200, 200], [200, 400], [400, 400], [400, 200]]
    @edges = @nodes.combination(2).to_a

    render_game_init
  end

  def game_tick; end
end
