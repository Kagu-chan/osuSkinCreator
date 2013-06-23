class HelpPopup < Sprite
	
	def initialize(texts, parent)
		super()
		self.z = 99999
		
		if (!texts.is_a?(Array)) || (texts.size <= 0) || (texts.size > 2) || ((!parent.is_a?(Sprite)) && (!parent.is_a?(Rect)))
			raise(InvalidHelpPopupParameters)
		end
		@parent = parent
		
		@calcer = Bitmap.new(5, 5)
		@calcer.font.size = 12
		
		@fac = @calcer.text_size("I").height
		@height = (texts.size * @fac) + ((texts.size - 1) * 2)
		
		first = create_box(texts[0])
		second = create_box(texts.size == 2 ? texts[1] : nil)
		
		@length = [first.width, second.width].max
		
		f_p = (@length - first.width) / 2
		s_p = (@length - second.width) / 2
		
		self.bitmap = Bitmap.new(@length, @height)
		self.bitmap.fill_rect(self.bitmap.rect, Color.new(0, 0, 0, 130))
		self.bitmap.blt(f_p, 0, first, first.rect)
		
		if texts.size == 2
			self.bitmap.blt(s_p, @fac + 2, second, second.rect)
		end
		
		self.visible = false
	end
	
	def create_box(text)
		btm = Bitmap.new(5, 5)
		return btm if text.nil?
		
		btm = Bitmap.new((@calcer.text_size(text).width * 1.2).to_i, @fac)
		btm.font.size = @calcer.font.size
		btm.draw_text(btm.rect, text, 1)
		
		btm
	end
	
	def visible=(value)
		return if value == self.visible
		if value
			self.x = [$mouse.x + 20, 640 - @length].min
			self.x = [0, self.x].max
			
			self.y = [$mouse.y + 20, 480 - @height].min
			self.y = [0, self.y].max
		end
		super(value)
	end
	
	def update
		self.visible=(@parent.mouse_over?)
	end
	
end