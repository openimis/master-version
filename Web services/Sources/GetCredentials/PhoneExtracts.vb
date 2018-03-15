'Copyright (c) 2016-%CurrentYear% Swiss Agency for Development and Cooperation (SDC)
'
'The program users must agree to the following terms:
'
'Copyright notices
'This program is free software: you can redistribute it and/or modify it under the terms of the GNU AGPL v3 License as published by the 
'Free Software Foundation, version 3 of the License.
'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL v3 License for more details www.gnu.org.
'
'Disclaimer of Warranty
'There is no warranty for the program, to the extent permitted by applicable law; except when otherwise stated in writing the copyright 
'holders and/or other parties provide the program "as is" without warranty of any kind, either expressed or implied, including, but not 
'limited to, the implied warranties of merchantability and fitness for a particular purpose. The entire risk as to the quality and 
'performance of the program is with you. Should the program prove defective, you assume the cost of all necessary servicing, repair or correction.
'
'Limitation of Liability 
'In no event unless required by applicable law or agreed to in writing will any copyright holder, or any other party who modifies and/or 
'conveys the program as permitted above, be liable to you for damages, including any general, special, incidental or consequential damages 
'arising out of the use or inability to use the program (including but not limited to loss of data or data being rendered inaccurate or losses 
'sustained by you or third parties or a failure of the program to operate with any other programs), even if such holder or other party has been 
'advised of the possibility of such damages.
'
'In case of dispute arising out or in relation to the use of the program, it is subject to the public law of Switzerland. The place of jurisdiction is Berne.


Imports System.Data.SqlClient
Imports System.IO
Imports System.Data.SQLite

Public Class PhoneExtracts
    Public Function CreatePhoneExtracts(ByRef eExtractInfo As eExtractInfo, ByVal WithInsuree As Boolean, FolderPath As String) As String

        Dim eDefaults As New tblIMISDefaults
        Dim DB_NAME As String
        Dim dtExtractSource As New DataTable
        Dim eExtractInfoLast As New tblExtracts

        eExtractInfoLast = GetLastCreateExtractInfo(eExtractInfo.DistrictID, eExtractInfo.ExtractType, 0)


        'Try


        Dim eExtract As New tblExtracts

        GetDefaults(eDefaults)

        Dim FileName As String = "ImisData" & eExtractInfo.DistrictID & "_" & Guid.NewGuid.ToString & ".db3"

        DB_NAME = FolderPath & "\" & FileName

        If System.IO.File.Exists(DB_NAME) = True Then
            System.IO.File.Delete(DB_NAME)
        End If

        Dim con As New SQLite.SQLiteConnection
        Dim cmd As New SQLite.SQLiteCommand

        con.ConnectionString = "Data source = " & DB_NAME
        con.Open()
        'con.ChangePassword(DB_PWD)
        cmd = con.CreateCommand

        Dim sSQL As String = ""
        Dim strPhoto As String = ""
        sSQL = "CREATE TABLE tblPolicyInquiry(CHFID text,Photo BLOB, InsureeName Text, DOB Text, Gender Text, ProductCode Text, ProductName Text, ExpiryDate Text, Status Text, DedType Int, Ded1 Int, Ded2 Int, Ceiling1 Int, Ceiling2 Int)"
        cmd.CommandText = sSQL
        cmd.ExecuteNonQuery()


        If WithInsuree = True Then
            dtExtractSource = GetPhoneExtractSource(eExtractInfo.DistrictID)

            Dim i As Integer = 1

            Using InsertCmd = New SQLiteCommand(con)
                Using transaction = con.BeginTransaction
                    For Each row In dtExtractSource.Rows
                        sSQL = "INSERT INTO tblPolicyInquiry(CHFID ,Photo , InsureeName, DOB, Gender, ProductCode, ProductName, ExpiryDate, Status, DedType, Ded1, Ded2, Ceiling1, Ceiling2)" & _
                       " VALUES(@CHFID,@image,@InsureeName,@DOB,@Gender,@ProductCode,@ProductName,@ExpiryDate,@Status,@DedType,@Ded1,@Ded2,@Ceiling1,@Ceiling2)"
                        InsertCmd.CommandText = sSQL

                        InsertCmd.Parameters.AddWithValue("@CHFID", row("CHFID").ToString)
                        InsertCmd.Parameters.Add(ImageToBlob("@image", "\" & row("PhotoPath")))
                        InsertCmd.Parameters.AddWithValue("@InsureeName", row("InsureeName").ToString)
                        InsertCmd.Parameters.AddWithValue("@DOB", row("DOB"))
                        InsertCmd.Parameters.AddWithValue("@Gender", row("Gender").ToString)
                        InsertCmd.Parameters.AddWithValue("@ProductCode", row("ProductCode").ToString)
                        InsertCmd.Parameters.AddWithValue("@ProductName", row("ProductName").ToString)
                        InsertCmd.Parameters.AddWithValue("@ExpiryDate", row("ExpiryDate"))
                        InsertCmd.Parameters.AddWithValue("@Status", row("Status"))
                        InsertCmd.Parameters.AddWithValue("@DedType", row("DedType"))
                        InsertCmd.Parameters.AddWithValue("@Ded1", row("Ded1"))
                        InsertCmd.Parameters.AddWithValue("@Ded2", row("Ded2"))
                        InsertCmd.Parameters.AddWithValue("@Ceiling1", row("Ceiling1"))
                        InsertCmd.Parameters.AddWithValue("@Ceiling2", row("Ceiling2"))

                        InsertCmd.ExecuteNonQuery()
                        i = i + 1

                    Next
                    transaction.Commit()
                    InsertCmd.Dispose()
                End Using
            End Using

        End If
        cmd.Dispose()

        cmd = New SQLite.SQLiteCommand
        cmd = con.CreateCommand
        sSQL = "CREATE TABLE tblReferences([Code] Text, [Name] Text, [Type] Text, [Price] INT)"
        cmd.CommandText = sSQL
        cmd.ExecuteNonQuery()

        Dim dtReference As New DataTable
        dtReference = getReferences()



        Using InsertCmd = New SQLiteCommand(con)
            Using transaction = con.BeginTransaction
                For Each row In dtReference.Rows
                    sSQL = "INSERT INTO tblReferences([Code],[Name],[Type],[Price])" & _
                           " VALUES(@Code,@Name,@Type,@Price)"

                    InsertCmd.CommandText = sSQL

                    InsertCmd.Parameters.AddWithValue("@Code", row("Code").ToString)
                    InsertCmd.Parameters.AddWithValue("@Name", row("Name").ToString)
                    InsertCmd.Parameters.AddWithValue("@Type", row("Type").ToString)
                    InsertCmd.Parameters.AddWithValue("@Price", row("Price"))

                    InsertCmd.ExecuteNonQuery()

                Next
                transaction.Commit()
            End Using
        End Using

        cmd.Dispose()
        con.Close()


        eExtract.RowID = 0
        eExtract.AuditUserID = eExtractInfo.AuditUserID
        eExtract.ExtractDirection = 0
        eExtract.DistrictID = eExtractInfo.DistrictID
        eExtract.ExtractDate = Date.Now
        eExtract.HFID = 0
        eExtract.ExtractSequence = eExtractInfoLast.ExtractSequence + 1
        eExtract.AppVersionBackend = eDefaults.AppVersionBackEnd
        eExtract.ExtractFolder = eDefaults.FTPPhoneExtractFolder
        eExtract.ExtractType = eExtractInfo.ExtractType
        eExtract.ExtractFileName = "ImisData.db3"

        If Right(eExtract.ExtractFolder, 1) = "/" Or Right(eExtract.ExtractFolder, 1) = "\" Then
            eExtractInfo.ExtractFileName = Left(eExtract.ExtractFolder, Len(eExtract.ExtractFolder) - 1) & "\" & eExtract.ExtractFileName
        Else
            eExtractInfo.ExtractFileName = eExtract.ExtractFolder & "\" & eExtract.ExtractFileName
        End If

        'insert the extract entry 
        InsertExtract(eExtract)

        eExtractInfo.ExtractStatus = 0

        Return FileName

        'Catch ex As Exception
        '    Exit Sub
        'End Try

    End Function

    Private Function GetLastCreateExtractInfo(ByVal DistrictID As Integer, ByVal ExtractType As Integer, Optional ByVal ExtractDirection As Integer = 0) As tblExtracts
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand("DECLARE @MaxSeq int; SELECT @MaxSeq = ISNULL(MAX([ExtractSequence]),0) FROM [dbo].[tblExtracts] WHERE ExtractDirection = @ExtractDirection AND (CASE @DistrictID WHEN 0 THEN 0 ELSE LocationId END ) = @DistrictID AND (CASE @ExtractType WHEN 0 THEN 0 ELSE ExtractType END ) = @ExtractType AND ValidityTo is null;SELECT @MaxSeq as Sequence, RowID FROM tblExtracts WHERE ExtractDirection = @ExtractDirection AND (CASE @DistrictID WHEN 0 THEN 0 ELSE LocationId END ) = @DistrictID  AND (CASE @ExtractType WHEN 0 THEN 0 ELSE ExtractType END ) = @ExtractType  AND ValidityTo is null AND ExtractSequence = @MaxSeq;", con)
        cmd.CommandType = CommandType.Text
        If con.State = ConnectionState.Closed Then con.Open()

        cmd.Parameters.AddWithValue("@DistrictID", DistrictID)
        cmd.Parameters.AddWithValue("@ExtractType", ExtractType)
        cmd.Parameters.AddWithValue("@ExtractDirection", ExtractDirection)

        Dim eExtractLog As New tblExtracts

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)
        Dim dr As DataRow = Nothing
        If dt.Rows.Count > 0 Then
            dr = dt.Rows(0)
        End If

        If Not dr Is Nothing Then
            eExtractLog.RowID = dr("RowID")
            eExtractLog.ExtractSequence = dr("Sequence")

        Else
            eExtractLog.RowID = 0
            eExtractLog.ExtractSequence = 0
        End If
        Return eExtractLog
    End Function
    Private Function GetPhoneExtractSource(ByVal DistrictID As Integer) As DataTable

        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand("uspPhoneExtract", con)
        cmd.CommandType = CommandType.StoredProcedure
        If con.State = ConnectionState.Closed Then con.Open()

        'cmd.Parameters.Add("@CHFID", SqlDbType.NVarChar, 12).Value = ""
        cmd.Parameters.AddWithValue("@LocationId", DistrictID)

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)

        Return dt

    End Function
    Private Function getReferences() As DataTable
        Dim sSQL As String = ""
        sSQL = "SELECT ItemCode [Code],ItemName [Name],'I' [Type],ItemPrice [Price] FROM TBLITEMS WHERE ValidityTo IS NULL" & vbCrLf & _
               " UNION ALL" & vbCrLf & _
               " SELECT ServCode,ServName,'S',ServPrice FROM tblServices WHERE ValidityTo IS NULL" & vbCrLf & _
               " UNION ALL" & vbCrLf & _
               " SELECT ICDCode,ICDName, 'D',0 FROM tblICDCodes WHERE ValidityTo IS NULL" & vbCrLf & _
               " UNION ALL" & vbCrLf & _
               " SELECT PayerName, PayerName + ' ' + QUOTENAME(ISNULL(D.DistrictName, N'National')), 'P',0 FROM tblPayer P LEFT OUTER JOIN tblDistricts D ON P.LocationId = D.DistrictID WHERE P.ValidityTo IS NULL AND D.ValidityTo IS NULL"



        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.Text
        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)

        Return dt

    End Function
    Private Sub InsertExtract(ByVal eExtract As tblExtracts)

        Dim sSQL As String = "INSERT INTO tblExtracts (ExtractDirection ,ExtractType,ExtractSequence,ExtractDate,ExtractFileName,ExtractFolder,LocationId,HFID,AppVersionBackend,AuditUserID,RowID)" _
        & " VALUES (@Direction,@ExtractType,@Sequence,@ExtractDate,@ExtractFileName,@ExtractFolder,@DistrictID,@HFID,@AppVersionBackend,@AuditUserID,@RowID); select @ExtractID = scope_identity()"


        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.Text
        If con.State = ConnectionState.Closed Then con.Open()

        cmd.Parameters.AddWithValue("@ExtractID", eExtract.ExtractID)
        cmd.Parameters("@ExtractId").Direction = ParameterDirection.Output
        cmd.Parameters.AddWithValue("@Direction", eExtract.ExtractDirection)
        cmd.Parameters.AddWithValue("@ExtractType", eExtract.ExtractType)
        cmd.Parameters.AddWithValue("@Sequence", eExtract.ExtractSequence)
        cmd.Parameters.AddWithValue("@ExtractDate", Now())
        cmd.Parameters.Add("@ExtractFileName", SqlDbType.NVarChar, 255).Value = eExtract.ExtractFileName
        cmd.Parameters.Add("@ExtractFolder", SqlDbType.NVarChar, 255).Value = eExtract.ExtractFolder
        cmd.Parameters.AddWithValue("@DistrictID", eExtract.DistrictID)
        cmd.Parameters.AddWithValue("@HFID", eExtract.HFID)
        cmd.Parameters.AddWithValue("@AppVersionBackend", eExtract.AppVersionBackend)
        cmd.Parameters.AddWithValue("@AuditUserID", eExtract.AuditUserID)
        cmd.Parameters.AddWithValue("@RowID", eExtract.RowID)

        cmd.ExecuteNonQuery()

        con.Close()

        eExtract.ExtractID = cmd.Parameters("@ExtractID").Value

    End Sub
    Private Sub GetDefaults(ByRef eDefaults As tblIMISDefaults)

        Dim sSQL As String = "SELECT [DefaultID],[PolicyRenewalInterval],[FTPHost],[FTPUser],[FTPPassword],[FTPPort],[FTPEnrollmentFolder],[FTPClaimFolder],[FTPFeedbackFolder],[FTPPolicyRenewalFolder],[FTPPhoneExtractFolder],[FTPOffLineExtractFolder],[AppVersionBackEnd],[AppVersionEnquire],[AppVersionEnroll],[AppVersionRenewal],[AppVersionFeedback],[AppVersionClaim],[OffLineHF],[OfflineCHF],[WinRarFolder],[DatabaseBackupFolder] FROM tblIMISDefaults"

        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.Text
        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)


        Dim dr As DataRow = dt.Rows(0)
        If Not dr Is Nothing Then
            eDefaults.DefaultID = dr("DefaultID")
            eDefaults.PolicyRenewalInterval = dr("PolicyRenewalInterval")
            eDefaults.FTPHost = dr("FTPHost")
            eDefaults.FTPUser = dr("FTPUser")
            eDefaults.FTPPassword = dr("FTPPassword")
            eDefaults.FTPPort = dr("FTPPort")
            eDefaults.FTPEnrollmentFolder = dr("FTPEnrollmentFolder")
            eDefaults.FTPClaimFolder = dr("FTPClaimFolder")
            eDefaults.FTPFeedbackFolder = dr("FTPFeedbackFolder")
            eDefaults.FTPPolicyRenewalFolder = dr("FTPPolicyRenewalFolder")
            eDefaults.FTPPhoneExtractFolder = dr("FTPPhoneExtractFolder")
            eDefaults.FTPOffLineExtractFolder = dr("FTPOffLineExtractFolder")
            eDefaults.AppVersionBackEnd = dr("AppVersionBackEnd")
            eDefaults.AppVersionEnquire = dr("AppVersionEnquire")
            eDefaults.AppVersionEnroll = dr("AppVersionEnroll")
            eDefaults.AppVersionRenewal = dr("AppVersionRenewal")
            eDefaults.AppVersionFeedback = dr("AppVersionFeedback")
            eDefaults.AppVersionClaim = dr("AppVersionClaim")
            eDefaults.WinRarFolder = dr("WinRarFolder")
            eDefaults.OffLineHF = IIf(dr("OffLineHF") Is DBNull.Value, 0, dr("OffLineHF"))
            eDefaults.OfflineCHF = IIf(dr("OfflineCHF") Is DBNull.Value, 0, dr("OfflineCHF"))
            eDefaults.DatabaseBackupFolder = dr("DatabaseBackupFolder")
        End If

    End Sub
    Private Function ImageToBlob(ByVal id As String, ByVal filePath As String) As SQLiteParameter

        Dim SQLParam As New SQLiteParameter


        If Not System.IO.File.Exists(HttpContext.Current.Server.MapPath(filePath)) Then

            SQLParam = New SQLiteParameter("@Image", Nothing)
            SQLParam.DbType = DbType.Binary
            SQLParam.Value = Nothing

            Return SQLParam

        End If

        Dim fs As FileStream = New FileStream(HttpContext.Current.Server.MapPath(filePath), FileMode.Open, FileAccess.Read)
        Dim br As BinaryReader = New BinaryReader(fs)
        Dim bm() As Byte = br.ReadBytes(fs.Length)

        br.Close()
        fs.Close()


        Dim Photo() As Byte = bm
        SQLParam = New SQLiteParameter("@Image", Photo)
        SQLParam.DbType = DbType.Binary
        SQLParam.Value = Photo

        Return SQLParam


    End Function
End Class
