Option Compare Binary
Option Explicit On
Option Infer On
Option Strict On

Imports System.ComponentModel

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
                .Items.Add("Read Skin Library")
                AddHandler .Items(0).Click, Sub() TaskExecuter.AnalizeSkins()

                .Items.Add("Exit")
                AddHandler .Items(1).Click, Sub() If Not _process.HasExited Then _process.CloseMainWindow()

            End With

            Properties.Notifier.ContextMenuStrip = context
        End Sub

    End Class

End Namespace