Option Compare Binary
Option Explicit On
Option Infer On
Option Strict On

Imports System.ComponentModel
Imports System.Runtime.CompilerServices

Namespace OSC

    Public Class AppContext
        Inherits ApplicationContext

        Private _runningApp As String = "Game.exe"
        Private _process As Process = Nothing

        Private _HWND As IntPtr

        Private _livingChecker As New BackgroundWorker
        Private _taskChecker As New BackgroundWorker

        Private _osuPath As String

        Private Declare Function FindWindow Lib "user32.dll" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As IntPtr
        Private Declare Function SetForegroundWindow Lib "user32.dll" (ByVal hwnd As IntPtr) As Int32


        Public Sub New()
            NotesHandler.SetUp()
            NotesHandler.CreateNote(4)

            TaskChecker.SetUp()

            Properties.Notifier = New NotifyIcon()
            Properties.Notifier.Icon = New Icon("osusk.ico")

            AddHandler Properties.Notifier.MouseClick, AddressOf OnIconMouseClick
            AddHandler Application.ApplicationExit, AddressOf OnApplicationExit

            Properties.Notifier.Visible = True

            CreateHandleMenu()
            RunApplication()

            Properties.Notifier.Text = "Osu Skin Creator - Helper"

            AddHandler _livingChecker.DoWork, Sub()
                                                  While Not _process.HasExited
                                                      ' NOP
                                                  End While
                                                  Properties.Notifier.Visible = False
                                                  ExitThread()
                                              End Sub
            _livingChecker.RunWorkerAsync()

            AddHandler _taskChecker.DoWork, Sub()
                                                While True
                                                    While Not _process.HasExited
                                                        TaskChecker.CheckTasks()
                                                    End While
                                                End While
                                            End Sub
            _taskChecker.RunWorkerAsync()
            TaskExecuter.AnalizeSkins()
        End Sub

        Private Sub RunApplication()
            _process = Process.Start(_runningApp)
        End Sub

        Private Sub OnApplicationExit(ByVal sender As Object, ByVal e As EventArgs)
            If Properties.Notifier IsNot Nothing Then
                Properties.Notifier.Dispose()
            End If
        End Sub

        Private Sub OnIconMouseClick(ByVal sender As Object, ByVal e As MouseEventArgs)
            If e.Button = MouseButtons.Left Then
                _HWND = FindWindow(vbNullString, _process.MainWindowTitle)
                SetForegroundWindow(_HWND)
            End If
            If e.Button = MouseButtons.Right Then
                Properties.Notifier.ContextMenuStrip.Show()
            End If
        End Sub

        Private Sub CreateHandleMenu()
            Dim context As New ContextMenuStrip
            With context
                .Items.Add("Start Osu")
                AddHandler .Items.GetLast.Click, Sub()
                                                     Dim osuPath As String = CStr(My.Computer.Registry.GetValue(
                                                        "HKEY_CLASSES_ROOT\Applications\osu!.exe\shell\open\command", "", Nothing))
                                                     osuPath = osuPath.Substring(1)
                                                     osuPath = osuPath.Substring(0, osuPath.IndexOf(""""))
                                                     Process.Start(osuPath)
                                                 End Sub

                .Items.Add("Read Skin Library")
                AddHandler .Items.GetLast.Click, Sub() TaskExecuter.AnalizeSkins()

                .Items.Add("Exit")
                AddHandler .Items.GetLast.Click, Sub() If Not _process.HasExited Then _process.CloseMainWindow()

            End With

            Properties.Notifier.ContextMenuStrip = context
        End Sub

    End Class

    Public Module Extensions

        <Extension()>
        Public Function GetLast(ByVal self As ToolStripItemCollection) As ToolStripItem
            If self.Count = 0 Then Return Nothing
            Return self(self.Count - 1)
        End Function

    End Module

End Namespace