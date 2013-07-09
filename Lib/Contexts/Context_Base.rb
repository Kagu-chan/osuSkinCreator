class Context_Base
  
  def initialize(window)
    Thread.main.raise InvalidContextCall unless window.is_a? Window_Base
    
    @window = window
    @contents = Context_Contents.new
    @contents.x = window.x + 5
    @contents.y = window.y + 5
    @contents.z = window.z + 5
    @contents.w = window.width - 10
    @contents.h = window.height - 10
    @graphics = []
		
		@relations = []
  end
  
  def setup
    Thread.main.raise InvalidContextScene
  end
  
  def update
    unless @back.nil?
			exit if @back.mouse_over? && Input.mouse?
		end
  end
  
	def exit
		Thread.main.raise InvalidContextScene
	end
	
  def unload
    @graphics.each { |gr|
      gr.bitmap.dispose
      gr.dispose
    }
    @graphics = []
		@window.dispose
		unless @back.nil?
			@back.bitmap.dispose
			@back.dispose
		end
  end
  
  def gr_add(bitmap)
    return unless bitmap.is_a? Bitmap
    bitmap = bitmap.clone
    
    sprite = Sprite.new
    sprite.x = @contents.x
    sprite.y = @contents.y
    sprite.z = @contents.z
    
    # calc x zoom
    factor = bitmap.width / @contents.w.to_f
    unless factor <= 1.0
      to_big = bitmap.width - @contents.w.to_f
      sub_factor = to_big / bitmap.width
      factor = 1.0 - sub_factor
      
      sprite.zoom_x = factor
    end
    
    # calc y zoom
    factor = bitmap.height / @contents.h.to_f
    
    unless factor <= 1.0
      to_big = bitmap.height - @contents.h.to_f
      sub_factor = to_big / bitmap.height
      factor = 1.0 - sub_factor
      
      sprite.zoom_y = factor
    end
    
    fac = [sprite.zoom_x, sprite.zoom_y].min
    sprite.zoom_x, sprite.zoom_y = fac, fac
    
    sprite.bitmap = bitmap
    @graphics << sprite
    sprite
  end
  
  def gr_last
    return nil if @graphics.nil? || @graphics.size == 0
    @graphics[@graphics.size - 1]
  end
  
	def slit_for_relation_table
		c = @contents
		r = @relations
		
		r << [5, 5, c.w / 2, c.h]
		r << [c.w / 2 + 5, 5, c.w / 2, c.h]
	end
	
	# btm_res: :r or :l for left or right
	def add_rel(y_pos, btm_res, bitmap, text=" ")
		r = @relations
		
		slit_for_relation_table if r.size == 0
		
		ret = [nil, nil]
		btm_res = :l unless [:r, :l].include? btm_res
		this_p = 0
		
		x_l = 3
		x_r = r[1][0] + 3
		
		gr_add bitmap
		gr_last.y += y_pos
		gr_last.x += btm_res == :l ? x_l : x_r
		
		ret[0] = gr_last
		
		gr_add Bitmap.new(r[1][2], bitmap.height)
		gr_last.bitmap.draw_text(gr_last.bitmap.rect, text)
		gr_last.y += y_pos
		gr_last.x += btm_res == :r ? x_l : x_r
		
		ret[1] = gr_last
		ret
	end
	
	def activate_back
		@back = Sprite.new
		@back.bitmap = Bitmap.new System::Skins::OSC.get_file(:menu_back)
		
		@back.x = 5
		@back.y = 480 - @back.bitmap.height - 5
		
		@back.add_info_text("Go back to last screen")
	end
	
end

class Context_Contents
  attr_accessor :x, :y, :w, :h, :z
  
  def initialize
    @x = 0
    @y = 0
    @w = 0
    @h = 0
    @z = 0
  end
end