<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(Form1))
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.btnApply = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.txtServer = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.txtDatabase = New System.Windows.Forms.TextBox
        Me.txtUserName = New System.Windows.Forms.TextBox
        Me.txtPassword = New System.Windows.Forms.TextBox
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.txtInterval = New System.Windows.Forms.TextBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.dtTime = New System.Windows.Forms.DateTimePicker
        Me.Label5 = New System.Windows.Forms.Label
        Me.ServiceController1 = New System.ServiceProcess.ServiceController
        Me.niPolicyRenewal = New System.Windows.Forms.NotifyIcon(Me.components)
        Me.ContextMenuStrip1 = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.mnuStart = New System.Windows.Forms.ToolStripMenuItem
        Me.mnuStop = New System.Windows.Forms.ToolStripMenuItem
        Me.mnuSettings = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.mnuExit = New System.Windows.Forms.ToolStripMenuItem
        Me.chkSendSMSOfficer = New System.Windows.Forms.CheckBox
        Me.chkSendSMSFamily = New System.Windows.Forms.CheckBox
        Me.pnlButton = New System.Windows.Forms.Panel
        Me.grpSendSMSFamily = New System.Windows.Forms.GroupBox
        Me.btnFamiliesTemplatePath = New System.Windows.Forms.Button
        Me.Label8 = New System.Windows.Forms.Label
        Me.txtFamiliesTemplatePath = New System.Windows.Forms.TextBox
        Me.grpSMSToOfficer = New System.Windows.Forms.GroupBox
        Me.btnOfficerTemplatePath = New System.Windows.Forms.Button
        Me.Label9 = New System.Windows.Forms.Label
        Me.txtOfficerTemplatePath = New System.Windows.Forms.TextBox
        Me.grpSMSSGatewaySettings = New System.Windows.Forms.GroupBox
        Me.txtSMSGateway = New System.Windows.Forms.TextBox
        Me.Label10 = New System.Windows.Forms.Label
        Me.Label12 = New System.Windows.Forms.Label
        Me.Label13 = New System.Windows.Forms.Label
        Me.txtGatewayUserName = New System.Windows.Forms.TextBox
        Me.txtGatewayPassword = New System.Windows.Forms.TextBox
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.ContextMenuStrip1.SuspendLayout()
        Me.pnlButton.SuspendLayout()
        Me.grpSendSMSFamily.SuspendLayout()
        Me.grpSMSToOfficer.SuspendLayout()
        Me.grpSMSSGatewaySettings.SuspendLayout()
        Me.SuspendLayout()
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(113, 6)
        '
        'btnApply
        '
        Me.btnApply.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnApply.Location = New System.Drawing.Point(10, 8)
        Me.btnApply.Name = "btnApply"
        Me.btnApply.Size = New System.Drawing.Size(75, 23)
        Me.btnApply.TabIndex = 0
        Me.btnApply.Text = "Apply"
        Me.btnApply.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnCancel.Location = New System.Drawing.Point(195, 8)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 1
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.txtServer)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.Label4)
        Me.GroupBox1.Controls.Add(Me.txtDatabase)
        Me.GroupBox1.Controls.Add(Me.txtUserName)
        Me.GroupBox1.Controls.Add(Me.txtPassword)
        Me.GroupBox1.Dock = System.Windows.Forms.DockStyle.Top
        Me.GroupBox1.ForeColor = System.Drawing.Color.Snow
        Me.GroupBox1.Location = New System.Drawing.Point(3, 3)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(284, 127)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Server Settings"
        '
        'txtServer
        '
        Me.txtServer.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtServer.Location = New System.Drawing.Point(96, 19)
        Me.txtServer.Name = "txtServer"
        Me.txtServer.Size = New System.Drawing.Size(156, 20)
        Me.txtServer.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(25, 22)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(41, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Server:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(25, 48)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(56, 13)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Database:"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label3.Location = New System.Drawing.Point(25, 74)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(63, 13)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "User Name:"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label4.Location = New System.Drawing.Point(25, 100)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(56, 13)
        Me.Label4.TabIndex = 6
        Me.Label4.Text = "Password:"
        '
        'txtDatabase
        '
        Me.txtDatabase.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtDatabase.Location = New System.Drawing.Point(96, 45)
        Me.txtDatabase.Name = "txtDatabase"
        Me.txtDatabase.Size = New System.Drawing.Size(156, 20)
        Me.txtDatabase.TabIndex = 3
        '
        'txtUserName
        '
        Me.txtUserName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtUserName.Location = New System.Drawing.Point(96, 71)
        Me.txtUserName.Name = "txtUserName"
        Me.txtUserName.Size = New System.Drawing.Size(156, 20)
        Me.txtUserName.TabIndex = 5
        '
        'txtPassword
        '
        Me.txtPassword.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtPassword.Location = New System.Drawing.Point(96, 97)
        Me.txtPassword.Name = "txtPassword"
        Me.txtPassword.Size = New System.Drawing.Size(156, 20)
        Me.txtPassword.TabIndex = 7
        Me.txtPassword.UseSystemPasswordChar = True
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.txtInterval)
        Me.GroupBox2.Controls.Add(Me.Label7)
        Me.GroupBox2.Controls.Add(Me.Label6)
        Me.GroupBox2.Controls.Add(Me.dtTime)
        Me.GroupBox2.Controls.Add(Me.Label5)
        Me.GroupBox2.Dock = System.Windows.Forms.DockStyle.Top
        Me.GroupBox2.ForeColor = System.Drawing.Color.Snow
        Me.GroupBox2.Location = New System.Drawing.Point(3, 234)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(284, 81)
        Me.GroupBox2.TabIndex = 2
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Schedule"
        '
        'txtInterval
        '
        Me.txtInterval.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtInterval.Location = New System.Drawing.Point(96, 46)
        Me.txtInterval.MaxLength = 2
        Me.txtInterval.Name = "txtInterval"
        Me.txtInterval.Size = New System.Drawing.Size(42, 20)
        Me.txtInterval.TabIndex = 3
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label7.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label7.Location = New System.Drawing.Point(146, 49)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(41, 13)
        Me.Label7.TabIndex = 4
        Me.Label7.Text = "(Hours)"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label6.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label6.Location = New System.Drawing.Point(25, 49)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(45, 13)
        Me.Label6.TabIndex = 2
        Me.Label6.Text = "Interval:"
        '
        'dtTime
        '
        Me.dtTime.CustomFormat = "HH:mm"
        Me.dtTime.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.dtTime.Location = New System.Drawing.Point(96, 20)
        Me.dtTime.Name = "dtTime"
        Me.dtTime.ShowUpDown = True
        Me.dtTime.Size = New System.Drawing.Size(57, 20)
        Me.dtTime.TabIndex = 1
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label5.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label5.Location = New System.Drawing.Point(25, 26)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(33, 13)
        Me.Label5.TabIndex = 0
        Me.Label5.Text = "Time:"
        '
        'ServiceController1
        '
        Me.ServiceController1.ServiceName = "ImisPolicyRenewal"
        '
        'niPolicyRenewal
        '
        Me.niPolicyRenewal.BalloonTipIcon = System.Windows.Forms.ToolTipIcon.Info
        Me.niPolicyRenewal.BalloonTipText = "Imis Policy Renewal service is now started."
        Me.niPolicyRenewal.BalloonTipTitle = "IMIS Renewal"
        Me.niPolicyRenewal.ContextMenuStrip = Me.ContextMenuStrip1
        Me.niPolicyRenewal.Icon = CType(resources.GetObject("niPolicyRenewal.Icon"), System.Drawing.Icon)
        Me.niPolicyRenewal.Text = "Policy Renewal"
        Me.niPolicyRenewal.Visible = True
        '
        'ContextMenuStrip1
        '
        Me.ContextMenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.mnuStart, Me.mnuStop, Me.mnuSettings, Me.ToolStripSeparator2, Me.mnuExit})
        Me.ContextMenuStrip1.Name = "ContextMenuStrip1"
        Me.ContextMenuStrip1.Size = New System.Drawing.Size(117, 98)
        '
        'mnuStart
        '
        Me.mnuStart.Name = "mnuStart"
        Me.mnuStart.Size = New System.Drawing.Size(116, 22)
        Me.mnuStart.Text = "Start"
        '
        'mnuStop
        '
        Me.mnuStop.Name = "mnuStop"
        Me.mnuStop.Size = New System.Drawing.Size(116, 22)
        Me.mnuStop.Text = "Stop"
        '
        'mnuSettings
        '
        Me.mnuSettings.Name = "mnuSettings"
        Me.mnuSettings.Size = New System.Drawing.Size(116, 22)
        Me.mnuSettings.Text = "Settings"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(113, 6)
        '
        'mnuExit
        '
        Me.mnuExit.Name = "mnuExit"
        Me.mnuExit.Size = New System.Drawing.Size(116, 22)
        Me.mnuExit.Text = "Exit"
        '
        'chkSendSMSOfficer
        '
        Me.chkSendSMSOfficer.AutoSize = True
        Me.chkSendSMSOfficer.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chkSendSMSOfficer.Location = New System.Drawing.Point(12, 20)
        Me.chkSendSMSOfficer.Name = "chkSendSMSOfficer"
        Me.chkSendSMSOfficer.Size = New System.Drawing.Size(123, 17)
        Me.chkSendSMSOfficer.TabIndex = 0
        Me.chkSendSMSOfficer.Text = "Send SMS to Officer"
        Me.chkSendSMSOfficer.UseVisualStyleBackColor = True
        '
        'chkSendSMSFamily
        '
        Me.chkSendSMSFamily.AutoSize = True
        Me.chkSendSMSFamily.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chkSendSMSFamily.Location = New System.Drawing.Point(12, 19)
        Me.chkSendSMSFamily.Name = "chkSendSMSFamily"
        Me.chkSendSMSFamily.Size = New System.Drawing.Size(121, 17)
        Me.chkSendSMSFamily.TabIndex = 0
        Me.chkSendSMSFamily.Text = "Send SMS to Family"
        Me.chkSendSMSFamily.UseVisualStyleBackColor = True
        '
        'pnlButton
        '
        Me.pnlButton.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.pnlButton.Controls.Add(Me.btnApply)
        Me.pnlButton.Controls.Add(Me.btnCancel)
        Me.pnlButton.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlButton.Location = New System.Drawing.Point(3, 456)
        Me.pnlButton.Name = "pnlButton"
        Me.pnlButton.Size = New System.Drawing.Size(284, 45)
        Me.pnlButton.TabIndex = 5
        '
        'grpSendSMSFamily
        '
        Me.grpSendSMSFamily.Controls.Add(Me.btnFamiliesTemplatePath)
        Me.grpSendSMSFamily.Controls.Add(Me.Label8)
        Me.grpSendSMSFamily.Controls.Add(Me.txtFamiliesTemplatePath)
        Me.grpSendSMSFamily.Controls.Add(Me.chkSendSMSFamily)
        Me.grpSendSMSFamily.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpSendSMSFamily.ForeColor = System.Drawing.Color.Snow
        Me.grpSendSMSFamily.Location = New System.Drawing.Point(3, 383)
        Me.grpSendSMSFamily.Name = "grpSendSMSFamily"
        Me.grpSendSMSFamily.Size = New System.Drawing.Size(284, 68)
        Me.grpSendSMSFamily.TabIndex = 4
        Me.grpSendSMSFamily.TabStop = False
        Me.grpSendSMSFamily.Text = "Send SMS To Families"
        '
        'btnFamiliesTemplatePath
        '
        Me.btnFamiliesTemplatePath.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnFamiliesTemplatePath.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnFamiliesTemplatePath.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnFamiliesTemplatePath.Location = New System.Drawing.Point(258, 40)
        Me.btnFamiliesTemplatePath.Name = "btnFamiliesTemplatePath"
        Me.btnFamiliesTemplatePath.Size = New System.Drawing.Size(20, 23)
        Me.btnFamiliesTemplatePath.TabIndex = 3
        Me.btnFamiliesTemplatePath.Text = "..."
        Me.btnFamiliesTemplatePath.UseVisualStyleBackColor = True
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label8.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label8.Location = New System.Drawing.Point(25, 45)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(54, 13)
        Me.Label8.TabIndex = 1
        Me.Label8.Text = "Template:"
        '
        'txtFamiliesTemplatePath
        '
        Me.txtFamiliesTemplatePath.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtFamiliesTemplatePath.Location = New System.Drawing.Point(96, 43)
        Me.txtFamiliesTemplatePath.Name = "txtFamiliesTemplatePath"
        Me.txtFamiliesTemplatePath.Size = New System.Drawing.Size(156, 20)
        Me.txtFamiliesTemplatePath.TabIndex = 2
        '
        'grpSMSToOfficer
        '
        Me.grpSMSToOfficer.Controls.Add(Me.btnOfficerTemplatePath)
        Me.grpSMSToOfficer.Controls.Add(Me.Label9)
        Me.grpSMSToOfficer.Controls.Add(Me.txtOfficerTemplatePath)
        Me.grpSMSToOfficer.Controls.Add(Me.chkSendSMSOfficer)
        Me.grpSMSToOfficer.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpSMSToOfficer.ForeColor = System.Drawing.Color.Snow
        Me.grpSMSToOfficer.Location = New System.Drawing.Point(3, 315)
        Me.grpSMSToOfficer.Name = "grpSMSToOfficer"
        Me.grpSMSToOfficer.Size = New System.Drawing.Size(284, 68)
        Me.grpSMSToOfficer.TabIndex = 3
        Me.grpSMSToOfficer.TabStop = False
        Me.grpSMSToOfficer.Text = "Send SMS To Officers"
        '
        'btnOfficerTemplatePath
        '
        Me.btnOfficerTemplatePath.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnOfficerTemplatePath.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnOfficerTemplatePath.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnOfficerTemplatePath.Location = New System.Drawing.Point(258, 40)
        Me.btnOfficerTemplatePath.Name = "btnOfficerTemplatePath"
        Me.btnOfficerTemplatePath.Size = New System.Drawing.Size(20, 23)
        Me.btnOfficerTemplatePath.TabIndex = 3
        Me.btnOfficerTemplatePath.Text = "..."
        Me.btnOfficerTemplatePath.UseVisualStyleBackColor = True
        Me.btnOfficerTemplatePath.Visible = False
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label9.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label9.Location = New System.Drawing.Point(25, 45)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(54, 13)
        Me.Label9.TabIndex = 1
        Me.Label9.Text = "Template:"
        Me.Label9.Visible = False
        '
        'txtOfficerTemplatePath
        '
        Me.txtOfficerTemplatePath.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtOfficerTemplatePath.Location = New System.Drawing.Point(96, 43)
        Me.txtOfficerTemplatePath.Name = "txtOfficerTemplatePath"
        Me.txtOfficerTemplatePath.Size = New System.Drawing.Size(156, 20)
        Me.txtOfficerTemplatePath.TabIndex = 2
        Me.txtOfficerTemplatePath.Visible = False
        '
        'grpSMSSGatewaySettings
        '
        Me.grpSMSSGatewaySettings.Controls.Add(Me.txtSMSGateway)
        Me.grpSMSSGatewaySettings.Controls.Add(Me.Label10)
        Me.grpSMSSGatewaySettings.Controls.Add(Me.Label12)
        Me.grpSMSSGatewaySettings.Controls.Add(Me.Label13)
        Me.grpSMSSGatewaySettings.Controls.Add(Me.txtGatewayUserName)
        Me.grpSMSSGatewaySettings.Controls.Add(Me.txtGatewayPassword)
        Me.grpSMSSGatewaySettings.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpSMSSGatewaySettings.ForeColor = System.Drawing.Color.Snow
        Me.grpSMSSGatewaySettings.Location = New System.Drawing.Point(3, 130)
        Me.grpSMSSGatewaySettings.Name = "grpSMSSGatewaySettings"
        Me.grpSMSSGatewaySettings.Size = New System.Drawing.Size(284, 104)
        Me.grpSMSSGatewaySettings.TabIndex = 1
        Me.grpSMSSGatewaySettings.TabStop = False
        Me.grpSMSSGatewaySettings.Text = "Server Settings"
        '
        'txtSMSGateway
        '
        Me.txtSMSGateway.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtSMSGateway.Location = New System.Drawing.Point(96, 19)
        Me.txtSMSGateway.Name = "txtSMSGateway"
        Me.txtSMSGateway.Size = New System.Drawing.Size(156, 20)
        Me.txtSMSGateway.TabIndex = 1
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label10.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label10.Location = New System.Drawing.Point(25, 22)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(52, 13)
        Me.Label10.TabIndex = 0
        Me.Label10.Text = "Gateway:"
        '
        'Label12
        '
        Me.Label12.AutoSize = True
        Me.Label12.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label12.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label12.Location = New System.Drawing.Point(25, 48)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(63, 13)
        Me.Label12.TabIndex = 2
        Me.Label12.Text = "User Name:"
        '
        'Label13
        '
        Me.Label13.AutoSize = True
        Me.Label13.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label13.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label13.Location = New System.Drawing.Point(25, 74)
        Me.Label13.Name = "Label13"
        Me.Label13.Size = New System.Drawing.Size(56, 13)
        Me.Label13.TabIndex = 4
        Me.Label13.Text = "Password:"
        '
        'txtGatewayUserName
        '
        Me.txtGatewayUserName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtGatewayUserName.Location = New System.Drawing.Point(96, 45)
        Me.txtGatewayUserName.Name = "txtGatewayUserName"
        Me.txtGatewayUserName.Size = New System.Drawing.Size(156, 20)
        Me.txtGatewayUserName.TabIndex = 3
        '
        'txtGatewayPassword
        '
        Me.txtGatewayPassword.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtGatewayPassword.Location = New System.Drawing.Point(96, 71)
        Me.txtGatewayPassword.Name = "txtGatewayPassword"
        Me.txtGatewayPassword.Size = New System.Drawing.Size(156, 20)
        Me.txtGatewayPassword.TabIndex = 5
        Me.txtGatewayPassword.UseSystemPasswordChar = True
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.SlateGray
        Me.ClientSize = New System.Drawing.Size(290, 504)
        Me.ControlBox = False
        Me.Controls.Add(Me.grpSendSMSFamily)
        Me.Controls.Add(Me.grpSMSToOfficer)
        Me.Controls.Add(Me.pnlButton)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.grpSMSSGatewaySettings)
        Me.Controls.Add(Me.GroupBox1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.Name = "Form1"
        Me.Padding = New System.Windows.Forms.Padding(3)
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Imis Policy Renewal"
        Me.WindowState = System.Windows.Forms.FormWindowState.Minimized
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.ContextMenuStrip1.ResumeLayout(False)
        Me.pnlButton.ResumeLayout(False)
        Me.grpSendSMSFamily.ResumeLayout(False)
        Me.grpSendSMSFamily.PerformLayout()
        Me.grpSMSToOfficer.ResumeLayout(False)
        Me.grpSMSToOfficer.PerformLayout()
        Me.grpSMSSGatewaySettings.ResumeLayout(False)
        Me.grpSMSSGatewaySettings.PerformLayout()
        Me.ResumeLayout(False)

    End Sub


    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents btnApply As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents txtServer As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents txtDatabase As System.Windows.Forms.TextBox
    Friend WithEvents txtUserName As System.Windows.Forms.TextBox
    Friend WithEvents txtPassword As System.Windows.Forms.TextBox
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents dtTime As System.Windows.Forms.DateTimePicker
    Friend WithEvents txtInterval As System.Windows.Forms.TextBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents ServiceController1 As System.ServiceProcess.ServiceController
    Friend WithEvents niPolicyRenewal As System.Windows.Forms.NotifyIcon
    Friend WithEvents ContextMenuStrip1 As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents mnuStart As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents mnuStop As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents mnuSettings As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents mnuExit As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents chkSendSMSOfficer As System.Windows.Forms.CheckBox
    Friend WithEvents chkSendSMSFamily As System.Windows.Forms.CheckBox
    Friend WithEvents pnlButton As System.Windows.Forms.Panel
    Friend WithEvents grpSendSMSFamily As System.Windows.Forms.GroupBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents txtFamiliesTemplatePath As System.Windows.Forms.TextBox
    Friend WithEvents btnFamiliesTemplatePath As System.Windows.Forms.Button
    Friend WithEvents grpSMSToOfficer As System.Windows.Forms.GroupBox
    Friend WithEvents btnOfficerTemplatePath As System.Windows.Forms.Button
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents txtOfficerTemplatePath As System.Windows.Forms.TextBox
    Friend WithEvents grpSMSSGatewaySettings As System.Windows.Forms.GroupBox
    Friend WithEvents txtSMSGateway As System.Windows.Forms.TextBox
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents Label12 As System.Windows.Forms.Label
    Friend WithEvents Label13 As System.Windows.Forms.Label
    Friend WithEvents txtGatewayUserName As System.Windows.Forms.TextBox
    Friend WithEvents txtGatewayPassword As System.Windows.Forms.TextBox

End Class
