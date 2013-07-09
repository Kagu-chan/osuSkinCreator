=begin
begin
	System::Globs::Initialization.ensure_user_dir
	System::Globs::Initialization.set_variables

	$notes_graph.dispose
	$osu_dir = "D:\\Programme\\osu!"
	$kill = false
	x = SkinContainer.new(640 - 32, 305)


	while !$kill
		Graphics.update
		Input._update
		x.update
		$kill = Input.trigger? Input::C
	end
	x.dispose
rescue
	print ([$!.to_s, ''] + $@).join("\n")
	Kernel.exit
end
Kernel.exit
=end