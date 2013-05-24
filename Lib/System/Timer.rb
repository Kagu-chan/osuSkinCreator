class Timer
  def initialize
    @running = false
    reset
  end
  
  def start
    @running = true
    @estimated = @last
  end
  
  def stop
    @running = false
    @last = @estimated
  end
  
  def reset
    @estimated = Graphics.frame_count
    @last = @estimated
  end
  
  def update_time
    return unless @running
    total_sec = (Graphics.frame_count - @estimated) / Graphics.frame_rate
    hour = total_sec / 60 / 60
    min = total_sec / 60 % 60
    sec = total_sec % 60
    $time_screen_string = sprintf("%02d:%02d:%02d", hour, min, sec)
  end
  
end