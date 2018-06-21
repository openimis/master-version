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


Public Class FTP
    Dim _Host As String
    Dim _UsernName As String
    Dim _Password As String
    Dim _Port As Integer
    Dim _FTPEnrollmentFolder As String
    Dim _FTPClaimFolder As String
    Dim _FTPFeedbackFolder As String
    Dim _FTPPolicyRenewalFolder As String


    Public Property Host() As String
        Get
            Host = _Host
        End Get
        Set(ByVal value As String)
            _Host = value
        End Set
    End Property

    Public Property UserName() As String
        Get
            UserName = _UsernName
        End Get
        Set(ByVal value As String)
            _UsernName = value
        End Set
    End Property

    Public Property Password() As String
        Get
            Password = _Password
        End Get
        Set(ByVal value As String)
            _Password = value
        End Set
    End Property

    Public Property Port() As Integer
        Get
            Port = _Port
        End Get
        Set(ByVal value As Integer)
            _Port = value
        End Set
    End Property

    Public Property FTPEnrollmentFolder() As String
        Get
            FTPEnrollmentFolder = _FTPEnrollmentFolder
        End Get
        Set(ByVal value As String)
            _FTPEnrollmentFolder = value
        End Set
    End Property

    Public Property FTPClaimFolder() As String
        Get
            FTPClaimFolder = _FTPClaimFolder
        End Get
        Set(ByVal value As String)
            _FTPClaimFolder = value
        End Set
    End Property

    Public Property FTPFeedbackFolder() As String
        Get
            FTPFeedbackFolder = _FTPFeedbackFolder
        End Get
        Set(ByVal value As String)
            _FTPFeedbackFolder = value
        End Set
    End Property

    Public Property FTPPolicyRenewalFolder() As String
        Get
            FTPPolicyRenewalFolder = _FTPPolicyRenewalFolder
        End Get
        Set(ByVal value As String)
            _FTPPolicyRenewalFolder = value
        End Set
    End Property
End Class
