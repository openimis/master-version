
--<<<<<<<<<<<<<<<<<<<<< SCRIPT TO INSERT INITIAL VALUES TO DIMENSIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--SET Age Dimension

DELETE FROM tblDimAge;

DBCC CHECKIDENT(tblDimAge,RESEED,0);

INSERT INTO tblDimAge(AgeRange,AgeLow,AgeHigh)
SELECT N'Below 1' AgeRange,0 AgeLow,NULL AgeHigh UNION ALL
SELECT N'1-5' AgeRange,1 AgeLow,5 AgeHigh UNION ALL
SELECT N'6-10' AgeRange,6 AgeLow,10 AgeHigh UNION ALL
SELECT N'11-15' AgeRange,11 AgeLow,15 AgeHigh UNION ALL
SELECT N'16-20' AgeRange,16 AgeLow,20 AgeHigh UNION ALL
SELECT N'21-25' AgeRange,21 AgeLow,25 AgeHigh UNION ALL
SELECT N'26-30' AgeRange,26 AgeLow,30 AgeHigh UNION ALL
SELECT N'31-35' AgeRange,31 AgeLow,35 AgeHigh UNION ALL
SELECT N'36-40' AgeRange,36 AgeLow,40 AgeHigh UNION ALL
SELECT N'41-45' AgeRange,41 AgeLow,45 AgeHigh UNION ALL
SELECT N'46-50' AgeRange,46 AgeLow,50 AgeHigh UNION ALL
SELECT N'51-55' AgeRange,51 AgeLow,55 AgeHigh UNION ALL 
SELECT N'56-60' AgeRange,56 AgeLow,60 AgeHigh UNION ALL
SELECT N'61-65' AgeRange,61 AgeLow,65 AgeHigh UNION ALL
SELECT N'66-70' AgeRange,66 AgeLow,70 AgeHigh UNION ALL
SELECT N'71-75' AgeRange,71 AgeLow,75 AgeHigh UNION ALL
SELECT N'76-80' AgeRange,76 AgeLow,80 AgeHigh UNION ALL
SELECT N'80+' AgeRange,81 AgeLow,200 AgeHigh


--SET Gender Dimensions

DELETE FROM tblDimGender;
DBCC CHECKIDENT(tblDimGender,RESEED,0);

INSERT INTO tblDimGender(GenderCode,GenderName)
SELECT N'M' GenderCode,N'Male' UNION ALL
SELECT N'F' GenderCode,N'Female' UNION ALL
SELECT N'O' GenderCode,N'Other'

--SET Category Care Dimension

DELETE FROM tblDimCategoryCare;
DBCC CHECKIDENT(tblDimCategoryCare,RESEED,0);

INSERT INTO tblDimCategoryCare(CategoryCareCode,CategoryCare)
SELECT N'E',N'Emeregency' UNION ALL
SELECT N'R',N'Referral' UNION ALL
SELECT N'O',N'Other' 


--SET Care Type Dimension
DELETE FROM tblDimCareType;
DBCC CHECKIDENT(tblDimCareType,RESEED,0);

INSERT INTO tblDimCareType(CareType)
SELECT N'I' UNION ALL
SELECT N'O';

--SET Feedback Questions
DELETE FROM tblDimQuestions;
DBCC CHECKIDENT(tblDimQuestions, RESEED,0)

INSERT INTO tblDimQuestions(Question)
SELECT N'Care Rendered' UNION ALL
SELECT N'Payment Asked' UNION ALL
SELECT N'Drug Prescribed' UNION ALL
SELECT N'Drug Received';
