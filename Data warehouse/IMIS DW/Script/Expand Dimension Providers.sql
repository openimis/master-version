IF (SELECT COL_LENGTH(N'tblDimProviders',N'District')) IS NULL
ALTER TABLE tblDimProviders ADD District NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblDimProviders',N'Region')) IS NULL
ALTER TABLE tblDimProviders ADD Region NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempServiceExpenditures',N'HFDistrict')) IS NULL
ALTER TABLE tblTempServiceExpenditures ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempServiceExpenditures',N'HFRegion')) IS NULL
ALTER TABLE tblTempServiceExpenditures ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempItemExpenditures',N'HFDistrict')) IS NULL
ALTER TABLE tblTempItemExpenditures ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempItemExpenditures',N'HFRegion')) IS NULL
ALTER TABLE tblTempItemExpenditures ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempServiceUtilization',N'HFDistrict')) IS NULL
ALTER TABLE tblTempServiceUtilization ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempServiceUtilization',N'HFRegion')) IS NULL
ALTER TABLE tblTempServiceUtilization ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempItemUtilization',N'HFDistrict')) IS NULL
ALTER TABLE tblTempItemUtilization ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempItemUtilization',N'HFRegion')) IS NULL
ALTER TABLE tblTempItemUtilization ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempHospitalAdmissions',N'HFDistrict')) IS NULL
ALTER TABLE tblTempHospitalAdmissions ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempHospitalAdmissions',N'HFRegion')) IS NULL
ALTER TABLE tblTempHospitalAdmissions ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempVisits',N'HFDistrict')) IS NULL
ALTER TABLE tblTempVisits ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempVisits',N'HFRegion')) IS NULL
ALTER TABLE tblTempVisits ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempHospitalDays',N'HFDistrict')) IS NULL
ALTER TABLE tblTempHospitalDays ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempHospitalDays',N'HFRegion')) IS NULL
ALTER TABLE tblTempHospitalDays ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempClaimSent',N'HFDistrict')) IS NULL
ALTER TABLE tblTempClaimSent ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempClaimSent',N'HFRegion')) IS NULL
ALTER TABLE tblTempClaimSent ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempAmountClaimed',N'HFDistrict')) IS NULL
ALTER TABLE tblTempAmountClaimed ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempAmountClaimed',N'HFRegion')) IS NULL
ALTER TABLE tblTempAmountClaimed ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempAmountApproved',N'HFDistrict')) IS NULL
ALTER TABLE tblTempAmountApproved ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempAmountApproved',N'HFRegion')) IS NULL
ALTER TABLE tblTempAmountApproved ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempAmountRejected',N'HFDistrict')) IS NULL
ALTER TABLE tblTempAmountRejected ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempAmountRejected',N'HFRegion')) IS NULL
ALTER TABLE tblTempAmountRejected ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempNumberFeedbacksent',N'HFDistrict')) IS NULL
ALTER TABLE tblTempNumberFeedbacksent ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempNumberFeedbacksent',N'HFRegion')) IS NULL
ALTER TABLE tblTempNumberFeedbacksent ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempNumberFeedbackResponded',N'HFDistrict')) IS NULL
ALTER TABLE tblTempNumberFeedbackResponded ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempNumberFeedbackResponded',N'HFRegion')) IS NULL
ALTER TABLE tblTempNumberFeedbackResponded ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tbLTempNumberFeedbackAnswerYes',N'HFDistrict')) IS NULL
ALTER TABLE tbLTempNumberFeedbackAnswerYes ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tbLTempNumberFeedbackAnswerYes',N'HFRegion')) IS NULL
ALTER TABLE tbLTempNumberFeedbackAnswerYes ADD HFRegion NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempOverallAssessment',N'HFDistrict')) IS NULL
ALTER TABLE tblTempOverallAssessment ADD HFDistrict NVARCHAR(50);

IF (SELECT COL_LENGTH(N'tblTempOverallAssessment',N'HFRegion')) IS NULL
ALTER TABLE tblTempOverallAssessment ADD HFRegion NVARCHAR(50);

IF NOT OBJECT_ID('uspInsertDimProviders') IS NULL
DROP PROCEDURE uspInsertDimProviders
GO

CREATE PROCEDURE [dbo].[uspInsertDimProviders]
AS
BEGIN
	INSERT INTO tblDimProviders(ProviderCategory,ProviderCode,ProviderName, District, Region)
	SELECT DISTINCT SE.HFLevel, SE.HFCode, SE.HFName, SE.HFDistrict, SE.HFRegion
	FROM tblTempServiceExpenditures SE LEFT OUTER JOIN tblDimProviders P ON SE.HFLevel = P.ProviderCategory
																		AND SE.HFCode = P.ProviderCode
																		AND SE.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL

	UNION

	SELECT DISTINCT IE.HFLevel, IE.HFCode, IE.HFName, IE.HFDistrict, IE.HFRegion
	FROM tblTempItemExpenditures IE LEFT OUTER JOIN tblDimProviders P ON IE.HFLevel = P.ProviderCategory
																		AND IE.HFCode = P.ProviderCode
																		AND IE.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL
		
	UNION

	SELECT DISTINCT SU.HFLevel, SU.HFCode, SU.HFName, SU.HFDistrict, SU.HFRegion
	FROM tblTempServiceUtilization SU LEFT OUTER JOIN tblDimProviders P ON SU.HFLevel = P.ProviderCategory
																		AND SU.HFCode = P.ProviderCode
																		AND SU.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL

	UNION

	SELECT DISTINCT IU.HFLevel, IU.HFCode, IU.HFName, IU.HFDistrict, IU.HFRegion
	FROM tblTempItemUtilization IU LEFT OUTER JOIN tblDimProviders P ON IU.HFLevel = P.ProviderCategory
																		AND IU.HFCode = P.ProviderCode
																		AND IU.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL

	UNION

	SELECT DISTINCT A.HFLevel, A.HFCode, A.HFName, A.HFDistrict, A.HFRegion
	FROM tblTempHospitalAdmissions A LEFT OUTER JOIN tblDimProviders P ON A.HFLevel = P.ProviderCategory
																		AND A.HFCode = P.ProviderCode
																		AND A.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL
	
	UNION

	SELECT DISTINCT V.HFLevel, V.HFCode, V.HFName, V.HFDistrict, V.HFRegion
	FROM tblTempVisits V LEFT OUTER JOIN tblDimProviders P ON V.HFLevel = P.ProviderCategory
																		AND V.HFCode = P.ProviderCode
																		AND V.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL

	UNION

	SELECT DISTINCT HD.HFLevel, HD.HFCode, HD.HFName, HD.HFDistrict, HD.HFRegion
	FROM tblTempHospitalDays HD LEFT OUTER JOIN tblDimProviders P ON HD.HFLevel = P.ProviderCategory
																		AND HD.HFCode = P.ProviderCode
																		AND HD.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL

	UNION

	SELECT DISTINCT CS.HFLevel, CS.HFCode, CS.HFName, CS.HFDistrict, CS.HFRegion
	FROM tblTempClaimSent CS LEFT OUTER JOIN tblDimProviders P ON CS.HFLevel = P.ProviderCategory
																		AND CS.HFCode = P.ProviderCode
																		AND CS.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL
	
	UNION

	SELECT DISTINCT AC.HFLevel, AC.HFCode, AC.HFName, AC.HFDistrict, AC.HFRegion
	FROM tblTempAmountClaimed AC LEFT OUTER JOIN tblDimProviders P ON AC.HFLevel = P.ProviderCategory
																		AND AC.HFCode = P.ProviderCode
																		AND AC.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL

	UNION

	SELECT DISTINCT AP.HFLevel, AP.HFCode, AP.HFName, AP.HFDistrict, AP.HFRegion
	FROM tblTempAmountApproved AP LEFT OUTER JOIN tblDimProviders P ON AP.HFLevel = P.ProviderCategory
																		AND AP.HFCode = P.ProviderCode
																		AND AP.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL
	
	UNION

	SELECT DISTINCT AR.HFLevel, AR.HFCode, AR.HFName, AR.HFDistrict, AR.HFRegion
	FROM tblTempAmountRejected AR LEFT OUTER JOIN tblDimProviders P ON AR.HFLevel = P.ProviderCategory
																		AND AR.HFCode = P.ProviderCode
																		AND AR.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL

	UNION

	SELECT DISTINCT FS.HFLevel, FS.HFCode, FS.HFName, FS.HFDistrict, FS.HFRegion
	FROM tblTempNumberFeedbacksent FS LEFT OUTER JOIN tblDimProviders P ON FS.HFLevel = P.ProviderCategory
																		AND FS.HFCode = P.ProviderCode
																		AND FS.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL
	
	UNION

	SELECT DISTINCT FR.HFLevel, FR.HFCode, FR.HFName, FR.HFDistrict, FR.HFRegion
	FROM tblTempNumberFeedbackResponded FR LEFT OUTER JOIN tblDimProviders P ON FR.HFLevel = P.ProviderCategory
																		AND FR.HFCode = P.ProviderCode
																		AND FR.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL

	UNION

	SELECT DISTINCT FA.HFLevel, FA.HFCode, FA.HFName, FA.HFDistrict, FA.HFRegion
	FROM tbLTempNumberFeedbackAnswerYes FA LEFT OUTER JOIN tblDimProviders P ON FA.HFLevel = P.ProviderCategory
																		AND FA.HFCode = P.ProviderCode
																		AND FA.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL

	UNION

	SELECT DISTINCT A.HFLevel, A.HFCode, A.HFName, A.HFDistrict, A.HFRegion
	FROM tblTempOverallAssessment A LEFT OUTER JOIN tblDimProviders P ON A.HFLevel = P.ProviderCategory
																		AND A.HFCode = P.ProviderCode
																		AND A.HFName = P.ProviderName
	WHERE P.ProviderCategory IS NULL
	AND P.ProviderCode IS NULL
	AND P.ProviderName IS NULL

END
GO
