Option Compare Binary
Option Explicit On
Option Infer On
Option Strict On

Namespace OSC

    Module NotesHandler

        Private _files() As String = {"SkinAvailable",
                                      "OsuDir",
                                      "CreatedUserFolder",
                                      "CopiedSkinData",
                                      "StubRunning",
                                      "Inverted",
                                      "InvertedCollection"}

        Public Sub SetUp()
            If Not IO.Directory.Exists("Messages") Then IO.Directory.CreateDirectory("Messages")

            DeleteNotes()
        End Sub

        ' Delete old notifications
        Private Sub DeleteNotes()
            For Each file As String In _files
                Dim f_name As String = "Messages/Note_" + file
                If IO.File.Exists(f_name) Then IO.File.Delete(f_name)
            Next
        End Sub

        ' create notification
        Public Sub CreateNote(ByVal id As Integer)
            CreateNote(id, {})
        End Sub

        ' create notification with text input
        Public Sub CreateNote(ByVal id As Integer, ByVal args As IEnumerable(Of String))
            Dim f_name As String = "Messages/Note_" + _files(id)
            Dim f As New IO.StreamWriter(f_name, False)
            For Each arg As String In args
                f.WriteLine(arg)
            Next
            f.Close()
        End Sub

        ' check if a notification exist
        Public Function ExistNote(ByVal id As Integer) As Boolean
            Return IO.File.Exists("Messages/Note_" + _files(id))
        End Function

    End Module

End Namespace