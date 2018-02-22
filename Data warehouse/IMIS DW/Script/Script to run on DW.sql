/*=============================================================
Script to run on Data Warehouse database
=============================================================*/
--ON 22/11/2016
ALTER TABLE tblDimProducts ALTER COLUMN ProductName NVARCHAR(100) NULL
GO

--ON 30/11/2016
IF NOT OBJECT_ID('uspInsertFactItemUtilization') IS NULL
DROP PROCEDURE uspInsertFactItemUtilization
GO

CREATE PROCEDURE [dbo].[uspInsertFactItemUtilization]
AS
BEGIN

	BEGIN TRY
		BEGIN TRAN ItemvUti
			--Disable all the constraint
			ALTER TABLE tblFactUtilizationItems NOCHECK CONSTRAINT ALL;

			INSERT INTO tblFactUtilizationItems(ItemsUtilized,TimeDimId,ProductDimId,AgeDimId,GenderDimId,ItemDimId,CareTypeDimId,ProviderDimId, DiseaseDimId, RegionDimId, CategoryCareDimId)
			SELECT SUM(IU.ItemUtilized)ITemUtilized, T.TimeDimId, Prod.ProductDimId, A.AgeDimId,G.GenderDimId, I.ItemDimId, CT.CareTypeDimId, PR.ProviderDimId, D.DiseaseDimId, R.RegionDimId, CC.CategoryCareDimId
			FROM tblTempItemUtilization IU LEFT OUTER JOIN tblDimTime T ON IU.MonthTime = T.MonthTime AND IU.QuarterTime = T.QuarterTime AND IU.YearTime = T.YearTime
			LEFT OUTER JOIN tblDimProducts Prod ON ISNULL(IU.DistrictName,'') = ISNULL(Prod.District,'') AND IU.ProductCode = Prod.ProductCode AND IU.ProductName = Prod.ProductName
			LEFT OUTER JOIN tblDimAge A ON IU.Age BETWEEN A.AgeLow AND ISNULL(A.AgeHigh,0)
			LEFT OUTER JOIN tblDimGender G ON IU.Gender = G.GenderCode
			LEFT OUTER JOIN tblDimItems I ON IU.ItemType = I.ItemCategory AND IU.ItemCode = I.ItemCode AND IU.ItemName = I.ItemName
			LEFT OUTER JOIN tblDimCareType CT ON IU.ItemCareType = CT.CareType
			LEFT OUTER JOIN tblDimProviders PR ON IU.HFLevel = PR.ProviderCategory AND IU.HFCode = PR.ProviderCode AND IU.HFName = PR.ProviderName
			LEFT OUTER JOIN tblDimDisease D ON IU.ICDCode = D.DiseaseCode AND IU.ICDName = D.DiseaseName
			LEFT OUTER JOIN tblDimRegion R ON IU.Region = R.Region AND IU.IDistrictName = R.District AND IU.WardName = R.Ward AND IU.VillageName = R.Village
			LEFT OUTER JOIN tblDimCategoryCare CC ON IU.VisitType = CC.CategoryCareCode
			GROUP BY T.TimeDimId, Prod.ProductDimId, A.AgeDimId,G.GenderDimId, I.ItemDimId, CT.CareTypeDimId, PR.ProviderDimId, D.DiseaseDimId, R.RegionDimId, CC.CategoryCareDimId
			--Enable all the constraint
			ALTER TABLE tblFactUtilizationItems WITH CHECK CHECK CONSTRAINT ALL;

		COMMIT TRAN ItemvUti
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN ItemvUti
		RAISERROR('Error occured',16,1);
	END CATCH
END
GO

IF NOT OBJECT_ID('uspInsertFactItemExpenditures') IS NULL
DROP PROCEDURE uspInsertFactItemExpenditures
GO

CREATE PROCEDURE [dbo].[uspInsertFactItemExpenditures]
AS
BEGIN

	BEGIN TRY
		BEGIN TRAN ItemExp
			--Disable all the constraint
			ALTER TABLE tblFactItemExpenditures NOCHECK CONSTRAINT ALL;

			INSERT INTO tblFactItemExpenditures(ItemExpenditures,TimeDimId,ProductDimId,AgeDimId,GenderDimId,ItemDimId,CareTypeDimId,ProviderDimId,CategoryCareDimId, RegionDimId, DiseaseDimId)
			SELECT IE.ItemExpenditure, T.TimeDimId, Prod.ProductDimId, A.AgeDimId,G.GenderDimId, I.ItemDimId, CT.CareTypeDimId, PR.ProviderDimId,CC.CategoryCareDimId, R.RegionDimId, D.DiseaseDimId
			FROM tblTempItemExpenditures IE INNER JOIN tblDimTime T ON IE.MonthTime = T.MonthTime AND IE.QuarterTime = T.QuarterTime AND IE.YearTime = T.YearTime
			INNER JOIN tblDimProducts Prod ON ISNULL(IE.DistrictName, '') = ISNULL(Prod.District, '') AND IE.ProductCode = Prod.ProductCode AND IE.ProductName = Prod.ProductName
			INNER JOIN tblDimAge A ON IE.Age BETWEEN A.AgeLow AND ISNULL(A.AgeHigh,0)
			INNER JOIN tblDimGender G ON IE.Gender = G.GenderCode
			INNER JOIN tblDimItems I ON IE.ItemType = I.ItemCategory AND IE.ItemCode = I.ItemCode AND IE.ItemName = I.ItemName
			INNER JOIN tblDimCareType CT ON IE.ItemCareType = CT.CareType
			INNER JOIN tblDimProviders PR ON IE.HFLevel = PR.ProviderCategory AND IE.HFCode = PR.ProviderCode AND IE.HFName = PR.ProviderName
			INNER JOIN tblDimCategoryCare CC ON IE.VisitType = CC.CategoryCareCode
			INNER JOIN tblDimRegion R ON R.Region = IE.Region AND R.District = IE.IDistrictName AND R.Ward = IE.WardName AND R.Village = IE.VillageName
			INNER JOIN tblDimDisease D ON IE.ICDCode = D.DiseaseCode AND IE.ICDName = D.DiseaseName

			--Enable all the constraint
			ALTER TABLE tblFactItemExpenditures WITH CHECK CHECK CONSTRAINT ALL;
		COMMIT TRAN ItemExp
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN ItemExp
		RAISERROR('Error occured',16,1);
	END CATCH
END
GO

IF NOT OBJECT_ID('uspInsertFactServiceUtilization') IS NULL
DROP PROCEDURE uspInsertFactServiceUtilization
GO

CREATE PROCEDURE [dbo].[uspInsertFactServiceUtilization]
AS
BEGIN

	BEGIN TRY
		BEGIN TRAN ServUti
			--Disable all the constraint
			ALTER TABLE tblFactUtilizationServices NOCHECK CONSTRAINT ALL;

			INSERT INTO tblFactUtilizationServices(ServiceUtilized,TimeDimId,ProductDimId,AgeDimId,GenderDimId,ServiceDimId,CareTypeDimId,ProviderDimId,CategoryCareDimId, DiseaseDImId, RegionDimId)
			SELECT SUM(SU.ServiceUtilized)ServiceUtilized, T.TimeDimId, Prod.ProductDimId, A.AgeDimId,G.GenderDimId, S.ServiceDimId, CT.CareTypeDimId, PR.ProviderDimId,CC.CategoryCareDimId, D.DiseaseDimId, R.RegionDimId
			FROM tblTempServiceUtilization SU LEFT OUTER JOIN tblDimTime T ON SU.MonthTime = T.MonthTime AND SU.QuarterTime = T.QuarterTime AND SU.YearTime = T.YearTime
			LEFT OUTER JOIN tblDimProducts Prod ON ISNULL(SU.DistrictName, '') = ISNULL(Prod.District, '') AND SU.ProductCode = Prod.ProductCode AND SU.ProductName = Prod.ProductName
			LEFT OUTER JOIN tblDimAge A ON SU.Age BETWEEN A.AgeLow AND ISNULL(A.AgeHigh,0)
			LEFT OUTER JOIN tblDimGender G ON SU.Gender = G.GenderCode
			LEFT OUTER JOIN tblDimServices S ON SU.ServType = S.ServiceCategory AND SU.ServCode = S.ServiceCode AND SU.ServName = S.ServiceName
			LEFT OUTER JOIN tblDimCareType CT ON SU.ServCareType = CT.CareType
			LEFT OUTER JOIN tblDimProviders PR ON SU.HFLevel = PR.ProviderCategory AND SU.HFCode = PR.ProviderCode AND SU.HFName = PR.ProviderName
			LEFT OUTER JOIN tblDimCategoryCare CC ON SU.VisitType = CC.CategoryCareCode
			LEFT OUTER JOIN tblDimDisease D ON SU.ICDCode = D.DiseaseCode AND SU.ICDName = D.DiseaseName
			LEFT OUTER JOIN tblDimRegion R ON SU.Region = R.Region AND SU.IDistrictName = R.District AND SU.WardName = R.Ward AND SU.VillageName = R.Village
			GROUP BY T.TimeDimId, Prod.ProductDimId, A.AgeDimId,G.GenderDimId, S.ServiceDimId, CT.CareTypeDimId, PR.ProviderDimId,CC.CategoryCareDimId, D.DiseaseDimId, R.RegionDimId


			--Enable all the constraint
			ALTER TABLE tblFactUtilizationServices WITH CHECK CHECK CONSTRAINT ALL;

		COMMIT TRAN ServUti
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN ServUti
		RAISERROR('Error occured',16,1);
	END CATCH
END
GO

IF NOT OBJECT_ID('uspInsertFactServiceExpenditures') IS NULL
DROP PROCEDURE uspInsertFactServiceExpenditures
GO

CREATE PROCEDURE [dbo].[uspInsertFactServiceExpenditures]
AS
BEGIN

	BEGIN TRY
		BEGIN TRAN ServExp
			--Disable all the constraint
			ALTER TABLE tblFactServiceExpenditures NOCHECK CONSTRAINT ALL;

			INSERT INTO tblFactServiceExpenditures(ServiceExpenditures,TimeDimId,ProductDimId,AgeDimId,GenderDimId,ServiceDimId,CareTypeDimId,ProviderDimId,CategoryCareDimId, DiseaseDimId, RegionDimId)
			SELECT SE.ServiceExpenditure, T.TimeDimId, Prod.ProductDimId, A.AgeDimId,G.GenderDimId, S.ServiceDimId, CT.CareTypeDimId, PR.ProviderDimId,CC.CategoryCareDimId, D.DiseaseDimId, R.RegionDimId
			FROM tblTempServiceExpenditures SE INNER JOIN tblDimTime T ON SE.MonthTime = T.MonthTime AND SE.QuarterTime = T.QuarterTime AND SE.YearTime = T.YearTime
			INNER JOIN tblDimProducts Prod ON ISNULL(SE.DistrictName, '') = ISNULL(Prod.District, '') AND SE.ProductCode = Prod.ProductCode AND SE.ProductName = Prod.ProductName
			INNER JOIN tblDimAge A ON SE.Age BETWEEN A.AgeLow AND ISNULL(A.AgeHigh,0)
			INNER JOIN tblDimGender G ON SE.Gender = G.GenderCode
			INNER JOIN tblDimServices S ON SE.ServType = S.ServiceCategory AND SE.ServCode = S.ServiceCode AND SE.ServName = S.ServiceName
			INNER JOIN tblDimCareType CT ON SE.ServCareType = CT.CareType
			INNER JOIN tblDimProviders PR ON SE.HFLevel = PR.ProviderCategory AND SE.HFCode = PR.ProviderCode AND SE.HFName = PR.ProviderName
			INNER JOIN tblDimCategoryCare CC ON SE.VisitType = CC.CategoryCareCode
			INNER JOIN tblDimDisease D ON SE.ICDCode = D.DiseaseCode AND SE.ICDName = D.DiseaseName
			INNER JOIN tblDimRegion R ON SE.Region = R.Region AND SE.IDistrictName = R.District AND SE.WardName = R.Ward AND SE.VillageName = R.Village

			--Enable all the constraint
			ALTER TABLE tblFactServiceExpenditures WITH CHECK CHECK CONSTRAINT ALL;
		COMMIT TRAN ServExp
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN ServExp
		RAISERROR('Error occured',16,1);
	END CATCH
END
GO

IF NOT COL_LENGTH(N'tblTempNumberInsureeAcquired', N'Region') IS NULL
ALTER TABLE tblTempNumberInsureeAcquired ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempNumberPoliciesSold', N'Region') IS NULL
ALTER TABLE tblTempNumberPoliciesSold ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempPolicyRenewal', N'Region') IS NULL
ALTER TABLE tblTempPolicyRenewal ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempPremiumCollection', N'Region') IS NULL
ALTER TABLE tblTempPremiumCollection ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempServiceExpenditures', N'Region') IS NULL
ALTER TABLE tblTempServiceExpenditures ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempItemExpenditures', N'Region') IS NULL
ALTER TABLE tblTempItemExpenditures ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempServiceUtilization', N'Region') IS NULL
ALTER TABLE tblTempServiceUtilization ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempItemUtilization', N'Region') IS NULL
ALTER TABLE tblTempItemUtilization ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempHospitalAdmissions', N'Region') IS NULL
ALTER TABLE tblTempHospitalAdmissions ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempVisits', N'Region') IS NULL
ALTER TABLE tblTempVisits ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempHospitalDays', N'Region') IS NULL
ALTER TABLE tblTempHospitalDays ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempClaimSent', N'Region') IS NULL
ALTER TABLE tblTempClaimSent ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempAmountClaimed', N'Region') IS NULL
ALTER TABLE tblTempAmountClaimed ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempAmountApproved', N'Region') IS NULL
ALTER TABLE tblTempAmountApproved ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempAmountRejected', N'Region') IS NULL
ALTER TABLE tblTempAmountRejected ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempAmountValuated', N'Region') IS NULL
ALTER TABLE tblTempAmountValuated ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempNumberFeedbacksent', N'Region') IS NULL
ALTER TABLE tblTempNumberFeedbacksent ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempNumberFeedbackResponded', N'Region') IS NULL
ALTER TABLE tblTempNumberFeedbackResponded ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tbLTempNumberFeedbackAnswerYes', N'Region') IS NULL
ALTER TABLE tbLTempNumberFeedbackAnswerYes ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempExpenditure', N'Region') IS NULL
ALTER TABLE tblTempExpenditure ALTER COLUMN Region NVARCHAR(50)
GO

IF NOT COL_LENGTH(N'tblTempOverallAssessment', N'Region') IS NULL
ALTER TABLE tblTempOverallAssessment ALTER COLUMN Region NVARCHAR(50)
GO

--ON 01/12/2016

IF OBJECT_ID('tblTempNumberOfInsuredHouseholds') IS NULL
BEGIN
	CREATE TABLE tblTempNumberOfInsuredHouseholds(
		InsuredHouseholds INT,
		MonthTime INT,
		QuarterTime INT,
		YearTime INT,
		Region NVARCHAR(50),
		DistrictName NVARCHAR(50),
		WardName NVARCHAR(50),
		VillageName NVARCHAR(50)
	)

PRINT N'tblTempNumberOfInsuredHouseholds Table Created'
END
GO

IF OBJECT_ID('tblFactNumberOfInsuredHouseholds') IS NULL
BEGIN
	CREATE TABLE tblFactNumberOfInsuredHouseholds(
		InsuredHouseholds INT,
		TimeDimId INT CONSTRAINT FK_tblFactNumberOfInsuredHouseholds_tblDimTime FOREIGN KEY REFERENCES tblDimTime(TimeDimId),
		RegionDimId INT CONSTRAINT FK_tblFactNumberOfInsuredHouseholds_tblDimRegion FOREIGN KEY REFERENCES tblDimRegion(RegionDimId)
	)

PRINT N'tblFactNumberOfInsuredHouseholds Table Created'
END
GO

IF NOT OBJECT_ID('uspInsertDimRegion') IS NULL
DROP PROCEDURE uspInsertDimRegion
GO

CREATE PROCEDURE [dbo].[uspInsertDimRegion]
AS
BEGIN
	INSERT INTO tblDimRegion(Region,District,Ward,Village)
	SELECT DISTINCT CI.Region,CI.InsureeDistrictName,CI.WardName,CI.VillageName
	FROM tblTempNumberInsureeCurrent CI LEFT OUTER JOIN tblDimRegion R ON CI.Region = R.Region
																	AND CI.InsureeDistrictName = R.District
																	AND CI.WardName = R.Ward
																	AND CI.VillageName = R.Village
	WHERE R.Region IS NULL
	AND R.District IS NULL
	AND R.Ward IS NULL
	AND R.Village IS NULL

	UNION 

	SELECT DISTINCT AI.Region,AI.InsDistrict,AI.InsWard,AI.InsVillage
	FROM tblTempNumberInsureeAcquired AI LEFT OUTER JOIN tblDimRegion R ON AI.Region = R.Region
																	AND AI.InsDistrict = R.District
																	AND AI.InsWard = R.Ward
																	AND AI.InsVillage = R.Village
	WHERE R.Region IS NULL
	AND R.District IS NULL
	AND R.Ward IS NULL
	AND R.Village IS NULL

	UNION 

	SELECT DISTINCT CP.Region,CP.InsureeDistrictName,CP.WardName,CP.VillageName
	FROM tblTempNumberPolicyCurrent CP LEFT OUTER JOIN tblDimRegion R ON CP.Region = R.Region
																	AND CP.InsureeDistrictName = R.District
																	AND CP.WardName = R.Ward
																	AND CP.VillageName = R.Village
	WHERE R.Region IS NULL
	AND R.District IS NULL
	AND R.Ward IS NULL
	AND R.Village IS NULL

	UNION 

	SELECT DISTINCT PS.Region,PS.InsDistrict,PS.InsWard,PS.InsVillage
	FROM tblTempNumberPoliciesSold PS LEFT OUTER JOIN tblDimRegion R ON PS.Region = R.Region
																	AND PS.InsDistrict = R.District
																	AND PS.InsWard = R.Ward
																	AND PS.InsVillage = R.Village
	WHERE R.Region IS NULL
	AND R.District IS NULL
	AND R.Ward IS NULL
	AND R.Village IS NULL

	UNION 

	SELECT DISTINCT PR.Region,PR.InsureeDistrictName,PR.WardName,PR.VillageName
	FROM tblTempPolicyRenewal PR LEFT OUTER JOIN tblDimRegion R ON PR.Region = R.Region
																	AND PR.InsureeDistrictName = R.District
																	AND PR.WardName = R.Ward
																	AND PR.VillageName = R.Village
	WHERE R.Region IS NULL
	AND R.District IS NULL
	AND R.Ward IS NULL
	AND R.Village IS NULL

	UNION 

	SELECT DISTINCT PE.Region,PE.InsureeDistrictName,PE.WardName,PE.VillageName
	FROM tblTempNumberPolicyExpired PE LEFT OUTER JOIN tblDimRegion R ON PE.Region = R.Region
																	AND PE.InsureeDistrictName = R.District
																	AND PE.WardName = R.Ward
																	AND PE.VillageName = R.Village
	WHERE R.Region IS NULL
	AND R.District IS NULL
	AND R.Ward IS NULL
	AND R.Village IS NULL

	UNION 

	SELECT DISTINCT IE.Region,IE.IDistrictName,IE.WardName,IE.VillageName
	FROM tblTempItemExpenditures IE LEFT OUTER JOIN tblDimRegion R ON IE.Region = R.Region
																	AND IE.IDistrictName = R.District
																	AND IE.WardName = R.Ward
																	AND IE.VillageName = R.Village
	WHERE R.Region IS NULL
	AND R.District IS NULL
	AND R.Ward IS NULL
	AND R.Village IS NULL

	UNION

	SELECT DISTINCT IH.Region Region, IH.DistrictName, IH.WardName ,IH.VillageName
	FROM tblTEmpNumberOfInsuredHouseholds IH LEFT OUTER JOIN tblDimRegion R ON IH.Region = R.Region
																	AND IH.DistrictName = R.District
																	AND IH.WardName = R.Ward
																	AND IH.VillageName = R.Village
	WHERE R.Region IS NULL
	AND R.District IS NULL
	AND R.Ward IS NULL
	AND R.Village IS NULL

END
GO

PRINT N'uspInsertDimRegion is dropped and created'

IF NOT OBJECT_ID('uspInsertDimTime') IS NULL
DROP PROCEDURE uspInsertDimTime
GO

CREATE PROCEDURE [dbo].[uspInsertDimTime]
AS
BEGIN

	INSERT INTO tblDimTime(MonthTime,QuarterTime,YearTime)
	
	SELECT DISTINCT CI.MonthTime,CI.QuarterTime, CI.YearTime
	FROM tblTempNumberInsureeCurrent CI LEFT OUTER JOIN tblDimTime T ON CI.MonthTime = T.MonthTime
															AND CI.QuarterTime = T.QuarterTime
															AND CI.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 

	SELECT DISTINCT AI.MonthTime,AI.QuarterTime, AI.YearTime
	FROM tblTempNumberInsureeAcquired AI LEFT OUTER JOIN tblDimTime T ON AI.MonthTime = T.MonthTime
															AND AI.QuarterTime = T.QuarterTime
															AND AI.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 

	SELECT DISTINCT CP.MonthTime,CP.QuarterTime, CP.YearTime
	FROM tblTempNumberPolicyCurrent CP LEFT OUTER JOIN tblDimTime T ON CP.MonthTime = T.MonthTime
															AND CP.QuarterTime = T.QuarterTime
															AND CP.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 

	SELECT DISTINCT PS.MonthTime,PS.QuarterTime, PS.YearTime
	FROM tblTempNumberPoliciesSold PS LEFT OUTER JOIN tblDimTime T ON PS.MonthTime = T.MonthTime
															AND PS.QuarterTime = T.QuarterTime
															AND PS.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 

	SELECT DISTINCT PR.MonthTime,PR.QuarterTime, PR.YearTime
	FROM tblTempPolicyRenewal PR LEFT OUTER JOIN tblDimTime T ON PR.MonthTime = T.MonthTime
															AND PR.QuarterTime = T.QuarterTime
															AND PR.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL
	
	UNION 

	SELECT DISTINCT PE.MonthTime,PE.QuarterTime, PE.YearTime
	FROM tblTempNumberPolicyExpired PE LEFT OUTER JOIN tblDimTime T ON PE.MonthTime = T.MonthTime
															AND PE.QuarterTime = T.QuarterTime
															AND PE.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT PC.MonthTime,PC.QuarterTime, PC.YearTime
	FROM tblTempPremiumCollection PC LEFT OUTER JOIN tblDimTime T ON PC.MonthTime = T.MonthTime
															AND PC.QuarterTime = T.QuarterTime
															AND PC.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT SE.MonthTime,SE.QuarterTime, SE.YearTime
	FROM tblTempServiceExpenditures SE LEFT OUTER JOIN tblDimTime T ON SE.MonthTime = T.MonthTime
															AND SE.QuarterTime = T.QuarterTime
															AND SE.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT IE.MonthTime,IE.QuarterTime, IE.YearTime
	FROM tblTempItemExpenditures IE LEFT OUTER JOIN tblDimTime T ON IE.MonthTime = T.MonthTime
															AND IE.QuarterTime = T.QuarterTime
															AND IE.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL


	UNION 
	
	SELECT DISTINCT SU.MonthTime,SU.QuarterTime, SU.YearTime
	FROM tblTempServiceUtilization SU LEFT OUTER JOIN tblDimTime T ON SU.MonthTime = T.MonthTime
															AND SU.QuarterTime = T.QuarterTime
															AND SU.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL


	UNION 
	
	SELECT DISTINCT IU.MonthTime,IU.QuarterTime, IU.YearTime
	FROM tblTempItemUtilization IU LEFT OUTER JOIN tblDimTime T ON IU.MonthTime = T.MonthTime
															AND IU.QuarterTime = T.QuarterTime
															AND IU.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT A.MonthTime,A.QuarterTime, A.YearTime
	FROM tblTempHospitalAdmissions A LEFT OUTER JOIN tblDimTime T ON A.MonthTime = T.MonthTime
															AND A.QuarterTime = T.QuarterTime
															AND A.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT V.MonthTime,V.QuarterTime, V.YearTime
	FROM tblTempVisits V LEFT OUTER JOIN tblDimTime T ON V.MonthTime = T.MonthTime
															AND V.QuarterTime = T.QuarterTime
															AND V.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT HD.MonthTime,HD.QuarterTime, HD.YearTime
	FROM tblTempHospitalDays HD LEFT OUTER JOIN tblDimTime T ON HD.MonthTime = T.MonthTime
															AND HD.QuarterTime = T.QuarterTime
															AND HD.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT CS.MonthTime,CS.QuarterTime, CS.YearTime
	FROM tblTempClaimSent CS LEFT OUTER JOIN tblDimTime T ON CS.MonthTime = T.MonthTime
															AND CS.QuarterTime = T.QuarterTime
															AND CS.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT AC.MonthTime,AC.QuarterTime, AC.YearTime
	FROM tblTempAmountClaimed AC LEFT OUTER JOIN tblDimTime T ON AC.MonthTime = T.MonthTime
															AND AC.QuarterTime = T.QuarterTime
															AND AC.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL


	UNION 
	
	SELECT DISTINCT AP.MonthTime,AP.QuarterTime, AP.YearTime
	FROM tblTempAmountApproved AP LEFT OUTER JOIN tblDimTime T ON AP.MonthTime = T.MonthTime
															AND AP.QuarterTime = T.QuarterTime
															AND AP.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT AR.MonthTime,AR.QuarterTime, AR.YearTime
	FROM tblTempAmountRejected AR LEFT OUTER JOIN tblDimTime T ON AR.MonthTime = T.MonthTime
															AND AR.QuarterTime = T.QuarterTime
															AND AR.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL


	UNION 
	
	SELECT DISTINCT FS.MonthTime,FS.QuarterTime, FS.YearTime
	FROM tblTempNumberFeedbacksent FS LEFT OUTER JOIN tblDimTime T ON FS.MonthTime = T.MonthTime
															AND FS.QuarterTime = T.QuarterTime
															AND FS.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT FR.MonthTime,FR.QuarterTime, FR.YearTime
	FROM tblTempNumberFeedbackResponded FR LEFT OUTER JOIN tblDimTime T ON FR.MonthTime = T.MonthTime
															AND FR.QuarterTime = T.QuarterTime
															AND FR.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT FA.MonthTime,FA.QuarterTime, FA.YearTime
	FROM tblTempNumberFeedbackAnswerYes FA LEFT OUTER JOIN tblDimTime T ON FA.MonthTime = T.MonthTime
															AND FA.QuarterTime = T.QuarterTime
															AND FA.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT A.MonthTime,A.QuarterTime, A.YearTime
	FROM tblTempOverallAssessment A LEFT OUTER JOIN tblDimTime T ON A.MonthTime = T.MonthTime
															AND A.QuarterTime = T.QuarterTime
															AND A.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL


	
	UNION 
	
	SELECT DISTINCT E.MonthTime,E.QuarterTime, E.YearTime
	FROM tbLTempClaimEntered E LEFT OUTER JOIN tblDimTime T ON E.MonthTime = T.MonthTime
															AND E.QuarterTime = T.QuarterTime
															AND E.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL


	UNION 
	
	SELECT DISTINCT S.MonthTime,S.QuarterTime, S.YearTime
	FROM tblTempClaimSubmitted S LEFT OUTER JOIN tblDimTime T ON S.MonthTime = T.MonthTime
															AND S.QuarterTime = T.QuarterTime
															AND S.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION 
	
	SELECT DISTINCT P.MonthTime,P.QuarterTime, P.YearTime
	FROM tblTempClaimProcessed P LEFT OUTER JOIN tblDimTime T ON P.MonthTime = T.MonthTime
															AND P.QuarterTime = T.QuarterTime
															AND P.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL


	UNION 
	
	SELECT DISTINCT R.MonthTime,R.QuarterTime, R.YearTime
	FROM tbLTempClaimRejected R LEFT OUTER JOIN tblDimTime T ON R.MonthTime = T.MonthTime
															AND R.QuarterTime = T.QuarterTime
															AND R.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL


	UNION

	SELECT DISTINCT A.MonthTime,A.QuarterTime, A.YearTime
	FROM tblTempPremiumAllocation A LEFT OUTER JOIN tblDimTime T ON A.MonthTime = T.MonthTime
															AND A.QuarterTime = T.QuarterTime
															AND A.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL


	UNION

	SELECT DISTINCT CV.MonthTime,CV.QuarterTime, CV.YearTime
	FROM tblTempClaimValuated CV LEFT OUTER JOIN tblDimTime T ON CV.MonthTime = T.MonthTime
															AND CV.QuarterTime = T.QuarterTime
															AND CV.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL


	UNION

	SELECT DISTINCT AV.MonthTime,AV.QuarterTime, AV.YearTime
	FROM tblTempAmountValuated AV LEFT OUTER JOIN tblDimTime T ON AV.MonthTime = T.MonthTime
															AND AV.QuarterTime = T.QuarterTime
															AND AV.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

	UNION

	SELECT DISTINCT IH.MonthTime,IH.QuarterTime, IH.YearTime
	FROM tblTEmpNumberOfInsuredHouseholds IH LEFT OUTER JOIN tblDimTime T ON IH.MonthTime = T.MonthTime
															AND IH.QuarterTime = T.QuarterTime
															AND IH.YearTime = T.YearTime
	WHERE T.MonthTime IS NULL
	AND T.QuarterTime IS NULL
	AND T.YearTime IS NULL

END
GO

PRINT N'uspInsertDimTime is dropped and created';

IF NOT OBJECT_ID('uspInsertFactNumberOfInsuredHouseholds') IS NULL
DROP PROCEDURE uspInsertFactNumberOfInsuredHouseholds
GO

CREATE PROCEDURE [dbo].[uspInsertFactNumberOfInsuredHouseholds]
AS
BEGIN

	BEGIN TRY
		BEGIN TRAN Households
			--Disable all the constraint
			ALTER TABLE tblFactNumberOfInsuredHouseholds NOCHECK CONSTRAINT ALL;

			INSERT INTO tblFactNumberOfInsuredHouseholds(InsuredHouseholds, TimeDimId, RegionDimId)
			SELECT IH.InsuredHouseholds ,T.TimeDimId, R.RegionDimId
			FROM tblTEmpNumberOfInsuredHouseholds IH INNER JOIN tblDimTime T ON IH.MonthTime = T.MonthTime AND IH.QuarterTime = T.QuarterTime AND IH.YearTime = T.YearTime
			INNER JOIN tblDimRegion R ON IH.Region = R.Region AND IH.DistrictName = R.District AND IH.WardName = R.Ward AND IH.VillageName = R.Village

			--Enable all the constraint
			ALTER TABLE tblFactNumberOfInsuredHouseholds WITH CHECK CHECK CONSTRAINT ALL;
		COMMIT TRAN Households
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Households
		RAISERROR('Error occured',16,1);
	END CATCH
END
GO

PRINT N'uspInsertFactNumberOfInsuredHouseholds is dropped and created'

--ON 02/12/2016
ALTER TABLE tblDimProducts ALTER COLUMN ProductName NVARCHAR(100)
GO

ALTER TABLE tblTempPremiumAllocation ALTER COLUMN ProductName NVARCHAR(100)
GO

--ON 20/12/2016
IF COL_LENGTH(N'tblTempClaimProcessed', N'Region') IS NULL
ALTER TABLE tblTempClaimProcessed ADD Region NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempClaimProcessed', N'HFRegion') IS NULL
ALTER TABLE tblTempClaimProcessed ADD HFRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempClaimValuated', N'Region') IS NULL
ALTER TABLE tblTempClaimValuated ADD Region NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempClaimValuated', N'HFRegion') IS NULL
ALTER TABLE tblTempClaimValuated ADD HFRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempAmountValuated', N'Region') IS NULL
ALTER TABLE tblTempAmountValuated ADD Region NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempAmountValuated', N'HFRegion') IS NULL
ALTER TABLE tblTempAmountValuated ADD HFRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempNumberInsureeCurrent', N'ProdRegion') IS NULL
ALTER TABLE tblTempNumberInsureeCurrent ADD ProdRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempNumberInsureeAcquired', N'ProdRegion') IS NULL
ALTER TABLE tblTempNumberInsureeAcquired ADD ProdRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempNumberPolicyCurrent', N'ProdRegion') IS NULL
ALTER TABLE tblTempNumberPolicyCurrent ADD ProdRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempNumberPoliciesSold', N'ProdRegion') IS NULL
ALTER TABLE tblTempNumberPoliciesSold ADD ProdRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempPolicyRenewal', N'ProdRegion') IS NULL
ALTER TABLE tblTempPolicyRenewal ADD ProdRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempNumberPolicyExpired', N'ProdRegion') IS NULL
ALTER TABLE tblTempNumberPolicyExpired ADD ProdRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempServiceExpenditures', N'ProdRegion') IS NULL
ALTER TABLE tblTempServiceExpenditures ADD ProdRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempItemExpenditures', N'ProdRegion') IS NULL
ALTER TABLE tblTempItemExpenditures ADD ProdRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempServiceUtilization', N'ProdRegion') IS NULL
ALTER TABLE tblTempServiceUtilization ADD ProdRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempItemUtilization', N'ProdRegion') IS NULL
ALTER TABLE tblTempItemUtilization ADD ProdRegion NVARCHAR(50)
GO

IF NOT OBJECT_ID('uspInsertDimProducts') IS NULL
DROP PROCEDURE uspInsertDimProducts
GO

--ON 22/11/2016
CREATE PROCEDURE [dbo].[uspInsertDimProducts]
AS
BEGIN
	;WITH FullProductDim AS
	(
		SELECT DISTINCT CI.ProdRegion,CI.ProdDistrictName,CI.ProductCode,CI.ProductName
		FROM tblTempNumberInsureeCurrent CI LEFT OUTER JOIN tblDimProducts Prod
																		ON CI.ProdRegion = Prod.Region 
																		AND ISNULL(CI.ProdDistrictName, '') = ISNULL(Prod.District, '')
																		AND CI.ProductCode = Prod.ProductCode
																		AND CI.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL
	

		UNION 

		SELECT DISTINCT AI.ProdRegion,AI.ProdDistrict,AI.ProductCode,AI.ProductName
		FROM tblTempNumberInsureeAcquired AI LEFT OUTER JOIN tblDimProducts Prod 
																		ON AI.ProdRegion = Prod.Region
																		AND ISNULL(AI.ProdDistrict, '') = ISNULL(Prod.District, '')
																		AND AI.ProductCode = Prod.ProductCode
																		AND AI.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT CP.ProdRegion,CP.ProdDistrictName,CP.ProductCode,CP.ProductName
		FROM tblTempNumberPolicyCurrent CP LEFT OUTER JOIN tblDimProducts Prod 
																		ON CP.ProdRegion = Prod.Region
																		AND ISNULL(CP.ProdDistrictName, '') = ISNULL(Prod.District, '')
																		AND CP.ProductCode = Prod.ProductCode
																		AND CP.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT PS.ProdRegion,PS.ProdDistrict,PS.ProductCode,PS.ProductName
		FROM tblTempNumberPoliciesSold PS LEFT OUTER JOIN tblDimProducts Prod 
																		ON PS.ProdRegion = Prod.Region
																		AND ISNULL(PS.ProdDistrict, '') = ISNULL(Prod.District, '')
																		AND PS.ProductCode = Prod.ProductCode
																		AND PS.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL
	
		UNION 

		SELECT DISTINCT PR.ProdRegion,PR.ProdDistrictName,PR.ProductCode,PR.ProductName
		FROM tblTempPolicyRenewal PR LEFT OUTER JOIN tblDimProducts Prod 
																		ON PR.ProdRegion = Prod.Region
																		AND ISNULL(PR.ProdDistrictName, '') = ISNULL(Prod.District, '')
																		AND PR.ProductCode = Prod.ProductCode
																		AND PR.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL
	
		UNION 

		SELECT DISTINCT PE.ProdRegion,PE.ProdDistrictName,PE.ProductCode,PE.ProductName
		FROM tblTempNumberPolicyExpired PE LEFT OUTER JOIN tblDimProducts Prod 
																		ON PE.ProdRegion = Prod.Region
																		AND ISNULL(PE.ProdDistrictName, '') = ISNULL(Prod.District, '')
																		AND PE.ProductCode = Prod.ProductCode
																		AND PE.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT PC.Region,PC.DistrictName,PC.ProductCode,PC.ProductName
		FROM tblTempPremiumCollection PC LEFT OUTER JOIN tblDimProducts Prod 
																		ON PC.Region = Prod.Region			
																		AND ISNULL(PC.DistrictName, '') = ISNULL(Prod.District, '')
																		AND PC.ProductCode = Prod.ProductCode
																		AND PC.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT SE.ProdRegion,SE.DistrictName,SE.ProductCode,SE.ProductName
		FROM tblTempServiceExpenditures SE LEFT OUTER JOIN tblDimProducts Prod 
																		ON SE.ProdRegion = Prod.Region
																		AND ISNULL(SE.DistrictName, '') = ISNULL(Prod.District, '')
																		AND SE.ProductCode = Prod.ProductCode
																		AND SE.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT IE.ProdRegion,IE.DistrictName,IE.ProductCode,IE.ProductName
		FROM tblTempItemExpenditures IE LEFT OUTER JOIN tblDimProducts Prod 
																		ON IE.ProdRegion = Prod.Region
																		AND ISNULL(IE.DistrictName, '') = ISNULL(Prod.District, '')
																		AND IE.ProductCode = Prod.ProductCode
																		AND IE.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL


		UNION 

		SELECT DISTINCT SU.ProdRegion,SU.DistrictName,SU.ProductCode,SU.ProductName
		FROM tblTempServiceUtilization SU LEFT OUTER JOIN tblDimProducts Prod 
																		ON SU.ProdRegion = Prod.Region
																		AND ISNULL(SU.DistrictName, '') = ISNULL(Prod.District, '')
																		AND SU.ProductCode = Prod.ProductCode
																		AND SU.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

	
		UNION 

		SELECT DISTINCT IU.ProdRegion,IU.DistrictName,IU.ProductCode,IU.ProductName
		FROM tblTempItemUtilization IU LEFT OUTER JOIN tblDimProducts Prod 
																		ON IU.ProdRegion = Prod.Region
																		AND ISNULL(IU.DistrictName, '') = ISNULL(Prod.District, '')
																		AND IU.ProductCode = Prod.ProductCode
																		AND IU.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT A.Region,A.DistrictName,A.ProductCode,A.ProductName
		FROM tblTempHospitalAdmissions A LEFT OUTER JOIN tblDimProducts Prod 
																		ON A.Region = Prod.Region
																		AND ISNULL(A.DistrictName, '') = ISNULL(Prod.District, '')
																		AND A.ProductCode = Prod.ProductCode
																		AND A.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT V.Region,V.DistrictName,V.ProductCode,V.ProductName
		FROM tblTempVisits V LEFT OUTER JOIN tblDimProducts Prod 
																ON V.Region = Prod.Region
																AND ISNULL(V.DistrictName, '') = ISNULL(Prod.District, '')
																AND V.ProductCode = Prod.ProductCode
																AND V.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT HD.Region,HD.DistrictName,HD.ProductCode,HD.ProductName
		FROM tblTempHospitalDays HD LEFT OUTER JOIN tblDimProducts Prod 
																		ON HD.Region = Prod.Region
																		AND ISNULL(HD.DistrictName, '') = ISNULL(Prod.District, '')
																		AND HD.ProductCode = Prod.ProductCode
																		AND HD.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT CS.Region,CS.DistrictName,CS.ProductCode,CS.ProductName
		FROM tblTempClaimSent CS LEFT OUTER JOIN tblDimProducts Prod 
																	ON CS.Region = Prod.Region
																	AND ISNULL(CS.DistrictName, '') = ISNULL(Prod.District, '')
																	AND CS.ProductCode = Prod.ProductCode
																	AND CS.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT AC.Region,AC.DistrictName,AC.ProductCode,AC.ProductName
		FROM tblTempAmountClaimed AC LEFT OUTER JOIN tblDimProducts Prod 
																		ON AC.Region = Prod.Region
																		AND ISNULL(AC.DistrictName, '') = ISNULL(Prod.District, '')
																		AND AC.ProductCode = Prod.ProductCode
																		AND AC.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT AP.Region,AP.DistrictName,AP.ProductCode,AP.ProductName
		FROM tblTempAmountApproved AP LEFT OUTER JOIN tblDimProducts Prod 
																		ON AP.Region = Prod.Region
																		AND ISNULL(AP.DistrictName, '') = ISNULL(Prod.District, '')
																		AND AP.ProductCode = Prod.ProductCode
																		AND AP.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT AR.Region,AR.DistrictName,AR.ProductCode,AR.ProductName
		FROM tblTempAmountRejected AR LEFT OUTER JOIN tblDimProducts Prod 
																		ON AR.Region = Prod.Region
																		AND ISNULL(AR.DistrictName, '') = ISNULL(Prod.District, '')
																		AND AR.ProductCode = Prod.ProductCode
																		AND AR.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL


		UNION 

		SELECT DISTINCT FS.Region,FS.DistrictName,FS.ProductCode,FS.ProductName
		FROM tblTempNumberFeedbacksent FS LEFT OUTER JOIN tblDimProducts Prod 
																		ON FS.Region = Prod.Region
																		AND ISNULL(FS.DistrictName, '') = ISNULL(Prod.District, '')
																		AND FS.ProductCode = Prod.ProductCode
																		AND FS.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT FR.Region,FR.DistrictName,FR.ProductCode,FR.ProductName
		FROM tblTempNumberFeedbackResponded FR LEFT OUTER JOIN tblDimProducts Prod 
																		ON FR.Region = Prod.Region
																		AND ISNULL(FR.DistrictName, '') = ISNULL(Prod.District, '')
																		AND FR.ProductCode = Prod.ProductCode
																		AND FR.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT FA.Region,FA.DistrictName,FA.ProductCode,FA.ProductName
		FROM tbLTempNumberFeedbackAnswerYes FA LEFT OUTER JOIN tblDimProducts Prod 
																		ON FA.Region = Prod.Region
																		AND ISNULL(FA.DistrictName, '') = ISNULL(Prod.District, '')
																		AND FA.ProductCode = Prod.ProductCode
																		AND FA.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT A.Region,A.DistrictName,A.ProductCode,A.ProductName
		FROM tblTempOverallAssessment A LEFT OUTER JOIN tblDimProducts Prod 
																		ON A.Region = Prod.Region
																		AND ISNULL(A.DistrictName, '') = ISNULL(Prod.District, '')
																		AND A.ProductCode = Prod.ProductCode
																		AND A.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL


		UNION 

		SELECT DISTINCT A.Region,A.DistrictName,A.ProductCode,A.ProductName
		FROM tblTempPremiumAllocation A LEFT OUTER JOIN tblDimProducts Prod 
																		ON A.Region = Prod.Region
																		AND ISNULL(A.DistrictName, '') = ISNULL(Prod.District, '')
																		AND A.ProductCode = Prod.ProductCode
																		AND A.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL


		UNION 

		SELECT DISTINCT CP.Region,CP.DistrictName,CP.ProductCode,CP.ProductName
		FROM tblTempClaimProcessed CP LEFT OUTER JOIN tblDimProducts Prod 
																		ON CP.Region = Prod.Region
																		AND ISNULL(CP.DistrictName, '') = ISNULL(Prod.District, '')
																		AND CP.ProductCode = Prod.ProductCode
																		AND CP.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL


		UNION 

		SELECT DISTINCT CV.Region,CV.DistrictName,CV.ProductCode,CV.ProductName
		FROM tblTempClaimValuated CV LEFT OUTER JOIN tblDimProducts Prod 
																		ON CV.Region = Prod.Region
																		AND ISNULL(CV.DistrictName, '') = ISNULL(Prod.District, '')
																		AND CV.ProductCode = Prod.ProductCode
																		AND CV.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL


		UNION 

		SELECT DISTINCT AV.Region,AV.DistrictName,AV.ProductCode,AV.ProductName
		FROM tblTempAmountValuated AV LEFT OUTER JOIN tblDimProducts Prod 
																		ON AV.Region = Prod.Region
																		AND ISNULL(AV.DistrictName, '') = ISNULL(Prod.District, '')
																		AND AV.ProductCode = Prod.ProductCode
																		AND AV.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL
	)
	
	INSERT INTO tblDimProducts(Region,District,ProductCode,ProductName)
	SELECT ProdRegion, ProdDistrictName, ProductCode, ProductName
	FROM FullProductDim
	GROUP BY ProdRegion, ProdDistrictName, ProductCode, ProductName
	ORDER BY ProdRegion, ProdDistrictName




	DELETE FROM tblDimProducts WHERE ProductCode IS NULL AND ProductName IS NULL;

	

END

GO

IF COL_LENGTH(N'tbLTempClaimEntered', N'HFRegion') IS NULL
ALTER TABLE tbLTempClaimEntered ADD HFRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tbLTempClaimRejected', N'HFRegion') IS NULL
ALTER TABLE tbLTempClaimRejected ADD HFRegion NVARCHAR(50)
GO

IF COL_LENGTH(N'tblTempClaimSubmitted', N'HFRegion') IS NULL
ALTER TABLE tblTempClaimSubmitted ADD HFRegion NVARCHAR(50)
GO

--ON 06/02/2016 Rogers starts
IF NOT OBJECT_ID('[uspInsertFactHospitalDays]') IS NULL
DROP PROCEDURE [uspInsertFactHospitalDays]
GO
CREATE PROCEDURE [dbo].[uspInsertFactHospitalDays]
AS
BEGIN

	BEGIN TRY
		BEGIN TRAN HospDays
			--Disable all the constraint
			ALTER TABLE tblFactHospitalDays NOCHECK CONSTRAINT ALL;

			INSERT INTO tblFactHospitalDays(HospitalDays, TimeDimId, ProductDimId, AgeDimId,GenderDimId, DiseaseDimId, ProviderDimId, CategoryCareDimId)
			SELECT SUM(HD.HospitalDays)HospitalDays, T.TimeDimId, Prod.ProductDimId, Age.AgeDimId, G.GenderDimId, D.DiseaseDimId,PR.ProviderDimId, CC.CategoryCareDimId
			FROM tblTempHospitalDays HD 
			LEFT OUTER JOIN  tblDimTime T ON HD.MonthTime = T.MonthTime AND HD.QuarterTime = T.QuarterTime AND HD.YearTime = T.YearTime
			LEFT OUTER JOIN tblDimProducts Prod ON ISNULL(HD.DistrictName, '') = ISNULL(Prod.District, '') 
			AND HD.ProductCode = Prod.ProductCode 
			AND HD.ProductName = Prod.ProductName  
			AND Prod.Region IS NOT NULL
			LEFT OUTER JOIN  tblDimAge Age ON HD.Age BETWEEN Age.AgeLow AND ISNULL(Age.AgeHigh,0)
			LEFT OUTER JOIN  tblDimGender G ON HD.Gender = G.GenderCode
			LEFT OUTER JOIN  tblDimProviders PR ON HD.HFLevel = PR.ProviderCategory AND HD.HFCode = PR.ProviderCode AND HD.HFName = PR.ProviderName
			LEFT OUTER JOIN tblDimCategoryCare CC ON HD.VisitType = CC.CategoryCareCode
			LEFT OUTER JOIN  tblDimDisease D ON HD.ICDCode = D.DiseaseCode AND HD.ICDName = D.DiseaseName
			GROUP BY T.TimeDimId, Prod.ProductDimId, Age.AgeDimId, G.GenderDimId, D.DiseaseDimId,PR.ProviderDimId, CC.CategoryCareDimId

			--Enable all the constraint
			ALTER TABLE tblFactHospitalDays WITH CHECK CHECK CONSTRAINT ALL;
		COMMIT TRAN HospDays
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN HospDays
		RAISERROR('Error occured',16,1);
	END CATCH
END
GO
IF NOT OBJECT_ID('[uspInsertFactAdmissions]') IS NULL
DROP PROCEDURE [uspInsertFactAdmissions]
GO
CREATE PROCEDURE [dbo].[uspInsertFactAdmissions]
AS
BEGIN

	BEGIN TRY
		BEGIN TRAN Adm
			--Disable all the constraint
			ALTER TABLE tblFactAdmissions NOCHECK CONSTRAINT ALL;

			INSERT INTO tblFactAdmissions(Admissions, TimeDimId, ProductDimId, AgeDimId,GenderDimId, DiseaseDimId, ProviderDimId, CategoryCareDimId)
			SELECT SUM(A.Admissions)Admissions, T.TimeDimId, Prod.ProductDimId, Age.AgeDimId, G.GenderDimId, D.DiseaseDimId,PR.ProviderDimId, CC.CategoryCareDimId
			FROM tblTempHospitalAdmissions A LEFT OUTER JOIN  tblDimTime T ON A.MonthTime = T.MonthTime AND A.QuarterTime = T.QuarterTime AND A.YearTime = T.YearTime
			LEFT OUTER JOIN tblDimProducts Prod ON ISNULL(A.DistrictName, '') = ISNULL(Prod.District, '') 
			AND A.ProductCode = Prod.ProductCode 
			AND A.ProductName = Prod.ProductName
			AND Prod.Region IS NOT NULL
			LEFT OUTER JOIN  tblDimAge Age ON A.Age BETWEEN Age.AgeLow AND ISNULL(Age.AgeHigh,0)
			LEFT OUTER JOIN  tblDimGender G ON A.Gender = G.GenderCode
			LEFT OUTER JOIN  tblDimProviders PR ON A.HFLevel = PR.ProviderCategory AND A.HFCode = PR.ProviderCode AND A.HFName = PR.ProviderName
			LEFT OUTER JOIN tblDimCategoryCare CC ON A.VisitType = CC.CategoryCareCode
			LEFT OUTER JOIN  tblDimDisease D ON A.ICDCode = D.DiseaseCode AND A.ICDName = D.DiseaseName
			GROUP BY T.TimeDimId, Prod.ProductDimId, Age.AgeDimId, G.GenderDimId, D.DiseaseDimId,PR.ProviderDimId, CC.CategoryCareDimId

			--Enable all the constraint
			ALTER TABLE tblFactAdmissions WITH CHECK CHECK CONSTRAINT ALL;
		COMMIT TRAN Adm
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Adm
		RAISERROR('Error occured',16,1);
	END CATCH
END
GO
IF NOT OBJECT_ID('[uspInsertFactVisits]') IS NULL
DROP PROCEDURE [uspInsertFactVisits]
GO
CREATE PROCEDURE [dbo].[uspInsertFactVisits]
AS
BEGIN

	BEGIN TRY
		BEGIN TRAN Visits
			--Disable all the constraint
			ALTER TABLE tblFactVisits NOCHECK CONSTRAINT ALL;

			INSERT INTO tblFactVisits(Visits, TimeDimId, ProductDimId, AgeDimId,GenderDimId, DiseaseDimId, ProviderDimId, CategoryCareDimId)
			SELECT V.Visits, T.TimeDimId, Prod.ProductDimId, Age.AgeDimId, G.GenderDimId, D.DiseaseDimId,PR.ProviderDimId, CC.CategoryCareDimId
			FROM tblTempVisits V INNER JOIN tblDimTime T ON V.MonthTime = T.MonthTime AND V.QuarterTime = T.QuarterTime AND V.YearTime = T.YearTime
			LEFT OUTER JOIN tblDimProducts Prod ON ISNULL(V.DistrictName, '') = ISNULL(Prod.District, '') 
			AND V.ProductCode = Prod.ProductCode 
			AND V.ProductName = Prod.ProductName
			AND Prod.Region IS NOT NULL
			INNER JOIN tblDimAge Age ON V.Age BETWEEN Age.AgeLow AND ISNULL(Age.AgeHigh,0)
			INNER JOIN tblDimGender G ON V.Gender = G.GenderCode
			INNER JOIN tblDimProviders PR ON V.HFLevel = PR.ProviderCategory AND V.HFCode = PR.ProviderCode AND V.HFName = PR.ProviderName
			INNER JOIN tblDimCategoryCare CC ON V.VisitType = CC.CategoryCareCode
			INNER JOIN tblDimDisease D ON V.ICDCode = D.DiseaseCode AND V.ICDName = D.DiseaseName

			--Enable all the constraint
			ALTER TABLE tblFactVisits WITH CHECK CHECK CONSTRAINT ALL;
		COMMIT TRAN Visits
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Visits
		RAISERROR('Error occured',16,1);
	END CATCH
END
GO



IF OBJECT_ID('[uspInsertDimProducts]') IS NOT NULL
DROP PROCEDURE [uspInsertDimProducts]
GO 
CREATE PROCEDURE [dbo].[uspInsertDimProducts]
AS
BEGIN
	;WITH FullProductDim AS
	(
		SELECT DISTINCT CI.ProdRegion,CI.ProdDistrictName,CI.ProductCode,CI.ProductName
		FROM tblTempNumberInsureeCurrent CI LEFT OUTER JOIN tblDimProducts Prod
																		ON CI.ProdRegion = Prod.Region 
																		AND ISNULL(CI.ProdDistrictName, '') = ISNULL(Prod.District, '')
																		AND CI.ProductCode = Prod.ProductCode
																		AND CI.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL
	

		UNION 

		SELECT DISTINCT AI.ProdRegion,AI.ProdDistrict,AI.ProductCode,AI.ProductName
		FROM tblTempNumberInsureeAcquired AI LEFT OUTER JOIN tblDimProducts Prod 
																		ON AI.ProdRegion = Prod.Region
																		AND ISNULL(AI.ProdDistrict, '') = ISNULL(Prod.District, '')
																		AND AI.ProductCode = Prod.ProductCode
																		AND AI.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT CP.ProdRegion,CP.ProdDistrictName,CP.ProductCode,CP.ProductName
		FROM tblTempNumberPolicyCurrent CP LEFT OUTER JOIN tblDimProducts Prod 
																		ON CP.ProdRegion = Prod.Region
																		AND ISNULL(CP.ProdDistrictName, '') = ISNULL(Prod.District, '')
																		AND CP.ProductCode = Prod.ProductCode
																		AND CP.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT PS.ProdRegion,PS.ProdDistrict,PS.ProductCode,PS.ProductName
		FROM tblTempNumberPoliciesSold PS LEFT OUTER JOIN tblDimProducts Prod 
																		ON PS.ProdRegion = Prod.Region
																		AND ISNULL(PS.ProdDistrict, '') = ISNULL(Prod.District, '')
																		AND PS.ProductCode = Prod.ProductCode
																		AND PS.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL
	
		UNION 

		SELECT DISTINCT PR.ProdRegion,PR.ProdDistrictName,PR.ProductCode,PR.ProductName
		FROM tblTempPolicyRenewal PR LEFT OUTER JOIN tblDimProducts Prod 
																		ON PR.ProdRegion = Prod.Region
																		AND ISNULL(PR.ProdDistrictName, '') = ISNULL(Prod.District, '')
																		AND PR.ProductCode = Prod.ProductCode
																		AND PR.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL
	
		UNION 

		SELECT DISTINCT PE.ProdRegion,PE.ProdDistrictName,PE.ProductCode,PE.ProductName
		FROM tblTempNumberPolicyExpired PE LEFT OUTER JOIN tblDimProducts Prod 
																		ON PE.ProdRegion = Prod.Region
																		AND ISNULL(PE.ProdDistrictName, '') = ISNULL(Prod.District, '')
																		AND PE.ProductCode = Prod.ProductCode
																		AND PE.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT PC.Region,PC.DistrictName,PC.ProductCode,PC.ProductName
		FROM tblTempPremiumCollection PC LEFT OUTER JOIN tblDimProducts Prod 
																		ON PC.Region = Prod.Region			
																		AND ISNULL(PC.DistrictName, '') = ISNULL(Prod.District, '')
																		AND PC.ProductCode = Prod.ProductCode
																		AND PC.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT SE.ProdRegion,SE.DistrictName,SE.ProductCode,SE.ProductName
		FROM tblTempServiceExpenditures SE LEFT OUTER JOIN tblDimProducts Prod 
																		ON SE.ProdRegion = Prod.Region
																		AND ISNULL(SE.DistrictName, '') = ISNULL(Prod.District, '')
																		AND SE.ProductCode = Prod.ProductCode
																		AND SE.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT IE.ProdRegion,IE.DistrictName,IE.ProductCode,IE.ProductName
		FROM tblTempItemExpenditures IE LEFT OUTER JOIN tblDimProducts Prod 
																		ON IE.ProdRegion = Prod.Region
																		AND ISNULL(IE.DistrictName, '') = ISNULL(Prod.District, '')
																		AND IE.ProductCode = Prod.ProductCode
																		AND IE.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL


		UNION 

		SELECT DISTINCT SU.ProdRegion,SU.DistrictName,SU.ProductCode,SU.ProductName
		FROM tblTempServiceUtilization SU LEFT OUTER JOIN tblDimProducts Prod 
																		ON SU.ProdRegion = Prod.Region
																		AND ISNULL(SU.DistrictName, '') = ISNULL(Prod.District, '')
																		AND SU.ProductCode = Prod.ProductCode
																		AND SU.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

	
		UNION 

		SELECT DISTINCT IU.ProdRegion,IU.DistrictName,IU.ProductCode,IU.ProductName
		FROM tblTempItemUtilization IU LEFT OUTER JOIN tblDimProducts Prod 
																		ON IU.ProdRegion = Prod.Region
																		AND ISNULL(IU.DistrictName, '') = ISNULL(Prod.District, '')
																		AND IU.ProductCode = Prod.ProductCode
																		AND IU.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT A.Region,A.DistrictName,A.ProductCode,A.ProductName
		FROM tblTempHospitalAdmissions A LEFT OUTER JOIN tblDimProducts Prod 
																		ON A.Region = Prod.Region
																		AND ISNULL(A.DistrictName, '') = ISNULL(Prod.District, '')
																		AND A.ProductCode = Prod.ProductCode
																		AND A.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT V.Region,V.DistrictName,V.ProductCode,V.ProductName
		FROM tblTempVisits V LEFT OUTER JOIN tblDimProducts Prod 
																ON V.Region = Prod.Region
																AND ISNULL(V.DistrictName, '') = ISNULL(Prod.District, '')
																AND V.ProductCode = Prod.ProductCode
																AND V.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT HD.Region,HD.DistrictName,HD.ProductCode,HD.ProductName
		FROM tblTempHospitalDays HD LEFT OUTER JOIN tblDimProducts Prod 
																		ON HD.Region = Prod.Region
																		AND ISNULL(HD.DistrictName, '') = ISNULL(Prod.District, '')
																		AND HD.ProductCode = Prod.ProductCode
																		AND HD.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT CS.Region,CS.DistrictName,CS.ProductCode,CS.ProductName
		FROM tblTempClaimSent CS LEFT OUTER JOIN tblDimProducts Prod 
																	ON CS.Region = Prod.Region
																	AND ISNULL(CS.DistrictName, '') = ISNULL(Prod.District, '')
																	AND CS.ProductCode = Prod.ProductCode
																	AND CS.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT AC.Region,AC.DistrictName,AC.ProductCode,AC.ProductName
		FROM tblTempAmountClaimed AC LEFT OUTER JOIN tblDimProducts Prod 
																		ON AC.Region = Prod.Region
																		AND ISNULL(AC.DistrictName, '') = ISNULL(Prod.District, '')
																		AND AC.ProductCode = Prod.ProductCode
																		AND AC.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT AP.Region,AP.DistrictName,AP.ProductCode,AP.ProductName
		FROM tblTempAmountApproved AP LEFT OUTER JOIN tblDimProducts Prod 
																		ON AP.Region = Prod.Region
																		AND ISNULL(AP.DistrictName, '') = ISNULL(Prod.District, '')
																		AND AP.ProductCode = Prod.ProductCode
																		AND AP.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT AR.Region,AR.DistrictName,AR.ProductCode,AR.ProductName
		FROM tblTempAmountRejected AR LEFT OUTER JOIN tblDimProducts Prod 
																		ON AR.Region = Prod.Region
																		AND ISNULL(AR.DistrictName, '') = ISNULL(Prod.District, '')
																		AND AR.ProductCode = Prod.ProductCode
																		AND AR.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL


		UNION 

		SELECT DISTINCT FS.Region,FS.DistrictName,FS.ProductCode,FS.ProductName
		FROM tblTempNumberFeedbacksent FS LEFT OUTER JOIN tblDimProducts Prod 
																		ON FS.Region = Prod.Region
																		AND ISNULL(FS.DistrictName, '') = ISNULL(Prod.District, '')
																		AND FS.ProductCode = Prod.ProductCode
																		AND FS.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT FR.Region,FR.DistrictName,FR.ProductCode,FR.ProductName
		FROM tblTempNumberFeedbackResponded FR LEFT OUTER JOIN tblDimProducts Prod 
																		ON FR.Region = Prod.Region
																		AND ISNULL(FR.DistrictName, '') = ISNULL(Prod.District, '')
																		AND FR.ProductCode = Prod.ProductCode
																		AND FR.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT FA.Region,FA.DistrictName,FA.ProductCode,FA.ProductName
		FROM tbLTempNumberFeedbackAnswerYes FA LEFT OUTER JOIN tblDimProducts Prod 
																		ON FA.Region = Prod.Region
																		AND ISNULL(FA.DistrictName, '') = ISNULL(Prod.District, '')
																		AND FA.ProductCode = Prod.ProductCode
																		AND FA.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL

		UNION 

		SELECT DISTINCT A.Region,A.DistrictName,A.ProductCode,A.ProductName
		FROM tblTempOverallAssessment A LEFT OUTER JOIN tblDimProducts Prod 
																		ON A.Region = Prod.Region
																		AND ISNULL(A.DistrictName, '') = ISNULL(Prod.District, '')
																		AND A.ProductCode = Prod.ProductCode
																		AND A.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL


		UNION 

		SELECT DISTINCT A.Region,A.DistrictName,A.ProductCode,A.ProductName
		FROM tblTempPremiumAllocation A LEFT OUTER JOIN tblDimProducts Prod 
																		ON A.Region = Prod.Region
																		AND ISNULL(A.DistrictName, '') = ISNULL(Prod.District, '')
																		AND A.ProductCode = Prod.ProductCode
																		AND A.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL


		UNION 

		SELECT DISTINCT CP.Region,CP.DistrictName,CP.ProductCode,CP.ProductName
		FROM tblTempClaimProcessed CP LEFT OUTER JOIN tblDimProducts Prod 
																		ON CP.Region = Prod.Region
																		AND ISNULL(CP.DistrictName, '') = ISNULL(Prod.District, '')
																		AND CP.ProductCode = Prod.ProductCode
																		AND CP.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL


		UNION 

		SELECT DISTINCT CV.Region,CV.DistrictName,CV.ProductCode,CV.ProductName
		FROM tblTempClaimValuated CV LEFT OUTER JOIN tblDimProducts Prod 
																		ON CV.Region = Prod.Region
																		AND ISNULL(CV.DistrictName, '') = ISNULL(Prod.District, '')
																		AND CV.ProductCode = Prod.ProductCode
																		AND CV.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL


		UNION 

		SELECT DISTINCT AV.Region,AV.DistrictName,AV.ProductCode,AV.ProductName
		FROM tblTempAmountValuated AV LEFT OUTER JOIN tblDimProducts Prod 
																		ON AV.Region = Prod.Region
																		AND ISNULL(AV.DistrictName, '') = ISNULL(Prod.District, '')
																		AND AV.ProductCode = Prod.ProductCode
																		AND AV.ProductName = Prod.ProductName
		WHERE Prod.Region IS NULL 
		AND Prod.District IS NULL
		AND Prod.ProductCode IS NULL
		AND Prod.ProductName IS NULL
	)
	
	INSERT INTO tblDimProducts(Region,District,ProductCode,ProductName)
	SELECT ProdRegion, ProdDistrictName, ProductCode, ProductName
	FROM FullProductDim WHERE ProdRegion IS NOT NULL --ADDED
	GROUP BY ProdRegion, ProdDistrictName, ProductCode, ProductName
	ORDER BY ProdRegion, ProdDistrictName




	DELETE FROM tblDimProducts WHERE ProductCode IS NULL AND ProductName IS NULL;

	

END

--Rogers ends
--ON 28/03/2017

IF COL_LENGTH(N'tblFactAmountApproved', N'AmountApproved') IS NOT NULL
ALTER TABLE tblFactAmountApproved ALTER COLUMN AmountApproved DECIMAL(18, 4)
GO

IF COL_LENGTH(N'tblFactAmountClaimed', N'AmountClaimed') IS NOT NULL
ALTER TABLE tblFactAmountClaimed ALTER COLUMN AmountClaimed DECIMAL(18, 4)
GO

IF COL_LENGTH(N'tblFactAmountRejected', N'AmountRejected') IS NOT NULL
ALTER TABLE tblFactAmountRejected ALTER COLUMN AmountRejected DECIMAL(18, 4)
GO

IF COL_LENGTH(N'tblFactAmountValuated', N'AmountValuated') IS NOT NULL
ALTER TABLE tblFactAmountValuated ALTER COLUMN AmountValuated DECIMAL(18, 4)
GO

--ON 10/08/2017
IF NOT OBJECT_ID('tblTempPopulation') IS NULL
DROP TABLE tblTempPopulation;

CREATE TABLE tblTempPopulation(
	Region NVARCHAR(255),
	District NVARCHAR(255),
	Ward NVARCHAR(255),
	Village NVARCHAR(255),
	Male INT,
	Female INT,
	Other INT,
	Households FLOAT,
	YearTime INT
)
GO


IF NOT OBJECT_ID('uspInsertDimRegion') IS NULL
DROP PROCEDURE uspInsertDimRegion
GO

CREATE PROCEDURE [dbo].[uspInsertDimRegion]
AS
BEGIN
	INSERT INTO tblDimRegion(Region,District,Ward,Village)
	SELECT DISTINCT P.Region, P.District, P.Ward, P.Village
	FROM tblTempPopulation P
	LEFT OUTER JOIN tblDimRegion R ON R.Region = P.Region
								AND R.District = P.District
								AND R.Ward = P.Ward
								AND R.Village = P.Village
	WHERE R.Region IS NULL
	AND R.District IS NULL
	AND R.Ward IS NULL
	AND R.Village IS NULL;



	--SELECT DISTINCT CI.Region,CI.InsureeDistrictName,CI.WardName,CI.VillageName
	--FROM tblTempNumberInsureeCurrent CI LEFT OUTER JOIN tblDimRegion R ON CI.Region = R.Region
	--																AND CI.InsureeDistrictName = R.District
	--																AND CI.WardName = R.Ward
	--																AND CI.VillageName = R.Village
	--WHERE R.Region IS NULL
	--AND R.District IS NULL
	--AND R.Ward IS NULL
	--AND R.Village IS NULL

	--UNION 

	--SELECT DISTINCT AI.Region,AI.InsDistrict,AI.InsWard,AI.InsVillage
	--FROM tblTempNumberInsureeAcquired AI LEFT OUTER JOIN tblDimRegion R ON AI.Region = R.Region
	--																AND AI.InsDistrict = R.District
	--																AND AI.InsWard = R.Ward
	--																AND AI.InsVillage = R.Village
	--WHERE R.Region IS NULL
	--AND R.District IS NULL
	--AND R.Ward IS NULL
	--AND R.Village IS NULL

	--UNION 

	--SELECT DISTINCT CP.Region,CP.InsureeDistrictName,CP.WardName,CP.VillageName
	--FROM tblTempNumberPolicyCurrent CP LEFT OUTER JOIN tblDimRegion R ON CP.Region = R.Region
	--																AND CP.InsureeDistrictName = R.District
	--																AND CP.WardName = R.Ward
	--																AND CP.VillageName = R.Village
	--WHERE R.Region IS NULL
	--AND R.District IS NULL
	--AND R.Ward IS NULL
	--AND R.Village IS NULL

	--UNION 

	--SELECT DISTINCT PS.Region,PS.InsDistrict,PS.InsWard,PS.InsVillage
	--FROM tblTempNumberPoliciesSold PS LEFT OUTER JOIN tblDimRegion R ON PS.Region = R.Region
	--																AND PS.InsDistrict = R.District
	--																AND PS.InsWard = R.Ward
	--																AND PS.InsVillage = R.Village
	--WHERE R.Region IS NULL
	--AND R.District IS NULL
	--AND R.Ward IS NULL
	--AND R.Village IS NULL

	--UNION 

	--SELECT DISTINCT PR.Region,PR.InsureeDistrictName,PR.WardName,PR.VillageName
	--FROM tblTempPolicyRenewal PR LEFT OUTER JOIN tblDimRegion R ON PR.Region = R.Region
	--																AND PR.InsureeDistrictName = R.District
	--																AND PR.WardName = R.Ward
	--																AND PR.VillageName = R.Village
	--WHERE R.Region IS NULL
	--AND R.District IS NULL
	--AND R.Ward IS NULL
	--AND R.Village IS NULL

	--UNION 

	--SELECT DISTINCT PE.Region,PE.InsureeDistrictName,PE.WardName,PE.VillageName
	--FROM tblTempNumberPolicyExpired PE LEFT OUTER JOIN tblDimRegion R ON PE.Region = R.Region
	--																AND PE.InsureeDistrictName = R.District
	--																AND PE.WardName = R.Ward
	--																AND PE.VillageName = R.Village
	--WHERE R.Region IS NULL
	--AND R.District IS NULL
	--AND R.Ward IS NULL
	--AND R.Village IS NULL

	--UNION 

	--SELECT DISTINCT IE.Region,IE.IDistrictName,IE.WardName,IE.VillageName
	--FROM tblTempItemExpenditures IE LEFT OUTER JOIN tblDimRegion R ON IE.Region = R.Region
	--																AND IE.IDistrictName = R.District
	--																AND IE.WardName = R.Ward
	--																AND IE.VillageName = R.Village
	--WHERE R.Region IS NULL
	--AND R.District IS NULL
	--AND R.Ward IS NULL
	--AND R.Village IS NULL

	--UNION

	--SELECT DISTINCT IH.Region Region, IH.DistrictName, IH.WardName ,IH.VillageName
	--FROM tblTEmpNumberOfInsuredHouseholds IH LEFT OUTER JOIN tblDimRegion R ON IH.Region = R.Region
	--																AND IH.DistrictName = R.District
	--																AND IH.WardName = R.Ward
	--																AND IH.VillageName = R.Village
	--WHERE R.Region IS NULL
	--AND R.District IS NULL
	--AND R.Ward IS NULL
	--AND R.Village IS NULL

END
GO


IF NOT OBJECT_ID('uspInsertFactPopulation') IS NULL
DROP PROCEDURE uspInsertFactPopulation
GO

CREATE PROCEDURE [dbo].[uspInsertFactPopulation]
AS
BEGIN

	BEGIN TRY
		BEGIN TRAN Pop
			--Disable all the constraint
			ALTER TABLE tblFactPopulation NOCHECK CONSTRAINT ALL;

			--INSERT INTO tblFactPopulation([Population],HouseHolds,YearTime,GenderDimId, DistrictName, WardName)
			--SELECT [Population],[Households],YearTime,R.RegionDimId, G.GenderDimId 
			--FROM 
			--(SELECT Region, District, Ward,gender.Gender,Gender.[Population], P.Households, YearTime
			--FROM tblTempPopulation P CROSS APPLY (VALUES('M', P.[ Male]),('F',P.Female)) as gender(Gender,[Population])
			--)Base 
			--INNER JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY District, Ward ORDER BY District)Rno,
			--RegionDimId,District,Ward FROM tblDimRegion) R ON Base.District = R.District AND Base.Ward = R.Ward
			--INNER JOIN tblDimGender G ON Base.Gender = G.GenderCode
			--WHERE R.Rno = 1
			
			--SELECT [Population],[Households],YearTime,R.RegionDimId, G.GenderDimId 
			--FROM 
			--(SELECT N'Tanzania'Region, District, Ward,gender.Gender,Gender.[Population], P.Households, YearTime
			--FROM tblTempPopulation P CROSS APPLY (VALUES('M', P.[ Male]),('F',P.Female)) as gender(Gender,[Population])
			--)Base 
			--INNER JOIN (SELECT RegionDimId,District,Ward FROM tblDimRegion) R ON Base.District = R.District AND Base.Ward = R.Ward
			--INNER JOIN tblDimGender G ON Base.Gender = G.GenderCode


			--In the below query RegionDimId is replaced by District in RoW_Number Function
			;With Base AS
			(
				SELECT DISTINCT ROW_NUMBER() OVER(PARTITION BY T.TimeDimId, R.District, R.Ward ORDER BY P.YearTime DESC)RNo,
				T.TimeDimId,P.Households, P.[Male], P.Female, P.Other, R.RegionDimId, R.District, R.Ward
				FROM tblDimTime T LEFT OUTER JOIN tblTempPopulation P ON P.YearTime <= T.YearTime
				INNER JOIN tblDimRegion R ON P.District = R.District AND P.Ward = R.Ward AND R.Village = P.Village
			)
			INSERT INTO tblFactPopulation([Population], HouseHolds, TimeDimId, GenderDimId, RegionDimId)
			SELECT G.[Population], Base.Households, Base.TimeDimId, Gen.GenderDimId, Base.RegionDimId --, Base.District, Base.Ward
			FROM Base CROSS APPLY(VALUES(N'M', [Male]),(N'F',Female), (N'O', Other))AS G(Gender,[Population])
			INNER JOIN tblDimGender Gen ON G.Gender = Gen.GenderCode
			WHERE Rno = 1

			

			--Enable all the constraint
			ALTER TABLE tblFactPopulation WITH CHECK CHECK CONSTRAINT ALL;
		COMMIT TRAN Pop
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Pop
		RAISERROR('Error occured',16,1);
	END CATCH
END

GO

--ON 18/08/2017
IF NOT OBJECT_ID('uspInsertFactPopulation') IS NULL
DROP PROCEDURE uspInsertFactPopulation
GO

CREATE PROCEDURE [dbo].[uspInsertFactPopulation]
AS
BEGIN

	BEGIN TRY
		BEGIN TRAN Pop
			--Disable all the constraint
			ALTER TABLE tblFactPopulation NOCHECK CONSTRAINT ALL;

			INSERT INTO tblFactPopulation([Population], HouseHolds, TimeDimId, GenderDimId, RegionDimId)
			SELECT G.[Population], P.Households, NULL TimeDimId, Gen.GenderDimId, R.RegionDimId
			FROM tblTempPopulation P 
			CROSS APPLY(VALUES(N'M', P.Male), (N'F', P.Female), (N'O', P.Other))G(Gender, [Population])
			INNER JOIN tblDimGender Gen ON Gen.GenderCode = G.Gender
			INNER JOIN tblDimRegion R ON R.Region = P.Region AND R.District = P.District AND R.Village = P.Village


			--Enable all the constraint
			ALTER TABLE tblFactPopulation WITH CHECK CHECK CONSTRAINT ALL;
		COMMIT TRAN Pop
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Pop
		RAISERROR('Error occured',16,1);
	END CATCH
END
GO

