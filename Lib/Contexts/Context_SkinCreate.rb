class Context_SkinCreate < Context_Base

	def setup
		@sub_context = SCreate::Properties.new
		@context = nil
	end
	
	def unload
		@context.unload unless @context.nil?
	end
	
	def update
		unless @sub_context == @context
			@context.unload unless @context.nil?
			@context = @sub_context
			@context.setup
		end
		
		@context.update
		
		new_context = @context.new_context
		@sub_context = new_context unless new_context.nil?
	end
	
end