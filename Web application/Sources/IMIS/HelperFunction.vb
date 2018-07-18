
Public Class HelperFunction
    'Nepali to english date conversion function by Nirmal
    Public Function ConvertNepaliTOEnglish(day As String, month As String, year As String) As String

        Try
            Dim nepalidate As NCCSNepaliDateLib.NepaliDate = New NCCSNepaliDateLib.NepaliDate
            nepalidate.SetNepaliDate(Convert.ToInt16(year), Convert.ToInt16(month), Convert.ToInt16(day))
            Dim ENGDate As DateTime = nepalidate.GetEnglishDate()
            Return ENGDate.ToString("dd/MM/yyyy")

        Catch ex As Exception
            Return ""
        End Try

    End Function
    'English to nepali date conversion new function by Nirmal
    Public Function ConvertNepaliTOEnglishNew(ByVal nepDate As String) As String
        Try
            If (String.IsNullOrEmpty(nepDate)) Then
                Return ""
            End If
            Dim nepalidate As NCCSNepaliDateLib.NepaliDate = New NCCSNepaliDateLib.NepaliDate
            Dim NepDateArray() As String = Split(nepDate, "/")
            nepalidate.SetNepaliDate(Convert.ToInt16(NepDateArray(2)), Convert.ToInt16(NepDateArray(1)), Convert.ToInt16(NepDateArray(0)))
            Dim ENGDate As DateTime = nepalidate.GetEnglishDate()
            Return ENGDate.ToString("dd/MM/yyyy")

        Catch ex As Exception
            Return ""
        End Try
    End Function
    'English to nepali date conversion function by Nirmal
    Public Function ConverEnglishTONepali(EngDate As String) As String
        If (String.IsNullOrEmpty(EngDate)) Then
            Return ""
        End If

        Dim Nyear As Short
        Dim Nmonth As Short
        Dim Nday As Short
        Dim EngDateArray() As String = Split(EngDate, "/")
        Dim nepalidate As NCCSNepaliDateLib.NepaliDate = New NCCSNepaliDateLib.NepaliDate
        Dim englishDate As DateTime = New DateTime()
        Try

            englishDate = New DateTime(Convert.ToInt16(EngDateArray(2)), Convert.ToInt16(EngDateArray(1)), Convert.ToInt16(EngDateArray(0)))

        Catch ex As Exception
            englishDate = DateTime.Today
        End Try
        nepalidate.SetEnglishDate(englishDate.Date)
        nepalidate.GetNepaliDate(Nyear, Nmonth, Nday)
        Dim NepaliDateString As String = ""
        '= +"/" + Nmonth.ToString() + "/" + Nyear.ToString()
        If (Nday.ToString().Length = 1) Then
            NepaliDateString = "0" + Nday.ToString()
        Else
            NepaliDateString = Nday.ToString()
        End If
        NepaliDateString = NepaliDateString + "/"
        If (Nmonth.ToString().Length = 1) Then
            NepaliDateString = NepaliDateString + "0" + Nmonth.ToString()
        Else
            NepaliDateString = NepaliDateString + Nmonth.ToString()
        End If
        NepaliDateString = NepaliDateString + "/" + Nyear.ToString()
        Return NepaliDateString

    End Function
    'Function to get current nepali year by Nirmal
    Public Function GetCurrentNepaliYear() As String
        Dim nepaliYear As String = ""
        Dim englishDate As DateTime = Today.Date
        Dim nepalidate As NCCSNepaliDateLib.NepaliDate = New NCCSNepaliDateLib.NepaliDate
        Dim Nyear As Short
        Dim Nmonth As Short
        Dim Nday As Short
        Try

            nepalidate.SetEnglishDate(englishDate.Date)
            nepalidate.GetNepaliDate(Nyear, Nmonth, Nday)
            nepaliYear = Nyear.ToString()
        Catch ex As Exception
            nepaliYear = ""
        End Try
        Return nepaliYear
    End Function
    'Function to get current nepali month by Nirmal
    Public Function GetCurrentNepaliMonth() As String
        Dim nepaliMonth As String = ""
        Dim englishDate As DateTime = Today.Date
        Dim nepalidate As NCCSNepaliDateLib.NepaliDate = New NCCSNepaliDateLib.NepaliDate
        Dim Nyear As Short
        Dim Nmonth As Short
        Dim Nday As Short
        Try

            nepalidate.SetEnglishDate(englishDate.Date)
            nepalidate.GetNepaliDate(Nyear, Nmonth, Nday)
            nepaliMonth = Nmonth.ToString()
        Catch ex As Exception
            nepaliMonth = ""
        End Try
        Return nepaliMonth
    End Function
    'Function to get current nepali day by Nirmal
    Public Function GetCurrentNepaliDay() As String
        Dim nepaliDay As String = ""
        Dim englishDate As DateTime = Today.Date
        Dim nepalidate As NCCSNepaliDateLib.NepaliDate = New NCCSNepaliDateLib.NepaliDate
        Dim Nyear As Short
        Dim Nmonth As Short
        Dim Nday As Short
        Try

            nepalidate.SetEnglishDate(englishDate.Date)
            nepalidate.GetNepaliDate(Nyear, Nmonth, Nday)
            nepaliDay = Nday.ToString()
        Catch ex As Exception
            nepaliDay = ""
        End Try
        Return nepaliDay
    End Function
End Class
