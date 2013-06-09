#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
# Mouse Controller by Blizzard
# Version: 2.0b
# Type: Custom Input System
# Date: 9.10.2009
# Date v2.0b: 22.7.2010
# Edit by Kagurame for osc v0.1 mouse control
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#   
#  This work is protected by the following license:
# #----------------------------------------------------------------------------
# #  
# #  Creative Commons - Attribution-NonCommercial-ShareAlike 3.0 Unported
# #  ( http://creativecommons.org/licenses/by-nc-sa/3.0/ )
# #  
# #  You are free:
# #  
# #  to Share - to copy, distribute and transmit the work
# #  to Remix - to adapt the work
# #  
# #  Under the following conditions:
# #  
# #  Attribution. You must attribute the work in the manner specified by the
# #  author or licensor (but not in any way that suggests that they endorse you
# #  or your use of the work).
# #  
# #  Noncommercial. You may not use this work for commercial purposes.
# #  
# #  Share alike. If you alter, transform, or build upon this work, you may
# #  distribute the resulting work only under the same or similar license to
# #  this one.
# #  
# #  - For any reuse or distribution, you must make clear to others the license
# #    terms of this work. The best way to do this is with a link to this web
# #    page.
# #  
# #  - Any of the above conditions can be waived if you get permission from the
# #    copyright holder.
# #  
# #  - Nothing in this license impairs or restricts the author's moral rights.
# #  
# #----------------------------------------------------------------------------

#===============================================================================
# Mouse
#===============================================================================

class Mouse
  
	attr_reader :mx, :my
	
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# START Configuration
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  APPLY_BORDERS = true
  WINDOW_WIDTH = 640
  WINDOW_HEIGHT = 480
  HIDE_WINDOWS_CURSOR = true
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# END Configuration
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  
  if HIDE_WINDOWS_CURSOR
    Win32API.new('user32', 'ShowCursor', 'i', 'i').call(0)
  end
  
  SCREEN_TO_CLIENT = Win32API.new('user32', 'ScreenToClient', %w(l p), 'i')
  READ_INI = Win32API.new('kernel32', 'GetPrivateProfileStringA', %w(p p p p l p), 'l')
  FIND_WINDOW = Win32API.new('user32', 'FindWindowA', %w(p p), 'l')
  CURSOR_POSITION = Win32API.new('user32', 'GetCursorPos', 'p', 'i')
	GET_MESSAGE = Win32API.new('user32', 'GetMessage', 'plll', 'l')
	Scroll = 0x0000020A
  
	Point = Struct.new(:x, :y)
  Message = Struct.new(:message, :wparam, :lparam, :pt)
  Param = Struct.new(:x, :y, :scroll)
	
  def initialize
    @cursor = Sprite.new
    @cursor.z = 1000000
    self.set_cursor(System::Skins::OSC.get_file(:mouse))
    update
  end
  
  def update
    @cursor.x, @cursor.y = self.position
  end
  
  def x
    return @cursor.x
  end
  
  def y
    return @cursor.y
  end
  
  def position
    x, y = self.get_client_position
    if APPLY_BORDERS
      if x < 0
        x = 0
      elsif x >= WINDOW_WIDTH
        x = WINDOW_WIDTH - 1
      end
      if y < 0
        y = 0
      elsif y >= WINDOW_HEIGHT
        y = WINDOW_HEIGHT - 1
      end
    end
		x -= @mx
		y -= @my
    return x, y
  end
	
	def hiword(dword); return ((dword&0xffff0000) >> 16)&0x0000ffff; end
  def loword(dword); return dword&0x0000ffff; end
    
  def word2signed_short(value)
    return value if (value&0x8000) == 0
    return -1 * ((~value&0x7fff) + 1)
  end
  
  def unpack_dword(buffer, offset = 0)
    ret = buffer[offset + 0]&0x000000ff
    ret |= (buffer[offset + 1] << (8 * 1))&0x0000ff00
    ret |= (buffer[offset + 2] << (8 * 2))&0x00ff0000
    ret |= (buffer[offset + 3] << (8 * 3))&0xff000000
    return ret
  end
  
  def unpack_msg(buffer)
    msg = Message.new; msg.pt = Point.new
    msg.message=unpack_dword(buffer,4*1)
    msg.wparam = unpack_dword(buffer, 4 * 2)
    msg.lparam = unpack_dword(buffer,4*3)
    msg.pt.x = unpack_dword(buffer, 4 * 5)
    msg.pt.y = unpack_dword(buffer, 4 * 6)
    return msg
  end
  
  def wmcallback(msg)
    return unless msg.message == Scroll
    param = Param.new
    param.x = word2signed_short(loword(msg.lparam))
    param.y = word2signed_short(hiword(msg.lparam))
    param.scroll = word2signed_short(hiword(msg.wparam))
    return [param.x, param.y, param.scroll]
  end
	
  def scroll?
    msg = "\0" * 32
		GET_MESSAGE.call(msg, 0, 0, 0)
		r = wmcallback unpack_msg(msg)
    return r.nil? ? nil : r[2] > 0 ? true : false
  end
	
  def get_client_position
    pos = [0, 0].pack('ll')
    CURSOR_POSITION.call(pos)
    SCREEN_TO_CLIENT.call(WINDOW, pos)
    return pos.unpack('ll')
  end
  
  def set_cursor(image)
		bitmap = nil
		image = image.ensure_extend(".png", ".png", ".png")
		if FileTest.exist? "Graphics/Pictures/#{image}"
			bitmap = RPG::Cache.picture(image).clone
		else
			bitmap = Bitmap.new(image)
		end
		
		@mx, @my = bitmap.width / 2, bitmap.height / 2
    @cursor.bitmap = bitmap
  end
  
  def show
    @cursor.visible = true
  end
  
  def hide
    @cursor.visible = false
  end
  
  def self.find_window
    game_name = "\0" * 256
    READ_INI.call('Game', 'Title', '', game_name, 255, '.\\Game.ini')
    game_name.delete!("\0")
    return FIND_WINDOW.call('RGSS Player', game_name)
  end
  
  WINDOW = self.find_window
  
end

#==============================================================================
# module Input
#==============================================================================

module Input
  
  class << Input
    alias_method :update_mousecontroller_later, :update
  end
  
  def self.update
    $mouse.update unless $mouse.nil?
    update_mousecontroller_later
  end
  
	def self.scroll?
		$mouse.scroll?
	end
	
end

#===============================================================================
# Rect
#===============================================================================

class Rect
  
  def covers?(x, y)
    return !(x < self.x || x >= self.x + self.width ||
        y < self.y || y >= self.y + self.height)
  end
  
	def mouse_over?
		return false if $mouse.nil?
		mx = $mouse.mx
		my = $mouse.my
		pos = [x - mx, x + width - mx, y - my, y + height - my]
		return $mouse.x.between?(pos[0], pos[1]) && $mouse.y.between?(pos[2], pos[3])
	end
	
end

#===============================================================================
# Sprite
#===============================================================================

class Sprite
  
  def mouse_in_area?
    return false if self.bitmap.nil?
		return false if $mouse.nil?
		mx = $mouse.mx
		my = $mouse.my
		pos = [x - mx, x + bitmap.width - mx, y - my, y + bitmap.height - my]
		return $mouse.x.between?(pos[0], pos[1]) && $mouse.y.between?(pos[2], pos[3])
  end
	
	def mouse_over?
		mouse_in_area?
	end
  
end

#===============================================================================
# Window_Base
#===============================================================================

class Window_Base
  
  def mouse_in_area?
		return false if $mouse.nil?
		mx = $mouse.mx
		my = $mouse.my
		pos = [self.x - mx, self.x + self.width - mx, self.y - my, self.y + self.height - my]
		return $mouse.x.between?(pos[0], pos[1]) && $mouse.y.between?(pos[2], pos[3])
  end
  
  def mouse_in_inner_area?
		return false if $mouse.nil?
		mx = $mouse.mx
		my = $mouse.my
		pos = [self.x - mx + 16, self.x + self.width - mx - 16, self.y - my + 16, self.y + self.height - my - 16]
		return $mouse.x.between?(pos[0], pos[1]) && $mouse.y.between?(pos[2], pos[3])
  end
  
	def mouse_over?
		mouse_in_area?
	end
	
	def mouse_inner?
		mouse_in_inner_area?
	end
	
end