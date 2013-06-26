=begin
System::Globs::Initialization.ensure_user_dir
System::Globs::Initialization.set_variables

$notes_graph.dispose

$kill = false
x = SkinPreview.new(0, 0, "New Skin")

y = SkinPreview.new(200, 0, "Load Skin", "C:\\Programme\\osu!\\Skins\\Kagus Satisfaction\\")
z = SkinPreview.new(400, 0, "Last Skin", "C:\\Programme\\osu!\\Skins\\KuroxKaga Love\\")

while !$kill
	Graphics.update
	Input._update
	x.update
	y.update
	z.update
	$kill = Input.trigger? Input::C
end
x.dispose
y.dispose
z.dispose
=end