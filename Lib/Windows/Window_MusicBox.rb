class Window_MusicBox < Window_Base
  
  def initialize
    super 192, 480 - 108, 640 - 192, 108
    
    @tool_buttons = [Sprite.new, Sprite.new, Sprite.new]
    @tool_buttons.each_index { |i|
      @tool_buttons[i].z = 500
      @tool_buttons[i].x = 640 - 37
      @tool_buttons[i].y = 480 - 108 + 7 + 2 * i + 30 * i
    }
    @tool_buttons[2].bitmap = RPG::Cache.picture "stop"
    
    @play = false
    @repeat = false
    
    refresh
  end
  
  def refresh
    fName = @play ? "pause" : "play"
    @tool_buttons[0].bitmap = RPG::Cache.picture fName
    
    fName = @repeat ? "repeat" : "repeat_none"
    @tool_buttons[1].bitmap = RPG::Cache.picture fName
  end
  
end