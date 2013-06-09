class TextInput < Bitmap
  
  attr_reader :length
  attr_accessor :hover
  
  def initialize(length, text="")
    super length, 32
    
    @length = length
    @text = text.split("")
    @hover = false
    @index = text == "" ? 0 : @text.size
    
    @blink_cursor = Bitmap.new(16, 2)
    @blink_cursor.fill_rect(@blink_cursor.rect, Color.new(255, 255, 255))
    
    refresh
    
    Input.text_init
  end
  
  def length=(value)
    return if @length == value
    @length = value
    refresh
  end
  
  def text
    @text.so_s
  end
  
  def text=(value)
    return if @text == value
    @text = value.split("")
    @index = @text.size
    refresh
  end
  
  def insert(value)
    if @index == @text.size
      @text << value
    else
      @text.insert(@index, value)
    end
    @index += 1
    refresh
  end
  
  def back
    return if @index == 0
    @text.delete_at(@index - 1)
    @index -= 1
    refresh
  end
  
  def entf
    return if @index > @text.size - 1
    @text.delete_at(@index)
    refresh
  end
  
  def text
    @text.to_s
  end
  
  def refresh
    clear
    
    circle = Bitmap.new(12, 12)
    circle.draw_circle(circle.rect, Color.new(255, 255, 255), 2)
    
    corners = []
    4.times { corners << Bitmap.new(6, 6) }
    
    corners[0].blt(0, 0, circle, Rect.new(0, 0, 6, 6)) # upper left
    corners[1].blt(0, 0, circle, Rect.new(7, 0, 5, 6)) # upper right
    corners[2].blt(0, 0, circle, Rect.new(0, 7, 6, 5)) # lower left
    corners[3].blt(0, 0, circle, Rect.new(7, 7, 5, 5)) # lower right
    
    borders = [Bitmap.new(2 ,20), Bitmap.new(@length - 12, 2)]
    yellow_pigment = @hover ? 0 : 255
    borders.each { |border| border.fill_rect(border.rect, Color.new(255, 255, yellow_pigment)) }
    
    blt(1, 6, borders[0], borders[0].rect) # left
    blt(@length - 3, 6, borders[0], borders[0].rect) # right
    blt(6, 1, borders[1], borders[1].rect) # upper
    blt(6, 29, borders[1], borders[1].rect) # lower
    blt(0, 0, corners[0], corners[0].rect) # upper left
    blt(@length - 6, 0, corners[1], corners[1].rect) # upper right
    blt(0, 26, corners[2], corners[2].rect) # lower left
    blt(@length - 6, 26, corners[3], corners[3].rect) # lower right
    
    text_length = Bitmap.new(16,16).text_size(@text.to_s).width
    text_length = 1 if text_length == 0
		
    parts = []
    text_bitmap = nil
		
    if @index == @text.size
      adding = Bitmap.new(16,16).text_size("_").width
			
      text_bitmap = Bitmap.new(text_length + adding, 26)
      parts << @text.to_s
      parts << "_" if @hover
    elsif @index == 0
      text_bitmap = Bitmap.new(text_length, 26)
      parts << @text[0] << @text[1, @text.size - 1].to_s
    else
      text_bitmap = Bitmap.new(text_length, 26)
      parts << @text[0,@index].to_s << @text[@index]
      parts << @text[@index + 1, @text.size - @index - 1].to_s
    end
    
    pos = 0
    parts.each_index { |i|
      next if parts[i] == ""
      part_size = Bitmap.new(16,16).text_size(parts[i].to_s).width
      part_size = 1 if part_size == 0
			
      bitmap = Bitmap.new(part_size, 26)
      
      yellow = nil
      if parts.size == 3
        yellow = i == 1 ? 0 : 255
      else
        if @index == 0
          yellow = i == 0 ? 0 : 255
        else
          yellow = i != 0 ? 0 : 255
        end
      end
      
      yellow = 255 unless @hover
      
      bitmap.font.color = Color.new(255, 255, yellow)
      bitmap.draw_text(bitmap.rect, parts[i])
      
      text_bitmap.blt(pos, 0, bitmap, bitmap.rect)
      pos += part_size
    }
		
    real_size = Bitmap.new(16,16).text_size(parts.to_s).width
    
    blt_from = [0, @length - 8 - real_size].min
    blt_from *= -1 if blt_from < 0
    
    blt(4, 3, text_bitmap, Rect.new(blt_from, 0, [real_size, @length - 8].min, 26))
  end
  
  def update
    if Input.trigger? Input::RIGHT
      @index += 1 unless @index == @text.size
      refresh
    end
    if Input.trigger? Input::LEFT
      @index -= 1 unless @index == 0
      refresh
    end
    inp = Input.text_input
    if inp.size != 0
      if inp.include? "back"
        back
      elsif inp.include? "entf"
        entf
      else
        insert(inp)
      end
    end
  end
  
end