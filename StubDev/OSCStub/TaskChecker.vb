Option Compare Binary
Option Infer On
Option Explicit On
Option Strict On

Namespace OSC

    Module TaskChecker

        Private _files() As String = {"AnalizeSkins",
                                      "CopySkin",
                                      "CreateUserFolder",
                                      "GetOsuDir",
                                      "CreateInverted",
                                      "InvertCollection"}

        Public Sub SetUp()
            If Not IO.Directory.Exists("Tasks") Then IO.Directory.CreateDirectory("Tasks")

            DeleteTasks()
        End Sub

        ' Delete old tasks
        Private Sub DeleteTasks()
            For Each file As String In _files
                Dim f_name As String = "Tasks/Task_" + file
                If IO.File.Exists(f_name) Then IO.File.Delete(f_name)
            Next
        End Sub

        ' Check if a specified Task if wanted to run
        Public Sub CheckTasks()
            Dim begin As String = "Tasks/Task_"

            For i As Integer = 0 To _files.Count - 1
                Dim f_name As String = begin + _files(i)
                If IO.File.Exists(f_name) Then RunTask(i, f_name)
                IO.File.Delete(f_name)
            Next
        End Sub

        Private Sub RunTask(ByVal id As Integer, ByVal f_name As String)
            Select Case id
                Case 0
                    ' Analize Skin
                    TaskExecuter.AnalizeSkins()
                Case 1
                    ' Copy Skin Data
                    Dim stream As New IO.StreamReader(f_name)
                    Dim userFolder As String = String.Empty

                    If Not stream.EndOfStream Then userFolder = stream.ReadLine
                    
                    stream.Close()
                    If Not userFolder.Equals(String.Empty) Then TaskExecuter.CopySkinFiles(userFolder)
                Case 2
                    ' Create User Folder
                    Dim stream As New IO.StreamReader(f_name)
                    Dim userName As String = String.Empty

                    If Not stream.EndOfStream Then userName = stream.ReadLine

                    stream.Close()
                    If Not userName.Equals(String.Empty) Then TaskExecuter.CreateUserFolder(userName)
                Case 3
                    ' Get Osu Dir
                    TaskExecuter.GetOsuDir()
                Case 4
                    ' Invert named files
                    Dim stream As New IO.StreamReader(f_name)
                    Dim files As IEnumerable(Of String) = Nothing

                    If Not stream.EndOfStream Then files = stream.ReadToEnd.Split(CChar(vbNewLine))

                    stream.Close()
                    If Not files Is Nothing Then TaskExecuter.InvertFiles(files)
                Case 5
                    ' Invert files from a skd file
                    Dim stream As New IO.StreamReader(f_name)
                    Dim col As String = String.Empty

                    If Not stream.EndOfStream Then col = stream.ReadLine

                    stream.Close()
                    If Not col.Equals(String.Empty) Then TaskExecuter.InvertCollection(col)
            End Select
        End Sub

    End Module

End Namespace