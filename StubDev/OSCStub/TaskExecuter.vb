Option Compare Binary
Option Infer On
Option Strict On
Option Explicit On

Imports System.ComponentModel
Imports System.Collections.ObjectModel

Namespace OSC

    ' Execute Tasks in own bgw´s
    Module TaskExecuter

        Private _analizeSkins As New BackgroundWorker
        Private _copySkinFiles As New BackgroundWorker
        Private _invertFiles As New BackgroundWorker
        Private _invertCollection As New BackgroundWorker

        ' Analize skins from osu dir
        Public Sub AnalizeSkins()
            If _analizeSkins.IsBusy Then Return

            Dim osuPath As String = CStr(My.Computer.Registry.GetValue(Properties.OsuRegKey, "", Nothing))
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

        ' Returns the OsuDirectory
        Public Sub GetOsuDir()
            Dim osuPath As String = CStr(My.Computer.Registry.GetValue(Properties.OsuRegKey, "", Nothing))
            osuPath = osuPath.Substring(1, osuPath.IndexOf("osu!.exe") - 1)

            NotesHandler.CreateNote(1, {osuPath})
        End Sub

        ' Copy SkinFiles into the given user folder
        Public Sub CopySkinFiles(ByVal userFolder As String)
            If _copySkinFiles.IsBusy Then Return

            AddHandler _copySkinFiles.DoWork, Sub()
                                                  Dim files As New ReadOnlyCollection(Of String)(FileIO.FileSystem.GetFiles("osuSkins/"))
                                                  Dim toPath As String = String.Empty

                                                  For Each file As String In files
                                                      Dim ctf() As String = file.Split("\"c)
                                                      If Not IO.Directory.Exists(String.Format("{0}/SkinData", userFolder)) Then IO.Directory.CreateDirectory(String.Format("{0}/SkinData", userFolder))
                                                      toPath = String.Format("{0}/{1}", userFolder,
                                                                             If(file.EndsWith("SkinCache.skd"), ctf.Last,
                                                                                String.Format("SkinData/{1}", userFolder, ctf.Last)))
                                                      IO.File.Copy(file, toPath, True)
                                                  Next
                                                  NotesHandler.CreateNote(3)
                                              End Sub
            _copySkinFiles.RunWorkerAsync()
        End Sub

        ' Create as new user folder and generate the files
        Public Sub CreateUserFolder(ByVal userName As String)

            NotesHandler.CreateNote(2)
        End Sub

        ' Invert a list of files (reading the bitmaps)
        Public Sub InvertFiles(ByVal files As IEnumerable(Of String))
            If _invertFiles.IsBusy Then Return

            AddHandler _invertFiles.DoWork, Sub()
                                                Dim codes As New List(Of String)
                                                InvertList(files, codes, True)

                                                NotesHandler.CreateNote(5, codes)
                                            End Sub
            _invertFiles.RunWorkerAsync()
        End Sub

        Public Sub InvertCollection(ByVal collectionName As String)
            If _invertCollection.IsBusy Then Return

            AddHandler _invertCollection.DoWork, Sub()
                                                     Dim collection As String = "osuSkins/" & collectionName & ".skd"

                                                     If Not IO.File.Exists(collection) Then Return
                                                     Dim stream As New IO.StreamReader(collection)
                                                     Dim files As IEnumerable(Of String) = Nothing

                                                     If Not stream.EndOfStream Then files = stream.ReadToEnd.Split(CChar(vbNewLine))

                                                     stream.Close()
                                                     Dim codes As New List(Of String)
                                                     InvertList(files, codes, True)

                                                     NotesHandler.CreateNote(6, codes)
                                                 End Sub
            _invertCollection.RunWorkerAsync()
        End Sub

        Private Sub InvertList(ByVal files As IEnumerable(Of String), ByRef list As List(Of String), Optional ByVal reset As Boolean = False)
            If reset Then list.Clear()

            Dim cVal As String = String.Empty

            For Each file As String In files
                file = file.Trim(CChar(vbLf))
                If Not IO.File.Exists(file) Then Continue For
                Dim bmp As Bitmap = New Bitmap(file)
                Dim r As Integer = 0
                Dim g As Integer = 0
                Dim b As Integer = 0
                Dim c As Integer = 0
                Dim w As Integer = bmp.Width - 1
                Dim h As Integer = bmp.Height - 1
                Dim cl As Color = Nothing
                For x As Integer = 0 To w
                    For y As Integer = 0 To h
                        cl = bmp.GetPixel(x, y)
                        r += cl.R
                        g += cl.G
                        b += cl.B
                        c += 1
                    Next
                    If Not w = 0 Then w -= 1
                Next
                r = 255 - CInt(r / c)
                g = 255 - CInt(g / c)
                b = 255 - CInt(b / c)
                If r = 111 And g = 111 And b = 111 Then
                    r = 255
                    g = 255
                    b = 255
                End If
                list.Add(String.Format("{0}:{1}:{2}", r, g, b))
            Next
        End Sub

    End Module

End Namespace