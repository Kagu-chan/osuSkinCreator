Option Compare Binary
Option Explicit On
Option Infer On
Option Strict On

Imports System.ComponentModel

Namespace OSC

    Public Class SkinReader

        Private Shared Property Files As New List(Of String)
        Private Shared Property BGW As New BackgroundWorker With {.WorkerSupportsCancellation = True}
        Private Shared Property FilesReaded As Boolean = False
        Private Shared Property StepCount As Integer = 0

        Private Shared _temp As String = String.Empty
        Private Shared _filesDirectory As String = String.Empty
        'Private Shared _userData As String = String.Empty

        Public Shared Sub Read(ByVal path As String, ByVal filesFolder As String)
            If NotesHandler.ExistNote(0) Then Return

            _filesDirectory = filesFolder
            If Not IO.Directory.Exists(_filesDirectory) Then IO.Directory.CreateDirectory(_filesDirectory)

            ReadDirectories(path)

            BGW.CancelAsync()

            Dim file As New IO.StreamWriter(_filesDirectory + "/SkinCache.skd", False)
            For Each el As String In Files
                file.WriteLine(el)
            Next
            file.Close()

            FilterStoryBoardElements()
            FilterSkinElements()

            NotesHandler.CreateNote(0)
        End Sub

        Private Shared Sub LogCurrFileCount()
            AddHandler BGW.DoWork, Sub()
                                       Dim lastFile As String = String.Empty
                                       While Not FilesReaded
                                           System.Threading.Thread.Sleep(1000)
                                           If Not String.IsNullOrEmpty(lastFile) Then
                                               If IO.File.Exists(lastFile) Then IO.File.Delete(lastFile)
                                           End If
                                           lastFile = _temp + "/" + Files.Count.ToString + ".skd"
                                           If lastFile.Equals(_temp + "/0.skd") Then Continue While
                                           Dim file As New IO.StreamWriter(lastFile, False)
                                           file.Close()
                                       End While
                                       IO.File.Delete(lastFile)
                                   End Sub
            BGW.RunWorkerAsync()
        End Sub

        Private Shared Sub LogEndFileCount()
            Dim file As New IO.StreamWriter(_temp + "/Ges_" + Files.Count.ToString + ".skd", False)
            file.Close()
        End Sub

        Private Shared Sub COut(ByVal element As String)
            Console.WriteLine(element)
        End Sub

        Private Shared Function ReadDirectories(ByVal baseDir As String) As Boolean
            If Not (baseDir.EndsWith("/") OrElse baseDir.EndsWith("\")) Then baseDir += "/"
            If Not IO.Directory.Exists(baseDir) Then
                COut("Basedir doesnt exist")
                Return False
            End If
            ReadSongSkinFiles(baseDir)
            ReadSkinDirFiles(baseDir)

            FilesReaded = True
            Return True
        End Function

        Private Shared Sub ReadSongSkinFiles(ByVal baseDir As String)
            baseDir += "Songs/"

            CreateFileList(baseDir, Files)
        End Sub

        Private Shared Sub ReadSkinDirFiles(ByVal baseDir As String)
            baseDir += "Skins/"

            CreateFileList(baseDir, Files)
        End Sub

        Private Shared Sub CreateFileList(ByVal startDirectory As String, ByRef fList As List(Of String))
            Dim currentFName As String
            Dim foundedFile As String
            Dim foundedFolder As String
            Dim directories() As String = {}
            Dim directoryNumber As Integer
            Dim i As Integer

            'Eventuell Backslash anhängen
            If Not (startDirectory.EndsWith("\") OrElse startDirectory.EndsWith("/")) Then startDirectory += "/"

            'Alle Dateien des Verzeichnisses auflisten
            currentFName = Dir(startDirectory & "*.*")

            While Len(currentFName) > 0
                foundedFile = startDirectory & currentFName 'Filename enthält dann die aktuelle Datei

                currentFName = Dir()
                ' Nur Grafiken laden
                If Not (foundedFile.EndsWith(".png") OrElse foundedFile.EndsWith(".jpg")) Then Continue While
                fList.Add(foundedFile)
            End While

            'Alle Unterverzeichnisse in Array einlesen
            directoryNumber = 0
            currentFName = Dir(startDirectory, vbDirectory)
            While Len(currentFName) > 0
                If currentFName <> "." AndAlso currentFName <> ".." Then
                    directoryNumber = directoryNumber + 1
                    ReDim Preserve directories(directoryNumber)
                    directories(directoryNumber - 1) = currentFName
                End If
                currentFName = Dir()
            End While

            For i = 0 To directoryNumber - 1
                foundedFolder = startDirectory & directories(i)
                CreateFileList(foundedFolder, fList)
            Next
        End Sub

        Private Shared Sub FilterStoryBoardElements()
            Dim elements = From element As String In Files Where element.Contains("/SB/")

            Dim otherElements = From element As String In Files Where Not element.Contains("/SB/")

            Files = New List(Of String)(otherElements)

            Dim sbList As New IO.StreamWriter(_filesDirectory + "/SB.skd", False)
            For Each element As String In elements
                sbList.WriteLine(element)
            Next
            sbList.Close()
        End Sub

        Private Shared Sub FilterSkinElements()
            Dim skinFiles As New List(Of String)
            CreateFileList("Graphics/SkinFiles", skinFiles)

            For Each skinFile As String In skinFiles
                skinFile = skinFile.Substring(0, skinFile.Length - 3)

                skinFile = skinFile.Split("/"c)(2)

                FilterElements(skinFile)
            Next

            Dim fList As New IO.StreamWriter(_filesDirectory + "/others.skd", False)
            For Each element As String In Files
                fList.WriteLine(element)
            Next
            fList.Close()
        End Sub

        Private Shared Sub FilterElements(ByVal el As String)
            Dim elements = From element As String In Files Where element.Contains(el)

            Dim otherElements = From element As String In Files Where Not element.Contains(el)

            Files = New List(Of String)(otherElements)

            Dim fList As New IO.StreamWriter(_filesDirectory + "/" + el + "skd", False)
            For Each element As String In elements
                fList.WriteLine(element)
            Next
            fList.Close()
        End Sub

    End Class

End Namespace