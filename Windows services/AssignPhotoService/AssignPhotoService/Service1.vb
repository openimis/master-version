Imports System.Threading
Imports System.IO
Imports System.Data.SqlClient

Public Class AssignPhotos

    Private Timer As System.Threading.Timer
    Private sConString As String = "Data Source=" & My.Settings.DataSource & ";Initial Catalog=" & My.Settings.DatabaseName & ";User ID=" & My.Settings.UserName & ";Password=" & My.Settings.Password & ";Application Name = AssignPhotoService"

    Protected Overrides Sub OnStart(ByVal args() As String)
        Try
            EventLog1.WriteEntry("Service started @ " & Now)

            Dim oCallback As New TimerCallback(AddressOf AssignPhotos)

            Dim SecondsToNextAssign As Integer

            Dim NextActionTime As String = My.Settings.ActionTime
            Dim Interval As Integer = My.Settings.ActionInterval * 60 * 60 * 1000

            If Date.ParseExact(NextActionTime, "HH:mm", Nothing) > Now Then
                SecondsToNextAssign = DateDiff(DateInterval.Second, Now, Date.ParseExact(NextActionTime, "HH:mm", Nothing))
            Else
                SecondsToNextAssign = DateDiff(DateInterval.Second, Now, DateAdd(DateInterval.Day, 1, Date.ParseExact(NextActionTime, "HH:mm", Nothing)))
            End If

            Timer = New System.Threading.Timer(oCallback, Nothing, 1000 * SecondsToNextAssign + 1000, Interval)

        Catch ex As Exception
            EventLog1.WriteEntry("Erro On Start: " & ex.Message, System.Diagnostics.EventLogEntryType.Error)
        End Try
    End Sub
    Protected Overrides Sub OnStop()
        EventLog1.WriteEntry("Service stopped @ " & Now)
    End Sub
    Public Sub New()
        InitializeComponent()

        If Not System.Diagnostics.EventLog.SourceExists("AssignPhotoSource") Then
            System.Diagnostics.EventLog.CreateEventSource("AssignPhotoSource", "AssignPhotoLog")
        End If

        EventLog1.Source = "AssignPhotoSource"
        EventLog1.Log = "AssignPhotoLog"

    End Sub
    Public Function CheckCHFID(ByVal CHFID As String) As Boolean
        'Master versino does not check for modula 9 so just return true
        Return True
        'If Not CHFID.ToString.Length = 9 Then Return False
        'Dim n As String = Left(CHFID.ToString, 8)
        'Dim Checksum As String = Right(CHFID.ToString, 1)
        'If CInt(n) = Checksum And Checksum = 0 Then Return False
        'If Checksum = n - (Int(n / 7) * 7) Then Return True
    End Function
    Public Function isValidDate(ByVal PhotoDate As String) As Boolean
        isValidDate = False

        If PhotoDate.Trim.Length <> 8 Then Exit Function
        If Not IsNumeric(PhotoDate) Then Exit Function

        Dim sDate As String = PhotoDate.Insert(4, "-").Insert(7, "-")

        If Not IsDate(sDate) Then Exit Function

        isValidDate = True
    End Function
    Private Sub InsertIntoTable(ByVal row As DataRow)
        Try

            Dim sSQL As String = ""
            sSQL = "IF NOT EXISTS(SELECT 1 FROM tblSubmittedPhotos WHERE ImageName = '" & row("ImageName").ToString & "')" & _
                   " INSERT INTO tblSubmittedPhotos(ImageName,CHFID,OfficerCode,PhotoDate)" & _
                   " VALUES('" & row("ImageName").ToString & "','" & row("CHFID").ToString & "','" & row("OfficerCode") & "','" & row("PhotoDate") & "')"

            ExecuteData(sSQL, CommandType.Text)

        Catch ex As Exception
            EventLog1.WriteEntry("While inserting " & row("ImageName") & " into tblSubmittedPhotos :" & ex.Message, EventLogEntryType.Error)
        End Try
    End Sub
    Private Sub DeleteFromTable(ByVal ImageName As String)
        Try

            Dim sSQL As String = ""
            sSQL = "DELETE FROM tblSubmittedPhotos WHERE ImageName = '" & ImageName & "'"
            ExecuteData(sSQL, CommandType.Text)

        Catch ex As Exception
            EventLog1.WriteEntry("While deleting " & ImageName & " from tblSubmittedPhotos : " & ex.Message, EventLogEntryType.Error)
        End Try
    End Sub
    Private Sub ClearSubmittedPhotos()
        Try

            Dim sSQL As String = "DELETE P FROM tblSubmittedPhotos P INNER JOIN tblInsuree I ON P.CHFID = I.CHFID WHERE I.ValidityTo IS NULL"
            ExecuteData(sSQL, CommandType.Text)
            EventLog1.WriteEntry("Cleaned table @ " & Now)

        Catch ex As Exception
            EventLog1.WriteEntry("While cleaning the table : " & ex.Message, EventLogEntryType.Error)
        End Try
    End Sub
    Private Function isValidFileName(ByVal row As DataRow) As Boolean
        isValidFileName = False

        Try


            If UBound(row("ImageName").ToString.Split(My.Settings.Delimiter)) <> 4 Then
                MoveFile(My.Settings.SubmittedFolder & row("ImageName"), My.Settings.RejectedFolder & row("ImageName"))
                Exit Function
            End If

            If (row("ImageName").ToString.Length > 50) Then
                MoveFile(My.Settings.SubmittedFolder & row("ImageName"), My.Settings.RejectedFolder & row("ImageName"))
                Exit Function
            End If

            If GetOfficerId(row("OfficerCode")) < 0 Then
                MoveFile(My.Settings.SubmittedFolder & row("ImageName"), My.Settings.RejectedFolder & row("ImageName"))
                Exit Function
            End If

            If CheckCHFID(row("CHFId").ToString) = False Then
                MoveFile(My.Settings.SubmittedFolder & row("ImageName"), My.Settings.RejectedFolder & row("ImageName"))
                Exit Function
            End If

            If row("PhotoDate") Is DBNull.Value Then
                MoveFile(My.Settings.SubmittedFolder & row("ImageName"), My.Settings.RejectedFolder & row("ImageName"))
                Exit Function
            End If

            If isCHFIDExists(row("CHFId")) = False Then
                InsertIntoTable(row)
                Exit Function
            End If

        Catch ex As Exception
            EventLog1.WriteEntry("Validating FileName: " & row("ImageName") & " - " & ex.Message, EventLogEntryType.Error)
            Return False
        End Try

        isValidFileName = True
    End Function
    Private Sub AssignPhotos()

        Try

            EventLog1.WriteEntry("Started assigning photos @ " & Now)

            Dim dtImages As New DataTable

            dtImages = GetAllImages()

            EventLog1.WriteEntry(dtImages.Rows.Count & " photo(s) found.")

            Dim iPhotoAssigned As Integer = 0

            For Each row As DataRow In dtImages.Rows

                If Not isValidFileName(row) Then
                    Continue For
                End If

                'Insert into tblSubmittedPhotos
                InsertIntoTable(row)

                Try

                    If InsertPhoto(row("CHFID"), row("ImageName"), row("PhotoDate")) Then

                        MoveFile(My.Settings.SubmittedFolder & row("ImageName"), My.Settings.UpdatedFolder & row("ImageName"))

                        'Delete from tblSubmittedPhotos
                        DeleteFromTable(row("ImageName").ToString)

                        iPhotoAssigned = iPhotoAssigned + 1
                    End If

                Catch ex As Exception
                    EventLog1.WriteEntry("Inserting in DB:" & row("ImageName") & " - " & ex.Message, EventLogEntryType.Error)
                End Try
            Next

            'Clean the table
            ClearSubmittedPhotos()

            'Write how many photos inserted
            EventLog1.WriteEntry(iPhotoAssigned & " of " & dtImages.Rows.Count & " photo(s) assigned successfully.")


        Catch ex As Exception
            EventLog1.WriteEntry(ex.Message, EventLogEntryType.Error)
        End Try

    End Sub
    Private Function GetAllImages() As DataTable
        Dim dt As New DataTable
        dt.Columns.Add("ImageName")
        dt.Columns.Add("CHFID")
        dt.Columns.Add("OfficerCode")
        dt.Columns.Add("PhotoDate")


        Dim Images() As FileInfo
        Dim DirInfo As New DirectoryInfo(My.Settings.SubmittedFolder)

        'Dim CHFID As String = ""
        'Dim Officer As String = ""
        'Dim PhotoDate As Date


        Images = DirInfo.GetFiles("*.jpg")

        For i As Integer = 0 To Images.Count - 1
            Try

                Dim r As DataRow = dt.NewRow()
                If UBound(Images(i).Name.Split(My.Settings.Delimiter)) <> 4 Then
                    MoveFile(My.Settings.SubmittedFolder & Images(i).Name, My.Settings.RejectedFolder & Images(i).Name)
                    Continue For
                End If
                r("ImageName") = Images(i)
                r("CHFID") = ExtractCHFID(Images(i).Name)
                r("OfficerCode") = ExtractOfficer(Images(i).Name)
                If Not isValidDate(Mid(Split(Images(i).Name, My.Settings.Delimiter)(2), 1, 8)) Then
                    r("PhotoDate") = DBNull.Value
                Else
                    r("PhotoDate") = ExtractDate(Images(i).Name)
                End If

                dt.Rows.Add(r)

            Catch ex As Exception
                EventLog1.WriteEntry("Collecting Pictures: " & ex.Message, EventLogEntryType.Error)
                Continue For
            End Try
        Next

        Return dt

    End Function
    Private Function ExtractCHFID(ByVal ImageName As String) As String
        Return Split(ImageName, My.Settings.Delimiter)(0)
    End Function
    Private Function ExtractOfficer(ByVal ImageName As String) As String
        Return Split(ImageName, My.Settings.Delimiter)(1)
    End Function
    Private Function ExtractDate(ByVal ImageName As String) As String
        Return Format(Date.ParseExact(Mid(Split(ImageName, My.Settings.Delimiter)(2), 1, 8), "yyyyMMdd", Nothing), "yyyyMMdd")
    End Function
    Private Function ExtractLatitude(ByVal ImageName As String) As String
        Dim ImageNameArray = Split(ImageName, My.Settings.Delimiter)

        If ImageNameArray.Length > 3 Then
            Return Split(ImageName, My.Settings.Delimiter)(3)
        End If

        Return ""
    End Function
    Private Function ExtractLongitude(ByVal ImageName As String) As String
        Dim ImageNameArray = Split(ImageName, My.Settings.Delimiter)

        If ImageNameArray.Length > 4 Then
            Return Split(ImageName, My.Settings.Delimiter)(4).Replace(".jpg", "")
        End If

        Return ""

    End Function
    Private Function isCHFIDExists(ByVal CHFID As String) As Boolean
        Dim sSQL As String = ""
        sSQL = "SELECT * FROM tblInsuree WHERE CHFId = '" & Replace(CHFID, "'", "''") & "' AND ValidityTo IS NULL"
        Dim dt As New DataTable
        dt = GetData(sSQL, CommandType.Text)
        If dt.Rows.Count > 0 Then
            Return True
        Else
            Return False
        End If
    End Function
    Private Function GetOfficerId(ByVal OfficerCode As String) As Integer
        Dim sSQL As String = ""
        sSQL = "SELECT OfficerId FROM tblOfficer WHERE Code = '" & Replace(OfficerCode, "'", "''") & "' AND ValidityTo IS NULL"

        Dim dt As New DataTable
        dt = GetData(sSQL, CommandType.Text)

        If dt Is Nothing Then Return -1
        If dt.Rows.Count = 0 Then Return -1

        If dt.Rows(0)("OfficerId") > 0 Then
            Return dt.Rows(0)("OfficerId")
        Else
            Return -1
        End If

    End Function
    Private Function InsertPhoto(ByVal CHFID As String, ByVal ImageName As String, ByVal PhotoDate As String) As Boolean
        Dim sSQL As String = ""
        sSQL = "DECLARE @PhotoId INT,@InsureeId INT;SELECT @PhotoId = PhotoId,@InsureeId = InsureeId FROM tblInsuree WHERE CHFID = '" & CHFID & "' AND ValidityTo IS NULL;" & _
               " INSERT INTO tblPhotos(InsureeId,CHFID,PhotoFolder,PhotoFileName,OfficerId, PhotoDate,ValidityFrom,ValidityTo,AuditUserId)" & _
               " SELECT InsureeId, CHFID,PhotoFolder,PhotoFileName,OfficerId, PhotoDate,ValidityFrom,GETDATE(),AuditUserId FROM tblPhotos WHERE PhotoId = @PhotoId;" & _
               " UPDATE tblPhotos SET PhotoFolder = 'Images\Updated\' , PhotoFileName = '" & ImageName & "',PhotoDate = '" & PhotoDate & "',AuditUserId = -1 WHERE PhotoID = @PhotoId;" & _
               " UPDATE tblInsuree SET PhotoDate = '" & PhotoDate & "', GeoLocation = '" & ExtractLatitude(ImageName) & " " & ExtractLongitude(ImageName) & "' WHERE InsureeId = @InsureeId"

        ExecuteData(sSQL, CommandType.Text)

        Return True
    End Function
    Private Sub MoveFile(ByVal strSourceFile As String, ByVal strDestinationFile As String)
        If File.Exists(strDestinationFile) Then
            File.Delete(strDestinationFile)
        End If
        File.Move(strSourceFile, strDestinationFile)
    End Sub

#Region "Data Access"

    Private Sub ExecuteData(ByVal sql As String, ByVal CommandType As CommandType)
        Dim con As New SqlConnection(sConString)
        If con.State = ConnectionState.Closed Then con.Open()
        Dim cmd As New SqlCommand(sql, con)
        cmd.CommandType = CommandType
        cmd.ExecuteNonQuery()
    End Sub
    Public Function GetData(ByVal sql As String, ByVal CommandType As CommandType) As DataTable
        Dim con As New SqlConnection(sConString)
        Dim cmd As New SqlCommand(sql, con)
        cmd.CommandType = CommandType
        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)
        Return dt
    End Function

#End Region

End Class
