class String

  def start_with?(str)
    !self.match(/^#{Regexp.escape(str)}/).nil?
  end

  def end_with?(str)
    !self.match(/#{Regexp.escape(str)}$/).nil?
  end
	
	def ensure_extend(str1, str2, extension)
		end_with = end_with?(str1) or end_with?(str2)
		addition = end_with ? "" : extension
		return self + addition
	end
end

class Thread
  
  def call_method(command)
    eval command
  end
  
end

class File

	def File.copy(from, to)
		fr_stream = File.open(from, "rb")
		to_stream = File.open(to, "wb")
		
		to_stream.puts fr_stream.read
		
		fr_stream.close
		to_stream.close
	end
	
end