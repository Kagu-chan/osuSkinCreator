def run_application
	System::Globs.run_application if Interfacing::NotesHandler.stub_running?
end