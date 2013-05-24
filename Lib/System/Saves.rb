module Save
  
  def self.save_settings
    file = File.open($user_name + "/usersettings.ini", "w+")
    
    file.puts $settings[:osu_dir]
    file.puts $settings[:update_at_startup] ? "1" : "0"
    
    file.close
  end
  
end