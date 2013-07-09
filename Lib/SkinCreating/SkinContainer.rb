class SkinContainer < Bitmap

	attr_reader :path
	attr_reader :selected
	
	def initialize(length, height)
		super(length, height)
		
		@y = 0
		@selected = false
		
		@skins = get_skins
		
		refresh
	end
	
	def refresh
		@container.dispose if @container
		
		@container = SkinListContainer.new(@skins, self.width, self.height)
	end
	
	def y=(value)
		diff = value - @y
		@y = value
		@container.y += diff
	end
	
	def update
		pressed = @container.get_pressed
		unless pressed == -1
			element = @skins[pressed]
			
			return element
		end
		
		@container.update
	end
	
	def get_skins
		skins = []
		Dir.foreach($osu_dir + "/Skins") { |file|
			next if file == "." || file == ".."
			
			f_name = "#{$osu_dir}/Skins/#{file}/"
			next unless FileTest.exist?(f_name + "skin.ini")
			skins << f_name
		}
		
		skins
	end
	
	def dispose
		@container.dispose
		super
	end

end

class SkinListContainer	< Sprite

	attr_reader :scrolled

	def initialize(list, length, height)
		super()
		
		@previews = []
		@rows = []
		
		@list = list
		return if @list.nil? || @list.size == 0
		@length = length
		@height = height
		
		@ables = @length / 197
		@down_ables = @height / 150
		@diff = (@length - 10 - (@ables * 197)) / (@ables - 1)
		
		draw_content_container
		refresh
	end
	
	def x=(value)
		old = self.x
		super(value)
		return if @previews.nil?
		diff = value - old
		@previews.each { |r|
			next if r.nil?
			r.x += diff
		}
	end
	
	def y=(value)
		old = self.y
		super(value)
		return if @previews.nil?
		diff = value - old
		@previews.each { |r|
			next if r.nil?
			r.y += diff
		}
	end
	
	def draw_content_container
		@contents_bitmap = Bitmap.new(@length, @list.size * 150)
		c = 0
		row = []
		@list.each_index { |i|
			ini = File.open(@list[i] + "/skin.ini", "r+")
			t = ini.read
			ini.close
			
			t.match(/#{Regexp.escape("Name:")}(.*)$/)
			
			a = i / @ables
			b = i % @ables
			
			x = 5 + b * 197 + (b - 1) * @diff
			preview = SkinPreview.new(x, a * 150, $1.to_s, @list[i])
			
			@previews << preview
			row << preview
			
			c += 1
			if c % @ables == 0 || i == @list.size - 1
				@rows << row
				row = []
			end
		}
		
		check_visibility
	end
	
	def refresh
		self.bitmap.clear unless self.bitmap.nil?
		self.bitmap = Bitmap.new(@length, @height)
		
		self.bitmap.blt(0, 0, @contents_bitmap, Rect.new(0, 0, @length, @height))
	end
	
	def update
		return if @list.size == 0
		@previews.each { |p| p.update }
		scroll = Input.scroll?
		return if scroll.nil?
		if scroll
			# wheel up
			if !@rows[0][0].visible
				@previews.each { |prv| prv.py += 150 }
				check_visibility
			end
		else
			last = @rows[@rows.size - 1][0]
			if !last.visible
				@previews.each { |prv| prv.py -= 150 }
				check_visibility
			end
		end
		
		super
	end
	
	def check_visibility
		upper = self.y
		lower = @height
		able = @down_ables
		
		@rows.each { |row|
			upp = row[0].y - upper
			low = upp + 150
			row.each { |e| 
				e.visible = (upp >= 0) && (low <= able * 150)
			}
		}
	end
	
	def get_pressed
		pressed = -1
		
		i = 0
		@previews.each { |preview|
			pressed = i if preview.mouse_over? && Input.mouse?
			i += 1
		}
		
		pressed
	end
	
	def dispose
		@previews.each { |p| p.dispose }
		
		super
	end
	
end