Imports System.Xml

Public Class Form1

    Friend Shared Notify As System.Windows.Forms.NotifyIcon

    Private Sub StartService()
        If Not ServiceController1.Status = 4 Then ServiceController1.Start()
        SetMenu()
    End Sub

    Private Sub StopService()
        If Not ServiceController1.Status = 1 Then ServiceController1.Stop()
        SetMenu()
    End Sub

    Private Sub RestartService()
        StopService()
        ServiceController1.WaitForStatus(1)
        StartService()
    End Sub

    Private Sub Form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Notify = niPolicyRenewal
        Me.niPolicyRenewal.ShowBalloonTip(5000)


        StartService()

        SetMenu()

    End Sub

    Private Sub SetMenu()

        mnuStart.Enabled = False
        mnuStop.Enabled = False


        ServiceController1.Refresh()

CHECK_AGAIN:

        Select Case ServiceController1.Status

            Case 1
                mnuStart.Enabled = True
            Case 4
                mnuStop.Enabled = True
            Case Else
                System.Threading.Thread.Sleep(2000)
                ServiceController1.Refresh()
                GoTo CHECK_AGAIN

        End Select

    End Sub

    Private Sub mnuStop_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuStop.Click
        StopService()

    End Sub

    Private Sub mnuStart_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuStart.Click
        StartService()

    End Sub

    Private Sub mnuExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuExit.Click
        StopService()
        niPolicyRenewal.Visible = False
        niPolicyRenewal.Dispose()
        End
    End Sub

    Private Sub LoadSettings()
        Dim XmlDoc As XmlDocument = New XmlDocument()

        XmlDoc.Load(My.Application.Info.DirectoryPath & "\ImisPolicyRenewal.exe.config")

        For Each xElement As XmlElement In XmlDoc.DocumentElement
            If xElement.Name = "userSettings" Then
                For Each xNode As XmlNode In xElement.ChildNodes
                    For Each node As XmlNode In xNode.ChildNodes
                        If node.Attributes(0).InnerText = "DataSource" Then txtServer.Text = node.InnerText
                        If node.Attributes(0).InnerText = "DatabaseName" Then txtDatabase.Text = node.InnerText
                        If node.Attributes(0).InnerText = "UserName" Then txtUserName.Text = node.InnerText
                        If node.Attributes(0).InnerText = "Password" Then txtPassword.Text = node.InnerText
                        If node.Attributes(0).InnerText = "RenewalTime" Then dtTime.Text = node.InnerText
                        If node.Attributes(0).InnerText = "RenewalInterval" Then txtInterval.Text = node.InnerText
                        If node.Attributes(0).InnerText = "SendSMSOfficer" Then chkSendSMSOfficer.Checked = node.InnerText
                        If node.Attributes(0).InnerText = "SendSMSFamily" Then chkSendSMSFamily.Checked = node.InnerText
                        If node.Attributes(0).InnerText = "FamilySMSTemplatePath" Then txtFamiliesTemplatePath.Text = node.InnerText
                        If node.Attributes(0).InnerText = "OfficerSMSTemplatePath" Then txtFamiliesTemplatePath.Text = node.InnerText
                        If node.Attributes(0).InnerText = "SMSGatewayURL" Then txtSMSGateway.Text = node.InnerText
                        If node.Attributes(0).InnerText = "SMSGatewayUser" Then txtGatewayUserName.Text = node.InnerText
                        If node.Attributes(0).InnerText = "SMSGatewayPassword" Then txtGatewayPassword.Text = node.InnerText

                    Next
                Next
            End If
        Next
        chkSendSMSFamily_CheckedChanged(Me, New System.EventArgs)

    End Sub

    Private Function isValidData() As Boolean
        isValidData = False

        'If chkSendSMSOfficer.Checked And txtOfficerTemplatePath.Text.Trim.Length = 0 Then
        '    MessageBox.Show("Template path must be selected", Me.Text, MessageBoxButtons.OK)
        '    txtOfficerTemplatePath.Focus()
        '    Exit Function
        'End If

        If chkSendSMSFamily.Checked And txtFamiliesTemplatePath.Text.Trim.Length = 0 Then
            MessageBox.Show("Template path must be selected", Me.Text, MessageBoxButtons.OK)
            txtFamiliesTemplatePath.Focus()
            Exit Function
        End If

        isValidData = True
    End Function

    Private Function UpdateSettings() As Boolean
        If Not isValidData() Then Return False

        Dim XmlDoc As XmlDocument = New XmlDocument()

        XmlDoc.Load(My.Application.Info.DirectoryPath & "\ImisPolicyRenewal.exe.config")

        For Each xElement As XmlElement In XmlDoc.DocumentElement
            If xElement.Name = "userSettings" Then
                For Each xNode As XmlNode In xElement.ChildNodes
                    For Each node As XmlNode In xNode.ChildNodes
                        If node.Attributes(0).InnerXml = "DataSource" Then node.FirstChild.InnerXml = txtServer.Text
                        If node.Attributes(0).InnerText = "DatabaseName" Then node.FirstChild.InnerXml = txtDatabase.Text
                        If node.Attributes(0).InnerText = "UserName" Then node.FirstChild.InnerXml = txtUserName.Text
                        If node.Attributes(0).InnerText = "Password" Then node.FirstChild.InnerXml = txtPassword.Text
                        If node.Attributes(0).InnerText = "RenewalTime" Then node.FirstChild.InnerXml = dtTime.Text
                        If node.Attributes(0).InnerText = "RenewalInterval" Then node.FirstChild.InnerXml = txtInterval.Text
                        If node.Attributes(0).InnerText = "SendSMSOfficer" Then node.FirstChild.InnerXml = chkSendSMSOfficer.Checked
                        If node.Attributes(0).InnerText = "SendSMSFamily" Then node.FirstChild.InnerXml = chkSendSMSFamily.Checked
                        If node.Attributes(0).InnerText = "FamilySMSTemplatePath" Then node.FirstChild.InnerXml = txtFamiliesTemplatePath.Text
                        If node.Attributes(0).InnerText = "OfficerSMSTemplatePath" Then node.FirstChild.InnerXml = txtFamiliesTemplatePath.Text
                        If node.Attributes(0).InnerText = "SMSGatewayURL" Then node.FirstChild.InnerXml = txtSMSGateway.Text
                        If node.Attributes(0).InnerText = "SMSGatewayUser" Then node.FirstChild.InnerXml = txtGatewayUserName.Text
                        If node.Attributes(0).InnerText = "SMSGatewayPassword" Then node.FirstChild.InnerXml = txtGatewayPassword.Text
                    Next
                Next
            End If
        Next

        XmlDoc.Save(My.Application.Info.DirectoryPath & "\ImisPolicyRenewal.exe.config")

        Return True
    End Function

    Private Sub mnuSetting_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuSettings.Click
        Me.Show()
        Me.Width = 308
        Me.Height = 540
        Me.WindowState = FormWindowState.Normal
        LoadSettings()
        txtServer.Focus()
    End Sub

    Private Sub btnApply_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnApply.Click
        If UpdateSettings() = True Then
            Me.WindowState = FormWindowState.Minimized
            RestartService()
            Me.Hide()
        End If
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.WindowState = FormWindowState.Minimized
        Me.Hide()
    End Sub

    Private Sub txtTemplate_EnabledChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtFamiliesTemplatePath.EnabledChanged
        btnFamiliesTemplatePath.Enabled = txtFamiliesTemplatePath.Enabled
    End Sub
    Private Function BrowseFolder() As String
        Dim fd As New OpenFileDialog
        If fd.ShowDialog = Windows.Forms.DialogResult.OK Then
            Return fd.FileName
        Else
            Return ""
        End If
    End Function
    Private Sub btnFamiliesTemplatePath_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFamiliesTemplatePath.Click
        Try
            txtFamiliesTemplatePath.Text = BrowseFolder()
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try
    End Sub

    Private Sub chkSendSMSFamily_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkSendSMSFamily.CheckedChanged
        txtFamiliesTemplatePath.Enabled = chkSendSMSFamily.Checked
    End Sub

    
    Private Sub btnOfficerTemplatePath_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOfficerTemplatePath.Click
        Try
            txtOfficerTemplatePath.Text = BrowseFolder()
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try
    End Sub
End Class
