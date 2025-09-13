class UntangleGame
  def render_main_menu_init
    @subtext = @best_times.values.map { |t| t ? format_time(t) : nil }
  end

  def render_main_menu
    render_background
    @menu.render_choices(subtext: @subtext)
  end
end
