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
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.txtInterval = New System.Windows.Forms.TextBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.dtTime = New System.Windows.Forms.DateTimePicker
        Me.Label5 = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.txtServer = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.txtDatabase = New System.Windows.Forms.TextBox
        Me.txtUserName = New System.Windows.Forms.TextBox
        Me.txtPassword = New System.Windows.Forms.TextBox
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnApply = New System.Windows.Forms.Button
        Me.ServiceController1 = New System.ServiceProcess.ServiceController
        Me.niAssignPhoto = New System.Windows.Forms.NotifyIcon(Me.components)
        Me.ContextMenuStrip1 = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.mnuStart = New System.Windows.Forms.ToolStripMenuItem
        Me.mnuStop = New System.Windows.Forms.ToolStripMenuItem
        Me.mnuSettings = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.mnuExit = New System.Windows.Forms.ToolStripMenuItem
        Me.GroupBox3 = New System.Windows.Forms.GroupBox
        Me.txtSubmitted = New System.Windows.Forms.TextBox
        Me.Label8 = New System.Windows.Forms.Label
        Me.Label9 = New System.Windows.Forms.Label
        Me.txtUpdated = New System.Windows.Forms.TextBox
        Me.Label10 = New System.Windows.Forms.Label
        Me.txtRejected = New System.Windows.Forms.TextBox
        Me.btnSubmitted = New System.Windows.Forms.Button
        Me.btnUpdated = New System.Windows.Forms.Button
        Me.btnRejected = New System.Windows.Forms.Button
        Me.FolderBrowserDialog1 = New System.Windows.Forms.FolderBrowserDialog
        Me.GroupBox2.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.ContextMenuStrip1.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        Me.SuspendLayout()
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.txtInterval)
        Me.GroupBox2.Controls.Add(Me.Label7)
        Me.GroupBox2.Controls.Add(Me.Label6)
        Me.GroupBox2.Controls.Add(Me.dtTime)
        Me.GroupBox2.Controls.Add(Me.Label5)
        resources.ApplyResources(Me.GroupBox2, "GroupBox2")
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.TabStop = False
        '
        'txtInterval
        '
        resources.ApplyResources(Me.txtInterval, "txtInterval")
        Me.txtInterval.Name = "txtInterval"
        '
        'Label7
        '
        resources.ApplyResources(Me.Label7, "Label7")
        Me.Label7.Name = "Label7"
        '
        'Label6
        '
        resources.ApplyResources(Me.Label6, "Label6")
        Me.Label6.Name = "Label6"
        '
        'dtTime
        '
        resources.ApplyResources(Me.dtTime, "dtTime")
        Me.dtTime.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.dtTime.Name = "dtTime"
        Me.dtTime.ShowUpDown = True
        '
        'Label5
        '
        resources.ApplyResources(Me.Label5, "Label5")
        Me.Label5.Name = "Label5"
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
        resources.ApplyResources(Me.GroupBox1, "GroupBox1")
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.TabStop = False
        '
        'txtServer
        '
        resources.ApplyResources(Me.txtServer, "txtServer")
        Me.txtServer.Name = "txtServer"
        '
        'Label1
        '
        resources.ApplyResources(Me.Label1, "Label1")
        Me.Label1.Name = "Label1"
        '
        'Label2
        '
        resources.ApplyResources(Me.Label2, "Label2")
        Me.Label2.Name = "Label2"
        '
        'Label3
        '
        resources.ApplyResources(Me.Label3, "Label3")
        Me.Label3.Name = "Label3"
        '
        'Label4
        '
        resources.ApplyResources(Me.Label4, "Label4")
        Me.Label4.Name = "Label4"
        '
        'txtDatabase
        '
        resources.ApplyResources(Me.txtDatabase, "txtDatabase")
        Me.txtDatabase.Name = "txtDatabase"
        '
        'txtUserName
        '
        resources.ApplyResources(Me.txtUserName, "txtUserName")
        Me.txtUserName.Name = "txtUserName"
        '
        'txtPassword
        '
        resources.ApplyResources(Me.txtPassword, "txtPassword")
        Me.txtPassword.Name = "txtPassword"
        Me.txtPassword.UseSystemPasswordChar = True
        '
        'btnCancel
        '
        resources.ApplyResources(Me.btnCancel, "btnCancel")
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'btnApply
        '
        resources.ApplyResources(Me.btnApply, "btnApply")
        Me.btnApply.Name = "btnApply"
        Me.btnApply.UseVisualStyleBackColor = True
        '
        'ServiceController1
        '
        Me.ServiceController1.ServiceName = "AssignPhotos"
        '
        'niAssignPhoto
        '
        Me.niAssignPhoto.BalloonTipIcon = System.Windows.Forms.ToolTipIcon.Info
        resources.ApplyResources(Me.niAssignPhoto, "niAssignPhoto")
        Me.niAssignPhoto.ContextMenuStrip = Me.ContextMenuStrip1
        '
        'ContextMenuStrip1
        '
        Me.ContextMenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.mnuStart, Me.mnuStop, Me.mnuSettings, Me.ToolStripSeparator2, Me.mnuExit})
        Me.ContextMenuStrip1.Name = "ContextMenuStrip1"
        resources.ApplyResources(Me.ContextMenuStrip1, "ContextMenuStrip1")
        '
        'mnuStart
        '
        Me.mnuStart.Name = "mnuStart"
        resources.ApplyResources(Me.mnuStart, "mnuStart")
        '
        'mnuStop
        '
        Me.mnuStop.Name = "mnuStop"
        resources.ApplyResources(Me.mnuStop, "mnuStop")
        '
        'mnuSettings
        '
        Me.mnuSettings.Name = "mnuSettings"
        resources.ApplyResources(Me.mnuSettings, "mnuSettings")
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        resources.ApplyResources(Me.ToolStripSeparator2, "ToolStripSeparator2")
        '
        'mnuExit
        '
        Me.mnuExit.Name = "mnuExit"
        resources.ApplyResources(Me.mnuExit, "mnuExit")
        '
        'GroupBox3
        '
        Me.GroupBox3.Controls.Add(Me.btnRejected)
        Me.GroupBox3.Controls.Add(Me.btnUpdated)
        Me.GroupBox3.Controls.Add(Me.btnSubmitted)
        Me.GroupBox3.Controls.Add(Me.txtRejected)
        Me.GroupBox3.Controls.Add(Me.Label10)
        Me.GroupBox3.Controls.Add(Me.txtUpdated)
        Me.GroupBox3.Controls.Add(Me.Label9)
        Me.GroupBox3.Controls.Add(Me.txtSubmitted)
        Me.GroupBox3.Controls.Add(Me.Label8)
        resources.ApplyResources(Me.GroupBox3, "GroupBox3")
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.TabStop = False
        '
        'txtSubmitted
        '
        resources.ApplyResources(Me.txtSubmitted, "txtSubmitted")
        Me.txtSubmitted.Name = "txtSubmitted"
        Me.txtSubmitted.ReadOnly = True
        '
        'Label8
        '
        resources.ApplyResources(Me.Label8, "Label8")
        Me.Label8.Name = "Label8"
        '
        'Label9
        '
        resources.ApplyResources(Me.Label9, "Label9")
        Me.Label9.Name = "Label9"
        '
        'txtUpdated
        '
        resources.ApplyResources(Me.txtUpdated, "txtUpdated")
        Me.txtUpdated.Name = "txtUpdated"
        Me.txtUpdated.ReadOnly = True
        '
        'Label10
        '
        resources.ApplyResources(Me.Label10, "Label10")
        Me.Label10.Name = "Label10"
        '
        'txtRejected
        '
        resources.ApplyResources(Me.txtRejected, "txtRejected")
        Me.txtRejected.Name = "txtRejected"
        Me.txtRejected.ReadOnly = True
        '
        'btnSubmitted
        '
        resources.ApplyResources(Me.btnSubmitted, "btnSubmitted")
        Me.btnSubmitted.Name = "btnSubmitted"
        Me.btnSubmitted.UseVisualStyleBackColor = True
        '
        'btnUpdated
        '
        resources.ApplyResources(Me.btnUpdated, "btnUpdated")
        Me.btnUpdated.Name = "btnUpdated"
        Me.btnUpdated.UseVisualStyleBackColor = True
        '
        'btnRejected
        '
        resources.ApplyResources(Me.btnRejected, "btnRejected")
        Me.btnRejected.Name = "btnRejected"
        Me.btnRejected.UseVisualStyleBackColor = True
        '
        'Form1
        '
        resources.ApplyResources(Me, "$this")
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ControlBox = False
        Me.Controls.Add(Me.GroupBox3)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.btnApply)
        Me.Controls.Add(Me.btnCancel)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.Name = "Form1"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.WindowState = System.Windows.Forms.FormWindowState.Minimized
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ContextMenuStrip1.ResumeLayout(False)
        Me.GroupBox3.ResumeLayout(False)
        Me.GroupBox3.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents txtInterval As System.Windows.Forms.TextBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents dtTime As System.Windows.Forms.DateTimePicker
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents txtServer As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents txtDatabase As System.Windows.Forms.TextBox
    Friend WithEvents txtUserName As System.Windows.Forms.TextBox
    Friend WithEvents txtPassword As System.Windows.Forms.TextBox
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents btnApply As System.Windows.Forms.Button
    Friend WithEvents ServiceController1 As System.ServiceProcess.ServiceController
    Friend WithEvents niAssignPhoto As System.Windows.Forms.NotifyIcon
    Friend WithEvents ContextMenuStrip1 As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents mnuStart As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents mnuStop As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents mnuSettings As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents mnuExit As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents txtRejected As System.Windows.Forms.TextBox
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents txtUpdated As System.Windows.Forms.TextBox
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents txtSubmitted As System.Windows.Forms.TextBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents btnSubmitted As System.Windows.Forms.Button
    Friend WithEvents btnRejected As System.Windows.Forms.Button
    Friend WithEvents btnUpdated As System.Windows.Forms.Button
    Friend WithEvents FolderBrowserDialog1 As System.Windows.Forms.FolderBrowserDialog

End Class
