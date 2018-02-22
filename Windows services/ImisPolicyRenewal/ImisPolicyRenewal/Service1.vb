Imports System.Threading
Imports System.Net
Imports System.Text
Imports System.IO
Imports System.Xml

Public Class ImisPolicyRenewal

    Private Timer As System.Threading.Timer
    Private bSendSMS As Boolean
    Private bSendSMSFamily As Boolean

    Protected Overrides Sub OnStart(ByVal args() As String)

        ' Add code here to start your service. This method should set things
        ' in motion so your service can do its work.
        Try

            EventLog1.WriteEntry("Service Started at " & Now)

            Dim oCallBack As New TimerCallback(AddressOf RunRenewals)

            Dim SecondsToNextRenewal As Integer

            Dim NextRenewalTime As String = My.Settings.RenewalTime
            Dim Interval As Integer = My.Settings.RenewalInterval * 60 * 60 * 1000

            bSendSMS = My.Settings.SendSMSOfficer
            bSendSMSFamily = My.Settings.SendSMSFamily

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

        If Not System.Diagnostics.EventLog.SourceExists("ImisPolicyRenewalSource") Then
            System.Diagnostics.EventLog.CreateEventSource("ImisPolicyRenewalSource", "ImisPolicyRenewalLog")
        End If

        EventLog1.Source = "ImisPolicyRenewalSource"
        EventLog1.Log = "ImisPolicyRenewalLog"

    End Sub


    Private Sub RunRenewals()
        InsertRenewals()
        UpdateRenewals()
        SendSMS()
    End Sub

    Private Sub InsertRenewals()
        EventLog1.WriteEntry("Insert Started @ " & Now)

        Try
            Dim ConStr As String = "Data Source = " & My.Settings.DataSource & ";Initial Catalog = " & My.Settings.DatabaseName & ";User ID = " & My.Settings.UserName & "; PWD =" & My.Settings.Password & ""
            Dim Con As New SqlClient.SqlConnection(ConStr)
            If Con.State = ConnectionState.Closed Then Con.Open()
            Dim sSQL As String = "uspPolicyRenewalInserts"
            Dim cmd As New SqlClient.SqlCommand(sSQL, Con)
            cmd.ExecuteNonQuery()

            Con.Close()
            cmd = Nothing
            Con = Nothing

        Catch ex As Exception
            EventLog1.WriteEntry("Error On Insert:" & ex.Message, System.Diagnostics.EventLogEntryType.Error)
        End Try

    End Sub

    Private Sub UpdateRenewals()
        EventLog1.WriteEntry("Update Started @ " & Now)

        Try

            Dim ConStr As String = "Data Source = " & My.Settings.DataSource & ";Initial Catalog = " & My.Settings.DatabaseName & ";User ID = " & My.Settings.UserName & "; PWD =" & My.Settings.Password & ""
            Dim Con As New SqlClient.SqlConnection(ConStr)
            If Con.State = ConnectionState.Closed Then Con.Open()
            Dim sSQL As String = "uspPolicyStatusUpdate"
            Dim cmd As New SqlClient.SqlCommand(sSQL, Con)
            cmd.ExecuteNonQuery()

            Con.Close()
            cmd = Nothing
            Con = Nothing


        Catch ex As Exception
            EventLog1.WriteEntry("Error On Update: " & ex.Message, System.Diagnostics.EventLogEntryType.Error)
        End Try

    End Sub

    Private Sub SendSMS()
        If bSendSMS Then
            EventLog1.WriteEntry("Sending SMS Started @ " & Now)


            Try
                Dim ConStr As String = "Data Source = " & My.Settings.DataSource & ";Initial Catalog = " & My.Settings.DatabaseName & ";User ID = " & My.Settings.UserName & "; PWD =" & My.Settings.Password & ""
                Dim Con As New SqlClient.SqlConnection(ConStr)
                Dim dt As New DataTable
                Dim FamilySMS As String = ""
                Try
                    If My.Computer.FileSystem.FileExists(My.Settings.FamilySMSTemplatePath.ToString) Then
                        FamilySMS = My.Computer.FileSystem.ReadAllText(My.Settings.FamilySMSTemplatePath.ToString)
                    End If
                Catch ex As Exception
                    FamilySMS = ""
                End Try


                If Con.State = ConnectionState.Closed Then Con.Open()
                Dim sSQL As String = "uspPolicyRenewalSMS"
                Dim cmd As New SqlClient.SqlCommand(sSQL, Con)
                cmd.Parameters.Add(New SqlClient.SqlParameter("@FamilyMessage", FamilySMS))
                Dim da As New SqlClient.SqlDataAdapter(cmd)

                da.Fill(dt)

                Con.Close()
                cmd = Nothing
                Con = Nothing

                If dt.Rows.Count > 0 Then

                    Dim xml As String = dt.Rows(0)(0).ToString

                    Dim Response As String = ""

                    Dim Req As HttpWebRequest = Nothing
                    Dim res As HttpWebResponse

                    Dim URL As String = My.Settings.SMSGatewayURL
                    Dim UserName As String = My.Settings.SMSGatewayUser
                    Dim UserPassword As String = My.Settings.SMSGatewayPassword

                    Dim Byt As Byte() = Encoding.UTF8.GetBytes(String.Format("{0}:{1}", UserName, UserPassword))
                    Dim xmlBytes As Byte() = Encoding.UTF8.GetBytes(xml.ToString)

                    Dim base64 As String = Convert.ToBase64String(Byt)
                    Req = HttpWebRequest.Create(URL)
                    With Req
                        .ContentType = "application/xml"
                        .Headers.Add(HttpRequestHeader.Authorization, "Basic " & base64)
                        .Method = "POST"
                        .ContentLength = xmlBytes.Length
                    End With

                    Dim DataStream As Stream = Req.GetRequestStream
                    DataStream.Write(xmlBytes, 0, xmlBytes.Length)
                    DataStream.Close()

                    res = Req.GetResponse
                    Response = String.Format("{0} {1}", res.StatusCode, res.StatusDescription)

                    DataStream = res.GetResponseStream
                    Dim Reader As New StreamReader(DataStream)
                    Dim ResponseFromServer As String = Reader.ReadToEnd

                    Dim BulkSMSId As String = ""

                    Using r As XmlReader = XmlReader.Create(New StringReader(ResponseFromServer))
                        r.ReadToFollowing("bulk_id")
                        BulkSMSId = r.ReadElementContentAsString()
                    End Using

                    Response += " Bulk Id : " & BulkSMSId

                    Reader.Close()
                    DataStream.Close()
                    res.Close()

                    EventLog1.WriteEntry("Sending SMS Finished @ " & Now & "(Response : " & Response & ")")

                End If

            Catch ex As Exception
                EventLog1.WriteEntry("Error On sending SMS: " & ex.Message, System.Diagnostics.EventLogEntryType.Error)
            End Try
        Else
            EventLog1.WriteEntry("Sending SMS Started @ " & Now() & ". But Send SMS Setting is disabled.")

        End If
    End Sub

End Class
