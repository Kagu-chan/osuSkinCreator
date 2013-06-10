Option Compare Binary
Option Infer On
Option Strict On
Option Explicit On

Imports System.ComponentModel

Namespace OSC

    ' Execute Tasks in own bgw´s
    Module TaskExecuter

        Private _analizeSkins As New BackgroundWorker

        ' Analize skins from osu dir
        Public Sub AnalizeSkins()
            If _analizeSkins.IsBusy Then Return

            Dim osuPath As String = CStr(My.Computer.Registry.GetValue(
                    "HKEY_CLASSES_ROOT\Applications\osu!.exe\shell\open\command", "", Nothing))
            osuPath = osuPath.Substring(1, osuPath.IndexOf("osu!.exe") - 1)

            AddHandler _analizeSkins.DoWork, Sub()
                                                 Properties.Notifier.ContextMenuStrip.Items(0).Enabled = False
                                                 Properties.Notifier.Text = "Analizing skins!"

                                                 SkinReader.Read(osuPath, "osuSkins")

                                                 Properties.Notifier.Text = "Osu Skin Creator - Helper"
                                                 Properties.Notifier.ContextMenuStrip.Items(0).Enabled = True
                                             End Sub
            _analizeSkins.RunWorkerAsync()
        End Sub

        Public Sub GetOsuDir()
            Dim osuPath As String = CStr(My.Computer.Registry.GetValue(
                    "HKEY_CLASSES_ROOT\Applications\osu!.exe\shell\open\command", "", Nothing))
            osuPath = osuPath.Substring(1, osuPath.IndexOf("osu!.exe") - 1)

            NotesHandler.CreateNote(1, {osuPath})
        End Sub

    End Module

End Namespace