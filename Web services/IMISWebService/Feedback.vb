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


Public Class Feedback
    Private _ClaimId As Integer
    Private _OfficerId As Integer
    Private _OfficerCode As String
    Private _CHFID As String
    Private _LastName As String
    Private _OtherNames As String
    Private _HFCode As String
    Private _HFName As String
    Private _ClaimCode As String
    Private _DateFrom As String
    Private _DateTo As String
    Private _IMEI As String
    Private _Phone As String
    Private _FeedbackPromptDate As String

    Public Property ClaimId() As Integer
        Get
            ClaimId = _ClaimId
        End Get
        Set(ByVal value As Integer)
            _ClaimId = value
        End Set
    End Property

    Public Property OfficerId() As Integer
        Get
            OfficerId = _OfficerId
        End Get
        Set(ByVal value As Integer)
            _OfficerId = value
        End Set
    End Property

    Public Property OfficerCode() As String
        Get
            OfficerCode = _OfficerCode
        End Get
        Set(ByVal value As String)
            _OfficerCode = value
        End Set
    End Property

    Public Property CHFID() As String
        Get
            CHFID = _CHFID
        End Get
        Set(ByVal value As String)
            _CHFID = value
        End Set
    End Property

    Public Property LastName() As String
        Get
            LastName = _LastName
        End Get
        Set(ByVal value As String)
            _LastName = value
        End Set
    End Property

    Public Property OtherNames() As String
        Get
            OtherNames = _OtherNames
        End Get
        Set(ByVal value As String)
            _OtherNames = value
        End Set
    End Property

    Public Property HFCode() As String
        Get
            HFCode = _HFCode
        End Get
        Set(ByVal value As String)
            _HFCode = value
        End Set
    End Property

    Public Property HFName() As String
        Get
            HFName = _HFName
        End Get
        Set(ByVal value As String)
            _HFName = value
        End Set
    End Property

    Public Property ClaimCode() As String
        Get
            ClaimCode = _ClaimCode
        End Get
        Set(ByVal value As String)
            _ClaimCode = value
        End Set
    End Property

    Public Property DateFrom() As String
        Get
            DateFrom = _DateFrom
        End Get
        Set(ByVal value As String)
            _DateFrom = value
        End Set
    End Property

    Public Property DateTo() As String
        Get
            DateTo = _DateTo
        End Get
        Set(ByVal value As String)
            _DateTo = value
        End Set
    End Property

    Public Property IMEI() As String
        Get
            IMEI = _IMEI
        End Get
        Set(ByVal value As String)
            _IMEI = value
        End Set
    End Property

    Public Property Phone As String
        Get
            Phone = _Phone
        End Get
        Set(value As String)
            _Phone = value
        End Set
    End Property

    Public Property FeedbackPromptDate() As String
        Get
            FeedbackPromptDate = _FeedbackPromptDate
        End Get
        Set(ByVal value As String)
            _FeedbackPromptDate = value
        End Set
    End Property


End Class
