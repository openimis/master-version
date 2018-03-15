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


Public Class tblIMISDefaults

    Private _DefaultID As Int32
    Private _PolicyRenewalInterval As Int32?
    Private _FTPHost As String
    Private _FTPUser As String
    Private _FTPPassword As String
    Private _FTPPort As Int32?
    Private _FTPEnrollmentFolder As String
    Private _AssociatedPhotoFolder As String
    Private _FTPClaimFolder As String
    Private _FTPFeedbackFolder As String
    Private _FTPPolicyRenewalFolder As String
    Private _FTPPhoneExtractFolder As String
    Private _FTPOffLineExtractFolder As String
    Private _AppVersionBackEnd As Decimal?
    Private _AppVersionEnquire As Decimal?
    Private _AppVersionEnroll As Decimal?
    Private _AppVersionRenewal As Decimal?
    Private _AppVersionFeedback As Decimal?
    Private _AppVersionClaim As Decimal?
    Private _AppVersionFeedbackRenewal As Decimal?
    Private _OffLineHF As Int32?
    Private _WinRarFolder As String
    Private _DatabaseBackupFolder As String
    Private _OfflineCHF As Int32?


    Public Property [DefaultID] As Int32
        Get
            [DefaultID] = _DefaultID
        End Get
        Set(Value As Int32)
            _DefaultID = Value
        End Set
    End Property
    Public Property [PolicyRenewalInterval] As Int32?
        Get
            [PolicyRenewalInterval] = _PolicyRenewalInterval
        End Get
        Set(Value As Int32?)
            _PolicyRenewalInterval = Value
        End Set
    End Property
    Public Property [FTPHost] As String
        Get
            [FTPHost] = _FTPHost
        End Get
        Set(Value As String)
            _FTPHost = Value
        End Set
    End Property
    Public Property [FTPUser] As String
        Get
            [FTPUser] = _FTPUser
        End Get
        Set(Value As String)
            _FTPUser = Value
        End Set
    End Property
    Public Property [FTPPassword] As String
        Get
            [FTPPassword] = _FTPPassword
        End Get
        Set(Value As String)
            _FTPPassword = Value
        End Set
    End Property
    Public Property [FTPPort] As Int32?
        Get
            [FTPPort] = _FTPPort
        End Get
        Set(Value As Int32?)
            _FTPPort = Value
        End Set
    End Property
    Public Property [FTPEnrollmentFolder] As String
        Get
            [FTPEnrollmentFolder] = _FTPEnrollmentFolder
        End Get
        Set(Value As String)
            _FTPEnrollmentFolder = Value
        End Set
    End Property
    Public Property [AssociatedPhotoFolder] As String
        Get
            [AssociatedPhotoFolder] = _AssociatedPhotoFolder
        End Get
        Set(Value As String)
            _AssociatedPhotoFolder = Value
        End Set
    End Property
    Public Property [FTPClaimFolder] As String
        Get
            [FTPClaimFolder] = _FTPClaimFolder
        End Get
        Set(Value As String)
            _FTPClaimFolder = Value
        End Set
    End Property
    Public Property [FTPFeedbackFolder] As String
        Get
            [FTPFeedbackFolder] = _FTPFeedbackFolder
        End Get
        Set(Value As String)
            _FTPFeedbackFolder = Value
        End Set
    End Property
    Public Property [FTPPolicyRenewalFolder] As String
        Get
            [FTPPolicyRenewalFolder] = _FTPPolicyRenewalFolder
        End Get
        Set(Value As String)
            _FTPPolicyRenewalFolder = Value
        End Set
    End Property
    Public Property [FTPPhoneExtractFolder] As String
        Get
            [FTPPhoneExtractFolder] = _FTPPhoneExtractFolder
        End Get
        Set(Value As String)
            _FTPPhoneExtractFolder = Value
        End Set
    End Property
    Public Property [FTPOffLineExtractFolder] As String
        Get
            [FTPOffLineExtractFolder] = _FTPOffLineExtractFolder
        End Get
        Set(Value As String)
            _FTPOffLineExtractFolder = Value
        End Set
    End Property
    Public Property [AppVersionBackEnd] As Decimal?
        Get
            [AppVersionBackEnd] = _AppVersionBackEnd
        End Get
        Set(Value As Decimal?)
            _AppVersionBackEnd = Value
        End Set
    End Property
    Public Property [AppVersionEnquire] As Decimal?
        Get
            [AppVersionEnquire] = _AppVersionEnquire
        End Get
        Set(Value As Decimal?)
            _AppVersionEnquire = Value
        End Set
    End Property
    Public Property [AppVersionEnroll] As Decimal?
        Get
            [AppVersionEnroll] = _AppVersionEnroll
        End Get
        Set(Value As Decimal?)
            _AppVersionEnroll = Value
        End Set
    End Property
    Public Property [AppVersionRenewal] As Decimal?
        Get
            [AppVersionRenewal] = _AppVersionRenewal
        End Get
        Set(Value As Decimal?)
            _AppVersionRenewal = Value
        End Set
    End Property
    Public Property [AppVersionFeedback] As Decimal?
        Get
            [AppVersionFeedback] = _AppVersionFeedback
        End Get
        Set(Value As Decimal?)
            _AppVersionFeedback = Value
        End Set
    End Property
    Public Property [AppVersionClaim] As Decimal?
        Get
            [AppVersionClaim] = _AppVersionClaim
        End Get
        Set(Value As Decimal?)
            _AppVersionClaim = Value
        End Set
    End Property
    Public Property [AppVersionFeedbackRenewal] As Decimal?
        Get
            [AppVersionFeedbackRenewal] = _AppVersionFeedbackRenewal
        End Get
        Set(Value As Decimal?)
            _AppVersionFeedbackRenewal = Value
        End Set
    End Property
    Public Property [OffLineHF] As Int32?
        Get
            [OffLineHF] = _OffLineHF
        End Get
        Set(Value As Int32?)
            _OffLineHF = Value
        End Set
    End Property
    Public Property [WinRarFolder] As String
        Get
            [WinRarFolder] = _WinRarFolder
        End Get
        Set(Value As String)
            _WinRarFolder = Value
        End Set
    End Property
    Public Property [DatabaseBackupFolder] As String
        Get
            [DatabaseBackupFolder] = _DatabaseBackupFolder
        End Get
        Set(Value As String)
            _DatabaseBackupFolder = Value
        End Set
    End Property
    Public Property [OfflineCHF] As Int32?
        Get
            [OfflineCHF] = _OfflineCHF
        End Get
        Set(Value As Int32?)
            _OfflineCHF = Value
        End Set
    End Property


End Class
