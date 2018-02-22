Imports System.Threading
Imports System.Net
Imports System.IO
Imports System.Text
Imports System.Xml

Public Class SMSOnEffective

    Private LogSource As String = "SMSOnEffectiveSource"
    Private Log As String = "SMSOnEffectiveLog"
    Private Timer As System.Threading.Timer
    Private dtInsuree As New DataTable

    Protected Overrides Sub OnStart(ByVal args() As String)

        Try
            EventLog1.WriteEntry("Service Started at " & Now)
            Dim oCallBack As New TimerCallback(AddressOf SendSMS)

            Dim SecondsToNextSMS As Integer

            Dim NextSMSTime As String = My.Settings.SMSTime
            Dim Interval As Integer = My.Settings.SMSInterval * 60 * 60 * 1000

            If Date.ParseExact(NextSMSTime, "HH:mm", Nothing) > Now Then
                SecondsToNextSMS = DateDiff(DateInterval.Second, Now, Date.ParseExact(NextSMSTime, "HH:mm", Nothing))
            Else
                SecondsToNextSMS = DateDiff(DateInterval.Second, Now, DateAdd(DateInterval.Day, 1, Date.ParseExact(NextSMSTime, "HH:mm", Nothing)))
            End If

            Timer = New System.Threading.Timer(oCallBack, Nothing, 1000 * SecondsToNextSMS + 1000, Interval)

        Catch ex As Exception
            EventLog1.WriteEntry("Errot on Start: " & ex.Message, System.Diagnostics.EventLogEntryType.Error)
        End Try

    End Sub
    Protected Overrides Sub OnStop()
        EventLog1.WriteEntry("Service stopped at " & Now)
    End Sub
    Public Sub New()

        ' This call is required by the designer.
        InitializeComponent()

        If Not System.Diagnostics.EventLog.SourceExists(LogSource) Then
            System.Diagnostics.EventLog.CreateEventSource(LogSource, Log)
        End If

        EventLog1.Source = LogSource
        EventLog1.Log = Log

    End Sub

    Private Function GetSMSSettings() As DataTable
        Dim sSQL As String = "SELECT SMSLink,SMSIP, SMSUserName, SMSPassword, SMSSource, SMSDlr FROM tblIMISDefaults"
        Dim data As New ExactSQL
        data.setSQLCommand(sSQL, CommandType.Text)
        Return data.Filldata
    End Function
    Private Function CreateURL() As String
        Dim dt As DataTable = GetSMSSettings()
        Dim Link As String = ""
        Dim IP As String = ""
        Dim UserName As String = ""
        Dim Password As String = ""
        Dim Source As String = ""
        Dim Destination As String = ""
        Dim Dlr As String = ""
        Dim Type As String = ""
        Dim Message As String = ""


        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            Link = dt.Rows(0)("SMSLink").ToString
            IP = dt.Rows(0)("SMSIP").ToString
            UserName = dt.Rows(0)("SMSUserName").ToString
            Password = dt.Rows(0)("SMSPassword").ToString
            Source = dt.Rows(0)("SMSSource").ToString

            For Each dr As DataRow In dtInsuree.Rows
                Destination += dr("Phone") & ","
            Next
            Destination = Mid(Destination, 1, Len(Destination) - 1)

            Dlr = dt.Rows(0)("SMSDlr")
            Type = dt.Rows(0)("SMSType")
            Message = My.Settings.Message
        End If

        Dim Url As String = String.Format("{0}?username={1}&password={2}&source={3}&destination={4}&dlr={5}&type={6}&message={7}", Link, UserName, Password, Source, Destination, Dlr, Type, Message)
        Return Url
    End Function
    Private Function GetInsurees() As DataTable
        'Dim sSQL = "SELECT CONCAT(I.OtherNames, ' ' , I.LastName) Insuree, I.Phone" & _
        '           " FROM tblPolicy  P INNER JOIN tblFamilies F ON P.FamilyID = F.FamilyID" & _
        '           " INNER JOIN tblInsuree I ON F.InsureeID = I.InsureeID" & _
        '           " WHERE P.ValidityTo Is NULL" & _
        '           " AND F.ValidityTo IS NULL" & _
        '           " AND I.ValidityTo IS NULL" & _
        '           " AND LEN(LTRIM(RTRIM(I.Phone))) > 0" & _
        '           " AND EffectiveDate = @EffectiveDate"


        Dim sSQL = "SELECT 'IMIS' sender,"
        sSQL += " ("
        sSQL += " SELECT REPLACE(REPLACE(REPLACE(I.Phone,' ',''), '(', ''), ')', '') [to]"
        sSQL += " FROM tblInsuree PNo"
        sSQL += " WHERE Pno.InsureeID = I.InsureeID"
        sSQL += " FOR XML  PATH('recipients'), TYPE"
        sSQL += " )PhoneNumber,"
        sSQL += " REPLACE(REPLACE(REPLACE(@Message, '@@Name', I.OtherNames + ' ' + I.LastName), '@@EffectiveDate', CONVERT(NVARCHAR(10), @EffectiveDate, 103)), '@@ExpiryDate', CONVERT(NVARCHAR(10), P.ExpiryDate, 103)) [text]"
        sSQL += " FROM tblPolicy  P INNER JOIN tblFamilies F ON P.FamilyID = F.FamilyID"
        sSQL += " INNER JOIN tblInsuree I ON F.FamilyId = I.FamilyId"
        sSQL += " WHERE P.ValidityTo Is NULL"
        sSQL += " AND F.ValidityTo IS NULL"
        sSQL += " AND I.ValidityTo IS NULL"
        sSQL += " AND LEN(LTRIM(RTRIM(I.Phone))) > 0"
        sSQL += " AND CASE @HOFOnly WHEN 1 THEN 1 ELSE I.IsHead END = I.IsHead"
        sSQL += " AND EffectiveDate = @EffectiveDate"
        sSQL += " GROUP BY I.InsureeId, I.Phone, I.OtherNames, I.lastName, ExpiryDate"
        sSQL += " FOR XML PATH('message'), ROOT('request'), TYPE;"


        Dim data As New ExactSQL
        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@EffectiveDate", SqlDbType.Date, Format(Now.Date, "yyyy-MM-dd"), ParameterDirection.Input)
        data.params("@Message", SqlDbType.NVarChar, 500, My.Settings.Message)
        data.params("@HOFOnly", SqlDbType.Bit, If(My.Settings.SMSToHOFOnly = True, 1, 0))

        Return data.Filldata

    End Function

    Private Function ExecuteURL(ByVal Url As String) As Integer
        Dim req As WebRequest = WebRequest.Create(Url)
        Dim res As WebResponse = req.GetResponse()
        Dim s As Stream = res.GetResponseStream()
        Dim sr As StreamReader = New StreamReader(s, System.Text.Encoding.ASCII)
        Dim info As String = sr.ReadToEnd
        If info.Trim.Length > 0 Then
            EventLog1.WriteEntry(GetResponse(info))
        Else
            EventLog1.WriteEntry("Status: Unknown")
        End If
    End Function
    Private Function GetResponse(ByVal Info As String) As String
        Select Case Mid(Info, 1, Info.IndexOf(":"))
            Case 1501
                Return "IP Verification failed!"
            Case 1502
                Return "Invalid username or password!"
            Case 1503
                Return "User validation failed!"
            Case 1504
                Return "Problem in Sender!"
            Case 1505
                Return "Problem in Message!"
            Case 1506
                Return "Problem in Destination!"
            Case 1507
                Return "Problem in DLR!"
            Case 1508
                Return "Problem in Type!"
            Case 1509
                Return "Insufficient credit!"
            Case 1701
                Return "Message sent successfully"
            Case Else
                Return "Unknown: " & Info
        End Select

    End Function
    Private Sub SendSMS()
        Try
            EventLog1.WriteEntry("Seding SMS started at " & Now)

            'Check if the message is defined in settings
            If My.Settings.Message.Trim.Length = 0 Then
                Dim ex1 As New Exception("No message has been defined")
                Throw ex1
            End If

            'Get all the insurees who became activated today
            dtInsuree = GetInsurees()
            Dim xml As String = dtInsuree(0)(0).ToString

            'Proceed only if insuree found
            If dtInsuree.Rows.Count > 0 And xml.Trim.Length > 0 Then
                'EventLog1.WriteEntry(dtInsuree.Rows.Count.ToString & " sms will be sent")

                ''Create a url to execute
                'Dim URL As String = CreateURL()

                ''Execute the url which will send sms to all insurees
                'ExecuteURL(URL)

                Dim Response As String = ""

                Dim Req As HttpWebRequest = Nothing
                Dim res As HttpWebResponse

                Dim URL As String = My.Settings.GatewayURL
                Dim UserName As String = My.Settings.GatewayUser
                Dim UserPassword As String = My.Settings.GatewayPassword

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

                'EventLog1.WriteEntry("Seding SMS finished at " & Now)

            Else
                EventLog1.WriteEntry("No insuree became effective today.")
            End If


        Catch ex As Exception
            EventLog1.WriteEntry("Error while sending SMS: " & ex.Message, System.Diagnostics.EventLogEntryType.Error)
        End Try
    End Sub

End Class
