Imports System.Threading

Public Class ImisBackup

    Private Timer As System.Threading.Timer

    Shared Sub Main()
        Dim ServiceToRun() As System.ServiceProcess.ServiceBase
        ServiceToRun = New System.ServiceProcess.ServiceBase() {New ImisBackup()}
        System.ServiceProcess.ServiceBase.Run(ServiceToRun)
    End Sub

    Protected Overrides Sub OnStart(ByVal args() As String)
        Try
            EventLog1.WriteEntry("Service Started at " & Now)

            Dim oCallBack As New TimerCallback(AddressOf TakeBackup)

            Dim SecondsToNextBackup As Integer

            Dim NextBackupTime As String = My.Settings.BackupTime
            Dim Interval As Integer = My.Settings.BackupInterval * 60 * 60 * 1000

            If Date.ParseExact(NextBackupTime, "HH:mm", Nothing) > Now Then
                SecondsToNextBackup = DateDiff(DateInterval.Second, Now, Date.ParseExact(NextBackupTime, "HH:mm", Nothing))
            Else
                SecondsToNextBackup = DateDiff(DateInterval.Second, Now, DateAdd(DateInterval.Day, 1, Date.ParseExact(NextBackupTime, "HH:mm", Nothing)))
            End If

            'EventLog1.WriteEntry("Next backup will be taken after " & SecondsToNextBackup & " seconds. And Interval is " & Interval & " ms.")
            'SecondsToNextBackup = DateDiff(DateInterval.Second, Now, DateAdd(DateInterval.Second, 1, DateAdd(DateInterval.Day, 1, Date.Now.Date)))

            Timer = New System.Threading.Timer(oCallBack, Nothing, 1000 * SecondsToNextBackup + 1000, Interval)

        Catch ex As Exception
            EventLog1.WriteEntry("Errot on Start: " & ex.Message, System.Diagnostics.EventLogEntryType.Error)
        End Try

    End Sub

    Protected Overrides Sub OnStop()
        EventLog1.WriteEntry("Service stopped at " & Now)
    End Sub

    Public Sub New()
        MyBase.New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

        If Not System.Diagnostics.EventLog.SourceExists("ImisBackupSource") Then
            System.Diagnostics.EventLog.CreateEventSource("ImisBackupSource", "ImisBackupLog")
        End If

        EventLog1.Source = "ImisBackupSource"
        EventLog1.Log = "ImisBackupLog"
    End Sub

    Private Sub TakeBackup()
        Try

            EventLog1.WriteEntry("Backup Started @ " & Now)

            Dim ConStr As String = "Data Source = " & My.Settings.DataSource & ";Initial Catalog = " & My.Settings.DatabaseName & ";User ID = " & My.Settings.UserName & "; PWD =" & My.Settings.Password & ""
            Dim Con As New SqlClient.SqlConnection(ConStr)
            If Con.State = ConnectionState.Closed Then Con.Open()
            Dim sSQL As String = "uspBackupDatabase"
            Dim cmd As New SqlClient.SqlCommand(sSQL, Con)
            cmd.CommandTimeout = 0
            cmd.ExecuteNonQuery()

        Catch ex As Exception
            EventLog1.WriteEntry("Error On TakeBackup: " & ex.Message, System.Diagnostics.EventLogEntryType.Error)
        End Try

    End Sub
End Class
