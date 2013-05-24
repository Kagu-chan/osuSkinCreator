class Context_Welcome < Context_Base
  
  def setup
    gr_add RPG::Cache.picture("OSKCLogo")
    
    @buttons = [0, 0, 0, 0]
    
    @index = 0
    refresh
  end
  
  def init_button(text, x, y, hover=false)
    gr_add RPG::Cache.picture(hover ? "MenuTextBase_hover" : "MenuTextBase")
    gr_last.z -= 1
    gr_last.x += x
    gr_last.y += y
    gr_last.bitmap.draw_text(gr_last.bitmap.rect, text + "  ", 2)
    gr_last
  end
  
  def refresh
    texts = [:new_skin, :load_skin, :options, :about]
    x_pos = [220, 280, 280, 220]
    
    for i in 0..3
      @buttons[i] = init_button($lang[texts[i]], x_pos[i], (18 + 18 * i + 58 * i), i == @index)
    end
  end
  
  def update
    if Input.trigger? Input::UP
      @index = (@index - 1) % 4
      refresh
    end
    if Input.trigger? Input::DOWN
      @index = (@index + 1) % 4
      refresh
    end
    if Input.trigger? Input::C
      return case @index
      when 0
        nil
      when 1
        nil
      when 2
        Context_Options.new(@window)
      when 3
        nil
      end
    end
    nil
  end
  
end