class Browse < Bitmap

	attr_reader :path
	attr_reader :selected
	
	def initialize(length, height, help_text, dir=false)
		super(length, height)
		
		@y = 0
		@selected = false
		help_text = help_text.to_s
		help_text = " " if help_text == ""
		btm = Bitmap.new(length, 26)
		btm.draw_text(btm.rect, help_text, 1)
		blt(0, 8, btm, btm.rect)
		
		@drives = get_drives
		@drive_button = Sprite.new
		@drive_button.y = 40
		@drive_button.x = 16
		@drive_button.bitmap = UpDown.new(length - 32, @drives)
		@dir = dir
		
		refresh_drive
		refresh
	end
	
	def refresh
		@container.dispose if @container
		
		@container = ListContainer.new(@show, self.width - 48, self.height - 74 - 16)
		@container.x = 24
		@container.y = 74 + @y
	end
	
	def y=(value)
		diff = value - @y
		@y = value
		@drive_button.y += diff
		@container.y += diff
	end
	
	def update
		return @path.to_s if @selected
		@drive_button.bitmap.hover = @drive_button.mouse_over?
		@drive_button.bitmap.update
		
		pressed = @container.get_pressed
		unless pressed == -1
			element = @show[pressed]
			unless @dir
				if element.include?(".")
					@selected = true
					@path << @show[pressed]
					return @path.to_s
				end
			end
			@path << (@show[pressed] + "\\")
			@show = get_current_input(@path.to_s)
			refresh
		end
		
		if Input.mouse_r?
			unless @path.size == 1
				@path.delete_at(@path.size - 1)
				@show = get_current_input(@path.to_s)
				refresh
			end
		end
		
		@container.update
		
		refresh_drive unless @d_index == @drive_button.bitmap.index
	end
	
	def refresh_drive
		@d_index = @drive_button.bitmap.index
		@show = []
		@show = get_current_input(@drives[@d_index])
		
		@path = [@drives[@d_index]]
		
		refresh
	end
	
	def get_current_input(dir)
		files = []
		begin
			Dir.foreach(dir) { |file|
				next if file == "." || file == ".." || file == "ntldr" || file == "RECYCLER" || file == "System Volume Information" || file == "boot.ini"
				next if (file.include?(".") || file.include?("$")) && @dir
				next if file.start_with?(".")
				next if file.end_with?("bat") || file.end_with?("BAT")
				next if file.end_with?("bin") || file.end_with?("BIN")
				next if file.end_with?("sys") || file.end_with?("SYS")
				next if file.end_with?("com") || file.end_with?("COM")
				next if file.end_with?("dat") || file.end_with?("DAT")
				files << file
			}
		rescue; end
		files
	end
	
	def get_drives
		drives = []
		["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"].each { |e|
			d = "#{e}:\\"
			drives << d if FileTest.exist? d
		}
		drives
	end
	
	def dispose
		@container.dispose
		@drive_button.bitmap.dispose
		@drive_button.dispose
		super
	end
	
end

class ListContainer	< Sprite

	attr_reader :scrolled

	def initialize(list, length, height)
		super()
		
		@rects = []
		@list = list
		return if @list.nil? || @list.size == 0
		@length = length
		@height = height
		
		draw_content_container
		
		refresh
	end
	
	def rects
		return @rects.nil? ? [] : @rects
	end
	
	def x=(value)
		old = self.x
		super(value)
		return if @rects.nil?
		diff = value - old
		@rects.each { |r|
			next if r.nil?
			r.x += diff
		}
	end
	
	def y=(value)
		old = self.y
		super(value)
		return if @rects.nil?
		diff = value - old
		@rects.each { |r|
			next if r.nil?
			r.y += diff
		}
	end
	
	def draw_content_container
		@contents_bitmap = Bitmap.new(@length, @list.size * 30)
		
		b = Bitmap.new(16, 16)
		
		@list.each_index { |i|
			btm = Bitmap.new(b.text_size(@list[i]).width, 26)
			btm.draw_text(btm.rect, @list[i])
			
			x = 0
			y = i * 30
			@contents_bitmap.blt(x, y, btm, btm.rect)
			r = Rect.new(x, y, btm.rect.width, 26)
			@rects << r
		}
	end
	
	def refresh
		self.bitmap.clear unless self.bitmap.nil?
		self.bitmap = Bitmap.new(@length, @height)
		
		self.bitmap.blt(0, 0, @contents_bitmap, Rect.new(0, 0, @length, @height))
	end
	
	def update
		return if @list.size == 0
		return unless mouse_over?
		scroll = Input.scroll?
		return if scroll.nil?
		if scroll
			# wheel up
			if @rects[0].y <= 60
				self.bitmap.clear
				
				@rects.each { |r|
					r.y += 60
				}
				y = @rects[0].y - self.y
				self.bitmap.blt(0, y, @contents_bitmap, Rect.new(0, 0, @length, @list.size * 30))
			end
		else
			last = @rects[@rects.size - 1]
			if last.y > @height
				self.bitmap.clear
				
				@rects.each { |r|
					r.y -= 60
				}
				y = @rects[0].y - self.y
				self.bitmap.blt(0, y, @contents_bitmap, Rect.new(0, 0, @length, @list.size * 30))
			end
		end
		
		super
	end
	
	def get_pressed
		pressed = -1
		
		i = 0
		@rects.each { |r|
			pressed = i if r.mouse_over? && Input.mouse?
			i += 1
		}
		
		pressed
	end
	
	def dispose
		self.bitmap.dispose unless self.bitmap.nil?
		
		super
	end
	
end