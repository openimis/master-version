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
Imports System.Web.Script.Serialization
Imports System.Web.Script.Services
Imports System.Web.Services

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
'<WebService(Namespace:="http://tempuri.org/")>
'<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)>
'<ToolboxItem(False)>

Public Class Service1
    Inherits System.Web.Services.WebService


    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getFTPCredentials() As String
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand("Select FTPHost,FTPUser,FTPPassword,FTPPort,FTPEnrollmentFolder,FTPClaimFolder,FTPFeedbackFolder,FTPPolicyRenewalFolder from tblIMISDefaults", con)
        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)
        dt.TableName = "FTP"

        Dim ftp As FTP() = New FTP(dt.Rows.Count - 1) {}

        Dim JString As String = ""


        Dim i As Integer = 0

        For Each row In dt.Rows
            ftp(i) = New FTP()
            ftp(i).Host = row("FTPHost").ToString
            ftp(i).UserName = row("FTPUser").ToString
            ftp(i).Password = row("FTPPassword").ToString
            ftp(i).Port = row("FTPPort").ToString
            ftp(i).FTPEnrollmentFolder = row("FTPEnrollmentFolder").ToString
            ftp(i).FTPClaimFolder = row("FTPClaimFolder").ToString
            ftp(i).FTPFeedbackFolder = row("FTPFeedbackFolder").ToString
            ftp(i).FTPPolicyRenewalFolder = row("FTPPolicyRenewalFolder").ToString

            i += 1
        Next

        Dim js As New JavaScriptSerializer
        JString = js.Serialize(ftp)

        Return JString

    End Function
    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function EnquireInsuree(ByVal CHFID As String) As String

        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim sSQL As String = "uspPolicyInquiry"

        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.StoredProcedure

        cmd.Parameters.Add("@CHFID", SqlDbType.VarChar, 12).Value = CHFID

        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)

        Dim Insuree As InsureeDetails() = New InsureeDetails() {}
        Dim Policy As PolicyDetails() = New PolicyDetails() {}

        Dim jString As String = ""

        Dim i As Integer = 0
        Dim j As Integer = 0
        Dim cnt As Integer = 0
        Dim cntPolicy As Integer = 0

        If dt.Rows.Count > 0 Then
            While j < dt.Rows.Count
                ReDim Preserve Insuree(cnt)
                ReDim Policy(cntPolicy)

                Insuree(cnt) = New InsureeDetails()
                Insuree(cnt).CHFID = dt.Rows(j)("CHFID")
                Insuree(cnt).PhotoPath = dt.Rows(j)("PhotoPath").ToString
                Insuree(cnt).InsureeName = dt.Rows(j)("InsureeName")
                Insuree(cnt).DOB = dt.Rows(j)("DOB").ToString
                Insuree(cnt).Gender = dt.Rows(j)("Gender")



                'For Each row In dt.Rows
                While i < dt.Rows.Count

                    Dim row As DataRow = dt.Rows(i)

                    Dim isCurrentObject As Boolean = True

                    If dt.Rows(j)("CHFID") <> row("CHFID") Then Exit While
                    ReDim Preserve Policy(cntPolicy)
                    Policy(cntPolicy) = New PolicyDetails()


                    Policy(cntPolicy).ProductCode = row("ProductCode").ToString
                    Policy(cntPolicy).ProductName = row("ProductName").ToString
                    Policy(cntPolicy).ExpiryDate = row("ExpiryDate").ToString
                    Policy(cntPolicy).Status = row("Status")
                    'If Not row("DedType") Is DBNull.Value Then Policy(cntPolicy).DedType = row("DedType") 'IIf(row("DedType") Is DBNull.Value, Nothing, row("DedType"))
                    'If Not row("Ded1") Is DBNull.Value Then Policy(cntPolicy).Ded1 = Convert.ToDouble(row("Ded1")) 'IIf(row("Ded1") Is DBNull.Value, Nothing, Convert.ToDouble(row("Ded1")))
                    'If Not row("Ded2") Is DBNull.Value Then Policy(cntPolicy).Ded2 = Convert.ToDouble(row("Ded2")) ' IIf(row("Ded2") Is DBNull.Value, Nothing, Convert.ToDouble(row("Ded2")))
                    'If Not row("Ceiling1") Is DBNull.Value Then Policy(cntPolicy).Ceiling1 = Convert.ToDouble(row("Ceiling1")) 'IIf(row("Ceiling1") Is DBNull.Value, Nothing, Convert.ToDouble(row("Ceiling1")))
                    'If Not row("Ceiling2") Is DBNull.Value Then Policy(cntPolicy).Ceiling2 = Convert.ToDouble(row("Ceiling2")) 'IIf(row("Ceiling2") Is DBNull.Value, Nothing, Convert.ToDouble(row("Ceiling2")))

                    If row("DedType") Is DBNull.Value Then
                        Policy(cntPolicy).DedType = Nothing
                    Else
                        Policy(cntPolicy).DedType = row("DedType")
                    End If

                    If row("Ded1") Is DBNull.Value Then
                        Policy(cntPolicy).Ded1 = Nothing
                    Else
                        Policy(cntPolicy).Ded1 = Convert.ToDouble(row("Ded1"))
                    End If

                    If row("Ded2") Is DBNull.Value Then
                        Policy(cntPolicy).Ded2 = Nothing
                    Else
                        Policy(cntPolicy).Ded2 = Convert.ToDouble(row("Ded2"))
                    End If

                    If row("Ceiling1") Is DBNull.Value Then
                        Policy(cntPolicy).Ceiling1 = Nothing
                    Else
                        Policy(cntPolicy).Ceiling1 = Convert.ToDouble(row("Ceiling1"))
                    End If

                    If row("Ceiling2") Is DBNull.Value Then
                        Policy(cntPolicy).Ceiling2 = Nothing
                    Else
                        Policy(cntPolicy).Ceiling2 = Convert.ToDouble(row("Ceiling2"))
                    End If

                    cntPolicy += 1
                    i += 1
                End While

                Insuree(cnt).Details = Policy

                j = i
                cnt += 1
                cntPolicy = 0
            End While

        End If

        Dim js As New JavaScriptSerializer
        js.MaxJsonLength = Int32.MaxValue
        jString = js.Serialize(Insuree)

        Return jString

    End Function
    <WebMethod()> _
    Public Function GetCurrentVersion(ByVal Field As String) As String
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim sSQL As String = "SELECT " & Field & " FROM tblIMISDefaults"

        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.Text

        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)

        Return dt.Rows(0)(0)

    End Function
    <WebMethod()> _
    Public Function isUniqueReceiptNo(ByVal ReceiptNo As String, CHFID As String) As Boolean
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim sSQL As String = ""

        'sSQL = "SELECT 1 FROM tblPremium WHERE Receipt = @Receipt"

        sSQL = "SELECT 1"
        sSQL += " FROM tblPremium PR INNER JOIN tblPolicy PL ON PR.PolicyId = PL.PolicyID"
        sSQL += " INNER JOIN tblFamilies F ON PL.FamilyId = F.FamilyID"
        sSQL += " INNER JOIN tblInsuree I ON F.InsureeId = I.InsureeID"
        sSQL += " INNER JOIN tblVillages V ON V.VillageId = F.LocationId"
        sSQL += " INNER JOIN tblWards W ON W.WardId = V.WardId"
        sSQL += " INNER JOIN tblDistricts  D ON D.DistrictID = W.DistrictID"
        sSQL += " WHERE PR.ValidityTo IS NULL"
        sSQL += " AND PL.ValidityTo IS NULL"
        sSQL += " AND F.ValidityTo IS NULL"
        sSQL += " AND I.ValidityTo IS NULL"
        sSQL += " AND D.ValidityTo IS NULL"
        sSQL += " AND PR.Receipt = @Receipt"
        sSQL += " AND D.DistrictID = ("
        sSQL += " SELECT TOP 1 D.DistrictId"
        sSQL += " FROM tblFamilies F "
        sSQL += " INNER JOIN tblInsuree I ON F.InsureeId = I.InsureeID"
        sSQL += " INNER JOIN tblVillages V ON V.VillageId = F.LocationId"
        sSQL += " INNER JOIN tblWards W ON W.WardId = V.WardId"
        sSQL += " INNER JOIN tblDistricts  D ON D.DistrictID = W.DistrictID"
        sSQL += " WHERE F.ValidityTo IS NULL"
        sSQL += " AND I.ValidityTo IS NULL"
        sSQL += " AND I.CHFID = @CHFID)"


        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.Text

        cmd.Parameters.Add("@Receipt", SqlDbType.NVarChar, 50).Value = ReceiptNo
        cmd.Parameters.Add("@CHFID", SqlDbType.NVarChar, 12).Value = CHFID

        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)

        If dt.Rows.Count > 0 Then
            Return False
        Else
            Return True
        End If

    End Function
    <WebMethod()> _
    Public Function isValidRenewal(ByVal FileName As String) As Boolean
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim sSQL As String = ""

        Dim FilePath As String = Server.MapPath(ConfigurationManager.AppSettings("FromPhone_Renewal"))

        sSQL = "uspIsValidRenewal"

        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.StoredProcedure

        cmd.Parameters.Add("@FileName", SqlDbType.VarChar, 100).Value = FilePath & FileName
        cmd.Parameters.Add("@RV", SqlDbType.Int)
        cmd.Parameters("@RV").Direction = ParameterDirection.ReturnValue

        If con.State = ConnectionState.Closed Then con.Open()

        cmd.ExecuteScalar()

        Dim rv As Integer = cmd.Parameters("@RV").Value

        'Dim da As New SqlDataAdapter(cmd)
        'Dim dt As New DataTable
        'da.Fill(dt)

        If rv = 0 Then
            Return True
        Else
            MoveFileToRejectedFolder(Server.MapPath(ConfigurationManager.AppSettings("FromPhone_Renewal") & FileName & ""), Server.MapPath(ConfigurationManager.AppSettings("FromPhone_Renewal_Rejected")))
            'MoveFileToRejectedFolder(Server.MapPath("\Dev\FromPhone\Renewal\" & FileName & ""), Server.MapPath("\Dev\FromPhone\Renewal\Rejected\"))
            Return False
        End If

    End Function
    <WebMethod()> _
    Public Function isValidClaim(ByVal FileName As String) As Boolean

        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim sSQL As String = ""

        Dim FilePath As String = Server.MapPath(ConfigurationManager.AppSettings("FromPhone_Claim")) '"c:/inetpub/wwwroot/IMIS/FromPhone/Claim/"

        sSQL = "uspUpdateClaimFromPhone"

        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.StoredProcedure

        cmd.Parameters.Add("@FileName", SqlDbType.VarChar, 100).Value = FilePath & FileName
        cmd.Parameters.Add("@ByPassSubmit", SqlDbType.Bit).Value = True
        cmd.Parameters.Add("@Result", SqlDbType.Int).Direction = ParameterDirection.ReturnValue

        If con.State = ConnectionState.Closed Then con.Open()

        cmd.ExecuteNonQuery()

        If cmd.Parameters("@Result").Value = 0 Then
            Return True
        Else
            MoveFileToRejectedFolder(Server.MapPath(ConfigurationManager.AppSettings("FromPhone_Claim") & FileName & ""), Server.MapPath(ConfigurationManager.AppSettings("FromPhone_Claim_Rejected")))
            'MoveFileToRejectedFolder(Server.MapPath("\Dev\FromPhone\Claim\" & FileName & ""), Server.MapPath("\Dev\FromPhone\Claim\Rejected\"))
            Return False
        End If

    End Function
    <WebMethod()> _
    Public Function isValidFeedback(ByVal FileName As String) As Boolean
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim FilePath As String = Server.MapPath(ConfigurationManager.AppSettings("FromPhone_Feedback") & FileName & "")
        Dim con As New SqlConnection(ConStr)
        Dim sSQL As String = "uspInsertFeedback"
        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.StoredProcedure

        cmd.Parameters.Add("@FileName", SqlDbType.VarChar, 100).Value = FilePath
        cmd.Parameters.Add("@Result", SqlDbType.Int).Direction = ParameterDirection.ReturnValue

        If con.State = ConnectionState.Closed Then con.Open()

        cmd.ExecuteNonQuery()

        If cmd.Parameters("@Result").Value = 0 Then
            Return True
        Else
            MoveFileToRejectedFolder(Server.MapPath(ConfigurationManager.AppSettings("FromPhone_Feedback") & FileName & ""), Server.MapPath(ConfigurationManager.AppSettings("FromPhone_Feedback_Rejected")))
            'MoveFileToRejectedFolder(Server.MapPath("\Dev\FromPhone\Feedback\" & FileName & ""), Server.MapPath("\Dev\FromPhone\Feedback\Rejected\"))
            Return False
        End If


    End Function
    <WebMethod()> _
    Public Function isValidPhone(ByVal OfficerCode As String, ByVal PhoneNumber As String) As Boolean
        Try
            Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
            Dim con As New SqlConnection(ConStr)
            Dim sSQL As String = "SELECT 1 FROM tblOfficer WHERE Code = @OfficerCode AND Phone = @Phone AND ValidityTo IS NULL"

            Dim cmd As New SqlCommand(sSQL, con)
            cmd.CommandType = CommandType.Text

            cmd.Parameters.Add("@OfficerCode", SqlDbType.NVarChar, 8).Value = OfficerCode
            cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 16).Value = PhoneNumber

            If con.State = ConnectionState.Closed Then con.Open()

            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable
            da.Fill(dt)

            If dt.Rows.Count > 0 Then Return True Else Return False

        Catch ex As Exception
            Throw ex
        End Try
    End Function
    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getFeedbacksNew(ByVal OfficerCode As String) As String
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim sSQL As String = ""
        sSQL = "SELECT F.ClaimId,F.OfficerId,O.Code OfficerCode, I.CHFID, I.LastName, I.OtherNames, HF.HFCode, HF.HFName,C.ClaimCode,CONVERT(NVARCHAR(10),C.DateFrom,103)DateFrom, CONVERT(NVARCHAR(10),C.DateTo,103)DateTo,O.Phone, CONVERT(NVARCHAR(10),F.FeedbackPromptDate,103)FeedbackPromptDate" & _
               " FROM tblFeedbackPrompt F INNER JOIN tblOfficer O ON F.OfficerId = O.OfficerId" & _
               " INNER JOIN tblClaim C ON F.ClaimId = C.ClaimId" & _
               " INNER JOIN tblInsuree I ON C.InsureeId = I.InsureeId" & _
               " INNER JOIN tblHF HF ON C.HFID = HF.HFID" & _
               " WHERE F.ValidityTo Is NULL AND O.ValidityTo IS NULL" & _
               " AND O.Code = @OfficerCode" & _
               " AND C.FeedbackStatus = 4" 'Commented by Rogers

        Dim cmd As New SqlCommand(sSQL, con)
        If con.State = ConnectionState.Closed Then con.Open()

        cmd.Parameters.Add("@OfficerCode", SqlDbType.NVarChar, 8).Value = OfficerCode
        'cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 16).Value = PhoneNumber

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)
        dt.TableName = "Feedbacks"

        Dim fb As Feedback() = New Feedback(dt.Rows.Count - 1) {}

        Dim jString As String = String.Empty
        Dim i As Integer = 0

        For Each row In dt.Rows
            fb(i) = New Feedback()
            fb(i).ClaimId = row("ClaimId")
            fb(i).OfficerId = row("OfficerId")
            fb(i).OfficerCode = row("OfficerCode").ToString
            fb(i).CHFID = row("CHFID").ToString
            fb(i).LastName = row("LastName").ToString
            fb(i).OtherNames = row("OtherNames").ToString
            fb(i).HFCode = row("HFCode").ToString
            fb(i).HFName = row("HFName").ToString
            fb(i).ClaimCode = row("ClaimCode").ToString
            fb(i).DateFrom = row("DateFrom").ToString
            fb(i).DateTo = row("DateTo").ToString
            fb(i).Phone = row("Phone").ToString
            fb(i).FeedbackPromptDate = row("FeedbackPromptDate").ToString

            i += 1
        Next

        Dim js As New JavaScriptSerializer
        jString = js.Serialize(fb)

        Return jString

    End Function
    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getFeedbacks(ByVal OfficerCode As String, ByVal PhoneNumber As String) As String
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim sSQL As String = ""
        sSQL = "SELECT F.ClaimId,F.OfficerId,O.Code OfficerCode, I.CHFID, I.LastName, I.OtherNames, HF.HFCode, HF.HFName,C.ClaimCode,CONVERT(NVARCHAR(10),C.DateFrom,103)DateFrom, CONVERT(NVARCHAR(10),C.DateTo,103)DateTo,O.Phone, CONVERT(NVARCHAR(10),F.FeedbackPromptDate,103)FeedbackPromptDate" & _
               " FROM tblFeedbackPrompt F INNER JOIN tblOfficer O ON F.OfficerId = O.OfficerId" & _
               " INNER JOIN tblClaim C ON F.ClaimId = C.ClaimId" & _
               " INNER JOIN tblInsuree I ON C.InsureeId = I.InsureeId" & _
               " INNER JOIN tblHF HF ON C.HFID = HF.HFID" & _
               " WHERE F.ValidityTo Is NULL" & _
               " AND O.Code = @OfficerCode" & _
               " AND O.Phone = @Phone" & _
               " AND C.FeedbackStatus = 4"

        Dim cmd As New SqlCommand(sSQL, con)
        If con.State = ConnectionState.Closed Then con.Open()

        cmd.Parameters.Add("@OfficerCode", SqlDbType.NVarChar, 8).Value = OfficerCode
        cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 16).Value = PhoneNumber

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)
        dt.TableName = "Feedbacks"

        Dim fb As Feedback() = New Feedback(dt.Rows.Count - 1) {}

        Dim jString As String = String.Empty
        Dim i As Integer = 0

        For Each row In dt.Rows
            fb(i) = New Feedback()
            fb(i).ClaimId = row("ClaimId")
            fb(i).OfficerId = row("OfficerId")
            fb(i).OfficerCode = row("OfficerCode").ToString
            fb(i).CHFID = row("CHFID").ToString
            fb(i).LastName = row("LastName").ToString
            fb(i).OtherNames = row("OtherNames").ToString
            fb(i).HFCode = row("HFCode").ToString
            fb(i).HFName = row("HFName").ToString
            fb(i).ClaimCode = row("ClaimCode").ToString
            fb(i).DateFrom = row("DateFrom").ToString
            fb(i).DateTo = row("DateTo").ToString
            fb(i).Phone = row("Phone").ToString
            fb(i).FeedbackPromptDate = row("FeedbackPromptDate").ToString

            i += 1
        Next

        Dim js As New JavaScriptSerializer
        jString = js.Serialize(fb)

        Return jString

    End Function
    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getRenewalsNew(ByVal OfficerCode As String) As String
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim sSQL As String = ""
        sSQL += " ;WITH FollowingPolicies AS ("
        sSQL += " SELECT P.PolicyId, P.FamilyId, ISNULL(Prod.ConversionProdId, Prod.ProdId)ProdID, P.StartDate"
        sSQL += " FROM tblPolicy P"
        sSQL += " INNER JOIN tblProduct Prod ON P.ProdId = ISNULL(Prod.ConversionProdId, Prod.ProdId)"
        sSQL += " WHERE P.ValidityTo IS NULL"
        sSQL += " AND Prod.ValidityTo IS NULL )"
        sSQL += " SELECT R.RenewalId,R.PolicyId, O.OfficerId, O.Code OfficerCode, I.CHFID, I.LastName, I.OtherNames, Prod.ProductCode, Prod.ProductName,F.LocationId, V.VillageName, CONVERT(NVARCHAR(10),R.RenewalpromptDate,103)RenewalpromptDate, O.Phone, CONVERT(NVARCHAR(10),Po.EnrollDate,103) EnrollDate,Po.PolicyStage, F.FamilyID, Prod.ProdID FROM tblPolicyRenewals R "
        sSQL += " INNER JOIN tblOfficer O ON R.NewOfficerId = O.OfficerId"
        sSQL += " INNER JOIN tblInsuree I ON R.InsureeId = I.InsureeId"
        sSQL += " LEFT OUTER JOIN tblProduct Prod ON R.NewProdId = Prod.ProdId"
        sSQL += " INNER JOIN tblFamilies F ON I.FamilyId = F.Familyid"
        sSQL += " INNER JOIN tblVillages V ON F.LocationId = V.VillageId"
        sSQL += " INNER JOIN tblPolicy Po ON Po.PolicyID = R.PolicyID"
        sSQL += " LEFT OUTER JOIN FollowingPolicies FP ON FP.FamilyID = F.FamilyId AND FP.ProdId = Po.ProdID AND FP.PolicyId <> R.PolicyID"
        sSQL += " WHERE R.ValidityTo Is NULL"
        sSQL += " AND ISNULL(R.ResponseStatus, 0) = 0"
        sSQL += " AND O.Code = @OfficerCode"
        sSQL += " AND FP.PolicyId IS NULL"
        Dim cmd As New SqlCommand(sSQL, con)

        cmd.Parameters.Add("@OfficerCode", SqlDbType.NVarChar, 8).Value = OfficerCode
        'cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 16).Value = PhoneNumber

        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)
        dt.TableName = "Renewal"

        Dim R As Renewal() = New Renewal(dt.Rows.Count - 1) {}

        Dim JString As String = ""


        Dim i As Integer = 0

        For Each row In dt.Rows
            R(i) = New Renewal()
            R(i).RenewalId = row("RenewalId")
            R(i).PolicyId = row("PolicyId")
            R(i).OfficerId = row("OfficerId")
            R(i).OfficerCode = row("OfficerCode").ToString
            R(i).CHFID = row("CHFID").ToString
            R(i).LastName = row("LastName").ToString
            R(i).OtherNames = row("OtherNames").ToString
            R(i).ProductCode = row("ProductCode").ToString
            R(i).ProductName = row("ProductName").ToString
            R(i).VillageName = row("VillageName").ToString
            R(i).RenewalPromptDate = row("RenewalPromptDate").ToString
            R(i).Phone = row("Phone").ToString
            R(i).LocationId = row("LocationId").ToString
            R(i).FamilyId = row("FamilyId").ToString
            R(i).EnrollDate = row("EnrollDate").ToString
            R(i).PolicyStage = row("PolicyStage").ToString
            R(i).ProdId = row("ProdId").ToString
            R(i).PolicyValue = getPolicyValue(R(i).FamilyId, R(i).ProdId, 0, R(i).PolicyStage, R(i).EnrollDate, R(i).PolicyId)
            i += 1
        Next

        Dim js As New JavaScriptSerializer
        JString = js.Serialize(R)

        Return JString
    End Function
    <WebMethod()> _
   <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getRenewals(ByVal OfficerCode As String, ByVal PhoneNumber As String) As String
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim sSQL As String = ""
        sSQL = "SELECT R.RenewalId,R.PolicyId, O.OfficerId, O.Code OfficerCode, I.CHFID, I.LastName, I.OtherNames, Prod.ProductCode, Prod.ProductName, V.VillageName, CONVERT(NVARCHAR(10),R.RenewalpromptDate,103)RenewalpromptDate, O.Phone" & _
               " FROM tblPolicyRenewals R INNER JOIN tblOfficer O ON R.NewOfficerId = O.OfficerId" & _
               " INNER JOIN tblInsuree I ON R.InsureeId = I.InsureeId" & _
               " LEFT OUTER JOIN tblProduct Prod ON R.NewProdId = Prod.ProdId" & _
               " INNER JOIN tblFamilies F ON I.FamilyId = F.Familyid" & _
               " INNER JOIN tblVillages V ON F.LocationId = V.VillageId" & _
               " WHERE R.ValidityTo Is NULL" & _
               " AND R.ResponseStatus = 0" & _
               " AND O.Code = @OfficerCode" & _
               " AND O.Phone = @Phone"

        Dim cmd As New SqlCommand(sSQL, con)

        cmd.Parameters.Add("@OfficerCode", SqlDbType.NVarChar, 8).Value = OfficerCode
        cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 16).Value = PhoneNumber

        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)
        dt.TableName = "Renewal"

        Dim R As Renewal() = New Renewal(dt.Rows.Count - 1) {}

        Dim JString As String = ""


        Dim i As Integer = 0

        For Each row In dt.Rows
            R(i) = New Renewal()
            R(i).RenewalId = row("RenewalId")
            R(i).PolicyId = row("PolicyId")
            R(i).OfficerId = row("OfficerId")
            R(i).OfficerCode = row("OfficerCode").ToString
            R(i).CHFID = row("CHFID").ToString
            R(i).LastName = row("LastName").ToString
            R(i).OtherNames = row("OtherNames").ToString
            R(i).ProductCode = row("ProductCode").ToString
            R(i).ProductName = row("ProductName").ToString
            R(i).VillageName = row("VillageName").ToString
            R(i).RenewalPromptDate = row("RenewalPromptDate").ToString

            R(i).Phone = row("Phone").ToString

            i += 1
        Next

        Dim js As New JavaScriptSerializer
        JString = js.Serialize(R)

        Return JString
    End Function
    <WebMethod()> _
    Public Sub DiscontinuePolicy(ByVal RenewalId As Integer)
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim sSQL As String = ""
        sSQL = "UPDATE tblPolicyRenewals SET ResponseStatus = 2, ResponseDate = GETDATE() WHERE RenewalId = @RenewalId"

        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.Text
        cmd.Parameters.Add("@RenewalId", SqlDbType.Int).Value = RenewalId
        If con.State = ConnectionState.Closed Then con.Open()
        cmd.ExecuteNonQuery()

    End Sub
    Private Sub MoveFileToRejectedFolder(ByVal OrginalFile As String, ByVal DestinationFolder As String)
        On Error Resume Next
        File.Move(OrginalFile, DestinationFolder & Mid(OrginalFile, OrginalFile.LastIndexOf("\") + 2, OrginalFile.Length))
    End Sub
    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function GetClaimStats(HFCode As String, ClaimAdmin As String, FromDate As Date, ToDate As String) As String
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand("uspGetClaimStats", con)
        cmd.CommandType = CommandType.StoredProcedure

        cmd.Parameters.Add("@HFCode", SqlDbType.VarChar, 8).Value = HFCode
        cmd.Parameters.Add("@ClaimAdmin", SqlDbType.VarChar, 8).Value = ClaimAdmin
        cmd.Parameters.Add("@FromDate", SqlDbType.Date).Value = FromDate
        cmd.Parameters.Add("@ToDate", SqlDbType.Date).Value = ToDate

        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)
        dt.TableName = "dtClaimStats"

        Dim jString As String = GetJsonFromDt(dt)

        Return jString

    End Function
    Private Function GetJsonFromDt(dt As DataTable) As String
        Dim json As String = String.Empty
        Dim js As New JavaScriptSerializer
        js.MaxJsonLength = Integer.MaxValue
        json = js.Serialize(From dr As DataRow In dt.Rows Select dt.Columns.Cast(Of DataColumn)().ToDictionary(Function(Col) Col.ColumnName, Function(Col) dr(Col)))
        Return json
    End Function
    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function GetFeedbackStats(OfficerCode As String, FromDate As Date, ToDate As Date) As String
        Dim sSQL As String = String.Empty
        sSQL = "SELECT ISNULL(SUM(1),0) FeedbackSent, ISNULL(SUM(CASE DocStatus WHEN N'A' THEN 1 ELSE 0 END),0) FeedbackAccepted"
        sSQL += " FROM tblFromPhone"
        sSQL += " WHERE DocType = N'F'"
        sSQL += " AND OfficerCode = @OfficerCode"
        sSQL += " AND CAST(LandedDate AS DATE) BETWEEN @FromDate AND @ToDate"


        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.Text

        cmd.Parameters.Add("@OfficerCode", SqlDbType.VarChar, 8).Value = OfficerCode
        cmd.Parameters.Add("@FromDate", SqlDbType.Date).Value = FromDate
        cmd.Parameters.Add("@ToDate", SqlDbType.Date).Value = ToDate

        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)
        dt.TableName = "dtFeedbackStats"

        Dim jString As String = GetJsonFromDt(dt)

        Return jString

    End Function
    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function GetRenewalStats(OfficerCode As String, FromDate As Date, ToDate As Date) As String
        Dim sSQL As String = String.Empty
        sSQL = "SELECT COUNT(1) RenewalSent, ISNULL(SUM(CASE DocStatus WHEN N'A' THEN 1 ELSE 0 END),0) RenewalAccepted"
        sSQL += " FROM tblFromPhone"
        sSQL += " WHERE DocType = N'R'"
        sSQL += " AND OfficerCode = @OfficerCode"
        sSQL += " AND CAST(LandedDate AS DATE) BETWEEN @FromDate AND @ToDate"


        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.Text

        cmd.Parameters.Add("@OfficerCode", SqlDbType.VarChar, 8).Value = OfficerCode
        cmd.Parameters.Add("@FromDate", SqlDbType.Date).Value = FromDate
        cmd.Parameters.Add("@ToDate", SqlDbType.Date).Value = ToDate

        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)
        dt.TableName = "dtRenewalStats"

        Dim jString As String = GetJsonFromDt(dt)

        Return jString


    End Function
    <WebMethod()> _
    Public Sub InsertPhotoEntry(FileName As String, CHFID As String, OfficerCode As String)
        Dim sSQL As String = String.Empty
        sSQL = "IF NOT EXISTS(SELECT 1 FROM tblFromPhone WHERE DocName = @FileName)"
        sSQL += "INSERT INTO tblFromPhone(DocType, DocName, OfficerCode, CHFID)"
        sSQL += " SELECT N'E' DocType, @FileName DocName, @OfficerCode OfficerCode, @CHFID CHFID"


        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.Text

        cmd.Parameters.Add("@FileName", SqlDbType.NVarChar, 100).Value = FileName
        cmd.Parameters.Add("@CHFID", SqlDbType.NVarChar, 12).Value = CHFID
        cmd.Parameters.Add("@OfficerCode", SqlDbType.NVarChar, 8).Value = OfficerCode

        If con.State = ConnectionState.Closed Then con.Open()

        cmd.ExecuteReader()

    End Sub
    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function GetEnrolmentStats(OfficerCode As String, FromDate As String, ToDate As String) As String
        Dim sSQL As String = String.Empty
        sSQL = "SELECT ISNULL(SUM(1),0) TotalSubmitted, ISNULL(SUM(CASE WHEN Pic.PhotoFileName IS NULL THEN 0 ELSE 1 END),0) TotalAssigned"
        sSQL += " FROM tblFromPhone Ph INNER JOIN tblOfficer O ON Ph.OfficerCode = O.Code"
        sSQL += " OUTER APPLY(SELECT PhotoFileName FROM tblPhotos P WHERE P.validityTo IS NULL AND P.PhotoFileName = Ph.DocName AND P.OfficerID = O.OfficerID)Pic"
        sSQL += " WHERE CAST(Ph.LandedDate AS DATE) BETWEEN @FromDate AND @ToDate"
        sSQL += " AND O.ValidityTo IS NULL"
        sSQL += " AND DocType = N'E'"
        sSQL += " AND OfficerCode = @OfficerCode"

        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand(sSQL, con)
        cmd.CommandType = CommandType.Text

        cmd.Parameters.Add("@OfficerCode", SqlDbType.VarChar, 8).Value = OfficerCode
        cmd.Parameters.Add("@FromDate", SqlDbType.Date).Value = FromDate
        cmd.Parameters.Add("@ToDate", SqlDbType.Date).Value = ToDate

        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)
        dt.TableName = "dtEnrolmentStats"

        Dim jString As String = GetJsonFromDt(dt)

        Return jString


    End Function
    <WebMethod()> _
    Public Function CheckServerPath(ByVal PathToGo As String) As String
        Dim WithClaim As String = Server.MapPath(PathToGo)


        Return WithClaim

    End Function

    <WebMethod()> _
    Public Function checkAppSettings(ByVal SettingName As String) As String
        Dim SettingValue As String = ConfigurationManager.AppSettings(SettingName)
        Return SettingValue
    End Function

    <WebMethod> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function GetPayers(OfficerCode As String) As String
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim sSQL As String = ""

        sSQL = "SELECT P.PayerId, P.PayerType, PayDesc.PayerTypeDescription, P.PayerName, @OfficerCode OfficerCode"
        sSQL += " FROM tblPayer P LEFT OUTER JOIN tblOfficer O ON P.LocationId = O.LocationId AND O.Code = @OfficerCode"
        sSQL += " INNER JOIN (VALUES('G', 'Government'),('L','Local Authority'),('C','Co-operative'),('P','Private organization'),('D','Donor'),('O','Other')) PayDesc(PayerType,PayerTypeDescription)  ON PayDesc.PayerType = P.PayerType"
        sSQL += " WHERE P.ValidityTo IS NULL"
        sSQL += " AND O.ValidityTo IS NULL"
        sSQL += " AND (P.LocationId = O.LocationId OR P.LocationId IS NULL)"
        sSQL += " ORDER BY P.PayerName"

        Dim cmd As New SqlCommand(sSQL, con)
        If con.State = ConnectionState.Closed Then con.Open()

        cmd.Parameters.Add("@OfficerCode", SqlDbType.NVarChar, 8).Value = OfficerCode

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)
        dt.TableName = "Payers"

        Dim r As DataRow = dt.NewRow
        r("PayerId") = 0
        r("PayerType") = ""
        r("PayerTypeDescription") = ""
        r("PayerName") = "Self payment"
        r("OfficerCode") = OfficerCode

        dt.Rows.InsertAt(r, 0)

        Dim Pay As Payers() = New Payers(dt.Rows.Count - 1) {}

        Dim jString As String = String.Empty
        Dim i As Integer = 0

        For Each row As DataRow In dt.Rows
            Pay(i) = New Payers
            Pay(i).PayerId = row("PayerId")
            Pay(i).PayerType = row("PayerType").ToString
            Pay(i).PayerTypeDescription = row("PayerTypeDescription").ToString
            Pay(i).PayerName = row("PayerName").ToString
            Pay(i).OfficerCode = row("OfficerCode").ToString

            i += 1
        Next

        Dim js As New JavaScriptSerializer
        jString = js.Serialize(Pay)

        Return jString

    End Function


    <WebMethod> _
    Public Function CreatePhoneExtracts(ByVal DistrictId As Integer, ByVal UserId As Integer, ByVal WithInsuree As Boolean) As Boolean
        Dim sp As New Stopwatch
        sp.Start()

        Dim Extracts As New PhoneExtracts
        Dim eExtractInfo As New eExtractInfo

        eExtractInfo.DistrictID = DistrictId
        eExtractInfo.AuditUserID = UserId
        eExtractInfo.WithInsuree = WithInsuree

        If Len(DistrictId) = 0 Then

        End If
        Dim dtUser As DataTable = GetUserDetails(UserId)
        Dim Host As String = Web.Configuration.WebConfigurationManager.AppSettings.Get("Host") 'GetMainHost()
        If dtUser.Rows.Count = 0 Then Exit Function
        Dim FolderPath As String = Server.MapPath(ConfigurationManager.AppSettings("Extracts_Phone"))


        Dim FileName As String = Extracts.CreatePhoneExtracts(eExtractInfo, WithInsuree, FolderPath)
        Dim UserName As String = dtUser(0)("UserName").ToString
        Dim UserEmail As String = dtUser(0)("EmailId").ToString

        Dim Dict As New Dictionary(Of String, String)
        Dict.Add("@@Name", UserName)
        Dict.Add("@@Host", Host)
        Dict.Add("@@FileName", FileName)
        Dict.Add("UserEmail", UserEmail)
        'eExtractInfo.DistrictID = DistrictId ' Commected By Rogers
        'eExtractInfo.AuditUserID = UserId
        eExtractInfo.ExtractType = 1
        Dim TemplatePath As String = HttpContext.Current.Server.MapPath("\") & "Templates\PhoneExtract.html"
        Dim EmailSubject As String = "Phone Extract is ready to download"
        ' Dim EmailMessage = "Phone extract is ready to download"
        

        sp.Stop()

        Dim ts As TimeSpan = sp.Elapsed

        Dim TimeElapsed As String = String.Format("{0:00}:{1:00}:{2:00}", ts.Hours, ts.Minutes, ts.Seconds)


        If eExtractInfo.ExtractStatus = 0 Then
            If FileName.Trim.Length > 0 Then
                SendEmail(FileName, UserId, TemplatePath, EmailSubject, Dict)
            End If
        End If
        Return True
    End Function

    'added by amani 28/09
    <WebMethod> _
    Public Function CreateOfflineExtract(ByVal RegionId As Integer, ByVal DistrictId As Integer, ByVal UserId As Integer, ByVal WithInsuree As Boolean, ByVal ChkFullExtract As Boolean) As Boolean

        Dim Extracts As New OffLineExtracts
        Dim eExtractInfo As New eExtractInfo
        Dim Extract As New IMISExtractsDAL
        Dim eExtract As New tblExtracts
        ' Dim EmailMessage = "Offline extract is ready to download"
        Dim FolderPath As String = Server.MapPath(ConfigurationManager.AppSettings("Extracts_Offline"))
        eExtractInfo.WithInsuree = WithInsuree
        eExtractInfo.DistrictID = DistrictId
        eExtractInfo.RegionID = RegionId
        eExtractInfo.AuditUserID = UserId
        eExtractInfo.ExtractType = 4


        If eExtractInfo.DistrictID = 0 Then
            eExtractInfo.ExtractSequence = Extract.NewSequenceNumber(eExtractInfo.RegionID)
        Else
            eExtractInfo.ExtractSequence = Extract.NewSequenceNumber(eExtractInfo.DistrictID)
        End If


        Dim dtUser As DataTable = GetUserDetails(UserId)

        If dtUser.Rows.Count = 0 Then Exit Function

        Dim UserName As String = dtUser(0)("UserName").ToString
        Dim UserEmail As String = dtUser(0)("EmailId").ToString

        Dim Dict As New Dictionary(Of String, String)
        Dict.Add("@@Name", UserName)
        Dict.Add("UserEmail", UserEmail)
        Dim TemplatePath As String = HttpContext.Current.Server.MapPath("\") & "Templates\OfflineExtract.html"
        Dim EmailSubject As String = "Extract is ready to download"
        If ChkFullExtract = True Then
            'for differential extract first
            eExtractInfo.ExtractType = 4
            Dim FileName As String = Extracts.CreateOffLineExtracts(eExtractInfo, FolderPath)
            'for only full extract then
            eExtractInfo.ExtractType = 2

            
            Dim FullExtractFileName As String = Extracts.CreateOffLineExtracts(eExtractInfo, FolderPath)
            If eExtractInfo.ExtractStatus = 0 Then
                If FileName.Trim.Length > 0 Then
                    SendEmail(FullExtractFileName, UserId, TemplatePath, EmailSubject, Dict)
                End If
            End If
        Else
            'for differential extract only
            eExtractInfo.ExtractType = 4
            Dim FileName As String = Extracts.CreateOffLineExtracts(eExtractInfo, FolderPath)
            If eExtractInfo.ExtractStatus = 0 Then
                If FileName.Trim.Length > 0 Then
                    SendEmail(FileName, UserId, TemplatePath, EmailSubject, Dict)
                End If
            End If
        End If
        Return True


    End Function
    'Old function for sending email
    Public Sub SendEmail(FileName As String, UserId As Integer, TemplatePath As String, EmailSubject As String, Dict As Dictionary(Of String, String))

        Dim LogFile As String = Server.MapPath(ConfigurationManager.AppSettings("Extracts_Phone")) & "EmailLog.txt"
        If Not My.Computer.FileSystem.FileExists(LogFile) Then
            My.Computer.FileSystem.WriteAllText(LogFile, "Sending Email..." & vbNewLine, False)
        End If

        Dim Email As New EmailHandler
      
        My.Computer.FileSystem.WriteAllText(LogFile, vbNewLine & vbNewLine & "EmailID: " & Dict("UserEmail") & "" & vbNewLine, True)

        If Dict("UserEmail").Trim.Length = 0 Then Exit Sub

        Dim Host As String = Web.Configuration.WebConfigurationManager.AppSettings.Get("Host") 'GetMainHost()

        My.Computer.FileSystem.WriteAllText(LogFile, "Host: " & Host & "" & vbNewLine, True)



        My.Computer.FileSystem.WriteAllText(LogFile, "FileName: " & FileName & "" & vbNewLine, True)

        ' Dim TemplatePath As String = HttpContext.Current.Server.MapPath("\") & "Templates\PhoneExtract.html"
        'Dim TemplatePath As String = Server.MapPath("\Templates\PhoneExtract.html")

        My.Computer.FileSystem.WriteAllText(LogFile, "Template: " & TemplatePath & "" & vbNewLine, True)

        Email.sendEmail(TemplatePath, Dict("UserEmail"), EmailSubject, Dict, Nothing, "", "", "")
    End Sub

    ''new function by Amani 28/09
    '<WebMethod> _
    'Public Sub SendEmail(FileName As String, UserId As Integer, FolderPath As String, EmailMessage As String)

    '    Dim LogFile As String = Server.MapPath(FolderPath) & "EmailLog.txt"
    '    If Not My.Computer.FileSystem.FileExists(LogFile) Then
    '        My.Computer.FileSystem.WriteAllText(LogFile, "Sending Email..." & vbNewLine, False)
    '    End If

    '    Dim Email As New EmailHandler
    '    Dim dtUser As DataTable = GetUserDetails(UserId)

    '    If dtUser.Rows.Count = 0 Then Exit Sub

    '    Dim UserName As String = dtUser(0)("UserName").ToString
    '    Dim UserEmail As String = dtUser(0)("EmailId").ToString

    '    My.Computer.FileSystem.WriteAllText(LogFile, vbNewLine & vbNewLine & "EmailID: " & UserEmail & "" & vbNewLine, True)

    '    If UserEmail.Trim.Length = 0 Then Exit Sub

    '    Dim Host As String = Web.Configuration.WebConfigurationManager.AppSettings.Get("Host") 'GetMainHost()

    '    My.Computer.FileSystem.WriteAllText(LogFile, "Host: " & Host & "" & vbNewLine, True)

    '    Dim Dict As New Dictionary(Of String, String)
    '    Dict.Add("@@Host", Host)
    '    Dict.Add("@@Name", UserName)
    '    Dict.Add("@@FileName", FileName)

    '    My.Computer.FileSystem.WriteAllText(LogFile, "FileName: " & FileName & "" & vbNewLine, True)

    '    Dim TemplatePath As String = HttpContext.Current.Server.MapPath("\") & "Templates\PhoneExtract.html"
    '    'Dim TemplatePath As String = Server.MapPath("\Templates\PhoneExtract.html")

    '    My.Computer.FileSystem.WriteAllText(LogFile, "Template: " & TemplatePath & "" & vbNewLine, True)

    '    Email.sendEmail(TemplatePath, UserEmail, EmailMessage, Dict, Nothing, "", "", "")
    'End Sub
    Private Function GetUserDetails(UserId As Integer) As DataTable
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand("SELECT CONCAT(LastName, ' ' ,OtherNames)UserName, EmailId FROM tblUsers WHERE UserID = @UserId", con)
        cmd.CommandType = CommandType.Text
        If con.State = ConnectionState.Closed Then con.Open()

        cmd.Parameters.AddWithValue("@UserId", UserId)

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)

        Return dt
    End Function

    Private Function GetMainHost() As String
        Dim Scheme As String = HttpContext.Current.Request.Url.Scheme
        Dim url As String = HttpContext.Current.Request.Url.Host
        Return String.Format("{0}://{1}", Scheme, url)

    End Function

    'Calculate The policyValue
    <WebMethod>
    Public Function getPolicyValue(ByVal FamilyId As Integer, ByVal ProdId As Integer, ByVal PolicyId As Integer, ByVal PolicyStage As String, ByVal EnrollDate As String, ByVal PreviousPolicyId As Integer) As Double
        Dim data As New SQLHelper
        Dim sSQL As String = "uspPolicyValue"
        data.setSQLCommand(sSQL, CommandType.StoredProcedure)
        data.params("@FamilyId", FamilyId)
        data.params("@ProdId", ProdId)
        data.params("@PolicyId", PolicyId)
        data.params("@PolicyStage", PolicyStage)
        'amani modified 26/02/2018
        data.params("@EnrollDate", Date.ParseExact(EnrollDate, "dd/MM/yyyy", System.Globalization.DateTimeFormatInfo.InvariantInfo))
        data.params("@PreviousPolicyId", PreviousPolicyId)
        Dim dt As DataTable = data.Filldata
        Return dt.Rows(0)("PolicyValue")
    End Function

#Region "Android Front End"
    <WebMethod> _
    Public Function isValidLogin(LoginName As String, Password As String) As Integer
        Dim sSQL As String = ""
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)

        sSQL = " OPEN SYMMETRIC KEY EncryptionKey DECRYPTION BY Certificate EncryptData;" & _
              " SELECT UserID,LoginName, LanguageID, RoleID" & _
              " FROM tblUsers" & _
              " WHERE LoginName = @LoginName" & _
              " AND  CONVERT(NVARCHAR(25), DECRYPTBYKEY(Password)) COLLATE LATIN1_GENERAL_CS_AS = @Password" & _
              " AND ValidityTo is null" & _
              " CLOSE SYMMETRIC KEY EncryptionKey"

        Dim cmd As New SqlCommand(sSQL, con) With {
            .CommandType = CommandType.Text
        }

        cmd.Parameters.Add("@LoginName", SqlDbType.NVarChar, 50).Value = LoginName
        cmd.Parameters.Add("@Password", SqlDbType.NVarChar, 50).Value = Password

        If con.State = ConnectionState.Closed Then con.Open()

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable
        da.Fill(dt)

        If dt.Rows.Count > 0 Then
            If (dt(0)("RoleId") And 1) > 0 Then
                Return dt(0)("UserId")
            Else
                Return 0
            End If
        Else
            Return 0
        End If

        Return 0

    End Function

    Private Function getJsonToDt(json As String) As DataTable

        Dim dt As New DataTable
        Dim js As New JavaScriptSerializer
        Dim dict As Dictionary(Of String, Object) = js.Deserialize(Of Dictionary(Of String, Object))(json)

        If dict(dict.Keys.First).count = 0 Then Return Nothing
        For Each k In dict(dict.Keys.First)(0).keys
            dt.Columns.Add(k)
        Next


        For i As Integer = 0 To dict(dict.Keys.First).count - 1
            Dim d As Dictionary(Of String, Object) = dict(dict.Keys.First)(i)
            Dim dr As DataRow = dt.NewRow
            For Each kv In d
                dr(kv.Key) = kv.Value
            Next
            dt.Rows.Add(dr)
        Next

        Return dt
    End Function


    <WebMethod>
    Public Function EnrollFamily(Family As String, Insuree As String, Policy As String, Premium As String, OfficerId As Integer, UserId As Integer, Pictures() As InsureeImages) As Integer


        Dim sSQL As String = ""
        Dim ConStr As String = ConfigurationManager.ConnectionStrings("CHF_CENTRALConnectionString").ConnectionString.ToString
        Dim con As New SqlConnection(ConStr)
        Dim cmd As New SqlCommand()

        Try

            Dim dtFamily As DataTable = getJsonToDt(Family)
            Dim dtInsuree As DataTable = getJsonToDt(Insuree)
            Dim dtPolicy As DataTable = getJsonToDt(Policy)
            Dim dtPremium As DataTable = getJsonToDt(Premium)
            'Dim dtPictures As DataTable = getJsonToDt(Pictures)
            ' Dim dtInsureePolicy As DataTable = getJsonToDt(InsureePolicy)

            Dim Writer As New StringWriter

            If Not dtFamily Is Nothing Then dtFamily.TableName = "Family"
            If Not dtInsuree Is Nothing Then dtInsuree.TableName = "Insuree"
            If Not dtPolicy Is Nothing Then dtPolicy.TableName = "Policy"
            If Not dtPremium Is Nothing Then dtPremium.TableName = "Premium"
            ' If Not dtInsureePolicy Is Nothing Then dtInsureePolicy.TableName = "InsureePolicy"

            Dim ds As New DataSet("Enrollment")


            If Not dtFamily Is Nothing Then ds.Tables.Add(dtFamily)
            If Not dtInsuree Is Nothing Then ds.Tables.Add(dtInsuree)
            If Not dtPolicy Is Nothing Then ds.Tables.Add(dtPolicy)
            If Not dtPremium Is Nothing Then ds.Tables.Add(dtPremium)
            ' If Not dtInsureePolicy Is Nothing Then ds.Tables.Add(dtInsureePolicy)
            ds.WriteXml(Writer)

            Dim xmlEnrollment As String = Writer.ToString

            'Save XML for future reference
            Dim EnrollmentDir As String = ConfigurationManager.AppSettings("Enrollment_Phone")
            Dim JsonDebugFolder As String = ConfigurationManager.AppSettings("JsonDebugFolder")
            Dim UpdatedFolder As String = ConfigurationManager.AppSettings("UpdatedFolder")
            Dim hof As String = ""
            If dtInsuree IsNot Nothing Then
                If dtInsuree.Select("isHead = '1' OR isHead = 'true'").Count > 0 Then
                    hof = dtInsuree.Select("isHead = '1' OR isHead = 'true'")(0)("CHFID").ToString
                Else
                    hof = "Unknown"
                End If
            End If

            Dim JsonContents As String = String.Empty
            JsonContents += "Family: "
            JsonContents += vbCrLf
            JsonContents += Family
            JsonContents += vbCrLf
            JsonContents += vbCrLf

            JsonContents += "Insuree: "
            JsonContents += vbCrLf
            JsonContents += Insuree
            JsonContents += vbCrLf
            JsonContents += vbCrLf

            JsonContents += "Policy: "
            JsonContents += vbCrLf
            JsonContents += Policy
            JsonContents += vbCrLf
            JsonContents += vbCrLf

            JsonContents += "Premium: "
            JsonContents += vbCrLf
            JsonContents += Premium
            JsonContents += vbCrLf
            JsonContents += vbCrLf

            JsonContents += "OfficerId: "
            JsonContents += vbCrLf
            JsonContents += OfficerId.ToString()
            JsonContents += vbCrLf
            JsonContents += vbCrLf


            JsonContents += "UserId: "
            JsonContents += vbCrLf
            JsonContents += UserId.ToString()


            Dim FileName As String = String.Format("{0}_{1}_{2}.xml", hof, OfficerId.ToString, Format(Now, "dd-MM-yyyy HH-mm-ss"))
            Dim JsonFileName As String = String.Format("{0}_{1}_{2}.txt", hof, OfficerId.ToString, Format(Now, "dd-MM-yyyy HH-mm-ss"))
            Try
                My.Computer.FileSystem.WriteAllText(Server.MapPath(EnrollmentDir) & FileName, xmlEnrollment, False)
                If System.IO.Directory.Exists(Server.MapPath(JsonDebugFolder)) Then
                    My.Computer.FileSystem.WriteAllText(Server.MapPath(JsonDebugFolder) & JsonFileName, JsonContents, False)
                Else
                    System.IO.Directory.CreateDirectory(Server.MapPath(JsonDebugFolder))
                    My.Computer.FileSystem.WriteAllText(Server.MapPath(JsonDebugFolder) & JsonFileName, JsonContents, False)
                End If

                'For i As Int16 = 0 To dtPictures.Rows.Count
                '    Dim temp As Byte()
                '    temp = System.Text.Encoding.Unicode.GetBytes(dtPictures.Rows(i)("values").ToString())

                'Next

                If Not Directory.Exists(Server.MapPath(UpdatedFolder)) Then
                    Directory.CreateDirectory(Server.MapPath(UpdatedFolder))
                End If

                'Dim updatedFolder As String = 

                For Each picture In Pictures
                    If Not picture Is Nothing Then
                        If picture.ImageContent.Length = 0 Then Continue For
                        File.WriteAllBytes(Server.MapPath(UpdatedFolder) & Path.DirectorySeparatorChar & picture.ImageName, picture.ImageContent)
                    End If
                Next


            Catch ex As Exception

            End Try

            sSQL = "uspUploadEnrolmentFromPhone"
            cmd = New SqlCommand(sSQL, con) With {
                .CommandType = CommandType.StoredProcedure
            }

            cmd.Parameters.Add("@xml", SqlDbType.Xml).Value = xmlEnrollment
            cmd.Parameters.Add("@OfficerId", SqlDbType.Int).Value = OfficerId
            cmd.Parameters.Add("@AuditUserId", SqlDbType.Int).Value = UserId
            cmd.Parameters.Add("@ErrorMessage", SqlDbType.NVarChar, 200).Value = ""
            cmd.Parameters("@ErrorMessage").Direction = ParameterDirection.Output
            cmd.Parameters.Add("@RV", SqlDbType.Int).Value = -99
            cmd.Parameters("@RV").Direction = ParameterDirection.ReturnValue

            If con.State = ConnectionState.Closed Then con.Open()

            cmd.ExecuteScalar()

            Dim ErrorMessage As String = cmd.Parameters("@ErrorMessage").Value.ToString
            Dim RV As Integer = cmd.Parameters("@RV").Value
            Return RV

        Catch ex As Exception
            Throw New Exception(ex.Message)
        Finally
            cmd = Nothing
            con.Close()
            con = Nothing
        End Try
    End Function

    Private Function getConfirmationTypes() As DataTable
        Dim sSQL As String = "SELECT ConfirmationTypeCode, ConfirmationType, SortOrder, AltLanguage FROM tblConfirmationTypes"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "ConfirmationTypes"
        Return dt
    End Function
    Private Function getControls() As DataTable
        Dim sSQL As String = "SELECT FieldName, Adjustibility FROM tblControls"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Controls"
        Return dt
    End Function
    Private Function getEducations() As DataTable
        Dim sSQL As String = "SELECT EducationId, Education, SortOrder, AltLanguage FROM tblEducations"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Educations"
        Return dt
    End Function
    Private Function getFamilyTypes() As DataTable
        Dim sSQL As String = "SELECT FamilyTypeCode, FamilyType, SortOrder, AltLanguage FROM tblFamilyTypes"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "FamilyTypes"
        Return dt
    End Function
    Private Function getHFs() As DataTable
        Dim sSQL As String = "SELECT HFID, HFCode, HFName, LocationId, HFLevel FROM tblHF WHERE ValidityTo IS NULL"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "HF"
        Return dt
    End Function
    Private Function getIdentificationTypes() As DataTable
        Dim sSQL As String = "SELECT IdentificationCode, IdentificationTypes, SortOrder, AltLanguage FROM tblIdentificationTypes"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "IdentificationTypes"
        Return dt
    End Function
    Private Function getLanguages() As DataTable
        Dim sSQL As String = "SELECT LanguageCode, LanguageName, SortOrder FROM tblLanguages"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Languages"
        Return dt
    End Function
    Private Function getLocations() As DataTable
        Dim sSQL As String = "SELECT LocationId, LocationCode, LocationName, ParentLocationId, LocationType FROM tblLocations WHERE ValidityTo IS NULL AND NOT(LocationName='Funding' OR LocationCode='FR' OR LocationCode='FD' OR LocationCode='FW' OR LocationCode='FV')"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Locations"
        Return dt
    End Function
    Private Function getOfficers() As DataTable
        Dim sSQL As String = "SELECT OfficerId, Code, LastName, OtherNames, Phone, LocationId, OfficerIDSubst, FORMAT(WorksTo, 'yyyy-MM-dd')WorksTo FROM tblOfficer WHERE ValidityTo IS NULL"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Officers"
        Return dt
    End Function
    Private Function getPayers() As DataTable
        Dim sSQL As String = "SELECT payerId, PayerName, LocationId FROM tblPayer WHERE ValidityTo IS NULL"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Payers"
        Return dt
    End Function
    Private Function getProducts() As DataTable
        Dim sSQL As String = ""
        sSQL = "SELECT ProdId, ProductCode, ProductName, LocationId, InsurancePeriod, FORMAT(DateFrom, 'yyyy-MM-dd')DateFrom, FORMAT(DateTo, 'yyyy-MM-dd')DateTo, ConversionProdId , Lumpsum,"
        sSQL += " MemberCount, PremiumAdult, PremiumChild, RegistrationLumpsum, RegistrationFee, GeneralAssemblyLumpSum, GeneralAssemblyFee,"
        sSQL += " StartCycle1, StartCycle2, StartCycle3, StartCycle4, GracePeriodRenewal, MaxInstallments, WaitingPeriod, Threshold,"
        sSQL += " RenewalDiscountPerc, RenewalDiscountPeriod, AdministrationPeriod, EnrolmentDiscountPerc, EnrolmentDiscountPeriod, GracePeriod"
        sSQL += " FROM tblProduct WHERE ValidityTo IS NULL"

        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Products"
        Return dt
    End Function
    Private Function getProfessions() As DataTable
        Dim sSQL As String = "SELECT ProfessionId, Profession, SortOrder, AltLanguage FROM tblProfessions"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Professions"
        Return dt
    End Function
    Private Function getRelations() As DataTable
        Dim sSQL As String = "SELECT Relationid, Relation, SortOrder, AltLanguage FROM tblRelations"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Relations"
        Return dt
    End Function

    Private Function GetPhoneDefaults() As DataTable
        Dim sSQL As String = "SELECT RuleName, RuleValue FROM tblIMISDetaulsPhone;"
        Dim data As New SQLHelper
        data.setSQLCommand(sSQL, CommandType.Text)
        Dim dt As DataTable = data.Filldata
        dt.TableName = "PhoneDefaults"
        Return dt
    End Function


    'Function added by Rogers for geting

    '--Families to modify
    Private Function getFamilies(ByVal FamilyId As Integer) As DataTable
        Dim sSQL As String = ""
        Dim data As New SQLHelper
        sSQL = " SELECT F.FamilyId, I.InsureeId, LocationId, Poverty, FamilyType, FamilyAddress, Ethnicity, ConfirmationNo, ConfirmationType,"
        sSQL += " CAST(IsHead AS INT)IsHead, 0 isOffline"
        sSQL += " FROM tblFamilies F"
        sSQL += " INNER JOIN tblInsuree I ON I.FamilyID =F.FamilyID"
        sSQL += " WHERE F.ValidityTo IS NULL AND I.ValidityTo IS NULL AND F.FamilyID =@FamilyId AND  I.IsHead = 1"
        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@FamilyId", FamilyId)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Families"
        Return dt
    End Function

    '--Insuree to modify
    Private Function getInsurees(ByVal FamilyId As Integer) As DataTable
        Dim sSQL As String = ""
        Dim data As New SQLHelper
        sSQL = "SELECT ISNULL(I.Passport,'') IdentificationNumber, I.InsureeId, FamilyId, I.CHFID, LastName, OtherNames,  FORMAT(DOB, 'yyyy-MM-dd') DOB, Gender, Marital, CAST(IsHead AS INT)IsHead, ISNULL(Phone,'') Phone, CAST(CardIssued AS INT)CardIssued, Relationship,"
        sSQL += " ISNULL(Profession,'')Profession, ISNULL(Education,'')Education, ISNULL(Email,'')Email, TypeOfId, HFID, ISNULL(CurrentAddress,'')CurrentAddress, GeoLocation, CurrentVillage CurVillage, PhotoFileName PhotoPath,"
        sSQL += " id.IdentificationTypes, 0 isOffline"
        sSQL += " FROM tblInsuree I"
        sSQL += " LEFT JOIN tblPhotos P ON P.PhotoID = I.PhotoID"
        sSQL += " LEFT JOIN tblIdentificationTypes Id ON Id.IdentificationCode = I.TypeOfId"
        sSQL += " WHERE I.ValidityTo IS NULL"
        sSQL += " AND P.ValidityTo IS NULL"
        ' sSQL += " AND (I.CHFID = @CHFID OR IsHead = 1)"
        sSQL += " AND FamilyID = @FamilyId"

        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@FamilyId", FamilyId)
        ' data.params("@CHFID", CHFID)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Insurees"
        Return dt
    End Function
    '
    '--Policy to Modify
    Private Function getPolicy(ByVal FamilyId As Integer, CHFID As Integer)
        Dim sSQL As String = ""
        Dim data As New SQLHelper

        sSQL = " SELECT PolicyId, FamilyId,  FORMAT(EnrollDate, 'yyyy-MM-dd') EnrollDate, FORMAT(StartDate, 'yyyy-MM-dd') StartDate, FORMAT(EffectiveDate, 'yyyy-MM-dd')  EffectiveDate, FORMAT(ExpiryDate, 'yyyy-MM-dd') ExpiryDate, PolicyStatus, PolicyValue, ProdId,"
        sSQL += " OfficerId, PolicyStage, 0 isOffline"
        sSQL += " FROM tblPolicy"
        sSQL += " WHERE  ValidityTo IS NULL AND FamilyID = @FamilyId"

        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@FamilyId", FamilyId)
        data.params("@CHFID", CHFID)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Policies"
        Return dt
    End Function
    'Policy Insuree
    Private Function getInsureePolicy(ByVal FamilyId As Integer, CHFID As Integer) As DataTable
        Dim sSQL As String = ""
        Dim data As New SQLHelper
        sSQL = " SELECT InsureePolicyId, IP.InsureeId,PolicyId, FORMAT(EnrollmentDate, 'yyyy-MM-dd')EnrollmentDate,FORMAT(StartDate, 'yyyy-MM-dd') StartDate, FORMAT(EffectiveDate, 'yyyy-MM-dd') EffectiveDate,FORMAT(ExpiryDate, 'yyyy-MM-dd') ExpiryDate, 0 isOffline"
        sSQL += " FROM tblInsureePolicy IP"
        sSQL += " INNER JOIN tblInsuree I ON I.InsureeID = IP.InsureeId"
        sSQL += " WHERE IP.ValidityTo IS NULL"
        sSQL += " AND I.ValidityTo  IS NULL"
        sSQL += " AND (I.CHFID = @CHFID OR IsHead = 1)"
        sSQL += " AND FamilyID = @FamilyId"
        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@FamilyId", FamilyId)
        data.params("@CHFID", CHFID)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "InsureePolicies"
        Return dt
    End Function

    '--get Premiums
    Private Function getPremiums(ByVal FamilyId As Integer) As DataTable
        Dim sSQL As String = ""
        Dim data As New SQLHelper
        sSQL += " SELECT PremiumId, P.PolicyId, PayerId, Amount, Receipt,FORMAT(PayDate, 'yyyy-MM-dd')  PayDate, PayType, isPhotoFee ,0 isOffline"
        sSQL += " FROM tblPremium P"
        sSQL += " INNER JOIN tblPolicy Po ON P.PolicyID = Po.PolicyID"
        sSQL += " WHERE Po.ValidityTo IS NULL"
        sSQL += " AND	P.ValidityTo IS NULL"
        sSQL += " AND Po.FamilyID = @FamilyId"
        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@FamilyId", FamilyId)
        Dim dt As DataTable = data.Filldata()
        dt.TableName = "Premiums"
        Return dt
    End Function

    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function downloadMasterData() As String
        Dim dtConfirmationTypes As DataTable = getConfirmationTypes()
        Dim dtControls As DataTable = getControls()
        Dim dtEducations As DataTable = getEducations()
        Dim dtFamilyTypes As DataTable = getFamilyTypes()
        Dim dtHF As DataTable = getHFs()
        Dim dtIdentificationTypes As DataTable = getIdentificationTypes()
        Dim dtLanguages As DataTable = getLanguages()
        Dim dtLocations As DataTable = getLocations()
        Dim dtOfficers As DataTable = getOfficers()
        Dim dtPayers As DataTable = GetPayers()
        Dim dtProducts As DataTable = getProducts()
        Dim dtProfessions As DataTable = getProfessions()
        Dim dtRelations As DataTable = getRelations()
        Dim dtPhoneDefaults As DataTable = GetPhoneDefaults()

        Dim ConfirmationTypes As String = "{""ConfirmationTypes"":" & GetJsonFromDt(dtConfirmationTypes) & "}"
        Dim Controls As String = "{""Controls"":" & GetJsonFromDt(dtControls) & "}"
        Dim Education As String = "{""Education"":" & GetJsonFromDt(dtEducations) & "}"
        Dim FamilyTypes As String = "{""FamilyTypes"":" & GetJsonFromDt(dtFamilyTypes) & "}"
        Dim HF As String = "{""HF"":" & GetJsonFromDt(dtHF) & "}"
        Dim IdentificationTypes As String = "{""IdentificationTypes"":" & GetJsonFromDt(dtIdentificationTypes) & "}"
        Dim Languages As String = "{""Languages"":" & GetJsonFromDt(dtLanguages) & "}"
        Dim Locations As String = "{""Locations"":" & GetJsonFromDt(dtLocations) & "}"
        Dim Officers As String = "{""Officers"":" & GetJsonFromDt(dtOfficers) & "}"
        Dim Payers As String = "{""Payers"":" & GetJsonFromDt(dtPayers) & "}"
        Dim Products As String = "{""Products"":" & GetJsonFromDt(dtProducts) & "}"
        Dim Professions As String = "{""Professions"":" & GetJsonFromDt(dtProfessions) & "}"
        Dim Relations As String = "{""Relations"":" & GetJsonFromDt(dtRelations) & "}"
        Dim PhoneDefaults As String = "{""PhoneDefaults"":" & GetJsonFromDt(dtPhoneDefaults) & "}"


        Dim Json As String = "["
        Json += ConfirmationTypes + ", " + Controls + ", " + Education + ", " + FamilyTypes + ", " + HF + ", " + IdentificationTypes + ", " + Languages + ", " + Locations + ", " +
            Officers + ", " + Payers + ", " + Products + ", " + Professions + ", " + Relations + ", " + PhoneDefaults
        Json += "]"

        Return Json

    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Function DownloadFamilyData(ByVal CHFID As String, ByVal LocationId As Integer) As String
        Dim FamilyId As Integer
        Dim sSQL As String = ""
        Dim data As New SQLHelper


        sSQL = " SELECT F.FamilyID FROM tblInsuree I"
        sSQL += " INNER JOIN tblFamilies F ON F.FamilyID = I.FamilyID"
        sSQL += " INNER JOIN tblVillages V ON V.VillageId = F.LocationId"
        sSQL += " INNER JOIN tblWards    W ON W.WardId = V.WardId"
        sSQL += " INNER JOIN tblDistricts D ON D.DistrictId = W.DistrictId"
        sSQL += " WHERE CHFID =@CHFID"
        sSQL += " AND D.DistrictId = @LocationId AND F.ValidityTo IS NULL"
        sSQL += " AND F.ValidityTo IS NULL"
        sSQL += " AND I.ValidityTo IS NULL"
        sSQL += " AND V.ValidityTo IS NULL"
        sSQL += " AND W.ValidityTo IS NULL"
        sSQL += " AND D.ValidityTo IS NULL"
        'sSQL += " AND I.IsHead = 1"

        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@CHFID", SqlDbType.NVarChar, 12, CHFID)
        data.params("@LocationId", SqlDbType.Int, LocationId)
        Dim dt As DataTable = data.Filldata()
        If dt.Rows.Count = 0 Then Return "[]"
        FamilyId = dt.Rows(0)("FamilyID")



        Dim dtFamilies As DataTable = getFamilies(FamilyId)
        Dim dtInsurees As DataTable = getInsurees(FamilyId)
        'Dim dtPolicy As DataTable = getPolicy(FamilyId, CHFID)
        'Dim dtInsureePolicy As DataTable = getInsureePolicy(FamilyId, CHFID)
        'Dim dtPremiums As DataTable = getPremiums(FamilyId)

        Dim Family As String = "{""Families"":" & GetJsonFromDt(dtFamilies) & "}"
        Dim Insurees As String = "{""Insurees"":" & GetJsonFromDt(dtInsurees) & "}"
        'Dim Policy As String = "{""Policies"":" & GetJsonFromDt(dtPolicy) & "}"
        'Dim InsureePolicy As String = "{""InsureePolicies"":" & GetJsonFromDt(dtInsureePolicy) & "}"
        'Dim Premiums As String = "{""Premiums"":" & GetJsonFromDt(dtPremiums) & "}"

        Dim json As String = "["
        json += Family + ", " + Insurees
        json += "]"
        Return json
    End Function

    <WebMethod>
    Public Function DeleteFromPhone(Id As Integer, AuditUserID As Integer, DeleteInfo As String) As Integer
        Dim sSQL As String = ""
        Dim data As New SQLHelper
        sSQL = "uspDeleteFromPhone"
        data.setSQLCommand(sSQL, CommandType.StoredProcedure)
        data.params("@Id", SqlDbType.Int, Id)
        data.params("@DeleteInfo", SqlDbType.Char, 2, DeleteInfo)
        data.params("@AuditUserID", SqlDbType.Int, AuditUserID)
        data.params("@RV", SqlDbType.Int, 0, ParameterDirection.ReturnValue)
        data.ExecuteCommand()
        Dim RV As Integer = data.sqlParameters("@RV")
        Return RV
    End Function

    <WebMethod>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Function InsureeNumberExist(ByVal CHFID As String) As Boolean
        Dim data As New SQLHelper
        Dim sSQL As String = "SELECT CHFID FROM tblInsuree  WHERE LTRIM(RTRIM(CHFID))=LTRIM(RTRIM(@CHFID))  AND ValidityTo IS NULL"
        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@CHFID", SqlDbType.NVarChar, 120, CHFID)
        Dim dt As DataTable = data.Filldata
        Return dt.Rows.Count > 0
    End Function

#End Region



End Class



