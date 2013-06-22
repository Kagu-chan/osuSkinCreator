class String

  def start_with?(str)
    !self.match(/^#{Regexp.escape(str)}/).nil?
  end

  def end_with?(str)
    !self.match(/#{Regexp.escape(str)}$/).nil?
  end
	
	def ensure_extend(str1, str2, extension)
		end_with = end_with?(str1) or end_with?(str2)
		addition = end_with ? "" : extension
		return self + addition
	end
end

class Thread
  
  def call_method(command)
    eval command
  end
  
end

class File

	def File.copy(from, to)
		p from, to
		fr_stream = File.open(from, "rb")
		to_stream = File.open(to, "wb")
		
		to_stream.puts fr_stream.read
		
		fr_stream.close
		to_stream.close
	end
	
end

# Bitmaps, which are bigger than 640 x or 480 y will automatically scaled down to the maximum size.
class Sprite

	alias_method :old_unscaled_bitmap, :bitmap=
	
	def bitmap=(value)
		old_unscaled_bitmap(value)
		sizes = [value.width, value.height]
		
		scale_down_x(sizes[0], 640)
		scale_down_y(sizes[1], 480)
	end
	
	def scale_down_x(size, to)
		return if size <= to
		size = size.to_f
		
    to_big = size - to
		sub_factor = to_big / size
		factor = 1.0 - sub_factor
		
		self.zoom_x = factor
	end
	
	def scale_down_y(size, to)
		return if size <= to
		size = size.to_f
		
    to_big = size - to
		sub_factor = to_big / size
		factor = 1.0 - sub_factor
      
		self.zoom_y = factor
	end
	
	def scale_down_to(width, height)
		sizes = [self.bitmap.width, self.bitmap.height]
		
		scale_down_x(sizes[0], width)
		scale_down_y(sizes[1], height)
	end
	
end

class Bitmap

	def coloring(color)
		for x in 0...self.width
			for y in 0...self.height
				c = get_pixel(x, y)
				c.red = [c.red - color.red, 0].max
				c.green = [c.green - color.green, 0].max
				c.blue = [c.blue - color.blue, 0].max
				set_pixel(x, y, c)
			end
		end
		self
	end
	
	def get_inverted_color
		r = 0
		g = 0
		b = 0
		px = 0
		w = self.width
		h = self.height
		for x in 0...w
			for y in 0...h
				c = get_pixel(x, y)
				r += c.red
				g += c.green
				b += c.blue
				px += 1
			end
			#h = [h-1, 0].max
			w = [w-1, 0].max
		end
		r /= px
		g /= px
		b /= px
		Color.new(255 - r, 255 - g, 255 - b)
	end

end

# Sprites could have a infobox
class Sprite

	class << self; 
		attr_accessor :texts
	end
	
	def setup
		self.class.texts ||= {}
	end
	private :setup
	
	attr_reader :info
	
	def add_info_text(*args)
		setup
		infos = case args.size
			when 0
				nil
			when 1
				args[0]
			else
				[args[0], args[1]]
		end
		return if infos.nil?
		
		@key = "#{rand(1000000).to_s}"
		@info = infos
		self.class.texts[@key] = self
	end
	
	def has_info_text?
		!@key.nil?
	end
	
	alias_method :jrgcbfexkndjnfxgiz_dispose, :dispose
	def dispose
		unless @key.nil?
			self.class.texts.delete(@key) if self.class.texts.has_key?(@key)
		end
		jrgcbfexkndjnfxgiz_dispose
	end
	
end