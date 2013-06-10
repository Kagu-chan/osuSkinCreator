Option Compare Binary
Option Explicit On
Option Infer On
Option Strict On

Namespace OSC

    Module Programm

        Private _notifier As NotifyIcon

        Public Sub Main()
            RunApplication()
        End Sub

        Private Sub RunApplication()
            Dim ctx As New AppContext()
            Application.Run(ctx)
        End Sub

    End Module

End Namespace