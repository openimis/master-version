Imports System.Threading

Public Class ImisFeedbackPrompt

    Private Timer As System.Threading.Timer

    Protected Overrides Sub OnStart(ByVal args() As String)

        ' Add code here to start your service. This method should set things
        ' in motion so your service can do its work.
        Try

            EventLog1.WriteEntry("Service Started at " & Now)

            Dim oCallBack As New TimerCallback(AddressOf RunRenewals)

            Dim SecondsToNextRenewal As Integer

            Dim NextRenewalTime As String = My.Settings.RenewalTime
            Dim Interval As Integer = My.Settings.RenewalInterval * 60 * 60 * 1000

            If Date.ParseExact(NextRenewalTime, "HH:mm", Nothing) > Now Then
                SecondsToNextRenewal = DateDiff(DateInterval.Second, Now, Date.ParseExact(NextRenewalTime, "HH:mm", Nothing))
            Else
                SecondsToNextRenewal = DateDiff(DateInterval.Second, Now, DateAdd(DateInterval.Day, 1, Date.ParseExact(NextRenewalTime, "HH:mm", Nothing)))
            End If

            Timer = New System.Threading.Timer(oCallBack, Nothing, 1000 * SecondsToNextRenewal + 1000, Interval)

        Catch ex As Exception
            EventLog1.WriteEntry("Erro On Start: " & ex.Message, System.Diagnostics.EventLogEntryType.Error)
        End Try

    End Sub

    Protected Overrides Sub OnStop()
        ' Add code here to perform any tear-down necessary to stop your service.
        EventLog1.WriteEntry("Service stopped at " & Now)

    End Sub

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

        If Not System.Diagnostics.EventLog.SourceExists("ImisFeedbackPromptSource") Then
            System.Diagnostics.EventLog.CreateEventSource("ImisFeedbackPromptSource", "ImisFeedbackPromptLog")
        End If

        EventLog1.Source = "ImisFeedbackPromptSource"
        EventLog1.Log = "ImisFeedbackPromptLog"

    End Sub


    Private Sub RunRenewals()
        SendSMS()
    End Sub

  

    Private Sub SendSMS()

        EventLog1.WriteEntry("Sending SMS Started @ " & Now)


        Try
            Dim ConStr As String = "Data Source = " & My.Settings.DataSource & ";Initial Catalog = " & My.Settings.DatabaseName & ";User ID = " & My.Settings.UserName & "; PWD =" & My.Settings.Password & ""
            Dim Con As New SqlClient.SqlConnection(ConStr)
            Dim dt As New DataTable

            If Con.State = ConnectionState.Closed Then Con.Open()
            Dim sSQL As String = "uspFeedbackPromptSMS"
            Dim cmd As New SqlClient.SqlCommand(sSQL, Con)
            Dim da As New SqlClient.SqlDataAdapter(cmd)

            da.Fill(dt)

            Dim TotalSMSTobeSent As Integer = dt.Rows.Count
            Dim SMSSent As Integer = 0

            For Each row In dt.Rows
                'send sms here
                SMSSent += 1
            Next

            Con.Close()
            cmd = Nothing
            Con = Nothing

            EventLog1.WriteEntry("Sending SMS Finished @ " & Now & " (" & SMSSent & " out of " & TotalSMSTobeSent & " SMS have been sent successfully.)")


        Catch ex As Exception
            EventLog1.WriteEntry("Error On sending SMS: " & ex.Message, System.Diagnostics.EventLogEntryType.Error)
        End Try
       
    End Sub

End Class
