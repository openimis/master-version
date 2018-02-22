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
        Me.niImisBackup = New System.Windows.Forms.NotifyIcon(Me.components)
        Me.ContextMenuStrip1 = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.mnuStart = New System.Windows.Forms.ToolStripMenuItem
        Me.mnuStop = New System.Windows.Forms.ToolStripMenuItem
        Me.mnuSetting = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.mnuExit = New System.Windows.Forms.ToolStripMenuItem
        Me.ServiceController1 = New System.ServiceProcess.ServiceController
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
        Me.ContextMenuStrip1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.SuspendLayout()
        '
        'niImisBackup
        '
        Me.niImisBackup.BalloonTipIcon = System.Windows.Forms.ToolTipIcon.Info
        Me.niImisBackup.BalloonTipText = "Imis backup service is now started"
        Me.niImisBackup.BalloonTipTitle = "Imis Backup"
        Me.niImisBackup.ContextMenuStrip = Me.ContextMenuStrip1
        Me.niImisBackup.Icon = CType(resources.GetObject("niImisBackup.Icon"), System.Drawing.Icon)
        Me.niImisBackup.Text = "Imis Backup"
        Me.niImisBackup.Visible = True
        '
        'ContextMenuStrip1
        '
        Me.ContextMenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.mnuStart, Me.mnuStop, Me.mnuSetting, Me.ToolStripSeparator1, Me.mnuExit})
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
        'mnuSetting
        '
        Me.mnuSetting.Name = "mnuSetting"
        Me.mnuSetting.Size = New System.Drawing.Size(116, 22)
        Me.mnuSetting.Text = "Settings"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(113, 6)
        '
        'mnuExit
        '
        Me.mnuExit.Name = "mnuExit"
        Me.mnuExit.Size = New System.Drawing.Size(116, 22)
        Me.mnuExit.Text = "Exit"
        '
        'ServiceController1
        '
        Me.ServiceController1.ServiceName = "ImisBackup"
        '
        'btnApply
        '
        Me.btnApply.Location = New System.Drawing.Point(12, 224)
        Me.btnApply.Name = "btnApply"
        Me.btnApply.Size = New System.Drawing.Size(75, 23)
        Me.btnApply.TabIndex = 1
        Me.btnApply.Text = "Apply"
        Me.btnApply.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.Location = New System.Drawing.Point(197, 224)
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
        Me.GroupBox1.Location = New System.Drawing.Point(0, 0)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(276, 127)
        Me.GroupBox1.TabIndex = 4
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Server Settings"
        '
        'txtServer
        '
        Me.txtServer.Location = New System.Drawing.Point(96, 19)
        Me.txtServer.Name = "txtServer"
        Me.txtServer.Size = New System.Drawing.Size(164, 20)
        Me.txtServer.TabIndex = 10
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(25, 22)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(41, 13)
        Me.Label1.TabIndex = 7
        Me.Label1.Text = "Server:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(25, 48)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(56, 13)
        Me.Label2.TabIndex = 4
        Me.Label2.Text = "Database:"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.Location = New System.Drawing.Point(25, 74)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(63, 13)
        Me.Label3.TabIndex = 6
        Me.Label3.Text = "User Name:"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.Location = New System.Drawing.Point(25, 100)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(56, 13)
        Me.Label4.TabIndex = 5
        Me.Label4.Text = "Password:"
        '
        'txtDatabase
        '
        Me.txtDatabase.Location = New System.Drawing.Point(96, 45)
        Me.txtDatabase.Name = "txtDatabase"
        Me.txtDatabase.Size = New System.Drawing.Size(164, 20)
        Me.txtDatabase.TabIndex = 11
        '
        'txtUserName
        '
        Me.txtUserName.Location = New System.Drawing.Point(96, 71)
        Me.txtUserName.Name = "txtUserName"
        Me.txtUserName.Size = New System.Drawing.Size(164, 20)
        Me.txtUserName.TabIndex = 8
        '
        'txtPassword
        '
        Me.txtPassword.Location = New System.Drawing.Point(96, 97)
        Me.txtPassword.Name = "txtPassword"
        Me.txtPassword.Size = New System.Drawing.Size(164, 20)
        Me.txtPassword.TabIndex = 9
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
        Me.GroupBox2.Location = New System.Drawing.Point(0, 127)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(276, 81)
        Me.GroupBox2.TabIndex = 5
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Schedule"
        '
        'txtInterval
        '
        Me.txtInterval.Location = New System.Drawing.Point(96, 46)
        Me.txtInterval.MaxLength = 2
        Me.txtInterval.Name = "txtInterval"
        Me.txtInterval.Size = New System.Drawing.Size(42, 20)
        Me.txtInterval.TabIndex = 11
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label7.Location = New System.Drawing.Point(146, 49)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(41, 13)
        Me.Label7.TabIndex = 10
        Me.Label7.Text = "(Hours)"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label6.Location = New System.Drawing.Point(25, 49)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(45, 13)
        Me.Label6.TabIndex = 10
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
        Me.dtTime.TabIndex = 9
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label5.Location = New System.Drawing.Point(25, 26)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(33, 13)
        Me.Label5.TabIndex = 8
        Me.Label5.Text = "Time:"
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(276, 254)
        Me.ControlBox = False
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnApply)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.Name = "Form1"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Imis Backup"
        Me.WindowState = System.Windows.Forms.FormWindowState.Minimized
        Me.ContextMenuStrip1.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents niImisBackup As System.Windows.Forms.NotifyIcon
    Friend WithEvents ContextMenuStrip1 As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents mnuStart As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents mnuStop As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents mnuSetting As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ServiceController1 As System.ServiceProcess.ServiceController
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents mnuExit As System.Windows.Forms.ToolStripMenuItem
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

End Class
