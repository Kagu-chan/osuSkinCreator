class SkinPreview < Window_Base

	attr_reader :disabled
	attr_reader :hover
	
	def initialize(x, y, text, path=nil)
		super(x, y, 196, 147, 200)
		
		@hover = false
		@sprites = []
		@text = text
		@disabled = false
		
		@path = path
		@path = "Graphics/SkinFiles/" if @path.nil?
		@path = "Graphics/SkinFiles/" unless FileTest.exist? @path
		
		refresh
	end
	
	def px; self.x; end
	def py; self.y; end
	
	def px=(value)
		diff = self.x - value
		return if diff == 0
		
		self.x -= diff
		@sprites.each { |s| s.x -= diff }
	end
	
	def py=(value)
		diff = self.y - value
		return if diff == 0
		
		self.y -= diff
		@sprites.each { |s| s.y -= diff }
	end
	
	def hover=(value)
		return if value == @hover
		@hover = value
		r_hover
	end
	
	def visible=(value)
		@sprites.each { |s| s.visible = value }
		super
	end
	
	def disable
		@disabled = true
		self.opacity = 30
		@sprites.each { |s|
			s.opacity = 60
		}
	end
	
	def hov_int(value)
		return if value == @hover
		@hover = value
		r_hover
	end
	
	def r_hover
		self.opacity = @hover ? 120 : 60
		@sprites.each { |s|
			s.opacity = @hover ? 255 : 120
		}
	end
	
	def refresh
		s = System::Skins::Helper.get_hit_circle(@path, rand(10), Color.new(253,133,15))
		s.x += 10 + self.x
		s.y += 5 + self.y
		@sprites << s
		
		s = System::Skins::Helper.get_cursor(@path)
		s.x += 43 + self.x
		s.y += 18 + self.y
		@sprites << s
		
		p = System::Skins::Helper.get_playfield(@path, [192, 143])
		p.x += 2 + self.x
		p.y += 2 + self.y
		p.z = self.z - 1
		
		b = System::Skins::Helper.get_button_with_star(@path, [192, 34])
		b.x += 2 + self.x
		b.y = 147 - 2 - 34 + self.y
		@sprites << b
		
		Graphics.update
		
		s = Sprite.new
		s.bitmap = Bitmap.new(192, 34)
		#s.bitmap.font.color = b.bitmap.get_inverted_color
		s.bitmap.font.color = Color.new(0, 0, 0)
		s.bitmap.draw_text(s.bitmap.rect, @text + "   ", 2)
		s.x += 2 + self.x
		s.y = 147 - 2 - 34 + self.y
		@sprites << s
		
		Graphics.update
		
		s = System::Skins::Helper.get_ranking_xh(@path)
		s.x = self.x - s.bitmap.width - 5 + self.width
		s.y += 5 + self.y
		@sprites << s
		
		@sprites.each { |s|
			s.z = 201
		}
		
		@sprites << p
		
		r_hover
	end
	
	def update
		if @disabled
			hov_int(false)
			return
		end
		hov_int(mouse_over?)
	end
	
	def dispose
		@sprites.each { |s|
			s.bitmap.dispose
			s.dispose
		}
		super
	end
	
end