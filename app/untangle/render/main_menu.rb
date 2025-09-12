class UntangleGame
  def render_main_menu
    render_background
    render_choices
  end

  def render_choices
    @choices.each_with_index do |choice, i|
      render_choice_box(i)
      render_choice_text(choice, i)
    end
  end

  # The centerpoint of a choice box
  def choice_point(i)
    separation = (@screen_height - (CHOICES_PADDING * 2)) / @choices.count
    [
      @cx,
      @screen_height - (separation * i + separation / 2 + CHOICES_PADDING),
    ]
  end

  def choice_rect(i)
    x, y = choice_point(i)

    {
      x: x - CHOICE_BOX_WIDTH / 2, y: y - CHOICE_BOX_HEIGHT / 2,
      w: CHOICE_BOX_WIDTH, h: CHOICE_BOX_HEIGHT,
    }
  end

  def render_choice_box(i)
    @primitives << {
      primitive_marker: :solid,
      **choice_rect(i),
      **(mouse_box_pos == i ? BUTTON_HIGHLIGHT_COLOR : BUTTON_COLOR),
    }
    @primitives << {
      primitive_marker: :border,
      **choice_rect(i),
      **BUTTON_BORDER_COLOR,
    }
  end

  def render_choice_text(choice, i)
    x, y = choice_point(i)

    @primitives << {
      x: x, y: y,
      w: CHOICE_BOX_WIDTH, h: CHOICE_BOX_HEIGHT,
      text: @choices[i].capitalize,
      alignment_enum: 1,
      vertical_alignment_enum: 1,
      size_enum: CHOICE_TEXT_SIZE,
      r: 255, g: 255, b: 255,
    }
  end
end
