Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Configuration.WebConfigurationManager


Public Class ExactSQL

    Private _sqladapter As New SqlClient.SqlDataAdapter
    Private _dtbl As New DataTable
    Private _ds As DataSet = Nothing
    Private _IdentityKey As String = ""
    Private _TableName As String = ""
    Private _SQLCommand As New SqlClient.SqlCommand


    Public ReadOnly Property sqlParameters(Optional ByVal Paramname As String = "") As Object
        Get
            Return _SQLCommand.Parameters(Paramname).Value
        End Get
    End Property
    Public Sub params(ByVal param As String, ByVal type As SqlDbType, ByVal paramvalue As Object, Optional ByVal direction As ParameterDirection = ParameterDirection.Input)
        _SQLCommand.Parameters.Add(param, type).Value = IIf(paramvalue Is Nothing, DBNull.Value, paramvalue)
        _SQLCommand.Parameters(param).Direction = direction
    End Sub
    Public Sub params(ByVal param As String, ByVal paramvalue As Object, Optional ByVal UserType As String = Nothing)
        _SQLCommand.Parameters.AddWithValue(param, paramvalue)
        If Not UserType = Nothing Then
            _SQLCommand.Parameters(param).TypeName = UserType
        End If
    End Sub

   
    Public Sub params(ByVal param As String, ByVal type As SqlDbType, ByVal Size As Integer, ByVal paramvalue As String, Optional ByVal direction As ParameterDirection = ParameterDirection.Input)
        _SQLCommand.Parameters.Add(param, type, Size).Value = IIf(paramvalue Is Nothing, DBNull.Value, paramvalue)
        _SQLCommand.Parameters(param).Direction = direction
    End Sub
    Public Sub setSQLCommand(ByVal cmd As String, ByVal cmdtype As CommandType, Optional ByVal ConString As String = "NP_CENTRALConnectionString", Optional ByVal timeout As Integer = 60)
        _SQLCommand = New SqlClient.SqlCommand
        'If ConString = "" Then
        '    ConString = Web.Configuration.WebConfigurationManager.ConnectionStrings("NP_CENTRALConnectionString").ConnectionString
        'Else
        ConString = "Password=" & My.Settings.Password & ";Persist Security Info=True;User ID=" & My.Settings.UserName & ";Initial Catalog=" & My.Settings.DatabaseName & ";Data Source=" & My.Settings.DataSource & ""
        'End If
        Dim con As New SqlConnection(ConString)
        _SQLCommand.CommandTimeout = timeout
        _SQLCommand.CommandText = cmd
        _SQLCommand.CommandType = cmdtype
        _SQLCommand.Connection = con 'Exact.Data.sql.SQLConn
    End Sub
    Public Function Filldata(Optional ByVal IdentityColumn As String = "", Optional ByVal TableName As String = "") As DataTable
        Try
            _TableName = TableName
            _IdentityKey = IdentityColumn
            _sqladapter = New SqlClient.SqlDataAdapter
            _sqladapter.SelectCommand = _SQLCommand
            _dtbl = New DataTable
            _sqladapter.Fill(_dtbl)
            Return _dtbl
        Catch ex1 As System.Data.SqlClient.SqlException
            Throw New Exception(ex1.Message, ex1)
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Function
    Public Function ExecuteScalar() As Boolean
        Try
            Dim count As Integer
            If _SQLCommand.Connection.State = 0 Then _SQLCommand.Connection.Open()

            Dim res As Object = _SQLCommand.ExecuteScalar()
            count = Integer.Parse(IIf(res Is Nothing, 0, res))


            _SQLCommand.Connection.Close()
            If count > 0 Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Function
    Public Function ExecuteCommand() As Boolean
        Try
            If _SQLCommand.Connection.State = 0 Then _SQLCommand.Connection.Open()
            _SQLCommand.ExecuteNonQuery()
            _SQLCommand.Connection.Close()
            Return True
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Function
    Private Sub getUpdateCommand(Optional ByVal conflictType As System.Data.ConflictOption = 1)
        '1 = compare,'2 = use timestamp,3= overwrite
        Try
            Dim cmdUpdate As New SqlClient.SqlCommandBuilder(_sqladapter)
            cmdUpdate.ConflictOption = conflictType
            _sqladapter.UpdateCommand = cmdUpdate.GetUpdateCommand


        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Sub
    Public Sub savedata(Optional ByVal conflictType As System.Data.ConflictOption = 1)
        Try
            If _sqladapter.UpdateCommand Is Nothing Then
                AddHandler _sqladapter.RowUpdated, New SqlClient.SqlRowUpdatedEventHandler(AddressOf OnRowUpdated)
            End If
            getUpdateCommand(conflictType)
            _sqladapter.Update(_dtbl)
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Sub
    Public Function FilldataSet() As DataSet
        Try

            _sqladapter = New SqlClient.SqlDataAdapter
            _sqladapter.SelectCommand = _SQLCommand
            _ds = New DataSet
            _sqladapter.Fill(_ds)
            Return _ds
        Catch ex1 As System.Data.SqlClient.SqlException
            Dim s As String = "INSERT INTO Result(errorMessage) VALUES('" & Replace(ex1.Message, "'", "''") & "')"
            setSQLCommand(s, CommandType.Text)
            ExecuteCommand()
            Throw New Exception(ex1.Message, ex1)
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Function

    'Private Sub ConcurrencyError()
    '    Try
    '        If Windows.Forms.MessageBox.Show("Another user has recently altered the record!" & vbNewLine & vbNewLine & "Would you like to overwrite these changes?", "Concurrency Error", Windows.Forms.MessageBoxButtons.YesNo, Windows.Forms.MessageBoxIcon.Question) = MsgBoxResult.Yes Then
    '            getUpdateCommand(ConflictOption.OverwriteChanges)
    '            savedata()
    '        Else
    '            _dtbl.RejectChanges()
    '        End If
    '    Catch ex As Exception
    '        Throw New Exception(ex.Message)
    '    End Try

    'End Sub
    Private Sub OnRowUpdated(ByVal sender As Object, ByVal args As SqlClient.SqlRowUpdatedEventArgs)
        Try

            If args.RecordsAffected = 0 Then
                If args.Errors.GetType().Name = "DBConcurrencyException" Then
                    args.Status = UpdateStatus.Continue
                    'ConcurrencyError()
                Else
                    Throw New Exception(args.Errors.Message)
                End If
            Else
                If args.StatementType = 1 Then
                    If _IdentityKey <> "" Then
                        args.Row(_IdentityKey) = GetIdentity(args.Command.Connection)
                    End If
                End If
            End If

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Sub
    Private Function GetIdentity(ByRef cnn As SqlClient.SqlConnection) As Integer
        Try

            Dim oCmd As New SqlClient.SqlCommand("SELECT ident_current('" & _TableName & "')", cnn)
            Dim x As Object = oCmd.ExecuteScalar()
            Return CInt(x)
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Function
End Class


