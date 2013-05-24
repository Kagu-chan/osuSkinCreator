class Bitmap
  
  # border = 0 => no border
  def draw_circle(rect, color, border, r_fill=nil)
    unless r_fill.is_a? Integer
      r_fill = [rect.height, rect.width].min / 2
    end
    ox = rect.x + r_fill
    oy = rect.y + r_fill
    
    dot_max = r_fill
    dot_min = border == 0 ? 0 : r_fill - border
    
    for x in 0..r_fill
      for y in 0..r_fill
        dot = (x**2 + y**2)**0.5
        
        if dot.between?(dot_min, dot_max)
          self.set_pixel(ox+x, oy+y, color)
          self.set_pixel(ox-x, oy+y, color)
          self.set_pixel(ox+x, oy-y, color)
          self.set_pixel(ox-x, oy-y, color)
        end
      end
    end
  end
  
end