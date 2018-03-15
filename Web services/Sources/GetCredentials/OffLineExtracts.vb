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


Imports System.IO
Imports System.Text
Imports System.Security.Cryptography
Imports System.Data.SqlClient
Imports System.Data.SQLite
Imports System.Web.Configuration.WebConfigurationManager
Imports System.Configuration
Imports System.Web
Imports System.Threading
Imports SevenZip


Public Class OffLineExtracts


    Private Const DB3_PWD As String = "%^Klp)*3"
    Private Const DB_PWD As String = "%^Klp)*3"

    Private Const DESKEY As String = ":-+A7V@="
    Private Const RARPWD As String = ")(#$1HsD"

    Private dtblIn As New DataTable
    Private dtblOut As New DataTable
    Private Proc As New Process


    Public Function GetLastCreateExtractInfo(ByVal LocationId As Integer, ByVal ExtractType As Integer, Optional ByVal ExtractDirection As Integer = 0) As tblExtracts
        Dim Extract As New IMISExtractsDAL
        Return Extract.GetLastCreateExtractInfo(LocationId, ExtractType)

    End Function

    Private Sub Unzip(ByVal strZippedFilename As String, ByVal strDestFolder As String)
        'Dim cmd As String = ""

        ''Folders must have the last '\' character
        ''cmd = "e -o+ -p" & RARPWD & " " & strZippedFilename & " " & strDestFolder
        'cmd = "e -o+ -p" & RARPWD & " """ & strZippedFilename & """ """ & strDestFolder & """"
        'StartProcess(WinRarFolder, cmd)

        Try

            If Not File.Exists(strZippedFilename) Then Exit Sub
            If IntPtr.Size = 8 Then 'If 64 bit
                SevenZipBase.SetLibraryPath(System.AppDomain.CurrentDomain.RelativeSearchPath & "\7z64.dll")
            Else
                SevenZipBase.SetLibraryPath(System.AppDomain.CurrentDomain.RelativeSearchPath & "\7z.dll")
            End If

            Dim Ext As SevenZipExtractor = New SevenZipExtractor(strZippedFilename, RARPWD)
            Ext.ExtractArchive(strDestFolder)

        Catch ex As Exception

            Throw ex
        End Try


    End Sub

    Public Sub Zip(ByVal strDestFolder As String, ByVal strDestFileName As String, ByVal strSrcFolder As String, ByVal strSrcFilter As String)
        Dim cmd As String = ""
        'Folders must have the last '\' character
        'cmd = "a -p" & RARPWD & " """ & strDestFolder & strDestFileName & """ """ & strSrcFolder & strSrcFilter & """"
        'StartProcess(WinRarFolder, cmd)

        If IntPtr.Size = 8 Then 'If 64 bit
            SevenZipBase.SetLibraryPath(System.AppDomain.CurrentDomain.RelativeSearchPath & "\7z64.dll")
        Else
            SevenZipBase.SetLibraryPath(System.AppDomain.CurrentDomain.RelativeSearchPath & "\7z.dll")
        End If

        Dim Compressor As New SevenZipCompressor
        With Compressor
            .ArchiveFormat = OutArchiveFormat.SevenZip
            .CompressionMode = CompressionMode.Create
            .CompressionMethod = CompressionMethod.Default
            .DirectoryStructure = False
            .CompressionLevel = CompressionLevel.Normal
        End With


        'Compressor.CompressFilesEncrypted(strDestFolder & Path.DirectorySeparatorChar & strDestFileName, RARPWD, strSrcFolder)
        If Directory.EnumerateFiles(strSrcFolder, strSrcFilter).ToArray().Length > 0 Then
            Compressor.CompressFilesEncrypted(strDestFolder & Path.DirectorySeparatorChar & strDestFileName, RARPWD, Directory.EnumerateFiles(strSrcFolder, strSrcFilter).ToArray())
        End If


    End Sub



    Private Sub StartProcess(ByVal WinRarFolder As String, ByVal cmd As String)
        Proc = New Process

        With Proc.StartInfo
            .FileName = WinRarFolder & "WinRAR.exe"
            .Arguments = cmd
            .UseShellExecute = False
            .RedirectStandardOutput = True
            .RedirectStandardError = False
            .CreateNoWindow = False
        End With

        Proc.EnableRaisingEvents = True
        Proc.Start()

        Dim output As String = Proc.StandardOutput.ReadToEnd

        Proc.WaitForExit()





    End Sub



    Private Function StrToBytes(ByVal str As String) As Byte()
        If str <> "" Then
            Dim byt(str.Length - 1) As Byte
            Dim int As Integer = 0
            For Each c As Char In str
                byt(int) = Asc(c)
            Next
            Return byt
        Else
            Return Nothing
        End If
    End Function
    Private Sub Encrypt(ByRef XMLFile As FileStream, ByVal key As String, ByVal outFile As String)
        Dim DESalg As New DESCryptoServiceProvider
        Dim outFs As New FileStream(outFile, FileMode.Create)
        Dim objEncod As Encoding = Encoding.ASCII
        DESalg.Key = objEncod.GetBytes(key)
        DESalg.IV = objEncod.GetBytes("11110000")
        Dim CryFile As New CryptoStream(outFs, DESalg.CreateEncryptor(DESalg.Key, DESalg.IV), CryptoStreamMode.Write)

        Dim BytesRead As Integer = 0
        Dim TransferChuckSize As Integer = 10485760   '10MB
        Dim numTotalBytes As Integer = CType(XMLFile.Length, Integer)
        Dim numTransferredBytes As Integer = 0
        Dim CurrentTransfer As Integer = 0
        ' Dim numBytesToRead As Integer = CType(XMLFile.Length, Integer)
        Dim numBytesRead As Integer = 0
        Dim bytes() As Byte = New Byte(10) {}

        ReDim bytes(0)
        XMLFile.Seek(0, SeekOrigin.Begin)
        'NOW NEED TO SPLIT
        While numTransferredBytes < numTotalBytes
            'chunks of 
            If numTotalBytes - numTransferredBytes > TransferChuckSize Then
                CurrentTransfer = TransferChuckSize
            Else
                CurrentTransfer = numTotalBytes - numTransferredBytes
            End If

            ReDim bytes(CurrentTransfer - 1)

            For i = 0 To CurrentTransfer - 1
                bytes(i) = XMLFile.ReadByte()
            Next
            'BytesRead = XMLFile.ReadByte((bytes, numTransferredBytes, _
            '            CurrentTransfer)

            Try
                CryFile.Write(bytes, 0, CurrentTransfer)
            Catch ex As Exception
                Try
                    CryFile.Write(bytes, 0, CurrentTransfer - 1)
                Catch ex1 As Exception
                    CryFile.Close()
                    outFs.Close()
                    Throw New Exception("Failed to encrypt an extract file...please verify available memory.")
                End Try

            End Try

            numTransferredBytes += CurrentTransfer
        End While

        CryFile.Close()
        outFs.Close()

    End Sub

    Private Sub EncryptData(ByVal filename As String, ByVal ExtractTableName As String, ByVal dtbl As DataTable)

        Dim ExtractFolder As String = Path.GetDirectoryName(filename) 'HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/")


        Dim strTempXMLFile As String = ExtractFolder & "\" & ExtractTableName & ".xml"

        ' If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/" & ExtractTableName & ".xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/" & ExtractTableName & ".xml"))
        If System.IO.File.Exists(strTempXMLFile) = True Then System.IO.File.Delete(strTempXMLFile)

        dtblIn = dtbl
        dtblIn.TableName = ExtractTableName
        ' Write the schema and data to XML in a memory stream.

        Dim XMLFile As New System.IO.FileStream(strTempXMLFile, System.IO.FileMode.Create)
        dtblIn.WriteXml(XMLFile, XmlWriteMode.WriteSchema)
        Encrypt(XMLFile, DESKEY, filename)

        XMLFile.Close()
        If System.IO.File.Exists(strTempXMLFile) = True Then System.IO.File.Delete(strTempXMLFile)

        ' If System.IO.File.Exists(strTempXMLFile) = True Then System.IO.File.Delete(strTempXMLFile)
        ' Dim xmlStream As New System.IO.MemoryStream()
        ' dtblIn.WriteXml(xmlStream, XmlWriteMode.WriteSchema)
        ' Dim buf As Byte() = xmlStream.ToArray()
        ' Encrypt(buf, DESKEY, filename)
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

    Private Sub DeleteWorkingFolder(WorkingFolder As String)
        If My.Computer.FileSystem.DirectoryExists(WorkingFolder) Then My.Computer.FileSystem.DeleteDirectory(WorkingFolder, FileIO.DeleteDirectoryOption.DeleteAllContents)
    End Sub

    Private Sub FlushWorkFolder()


        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xInsureePolicy.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xInsureePolicy.xml"))

        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xLocations.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xLocations.xml"))

        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xRegions.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xRegions.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xDistricts.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xDistricts.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xWards.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xWards.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xVillages.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xVillages.xml"))
        '2
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xItems.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xItems.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xServices.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xServices.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPLItems.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPLItems.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPLItemsDetails.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPLItemsDetails.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPLServices.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPLServices.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPLServicesDetails.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPLServicesDetails.xml"))
        '3

        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xICD.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xICD.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xHF.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xHF.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPayer.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPayer.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xOfficer.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xOfficer.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xProduct.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xProduct.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xProductItems.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xProductItems.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xProductServices.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xProductServices.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xRelDistr.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xRelDistr.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xClaimAdmin.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xClaimAdmin.xml"))

        '4
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xFamilies.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xFamilies.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xInsuree.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xInsuree.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPhotos.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPhotos.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPolicies.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPolicies.xml"))
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPremiums.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xPremiums.xml"))
        '5
        If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xExtract.xml")) = True Then System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/xExtract.xml"))

    End Sub



    Public Function CreateOffLineExtracts(ByRef eExtractInfo As eExtractInfo, FolderPath As String) As String

        Dim Extract As New IMISExtractsDAL
        Dim Defaults As New IMISDefaultsBL
        Dim eExtract As New tblExtracts

        Dim eDefaults As New tblIMISDefaults
        '1
        Dim dtLocations As New DataTable
        'Dim dtRegions As New DataTable
        'Dim dtDistricts As New DataTable
        'Dim dtWards As New DataTable
        'Dim dtVillages As New DataTable
        '2
        Dim dtItems As New DataTable
        Dim dtServices As New DataTable
        Dim dtPLItems As New DataTable
        Dim dtPLItemsDetails As New DataTable
        Dim dtPLServices As New DataTable
        Dim dtPLServicesDetails As New DataTable
        '3
        Dim dtICD As New DataTable
        Dim dtHF As New DataTable
        Dim dtClaimAdmin As New DataTable
        Dim dtPayer As New DataTable
        Dim dtOfficer As New DataTable
        Dim dtProduct As New DataTable
        Dim dtProductItems As New DataTable
        Dim dtProductServices As New DataTable
        Dim dtRelDistr As New DataTable
        '4
        Dim dtFamilies As New DataTable
        Dim dtInsuree As New DataTable
        Dim dtPhotos As New DataTable
        Dim dtPolicies As New DataTable
        Dim dtPremiums As New DataTable
        Dim dtInsureePolicy As New DataTable

        '5
        Dim dtExtract As New DataTable

        Dim LRV As Int64
        Dim strTemp As String
        Dim iRandom As New Random

        Dim RandomFolderName As String = Path.GetRandomFileName
        'Dim ExtractFolder As String = HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/")

        'Create directory to extract data
        My.Computer.FileSystem.CreateDirectory(FolderPath & RandomFolderName)

        Dim strFile As String = FolderPath & RandomFolderName

        Try

            LRV = Extract.GetDBLastRowVersion()   'to be saved later in the extract table

            Defaults.GetDefaults(eDefaults)

            'strFile = eDefaults.FTPOffLineExtractFolder & "\WorkFolder\xDistricts.xml"
            'strFile += "/xDistricts.xml"
            'If System.IO.File.Exists(strFile) = True Then
            '    eExtractInfo.ExtractStatus = 1    'Already in process
            '    CreateOffLineExtracts = False
            '    Exit Function
            'End If

            eExtract = Extract.GetLastCreateExtractInfo(If(eExtractInfo.DistrictID = 0, eExtractInfo.RegionID, eExtractInfo.DistrictID), eExtractInfo.ExtractType, 0)

            If eExtractInfo.ExtractType = 2 Then 'FULL !!
                eExtract.RowID = 0
            End If

            Extract.GetExportOfflineExtract1(eExtract.RowID, dtLocations)
            'now create the XML encrypted files in the FTP Folder 

            EncryptData(strFile & "/xLocations.xml", "Locations", dtLocations)

            'EncryptData(strFile & "/xRegions.xml", "Regions", dtRegions)
            'EncryptData(strFile & "/xDistricts.xml", "Districts", dtDistricts)
            'EncryptData(strFile & "/xWards.xml", "Wards", dtWards)
            'EncryptData(strFile & "/xVillages.xml", "Villages", dtVillages)

            eExtractInfo.LocationsCS = dtLocations.Rows.Count
            'eExtractInfo.RegionCS = dtRegions.Rows.Count
            'eExtractInfo.DistrictsCS = dtDistricts.Rows.Count
            'eExtractInfo.WardsCS = dtWards.Rows.Count
            'eExtractInfo.VillagesCS = dtVillages.Rows.Count

            Extract.GetExportOfflineExtract2(eExtractInfo.LocationId, eExtract.RowID, dtItems, dtServices, dtPLItems, dtPLItemsDetails, dtPLServices, dtPLServicesDetails)
            'now create the XML encrypted files in the FTP Folder 
            EncryptData(strFile & "/xItems.xml", "Items", dtItems)
            EncryptData(strFile & "/xServices.xml", "Services", dtServices)
            EncryptData(strFile & "/xPLItems.xml", "PLItems", dtPLItems)
            EncryptData(strFile & "/xPLItemsDetails.xml", "PLItemsDetails", dtPLItemsDetails)
            EncryptData(strFile & "/xPLServices.xml", "PLServices", dtPLServices)
            EncryptData(strFile & "/xPLServicesDetails.xml", "PLServicesDetails", dtPLServicesDetails)
            eExtractInfo.ItemsCS = dtItems.Rows.Count
            eExtractInfo.ServicesCS = dtServices.Rows.Count
            eExtractInfo.PLItemsCS = dtPLItems.Rows.Count
            eExtractInfo.PLItemsDetailsCS = dtPLItemsDetails.Rows.Count
            eExtractInfo.PLServicesCS = dtPLServices.Rows.Count
            eExtractInfo.PLServicesDetailsCS = dtPLServicesDetails.Rows.Count

            Extract.GetExportOfflineExtract3(eExtractInfo, eExtract.RowID, dtICD, dtHF, dtPayer, dtOfficer, dtProduct, dtProductItems, dtProductServices, dtRelDistr, dtClaimAdmin)
            'now create the XML encrypted files in the FTP Folder 
            EncryptData(strFile & "/xICD.xml", "ICD", dtICD)
            EncryptData(strFile & "/xHF.xml", "HF", dtHF)
            EncryptData(strFile & "/xPayer.xml", "Payer", dtPayer)
            EncryptData(strFile & "/xOfficer.xml", "Officer", dtOfficer)
            EncryptData(strFile & "/xProduct.xml", "Product", dtProduct)
            EncryptData(strFile & "/xProductItems.xml", "ProductItems", dtProductItems)
            EncryptData(strFile & "/xProductServices.xml", "ProductServices", dtProductServices)
            EncryptData(strFile & "/xRelDistr.xml", "RelDistr", dtRelDistr)
            EncryptData(strFile & "/xClaimAdmin.xml", "ClaimAdmin", dtClaimAdmin)

            eExtractInfo.RegionCS = dtLocations.Select("LocationType='R'  AND ValidityTo IS NULL").Count
            eExtractInfo.DistrictsCS = dtLocations.Select("LocationType='D'  AND ValidityTo IS NULL").Count
            eExtractInfo.WardsCS = dtLocations.Select("LocationType='W'  AND ValidityTo IS NULL").Count
            eExtractInfo.VillagesCS = dtLocations.Select("LocationType='V'").Count
            eExtractInfo.ICDCS = dtICD.Select("ValidityTo IS NULL").Count
            eExtractInfo.HFCS = dtHF.Select("ValidityTo IS NULL").Count
            eExtractInfo.PayerCS = dtPayer.Select("ValidityTo IS NULL").Count
            eExtractInfo.OfficerCS = dtOfficer.Select("ValidityTo IS NULL").Count
            eExtractInfo.ProductCS = dtProduct.Select("ValidityTo IS NULL").Count
            eExtractInfo.ProductItemsCS = dtProductItems.Select("ValidityTo IS NULL").Count
            eExtractInfo.ProductServicesCS = dtProductServices.Select("ValidityTo IS NULL").Count
            eExtractInfo.RelDistrCS = dtRelDistr.Select("ValidityTo IS NULL").Count
            eExtractInfo.ClaimAdminCS = dtClaimAdmin.Select("ValidityTo IS NULL").Count


            Extract.GetExportOfflineExtract4(eExtractInfo, eExtract.RowID, dtFamilies, 1)
            EncryptData(strFile & "/xFamilies.xml", "Families", dtFamilies)
            eExtractInfo.FamiliesCS = dtFamilies.Rows.Count
            dtFamilies = New DataTable()
            'clear memory

            Extract.GetExportOfflineExtract4(eExtractInfo, eExtract.RowID, dtInsuree, 2)
            EncryptData(strFile & "/xInsuree.xml", "Insuree", dtInsuree)
            eExtractInfo.InsureeCS = dtInsuree.Rows.Count
            dtInsuree = New DataTable()


            Extract.GetExportOfflineExtract4(eExtractInfo, eExtract.RowID, dtPhotos, 3)
            EncryptData(strFile & "/xPhotos.xml", "Photos", dtPhotos)
            eExtractInfo.PhotoCS = dtPhotos.Rows.Count
            dtPhotos = New DataTable()


            Extract.GetExportOfflineExtract4(eExtractInfo, eExtract.RowID, dtPolicies, 4)
            EncryptData(strFile & "/xPolicies.xml", "Policies", dtPolicies)
            eExtractInfo.PolicyCS = dtPolicies.Rows.Count
            dtPolicies = New DataTable()


            Extract.GetExportOfflineExtract4(eExtractInfo, eExtract.RowID, dtPremiums, 5)
            EncryptData(strFile & "/xPremiums.xml", "Premiums", dtPremiums)
            eExtractInfo.PremiumCS = dtPremiums.Rows.Count
            dtPremiums = New DataTable()

            Extract.GetExportOfflineExtract4(eExtractInfo, eExtract.RowID, dtInsureePolicy, 6)
            'now create the XML encrypted files in the FTP Folder 
            EncryptData(strFile & "/xInsureePolicy.xml", "InsureePolicy", dtInsureePolicy)
            dtInsureePolicy = New DataTable()

            eExtract.RowID = LRV
            eExtract.AuditUserID = eExtractInfo.AuditUserID
            eExtract.ExtractDirection = 0
            If eExtractInfo.DistrictID = 0 Then
                eExtract.LocationId = eExtractInfo.RegionID
            Else
                eExtract.LocationId = eExtractInfo.DistrictID
            End If
            eExtract.ExtractDate = Date.Now
            eExtract.HFID = 0
            
            eExtract.AppVersionBackend = eDefaults.AppVersionBackEnd
            eExtract.ExtractFolder = eDefaults.FTPOffLineExtractFolder
            eExtract.ExtractType = eExtractInfo.ExtractType

            'EDITED BY AMANI 26/09
            'ANOTHER CONDITION FOR eExtractInfo.WithInsuree = 0 ADDED
            If eExtractInfo.ExtractType = 2 Then
                strTemp = "F"
                If eExtractInfo.WithInsuree = 0 Then
                    strTemp = "E"
                End If
            Else
                strTemp = "D"
            End If
            'EDITED END 







            ' eExtract.ExtractFileName = "OE" & strTemp & "_" & eExtract.LocationId & "_" & FormatDateTime(Now, DateFormat.GeneralDate) & "_" & eExtract.ExtractSequence & ".RAR"
            eExtract.ExtractFileName = "OE_" & strTemp & "_" & eExtract.LocationId & "_" & eExtract.ExtractSequence & ".RAR"
            eExtractInfo.ExtractFileName = eExtract.ExtractFileName
            'zip the files 

            'eExtract.ExtractSequence = eExtractInfo.ExtractSequence


            eExtract.ExtractSequence = eExtractInfo.ExtractSequence
            Extract.InsertExtract(eExtract)


            Extract.GetExportOfflineExtract5(eExtract, dtExtract)  'Check header table and include in the export 
            EncryptData(strFile & "/xExtract.xml", "Extract", dtExtract)

            Zip(FolderPath, eExtract.ExtractFileName, strFile & "/", "*.xml")

            'now create all photos into a file 

            eExtractInfo.ZippedPhotosCS = CollectPhotos(dtPhotos, "OE_" & strTemp & "_" & eExtract.LocationId & "_" & eExtract.ExtractSequence & "_Photos", strFile)
            ZipPhotos("OE_" & strTemp & "_" & eExtract.LocationId & "_" & eExtract.ExtractSequence & "_Photos", ".RAR", strFile)

            'We don't need to clear images because we will delete the temp folder
            'Call ClearJPGContents()

            eExtractInfo.ExtractStatus = 0  '=ALL OK
            Return eExtractInfo.ExtractFileName

        Catch ex As Exception
            Throw ex
        Finally
            DeleteWorkingFolder(strFile)
        End Try
    End Function

    
    Public Sub DeleteAllLocalRecords()
        Dim Ext As New IMISExtractsDAL
        Ext.DeleteAllLocalRecords()
    End Sub

    

    'Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
    '    Dim con As New SQLite.SQLiteConnection
    '    con.ConnectionString = "Data source = " & DB_NAME
    '    con.Open()

    '    Dim cmd As New SQLiteCommand
    '    cmd = con.CreateCommand
    '    cmd.CommandText = "SELECT PHOTO from tblPolicyInquiry"
    '    Dim sqlReader As SQLiteDataReader = cmd.ExecuteReader
    '    While sqlReader.Read
    '        PictureBox1.Image = BlobToImage(sqlReader("Photo"))
    '    End While

    '    cmd.Dispose()
    '    con.Dispose()



    'End Sub

    'Private Function BlobToImage(ByVal BLOB)
    '    Dim mStream As New System.IO.MemoryStream
    '    Dim pData() As Byte = DirectCast(BLOB, Byte())
    '    mStream.Write(pData, 0, Convert.ToInt32(pData.Length))
    '    Dim bm As Bitmap = New Bitmap(mStream, False)
    '    mStream.Dispose()
    '    Return bm
    'End Function


    Private Sub ZipPhotos(ByVal FileName As String, ByVal Extension As String, WorkingFolder As String)
        Dim Defaults As New IMISDefaultsBL
        Dim eDefaults As New tblIMISDefaults

        Defaults.GetDefaults(eDefaults)

        Zip(HttpContext.Current.Server.MapPath("~/Extracts/Offline/"), FileName & Extension, WorkingFolder & "/", "*.jpg")


        'Dim DestDir As String = HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/" & FileName & "")

        'Directory.Delete(DestDir)


    End Sub


    Private Function ClearJPGContents()

        Dim strDirectory As String = HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/")
        For Each foundFile As String In My.Computer.FileSystem.GetFiles(strDirectory, FileIO.SearchOption.SearchTopLevelOnly, "*.jpg")
            My.Computer.FileSystem.DeleteFile(foundFile, FileIO.UIOption.OnlyErrorDialogs, FileIO.RecycleOption.DeletePermanently)
        Next

        Return ""
    End Function

    Private Function CollectPhotos(ByVal dt As DataTable, ByVal FileName As String, WorkingFolder As String) As Integer


        Dim iPhotos As Integer

        'Dim DestDir As String = HttpContext.Current.Server.MapPath("~/Extracts/Offline/WorkFolder/")

        ''If Directory.Exists(DestDir) Then
        ''    Directory.Delete(DestDir)
        ''End If


        'Directory.CreateDirectory(DestDir)

        iPhotos = 0
        For Each row In dt.Rows
            If Not row("ValidityTo") Is DBNull.Value Then Continue For
            'check first if photo already exists in temp directory
            If System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Images/Updated/") & row("PhotoFileName")) = True Then
                If System.IO.File.Exists(WorkingFolder & "/" & row("PhotoFileName")) = False Then
                    System.IO.File.Copy(HttpContext.Current.Server.MapPath("~/Images/Updated/") & row("PhotoFileName"), WorkingFolder & "/" & row("PhotoFileName"), True)
                    ' Directory.Move(HttpContext.Current.Server.MapPath("~/Images/Updated/") & row("PhotoFileName"), DestDir & "\" & row("PhotoFileName"))
                    iPhotos = iPhotos + 1

                End If

            End If

        Next

        CollectPhotos = iPhotos

    End Function

    Public Sub SubmitClaimFromXML(ByVal FileName As String)
        Dim Defaults As New tblIMISDefaults
        Dim def As New IMISDefaultsBL
        def.GetDefaults(Defaults)
        Dim Extracts As New IMISExtractsDAL

        Dim WorkingFolder As String = HttpContext.Current.Server.MapPath("\FromPhone\Claim\")

        Unzip(FileName, WorkingFolder)

        Dim XMLs As String() = Directory.GetFiles(WorkingFolder, "Claim_*.xml")
        Dim xml As String = ""

        For i As Integer = 0 To XMLs.Count - 1
            'xml = Mid(XMLs(i), XMLs(i).LastIndexOf("\") + 2, XMLs(i).Length)
            Extracts.SubmitClaimFromXML(XMLs(i))
            File.Delete(XMLs(i))
        Next

        File.Delete(FileName)

    End Sub




    

    Public Function UploadEnrolments(ByVal FileName As String, ByVal Output As Dictionary(Of String, Integer)) As DataTable
        Dim Defaults As New tblIMISDefaults
        Dim def As New IMISDefaultsBL
        def.GetDefaults(Defaults)
        Dim Extracts As New IMISExtractsDAL
        Dim WorkingFolder As String = HttpContext.Current.Server.MapPath("WorkSpace")
        Dim WorkingDirectory As String = IO.Path.GetFileNameWithoutExtension(FileName)

        Dim WorkingDirectoryPath As String = IO.Path.Combine(WorkingFolder, WorkingDirectory)

        If My.Computer.FileSystem.DirectoryExists(WorkingDirectoryPath) Then My.Computer.FileSystem.DeleteDirectory(WorkingDirectoryPath, FileIO.DeleteDirectoryOption.DeleteAllContents)

        My.Computer.FileSystem.CreateDirectory(WorkingDirectoryPath)


        'Move the file to the newly created folder
        File.Move(FileName, IO.Path.Combine(WorkingDirectoryPath, IO.Path.GetFileName(FileName)))

        'Unzip(Defaults.WinRarFolder, FileName, WorkingFolder)
        Unzip(IO.Path.Combine(WorkingDirectoryPath, IO.Path.GetFileName(FileName)), WorkingDirectoryPath)

        'Dim XMLs As String() = Directory.GetFiles(WorkingFolder, "Enrolment_*.xml")
        Dim XMLs As String() = Directory.GetFiles(WorkingDirectoryPath, "Enrolment_*.xml")
        Dim xml As String = ""

        Dim Result As New DataTable

        If XMLs.Count > 0 Then
            Result = Extracts.UploadEnrolments(XMLs(0), Output)
            File.Delete(XMLs(0))
        End If

        'File.Delete(IO.Path.Combine(WorkingDirectoryPath, IO.Path.GetFileName(FileName)))
        If My.Computer.FileSystem.DirectoryExists(WorkingDirectoryPath) Then My.Computer.FileSystem.DeleteDirectory(WorkingDirectoryPath, FileIO.DeleteDirectoryOption.DeleteAllContents)
        Return Result

    End Function

    Private Sub MoveXMLsToArhive()
        Dim XMLs As String()
        XMLs = Directory.GetFiles(HttpContext.Current.Server.MapPath("Workspace"), "Enrolment_*.xml")

        For i As Integer = 0 To XMLs.Length - 1
            If File.Exists(XMLs(i)) Then
                File.Move(XMLs(i), HttpContext.Current.Server.MapPath("Archive\") & Mid(XMLs(i), XMLs(i).LastIndexOf("\") + 2, XMLs(i).Length))
                'File.Delete(XMLs(i))
                'Continue For
            End If


        Next

    End Sub

    
End Class

