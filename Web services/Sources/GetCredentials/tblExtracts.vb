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


Public Class tblExtracts

    Private _ExtractID As Int32
    Private _ExtractDirection As Byte
    Private _ExtractType As Byte
    Private _ExtractSequence As Int32
    Private _ExtractDate As DateTime
    Private _ExtractFileName As String
    Private _ExtractFolder As String
    Private _DistrictID As Int32
    Private _HFID As Int32?
    Private _AppVersionBackend As Decimal
    Private _ValidityFrom As DateTime
    Private _ValidityTo As DateTime?
    Private _LegacyID As Int32?
    Private _AuditUserID As Int32
    Private _RowID As Int64?
    Private _LocationId As Int32


    Public Property [ExtractID] As Int32
        Get
            [ExtractID] = _ExtractID
        End Get
        Set(Value As Int32)
            _ExtractID = Value
        End Set
    End Property
    Public Property [ExtractDirection] As Byte
        Get
            [ExtractDirection] = _ExtractDirection
        End Get
        Set(Value As Byte)
            _ExtractDirection = Value
        End Set
    End Property
    Public Property [ExtractType] As Byte
        Get
            [ExtractType] = _ExtractType
        End Get
        Set(Value As Byte)
            _ExtractType = Value
        End Set
    End Property
    Public Property [ExtractSequence] As Int32
        Get
            [ExtractSequence] = _ExtractSequence
        End Get
        Set(Value As Int32)
            _ExtractSequence = Value
        End Set
    End Property
    Public Property [ExtractDate] As DateTime
        Get
            [ExtractDate] = _ExtractDate
        End Get
        Set(Value As DateTime)
            _ExtractDate = Value
        End Set
    End Property
    Public Property [ExtractFileName] As String
        Get
            [ExtractFileName] = _ExtractFileName
        End Get
        Set(Value As String)
            _ExtractFileName = Value
        End Set
    End Property
    Public Property [ExtractFolder] As String
        Get
            [ExtractFolder] = _ExtractFolder
        End Get
        Set(Value As String)
            _ExtractFolder = Value
        End Set
    End Property
    Public Property [DistrictID] As Int32
        Get
            [DistrictID] = _DistrictID
        End Get
        Set(Value As Int32)
            _DistrictID = Value
        End Set
    End Property
    Public Property [HFID] As Int32?
        Get
            [HFID] = _HFID
        End Get
        Set(Value As Int32?)
            _HFID = Value
        End Set
    End Property
    Public Property [AppVersionBackend] As Decimal
        Get
            [AppVersionBackend] = _AppVersionBackend
        End Get
        Set(Value As Decimal)
            _AppVersionBackend = Value
        End Set
    End Property
    Public Property [ValidityFrom] As DateTime
        Get
            [ValidityFrom] = _ValidityFrom
        End Get
        Set(Value As DateTime)
            _ValidityFrom = Value
        End Set
    End Property
    Public Property [ValidityTo] As DateTime?
        Get
            [ValidityTo] = _ValidityTo
        End Get
        Set(Value As DateTime?)
            _ValidityTo = Value
        End Set
    End Property
    Public Property [LegacyID] As Int32?
        Get
            [LegacyID] = _LegacyID
        End Get
        Set(Value As Int32?)
            _LegacyID = Value
        End Set
    End Property
    Public Property [AuditUserID] As Int32
        Get
            [AuditUserID] = _AuditUserID
        End Get
        Set(Value As Int32)
            _AuditUserID = Value
        End Set
    End Property
    Public Property [RowID] As Int64?
        Get
            [RowID] = _RowID
        End Get
        Set(Value As Int64?)
            _RowID = Value
        End Set
    End Property
    Public Property LocationId() As Int32
        Get
            Return _LocationId
        End Get
        Set(value As Int32)
            _LocationId = value
        End Set
    End Property


End Class
