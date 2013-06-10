Option Compare Binary
Option Infer On
Option Explicit On
Option Strict On

Namespace OSC

    Module TaskChecker

        Private _files() As String = {"AnalizeSkins",
                                      "CopySkin",
                                      "CreateUserFolder",
                                      "GetOsuDir"}

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

            ' Check if the user want to analize skins
            If IO.File.Exists(begin + _files(0)) Then
                TaskExecuter.AnalizeSkins()
                IO.File.Delete(begin + _files(0))
            End If

            ' Get install dir of osu from registry
            If IO.File.Exists(begin + _files(3)) Then
                TaskExecuter.GetOsuDir()
                IO.File.Delete(begin + _files(3))
            End If
        End Sub

    End Module

End Namespace