ARROW_ALPHA = 100
ARROW_BRIGHT_ALPHA = 200

SELECTOR_WIDTH = 100
SELECTOR_HEIGHT = 40
SELECTOR_X_SPACING = 250
SELECTOR_Y_SPACING = 100

class UntangleGame
  def render_custom_menu_init
    set_selector_positions
  end

  def set_selector_positions
    start_x = @cx - (SELECTOR_X_SPACING * (@selectors.size - 1) / 2) - (SELECTOR_WIDTH / 2)
    start_y_bottom = @cy - (SELECTOR_Y_SPACING / 2) - SELECTOR_HEIGHT
    start_y_top = start_y_bottom + SELECTOR_HEIGHT + SELECTOR_Y_SPACING
    @label_y = start_y_bottom + (SELECTOR_HEIGHT * 2) + SELECTOR_Y_SPACING + 50

    @selectors.each_with_index do |(_, data), i|
      data[:buttons] = [
        {
          x: start_x + i * SELECTOR_X_SPACING,
          y: start_y_top,
          w: 100,
          h: 40,
          path: "sprites/ui/chevron.png",
          a: ARROW_ALPHA,
          value: 1,
        },
        {
          x: start_x + i * SELECTOR_X_SPACING,
          y: start_y_bottom,
          w: 100,
          h: 40,
          angle: 180,
          path: "sprites/ui/chevron.png",
          a: ARROW_ALPHA,
          value: -1
        }
      ]
    end
  end

  def render_custom_menu
    render_background
    render_selectors
  end

  def render_selectors
    # Render up/down buttons
    @selectors.each do |name, data|
      data[:buttons].each do |button|
        # We're going to be pulsing the arrows white on hover, this makes it fade back.
        # Doing this before setting bright alpha so there is no flickering
        button[:a] -= 1 if button[:a] > ARROW_ALPHA

        # Pulse button white on hover
        button[:a] = ARROW_BRIGHT_ALPHA if @mouse.intersect_rect?(button)

        @primitives << button
      end

      selector_cx = data[:buttons][0][:x] + (SELECTOR_WIDTH / 2)

      # Render value
      @primitives << {
        x: selector_cx, y: @cy,
        text: data[:value],
        size_enum: 15,
        alignment_enum: 1,
        vertical_alignment_enum: 1,
        r: 255, g: 255, b: 255,
      }

      # Render title
      @primitives << {
        x: selector_cx, y: @label_y,
        text: name.to_capitalized_str,
        size_enum: 8,
        alignment_enum: 1,
        vertical_alignment_enum: 1,
        r: 255, g: 255, b: 255,
      }
    end
  end
end
