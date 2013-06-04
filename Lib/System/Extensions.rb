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
		
		scale_down_x(sizes[0])
		scale_down_y(sizes[1])
	end
	
	def scale_down_x(size)
		return if size <= 640
		size = size.to_f
		
    to_big = size - 640
		sub_factor = to_big / size
		factor = 1.0 - sub_factor
		
		self.zoom_x = factor
	end
	
	def scale_down_y(size)
		return if size <= 480
		size = size.to_f
		
    to_big = size - 480
		sub_factor = to_big / size
		factor = 1.0 - sub_factor
      
		self.zoom_y = factor
	end
	
end