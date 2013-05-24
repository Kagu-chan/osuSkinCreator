class CheckBox < Bitmap
  
  attr_reader :checked
  attr_reader :hover
  
  def initialize(checked=false)
    super 32, 32
    @checked = checked
    @hover = false
    refresh
  end
  
  def checked=(value)
    return if value == @checked
    @checked = value
    refresh
  end
  
  def hover=(value)
    return if value == @hover
    @hover = value
    refresh
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
    
    borders = [Bitmap.new(2,20), Bitmap.new(20,2)]
    yellow_pigment = @hover ? 0 : 255
    borders.each { |border| border.fill_rect(border.rect, Color.new(255, 255, yellow_pigment)) }
    
    fill_rect(4, 4, 24, 24, Color.new(255, 255, 255)) if @checked
    
    blt(1, 6, borders[0], borders[0].rect) # left
    blt(29, 6, borders[0], borders[0].rect) # right
    blt(6, 1, borders[1], borders[1].rect) # upper
    blt(6, 29, borders[1], borders[1].rect) # lower
    blt(0, 0, corners[0], corners[0].rect) # upper left
    blt(26, 0, corners[1], corners[1].rect) # upper right
    blt(0, 26, corners[2], corners[2].rect) # lower left
    blt(26, 26, corners[3], corners[3].rect) # lower right
  end
  
end