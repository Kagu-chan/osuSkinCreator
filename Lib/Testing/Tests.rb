=begin
System::Globs::Initialization.ensure_user_dir
System::Globs::Initialization.set_variables
System::Loads.load_infotexts

$notes_graph.dispose

$kill = false

a = Sprite.new
a.setup
a.bitmap = Bitmap.new(640, 480)
a.bitmap.fill_rect(a.bitmap.rect, Color.new(255, 255, 255))

x = Sprite.new
x.bitmap = Bitmap.new(50, 50)
x.bitmap.fill_rect(x.bitmap.rect, Color.new(0, 0, 0))
#i0 i2
x.add_info_text($infos["i0"], $infos["i1"])

System::Threads.run_infobox_handle

while !$kill
	Graphics.update
	Input._update
	#if Input.trigger? Input::B
	#	p x.box
	#end
	$kill = Input.trigger?(Input::C) || Input.mouse?
end
Kernel.exit
=end