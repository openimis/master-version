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
        Me.mnuSetting = New System.Windows.Forms.ToolStripMenuItem
        Me.mnuStop = New System.Windows.Forms.ToolStripMenuItem
        Me.mnuStart = New System.Windows.Forms.ToolStripMenuItem
        Me.ContextMenuStrip1 = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.mnuExit = New System.Windows.Forms.ToolStripMenuItem
        Me.nSMS = New System.Windows.Forms.NotifyIcon(Me.components)
        Me.txtMessage = New System.Windows.Forms.TextBox
        Me.GroupBox3 = New System.Windows.Forms.GroupBox
        Me.chkOnlyHOF = New System.Windows.Forms.CheckBox
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.btnApply = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.txtInterval = New System.Windows.Forms.TextBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.dtTime = New System.Windows.Forms.DateTimePicker
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.txtServer = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.txtDatabase = New System.Windows.Forms.TextBox
        Me.txtUserName = New System.Windows.Forms.TextBox
        Me.txtPassword = New System.Windows.Forms.TextBox
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.ServiceController1 = New System.ServiceProcess.ServiceController
        Me.grpSMSSettings = New System.Windows.Forms.GroupBox
        Me.txtGateway = New System.Windows.Forms.TextBox
        Me.Label8 = New System.Windows.Forms.Label
        Me.Label10 = New System.Windows.Forms.Label
        Me.Label11 = New System.Windows.Forms.Label
        Me.txtGatewayUserName = New System.Windows.Forms.TextBox
        Me.txtGatewayPassword = New System.Windows.Forms.TextBox
        Me.ContextMenuStrip1.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        Me.Panel1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.grpSMSSettings.SuspendLayout()
        Me.SuspendLayout()
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(113, 6)
        '
        'mnuSetting
        '
        Me.mnuSetting.Name = "mnuSetting"
        Me.mnuSetting.Size = New System.Drawing.Size(116, 22)
        Me.mnuSetting.Text = "Settings"
        '
        'mnuStop
        '
        Me.mnuStop.Name = "mnuStop"
        Me.mnuStop.Size = New System.Drawing.Size(116, 22)
        Me.mnuStop.Text = "Stop"
        '
        'mnuStart
        '
        Me.mnuStart.Name = "mnuStart"
        Me.mnuStart.Size = New System.Drawing.Size(116, 22)
        Me.mnuStart.Text = "Start"
        '
        'ContextMenuStrip1
        '
        Me.ContextMenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.mnuStart, Me.mnuStop, Me.mnuSetting, Me.ToolStripSeparator1, Me.mnuExit})
        Me.ContextMenuStrip1.Name = "ContextMenuStrip1"
        Me.ContextMenuStrip1.Size = New System.Drawing.Size(117, 98)
        '
        'mnuExit
        '
        Me.mnuExit.Name = "mnuExit"
        Me.mnuExit.Size = New System.Drawing.Size(116, 22)
        Me.mnuExit.Text = "Exit"
        '
        'nSMS
        '
        Me.nSMS.BalloonTipIcon = System.Windows.Forms.ToolTipIcon.Info
        Me.nSMS.BalloonTipText = "SMS On Effective service is now started."
        Me.nSMS.BalloonTipTitle = "SMS On Effective"
        Me.nSMS.ContextMenuStrip = Me.ContextMenuStrip1
        Me.nSMS.Icon = CType(resources.GetObject("nSMS.Icon"), System.Drawing.Icon)
        Me.nSMS.Text = "SMS On Effective"
        Me.nSMS.Visible = True
        '
        'txtMessage
        '
        Me.txtMessage.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtMessage.Dock = System.Windows.Forms.DockStyle.Top
        Me.txtMessage.Location = New System.Drawing.Point(3, 16)
        Me.txtMessage.Multiline = True
        Me.txtMessage.Name = "txtMessage"
        Me.txtMessage.Size = New System.Drawing.Size(278, 62)
        Me.txtMessage.TabIndex = 0
        Me.txtMessage.UseSystemPasswordChar = True
        '
        'GroupBox3
        '
        Me.GroupBox3.Controls.Add(Me.txtMessage)
        Me.GroupBox3.Controls.Add(Me.chkOnlyHOF)
        Me.GroupBox3.Dock = System.Windows.Forms.DockStyle.Top
        Me.GroupBox3.ForeColor = System.Drawing.Color.RoyalBlue
        Me.GroupBox3.Location = New System.Drawing.Point(0, 313)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(284, 117)
        Me.GroupBox3.TabIndex = 3
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Message"
        '
        'chkOnlyHOF
        '
        Me.chkOnlyHOF.AutoSize = True
        Me.chkOnlyHOF.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chkOnlyHOF.Location = New System.Drawing.Point(28, 84)
        Me.chkOnlyHOF.Name = "chkOnlyHOF"
        Me.chkOnlyHOF.Size = New System.Drawing.Size(136, 17)
        Me.chkOnlyHOF.TabIndex = 1
        Me.chkOnlyHOF.Text = "Send SMS to HOF only"
        Me.chkOnlyHOF.UseVisualStyleBackColor = True
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.btnApply)
        Me.Panel1.Controls.Add(Me.btnCancel)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.Panel1.Location = New System.Drawing.Point(0, 427)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(284, 45)
        Me.Panel1.TabIndex = 4
        '
        'btnApply
        '
        Me.btnApply.Location = New System.Drawing.Point(12, 13)
        Me.btnApply.Name = "btnApply"
        Me.btnApply.Size = New System.Drawing.Size(75, 23)
        Me.btnApply.TabIndex = 0
        Me.btnApply.Text = "Apply"
        Me.btnApply.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.Location = New System.Drawing.Point(197, 13)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 1
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
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
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.txtInterval)
        Me.GroupBox2.Controls.Add(Me.Label7)
        Me.GroupBox2.Controls.Add(Me.Label6)
        Me.GroupBox2.Controls.Add(Me.dtTime)
        Me.GroupBox2.Controls.Add(Me.Label5)
        Me.GroupBox2.Dock = System.Windows.Forms.DockStyle.Top
        Me.GroupBox2.ForeColor = System.Drawing.Color.RoyalBlue
        Me.GroupBox2.Location = New System.Drawing.Point(0, 232)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(284, 81)
        Me.GroupBox2.TabIndex = 2
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Schedule"
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
        'txtServer
        '
        Me.txtServer.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtServer.Location = New System.Drawing.Point(96, 19)
        Me.txtServer.Name = "txtServer"
        Me.txtServer.Size = New System.Drawing.Size(164, 20)
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
        Me.txtDatabase.Size = New System.Drawing.Size(164, 20)
        Me.txtDatabase.TabIndex = 3
        '
        'txtUserName
        '
        Me.txtUserName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtUserName.Location = New System.Drawing.Point(96, 71)
        Me.txtUserName.Name = "txtUserName"
        Me.txtUserName.Size = New System.Drawing.Size(164, 20)
        Me.txtUserName.TabIndex = 5
        '
        'txtPassword
        '
        Me.txtPassword.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtPassword.Location = New System.Drawing.Point(96, 97)
        Me.txtPassword.Name = "txtPassword"
        Me.txtPassword.Size = New System.Drawing.Size(164, 20)
        Me.txtPassword.TabIndex = 7
        Me.txtPassword.UseSystemPasswordChar = True
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
        Me.GroupBox1.ForeColor = System.Drawing.Color.RoyalBlue
        Me.GroupBox1.Location = New System.Drawing.Point(0, 0)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(284, 127)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Server Settings"
        '
        'ServiceController1
        '
        Me.ServiceController1.ServiceName = "SMSOnEffective"
        '
        'grpSMSSettings
        '
        Me.grpSMSSettings.Controls.Add(Me.txtGateway)
        Me.grpSMSSettings.Controls.Add(Me.Label8)
        Me.grpSMSSettings.Controls.Add(Me.Label10)
        Me.grpSMSSettings.Controls.Add(Me.Label11)
        Me.grpSMSSettings.Controls.Add(Me.txtGatewayUserName)
        Me.grpSMSSettings.Controls.Add(Me.txtGatewayPassword)
        Me.grpSMSSettings.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpSMSSettings.ForeColor = System.Drawing.Color.RoyalBlue
        Me.grpSMSSettings.Location = New System.Drawing.Point(0, 127)
        Me.grpSMSSettings.Name = "grpSMSSettings"
        Me.grpSMSSettings.Size = New System.Drawing.Size(284, 105)
        Me.grpSMSSettings.TabIndex = 1
        Me.grpSMSSettings.TabStop = False
        Me.grpSMSSettings.Text = "SMS Gateway Settings"
        '
        'txtGateway
        '
        Me.txtGateway.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtGateway.Location = New System.Drawing.Point(96, 19)
        Me.txtGateway.Name = "txtGateway"
        Me.txtGateway.Size = New System.Drawing.Size(164, 20)
        Me.txtGateway.TabIndex = 1
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label8.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label8.Location = New System.Drawing.Point(25, 22)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(52, 13)
        Me.Label8.TabIndex = 0
        Me.Label8.Text = "Gateway:"
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label10.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label10.Location = New System.Drawing.Point(25, 48)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(63, 13)
        Me.Label10.TabIndex = 2
        Me.Label10.Text = "User Name:"
        '
        'Label11
        '
        Me.Label11.AutoSize = True
        Me.Label11.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label11.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label11.Location = New System.Drawing.Point(25, 74)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(56, 13)
        Me.Label11.TabIndex = 4
        Me.Label11.Text = "Password:"
        '
        'txtGatewayUserName
        '
        Me.txtGatewayUserName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtGatewayUserName.Location = New System.Drawing.Point(96, 45)
        Me.txtGatewayUserName.Name = "txtGatewayUserName"
        Me.txtGatewayUserName.Size = New System.Drawing.Size(164, 20)
        Me.txtGatewayUserName.TabIndex = 3
        '
        'txtGatewayPassword
        '
        Me.txtGatewayPassword.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtGatewayPassword.Location = New System.Drawing.Point(96, 71)
        Me.txtGatewayPassword.Name = "txtGatewayPassword"
        Me.txtGatewayPassword.Size = New System.Drawing.Size(164, 20)
        Me.txtGatewayPassword.TabIndex = 5
        Me.txtGatewayPassword.UseSystemPasswordChar = True
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(284, 472)
        Me.Controls.Add(Me.GroupBox3)
        Me.Controls.Add(Me.Panel1)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.grpSMSSettings)
        Me.Controls.Add(Me.GroupBox1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "Form1"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "SMS On Policy Effective"
        Me.WindowState = System.Windows.Forms.FormWindowState.Minimized
        Me.ContextMenuStrip1.ResumeLayout(False)
        Me.GroupBox3.ResumeLayout(False)
        Me.GroupBox3.PerformLayout()
        Me.Panel1.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.grpSMSSettings.ResumeLayout(False)
        Me.grpSMSSettings.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents mnuSetting As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents mnuStop As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents mnuStart As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ContextMenuStrip1 As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents mnuExit As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents nSMS As System.Windows.Forms.NotifyIcon
    Friend WithEvents txtMessage As System.Windows.Forms.TextBox
    Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents btnApply As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents txtInterval As System.Windows.Forms.TextBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents dtTime As System.Windows.Forms.DateTimePicker
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents txtServer As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents txtDatabase As System.Windows.Forms.TextBox
    Friend WithEvents txtUserName As System.Windows.Forms.TextBox
    Friend WithEvents txtPassword As System.Windows.Forms.TextBox
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents ServiceController1 As System.ServiceProcess.ServiceController
    Friend WithEvents chkOnlyHOF As System.Windows.Forms.CheckBox
    Friend WithEvents grpSMSSettings As System.Windows.Forms.GroupBox
    Friend WithEvents txtGateway As System.Windows.Forms.TextBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents txtGatewayUserName As System.Windows.Forms.TextBox
    Friend WithEvents txtGatewayPassword As System.Windows.Forms.TextBox

End Class
