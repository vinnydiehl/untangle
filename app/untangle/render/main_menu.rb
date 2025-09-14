CUSTOM_BUTTON_WIDTH = 150
CUSTOM_BUTTON_HEIGHT = 50
CUSTOM_BUTTON_PADDING = 20
CUSTOM_TEXT_SIZE = 0

class UntangleGame
  def render_main_menu_init
    @subtext = @best_times.values.map { |t| t ? format_time(t) : nil }
    @custom_button_rect = {
      x: @screen_width - CUSTOM_BUTTON_WIDTH - CUSTOM_BUTTON_PADDING,
      y: CUSTOM_BUTTON_PADDING,
      w: CUSTOM_BUTTON_WIDTH, h: CUSTOM_BUTTON_HEIGHT,
    }
  end

  def render_main_menu
    render_background
    @menu.render_choices(subtext: @subtext)
    render_custom_button
  end

  def render_custom_button
    @primitives << {
      primitive_marker: :solid,
      **@custom_button_rect,
      **(mouse_on_custom_button? ? BUTTON_HIGHLIGHT_COLOR : BUTTON_COLOR),
    }
    @primitives << {
      primitive_marker: :border,
      **@custom_button_rect,
      **BUTTON_BORDER_COLOR,
    }

    @primitives << {
      x: @custom_button_rect.x + (CUSTOM_BUTTON_WIDTH / 2),
      y: @custom_button_rect.y + (CUSTOM_BUTTON_HEIGHT / 2),
      text: "Custom...",
      alignment_enum: 1,
      vertical_alignment_enum: 1,
      size_enum: CUSTOM_TEXT_SIZE,
      r: 255, g: 255, b: 255,
    }
  end
end
