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
        nSMS.Visible = False
        nSMS.Dispose()
        End
    End Sub
    Private Sub LoadSettings()
        Dim XmlDoc As XmlDocument = New XmlDocument()

        XmlDoc.Load(My.Application.Info.DirectoryPath & "\SMSOnEffective.exe.config")

        For Each xElement As XmlElement In XmlDoc.DocumentElement
            If xElement.Name = "userSettings" Then
                For Each xNode As XmlNode In xElement.ChildNodes
                    For Each node As XmlNode In xNode.ChildNodes
                        If node.Attributes(0).InnerText = "DataSource" Then txtServer.Text = node.InnerText
                        If node.Attributes(0).InnerText = "DatabaseName" Then txtDatabase.Text = node.InnerText
                        If node.Attributes(0).InnerText = "UserName" Then txtUserName.Text = node.InnerText
                        If node.Attributes(0).InnerText = "Password" Then txtPassword.Text = node.InnerText
                        If node.Attributes(0).InnerText = "SMSTime" Then dtTime.Text = node.InnerText
                        If node.Attributes(0).InnerText = "SMSInterval" Then txtInterval.Text = node.InnerText
                        If node.Attributes(0).InnerText = "Message" Then txtMessage.Text = node.InnerText
                        If node.Attributes(0).InnerText = "GatewayURL" Then txtGateway.Text = node.InnerText
                        If node.Attributes(0).InnerText = "GatewayUser" Then txtGatewayUserName.Text = node.InnerText
                        If node.Attributes(0).InnerText = "GatewayPassword" Then txtGatewayPassword.Text = node.InnerText
                        If node.Attributes(0).InnerText = "SMSToHOFOnly" Then chkOnlyHOF.Checked = CBool(node.InnerText)
                    Next
                Next
            End If
        Next
    End Sub
    Private Sub UpdateSettings()

        Dim XmlDoc As XmlDocument = New XmlDocument()

        XmlDoc.Load(My.Application.Info.DirectoryPath & "\SMSOnEffective.exe.config")

        For Each xElement As XmlElement In XmlDoc.DocumentElement
            If xElement.Name = "userSettings" Then
                For Each xNode As XmlNode In xElement.ChildNodes
                    For Each node As XmlNode In xNode.ChildNodes
                        If node.Attributes(0).InnerXml = "DataSource" Then node.FirstChild.InnerXml = txtServer.Text
                        If node.Attributes(0).InnerText = "DatabaseName" Then node.FirstChild.InnerXml = txtDatabase.Text
                        If node.Attributes(0).InnerText = "UserName" Then node.FirstChild.InnerXml = txtUserName.Text
                        If node.Attributes(0).InnerText = "Password" Then node.FirstChild.InnerXml = txtPassword.Text
                        If node.Attributes(0).InnerText = "SMSTime" Then node.FirstChild.InnerXml = dtTime.Text
                        If node.Attributes(0).InnerText = "SMSInterval" Then node.FirstChild.InnerXml = txtInterval.Text
                        If node.Attributes(0).InnerText = "Message" Then node.FirstChild.InnerXml = txtMessage.Text
                        If node.Attributes(0).InnerText = "GatewayURL" Then node.FirstChild.InnerXml = txtGateway.Text
                        If node.Attributes(0).InnerText = "GatewayUser" Then node.FirstChild.InnerXml = txtGatewayUserName.Text
                        If node.Attributes(0).InnerText = "GatewayPassword" Then node.FirstChild.InnerXml = txtGatewayPassword.Text
                        If node.Attributes(0).InnerText = "SMSToHOFOnly" Then node.FirstChild.InnerXml = chkOnlyHOF.Checked
                    Next
                Next
            End If
        Next

        XmlDoc.Save(My.Application.Info.DirectoryPath & "\SMSOnEffective.exe.config")

    End Sub

    Private Sub frmSettings_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        Notify = nSMS
        Me.nSMS.ShowBalloonTip(5000)
        StartService()
        SetMenu()
    End Sub
    Private Sub mnuSetting_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuSetting.Click
        Me.Show()
        Me.Width = 300
        Me.Height = 500
        Me.WindowState = FormWindowState.Normal
        LoadSettings()
        txtServer.Focus()
    End Sub
    Private Sub btnApply_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnApply.Click
        UpdateSettings()
        Me.WindowState = FormWindowState.Minimized
        RestartService()
        Me.Hide()
    End Sub
    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.WindowState = FormWindowState.Minimized
        Me.Hide()
    End Sub
End Class
