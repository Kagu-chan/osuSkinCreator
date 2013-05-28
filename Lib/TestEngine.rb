$TEST_GRAPHICS = false
$window_skin = System::Skins::OSC.get_file(:w_skin)

$test_windows = []
$test_graphics = []

module Tests
  
  def self.show_window(window)
    begin
			cmd = "win = #{window}.new"
			(Proc.new() { eval(cmd) }).call
		rescue
			print "undefined window or missing parameter"
		end
  end
  
	def self.scale(x_res, y_res)
		p = $test_graphics.size == 0 ? nil : $test_graphics[$test_graphics.size-1]
    return if p.nil?
		
		p.zoom_x, p.zoom_y = x_res, y_res
	end
	
  def self.show_picture(name)
    p_base = [0, 0]
    if $test_windows.size != 0
      w = $test_windows[$test_windows.size - 1]
      p_base = [w.x, w.y]
    end
    s = Sprite.new; s.x = p_base[0]; s.y = p_base[1]; s.z = 99999
    begin
      s.bitmap = RPG::Cache.picture name
    rescue Errno::ENOENT
      print "file does not exist"
      return
    end
    
    $test_graphics << s
  end
  
  def self.change_position(x, y)
    p_base = [0, 0]
    if $test_windows.size != 0
      w = $test_windows[$test_windows.size - 1]
      p_base = [w.x, w.y]
    end
    p = $test_graphics.size == 0 ? nil : $test_graphics[$test_graphics.size-1]
    return if p.nil?
    
    p.x, p.y = p_base[0]+x, p_base[1]+y
  end
  
  def self.change_opacity(value)
    p = $test_graphics.size == 0 ? nil : $test_graphics[$test_graphics.size-1]
    return if p.nil?
    
    p.opacity = value
  end
  
  def self.kill
    $test_graphics.each { |s| s.bitmap.dispose; s.dispose }
    $test_windows.each { |w| w.dispose }
  end
  
  def self.load_script
    f_name = "test-script.txt"
    
    return nil unless FileTest.exist? f_name
    
    file = File.open(f_name, "rb")
    text = file.read
    file.close
    
    return text
  end
  
end

class Test_Scene
  
  def main
    $kill = true
    
    @script = Tests.load_script
    create_script
    setup
    
    Graphics.transition
    loop do
      break unless $scene == self
      Graphics.update
      Input._update
      break if update
    end
    Graphics.freeze
    Tests.kill
  end
  
  def setup
    run_script
  end
  
  def update
    if Input.trigger? Input::B
      $kill = false
      $scene = Test_Scene.new
    end
    (Input.mouse? || Input.trigger?(Input::C))
  end
  
  def create_script
    return nil if @script.nil?
    
    @script = "def run_script; " + @script + "; end"
    
    begin
      eval( @script )
    rescue SyntaxError
      print $!.message
    rescue Hangup
      print $!.message
    rescue
      print $!.message
    end
  end
  
  def run_script; end
  
end

if $TEST_GRAPHICS
	$scene = Test_Scene.new
	while !$kill; $scene.main; end
end