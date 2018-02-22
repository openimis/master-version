Imports System.ServiceProcess

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ImisBackup
    Inherits System.ServiceProcess.ServiceBase

    'UserService overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    ' The main entry point for the process
   

    'Required by the Component Designer
    Private components As System.ComponentModel.IContainer

    ' NOTE: The following procedure is required by the Component Designer
    ' It can be modified using the Component Designer.  
    ' Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.EventLog1 = New System.Diagnostics.EventLog
        CType(Me.EventLog1, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'ImisBackup
        '
        Me.ServiceName = "ImisBackup"
        CType(Me.EventLog1, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents EventLog1 As System.Diagnostics.EventLog

End Class
