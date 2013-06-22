Option Compare Binary
Option Infer On
Option Strict On
Option Explicit On

Namespace OSC

    Module Properties

        Public Notifier As NotifyIcon
        Public OsuRegKey As String = "HKEY_CLASSES_ROOT\Applications\osu!.exe\shell\open\command"

    End Module

End Namespace