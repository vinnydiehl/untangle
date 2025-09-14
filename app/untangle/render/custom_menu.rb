ARROW_ALPHA = 100
ARROW_BRIGHT_ALPHA = 200

SELECTOR_WIDTH = 100
SELECTOR_HEIGHT = 40
SELECTOR_X_SPACING = 250
SELECTOR_Y_SPACING = 100

BACK_BUTTON_WIDTH = 100
BACK_BUTTON_HEIGHT = 50
BACK_BUTTON_PADDING = 20
BACK_TEXT_SIZE = 0

START_BUTTON_WIDTH = 200
START_BUTTON_HEIGHT = 75

class UntangleGame
  def render_custom_menu_init
    set_selector_positions

    @start_button_rect = {
      x: @cx - (START_BUTTON_WIDTH / 2), y: 100,
      w: START_BUTTON_WIDTH, h: START_BUTTON_HEIGHT,
    }

    @back_button_rect = {
      x: BACK_BUTTON_PADDING,
      y: @screen_height - BACK_BUTTON_HEIGHT - BACK_BUTTON_PADDING,
      w: BACK_BUTTON_WIDTH, h: BACK_BUTTON_HEIGHT,
    }
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
    render_back_button
    render_start_button
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

  def render_back_button
    @primitives << {
      primitive_marker: :solid,
      **@back_button_rect,
      **(mouse_on_back_button? ? BUTTON_HIGHLIGHT_COLOR : BUTTON_COLOR),
    }
    @primitives << {
      primitive_marker: :border,
      **@back_button_rect,
      **BUTTON_BORDER_COLOR,
    }

    @primitives << {
      x: @back_button_rect.x + (BACK_BUTTON_WIDTH / 2),
      y: @back_button_rect.y + (BACK_BUTTON_HEIGHT / 2),
      text: "Back",
      alignment_enum: 1,
      vertical_alignment_enum: 1,
      size_enum: BACK_TEXT_SIZE,
      r: 255, g: 255, b: 255,
    }
  end

  def render_start_button
    @primitives << {
      primitive_marker: :solid,
      **@start_button_rect,
      **(mouse_on_start_button? ? BUTTON_HIGHLIGHT_COLOR : BUTTON_COLOR),
    }
    @primitives << {
      primitive_marker: :border,
      **@start_button_rect,
      **BUTTON_BORDER_COLOR,
    }

    @primitives << {
      x: @start_button_rect.x + (START_BUTTON_WIDTH / 2),
      y: @start_button_rect.y + (START_BUTTON_HEIGHT / 2),
      text: "Start",
      alignment_enum: 1,
      vertical_alignment_enum: 1,
      size_enum: 8,
      r: 255, g: 255, b: 255,
    }
  end
end
