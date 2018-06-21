/*====================================================================================================================
SCRIPT TO CHANGE FROM 17.5.16 TO 18.0.0
====================================================================================================================*/

--ON 06/03/2018
IF NOT OBJECT_ID('uspPolicyInquiry') IS NULL
DROP PROCEDURE uspPolicyInquiry
GO


CREATE PROCEDURE [dbo].[uspPolicyInquiry] 
(
	@CHFID NVARCHAR(12) = '',
	@LocationId int =  0
)
AS
BEGIN
	IF NOT OBJECT_ID('tempdb..#tempBase') IS NULL DROP TABLE #tempBase

		SELECT PR.ProdID,PL.PolicyID,I.CHFID,P.PhotoFolder + case when RIGHT(P.PhotoFolder,1) = '\' then '' else '\' end + P.PhotoFileName PhotoPath,I.LastName + ' ' + I.OtherNames InsureeName,
		CONVERT(VARCHAR,DOB,103) DOB, CASE WHEN I.Gender = 'M' THEN 'Male' ELSE 'Female' END Gender,PR.ProductCode,PR.ProductName,
		CONVERT(VARCHAR(12),IP.ExpiryDate,103) ExpiryDate, 
		CASE WHEN IP.EffectiveDate IS NULL OR CAST(GETDATE() AS DATE) < IP.EffectiveDate  THEN 'I' WHEN CAST(GETDATE() AS DATE) NOT BETWEEN IP.EffectiveDate AND IP.ExpiryDate THEN 'E' ELSE 
		CASE PL.PolicyStatus WHEN 1 THEN 'I' WHEN 2 THEN 'A' WHEN 4 THEN 'S' ELSE 'E' END
		END  AS [Status]
		INTO #tempBase
		FROM tblInsuree I LEFT OUTER JOIN tblPhotos P ON I.PhotoID = P.PhotoID
		INNER JOIN tblFamilies F ON I.FamilyId = F.FamilyId 
		INNER JOIN tblVillages V ON V.VillageId = F.LocationId
		INNER JOIN tblWards W ON W.WardId = V.WardId
		INNER JOIN tblDistricts D ON D.DistrictId = W.DistrictId
		LEFT OUTER JOIN tblPolicy PL ON I.FamilyID = PL.FamilyID
		LEFT OUTER JOIN tblProduct PR ON PL.ProdID = PR.ProdID
		LEFT OUTER JOIN tblInsureePolicy IP ON IP.InsureeId = I.InsureeId AND IP.PolicyId = PL.PolicyID
		WHERE I.ValidityTo IS NULL AND PL.ValidityTo IS NULL AND P.ValidityTo IS NULL AND PR.ValidityTo IS NULL AND IP.ValidityTo IS NULL AND F.ValidityTo IS NULL
		AND (I.CHFID = @CHFID OR @CHFID = '')
		AND (D.DistrictID = @LocationId or @LocationId= 0)


	DECLARE @Members INT = (SELECT COUNT(1) FROM tblInsuree WHERE FamilyID = (SELECT TOP 1 FamilyId FROM tblInsuree WHERE CHFID = @CHFID AND ValidityTo IS NULL) AND ValidityTo IS NULL); 		
	DECLARE @InsureeId INT = (SELECT InsureeId FROM tblInsuree WHERE CHFID = @CHFID AND ValidityTo IS NULL)
	DECLARE @FamilyId INT = (SELECT FamilyId FROM tblInsuree WHERE ValidityTO IS NULL AND CHFID = @CHFID);

		
	IF NOT OBJECT_ID('tempdb..#tempDedRem')IS NULL DROP TABLE #tempDedRem
	CREATE TABLE #tempDedRem (PolicyId INT, ProdID INT,DedInsuree DECIMAL(18,2),DedOPInsuree DECIMAL(18,2),DedIPInsuree DECIMAL(18,2),MaxInsuree DECIMAL(18,2),MaxOPInsuree DECIMAL(18,2),MaxIPInsuree DECIMAL(18,2),DedTreatment DECIMAL(18,2),DedOPTreatment DECIMAL(18,2),DedIPTreatment DECIMAL(18,2),MaxTreatment DECIMAL(18,2),MaxOPTreatment DECIMAL(18,2),MaxIPTreatment DECIMAL(18,2),DedPolicy DECIMAL(18,2),DedOPPolicy DECIMAL(18,2),DedIPPolicy DECIMAL(18,2),MaxPolicy DECIMAL(18,2),MaxOPPolicy DECIMAL(18,2),MaxIPPolicy DECIMAL(18,2))

	INSERT INTO #tempDedRem(PolicyId, ProdID ,DedInsuree ,DedOPInsuree ,DedIPInsuree ,MaxInsuree ,MaxOPInsuree ,MaxIPInsuree ,DedTreatment ,DedOPTreatment ,DedIPTreatment ,MaxTreatment ,MaxOPTreatment ,MaxIPTreatment ,DedPolicy ,DedOPPolicy ,DedIPPolicy ,MaxPolicy ,MaxOPPolicy ,MaxIPPolicy)
					SELECT #tempBase.PolicyId, #tempBase.ProdID,
					DedInsuree ,DedOPInsuree ,DedIPInsuree ,
					MaxInsuree,MaxOPInsuree,MaxIPInsuree ,
					DedTreatment ,DedOPTreatment ,DedIPTreatment,
					MaxTreatment ,MaxOPTreatment ,MaxIPTreatment,
					DedPolicy ,DedOPPolicy ,DedIPPolicy , 
					CASE WHEN ISNULL(NULLIF(SIGN(((CASE WHEN MemberCount - @Members < 0 THEN MemberCount ELSE @Members END - Threshold) * ISNULL(MaxPolicyExtraMember, 0))),-1),0) * ((CASE WHEN MemberCount - @Members < 0 THEN MemberCount ELSE @Members END - Threshold) * ISNULL(MaxPolicyExtraMember, 0)) + MaxPolicy > MaxCeilingPolicy THEN MaxCeilingPolicy ELSE ISNULL(NULLIF(SIGN(((CASE WHEN MemberCount - @Members < 0 THEN MemberCount ELSE @Members END - Threshold) * ISNULL(MaxPolicyExtraMember, 0))),-1),0) * ((CASE WHEN MemberCount - @Members < 0 THEN MemberCount ELSE @Members END - Threshold) * ISNULL(MaxPolicyExtraMember, 0)) + MaxPolicy END MaxPolicy ,
					CASE WHEN ISNULL(NULLIF(SIGN(((CASE WHEN MemberCount - @Members < 0 THEN MemberCount ELSE @Members END - Threshold) * ISNULL(MaxPolicyExtraMemberOP, 0))),-1),0) * ((CASE WHEN MemberCount - @Members < 0 THEN MemberCount ELSE @Members END - Threshold) * ISNULL(MaxPolicyExtraMemberOP, 0)) + MaxOPPolicy > MaxCeilingPolicyOP THEN MaxCeilingPolicyOP ELSE ISNULL(NULLIF(SIGN(((CASE WHEN MemberCount - @Members < 0 THEN MemberCount ELSE @Members END - Threshold) * ISNULL(MaxPolicyExtraMemberOP, 0))),-1),0) * ((CASE WHEN MemberCount - @Members < 0 THEN MemberCount ELSE @Members END - Threshold) * ISNULL(MaxPolicyExtraMemberOP, 0)) + MaxOPPolicy END MaxOPPolicy ,
					CASE WHEN ISNULL(NULLIF(SIGN(((CASE WHEN MemberCount - @Members < 0 THEN MemberCount ELSE @Members END - Threshold) * ISNULL(MaxPolicyExtraMemberIP, 0))),-1),0) * ((CASE WHEN MemberCount - @Members < 0 THEN MemberCount ELSE @Members END - Threshold) * ISNULL(MaxPolicyExtraMemberIP, 0)) + MaxIPPolicy > MaxCeilingPolicyIP THEN MaxCeilingPolicyIP ELSE ISNULL(NULLIF(SIGN(((CASE WHEN MemberCount - @Members < 0 THEN MemberCount ELSE @Members END - Threshold) * ISNULL(MaxPolicyExtraMemberIP, 0))),-1),0) * ((CASE WHEN MemberCount - @Members < 0 THEN MemberCount ELSE @Members END - Threshold) * ISNULL(MaxPolicyExtraMemberIP, 0)) + MaxIPPolicy END MaxIPPolicy
					FROM tblProduct INNER JOIN #tempBase ON tblProduct.ProdID = #tempBase.ProdID
					WHERE ValidityTo IS NULL



IF EXISTS(SELECT 1 FROM tblClaimDedRem WHERE InsureeID = @InsureeId AND ValidityTo IS NULL)
BEGIN			
	UPDATE #tempDedRem
	SET 
	DedInsuree = (SELECT DedInsuree - ISNULL(SUM(DedG),0) 
			FROM tblProduct INNER JOIN tblPolicy ON tblProduct.ProdID = tblPolicy.ProdID
			LEFT OUTER JOIN tblClaimDedRem ON tblPolicy.PolicyID = tblClaimDedRem.PolicyID
			WHERE tblProduct.ValidityTo IS NULL 
			AND tblProduct.ProdID = #tempDedRem.ProdID
			AND tblClaimDedRem.PolicyID = #tempDedRem.PolicyId
			AND InsureeId = @InsureeId
			GROUP BY DedInsuree),
	DedOPInsuree = (select DedOPInsuree - ISNULL(SUM(DedOP),0) 
			FROM tblProduct INNER JOIN tblPolicy ON tblProduct.ProdID = tblPolicy.ProdID
			LEFT OUTER JOIN tblClaimDedRem ON tblPolicy.PolicyID = tblClaimDedRem.PolicyID
			WHERE tblProduct.ValidityTo IS NULL 
			AND tblProduct.ProdID = #tempDedRem.ProdID
			AND tblClaimDedRem.PolicyId = #tempDedRem.PolicyId
			AND InsureeId = @InsureeId
			GROUP BY DedOPInsuree),
	DedIPInsuree = (SELECT DedIPInsuree - ISNULL(SUM(DedIP),0)
			FROM tblProduct INNER JOIN tblPolicy ON tblProduct.ProdID = tblPolicy.ProdID
			LEFT OUTER JOIN tblClaimDedRem ON tblPolicy.PolicyID = tblClaimDedRem.PolicyID
			WHERE tblProduct.ValidityTo IS NULL 
			AND tblProduct.ProdID = #tempDedRem.ProdID
			AND tblClaimDedRem.PolicyId = #tempDedRem.PolicyId
			AND InsureeId = @InsureeId
			GROUP BY DedIPInsuree) ,
	MaxInsuree = (SELECT MaxInsuree - ISNULL(SUM(RemG),0)
			FROM tblProduct INNER JOIN tblPolicy ON tblProduct.ProdID = tblPolicy.ProdID
			LEFT OUTER JOIN tblClaimDedRem ON tblPolicy.PolicyID = tblClaimDedRem.PolicyID
			WHERE tblProduct.ValidityTo IS NULL 
			AND tblProduct.ProdID = #tempDedRem.ProdID
			AND tblClaimDedRem.PolicyId = #tempDedRem.PolicyId
			AND InsureeId = @InsureeId
			GROUP BY MaxInsuree ),
	MaxOPInsuree = (SELECT MaxOPInsuree - ISNULL(SUM(RemOP),0)
			FROM tblProduct INNER JOIN tblPolicy ON tblProduct.ProdID = tblPolicy.ProdID
			LEFT OUTER JOIN tblClaimDedRem ON tblPolicy.PolicyID = tblClaimDedRem.PolicyID
			WHERE tblProduct.ValidityTo IS NULL 
			AND tblProduct.ProdID = #tempDedRem.ProdID
			AND tblClaimDedRem.PolicyId = #tempDedRem.PolicyId
			AND InsureeId = @InsureeId
			GROUP BY MaxOPInsuree ) ,
	MaxIPInsuree = (SELECT MaxIPInsuree - ISNULL(SUM(RemIP),0)
			FROM tblProduct INNER JOIN tblPolicy ON tblProduct.ProdID = tblPolicy.ProdID
			LEFT OUTER JOIN tblClaimDedRem ON tblPolicy.PolicyID = tblClaimDedRem.PolicyID
			WHERE tblProduct.ValidityTo IS NULL 
			AND tblProduct.ProdID = #tempDedRem.ProdID
			AND tblClaimDedRem.PolicyId = #tempDedRem.PolicyId
			AND InsureeId = @InsureeId
			GROUP BY MaxIPInsuree),
	DedTreatment = (SELECT DedTreatment FROM tblProduct WHERE tblProduct.ValidityTo IS NULL AND tblProduct.ProdID = #tempDedRem.ProdID ) ,
	DedOPTreatment = (SELECT DedOPTreatment FROM tblProduct WHERE tblProduct.ValidityTo IS NULL AND tblProduct.ProdID = #tempDedRem.ProdID) ,
	DedIPTreatment = (SELECT DedIPTreatment FROM tblProduct WHERE tblProduct.ValidityTo IS NULL AND tblProduct.ProdID = #tempDedRem.ProdID) ,
	MaxTreatment = (SELECT MaxTreatment FROM tblProduct WHERE tblProduct.ValidityTo IS NULL AND tblProduct.ProdID = #tempDedRem.ProdID) ,
	MaxOPTreatment = (SELECT MaxOPTreatment FROM tblProduct WHERE tblProduct.ValidityTo IS NULL AND tblProduct.ProdID = #tempDedRem.ProdID) ,
	MaxIPTreatment = (SELECT MaxIPTreatment FROM tblProduct WHERE tblProduct.ValidityTo IS NULL AND tblProduct.ProdID = #tempDedRem.ProdID) 
	
END



IF EXISTS(SELECT 1
			FROM tblInsuree I INNER JOIN tblClaimDedRem DR ON I.InsureeId = DR.InsureeId
			WHERE I.ValidityTo IS NULL
			AND DR.ValidityTO IS NULL
			AND I.FamilyId = @FamilyId)			
BEGIN
	UPDATE #tempDedRem SET
	DedPolicy = (SELECT DedPolicy - ISNULL(SUM(DedG),0)
			FROM tblProduct INNER JOIN tblPolicy ON tblProduct.ProdID = tblPolicy.ProdID
			LEFT OUTER JOIN tblClaimDedRem ON tblPolicy.PolicyID = tblClaimDedRem.PolicyID
			WHERE tblProduct.ValidityTo IS NULL 
			AND tblProduct.ProdID = #tempDedRem.ProdID
			AND tblClaimDedRem.PolicyId = #tempDedRem.PolicyId
			AND FamilyId = @FamilyId
			GROUP BY DedPolicy),
	DedOPPolicy = (SELECT DedOPPolicy - ISNULL(SUM(DedOP),0)
			FROM tblProduct INNER JOIN tblPolicy ON tblProduct.ProdID = tblPolicy.ProdID
			LEFT OUTER JOIN tblClaimDedRem ON tblPolicy.PolicyID = tblClaimDedRem.PolicyID
			WHERE tblProduct.ValidityTo IS NULL 
			AND tblProduct.ProdID = #tempDedRem.ProdID
			AND tblClaimDedRem.PolicyId = #tempDedRem.PolicyId
			AND FamilyId = @FamilyId
			GROUP BY DedOPPolicy),
	DedIPPolicy = (SELECT DedIPPolicy - ISNULL(SUM(DedIP),0)
			FROM tblProduct INNER JOIN tblPolicy ON tblProduct.ProdID = tblPolicy.ProdID
			LEFT OUTER JOIN tblClaimDedRem ON tblPolicy.PolicyID = tblClaimDedRem.PolicyID
			WHERE tblProduct.ValidityTo IS NULL 
			AND tblProduct.ProdID = #tempDedRem.ProdID
			AND tblClaimDedRem.PolicyId = #tempDedRem.PolicyId
			AND FamilyId = @FamilyId
			GROUP BY DedIPPolicy)


	UPDATE t SET MaxPolicy = MaxPolicyLeft, MaxOPPolicy = MaxOPLeft, MaxIPPolicy = MaxIPLeft
	FROM #tempDedRem t LEFT OUTER JOIN
	(SELECT t.PolicyId, t.ProdId, t.MaxPolicy - ISNULL(SUM(RemG),0)MaxPolicyLeft
	FROM #tempDedRem t INNER JOIN tblPolicy ON t.ProdID = tblPolicy.ProdID --AND tblPolicy.PolicyStatus = 2 
	LEFT OUTER JOIN tblClaimDedRem ON tblPolicy.PolicyID = tblClaimDedRem.PolicyID AND tblClaimDedRem.PolicyId = t.PolicyId
	WHERE FamilyId = @FamilyId
	
	--AND Prod.ValidityTo IS NULL AND Prod.ProdID = t.ProdID
	GROUP BY t.ProdId, t.MaxPolicy, t.PolicyId)MP ON t.ProdID = MP.ProdID AND t.PolicyId = MP.PolicyId
	LEFT OUTER JOIN
	--UPDATE t SET MaxOPPolicy = MaxOPLeft
	--FROM #tempDedRem t LEFT OUTER JOIN
	(SELECT t.PolicyId, t.ProdId, MaxOPPolicy - ISNULL(SUM(RemOP),0) MaxOPLeft
	FROM #tempDedRem t INNER JOIN tblPolicy ON t.ProdID = tblPolicy.ProdID  --AND tblPolicy.PolicyStatus = 2
	LEFT OUTER JOIN tblClaimDedRem ON tblPolicy.PolicyID = tblClaimDedRem.PolicyID AND tblClaimDedRem.PolicyId = t.PolicyId
	WHERE FamilyId = @FamilyId
	
	--WHERE tblProduct.ValidityTo IS NULL AND tblProduct.ProdID = #tempDedRem.ProdID
	GROUP BY t.ProdId, MaxOPPolicy, t.PolicyId)MOP ON t.ProdId = MOP.ProdID AND t.PolicyId = MOP.PolicyId
	LEFT OUTER JOIN
	(SELECT t.PolicyId, t.ProdId, MaxIPPolicy - ISNULL(SUM(RemIP),0) MaxIPLeft
	FROM #tempDedRem t INNER JOIN tblPolicy ON t.ProdID = tblPolicy.ProdID  --AND tblPolicy.PolicyStatus = 2
	LEFT OUTER JOIN tblClaimDedRem ON tblPolicy.PolicyID = tblClaimDedRem.PolicyID AND tblClaimDedRem.PolicyId = t.PolicyId
	WHERE FamilyId = @FamilyId
	
	--WHERE tblProduct.ValidityTo IS NULL AND tblProduct.ProdID = #tempDedRem.ProdID
	GROUP BY t.ProdId, MaxIPPolicy, t.PolicyId)MIP ON t.ProdId = MIP.ProdID AND t.PolicyId = MIP.PolicyId	
END


	ALTER TABLE #tempBase ADD DedType FLOAT NULL
	ALTER TABLE #tempBase ADD Ded1 DECIMAL(18,2) NULL
	ALTER TABLE #tempBase ADD Ded2 DECIMAL(18,2) NULL
	ALTER TABLE #tempBase ADD Ceiling1 DECIMAL(18,2) NULL
	ALTER TABLE #tempBase ADD Ceiling2 DECIMAL(18,2) NULL
			
	DECLARE @ProdID INT
	DECLARE @DedType FLOAT = NULL
	DECLARE @Ded1 DECIMAL(18,2) = NULL
	DECLARE @Ded2 DECIMAL(18,2) = NULL
	DECLARE @Ceiling1 DECIMAL(18,2) = NULL
	DECLARE @Ceiling2 DECIMAL(18,2) = NULL
	DECLARE @PolicyID INT

	DECLARE Cur CURSOR FOR SELECT DISTINCT ProdId, PolicyId FROM #tempDedRem
	OPEN Cur
	FETCH NEXT FROM Cur INTO @ProdID, @PolicyId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Ded1 = NULL
		SET @Ded2 = NULL
		SET @Ceiling1 = NULL
		SET @Ceiling2 = NULL
		
		SELECT @Ded1 =  CASE WHEN NOT DedInsuree IS NULL THEN DedInsuree WHEN NOT DedTreatment IS NULL THEN DedTreatment WHEN NOT DedPolicy IS NULL THEN DedPolicy ELSE NULL END  FROM #tempDedRem WHERE ProdID = @ProdID AND PolicyId = @PolicyId
		IF NOT @Ded1 IS NULL SET @DedType = 1
		
		IF @Ded1 IS NULL
		BEGIN
			SELECT @Ded1 = CASE WHEN NOT DedIPInsuree IS NULL THEN DedIPInsuree WHEN NOT DedIPTreatment IS NULL THEN DedIPTreatment WHEN NOT DedIPPolicy IS NULL THEN DedIPPolicy ELSE NULL END FROM #tempDedRem WHERE ProdID = @ProdID AND PolicyId = @PolicyId
			SELECT @Ded2 = CASE WHEN NOT DedOPInsuree IS NULL THEN DedOPInsuree WHEN NOT DedOPTreatment IS NULL THEN DedOPTreatment WHEN NOT DedOPPolicy IS NULL THEN DedOPPolicy ELSE NULL END FROM #tempDedRem WHERE ProdID = @ProdID AND PolicyId = @PolicyId
			IF NOT @Ded1 IS NULL OR NOT @Ded2 IS NULL SET @DedType = 1.1
		END
		
		SELECT @Ceiling1 =  CASE WHEN NOT MaxInsuree IS NULL THEN MaxInsuree WHEN NOT MaxTreatment IS NULL THEN MaxTreatment WHEN NOT MaxPolicy IS NULL THEN MaxPolicy ELSE NULL END  FROM #tempDedRem WHERE ProdID = @ProdID AND PolicyId = @PolicyId
		IF NOT @Ceiling1 IS NULL SET @DedType = 1
		
		IF @Ceiling1 IS NULL
		BEGIN
			SELECT @Ceiling1 = CASE WHEN NOT MaxIPInsuree IS NULL THEN MaxIPInsuree WHEN NOT MaxIPTreatment IS NULL THEN MaxIPTreatment WHEN NOT MaxIPPolicy IS NULL THEN MaxIPPolicy ELSE NULL END FROM #tempDedRem WHERE ProdID = @ProdID AND PolicyId = @PolicyId
			SELECT @Ceiling2 = CASE WHEN NOT MaxOPInsuree IS NULL THEN MaxOPInsuree WHEN NOT MaxOPTreatment IS NULL THEN MaxOPTreatment WHEN NOT MaxOPPolicy IS NULL THEN MaxOPPolicy ELSE NULL END FROM #tempDedRem WHERE ProdID = @ProdID AND PolicyId = @PolicyId
			IF NOT @Ceiling1 IS NULL OR NOT @Ceiling2 IS NULL SET @DedType = 1.1
		END
		
			UPDATE #tempBase SET DedType = @DedType, Ded1 = @Ded1, Ded2 = CASE WHEN @DedType = 1 THEN @Ded1 ELSE @Ded2 END,Ceiling1 = @Ceiling1,Ceiling2 = CASE WHEN @DedType = 1 THEN @Ceiling1 ELSE @Ceiling2 END
		WHERE ProdID = @ProdID
		 AND PolicyId = @PolicyId
		
	FETCH NEXT FROM Cur INTO @ProdID, @PolicyId
	END

	CLOSE Cur
	DEALLOCATE Cur


IF (SELECT COUNT(*) FROM #tempBase WHERE [Status] = 'A') > 0
		SELECT CHFID, PhotoPath, InsureeName, DOB,Gender,ProductCode,ProductName,ExpiryDate,[Status],DedType,Ded1,Ded2,CASE WHEN Ceiling1<0 THEN 0 ELSE Ceiling1 END Ceiling1 ,CASE WHEN Ceiling2<0 THEN 0 ELSE Ceiling2 END Ceiling2  from #tempBase WHERE [Status] = 'A';
		
	ELSE 
		IF (SELECT COUNT(1) FROM #tempBase WHERE (YEAR(GETDATE()) - YEAR(CONVERT(DATETIME,ExpiryDate,103))) <= 2) > 1
			SELECT CHFID, PhotoPath, InsureeName, DOB,Gender,ProductCode,ProductName,ExpiryDate,[Status],DedType,Ded1,Ded2,CASE WHEN Ceiling1<0 THEN 0 ELSE Ceiling1 END Ceiling1,CASE WHEN Ceiling2<0 THEN 0 ELSE Ceiling2 END Ceiling2  from #tempBase WHERE (YEAR(GETDATE()) - YEAR(CONVERT(DATETIME,ExpiryDate,103))) <= 2;
		ELSE
			SELECT CHFID, PhotoPath, InsureeName, DOB,Gender,ProductCode,ProductName,ExpiryDate,[Status],DedType,Ded1,Ded2,CASE WHEN Ceiling1<0 THEN 0 ELSE Ceiling1 END Ceiling1,CASE WHEN Ceiling2<0 THEN 0 ELSE Ceiling2 END Ceiling2  from #tempBase 
END
GO

--ON 14/03/2017
IF  NOT OBJECT_ID('uspUploadEnrolments') IS NULL
DROP PROCEDURE uspUploadEnrolments
GO

CREATE PROCEDURE [dbo].[uspUploadEnrolments](
	@File NVARCHAR(300),
	@FamilySent INT = 0 OUTPUT,
	@InsureeSent INT = 0 OUTPUT,
	@PolicySent INT = 0 OUTPUT,
	@PremiumSent INT = 0 OUTPUT,
	@FamilyImported INT = 0 OUTPUT,
	@InsureeImported INT = 0 OUTPUT,
	@PolicyImported INT = 0 OUTPUT,
	@PremiumImported INT = 0 OUTPUT 
)
AS
BEGIN
	DECLARE @Query NVARCHAR(500)
	DECLARE @XML XML
	DECLARE @tblFamilies TABLE(FamilyId INT,InsureeId INT, CHFID nvarchar(12),  LocationId INT,Poverty NVARCHAR(1),FamilyType NVARCHAR(2),FamilyAddress NVARCHAR(200), Ethnicity NVARCHAR(1), ConfirmationNo NVARCHAR(12), NewFamilyId INT)
	DECLARE @tblInsuree TABLE(InsureeId INT,FamilyId INT,CHFID NVARCHAR(12),LastName NVARCHAR(100),OtherNames NVARCHAR(100),DOB DATE,Gender CHAR(1),Marital CHAR(1),IsHead BIT,Passport NVARCHAR(25),Phone NVARCHAR(50),CardIssued BIT,Relationship SMALLINT,Profession SMALLINT,Education SMALLINT,Email NVARCHAR(100), TypeOfId NVARCHAR(1), HFID INT,EffectiveDate DATE, NewFamilyId INT, NewInsureeId INT)
	DECLARE @tblPolicy TABLE(PolicyId INT,FamilyId INT,EnrollDate DATE,StartDate DATE,EffectiveDate DATE,ExpiryDate DATE,PolicyStatus TINYINT,PolicyValue DECIMAL(18,2),ProdId INT,OfficerId INT,PolicyStage CHAR(1), NewFamilyId INT, NewPolicyId INT)
	DECLARE @tblPremium TABLE(PremiumId INT,PolicyId INT,PayerId INT,Amount DECIMAL(18,2),Receipt NVARCHAR(50),PayDate DATE,PayType CHAR(1),isPhotoFee BIT, NewPolicyId INT)

	DECLARE @tblResult TABLE(Result NVARCHAR(Max))
	DECLARE @tblIds TABLE(OldId INT, [NewId] INT)


	BEGIN TRY

		SET @Query = (N'SELECT @XML = CAST(X as XML) FROM OPENROWSET(BULK  '''+ @File +''' ,SINGLE_BLOB) AS T(X)')

		EXECUTE SP_EXECUTESQL @Query,N'@XML XML OUTPUT',@XML OUTPUT


		--GET ALL THE FAMILY FROM THE XML
		INSERT INTO @tblFamilies(FamilyId,InsureeId,CHFID, LocationId,Poverty,FamilyType,FamilyAddress,Ethnicity, ConfirmationNo)
		SELECT 
		T.F.value('(FamilyId)[1]','INT'),
		T.F.value('(InsureeId)[1]','INT'),
		T.F.value('(CHFID)[1]','NVARCHAR(12)'),
		T.F.value('(LocationId)[1]','INT'),
		T.F.value('(Poverty)[1]','BIT'),
		T.F.value('(FamilyType)[1]','NVARCHAR(2)'),
		T.F.value('(FamilyAddress)[1]','NVARCHAR(200)'),
		T.F.value('(Ethnicity)[1]','NVARCHAR(1)'),
		T.F.value('(ConfirmationNo)[1]','NVARCHAR(12)')
		FROM @XML.nodes('Enrolment/Families/Family') AS T(F)
		
		--Get total number of families sent via XML
		SELECT @FamilySent = COUNT(*) FROM @tblFamilies

		--GET ALL THE INSUREES FROM XML
		INSERT INTO @tblInsuree(InsureeId,FamilyId,CHFID,LastName,OtherNames,DOB,Gender,Marital,IsHead,Passport,Phone,CardIssued,Relationship,Profession,Education,Email, TypeOfId, HFID,EffectiveDate)
		SELECT
		T.I.value('(InsureeID)[1]','INT'),
		T.I.value('(FamilyID)[1]','INT'),
		T.I.value('(CHFID)[1]','NVARCHAR(12)'),
		T.I.value('(LastName)[1]','NVARCHAR(100)'),
		T.I.value('(OtherNames)[1]','NVARCHAR(100)'),
		T.I.value('(DOB)[1]','DATE'),
		T.I.value('(Gender)[1]','CHAR(1)'),
		T.I.value('(Marital)[1]','CHAR(1)'),
		T.I.value('(IsHead)[1]','BIT'),
		T.I.value('(passport)[1]','NVARCHAR(25)'),
		T.I.value('(Phone)[1]','NVARCHAR(50)'),
		T.I.value('(CardIssued)[1]','BIT'),
		T.I.value('(Relationship)[1]','SMALLINT'),
		T.I.value('(Profession)[1]','SMALLINT'),
		T.I.value('(Education)[1]','SMALLINT'),
		T.I.value('(Email)[1]','NVARCHAR(100)'),
		T.I.value('(TypeOfId)[1]','NVARCHAR(1)'),
		T.I.value('(HFID)[1]','INT'),
		T.I.value('(EffectiveDate)[1]','DATE')  
		FROM @XML.nodes('Enrolment/Insurees/Insuree') AS T(I)

		--Get total number of Insurees sent via XML
		SELECT @InsureeSent = COUNT(*) FROM @tblInsuree

		--GET ALL THE POLICIES FROM XML
		INSERT INTO @tblPolicy(PolicyId,FamilyId,EnrollDate,StartDate,EffectiveDate,ExpiryDate,PolicyStatus,PolicyValue,ProdId,OfficerId,PolicyStage)
		SELECT 
		T.P.value('(PolicyID)[1]','INT'),
		T.P.value('(FamilyID)[1]','INT'),
		T.P.value('(EnrollDate)[1]','DATE'),
		T.P.value('(StartDate)[1]','DATE'),
		T.P.value('(EffectiveDate)[1]','DATE'),
		T.P.value('(ExpiryDate)[1]','DATE'),
		T.P.value('(PolicyStatus)[1]','TINYINT'),
		T.P.value('(PolicyValue)[1]','DECIMAL(18,2)'),
		T.P.value('(ProdID)[1]','INT'),
		T.P.value('(OfficerID)[1]','INT'),
		T.P.value('(PolicyStage)[1]','CHAR(1)')
		FROM @XML.nodes('Enrolment/Policies/Policy') AS T(P)

		--Get total number of Policies sent via XML
		SELECT @PolicySent = COUNT(*) FROM @tblPolicy
			
		--GET ALL THE PREMIUMS FROM XML
		INSERT INTO @tblPremium(PremiumId,PolicyId,PayerId,Amount,Receipt,PayDate,PayType,isPhotoFee)
		SELECT
		T.PR.value('(PremiumId)[1]','INT'),
		T.PR.value('(PolicyID)[1]','INT'),
		T.PR.value('(PayerID)[1]','INT'),
		T.PR.value('(Amount)[1]','DECIMAL(18,2)'),
		T.PR.value('(Receipt)[1]','NVARCHAR(50)'),
		T.PR.value('(PayDate)[1]','DATE'),
		T.PR.value('(PayType)[1]','CHAR(1)'),
		T.PR.value('(isPhotoFee)[1]','BIT')
		FROM @XML.nodes('Enrolment/Premiums/Premium') AS T(PR)

		--Get total number of premium sent via XML
		SELECT @PremiumSent = COUNT(*) FROM @tblPremium;

		IF EXISTS(
		--Insuree without family
		SELECT 1 
		FROM @tblInsuree I LEFT OUTER JOIN @tblFamilies F ON I.FamilyId = F.FamilyID
		WHERE F.FamilyID IS NULL

		UNION ALL

		--Policy without family
		SELECT 1 FROM
		@tblPolicy PL LEFT OUTER JOIN @tblFamilies F ON PL.FamilyId = F.FamilyId
		WHERE F.FamilyId IS NULL

		UNION ALL

		--Premium without policy
		SELECT 1
		FROM @tblPremium PR LEFT OUTER JOIN @tblPolicy P ON PR.PolicyId = P.PolicyId
		WHERE P.PolicyId  IS NULL
		)
		BEGIN
			INSERT INTO @tblResult VALUES
			(N'<h1 style="color:red;">Wrong format of the extract found. <br />Please contact your IT manager for further assistant.</h1>')
		
			RAISERROR (N'<h1 style="color:red;">Wrong format of the extract found. <br />Please contact your IT manager for further assistant.</h1>', 16, 1);
		END


		BEGIN TRAN ENROLL;

			DELETE F
			OUTPUT N'Insuree information is missing for Family with Insurance Number ' + QUOTENAME(deleted.CHFID) INTO @tblResult
			FROM @tblFamilies F
			LEFT OUTER JOIN @tblInsuree I ON F.CHFID = I.CHFID
			WHERE I.InsureeId IS NULL;

			INSERT INTO @tblResult(Result)
			SELECT N'Family with Insurance Number : ' + QUOTENAME(I.CHFID) + ' already exists' 
			FROM @tblFamilies TF 
			INNER JOIN tblInsuree I ON TF.CHFID = I.CHFID
			WHERE I.ValidityTo IS NULL
			AND I.IsHead = 1;

			--Get the new FamilyId frmo DB and udpate @tblFamilies, @tblInsuree and @tblPolicy
			UPDATE TF SET NewFamilyId = I.FamilyID
			FROM @tblFamilies TF 
			INNER JOIN tblInsuree I ON TF.CHFID = I.CHFID
			WHERE I.ValidityTo IS NULL
			AND I.IsHead = 1;

		
			UPDATE TI SET NewFamilyId = TF.NewFamilyId
			FROM @tblFamilies TF 
			INNER JOIN @tblInsuree TI ON TF.FamilyId = TI.FamilyId;

			UPDATE TP SET TP.NewFamilyId = TF.NewFamilyId
			FROM @tblFamilies TF
			INNER JOIN @tblPolicy TP ON TF.FamilyId = TP.FamilyId;

			--Delete existing families from temp table, we don't need them anymore
			DELETE FROM @tblFamilies WHERE NewFamilyId IS NOT NULL;


			--Insert new Families
			MERGE INTO tblFamilies 
			USING @tblFamilies AS TF ON 1 = 0 
			WHEN NOT MATCHED THEN 
				INSERT (InsureeId, LocationId, Poverty, ValidityFrom, AuditUserId, FamilyType, FamilyAddress, Ethnicity, ConfirmationNo) 
				VALUES(0 , TF.LocationId, TF.Poverty, GETDATE() , -1 , TF.FamilyType, TF.FamilyAddress, TF.Ethnicity, TF.ConfirmationNo)
				OUTPUT TF.FamilyId, inserted.FamilyId INTO @tblIds;
		

			SELECT @FamilyImported = @@ROWCOUNT;

			--Update Family, Insuree and Policy with newly inserted FamilyId
			UPDATE TF SET NewFamilyId = ID.[NewId]
			FROM @tblFamilies TF
			INNER JOIN @tblIds ID ON TF.FamilyId = ID.OldId;

			UPDATE TI SET NewFamilyId = ID.[NewId]
			FROM @tblInsuree TI
			INNER JOIN @tblIds ID ON TI.FamilyId = ID.OldId;

			UPDATE TP SET NewFamilyId = ID.[NewId]
			FROM @tblPolicy TP
			INNER JOIN @tblIds ID ON TP.FamilyId = ID.OldId;

			--Clear the Ids table
			DELETE FROM @tblIds;

			--Delete duplicate insurees from table
			DELETE TI
			OUTPUT 'Insurance Number ' + QUOTENAME(deleted.CHFID) + ' already exists' INTO @tblResult
			FROM @tblInsuree TI 
			INNER JOIN tblInsuree I ON TI.CHFID = I.CHFID
			WHERE I.ValidityTo IS NULL;

			--Insert new insurees 
			MERGE tblInsuree
			USING @tblInsuree TI ON 1 = 0
			WHEN NOT MATCHED THEN
				INSERT(FamilyID,CHFID,LastName,OtherNames,DOB,Gender,Marital,IsHead,passport,Phone,CardIssued,ValidityFrom,AuditUserID,Relationship,Profession,Education,Email,TypeOfId, HFID)
				VALUES(TI.NewFamilyId, TI.CHFID, TI.LastName, TI.OtherNames, TI.DOB, TI.Gender, TI.Marital, TI.IsHead, TI.Passport, TI.Phone, TI.CardIssued, GETDATE(), -1, TI.Relationship, TI.Profession, TI.Education, TI.Email, TI.TypeOfId, TI.HFID)
				OUTPUT TI.InsureeId, inserted.InsureeId INTO @tblIds;


			SELECT @InsureeImported = @@ROWCOUNT;

			--Update Ids of newly inserted insurees 
			UPDATE TI SET NewInsureeId = Id.[NewId]
			FROM @tblInsuree TI 
			INNER JOIN @tblIds Id ON TI.InsureeId = Id.OldId;

			--Insert Photos
			INSERT INTO tblPhotos(InsureeID,CHFID,PhotoFolder,PhotoFileName,OfficerID,PhotoDate,ValidityFrom,AuditUserID)
			SELECT NewInsureeId,CHFID,'','',0,GETDATE(),GETDATE() ValidityFrom, -1 AuditUserID 
			FROM @tblInsuree TI; 
		
			--Update tblInsuree with newly inserted PhotoId
			UPDATE I SET PhotoId = PH.PhotoId
			FROM @tblInsuree TI
			INNER JOIN tblPhotos PH ON TI.NewInsureeId = PH.InsureeID
			INNER JOIN tblInsuree I ON TI.NewInsureeId = I.InsureeID;


			--Update new InsureeId in tblFamilies
			UPDATE F SET InsureeId = TI.NewInsureeId
			FROM @tblInsuree TI 
			INNER JOIN tblInsuree I ON TI.NewInsureeId = I.InsureeId
			INNER JOIN tblFamilies F ON TI.NewFamilyId = F.FamilyID
			WHERE TI.IsHead = 1;

			--Clear the Ids table
			DELETE FROM @tblIds;

			INSERT INTO @tblIds
			SELECT TP.PolicyId, PL.PolicyID
			FROM tblPolicy PL 
			INNER JOIN @tblPolicy TP ON PL.FamilyID = TP.NewFamilyId 
									AND PL.EnrollDate = TP.EnrollDate 
									AND PL.StartDate = TP.StartDate 
									AND PL.ProdID = TP.ProdId 
			INNER JOIN tblProduct Prod ON PL.ProdId = Prod.ProdId
			INNER JOIN tblInsuree I ON PL.FamilyId = I.FamilyId
			WHERE PL.ValidityTo IS NULL
			AND I.IsHead = 1;

		
			--Delete duplicate policies
			DELETE TP
			OUTPUT 'Policy for the family : ' + QUOTENAME(I.CHFID) + ' with Product Code:' + QUOTENAME(Prod.ProductCode) + ' already exists' INTO @tblResult
			FROM tblPolicy PL 
			INNER JOIN @tblPolicy TP ON PL.FamilyID = TP.NewFamilyId 
									AND PL.EnrollDate = TP.EnrollDate 
									AND PL.StartDate = TP.StartDate 
									AND PL.ProdID = TP.ProdId 
			INNER JOIN tblProduct Prod ON PL.ProdId = Prod.ProdId
			INNER JOIN tblInsuree I ON PL.FamilyId = I.FamilyId
			WHERE PL.ValidityTo IS NULL
			AND I.IsHead = 1;

			--Update Premium table 
			UPDATE TPR SET NewPolicyId = Id.[NewId]
			FROM @tblPremium TPR 
			INNER JOIN @tblIds Id ON TPR.PolicyId = Id.OldId;
		
	
			--Clear the Ids table
			DELETE FROM @tblIds;

			--Insert new policies
			MERGE tblPolicy
			USING @tblPolicy TP ON 1 = 0
			WHEN NOT MATCHED THEN
				INSERT(FamilyID,EnrollDate,StartDate,EffectiveDate,ExpiryDate,PolicyStatus,PolicyValue,ProdID,OfficerID,PolicyStage,ValidityFrom,AuditUserID)
				VALUES(TP.NewFamilyID,EnrollDate,StartDate,EffectiveDate,ExpiryDate,PolicyStatus,PolicyValue,ProdID,OfficerID,PolicyStage,GETDATE(),-1)
			OUTPUT TP.PolicyId, inserted.PolicyId INTO @tblIds;
		
			SELECT @PolicyImported = @@ROWCOUNT;


			--Update new PolicyId
			UPDATE TP SET NewPolicyId = Id.[NewId]
			FROM @tblPolicy TP
			INNER JOIN @tblIds Id ON TP.PolicyId = Id.OldId;

			UPDATE TPR SET NewPolicyId = TP.NewPolicyId
			FROM @tblPremium TPR
			INNER JOIN @tblPolicy TP ON TPR.PolicyId = TP.PolicyId;
		
	

			--Delete duplicate Premiums
			DELETE TPR
			OUTPUT 'Premium on receipt number ' + QUOTENAME(PR.Receipt) + ' already exists.' INTO @tblResult
			--OUTPUT deleted.*
			FROM tblPremium PR
			INNER JOIN @tblPremium TPR ON PR.Amount = TPR.Amount 
										AND PR.Receipt = TPR.Receipt 
										AND PR.PolicyID = TPR.NewPolicyId
			WHERE PR.ValidityTo IS NULL
		
			--Insert Premium
			INSERT INTO tblPremium(PolicyID,PayerID,Amount,Receipt,PayDate,PayType,ValidityFrom,AuditUserID,isPhotoFee)
			SELECT NewPolicyId,PayerID,Amount,Receipt,PayDate,PayType,GETDATE(),-1,isPhotoFee 
			FROM @tblPremium
		
			SELECT @PremiumImported = @@ROWCOUNT;


			--TODO: Insert the InsureePolicy Table 
			--Create a cursor and loop through each new insuree 
	
			DECLARE @InsureeId INT
			DECLARE CurIns CURSOR FOR SELECT NewInsureeId FROM @tblInsuree;
			OPEN CurIns;
			FETCH NEXT FROM CurIns INTO @InsureeId;
			WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC uspAddInsureePolicy @InsureeId;
				FETCH NEXT FROM CurIns INTO @InsureeId;
			END
			CLOSE CurIns;
			DEALLOCATE CurIns; 
	
	IF EXISTS(SELECT COUNT(1) 
			FROM tblInsuree 
			WHERE ValidityTo IS NULL
			AND IsHead = 1
			GROUP BY FamilyID
			HAVING COUNT(1) > 1)
			
			--Added by Amani
			BEGIN
					DELETE FROM @tblResult;
					SET @FamilyImported = 0;
					SET @InsureeImported  = 0;
					SET @PolicyImported  = 0;
					SET @PremiumImported  = 0 
					INSERT INTO @tblResult VALUES
						(N'<h1 style="color:red;">Double HOF Found. <br />Please contact your IT manager for further assistant.</h1>')
						--GOTO EndOfTheProcess;
						RAISERROR(N'Double HOF Found',16,1)	
					END


		COMMIT TRAN ENROLL;

	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE();
		IF @@TRANCOUNT > 0 ROLLBACK TRAN ENROLL;
	END CATCH

	SELECT Result FROM @tblResult;
	RETURN 0;
END
GO


IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE Name = 'IX_tblInsuree-IsHead_VT-Fid-CHF')
BEGIN
	CREATE NONCLUSTERED INDEX [IX_tblInsuree-IsHead_VT-Fid-CHF] 
	ON [dbo].[tblInsuree]([IsHead], [ValidityTo])
	INCLUDE ([FamilyID], [CHFID]) 
END
GO

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE Name = 'IX_tblInsuree_VT-CHFID')
BEGIN
	CREATE NONCLUSTERED INDEX [IX_tblInsuree_VT-CHFID]
	ON [dbo].[tblInsuree] ([ValidityTo])
	INCLUDE ([CHFID])
END
GO

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE Name = 'IX_tblInsuree_CHFID_VT')
BEGIN
	CREATE NONCLUSTERED INDEX [IX_tblInsuree_CHFID_VT]
	ON [dbo].[tblInsuree] ([CHFID],[ValidityTo])
END
GO

--ON 20/03/2018

IF NOT OBJECT_ID('uspSSRSCapitationPayment') IS NULL
DROP PROCEDURE uspSSRSCapitationPayment
GO
CREATE PROCEDURE [dbo].[uspSSRSCapitationPayment]

(
	@RegionId INT = NULL,
	@DistrictId INT = NULL,
	@ProdId INT,
	@Year INT,
	@Month INT,
	@HFLevel xAttributeV READONLY
)
AS
BEGIN
	
	DECLARE @Level1 CHAR(1) = NULL,
			@Sublevel1 CHAR(1) = NULL,
			@Level2 CHAR(1) = NULL,
			@Sublevel2 CHAR(1) = NULL,
			@Level3 CHAR(1) = NULL,
			@Sublevel3 CHAR(1) = NULL,
			@Level4 CHAR(1) = NULL,
			@Sublevel4 CHAR(1) = NULL,
			@ShareContribution DECIMAL(5, 2),
			@WeightPopulation DECIMAL(5, 2),
			@WeightNumberFamilies DECIMAL(5, 2),
			@WeightInsuredPopulation DECIMAL(5, 2),
			@WeightNumberInsuredFamilies DECIMAL(5, 2),
			@WeightNumberVisits DECIMAL(5, 2),
			@WeightAdjustedAmount DECIMAL(5, 2)

	DECLARE @FirstDay DATE = CAST(@Year AS VARCHAR(4)) + '-' + CAST(@Month AS VARCHAR(2)) + '-01'; 
	DECLARE @LastDay DATE = EOMONTH(CAST(@Year AS VARCHAR(4)) + '-' + CAST(@Month AS VARCHAR(2)) + '-01', 0)
	DECLARE @DaysInMonth INT = DATEDIFF(DAY,@FirstDay,DATEADD(MONTH,1,@FirstDay));

	SELECT @Level1 = Level1, @Sublevel1 = Sublevel1, @Level2 = Level2, @Sublevel2 = Sublevel2, @Level3 = Level3, @Sublevel3 = Sublevel3, 
	@Level4 = Level4, @Sublevel4 = Sublevel4, @ShareContribution = ISNULL(ShareContribution, 0), @WeightPopulation = ISNULL(WeightPopulation, 0), 
	@WeightNumberFamilies = ISNULL(WeightNumberFamilies, 0), @WeightInsuredPopulation = ISNULL(WeightInsuredPopulation, 0), @WeightNumberInsuredFamilies = ISNULL(WeightNumberInsuredFamilies, 0), 
	@WeightNumberVisits = ISNULL(WeightNumberVisits, 0), @WeightAdjustedAmount = ISNULL(WeightAdjustedAmount, 0)
	FROM tblProduct Prod 
	WHERE ProdId = @ProdId;


	PRINT @ShareContribution
	PRINT @WeightPopulation
	PRINT @WeightNumberFamilies 
	PRINT @WeightInsuredPopulation 
	PRINT @WeightNumberInsuredFamilies 
	PRINT @WeightNumberVisits 
	PRINT @WeightAdjustedAmount


	;WITH TotalPopFam AS
	(
	SELECT C.HFID , SUM((ISNULL(L.MalePopulation, 0) + ISNULL(L.FemalePopulation, 0) + ISNULL(L.OtherPopulation, 0)) *(0.01* Catchment))[Population], SUM(ISNULL(((L.Families)*(0.01* Catchment)), 0))TotalFamilies
		FROM tblHFCatchment C
		INNER JOIN tblLocations L ON L.LocationId = C.LocationId
		WHERE C.ValidityTo IS NULL
		AND L.ValidityTo IS NULL
		GROUP BY C.HFID--, L.LocationId, Catchment
	), InsuredInsuree AS
	(
		SELECT HC.HFID, COUNT(DISTINCT IP.InsureeId)*(0.01 * Catchment) TotalInsuredInsuree
		FROM tblInsureePolicy IP
		INNER JOIN tblInsuree I ON I.InsureeId = IP.InsureeId
		INNER JOIN tblFamilies F ON F.FamilyId = I.FamilyId
		INNER JOIN tblHFCatchment HC ON HC.LocationId = F.LocationId
		INNER JOIN uvwLocations L ON L.LocationId = HC.LocationId
		INNER JOIN tblPolicy PL ON PL.PolicyID = IP.PolicyId
		WHERE HC.ValidityTo IS NULL 
		AND I.ValidityTo IS NULL
		AND IP.ValidityTo IS NULL
		AND F.ValidityTo IS NULL
		AND PL.ValidityTo IS NULL
		AND IP.EffectiveDate <= @LastDay 
		AND IP.ExpiryDate > @LastDay
		AND PL.ProdID = @ProdId
		GROUP BY HC.HFID, L.LocationId, Catchment
	), InsuredFamilies AS
	(
		SELECT HC.HFID, COUNT(DISTINCT F.FamilyID)*(0.01 * Catchment) TotalInsuredFamilies
		FROM tblInsureePolicy IP
		INNER JOIN tblInsuree I ON I.InsureeId = IP.InsureeId
		INNER JOIN tblFamilies F ON F.InsureeID = I.InsureeID
		INNER JOIN tblHFCatchment HC ON HC.LocationId = F.LocationId
		INNER JOIN uvwLocations L ON L.LocationId = HC.LocationId
		INNER JOIN tblPolicy PL ON PL.PolicyID = IP.PolicyId
		WHERE HC.ValidityTo IS NULL 
		AND I.ValidityTo IS NULL
		AND IP.ValidityTo IS NULL
		AND F.ValidityTo IS NULL
		AND PL.ValidityTo IS NULL
		AND IP.EffectiveDate <= @LastDay 
		AND IP.ExpiryDate > @LastDay
		AND PL.ProdID = @ProdId
		GROUP BY HC.HFID, L.LocationId, Catchment
	), Claims AS
	(
		SELECT C.HFID,  COUNT(C.ClaimId)TotalClaims
		FROM tblClaim C
		INNER JOIN (
			SELECT ClaimId FROM tblClaimItems WHERE ProdId = @ProdId AND ValidityTo IS NULL
			UNION
			SELECT ClaimId FROM tblClaimServices WHERE ProdId = @ProdId AND ValidityTo IS NULL
			) CProd ON CProd.ClaimID = C.ClaimID
		WHERE C.ValidityTo IS NULL
		AND C.ClaimStatus >= 8
		AND YEAR(C.DateProcessed) = @Year
		AND MONTH(C.DateProcessed) = @Month
		GROUP BY C.HFID
	), ClaimValues AS
	(
		SELECT HFID, SUM(PriceValuated)TotalAdjusted
		FROM(
		SELECT C.HFID, CValue.PriceValuated
		FROM tblClaim C
		INNER JOIN (
			SELECT ClaimId, PriceValuated FROM tblClaimItems WHERE ValidityTo IS NULL AND ProdId = @ProdId
			UNION ALL
			SELECT ClaimId, PriceValuated FROM tblClaimServices WHERE ValidityTo IS NULL AND ProdId = @ProdId
			) CValue ON CValue.ClaimID = C.ClaimID
		WHERE C.ValidityTo IS NULL
		AND C.ClaimStatus >= 8
		AND YEAR(C.DateProcessed) = @Year
		AND MONTH(C.DateProcessed) = @Month
		)CValue
		GROUP BY HFID
	),Locations AS
	(
		SELECT 0 LocationId, N'National' LocationName, NULL ParentLocationId
		UNION
		SELECT LocationId,LocationName, ISNULL(ParentLocationId, 0) FROM tblLocations WHERE ValidityTo IS NULL AND LocationId = ISNULL(@DistrictId, @RegionId)
		UNION ALL
		SELECT L.LocationId, L.LocationName, L.ParentLocationId 
		FROM tblLocations L 
		INNER JOIN Locations ON Locations.LocationId = L.ParentLocationId
		WHERE L.validityTo IS NULL
		AND L.LocationType IN ('R', 'D')
	), Allocation AS
	(
		SELECT ProdId, CAST(SUM(ISNULL(Allocated, 0)) AS DECIMAL(18, 6))Allocated
		FROM
		(SELECT PL.ProdID,
		CASE 
		WHEN MONTH(DATEADD(D,-1,PL.ExpiryDate)) = @Month AND YEAR(DATEADD(D,-1,PL.ExpiryDate)) = @Year AND (DAY(PL.ExpiryDate)) > 1
			THEN CASE WHEN DATEDIFF(D,CASE WHEN PR.PayDate < @FirstDay THEN @FirstDay ELSE PR.PayDate END,PL.ExpiryDate) = 0 THEN 1 ELSE DATEDIFF(D,CASE WHEN PR.PayDate < @FirstDay THEN @FirstDay ELSE PR.PayDate END,PL.ExpiryDate) END  * ((SUM(PR.Amount))/(CASE WHEN (DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate)) <= 0 THEN 1 ELSE DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate) END))
		WHEN MONTH(CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END) = @Month AND YEAR(CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END) = @Year
			THEN ((@DaysInMonth + 1 - DAY(CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END)) * ((SUM(PR.Amount))/CASE WHEN DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate) <= 0 THEN 1 ELSE DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate) END)) 
		WHEN PL.EffectiveDate < @FirstDay AND PL.ExpiryDate > @LastDay AND PR.PayDate < @FirstDay
			THEN @DaysInMonth * (SUM(PR.Amount)/CASE WHEN (DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,DATEADD(D,-1,PL.ExpiryDate))) <= 0 THEN 1 ELSE DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate) END)
		END Allocated
		FROM tblPremium PR 
		INNER JOIN tblPolicy PL ON PR.PolicyID = PL.PolicyID
		INNER JOIN tblProduct Prod ON Prod.ProdId = PL.ProdID
		INNER JOIN Locations L ON ISNULL(Prod.LocationId, 0) = L.LocationId
		WHERE PR.ValidityTo IS NULL
		AND PL.ValidityTo IS NULL
		AND PL.ProdID = @ProdId
		AND PL.PolicyStatus <> 1
		AND PR.PayDate <= PL.ExpiryDate
		GROUP BY PL.ProdID, PL.ExpiryDate, PR.PayDate,PL.EffectiveDate)Alc
		GROUP BY ProdId
	) ,ReportData AS
	(
		SELECT L.RegionCode, L.RegionName, L.DistrictCode, L.DistrictName, HF.HFCode, HF.HFName, Hf.AccCode, HL.Name HFLevel, SL.HFSublevelDesc HFSublevel,
		PF.[Population] [Population], PF.TotalFamilies TotalFamilies, II.TotalInsuredInsuree, IFam.TotalInsuredFamilies, C.TotalClaims, CV.TotalAdjusted
		,(
			  ISNULL(ISNULL(PF.[Population], 0) * (Allocation.Allocated * (0.01 * @ShareContribution) * (0.01 * @WeightPopulation)) /  NULLIF(SUM(PF.[Population])OVER(),0),0)  
			+ ISNULL(ISNULL(PF.TotalFamilies, 0) * (Allocation.Allocated * (0.01 * @ShareContribution) * (0.01 * @WeightNumberFamilies)) /NULLIF(SUM(PF.[TotalFamilies])OVER(),0),0) 
			+ ISNULL(ISNULL(II.TotalInsuredInsuree, 0) * (Allocation.Allocated * (0.01 * @ShareContribution) * (0.01 * @WeightInsuredPopulation)) /NULLIF(SUM(II.TotalInsuredInsuree)OVER(),0),0) 
			+ ISNULL(ISNULL(IFam.TotalInsuredFamilies, 0) * (Allocation.Allocated * (0.01 * @ShareContribution) * (0.01 * @WeightNumberInsuredFamilies)) /NULLIF(SUM(IFam.TotalInsuredFamilies)OVER(),0),0) 
			+ ISNULL(ISNULL(C.TotalClaims, 0) * (Allocation.Allocated * (0.01 * @ShareContribution) * (0.01 * @WeightNumberVisits)) /NULLIF(SUM(C.TotalClaims)OVER() ,0),0) 
			+ ISNULL(ISNULL(CV.TotalAdjusted, 0) * (Allocation.Allocated * (0.01 * @ShareContribution) * (0.01 * @WeightAdjustedAmount)) /NULLIF(SUM(CV.TotalAdjusted)OVER(),0),0)

		) PaymentCathment

		, Allocation.Allocated * (0.01 * @WeightPopulation) * (0.01 * @ShareContribution) AlcContriPopulation
		, Allocation.Allocated * (0.01 * @WeightNumberFamilies) * (0.01 * @ShareContribution) AlcContriNumFamilies
		, Allocation.Allocated * (0.01 * @WeightInsuredPopulation) * (0.01 * @ShareContribution) AlcContriInsPopulation
		, Allocation.Allocated * (0.01 * @WeightNumberInsuredFamilies) * (0.01 * @ShareContribution) AlcContriInsFamilies
		, Allocation.Allocated * (0.01 * @WeightNumberVisits) * (0.01 * @ShareContribution) AlcContriVisits
		, Allocation.Allocated * (0.01 * @WeightAdjustedAmount) * (0.01 * @ShareContribution) AlcContriAdjustedAmount

		,  ISNULL((Allocation.Allocated * (0.01 * @WeightPopulation) * (0.01 * @ShareContribution))/ NULLIF(SUM(PF.[Population]) OVER(),0),0) UPPopulation
		,  ISNULL((Allocation.Allocated * (0.01 * @WeightNumberFamilies) * (0.01 * @ShareContribution))/NULLIF(SUM(PF.TotalFamilies) OVER(),0),0) UPNumFamilies
		,  ISNULL((Allocation.Allocated * (0.01 * @WeightInsuredPopulation) * (0.01 * @ShareContribution))/NULLIF(SUM(II.TotalInsuredInsuree) OVER(),0),0) UPInsPopulation
		,  ISNULL((Allocation.Allocated * (0.01 * @WeightNumberInsuredFamilies) * (0.01 * @ShareContribution))/ NULLIF(SUM(IFam.TotalInsuredFamilies) OVER(),0),0) UPInsFamilies
		,  ISNULL((Allocation.Allocated * (0.01 * @WeightNumberVisits) * (0.01 * @ShareContribution)) / NULLIF(SUM(C.TotalClaims) OVER(),0),0) UPVisits
		,  ISNULL((Allocation.Allocated * (0.01 * @WeightAdjustedAmount) * (0.01 * @ShareContribution))/ NULLIF(SUM(CV.TotalAdjusted) OVER(),0),0) UPAdjustedAmount




		FROM tblHF HF
		INNER JOIN @HFLevel HL ON HL.Code = HF.HFLevel
		LEFT OUTER JOIN tblHFSublevel SL ON SL.HFSublevel = HF.HFSublevel
		INNER JOIN uvwLocations L ON L.LocationId = HF.LocationId
		LEFT OUTER JOIN TotalPopFam PF ON PF.HFID = HF.HfID
		LEFT OUTER JOIN InsuredInsuree II ON II.HFID = HF.HfID
		LEFT OUTER JOIN InsuredFamilies IFam ON IFam.HFID = HF.HfID
		LEFT OUTER JOIN Claims C ON C.HFID = HF.HfID
		LEFT OUTER JOIN ClaimValues CV ON CV.HFID = HF.HfID
		INNER JOIN Allocation ON Allocation.ProdID = @ProdId

		WHERE HF.ValidityTo IS NULL
		AND (L.RegionId = @RegionId OR @RegionId IS NULL)
		AND (L.DistrictId = @DistrictId OR @DistrictId IS NULL)
		AND (HF.HFLevel IN (@Level1, @Level2, @Level3, @Level4) OR (@Level1 IS NULL AND @Level2 IS NULL AND @Level3 IS NULL AND @Level4 IS NULL))
		AND(
			((HF.HFLevel = @Level1 OR @Level1 IS NULL) AND (HF.HFSublevel = @Sublevel1 OR @Sublevel1 IS NULL))
			OR ((HF.HFLevel = @Level2 ) AND (HF.HFSublevel = @Sublevel2 OR @Sublevel2 IS NULL))
			OR ((HF.HFLevel = @Level3) AND (HF.HFSublevel = @Sublevel3 OR @Sublevel3 IS NULL))
			OR ((HF.HFLevel = @Level4) AND (HF.HFSublevel = @Sublevel4 OR @Sublevel4 IS NULL))
		  )

	)



	SELECT  MAX (RegionCode)RegionCode, 
		MAX(RegionName)RegionName,
		MAX(DistrictCode)DistrictCode,
		MAX(DistrictName)DistrictName,
		HFCode, 
		MAX(HFName)HFName,
		MAX(AccCode)AccCode, 
		MAX(HFLevel)HFLevel, 
		MAX(HFSublevel)HFSublevel,
		ISNULL(SUM([Population]),0)[Population],
		ISNULL(SUM(TotalFamilies),0)TotalFamilies,
		ISNULL(SUM(TotalInsuredInsuree),0)TotalInsuredInsuree,
		ISNULL(SUM(TotalInsuredFamilies),0)TotalInsuredFamilies,
		ISNULL(SUM(TotalClaims),0)TotalClaims,
		ISNULL(SUM(AlcContriPopulation),0)AlcContriPopulation,
		ISNULL(SUM(AlcContriNumFamilies),0)AlcContriNumFamilies,
		ISNULL(SUM(AlcContriInsPopulation),0)AlcContriInsPopulation,
		ISNULL(SUM(AlcContriInsFamilies),0)AlcContriInsFamilies,
		ISNULL(SUM(AlcContriVisits),0)AlcContriVisits,
		ISNULL(SUM(AlcContriAdjustedAmount),0)AlcContriAdjustedAmount,
		ISNULL(SUM(UPPopulation),0)UPPopulation,
		ISNULL(SUM(UPNumFamilies),0)UPNumFamilies,
		ISNULL(SUM(UPInsPopulation),0)UPInsPopulation,
		ISNULL(SUM(UPInsFamilies),0)UPInsFamilies,
		ISNULL(SUM(UPVisits),0)UPVisits,
		ISNULL(SUM(UPAdjustedAmount),0)UPAdjustedAmount,
		ISNULL(SUM(PaymentCathment),0)PaymentCathment,
		ISNULL(SUM(TotalAdjusted),0)TotalAdjusted
	
	 FROM ReportData

	 GROUP BY HFCode

	  

END
GO

--ON 21/03/2018

IF NOT OBJECT_ID('uspImportLocations') IS NULL
DROP PROC uspImportLocations
GO
CREATE PROCEDURE [dbo].[uspImportLocations]
(

	@RegionsFile NVARCHAR(255),
	@DistrictsFile NVARCHAR(255),
	@WardsFile NVARCHAR(255),
	@VillagesFile NVARCHAR(255)
)
AS
BEGIN
BEGIN TRY
	--CREATE TEMP TABLE FOR REGION
	IF OBJECT_ID('tempdb..#tempRegion') IS NOT NULL DROP TABLE #tempRegion
	CREATE TABLE #tempRegion(RegionCode NVARCHAR(50), RegionName NVARCHAR(50))

	--CREATE TEMP TABLE FOR DISTRICTS
	IF OBJECT_ID('tempdb..#tempDistricts') IS NOT NULL DROP TABLE #tempDistricts
	CREATE TABLE #tempDistricts(RegionCode NVARCHAR(50),DistrictCode NVARCHAR(50),DistrictName NVARCHAR(50))

	--CREATE TEMP TABLE FOR WARDS
	IF OBJECT_ID('tempdb..#tempWards') IS NOT NULL DROP TABLE #tempWards
	CREATE TABLE #tempWards(DistrictCode NVARCHAR(50),WardCode NVARCHAR(50),WardName NVARCHAR(50))

	--CREATE TEMP TABLE FOR VILLAGES
	IF OBJECT_ID('tempdb..#tempVillages') IS NOT NULL DROP TABLE #tempVillages
	CREATE TABLE #tempVillages(WardCode NVARCHAR(50),VillageCode NVARCHAR(50), VillageName NVARCHAR(50),MalePopulation INT,FemalePopulation INT, OtherPopulation INT, Families INT)



	--INSERT REGION IN TEMP TABLE
	DECLARE @InsertRegion NVARCHAR(2000)
	SET @InsertRegion = N'BULK INSERT #tempRegion FROM ''' + @RegionsFile + '''' +
		'WITH (
		FIELDTERMINATOR = ''	'',
		FIRSTROW = 2
		)'
	EXEC SP_EXECUTESQL @InsertRegion


	--INSERT DISTRICTS IN TEMP TABLE
	DECLARE @InsertDistricts NVARCHAR(2000)
	SET @InsertDistricts = N'BULK INSERT #tempDistricts FROM ''' + @DistrictsFile + '''' +
		'WITH (
		FIELDTERMINATOR = ''	'',
		FIRSTROW = 2
		)'
	EXEC SP_EXECUTESQL @InsertDistricts

	--INSERT WARDS IN TEMP TABLE
	DECLARE @InsertWards NVARCHAR(2000)
	SET @InsertWards = N'BULK INSERT #tempWards FROM ''' + @WardsFile + '''' +
		'WITH (
		FIELDTERMINATOR = ''	'',
		FIRSTROW = 2
		)'
	EXEC SP_EXECUTESQL @InsertWards


	
	--INSERT VILLAGES IN TEMP TABLE
	DECLARE @InsertVillages NVARCHAR(2000)
	SET @InsertVillages = N'BULK INSERT #tempVillages FROM ''' + @VillagesFile + '''' +
		'WITH (
		FIELDTERMINATOR = ''	'',
		FIRSTROW = 2
		)'
	EXEC SP_EXECUTESQL @InsertVillages
    

	--check if the location is null or empty space
	IF EXISTS(
	SELECT 1 FROM #tempRegion WHERE RegionCode IS NULL OR RegionName IS NULL
	UNION
	SELECT 1FROM #tempDistricts WHERE (RegionCode IS NULL OR LEN(RegionCode)=0) OR (DistrictCode IS NULL OR LEN(DistrictCode)=0) OR (DistrictName IS NULL OR LEN(DistrictName)=0)
	UNION
	SELECT 1 FROM #tempWards WHERE (DistrictCode IS NULL OR LEN(DistrictCode)=0) OR (WardCode IS NULL OR LEN(WardCode)=0) OR (WardName IS NULL OR LEN(WardName)=0)
	UNION
	SELECT 1 FROM #tempVillages WHERE (WardCode IS NULL OR LEN(WardCode)=0) OR (VillageCode IS NULL OR LEN(VillageCode)=0) OR (VillageName IS NULL OR  LEN(VillageName)=0)
	)
	RAISERROR ('LocationCode Or LocationName is Missing in excel', 16, 1)



	--check if the population is numeric
	IF EXISTS(
		SELECT * FROM #tempVillages WHERE   (ISNUMERIC(MalePopulation)=0 AND LEN(MalePopulation)>0) OR  (ISNUMERIC(FemalePopulation)=0  AND LEN(FemalePopulation)>0) OR  (ISNUMERIC(OtherPopulation)=0 AND LEN(OtherPopulation)>0) OR  (ISNUMERIC(Families)=0 AND LEN(Families)>0)
	)
	RAISERROR ('Village population must be numeric in excel', 16, 1)



	DECLARE @AllCodes AS TABLE(LocationCode NVARCHAR(8))
	;WITH AllCodes AS
	(
		SELECT RegionCode LocationCode FROM #tempRegion
		UNION ALL
		SELECT DistrictCode FROM #tempDistricts
		UNION ALL
		SELECT WardCode FROM #tempWards
		UNION ALL
		SELECT VillageCode FROM #tempVillages
	)
	INSERT INTO @AllCodes(LocationCode)
	SELECT LocationCode
	FROM AllCodes

	IF EXISTS(SELECT LocationCode FROM @AllCodes GROUP BY LocationCode HAVING COUNT(1) > 1)
		BEGIN
			SELECT LocationCode FROM @AllCodes GROUP BY LocationCode HAVING COUNT(1) > 1;
			RAISERROR ('Duplicate in excel', 16, 1)
		END

	;WITH AllLocations AS
	(
		SELECT RegionCode LocationCode FROM tblRegions
		UNION ALL
		SELECT DistrictCode FROM tblDistricts
		UNION ALL
		SELECT WardCode FROM tblWards
		UNION ALL
		SELECT VillageCode FROM tblVillages
	)
	SELECT AC.LocationCode
	FROM @AllCodes AC
	INNER JOIN AllLocations AL ON AC.LocationCode COLLATE DATABASE_DEFAULT = AL.LocationCode COLLATE DATABASE_DEFAULT

	IF @@ROWCOUNT > 0
		RAISERROR ('One or more location codes are already existing in database', 16, 1)
	
	BEGIN TRAN
	
 
	--INSERT REGION IN DATABASE
	IF EXISTS(SELECT * FROM tblRegions
			 INNER JOIN #tempRegion ON tblRegions.RegionCode COLLATE DATABASE_DEFAULT = #tempRegion.RegionCode COLLATE DATABASE_DEFAULT)
		BEGIN
			ROLLBACK TRAN

			--RETURN -4
		END
	ELSE
		--INSERT INTO tblRegions(RegionName,RegionCode,AuditUserID)
		INSERT INTO tblLocations(LocationCode, LocatioNname, LocationType, AuditUserId)
		SELECT RegionCode, REPLACE(RegionName,CHAR(12),''),'R',-1 
		FROM #tempRegion
		WHERE RegionName IS NOT NULL

	--INSERT DISTRICTS IN DATABASE
	IF EXISTS(SELECT * FROM tblDistricts
			 INNER JOIN #tempDistricts ON tblDistricts.DistrictCode COLLATE DATABASE_DEFAULT = #tempDistricts.DistrictCode COLLATE DATABASE_DEFAULT)
		BEGIN
			ROLLBACK TRAN
			--RETURN -1
		END
	ELSE
		--INSERT INTO tblDistricts(Region,DistrictName,DistrictCode,AuditUserID)
		INSERT INTO tblLocations(LocationCode, LocationName, ParentLocationId, LocationType, AuditUserId)
		SELECT #tempDistricts.DistrictCode, REPLACE(#tempDistricts.DistrictName,CHAR(9),''),tblRegions.RegionId,'D', -1
		FROM #tempDistricts 
		INNER JOIN tblRegions ON #tempDistricts.RegionCode COLLATE DATABASE_DEFAULT = tblRegions.RegionCode COLLATE DATABASE_DEFAULT
		WHERE #tempDistricts.DistrictName is NOT NULL
		 
		
	--INSERT WARDS IN DATABASE
	IF EXISTS (SELECT * 
				FROM tblWards 
				INNER JOIN tblDistricts ON tblWards.DistrictID = tblDistricts.DistrictID
				INNER JOIN #tempWards ON tblWards.WardCode COLLATE DATABASE_DEFAULT = #tempWards.WardCode COLLATE DATABASE_DEFAULT
									AND tblDistricts.DistrictCode COLLATE DATABASE_DEFAULT = #tempWards.DistrictCode COLLATE DATABASE_DEFAULT)	
		BEGIN
			ROLLBACK TRAN
			--RETURN -2
		END
	ELSE
		--INSERT INTO tblWards(DistrictID,WardName,WardCode,AuditUserID)
		INSERT INTO tblLocations(LocationCode, LocationName, ParentLocationId, LocationType, AuditUserId)
		SELECT WardCode, REPLACE(#tempWards.WardName,CHAR(9),''),tblDistricts.DistrictID,'W',-1
		FROM #tempWards 
		INNER JOIN tblDistricts ON #tempWards.DistrictCode COLLATE DATABASE_DEFAULT = tblDistricts.DistrictCode COLLATE DATABASE_DEFAULT
		WHERE #tempWards.WardName is NOT NULL


	--INSERT VILLAGES IN DATABASE
	IF EXISTS (SELECT * FROM 
				tblVillages 
				INNER JOIN tblWards ON tblVillages.WardID = tblWards.WardID
				INNER JOIN tblDistricts ON tblDistricts.DistrictID = tblWards.DistrictID
				INNER JOIN #tempVillages ON #tempVillages.VillageCode COLLATE DATABASE_DEFAULT = tblVillages.VillageCode COLLATE DATABASE_DEFAULT
										AND #tempVillages.WardCode COLLATE DATABASE_DEFAULT = tblWards.WardCode COLLATE DATABASE_DEFAULT
				)
		BEGIN
			ROLLBACK TRAN
			--RETURN -3
		END
	ELSE
		--INSERT INTO tblVillages(WardID,VillageName,VillageCode,AuditUserID)
		INSERT INTO tblLocations(LocationCode, LocationName, ParentLocationId, LocationType, MalePopulation,FemalePopulation,OtherPopulation,Families, AuditUserId)
		SELECT VillageCode,REPLACE(#tempVillages.VillageName,CHAR(9),''),tblWards.WardID,'V', MalePopulation,FemalePopulation,OtherPopulation,Families,-1
		FROM #tempVillages 
		INNER JOIN tblWards ON #tempVillages.WardCode COLLATE DATABASE_DEFAULT = tblWards.WardCode COLLATE DATABASE_DEFAULT 
		WHERE VillageName IS NOT NULL
	
	COMMIT TRAN				
	
		--DROP ALL THE TEMP TABLES
		DROP TABLE #tempRegion
		DROP TABLE #tempDistricts
		DROP TABLE #tempWards
		DROP TABLE #tempVillages
	
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		THROW SELECT ERROR_MESSAGE();
	END CATCH
	
END
GO


IF NOT OBJECT_ID('uspCreateEnrolmentXML') IS NULL
DROP PROC uspCreateEnrolmentXML
GO
CREATE PROCEDURE [dbo].[uspCreateEnrolmentXML]
(
	@FamilyExported INT = 0 OUTPUT,
	@InsureeExported INT = 0 OUTPUT,
	@PolicyExported INT = 0 OUTPUT,
	@PremiumExported INT = 0 OUTPUT
)
AS
BEGIN
	SELECT
	(SELECT * FROM (SELECT F.FamilyId,F.InsureeId, I.CHFID , F.LocationId, F.Poverty FROM tblInsuree I 
	INNER JOIN tblFamilies F ON F.FamilyID=I.FamilyID
	WHERE F.FamilyID IN (SELECT FamilyID FROM tblInsuree WHERE isOffline=1 AND ValidityTo IS NULL GROUP BY FamilyID) 
	AND I.IsHead=1 AND F.ValidityTo IS NULL
	UNION
SELECT F.FamilyId,F.InsureeId, I.CHFID , F.LocationId, F.Poverty
	FROM tblFamilies F 
	LEFT OUTER JOIN tblInsuree I ON F.insureeID = I.InsureeID AND I.ValidityTo IS NULL
	LEFT OUTER JOIN tblPolicy PL ON F.FamilyId = PL.FamilyID AND PL.ValidityTo IS NULL
	LEFT OUTER JOIN tblPremium PR ON PR.PolicyID = PL.PolicyID AND PR.ValidityTo IS NULL
	WHERE F.ValidityTo IS NULL 
	AND (F.isOffline = 1 OR I.isOffline = 1 OR PL.isOffline = 1 OR PR.isOffline = 1)	
	GROUP BY F.FamilyId,F.InsureeId,F.LocationId,F.Poverty,I.CHFID) aaa	
	FOR XML PATH('Family'),ROOT('Families'),TYPE),
	
	(SELECT * FROM (
	SELECT I.InsureeID,I.FamilyID,I.CHFID,I.LastName,I.OtherNames,I.DOB,I.Gender,I.Marital,I.IsHead,I.passport,I.Phone,I.CardIssued,NULL EffectiveDate
	FROM tblInsuree I
	LEFT OUTER JOIN tblInsureePolicy IP ON IP.InsureeId=I.InsureeID
	WHERE I.ValidityTo IS NULL AND I.isOffline = 1
	AND IP.ValidityTo IS NULL 
	GROUP BY I.InsureeID,I.FamilyID,I.CHFID,I.LastName,I.OtherNames,I.DOB,I.Gender,I.Marital,I.IsHead,I.passport,I.Phone,I.CardIssued
	)xx
	FOR XML PATH('Insuree'),ROOT('Insurees'),TYPE),

	(SELECT P.PolicyID,P.FamilyID,P.EnrollDate,P.StartDate,P.EffectiveDate,P.ExpiryDate,P.PolicyStatus,P.PolicyValue,P.ProdID,P.OfficerID, P.PolicyStage
	FROM tblPolicy P 
	LEFT OUTER JOIN tblPremium PR ON P.PolicyID = PR.PolicyID
	INNER JOIN tblFamilies F ON P.FamilyId = F.FamilyID
	WHERE P.ValidityTo IS NULL 
	AND PR.ValidityTo IS NULL
	AND F.ValidityTo IS NULL
	AND (P.isOffline = 1 OR PR.isOffline = 1)
	FOR XML PATH('Policy'),ROOT('Policies'),TYPE),
	(SELECT Pr.PremiumId,Pr.PolicyID,Pr.PayerID,Pr.Amount,Pr.Receipt,Pr.PayDate,Pr.PayType
	FROM tblPremium Pr INNER JOIN tblPolicy PL ON Pr.PolicyID = PL.PolicyID
	INNER JOIN tblFamilies F ON F.FamilyId = PL.FamilyID
	WHERE Pr.ValidityTo IS NULL 
	AND PL.ValidityTo IS NULL
	AND F.ValidityTo IS NULL
	AND Pr.isOffline = 1
	FOR XML PATH('Premium'),ROOT('Premiums'),TYPE)
	FOR XML PATH(''), ROOT('Enrolment')
	
	
	SELECT @FamilyExported = ISNULL(COUNT(*),0)	FROM tblFamilies F 	WHERE ValidityTo IS NULL AND isOffline = 1
	SELECT @InsureeExported = ISNULL(COUNT(*),0) FROM tblInsuree I WHERE I.ValidityTo IS NULL AND I.isOffline = 1
	SELECT @PolicyExported = ISNULL(COUNT(*),0)	FROM tblPolicy P WHERE ValidityTo IS NULL AND isOffline = 1
	SELECT @PremiumExported = ISNULL(COUNT(*),0)	FROM tblPremium Pr WHERE ValidityTo IS NULL AND isOffline = 1
END

GO

IF NOT OBJECT_ID('dw.udfNumberOfCurrentInsuree') IS NULL
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
	ODist.DistrictName OfficerDistrict,O.Code, O.LastName,O.OtherNames, COALESCE(ISNULL(PD.DistrictName, R.RegionName) ,PR.RegionName, R.RegionName)ProdRegion
	

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

IF NOT OBJECT_ID('dw.udfNumberOfCurrentPolicies') IS NULL
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
	COALESCE(ISNULL(PD.DistrictName, R.RegionName) ,PRDR.RegionName, R.RegionName)ProdRegion

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

--ON 22/03/2017
IF NOT OBJECT_ID('uspImportLocations') IS NULL
DROP PROC uspImportLocations
GO
CREATE PROCEDURE [dbo].[uspImportLocations]
(

	@RegionsFile NVARCHAR(255),
	@DistrictsFile NVARCHAR(255),
	@WardsFile NVARCHAR(255),
	@VillagesFile NVARCHAR(255)
)
AS
BEGIN
BEGIN TRY
	--CREATE TEMP TABLE FOR REGION
	IF OBJECT_ID('tempdb..#tempRegion') IS NOT NULL DROP TABLE #tempRegion
	CREATE TABLE #tempRegion(RegionCode NVARCHAR(50), RegionName NVARCHAR(50))

	--CREATE TEMP TABLE FOR DISTRICTS
	IF OBJECT_ID('tempdb..#tempDistricts') IS NOT NULL DROP TABLE #tempDistricts
	CREATE TABLE #tempDistricts(RegionCode NVARCHAR(50),DistrictCode NVARCHAR(50),DistrictName NVARCHAR(50))

	--CREATE TEMP TABLE FOR WARDS
	IF OBJECT_ID('tempdb..#tempWards') IS NOT NULL DROP TABLE #tempWards
	CREATE TABLE #tempWards(DistrictCode NVARCHAR(50),WardCode NVARCHAR(50),WardName NVARCHAR(50))

	--CREATE TEMP TABLE FOR VILLAGES
	IF OBJECT_ID('tempdb..#tempVillages') IS NOT NULL DROP TABLE #tempVillages
	CREATE TABLE #tempVillages(WardCode NVARCHAR(50),VillageCode NVARCHAR(50), VillageName NVARCHAR(50),MalePopulation INT,FemalePopulation INT, OtherPopulation INT, Families INT)



	--INSERT REGION IN TEMP TABLE
	DECLARE @InsertRegion NVARCHAR(2000)
	SET @InsertRegion = N'BULK INSERT #tempRegion FROM ''' + @RegionsFile + '''' +
		'WITH (
		FIELDTERMINATOR = ''	'',
		FIRSTROW = 2
		)'
	EXEC SP_EXECUTESQL @InsertRegion


	--INSERT DISTRICTS IN TEMP TABLE
	DECLARE @InsertDistricts NVARCHAR(2000)
	SET @InsertDistricts = N'BULK INSERT #tempDistricts FROM ''' + @DistrictsFile + '''' +
		'WITH (
		FIELDTERMINATOR = ''	'',
		FIRSTROW = 2
		)'
	EXEC SP_EXECUTESQL @InsertDistricts

	--INSERT WARDS IN TEMP TABLE
	DECLARE @InsertWards NVARCHAR(2000)
	SET @InsertWards = N'BULK INSERT #tempWards FROM ''' + @WardsFile + '''' +
		'WITH (
		FIELDTERMINATOR = ''	'',
		FIRSTROW = 2
		)'
	EXEC SP_EXECUTESQL @InsertWards


	
	--INSERT VILLAGES IN TEMP TABLE
	DECLARE @InsertVillages NVARCHAR(2000)
	SET @InsertVillages = N'BULK INSERT #tempVillages FROM ''' + @VillagesFile + '''' +
		'WITH (
		FIELDTERMINATOR = ''	'',
		FIRSTROW = 2
		)'
	EXEC SP_EXECUTESQL @InsertVillages
    
	--check if the location is null or empty space
	IF EXISTS(
	SELECT 1 FROM #tempRegion WHERE RegionCode IS NULL OR RegionName IS NULL
	UNION
	SELECT 1FROM #tempDistricts WHERE (RegionCode IS NULL OR LEN(RegionCode)=0) OR (DistrictCode IS NULL OR LEN(DistrictCode)=0) OR (DistrictName IS NULL OR LEN(DistrictName)=0)
	UNION
	SELECT 1 FROM #tempWards WHERE (DistrictCode IS NULL OR LEN(DistrictCode)=0) OR (WardCode IS NULL OR LEN(WardCode)=0) OR (WardName IS NULL OR LEN(WardName)=0)
	UNION
	SELECT 1 FROM #tempVillages WHERE (WardCode IS NULL OR LEN(WardCode)=0) OR (VillageCode IS NULL OR LEN(VillageCode)=0) OR (VillageName IS NULL OR  LEN(VillageName)=0)
	)
	RAISERROR ('LocationCode Or LocationName is Missing in excel', 16, 1)



	--check if the population is numeric
	IF EXISTS(
		SELECT * FROM #tempVillages WHERE   (ISNUMERIC(MalePopulation)=0 AND LEN(MalePopulation)>0) OR  (ISNUMERIC(FemalePopulation)=0  AND LEN(FemalePopulation)>0) OR  (ISNUMERIC(OtherPopulation)=0 AND LEN(OtherPopulation)>0) OR  (ISNUMERIC(Families)=0 AND LEN(Families)>0)
	)
	RAISERROR ('Village population must be numeric in excel', 16, 1)



	DECLARE @AllCodes AS TABLE(LocationCode NVARCHAR(8))
	;WITH AllCodes AS
	(
		SELECT RegionCode LocationCode FROM #tempRegion
		UNION ALL
		SELECT DistrictCode FROM #tempDistricts
		UNION ALL
		SELECT WardCode FROM #tempWards
		UNION ALL
		SELECT VillageCode FROM #tempVillages
	)
	INSERT INTO @AllCodes(LocationCode)
	SELECT LocationCode
	FROM AllCodes

	IF EXISTS(SELECT LocationCode FROM @AllCodes GROUP BY LocationCode HAVING COUNT(1) > 1)
		BEGIN
			SELECT LocationCode FROM @AllCodes GROUP BY LocationCode HAVING COUNT(1) > 1;
			RAISERROR ('Duplicate in excel', 16, 1)
		END

	--;WITH AllLocations AS
	--(
	--	SELECT RegionCode LocationCode, RegionName LocationName FROM tblRegions
	--	UNION ALL
	--	SELECT DistrictCode, DistrictName FROM tblDistricts
	--	UNION ALL
	--	SELECT WardCode, WardName FROM tblWards
	--	UNION ALL
	--	SELECT VillageCode, VillageName FROM tblVillages
	--)
	--SELECT AC.LocationCode ExistingCodenNDB, AL.LocationName ExistingNameInDB
	--FROM @AllCodes AC
	--INNER JOIN AllLocations AL ON AC.LocationCode COLLATE DATABASE_DEFAULT = AL.LocationCode COLLATE DATABASE_DEFAULT

	--IF @@ROWCOUNT > 0
	--	RAISERROR ('One or more location codes are already existing in database', 16, 1)
	
	--DELETE EXISTING LOCATIONS
	DELETE Temp
	OUTPUT deleted.RegionCode OmmitedRegionCode, deleted.RegionName OmmitedRegionName
	FROM #tempRegion Temp
	INNER JOIN tblLocations L ON Temp.RegionCode COLLATE DATABASE_DEFAULT = L.LocationCode COLLATE DATABASE_DEFAULT
	WHERE L.ValidityTo IS NULL;

	DELETE Temp
	OUTPUT deleted.DistrictCode OmmitedDistrictCode, deleted.DistrictName OmmitedDistrictName
	FROM #tempDistricts Temp
	INNER JOIN tblLocations L ON Temp.DistrictCode COLLATE DATABASE_DEFAULT = L.LocationCode COLLATE DATABASE_DEFAULT
	WHERE L.ValidityTo IS NULL;

	DELETE Temp
	OUTPUT deleted.WardCode OmmitedWardCode, deleted.WardName OmmitedWardName
	FROM #tempWards Temp
	INNER JOIN tblLocations L ON Temp.WardCode COLLATE DATABASE_DEFAULT = L.LocationCode COLLATE DATABASE_DEFAULT
	WHERE L.ValidityTo IS NULL;

	DELETE Temp
	OUTPUT deleted.VillageCode OmmitedVillageCode, deleted.VillageName OmmitedVillageName
	FROM #tempVillages Temp
	INNER JOIN tblLocations L ON Temp.VillageCode COLLATE DATABASE_DEFAULT = L.LocationCode COLLATE DATABASE_DEFAULT
	WHERE L.ValidityTo IS NULL;


	BEGIN TRAN
	
 
	--INSERT REGION IN DATABASE
	IF EXISTS(SELECT * FROM tblRegions
			 INNER JOIN #tempRegion ON tblRegions.RegionCode COLLATE DATABASE_DEFAULT = #tempRegion.RegionCode COLLATE DATABASE_DEFAULT)
		BEGIN
			ROLLBACK TRAN

			--RETURN -4
		END
	ELSE
		INSERT INTO tblLocations(LocationCode, LocatioNname, LocationType, AuditUserId)
		SELECT TR.RegionCode, REPLACE(TR.RegionName,CHAR(12),''),'R',-1 
		FROM #tempRegion TR
		--LEFT OUTER JOIN tblRegions R ON TR.RegionCode COLLATE DATABASE_DEFAULT = R.RegionCode COLLATE DATABASE_DEFAULT AND R.ValidityTo IS NULL
		WHERE TR.RegionName IS NOT NULL
		--AND R.RegionCode IS NULL;

		
	--INSERT DISTRICTS IN DATABASE
	IF EXISTS(SELECT * FROM tblDistricts
			 INNER JOIN #tempDistricts ON tblDistricts.DistrictCode COLLATE DATABASE_DEFAULT = #tempDistricts.DistrictCode COLLATE DATABASE_DEFAULT)
		BEGIN
			ROLLBACK TRAN
			--RETURN -1
		END
	ELSE
		--INSERT INTO tblDistricts(Region,DistrictName,DistrictCode,AuditUserID)
		INSERT INTO tblLocations(LocationCode, LocationName, ParentLocationId, LocationType, AuditUserId)
		SELECT #tempDistricts.DistrictCode, REPLACE(#tempDistricts.DistrictName,CHAR(9),''),tblRegions.RegionId,'D', -1
		FROM #tempDistricts 
		INNER JOIN tblRegions ON #tempDistricts.RegionCode COLLATE DATABASE_DEFAULT = tblRegions.RegionCode COLLATE DATABASE_DEFAULT
		--LEFT OUTER JOIN tblDistricts D ON #tempDistricts.DistrictCode COLLATE DATABASE_DEFAULT = D.DistrictCode COLLATE DATABASE_DEFAULT AND D.ValidityTo IS NULL
		WHERE #tempDistricts.DistrictName is NOT NULL
		--AND D.DistrictCode IS NULL;
		 
		
	--INSERT WARDS IN DATABASE
	IF EXISTS (SELECT * 
				FROM tblWards 
				INNER JOIN tblDistricts ON tblWards.DistrictID = tblDistricts.DistrictID
				INNER JOIN #tempWards ON tblWards.WardCode COLLATE DATABASE_DEFAULT = #tempWards.WardCode COLLATE DATABASE_DEFAULT
									AND tblDistricts.DistrictCode COLLATE DATABASE_DEFAULT = #tempWards.DistrictCode COLLATE DATABASE_DEFAULT)	
		BEGIN
			ROLLBACK TRAN
			--RETURN -2
		END
	ELSE
		--INSERT INTO tblWards(DistrictID,WardName,WardCode,AuditUserID)
		INSERT INTO tblLocations(LocationCode, LocationName, ParentLocationId, LocationType, AuditUserId)
		SELECT #tempWards.WardCode, REPLACE(#tempWards.WardName,CHAR(9),''),tblDistricts.DistrictID,'W',-1
		FROM #tempWards 
		INNER JOIN tblDistricts ON #tempWards.DistrictCode COLLATE DATABASE_DEFAULT = tblDistricts.DistrictCode COLLATE DATABASE_DEFAULT
		--LEFT OUTER JOIN tblWards W ON #tempWards.WardCode COLLATE DATABASE_DEFAULT = W.WardCode COLLATE DATABASE_DEFAULT AND W.ValidityTo IS NULL
		WHERE #tempWards.WardName is NOT NULL
		


	--INSERT VILLAGES IN DATABASE
	IF EXISTS (SELECT * FROM 
				tblVillages 
				INNER JOIN tblWards ON tblVillages.WardID = tblWards.WardID
				INNER JOIN tblDistricts ON tblDistricts.DistrictID = tblWards.DistrictID
				INNER JOIN #tempVillages ON #tempVillages.VillageCode COLLATE DATABASE_DEFAULT = tblVillages.VillageCode COLLATE DATABASE_DEFAULT
										AND #tempVillages.WardCode COLLATE DATABASE_DEFAULT = tblWards.WardCode COLLATE DATABASE_DEFAULT
				)
		BEGIN
			ROLLBACK TRAN
			--RETURN -3
		END
	ELSE
		--INSERT INTO tblVillages(WardID,VillageName,VillageCode,AuditUserID)
		INSERT INTO tblLocations(LocationCode, LocationName, ParentLocationId, LocationType, MalePopulation,FemalePopulation,OtherPopulation,Families, AuditUserId)
		SELECT VillageCode,REPLACE(#tempVillages.VillageName,CHAR(9),''),tblWards.WardID,'V', MalePopulation,FemalePopulation,OtherPopulation,Families,-1
		FROM #tempVillages 
		INNER JOIN tblWards ON #tempVillages.WardCode COLLATE DATABASE_DEFAULT = tblWards.WardCode COLLATE DATABASE_DEFAULT 
		--LEFT OUTER JOIN tblVillages V ON #tempVillages.VillageCode COLLATE DATABASE_DEFAULT = V.VillageCode COLLATE DATABASE_DEFAULT AND V.ValidityTo IS  NULL
		WHERE VillageName IS NOT NULL
	
	COMMIT TRAN				
	
		--DROP ALL THE TEMP TABLES
		DROP TABLE #tempRegion
		DROP TABLE #tempDistricts
		DROP TABLE #tempWards
		DROP TABLE #tempVillages
	
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		THROW SELECT ERROR_MESSAGE();
	END CATCH
	
END
GO
--ON 28/03/2018

IF NOT EXISTS(SELECT 1 FROM tblControls WHERE FieldName = N'ClaimAdministrator')
	INSERT INTO tblControls(FieldName, Adjustibility, Usage)
	SELECT N'ClaimAdministrator', N'M', N'FindClaim, Claim, ClaimReview, ClaimFeedback';
GO

IF NOT OBJECT_ID('uspUploadDiagnosisXML') IS NULL
DROP PROCEDURE uspUploadDiagnosisXML
GO


CREATE PROCEDURE uspUploadDiagnosisXML
(
	@File NVARCHAR(300),
	@StratergyId INT,	--1	: Insert Only,	2: Insert & Update	3: Insert, Update & Delete
	@AuditUserID INT = -1,
	@DryRun BIT=0,
	@DiagnosisSent INT = 0 OUTPUT,
	@Inserts INT  = 0 OUTPUT,
	@Updates INT  = 0 OUTPUT,
	@Deletes INT = 0 OUTPUT
)
AS
BEGIN

	/* Result type in @tblResults
	-------------------------------
		E	:	Error
		C	:	Conflict
		FE	:	Fatal Error

	Return Values
	------------------------------
		0	:	All Okay
		-1	:	Fatal error
	*/
	

	SET @Inserts = 0;
	SET @Updates = 0;
	SET @Deletes = 0;

	DECLARE @Query NVARCHAR(500)
	DECLARE @XML XML
	DECLARE @tblDiagnosis TABLE(ICDCode nvarchar(50),  ICDName NVARCHAR(255), IsValid BIT)
	DECLARE @tblDeleted TABLE(Id INT, Code NVARCHAR(8));
	DECLARE @tblResult TABLE(Result NVARCHAR(Max), ResultType NVARCHAR(2))

	BEGIN TRY

		IF @AuditUserID IS NULL
			SET @AuditUserID=-1

		SET @Query = (N'SELECT @XML = CAST(X as XML) FROM OPENROWSET(BULK  '''+ @File +''' ,SINGLE_BLOB) AS T(X)')

		EXECUTE SP_EXECUTESQL @Query,N'@XML XML OUTPUT',@XML OUTPUT


		--GET ALL THE DIAGNOSES	 FROM THE XML
		INSERT INTO @tblDiagnosis(ICDCode,ICDName, IsValid)
		SELECT 
		T.F.value('(ICDCode)[1]','NVARCHAR(12)'),
		T.F.value('(ICDName)[1]','NVARCHAR(255)'),
		1 IsValid
		FROM @XML.nodes('Diagnosis/ICD') AS T(F)

		SELECT @DiagnosisSent=@@ROWCOUNT
	
		/*========================================================================================================
		VALIDATION STARTS
		========================================================================================================*/	

			--Invalidate empty code or empty name 
			IF EXISTS(
				SELECT 1
				FROM @tblDiagnosis D 
				WHERE LEN(ISNULL(D.ICDCode, '')) = 0
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT CONVERT(NVARCHAR(3), COUNT(D.ICDCode)) + N' ICD(s) have empty code', N'E'
			FROM @tblDiagnosis D 
			WHERE LEN(ISNULL(D.ICDCode, '')) = 0

			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'ICD Code ' + QUOTENAME(D.ICDCode) + N' has empty name field', N'E'
			FROM @tblDiagnosis D 
			WHERE LEN(ISNULL(D.ICDName, '')) = 0


			UPDATE D SET IsValid = 0
			FROM @tblDiagnosis D 
			WHERE LEN(ISNULL(D.ICDCode, '')) = 0 OR LEN(ISNULL(D.ICDName, '')) = 0

			--Check if any ICD Code is greater than 6 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the ICD Code ' + QUOTENAME(D.ICDCode) + ' is greater than 6 characters', N'E'
			FROM @tblDiagnosis D
			WHERE LEN(D.ICDCode) > 6;

			UPDATE D SET IsValid = 0
			FROM @tblDiagnosis D
			WHERE LEN(D.ICDCode) > 6;

			--Check if any ICD code is duplicated in the file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT QUOTENAME(D.ICDCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(D.ICDCode)) + ' times in the file', N'C'
			FROM @tblDiagnosis D
			GROUP BY D.ICDCode
			HAVING COUNT(D.ICDCode) > 1;
	
			UPDATE D SET IsValid = 0
			FROM @tblDiagnosis D
			WHERE D.ICDCode IN (
				SELECT ICDCode FROM @tblDiagnosis GROUP BY ICDCode HAVING COUNT(ICDCode) > 1
			)

				
		--Get the counts
		--To be deleted
		IF @StratergyId = 3
			SELECT @Deletes = COUNT(1)
			FROM tblICDCodes D
			LEFT OUTER JOIN @tblDiagnosis temp ON D.ICDCode = temp.ICDCode AND temp.IsValid = 1
			LEFT OUTER JOIN tblClaim C ON C.ICDID = D.ICDID OR C.ICDID1 = D.ICDID OR C.ICDID2 = D.ICDID OR C.ICDID3 = D.ICDID OR C.ICDID4 = D.ICDID
			WHERE D.ValidityTo IS NULL
			AND temp.ICDCode IS NULL
			AND C.ClaimId IS NULL;
			
		
		--To be udpated
		IF @StratergyId = 2 OR @StratergyId = 3
		BEGIN
			SELECT @Updates = COUNT(1)
			FROM tblICDCodes ICD
			INNER JOIN @tblDiagnosis D ON ICD.ICDCode = D.ICDCode
			WHERE ICD.ValidityTo IS NULL
			AND D.IsValid = 1
		END
		
		SELECT @Inserts = COUNT(1)
		FROM @tblDiagnosis D
		LEFT OUTER JOIN tblICDCodes ICD ON D.ICDCode = ICD.ICDCode AND ICD.ValidityTo IS NULL
		WHERE D.IsValid = 1
		AND ICD.ICDCode IS NULL

		/*========================================================================================================
		VALIDATION ENDS
		========================================================================================================*/	

		IF @DryRun = 0
		BEGIN
			BEGIN TRAN UPLOAD

			/*========================================================================================================
			DELETE STARTS
			========================================================================================================*/	
				IF @StratergyId = 3
				BEGIN
					INSERT INTO @tblDeleted(Id, Code)
					SELECT D.ICDID, D.ICDCode
					FROM tblICDCodes D
					LEFT OUTER JOIN @tblDiagnosis temp ON D.ICDCode = temp.ICDCode
					WHERE D.ValidityTo IS NULL
					AND temp.ICDCode IS NULL
					AND temp.IsValid = 1

					--Check if any of the ICDCodes are used in Claims and remove them from the temporory table
					DELETE D
					FROM tblClaim C
					INNER JOIN @tblDeleted D ON C.ICDID = D.Id OR C.ICDID1 = D.Id OR C.ICDID2 = D.Id OR C.ICDID3 = D.Id OR C.ICDID4 = D.Id
	
					--Insert a copy of the to be deleted records
					INSERT INTO tblICDCodes(ICDCode, ICDName, ValidityFrom, ValidityTo, LegacyId, AuditUserId)
					SELECT ICD.ICDCode, ICD.ICDName, ICD.ValidityFrom, GETDATE() ValidityTo, ICD.ICDID LegacyId, @AuditUserID AuditUserId 
					FROM tblICDCodes ICD
					INNER JOIN @tblDeleted D ON ICD.ICDID = D.Id

					--Update the ValidtyFrom Flag to mark as deleted
					UPDATE ICD SET ValidityTo = GETDATE()
					FROM tblICDCodes ICD
					INNER JOIN @tblDeleted D ON ICD.ICDID = D.Id;
					
					SELECT @Deletes=@@ROWCOUNT;
				END
								
			/*========================================================================================================
			DELETE ENDS
			========================================================================================================*/	



			/*========================================================================================================
			UDPATE STARTS
			========================================================================================================*/	

	
				IF @StratergyId = 2 OR @StratergyId = 3
				BEGIN

				--Make a copy of the original record
					INSERT INTO tblICDCodes(ICDCode, ICDName, ValidityFrom, ValidityTo, LegacyId, AuditUserId)
					SELECT ICD.ICDCode, ICD.ICDName, ICD.ValidityFrom, GETDATE() ValidityTo, ICD.ICDID LegacyId, @AuditUserID AuditUserId 
					FROM tblICDCodes ICD
					INNER JOIN @tblDiagnosis D ON ICD.ICDCode = D.ICDCode
					WHERE ICD.ValidityTo IS NULL
					AND D.IsValid = 1;

					SELECT @Updates = @@ROWCOUNT;

				--Upadte the record
					UPDATE ICD SET ICDName = D.ICDName, ValidityFrom = GETDATE(), AuditUserID = @AuditUserID
					FROM tblICDCodes ICD
					INNER JOIN @tblDiagnosis D ON ICD.ICDCode = D.ICDCode
					WHERE ICD.ValidityTo IS NULL
					AND D.IsValid = 1;


				END

			/*========================================================================================================
			UPDATE ENDS
			========================================================================================================*/	

			/*========================================================================================================
			INSERT STARTS
			========================================================================================================*/	

				INSERT INTO tblICDCodes(ICDCode, ICDName, ValidityFrom, AuditUserId)
				SELECT D.ICDCode, D.ICDName, GETDATE() ValidityFrom, @AuditUserId AuditUserId
				FROM @tblDiagnosis D
				LEFT OUTER JOIN tblICDCodes ICD ON D.ICDCode = ICD.ICDCode AND ICD.ValidityTo IS NULL
				WHERE D.IsValid = 1
				AND ICD.ICDCode IS NULL;
	
				SELECT @Inserts = @@ROWCOUNT;


			/*========================================================================================================
			INSERT ENDS
			========================================================================================================*/	


			COMMIT TRAN UPLOAD
		END
	END TRY
	BEGIN CATCH
		INSERT INTO @tblResult(Result, ResultType)
		SELECT ERROR_MESSAGE(), N'FE';

		IF @@TRANCOUNT > 0 ROLLBACK TRAN UPLOAD;

		RETURN -1;
	END CATCH

	SELECT * FROM @tblResult;
	RETURN 0;
END
GO


IF NOT OBJECT_ID('uspImportHFXML') IS NULL
DROP PROCEDURE uspImportHFXML
GO

CREATE PROCEDURE uspImportHFXML
(
	@File NVARCHAR(300),
	@StratergyId INT,	--1	: Insert Only,	2: Insert & Update	3: Insert, Update & Delete
	@AuditUserID INT = -1,
	@DryRun BIT=0,
	@SentHF INT = 0 OUTPUT,
	@Inserts INT  = 0 OUTPUT,
	@Updates INT  = 0 OUTPUT
)
AS
BEGIN

	/* Result type in @tblResults
	-------------------------------
		E	:	Error
		C	:	Conflict
		FE	:	Fatal Error

	Return Values
	------------------------------
		0	:	All Okay
		-1	:	Fatal error
	*/
	

	DECLARE @Query NVARCHAR(500)
	DECLARE @XML XML
	DECLARE @tblHF TABLE(LegalForms NVARCHAR(15), [Level] NVARCHAR(15)  NULL, SubLevel NVARCHAR(15), Code NVARCHAR (50) NULL, Name NVARCHAR (101) NULL, [Address] NVARCHAR (101), DistrictCode NVARCHAR (50) NULL,Phone NVARCHAR (51), Fax NVARCHAR (51), Email NVARCHAR (51), CareType CHAR (15) NULL, AccountCode NVARCHAR (26), IsValid BIT )
	DECLARE @tblResult TABLE(Result NVARCHAR(Max), ResultType NVARCHAR(2))

	BEGIN TRY
		IF @AuditUserID IS NULL
			SET @AuditUserID=-1

		SET @Query = (N'SELECT @XML = CAST(X as XML) FROM OPENROWSET(BULK  '''+ @File +''' ,SINGLE_BLOB) AS T(X)')

		EXECUTE SP_EXECUTESQL @Query,N'@XML XML OUTPUT',@XML OUTPUT


		--GET ALL THE HF FROM THE XML
		INSERT INTO @tblHF(LegalForms,[Level],SubLevel,Code,Name,[Address],DistrictCode,Phone,Fax,Email,CareType,AccountCode,IsValid)
		SELECT 
		NULLIF(T.F.value('(LegalForm)[1]','NVARCHAR(15)'),''),
		NULLIF(T.F.value('(Level)[1]','NVARCHAR(15)'),''),
		NULLIF(T.F.value('(SubLevel)[1]','NVARCHAR(15)'),''),
		T.F.value('(Code)[1]','NVARCHAR(50)'),
		T.F.value('(Name)[1]','NVARCHAR(101)'),
		T.F.value('(Address)[1]','NVARCHAR(101)'),
		NULLIF(T.F.value('(DistrictCode)[1]','NVARCHAR(50)'),''),
		T.F.value('(Phone)[1]','NVARCHAR(51)'),
		T.F.value('(Fax)[1]','NVARCHAR(51)'),
		T.F.value('(Email)[1]','NVARCHAR(51)'),
		NULLIF(T.F.value('(CareType)[1]','NVARCHAR(15)'),''),
		T.F.value('(AccountCode)[1]','NVARCHAR(26)'),
		1
		FROM @XML.nodes('HealthFacilities/HealthFacility') AS T(F)

		SELECT @SentHF=@@ROWCOUNT

		/*========================================================================================================
		VALIDATION STARTS
		========================================================================================================*/	
		--Invalidate empty code or empty name 
			IF EXISTS(
				SELECT 1
				FROM @tblHF HF 
				WHERE LEN(ISNULL(HF.Code, '')) = 0
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT CONVERT(NVARCHAR(3), COUNT(HF.Code)) + N' HF(s) have empty code', N'E'
			FROM @tblHF HF 
			WHERE LEN(ISNULL(HF.Code, '')) = 0

			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty name field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Name, '')) = 0


			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Name, '')) = 0 OR LEN(ISNULL(HF.Code, '')) = 0

			--Ivalidate empty Legal Forms
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty LegaForms field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.LegalForms, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.LegalForms, '')) = 0 


			--Ivalidate empty Level
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty Level field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Level, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Level, '')) = 0 

			--Ivalidate empty District Code
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty District Code field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.DistrictCode, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.DistrictCode, '')) = 0 OR LEN(ISNULL(HF.Code, '')) = 0

				--Ivalidate empty Care Type
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty Care Type field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.CareType, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.CareType, '')) = 0 OR LEN(ISNULL(HF.Code, '')) = 0


			--Invalidate HF with duplicate Codes
			IF EXISTS(SELECT 1 FROM @tblHF  GROUP BY Code HAVING COUNT(Code) >1)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT QUOTENAME(Code) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(Code)) + ' times in the file', N'C'
			FROM @tblHF  GROUP BY Code HAVING COUNT(Code) >1

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE code in (SELECT code from @tblHF GROUP BY Code HAVING COUNT(Code) >1)

			--Invalidate HF with invalid Legal Forms
			INSERT INTO @tblResult(Result,ResultType)
			SELECT 'HF Code '+QUOTENAME(Code) +' has invalid Legal Form', N'E'  FROM @tblHF HF LEFT OUTER JOIN tblLegalForms LF ON HF.LegalForms = LF.LegalFormCode 	WHERE LF.LegalFormCode IS NULL AND NOT HF.LegalForms IS NULL
			
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN tblLegalForms LF ON HF.LegalForms = LF.LegalFormCode 	WHERE LF.LegalFormCode IS NULL AND NOT HF.LegalForms IS NULL)


			--Ivalidate HF with invalid Disrict Code
			IF EXISTS(SELECT 1  FROM @tblHF HF 	LEFT OUTER JOIN tblLocations L ON L.LocationCode=HF.DistrictCode AND L.ValidityTo IS NULL	WHERE	L.LocationCode IS NULL AND NOT HF.DistrictCode IS NULL)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has invalid District Code', N'E'
			FROM @tblHF HF 	LEFT OUTER JOIN tblLocations L ON L.LocationCode=HF.DistrictCode AND L.ValidityTo IS NULL	WHERE L.LocationCode IS NULL AND NOT HF.DistrictCode IS NULL
	
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE HF.DistrictCode IN (SELECT HF.DistrictCode  FROM @tblHF HF 	LEFT OUTER JOIN tblLocations L ON L.LocationCode=HF.DistrictCode AND L.ValidityTo IS NULL WHERE  L.LocationCode IS NULL)

			--Invalidate HF with invalid Level
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+ QUOTENAME(HF.Code)+' has invalid Level', N'E'   FROM @tblHF HF LEFT OUTER JOIN (SELECT HFLevel FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFLevel) L ON HF.Level = L.HFLevel WHERE L.HFLevel IS NULL AND NOT HF.Level IS NULL
			
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF 
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN (SELECT HFLevel FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFLevel) L ON HF.Level = L.HFLevel WHERE L.HFLevel IS NULL AND NOT HF.Level IS NULL)
			
			--Invalidate HF with invalid SubLevel
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+QUOTENAME(HF.Code) +' has invalid SubLevel' ,N'E'  FROM @tblHF HF LEFT OUTER JOIN tblHFSublevel HSL ON HSL.HFSublevel= HF.SubLevel WHERE HSL.HFSublevel IS NULL AND NOT HF.SubLevel IS NULL
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF 
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN tblHFSublevel HSL ON HSL.HFSublevel= HF.SubLevel WHERE HSL.HFSublevel IS NULL AND NOT HF.SubLevel IS NULL)

			--Remove HF with invalid CareType
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+QUOTENAME(HF.Code) +' has invalid CareType',N'E'   FROM @tblHF HF LEFT OUTER JOIN (SELECT HFCareType FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFCareType) CT ON HF.CareType = CT.HFCareType WHERE CT.HFCareType IS NULL AND NOT HF.CareType IS NULL
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF 
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN (SELECT HFCareType FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFCareType) CT ON HF.CareType = CT.HFCareType WHERE CT.HFCareType IS NULL)


			--Check if any HF Code is greater than 8 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Code ' + QUOTENAME(HF.Code) + ' is greater than 8 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Code) > 8;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Code) > 8;

			--Check if any HF Name is greater than 100 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Name ' + QUOTENAME(HF.Code) + ' is greater than 100 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Name) > 100;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Name) > 100;


			--Check if any HF Address is greater than 100 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Address ' + QUOTENAME(HF.Code) + ' is greater than 100 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Address) > 100;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Address) > 100;

			--Check if any HF Phone is greater than 50 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Phone ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Phone) > 50;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Phone) > 50;

			--Check if any HF Fax is greater than 50 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Fax ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Fax) > 50;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Fax) > 50;

			--Check if any HF Email is greater than 50 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Email ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Email) > 50;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Email) > 50;

			--Check if any HF AccountCode is greater than 25 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Account Code ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.AccountCode) > 25;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.AccountCode) > 25;

			--Get the counts
			--To be udpated
			IF @StratergyId=2
				BEGIN
					SELECT @Updates=COUNT(1) FROM @tblHF TempHF
					INNER JOIN tblHF HF ON HF.HFCode=TempHF.Code AND HF.ValidityTo IS NULL
					WHERE TempHF.IsValid=1
				END
			
			--To be Inserted
			SELECT @Inserts=COUNT(1) FROM @tblHF TempHF
			LEFT OUTER JOIN tblHF HF ON HF.HFCode=TempHF.Code AND HF.ValidityTo IS NULL
			WHERE TempHF.IsValid=1
			AND HF.HFCode IS NULL
			
		/*========================================================================================================
		VALIDATION ENDS
		========================================================================================================*/	
		IF @DryRun=0
		BEGIN
			BEGIN TRAN UPLOAD
				
			/*========================================================================================================
			UDPATE STARTS
			========================================================================================================*/	
			IF @StratergyId = 2
				BEGIN

				--Make a copy of the original record
					INSERT INTO tblHF(HFCode, HFName,[LegalForm],[HFLevel],[HFSublevel],[HFAddress],[LocationId],[Phone],[Fax],[eMail],[HFCareType],[PLServiceID],[PLItemID],[AccCode],[OffLine],[ValidityFrom],[ValidityTo],LegacyID, AuditUserId)
					SELECT HF.[HFCode] ,HF.[HFName],HF.[LegalForm],HF.[HFLevel],HF.[HFSublevel],HF.[HFAddress],HF.[LocationId],HF.[Phone],HF.[Fax],HF.[eMail],HF.[HFCareType],HF.[PLServiceID],HF.[PLItemID],HF.[AccCode],HF.[OffLine],[ValidityFrom],GETDATE()[ValidityTo],HF.HfID, @AuditUserID AuditUserId 
					FROM tblHF HF
					INNER JOIN @tblHF TempHF  ON TempHF.Code=HF.HFCode
					WHERE HF.ValidityTo IS NULL
					AND TempHF.IsValid = 1;

					SELECT @Updates = @@ROWCOUNT;
				--Upadte the record
					UPDATE HF SET HF.HFName = TempHF.Name, HF.LegalForm=TempHF.LegalForms,HF.HFLevel=TempHF.Level, HF.HFSublevel=TempHF.SubLevel,HF.HFAddress=TempHF.Address,HF.LocationId=L.LocationId, HF.Phone=TempHF.Phone, HF.Fax=TempHF.Fax, HF.eMail=TempHF.Email,HF.HFCareType=TempHF.CareType, HF.AccCode=TempHF.AccountCode, HF.OffLine=0, HF.ValidityFrom=GETDATE(), AuditUserID = @AuditUserID
					FROM tblHF HF
					INNER JOIN @tblHF TempHF  ON HF.HFCode=TempHF.Code
					INNER JOIN tblLocations L ON L.LocationCode=TempHF.DistrictCode
					WHERE HF.ValidityTo IS NULL
					AND L.ValidityTo IS NULL
					AND TempHF.IsValid = 1;
				END
			/*========================================================================================================
			UPDATE ENDS
			========================================================================================================*/	


			/*========================================================================================================
			INSERT STARTS
			========================================================================================================*/	

				INSERT INTO tblHF(HFCode, HFName,[LegalForm],[HFLevel],[HFSublevel],[HFAddress],[LocationId],[Phone],[Fax],[eMail],[HFCareType],[AccCode],[OffLine],[ValidityFrom],AuditUserId)
				SELECT TempHF.[Code] ,TempHF.[Name],TempHF.[LegalForms],TempHF.[Level],TempHF.[Sublevel],TempHF.[Address],L.LocationId,TempHF.[Phone],TempHF.[Fax],TempHF.[Email],TempHF.[CareType],TempHF.[AccountCode],0 [OffLine],GETDATE()[ValidityFrom], @AuditUserID AuditUserId 
				FROM @tblHF TempHF 
				LEFT OUTER JOIN tblHF HF  ON TempHF.Code=HF.HFCode
				INNER JOIN tblLocations L ON L.LocationCode=TempHF.DistrictCode
				WHERE HF.ValidityTo IS NULL
				AND L.ValidityTo IS NULL
				AND HF.HFCode IS NULL
				AND TempHF.IsValid = 1;
	
				SELECT @Inserts = @@ROWCOUNT;


			/*========================================================================================================
			INSERT ENDS
			========================================================================================================*/	

			COMMIT TRAN UPLOAD
		END

		
	END TRY
	BEGIN CATCH
		INSERT INTO @tblResult(Result, ResultType)
		SELECT ERROR_MESSAGE(), N'FE';

		IF @@TRANCOUNT > 0 ROLLBACK TRAN UPLOAD;
		SELECT * FROM @tblResult;
		RETURN -1;
	END CATCH

	SELECT * FROM @tblResult;
	RETURN 0;
END
GO

--ON 29/03/2017
IF NOT OBJECT_ID('uspUpdateClaimFromPhone') IS NULL
DROP PROCEDURE uspUpdateClaimFromPhone
GO

CREATE PROCEDURE [dbo].[uspUpdateClaimFromPhone]
(
	@FileName NVARCHAR(255),
	@ByPassSubmit BIT = 0
)

/*
-1	-- Fatal Error
0	-- All OK
1	--Invalid HF CODe
2	--Duplicate Claim Code
3	--Invald CHFID
4	--End date is smaller than start date
5	--Invalid ICDCode
6	--Claimed amount is 0
7	--Invalid ItemCode
8	--Invalid ServiceCode
9	--Invalid Claim Admin
*/


AS
BEGIN
	
	SET XACT_ABORT ON

	DECLARE @XML XML
	
	DECLARE @Query NVARCHAR(3000)

	DECLARE @ClaimID INT
	DECLARE @ClaimDate DATE
	DECLARE @HFCode NVARCHAR(8)
	DECLARE @ClaimAdmin NVARCHAR(8)
	DECLARE @ClaimCode NVARCHAR(8)
	DECLARE @CHFID NVARCHAR(12)
	DECLARE @StartDate DATE
	DECLARE @EndDate DATE
	DECLARE @ICDCode NVARCHAR(6)
	DECLARE @Comment NVARCHAR(MAX)
	DECLARE @Total DECIMAL(18,2)
	DECLARE @ICDCode1 NVARCHAR(6)
	DECLARE @ICDCode2 NVARCHAR(6)
	DECLARE @ICDCode3 NVARCHAR(6)
	DECLARE @ICDCode4 NVARCHAR(6)
	DECLARE @VisitType CHAR(1)
	
	

	DECLARE @HFID INT
	DECLARE @ClaimAdminId INT
	DECLARE @InsureeID INT
	DECLARE @ICDID INT
	DECLARE @ICDID1 INT
	DECLARE @ICDID2 INT
	DECLARE @ICDID3 INT
	DECLARE @ICDID4 INT
	DECLARE @TotalItems DECIMAL(18,2) = 0
	DECLARE @TotalServices DECIMAL(18,2) = 0

	DECLARE @isClaimAdminRequired BIT = (SELECT CASE Adjustibility WHEN N'M' THEN 1 ELSE 0 END FROM tblControls WHERE FieldName = N'ClaimAdministrator')
	
	BEGIN TRY
		
			IF NOT OBJECT_ID('tempdb..#tblItem') IS NULL DROP TABLE #tblItem
			CREATE TABLE #tblItem(ItemCode NVARCHAR(6),ItemPrice DECIMAL(18,2), ItemQuantity INT)

			IF NOT OBJECT_ID('tempdb..#tblService') IS NULL DROP TABLE #tblService
			CREATE TABLE #tblService(ServiceCode NVARCHAR(6),ServicePrice DECIMAL(18,2), ServiceQuantity INT)

			SET @Query = (N'SELECT @XML = CAST(X as XML) FROM OPENROWSET(BULK '''+ @FileName +''',SINGLE_BLOB) AS T(X)')
			
			EXECUTE SP_EXECUTESQL @Query,N'@XML XML OUTPUT',@XML OUTPUT

			SELECT
			@ClaimDate = CONVERT(DATE,Claim.value('(ClaimDate)[1]','NVARCHAR(10)'),103),
			@HFCode = Claim.value('(HFCode)[1]','NVARCHAR(8)'),
			@ClaimAdmin = Claim.value('(ClaimAdmin)[1]','NVARCHAR(8)'),
			@ClaimCode = Claim.value('(ClaimCode)[1]','NVARCHAR(8)'),
			@CHFID = Claim.value('(CHFID)[1]','NVARCHAR(12)'),
			@StartDate = CONVERT(DATE,Claim.value('(StartDate)[1]','NVARCHAR(10)'),103),
			@EndDate = CONVERT(DATE,Claim.value('(EndDate)[1]','NVARCHAR(10)'),103),
			@ICDCode = Claim.value('(ICDCode)[1]','NVARCHAR(6)'),
			@Comment = Claim.value('(Comment)[1]','NVARCHAR(MAX)'),
			@Total = CASE Claim.value('(Total)[1]','VARCHAR(10)') WHEN '' THEN 0 ELSE CONVERT(DECIMAL(18,2),ISNULL(Claim.value('(Total)[1]','VARCHAR(10)'),0)) END,
			@ICDCode1 = Claim.value('(ICDCode1)[1]','NVARCHAR(6)'),
			@ICDCode2 = Claim.value('(ICDCode2)[1]','NVARCHAR(6)'),
			@ICDCode3 = Claim.value('(ICDCode3)[1]','NVARCHAR(6)'),
			@ICDCode4 = Claim.value('(ICDCode4)[1]','NVARCHAR(6)'),
			@VisitType = Claim.value('(VisitType)[1]','CHAR(1)')
			FROM @XML.nodes('Claim/Details')AS T(Claim)


			INSERT INTO #tblItem(ItemCode,ItemPrice,ItemQuantity)
			SELECT
			T.Items.value('(ItemCode)[1]','NVARCHAR(6)'),
			CONVERT(DECIMAL(18,2),T.Items.value('(ItemPrice)[1]','DECIMAL(18,2)')),
			CONVERT(DECIMAL(18,2),T.Items.value('(ItemQuantity)[1]','NVARCHAR(15)'))
			FROM @XML.nodes('Claim/Items/Item') AS T(Items)



			INSERT INTO #tblService(ServiceCode,ServicePrice,ServiceQuantity)
			SELECT
			T.[Services].value('(ServiceCode)[1]','NVARCHAR(6)'),
			CONVERT(DECIMAL(18,2),T.[Services].value('(ServicePrice)[1]','DECIMAL(18,2)')),
			CONVERT(DECIMAL(18,2),T.[Services].value('(ServiceQuantity)[1]','NVARCHAR(15)'))
			FROM @XML.nodes('Claim/Services/Service') AS T([Services])

			--isValid HFCode

			SELECT @HFID = HFID FROM tblHF WHERE HFCode = @HFCode AND ValidityTo IS NULL
			IF @HFID IS NULL
				RETURN 1
				
			--isDuplicate ClaimCode
			IF EXISTS(SELECT ClaimCode FROM tblClaim WHERE ClaimCode = @ClaimCode AND HFID = @HFID AND ValidityTo IS NULL)
				RETURN 2

			--isValid CHFID
			SELECT @InsureeID = InsureeID FROM tblInsuree WHERE CHFID = @CHFID AND ValidityTo IS NULL
			IF @InsureeID IS NULL
				RETURN 3

			--isValid EndDate
			IF DATEDIFF(DD,@ENDDATE,@STARTDATE) > 0
				RETURN 4
				
			--isValid ICDCode
			SELECT @ICDID = ICDID FROM tblICDCodes WHERE ICDCode = @ICDCode AND ValidityTo IS NULL
			IF @ICDID IS NULL
				RETURN 5
			
			IF NOT NULLIF(@ICDCode1, '')IS NULL
			BEGIN
				SELECT @ICDID1 = ICDID FROM tblICDCodes WHERE ICDCode = @ICDCode1 AND ValidityTo IS NULL
				IF @ICDID1 IS NULL
					RETURN 5
			END
			
			IF NOT NULLIF(@ICDCode2, '') IS NULL
			BEGIN
				SELECT @ICDID2 = ICDID FROM tblICDCodes WHERE ICDCode = @ICDCode2 AND ValidityTo IS NULL
				IF @ICDID2 IS NULL
					RETURN 5
			END
			
			IF NOT NULLIF(@ICDCode3, '') IS NULL
			BEGIN
				SELECT @ICDID3 = ICDID FROM tblICDCodes WHERE ICDCode = @ICDCode3 AND ValidityTo IS NULL
				IF @ICDID3 IS NULL
					RETURN 5
			END
			
			IF NOT NULLIF(@ICDCode4, '') IS NULL
			BEGIN
				SELECT @ICDID4 = ICDID FROM tblICDCodes WHERE ICDCode = @ICDCode4 AND ValidityTo IS NULL
				IF @ICDID4 IS NULL
					RETURN 5
			END		
			--isValid Claimed Amount
			--THIS CONDITION CAN BE PUT BACK
			--IF @Total <= 0
			--	RETURN 6
				
			--isValid ItemCode
			IF EXISTS (SELECT I.ItemCode
			FROM tblItems I FULL OUTER JOIN #tblItem TI ON I.ItemCode COLLATE DATABASE_DEFAULT = TI.ItemCode COLLATE DATABASE_DEFAULT
			WHERE I.ItemCode IS NULL AND I.ValidityTo IS NULL)
				RETURN 7
				
			--isValid ServiceCode
			IF EXISTS(SELECT S.ServCode
			FROM tblServices S FULL OUTER JOIN #tblService TS ON S.ServCode COLLATE DATABASE_DEFAULT = TS.ServiceCode COLLATE DATABASE_DEFAULT
			WHERE S.ServCode IS NULL AND S.ValidityTo IS NULL)
				RETURN 8
			
			--isValid Claim Admin
			IF @isClaimAdminRequired = 1
			BEGIN	
				SELECT @ClaimAdminId = ClaimAdminId FROM tblClaimAdmin WHERE ClaimAdminCode = @ClaimAdmin AND ValidityTo IS NULL
				IF @ClaimAdmin IS NULL
					RETURN 9
			END

		BEGIN TRAN CLAIM
			INSERT INTO tblClaim(InsureeID,ClaimCode,DateFrom,DateTo,ICDID,ClaimStatus,Claimed,DateClaimed,Explanation,AuditUserID,HFID,ClaimAdminId,ICDID1,ICDID2,ICDID3,ICDID4,VisitType)
						VALUES(@InsureeID,@ClaimCode,@StartDate,@EndDate,@ICDID,2,@Total,@ClaimDate,@Comment,-1,@HFID,@ClaimAdminId,@ICDID1,@ICDID2,@ICDID3,@ICDID4,@VisitType);

			SELECT @ClaimID = SCOPE_IDENTITY();
			
			;WITH PLID AS
			(
				SELECT PLID.ItemId, PLID.PriceOverule
				FROM tblHF HF
				INNER JOIN tblPLItems PLI ON PLI.PLItemId = HF.PLItemID
				INNER JOIN tblPLItemsDetail PLID ON PLID.PLItemId = PLI.PLItemId
				WHERE HF.ValidityTo IS NULL
				AND PLI.ValidityTo IS NULL
				AND PLID.ValidityTo IS NULL
				AND HF.HFID = @HFID
			)
			INSERT INTO tblClaimItems(ClaimID,ItemID,QtyProvided,PriceAsked,AuditUserID)
			SELECT @ClaimID, I.ItemId, T.ItemQuantity, COALESCE(NULLIF(T.ItemPrice,0),PLID.PriceOverule,I.ItemPrice)ItemPrice, -1
			FROM #tblItem T 
			INNER JOIN tblItems I  ON T.ItemCode COLLATE DATABASE_DEFAULT = I.ItemCode COLLATE DATABASE_DEFAULT AND I.ValidityTo IS NULL
			LEFT OUTER JOIN PLID ON PLID.ItemID = I.ItemID
			
			SELECT @TotalItems = SUM(PriceAsked * QtyProvided) FROM tblClaimItems 
						WHERE ClaimID = @ClaimID
						GROUP BY ClaimID

			;WITH PLSD AS
			(
				SELECT PLSD.ServiceId, PLSD.PriceOverule
				FROM tblHF HF
				INNER JOIN tblPLServices PLS ON PLS.PLServiceId = HF.PLServiceID
				INNER JOIN tblPLServicesDetail PLSD ON PLSD.PLServiceId = PLS.PLServiceId
				WHERE HF.ValidityTo IS NULL
				AND PLS.ValidityTo IS NULL
				AND PLSD.ValidityTo IS NULL
				AND HF.HFID = @HFID
			)
			INSERT INTO tblClaimServices(ClaimId, ServiceID, QtyProvided, PriceAsked, AuditUserID)
			SELECT @ClaimID, S.ServiceID, T.ServiceQuantity,COALESCE(NULLIF(T.ServicePrice,0),PLSD.PriceOverule,S.ServPrice)ServicePrice , -1
			FROM #tblService T 
			INNER JOIN tblServices S ON T.ServiceCode COLLATE DATABASE_DEFAULT = S.ServCode COLLATE DATABASE_DEFAULT AND S.ValidityTo IS NULL
			LEFT OUTER JOIN PLSD ON PLSD.ServiceId = S.ServiceId
						
						SELECT @TotalServices = SUM(PriceAsked * QtyProvided) FROM tblClaimServices 
						WHERE ClaimID = @ClaimID
						GROUP BY ClaimID
					
						UPDATE tblClaim SET Claimed = ISNULL(@TotalItems,0) + ISNULL(@TotalServices,0)
						WHERE ClaimID = @ClaimID
						
		COMMIT TRAN CLAIM
		
		
		SELECT @ClaimID  = IDENT_CURRENT('tblClaim')
		
		IF @ByPassSubmit = 0
			EXEC uspSubmitSingleClaim -1, @ClaimID,0 
		
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN CLAIM
			SELECT ERROR_MESSAGE()
		RETURN -1
	END CATCH
	
	RETURN 0
END
GO


--ON 03/04/2018
IF OBJECT_ID('tblIMISDetaulsPhone') IS NULL
BEGIN 
	CREATE TABLE [dbo].[tblIMISDetaulsPhone](
		[RuleName] [nvarchar](100) NULL,
		[RuleValue] [bit] NULL
	);

	INSERT INTO tblIMISDetaulsPhone(RuleName, RuleValue)VALUES
	(N'AllowInsureeWithoutPhoto', 0), (N'AllowFamilyWithoutPolicy', 0), (N'AllowPolicyWithoutPremium', 0)

END

GO

--ON 06/04/2018
IF NOT OBJECT_ID('uspUploadDiagnosisXML') IS NULL
DROP PROCEDURE [dbo].[uspUploadDiagnosisXML]
GO

CREATE PROCEDURE [dbo].[uspUploadDiagnosisXML]
(
	@File NVARCHAR(300),
	@StratergyId INT,	--1	: Insert Only,	2: Insert & Update	3: Insert, Update & Delete
	@AuditUserID INT = -1,
	@DryRun BIT=0,
	@DiagnosisSent INT = 0 OUTPUT,
	@Inserts INT  = 0 OUTPUT,
	@Updates INT  = 0 OUTPUT,
	@Deletes INT = 0 OUTPUT
)
AS
BEGIN

	/* Result type in @tblResults
	-------------------------------
		E	:	Error
		C	:	Conflict
		FE	:	Fatal Error

	Return Values
	------------------------------
		0	:	All Okay
		-1	:	Fatal error
	*/
	

	SET @Inserts = 0;
	SET @Updates = 0;
	SET @Deletes = 0;

	DECLARE @Query NVARCHAR(500)
	DECLARE @XML XML
	DECLARE @tblDiagnosis TABLE(ICDCode nvarchar(50),  ICDName NVARCHAR(255), IsValid BIT)
	DECLARE @tblDeleted TABLE(Id INT, Code NVARCHAR(8));
	DECLARE @tblResult TABLE(Result NVARCHAR(Max), ResultType NVARCHAR(2))

	BEGIN TRY

		IF @AuditUserID IS NULL
			SET @AuditUserID=-1

		SET @Query = (N'SELECT @XML = CAST(X as XML) FROM OPENROWSET(BULK  '''+ @File +''' ,SINGLE_BLOB) AS T(X)')

		EXECUTE SP_EXECUTESQL @Query,N'@XML XML OUTPUT',@XML OUTPUT


		--GET ALL THE DIAGNOSES	 FROM THE XML
		INSERT INTO @tblDiagnosis(ICDCode,ICDName, IsValid)
		SELECT 
		T.F.value('(ICDCode)[1]','NVARCHAR(12)'),
		T.F.value('(ICDName)[1]','NVARCHAR(255)'),
		1 IsValid
		FROM @XML.nodes('Diagnosis/ICD') AS T(F)

		SELECT @DiagnosisSent=@@ROWCOUNT
	
		/*========================================================================================================
		VALIDATION STARTS
		========================================================================================================*/	

			--Invalidate empty code or empty name 
			IF EXISTS(
				SELECT 1
				FROM @tblDiagnosis D 
				WHERE LEN(ISNULL(D.ICDCode, '')) = 0
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT CONVERT(NVARCHAR(3), COUNT(D.ICDCode)) + N' ICD(s) have empty code', N'E'
			FROM @tblDiagnosis D 
			WHERE LEN(ISNULL(D.ICDCode, '')) = 0

			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'ICD Code ' + QUOTENAME(D.ICDCode) + N' has empty name field', N'E'
			FROM @tblDiagnosis D 
			WHERE LEN(ISNULL(D.ICDName, '')) = 0


			UPDATE D SET IsValid = 0
			FROM @tblDiagnosis D 
			WHERE LEN(ISNULL(D.ICDCode, '')) = 0 OR LEN(ISNULL(D.ICDName, '')) = 0

			--Check if any ICD Code is greater than 6 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the ICD Code ' + QUOTENAME(D.ICDCode) + ' is greater than 6 characters', N'E'
			FROM @tblDiagnosis D
			WHERE LEN(D.ICDCode) > 6;

			UPDATE D SET IsValid = 0
			FROM @tblDiagnosis D
			WHERE LEN(D.ICDCode) > 6;

			--Check if any ICD code is duplicated in the file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT QUOTENAME(D.ICDCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(D.ICDCode)) + ' times in the file', N'C'
			FROM @tblDiagnosis D
			GROUP BY D.ICDCode
			HAVING COUNT(D.ICDCode) > 1;
	
			UPDATE D SET IsValid = 0
			FROM @tblDiagnosis D
			WHERE D.ICDCode IN (
				SELECT ICDCode FROM @tblDiagnosis GROUP BY ICDCode HAVING COUNT(ICDCode) > 1
			)

				
		--Get the counts
		--To be deleted
		IF @StratergyId = 3
			SELECT @Deletes = COUNT(1)
			FROM tblICDCodes D
			LEFT OUTER JOIN @tblDiagnosis temp ON D.ICDCode = temp.ICDCode AND temp.IsValid = 1
			LEFT OUTER JOIN tblClaim C ON C.ICDID = D.ICDID OR C.ICDID1 = D.ICDID OR C.ICDID2 = D.ICDID OR C.ICDID3 = D.ICDID OR C.ICDID4 = D.ICDID
			WHERE D.ValidityTo IS NULL
			AND temp.ICDCode IS NULL
			AND C.ClaimId IS NULL;
			
		
		--To be udpated
		IF @StratergyId = 2 OR @StratergyId = 3
		BEGIN
			SELECT @Updates = COUNT(1)
			FROM tblICDCodes ICD
			INNER JOIN @tblDiagnosis D ON ICD.ICDCode = D.ICDCode
			WHERE ICD.ValidityTo IS NULL
			AND D.IsValid = 1
		END
		
		SELECT @Inserts = COUNT(1)
		FROM @tblDiagnosis D
		LEFT OUTER JOIN tblICDCodes ICD ON D.ICDCode = ICD.ICDCode AND ICD.ValidityTo IS NULL
		WHERE D.IsValid = 1
		AND ICD.ICDCode IS NULL

		/*========================================================================================================
		VALIDATION ENDS
		========================================================================================================*/	

		IF @DryRun = 0
		BEGIN
			BEGIN TRAN UPLOAD

			/*========================================================================================================
			DELETE STARTS
			========================================================================================================*/	
				IF @StratergyId = 3
				BEGIN
					INSERT INTO @tblDeleted(Id, Code)
					SELECT D.ICDID, D.ICDCode
					FROM tblICDCodes D
					LEFT OUTER JOIN @tblDiagnosis temp ON D.ICDCode = temp.ICDCode
					WHERE D.ValidityTo IS NULL
					AND temp.ICDCode IS NULL
					AND temp.IsValid = 1

					--Check if any of the ICDCodes are used in Claims and remove them from the temporory table
					DELETE D
					FROM tblClaim C
					INNER JOIN @tblDeleted D ON C.ICDID = D.Id OR C.ICDID1 = D.Id OR C.ICDID2 = D.Id OR C.ICDID3 = D.Id OR C.ICDID4 = D.Id
	
					--Insert a copy of the to be deleted records
					INSERT INTO tblICDCodes(ICDCode, ICDName, ValidityFrom, ValidityTo, LegacyId, AuditUserId)
					SELECT ICD.ICDCode, ICD.ICDName, ICD.ValidityFrom, GETDATE() ValidityTo, ICD.ICDID LegacyId, @AuditUserID AuditUserId 
					FROM tblICDCodes ICD
					INNER JOIN @tblDeleted D ON ICD.ICDID = D.Id

					--Update the ValidtyFrom Flag to mark as deleted
					UPDATE ICD SET ValidityTo = GETDATE()
					FROM tblICDCodes ICD
					INNER JOIN @tblDeleted D ON ICD.ICDID = D.Id;
					
					SELECT @Deletes=@@ROWCOUNT;
				END
								
			/*========================================================================================================
			DELETE ENDS
			========================================================================================================*/	



			/*========================================================================================================
			UDPATE STARTS
			========================================================================================================*/	

	
				IF @StratergyId = 2 OR @StratergyId = 3
				BEGIN

				--Make a copy of the original record
					INSERT INTO tblICDCodes(ICDCode, ICDName, ValidityFrom, ValidityTo, LegacyId, AuditUserId)
					SELECT ICD.ICDCode, ICD.ICDName, ICD.ValidityFrom, GETDATE() ValidityTo, ICD.ICDID LegacyId, @AuditUserID AuditUserId 
					FROM tblICDCodes ICD
					INNER JOIN @tblDiagnosis D ON ICD.ICDCode = D.ICDCode
					WHERE ICD.ValidityTo IS NULL
					AND D.IsValid = 1;

					SELECT @Updates = @@ROWCOUNT;

				--Upadte the record
					UPDATE ICD SET ICDName = D.ICDName, ValidityFrom = GETDATE(), AuditUserID = @AuditUserID
					FROM tblICDCodes ICD
					INNER JOIN @tblDiagnosis D ON ICD.ICDCode = D.ICDCode
					WHERE ICD.ValidityTo IS NULL
					AND D.IsValid = 1;


				END

			/*========================================================================================================
			UPDATE ENDS
			========================================================================================================*/	

			/*========================================================================================================
			INSERT STARTS
			========================================================================================================*/	

				INSERT INTO tblICDCodes(ICDCode, ICDName, ValidityFrom, AuditUserId)
				SELECT D.ICDCode, D.ICDName, GETDATE() ValidityFrom, @AuditUserId AuditUserId
				FROM @tblDiagnosis D
				LEFT OUTER JOIN tblICDCodes ICD ON D.ICDCode = ICD.ICDCode AND ICD.ValidityTo IS NULL
				WHERE D.IsValid = 1
				AND ICD.ICDCode IS NULL;
	
				SELECT @Inserts = @@ROWCOUNT;


			/*========================================================================================================
			INSERT ENDS
			========================================================================================================*/	


			COMMIT TRAN UPLOAD
			
		END
	END TRY
	BEGIN CATCH
		DECLARE @InvalidXML NVARCHAR(100)
		IF ERROR_NUMBER()=9436
		BEGIN 
			SET @InvalidXML='Invalid XML file, end tag does not match start tag'
			INSERT INTO @tblResult(Result, ResultType)
			SELECT @InvalidXML, N'FE';
		END
		ELSE
			INSERT INTO @tblResult(Result, ResultType)
			SELECT'Invalid XML file', N'FE';
			
		IF @@TRANCOUNT > 0 ROLLBACK TRAN UPLOAD;
		SELECT * FROM @tblResult;
		RETURN -1;
	END CATCH

	SELECT * FROM @tblResult;
	RETURN 0;
END

GO

IF NOT OBJECT_ID('uspUploadLocationsXML') IS NULL
DROP PROCEDURE [dbo].[uspUploadLocationsXML]
GO

CREATE PROCEDURE [dbo].[uspUploadLocationsXML]
(
		@File NVARCHAR(500),
		@StratergyId INT,
		@DryRun BIT,
		@AuditUserId INT,
		@SentRegion INT =0 OUTPUT,  
		@SentDistrict INT =0  OUTPUT, 
		@SentWard INT =0  OUTPUT, 
		@SentVillage INT =0  OUTPUT, 
		@InsertRegion INT =0  OUTPUT, 
		@InsertDistrict INT =0  OUTPUT, 
		@InsertWard INT =0  OUTPUT, 
		@InsertVillage INT =0 OUTPUT, 
		@UpdateRegion INT =0  OUTPUT, 
		@UpdateDistrict INT =0  OUTPUT, 
		@UpdateWard INT =0  OUTPUT, 
		@UpdateVillage INT =0  OUTPUT
)
AS 
	BEGIN

		/* Result type in @tblResults
		-------------------------------
			E	:	Error
			C	:	Conflict
			FE	:	Fatal Error

		Return Values
		------------------------------
			0	:	All Okay
			-1	:	Fatal error
		*/

		DECLARE @Query NVARCHAR(500)
		DECLARE @XML XML
		DECLARE @tblResult TABLE(Result NVARCHAR(Max), ResultType NVARCHAR(2))
		DECLARE @tempRegion TABLE(RegionCode NVARCHAR(100), RegionName NVARCHAR(100), IsValid BIT )
		DECLARE @tempLocation TABLE(LocationCode NVARCHAR(100))
		DECLARE @tempDistricts TABLE(RegionCode NVARCHAR(100),DistrictCode NVARCHAR(100),DistrictName NVARCHAR(100), IsValid BIT )
		DECLARE @tempWards TABLE(DistrictCode NVARCHAR(100),WardCode NVARCHAR(100),WardName NVARCHAR(100), IsValid BIT )
		DECLARE @tempVillages TABLE(WardCode NVARCHAR(100),VillageCode NVARCHAR(100), VillageName NVARCHAR(100),MalePopulation INT,FemalePopulation INT, OtherPopulation INT, Families INT, IsValid BIT )

		BEGIN TRY
	
			SET @Query = (N'SELECT @XML = CAST(X as XML) FROM OPENROWSET(BULK  '''+ @File +''' ,SINGLE_BLOB) AS T(X)')

			EXECUTE SP_EXECUTESQL @Query,N'@XML XML OUTPUT',@XML OUTPUT


			--GET ALL THE REGIONS FROM THE XML
			INSERT INTO @tempRegion(RegionCode,RegionName,IsValid)
			SELECT 
			NULLIF(T.R.value('(RegionCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(RegionName)[1]','NVARCHAR(100)'),''),
			1
			FROM @XML.nodes('Locations/Regions/Region') AS T(R)
		
			SELECT @SentRegion=@@ROWCOUNT

			--GET ALL THE DISTRICTS FROM THE XML
			INSERT INTO @tempDistricts(RegionCode, DistrictCode, DistrictName,IsValid)
			SELECT 
			NULLIF(T.R.value('(RegionCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(DistrictCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(DistrictName)[1]','NVARCHAR(100)'),''),
			1
			FROM @XML.nodes('Locations/Districts/District') AS T(R)

			SELECT @SentDistrict=@@ROWCOUNT

			--GET ALL THE WARDS FROM THE XML
			INSERT INTO @tempWards(DistrictCode,WardCode, WardName,IsValid)
			SELECT 
			NULLIF(T.R.value('(DistrictCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(WardCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(WardName)[1]','NVARCHAR(100)'),''),
			1
			FROM @XML.nodes('Locations/Wards/Ward') AS T(R)
		
			SELECT @SentWard = @@ROWCOUNT

			--GET ALL THE VILLAGES FROM THE XML
			INSERT INTO @tempVillages(WardCode, VillageCode, VillageName, MalePopulation, FemalePopulation, OtherPopulation, Families, IsValid)
			SELECT 
			NULLIF(T.R.value('(WardCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(VillageCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(VillageName)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(MalePopulation)[1]','INT'),0),
			NULLIF(T.R.value('(FemalePopulation)[1]','INT'),0),
			NULLIF(T.R.value('(MalePopulation)[1]','INT'),0),
			NULLIF(T.R.value('(Families)[1]','INT'),0),
			1
			FROM @XML.nodes('Locations/Villages/Village') AS T(R)
		
			SELECT @SentVillage=@@ROWCOUNT

			/*========================================================================================================
			VALIDATION STARTS
			========================================================================================================*/	
			/********************************CHECK THE DUPLICATE LOCATION CODE******************************/
				INSERT INTO @tempLocation(LocationCode)
				SELECT RegionCode FROM @tempRegion
				INSERT INTO @tempLocation(LocationCode)
				SELECT DistrictCode FROM @tempDistricts
				INSERT INTO @tempLocation(LocationCode)
				SELECT WardCode FROM @tempWards
				INSERT INTO @tempLocation(LocationCode)
				SELECT VillageCode FROM @tempVillages
			
				INSERT INTO @tblResult(Result, ResultType)
				SELECT N'Location Code ' + QUOTENAME(LocationCode) + '  has already being used in a file ', N'C' FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1

				UPDATE @tempRegion  SET IsValid=0 WHERE RegionCode IN (SELECT LocationCode FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1)
				UPDATE @tempDistricts  SET IsValid=0 WHERE DistrictCode IN (SELECT LocationCode FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1)
				UPDATE @tempWards  SET IsValid=0 WHERE WardCode IN (SELECT LocationCode FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1)
				UPDATE @tempVillages  SET IsValid=0 WHERE VillageCode IN (SELECT LocationCode FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1)


			/********************************REGION STARTS******************************/
			--check if the regioncode is null 
			IF EXISTS(
			SELECT 1 FROM @tempRegion WHERE  LEN(ISNULL(RegionCode,''))=0 
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(1)) + N' Region(s) have empty code', N'E' FROM @tempRegion WHERE  LEN(ISNULL(RegionCode,''))=0 
		
			UPDATE @tempRegion SET IsValid=0  WHERE  LEN(ISNULL(RegionCode,''))=0 
		
			--check if the regionname is null 
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Region Code ' + QUOTENAME(RegionCode) + N' has empty name', N'E' FROM @tempRegion WHERE  LEN(ISNULL(RegionName,''))=0 
		
			UPDATE @tempRegion SET IsValid=0  WHERE RegionName  IS NULL OR LEN(ISNULL(RegionName,''))=0 

			--Check for Duplicates in file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Region Code ' + QUOTENAME(RegionCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(RegionCode)) + ' times in the file', N'C'  FROM @tempRegion GROUP BY RegionCode HAVING COUNT(RegionCode) >1 
		
			UPDATE R SET IsValid = 0 FROM @tempRegion R
			WHERE RegionCode in (SELECT RegionCode from @tempRegion GROUP BY RegionCode HAVING COUNT(RegionCode) >1)
		
			--check the length of the regionCode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Region Code ' + QUOTENAME(RegionCode) + N' is greater than 50', N'E' FROM @tempRegion WHERE  LEN(ISNULL(RegionCode,''))>50
		
			UPDATE @tempRegion SET IsValid=0  WHERE LEN(ISNULL(RegionCode,''))>50

			--check the length of the regionname
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Region Name ' + QUOTENAME(RegionCode) + N' is greater than 50', N'E' FROM @tempRegion WHERE  LEN(ISNULL(RegionName,''))>50
		
			UPDATE @tempRegion SET IsValid=0  WHERE LEN(ISNULL(RegionName,''))>50
		
		

			/********************************REGION ENDS******************************/

			/********************************DISTRICT STARTS******************************/
			--check if the district has regioncode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'District Code ' + QUOTENAME(DistrictCode) + N' has empty Region Code', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(RegionCode,''))=0 
		
			UPDATE @tempDistricts SET IsValid=0  WHERE  LEN(ISNULL(RegionCode,''))=0 

			--check if the district has valid regioncode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'District Code ' + QUOTENAME(DistrictCode) + N' has invalid Region Code', N'E' FROM @tempDistricts TD
			LEFT OUTER JOIN @tempRegion TR ON TR.RegionCode=TD.RegionCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TD.RegionCode AND L.LocationType='R' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TR.RegionCode IS NULL
			AND LEN(TD.RegionCode)>0

			UPDATE TD SET TD.IsValid=0 FROM @tempDistricts TD
			LEFT OUTER JOIN @tempRegion TR ON TR.RegionCode=TD.RegionCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TD.RegionCode AND L.LocationType='R' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TR.RegionCode IS NULL
			AND LEN(TD.RegionCode)>0

			--check if the districtcode is null 
			IF EXISTS(
			SELECT  1 FROM @tempDistricts WHERE  LEN(ISNULL(DistrictCode,''))=0 
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(1)) + N' District(s) have empty District code', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(DistrictCode,''))=0 
		
			UPDATE @tempDistricts SET IsValid=0  WHERE  LEN(ISNULL(DistrictCode,''))=0 
		
			--check if the districtname is null 
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'District Code ' + QUOTENAME(DistrictCode) + N' has empty name', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(DistrictName,''))=0 
		
			UPDATE @tempDistricts SET IsValid=0  WHERE  LEN(ISNULL(DistrictName,''))=0 
		
			--Check for Duplicates in file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'District Code ' + QUOTENAME(DistrictCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(DistrictCode)) + ' times in the file', N'C'  FROM @tempDistricts GROUP BY DistrictCode HAVING COUNT(DistrictCode) >1 
		
			UPDATE D SET IsValid = 0 FROM @tempDistricts D
			WHERE DistrictCode in (SELECT DistrictCode from @tempDistricts GROUP BY DistrictCode HAVING COUNT(DistrictCode) >1)

			--check the length of the DistrictCode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the District Code ' + QUOTENAME(DistrictCode) + N' is greater than 50', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(DistrictCode,''))>50
		
			UPDATE @tempDistricts SET IsValid=0  WHERE LEN(ISNULL(DistrictCode,''))>50

			--check the length of the regionname
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the District Name ' + QUOTENAME(DistrictName) + N' is greater than 50', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(DistrictName,''))>50
		
			UPDATE @tempDistricts SET IsValid=0  WHERE LEN(ISNULL(DistrictName,''))>50
		
			/********************************DISTRICT ENDS******************************/

			/********************************WARDS STARTS******************************/
			--check if the ward has districtcode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Ward Code ' + QUOTENAME(WardCode) + N' has empty District Code', N'E' FROM @tempWards WHERE  LEN(ISNULL(DistrictCode,''))=0 
		
			UPDATE @tempWards SET IsValid=0  WHERE  LEN(ISNULL(DistrictCode,''))=0 

			--check if the ward has valid districtCode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Ward Code ' + QUOTENAME(WardCode) + N' has invalid District Code', N'E' FROM @tempWards TW
			LEFT OUTER JOIN @tempDistricts TD ON  TD.DistrictCode=TW.DistrictCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.DistrictCode AND L.LocationType='D' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TD.DistrictCode IS NULL
			AND LEN(TW.DistrictCode)>0

			UPDATE TW SET TW.IsValid=0 FROM @tempWards TW
			LEFT OUTER JOIN @tempDistricts TD ON  TD.DistrictCode=TW.DistrictCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.DistrictCode AND L.LocationType='D' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TD.DistrictCode IS NULL
			AND LEN(TW.DistrictCode)>0

			--check if the wardcode is null 
			IF EXISTS(
			SELECT  1 FROM @tempWards WHERE  LEN(ISNULL(WardCode,''))=0 
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(1)) + N' Ward(s) have empty Ward code', N'E' FROM @tempWards WHERE  LEN(ISNULL(WardCode,''))=0 
		
			UPDATE @tempWards SET IsValid=0  WHERE  LEN(ISNULL(WardCode,''))=0 
		
			--check if the wardname is null 
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Ward Code ' + QUOTENAME(WardCode) + N' has empty name', N'E' FROM @tempWards WHERE  LEN(ISNULL(WardName,''))=0 
		
			UPDATE @tempWards SET IsValid=0  WHERE  LEN(ISNULL(WardName,''))=0 
		
			--Check for Duplicates in file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Ward Code ' + QUOTENAME(WardCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(WardCode)) + ' times in the file', N'C'  FROM @tempWards GROUP BY WardCode HAVING COUNT(WardCode) >1 
		
			UPDATE W SET IsValid = 0 FROM @tempWards W
			WHERE WardCode in (SELECT WardCode from @tempWards GROUP BY WardCode HAVING COUNT(WardCode) >1)

			--check the length of the wardcode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Ward Code ' + QUOTENAME(WardCode) + N' is greater than 50', N'E' FROM @tempWards WHERE  LEN(ISNULL(WardCode,''))>50
		
			UPDATE @tempWards SET IsValid=0  WHERE LEN(ISNULL(WardCode,''))>50

			--check the length of the wardname
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Ward Name ' + QUOTENAME(WardName) + N' is greater than 50', N'E' FROM @tempWards WHERE  LEN(ISNULL(WardName,''))>50
		
			UPDATE @tempWards SET IsValid=0  WHERE LEN(ISNULL(WardName,''))>50
		
			/********************************WARDS ENDS******************************/

			/********************************VILLAGE STARTS******************************/
			--check if the village has Wardcoce
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(VillageCode) + N' has empty Ward Code', N'E' FROM @tempVillages WHERE  LEN(ISNULL(WardCode,''))=0 
		
			UPDATE @tempVillages SET IsValid=0  WHERE  LEN(ISNULL(WardCode,''))=0 

			--check if the village has valid wardcode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(VillageCode) + N' has invalid Ward Code', N'E' FROM @tempVillages TV
			LEFT OUTER JOIN @tempWards TW ON  TW.WardCode=TV.WardCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TW.WardCode IS NULL
			AND LEN(TV.WardCode)>0
			AND LEN(TV.VillageCode) >0

			UPDATE TV SET TV.IsValid=0 FROM @tempVillages TV
			LEFT OUTER JOIN @tempWards TW ON  TW.WardCode=TV.WardCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TW.WardCode IS NULL
			AND LEN(TV.WardCode)>0
			AND LEN(TV.VillageCode) >0

			--check if the villagecode is null 
			IF EXISTS(
			SELECT  1 FROM @tempVillages WHERE  LEN(ISNULL(VillageCode,''))=0 
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(1)) + N' Village(s) have empty Village code', N'E' FROM @tempVillages WHERE  LEN(ISNULL(VillageCode,''))=0 
		
			UPDATE @tempVillages SET IsValid=0  WHERE  LEN(ISNULL(VillageCode,''))=0 
		
			--check if the villageName is null 
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(VillageCode) + N' has empty name', N'E' FROM @tempVillages WHERE  LEN(ISNULL(VillageName,''))=0 
		
			UPDATE @tempVillages SET IsValid=0  WHERE  LEN(ISNULL(VillageName,''))=0 
		
			--Check for Duplicates in file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(VillageCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(VillageCode)) + ' times in the file', N'C'  FROM @tempVillages GROUP BY VillageCode HAVING COUNT(VillageCode) >1 
		
			UPDATE V SET IsValid = 0 FROM @tempVillages V
			WHERE VillageCode in (SELECT VillageCode from @tempVillages GROUP BY VillageCode HAVING COUNT(VillageCode) >1)

			--check the length of the VillageCode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Village Code ' + QUOTENAME(VillageCode) + N' is greater than 50', N'E' FROM @tempVillages WHERE  LEN(ISNULL(VillageCode,''))>50
		
			UPDATE @tempVillages SET IsValid=0  WHERE LEN(ISNULL(VillageCode,''))>50

			--check the length of the VillageName
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Village Name ' + QUOTENAME(VillageName) + N' is greater than 50', N'E' FROM @tempVillages WHERE  LEN(ISNULL(VillageName,''))>50
		
			UPDATE @tempVillages SET IsValid=0  WHERE LEN(ISNULL(VillageName,''))>50

			--check the validity of the malepopulation
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'The Village Code' + QUOTENAME(VillageCode) + N' has invalid Male polulation', N'E' FROM @tempVillages WHERE  MalePopulation<0
		
			UPDATE @tempVillages SET IsValid=0  WHERE MalePopulation<0

			--check the validity of the female population
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'The Village Code' + QUOTENAME(VillageCode) + N' has invalid Female polulation', N'E' FROM @tempVillages WHERE  FemalePopulation<0
		
			UPDATE @tempVillages SET IsValid=0  WHERE FemalePopulation<0

			--check the validity of the OtherPopulation
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'The Village Code' + QUOTENAME(VillageCode) + N' has invalid Others polulation', N'E' FROM @tempVillages WHERE  OtherPopulation<0
		
			UPDATE @tempVillages SET IsValid=0  WHERE OtherPopulation<0

			--check the validity of the number of families
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'The Village Code' + QUOTENAME(VillageCode) + N' has invalid Number of  Families', N'E' FROM @tempVillages WHERE  Families<0
		
			UPDATE @tempVillages SET IsValid=0  WHERE Families<0

		
			/********************************VILLAGE ENDS******************************/
			/*========================================================================================================
			VALIDATION ENDS
			========================================================================================================*/	
	
			/*========================================================================================================
			COUNTS START
			========================================================================================================*/	
					IF @StratergyId =1 OR @StratergyId =2
						BEGIN
							--Regions insert
							SELECT @InsertRegion=COUNT(1) FROM @tempRegion TR 
							LEFT OUTER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
							WHERE
							TR.IsValid=1
							AND L.ValidityTo IS NULL
							AND L.LocationCode IS NULL

						--Districts insert
							SELECT @InsertDistrict=COUNT(1) FROM @tempDistricts TD 
							LEFT OUTER JOIN tblLocations L ON L.LocationCode=TD.DistrictCode AND L.LocationType='D'
							WHERE
							TD.IsValid=1
							AND L.ValidityTo IS NULL
							AND L.LocationCode IS NULL

						--Wards insert
							SELECT @InsertWard=COUNT(1) FROM @tempWards TW 
							LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W'
							WHERE
							TW.IsValid=1
							AND L.ValidityTo IS NULL
							AND L.LocationCode IS NULL

						--Villages insert
							SELECT @InsertVillage=COUNT(1) FROM @tempVillages TV 
							LEFT OUTER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='V'
							WHERE
							TV.IsValid=1
							AND L.ValidityTo IS NULL
							AND L.LocationCode IS NULL
						END
			

					IF @StratergyId=2
						BEGIN
							--Regions updates
								SELECT @UpdateRegion=COUNT(1) FROM @tempRegion TR 
								INNER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
								WHERE
								TR.IsValid=1
								AND L.ValidityTo IS NULL
							
							--Districts updates
								SELECT @UpdateDistrict=COUNT(1) FROM @tempDistricts TD 
								INNER JOIN tblLocations L ON L.LocationCode=TD.DistrictCode AND L.LocationType='D'
								WHERE
								TD.IsValid=1
								AND L.ValidityTo IS NULL

							--Wards updates
								SELECT @UpdateWard=COUNT(1) FROM @tempWards TW 
								INNER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W'
								WHERE
								TW.IsValid=1
								AND L.ValidityTo IS NULL

							--Villages updates
								SELECT @UpdateVillage=COUNT(1) FROM @tempVillages TV 
								INNER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='V'
								WHERE
								TV.IsValid=1
								AND L.ValidityTo IS NULL
						END

			/*========================================================================================================
			COUNTS ENDS
			========================================================================================================*/	
		
			
				IF @DryRun =0
					BEGIN
						BEGIN TRAN UPLOAD

						
			/*========================================================================================================
			UPDATE STARTS
			========================================================================================================*/	
					IF @StratergyId=2
							BEGIN
							/********************************REGIONS******************************/
								--insert historocal record(s)
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[ValidityTo] ,[LegacyId],[AuditUserId],[MalePopulation] ,[FemalePopulation],[OtherPopulation],[Families])
									SELECT L.LocationCode, L.LocationName,L.ParentLocationId,L.LocationType, L.ValidityFrom,GETDATE(),L.LocationId,@AuditUserId AuditUserId, L.MalePopulation, L.FemalePopulation, L.OtherPopulation,L.Families 
									FROM @tempRegion TR 
									INNER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
									WHERE TR.IsValid=1 AND L.ValidityTo IS NULL

								--update
									UPDATE L SET  L.LocationName=TR.RegionName
									FROM @tempRegion TR 
									INNER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
									WHERE TR.IsValid=1 AND L.ValidityTo IS NULL

									/********************************REGIONS******************************/
								--Insert historical records
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[ValidityTo] ,[LegacyId],[AuditUserId],[MalePopulation] ,[FemalePopulation],[OtherPopulation],[Families])
										SELECT L.LocationCode, L.LocationName,L.ParentLocationId,L.LocationType, L.ValidityFrom,GETDATE(),L.LocationId,@AuditUserId AuditUserId, L.MalePopulation, L.FemalePopulation, L.OtherPopulation,L.Families 
										FROM @tempDistricts TD 
										INNER JOIN tblLocations L ON L.LocationCode=TD.DistrictCode AND L.LocationType='D'
										WHERE TD.IsValid=1 AND L.ValidityTo IS NULL

									--update
										UPDATE L SET L.LocationName=TD.DistrictCode
										FROM @tempDistricts TD 
										INNER JOIN tblLocations L ON L.LocationCode=TD.DistrictCode AND L.LocationType='D'
										WHERE TD.IsValid=1 AND L.ValidityTo IS NULL

										/********************************WARD******************************/
								--Insert historical records
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[ValidityTo] ,[LegacyId],[AuditUserId],[MalePopulation] ,[FemalePopulation],[OtherPopulation],[Families])
										SELECT L.LocationCode, L.LocationName,L.ParentLocationId,L.LocationType, L.ValidityFrom,GETDATE(),L.LocationId,@AuditUserId AuditUserId, L.MalePopulation, L.FemalePopulation, L.OtherPopulation,L.Families 
										FROM @tempWards TW 
										INNER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W'
										WHERE TW.IsValid=1 AND L.ValidityTo IS NULL

								--Update
									UPDATE L SET L.LocationName=TW.WardName
										FROM @tempWards TW 
										INNER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W'
										WHERE TW.IsValid=1 AND L.ValidityTo IS NULL

									  
										/********************************WARD******************************/
								--Insert historical records
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[ValidityTo] ,[LegacyId],[AuditUserId],[MalePopulation] ,[FemalePopulation],[OtherPopulation],[Families])
										SELECT L.LocationCode, L.LocationName,L.ParentLocationId,L.LocationType, L.ValidityFrom,GETDATE(),L.LocationId,@AuditUserId AuditUserId, L.MalePopulation, L.FemalePopulation, L.OtherPopulation,L.Families 
										FROM @tempVillages TV 
										INNER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='V'
										WHERE TV.IsValid=1 AND L.ValidityTo IS NULL

								--Update
									UPDATE L  SET L.LocationName=TV.VillageName, L.MalePopulation=TV.MalePopulation, L.FemalePopulation=TV.FemalePopulation, L.OtherPopulation=TV.OtherPopulation, L.Families=TV.Families
										FROM @tempVillages TV 
										INNER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='V'
										WHERE TV.IsValid=1 AND L.ValidityTo IS NULL

							END
			/*========================================================================================================
			UPDATE ENDS
			========================================================================================================*/	

			/*========================================================================================================
			INSERT STARTS
			========================================================================================================*/	
						IF @StratergyId=1 OR @StratergyId=2
							BEGIN
							
								--insert Region(s)
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[LocationType],[ValidityFrom],[AuditUserId])
									SELECT TR.RegionCode, TR.RegionName,'R',GETDATE(), @AuditUserId AuditUserId FROM @tempRegion TR 
									LEFT OUTER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
									WHERE
									TR.IsValid=1
									AND L.ValidityTo IS NULL
									AND L.LocationCode IS NULL

								--Insert District(s)
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[AuditUserId])
									SELECT TD.DistrictCode, TD.DistrictName, L.LocationId, 'D', GETDATE(), @AuditUserId AuditUserId FROM @tempDistricts TD 
									LEFT OUTER JOIN tblLocations L ON L.LocationCode=TD.RegionCode AND L.LocationType='R'
									WHERE
									TD.IsValid=1
									AND L.ValidityTo IS NULL
									AND L.LocationCode IS NULL

							--Insert Wards
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[AuditUserId])
									SELECT TW.WardCode, TW.WardName, L.LocationId, 'W',GETDATE(), @AuditUserId AuditUserId FROM @tempWards TW 
									LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='D'
									WHERE
									TW.IsValid=1
									AND L.ValidityTo IS NULL
									AND L.LocationCode IS NULL


							--insert  villages
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType], [MalePopulation],[FemalePopulation],[OtherPopulation],[Families], [ValidityFrom],[AuditUserId])
									SELECT TV.VillageCode,TV.VillageName,L.LocationId,'V',TV.MalePopulation,TV.FemalePopulation,TV.OtherPopulation,TV.Families,GETDATE(), @AuditUserId AuditUserId
									FROM @tempVillages TV 
									LEFT OUTER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='W'
									WHERE
									TV.IsValid=1
									AND L.ValidityTo IS NULL
									AND L.LocationCode IS NULL

							END
			/*========================================================================================================
			INSERT ENDS
			========================================================================================================*/	
							

						COMMIT TRAN UPLOAD
					END
		
			
		
		END TRY
		BEGIN CATCH
			DECLARE @InvalidXML NVARCHAR(100)
			IF ERROR_NUMBER()=245 
				BEGIN
					SET @InvalidXML='Invalid input in either MalePopulation, FemalePopulation, OtherPopulation or Number of Families '
					INSERT INTO @tblResult(Result, ResultType)
					SELECT @InvalidXML, N'FE';
				END
			ELSE  IF ERROR_NUMBER()=9436 
				BEGIN
					SET @InvalidXML='Invalid XML file, end tag does not match start tag'
					INSERT INTO @tblResult(Result, ResultType)
					SELECT @InvalidXML, N'FE';
				END
			ELSE
				INSERT INTO @tblResult(Result, ResultType)
				SELECT'Invalid XML file', N'FE';

			IF @@TRANCOUNT > 0 ROLLBACK TRAN UPLOAD;
			SELECT * FROM @tblResult
			RETURN -1;
				
		END CATCH
		SELECT * FROM @tblResult
		RETURN 0;
	END


GO

IF NOT OBJECT_ID('uspUploadHFXML') IS NULL
DROP PROCEDURE [dbo].[uspUploadHFXML]
GO

CREATE PROCEDURE [dbo].[uspUploadHFXML]
(
	@File NVARCHAR(300),
	@StratergyId INT,	--1	: Insert Only,	2: Insert & Update	3: Insert, Update & Delete
	@AuditUserID INT = -1,
	@DryRun BIT=0,
	@SentHF INT = 0 OUTPUT,
	@Inserts INT  = 0 OUTPUT,
	@Updates INT  = 0 OUTPUT,
	@sentCatchment INT =0 OUTPUT,
	@InsertCatchment INT =0 OUTPUT,
	@UpdateCatchment INT =0 OUTPUT
)
AS
BEGIN

	/* Result type in @tblResults
	-------------------------------
		E	:	Error
		C	:	Conflict
		FE	:	Fatal Error

	Return Values
	------------------------------
		0	:	All Okay
		-1	:	Fatal error
	*/
	

	DECLARE @Query NVARCHAR(500)
	DECLARE @XML XML
	DECLARE @tblHF TABLE(LegalForms NVARCHAR(15), [Level] NVARCHAR(15)  NULL, SubLevel NVARCHAR(15), Code NVARCHAR (50) NULL, Name NVARCHAR (101) NULL, [Address] NVARCHAR (101), DistrictCode NVARCHAR (50) NULL,Phone NVARCHAR (51), Fax NVARCHAR (51), Email NVARCHAR (51), CareType CHAR (15) NULL, AccountCode NVARCHAR (26), IsValid BIT )
	DECLARE @tblResult TABLE(Result NVARCHAR(Max), ResultType NVARCHAR(2))
	DECLARE @tblCatchment TABLE(HFCode NVARCHAR(50), VillageCode NVARCHAR(50),Percentage INT, IsValid BIT )

	BEGIN TRY
		IF @AuditUserID IS NULL
			SET @AuditUserID=-1

		SET @Query = (N'SELECT @XML = CAST(X as XML) FROM OPENROWSET(BULK  '''+ @File +''' ,SINGLE_BLOB) AS T(X)')

		EXECUTE SP_EXECUTESQL @Query,N'@XML XML OUTPUT',@XML OUTPUT


		--GET ALL THE HF FROM THE XML
		INSERT INTO @tblHF(LegalForms,[Level],SubLevel,Code,Name,[Address],DistrictCode,Phone,Fax,Email,CareType,AccountCode,IsValid)
		SELECT 
		NULLIF(T.F.value('(LegalForm)[1]','NVARCHAR(15)'),''),
		NULLIF(T.F.value('(Level)[1]','NVARCHAR(15)'),''),
		NULLIF(T.F.value('(SubLevel)[1]','NVARCHAR(15)'),''),
		T.F.value('(Code)[1]','NVARCHAR(50)'),
		T.F.value('(Name)[1]','NVARCHAR(101)'),
		T.F.value('(Address)[1]','NVARCHAR(101)'),
		NULLIF(T.F.value('(DistrictCode)[1]','NVARCHAR(50)'),''),
		T.F.value('(Phone)[1]','NVARCHAR(51)'),
		T.F.value('(Fax)[1]','NVARCHAR(51)'),
		T.F.value('(Email)[1]','NVARCHAR(51)'),
		NULLIF(T.F.value('(CareType)[1]','NVARCHAR(15)'),''),
		T.F.value('(AccountCode)[1]','NVARCHAR(26)'),
		1
		FROM @XML.nodes('HealthFacilities/HealthFacilityDetails/HealthFacility') AS T(F)

		SELECT @SentHF=@@ROWCOUNT


		INSERT INTO @tblCatchment(HFCode,VillageCode,Percentage,IsValid)
		SELECT 
		C.CT.value('(HFCode)[1]','NVARCHAR(50)'),
		C.CT.value('(VillageCode)[1]','NVARCHAR(50)'),
		C.CT.value('(Percentage)[1]','INT'),
		1
		FROM @XML.nodes('HealthFacilities/CatchmentDetails/Catchment') AS C(CT)

		SELECT @sentCatchment=@@ROWCOUNT

		/*========================================================================================================
		VALIDATION STARTS
		========================================================================================================*/	
		--Invalidate empty code or empty name 
			IF EXISTS(
				SELECT 1
				FROM @tblHF HF 
				WHERE LEN(ISNULL(HF.Code, '')) = 0
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT CONVERT(NVARCHAR(3), COUNT(HF.Code)) + N' HF(s) have empty code', N'E'
			FROM @tblHF HF 
			WHERE LEN(ISNULL(HF.Code, '')) = 0

			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty name field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Name, '')) = 0


			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Name, '')) = 0 OR LEN(ISNULL(HF.Code, '')) = 0

			--Ivalidate empty Legal Forms
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty LegaForms field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.LegalForms, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.LegalForms, '')) = 0 


			--Ivalidate empty Level
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty Level field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Level, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Level, '')) = 0 

			--Ivalidate empty District Code
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty District Code field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.DistrictCode, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.DistrictCode, '')) = 0 OR LEN(ISNULL(HF.Code, '')) = 0

				--Ivalidate empty Care Type
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty Care Type field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.CareType, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.CareType, '')) = 0 OR LEN(ISNULL(HF.Code, '')) = 0


			--Invalidate HF with duplicate Codes
			IF EXISTS(SELECT 1 FROM @tblHF  GROUP BY Code HAVING COUNT(Code) >1)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT QUOTENAME(Code) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(Code)) + ' times in the file', N'C'
			FROM @tblHF  GROUP BY Code HAVING COUNT(Code) >1

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE code in (SELECT code from @tblHF GROUP BY Code HAVING COUNT(Code) >1)

			--Invalidate HF with invalid Legal Forms
			INSERT INTO @tblResult(Result,ResultType)
			SELECT 'HF Code '+QUOTENAME(Code) +' has invalid Legal Form', N'E'  FROM @tblHF HF LEFT OUTER JOIN tblLegalForms LF ON HF.LegalForms = LF.LegalFormCode 	WHERE LF.LegalFormCode IS NULL AND NOT HF.LegalForms IS NULL
			
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN tblLegalForms LF ON HF.LegalForms = LF.LegalFormCode 	WHERE LF.LegalFormCode IS NULL AND NOT HF.LegalForms IS NULL)


			--Ivalidate HF with invalid Disrict Code
			IF EXISTS(SELECT 1  FROM @tblHF HF 	LEFT OUTER JOIN tblLocations L ON L.LocationCode=HF.DistrictCode AND L.ValidityTo IS NULL	WHERE	L.LocationCode IS NULL AND NOT HF.DistrictCode IS NULL)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has invalid District Code', N'E'
			FROM @tblHF HF 	LEFT OUTER JOIN tblLocations L ON L.LocationCode=HF.DistrictCode AND L.ValidityTo IS NULL	WHERE L.LocationCode IS NULL AND NOT HF.DistrictCode IS NULL
	
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE HF.DistrictCode IN (SELECT HF.DistrictCode  FROM @tblHF HF 	LEFT OUTER JOIN tblLocations L ON L.LocationCode=HF.DistrictCode AND L.ValidityTo IS NULL WHERE  L.LocationCode IS NULL)

			--Invalidate HF with invalid Level
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+ QUOTENAME(HF.Code)+' has invalid Level', N'E'   FROM @tblHF HF LEFT OUTER JOIN (SELECT HFLevel FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFLevel) L ON HF.Level = L.HFLevel WHERE L.HFLevel IS NULL AND NOT HF.Level IS NULL
			
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF 
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN (SELECT HFLevel FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFLevel) L ON HF.Level = L.HFLevel WHERE L.HFLevel IS NULL AND NOT HF.Level IS NULL)
			
			--Invalidate HF with invalid SubLevel
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+QUOTENAME(HF.Code) +' has invalid SubLevel' ,N'E'  FROM @tblHF HF LEFT OUTER JOIN tblHFSublevel HSL ON HSL.HFSublevel= HF.SubLevel WHERE HSL.HFSublevel IS NULL AND NOT HF.SubLevel IS NULL
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF 
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN tblHFSublevel HSL ON HSL.HFSublevel= HF.SubLevel WHERE HSL.HFSublevel IS NULL AND NOT HF.SubLevel IS NULL)

			--Remove HF with invalid CareType
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+QUOTENAME(HF.Code) +' has invalid CareType',N'E'   FROM @tblHF HF LEFT OUTER JOIN (SELECT HFCareType FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFCareType) CT ON HF.CareType = CT.HFCareType WHERE CT.HFCareType IS NULL AND NOT HF.CareType IS NULL
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF 
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN (SELECT HFCareType FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFCareType) CT ON HF.CareType = CT.HFCareType WHERE CT.HFCareType IS NULL)


			--Check if any HF Code is greater than 8 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Code ' + QUOTENAME(HF.Code) + ' is greater than 8 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Code) > 8;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Code) > 8;

			--Check if any HF Name is greater than 100 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Name ' + QUOTENAME(HF.Code) + ' is greater than 100 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Name) > 100;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Name) > 100;


			--Check if any HF Address is greater than 100 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Address ' + QUOTENAME(HF.Code) + ' is greater than 100 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Address) > 100;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Address) > 100;

			--Check if any HF Phone is greater than 50 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Phone ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Phone) > 50;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Phone) > 50;

			--Check if any HF Fax is greater than 50 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Fax ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Fax) > 50;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Fax) > 50;

			--Check if any HF Email is greater than 50 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Email ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Email) > 50;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Email) > 50;

			--Check if any HF AccountCode is greater than 25 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Account Code ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.AccountCode) > 25;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.AccountCode) > 25;

			--Invalidate Catchment with empy HFCode
		IF EXISTS(SELECT  1 FROM @tblCatchment WHERE LEN(ISNULL(HFCode,''))=0)
		INSERT INTO @tblResult(Result,ResultType)
		SELECT  CONVERT(NVARCHAR(3), COUNT(HFCode)) + N' Catchment(s) have empty HFcode', N'E' FROM @tblCatchment WHERE LEN(ISNULL(HFCode,''))=0
		UPDATE @tblCatchment SET IsValid = 0 WHERE LEN(ISNULL(HFCode,''))=0

		--Invalidate Catchment with invalid HFCode
		INSERT INTO @tblResult(Result,ResultType)
		SELECT N'Invalid HF Code ' + QUOTENAME(C.HFCode) + N' in catchment section', N'E' FROM @tblCatchment C LEFT OUTER JOIN @tblHF HF ON C.HFCode=HF.Code WHERE HF.Code IS NULL
		UPDATE C SET C.IsValid =0 FROM @tblCatchment C LEFT OUTER JOIN @tblHF HF ON C.HFCode=HF.Code WHERE HF.Code IS NULL
		
		--Invalidate Catchment with empy VillageCode
		INSERT INTO @tblResult(Result,ResultType)
		SELECT N'HF Code ' + QUOTENAME(HFCode) + N' in catchment section have empty VillageCode', N'E' FROM @tblCatchment WHERE LEN(ISNULL(VillageCode,''))=0
		UPDATE @tblCatchment SET IsValid = 0 WHERE LEN(ISNULL(VillageCode,''))=0

		--Invalidate Catchment with invalid VillageCode
		INSERT INTO @tblResult(Result,ResultType)
		SELECT N'Invalid Village Code ' + QUOTENAME(C.VillageCode) + N' in catchment section', N'E' FROM @tblCatchment C LEFT OUTER JOIN tblLocations L ON L.LocationCode=C.VillageCode WHERE L.ValidityTo IS NULL AND L.LocationCode IS NULL AND LEN(ISNULL(VillageCode,''))>0
		UPDATE C SET IsValid=0 FROM @tblCatchment C LEFT OUTER JOIN tblLocations L ON L.LocationCode=C.VillageCode WHERE L.ValidityTo IS NULL AND L.LocationCode IS NULL
		
		--Invalidate Catchment with empy percentage
		INSERT INTO @tblResult(Result,ResultType)
		SELECT  N'HF Code ' + QUOTENAME(HFCode) + N' in catchment section has empty percentage', N'E' FROM @tblCatchment WHERE Percentage=0
		UPDATE @tblCatchment SET IsValid = 0 WHERE Percentage=0

		--Invalidate Catchment with invalid percentage
		INSERT INTO @tblResult(Result,ResultType)
		SELECT  N'HF Code ' + QUOTENAME(HFCode) + N' in catchment section has invalid percentage', N'E' FROM @tblCatchment WHERE Percentage<0 OR Percentage >100
		UPDATE @tblCatchment SET IsValid = 0 WHERE Percentage<0 OR Percentage >100


			--Get the counts
			--To be udpated
			IF @StratergyId=2
				BEGIN
					SELECT @Updates=COUNT(1) FROM @tblHF TempHF
					INNER JOIN tblHF HF ON HF.HFCode=TempHF.Code AND HF.ValidityTo IS NULL
					WHERE TempHF.IsValid=1

					SELECT @UpdateCatchment =COUNT(1) FROM @tblCatchment C 
					INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
					INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
					INNER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
					WHERE 
					C.IsValid =1
					AND L.ValidityTo IS NULL
					AND HF.ValidityTo IS NULL
					AND HFC.ValidityTo IS NULL
				END
			
			--To be Inserted
			SELECT @Inserts=COUNT(1) FROM @tblHF TempHF
			LEFT OUTER JOIN tblHF HF ON HF.HFCode=TempHF.Code AND HF.ValidityTo IS NULL
			WHERE TempHF.IsValid=1
			AND HF.HFCode IS NULL

			SELECT @InsertCatchment=COUNT(1) FROM @tblCatchment C 
			INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
			INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
			LEFT OUTER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
			WHERE 
			C.IsValid =1
			AND L.ValidityTo IS NULL
			AND HF.ValidityTo IS NULL
			AND HFC.ValidityTo IS NULL
			AND HFC.LocationId IS NULL
			AND HFC.HFID IS NULL
			
		/*========================================================================================================
		VALIDATION ENDS
		========================================================================================================*/	
		IF @DryRun=0
		BEGIN
			BEGIN TRAN UPLOAD
				
			/*========================================================================================================
			UDPATE STARTS
			========================================================================================================*/	
			IF @StratergyId = 2
				BEGIN

			--HF
				--Make a copy of the original record
					INSERT INTO tblHF(HFCode, HFName,[LegalForm],[HFLevel],[HFSublevel],[HFAddress],[LocationId],[Phone],[Fax],[eMail],[HFCareType],[PLServiceID],[PLItemID],[AccCode],[OffLine],[ValidityFrom],[ValidityTo],LegacyID, AuditUserId)
					SELECT HF.[HFCode] ,HF.[HFName],HF.[LegalForm],HF.[HFLevel],HF.[HFSublevel],HF.[HFAddress],HF.[LocationId],HF.[Phone],HF.[Fax],HF.[eMail],HF.[HFCareType],HF.[PLServiceID],HF.[PLItemID],HF.[AccCode],HF.[OffLine],[ValidityFrom],GETDATE()[ValidityTo],HF.HfID, @AuditUserID AuditUserId 
					FROM tblHF HF
					INNER JOIN @tblHF TempHF  ON TempHF.Code=HF.HFCode
					WHERE HF.ValidityTo IS NULL
					AND TempHF.IsValid = 1;

					SELECT @Updates = @@ROWCOUNT;
				--Upadte the record
					UPDATE HF SET HF.HFName = TempHF.Name, HF.LegalForm=TempHF.LegalForms,HF.HFLevel=TempHF.Level, HF.HFSublevel=TempHF.SubLevel,HF.HFAddress=TempHF.Address,HF.LocationId=L.LocationId, HF.Phone=TempHF.Phone, HF.Fax=TempHF.Fax, HF.eMail=TempHF.Email,HF.HFCareType=TempHF.CareType, HF.AccCode=TempHF.AccountCode, HF.OffLine=0, HF.ValidityFrom=GETDATE(), AuditUserID = @AuditUserID
					FROM tblHF HF
					INNER JOIN @tblHF TempHF  ON HF.HFCode=TempHF.Code
					INNER JOIN tblLocations L ON L.LocationCode=TempHF.DistrictCode
					WHERE HF.ValidityTo IS NULL
					AND L.ValidityTo IS NULL
					AND TempHF.IsValid = 1;

			--CATCHMENT
					--Make a copy of the original record
					INSERT INTO [tblHFCatchment]([HFID],[LocationId],[Catchment],[ValidityFrom],ValidityTo,[LegacyId],AuditUserId)		
					SELECT HFC.HfID,HFC.LocationId, HFC.Catchment,HFC.ValidityFrom, GETDATE() ValidityTo,HFC.HFCatchmentId, HFC.AuditUserId FROM @tblCatchment C 
					INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
					INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
					INNER JOIN @tblHF tempHF ON tempHF.Code=C.HFCode
					INNER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
					WHERE 
					C.IsValid =1
					AND tempHF.IsValid=1
					AND L.ValidityTo IS NULL
					AND HF.ValidityTo IS NULL
					AND HFC.ValidityTo IS NULL

					SELECT @UpdateCatchment =@@ROWCOUNT

					--Upadte the record
					UPDATE HFC SET HFC.HFID= HF.HfID,HFC.LocationId= L.LocationId, HFC.Catchment =C.Percentage,HFC.ValidityFrom=GETDATE(),  HFC.AuditUserId=@AuditUserID FROM @tblCatchment C 
					INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
					INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
					INNER JOIN @tblHF tempHF ON tempHF.Code=C.HFCode
					INNER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
					WHERE 
					C.IsValid =1
					AND tempHF.IsValid=1
					AND L.ValidityTo IS NULL
					AND HF.ValidityTo IS NULL
					AND HFC.ValidityTo IS NULL
				END
			/*========================================================================================================
			UPDATE ENDS
			========================================================================================================*/	


			/*========================================================================================================
			INSERT STARTS
			========================================================================================================*/	

			--INSERT HF
				INSERT INTO tblHF(HFCode, HFName,[LegalForm],[HFLevel],[HFSublevel],[HFAddress],[LocationId],[Phone],[Fax],[eMail],[HFCareType],[AccCode],[OffLine],[ValidityFrom],AuditUserId)
				SELECT TempHF.[Code] ,TempHF.[Name],TempHF.[LegalForms],TempHF.[Level],TempHF.[Sublevel],TempHF.[Address],L.LocationId,TempHF.[Phone],TempHF.[Fax],TempHF.[Email],TempHF.[CareType],TempHF.[AccountCode],0 [OffLine],GETDATE()[ValidityFrom], @AuditUserID AuditUserId 
				FROM @tblHF TempHF 
				LEFT OUTER JOIN tblHF HF  ON TempHF.Code=HF.HFCode
				INNER JOIN tblLocations L ON L.LocationCode=TempHF.DistrictCode
				WHERE HF.ValidityTo IS NULL
				AND L.ValidityTo IS NULL
				AND HF.HFCode IS NULL
				AND TempHF.IsValid = 1;
	
				SELECT @Inserts = @@ROWCOUNT;

				--INSERT CATCHMENT
				INSERT INTO [tblHFCatchment]([HFID],[LocationId],[Catchment],[ValidityFrom],[AuditUserId])
				SELECT HF.HfID,L.LocationId, C.Percentage, GETDATE() ValidityFrom, @AuditUserId FROM @tblCatchment C 
				INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
				INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
				INNER JOIN @tblHF tempHF ON tempHF.Code=C.HFCode
				LEFT OUTER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
				WHERE 
				C.IsValid =1
				AND tempHF.IsValid=1
				AND L.ValidityTo IS NULL
				AND HF.ValidityTo IS NULL
				AND HFC.ValidityTo IS NULL
				AND HFC.LocationId IS NULL
				AND HFC.HFID IS NULL
				
				SELECT @InsertCatchment=@@ROWCOUNT
				

			/*========================================================================================================
			INSERT ENDS
			========================================================================================================*/	

			COMMIT TRAN UPLOAD
		END

		
	END TRY
	BEGIN CATCH
		DECLARE @InvalidXML NVARCHAR(100)
		IF ERROR_NUMBER()=9436 
		BEGIN
			SET @InvalidXML='Invalid XML file, end tag does not match start tag'
			INSERT INTO @tblResult(Result, ResultType)
			SELECT @InvalidXML, N'FE';
		END
		ELSE
			INSERT INTO @tblResult(Result, ResultType)
			SELECT'Invalid XML file', N'FE';


		IF @@TRANCOUNT > 0 ROLLBACK TRAN UPLOAD;
		SELECT * FROM @tblResult;
		RETURN -1;
	END CATCH

	SELECT * FROM @tblResult;
	RETURN 0;
END



GO

--ON 07/04/2018

IF NOT OBJECT_ID('uspUploadHFXML') IS NULL
DROP PROCEDURE [dbo].[uspUploadHFXML]
GO

CREATE PROCEDURE [dbo].[uspUploadHFXML]
(
	@File NVARCHAR(300),
	@StratergyId INT,	--1	: Insert Only,	2: Insert & Update	3: Insert, Update & Delete
	@AuditUserID INT = -1,
	@DryRun BIT=0,
	@SentHF INT = 0 OUTPUT,
	@Inserts INT  = 0 OUTPUT,
	@Updates INT  = 0 OUTPUT
	--@sentCatchment INT =0 OUTPUT,
	--@InsertCatchment INT =0 OUTPUT,
	--@UpdateCatchment INT =0 OUTPUT
)
AS
BEGIN

	/* Result type in @tblResults
	-------------------------------
		E	:	Error
		C	:	Conflict
		FE	:	Fatal Error

	Return Values
	------------------------------
		0	:	All Okay
		-1	:	Fatal error
	*/
	

	DECLARE @Query NVARCHAR(500)
	DECLARE @XML XML
	DECLARE @tblHF TABLE(LegalForms NVARCHAR(15), [Level] NVARCHAR(15)  NULL, SubLevel NVARCHAR(15), Code NVARCHAR (50) NULL, Name NVARCHAR (101) NULL, [Address] NVARCHAR (101), DistrictCode NVARCHAR (50) NULL,Phone NVARCHAR (51), Fax NVARCHAR (51), Email NVARCHAR (51), CareType CHAR (15) NULL, AccountCode NVARCHAR (26), IsValid BIT )
	DECLARE @tblResult TABLE(Result NVARCHAR(Max), ResultType NVARCHAR(2))
	DECLARE @tblCatchment TABLE(HFCode NVARCHAR(50), VillageCode NVARCHAR(50),Percentage INT, IsValid BIT )

	BEGIN TRY
		IF @AuditUserID IS NULL
			SET @AuditUserID=-1

		SET @Query = (N'SELECT @XML = CAST(X as XML) FROM OPENROWSET(BULK  '''+ @File +''' ,SINGLE_BLOB) AS T(X)')

		EXECUTE SP_EXECUTESQL @Query,N'@XML XML OUTPUT',@XML OUTPUT


		--GET ALL THE HF FROM THE XML
		INSERT INTO @tblHF(LegalForms,[Level],SubLevel,Code,Name,[Address],DistrictCode,Phone,Fax,Email,CareType,AccountCode,IsValid)
		SELECT 
		NULLIF(T.F.value('(LegalForm)[1]','NVARCHAR(15)'),''),
		NULLIF(T.F.value('(Level)[1]','NVARCHAR(15)'),''),
		NULLIF(T.F.value('(SubLevel)[1]','NVARCHAR(15)'),''),
		T.F.value('(Code)[1]','NVARCHAR(50)'),
		T.F.value('(Name)[1]','NVARCHAR(101)'),
		T.F.value('(Address)[1]','NVARCHAR(101)'),
		NULLIF(T.F.value('(DistrictCode)[1]','NVARCHAR(50)'),''),
		T.F.value('(Phone)[1]','NVARCHAR(51)'),
		T.F.value('(Fax)[1]','NVARCHAR(51)'),
		T.F.value('(Email)[1]','NVARCHAR(51)'),
		NULLIF(T.F.value('(CareType)[1]','NVARCHAR(15)'),''),
		T.F.value('(AccountCode)[1]','NVARCHAR(26)'),
		1
		FROM @XML.nodes('HealthFacilities/HealthFacilityDetails/HealthFacility') AS T(F)

		SELECT @SentHF=@@ROWCOUNT


		INSERT INTO @tblCatchment(HFCode,VillageCode,Percentage,IsValid)
		SELECT 
		C.CT.value('(HFCode)[1]','NVARCHAR(50)'),
		C.CT.value('(VillageCode)[1]','NVARCHAR(50)'),
		C.CT.value('(Percentage)[1]','INT'),
		1
		FROM @XML.nodes('HealthFacilities/CatchmentDetails/Catchment') AS C(CT)

		--SELECT @sentCatchment=@@ROWCOUNT


		--SELECT * INTO tempHF FROM @tblHF;
		--SELECT * INTO tempCatchment FROM @tblCatchment;

		--RETURN;

		/*========================================================================================================
		VALIDATION STARTS
		========================================================================================================*/	
		--Invalidate empty code or empty name 
			IF EXISTS(
				SELECT 1
				FROM @tblHF HF 
				WHERE LEN(ISNULL(HF.Code, '')) = 0
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT CONVERT(NVARCHAR(3), COUNT(HF.Code)) + N' HF(s) have empty code', N'E'
			FROM @tblHF HF 
			WHERE LEN(ISNULL(HF.Code, '')) = 0

			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty name field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Name, '')) = 0


			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Name, '')) = 0 OR LEN(ISNULL(HF.Code, '')) = 0

			--Ivalidate empty Legal Forms
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty LegaForms field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.LegalForms, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.LegalForms, '')) = 0 


			--Ivalidate empty Level
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty Level field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Level, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Level, '')) = 0 

			--Ivalidate empty District Code
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty District Code field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.DistrictCode, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.DistrictCode, '')) = 0 OR LEN(ISNULL(HF.Code, '')) = 0

				--Ivalidate empty Care Type
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty Care Type field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.CareType, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.CareType, '')) = 0 OR LEN(ISNULL(HF.Code, '')) = 0


			--Invalidate HF with duplicate Codes
			IF EXISTS(SELECT 1 FROM @tblHF  GROUP BY Code HAVING COUNT(Code) >1)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT QUOTENAME(Code) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(Code)) + ' times in the file', N'C'
			FROM @tblHF  GROUP BY Code HAVING COUNT(Code) >1

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE code in (SELECT code from @tblHF GROUP BY Code HAVING COUNT(Code) >1)

			--Invalidate HF with invalid Legal Forms
			INSERT INTO @tblResult(Result,ResultType)
			SELECT 'HF Code '+QUOTENAME(Code) +' has invalid Legal Form', N'E'  FROM @tblHF HF LEFT OUTER JOIN tblLegalForms LF ON HF.LegalForms = LF.LegalFormCode 	WHERE LF.LegalFormCode IS NULL AND NOT HF.LegalForms IS NULL
			
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN tblLegalForms LF ON HF.LegalForms = LF.LegalFormCode 	WHERE LF.LegalFormCode IS NULL AND NOT HF.LegalForms IS NULL)


			--Ivalidate HF with invalid Disrict Code
			IF EXISTS(SELECT 1  FROM @tblHF HF 	LEFT OUTER JOIN tblLocations L ON L.LocationCode=HF.DistrictCode AND L.ValidityTo IS NULL	WHERE	L.LocationCode IS NULL AND NOT HF.DistrictCode IS NULL)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has invalid District Code', N'E'
			FROM @tblHF HF 	LEFT OUTER JOIN tblLocations L ON L.LocationCode=HF.DistrictCode AND L.ValidityTo IS NULL	WHERE L.LocationCode IS NULL AND NOT HF.DistrictCode IS NULL
	
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE HF.DistrictCode IN (SELECT HF.DistrictCode  FROM @tblHF HF 	LEFT OUTER JOIN tblLocations L ON L.LocationCode=HF.DistrictCode AND L.ValidityTo IS NULL WHERE  L.LocationCode IS NULL)

			--Invalidate HF with invalid Level
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+ QUOTENAME(HF.Code)+' has invalid Level', N'E'   FROM @tblHF HF LEFT OUTER JOIN (SELECT HFLevel FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFLevel) L ON HF.Level = L.HFLevel WHERE L.HFLevel IS NULL AND NOT HF.Level IS NULL
			
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF 
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN (SELECT HFLevel FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFLevel) L ON HF.Level = L.HFLevel WHERE L.HFLevel IS NULL AND NOT HF.Level IS NULL)
			
			--Invalidate HF with invalid SubLevel
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+QUOTENAME(HF.Code) +' has invalid SubLevel' ,N'E'  FROM @tblHF HF LEFT OUTER JOIN tblHFSublevel HSL ON HSL.HFSublevel= HF.SubLevel WHERE HSL.HFSublevel IS NULL AND NOT HF.SubLevel IS NULL
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF 
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN tblHFSublevel HSL ON HSL.HFSublevel= HF.SubLevel WHERE HSL.HFSublevel IS NULL AND NOT HF.SubLevel IS NULL)

			--Remove HF with invalid CareType
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+QUOTENAME(HF.Code) +' has invalid CareType',N'E'   FROM @tblHF HF LEFT OUTER JOIN (SELECT HFCareType FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFCareType) CT ON HF.CareType = CT.HFCareType WHERE CT.HFCareType IS NULL AND NOT HF.CareType IS NULL
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF 
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN (SELECT HFCareType FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFCareType) CT ON HF.CareType = CT.HFCareType WHERE CT.HFCareType IS NULL)


			--Check if any HF Code is greater than 8 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Code ' + QUOTENAME(HF.Code) + ' is greater than 8 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Code) > 8;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Code) > 8;

			--Check if any HF Name is greater than 100 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Name ' + QUOTENAME(HF.Code) + ' is greater than 100 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Name) > 100;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Name) > 100;


			--Check if any HF Address is greater than 100 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Address ' + QUOTENAME(HF.Code) + ' is greater than 100 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Address) > 100;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Address) > 100;

			--Check if any HF Phone is greater than 50 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Phone ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Phone) > 50;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Phone) > 50;

			--Check if any HF Fax is greater than 50 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Fax ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Fax) > 50;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Fax) > 50;

			--Check if any HF Email is greater than 50 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Email ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Email) > 50;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Email) > 50;

			--Check if any HF AccountCode is greater than 25 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Account Code ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.AccountCode) > 25;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.AccountCode) > 25;

			--Invalidate Catchment with empy HFCode
		IF EXISTS(SELECT  1 FROM @tblCatchment WHERE LEN(ISNULL(HFCode,''))=0)
		INSERT INTO @tblResult(Result,ResultType)
		SELECT  CONVERT(NVARCHAR(3), COUNT(HFCode)) + N' Catchment(s) have empty HFcode', N'E' FROM @tblCatchment WHERE LEN(ISNULL(HFCode,''))=0
		UPDATE @tblCatchment SET IsValid = 0 WHERE LEN(ISNULL(HFCode,''))=0

		--Invalidate Catchment with invalid HFCode
		INSERT INTO @tblResult(Result,ResultType)
		SELECT N'Invalid HF Code ' + QUOTENAME(C.HFCode) + N' in catchment section', N'E' FROM @tblCatchment C LEFT OUTER JOIN @tblHF HF ON C.HFCode=HF.Code WHERE HF.Code IS NULL
		UPDATE C SET C.IsValid =0 FROM @tblCatchment C LEFT OUTER JOIN @tblHF HF ON C.HFCode=HF.Code WHERE HF.Code IS NULL
		
		--Invalidate Catchment with empy VillageCode
		INSERT INTO @tblResult(Result,ResultType)
		SELECT N'HF Code ' + QUOTENAME(HFCode) + N' in catchment section have empty VillageCode', N'E' FROM @tblCatchment WHERE LEN(ISNULL(VillageCode,''))=0
		UPDATE @tblCatchment SET IsValid = 0 WHERE LEN(ISNULL(VillageCode,''))=0

		--Invalidate Catchment with invalid VillageCode
		INSERT INTO @tblResult(Result,ResultType)
		SELECT N'Invalid Village Code ' + QUOTENAME(C.VillageCode) + N' in catchment section', N'E' FROM @tblCatchment C LEFT OUTER JOIN tblLocations L ON L.LocationCode=C.VillageCode WHERE L.ValidityTo IS NULL AND L.LocationCode IS NULL AND LEN(ISNULL(VillageCode,''))>0
		UPDATE C SET IsValid=0 FROM @tblCatchment C LEFT OUTER JOIN tblLocations L ON L.LocationCode=C.VillageCode WHERE L.ValidityTo IS NULL AND L.LocationCode IS NULL
		
		--Invalidate Catchment with empy percentage
		INSERT INTO @tblResult(Result,ResultType)
		SELECT  N'HF Code ' + QUOTENAME(HFCode) + N' in catchment section has empty percentage', N'E' FROM @tblCatchment WHERE Percentage=0
		UPDATE @tblCatchment SET IsValid = 0 WHERE Percentage=0

		--Invalidate Catchment with invalid percentage
		INSERT INTO @tblResult(Result,ResultType)
		SELECT  N'HF Code ' + QUOTENAME(HFCode) + N' in catchment section has invalid percentage', N'E' FROM @tblCatchment WHERE Percentage<0 OR Percentage >100
		UPDATE @tblCatchment SET IsValid = 0 WHERE Percentage<0 OR Percentage >100


			--Get the counts
			--To be udpated
			IF @StratergyId=2
				BEGIN
					SELECT @Updates=COUNT(1) FROM @tblHF TempHF
					INNER JOIN tblHF HF ON HF.HFCode=TempHF.Code AND HF.ValidityTo IS NULL
					WHERE TempHF.IsValid=1

					--SELECT @UpdateCatchment =COUNT(1) FROM @tblCatchment C 
					--INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
					--INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
					--INNER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
					--WHERE 
					--C.IsValid =1
					--AND L.ValidityTo IS NULL
					--AND HF.ValidityTo IS NULL
					--AND HFC.ValidityTo IS NULL
				END
			
			--To be Inserted
			SELECT @Inserts=COUNT(1) FROM @tblHF TempHF
			LEFT OUTER JOIN tblHF HF ON HF.HFCode=TempHF.Code AND HF.ValidityTo IS NULL
			WHERE TempHF.IsValid=1
			AND HF.HFCode IS NULL

			--SELECT @InsertCatchment=COUNT(1) FROM @tblCatchment C 
			--INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
			--INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
			--LEFT OUTER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
			--WHERE 
			--C.IsValid =1
			--AND L.ValidityTo IS NULL
			--AND HF.ValidityTo IS NULL
			--AND HFC.ValidityTo IS NULL
			--AND HFC.LocationId IS NULL
			--AND HFC.HFID IS NULL
			
		/*========================================================================================================
		VALIDATION ENDS
		========================================================================================================*/	
		IF @DryRun=0
		BEGIN
			BEGIN TRAN UPLOAD
				
			/*========================================================================================================
			UDPATE STARTS
			========================================================================================================*/	
			IF @StratergyId = 2
				BEGIN

			--HF
				--Make a copy of the original record
					INSERT INTO tblHF(HFCode, HFName,[LegalForm],[HFLevel],[HFSublevel],[HFAddress],[LocationId],[Phone],[Fax],[eMail],[HFCareType],[PLServiceID],[PLItemID],[AccCode],[OffLine],[ValidityFrom],[ValidityTo],LegacyID, AuditUserId)
					SELECT HF.[HFCode] ,HF.[HFName],HF.[LegalForm],HF.[HFLevel],HF.[HFSublevel],HF.[HFAddress],HF.[LocationId],HF.[Phone],HF.[Fax],HF.[eMail],HF.[HFCareType],HF.[PLServiceID],HF.[PLItemID],HF.[AccCode],HF.[OffLine],[ValidityFrom],GETDATE()[ValidityTo],HF.HfID, @AuditUserID AuditUserId 
					FROM tblHF HF
					INNER JOIN @tblHF TempHF  ON TempHF.Code=HF.HFCode
					WHERE HF.ValidityTo IS NULL
					AND TempHF.IsValid = 1;

					SELECT @Updates = @@ROWCOUNT;
				--Upadte the record
					UPDATE HF SET HF.HFName = TempHF.Name, HF.LegalForm=TempHF.LegalForms,HF.HFLevel=TempHF.Level, HF.HFSublevel=TempHF.SubLevel,HF.HFAddress=TempHF.Address,HF.LocationId=L.LocationId, HF.Phone=TempHF.Phone, HF.Fax=TempHF.Fax, HF.eMail=TempHF.Email,HF.HFCareType=TempHF.CareType, HF.AccCode=TempHF.AccountCode, HF.OffLine=0, HF.ValidityFrom=GETDATE(), AuditUserID = @AuditUserID
					FROM tblHF HF
					INNER JOIN @tblHF TempHF  ON HF.HFCode=TempHF.Code
					INNER JOIN tblLocations L ON L.LocationCode=TempHF.DistrictCode
					WHERE HF.ValidityTo IS NULL
					AND L.ValidityTo IS NULL
					AND TempHF.IsValid = 1;

			--CATCHMENT
					--Make a copy of the original record
					INSERT INTO [tblHFCatchment]([HFID],[LocationId],[Catchment],[ValidityFrom],ValidityTo,[LegacyId],AuditUserId)		
					SELECT HFC.HfID,HFC.LocationId, HFC.Catchment,HFC.ValidityFrom, GETDATE() ValidityTo,HFC.HFCatchmentId, HFC.AuditUserId FROM @tblCatchment C 
					INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
					INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
					INNER JOIN @tblHF tempHF ON tempHF.Code=C.HFCode
					INNER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
					WHERE 
					C.IsValid =1
					AND tempHF.IsValid=1
					AND L.ValidityTo IS NULL
					AND HF.ValidityTo IS NULL
					AND HFC.ValidityTo IS NULL

					--SELECT @UpdateCatchment =@@ROWCOUNT

					--Upadte the record
					UPDATE HFC SET HFC.HFID= HF.HfID,HFC.LocationId= L.LocationId, HFC.Catchment =C.Percentage,HFC.ValidityFrom=GETDATE(),  HFC.AuditUserId=@AuditUserID FROM @tblCatchment C 
					INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
					INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
					INNER JOIN @tblHF tempHF ON tempHF.Code=C.HFCode
					INNER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
					WHERE 
					C.IsValid =1
					AND tempHF.IsValid=1
					AND L.ValidityTo IS NULL
					AND HF.ValidityTo IS NULL
					AND HFC.ValidityTo IS NULL
				END
			/*========================================================================================================
			UPDATE ENDS
			========================================================================================================*/	


			/*========================================================================================================
			INSERT STARTS
			========================================================================================================*/	

			--INSERT HF
				INSERT INTO tblHF(HFCode, HFName,[LegalForm],[HFLevel],[HFSublevel],[HFAddress],[LocationId],[Phone],[Fax],[eMail],[HFCareType],[AccCode],[OffLine],[ValidityFrom],AuditUserId)
				SELECT TempHF.[Code] ,TempHF.[Name],TempHF.[LegalForms],TempHF.[Level],TempHF.[Sublevel],TempHF.[Address],L.LocationId,TempHF.[Phone],TempHF.[Fax],TempHF.[Email],TempHF.[CareType],TempHF.[AccountCode],0 [OffLine],GETDATE()[ValidityFrom], @AuditUserID AuditUserId 
				FROM @tblHF TempHF 
				LEFT OUTER JOIN tblHF HF  ON TempHF.Code=HF.HFCode
				INNER JOIN tblLocations L ON L.LocationCode=TempHF.DistrictCode
				WHERE HF.ValidityTo IS NULL
				AND L.ValidityTo IS NULL
				AND HF.HFCode IS NULL
				AND TempHF.IsValid = 1;
	
				SELECT @Inserts = @@ROWCOUNT;

				--INSERT CATCHMENT
				INSERT INTO [tblHFCatchment]([HFID],[LocationId],[Catchment],[ValidityFrom],[AuditUserId])
				SELECT HF.HfID,L.LocationId, C.Percentage, GETDATE() ValidityFrom, @AuditUserId FROM @tblCatchment C 
				INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
				INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
				INNER JOIN @tblHF tempHF ON tempHF.Code=C.HFCode
				LEFT OUTER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
				WHERE 
				C.IsValid =1
				AND tempHF.IsValid=1
				AND L.ValidityTo IS NULL
				AND HF.ValidityTo IS NULL
				AND HFC.ValidityTo IS NULL
				AND HFC.LocationId IS NULL
				AND HFC.HFID IS NULL
				
				--SELECT @InsertCatchment=@@ROWCOUNT
				

			/*========================================================================================================
			INSERT ENDS
			========================================================================================================*/	

			COMMIT TRAN UPLOAD
		END

		
	END TRY
	BEGIN CATCH
		DECLARE @InvalidXML NVARCHAR(100)
		IF ERROR_NUMBER()=9436 
		BEGIN
			SET @InvalidXML='Invalid XML file, end tag does not match start tag'
			INSERT INTO @tblResult(Result, ResultType)
			SELECT @InvalidXML, N'FE';
		END
		ELSE
			INSERT INTO @tblResult(Result, ResultType)
			SELECT'Invalid XML file', N'FE';


		IF @@TRANCOUNT > 0 ROLLBACK TRAN UPLOAD;
		SELECT * FROM @tblResult;
		RETURN -1;
	END CATCH

	SELECT * FROM @tblResult;
	RETURN 0;
END

GO

IF NOT OBJECT_ID('uspUploadLocationsXML') IS NULL
DROP PROCEDURE [dbo].[uspUploadLocationsXML]
GO

CREATE PROCEDURE [dbo].[uspUploadLocationsXML]
(
		@File NVARCHAR(500),
		@StratergyId INT,
		@DryRun BIT,
		@AuditUserId INT,
		@SentRegion INT =0 OUTPUT,  
		@SentDistrict INT =0  OUTPUT, 
		@SentWard INT =0  OUTPUT, 
		@SentVillage INT =0  OUTPUT, 
		@InsertRegion INT =0  OUTPUT, 
		@InsertDistrict INT =0  OUTPUT, 
		@InsertWard INT =0  OUTPUT, 
		@InsertVillage INT =0 OUTPUT, 
		@UpdateRegion INT =0  OUTPUT, 
		@UpdateDistrict INT =0  OUTPUT, 
		@UpdateWard INT =0  OUTPUT, 
		@UpdateVillage INT =0  OUTPUT
)
AS 
	BEGIN

		/* Result type in @tblResults
		-------------------------------
			E	:	Error
			C	:	Conflict
			FE	:	Fatal Error

		Return Values
		------------------------------
			0	:	All Okay
			-1	:	Fatal error
		*/

		DECLARE @Query NVARCHAR(500)
		DECLARE @XML XML
		DECLARE @tblResult TABLE(Result NVARCHAR(Max), ResultType NVARCHAR(2))
		DECLARE @tempRegion TABLE(RegionCode NVARCHAR(100), RegionName NVARCHAR(100), IsValid BIT )
		DECLARE @tempLocation TABLE(LocationCode NVARCHAR(100))
		DECLARE @tempDistricts TABLE(RegionCode NVARCHAR(100),DistrictCode NVARCHAR(100),DistrictName NVARCHAR(100), IsValid BIT )
		DECLARE @tempWards TABLE(DistrictCode NVARCHAR(100),WardCode NVARCHAR(100),WardName NVARCHAR(100), IsValid BIT )
		DECLARE @tempVillages TABLE(WardCode NVARCHAR(100),VillageCode NVARCHAR(100), VillageName NVARCHAR(100),MalePopulation INT,FemalePopulation INT, OtherPopulation INT, Families INT, IsValid BIT )

		BEGIN TRY
	
			SET @Query = (N'SELECT @XML = CAST(X as XML) FROM OPENROWSET(BULK  '''+ @File +''' ,SINGLE_BLOB) AS T(X)')

			EXECUTE SP_EXECUTESQL @Query,N'@XML XML OUTPUT',@XML OUTPUT


			--GET ALL THE REGIONS FROM THE XML
			INSERT INTO @tempRegion(RegionCode,RegionName,IsValid)
			SELECT 
			NULLIF(T.R.value('(RegionCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(RegionName)[1]','NVARCHAR(100)'),''),
			1
			FROM @XML.nodes('Locations/Regions/Region') AS T(R)
		
			SELECT @SentRegion=@@ROWCOUNT

			--GET ALL THE DISTRICTS FROM THE XML
			INSERT INTO @tempDistricts(RegionCode, DistrictCode, DistrictName,IsValid)
			SELECT 
			NULLIF(T.R.value('(RegionCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(DistrictCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(DistrictName)[1]','NVARCHAR(100)'),''),
			1
			FROM @XML.nodes('Locations/Districts/District') AS T(R)

			SELECT @SentDistrict=@@ROWCOUNT

			--GET ALL THE WARDS FROM THE XML
			INSERT INTO @tempWards(DistrictCode,WardCode, WardName,IsValid)
			SELECT 
			NULLIF(T.R.value('(DistrictCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(WardCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(WardName)[1]','NVARCHAR(100)'),''),
			1
			FROM @XML.nodes('Locations/Wards/Ward') AS T(R)
		
			SELECT @SentWard = @@ROWCOUNT

			--GET ALL THE VILLAGES FROM THE XML
			INSERT INTO @tempVillages(WardCode, VillageCode, VillageName, MalePopulation, FemalePopulation, OtherPopulation, Families, IsValid)
			SELECT 
			NULLIF(T.R.value('(WardCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(VillageCode)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(VillageName)[1]','NVARCHAR(100)'),''),
			NULLIF(T.R.value('(MalePopulation)[1]','INT'),0),
			NULLIF(T.R.value('(FemalePopulation)[1]','INT'),0),
			NULLIF(T.R.value('(OtherPopulation)[1]','INT'),0),
			NULLIF(T.R.value('(Families)[1]','INT'),0),
			1
			FROM @XML.nodes('Locations/Villages/Village') AS T(R)
		
			SELECT @SentVillage=@@ROWCOUNT


			--SELECT * INTO tempRegion from @tempRegion
			--SELECT * INTO tempDistricts from @tempDistricts
			--SELECT * INTO tempWards from @tempWards
			--SELECT * INTO tempVillages from @tempVillages

			--RETURN

			/*========================================================================================================
			VALIDATION STARTS
			========================================================================================================*/	
			/********************************CHECK THE DUPLICATE LOCATION CODE******************************/
				INSERT INTO @tempLocation(LocationCode)
				SELECT RegionCode FROM @tempRegion
				INSERT INTO @tempLocation(LocationCode)
				SELECT DistrictCode FROM @tempDistricts
				INSERT INTO @tempLocation(LocationCode)
				SELECT WardCode FROM @tempWards
				INSERT INTO @tempLocation(LocationCode)
				SELECT VillageCode FROM @tempVillages
			
				INSERT INTO @tblResult(Result, ResultType)
				SELECT N'Location Code ' + QUOTENAME(LocationCode) + '  has already being used in a file ', N'C' FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1

				UPDATE @tempRegion  SET IsValid=0 WHERE RegionCode IN (SELECT LocationCode FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1)
				UPDATE @tempDistricts  SET IsValid=0 WHERE DistrictCode IN (SELECT LocationCode FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1)
				UPDATE @tempWards  SET IsValid=0 WHERE WardCode IN (SELECT LocationCode FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1)
				UPDATE @tempVillages  SET IsValid=0 WHERE VillageCode IN (SELECT LocationCode FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1)


			/********************************REGION STARTS******************************/
			--check if the regioncode is null 
			IF EXISTS(
			SELECT 1 FROM @tempRegion WHERE  LEN(ISNULL(RegionCode,''))=0 
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(1)) + N' Region(s) have empty code', N'E' FROM @tempRegion WHERE  LEN(ISNULL(RegionCode,''))=0 
		
			UPDATE @tempRegion SET IsValid=0  WHERE  LEN(ISNULL(RegionCode,''))=0 
		
			--check if the regionname is null 
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Region Code ' + QUOTENAME(RegionCode) + N' has empty name', N'E' FROM @tempRegion WHERE  LEN(ISNULL(RegionName,''))=0 
		
			UPDATE @tempRegion SET IsValid=0  WHERE RegionName  IS NULL OR LEN(ISNULL(RegionName,''))=0 

			--Check for Duplicates in file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Region Code ' + QUOTENAME(RegionCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(RegionCode)) + ' times in the file', N'C'  FROM @tempRegion GROUP BY RegionCode HAVING COUNT(RegionCode) >1 
		
			UPDATE R SET IsValid = 0 FROM @tempRegion R
			WHERE RegionCode in (SELECT RegionCode from @tempRegion GROUP BY RegionCode HAVING COUNT(RegionCode) >1)
		
			--check the length of the regionCode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Region Code ' + QUOTENAME(RegionCode) + N' is greater than 50', N'E' FROM @tempRegion WHERE  LEN(ISNULL(RegionCode,''))>50
		
			UPDATE @tempRegion SET IsValid=0  WHERE LEN(ISNULL(RegionCode,''))>50

			--check the length of the regionname
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Region Name ' + QUOTENAME(RegionCode) + N' is greater than 50', N'E' FROM @tempRegion WHERE  LEN(ISNULL(RegionName,''))>50
		
			UPDATE @tempRegion SET IsValid=0  WHERE LEN(ISNULL(RegionName,''))>50
		
		

			/********************************REGION ENDS******************************/

			/********************************DISTRICT STARTS******************************/
			--check if the district has regioncode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'District Code ' + QUOTENAME(DistrictCode) + N' has empty Region Code', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(RegionCode,''))=0 
		
			UPDATE @tempDistricts SET IsValid=0  WHERE  LEN(ISNULL(RegionCode,''))=0 

			--check if the district has valid regioncode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'District Code ' + QUOTENAME(DistrictCode) + N' has invalid Region Code', N'E' FROM @tempDistricts TD
			LEFT OUTER JOIN @tempRegion TR ON TR.RegionCode=TD.RegionCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TD.RegionCode AND L.LocationType='R' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TR.RegionCode IS NULL
			AND LEN(TD.RegionCode)>0

			UPDATE TD SET TD.IsValid=0 FROM @tempDistricts TD
			LEFT OUTER JOIN @tempRegion TR ON TR.RegionCode=TD.RegionCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TD.RegionCode AND L.LocationType='R' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TR.RegionCode IS NULL
			AND LEN(TD.RegionCode)>0

			--check if the districtcode is null 
			IF EXISTS(
			SELECT  1 FROM @tempDistricts WHERE  LEN(ISNULL(DistrictCode,''))=0 
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(1)) + N' District(s) have empty District code', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(DistrictCode,''))=0 
		
			UPDATE @tempDistricts SET IsValid=0  WHERE  LEN(ISNULL(DistrictCode,''))=0 
		
			--check if the districtname is null 
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'District Code ' + QUOTENAME(DistrictCode) + N' has empty name', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(DistrictName,''))=0 
		
			UPDATE @tempDistricts SET IsValid=0  WHERE  LEN(ISNULL(DistrictName,''))=0 
		
			--Check for Duplicates in file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'District Code ' + QUOTENAME(DistrictCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(DistrictCode)) + ' times in the file', N'C'  FROM @tempDistricts GROUP BY DistrictCode HAVING COUNT(DistrictCode) >1 
		
			UPDATE D SET IsValid = 0 FROM @tempDistricts D
			WHERE DistrictCode in (SELECT DistrictCode from @tempDistricts GROUP BY DistrictCode HAVING COUNT(DistrictCode) >1)

			--check the length of the DistrictCode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the District Code ' + QUOTENAME(DistrictCode) + N' is greater than 50', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(DistrictCode,''))>50
		
			UPDATE @tempDistricts SET IsValid=0  WHERE LEN(ISNULL(DistrictCode,''))>50

			--check the length of the regionname
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the District Name ' + QUOTENAME(DistrictName) + N' is greater than 50', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(DistrictName,''))>50
		
			UPDATE @tempDistricts SET IsValid=0  WHERE LEN(ISNULL(DistrictName,''))>50
		
			/********************************DISTRICT ENDS******************************/

			/********************************WARDS STARTS******************************/
			--check if the ward has districtcode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Ward Code ' + QUOTENAME(WardCode) + N' has empty District Code', N'E' FROM @tempWards WHERE  LEN(ISNULL(DistrictCode,''))=0 
		
			UPDATE @tempWards SET IsValid=0  WHERE  LEN(ISNULL(DistrictCode,''))=0 

			--check if the ward has valid districtCode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Ward Code ' + QUOTENAME(WardCode) + N' has invalid District Code', N'E' FROM @tempWards TW
			LEFT OUTER JOIN @tempDistricts TD ON  TD.DistrictCode=TW.DistrictCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.DistrictCode AND L.LocationType='D' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TD.DistrictCode IS NULL
			AND LEN(TW.DistrictCode)>0

			UPDATE TW SET TW.IsValid=0 FROM @tempWards TW
			LEFT OUTER JOIN @tempDistricts TD ON  TD.DistrictCode=TW.DistrictCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.DistrictCode AND L.LocationType='D' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TD.DistrictCode IS NULL
			AND LEN(TW.DistrictCode)>0

			--check if the wardcode is null 
			IF EXISTS(
			SELECT  1 FROM @tempWards WHERE  LEN(ISNULL(WardCode,''))=0 
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(1)) + N' Ward(s) have empty Ward code', N'E' FROM @tempWards WHERE  LEN(ISNULL(WardCode,''))=0 
		
			UPDATE @tempWards SET IsValid=0  WHERE  LEN(ISNULL(WardCode,''))=0 
		
			--check if the wardname is null 
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Ward Code ' + QUOTENAME(WardCode) + N' has empty name', N'E' FROM @tempWards WHERE  LEN(ISNULL(WardName,''))=0 
		
			UPDATE @tempWards SET IsValid=0  WHERE  LEN(ISNULL(WardName,''))=0 
		
			--Check for Duplicates in file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Ward Code ' + QUOTENAME(WardCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(WardCode)) + ' times in the file', N'C'  FROM @tempWards GROUP BY WardCode HAVING COUNT(WardCode) >1 
		
			UPDATE W SET IsValid = 0 FROM @tempWards W
			WHERE WardCode in (SELECT WardCode from @tempWards GROUP BY WardCode HAVING COUNT(WardCode) >1)

			--check the length of the wardcode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Ward Code ' + QUOTENAME(WardCode) + N' is greater than 50', N'E' FROM @tempWards WHERE  LEN(ISNULL(WardCode,''))>50
		
			UPDATE @tempWards SET IsValid=0  WHERE LEN(ISNULL(WardCode,''))>50

			--check the length of the wardname
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Ward Name ' + QUOTENAME(WardName) + N' is greater than 50', N'E' FROM @tempWards WHERE  LEN(ISNULL(WardName,''))>50
		
			UPDATE @tempWards SET IsValid=0  WHERE LEN(ISNULL(WardName,''))>50
		
			/********************************WARDS ENDS******************************/

			/********************************VILLAGE STARTS******************************/
			--check if the village has Wardcoce
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(VillageCode) + N' has empty Ward Code', N'E' FROM @tempVillages WHERE  LEN(ISNULL(WardCode,''))=0 
		
			UPDATE @tempVillages SET IsValid=0  WHERE  LEN(ISNULL(WardCode,''))=0 

			--check if the village has valid wardcode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(VillageCode) + N' has invalid Ward Code', N'E' FROM @tempVillages TV
			LEFT OUTER JOIN @tempWards TW ON  TW.WardCode=TV.WardCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TW.WardCode IS NULL
			AND LEN(TV.WardCode)>0
			AND LEN(TV.VillageCode) >0

			UPDATE TV SET TV.IsValid=0 FROM @tempVillages TV
			LEFT OUTER JOIN @tempWards TW ON  TW.WardCode=TV.WardCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TW.WardCode IS NULL
			AND LEN(TV.WardCode)>0
			AND LEN(TV.VillageCode) >0

			--check if the villagecode is null 
			IF EXISTS(
			SELECT  1 FROM @tempVillages WHERE  LEN(ISNULL(VillageCode,''))=0 
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(1)) + N' Village(s) have empty Village code', N'E' FROM @tempVillages WHERE  LEN(ISNULL(VillageCode,''))=0 
		
			UPDATE @tempVillages SET IsValid=0  WHERE  LEN(ISNULL(VillageCode,''))=0 
		
			--check if the villageName is null 
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(VillageCode) + N' has empty name', N'E' FROM @tempVillages WHERE  LEN(ISNULL(VillageName,''))=0 
		
			UPDATE @tempVillages SET IsValid=0  WHERE  LEN(ISNULL(VillageName,''))=0 
		
			--Check for Duplicates in file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(VillageCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(VillageCode)) + ' times in the file', N'C'  FROM @tempVillages GROUP BY VillageCode HAVING COUNT(VillageCode) >1 
		
			UPDATE V SET IsValid = 0 FROM @tempVillages V
			WHERE VillageCode in (SELECT VillageCode from @tempVillages GROUP BY VillageCode HAVING COUNT(VillageCode) >1)

			--check the length of the VillageCode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Village Code ' + QUOTENAME(VillageCode) + N' is greater than 50', N'E' FROM @tempVillages WHERE  LEN(ISNULL(VillageCode,''))>50
		
			UPDATE @tempVillages SET IsValid=0  WHERE LEN(ISNULL(VillageCode,''))>50

			--check the length of the VillageName
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Village Name ' + QUOTENAME(VillageName) + N' is greater than 50', N'E' FROM @tempVillages WHERE  LEN(ISNULL(VillageName,''))>50
		
			UPDATE @tempVillages SET IsValid=0  WHERE LEN(ISNULL(VillageName,''))>50

			--check the validity of the malepopulation
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'The Village Code' + QUOTENAME(VillageCode) + N' has invalid Male polulation', N'E' FROM @tempVillages WHERE  MalePopulation<0
		
			UPDATE @tempVillages SET IsValid=0  WHERE MalePopulation<0

			--check the validity of the female population
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'The Village Code' + QUOTENAME(VillageCode) + N' has invalid Female polulation', N'E' FROM @tempVillages WHERE  FemalePopulation<0
		
			UPDATE @tempVillages SET IsValid=0  WHERE FemalePopulation<0

			--check the validity of the OtherPopulation
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'The Village Code' + QUOTENAME(VillageCode) + N' has invalid Others polulation', N'E' FROM @tempVillages WHERE  OtherPopulation<0
		
			UPDATE @tempVillages SET IsValid=0  WHERE OtherPopulation<0

			--check the validity of the number of families
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'The Village Code' + QUOTENAME(VillageCode) + N' has invalid Number of  Families', N'E' FROM @tempVillages WHERE  Families<0
		
			UPDATE @tempVillages SET IsValid=0  WHERE Families<0

		
			/********************************VILLAGE ENDS******************************/
			/*========================================================================================================
			VALIDATION ENDS
			========================================================================================================*/	
	
			/*========================================================================================================
			COUNTS START
			========================================================================================================*/	
					IF @StratergyId =1 OR @StratergyId =2
						BEGIN
							--Regions insert
							SELECT @InsertRegion=COUNT(1) FROM @tempRegion TR 
							LEFT OUTER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
							WHERE
							TR.IsValid=1
							AND L.ValidityTo IS NULL
							AND L.LocationCode IS NULL

						--Districts insert
							SELECT @InsertDistrict=COUNT(1) FROM @tempDistricts TD 
							LEFT OUTER JOIN tblLocations L ON L.LocationCode=TD.DistrictCode AND L.LocationType='D'
							LEFT  OUTER JOIN tblRegions R ON TD.RegionCode = R.RegionCode AND R.ValidityTo IS NULL
							LEFT OUTER JOIN @tempRegion TR ON TD.RegionCode = TR.RegionCode
							WHERE
							TD.IsValid=1
							AND TR.IsValid = 1
							AND L.ValidityTo IS NULL
							AND L.LocationCode IS NULL
							

						--Wards insert
							SELECT @InsertWard=COUNT(1) FROM @tempWards TW 
							LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W'
							LEFT  OUTER JOIN tblDistricts D ON TW.DistrictCode = D.DistrictCode AND D.ValidityTo IS NULL
							LEFT OUTER JOIN @tempDistricts TD ON TD.DistrictCode = TW.DistrictCode
							WHERE
							TW.IsValid=1
							AND TD.IsValid = 1
							AND L.ValidityTo IS NULL
							AND L.LocationCode IS NULL

						--Villages insert
							SELECT @InsertVillage=COUNT(1) FROM @tempVillages TV 
							LEFT OUTER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='V'
							LEFT  OUTER JOIN tblWards W ON TV.WardCode = W.WardCode AND W.ValidityTo IS NULL
							LEFT OUTER JOIN @tempWards TW ON TV.WardCode = TW.WardCode
							WHERE
							TV.IsValid=1
							AND TW.IsValid = 1
							AND L.ValidityTo IS NULL
							AND L.LocationCode IS NULL
						END
			

					IF @StratergyId=2
						BEGIN
							--Regions updates
								SELECT @UpdateRegion=COUNT(1) FROM @tempRegion TR 
								INNER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
								WHERE
								TR.IsValid=1
								AND L.ValidityTo IS NULL
							
							--Districts updates
								SELECT @UpdateDistrict=COUNT(1) FROM @tempDistricts TD 
								INNER JOIN tblLocations L ON L.LocationCode=TD.DistrictCode AND L.LocationType='D'
								WHERE
								TD.IsValid=1
								AND L.ValidityTo IS NULL

							--Wards updates
								SELECT @UpdateWard=COUNT(1) FROM @tempWards TW 
								INNER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W'
								WHERE
								TW.IsValid=1
								AND L.ValidityTo IS NULL

							--Villages updates
								SELECT @UpdateVillage=COUNT(1) FROM @tempVillages TV 
								INNER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='V'
								WHERE
								TV.IsValid=1
								AND L.ValidityTo IS NULL
						END

			/*========================================================================================================
			COUNTS ENDS
			========================================================================================================*/	
		
			
				IF @DryRun =0
					BEGIN
						BEGIN TRAN UPLOAD

						
			/*========================================================================================================
			UPDATE STARTS
			========================================================================================================*/	
					IF @StratergyId=2
							BEGIN
							/********************************REGIONS******************************/
								--insert historocal record(s)
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[ValidityTo] ,[LegacyId],[AuditUserId],[MalePopulation] ,[FemalePopulation],[OtherPopulation],[Families])
									SELECT L.LocationCode, L.LocationName,L.ParentLocationId,L.LocationType, L.ValidityFrom,GETDATE(),L.LocationId,@AuditUserId AuditUserId, L.MalePopulation, L.FemalePopulation, L.OtherPopulation,L.Families 
									FROM @tempRegion TR 
									INNER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
									WHERE TR.IsValid=1 AND L.ValidityTo IS NULL

								--update
									UPDATE L SET  L.LocationName=TR.RegionName, ValidityFrom=GETDATE(),L.AuditUserId=@AuditUserId
									FROM @tempRegion TR 
									INNER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
									WHERE TR.IsValid=1 AND L.ValidityTo IS NULL;

									SELECT @UpdateRegion = @@ROWCOUNT;

									/********************************DISTRICTS******************************/
								--Insert historical records
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[ValidityTo] ,[LegacyId],[AuditUserId],[MalePopulation] ,[FemalePopulation],[OtherPopulation],[Families])
										SELECT L.LocationCode, L.LocationName,L.ParentLocationId,L.LocationType, L.ValidityFrom,GETDATE(),L.LocationId,@AuditUserId AuditUserId, L.MalePopulation, L.FemalePopulation, L.OtherPopulation,L.Families 
										FROM @tempDistricts TD 
										INNER JOIN tblLocations L ON L.LocationCode=TD.DistrictCode AND L.LocationType='D'
										WHERE TD.IsValid=1 AND L.ValidityTo IS NULL

									--update
										UPDATE L SET L.LocationName=TD.DistrictCode, ValidityFrom=GETDATE(),L.AuditUserId=@AuditUserId
										FROM @tempDistricts TD 
										INNER JOIN tblLocations L ON L.LocationCode=TD.DistrictCode AND L.LocationType='D'
										WHERE TD.IsValid=1 AND L.ValidityTo IS NULL;

										SELECT @UpdateDistrict = @@ROWCOUNT;

										/********************************WARD******************************/
								--Insert historical records
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[ValidityTo] ,[LegacyId],[AuditUserId],[MalePopulation] ,[FemalePopulation],[OtherPopulation],[Families])
										SELECT L.LocationCode, L.LocationName,L.ParentLocationId,L.LocationType, L.ValidityFrom,GETDATE(),L.LocationId,@AuditUserId AuditUserId, L.MalePopulation, L.FemalePopulation, L.OtherPopulation,L.Families 
										FROM @tempWards TW 
										INNER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W'
										WHERE TW.IsValid=1 AND L.ValidityTo IS NULL

								--Update
									UPDATE L SET L.LocationName=TW.WardName, ValidityFrom=GETDATE(),L.AuditUserId=@AuditUserId
										FROM @tempWards TW 
										INNER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W'
										WHERE TW.IsValid=1 AND L.ValidityTo IS NULL;

										SELECT @UpdateWard = @@ROWCOUNT;
									  
										/********************************VILLAGES******************************/
								--Insert historical records
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[ValidityTo] ,[LegacyId],[AuditUserId],[MalePopulation] ,[FemalePopulation],[OtherPopulation],[Families])
										SELECT L.LocationCode, L.LocationName,L.ParentLocationId,L.LocationType, L.ValidityFrom,GETDATE(),L.LocationId,@AuditUserId AuditUserId, L.MalePopulation, L.FemalePopulation, L.OtherPopulation,L.Families 
										FROM @tempVillages TV 
										INNER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='V'
										WHERE TV.IsValid=1 AND L.ValidityTo IS NULL

								--Update
									UPDATE L  SET L.LocationName=TV.VillageName, L.MalePopulation=TV.MalePopulation, L.FemalePopulation=TV.FemalePopulation, L.OtherPopulation=TV.OtherPopulation, L.Families=TV.Families, ValidityFrom=GETDATE(),L.AuditUserId=@AuditUserId
										FROM @tempVillages TV 
										INNER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='V'
										WHERE TV.IsValid=1 AND L.ValidityTo IS NULL;

										SELECT @UpdateVillage = @@ROWCOUNT;

							END
			/*========================================================================================================
			UPDATE ENDS
			========================================================================================================*/	

			/*========================================================================================================
			INSERT STARTS
			========================================================================================================*/	
						IF @StratergyId=1 OR @StratergyId=2
							BEGIN
							
								--insert Region(s)
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[LocationType],[ValidityFrom],[AuditUserId])
									SELECT TR.RegionCode, TR.RegionName,'R',GETDATE(), @AuditUserId AuditUserId 
									FROM @tempRegion TR 
									LEFT OUTER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
									WHERE
									TR.IsValid=1
									AND L.ValidityTo IS NULL
									AND L.LocationCode IS NULL;

									SELECT @InsertRegion = @@ROWCOUNT;

								--Insert District(s)

								
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[AuditUserId])
									SELECT TD.DistrictCode, TD.DistrictName, R.RegionId, 'D', GETDATE(), @AuditUserId AuditUserId 
									FROM @tempDistricts TD
									INNER JOIN tblRegions R ON TD.RegionCode = R.RegionCode
									LEFT OUTER JOIN tblDistricts D ON TD.DistrictCode = D.DistrictCode
									WHERE R.ValidityTo IS NULL
									AND D.ValidityTo IS NULL 
									AND D.DistrictId IS NULL;

									SELECT @InsertDistrict = @@ROWCOUNT;
									
							--Insert Wards
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[AuditUserId])
									SELECT TW.WardCode, TW.WardName, D.DistrictId, 'W',GETDATE(), @AuditUserId AuditUserId 
									FROM @tempWards TW
									INNER JOIN tblDistricts D ON TW.DistrictCode = D.DistrictCode
									LEFT OUTER JOIN tblWards W ON TW.WardCode = W.WardCode
									WHERE D.ValidityTo IS NULL
									AND W.ValidityTo IS NULL 
									AND W.WardId IS NULL;

									SELECT @InsertWard = @@ROWCOUNT;
									

							--insert  villages
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType], [MalePopulation],[FemalePopulation],[OtherPopulation],[Families], [ValidityFrom],[AuditUserId])
									SELECT TV.VillageCode,TV.VillageName,W.WardId,'V',TV.MalePopulation,TV.FemalePopulation,TV.OtherPopulation,TV.Families,GETDATE(), @AuditUserId AuditUserId
									FROM @tempVillages TV
									INNER JOIN tblWards W ON TV.WardCode = W.WardCode
									LEFT OUTER JOIN tblVillages V ON TV.VillageCode = V.VillageCode
									WHERE W.ValidityTo IS NULL
									AND V.ValidityTo IS NULL 
									AND V.VillageId IS NULL;

									SELECT @InsertVillage = @@ROWCOUNT;

							END
			/*========================================================================================================
			INSERT ENDS
			========================================================================================================*/	
							

						COMMIT TRAN UPLOAD
					END
		
			
		
		END TRY
		BEGIN CATCH
			DECLARE @InvalidXML NVARCHAR(100)
			IF ERROR_NUMBER()=245 
				BEGIN
					SET @InvalidXML='Invalid input in either MalePopulation, FemalePopulation, OtherPopulation or Number of Families '
					INSERT INTO @tblResult(Result, ResultType)
					SELECT @InvalidXML, N'FE';
				END
			ELSE  IF ERROR_NUMBER()=9436 
				BEGIN
					SET @InvalidXML='Invalid XML file, end tag does not match start tag'
					INSERT INTO @tblResult(Result, ResultType)
					SELECT @InvalidXML, N'FE';
				END
			ELSE
				INSERT INTO @tblResult(Result, ResultType)
				SELECT'Invalid XML file', N'FE';

			IF @@TRANCOUNT > 0 ROLLBACK TRAN UPLOAD;
			SELECT * FROM @tblResult
			RETURN -1;
				
		END CATCH
		SELECT * FROM @tblResult
		RETURN 0;
	END



GO

IF NOT OBJECT_ID('uspCleanTables') IS NULL
DROP PROCEDURE [dbo].[uspCleanTables]
GO


CREATE PROCEDURE [dbo].[uspCleanTables]
	@OffLine as int = 0		--0: For Online, 1: HF Offline, 2: CHF Offline
AS
BEGIN
	
	DECLARE @LocationId INT
	DECLARE @ParentLocationId INT

	--SELECT @ParentLocationId = ParentLocationId, @LocationId =LocationId  FROM tblLocations WHERE LocationName='Dummy' AND ValidityTo IS NULL AND LocationType = N'D'
	 
	--Phase 2
	DELETE FROM tblFeedbackPrompt;
	EXEC [UspS_ReseedTable] 'tblFeedbackPrompt';
	DELETE FROM tblReporting;
	EXEC [UspS_ReseedTable] 'tblReporting';
	DELETE FROM tblSubmittedPhotos;
	EXEC [UspS_ReseedTable] 'tblSubmittedPhotos';
	DELETE FROM dbo.tblFeedback;
	EXEC [UspS_ReseedTable] 'tblFeedback';
	DELETE FROM dbo.tblClaimServices;
	EXEC [UspS_ReseedTable] 'tblClaimServices';
	DELETE FROM dbo.tblClaimItems ;
	EXEC [UspS_ReseedTable] 'tblClaimItems';
	DELETE FROM dbo.tblClaimDedRem;
	EXEC [UspS_ReseedTable] 'tblClaimDedRem';
	DELETE FROM dbo.tblClaim;
	EXEC [UspS_ReseedTable] 'tblClaim';
	DELETE FROM dbo.tblClaimAdmin
	EXEC [USPS_ReseedTable] 'tblClaimAdmin'
	DELETE FROM dbo.tblICDCodes;
	EXEC [UspS_ReseedTable] 'tblICDCodes'
	
	
	DELETE FROM dbo.tblRelDistr;
	EXEC [UspS_ReseedTable] 'tblRelDistr';
	DELETE FROM dbo.tblRelIndex ;
	EXEC [UspS_ReseedTable] 'tblRelIndex';
	DELETE FROM dbo.tblBatchRun;
	EXEC [UspS_ReseedTable] 'tblBatchRun';
	DELETE FROM dbo.tblExtracts;
	EXEC [UspS_ReseedTable] 'tblExtracts';
	TRUNCATE TABLE tblPremium;
	
	--Phase 1
	EXEC [UspS_ReseedTable] 'tblPremium';
	DELETE FROM tblPayer;
	EXEC [UspS_ReseedTable] 'tblPayer';

	DELETE FROM dbo.tblPolicyRenewalDetails;
	EXEC [UspS_ReseedTable] 'tblPolicyRenewalDetails';
	DELETE FROM dbo.tblPolicyRenewals;
	EXEC [UspS_ReseedTable] 'tblPolicyRenewals';


	DELETE FROM tblInsureePolicy;
	EXEC [UspS_ReseedTable] 'tblInsureePolicy';
	DELETE FROM tblPolicy;
	EXEC [UspS_ReseedTable] 'tblPolicy';
	DELETE FROM tblProductItems;
	EXEC [UspS_ReseedTable] 'tblProductItems';
	DELETE FROM tblProductServices;
	EXEC [UspS_ReseedTable] 'tblProductServices';

	DELETE FROM dbo.tblRelDistr;
	EXEC [UspS_ReseedTable] 'tblRelDistr';


	DELETE FROM tblProduct;
	EXEC [UspS_ReseedTable] 'tblProduct';
	UPDATE tblInsuree set PhotoID = NULL ;
	DELETE FROM tblPhotos;
	EXEC [UspS_ReseedTable] 'tblPhotos';
	DELETE FROM tblInsuree;
	EXEC [UspS_ReseedTable] 'tblInsuree';
	DELETE FROM tblFamilies;
	EXEC [UspS_ReseedTable] 'tblFamilies';
	DELETE FROM tblOfficerVillages;
	EXEC [UspS_ReseedTable] 'tblOfficerVillages';
	DELETE FROM dbo.tblOfficer;
	EXEC [UspS_ReseedTable] 'tblOfficer';
	DELETE FROM dbo.tblHFCatchment;
	EXEC [UspS_ReseedTable] 'tblHFCatchment';
	DELETE FROM dbo.tblHF;
	EXEC [UspS_ReseedTable] 'tblHF';
	DELETe FROM dbo.tblPLItemsDetail;
	EXEC [UspS_ReseedTable] 'tblPLItemsDetail';
	DELETE FROM dbo.tblPLItems;
	EXEC [UspS_ReseedTable] 'tblPLItems';
	DELETE FROM dbo.tblItems;
	EXEC [UspS_ReseedTable] 'tblItems';
	DELETE FROM dbo.tblPLServicesDetail;
	EXEC [UspS_ReseedTable] 'tblPLServicesDetail';
	DELETE FROM dbo.tblPLServices;
	EXEC [UspS_ReseedTable] 'tblPLServices';
	DELETE FROM dbo.tblServices;
	EXEC [UspS_ReseedTable] 'tblServices';
	DELETE FROM dbo.tblUsersDistricts;
	EXEC [UspS_ReseedTable] 'tblUsersDistricts';


	DELETE FROM tblLocations;
	EXEC [UspS_ReseedTable] 'tblLocations';
	DELETE FROM dbo.tblLogins ;
	EXEC [UspS_ReseedTable] 'tblLogins';

	DELETE FROM dbo.tblUsers;
	EXEC [UspS_ReseedTable] 'tblUsers';

	TRUNCATE TABLE tblFromPhone;
	EXEC [UspS_ReseedTable] 'tblFromPhone';

	TRUNCATE TABLE tblEmailSettings;

	DBCC SHRINKDATABASE (0);
	
	--Drop the encryption set
	IF EXISTS(SELECT * FROM sys.symmetric_keys WHERE name = N'EncryptionKey')
	DROP SYMMETRIC KEY EncryptionKey;
		
	IF EXISTS(SELECT * FROM sys.certificates WHERE name = N'EncryptData')
	DROP CERTIFICATE EncryptData;
	
	IF EXISTS(SELECT * FROM sys.symmetric_keys WHERE symmetric_key_id = 101)
	DROP MASTER KEY;
	
	
	--Create Encryption Set
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = '!ExactImis';
	
	CREATE CERTIFICATE EncryptData 
	WITH Subject = 'Encrypt Data';
	
	CREATE SYMMETRIC KEY EncryptionKey
	WITH ALGORITHM = TRIPLE_DES, 
	KEY_SOURCE = 'Exact Key Source',
	IDENTITY_VALUE = 'Exact Identity Value'
	ENCRYPTION BY CERTIFICATE EncryptData
	
	
	--insert new user Admin-Admin
	IF @OffLine = 2  --CHF offline
	BEGIN
		OPEN SYMMETRIC KEY EncryptionKey DECRYPTION BY Certificate EncryptData
        INSERT INTO tblUsers ([LastName],[OtherNames],[Phone],[LoginName],[Password],[RoleID],[LanguageID],[HFID],[AuditUserID])
        VALUES('Admin', 'Admin', '', 'Admin', ENCRYPTBYKEY(KEY_GUID('EncryptionKey'),N'Admin'), 1048576,'en',0,0)
        CLOSE SYMMETRIC KEY EncryptionKey
        UPDATE tblIMISDefaults SET OffLineHF = 0,OfflineCHF = 0, FTPHost = '',FTPUser = '', FTPPassword = '',FTPPort = 0,FTPClaimFolder = '',FtpFeedbackFolder = '',FTPPolicyRenewalFolder = '',FTPPhoneExtractFolder = '',FTPOfflineExtractFolder = '',AppVersionEnquire = 0,AppVersionEnroll = 0,AppVersionRenewal = 0,AppVersionFeedback = 0,AppVersionClaim = 0, AppVersionImis = 0, DatabaseBackupFolder = ''
        
	END
	
	
	IF @OffLine = 1 --HF offline
	BEGIN
		OPEN SYMMETRIC KEY EncryptionKey DECRYPTION BY Certificate EncryptData
        INSERT INTO tblUsers ([LastName],[OtherNames],[Phone],[LoginName],[Password],[RoleID],[LanguageID],[HFID],[AuditUserID])
        VALUES('Admin', 'Admin', '', 'Admin', ENCRYPTBYKEY(KEY_GUID('EncryptionKey'),N'Admin'), 524288,'en',0,0)
        CLOSE SYMMETRIC KEY EncryptionKey
        UPDATE tblIMISDefaults SET OffLineHF = 0,OfflineCHF = 0,FTPHost = '',FTPUser = '', FTPPassword = '',FTPPort = 0,FTPClaimFolder = '',FtpFeedbackFolder = '',FTPPolicyRenewalFolder = '',FTPPhoneExtractFolder = '',FTPOfflineExtractFolder = '',AppVersionEnquire = 0,AppVersionEnroll = 0,AppVersionRenewal = 0,AppVersionFeedback = 0,AppVersionClaim = 0, AppVersionImis = 0, DatabaseBackupFolder = ''
        
	END
	IF @OffLine = 0 --ONLINE CREATION NEW COUNTRY NO DEFAULTS KEPT
	BEGIN
		OPEN SYMMETRIC KEY EncryptionKey DECRYPTION BY Certificate EncryptData
        INSERT INTO tblUsers ([LastName],[OtherNames],[Phone],[LoginName],[Password],[RoleID],[LanguageID],[HFID],[AuditUserID])
        VALUES('Admin', 'Admin', '', 'Admin', ENCRYPTBYKEY(KEY_GUID('EncryptionKey'),N'Admin'), 1023,'en',0,0)
        CLOSE SYMMETRIC KEY EncryptionKey
		UPDATE tblIMISDefaults SET OffLineHF = 0,OfflineCHF = 0,FTPHost = '',FTPUser = '', FTPPassword = '',FTPPort = 0,FTPClaimFolder = '',FtpFeedbackFolder = '',FTPPolicyRenewalFolder = '',FTPPhoneExtractFolder = '',FTPOfflineExtractFolder = '',AppVersionEnquire = 0,AppVersionEnroll = 0,AppVersionRenewal = 0,AppVersionFeedback = 0,AppVersionClaim = 0, AppVersionImis = 0,				DatabaseBackupFolder = ''
    END
	
	IF @OffLine = -1 --ONLINE CREATION WITH DEFAULTS KEPT AS PREVIOUS CONTENTS
	BEGIN
		OPEN SYMMETRIC KEY EncryptionKey DECRYPTION BY Certificate EncryptData
        INSERT INTO tblUsers ([LastName],[OtherNames],[Phone],[LoginName],[Password],[RoleID],[LanguageID],[HFID],[AuditUserID])
        VALUES('Admin', 'Admin', '', 'Admin', ENCRYPTBYKEY(KEY_GUID('EncryptionKey'),N'Admin'), 1023,'en',0,0)
        CLOSE SYMMETRIC KEY EncryptionKey
        UPDATE tblIMISDefaults SET OffLineHF = 0,OfflineCHF = 0
    END


	SET IDENTITY_INSERT tblLocations ON
	INSERT INTO tblLocations(LocationId, LocationCode, Locationname, LocationType, AuditUserId, ParentLocationId) VALUES
	(1, N'R0001', N'Region', N'R', -1, NULL),
	(2, N'D0001', N'Dummy', N'D', -1, 1)
	SET IDENTITY_INSERT tblLocations OFF
		
	INSERT INTO tblUsersDistricts ([UserID],[LocationId],[AuditUserID]) VALUES (1,2,-1)
END



GO

IF NOT OBJECT_ID('uspUploadEnrolmentFromPhone') IS NULL
DROP PROCEDURE [dbo].[uspUploadEnrolmentFromPhone]
GO

CREATE PROCEDURE [dbo].[uspUploadEnrolmentFromPhone]
(
	@xml XML,
	@OfficerId INT,
	@AuditUserId INT,
	@ErrorMessage NVARCHAR(300) = N'' OUTPUT
)
AS
BEGIN
    
	/*=========ERROR CODES==========
	-400	:Uncaught exception
	0	:	All okay
	-1	:	Given family has no HOF
	-2	:	Insurance number of the HOF already exists
	-3	:	Duplicate Insurance number found
	-4	:	Duplicate receipt found

	

	*/
TRY --THE MAIN TRY
		--Create table variables
		--DECLARE @Result TABLE(ErrorMessage NVARCHAR(500))
		DECLARE @Family TABLE(FamilyId INT,InsureeId INT,LocationId INT, HOFCHFID nvarchar(12),Poverty BIT NULL,FamilyType NVARCHAR(2),FamilyAddress NVARCHAR(200), Ethnicity NVARCHAR(1), ConfirmationNo NVARCHAR(12), ConfirmationType NVARCHAR(3),isOffline INT)
		DECLARE @Insuree TABLE(InsureeId INT,FamilyId INT,CHFID NVARCHAR(12),LastName NVARCHAR(100),OtherNames NVARCHAR(100),DOB DATE,Gender CHAR(1),Marital CHAR(1),IsHead BIT,Passport NVARCHAR(25),Phone NVARCHAR(50),CardIssued BIT,Relationship SMALLINT,Profession SMALLINT,Education SMALLINT,Email NVARCHAR(100), TypeOfId NVARCHAR(1), HFID INT, CurrentAddress NVARCHAR(200), GeoLocation NVARCHAR(250), CurrentVillage INT, PhotoPath NVARCHAR(100), IdentificationNumber NVARCHAR(50),isOffline INT,EffectiveDate DATE)
		DECLARE @Policy TABLE(PolicyId INT,FamilyId INT,EnrollDate DATE,StartDate DATE,EffectiveDate DATE,ExpiryDate DATE,PolicyStatus TINYINT,PolicyValue DECIMAL(18,2),ProdId INT,OfficerId INT,PolicyStage CHAR(1),isOffline INT)
		DECLARE @Premium TABLE(PremiumId INT,PolicyId INT,PayerId INT,Amount DECIMAL(18,2),Receipt NVARCHAR(50),PayDate DATE,PayType CHAR(1),isPhotoFee BIT,isOffline INT)
		--DECLARE @InsureePolicy TABLE(InsureePolicyId INT, InsureeId INT,PolicyId INT, EnrollmentDate DATE,StartDate DATE, EffectiveDate DATE, ExpiryDate DATE,isOffline INT)
		--Insert data into table variable from XML
		INSERT INTO @Family(FamilyId, InsureeId, LocationId,HOFCHFID, Poverty, FamilyType, FamilyAddress, Ethnicity, ConfirmationNo, ConfirmationType,isOffline)
		SELECT 
		T.F.value('(FamilyId)[1]', 'INT'),
		T.F.value('(InsureeId)[1]', 'INT'),
		T.F.value('(LocationId)[1]', 'INT'),
		T.F.value('(HOFCHFID)[1]', 'NVARCHAR(12)'),
		T.F.value('(Poverty)[1]', 'BIT'),
		NULLIF(T.F.value('(FamilyType)[1]', 'NVARCHAR(2)'), ''),
		NULLIF(T.F.value('(FamilyAddress)[1]', 'NVARCHAR(200)'), ''),
		NULLIF(T.F.value('(Ethnicity)[1]', 'NVARCHAR(1)'), ''),
		NULLIF(T.F.value('(ConfirmationNo)[1]', 'NVARCHAR(12)'), ''),
		NULLIF(T.F.value('(ConfirmationType)[1]', 'NVARCHAR(3)'), ''),
		T.F.value('(isOffline)[1]','INT')
		FROM @xml.nodes('Enrollment/Family') AS T(F);

	
		INSERT INTO @Insuree(InsureeId, FamilyId, CHFID, LastName, OtherNames, DOB, Gender, Marital, IsHead, Phone, CardIssued, Relationship, 
		Profession, Education, Email, TypeOfId, HFID, CurrentAddress, GeoLocation, CurrentVillage, PhotoPath, Passport,isOffline,EffectiveDate)
		SELECT 
		T.I.value('(InsureeId)[1]', 'INT'),
		T.I.value('(FamilyId)[1]', 'INT'),
		T.I.value('(CHFID)[1]', 'NVARCHAR(12)'),
		T.I.value('(LastName)[1]', 'NVARCHAR(100)'),
		T.I.value('(OtherNames)[1]', 'NVARCHAR(100)'),
		T.I.value('(DOB)[1]', 'DATE'),
		T.I.value('(Gender)[1]', 'CHAR(1)'),
		NULLIF(T.I.value('(Marital)[1]', 'CHAR(1)'), ''),
		T.I.value('(isHead)[1]', 'BIT'),
		NULLIF(T.I.value('(Phone)[1]', 'NVARCHAR(50)'), ''),
		ISNULL(NULLIF(T.I.value('(CardIssued)[1]', 'BIT'), ''), 0),
		NULLIF(T.I.value('(Relationship)[1]', 'INT'), ''),
		NULLIF(T.I.value('(Profession)[1]', 'INT'), ''),
		NULLIF(T.I.value('(Education)[1]', 'INT'), ''),
		NULLIF(T.I.value('(Email)[1]', 'NVARCHAR(100)'), ''),
		NULLIF(T.I.value('(TypeOfId)[1]', 'NVARCHAR(1)'), ''),
		NULLIF(T.I.value('(HFID)[1]', 'INT'), ''),
		NULLIF(T.I.value('(CurrentAddress)[1]', 'NVARCHAR(200)'), ''),
		NULLIF(T.I.value('(GeoLocation)[1]', 'NVARCHAR(250)'), ''),
		NULLIF(T.I.value('(CurVillage)[1]', 'INT'), ''),
		NULLIF(T.I.value('(PhotoPath )[1]', 'NVARCHAR(100)'), ''),
		NULLIF(T.I.value('(IdentificationNumber)[1]', 'NVARCHAR(50)'), ''),
		T.I.value('(isOffline)[1]','INT'),
		CASE WHEN T.I.value('(EffectiveDate)[1]', 'DATE')='1900-01-01' THEN NULL ELSE T.I.value('(EffectiveDate)[1]', 'DATE') END
		FROM @xml.nodes('Enrollment/Insuree') AS T(I)



		INSERT INTO @Policy(PolicyId, FamilyId, EnrollDate, StartDate, EffectiveDate, ExpiryDate, PolicyStatus, PolicyValue, ProdId, OfficerId, PolicyStage,isOffline)
		SELECT 
		T.P.value('(PolicyId)[1]', 'INT'),
		T.P.value('(FamilyId)[1]', 'INT'),
		T.P.value('(EnrollDate)[1]', 'DATE'),
		NULLIF(T.P.value('(StartDate)[1]', 'DATE'), ''),
		NULLIF(T.P.value('(EffectiveDate)[1]', 'DATE'), ''),
		NULLIF(T.P.value('(ExpiryDate)[1]', 'DATE'), ''),
		T.P.value('(PolicyStatus)[1]', 'INT'),
		NULLIF(T.P.value('(PolicyValue)[1]', 'DECIMAL'), 0),
		T.P.value('(ProdId)[1]', 'INT'),
		T.P.value('(OfficerId)[1]', 'INT'),
		ISNULL(NULLIF(T.P.value('(PolicyStage)[1]', 'CHAR(1)'), ''), N'N'),
		T.P.value('(isOffline)[1]','INT')
		FROM @xml.nodes('Enrollment/Policy') AS T(P)

		INSERT INTO @Premium(PremiumId, PolicyId, PayerId, Amount, Receipt, PayDate, PayType, isPhotoFee,isOffline)
		SELECT 
		T.PR.value('(PremiumId)[1]', 'INT'),
		T.PR.value('(PolicyId)[1]', 'INT'),
		NULLIF(T.PR.value('(PayerId)[1]', 'INT'), 0),
		T.PR.value('(Amount)[1]', 'DECIMAL'),
		T.PR.value('(Receipt)[1]', 'NVARCHAR(50)'),
		T.PR.value('(PayDate)[1]', 'DATE'),
		T.PR.value('(PayType)[1]', 'CHAR(1)'),
		T.PR.value('(isPhotoFee)[1]', 'BIT'),
		T.PR.value('(isOffline)[1]','INT')
		FROM @xml.nodes('Enrollment/Premium') AS T(PR)

		
		DECLARE @FamilyId INT = 0,
				@HOFId INT = 0,
				@PolicyValue DECIMAL(18, 4),
				@ProdId INT,
				@PolicyStage CHAR(1),
				@EnrollDate DATE,
				@ErrorCode INT,
				@PolicyStatus INT,
				@PolicyId INT,
				
				@CurInsureeId INT,
				@CurIsOffline INT,
				@CurHFID NVARCHAR(12),
				@CurFamilyId INT,
				
				@GivenPolicyValue DECIMAL(18, 4),
				@NewPolicyId INT,
				@ReturnValue INT = 0;
		DECLARE @isOffline INT,
				@CHFID NVARCHAR(12)
			--PREMIUM
			DECLARE @PremiumID INT,
					@Contribution DECIMAL(18,2) ,
					@EffectiveDate DATE,
					@AssociatedPhotoFolder NVARCHAR(255)

	SET @AssociatedPhotoFolder=(SELECT AssociatedPhotoFolder FROM tblIMISDefaults)
		--TEMP tables
		--IF NOT  OBJECT_ID('TempFamily') IS NULL
		--DROP TABLE TempFamily
		--SELECT * INTO TempFamily FROM @Family
		--IF NOT OBJECT_ID('TempInsuree') IS NULL
		--DROP TABLE TempInsuree
		--SELECT * INTO TempInsuree FROM @Insuree
		--IF NOT OBJECT_ID('TempPolicy') IS NULL
		--DROP TABLE TempPolicy
		--SELECT * INTO TempPolicy FROM @Policy
		--IF NOT OBJECT_ID('TempPremium') IS NULL
		--DROP TABLE TempPremium
		--SELECT * INTO TempPremium FROM @Premium
		--RETURN
		--end temp tables
	--CHFID for HOF, Amani 14.12.2017
	DECLARE @HOFCHFID NVARCHAR(12) =''
			
		---Added by Amani to Grab CHFID of HED
		SELECT @HOFCHFID =HOFCHFID FROM @Family F 
		--END
		--<newchanges>
		--Validations
		IF NOT EXISTS(SELECT 1 FROM tblInsuree WHERE IsHead=1 AND CHFID=@HOFCHFID AND ValidityTo IS NULL)
		BEGIN--NEW FAMILY BEGIN
		---NEW FAMILY HERE
		BEGIN TRY

		--Amani Added 25.01.2018
		IF NOT EXISTS(SELECT 1 FROM @Insuree  WHERE IsHead = 1)
			BEGIN
			--RETURN -1;
			--Make the first insuree to be head if there is no HOF by Amani & Hiren 19/02/2018
			UPDATE @Insuree SET IsHead =1 WHERE InsureeId=(SELECT TOP 1 InsureeId FROM @Insuree)
			END
			
		--end added by Amani
		IF EXISTS(SELECT 1 FROM tblInsuree I 
				  INNER JOIN @Insuree dt ON dt.CHFID = I.CHFID AND dt.InsureeId <> I.InsureeID
				  WHERE I.ValidityTo IS NULL AND dt.IsHead = 1 AND I.IsHead = 1)
			RETURN -2;

		IF EXISTS(SELECT 1 FROM tblInsuree I 
				  INNER JOIN @Insuree dt ON dt.CHFID = I.CHFID  AND dt.InsureeId <> I.InsureeID
				  WHERE I.ValidityTo IS NULL AND dt.isOffline = 1)
			RETURN -3;

		IF EXISTS(SELECT 1
					FROM @Premium dtPR
					INNER JOIN tblPremium PR ON PR.Receipt = dtPR.Receipt 
					INNER JOIN @Policy dtPL ON dtPL.PolicyId = dtPR.PolicyId
					INNER JOIN @Family dtF ON dtF.FamilyId = dtPL.FamilyID
					INNER JOIN tblVillages V ON V.VillageId = dtF.LocationId
					INNER JOIN tblWards W ON W.WardId = V.WardId
					INNER JOIN tblDistricts D ON D.DistrictId = W.DistrictId
					WHERE   dtPR.isOffline = 1)
			RETURN -4;
			--DROP TABLE Premium
			--SELECT * INTO Insuree FROM @Insuree
			--SELECT * INTO Policy FROM @Policy
			--SELECT * INTO Premium FROM @Premium
		BEGIN TRAN ENROLLFAMILY
		/****************************************************START INSERT FAMILY**********************************/


					
			SELECT @isOffline =F.isOffline, @CHFID=CHFID FROM @Family F
			INNER JOIN @Insuree I ON I.FamilyId =F.FamilyId
				
				IF EXISTS(SELECT 1 FROM @Family WHERE isOffline =1)
					BEGIN
						INSERT INTO tblFamilies(InsureeId, LocationId, Poverty, ValidityFrom, AuditUserId, isOffline, FamilyType,
						FamilyAddress, Ethnicity, ConfirmationNo, ConfirmationType)
						SELECT 0 InsureeId, LocationId, Poverty, GETDATE() ValidityFrom, @AuditUserId AuditUserId, 0 isOffline, FamilyType,
						FamilyAddress, Ethnicity, ConfirmationNo, ConfirmationType
						FROM @Family;
						SELECT @FamilyId = SCOPE_IDENTITY();
						UPDATE @Insuree SET FamilyId = @FamilyId
						UPDATE @Policy SET FamilyId =  @FamilyId
					END
			
				

		/****************************************************START INSERT INSUREE**********************************/
				SELECT @isOffline =I.isOffline, @CHFID=CHFID FROM @Insuree I
				
				--Insert insurees
				IF EXISTS(SELECT 1 FROM @Insuree WHERE isOffline = 1  )
						BEGIN
							DECLARE CurInsuree CURSOR FOR SELECT InsureeId, CHFID, isOffline,FamilyId FROM @Insuree WHERE isOffline = 1 --OR CHFID NOT IN (SELECT CHFID FROM tblInsuree WHERE ValidityTo IS NULL);
							OPEN CurInsuree
							FETCH NEXT FROM CurInsuree INTO @CurInsureeId, @CurHFID, @CurIsOffline, @CurFamilyId;
							WHILE @@FETCH_STATUS = 0
							BEGIN
							INSERT INTO tblInsuree(FamilyId, CHFID, LastName, OtherNames, DOB, Gender, Marital, IsHead, passport, Phone, CardIssued, ValidityFrom,
							AuditUserId, isOffline, Relationship, Profession, Education, Email, TypeOfId, HFID, CurrentAddress, GeoLocation, CurrentVillage)
							SELECT @CurFamilyId FamilyId, CHFID, LastName, OtherNames, DOB, Gender, Marital, IsHead, passport, Phone, CardIssued, GETDATE() ValidityFrom,
							@AuditUserId AuditUserId, 0 isOffline, Relationship, Profession, Education, Email, TypeOfId, HFID, CurrentAddress, GeoLocation, CurrentVillage
							FROM @Insuree WHERE InsureeId = @CurInsureeId;
							DECLARE @NewInsureeId  INT  =0
							SELECT @NewInsureeId = SCOPE_IDENTITY();
							IF @isOffline <> 1 AND @ReturnValue = 0 SET @ReturnValue = @NewInsureeId
							UPDATE @Insuree SET InsureeId = @NewInsureeId WHERE InsureeId = @CurInsureeId
							--Insert photo entry
							INSERT INTO tblPhotos(InsureeID,CHFID,PhotoFolder,PhotoFileName,OfficerID,PhotoDate,ValidityFrom,AuditUserID)
							SELECT I.InsureeId, I.CHFID, @AssociatedPhotoFolder + '\'PhotoFolder, dt.PhotoPath, @OfficerId OfficerId, GETDATE() PhotoDate, GETDATE() ValidityFrom, @AuditUserId AuditUserId
							FROM tblInsuree I 
							INNER JOIN @Insuree dt ON dt.CHFID = I.CHFID
							--WHERE I.FamilyId = @CurFamilyId
							WHERE dt.InsureeId=@NewInsureeId
							AND ValidityTo IS NULL;

							--Update photoId in Insuree
							UPDATE I SET PhotoId = PH.PhotoId, I.PhotoDate = PH.PhotoDate
							FROM tblInsuree I
							INNER JOIN tblPhotos PH ON PH.InsureeId = I.InsureeId
							WHERE I.FamilyId = @CurFamilyId;
					FETCH NEXT FROM CurInsuree INTO @CurInsureeId, @CurHFID, @CurIsOffline, @CurFamilyId;
					END
					CLOSE CurInsuree
					DEALLOCATE CurInsuree;	
				
			
				
					
					
					--Get the id of the HOF and update Family
					--SELECT @HOFId = InsureeId FROM tblInsuree WHERE FamilyId = @FamilyId AND IsHead = 1
					SELECT @HOFId = InsureeId FROM @Insuree WHERE FamilyId = @FamilyId AND IsHead = 1
					UPDATE tblFamilies SET InsureeId = @HOFId WHERE Familyid = @FamilyId 
					
						END
				/****************************************************END INSERT INSUREE**********************************/



				/****************************************************END INSERT POLICIES**********************************/
				
				SELECT TOP 1 @isOffline = P.isOffline FROM @Policy P
				IF EXISTS(SELECT 1 FROM @Policy WHERE isOffline = 1)
				BEGIN		
					--INSERT POLICIES
						DECLARE CurOfflinePolicy CURSOR FOR SELECT PolicyId, ProdId, ISNULL(PolicyStage, N'N') PolicyStage, EnrollDate,FamilyId FROM @Policy WHERE isOffline = 1 OR PolicyId NOT IN (SELECT PolicyId FROM tblPolicy WHERE ValidityTo	 IS NULL);
						OPEN CurOfflinePolicy
							FETCH NEXT FROM CurOfflinePolicy INTO @PolicyId, @ProdId, @PolicyStage, @EnrollDate,@FamilyId;
							WHILE @@FETCH_STATUS = 0
							BEGIN

								EXEC @PolicyValue = uspPolicyValue @FamilyId,
																	@ProdId,
																	0,
																	@PolicyStage,
																	@EnrollDate,
																	0,
																	@ErrorCode OUTPUT;


								SELECT @GivenPolicyValue = PolicyValue, @PolicyStatus = PolicyStatus FROM @Policy WHERE PolicyId = @PolicyId;
								INSERT INTO tblPolicy(FamilyId, EnrollDate, StartDate, EffectiveDate, ExpiryDate, PolicyStatus, PolicyValue, 
								ProdId, OfficerId, ValidityFrom, AuditUserId, isOffline, PolicyStage)
								SELECT @FamilyId FamilyId, EnrollDate, StartDate, EffectiveDate, ExpiryDate, @PolicyStatus PolicyStatus, @PolicyValue PolicyValue, 
								ProdId, OfficerId, GETDATE() ValidityFrom, @AuditUserId AuditUserId, 0 isOffline, @PolicyStage PolicyStage
								FROM @Policy
								WHERE PolicyId = @PolicyId;

								SELECT @NewPolicyId = SCOPE_IDENTITY();
								UPDATE @Premium SET PolicyId = @NewPolicyId WHERE PolicyId = @PolicyId 
								IF @isOffline <> 1 AND @ReturnValue = 0  
									BEGIN
										SET @ReturnValue = @NewPolicyId;
										--AND isOffline = 0
									END
								--Insert policy Insuree
							
						
								;WITH IP AS
								(
								SELECT  I.InsureeID,PL.PolicyID,PL.EnrollDate,PL.StartDate,I.EffectiveDate, PL.ExpiryDate,PL.AuditUserID,I.isOffline
								FROM @Insuree I
								INNER JOIN tblPolicy PL ON I.FamilyID = PL.FamilyID
								WHERE PL.ValidityTo IS NULL
								AND PL.PolicyID = @NewPolicyId
								)

								INSERT INTO tblInsureePolicy(InsureeId,PolicyId,EnrollmentDate,StartDate, EffectiveDate,ExpiryDate,AuditUserId,isOffline)
								SELECT InsureeId, PolicyId, EnrollDate, StartDate,EffectiveDate, ExpiryDate, AuditUserId, isOffline
								FROM IP
								

								IF   EXISTS(SELECT 1 FROM @Premium WHERE isOffline = 1)
								BEGIN
									INSERT INTO tblPremium(PolicyId, PayerId, Amount, Receipt, PayDate, PayType, ValidityFrom, AuditUserId, isOffline, isPhotoFee)
									SELECT  PolicyId, PayerId, Amount, Receipt, PayDate, PayType, GETDATE() ValidityFrom, @AuditUserId AuditUserId, 0 isOffline, isPhotoFee 
									FROM @Premium
									WHERE PolicyId = @NewPolicyId;
								END

		
								FETCH NEXT FROM CurOfflinePolicy INTO @PolicyId, @ProdId, @PolicyStage, @EnrollDate, @FamilyId;
						END
					CLOSE CurOfflinePolicy
					DEALLOCATE CurOfflinePolicy;
				END
	/****************************************************END INSERT POLICIES**********************************/
			
	/****************************************************START UPDATE PREMIUM**********************************/
		
		
						IF  EXISTS(SELECT 1 FROM @Premium dt 
									  LEFT JOIN tblPremium P ON P.PremiumId = dt.PremiumId 
										WHERE P.ValidityTo IS NULL AND dt.isOffline <> 1 AND P.PremiumId IS NULL)
							BEGIN
								--INSERTPREMIMIUN
									INSERT INTO tblPremium(PolicyId, PayerId, Amount, Receipt, PayDate, PayType, ValidityFrom, AuditUserId, isOffline, isPhotoFee)
												SELECT     PolicyId, PayerId, Amount, Receipt, PayDate, PayType, GETDATE() ValidityFrom, @AuditUserId AuditUserId, 0 isOffline, isPhotoFee 
												FROM @Premium
												WHERE @isOffline <> 1;
												SELECT @PremiumId = SCOPE_IDENTITY();
								IF @isOffline <> 1 AND ISNULL(@PremiumId,0) >0 AND @ReturnValue =0 SET @ReturnValue = @PremiumId
							END
						

	/****************************************************END INSERT PREMIUM**********************************/

		COMMIT TRAN ENROLLFAMILY;
		SET @ErrorMessage = '';
		RETURN @ReturnValue;
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE();
		IF @@TRANCOUNT > 0 ROLLBACK TRAN ENROLLFAMILY;
		RETURN -400;
	END CATCH
		SELECT 1
		END
		ELSE
		BEGIN---BEGIN EXISTING  FAMILY
	BEGIN TRY
	
		
		--IF   EXISTS(SELECT 1 FROM @Insuree WHERE IsHead = 0 AND isOffline = 1)
		--BEGIN
		--	UPDATE @Insuree SET IsHead = 1 WHERE InsureeId = (SELECT TOP 1 InsureeId FROM @Insuree ORDER BY InsureeId)
		--END

		--Amani Added 25.01.2018
		IF NOT EXISTS(SELECT 1 FROM tblInsuree I 
				  INNER JOIN @Insuree dt ON dt.FamilyId = I.FamilyId
				  WHERE I.ValidityTo IS NULL AND I.IsHead = 1)
			RETURN -1;
		--end added by Amani
		IF EXISTS(SELECT 1 FROM tblInsuree I 
				  INNER JOIN @Insuree dt ON dt.CHFID = I.CHFID AND dt.InsureeId <> I.InsureeID
				  WHERE I.ValidityTo IS NULL AND dt.IsHead = 1 AND I.IsHead = 1)
			RETURN -2;

		IF EXISTS(SELECT 1 FROM tblInsuree I 
				  INNER JOIN @Insuree dt ON dt.CHFID = I.CHFID  AND dt.InsureeId <> I.InsureeID
				  WHERE I.ValidityTo IS NULL AND dt.isOffline = 1)
			RETURN -3;

		IF EXISTS(SELECT 1
					FROM @Premium dtPR
					INNER JOIN tblPremium PR ON PR.Receipt = dtPR.Receipt 
					INNER JOIN @Policy dtPL ON dtPL.PolicyId = dtPR.PolicyId
					INNER JOIN @Family dtF ON dtF.FamilyId = dtPL.FamilyID
					INNER JOIN tblVillages V ON V.VillageId = dtF.LocationId
					INNER JOIN tblWards W ON W.WardId = V.WardId
					INNER JOIN tblDistricts D ON D.DistrictId = W.DistrictId
					WHERE   dtPR.isOffline = 1)
			RETURN -4;
			--DROP TABLE Premium
			--SELECT * INTO Insuree FROM @Insuree
			--SELECT * INTO Policy FROM @Policy
			--SELECT * INTO Premium FROM @Premium
		BEGIN TRAN UPDATEFAMILY
		/****************************************************START INSERT FAMILY**********************************/

			SELECT @FamilyId = FamilyID FROM tblInsuree WHERE IsHead=1 AND CHFID=@HOFCHFID AND ValidityTo IS NULL		
			SELECT @isOffline =F.isOffline, @CHFID=CHFID FROM @Family F
			INNER JOIN @Insuree I ON I.FamilyId =F.FamilyId
				
				IF EXISTS(SELECT 1 FROM @Family WHERE isOffline =1)
					BEGIN
						INSERT INTO tblFamilies(InsureeId, LocationId, Poverty, ValidityFrom, AuditUserId, isOffline, FamilyType,
						FamilyAddress, Ethnicity, ConfirmationNo, ConfirmationType)
						SELECT 0 InsureeId, LocationId, Poverty, GETDATE() ValidityFrom, @AuditUserId AuditUserId, 0 isOffline, FamilyType,
						FamilyAddress, Ethnicity, ConfirmationNo, ConfirmationType
						FROM @Family;
						SELECT @FamilyId = SCOPE_IDENTITY();
						UPDATE @Insuree SET FamilyId = @FamilyId
						UPDATE @Policy SET FamilyId =  @FamilyId
					END
				ELSE
					BEGIN
						
						--Insert History Record
						INSERT INTO tblFamilies ([insureeid],[Poverty],[ConfirmationType],isOffline,[ValidityFrom],[ValidityTo],[LegacyID],[AuditUserID],FamilyType, FamilyAddress,Ethnicity,ConfirmationNo, LocationId) 
						SELECT [insureeid],[Poverty],[ConfirmationType],isOffline,[ValidityFrom],getdate(),@FamilyID, @AuditUserID,FamilyType, FamilyAddress,Ethnicity,ConfirmationNo,LocationId FROM tblFamilies where FamilyID = @FamilyID;
						

						
						--Update Family
						UPDATE @Family SET FamilyId = @FamilyId
						UPDATE @Policy SET FamilyId =  @FamilyId
						 UPDATE  dst  SET dst.[Poverty] = src.Poverty,  dst.[ConfirmationType] = src.ConfirmationType, isOffline=0, dst.[ValidityFrom]=GETDATE(), dst.[AuditUserID] = @AuditUserID, dst.FamilyType = src.FamilyType,  dst.FamilyAddress = src.FamilyAddress,
										   dst.Ethnicity = src.Ethnicity,  dst.ConfirmationNo = src.ConfirmationNo,  dst.LocationId = src.LocationId 
						 FROM tblFamilies dst
						 INNER JOIN @Family src ON src.FamilyID = dst.FamilyID
					--	 WHERE  dst.FamilyID = @FamilyID;
					
					END
		/*******************************************************END INSERT FAMILY**********************************/		
				

		/****************************************************START INSERT INSUREE**********************************/
				SELECT @isOffline =I.isOffline, @CHFID=CHFID FROM @Insuree I
				
				--Insert insurees
				IF EXISTS(SELECT 1 FROM @Insuree WHERE isOffline = 1  )
						BEGIN
INSERTINSUREE:
								DECLARE CurInsuree CURSOR FOR SELECT InsureeId, CHFID, isOffline FROM @Insuree WHERE isOffline = 1 OR CHFID NOT IN (SELECT CHFID FROM tblInsuree WHERE ValidityTo IS NULL);
								OPEN CurInsuree
									FETCH NEXT FROM CurInsuree INTO @CurInsureeId, @CurHFID, @CurIsOffline;
									WHILE @@FETCH_STATUS = 0
									BEGIN
									INSERT INTO tblInsuree(FamilyId, CHFID, LastName, OtherNames, DOB, Gender, Marital, IsHead, passport, Phone, CardIssued, ValidityFrom,
									AuditUserId, isOffline, Relationship, Profession, Education, Email, TypeOfId, HFID, CurrentAddress, GeoLocation, CurrentVillage)
									SELECT @FamilyId FamilyId, CHFID, LastName, OtherNames, DOB, Gender, Marital, IsHead, passport, Phone, CardIssued, GETDATE() ValidityFrom,
									@AuditUserId AuditUserId, 0 isOffline, Relationship, Profession, Education, Email, TypeOfId, HFID, CurrentAddress, GeoLocation, CurrentVillage
									FROM @Insuree WHERE InsureeId = @CurInsureeId;
									DECLARE @NewExistingInsureeId  INT  =0
									SELECT @NewExistingInsureeId= SCOPE_IDENTITY();


									--Now we will insert new insuree in the table tblInsureePolicy
									 EXEC uspAddInsureePolicy @NewExistingInsureeId	


									IF @isOffline <> 1 AND @ReturnValue = 0 SET @ReturnValue = @NewExistingInsureeId
									UPDATE @Insuree SET InsureeId = @NewExistingInsureeId WHERE InsureeId = @CurInsureeId
									--Insert photo entry
									INSERT INTO tblPhotos(InsureeID,CHFID,PhotoFolder,PhotoFileName,OfficerID,PhotoDate,ValidityFrom,AuditUserID)
									--SELECT I.InsureeId, I.CHFID, @AssociatedPhotoFolder+'\'PhotoFolder, dt.PhotoPath, @OfficerId OfficerId, GETDATE() PhotoDate, GETDATE() ValidityFrom, @AuditUserId AuditUserId
									--FROM tblInsuree I 
									--INNER JOIN @Insuree dt ON dt.CHFID = I.CHFID
									----WHERE I.FamilyId = @FamilyId
									--WHERE dt.InsureeId=@NewInsureeId
									--AND ValidityTo IS NULL;

									SELECT @NewExistingInsureeId InsureeId, @CHFID CHFID, @AssociatedPhotoFolder photoFolder, PhotoPath photoFileName, @OfficerId OfficerID, getdate() photoDate, getdate() ValidityFrom,@AuditUserId AuditUserId
									FROM @Insuree WHERE InsureeId=@NewExistingInsureeId 

									--Update photoId in Insuree
									UPDATE I SET PhotoId = PH.PhotoId, I.PhotoDate = PH.PhotoDate
									FROM tblInsuree I
									INNER JOIN tblPhotos PH ON PH.InsureeId = I.InsureeId
									WHERE I.FamilyId = @FamilyId;
									FETCH NEXT FROM CurInsuree INTO @CurInsureeId, @CurHFID, @CurIsOffline;
									END
							CLOSE CurInsuree
							DEALLOCATE CurInsuree;
					
					
							--Get the id of the HOF and update Family
							SELECT @HOFId = InsureeId FROM tblInsuree WHERE FamilyId = @FamilyId AND IsHead = 1
							UPDATE tblFamilies SET InsureeId = @HOFId WHERE Familyid = @FamilyId 
					
					END
				ELSE
					BEGIN
						IF EXISTS (
								SELECT 1 FROM @Insuree dt 
								LEFT JOIN tblInsuree I ON I.CHFID = dt.CHFID AND I.ValidityTo IS NULL 
								WHERE  I.InsureeID IS NULL AND dt.isOffline =0 
									)
							BEGIN
								--SET @FamilyId = (SELECT TOP 1 FamilyId FROM @Family)
								GOTO INSERTINSUREE;
							END
									
						ELSE
						BEGIN
							DECLARE CurUpdateInsuree CURSOR FOR SELECT  TI.CHFID FROM @Insuree TI INNER JOIN tblInsuree I ON TI.CHFID=I.CHFID WHERE  I.ValidityTo IS NULL;
							OPEN CurUpdateInsuree
							FETCH NEXT FROM CurUpdateInsuree INTO  @CHFID;
								WHILE @@FETCH_STATUS = 0
								BEGIN
									DECLARE @InsureeId INT,
											@PhotoFileName NVARCHAR(200)
									SELECT @InsureeId = InsureeId, @PhotoFileName = PhotoPath FROM @Insuree WHERE CHFID = @CHFID
									update @Insuree set InsureeId = (select TOP 1 InsureeId from tblInsuree where CHFID = @CHFID and ValidityTo is null)
									where CHFID = @CHFID
									--Insert Insuree History
									INSERT INTO tblInsuree ([FamilyID],[CHFID],[LastName],[OtherNames],[DOB],[Gender],[Marital],[IsHead],[passport],[Phone],[PhotoID],						[PhotoDate],[CardIssued],isOffline,[AuditUserID],[ValidityFrom] ,[ValidityTo],legacyId,[Relationship],[Profession],[Education],[Email],[TypeOfId],[HFID], [CurrentAddress], [GeoLocation], [CurrentVillage]) 
									SELECT	[FamilyID],[CHFID],[LastName],[OtherNames],[DOB],[Gender],[Marital],[IsHead],[passport],[Phone],[PhotoID],[PhotoDate],[CardIssued],isOffline,[AuditUserID],[ValidityFrom] ,GETDATE(),InsureeID,[Relationship],[Profession],[Education],[Email] ,[TypeOfId],[HFID], [CurrentAddress], [GeoLocation], [CurrentVillage] 
									FROM tblInsuree WHERE InsureeID = @InsureeId; 

									--Update Insuree Record
									UPDATE dst SET dst.[CHFID] = @CHFID, dst.[LastName] = src.LastName,dst.[OtherNames] = src.OtherNames,dst.[DOB] = src.DOB,dst.[Gender] = src.Gender ,dst.[Marital] = src.Marital,dst.[passport] = src.passport,dst.[Phone] = src.Phone,dst.[PhotoDate] = GETDATE(),dst.[CardIssued] = src.CardIssued,dst.isOffline=0,dst.[ValidityFrom] = GetDate(),dst.[AuditUserID] = @AuditUserID ,dst.[Relationship] = src.Relationship, dst.[Profession] = src.Profession, dst.[Education] = src.Education,dst.[Email] = src.Email ,dst.TypeOfId = src.TypeOfId,dst.HFID = src.HFID, dst.CurrentAddress = src.CurrentAddress, dst.CurrentVillage = src.CurrentVillage, dst.GeoLocation = src.GeoLocation 
									FROM tblInsuree dst
									LEFT JOIN @Insuree src ON src.InsureeId = dst.InsureeID
									WHERE dst.InsureeId = @InsureeId;

									--Insert Photo  History
									DECLARE @PhotoId INT =  (SELECT PhotoID from tblInsuree where CHFID = @CHFID AND LegacyID is NULL and ValidityTo is NULL) 
									INSERT INTO tblPhotos(InsureeID,CHFID,PhotoFolder,PhotoFileName,PhotoDate,OfficerID,ValidityFrom,ValidityTo,AuditUserID) 
									SELECT InsureeID,CHFID,PhotoFolder,PhotoFileName,PhotoDate,OfficerID,ValidityFrom,GETDATE(),AuditUserID 
									FROM tblPhotos WHERE PhotoID = @PhotoID;

									--Update Photo
								
									UPDATE tblPhotos SET PhotoFolder = @AssociatedPhotoFolder+'\',PhotoFileName = @PhotoFileName, OfficerID = @OfficerID, ValidityFrom = GETDATE(), AuditUserID = @AuditUserID 
									WHERE PhotoID = @PhotoID
								FETCH NEXT FROM CurUpdateInsuree INTO  @CurHFID;
								END
							CLOSE CurUpdateInsuree
							DEALLOCATE CurUpdateInsuree;

						END
						
						END
				/****************************************************END INSERT INSUREE**********************************/



				/****************************************************END INSERT POLICIES**********************************/
				
				SELECT TOP 1 @isOffline = P.isOffline FROM @Policy P
				IF EXISTS(SELECT 1 FROM @Policy WHERE isOffline = 1)
				BEGIN

		INSERTPOLICY:
		DECLARE @isOfflinePolicy bit=0;
		
					--INSERT POLICIES
						DECLARE CurPolicy CURSOR FOR SELECT PolicyId, ProdId, ISNULL(PolicyStage, N'N') PolicyStage, EnrollDate,FamilyId,isOffline FROM @Policy WHERE isOffline = 1 OR PolicyId NOT IN (SELECT PolicyId FROM tblPolicy WHERE ValidityTo	 IS NULL);
						OPEN CurPolicy
							FETCH NEXT FROM CurPolicy INTO @PolicyId, @ProdId, @PolicyStage, @EnrollDate,@FamilyId,@isOfflinePolicy;
							WHILE @@FETCH_STATUS = 0
							BEGIN

								EXEC @PolicyValue = uspPolicyValue @FamilyId,
																	@ProdId,
																	0,
																	@PolicyStage,
																	@EnrollDate,
																	0,
																	@ErrorCode OUTPUT;


								SELECT @GivenPolicyValue = PolicyValue, @PolicyStatus = PolicyStatus FROM @Policy WHERE PolicyId = @PolicyId;
								IF @GivenPolicyValue < @PolicyValue

								--amani 17/12/2017
								if NOT @isOfflinePolicy =1
									SET @PolicyStatus = 1
								ELSE
									SET @PolicyStatus=2

								INSERT INTO tblPolicy(FamilyId, EnrollDate, StartDate, EffectiveDate, ExpiryDate, PolicyStatus, PolicyValue, 
								ProdId, OfficerId, ValidityFrom, AuditUserId, isOffline, PolicyStage)
								SELECT @FamilyId FamilyId, EnrollDate, StartDate, EffectiveDate, ExpiryDate, @PolicyStatus PolicyStatus, @PolicyValue PolicyValue, 
								ProdId, OfficerId, GETDATE() ValidityFrom, @AuditUserId AuditUserId, 0 isOffline, @PolicyStage PolicyStage
								FROM @Policy
								WHERE PolicyId = @PolicyId;

								SELECT @NewPolicyId = SCOPE_IDENTITY();
								UPDATE @Premium SET PolicyId = @NewPolicyId WHERE PolicyId = @PolicyId 



								IF @isOffline <> 1 AND @ReturnValue = 0  
									BEGIN
										SET @ReturnValue = @NewPolicyId;
										--AND isOffline = 0
									END
								--Insert policy Insuree
								
								----Amani added for Only New Family
								--IF EXISTS(SELECT 1 FROM tblFamilies F INNER JOIN tblInsuree I ON I.FamilyID=F.FamilyID
								--WHERE F.ValidityTo IS NULL AND I.ValidityTo IS NULL AND I.CHFID=@HOFCHFID)

				
								IF   EXISTS(SELECT 1 FROM @Premium WHERE isOffline = 1)
								BEGIN
									INSERT INTO tblPremium(PolicyId, PayerId, Amount, Receipt, PayDate, PayType, ValidityFrom, AuditUserId, isOffline, isPhotoFee)
									SELECT  PolicyId, PayerId, Amount, Receipt, PayDate, PayType, GETDATE() ValidityFrom, @AuditUserId AuditUserId, 0 isOffline, isPhotoFee 
									FROM @Premium
									WHERE PolicyId = @NewPolicyId;
								END


								BEGIN--Existing Family


								--SELECT InsureeID FROM tblInsuree WHERE FamilyID IN (SELECT FamilyID FROM tblPolicy WHERE PolicyID=@NewPolicyId AND ValidityTo IS NULL) AND ValidityTo IS NULL ORDER BY InsureeID ASC


										--DECLARE @NewCurrentInsureeId INT =0
										--DECLARE CurNewCurrentInsuree CURSOR FOR 	
										--SELECT InsureeID FROM tblInsuree WHERE FamilyID IN (SELECT FamilyID FROM tblPolicy WHERE PolicyID=@NewPolicyId AND ValidityTo IS NULL) AND ValidityTo IS NULL 
										--AND InsureeID NOT IN (SELECT InsureeID FROM tblInsureePolicy WHERE PolicyID=@NewPolicyId AND ValidityTo IS NULL)
										--ORDER BY InsureeID ASC
													--OPEN CurNewCurrentInsuree
														--FETCH NEXT FROM CurNewCurrentInsuree INTO @NewCurrentInsureeId
														--WHILE @@FETCH_STATUS = 0
														--BEGIN
														--Now we will insert new insuree in the table tblInsureePolicy
															EXEC uspAddInsureePolicyOffline  @NewPolicyId
															--FETCH NEXT FROM CurNewCurrentInsuree INTO @NewCurrentInsureeId
														--END
														
													--CLOSE CurNewCurrentInsuree
													--DEALLOCATE CurNewCurrentInsuree						
								END 

					
								FETCH NEXT FROM CurPolicy INTO @PolicyId, @ProdId, @PolicyStage, @EnrollDate, @FamilyId,@isOfflinePolicy;
						END
					CLOSE CurPolicy
					DEALLOCATE CurPolicy;
				END
			ELSE
				BEGIN 
					IF EXISTS (SELECT 1 FROM @Policy dt 
								WHERE   dt.IsOffline = 0 
								AND		dt.PolicyId NOT IN(SELECT PolicyId FROM tblPolicy WHERE ValidityTo IS NULL ) 
									 
							)
					BEGIN
						GOTO INSERTPOLICY;
					END
					--ELSE
					-- BEGIN
					----	SELECT TOP 1 @PolicyId = PolicyId  FROM @Policy 
					--	--INSERT Policy History
					--	INSERT INTO tblPolicy (FamilyID, EnrollDate, StartDate, EffectiveDate, ExpiryDate, ProdID, OfficerID,PolicyStage,PolicyStatus,PolicyValue,isOffline, ValidityTo, LegacyID, AuditUserID)
					--	SELECT FamilyID, EnrollDate, StartDate, EffectiveDate, ExpiryDate, ProdID, OfficerID,PolicyStage,PolicyStatus,PolicyValue,isOffline, GETDATE(), @PolicyID, AuditUserID FROM tblPolicy WHERE PolicyID = @PolicyID;
					--	--Update Policy Record
					--	UPDATE dst SET OfficerID= src.OfficerID, ValidityFrom=GETDATE(), AuditUserID = @AuditUserID 
					--	FROM tblPolicy dst
					--	INNER JOIN @Policy src ON src.PolicyId = dst.PolicyID
					----	WHERE src.PolicyID=@PolicyID
					--END
				END

	/****************************************************END INSERT POLICIES**********************************/
			
	/****************************************************START UPDATE PREMIUM**********************************/


			
			--SELECT TOP 1 @isOffline =  P.isOffline,  @PolicyId = PolicyId,@PremiumID=PremiumId FROM @Premium P WHERE isOffline   <> 1
			--IF @isOffline != 1
			--	BEGIN
				 
			--			IF  EXISTS(SELECT 1 FROM @Premium dt 
			--						  LEFT JOIN tblPremium P ON P.PremiumId = dt.PremiumId 
			--							WHERE P.ValidityTo IS NULL AND dt.isOffline <> 1 AND P.PremiumId IS NULL)
			--				BEGIN
			--					--INSERTPREMIMIUN
			--						INSERT INTO tblPremium(PolicyId, PayerId, Amount, Receipt, PayDate, PayType, ValidityFrom, AuditUserId, isOffline, isPhotoFee)
			--									SELECT     PolicyId, PayerId, Amount, Receipt, PayDate, PayType, GETDATE() ValidityFrom, @AuditUserId AuditUserId, 0 isOffline, isPhotoFee 
			--									FROM @Premium
			--									WHERE @isOffline <> 1;
			--									SELECT @PremiumId = SCOPE_IDENTITY();
			--					IF @isOffline <> 1 AND ISNULL(@PremiumId,0) >0 AND @ReturnValue =0 SET @ReturnValue = @PremiumId
			--				END
			--			ELSE
			--				BEGIN
			--					INSERT INTO tblPremium (PolicyID, PayerID, Amount, Receipt, PayDate, PayType,isOffline, ValidityTo, LegacyID, AuditUserID,isPhotoFee) 
			--					SELECT PolicyID, PayerID, Amount, Receipt, PayDate, PayType,isOffline, GETDATE(), @PremiumID, AuditUserID,isPhotoFee FROM tblPremium where PremiumID = @PremiumID;
				
			--					UPDATE dst set dst.PolicyID= src.PolicyID, dst.PayerID = src.PayerID, dst.Amount = src.Amount, dst.Receipt = src.Receipt, dst.PayDate =  src.PayDate, dst.PayType = src.PayType, 
			--											dst.ValidityFrom=GETDATE(), dst.LegacyID = @PremiumID, dst.AuditUserID = @AuditUserID,dst.isPhotoFee = src.isPhotoFee 
			--					FROM tblPremium dst
			--					INNER JOIN @Premium src ON src.PremiumId = dst.PremiumId
			--					--WHERE dst.PremiumID=@PremiumID;
													
			--				END
			--	 --Update InsureePolicy and Policy Table
			--	 SELECT TOP 1  @PremiumID= PremiumId , @FamilyId = FamilyId, @ProdId = Po.ProdId, @PolicyStage = PolicyStage,@EnrollDate = EnrollDate, @EffectiveDate = PayDate, @PolicyStatus = PolicyStatus
			--				FROM tblPremium P
			--				INNER JOIN tblPolicy Po ON Po.PolicyId = P.PolicyId
			--				WHERE PremiumId = @PremiumID 
			--	 EXEC @PolicyValue = uspPolicyValue		@FamilyId,
			--											@ProdId,
			--											0,
			--											@PolicyStage,
			--											@EnrollDate,
			--											0,
			--											@ErrorCode OUTPUT;
			--		SELECT @Contribution = SUM(AMOUNT) FROM tblPremium where PolicyID =@PolicyId AND ValidityTo IS NULL AND isPhotoFee = 0;
				  
			--		IF @PolicyValue <= @Contribution
			--		BEGIN
			--			UPDATE tblPolicy SET PolicyStatus = 2,EffectiveDate = @EffectiveDate   WHERE PolicyID =  @PolicyId AND ValidityTo IS NULL 
			--			UPDATE tblInsureePolicy SET EffectiveDate = @EffectiveDate WHERE ValidityTo IS NULL AND EffectiveDate IS NULL AND PolicyId = @PolicyId
			--		END
			--	END
	/****************************************************END INSERT PREMIUM**********************************/

		COMMIT TRAN UPDATEFAMILY;
		SET @ErrorMessage = '';
		RETURN @ReturnValue;
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE();
		IF @@TRANCOUNT > 0 ROLLBACK TRAN UPDATEFAMILY;
		RETURN -400;
	END CATCH
		END

END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE();
		--INSERT INTO @Result(ErrorMessage) values (@ErrorMessage)
		--IF NOT OBJECT_ID('TempResult') IS NULL
		--DROP TABLE TempResult
		--SELECT * INTO TempResult FROM @Result
		--IF @@TRANCOUNT > 0 ROLLBACK TRAN ENROLLFAMILY;
		RETURN -400;
	END CATCH



GO

--ON 10/04/2018

IF NOT OBJECT_ID('uspSSRSCapitationPayment') IS NULL
DROP PROCEDURE uspSSRSCapitationPayment
GO

CREATE PROCEDURE [dbo].[uspSSRSCapitationPayment]

(
	@RegionId INT = NULL,
	@DistrictId INT = NULL,
	@ProdId INT,
	@Year INT,
	@Month INT,
	@HFLevel xAttributeV READONLY
)
AS
BEGIN
	
	DECLARE @Level1 CHAR(1) = NULL,
			@Sublevel1 CHAR(1) = NULL,
			@Level2 CHAR(1) = NULL,
			@Sublevel2 CHAR(1) = NULL,
			@Level3 CHAR(1) = NULL,
			@Sublevel3 CHAR(1) = NULL,
			@Level4 CHAR(1) = NULL,
			@Sublevel4 CHAR(1) = NULL,
			@ShareContribution DECIMAL(5, 2),
			@WeightPopulation DECIMAL(5, 2),
			@WeightNumberFamilies DECIMAL(5, 2),
			@WeightInsuredPopulation DECIMAL(5, 2),
			@WeightNumberInsuredFamilies DECIMAL(5, 2),
			@WeightNumberVisits DECIMAL(5, 2),
			@WeightAdjustedAmount DECIMAL(5, 2)

	DECLARE @FirstDay DATE = CAST(@Year AS VARCHAR(4)) + '-' + CAST(@Month AS VARCHAR(2)) + '-01'; 
	DECLARE @LastDay DATE = EOMONTH(CAST(@Year AS VARCHAR(4)) + '-' + CAST(@Month AS VARCHAR(2)) + '-01', 0)
	DECLARE @DaysInMonth INT = DATEDIFF(DAY,@FirstDay,DATEADD(MONTH,1,@FirstDay));

	SELECT @Level1 = Level1, @Sublevel1 = Sublevel1, @Level2 = Level2, @Sublevel2 = Sublevel2, @Level3 = Level3, @Sublevel3 = Sublevel3, 
	@Level4 = Level4, @Sublevel4 = Sublevel4, @ShareContribution = ISNULL(ShareContribution, 0), @WeightPopulation = ISNULL(WeightPopulation, 0), 
	@WeightNumberFamilies = ISNULL(WeightNumberFamilies, 0), @WeightInsuredPopulation = ISNULL(WeightInsuredPopulation, 0), @WeightNumberInsuredFamilies = ISNULL(WeightNumberInsuredFamilies, 0), 
	@WeightNumberVisits = ISNULL(WeightNumberVisits, 0), @WeightAdjustedAmount = ISNULL(WeightAdjustedAmount, 0)
	FROM tblProduct Prod 
	WHERE ProdId = @ProdId;


	PRINT @ShareContribution
	PRINT @WeightPopulation
	PRINT @WeightNumberFamilies 
	PRINT @WeightInsuredPopulation 
	PRINT @WeightNumberInsuredFamilies 
	PRINT @WeightNumberVisits 
	PRINT @WeightAdjustedAmount


	;WITH TotalPopFam AS
	(
		SELECT C.HFID  ,
		CASE WHEN ISNULL(@DistrictId, @RegionId) IN (R.RegionId, D.DistrictId) THEN 1 ELSE 0 END * SUM((ISNULL(L.MalePopulation, 0) + ISNULL(L.FemalePopulation, 0) + ISNULL(L.OtherPopulation, 0)) *(0.01* Catchment))[Population], 
		CASE WHEN ISNULL(@DistrictId, @RegionId) IN (R.RegionId, D.DistrictId) THEN 1 ELSE 0 END * SUM(ISNULL(((L.Families)*(0.01* Catchment)), 0))TotalFamilies
		FROM tblHFCatchment C
		INNER JOIN tblLocations L ON L.LocationId = C.LocationId
		INNER JOIN tblHF HF ON C.HFID = HF.HfID
		INNER JOIN tblDistricts D ON HF.LocationId = D.DistrictId
		INNER JOIN tblRegions R ON D.Region = R.RegionId
		WHERE C.ValidityTo IS NULL
		AND L.ValidityTo IS NULL
		AND HF.ValidityTo IS NULL
		GROUP BY C.HFID, D.DistrictId, R.RegionId
	), InsuredInsuree AS
	(
		SELECT HC.HFID, @ProdId ProdId, COUNT(DISTINCT IP.InsureeId)*(0.01 * Catchment) TotalInsuredInsuree
		FROM tblInsureePolicy IP
		INNER JOIN tblInsuree I ON I.InsureeId = IP.InsureeId
		INNER JOIN tblFamilies F ON F.FamilyId = I.FamilyId
		INNER JOIN tblHFCatchment HC ON HC.LocationId = F.LocationId
		INNER JOIN uvwLocations L ON L.LocationId = HC.LocationId
		INNER JOIN tblPolicy PL ON PL.PolicyID = IP.PolicyId
		WHERE HC.ValidityTo IS NULL 
		AND I.ValidityTo IS NULL
		AND IP.ValidityTo IS NULL
		AND F.ValidityTo IS NULL
		AND PL.ValidityTo IS NULL
		AND IP.EffectiveDate <= @LastDay 
		AND IP.ExpiryDate > @LastDay
		AND PL.ProdID = @ProdId
		GROUP BY HC.HFID, Catchment--, L.LocationId
	), InsuredFamilies AS
	(
		SELECT HC.HFID, COUNT(DISTINCT F.FamilyID)*(0.01 * Catchment) TotalInsuredFamilies
		FROM tblInsureePolicy IP
		INNER JOIN tblInsuree I ON I.InsureeId = IP.InsureeId
		INNER JOIN tblFamilies F ON F.InsureeID = I.InsureeID
		INNER JOIN tblHFCatchment HC ON HC.LocationId = F.LocationId
		INNER JOIN uvwLocations L ON L.LocationId = HC.LocationId
		INNER JOIN tblPolicy PL ON PL.PolicyID = IP.PolicyId
		WHERE HC.ValidityTo IS NULL 
		AND I.ValidityTo IS NULL
		AND IP.ValidityTo IS NULL
		AND F.ValidityTo IS NULL
		AND PL.ValidityTo IS NULL
		AND IP.EffectiveDate <= @LastDay 
		AND IP.ExpiryDate > @LastDay
		AND PL.ProdID = @ProdId
		GROUP BY HC.HFID, Catchment--, L.LocationId
	), Claims AS
	(
		SELECT C.HFID,  COUNT(C.ClaimId)TotalClaims
		FROM tblClaim C
		INNER JOIN (
			SELECT ClaimId FROM tblClaimItems WHERE ProdId = @ProdId AND ValidityTo IS NULL
			UNION
			SELECT ClaimId FROM tblClaimServices WHERE ProdId = @ProdId AND ValidityTo IS NULL
			) CProd ON CProd.ClaimID = C.ClaimID
		WHERE C.ValidityTo IS NULL
		AND C.ClaimStatus >= 8
		AND YEAR(C.DateProcessed) = @Year
		AND MONTH(C.DateProcessed) = @Month
		GROUP BY C.HFID
	), ClaimValues AS
	(
		SELECT HFID, @ProdId ProdId, SUM(PriceValuated)TotalAdjusted
		FROM(
		SELECT C.HFID, CValue.PriceValuated
		FROM tblClaim C
		INNER JOIN (
			SELECT ClaimId, PriceValuated FROM tblClaimItems WHERE ValidityTo IS NULL AND ProdId = @ProdId
			UNION ALL
			SELECT ClaimId, PriceValuated FROM tblClaimServices WHERE ValidityTo IS NULL AND ProdId = @ProdId
			) CValue ON CValue.ClaimID = C.ClaimID
		WHERE C.ValidityTo IS NULL
		AND C.ClaimStatus >= 8
		AND YEAR(C.DateProcessed) = @Year
		AND MONTH(C.DateProcessed) = @Month
		)CValue
		GROUP BY HFID
	),Locations AS
	(
		SELECT 0 LocationId, N'National' LocationName, NULL ParentLocationId
		UNION
		SELECT LocationId,LocationName, ISNULL(ParentLocationId, 0) FROM tblLocations WHERE ValidityTo IS NULL AND LocationId = ISNULL(@DistrictId, @RegionId)
		UNION ALL
		SELECT L.LocationId, L.LocationName, L.ParentLocationId 
		FROM tblLocations L 
		INNER JOIN Locations ON Locations.LocationId = L.ParentLocationId
		WHERE L.validityTo IS NULL
		AND L.LocationType IN ('R', 'D')
	), Allocation AS
	(
		SELECT ProdId, CAST(SUM(ISNULL(Allocated, 0)) AS DECIMAL(18, 6))Allocated
		FROM
		(SELECT PL.ProdID,
		CASE 
		WHEN MONTH(DATEADD(D,-1,PL.ExpiryDate)) = @Month AND YEAR(DATEADD(D,-1,PL.ExpiryDate)) = @Year AND (DAY(PL.ExpiryDate)) > 1
			THEN CASE WHEN DATEDIFF(D,CASE WHEN PR.PayDate < @FirstDay THEN @FirstDay ELSE PR.PayDate END,PL.ExpiryDate) = 0 THEN 1 ELSE DATEDIFF(D,CASE WHEN PR.PayDate < @FirstDay THEN @FirstDay ELSE PR.PayDate END,PL.ExpiryDate) END  * ((SUM(PR.Amount))/(CASE WHEN (DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate)) <= 0 THEN 1 ELSE DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate) END))
		WHEN MONTH(CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END) = @Month AND YEAR(CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END) = @Year
			THEN ((@DaysInMonth + 1 - DAY(CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END)) * ((SUM(PR.Amount))/CASE WHEN DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate) <= 0 THEN 1 ELSE DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate) END)) 
		WHEN PL.EffectiveDate < @FirstDay AND PL.ExpiryDate > @LastDay AND PR.PayDate < @FirstDay
			THEN @DaysInMonth * (SUM(PR.Amount)/CASE WHEN (DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,DATEADD(D,-1,PL.ExpiryDate))) <= 0 THEN 1 ELSE DATEDIFF(DAY,CASE WHEN PR.PayDate < PL.EffectiveDate THEN PL.EffectiveDate ELSE PR.PayDate END,PL.ExpiryDate) END)
		END Allocated
		FROM tblPremium PR 
		INNER JOIN tblPolicy PL ON PR.PolicyID = PL.PolicyID
		INNER JOIN tblProduct Prod ON Prod.ProdId = PL.ProdID
		INNER JOIN Locations L ON ISNULL(Prod.LocationId, 0) = L.LocationId
		WHERE PR.ValidityTo IS NULL
		AND PL.ValidityTo IS NULL
		AND PL.ProdID = @ProdId
		AND PL.PolicyStatus <> 1
		AND PR.PayDate <= PL.ExpiryDate
		GROUP BY PL.ProdID, PL.ExpiryDate, PR.PayDate,PL.EffectiveDate)Alc
		GROUP BY ProdId
	)



	,ReportData AS
	(
		SELECT L.RegionCode, L.RegionName, L.DistrictCode, L.DistrictName, HF.HFCode, HF.HFName, Hf.AccCode, HL.Name HFLevel, SL.HFSublevelDesc HFSublevel,
		PF.[Population] [Population], PF.TotalFamilies TotalFamilies, II.TotalInsuredInsuree, IFam.TotalInsuredFamilies, C.TotalClaims, CV.TotalAdjusted
		,(
			  ISNULL(ISNULL(PF.[Population], 0) * (Allocation.Allocated * (0.01 * @ShareContribution) * (0.01 * @WeightPopulation)) /  NULLIF(SUM(PF.[Population])OVER(),0),0)  
			+ ISNULL(ISNULL(PF.TotalFamilies, 0) * (Allocation.Allocated * (0.01 * @ShareContribution) * (0.01 * @WeightNumberFamilies)) /NULLIF(SUM(PF.[TotalFamilies])OVER(),0),0) 
			+ ISNULL(ISNULL(II.TotalInsuredInsuree, 0) * (Allocation.Allocated * (0.01 * @ShareContribution) * (0.01 * @WeightInsuredPopulation)) /NULLIF(SUM(II.TotalInsuredInsuree)OVER(),0),0) 
			+ ISNULL(ISNULL(IFam.TotalInsuredFamilies, 0) * (Allocation.Allocated * (0.01 * @ShareContribution) * (0.01 * @WeightNumberInsuredFamilies)) /NULLIF(SUM(IFam.TotalInsuredFamilies)OVER(),0),0) 
			+ ISNULL(ISNULL(C.TotalClaims, 0) * (Allocation.Allocated * (0.01 * @ShareContribution) * (0.01 * @WeightNumberVisits)) /NULLIF(SUM(C.TotalClaims)OVER() ,0),0) 
			+ ISNULL(ISNULL(CV.TotalAdjusted, 0) * (Allocation.Allocated * (0.01 * @ShareContribution) * (0.01 * @WeightAdjustedAmount)) /NULLIF(SUM(CV.TotalAdjusted)OVER(),0),0)

		) PaymentCathment

		, Allocation.Allocated * (0.01 * @WeightPopulation) * (0.01 * @ShareContribution) AlcContriPopulation
		, Allocation.Allocated * (0.01 * @WeightNumberFamilies) * (0.01 * @ShareContribution) AlcContriNumFamilies
		, Allocation.Allocated * (0.01 * @WeightInsuredPopulation) * (0.01 * @ShareContribution) AlcContriInsPopulation
		, Allocation.Allocated * (0.01 * @WeightNumberInsuredFamilies) * (0.01 * @ShareContribution) AlcContriInsFamilies
		, Allocation.Allocated * (0.01 * @WeightNumberVisits) * (0.01 * @ShareContribution) AlcContriVisits
		, Allocation.Allocated * (0.01 * @WeightAdjustedAmount) * (0.01 * @ShareContribution) AlcContriAdjustedAmount

		,  ISNULL((Allocation.Allocated * (0.01 * @WeightPopulation) * (0.01 * @ShareContribution))/ NULLIF(SUM(PF.[Population]) OVER(),0),0) UPPopulation
		,  ISNULL((Allocation.Allocated * (0.01 * @WeightNumberFamilies) * (0.01 * @ShareContribution))/NULLIF(SUM(PF.TotalFamilies) OVER(),0),0) UPNumFamilies
		,  ISNULL((Allocation.Allocated * (0.01 * @WeightInsuredPopulation) * (0.01 * @ShareContribution))/NULLIF(SUM(II.TotalInsuredInsuree) OVER(),0),0) UPInsPopulation
		,  ISNULL((Allocation.Allocated * (0.01 * @WeightNumberInsuredFamilies) * (0.01 * @ShareContribution))/ NULLIF(SUM(IFam.TotalInsuredFamilies) OVER(),0),0) UPInsFamilies
		,  ISNULL((Allocation.Allocated * (0.01 * @WeightNumberVisits) * (0.01 * @ShareContribution)) / NULLIF(SUM(C.TotalClaims) OVER(),0),0) UPVisits
		,  ISNULL((Allocation.Allocated * (0.01 * @WeightAdjustedAmount) * (0.01 * @ShareContribution))/ NULLIF(SUM(CV.TotalAdjusted) OVER(),0),0) UPAdjustedAmount




		FROM tblHF HF
		INNER JOIN @HFLevel HL ON HL.Code = HF.HFLevel
		LEFT OUTER JOIN tblHFSublevel SL ON SL.HFSublevel = HF.HFSublevel
		INNER JOIN uvwLocations L ON L.LocationId = HF.LocationId
		LEFT OUTER JOIN TotalPopFam PF ON PF.HFID = HF.HfID
		LEFT OUTER JOIN InsuredInsuree II ON II.HFID = HF.HfID
		LEFT OUTER JOIN InsuredFamilies IFam ON IFam.HFID = HF.HfID
		LEFT OUTER JOIN Claims C ON C.HFID = HF.HfID
		LEFT OUTER JOIN ClaimValues CV ON CV.HFID = HF.HfID
		LEFT OUTER JOIN Allocation ON Allocation.ProdID = @ProdId

		WHERE HF.ValidityTo IS NULL
		AND (((L.RegionId = @RegionId OR @RegionId IS NULL) AND (L.DistrictId = @DistrictId OR @DistrictId IS NULL)) OR CV.ProdID IS NOT NULL OR II.ProdId IS NOT NULL)
		AND (HF.HFLevel IN (@Level1, @Level2, @Level3, @Level4) OR (@Level1 IS NULL AND @Level2 IS NULL AND @Level3 IS NULL AND @Level4 IS NULL))
		AND(
			((HF.HFLevel = @Level1 OR @Level1 IS NULL) AND (HF.HFSublevel = @Sublevel1 OR @Sublevel1 IS NULL))
			OR ((HF.HFLevel = @Level2 ) AND (HF.HFSublevel = @Sublevel2 OR @Sublevel2 IS NULL))
			OR ((HF.HFLevel = @Level3) AND (HF.HFSublevel = @Sublevel3 OR @Sublevel3 IS NULL))
			OR ((HF.HFLevel = @Level4) AND (HF.HFSublevel = @Sublevel4 OR @Sublevel4 IS NULL))
		  )

	)



	SELECT  MAX (RegionCode)RegionCode, 
			MAX(RegionName)RegionName,
			MAX(DistrictCode)DistrictCode,
			MAX(DistrictName)DistrictName,
			HFCode, 
			MAX(HFName)HFName,
			MAX(AccCode)AccCode, 
			MAX(HFLevel)HFLevel, 
			MAX(HFSublevel)HFSublevel,
			ISNULL(SUM([Population]),0)[Population],
			ISNULL(SUM(TotalFamilies),0)TotalFamilies,
			ISNULL(SUM(TotalInsuredInsuree),0)TotalInsuredInsuree,
			ISNULL(SUM(TotalInsuredFamilies),0)TotalInsuredFamilies,
			ISNULL(MAX(TotalClaims), 0)TotalClaims,
			ISNULL(SUM(AlcContriPopulation),0)AlcContriPopulation,
			ISNULL(SUM(AlcContriNumFamilies),0)AlcContriNumFamilies,
			ISNULL(SUM(AlcContriInsPopulation),0)AlcContriInsPopulation,
			ISNULL(SUM(AlcContriInsFamilies),0)AlcContriInsFamilies,
			ISNULL(SUM(AlcContriVisits),0)AlcContriVisits,
			ISNULL(SUM(AlcContriAdjustedAmount),0)AlcContriAdjustedAmount,
			ISNULL(SUM(UPPopulation),0)UPPopulation,
			ISNULL(SUM(UPNumFamilies),0)UPNumFamilies,
			ISNULL(SUM(UPInsPopulation),0)UPInsPopulation,
			ISNULL(SUM(UPInsFamilies),0)UPInsFamilies,
			ISNULL(SUM(UPVisits),0)UPVisits,
			ISNULL(SUM(UPAdjustedAmount),0)UPAdjustedAmount,
			ISNULL(SUM(PaymentCathment),0)PaymentCathment,
			ISNULL(SUM(TotalAdjusted),0)TotalAdjusted
	
	 FROM ReportData

	 GROUP BY HFCode



END
GO

--ON 11/04/2018
IF NOT OBJECT_ID('uspUploadHFXML') IS NULL
DROP PROCEDURE [dbo].[uspUploadHFXML]
GO

CREATE PROCEDURE [dbo].[uspUploadHFXML]
(
	@File NVARCHAR(300),
	@StrategyId INT,	--1	: Insert Only,	2: Update Only	3: Insert & Update	7: Insert, Update & Delete
	@AuditUserID INT = -1,
	@DryRun BIT=0,
	@SentHF INT = 0 OUTPUT,
	@Inserts INT  = 0 OUTPUT,
	@Updates INT  = 0 OUTPUT
	--@sentCatchment INT =0 OUTPUT,
	--@InsertCatchment INT =0 OUTPUT,
	--@UpdateCatchment INT =0 OUTPUT
)
AS
BEGIN

	/* Result type in @tblResults
	-------------------------------
		E	:	Error
		C	:	Conflict
		FE	:	Fatal Error

	Return Values
	------------------------------
		0	:	All Okay
		-1	:	Fatal error
	*/
	
	DECLARE @InsertOnly INT = 1,
			@UpdateOnly INT = 2,
			@Delete INT= 4

	SET @Inserts = 0;
	SET @Updates = 0;
	
	DECLARE @Query NVARCHAR(500)
	DECLARE @XML XML
	DECLARE @tblHF TABLE(LegalForms NVARCHAR(15), [Level] NVARCHAR(15)  NULL, SubLevel NVARCHAR(15), Code NVARCHAR (50) NULL, Name NVARCHAR (101) NULL, [Address] NVARCHAR (101), DistrictCode NVARCHAR (50) NULL,Phone NVARCHAR (51), Fax NVARCHAR (51), Email NVARCHAR (51), CareType CHAR (15) NULL, AccountCode NVARCHAR (26),ItemPriceListName NVARCHAR(120),ServicePriceListName NVARCHAR(120), IsValid BIT )
	DECLARE @tblResult TABLE(Result NVARCHAR(Max), ResultType NVARCHAR(2))
	DECLARE @tblCatchment TABLE(HFCode NVARCHAR(50), VillageCode NVARCHAR(50),Percentage INT, IsValid BIT )

	BEGIN TRY
		IF @AuditUserID IS NULL
			SET @AuditUserID=-1

		SET @Query = (N'SELECT @XML = CAST(X as XML) FROM OPENROWSET(BULK  '''+ @File +''' ,SINGLE_BLOB) AS T(X)')

		EXECUTE SP_EXECUTESQL @Query,N'@XML XML OUTPUT',@XML OUTPUT

		IF ( @XML.exist('(HealthFacilities/HealthFacilityDetails)')=1)
			BEGIN
				--GET ALL THE HF FROM THE XML
				INSERT INTO @tblHF(LegalForms,[Level],SubLevel,Code,Name,[Address],DistrictCode,Phone,Fax,Email,CareType,AccountCode, ItemPriceListName, ServicePriceListName, IsValid)
				SELECT 
				NULLIF(T.F.value('(LegalForm)[1]','NVARCHAR(15)'),''),
				NULLIF(T.F.value('(Level)[1]','NVARCHAR(15)'),''),
				NULLIF(T.F.value('(SubLevel)[1]','NVARCHAR(15)'),''),
				T.F.value('(Code)[1]','NVARCHAR(50)'),
				T.F.value('(Name)[1]','NVARCHAR(101)'),
				T.F.value('(Address)[1]','NVARCHAR(101)'),
				NULLIF(T.F.value('(DistrictCode)[1]','NVARCHAR(50)'),''),
				T.F.value('(Phone)[1]','NVARCHAR(51)'),
				T.F.value('(Fax)[1]','NVARCHAR(51)'),
				T.F.value('(Email)[1]','NVARCHAR(51)'),
				NULLIF(T.F.value('(CareType)[1]','NVARCHAR(15)'),''),
				T.F.value('(AccountCode)[1]','NVARCHAR(26)'),
				NULLIF(T.F.value('(ItemPriceListName)[1]','NVARCHAR(26)'), ''),
				NULLIF(T.F.value('(ServicePriceListName)[1]','NVARCHAR(26)'), ''),
				1
				FROM @XML.nodes('HealthFacilities/HealthFacilityDetails/HealthFacility') AS T(F)

				SELECT @SentHF=@@ROWCOUNT


				INSERT INTO @tblCatchment(HFCode,VillageCode,Percentage,IsValid)
				SELECT 
				C.CT.value('(HFCode)[1]','NVARCHAR(50)'),
				C.CT.value('(VillageCode)[1]','NVARCHAR(50)'),
				C.CT.value('(Percentage)[1]','INT'),
				1
				FROM @XML.nodes('HealthFacilities/CatchmentDetails/Catchment') AS C(CT)

				--SELECT @sentCatchment=@@ROWCOUNT
			END
		ELSE
			BEGIN
				RAISERROR (N'-200', 16, 1);
			END
			
			
		--SELECT * INTO tempHF FROM @tblHF;
		--SELECT * INTO tempCatchment FROM @tblCatchment;

		--RETURN;

		/*========================================================================================================
		VALIDATION STARTS
		========================================================================================================*/	
		--Invalidate empty code or empty name 
			IF EXISTS(
				SELECT 1
				FROM @tblHF HF 
				WHERE LEN(ISNULL(HF.Code, '')) = 0
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT CONVERT(NVARCHAR(3), COUNT(HF.Code)) + N' HF(s) have empty code', N'E'
			FROM @tblHF HF 
			WHERE LEN(ISNULL(HF.Code, '')) = 0

			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty name field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Name, '')) = 0


			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Name, '')) = 0 OR LEN(ISNULL(HF.Code, '')) = 0

			--Ivalidate empty Legal Forms
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty LegaForms field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.LegalForms, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.LegalForms, '')) = 0 


			--Ivalidate empty Level
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty Level field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Level, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.Level, '')) = 0 

			--Ivalidate empty District Code
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty District Code field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.DistrictCode, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.DistrictCode, '')) = 0 OR LEN(ISNULL(HF.Code, '')) = 0

				--Ivalidate empty Care Type
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has empty Care Type field', N'E'
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.CareType, '')) = 0

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(ISNULL(HF.CareType, '')) = 0 OR LEN(ISNULL(HF.Code, '')) = 0


			--Invalidate HF with duplicate Codes
			IF EXISTS(SELECT 1 FROM @tblHF  GROUP BY Code HAVING COUNT(Code) >1)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT QUOTENAME(Code) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(Code)) + ' times in the file', N'C'
			FROM @tblHF  GROUP BY Code HAVING COUNT(Code) >1

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE code in (SELECT code from @tblHF GROUP BY Code HAVING COUNT(Code) >1)

			--Invalidate HF with invalid Legal Forms
			INSERT INTO @tblResult(Result,ResultType)
			SELECT 'HF Code '+QUOTENAME(Code) +' has invalid Legal Form', N'E'  FROM @tblHF HF LEFT OUTER JOIN tblLegalForms LF ON HF.LegalForms = LF.LegalFormCode 	WHERE LF.LegalFormCode IS NULL AND NOT HF.LegalForms IS NULL
			
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN tblLegalForms LF ON HF.LegalForms = LF.LegalFormCode 	WHERE LF.LegalFormCode IS NULL AND NOT HF.LegalForms IS NULL)


			--Ivalidate HF with invalid Disrict Code
			IF EXISTS(SELECT 1  FROM @tblHF HF 	LEFT OUTER JOIN tblLocations L ON L.LocationCode=HF.DistrictCode AND L.ValidityTo IS NULL	WHERE	L.LocationCode IS NULL AND NOT HF.DistrictCode IS NULL)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'HF Code ' + QUOTENAME(HF.Code) + N' has invalid District Code', N'E'
			FROM @tblHF HF 	LEFT OUTER JOIN tblLocations L ON L.LocationCode=HF.DistrictCode AND L.ValidityTo IS NULL	WHERE L.LocationCode IS NULL AND NOT HF.DistrictCode IS NULL
	
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE HF.DistrictCode IN (SELECT HF.DistrictCode  FROM @tblHF HF 	LEFT OUTER JOIN tblLocations L ON L.LocationCode=HF.DistrictCode AND L.ValidityTo IS NULL WHERE  L.LocationCode IS NULL)

			--Invalidate HF with invalid Level
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+ QUOTENAME(HF.Code)+' has invalid Level', N'E'   FROM @tblHF HF LEFT OUTER JOIN (SELECT HFLevel FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFLevel) L ON HF.Level = L.HFLevel WHERE L.HFLevel IS NULL AND NOT HF.Level IS NULL
			
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF 
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN (SELECT HFLevel FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFLevel) L ON HF.Level = L.HFLevel WHERE L.HFLevel IS NULL AND NOT HF.Level IS NULL)
			
			--Invalidate HF with invalid SubLevel
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+QUOTENAME(HF.Code) +' has invalid SubLevel' ,N'E'  FROM @tblHF HF LEFT OUTER JOIN tblHFSublevel HSL ON HSL.HFSublevel= HF.SubLevel WHERE HSL.HFSublevel IS NULL AND NOT HF.SubLevel IS NULL
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF 
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN tblHFSublevel HSL ON HSL.HFSublevel= HF.SubLevel WHERE HSL.HFSublevel IS NULL AND NOT HF.SubLevel IS NULL)

			--Remove HF with invalid CareType
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+QUOTENAME(HF.Code) +' has invalid CareType',N'E'   FROM @tblHF HF LEFT OUTER JOIN (SELECT HFCareType FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFCareType) CT ON HF.CareType = CT.HFCareType WHERE CT.HFCareType IS NULL AND NOT HF.CareType IS NULL
			UPDATE HF SET IsValid = 0
			FROM @tblHF HF 
			WHERE Code IN (SELECT Code FROM @tblHF HF LEFT OUTER JOIN (SELECT HFCareType FROM tblHF WHERE ValidityTo IS NULL GROUP BY HFCareType) CT ON HF.CareType = CT.HFCareType WHERE CT.HFCareType IS NULL)


			--Check if any HF Code is greater than 8 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Code ' + QUOTENAME(HF.Code) + ' is greater than 8 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Code) > 8;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Code) > 8;

			--Check if any HF Name is greater than 100 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Name ' + QUOTENAME(HF.Code) + ' is greater than 100 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Name) > 100;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Name) > 100;


			--Check if any HF Address is greater than 100 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Address ' + QUOTENAME(HF.Code) + ' is greater than 100 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Address) > 100;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Address) > 100;

			--Check if any HF Phone is greater than 50 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Phone ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Phone) > 50;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Phone) > 50;

			--Check if any HF Fax is greater than 50 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Fax ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Fax) > 50;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Fax) > 50;

			--Check if any HF Email is greater than 50 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Email ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.Email) > 50;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.Email) > 50;

			--Check if any HF AccountCode is greater than 25 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the HF Account Code ' + QUOTENAME(HF.Code) + ' is greater than 50 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.AccountCode) > 25;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.AccountCode) > 25;

			--Invalidate HF with invalid Item Price List Name
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+QUOTENAME(HF.Code) +' has invalid Item Price List Name' ,N'E'  
			FROM @tblHF HF
			INNER JOIN tblDistricts D ON HF.DistrictCode = D.DistrictCode
			LEFT OUTER JOIN tblPLItems PLI ON HF.ItemPriceListName = PLI.PLItemName 
			WHERE PLI.ValidityTo IS NULL 
			AND NOT(PLI.LocationId = D.DistrictId OR PLI.LocationId = D.Region)
			AND HF.ItemPriceListName IS NOT NULL;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			INNER JOIN tblDistricts D ON HF.DistrictCode = D.DistrictCode
			LEFT OUTER JOIN tblPLItems PLI ON HF.ItemPriceListName = PLI.PLItemName 
			WHERE PLI.ValidityTo IS NULL 
			AND NOT(PLI.LocationId = D.DistrictId OR PLI.LocationId = D.Region)
			AND HF.ItemPriceListName IS NOT NULL;

			--Invalidate HF with invalid Service Price List Name
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code '+QUOTENAME(HF.Code) +' has invalid Service Price List Name' ,N'E'  
			FROM @tblHF HF
			INNER JOIN tblDistricts D ON HF.DistrictCode = D.DistrictCode
			LEFT OUTER JOIN tblPLServices PLS ON HF.ServicePriceListName = PLS.PLServName 
			WHERE PLS.ValidityTo IS NULL 
			AND NOT(PLS.LocationId = D.DistrictId OR PLS.LocationId = D.Region)
			AND HF.ServicePriceListName IS NOT NULL;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			INNER JOIN tblDistricts D ON HF.DistrictCode = D.DistrictCode
			LEFT OUTER JOIN tblPLServices PLS ON HF.ServicePriceListName = PLS.PLServName 
			WHERE PLS.ValidityTo IS NULL 
			AND NOT(PLS.LocationId = D.DistrictId OR PLS.LocationId = D.Region)
			AND HF.ServicePriceListName IS NOT NULL;

			--Check if any ItemPriceList is greater than 100 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the ItemPriceListName ' + QUOTENAME(HF.Code) + ' is greater than 100 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.ItemPriceListName) > 100;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.ItemPriceListName) > 100;

			--Check if any ServicePriceListName is greater than 100 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the ServicePriceListName ' + QUOTENAME(HF.Code) + ' is greater than 100 characters', N'E'
			FROM @tblHF HF
			WHERE LEN(HF.ServicePriceListName) > 100;

			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			WHERE LEN(HF.ServicePriceListName) > 100;

			--Invalidate Catchment with empy HFCode
			IF EXISTS(SELECT  1 FROM @tblCatchment WHERE LEN(ISNULL(HFCode,''))=0)
			INSERT INTO @tblResult(Result,ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(HFCode)) + N' Catchment(s) have empty HFcode', N'E' FROM @tblCatchment WHERE LEN(ISNULL(HFCode,''))=0
			UPDATE @tblCatchment SET IsValid = 0 WHERE LEN(ISNULL(HFCode,''))=0

			--Invalidate Catchment with invalid HFCode
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'Invalid HF Code ' + QUOTENAME(C.HFCode) + N' in catchment section', N'E' FROM @tblCatchment C LEFT OUTER JOIN @tblHF HF ON C.HFCode=HF.Code WHERE HF.Code IS NULL
			UPDATE C SET C.IsValid =0 FROM @tblCatchment C LEFT OUTER JOIN @tblHF HF ON C.HFCode=HF.Code WHERE HF.Code IS NULL
		
			--Invalidate Catchment with empy VillageCode
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'HF Code ' + QUOTENAME(HFCode) + N' in catchment section have empty VillageCode', N'E' FROM @tblCatchment WHERE LEN(ISNULL(VillageCode,''))=0
			UPDATE @tblCatchment SET IsValid = 0 WHERE LEN(ISNULL(VillageCode,''))=0

			--Invalidate Catchment with invalid VillageCode
			INSERT INTO @tblResult(Result,ResultType)
			SELECT N'Invalid Village Code ' + QUOTENAME(C.VillageCode) + N' in catchment section', N'E' FROM @tblCatchment C LEFT OUTER JOIN tblLocations L ON L.LocationCode=C.VillageCode WHERE L.ValidityTo IS NULL AND L.LocationCode IS NULL AND LEN(ISNULL(VillageCode,''))>0
			UPDATE C SET IsValid=0 FROM @tblCatchment C LEFT OUTER JOIN tblLocations L ON L.LocationCode=C.VillageCode WHERE L.ValidityTo IS NULL AND L.LocationCode IS NULL
		
			--Invalidate Catchment with empy percentage
			INSERT INTO @tblResult(Result,ResultType)
			SELECT  N'HF Code ' + QUOTENAME(HFCode) + N' in catchment section has empty percentage', N'E' FROM @tblCatchment WHERE Percentage=0
			UPDATE @tblCatchment SET IsValid = 0 WHERE Percentage=0

			--Invalidate Catchment with invalid percentage
			INSERT INTO @tblResult(Result,ResultType)
			SELECT  N'HF Code ' + QUOTENAME(HFCode) + N' in catchment section has invalid percentage', N'E' FROM @tblCatchment WHERE Percentage<0 OR Percentage >100
			UPDATE @tblCatchment SET IsValid = 0 WHERE Percentage<0 OR Percentage >100

			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(C.VillageCode) + ' fount ' + CAST(COUNT(C.VillageCode) AS NVARCHAR(4)) + ' time(s) in the Catchemnt for the HF Code ' + QUOTENAME(C.HFCode), 'C'
			FROM @tblCatchment C
			GROUP BY C.HFCode, C.VillageCode
			HAVING COUNT(C.VillageCode) > 1;


			UPDATE HF SET IsValid = 0
			FROM @tblHF HF
			INNER JOIN @tblCatchment C ON HF.Code = C.HFCode
			 WHERE C.HFCode IN (
				SELECT C.HFCode
				FROM @tblCatchment C
				GROUP BY C.HFCode
				HAVING COUNT(C.VillageCode) > 1
			 )

			UPDATE C SET IsValid = 0
			FROM @tblCatchment C
			 WHERE C.HFCode IN (
				SELECT C.HFCode
				FROM @tblCatchment C
				GROUP BY C.HFCode
				HAVING COUNT(C.VillageCode) > 1
			 )


			--Get the counts
			--To be udpated
			IF (@StrategyId & @UpdateOnly) > 0
				BEGIN
					SELECT @Updates=COUNT(1) FROM @tblHF TempHF
					INNER JOIN tblHF HF ON HF.HFCode=TempHF.Code AND HF.ValidityTo IS NULL
					WHERE TempHF.IsValid=1

					--SELECT @UpdateCatchment =COUNT(1) FROM @tblCatchment C 
					--INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
					--INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
					--INNER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
					--WHERE 
					--C.IsValid =1
					--AND L.ValidityTo IS NULL
					--AND HF.ValidityTo IS NULL
					--AND HFC.ValidityTo IS NULL
				END
			
			--To be Inserted
			IF (@StrategyId & @InsertOnly) > 0
				BEGIN
				
				--Failed HF
					IF(@StrategyId=@InsertOnly)
						BEGIN
							INSERT INTO @tblResult(Result,ResultType)
							SELECT 'HF Code '+  QUOTENAME(tempHF.Code) +' already exists in Database',N'FH' 
							FROM @tblHF tempHF
							INNER JOIN tblHF HF ON tempHF.Code=HF.HFCode 
							WHERE HF.ValidityTo IS NULL 
							AND  tempHF.IsValid=1
						END

					SELECT @Inserts=COUNT(1) FROM @tblHF TempHF
					LEFT OUTER JOIN tblHF HF ON HF.HFCode=TempHF.Code AND HF.ValidityTo IS NULL
					WHERE TempHF.IsValid=1
					AND HF.HFCode IS NULL

					--SELECT @InsertCatchment=COUNT(1) FROM @tblCatchment C 
					--INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
					--INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
					--LEFT OUTER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
					--WHERE 
					--C.IsValid =1
					--AND L.ValidityTo IS NULL
					--AND HF.ValidityTo IS NULL
					--AND HFC.ValidityTo IS NULL
					--AND HFC.LocationId IS NULL
					--AND HFC.HFID IS NULL
				END
			
		/*========================================================================================================
		VALIDATION ENDS
		========================================================================================================*/	
		IF @DryRun=0
		BEGIN
			BEGIN TRAN UPLOAD
				
			/*========================================================================================================
			UDPATE STARTS
			========================================================================================================*/	
			IF  (@StrategyId & @UpdateOnly) > 0
				BEGIN

			--HF
				--Make a copy of the original record
					INSERT INTO tblHF(HFCode, HFName,[LegalForm],[HFLevel],[HFSublevel],[HFAddress],[LocationId],[Phone],[Fax],[eMail],[HFCareType],[PLServiceID],[PLItemID],[AccCode],[OffLine],[ValidityFrom],[ValidityTo],LegacyID, AuditUserId)
					SELECT HF.[HFCode] ,HF.[HFName],HF.[LegalForm],HF.[HFLevel],HF.[HFSublevel],HF.[HFAddress],HF.[LocationId],HF.[Phone],HF.[Fax],HF.[eMail],HF.[HFCareType],HF.[PLServiceID],HF.[PLItemID],HF.[AccCode],HF.[OffLine],[ValidityFrom],GETDATE()[ValidityTo],HF.HfID, @AuditUserID AuditUserId 
					FROM tblHF HF
					INNER JOIN @tblHF TempHF  ON TempHF.Code=HF.HFCode
					WHERE HF.ValidityTo IS NULL
					AND TempHF.IsValid = 1;

					SELECT @Updates = @@ROWCOUNT;
				--Upadte the record
					UPDATE HF SET HF.HFName = TempHF.Name, HF.LegalForm=TempHF.LegalForms,HF.HFLevel=TempHF.Level, HF.HFSublevel=TempHF.SubLevel,HF.HFAddress=TempHF.Address,HF.LocationId=L.LocationId, HF.Phone=TempHF.Phone, HF.Fax=TempHF.Fax, HF.eMail=TempHF.Email,HF.HFCareType=TempHF.CareType, HF.AccCode=TempHF.AccountCode, HF.PLItemID=PLI.PLItemID, HF.PLServiceID=PLS.PLServiceID, HF.OffLine=0, HF.ValidityFrom=GETDATE(), AuditUserID = @AuditUserID
					OUTPUT QUOTENAME(deleted.HFCode), N'U' INTO @tblResult
					FROM tblHF HF
					INNER JOIN @tblHF TempHF  ON HF.HFCode=TempHF.Code
					INNER JOIN tblLocations L ON L.LocationCode=TempHF.DistrictCode
					LEFT OUTER JOIN tblPLItems PLI ON PLI.PLItemName= tempHF.ItemPriceListName AND (PLI.LocationId = L.LocationId OR PLI.LocationId = L.ParentLocationId)
					LEFT OUTER JOIN tblPLServices PLS ON PLS.PLServName=tempHF.ServicePriceListName  AND (PLS.LocationId = L.LocationId OR PLS.LocationId = L.ParentLocationId)
					WHERE HF.ValidityTo IS NULL
					AND L.ValidityTo IS NULL
					AND PLI.ValidityTo IS NULL
					AND PLS.ValidityTo IS NULL
					AND TempHF.IsValid = 1;

			--CATCHMENT
					--Make a copy of the original record
					INSERT INTO [tblHFCatchment]([HFID],[LocationId],[Catchment],[ValidityFrom],ValidityTo,[LegacyId],AuditUserId)		
					SELECT HFC.HfID,HFC.LocationId, HFC.Catchment,HFC.ValidityFrom, GETDATE() ValidityTo,HFC.HFCatchmentId, HFC.AuditUserId FROM @tblCatchment C 
					INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
					INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
					INNER JOIN @tblHF tempHF ON tempHF.Code=C.HFCode
					INNER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
					WHERE 
					C.IsValid =1
					AND tempHF.IsValid=1
					AND L.ValidityTo IS NULL
					AND HF.ValidityTo IS NULL
					AND HFC.ValidityTo IS NULL

					--SELECT @UpdateCatchment =@@ROWCOUNT

					--Upadte the record
					UPDATE HFC SET HFC.HFID= HF.HfID,HFC.LocationId= L.LocationId, HFC.Catchment =C.Percentage,HFC.ValidityFrom=GETDATE(),  HFC.AuditUserId=@AuditUserID FROM @tblCatchment C 
					INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
					INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
					INNER JOIN @tblHF tempHF ON tempHF.Code=C.HFCode
					INNER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
					WHERE 
					C.IsValid =1
					AND tempHF.IsValid=1
					AND L.ValidityTo IS NULL
					AND HF.ValidityTo IS NULL
					AND HFC.ValidityTo IS NULL
				END
			/*========================================================================================================
			UPDATE ENDS
			========================================================================================================*/	


			/*========================================================================================================
			INSERT STARTS
			========================================================================================================*/	

			--INSERT HF
			IF (@StrategyId & @InsertOnly) > 0
				BEGIN
					
					INSERT INTO tblHF(HFCode, HFName,[LegalForm],[HFLevel],[HFSublevel],[HFAddress],[LocationId],[Phone],[Fax],[eMail],[HFCareType],[AccCode],[PLItemID],[PLServiceID], [OffLine],[ValidityFrom],AuditUserId)
					OUTPUT QUOTENAME(inserted.HFCode), N'I' INTO @tblResult
					SELECT TempHF.[Code] ,TempHF.[Name],TempHF.[LegalForms],TempHF.[Level],TempHF.[Sublevel],TempHF.[Address],L.LocationId,TempHF.[Phone],TempHF.[Fax],TempHF.[Email],TempHF.[CareType],TempHF.[AccountCode], PLI.PLItemID, PLS.PLServiceID,0 [OffLine],GETDATE()[ValidityFrom], @AuditUserID AuditUserId 
					FROM @tblHF TempHF 
					LEFT OUTER JOIN tblHF HF  ON TempHF.Code=HF.HFCode
					INNER JOIN tblLocations L ON L.LocationCode=TempHF.DistrictCode
					LEFT OUTER JOIN tblPLItems PLI ON PLI.PLItemName= tempHF.ItemPriceListName  AND (PLI.LocationId = L.LocationId OR PLI.LocationId = L.ParentLocationId)
					LEFT OUTER JOIN tblPLServices PLS ON PLS.PLServName=tempHF.ServicePriceListName  AND (PLS.LocationId = L.LocationId OR PLS.LocationId = L.ParentLocationId)
					WHERE HF.ValidityTo IS NULL
					AND L.ValidityTo IS NULL
					AND HF.HFCode IS NULL
					AND PLI.ValidityTo IS NULL AND PLS.ValidityTo IS NULL
					AND TempHF.IsValid = 1;
	
					SELECT @Inserts = @@ROWCOUNT;

					--INSERT CATCHMENT
					INSERT INTO [tblHFCatchment]([HFID],[LocationId],[Catchment],[ValidityFrom],[AuditUserId])
					SELECT HF.HfID,L.LocationId, C.Percentage, GETDATE() ValidityFrom, @AuditUserId FROM @tblCatchment C 
					INNER JOIN tblHF HF ON C.HFCode=HF.HFCode
					INNER JOIN tblLocations L ON L.LocationCode=C.VillageCode
					INNER JOIN @tblHF tempHF ON tempHF.Code=C.HFCode
					LEFT OUTER JOIN tblHFCatchment HFC ON HFC.LocationId=L.LocationId AND HFC.HFID=HF.HfID
					WHERE 
					C.IsValid =1
					AND tempHF.IsValid=1
					AND L.ValidityTo IS NULL
					AND HF.ValidityTo IS NULL
					AND HFC.ValidityTo IS NULL
					AND HFC.LocationId IS NULL
					AND HFC.HFID IS NULL
				
					--SELECT @InsertCatchment=@@ROWCOUNT
				END
				

			/*========================================================================================================
			INSERT ENDS
			========================================================================================================*/	

			COMMIT TRAN UPLOAD
		END

		
	END TRY
	BEGIN CATCH
		DECLARE @InvalidXML NVARCHAR(100)
		IF ERROR_NUMBER()=9436 
		BEGIN
			SET @InvalidXML='Invalid XML file, end tag does not match start tag'
			INSERT INTO @tblResult(Result, ResultType)
			SELECT @InvalidXML, N'FE';
		END
		ELSE IF  ERROR_MESSAGE()=N'-200'
			BEGIN
				INSERT INTO @tblResult(Result, ResultType)
			SELECT'Invalid HF XML file', N'FE';
			END
		ELSE
			INSERT INTO @tblResult(Result, ResultType)
			SELECT'Invalid XML file', N'FE';


		IF @@TRANCOUNT > 0 ROLLBACK TRAN UPLOAD;
		SELECT * FROM @tblResult;
		RETURN -1;
	END CATCH

	SELECT * FROM @tblResult;
	RETURN 0;
END



GO

IF NOT OBJECT_ID('uspUploadLocationsXML') IS NULL
DROP PROCEDURE [dbo].[uspUploadLocationsXML]
GO

CREATE PROCEDURE [dbo].[uspUploadLocationsXML]
(
		@File NVARCHAR(500),
		@StrategyId INT,	--1	: Insert Only,	2: Update Only	3: Insert & Update	7: Insert, Update & Delete
		@DryRun BIT,
		@AuditUserId INT,
		@SentRegion INT =0 OUTPUT,  
		@SentDistrict INT =0  OUTPUT, 
		@SentWard INT =0  OUTPUT, 
		@SentVillage INT =0  OUTPUT, 
		@InsertRegion INT =0  OUTPUT, 
		@InsertDistrict INT =0  OUTPUT, 
		@InsertWard INT =0  OUTPUT, 
		@InsertVillage INT =0 OUTPUT, 
		@UpdateRegion INT =0  OUTPUT, 
		@UpdateDistrict INT =0  OUTPUT, 
		@UpdateWard INT =0  OUTPUT, 
		@UpdateVillage INT =0  OUTPUT
)
AS 
	BEGIN

		/* Result type in @tblResults
		-------------------------------
			E	:	Error
			C	:	Conflict
			FE	:	Fatal Error

		Return Values
		------------------------------
			0	:	All Okay
			-1	:	Fatal error
		*/

		DECLARE @InsertOnly INT = 1,
				@UpdateOnly INT = 2,
				@Delete INT= 4

		SET @SentRegion = 0
		SET @SentDistrict = 0
		SET @SentWard = 0
		SET @SentVillage = 0
		SET @InsertRegion = 0
		SET @InsertDistrict = 0
		SET @InsertWard = 0
		SET @InsertVillage = 0
		SET @UpdateRegion = 0
		SET @UpdateDistrict = 0
		SET @UpdateWard = 0
		SET @UpdateVillage = 0

		DECLARE @Query NVARCHAR(500)
		DECLARE @XML XML
		DECLARE @tblResult TABLE(Result NVARCHAR(Max), ResultType NVARCHAR(2))
		DECLARE @tempRegion TABLE(RegionCode NVARCHAR(100), RegionName NVARCHAR(100), IsValid BIT )
		DECLARE @tempLocation TABLE(LocationCode NVARCHAR(100))
		DECLARE @tempDistricts TABLE(RegionCode NVARCHAR(100),DistrictCode NVARCHAR(100),DistrictName NVARCHAR(100), IsValid BIT )
		DECLARE @tempWards TABLE(DistrictCode NVARCHAR(100),WardCode NVARCHAR(100),WardName NVARCHAR(100), IsValid BIT )
		DECLARE @tempVillages TABLE(WardCode NVARCHAR(100),VillageCode NVARCHAR(100), VillageName NVARCHAR(100),MalePopulation INT,FemalePopulation INT, OtherPopulation INT, Families INT, IsValid BIT )

		BEGIN TRY
	
			SET @Query = (N'SELECT @XML = CAST(X as XML) FROM OPENROWSET(BULK  '''+ @File +''' ,SINGLE_BLOB) AS T(X)')

			EXECUTE SP_EXECUTESQL @Query,N'@XML XML OUTPUT',@XML OUTPUT
			
			
			IF ( @XML.exist('(Locations/Regions/Region)')=1 AND  @XML.exist('(Locations/Districts/District)')=1 AND  @XML.exist('(Locations/Municipalities/Municipality)')=1 AND  @XML.exist('(Locations/Villages/Village)')=1)
				BEGIN
					--GET ALL THE REGIONS FROM THE XML
					INSERT INTO @tempRegion(RegionCode,RegionName,IsValid)
					SELECT 
					NULLIF(T.R.value('(RegionCode)[1]','NVARCHAR(100)'),''),
					NULLIF(T.R.value('(RegionName)[1]','NVARCHAR(100)'),''),
					1
					FROM @XML.nodes('Locations/Regions/Region') AS T(R)
		
					SELECT @SentRegion=@@ROWCOUNT

					--GET ALL THE DISTRICTS FROM THE XML
					INSERT INTO @tempDistricts(RegionCode, DistrictCode, DistrictName,IsValid)
					SELECT 
					NULLIF(T.R.value('(RegionCode)[1]','NVARCHAR(100)'),''),
					NULLIF(T.R.value('(DistrictCode)[1]','NVARCHAR(100)'),''),
					NULLIF(T.R.value('(DistrictName)[1]','NVARCHAR(100)'),''),
					1
					FROM @XML.nodes('Locations/Districts/District') AS T(R)

					SELECT @SentDistrict=@@ROWCOUNT

					--GET ALL THE WARDS FROM THE XML
					INSERT INTO @tempWards(DistrictCode,WardCode, WardName,IsValid)
					SELECT 
					NULLIF(T.R.value('(DistrictCode)[1]','NVARCHAR(100)'),''),
					NULLIF(T.R.value('(MunicipalityCode)[1]','NVARCHAR(100)'),''),
					NULLIF(T.R.value('(MunicipalityName)[1]','NVARCHAR(100)'),''),
					1
					FROM @XML.nodes('Locations/Municipalities/Municipality') AS T(R)
		
					SELECT @SentWard = @@ROWCOUNT

					--GET ALL THE VILLAGES FROM THE XML
					INSERT INTO @tempVillages(WardCode, VillageCode, VillageName, MalePopulation, FemalePopulation, OtherPopulation, Families, IsValid)
					SELECT 
					NULLIF(T.R.value('(MunicipalityCode)[1]','NVARCHAR(100)'),''),
					NULLIF(T.R.value('(VillageCode)[1]','NVARCHAR(100)'),''),
					NULLIF(T.R.value('(VillageName)[1]','NVARCHAR(100)'),''),
					NULLIF(T.R.value('(MalePopulation)[1]','INT'),0),
					NULLIF(T.R.value('(FemalePopulation)[1]','INT'),0),
					NULLIF(T.R.value('(OtherPopulation)[1]','INT'),0),
					NULLIF(T.R.value('(Families)[1]','INT'),0),
					1
					FROM @XML.nodes('Locations/Villages/Village') AS T(R)
		
					SELECT @SentVillage=@@ROWCOUNT
				END
			ELSE
				BEGIN
					RAISERROR (N'-200', 16, 1);
				END


			--SELECT * INTO tempRegion from @tempRegion
			--SELECT * INTO tempDistricts from @tempDistricts
			--SELECT * INTO tempWards from @tempWards
			--SELECT * INTO tempVillages from @tempVillages

			--RETURN

			/*========================================================================================================
			VALIDATION STARTS
			========================================================================================================*/	
			/********************************CHECK THE DUPLICATE LOCATION CODE******************************/
				INSERT INTO @tempLocation(LocationCode)
				SELECT RegionCode FROM @tempRegion
				INSERT INTO @tempLocation(LocationCode)
				SELECT DistrictCode FROM @tempDistricts
				INSERT INTO @tempLocation(LocationCode)
				SELECT WardCode FROM @tempWards
				INSERT INTO @tempLocation(LocationCode)
				SELECT VillageCode FROM @tempVillages
			
				INSERT INTO @tblResult(Result, ResultType)
				SELECT N'Location Code ' + QUOTENAME(LocationCode) + '  has already being used in a file ', N'C' FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1

				UPDATE @tempRegion  SET IsValid=0 WHERE RegionCode IN (SELECT LocationCode FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1)
				UPDATE @tempDistricts  SET IsValid=0 WHERE DistrictCode IN (SELECT LocationCode FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1)
				UPDATE @tempWards  SET IsValid=0 WHERE WardCode IN (SELECT LocationCode FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1)
				UPDATE @tempVillages  SET IsValid=0 WHERE VillageCode IN (SELECT LocationCode FROM @tempLocation GROUP BY LocationCode HAVING COUNT(LocationCode)>1)


			/********************************REGION STARTS******************************/
			--check if the regioncode is null 
			IF EXISTS(
			SELECT 1 FROM @tempRegion WHERE  LEN(ISNULL(RegionCode,''))=0 
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(1)) + N' Region(s) have empty code', N'E' FROM @tempRegion WHERE  LEN(ISNULL(RegionCode,''))=0 
		
			UPDATE @tempRegion SET IsValid=0  WHERE  LEN(ISNULL(RegionCode,''))=0 
		
			--check if the regionname is null 
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Region Code ' + QUOTENAME(RegionCode) + N' has empty name', N'E' FROM @tempRegion WHERE  LEN(ISNULL(RegionName,''))=0 
		
			UPDATE @tempRegion SET IsValid=0  WHERE RegionName  IS NULL OR LEN(ISNULL(RegionName,''))=0 

			--Check for Duplicates in file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Region Code ' + QUOTENAME(RegionCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(RegionCode)) + ' times in the file', N'C'  FROM @tempRegion GROUP BY RegionCode HAVING COUNT(RegionCode) >1 
		
			UPDATE R SET IsValid = 0 FROM @tempRegion R
			WHERE RegionCode in (SELECT RegionCode from @tempRegion GROUP BY RegionCode HAVING COUNT(RegionCode) >1)
		
			--check the length of the regionCode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Region Code ' + QUOTENAME(RegionCode) + N' is greater than 50', N'E' FROM @tempRegion WHERE  LEN(ISNULL(RegionCode,''))>50
		
			UPDATE @tempRegion SET IsValid=0  WHERE LEN(ISNULL(RegionCode,''))>50

			--check the length of the regionname
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Region Name ' + QUOTENAME(RegionCode) + N' is greater than 50', N'E' FROM @tempRegion WHERE  LEN(ISNULL(RegionName,''))>50
		
			UPDATE @tempRegion SET IsValid=0  WHERE LEN(ISNULL(RegionName,''))>50
		
		

			/********************************REGION ENDS******************************/

			/********************************DISTRICT STARTS******************************/
			--check if the district has regioncode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'District Code ' + QUOTENAME(DistrictCode) + N' has empty Region Code', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(RegionCode,''))=0 
		
			UPDATE @tempDistricts SET IsValid=0  WHERE  LEN(ISNULL(RegionCode,''))=0 

			--check if the district has valid regioncode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'District Code ' + QUOTENAME(DistrictCode) + N' has invalid Region Code', N'E' FROM @tempDistricts TD
			LEFT OUTER JOIN @tempRegion TR ON TR.RegionCode=TD.RegionCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TD.RegionCode AND L.LocationType='R' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TR.RegionCode IS NULL
			AND LEN(TD.RegionCode)>0

			UPDATE TD SET TD.IsValid=0 FROM @tempDistricts TD
			LEFT OUTER JOIN @tempRegion TR ON TR.RegionCode=TD.RegionCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TD.RegionCode AND L.LocationType='R' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TR.RegionCode IS NULL
			AND LEN(TD.RegionCode)>0

			--check if the districtcode is null 
			IF EXISTS(
			SELECT  1 FROM @tempDistricts WHERE  LEN(ISNULL(DistrictCode,''))=0 
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(1)) + N' District(s) have empty District code', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(DistrictCode,''))=0 
		
			UPDATE @tempDistricts SET IsValid=0  WHERE  LEN(ISNULL(DistrictCode,''))=0 
		
			--check if the districtname is null 
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'District Code ' + QUOTENAME(DistrictCode) + N' has empty name', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(DistrictName,''))=0 
		
			UPDATE @tempDistricts SET IsValid=0  WHERE  LEN(ISNULL(DistrictName,''))=0 
		
			--Check for Duplicates in file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'District Code ' + QUOTENAME(DistrictCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(DistrictCode)) + ' times in the file', N'C'  FROM @tempDistricts GROUP BY DistrictCode HAVING COUNT(DistrictCode) >1 
		
			UPDATE D SET IsValid = 0 FROM @tempDistricts D
			WHERE DistrictCode in (SELECT DistrictCode from @tempDistricts GROUP BY DistrictCode HAVING COUNT(DistrictCode) >1)

			--check the length of the DistrictCode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the District Code ' + QUOTENAME(DistrictCode) + N' is greater than 50', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(DistrictCode,''))>50
		
			UPDATE @tempDistricts SET IsValid=0  WHERE LEN(ISNULL(DistrictCode,''))>50

			--check the length of the regionname
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the District Name ' + QUOTENAME(DistrictName) + N' is greater than 50', N'E' FROM @tempDistricts WHERE  LEN(ISNULL(DistrictName,''))>50
		
			UPDATE @tempDistricts SET IsValid=0  WHERE LEN(ISNULL(DistrictName,''))>50
		
			/********************************DISTRICT ENDS******************************/

			/********************************WARDS STARTS******************************/
			--check if the ward has districtcode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Municipality Code ' + QUOTENAME(WardCode) + N' has empty District Code', N'E' FROM @tempWards WHERE  LEN(ISNULL(DistrictCode,''))=0 
		
			UPDATE @tempWards SET IsValid=0  WHERE  LEN(ISNULL(DistrictCode,''))=0 

			--check if the ward has valid districtCode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Municipality Code ' + QUOTENAME(WardCode) + N' has invalid District Code', N'E' FROM @tempWards TW
			LEFT OUTER JOIN @tempDistricts TD ON  TD.DistrictCode=TW.DistrictCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.DistrictCode AND L.LocationType='D' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TD.DistrictCode IS NULL
			AND LEN(TW.DistrictCode)>0

			UPDATE TW SET TW.IsValid=0 FROM @tempWards TW
			LEFT OUTER JOIN @tempDistricts TD ON  TD.DistrictCode=TW.DistrictCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.DistrictCode AND L.LocationType='D' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TD.DistrictCode IS NULL
			AND LEN(TW.DistrictCode)>0

			--check if the wardcode is null 
			IF EXISTS(
			SELECT  1 FROM @tempWards WHERE  LEN(ISNULL(WardCode,''))=0 
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(1)) + N' Ward(s) have empty Municipality Code', N'E' FROM @tempWards WHERE  LEN(ISNULL(WardCode,''))=0 
		
			UPDATE @tempWards SET IsValid=0  WHERE  LEN(ISNULL(WardCode,''))=0 
		
			--check if the wardname is null 
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Municipality Code ' + QUOTENAME(WardCode) + N' has empty name', N'E' FROM @tempWards WHERE  LEN(ISNULL(WardName,''))=0 
		
			UPDATE @tempWards SET IsValid=0  WHERE  LEN(ISNULL(WardName,''))=0 
		
			--Check for Duplicates in file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Municipality Code ' + QUOTENAME(WardCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(WardCode)) + ' times in the file', N'C'  FROM @tempWards GROUP BY WardCode HAVING COUNT(WardCode) >1 
		
			UPDATE W SET IsValid = 0 FROM @tempWards W
			WHERE WardCode in (SELECT WardCode from @tempWards GROUP BY WardCode HAVING COUNT(WardCode) >1)

			--check the length of the wardcode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Municipality Code ' + QUOTENAME(WardCode) + N' is greater than 50', N'E' FROM @tempWards WHERE  LEN(ISNULL(WardCode,''))>50
		
			UPDATE @tempWards SET IsValid=0  WHERE LEN(ISNULL(WardCode,''))>50

			--check the length of the wardname
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Municipality Name ' + QUOTENAME(WardName) + N' is greater than 50', N'E' FROM @tempWards WHERE  LEN(ISNULL(WardName,''))>50
		
			UPDATE @tempWards SET IsValid=0  WHERE LEN(ISNULL(WardName,''))>50
		
			/********************************WARDS ENDS******************************/

			/********************************VILLAGE STARTS******************************/
			--check if the village has Wardcoce
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(VillageCode) + N' has empty Municipality Code', N'E' FROM @tempVillages WHERE  LEN(ISNULL(WardCode,''))=0 
		
			UPDATE @tempVillages SET IsValid=0  WHERE  LEN(ISNULL(WardCode,''))=0 

			--check if the village has valid wardcode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(VillageCode) + N' has invalid Municipality Code', N'E' FROM @tempVillages TV
			LEFT OUTER JOIN @tempWards TW ON  TW.WardCode=TV.WardCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TW.WardCode IS NULL
			AND LEN(TV.WardCode)>0
			AND LEN(TV.VillageCode) >0

			UPDATE TV SET TV.IsValid=0 FROM @tempVillages TV
			LEFT OUTER JOIN @tempWards TW ON  TW.WardCode=TV.WardCode
			LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W' 
			WHERE L.ValidityTo IS NULL
			AND L.LocationCode IS NULL
			AND TW.WardCode IS NULL
			AND LEN(TV.WardCode)>0
			AND LEN(TV.VillageCode) >0

			--check if the villagecode is null 
			IF EXISTS(
			SELECT  1 FROM @tempVillages WHERE  LEN(ISNULL(VillageCode,''))=0 
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT  CONVERT(NVARCHAR(3), COUNT(1)) + N' Village(s) have empty Village code', N'E' FROM @tempVillages WHERE  LEN(ISNULL(VillageCode,''))=0 
		
			UPDATE @tempVillages SET IsValid=0  WHERE  LEN(ISNULL(VillageCode,''))=0 
		
			--check if the villageName is null 
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(VillageCode) + N' has empty name', N'E' FROM @tempVillages WHERE  LEN(ISNULL(VillageName,''))=0 
		
			UPDATE @tempVillages SET IsValid=0  WHERE  LEN(ISNULL(VillageName,''))=0 
		
			--Check for Duplicates in file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Village Code ' + QUOTENAME(VillageCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(VillageCode)) + ' times in the file', N'C'  FROM @tempVillages GROUP BY VillageCode HAVING COUNT(VillageCode) >1 
		
			UPDATE V SET IsValid = 0 FROM @tempVillages V
			WHERE VillageCode in (SELECT VillageCode from @tempVillages GROUP BY VillageCode HAVING COUNT(VillageCode) >1)

			--check the length of the VillageCode
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Village Code ' + QUOTENAME(VillageCode) + N' is greater than 50', N'E' FROM @tempVillages WHERE  LEN(ISNULL(VillageCode,''))>50
		
			UPDATE @tempVillages SET IsValid=0  WHERE LEN(ISNULL(VillageCode,''))>50

			--check the length of the VillageName
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'length of the Village Name ' + QUOTENAME(VillageName) + N' is greater than 50', N'E' FROM @tempVillages WHERE  LEN(ISNULL(VillageName,''))>50
		
			UPDATE @tempVillages SET IsValid=0  WHERE LEN(ISNULL(VillageName,''))>50

			--check the validity of the malepopulation
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'The Village Code' + QUOTENAME(VillageCode) + N' has invalid Male polulation', N'E' FROM @tempVillages WHERE  MalePopulation<0
		
			UPDATE @tempVillages SET IsValid=0  WHERE MalePopulation<0

			--check the validity of the female population
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'The Village Code' + QUOTENAME(VillageCode) + N' has invalid Female polulation', N'E' FROM @tempVillages WHERE  FemalePopulation<0
		
			UPDATE @tempVillages SET IsValid=0  WHERE FemalePopulation<0

			--check the validity of the OtherPopulation
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'The Village Code' + QUOTENAME(VillageCode) + N' has invalid Others polulation', N'E' FROM @tempVillages WHERE  OtherPopulation<0
		
			UPDATE @tempVillages SET IsValid=0  WHERE OtherPopulation<0

			--check the validity of the number of families
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'The Village Code' + QUOTENAME(VillageCode) + N' has invalid Number of  Families', N'E' FROM @tempVillages WHERE  Families<0
		
			UPDATE @tempVillages SET IsValid=0  WHERE Families<0

		
			/********************************VILLAGE ENDS******************************/
			/*========================================================================================================
			VALIDATION ENDS
			========================================================================================================*/	
	
			/*========================================================================================================
			COUNTS START
			========================================================================================================*/	
					--updates counts	
					IF (@StrategyId & @UpdateOnly) > 0
					BEGIN
						--Regions updates
							SELECT @UpdateRegion=COUNT(1) FROM @tempRegion TR 
							INNER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
							WHERE
							TR.IsValid=1
							AND L.ValidityTo IS NULL
							
						--Districts updates
							SELECT @UpdateDistrict=COUNT(1) FROM @tempDistricts TD 
							INNER JOIN tblLocations L ON L.LocationCode=TD.DistrictCode AND L.LocationType='D'
							WHERE
							TD.IsValid=1
							AND L.ValidityTo IS NULL

						--Wards updates
							SELECT @UpdateWard=COUNT(1) FROM @tempWards TW 
							INNER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W'
							WHERE
							TW.IsValid=1
							AND L.ValidityTo IS NULL

						--Villages updates
							SELECT @UpdateVillage=COUNT(1) FROM @tempVillages TV 
							INNER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='V'
							WHERE
							TV.IsValid=1
							AND L.ValidityTo IS NULL
					END

					--To be inserted
					IF (@StrategyId & @InsertOnly) > 0
						BEGIN
							
							--Failed Region
							IF (@StrategyId = @InsertOnly)
							BEGIN
								INSERT INTO @tblResult(Result, ResultType)
								SELECT 'Region Code' + QUOTENAME(TR.RegionCode) + ' is already exists in database', N'FR'
								FROM @tempRegion TR
								INNER JOIN tblLocations L ON TR.RegionCode = L.LocationCode
								WHERE L.ValidityTo IS NULL AND TR.IsValid=1;
							END
							--Regions insert
							SELECT @InsertRegion=COUNT(1) FROM @tempRegion TR 
							LEFT OUTER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
							WHERE
							TR.IsValid=1
							AND L.ValidityTo IS NULL
							AND L.LocationCode IS NULL

							--Failed Districts
							IF (@StrategyId = @InsertOnly)
							BEGIN
								INSERT INTO @tblResult(Result, ResultType)
								SELECT 'District Code' + QUOTENAME(TD.DistrictCode) + ' is already exists in database', N'FD'
								FROM @tempDistricts TD
								INNER JOIN tblLocations L ON TD.DistrictCode = L.LocationCode
								WHERE L.ValidityTo IS NULL AND TD.IsValid=1;
							END
							--Districts insert
							SELECT @InsertDistrict=COUNT(1) FROM @tempDistricts TD 
							LEFT OUTER JOIN tblLocations L ON L.LocationCode=TD.DistrictCode AND L.LocationType='D'
							LEFT  OUTER JOIN tblRegions R ON TD.RegionCode = R.RegionCode AND R.ValidityTo IS NULL
							LEFT OUTER JOIN @tempRegion TR ON TD.RegionCode = TR.RegionCode
							WHERE
							TD.IsValid=1
							AND TR.IsValid = 1
							AND L.ValidityTo IS NULL
							AND L.LocationCode IS NULL
							
							--Failed Municipalities
							IF (@StrategyId = @InsertOnly)
							BEGIN
								INSERT INTO @tblResult(Result, ResultType)
								SELECT 'Municipality Code' + QUOTENAME(TW.WardCode) + ' is already exists in database', N'FM'
								FROM @tempWards TW
								INNER JOIN tblLocations L ON TW.WardCode = L.LocationCode
								WHERE L.ValidityTo IS NULL AND TW.IsValid=1;
							END
							--Wards insert
							SELECT @InsertWard=COUNT(1) FROM @tempWards TW 
							LEFT OUTER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W'
							LEFT  OUTER JOIN tblDistricts D ON TW.DistrictCode = D.DistrictCode AND D.ValidityTo IS NULL
							LEFT OUTER JOIN @tempDistricts TD ON TD.DistrictCode = TW.DistrictCode
							WHERE
							TW.IsValid=1
							AND TD.IsValid = 1
							AND L.ValidityTo IS NULL
							AND L.LocationCode IS NULL

							--Failed Village
							IF (@StrategyId = @InsertOnly)
							BEGIN
								INSERT INTO @tblResult(Result, ResultType)
								SELECT 'Village Code' + QUOTENAME(TV.VillageCode) + ' is already exists in database', N'FV'
								FROM @tempVillages TV
								INNER JOIN tblLocations L ON TV.VillageCode= L.LocationCode
								WHERE L.ValidityTo IS NULL AND TV.IsValid=1;
							END
							--Villages insert
							SELECT @InsertVillage=COUNT(1) FROM @tempVillages TV 
							LEFT OUTER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='V'
							LEFT  OUTER JOIN tblWards W ON TV.WardCode = W.WardCode AND W.ValidityTo IS NULL
							LEFT OUTER JOIN @tempWards TW ON TV.WardCode = TW.WardCode
							WHERE
							TV.IsValid=1
							AND TW.IsValid = 1
							AND L.ValidityTo IS NULL
							AND L.LocationCode IS NULL
						END
			


			/*========================================================================================================
			COUNTS ENDS
			========================================================================================================*/	
		
			
				IF @DryRun =0
					BEGIN
						BEGIN TRAN UPLOAD

						
			/*========================================================================================================
			UPDATE STARTS
			========================================================================================================*/	
					IF (@StrategyId & @UpdateOnly) > 0
							BEGIN
							/********************************REGIONS******************************/
								--insert historocal record(s)
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[ValidityTo] ,[LegacyId],[AuditUserId],[MalePopulation] ,[FemalePopulation],[OtherPopulation],[Families])
									SELECT L.LocationCode, L.LocationName,L.ParentLocationId,L.LocationType, L.ValidityFrom,GETDATE(),L.LocationId,@AuditUserId AuditUserId, L.MalePopulation, L.FemalePopulation, L.OtherPopulation,L.Families 
									FROM @tempRegion TR 
									INNER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
									WHERE TR.IsValid=1 AND L.ValidityTo IS NULL

								--update
									UPDATE L SET  L.LocationName=TR.RegionName, ValidityFrom=GETDATE(),L.AuditUserId=@AuditUserId
									OUTPUT QUOTENAME(deleted.LocationCode), N'UR' INTO @tblResult
									FROM @tempRegion TR 
									INNER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
									WHERE TR.IsValid=1 AND L.ValidityTo IS NULL;

									SELECT @UpdateRegion = @@ROWCOUNT;

									/********************************DISTRICTS******************************/
								--Insert historical records
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[ValidityTo] ,[LegacyId],[AuditUserId],[MalePopulation] ,[FemalePopulation],[OtherPopulation],[Families])
										SELECT L.LocationCode, L.LocationName,L.ParentLocationId,L.LocationType, L.ValidityFrom,GETDATE(),L.LocationId,@AuditUserId AuditUserId, L.MalePopulation, L.FemalePopulation, L.OtherPopulation,L.Families 
										FROM @tempDistricts TD 
										INNER JOIN tblLocations L ON L.LocationCode=TD.DistrictCode AND L.LocationType='D'
										WHERE TD.IsValid=1 AND L.ValidityTo IS NULL

									--update
										UPDATE L SET L.LocationName=TD.DistrictName, ValidityFrom=GETDATE(),L.AuditUserId=@AuditUserId
										OUTPUT QUOTENAME(deleted.LocationCode), N'UD' INTO @tblResult
										FROM @tempDistricts TD 
										INNER JOIN tblLocations L ON L.LocationCode=TD.DistrictCode AND L.LocationType='D'
										WHERE TD.IsValid=1 AND L.ValidityTo IS NULL;

										SELECT @UpdateDistrict = @@ROWCOUNT;

										/********************************WARD******************************/
								--Insert historical records
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[ValidityTo] ,[LegacyId],[AuditUserId],[MalePopulation] ,[FemalePopulation],[OtherPopulation],[Families])
										SELECT L.LocationCode, L.LocationName,L.ParentLocationId,L.LocationType, L.ValidityFrom,GETDATE(),L.LocationId,@AuditUserId AuditUserId, L.MalePopulation, L.FemalePopulation, L.OtherPopulation,L.Families 
										FROM @tempWards TW 
										INNER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W'
										WHERE TW.IsValid=1 AND L.ValidityTo IS NULL

								--Update
									UPDATE L SET L.LocationName=TW.WardName, ValidityFrom=GETDATE(),L.AuditUserId=@AuditUserId
										OUTPUT QUOTENAME(deleted.LocationCode), N'UM' INTO @tblResult
										FROM @tempWards TW 
										INNER JOIN tblLocations L ON L.LocationCode=TW.WardCode AND L.LocationType='W'
										WHERE TW.IsValid=1 AND L.ValidityTo IS NULL;

										SELECT @UpdateWard = @@ROWCOUNT;
									  
										/********************************VILLAGES******************************/
								--Insert historical records
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[ValidityTo] ,[LegacyId],[AuditUserId],[MalePopulation] ,[FemalePopulation],[OtherPopulation],[Families])
										SELECT L.LocationCode, L.LocationName,L.ParentLocationId,L.LocationType, L.ValidityFrom,GETDATE(),L.LocationId,@AuditUserId AuditUserId, L.MalePopulation, L.FemalePopulation, L.OtherPopulation,L.Families 
										FROM @tempVillages TV 
										INNER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='V'
										WHERE TV.IsValid=1 AND L.ValidityTo IS NULL

								--Update
									UPDATE L  SET L.LocationName=TV.VillageName, L.MalePopulation=TV.MalePopulation, L.FemalePopulation=TV.FemalePopulation, L.OtherPopulation=TV.OtherPopulation, L.Families=TV.Families, ValidityFrom=GETDATE(),L.AuditUserId=@AuditUserId
										OUTPUT QUOTENAME(deleted.LocationCode), N'UV' INTO @tblResult
										FROM @tempVillages TV 
										INNER JOIN tblLocations L ON L.LocationCode=TV.VillageCode AND L.LocationType='V'
										WHERE TV.IsValid=1 AND L.ValidityTo IS NULL;

										SELECT @UpdateVillage = @@ROWCOUNT;

							END
			/*========================================================================================================
			UPDATE ENDS
			========================================================================================================*/	

			/*========================================================================================================
			INSERT STARTS
			========================================================================================================*/	
					IF (@StrategyId & @InsertOnly) > 0
							BEGIN
								--insert Region(s)
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[LocationType],[ValidityFrom],[AuditUserId])
									OUTPUT QUOTENAME(inserted.LocationCode), N'IR' INTO @tblResult
									SELECT TR.RegionCode, TR.RegionName,'R',GETDATE(), @AuditUserId AuditUserId 
									FROM @tempRegion TR 
									LEFT OUTER JOIN tblLocations L ON L.LocationCode=TR.RegionCode AND L.LocationType='R'
									WHERE
									TR.IsValid=1
									AND L.ValidityTo IS NULL
									AND L.LocationCode IS NULL;

									SELECT @InsertRegion = @@ROWCOUNT;


								--Insert District(s)
									INSERT INTO [tblLocations]
										([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[AuditUserId])
									OUTPUT QUOTENAME(inserted.LocationCode), N'ID' INTO @tblResult
									SELECT TD.DistrictCode, TD.DistrictName, R.RegionId, 'D', GETDATE(), @AuditUserId AuditUserId 
									FROM @tempDistricts TD
									INNER JOIN tblRegions R ON TD.RegionCode = R.RegionCode
									LEFT OUTER JOIN tblDistricts D ON TD.DistrictCode = D.DistrictCode
									WHERE R.ValidityTo IS NULL
									AND D.ValidityTo IS NULL 
									AND D.DistrictId IS NULL;

									SELECT @InsertDistrict = @@ROWCOUNT;
									
								--Insert Wards
								INSERT INTO [tblLocations]
									([LocationCode],[LocationName],[ParentLocationId],[LocationType],[ValidityFrom],[AuditUserId])
								OUTPUT QUOTENAME(inserted.LocationCode), N'IM' INTO @tblResult
								SELECT TW.WardCode, TW.WardName, D.DistrictId, 'W',GETDATE(), @AuditUserId AuditUserId 
								FROM @tempWards TW
								INNER JOIN tblDistricts D ON TW.DistrictCode = D.DistrictCode
								LEFT OUTER JOIN tblWards W ON TW.WardCode = W.WardCode
								WHERE D.ValidityTo IS NULL
								AND W.ValidityTo IS NULL 
								AND W.WardId IS NULL;

									SELECT @InsertWard = @@ROWCOUNT;
									

							--insert  villages
								INSERT INTO [tblLocations]
									([LocationCode],[LocationName],[ParentLocationId],[LocationType], [MalePopulation],[FemalePopulation],[OtherPopulation],[Families], [ValidityFrom],[AuditUserId])
								OUTPUT QUOTENAME(inserted.LocationCode), N'IV' INTO @tblResult
								SELECT TV.VillageCode,TV.VillageName,W.WardId,'V',TV.MalePopulation,TV.FemalePopulation,TV.OtherPopulation,TV.Families,GETDATE(), @AuditUserId AuditUserId
								FROM @tempVillages TV
								INNER JOIN tblWards W ON TV.WardCode = W.WardCode
								LEFT OUTER JOIN tblVillages V ON TV.VillageCode = V.VillageCode
								WHERE W.ValidityTo IS NULL
								AND V.ValidityTo IS NULL 
								AND V.VillageId IS NULL;

									SELECT @InsertVillage = @@ROWCOUNT;

							END
			/*========================================================================================================
			INSERT ENDS
			========================================================================================================*/	
							

						COMMIT TRAN UPLOAD
					END
		
			
		
		END TRY
		BEGIN CATCH
			DECLARE @InvalidXML NVARCHAR(100)
			IF ERROR_NUMBER()=245 
				BEGIN
					SET @InvalidXML='Invalid input in either MalePopulation, FemalePopulation, OtherPopulation or Number of Families '
					INSERT INTO @tblResult(Result, ResultType)
					SELECT @InvalidXML, N'FE';
				END
			ELSE  IF ERROR_NUMBER()=9436 
				BEGIN
					SET @InvalidXML='Invalid XML file, end tag does not match start tag'
					INSERT INTO @tblResult(Result, ResultType)
					SELECT @InvalidXML, N'FE';
				END
			ELSE IF  ERROR_MESSAGE()=N'-200'
				BEGIN
					INSERT INTO @tblResult(Result, ResultType)
				SELECT'Invalid Locations XML file', N'FE';
			END
			ELSE
				INSERT INTO @tblResult(Result, ResultType)
				SELECT'Invalid XML file', N'FE';

			IF @@TRANCOUNT > 0 ROLLBACK TRAN UPLOAD;
			SELECT * FROM @tblResult
			RETURN -1;
				
		END CATCH
		SELECT * FROM @tblResult
		RETURN 0;
	END




GO

IF NOT OBJECT_ID('uspUploadDiagnosisXML') IS NULL
DROP PROCEDURE [dbo].[uspUploadDiagnosisXML]
GO

CREATE PROCEDURE [dbo].[uspUploadDiagnosisXML]
(
	@File NVARCHAR(300),
	@StrategyId INT,	--1	: Insert Only,	2: Update Only	3: Insert & Update	7: Insert, Update & Delete
	@AuditUserID INT = -1,
	@DryRun BIT=0,
	@DiagnosisSent INT = 0 OUTPUT,
	@Inserts INT  = 0 OUTPUT,
	@Updates INT  = 0 OUTPUT,
	@Deletes INT = 0 OUTPUT
)
AS
BEGIN

	/* Result type in @tblResults
	-------------------------------
		E	:	Error
		C	:	Conflict
		FE	:	Fatal Error

	Return Values
	------------------------------
		0	:	All Okay
		-1	:	Fatal error
	*/
	

	DECLARE @InsertOnly INT = 1,
			@UpdateOnly INT = 2,
			@Delete INT= 4

	SET @Inserts = 0;
	SET @Updates = 0;
	SET @Deletes = 0;

	DECLARE @Query NVARCHAR(500)
	DECLARE @XML XML
	DECLARE @tblDiagnosis TABLE(ICDCode nvarchar(50),  ICDName NVARCHAR(255), IsValid BIT)
	DECLARE @tblDeleted TABLE(Id INT, Code NVARCHAR(8));
	DECLARE @tblResult TABLE(Result NVARCHAR(Max), ResultType NVARCHAR(2))

	BEGIN TRY

		IF @AuditUserID IS NULL
			SET @AuditUserID=-1

		SET @Query = (N'SELECT @XML = CAST(X as XML) FROM OPENROWSET(BULK  '''+ @File +''' ,SINGLE_BLOB) AS T(X)')

		EXECUTE SP_EXECUTESQL @Query,N'@XML XML OUTPUT',@XML OUTPUT

		IF ( @XML.exist('(Diagnoses/Diagnosis/ICDCode)')=1)
			BEGIN
				--GET ALL THE DIAGNOSES	 FROM THE XML
				INSERT INTO @tblDiagnosis(ICDCode,ICDName, IsValid)
				SELECT 
				T.F.value('(ICDCode)[1]','NVARCHAR(12)'),
				T.F.value('(ICDName)[1]','NVARCHAR(255)'),
				1 IsValid
				FROM @XML.nodes('Diagnoses/Diagnosis') AS T(F)

				SELECT @DiagnosisSent=@@ROWCOUNT
			END
		ELSE
			BEGIN
				RAISERROR (N'-200', 16, 1);
			END
	

	
		/*========================================================================================================
		VALIDATION STARTS
		========================================================================================================*/	

			--Invalidate empty code or empty name 
			IF EXISTS(
				SELECT 1
				FROM @tblDiagnosis D 
				WHERE LEN(ISNULL(D.ICDCode, '')) = 0
			)
			INSERT INTO @tblResult(Result, ResultType)
			SELECT CONVERT(NVARCHAR(3), COUNT(D.ICDCode)) + N' Diagnosis have empty ICD code', N'E'
			FROM @tblDiagnosis D 
			WHERE LEN(ISNULL(D.ICDCode, '')) = 0

			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'ICD Code ' + QUOTENAME(D.ICDCode) + N' has empty name field', N'E'
			FROM @tblDiagnosis D 
			WHERE LEN(ISNULL(D.ICDName, '')) = 0


			UPDATE D SET IsValid = 0
			FROM @tblDiagnosis D 
			WHERE LEN(ISNULL(D.ICDCode, '')) = 0 OR LEN(ISNULL(D.ICDName, '')) = 0

			--Check if any ICD Code is greater than 6 characters
			INSERT INTO @tblResult(Result, ResultType)
			SELECT N'Length of the ICD Code ' + QUOTENAME(D.ICDCode) + ' is greater than 6 characters', N'E'
			FROM @tblDiagnosis D
			WHERE LEN(D.ICDCode) > 6;

			UPDATE D SET IsValid = 0
			FROM @tblDiagnosis D
			WHERE LEN(D.ICDCode) > 6;

			--Check if any ICD code is duplicated in the file
			INSERT INTO @tblResult(Result, ResultType)
			SELECT QUOTENAME(D.ICDCode) + ' found  ' + CONVERT(NVARCHAR(3), COUNT(D.ICDCode)) + ' times in the file', N'C'
			FROM @tblDiagnosis D
			GROUP BY D.ICDCode
			HAVING COUNT(D.ICDCode) > 1;
	
			UPDATE D SET IsValid = 0
			FROM @tblDiagnosis D
			WHERE D.ICDCode IN (
				SELECT ICDCode FROM @tblDiagnosis GROUP BY ICDCode HAVING COUNT(ICDCode) > 1
			)

		
		--Get the counts
		--To be deleted
		IF (@StrategyId & @Delete) > 0
		BEGIN
			--Get the list of ICDs which can't be deleted
			INSERT INTO @tblResult(Result, ResultType)
			SELECT QUOTENAME(D.ICDCode) + ' is used in claim. Can''t delete' Result, N'E' ResultType
			FROM tblClaim C
			INNER JOIN (
					SELECT D.ICDID Id, D.ICDCode
					FROM tblICDCodes D
					LEFT OUTER JOIN @tblDiagnosis temp ON D.ICDCode = temp.ICDCode
					WHERE D.ValidityTo IS NULL
					AND temp.ICDCode IS NULL
					
			) D ON C.ICDID = D.Id OR C.ICDID1 = D.Id OR C.ICDID2 = D.Id OR C.ICDID3 = D.Id OR C.ICDID4 = D.Id
			GROUP BY D.ICDCode;

			SELECT @Deletes = COUNT(1)
			FROM tblICDCodes D
			LEFT OUTER JOIN @tblDiagnosis temp ON D.ICDCode = temp.ICDCode AND temp.IsValid = 1
			LEFT OUTER JOIN tblClaim C ON C.ICDID = D.ICDID OR C.ICDID1 = D.ICDID OR C.ICDID2 = D.ICDID OR C.ICDID3 = D.ICDID OR C.ICDID4 = D.ICDID
			WHERE D.ValidityTo IS NULL
			AND temp.ICDCode IS NULL
			AND C.ClaimId IS NULL;
		END	
		
		--To be udpated
		IF (@StrategyId & @UpdateOnly) > 0
		BEGIN
			SELECT @Updates = COUNT(1)
			FROM tblICDCodes ICD
			INNER JOIN @tblDiagnosis D ON ICD.ICDCode = D.ICDCode
			WHERE ICD.ValidityTo IS NULL
			AND D.IsValid = 1
		END
		
		--To be  Inserted
		IF (@StrategyId & @InsertOnly) > 0
		BEGIN
			--Failed ICD
			IF(@StrategyId=@InsertOnly)
				BEGIN
					INSERT INTO @tblResult(Result, ResultType)
					SELECT 'ICD Code '+  QUOTENAME(D.ICDCode) +' already exists in Database',N'FI' FROM @tblDiagnosis D
					INNER JOIN tblICDCodes ICD ON D.ICDCode=ICD.ICDCode WHERE ICD.ValidityTo IS NULL AND  D.IsValid=1
				END
			SELECT @Inserts = COUNT(1)
			FROM @tblDiagnosis D
			LEFT OUTER JOIN tblICDCodes ICD ON D.ICDCode = ICD.ICDCode AND ICD.ValidityTo IS NULL
			WHERE D.IsValid = 1
			AND ICD.ICDCode IS NULL
		END
		/*========================================================================================================
		VALIDATION ENDS
		========================================================================================================*/	

		IF @DryRun = 0
		BEGIN
			BEGIN TRAN UPLOAD

			/*========================================================================================================
			DELETE STARTS
			========================================================================================================*/	
				IF (@StrategyId & @Delete) > 0
				BEGIN
					
					
					INSERT INTO @tblDeleted(Id, Code)
					SELECT D.ICDID, D.ICDCode
					FROM tblICDCodes D
					LEFT OUTER JOIN @tblDiagnosis temp ON D.ICDCode = temp.ICDCode
					WHERE D.ValidityTo IS NULL
					AND temp.ICDCode IS NULL;


					--Check if any of the ICDCodes are used in Claims and remove them from the temporory table
					DELETE D
					FROM tblClaim C
					INNER JOIN @tblDeleted D ON C.ICDID = D.Id OR C.ICDID1 = D.Id OR C.ICDID2 = D.Id OR C.ICDID3 = D.Id OR C.ICDID4 = D.Id
	


					--Insert a copy of the to be deleted records
					INSERT INTO tblICDCodes(ICDCode, ICDName, ValidityFrom, ValidityTo, LegacyId, AuditUserId)
					OUTPUT QUOTENAME(inserted.ICDCode), N'D' INTO @tblResult
					SELECT ICD.ICDCode, ICD.ICDName, ICD.ValidityFrom, GETDATE() ValidityTo, ICD.ICDID LegacyId, @AuditUserID AuditUserId 
					FROM tblICDCodes ICD
					INNER JOIN @tblDeleted D ON ICD.ICDID = D.Id

					--Update the ValidtyFrom Flag to mark as deleted
					UPDATE ICD SET ValidityTo = GETDATE()
					FROM tblICDCodes ICD
					INNER JOIN @tblDeleted D ON ICD.ICDID = D.Id;
					
					SELECT @Deletes=@@ROWCOUNT;
				END
								
			/*========================================================================================================
			DELETE ENDS
			========================================================================================================*/	



			/*========================================================================================================
			UDPATE STARTS
			========================================================================================================*/	

				IF  (@StrategyId & @UpdateOnly) > 0
				BEGIN

				--Make a copy of the original record
					INSERT INTO tblICDCodes(ICDCode, ICDName, ValidityFrom, ValidityTo, LegacyId, AuditUserId)
					SELECT ICD.ICDCode, ICD.ICDName, ICD.ValidityFrom, GETDATE() ValidityTo, ICD.ICDID LegacyId, @AuditUserID AuditUserId 
					FROM tblICDCodes ICD
					INNER JOIN @tblDiagnosis D ON ICD.ICDCode = D.ICDCode
					WHERE ICD.ValidityTo IS NULL
					AND D.IsValid = 1;

					SELECT @Updates = @@ROWCOUNT;

				--Upadte the record
					UPDATE ICD SET ICDName = D.ICDName, ValidityFrom = GETDATE(), AuditUserID = @AuditUserID
					OUTPUT QUOTENAME(deleted.ICDCode), N'U' INTO @tblResult
					FROM tblICDCodes ICD
					INNER JOIN @tblDiagnosis D ON ICD.ICDCode = D.ICDCode
					WHERE ICD.ValidityTo IS NULL
					AND D.IsValid = 1;


				END

			/*========================================================================================================
			UPDATE ENDS
			========================================================================================================*/	

			/*========================================================================================================
			INSERT STARTS
			========================================================================================================*/	

				IF (@StrategyId & @InsertOnly) > 0
				BEGIN
					INSERT INTO tblICDCodes(ICDCode, ICDName, ValidityFrom, AuditUserId)
					OUTPUT QUOTENAME(inserted.ICDCode), N'I' INTO @tblResult
					SELECT D.ICDCode, D.ICDName, GETDATE() ValidityFrom, @AuditUserId AuditUserId
					FROM @tblDiagnosis D
					LEFT OUTER JOIN tblICDCodes ICD ON D.ICDCode = ICD.ICDCode AND ICD.ValidityTo IS NULL
					WHERE D.IsValid = 1
					AND ICD.ICDCode IS NULL;
	
					SELECT @Inserts = @@ROWCOUNT;
				END

			/*========================================================================================================
			INSERT ENDS
			========================================================================================================*/	


			COMMIT TRAN UPLOAD
			
		END
	END TRY
	BEGIN CATCH
		DECLARE @InvalidXML NVARCHAR(100)
		IF ERROR_NUMBER()=9436
			BEGIN 
				SET @InvalidXML='Invalid XML file, end tag does not match start tag'
				INSERT INTO @tblResult(Result, ResultType)
				SELECT @InvalidXML, N'FE';
			END
		ELSE IF  ERROR_MESSAGE()=N'-200'
			BEGIN
				INSERT INTO @tblResult(Result, ResultType)
			SELECT'Invalid Diagnosis XML file', N'FE';
			END
		ELSE
				INSERT INTO @tblResult(Result, ResultType)
				SELECT'Invalid XML file', N'FE';
			
		IF @@TRANCOUNT > 0 ROLLBACK TRAN UPLOAD;
		SELECT * FROM @tblResult;
		RETURN -1;
	END CATCH

	SELECT * FROM @tblResult;
	RETURN 0;
END
GO

