#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x      : window x-coordinate
  #     y      : window y-coordinate
  #     width  : window width
  #     height : window height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, z=0, opacity=120)
    super()
    @windowskin_name = $window_skin if $window_skin
    self.windowskin = Bitmap.new(@windowskin_name)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.z = z
    self.opacity = opacity
    self.contents = Bitmap.new(width - 32, height - 32)
  end
	
	#--------------------------------------------------------------------------
  # * Change skin file
  #--------------------------------------------------------------------------
	def change_window_skin(new_skin)
		@windowskin_name = new_skin
		self.windowskin = Bitmap.new(@windowskin_name)
	end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    # Dispose if window contents bitmap is set
    if self.contents != nil
      self.contents.dispose
    end
    super
  end
end
