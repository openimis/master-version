/*===========================================================================================================
Script to run on IMIS Production Server For Data Warehouse [After renaming Columns to LocationId]
===========================================================================================================*/
--ON 04/08/2017

IF NOT OBJECT_ID('dw.uvwAmountApproved') IS NULL
DROP VIEW dw.uvwAmountApproved
GO
CREATE VIEW dw.uvwAmountApproved
AS
	SELECT SUM(Details.Approved)AmountApproved,MONTH(ISNULL(C.DateTo, C.DateFrom))MonthTime, DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom))QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom))YearTime
	,HF.HFLevel,HF.HFCode, HF.HFName
	,HFR.RegionName Region, HFD.DistrictName DistrictName, Prod.ProductCode, Prod.ProductName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion

	FROM tblClaim C 
	LEFT OUTER JOIN

	(SELECT ClaimId,ProdId, SUM(PriceValuated) Approved FROM tblClaimItems WHERE ValidityTo IS NULL GROUP BY ClaimId,ProdId
	UNION ALL
	SELECT ClaimId,ProdID,SUM(PriceValuated) Approved FROM tblClaimServices WHERE ValidityTo IS NULL GROUP BY ClaimId,ProdId
	)Details ON C.ClaimID = Details.ClaimID


	LEFT OUTER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	LEFT OUTER JOIN tblHF HF ON C.HFID = HF.HFID
	LEFT OUTER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	LEFT OUTER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region

	WHERE C.ValidityTo IS NULL
	AND C.ClaimStatus >= 8 --Which is Processed and greater

	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom))
	,HF.HFLevel,HF.HFCode, HF.HFName
	, Prod.ProductCode, Prod.ProductName, HFD.DistrictName, HFR.RegionName

GO


IF NOT OBJECT_ID('dw.uvwAmountClaimed') IS NULL
DROP VIEW dw.uvwAmountClaimed
GO

CREATE VIEW dw.uvwAmountClaimed
AS
	SELECT SUM(Details.Claimed)AmountClaimed,MONTH(ISNULL(C.DateTo, C.DateFrom))MonthTime, DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom))QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom))YearTime
	,HF.HFLevel,HF.HFCode, HF.HFName
	,HFR.RegionName Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion

	FROM tblClaim C 
	LEFT OUTER JOIN

	(SELECT ClaimId,ProdId, SUM(QtyProvided * PriceAsked)Claimed FROM tblClaimItems WHERE ValidityTo IS NULL GROUP BY ClaimId,ProdId
	UNION ALL
	SELECT ClaimId,ProdID,SUM(QtyProvided * PriceAsked)Claimed FROM tblClaimServices WHERE ValidityTo IS NULL GROUP BY ClaimId,ProdId
	)Details ON C.ClaimID = Details.ClaimID

	LEFT OUTER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	LEFT OUTER JOIN tblHF HF ON C.HFID = HF.HFID
	LEFT OUTER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	LEFT OUTER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region

	WHERE C.ValidityTo IS NULL
	AND C.ClaimStatus <> 2 --Which is entered

	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom))
	,HF.HFLevel,HF.HFCode, HF.HFName
	,Prod.ProductCode, Prod.ProductName, HFD.DistrictName, HFR.RegionName


GO

IF NOT OBJECT_ID('dw.uvwAmountRejected') IS NULL
DROP VIEW dw.uvwAmountRejected
GO

CREATE VIEW [dw].[uvwAmountRejected]
AS
	SELECT SUM(Details.Rejected)AmountRejected,MONTH(ISNULL(C.DateTo, C.DateFrom))MonthTime, DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom))QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom))YearTime
	,HF.HFLevel,HF.HFCode, HF.HFName
	,HFR.RegionName Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion

	FROM tblClaim C 
	LEFT OUTER JOIN

	(SELECT ClaimId,ProdId, SUM(QtyProvided * PriceAsked)Rejected FROM tblClaimItems WHERE ValidityTo IS NULL GROUP BY ClaimId,ProdId
	UNION ALL
	SELECT ClaimId,ProdID,SUM(QtyProvided * PriceAsked)Rejected FROM tblClaimServices WHERE ValidityTo IS NULL GROUP BY ClaimId,ProdId
	)Details ON C.ClaimID = Details.ClaimID

	LEFT OUTER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	LEFT OUTER JOIN tblHF HF ON C.HFID = HF.HFID
	LEFT OUTER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	LEFT OUTER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region

	WHERE C.ValidityTo IS NULL
	AND Prod.ValidityTo IS NULL
	AND HF.ValidityTo IS NULL
	AND HFD.ValidityTo IS NULL

	AND C.ClaimStatus = 1 --Which is rejected

	--AND ISNULL(Details.Rejected,0) <> 0

	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom))
	,HF.HFLevel,HF.HFCode, HF.HFName
	, Prod.ProductCode, Prod.ProductName, HFD.DistrictName, HFR.RegionName

GO

IF NOT OBJECT_ID('dw.uvwamountvaluated') IS NULL
DROP VIEW dw.uvwamountvaluated
GO

CREATE VIEW [dw].[uvwamountvaluated]
AS
	SELECT SUM(Details.Valuated)AmountValuated,MONTH(ISNULL(C.DateTo, C.DateFrom))MonthTime, DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom))QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom))YearTime
	,HF.HFLevel,HF.HFCode, HF.HFName
	,HFR.RegionName Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion

	FROM tblClaim C 
	LEFT OUTER JOIN

	(SELECT ClaimId,ProdId, SUM(RemuneratedAmount) Valuated FROM tblClaimItems WHERE ValidityTo IS NULL GROUP BY ClaimId,ProdId
	UNION ALL
	SELECT ClaimId,ProdID,SUM(RemuneratedAmount) Valuated FROM tblClaimServices WHERE ValidityTo IS NULL GROUP BY ClaimId,ProdId
	)Details ON C.ClaimID = Details.ClaimID


	LEFT OUTER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	LEFT OUTER JOIN tblHF HF ON C.HFID = HF.HFID
	LEFT OUTER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	LEFT OUTER JOIN tblRegions HFR ON HFD.Region = HFR.RegionId

	WHERE C.ValidityTo IS NULL
	--AND Prod.ValidityTo IS NULL
	--AND D.ValidityTo IS NULL
	--AND HF.ValidityTo IS NULL
	--AND HFD.ValidityTo IS NULL
	AND C.ClaimStatus = 16 --Which is Processed and greater

	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom))
	,HF.HFLevel,HF.HFCode, HF.HFName
	,Prod.ProductCode, Prod.ProductName, HFD.DistrictName, HFR.RegionName


GO

IF NOT OBJECT_ID('dw.uvwClaimEntered') IS NULL
DROP VIEW dw.uvwClaimEntered
GO

CREATE VIEW [dw].[uvwClaimEntered] 
AS
	SELECT COUNT(1)TotalClaimEntered,MONTH(ISNULL(C.DateTo, C.DateFrom))MonthTime, DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom))QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom))YearTime,
	HF.HFLevel,HF.HFCode, HF.HFName,HFD.DistrictName HFDistrict, HFR.RegionName HFRegion
	FROM tblClaim C  LEFT OUTER JOIN tblHF HF ON C.HFID = HF.HFID
	LEFT OUTER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions HFR ON HFD.Region = HFR.RegionId
	WHERE C.ValidityTo IS NULL 
	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom)),
	HF.HFLevel,HF.HFCode, HF.HFName,HFD.DistrictName, HFR.RegionName

GO

IF NOT OBJECT_ID('[dw].[uvwClaimProcessed]') IS NULL
DROP VIEW [dw].[uvwClaimProcessed]
GO

CREATE VIEW [dw].[uvwClaimProcessed] 
AS
	SELECT COUNT(1)TotalClaimProcessed,MONTH(ISNULL(C.DateTo, C.DateFrom))MonthTime, DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom))QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom))YearTime,
	HF.HFLevel,HF.HFCode, HF.HFName,HFD.DistrictName HFDistrict, HFD.DistrictName, Prod.ProductCode, Prod.ProductName, HFR.RegionName Region, HFR.RegionName HFRegion
	FROM tblClaim C  
	LEFT OUTER JOIN
	(SELECT ClaimId,ProdId FROM tblClaimItems WHERE ValidityTo IS NULL AND ProdId IS NOT NULL GROUP BY ClaimId,ProdId
	UNION
	SELECT ClaimId,ProdID FROM tblClaimServices WHERE ValidityTo IS NULL AND ProdId IS NOT NULL GROUP BY ClaimId,ProdId
	)Details ON C.ClaimID = Details.ClaimID

	LEFT OUTER JOIN tblHF HF ON C.HFID = HF.HFID
	LEFT OUTER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	LEFT OUTER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	LEFT OUTER JOIN tblRegions HFR ON HFD.Region = HFR.RegionId

	WHERE C.ValidityTo IS NULL 
	AND (C.ClaimStatus >= 8)
	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom)),
	HF.HFLevel,HF.HFCode, HF.HFName,HFD.DistrictName , Prod.ProductCode, Prod.ProductName, HFR.RegionName


GO

IF NOT OBJECT_ID('[dw].[uvwClaimRejected]') IS NULL
DROP VIEW [dw].[uvwClaimRejected]
GO

CREATE VIEW [dw].[uvwClaimRejected] 
AS
	SELECT COUNT(1)TotalClaimRejected,MONTH(ISNULL(C.DateTo, C.DateFrom))MonthTime, DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom))QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom))YearTime,
	HF.HFLevel,HF.HFCode, HF.HFName,HFD.DistrictName HFDistrict, HFR.RegionName HFRegion
	FROM tblClaim C  LEFT OUTER JOIN tblHF HF ON C.HFID = HF.HFID
	LEFT OUTER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions HFR ON HFD.Region = HFR.RegionId
	WHERE C.ValidityTo IS NULL 
	AND C.ClaimStatus = 1
	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom)),
	HF.HFLevel,HF.HFCode, HF.HFName,HFD.DistrictName , HFR.RegionName


GO

IF NOT OBJECT_ID('[dw].[uvwClaimSent]') IS NULL
DROP VIEW [dw].[uvwClaimSent]
GO

CREATE VIEW [dw].[uvwClaimSent]
AS
	SELECT COUNT(C.ClaimID)ClaimSent,MONTH(C.DateClaimed)MonthTime, DATENAME(QUARTER,C.DateClaimed)QuarterTime, YEAR(C.DateClaimed)YearTime
	,HF.HFLevel,HF.HFCode, HF.HFName
	,HFR.RegionName Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion

	FROM tblClaim C 
		INNER JOIN
		(SELECT ClaimId,ProdId FROM tblClaimItems WHERE ValidityTo IS NULL
		UNION 
		SELECT ClaimId,ProdID FROM tblClaimServices WHERE ValidityTo IS NULL
		)Details ON C.ClaimID = Details.ClaimID
		INNER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
		INNER JOIN tblHF HF ON C.HFID = HF.HFID
		INNER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
		INNER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region

		WHERE C.ValidityTo IS NULL
		AND Prod.ValidityTo IS NULL
		AND HF.ValidityTo IS NULL
		AND HFD.ValidityTo IS NULL
		AND C.ClaimStatus > 2 --Which is entered

	GROUP BY MONTH(C.DateClaimed), DATENAME(QUARTER,C.DateClaimed), YEAR(C.DateClaimed)
	,HF.HFLevel,HF.HFCode, HF.HFName
	,Prod.ProductCode, Prod.ProductName, HFD.DistrictName, HFR.RegionName


GO

IF NOT OBJECT_ID('[dw].[uvwClaimSubmitted]') IS NULL
DROP VIEW [dw].[uvwClaimSubmitted]
GO

CREATE VIEW [dw].[uvwClaimSubmitted] 
AS
	SELECT COUNT(1)TotalClaimSubmitted,MONTH(ISNULL(C.DateTo, C.DateFrom))MonthTime, DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom))QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom))YearTime,
	HF.HFLevel,HF.HFCode, HF.HFName,HFD.DistrictName HFDistrict, HFR.RegionName HFRegion
	FROM tblClaim C  LEFT OUTER JOIN tblHF HF ON C.HFID = HF.HFID
	LEFT OUTER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region
	WHERE C.ValidityTo IS NULL 
	AND (C.ClaimStatus >= 4 OR C.ClaimStatus = 1)
	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom)),
	HF.HFLevel,HF.HFCode, HF.HFName,HFD.DistrictName, HFR.RegionName

GO

IF NOT OBJECT_ID('[dw].[uvwClaimValuated]') IS NULL
DROP VIEW [dw].[uvwClaimValuated]
GO

CREATE VIEW [dw].[uvwClaimValuated] 
AS
	SELECT COUNT(1)TotalClaimValuated,MONTH(ISNULL(C.DateTo, C.DateFrom))MonthTime, DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom))QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom))YearTime,
	HF.HFLevel,HF.HFCode, HF.HFName,HFD.DistrictName HFDistrict, HFD.DistrictName, Prod.ProductCode, Prod.ProductName, HFR.RegionName Region, HFR.RegionName HFRegion
	FROM tblClaim C  
	LEFT OUTER JOIN
	(SELECT ClaimId,ProdId FROM tblClaimItems WHERE ValidityTo IS NULL AND ProdId IS NOT NULL GROUP BY ClaimId,ProdId
	UNION
	SELECT ClaimId,ProdID FROM tblClaimServices WHERE ValidityTo IS NULL AND ProdId IS NOT NULL GROUP BY ClaimId,ProdId
	)Details ON C.ClaimID = Details.ClaimID
	LEFT OUTER JOIN tblHF HF ON C.HFID = HF.HFID
	LEFT OUTER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	LEFT OUTER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	LEFT OUTER JOIN tblRegions HFR ON HFD.Region = HFR.RegionId

	WHERE C.ValidityTo IS NULL 
	AND C.ClaimStatus = 16
	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom)),
	HF.HFLevel,HF.HFCode, HF.HFName,HFD.DistrictName , Prod.ProductCode, Prod.ProductName, HFR.RegionName

GO

IF NOT OBJECT_ID('[dw].[uvwExpenditureInsureeRange]') IS NULL
DROP VIEW [dw].[uvwExpenditureInsureeRange]
GO

CREATE VIEW [dw].[uvwExpenditureInsureeRange]
AS

	WITH Val
	AS
	(
	SELECT ClaimId, SUM(PriceValuated) Valuated, ProdID FROM tblClaimItems WHERE validityto IS NULL AND PriceValuated IS NOT NULL GROUP BY ClaimID, ProdID
	UNION ALL
	SELECT ClaimId, SUM(PriceValuated) Valuated, ProdID FROM tblClaimServices WHERE validityto IS NULL AND PriceValuated IS NOT NULL GROUP BY ClaimID, ProdID
	) 
	SELECT SUM(Val.Valuated)Valuated,C.ClaimID Insuree, MONTH(ISNULL(C.DateTo, C.DateFrom))MonthTime, DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom))QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom))YearTime
	,R.RegionName Region, D.DistrictName, Prod.ProductCode, Prod.ProductName
	,DATEDIFF(YEAR,I.DOB,ISNULL(C.DateTo, C.DateFrom))Age,I.Gender

	FROM Val INNER JOIN tblClaim C ON Val.ClaimID = C.ClaimID
	INNER JOIN tblProduct Prod ON Val.ProdID = Prod.ProdID
	INNER JOIN tblInsuree I ON C.InsureeID = I.InsureeID
	INNER JOIN tblFamilies F ON F.InsureeID = I.InsureeID
	INNER JOIN tblVillages V ON V.VillageId = F.LocationId
	INNER JOIN tblWards W ON W.WardId = V.WardId
	INNER JOIN tblDistricts D ON D.DistrictId = W.DistrictId
	INNER JOIN tblRegions R ON R.RegionId = D.Region

	WHERE C.ValidityTo IS NULL
	 AND Prod.ValidityTo IS NULL
	 AND I.ValidityTo IS NULL
	 AND F.ValidityTo IS NULL
	 AND D.ValidityTo IS NULL

	 GROUP BY C.Claimid, MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER,ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom))
	,R.RegionName, D.DistrictName, Prod.ProductCode, Prod.ProductName
	,DATEDIFF(YEAR,I.DOB,ISNULL(C.DateTo, C.DateFrom)),I.Gender

GO


IF NOT OBJECT_ID('[dw].[uvwHospitalAdmissions]') IS NULL
DROP VIEW [dw].[uvwHospitalAdmissions]
GO

CREATE VIEW [dw].[uvwHospitalAdmissions]
AS
	SELECT  COUNT(C.ClaimID) AS Admissions, MONTH(ISNULL(C.DateTo, C.DateFrom)) AS MonthTime, DATENAME(QUARTER, ISNULL(C.DateTo, C.DateFrom)) AS QuarterTime, 
			YEAR(ISNULL(C.DateTo, C.DateFrom)) AS YearTime, HFR.RegionName AS Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName, DATEDIFF(YEAR, I.DOB, 
			ISNULL(C.DateTo, C.DateFrom)) AS Age, I.Gender, HF.HFLevel, HF.HFCode, HF.HFName, C.VisitType, ICD.ICDCode, ICD.ICDName, HFD.DistrictName AS HFDistrict, 
			HFR.RegionName AS HFRegion
	FROM  dbo.tblClaim AS C 
	LEFT OUTER JOIN (SELECT        ClaimID, ProdID
								   FROM            dbo.tblClaimItems
								   WHERE        (ValidityTo IS NULL AND RejectionReason=0)
								   UNION
								   SELECT        ClaimID, ProdID
								   FROM            dbo.tblClaimServices
								   WHERE        (ValidityTo IS NULL AND RejectionReason=0)) AS Details ON C.ClaimID = Details.ClaimID 
	 LEFT OUTER JOIN
							 dbo.tblProduct AS Prod ON Details.ProdID = Prod.ProdID LEFT OUTER JOIN
							 dbo.tblInsuree AS I ON C.InsureeID = I.InsureeID LEFT OUTER JOIN
							 dbo.tblHF AS HF ON C.HFID = HF.HfID LEFT OUTER JOIN
							 dbo.tblICDCodes AS ICD ON C.ICDID = ICD.ICDID LEFT OUTER JOIN
							 dbo.tblDistricts AS HFD ON HF.LocationId = HFD.DistrictID LEFT OUTER JOIN
							 dbo.tblRegions AS HFR ON HFR.RegionId = HFD.Region
	WHERE        (C.ValidityTo IS NULL) AND (Prod.ValidityTo IS NULL) AND (I.ValidityTo IS NULL) AND (HF.ValidityTo IS NULL) AND (HFD.ValidityTo IS NULL) AND (DATEDIFF(DAY, 
							 C.DateFrom, C.DateTo) > 0)
							 AND C.ClaimStatus<>1
	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER, ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom)), Prod.ProductCode, 
							 Prod.ProductName, DATEDIFF(YEAR, I.DOB, ISNULL(C.DateTo, C.DateFrom)), I.Gender, HF.HFLevel, HF.HFCode, HF.HFName, C.VisitType, ICD.ICDCode, 
						   ICD.ICDName, HFD.DistrictName, HFR.RegionName

GO

IF NOT OBJECT_ID('[dw].[uvwHospitalDays]') IS NULL
DROP VIEW [dw].[uvwHospitalDays]
GO

CREATE VIEW [dw].[uvwHospitalDays]
AS
	SELECT        SUM(DATEDIFF(DAY, C.DateFrom, C.DateTo)) AS HospitalDays, MONTH(ISNULL(C.DateTo, C.DateFrom)) AS MonthTime, DATENAME(QUARTER, ISNULL(C.DateTo, 
							 C.DateFrom)) AS QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom)) AS YearTime, HFR.RegionName AS Region, HFD.DistrictName, Prod.ProductCode, 
							 Prod.ProductName, DATEDIFF(YEAR, I.DOB, ISNULL(C.DateTo, C.DateFrom)) AS Age, I.Gender, HF.HFLevel, HF.HFCode, HF.HFName, C.VisitType, ICD.ICDCode, 
							 ICD.ICDName, HFD.DistrictName AS HFDistrict, HFR.RegionName AS HFRegion
	FROM            dbo.tblClaim AS C LEFT OUTER JOIN
								 (SELECT        ClaimID, ProdID
								   FROM            dbo.tblClaimItems
								   WHERE        (ValidityTo IS NULL AND RejectionReason=0)
								   UNION
								   SELECT        ClaimID, ProdID
								   FROM            dbo.tblClaimServices
								   WHERE        (ValidityTo IS NULL AND RejectionReason=0)) AS Details ON C.ClaimID = Details.ClaimID LEFT OUTER JOIN
							 dbo.tblProduct AS Prod ON Details.ProdID = Prod.ProdID LEFT OUTER JOIN
							 dbo.tblInsuree AS I ON C.InsureeID = I.InsureeID LEFT OUTER JOIN
							 dbo.tblHF AS HF ON C.HFID = HF.HfID LEFT OUTER JOIN
							 dbo.tblICDCodes AS ICD ON C.ICDID = ICD.ICDID LEFT OUTER JOIN
							 dbo.tblDistricts AS HFD ON HF.LocationId = HFD.DistrictID LEFT OUTER JOIN
							 dbo.tblRegions AS HFR ON HFR.RegionId = HFD.Region
	WHERE        (C.ValidityTo IS NULL) AND (Prod.ValidityTo IS NULL) AND (I.ValidityTo IS NULL) AND (HF.ValidityTo IS NULL) AND (HFD.ValidityTo IS NULL) AND (DATEDIFF(DAY, 
							 C.DateFrom, C.DateTo) > 0) AND C.ClaimStatus <>1
	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER, ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom)), Prod.ProductCode, 
							 Prod.ProductName, DATEDIFF(YEAR, I.DOB, ISNULL(C.DateTo, C.DateFrom)), I.Gender, HF.HFLevel, HF.HFCode, HF.HFName, C.VisitType, ICD.ICDCode, 
							 ICD.ICDName, HFD.DistrictName, HFR.RegionName

GO

IF NOT OBJECT_ID('[dw].[uvwItemExpenditures]') IS NULL
DROP VIEW [dw].[uvwItemExpenditures]
GO

CREATE VIEW [dw].[uvwItemExpenditures]
AS
	SELECT SUM(CI.RemuneratedAmount)ItemExpenditure,MONTH(ISNULL(C.DateTo,C.DateFrom))MonthTime,DATENAME(QUARTER,ISNULL(C.DateTo,C.DateFrom))QuarterTime,YEAR(ISNULL(C.DateTo,C.DateFrom))YearTime,
	R.RegionName Region,HFD.DistrictName,PR.ProductCode,PR.ProductName,DATEDIFF(YEAR,I.DOB,ISNULL(C.DateTo, C.DateFrom))Age,I.Gender,
	Itm.ItemType,Itm.ItemCode,Itm.ItemName,CASE WHEN DATEDIFF(DAY, C.DateFrom, C.DateTo) > 0 THEN N'I' ELSE N'O' END ItemCareType,
	HF.HFLevel,HF.HFCode,HF.HFName,C.VisitType, ICD.ICDCode,ICD.ICDName,
	DIns.DistrictName IDistrictName , W.WardName, V.VillageName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion, HFR.RegionName ProdRegion

	FROM tblClaimItems CI INNER JOIN tblClaim C ON CI.ClaimID = C.ClaimID
	INNER JOIN tblProduct PR ON CI.ProdID = PR.ProdID
	INNER JOIN tblInsuree I ON C.InsureeID = I.InsureeID
	INNER JOIN tblFamilies F ON I.FamilyID = F.FamilyID
	INNER JOIN tblVillages V ON V.VillageId = F.LocationId
	INNER JOIN tblWards W ON W.WardId = V.WardId
	INNER JOIN tblDistricts DIns ON DIns.DistrictID = W.DistrictID
	INNER JOIN tblItems Itm ON CI.ItemID = Itm.ItemID
	INNER JOIN tblHF HF ON C.HFID = HF.HfID
	INNER JOIN tblICDCodes ICD ON C.ICDID = ICD.ICDID
	INNER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions R ON DIns.Region = R.RegionId
	INNER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region
	

	WHERE CI.ValidityTo IS NULL
	AND C.ValidityTo IS NULL
	AND PR.ValidityTo IS NULL
	AND I.ValidityTo IS NULL
	AND I.ValidityTo IS NULL
	AND HF.ValidityTo IS NULL
	AND HFD.ValidityTo IS NULL
	AND C.ClaimStatus >= 8		--Consider only Processed(8) and Valuated(16) Claims
	--AND ISNULL(CI.PriceValuated,0) > 0
	--Also add a criteria if they want the batch id as well

	GROUP BY MONTH(ISNULL(C.DateTo,C.DateFrom)),DATENAME(QUARTER,ISNULL(C.DateTo,C.DateFrom)),YEAR(ISNULL(C.DateTo,C.DateFrom)),
	R.RegionName, PR.ProductCode,PR.ProductName,DATEDIFF(YEAR,I.DOB,ISNULL(C.DateTo, C.DateFrom)),I.Gender,
	Itm.ItemType,Itm.ItemCode,Itm.ItemName,DATEDIFF(DAY, C.DateFrom, C.DateTo),
	HF.HFLevel,HF.HFCode,HF.HFName,C.VisitType, ICD.ICDCode,ICD.ICDName,
	DIns.DistrictName, W.WardName, V.VillageName, HFD.DistrictName, HFR.RegionName


GO

IF NOT OBJECT_ID('[dw].[uvwItemUtilization]') IS NULL
DROP VIEW [dw].[uvwItemUtilization]
GO

CREATE VIEW [dw].[uvwItemUtilization]
AS
	SELECT SUM(CI.QtyProvided) AS ItemUtilized, MONTH(ISNULL(C.DateTo, C.DateFrom)) AS MonthTime, DATENAME(QUARTER, ISNULL(C.DateTo, C.DateFrom)) 
		   AS QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom)) AS YearTime, R.RegionName AS Region, DIns.DistrictName, Prod.ProductCode, Prod.ProductName, 
		   DATEDIFF(YEAR, I.DOB, ISNULL(C.DateTo, C.DateFrom)) AS Age, I.Gender, Itm.ItemType, Itm.ItemCode, Itm.ItemName, CASE WHEN DATEDIFF(DAY, C.DateFrom, 
		   C.DateTo) > 0 THEN N'I' ELSE N'O' END AS ItemCareType, HF.HFLevel, HF.HFCode, HF.HFName, ICD.ICDCode, ICD.ICDName, DIns.DistrictName AS IDistrictName, 
		   W.WardName, V.VillageName, HFD.DistrictName AS HFDistrict, C.VisitType, HFR.RegionName AS HFRegion, R.RegionName AS ProdRegion
	FROM dbo.tblClaimItems AS CI 
	INNER JOIN dbo.tblClaim AS C ON C.ClaimID = CI.ClaimID 
	LEFT OUTER JOIN dbo.tblProduct AS Prod ON CI.ProdID = Prod.ProdID 
	INNER JOIN dbo.tblInsuree AS I ON C.InsureeID = I.InsureeID 
	INNER JOIN dbo.tblFamilies AS F ON I.FamilyID = F.FamilyID 
	INNER JOIN dbo.tblVillages AS V ON V.VillageID = F.LocationId 
	INNER JOIN dbo.tblWards AS W ON W.WardID = V.WardID 
	INNER JOIN dbo.tblDistricts AS DIns ON DIns.DistrictID = W.DistrictID 
	
	INNER JOIN dbo.tblItems AS Itm ON CI.ItemID = Itm.ItemID 
	INNER JOIN dbo.tblHF AS HF ON C.HFID = HF.HfID 
	INNER JOIN dbo.tblICDCodes AS ICD ON C.ICDID = ICD.ICDID 
	INNER JOIN dbo.tblDistricts AS HFD ON HF.LocationId = HFD.DistrictID 
	INNER JOIN dbo.tblRegions AS R ON R.RegionId = DIns.Region 
	INNER JOIN dbo.tblRegions AS HFR ON HFR.RegionId = HFD.Region

	WHERE (CI.ValidityTo IS NULL) 
	AND (C.ValidityTo IS NULL) 
	AND (Prod.ValidityTo IS NULL)
	AND (Itm.ValidityTo IS NULL) 
	AND (HF.ValidityTo IS NULL) 
	AND (HFD.ValidityTo IS NULL) 
	AND (C.ClaimStatus > 2)
	AND CI.RejectionReason=0
	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER, ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom)), R.RegionName, 
	Prod.ProductCode, Prod.ProductName, DATEDIFF(YEAR, I.DOB, ISNULL(C.DateTo, C.DateFrom)), I.Gender, Itm.ItemType, Itm.ItemCode, Itm.ItemName, DATEDIFF(DAY,
	C.DateFrom, C.DateTo), HF.HFLevel, HF.HFCode, HF.HFName, ICD.ICDCode, ICD.ICDName, DIns.DistrictName, W.WardName, V.VillageName,  C.VisitType
	,HFD.DistrictName, HFR.RegionName

GO

IF NOT OBJECT_ID('[dw].[uvwNumberFeedbackAnswerYes]') IS NULL
DROP VIEW [dw].[uvwNumberFeedbackAnswerYes]
GO

CREATE VIEW [dw].[uvwNumberFeedbackAnswerYes]
AS
	SELECT COUNT(F.FeedbackID)AnsYes, 1 QuestionId,MONTH(F.FeedbackDate)MonthTime, DATENAME(QUARTER,F.FeedbackDate)QuarterTime, YEAR(F.FeedbackDate)YearTime
	,HF.HFLevel,HF.HFCode, HF.HFName
	,HFR.RegionName Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion

	FROM tblFeedback F INNER JOIN tblClaim C ON F.ClaimID = C.ClaimID
	INNER JOIN
		(SELECT ClaimId,ProdId FROM tblClaimItems WHERE ValidityTo IS NULL
		UNION 
		SELECT ClaimId,ProdID FROM tblClaimServices WHERE ValidityTo IS NULL
		)Details ON C.ClaimID = Details.ClaimID

	INNER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	INNER JOIN tblHF HF ON C.HFID = HF.HFID
	INNER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region


	WHERE F.ValidityTo IS NULL
	AND CareRendered = 1

	GROUP BY MONTH(F.FeedbackDate), DATENAME(QUARTER,F.FeedbackDate), YEAR(F.FeedbackDate),
	HF.HFLevel,HF.HFCode, HF.HFName
	, Prod.ProductCode, Prod.ProductName, HFD.DistrictName, HFR.RegionName

	UNION ALL

	SELECT COUNT(F.FeedbackID)AnsYes, 2 QuestionId,MONTH(F.FeedbackDate)MonthTime, DATENAME(QUARTER,F.FeedbackDate)QuarterTime, YEAR(F.FeedbackDate)YearTime
	,HF.HFLevel,HF.HFCode, HF.HFName
	,HFR.RegionName Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion

	FROM tblFeedback F INNER JOIN tblClaim C ON F.ClaimID = C.ClaimID
	INNER JOIN
		(SELECT ClaimId,ProdId FROM tblClaimItems WHERE ValidityTo IS NULL
		UNION 
		SELECT ClaimId,ProdID FROM tblClaimServices WHERE ValidityTo IS NULL
		)Details ON C.ClaimID = Details.ClaimID

	INNER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	INNER JOIN tblHF HF ON C.HFID = HF.HFID
	INNER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region

	WHERE F.ValidityTo IS NULL
	AND F.PaymentAsked = 1

	GROUP BY MONTH(F.FeedbackDate), DATENAME(QUARTER,F.FeedbackDate), YEAR(F.FeedbackDate),
	HF.HFLevel,HF.HFCode, HF.HFName
	, Prod.ProductCode, Prod.ProductName, HFD.DistrictName, HFR.RegionName

	UNION ALL

	SELECT COUNT(F.FeedbackID)AnsYes, 3 QuestionId,MONTH(F.FeedbackDate)MonthTime, DATENAME(QUARTER,F.FeedbackDate)QuarterTime, YEAR(F.FeedbackDate)YearTime
	,HF.HFLevel,HF.HFCode, HF.HFName
	,HFR.RegionName Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion

	FROM tblFeedback F INNER JOIN tblClaim C ON F.ClaimID = C.ClaimID
	INNER JOIN
		(SELECT ClaimId,ProdId FROM tblClaimItems WHERE ValidityTo IS NULL
		UNION 
		SELECT ClaimId,ProdID FROM tblClaimServices WHERE ValidityTo IS NULL
		)Details ON C.ClaimID = Details.ClaimID

	INNER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	INNER JOIN tblHF HF ON C.HFID = HF.HFID
	INNER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region

	WHERE F.ValidityTo IS NULL
	AND F.DrugPrescribed = 1

	GROUP BY MONTH(F.FeedbackDate), DATENAME(QUARTER,F.FeedbackDate), YEAR(F.FeedbackDate),
	HF.HFLevel,HF.HFCode, HF.HFName
	, Prod.ProductCode, Prod.ProductName, HFD.DistrictName, HFR.RegionName

	UNION ALL

	SELECT COUNT(F.FeedbackID)AnsYes, 4 QuestionId,MONTH(F.FeedbackDate)MonthTime, DATENAME(QUARTER,F.FeedbackDate)QuarterTime, YEAR(F.FeedbackDate)YearTime
	,HF.HFLevel,HF.HFCode, HF.HFName
	,HFR.RegionName Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion

	FROM tblFeedback F INNER JOIN tblClaim C ON F.ClaimID = C.ClaimID
	INNER JOIN
		(SELECT ClaimId,ProdId FROM tblClaimItems WHERE ValidityTo IS NULL
		UNION 
		SELECT ClaimId,ProdID FROM tblClaimServices WHERE ValidityTo IS NULL
		)Details ON C.ClaimID = Details.ClaimID

	INNER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	INNER JOIN tblHF HF ON C.HFID = HF.HFID
	INNER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region

	WHERE F.ValidityTo IS NULL
	AND F.DrugReceived = 1

	GROUP BY MONTH(F.FeedbackDate), DATENAME(QUARTER,F.FeedbackDate), YEAR(F.FeedbackDate),
	HF.HFLevel,HF.HFCode, HF.HFName
	, Prod.ProductCode, Prod.ProductName, HFD.DistrictName, HFR.RegionName


GO

IF  NOT OBJECT_ID('[dw].[uvwNumberFeedbackResponded]') IS NULL
DROP VIEW [dw].[uvwNumberFeedbackResponded]
GO

CREATE VIEW [dw].[uvwNumberFeedbackResponded]
AS
	SELECT COUNT(F.FeedbackID)FeedbackResponded, MONTH(F.FeedbackDate)MonthTime, DATENAME(QUARTER,F.FeedbackDate)QuarterTime, YEAR(F.FeedbackDate)YearTime
	,HFR.RegionName Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName
	,HF.HFLevel,HF.HFCode, HF.HFName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion

	FROM tblFeedback F INNER JOIN tblClaim C ON F.ClaimID = C.ClaimID
	INNER JOIN
			(SELECT ClaimId,ProdId FROM tblClaimItems WHERE ValidityTo IS NULL
			UNION 
			SELECT ClaimId,ProdID FROM tblClaimServices WHERE ValidityTo IS NULL
			)Details ON F.ClaimID = Details.ClaimID
	INNER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	INNER JOIN tblHF HF ON C.HFID = HF.HFID
	INNER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region

	WHERE F.ValidityTo IS NULL
	AND Prod.ValidityTo IS NULL
	
	GROUP BY YEAR(F.FeedbackDate),MONTH(F.FeedbackDate), DATENAME(QUARTER,F.FeedbackDate) 
	, Prod.ProductCode, Prod.ProductName
	,HF.HFLevel,HF.HFCode, HF.HFName, HFD.DistrictName, HFR.RegionName


GO

IF NOT OBJECT_ID('[dw].[uvwNumberFeedbackSent]') IS NULL
DROP VIEW [dw].[uvwNumberFeedbackSent]
GO

CREATE VIEW [dw].[uvwNumberFeedbackSent]
AS
	SELECT COUNT(FeedbackPromptId)FeedbackSent, MONTH(F.FeedbackPromptDate)MonthTime, DATENAME(QUARTER,F.FeedbackPromptDate)QuarterTime, YEAR(F.FeedbackPromptDate)YearTime
	,HFR.RegionName Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName
	,HF.HFLevel,HF.HFCode, HF.HFName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion

	FROM tblFeedbackPrompt F INNER JOIN tblClaim C ON F.ClaimID = C.ClaimID
	INNER JOIN
			(SELECT ClaimId,ProdId FROM tblClaimItems WHERE ValidityTo IS NULL
			UNION 
			SELECT ClaimId,ProdID FROM tblClaimServices WHERE ValidityTo IS NULL
			)Details ON F.ClaimID = Details.ClaimID
	INNER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	INNER JOIN tblHF HF ON C.HFID = HF.HFID
	INNER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region

	WHERE F.ValidityTo IS NULL
	AND Prod.ValidityTo IS NULL
	AND HFD.ValidityTo IS NULL

	GROUP BY YEAR(F.FeedbackPromptDate),MONTH(F.FeedbackPromptDate), DATENAME(QUARTER,F.FeedbackPromptDate) 
	, Prod.ProductCode, Prod.ProductName
	,HF.HFLevel,HF.HFCode, HF.HFName, HFD.DistrictName, HFR.RegionName
	

GO

IF NOT OBJECT_ID('[dw].[uvwNumberInsureeAcquired]') IS NULL
DROP VIEW [dw].[uvwNumberInsureeAcquired]
GO

CREATE VIEW [dw].[uvwNumberInsureeAcquired]
AS
	SELECT COUNT(I.InsureeID)NewInsurees,MONTH(PL.EnrollDate)MonthTime,DATENAME(Q,PL.Enrolldate)QuarterTime, YEAR(PL.EnrollDate)YearTime,
	DATEDIFF(YEAR,I.DOB,GETDATE())Age, I.Gender, R.RegionName Region, D.DistrictName InsDistrict, V.VillageName InsVillage, W.WardName InsWard,
	D.DistrictName ProdDistrict, Prod.ProductCode, Prod.ProductName,
	ODist.DistrictName OfficerDistrict, O.Code, O.LastName, O.OtherNames, R.RegionName ProdRegion


	FROM tblPolicy PL INNER JOIN tblInsuree I ON PL.FamilyID = I.FamilyID
	INNER JOIN tblProduct Prod ON PL.ProdID = Prod.ProdID
	INNER JOIN tblFamilies F ON PL.FamilyID = F.FamilyID
	INNER JOIN tblVillages V ON V.VillageId = F.LocationId
	INNER JOIN tblWards W ON W.WardID = V.WardID
	INNER JOIN tblDistricts D ON D.DistrictID = W.DistrictID
	INNER JOIN tblOfficer O ON PL.OfficerID = O.OfficerId
	INNER JOIN tblDistricts ODist ON O.LocationId = ODist.DistrictId
	INNER JOIN tblInsureePolicy InsPL ON InsPL.InsureeId = I.InsureeId AND InsPL.PolicyId = PL.PolicyID
	INNER JOIN tblRegions R ON R.RegionId = D.Region
	
	WHERE PL.ValidityTo IS NULL 
	AND I.ValidityTo IS NULL 
	AND Prod.ValidityTo IS NULL 
	AND F.ValidityTo IS NULL
	AND D.ValidityTo IS NULL
	AND V.ValidityTo IS NULL
	AND W.ValidityTo IS NULL
	AND O.ValidityTo IS NULL
	AND ODist.ValidityTo IS NULL
	AND InsPL.ValidityTo IS NULL

	GROUP BY MONTH(PL.EnrollDate),DATENAME(Q,PL.Enrolldate), YEAR(PL.EnrollDate),
	DATEDIFF(YEAR,I.DOB,GETDATE()), I.Gender, D.DistrictName, V.VillageName, W.WardName,
	R.Regionname, Prod.ProductCode, Prod.ProductName,
	ODist.DistrictName, O.Code, O.LastName, O.OtherNames


GO

IF NOT OBJECT_ID('[dw].[uvwNumberOfInsuredHouseholds]') IS NULL
DROP VIEW [dw].[uvwNumberOfInsuredHouseholds]
GO


CREATE VIEW [dw].[uvwNumberOfInsuredHouseholds]
AS
	WITH RowData AS
	(
		SELECT F.FamilyID, DATEADD(MONTH,MonthCount.Numbers, EOMONTH(PL.EffectiveDate, 0))ActiveDate, 
		R.RegionName Region, D.DistrictName, W.WardName, V.VillageName
		FROM tblPolicy PL 
		INNER JOIN tblFamilies F ON PL.FamilyId = F.FamilyID
		INNER JOIN tblVillages V ON V.VillageId = F.LocationId
		INNER JOIN tblWards W ON W.WardId = V.WardId
		INNER JOIN tblDistricts D ON D.DistrictId = W.DistrictId
		INNER JOIN tblRegions R ON D.Region = R.RegionId 
		CROSS APPLY(VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11))MonthCount(Numbers)
		WHERE PL.ValidityTo IS NULL
		AND F.ValidityTo IS NULL
		AND R.ValidityTo IS NULL
		AND D.ValidityTo IS NULL
		AND W.ValidityTo IS NULL
		AND V.ValidityTo IS NULL
		AND PL.EffectiveDate IS NOT NULL
	), RowData2 AS
	(
		SELECT FamilyId, ActiveDate, Region, DistrictName, WardName, VillageName
		FROM RowData
		GROUP BY FamilyId, ActiveDate, Region, DistrictName, WardName, VillageName
	)
	SELECT COUNT(FamilyId) InsuredHouseholds, MONTH(ActiveDate)MonthTime, DATENAME(Q, ActiveDate)QuarterTime, YEAR(ActiveDate)YearTime, Region, DistrictName, WardName, VillageName
	FROM RowData2
	GROUP BY ActiveDate, Region, DistrictName, WardName, VillageName

GO

IF NOT OBJECT_ID('[dw].[uvwNumberPolicyRenewed]') IS NULL
DROP VIEW [dw].[uvwNumberPolicyRenewed]
GO

CREATE VIEW [dw].[uvwNumberPolicyRenewed]
AS
	
	SELECT COUNT(PL.FamilyID)Renewals, MONTH(PL.EnrollDate)MonthTime, DATENAME(Q, PL.EnrollDate)QuarterTime, YEAR(PL.EnrollDate)YearTime,
	DATEDIFF(YEAR, I.DOB, PL.EnrollDate)Age, I.Gender, R.RegionName Region, FD.DistrictName InsureeDistrictName, FV.VillageName, FW.WardName,
	FD.DistrictName ProdDistrictName, Prod.ProductCode, Prod.ProductName, OD.DistrictName OfficeDistrict, O.Code OfficerCode, O.LastName, O.OtherNames,
	R.RegionName ProdRegion

	FROM tblPolicy PL INNER JOIN tblFamilies F ON PL.FamilyId = F.FamilyID
	INNER JOIN tblInsuree I ON F.InsureeID = I.InsureeID
	INNER JOIN tblVillages FV ON FV.VillageId = F.LocationId
	INNER JOIN tblWards FW ON FW.WardId = FV.WardID
	INNER JOIN tblDistricts FD ON FD.DistrictID = FW.DistrictID
	INNER JOIN tblProduct Prod ON PL.ProdID = Prod.ProdID
	INNER JOIN tblOfficer O ON PL.OfficerId = O.OfficerID
	INNER JOIN tblDistricts OD ON OD.DistrictID = O.LocationId
	INNER JOIN tblRegions R ON R.RegionId = FD.Region
	
	WHERE PL.ValidityTo IS NULL
	AND F.ValidityTo IS NULL
	AND I.ValidityTo IS NULL
	AND FD.ValidityTo IS NULL
	AND FW.ValidityTo IS NULL
	AND FV.ValidityTo IS NULL
	AND Prod.ValidityTo IS NULL
	AND O.ValidityTo IS NULL
	AND OD.ValidityTo IS NULL
	AND PL.PolicyStage = N'R'

	GROUP BY MONTH(PL.EnrollDate), DATENAME(Q, PL.EnrollDate), YEAR(PL.EnrollDate),
	DATEDIFF(YEAR, I.DOB, PL.EnrollDate), I.Gender, R.RegionName, FD.DistrictName, FV.VillageName, FW.WardName,
	Prod.ProductCode, Prod.ProductName, OD.DistrictName, O.Code, O.LastName, O.OtherNames
	


GO

IF NOT OBJECT_ID('[dw].[uvwNumberPolicySold]') IS NULL
DROP VIEW [dw].[uvwNumberPolicySold]
GO

CREATE VIEW [dw].[uvwNumberPolicySold]
AS
	
	SELECT COUNT(PL.FamilyID)SoldPolicy, MONTH(PL.EnrollDate)MonthTime, DATENAME(Q, PL.EnrollDate)QuarterTime, YEAR(PL.EnrollDate)YearTime,
	DATEDIFF(YEAR, I.DOB, PL.EnrollDate)Age, I.Gender, RD.RegionName Region, FD.DistrictName InsDistrict, FV.VillageName InsVillage, FW.WardName InsWard,
	FD.DistrictName ProdDistrict, Prod.ProductCode, Prod.ProductName, OD.DistrictName OfficerDistrict, O.Code, O.LastName, O.OtherNames, RD.RegionName ProdRegion


	FROM tblPolicy PL INNER JOIN tblFamilies F ON PL.FamilyId = F.FamilyID
	INNER JOIN tblInsuree I ON F.InsureeID = I.InsureeID
	INNER JOIN tblVillages FV ON FV.VillageId = F.LocationId
	INNER JOIN tblWards FW ON FW.WardId = FV.WardID
	INNER JOIN tblDistricts FD ON FD.DistrictID = FW.DistrictID
	INNER JOIN tblProduct Prod ON PL.ProdID = Prod.ProdID
	INNER JOIN tblOfficer O ON PL.OfficerId = O.OfficerID
	INNER JOIN tblDistricts OD ON OD.DistrictID = O.LocationId
	INNER JOIN tblRegions RD ON RD.RegionId = FD.Region
	
	WHERE PL.ValidityTo IS NULL
	AND F.ValidityTo IS NULL
	AND I.ValidityTo IS NULL
	AND FD.ValidityTo IS NULL
	AND FW.ValidityTo IS NULL
	AND FV.ValidityTo IS NULL
	AND Prod.ValidityTo IS NULL
	AND O.ValidityTo IS NULL
	AND OD.ValidityTo IS NULL
	AND PL.PolicyStage = N'N'

	GROUP BY MONTH(PL.EnrollDate), DATENAME(Q, PL.EnrollDate), YEAR(PL.EnrollDate),
	DATEDIFF(YEAR, I.DOB, PL.EnrollDate), I.Gender, RD.RegionName, FD.DistrictName, FV.VillageName, FW.WardName,
	Prod.ProductCode, Prod.ProductName, OD.DistrictName, O.Code, O.LastName, O.OtherNames


GO

IF NOT OBJECT_ID('[dw].[uvwOverallAssessment]') IS NULL
DROP VIEW [dw].[uvwOverallAssessment]
GO

CREATE VIEW [dw].[uvwOverallAssessment]
AS
	SELECT Asessment,MONTH(FeedbackDate)MonthTime, DATENAME(QUARTER,FeedbackDate)QuarterTime, YEAR(FeedbackDate)YearTime,HFR.RegionName Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName,HF.HFLevel,HF.HFCode, HF.HFName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion
	FROM tblFeedback F INNER JOIN tblClaim C ON F.ClaimId = C.ClaimId
	INNER JOIN
			(SELECT ClaimId,ProdId FROM tblClaimItems WHERE ValidityTo IS NULL
			UNION 
			SELECT ClaimId,ProdID FROM tblClaimServices WHERE ValidityTo IS NULL
			)Details ON C.ClaimID = Details.ClaimID
	INNER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	INNER JOIN tblHF HF ON C.HFID = HF.HFID
	INNER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region

	WHERE F.ValidityTo IS NULL
	AND C.ValidityTo IS NULL
	AND Prod.ValidityTo IS NULL
	AND HF.ValidityTo IS NULL
	AND HFD.ValidityTo IS NULL

GO

IF NOT OBJECT_ID('[dw].[uvwPremiumCollection]') IS NULL
DROP VIEW [dw].[uvwPremiumCollection]
GO

CREATE VIEW [dw].[uvwPremiumCollection]
AS
	SELECT SUM(PR.Amount)Amount,PR.PayType,Pay.PayerType,Pay.PayerName,R.RegionName Region,FD.DistrictName,Prod.ProductCode,Prod.ProductName,
	O.Code,O.LastName,O.OtherNames,DO.DistrictName OfficerDistrict,MONTH(PR.PayDate)MonthTime,DATENAME(Q,PR.PayDate)QuarterTime,YEAR(PR.PayDate)YearTime
	FROM tblPremium PR LEFT OUTER JOIN tblPayer Pay ON PR.PayerId = Pay.PayerId
	INNER JOIN tblPolicy PL ON PR.PolicyID = PL.PolicyID
	INNER JOIN tblProduct Prod ON PL.ProdID = Prod.ProdId
	INNER JOIN tblOfficer O ON PL.OfficerID = O.OfficerID
	INNER JOIN tblDistricts DO ON O.LocationId = DO.DistrictID
	INNER JOIN tblFamilies F ON PL.FamilyID = F.FamilyID
	INNER JOIN tblVillages V ON V.VillageId = F.LocationId
	INNER JOIN tblWards W ON W.WardId = V.WardId
	INNER JOIN tblDistricts FD ON FD.DistrictID = W.DistrictID
	INNER JOIN tblRegions R ON R.RegionId = FD.Region
	WHERE PR.ValidityTo IS NULL AND Pay.ValidityTo IS NULL AND PL.ValidityTo IS NULL AND F.ValidityTo IS NULL
	GROUP BY PR.PayType,Pay.PayerType,Pay.PayerName, R.RegionName,Prod.ProductCode,Prod.ProductName,
	O.Code,O.LastName,O.OtherNames,DO.DistrictName,MONTH(PR.PayDate),DATENAME(Q,PR.PayDate),YEAR(PR.PayDate),
	FD.DistrictName
GO

IF NOT OBJECT_ID('[dw].[uvwServiceExpenditures]') IS NULL
DROP VIEW [dw].[uvwServiceExpenditures]
GO

CREATE VIEW [dw].[uvwServiceExpenditures]
AS
	SELECT SUM(CS.PriceValuated)ServiceExpenditure,MONTH(ISNULL(C.DateTo,C.DateFrom))MonthTime,DATENAME(QUARTER,ISNULL(C.DateTo,C.DateFrom))QuarterTime,YEAR(ISNULL(C.DateTo,C.DateFrom))YearTime,
	R.RegionName Region,HFD.DistrictName,PR.ProductCode,PR.ProductName,DATEDIFF(YEAR,I.DOB,ISNULL(C.DateTo,C.DateFrom))Age,I.Gender,
	S.ServType,S.ServCode,S.ServName,CASE WHEN DATEDIFF(DAY, C.DateFrom, C.DateTo) > 0 THEN N'I' ELSE N'O' END ServCareType,
	HF.HFLevel,HF.HFCode,HF.HFName,C.VisitType, ICD.ICDCode, ICD.ICDName,
	DIns.DistrictName IDistrictName , W.WardName, V.VillageName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion, HFR.RegionName ProdRegion

	FROM tblClaimServices CS INNER JOIN tblClaim C ON CS.ClaimID = C.ClaimID
	INNER JOIN tblProduct PR ON CS.ProdID = PR.ProdID
	INNER JOIN tblInsuree I ON C.InsureeID = I.InsureeID
	INNER JOIN tblFamilies F ON I.FamilyID = F.FamilyID
	INNER JOIN tblVillages V ON V.VillageId = F.LocationId
	INNER JOIN tblWards W ON W.WardID = V.WardID
	INNER JOIN tblDistricts DIns ON DIns.DistrictID = W.DistrictID
	INNER JOIN tblServices S ON CS.ServiceID = S.ServiceID
	INNER JOIN tblHF HF ON C.HFID = HF.HfID
	INNER JOIN tblICDCodes ICD ON C.ICDID = ICD.ICDID
	INNER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions R ON R.RegionId = DIns.Region
	INNER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region
	
	WHERE CS.ValidityTo IS NULL
	AND C.ValidityTo IS NULL
	AND PR.ValidityTo IS NULL
	AND I.ValidityTo IS NULL
	AND S.ValidityTo IS NULL
	AND HF.ValidityTo IS NULL
	AND HFD.ValidityTo IS NULL

	AND ISNULL(CS.PriceValuated,0) > 0
	--Also add a criteria if they want the batch id as well

	GROUP BY MONTH(ISNULL(C.DateTo,C.DateFrom)),DATENAME(QUARTER,ISNULL(C.DateTo,C.DateFrom)),YEAR(ISNULL(C.DateTo,C.DateFrom)),
	R.RegionName, PR.ProductCode,PR.ProductName,DATEDIFF(YEAR,I.DOB,ISNULL(C.DateTo,C.DateFrom)),I.Gender,
	S.ServType,S.ServCode,S.ServName,DATEDIFF(DAY, C.DateFrom, C.DateTo),
	HF.HFLevel,HF.HFCode,HF.HFName,C.VisitType, ICD.ICDCode, ICD.ICDName,
	DIns.DistrictName , W.WardName, V.VillageName, HFD.DistrictName, HFR.RegionName


GO

IF NOT OBJECT_ID('[dw].[uvwServiceUtilization]') IS NULL
DROP VIEW [dw].[uvwServiceUtilization]
GO

CREATE VIEW [dw].[uvwServiceUtilization]
AS
	SELECT  SUM(CS.QtyProvided) AS ServiceUtilized, MONTH(ISNULL(C.DateTo, C.DateFrom)) AS MonthTime, DATENAME(QUARTER, ISNULL(C.DateTo, C.DateFrom)) 
	AS QuarterTime, YEAR(ISNULL(C.DateTo, C.DateFrom)) AS YearTime, R.RegionName AS Region, DIns.DistrictName ,  Prod.ProductCode, Prod.ProductName, 
	DATEDIFF(YEAR, I.DOB, ISNULL(C.DateTo, C.DateFrom)) AS Age, I.Gender, S.ServType, S.ServCode, S.ServName, CASE WHEN DATEDIFF(DAY, C.DateFrom, 
	C.DateTo) > 0 THEN N'I' ELSE N'O' END AS ServCareType, HF.HFLevel, HF.HFCode, HF.HFName, C.VisitType, ICD.ICDCode, ICD.ICDName, 
	DIns.DistrictName AS IDistrictName, W.WardName, V.VillageName, HFD.DistrictName AS HFDistrict,HFR.RegionName AS HFRegion, 
	R.RegionName AS ProdRegion
	
	FROM dbo.tblClaimServices AS CS 
	INNER JOIN dbo.tblClaim AS C ON CS.ClaimID = C.ClaimID 
	LEFT OUTER JOIN dbo.tblProduct AS Prod ON CS.ProdID = Prod.ProdID 
	INNER JOIN dbo.tblInsuree AS I ON C.InsureeID = I.InsureeID 
	INNER JOIN dbo.tblFamilies AS F ON I.FamilyID = F.FamilyID 
	INNER JOIN dbo.tblVillages AS V ON V.VillageID = F.LocationId 
	INNER JOIN dbo.tblWards AS W ON W.WardID = V.WardID
	INNER JOIN  dbo.tblDistricts AS DIns ON DIns.DistrictID = W.DistrictID 
	INNER JOIN dbo.tblServices AS S ON CS.ServiceID = S.ServiceID 
	INNER JOIN dbo.tblHF AS HF ON C.HFID = HF.HfID 
	INNER JOIN dbo.tblICDCodes AS ICD ON C.ICDID = ICD.ICDID 
	INNER JOIN dbo.tblDistricts AS HFD ON HF.LocationId = HFD.DistrictID -- BY Rogers
	INNER JOIN dbo.tblRegions AS R ON R.RegionId = DIns.Region 
	INNER JOIN dbo.tblRegions AS HFR ON HFR.RegionId = HFD.Region

	WHERE (CS.ValidityTo IS NULL) 
	  AND (C.ValidityTo IS NULL) 
	  AND (Prod.ValidityTo IS NULL) 
	  AND (I.ValidityTo IS NULL) 
	  AND (DIns.ValidityTo IS NULL) 
	  AND (HF.ValidityTo IS NULL) 
	  AND (HFD.ValidityTo IS NULL) 
	  AND (F.ValidityTo IS NULL) 
	  AND (S.ValidityTo IS NULL) 
	  AND (C.ClaimStatus > 2)
	  AND CS.RejectionReason=0
	GROUP BY MONTH(ISNULL(C.DateTo, C.DateFrom)), DATENAME(QUARTER, ISNULL(C.DateTo, C.DateFrom)), YEAR(ISNULL(C.DateTo, C.DateFrom)), R.RegionName, 
	Prod.ProductCode, Prod.ProductName, DATEDIFF(YEAR, I.DOB, ISNULL(C.DateTo, C.DateFrom)), I.Gender, S.ServType, S.ServCode, S.ServName, DATEDIFF(DAY, 
	C.DateFrom, C.DateTo), HF.HFLevel, HF.HFCode, HF.HFName, C.VisitType, ICD.ICDCode, ICD.ICDName, DIns.DistrictName, W.WardName, V.VillageName, HFD.DistrictName  ,HFR.RegionName

GO

IF NOT OBJECT_ID('[dw].[uvwVisit]') IS NULL
DROP VIEW [dw].[uvwVisit]
GO

CREATE VIEW [dw].[uvwVisit]
AS
	SELECT COUNT(C.ClaimId) Visits, MONTH(C.DateFrom)MonthTime, DATENAME(QUARTER,C.DateFrom)QuarterTime, YEAR(C.DateFrom)YearTime
	,HFR.RegionName Region, HFD.DistrictName, Prod.ProductCode, Prod.ProductName,
	DATEDIFF(YEAR,I.DOB,C.DateFrom)Age,I.Gender,
	HF.HFLevel,HF.HFCode, HF.HFName,
	C.VisitType, ICD.ICDCode, ICD.ICDName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion
	FROM tblClaim C 
	LEFT OUTER JOIN
	(SELECT ClaimId,ProdId FROM tblClaimItems WHERE ValidityTo IS NULL AND RejectionReason = 0
	UNION 
	SELECT ClaimId,ProdID FROM tblClaimServices WHERE ValidityTo IS NULL AND RejectionReason = 0
	)Details ON C.ClaimID = Details.ClaimID
	LEFT OUTER JOIN tblProduct Prod ON Details.ProdID = Prod.ProdID
	LEFT OUTER JOIN tblInsuree I ON C.InsureeID = I.InsureeID
	LEFT OUTER JOIN tblHF HF ON C.HFID = HF.HFID
	LEFT OUTER JOIN tblICDCodes ICD ON C.ICDID = ICD.ICDID
	LEFT OUTER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	LEFT OUTER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region
	
	WHERE C.ValidityTo IS NULL
	AND Prod.ValidityTo IS NULL
	AND I.ValidityTo IS NULL
	AND HF.ValidityTo IS NULL
	AND HFD.ValidityTo IS NULL

	AND DATEDIFF(DAY,C.DateFrom,C.DateTo) = 0


	GROUP BY MONTH(C.DateFrom), DATENAME(QUARTER,C.DateFrom), YEAR(C.DateFrom)
	,Prod.ProductCode, Prod.ProductName,
	DATEDIFF(YEAR,I.DOB,C.DateFrom),I.Gender,
	HF.HFLevel,HF.HFCode, HF.HFName,C.VisitType, ICD.ICDCode, ICD.ICDName, HFD.DistrictName, HFR.RegionName


GO

IF NOT OBJECT_ID('[dw].[uspPremumAllocated]') IS NULL
DROP PROCEDURE [dw].[uspPremumAllocated]
GO

CREATE PROCEDURE [dw].[uspPremumAllocated]
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Counter INT = 1,
			@Year INT,
			@Date DATE,
			@EndDate DATE,
			@DaysInMonth INT,
			@MaxYear INT


	DECLARE @tblResult TABLE(
							Allocated DECIMAL(18,6),
							Region NVARCHAR(50), 
							DistrictName NVARCHAR(50), 
							ProductCode NVARCHAR(8), 
							ProductName NVARCHAR(100),
							MonthTime INT, 
							QuarterTime INT, 
							YearTime INT
							);

	SELECT @Year = YEAR(MIN(PayDate)) FROM tblPremium WHERE ValidityTo IS NULL;
	SELECT @MaxYear = YEAR(MAX(ExpiryDate)) FROM tblPolicy WHERE ValidityTo IS NULL;	



	WHILE @Year <= @MaxYear
	BEGIN	
		WHILE @Counter <= 12
		BEGIN

			SELECT @Date = CAST(CAST(@Year AS VARCHAR(4)) + '-' + CAST(@Counter AS VARCHAR(2)) + '-' + '01' AS DATE)
			SELECT @DaysInMonth = DAY(EOMONTH(@Date)) --DATEDIFF(DAY,@Date,DATEADD(MONTH,1,@Date))
			SELECT @EndDate = EOMONTH(@Date)--CAST(CONVERT(VARCHAR(4),@Year) + '-' + CONVERT(VARCHAR(2),@Counter) + '-' + CONVERT(VARCHAR(2),@DaysInMonth) AS DATE)
	


			;WITH Allocation AS
			(
				SELECT R.RegionName Region, D.DistrictName,Prod.ProductCode, Prod.ProductName,
				@Counter MonthTime,DATEPART(QUARTER,@Date)QuarterTime,@Year YearTime
				,CASE 
				WHEN MONTH(DATEADD(D,-1,PL.ExpiryDate)) = @Counter AND YEAR(DATEADD(D,-1,PL.ExpiryDate)) = @Year AND (DAY(PL.ExpiryDate)) > 1
					THEN CASE WHEN DATEDIFF(D,CASE WHEN PR.PayDate < @Date THEN @Date ELSE PR.PayDate END,PL.ExpiryDate) = 0 THEN 1 ELSE DATEDIFF(D,CASE WHEN PR.PayDate < @Date THEN @Date ELSE PR.PayDate END,PL.ExpiryDate) END  * ((SUM(PR.Amount))/(CASE WHEN (DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate)) <= 0 THEN 1 ELSE DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate) END))
				WHEN MONTH(CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END) = @Counter AND YEAR(CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END) = @Year
					THEN ((@DaysInMonth + 1 - DAY(CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END)) * ((SUM(PR.Amount))/CASE WHEN DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate) <= 0 THEN 1 ELSE DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate) END)) 
				WHEN PL.EffectiveDate < @Date AND PL.ExpiryDate > @EndDate AND PR.PayDate < @Date
					THEN @DaysInMonth * (SUM(PR.Amount)/CASE WHEN (DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,DATEADD(D,-1,PL.ExpiryDate))) <= 0 THEN 1 ELSE DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate) END)
				END Allocated
				FROM tblPremium PR INNER JOIN tblPolicy PL ON PR.PolicyID = PL.PolicyID
				INNER JOIN tblProduct Prod ON PL.ProdID = Prod.ProdID 
				INNER JOIN tblFamilies F ON PL.FamilyID = F.FamilyID
				INNER JOIN tblVillages V ON V.VillageId = F.LocationId
				INNER JOIN tblWards W ON W.WardId = V.WardId
				INNER JOIN tblDistricts D ON D.DistrictID = W.DistrictID
				INNER JOIN tblRegions R ON D.Region = R.RegionID
				--LEFT OUTER JOIN tblDistricts D ON Prod.DistrictID = D.DistrictID
				--LEFT OUTER JOIN tblRegions R ON R.RegionId = D.Region
				WHERE PR.ValidityTo IS NULL
				AND PL.ValidityTo IS NULL
				AND Prod.ValidityTo IS  NULL
				AND F.ValidityTo IS NULL
				AND D.ValidityTo IS NULL
				AND PL.PolicyStatus <> 1
				AND PR.PayDate <= PL.ExpiryDate
	
				GROUP BY PL.ExpiryDate, PR.PayDate, PL.EffectiveDate,R.RegionName, D.DistrictName,Prod.ProductCode, Prod.ProductName
			)
			INSERT INTO @tblResult(Allocated ,Region, DistrictName, ProductCode, ProductName, MonthTime, QuarterTime, YearTime)
			SELECT SUM(Allocated)Allocated, Region,DistrictName,ProductCode, ProductName,MonthTime,QuarterTime,YearTime
			FROM Allocation
			GROUP BY Region, DistrictName, ProductCode, ProductName,MonthTime,QuarterTime,YearTime;


			SET @Counter += 1;
		END	
		SET @Counter = 1;
		SET @Year += 1;
	END
	SELECT * FROM @tblResult;
END
GO

IF NOT OBJECT_ID('[dw].[udfNumberOfCurrentInsuree]') IS NULL
DROP FUNCTION [dw].[udfNumberOfCurrentInsuree]
GO

CREATE FUNCTION [dw].[udfNumberOfCurrentInsuree]()
RETURNS @Result TABLE(NumberOfCurrentInsuree INT, MonthTime INT, QuarterTime INT, YearTime INT, Age INT, Gender CHAR(1),Region NVARCHAR(20), InsureeDistrictName NVARCHAR(50), WardName NVARCHAR(50), VillageName NVARCHAR(50), ProdDistrictName NVARCHAR(50), ProductCode NVARCHAR(15), ProductName NVARCHAR(100), OfficeDistrict NVARCHAR(20), OfficerCode NVARCHAR(15), LastName NVARCHAR(100), OtherNames NVARCHAR(100), ProdRegion NVARCHAR(50))
AS
BEGIN

	DECLARE @StartDate DATE --= (SELECT MIN(EffectiveDate) FROM tblPolicy WHERE ValidityTo IS NULL)
	DECLARE @EndDate DATE --= (SELECT Max(ExpiryDate) FROM tblPolicy WHERE ValidityTo IS NULL)
	DECLARE @LastDate DATE

	SET @StartDate = '2011-01-01'
	SET @EndDate = DATEADD(YEAR,3,GETDATE())

	DECLARE @tblLastDays TABLE(LastDate DATE)

	WHILE @StartDate <= @EndDate
	BEGIN
	SET @LastDate = DATEADD(DAY,-1,DATEADD(MONTH,DATEDIFF(MONTH,0,@StartDate) + 1,0));
	SET @StartDate = DATEADD(MONTH,1,@StartDate);
	INSERT INTO @tblLastDays(LastDate) VALUES(@LastDate)
	END

	INSERT INTO @Result(NumberOfCurrentInsuree,MonthTime,QuarterTime,YearTime,Age,Gender,Region,InsureeDistrictName,WardName,VillageName,
	ProdDistrictName,ProductCode,ProductName, OfficeDistrict, OfficerCode,LastName,OtherNames, ProdRegion)

	SELECT COUNT(I.InsureeID)NumberOfCurrentInsuree,MONTH(LD.LastDate)MonthTime,DATENAME(Q,LastDate)QuarterTime,YEAR(LD.LastDate)YearTime,
	DATEDIFF(YEAR,I.DOB,GETDATE()) Age,CAST(I.Gender AS VARCHAR(1)) Gender,R.RegionName Region,D.DistrictName, W.WardName,V.VillageName,
	ISNULL(PD.DistrictName, D.DistrictName) ProdDistrictName,Prod.ProductCode, Prod.ProductName, 
	ODist.DistrictName OfficerDistrict,O.Code, O.LastName,O.OtherNames, ISNULL(PR.RegionName, R.RegionName) ProdRegion

	FROM tblPolicy PL INNER JOIN tblInsuree I ON PL.FamilyID = I.FamilyID
	INNER JOIN tblFamilies F ON I.FamilyID = F.FamilyID
	INNER JOIN tblVillages V ON V.VillageID = F.LocationId
	INNER JOIN tblWards W ON W.WardID = V.WardID
	INNER JOIN tblDistricts D ON D.DistrictID = W.DistrictID
	INNER JOIN tblProduct Prod ON PL.ProdID = Prod.ProdID
	INNER JOIN tblOfficer O ON PL.OfficerID = O.OfficerID
	INNER JOIN tblDistricts ODist ON O.LocationId = ODist.DistrictID
	INNER JOIN tblInsureePolicy PIns ON I.InsureeID = PIns.InsureeId AND PL.PolicyID = PIns.PolicyId
	INNER JOIN tblRegions R ON R.RegionId = D.Region
	LEFT OUTER JOIN tblDistricts PD ON PD.DistrictID = Prod.LocationId
	LEFT OUTER JOIN tblRegions PR ON PR.RegionId = Prod.LocationId
	CROSS APPLY @tblLastDays LD 

	WHERE PL.ValidityTo IS NULL 
	AND I.ValidityTo IS NULL 
	AND F.ValidityTo IS NULL
	AND D.ValidityTo IS NULL
	AND W.ValidityTo IS NULL
	AND Prod.ValidityTo IS NULL 
	AND O.ValidityTo IS NULL
	AND ODist.ValidityTo IS NULL
	AND PIns.ValidityTo IS NULL
	AND PIns.EffectiveDate <= LD.LastDate
	AND PIns.ExpiryDate  > LD.LastDate--= DATEADD(DAY, 1, DATEADD(MONTH,-1,EOMONTH(LD.LastDate,0))) 
	
	GROUP BY MONTH(LD.LastDate),DATENAME(Q,LastDate),YEAR(LD.LastDate),I.DOB,I.Gender, R.RegionName,D.DistrictName, W.WardName,V.VillageName,
	Prod.ProductCode, Prod.ProductName, ODist.DistrictName,O.Code, O.LastName,O.OtherNames, PD.DistrictName, PR.RegionName

	RETURN;

END
GO

IF NOT OBJECT_ID('[dw].[udfNumberOfCurrentPolicies]') IS NULL
DROP FUNCTION [dw].[udfNumberOfCurrentPolicies]
GO

CREATE FUNCTION [dw].[udfNumberOfCurrentPolicies]()
RETURNS @Result TABLE(NumberOfCurrentPolicies INT, MonthTime INT, QuarterTime INT, YearTime INT, Age INT, Gender CHAR(1),Region NVARCHAR(20), InsureeDistrictName NVARCHAR(50), WardName NVARCHAR(50), VillageName NVARCHAR(50), ProdDistrictName NVARCHAR(50), ProductCode NVARCHAR(15), ProductName NVARCHAR(100), OfficeDistrict NVARCHAR(20), OfficerCode NVARCHAR(15), LastName NVARCHAR(100), OtherNames NVARCHAR(100), ProdRegion NVARCHAR(50))
AS
BEGIN
	DECLARE @StartDate DATE --= (SELECT MIN(EffectiveDate) FROM tblPolicy WHERE ValidityTo IS NULL)
	DECLARE @EndDate DATE--= (SELECT Max(ExpiryDate) FROM tblPolicy WHERE ValidityTo IS NULL)
	DECLARE @LastDate DATE
	DECLARE @tblLastDays TABLE(LastDate DATE)

	DECLARE @Year INT,
		@MonthCounter INT = 1
	
	DECLARE Cur CURSOR FOR 
						SELECT Years FROM
						(SELECT YEAR(EffectiveDate) Years FROM tblPolicy WHERE ValidityTo IS NULL AND EffectiveDate IS NOT NULL GROUP BY YEAR(EffectiveDate) 
						UNION 
						SELECT YEAR(ExpiryDate) Years FROM tblPolicy WHERE ValidityTo IS NULL AND ExpiryDate IS NOT NULL GROUP BY YEAR(ExpiryDate)
						)Yrs ORDER BY Years
	OPEN Cur
		FETCH NEXT FROM Cur into @Year
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @StartDate = CAST(CAST(@Year AS VARCHAR(4))+ '-01-01' AS DATE)
			SET @MonthCounter = 1
			WHILE YEAR(@StartDate) = @Year
			BEGIN
				SET @LastDate = DATEADD(DAY,-1,DATEADD(MONTH,DATEDIFF(MONTH,0,@StartDate) + 1,0));
				SET @StartDate = DATEADD(MONTH,1,@StartDate);
				INSERT INTO @tblLastDays(LastDate) VALUES(@LastDate);
			END
			FETCH NEXT FROM Cur into @Year
		END
	CLOSE Cur
	DEALLOCATE Cur

	INSERT INTO @Result(NumberOfCurrentPolicies,MonthTime,QuarterTime,YearTime,Age,Gender,Region,InsureeDistrictName,WardName,VillageName,
	ProdDistrictName,ProductCode,ProductName, OfficeDistrict, OfficerCode,LastName,OtherNames, ProdRegion)
	SELECT COUNT(PolicyId) NumberOfCurrentPolicies, MONTH(LD.LastDate)MonthTime, DATENAME(Q,LD.LastDate)QuarterTime, YEAR(LD.LastDate)YearTime,
	DATEDIFF(YEAR, I.DOB,LD.LastDate)Age, I.Gender, R.RegionName Region, FD.DistrictName InsureeDistrictName, W.WardName, V.VillageName,
	ISNULL(PD.DistrictName, FD.DistrictName) ProdDistrictName, PR.ProductCode, PR.ProductName, OD.DistrictName OfficeDistrict, O.Code OfficerCode, O.LastName, O.OtherNames,
	ISNULL(PRDR.RegionName, R.RegionName) ProdRegion

	FROM tblPolicy PL 
	INNER JOIN tblFamilies F ON PL.FamilyId = F.FamilyID
	INNER JOIN tblInsuree I ON F.InsureeID = I.InsureeID
	INNER JOIN tblVillages V ON V.VillageId = F.LocationId
	INNER JOIN tblWards W ON W.WardId = V.WardID
	INNER JOIN tblDistricts FD ON FD.DistrictID = W.DistrictID
	INNER JOIN tblProduct PR ON PL.ProdID = PR.ProdID
	INNER JOIN tblOfficer O ON PL.OfficerId  = O.OfficerID
	INNER JOIN tblDistricts OD ON OD.DistrictId = O.LocationId
	INNER JOIN tblRegions R ON R.RegionId = FD.Region
	LEFT OUTER JOIN tblDistricts PD ON PD.DistrictId = PR.LocationId
	LEFT OUTER JOIN tblRegions PRDR ON PRDR.Regionid = PR.LocationId
	CROSS APPLY @tblLastDays LD
	WHERE PL.ValidityTo IS NULL
	AND F.ValidityTo IS NULL
	AND I.ValidityTo IS NULL
	AND F.ValidityTo IS NULL
	AND FD.ValidityTo IS NULL
	AND W.ValidityTo IS NULL
	AND V.ValidityTo IS NULL
	AND PR.ValidityTo IS NULL
	AND O.ValidityTo IS NULL
	AND OD.ValidityTo IS NULL
	AND PL.EffectiveDate <= LD.LastDate
	AND PL.ExpiryDate > LD.LastDate--DATEADD(DAY, 1, DATEADD(MONTH,-1,EOMONTH(LD.LastDate,0))) 
	AND PL.PolicyStatus > 1

	GROUP BY DATEDIFF(YEAR, I.DOB,LD.LastDate),MONTH(LD.LastDate), DATENAME(Q,LD.LastDate), YEAR(LD.LastDate),
	I.Gender, R.RegionName, FD.DistrictName, W.WardName, V.VillageName,PR.ProductCode, 
	PR.ProductName,OD.DistrictName, O.COde ,O.LastName, O.OtherNames, PD.DistrictName, PRDR.RegionName
	
	RETURN;
END


GO

IF NOT OBJECT_ID('[dw].[udfNumberOfPoliciesExpired]') IS NULL
DROP FUNCTION [dw].[udfNumberOfPoliciesExpired]
GO

CREATE FUNCTION [dw].[udfNumberOfPoliciesExpired]()
	RETURNS @Result TABLE(ExpiredPolicy INT, MonthTime INT, QuarterTime INT, YearTime INT, Age INT, Gender CHAR(1),Region NVARCHAR(20), InsureeDistrictName NVARCHAR(50), WardName NVARCHAR(50), VillageName NVARCHAR(50), ProdDistrictName NVARCHAR(50), ProductCode NVARCHAR(15), ProductName NVARCHAR(100), OfficeDistrict NVARCHAR(20), OfficerCode NVARCHAR(15), LastName NVARCHAR(100), OtherNames NVARCHAR(100), ProdRegion NVARCHAR(50))
AS
BEGIN

	DECLARE @tbl TABLE(MonthId INT, YearId INT)
	INSERT INTO @tbl
	SELECT DISTINCT MONTH(ExpiryDate),YEAR(ExpiryDate) FROM tblPolicy WHERE ValidityTo IS NULL ORDER BY YEAR(ExpiryDate),MONTH(ExpiryDate)


	INSERT INTO @Result(ExpiredPolicy,MonthTime,QuarterTime,YearTime,Age,Gender,Region,InsureeDistrictName,WardName,VillageName,
				ProdDistrictName,ProductCode,ProductName, OfficeDistrict, OfficerCode,LastName,OtherNames, ProdRegion)
			
	SELECT COUNT(PL.PolicyID)ExpiredPolicy, MONTH(PL.ExpiryDate)MonthTime, DATENAME(Q,PL.ExpiryDate) QuarterTime, YEAR(PL.ExpiryDate)YearTime,
	DATEDIFF(YEAR,I.DOB,GETDATE())Age, I.Gender, R.RegionName Region,D.DistrictName, W.WardName,V.VillageName,
	D.DistrictName ProdDistrictName,PR.ProductCode, PR.ProductName, 
	ODist.DistrictName OfficerDistrict,O.Code, O.LastName,O.OtherNames, R.RegionName ProdRegion


	FROM tblPolicy PL  INNER JOIN TblProduct PR ON PL.ProdID = PR.ProdID
	INNER JOIN tblOfficer O ON PL.OfficerID = O.OfficerID
	INNER JOIN tblInsuree I ON PL.FamilyID = I.FamilyID
	INNER JOIN tblFamilies F ON I.FamilyID = F.FamilyID
	INNER JOIN tblVillages V ON V.VillageID = F.LocationId
	INNER JOIN tblWards W ON W.WardID = V.WardID
	INNER JOIN tblDistricts D ON D.DistrictID = W.DistrictID
	INNER JOIN tblDistricts ODist ON O.LocationId = ODist.DistrictID
	INNER JOIN tblRegions R ON R.RegionId = D.Region
	CROSS APPLY @tbl t

	WHERE PL.ValidityTo IS NULL 
	AND PR.ValidityTo IS NULL 
	AND I.ValidityTo IS NULL 
	AND O.ValidityTo IS NULL
	AND I.IsHead = 1
	AND MONTH(PL.ExpiryDate) = t.MonthId AND YEAR(PL.ExpiryDate) = t.YearId
	AND PL.PolicyStatus > 1

	GROUP BY MONTH(PL.ExpiryDate),DATENAME(Q,PL.ExpiryDate), YEAR(PL.ExpiryDate), DATEDIFF(YEAR,I.DOB,GETDATE()),
	I.Gender, R.RegionName,D.DistrictName, W.WardName,V.VillageName ,PR.ProductCode, PR.ProductName, 
	ODist.DistrictName,O.Code, O.LastName,O.OtherNames

	RETURN;
END


GO


--ON 10/08/2017
IF NOT OBJECT_ID('dw.uvwPopulation') IS NULL
DROP VIEW dw.uvwPopulation
GO

CREATE VIEW dw.uvwPopulation
AS
	SELECT RegionName Region,	DistrictName District,WardName Ward, VillageName Village, MalePopulation Male, FemalePopulation	Female, OtherPopulation others , Families	Households,	Year(GETDATE()) YEAR 
	FROM tblVillages V
	INNER JOIN tblWards W ON V.WardId = W.WardId
	INNER JOIN tblDistricts D ON D.DistrictId =W.DistrictId
	INNER JOIN tblRegions R ON R.RegionId = D.Region
	WHERE V.ValidityTo IS NULL
	AND W.ValidityTo  IS NULL 
	AND D.ValidityTo   IS NULL
	AND R.ValidityTo   IS NULL
GO

--ON 17/08/2017
IF NOT OBJECT_ID('[dw].[udfNumberOfPoliciesExpired]') IS NULL
DROP FUNCTION [dw].[udfNumberOfPoliciesExpired]
GO

CREATE FUNCTION [dw].[udfNumberOfPoliciesExpired]()
	RETURNS @Result TABLE(ExpiredPolicy INT, MonthTime INT, QuarterTime INT, YearTime INT, Age INT, Gender CHAR(1),Region NVARCHAR(20), InsureeDistrictName NVARCHAR(50), WardName NVARCHAR(50), VillageName NVARCHAR(50), ProdDistrictName NVARCHAR(50), ProductCode NVARCHAR(15), ProductName NVARCHAR(100), OfficeDistrict NVARCHAR(20), OfficerCode NVARCHAR(15), LastName NVARCHAR(100), OtherNames NVARCHAR(100), ProdRegion NVARCHAR(50))
AS
BEGIN

	DECLARE @tbl TABLE(MonthId INT, YearId INT)
	INSERT INTO @tbl
	SELECT DISTINCT MONTH(ExpiryDate),YEAR(ExpiryDate) FROM tblPolicy WHERE ValidityTo IS NULL ORDER BY YEAR(ExpiryDate),MONTH(ExpiryDate)


	INSERT INTO @Result(ExpiredPolicy,MonthTime,QuarterTime,YearTime,Age,Gender,Region,InsureeDistrictName,WardName,VillageName,
				ProdDistrictName,ProductCode,ProductName, OfficeDistrict, OfficerCode,LastName,OtherNames, ProdRegion)
			
	SELECT COUNT(PL.PolicyID)ExpiredPolicy, MONTH(PL.ExpiryDate)MonthTime, DATENAME(Q,PL.ExpiryDate) QuarterTime, YEAR(PL.ExpiryDate)YearTime,
	DATEDIFF(YEAR,I.DOB,PL.ExpiryDate)Age, I.Gender, R.RegionName Region,D.DistrictName, W.WardName,V.VillageName,
	D.DistrictName ProdDistrictName,PR.ProductCode, PR.ProductName, 
	ODist.DistrictName OfficerDistrict,O.Code, O.LastName,O.OtherNames, R.RegionName ProdRegion


	FROM tblPolicy PL  INNER JOIN TblProduct PR ON PL.ProdID = PR.ProdID
	INNER JOIN tblOfficer O ON PL.OfficerID = O.OfficerID
	INNER JOIN tblInsuree I ON PL.FamilyID = I.FamilyID
	INNER JOIN tblFamilies F ON I.FamilyID = F.FamilyID
	INNER JOIN tblVillages V ON V.VillageID = F.LocationId
	INNER JOIN tblWards W ON W.WardID = V.WardID
	INNER JOIN tblDistricts D ON D.DistrictID = W.DistrictID
	INNER JOIN tblDistricts ODist ON O.LocationId = ODist.DistrictID
	INNER JOIN tblRegions R ON R.RegionId = D.Region
	CROSS APPLY @tbl t

	WHERE PL.ValidityTo IS NULL 
	AND PR.ValidityTo IS NULL 
	AND I.ValidityTo IS NULL 
	AND O.ValidityTo IS NULL
	AND I.IsHead = 1
	AND MONTH(PL.ExpiryDate) = t.MonthId AND YEAR(PL.ExpiryDate) = t.YearId
	AND PL.PolicyStatus > 1

	GROUP BY MONTH(PL.ExpiryDate),DATENAME(Q,PL.ExpiryDate), YEAR(PL.ExpiryDate), DATEDIFF(YEAR,I.DOB,PL.ExpiryDate),
	I.Gender, R.RegionName,D.DistrictName, W.WardName,V.VillageName ,PR.ProductCode, PR.ProductName, 
	ODist.DistrictName,O.Code, O.LastName,O.OtherNames

	RETURN;
END
GO


--ON 18/08/2017
IF NOT OBJECT_ID('[dw].[uvwServiceExpenditures]') IS NULL
DROP VIEW [dw].[uvwServiceExpenditures]
GO

CREATE VIEW [dw].[uvwServiceExpenditures]
AS
	SELECT SUM(CS.RemuneratedAmount)ServiceExpenditure,MONTH(ISNULL(C.DateTo,C.DateFrom))MonthTime,DATENAME(QUARTER,ISNULL(C.DateTo,C.DateFrom))QuarterTime,YEAR(ISNULL(C.DateTo,C.DateFrom))YearTime,
	R.RegionName Region,HFD.DistrictName,PR.ProductCode,PR.ProductName,DATEDIFF(YEAR,I.DOB,ISNULL(C.DateTo,C.DateFrom))Age,I.Gender,
	S.ServType,S.ServCode,S.ServName,CASE WHEN DATEDIFF(DAY, C.DateFrom, C.DateTo) > 0 THEN N'I' ELSE N'O' END ServCareType,
	HF.HFLevel,HF.HFCode,HF.HFName,C.VisitType, ICD.ICDCode, ICD.ICDName,
	DIns.DistrictName IDistrictName , W.WardName, V.VillageName, HFD.DistrictName HFDistrict, HFR.RegionName HFRegion, HFR.RegionName ProdRegion

	FROM tblClaimServices CS INNER JOIN tblClaim C ON CS.ClaimID = C.ClaimID
	INNER JOIN tblProduct PR ON CS.ProdID = PR.ProdID
	INNER JOIN tblInsuree I ON C.InsureeID = I.InsureeID
	INNER JOIN tblFamilies F ON I.FamilyID = F.FamilyID
	INNER JOIN tblVillages V ON V.VillageId = F.LocationId
	INNER JOIN tblWards W ON W.WardID = V.WardID
	INNER JOIN tblDistricts DIns ON DIns.DistrictID = W.DistrictID
	INNER JOIN tblServices S ON CS.ServiceID = S.ServiceID
	INNER JOIN tblHF HF ON C.HFID = HF.HfID
	INNER JOIN tblICDCodes ICD ON C.ICDID = ICD.ICDID
	INNER JOIN tblDistricts HFD ON HF.LocationId = HFD.DistrictID
	INNER JOIN tblRegions R ON R.RegionId = DIns.Region
	INNER JOIN tblRegions HFR ON HFR.RegionId = HFD.Region
	
	WHERE CS.ValidityTo IS NULL
	AND C.ValidityTo IS NULL
	AND PR.ValidityTo IS NULL
	AND I.ValidityTo IS NULL
	AND S.ValidityTo IS NULL
	AND HF.ValidityTo IS NULL
	AND HFD.ValidityTo IS NULL

	AND ISNULL(CS.PriceValuated,0) > 0
	--Also add a criteria if they want the batch id as well

	GROUP BY MONTH(ISNULL(C.DateTo,C.DateFrom)),DATENAME(QUARTER,ISNULL(C.DateTo,C.DateFrom)),YEAR(ISNULL(C.DateTo,C.DateFrom)),
	R.RegionName, PR.ProductCode,PR.ProductName,DATEDIFF(YEAR,I.DOB,ISNULL(C.DateTo,C.DateFrom)),I.Gender,
	S.ServType,S.ServCode,S.ServName,DATEDIFF(DAY, C.DateFrom, C.DateTo),
	HF.HFLevel,HF.HFCode,HF.HFName,C.VisitType, ICD.ICDCode, ICD.ICDName,
	DIns.DistrictName , W.WardName, V.VillageName, HFD.DistrictName, HFR.RegionName



GO

