/****** Script for V 17.5.14 to restructure @tblResult column sizes    Script Date: 11/12/2017 11:17:12 ******/

UPDATE tblIMISDefaults SET AppVersionImis = 2.5 , AppVersionFeedbackRenewal = 2.5
GO



IF NOT OBJECT_ID('[uspSSRSPolicyStatus]') IS NULL
DROP PROCEDURE [dbo].[uspSSRSPolicyStatus]
GO
CREATE PROCEDURE [dbo].[uspSSRSPolicyStatus]
	@RangeFrom datetime, --= getdate ,
	@RangeTo datetime, --= getdate ,
	@OfficerID int = 0,
	@RegionId INT = 0,
	@DistrictID as int = 0,
	@VillageID as int = 0, 
	@WardID as int = 0 ,
	@PolicyStatus as int = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE @RenewalID int
	DECLARE @PolicyID as int 
	DECLARE @FamilyID as int 
	DECLARE @RenewalDate as date
	DECLARE @InsureeID as int
	DECLARE @ProductID as int 
	DECLARE @ProductCode as nvarchar(8)
	DECLARE @ProductName as nvarchar(100)
	DECLARE @ProductFromDate as date 
	DECLARE @ProductToDate as date
	DECLARE @DistrictName as nvarchar(50)
	DECLARE @VillageName as nvarchar(50) 
	DECLARE @WardName as nvarchar(50)  
	DECLARE @CHFID as nvarchar(12)
	DECLARE @InsLastName as nvarchar(100)
	DECLARE @InsOtherNames as nvarchar(100)
	DECLARE @InsDOB as date
	DECLARE @ConvProdID as int    
	DECLARE @OffCode as nvarchar(15)
	DECLARE @OffLastName as nvarchar(50)
	DECLARE @OffOtherNames as nvarchar(50)
	DECLARE @OffPhone as nvarchar(50)
	DECLARE @OffSubstID as int 
	DECLARE @OffWorkTo as date 
	DECLARE @PolicyValue DECIMAL(18,4) = 0
	DECLARE @OfficerId1 INT


	DECLARE @SMSStatus as tinyint 
	DECLARE @iCount as int 


	DECLARE @tblResult TABLE(PolicyId INT, 
							FamilyId INT,
							RenewalDate DATE,
							PolicyValue DECIMAL(18,4),
							InsureeId INT,
							ProdId INT,
							ProductCode NVARCHAR(8),
							ProductName NVARCHAR(100),
							DateFrom DATE,
							DateTo DATE,
							DistrictName NVARCHAR(50),
							VillageName NVARCHAR(50),
							WardName NVARCHAR(50),
							CHFID NVARCHAR(12),
							LastName NVARCHAR(100),
							OtherNames NVARCHAR(100),
							DOB DATE,
							ConversionProdId INT,
							OfficerId INT,
							Code NVARCHAR(15),
							OffLastName NVARCHAR(50),
							OffOtherNames NVARCHAR(50),
							Phone NVARCHAR(50),
							OfficerIdSubst INT,
							WorksTo DATE)



	DECLARE LOOP1 CURSOR LOCAL FORWARD_ONLY FOR
	SELECT PL.PolicyID, PL.FamilyID, DATEADD(DAY, 1, PL.ExpiryDate) AS RenewalDate, 
			F.InsureeID, Prod.ProdID, Prod.ProductCode, Prod.ProductName,
			Prod.DateFrom, Prod.DateTo, D.DistrictName, V.VillageName, W.WardName, I.CHFID, I.LastName, I.OtherNames, I.DOB, Prod.ConversionProdID, 
			O.OfficerID, O.Code, O.LastName OffLastName, O.OtherNames OffOtherNames, O.Phone, O.OfficerIDSubst, O.WorksTo,
			PL.PolicyValue

			FROM tblPolicy PL INNER JOIN tblFamilies F ON PL.FamilyId = F.FamilyID
			INNER JOIN tblInsuree I ON F.InsureeId = I.InsureeID
			INNER JOIN tblProduct Prod ON PL.ProdId = Prod.ProdID
			INNER JOIN tblVillages V ON V.VillageId = F.LocationId
			INNER JOIN tblWards W ON W.WardId = V.WardId
			INNER JOIN tblDistricts D ON D.DistrictID = W.DistrictID
			INNER JOIN tblRegions R ON R.RegionId = D.Region
			INNER JOIN tblOfficer O ON PL.OfficerId = O.OfficerID
			AND PL.ExpiryDate BETWEEN @RangeFrom AND @RangeTo
			WHERE PL.ValidityTo IS NULL
			AND F.ValidityTo IS NULL
			AND R.ValidityTo IS NULL
			AND D.ValidityTo IS NULL
			AND V.ValidityTo IS NULL
			AND W.ValidityTo IS NULL
			AND I.ValidityTo IS NULL
			AND O.ValidityTo IS NULL

			AND PL.ExpiryDate BETWEEN @RangeFrom AND @RangeTo
			--AND (O.OfficerId = @OfficerId OR @OfficerId = 0)
			AND (R.RegionId = @RegionId OR @RegionId = 0)
			AND (D.DistrictID = @DistrictID OR @DistrictID = 0)
			AND (V.VillageId = @VillageId  OR @VillageId = 0)
			AND (W.WardId = @WardId OR @WardId = 0)
			AND (PL.PolicyStatus = @PolicyStatus OR @PolicyStatus = 0)
			AND (PL.PolicyStatus > 1)	--Do not renew Idle policies
		ORDER BY RenewalDate DESC  --Added by Rogers


		OPEN LOOP1
		FETCH NEXT FROM LOOP1 INTO @PolicyID,@FamilyID,@RenewalDate,@InsureeID,@ProductID, @ProductCode,@ProductName,@ProductFromDate,@ProductToDate,@DistrictName,@VillageName,@WardName,
								  @CHFID,@InsLastName,@InsOtherNames,@InsDOB,@ConvProdID,@OfficerID1, @OffCode,@OffLastName,@OffOtherNames,@OffPhone,@OffSubstID,@OffWorkTo,
								  @PolicyValue
	
		WHILE @@FETCH_STATUS = 0 
		BEGIN
			
			--GET ProductCode or the substitution
			IF ISNULL(@ConvProdID,0) > 0 
			BEGIN
				SET @iCount = 0 
				WHILE @ConvProdID <> 0 AND @iCount < 20   --this to prevent a recursive loop by wrong datra entries 
				BEGIN
					--get new product info 
					SET @ProductID = @ConvProdID
					SELECT @ConvProdID = ConversionProdID FROM tblProduct WHERE ProdID = @ProductID
					IF ISNULL(@ConvProdID,0) = 0 
					BEGIN
						SELECT @ProductCode = ProductCode from tblProduct WHERE ProdID = @ProductID
						SELECT @ProductName = ProductName  from tblProduct WHERE ProdID = @ProductID
						SELECT @ProductFromDate = DateFrom from tblProduct WHERE ProdID = @ProductID
						SELECT @ProductToDate = DateTo  from tblProduct WHERE ProdID = @ProductID
					
					
					END
					SET @iCount = @iCount + 1
				END
			END 
		
			IF ISNULL(@OfficerID1 ,0) > 0 
			BEGIN
				--GET OfficerCode or the substitution
				IF ISNULL(@OffSubstID,0) > 0 
				BEGIN
					SET @iCount = 0 
					WHILE @OffSubstID <> 0 AND @iCount < 20 AND @OffWorkTo < @RenewalDate  --this to prevent a recursive loop by wrong datra entries 
					BEGIN
						--get new product info 
						SET @OfficerID1 = @OffSubstID
						SELECT @OffSubstID = OfficerIDSubst FROM tblOfficer  WHERE OfficerID  = @OfficerID1
						IF ISNULL(@OffSubstID,0) = 0 
						BEGIN
							SELECT @OffCode = Code from tblOfficer  WHERE OfficerID  = @OfficerID1
							SELECT @OffLastName = LastName  from tblOfficer  WHERE OfficerID  = @OfficerID1
							SELECT @OffOtherNames = OtherNames  from tblOfficer  WHERE OfficerID  = @OfficerID1
							SELECT @OffPhone = Phone  from tblOfficer  WHERE OfficerID  = @OfficerID1
							SELECT @OffWorkTo = WorksTo  from tblOfficer  WHERE OfficerID  = @OfficerID1
						
						
							
						END
						SET @iCount = @iCount + 1
					END
				END 
			END
		

			--Code added by Hiren to check if the policy has another following policy
			IF EXISTS(SELECT 1 FROM tblPolicy 
								WHERE FamilyId = @FamilyId 
								AND (ProdId = @ProductID OR ProdId = @ConvProdID) 
								AND StartDate >= @RenewalDate
								AND ValidityTo IS NULL
								)
					GOTO NextPolicy;
		--Added by Rogers to check if the policy is alread in a family
		IF EXISTS(SELECT 1 FROM @tblResult WHERE FamilyId = @FamilyID AND ProdId = @ProductID OR ProdId = @ConvProdID)
		GOTO NextPolicy;

		
		EXEC @PolicyValue = uspPolicyValue
							@FamilyId = @FamilyID,
							@ProdId = @ProductID,
							@EnrollDate = @RenewalDate,
							@PreviousPolicyId = @PolicyID,
							@PolicyStage = 'R';


		
		INSERT INTO @tblResult(PolicyId, FamilyId, RenewalDate, Policyvalue, InsureeId, ProdId,
		ProductCode, ProductName, DateFrom, DateTo, DistrictName, VillageName,
		WardName, CHFID, LastName, OtherNames, DOB, ConversionProdId,OfficerId,
		Code, OffLastName, OffOtherNames, Phone, OfficerIdSubst, WorksTo)
		SELECT @PolicyID PolicyId, @FamilyId FamilyId, @RenewalDate RenewalDate, @PolicyValue PolicyValue, @InsureeID InsureeId, @ProductID ProdId,
		@ProductCode ProductCode, @ProductName ProductName, @ProductFromDate DateFrom, @ProductToDate DateTo, @DistrictName DistrictName, @VillageName VillageName,
		@WardName WardName, @CHFID CHFID, @InsLastName LastName, @InsOtherNames OtherNames, @InsDOB DOB, @ConvProdID ConversionProdId, @OfficerID1 OfficerId,
		@OffCode Code, @OffLastName OffLastName, @OffOtherNames OffOtherNames, @OffPhone Phone, @OffSubstID OfficerIdSubst, @OffWorkTo WorksTo
	

           
	NextPolicy:
			FETCH NEXT FROM LOOP1 INTO @PolicyID,@FamilyID,@RenewalDate,@InsureeID,@ProductID, @ProductCode,@ProductName,@ProductFromDate,@ProductToDate,@DistrictName,@VillageName,@WardName,
								  @CHFID,@InsLastName,@InsOtherNames,@InsDOB,@ConvProdID,@OfficerID1,@OffCode,@OffLastName,@OffOtherNames,@OffPhone,@OffSubstID,@OffWorkTo,
								  @PolicyValue
	
		END
		CLOSE LOOP1
		DEALLOCATE LOOP1

		SELECT PolicyId, FamilyId, RenewalDate, PolicyValue, InsureeId, ProdId, ProductCode, ProductName, DateFrom, DateTo, DistrictName,
		VillageName, WardName, CHFID, LastName, OtherNames, DOB, ConversionProdId, OfficerId, Code, OffLastName, OffOtherNames, Phone, OfficerIdSubst, WorksTo
		FROM @tblResult
		WHERE (OfficerId = @OfficerId OR @OfficerId = 0);


END

GO























---15/12/2017
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
	-1	:	Uncaught exception
	0	:	All okay
	-1	:	Given family has no HOF
	-2	:	Insurance number of the HOF already exists
	-3	:	Duplicate Insurance number found
	-4	:	Duplicate receipt found
	

	*/
TRY --THE MAIN TRY
		--Create table variables
		--DECLARE @Result TABLE(ErrorMessage NVARCHAR(500))
		DECLARE @Family TABLE(FamilyId INT,InsureeId INT,LocationId INT, HOFCHFID nvarchar(12),Poverty NVARCHAR(1),FamilyType NVARCHAR(2),FamilyAddress NVARCHAR(200), Ethnicity NVARCHAR(1), ConfirmationNo NVARCHAR(12), ConfirmationType NVARCHAR(3),isOffline INT)
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
		NULLIF(T.F.value('(Poverty)[1]', 'BIT'), ''),
		NULLIF(T.F.value('(FamilyType)[1]', 'NVARCHAR(2)'), ''),
		NULLIF(T.F.value('(FamilyAddress)[1]', 'NVARCHAR(200)'), ''),
		NULLIF(T.F.value('(Ethnicity)[1]', 'NVARCHAR(1)'), ''),
		NULLIF(T.F.value('(ConfirmationNo)[1]', 'NVARCHAR(12)'), ''),
		NULLIF(T.F.value('(ConfirmationType)[1]', 'NVARCHAR(3)'), ''),
		T.F.value('(isOffline)[1]','INT')
		FROM @xml.nodes('Enrollment/Family') AS T(F);

		INSERT INTO @Insuree(InsureeId, FamilyId, CHFID, LastName, OtherNames, DOB, Gender, Marital, IsHead, Phone, CardIssued, Relationship, 
		Profession, Education, Email, TypeOfId, HFID, CurrentAddress, GeoLocation, CurrentVillage, PhotoPath, IdentificationNumber,isOffline,EffectiveDate)
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
		T.I.value('(EffectiveDate)[1]', 'DATE')
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
					@EffectiveDate DATE

				
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

		IF   EXISTS(SELECT 1 FROM @Insuree WHERE IsHead = 0 AND isOffline = 1)
		BEGIN
			UPDATE @Insuree SET IsHead = 1 WHERE InsureeId = (SELECT TOP 1 InsureeId FROM @Insuree ORDER BY InsureeId)
		END

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
							DECLARE CurInsuree CURSOR FOR SELECT InsureeId, CHFID, isOffline,FamilyId FROM @Insuree WHERE isOffline = 1 OR CHFID NOT IN (SELECT CHFID FROM tblInsuree WHERE ValidityTo IS NULL);
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
							SELECT I.InsureeId, I.CHFID, 'Images\Updated\'PhotoFolder, dt.PhotoPath, @OfficerId OfficerId, GETDATE() PhotoDate, GETDATE() ValidityFrom, @AuditUserId AuditUserId
							FROM tblInsuree I 
							INNER JOIN @Insuree dt ON dt.CHFID = I.CHFID
							WHERE I.FamilyId = @CurFamilyId
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
					SELECT @HOFId = InsureeId FROM tblInsuree WHERE FamilyId = @FamilyId AND IsHead = 1
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
		RETURN -1;
	END CATCH
		SELECT 1
		END
		ELSE
		BEGIN---BEGIN EXISTING  FAMILY
	BEGIN TRY
	
		
		IF   EXISTS(SELECT 1 FROM @Insuree WHERE IsHead = 0 AND isOffline = 1)
		BEGIN
			UPDATE @Insuree SET IsHead = 1 WHERE InsureeId = (SELECT TOP 1 InsureeId FROM @Insuree ORDER BY InsureeId)
		END

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
							SELECT I.InsureeId, I.CHFID, 'Images\Updated\'PhotoFolder, dt.PhotoPath, @OfficerId OfficerId, GETDATE() PhotoDate, GETDATE() ValidityFrom, @AuditUserId AuditUserId
							FROM tblInsuree I 
							INNER JOIN @Insuree dt ON dt.CHFID = I.CHFID
							WHERE I.FamilyId = @FamilyId
							AND ValidityTo IS NULL;

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
								LEFT JOIN tblInsuree I ON I.CHFID = dt.CHFID 
								WHERE I.ValidityTo IS NULL AND I.InsureeID IS NULL AND dt.isOffline =0 
									)
							BEGIN
								--SET @FamilyId = (SELECT TOP 1 FamilyId FROM @Family)
								GOTO INSERTINSUREE;
							END
									
						ELSE
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
								
								UPDATE tblPhotos SET PhotoFolder = N'Images\Updated\',PhotoFileName = @PhotoFileName, OfficerID = @OfficerID, ValidityFrom = GETDATE(), AuditUserID = @AuditUserID 
								WHERE PhotoID = @PhotoID
						END
						
						END
				/****************************************************END INSERT INSUREE**********************************/



				/****************************************************END INSERT POLICIES**********************************/
				
				SELECT TOP 1 @isOffline = P.isOffline FROM @Policy P
				IF EXISTS(SELECT 1 FROM @Policy WHERE isOffline = 1)
				BEGIN

		INSERTPOLICY:
					--INSERT POLICIES
						DECLARE CurPolicy CURSOR FOR SELECT PolicyId, ProdId, ISNULL(PolicyStage, N'N') PolicyStage, EnrollDate,FamilyId FROM @Policy WHERE isOffline = 1 OR PolicyId NOT IN (SELECT PolicyId FROM tblPolicy WHERE ValidityTo	 IS NULL);
						OPEN CurPolicy
							FETCH NEXT FROM CurPolicy INTO @PolicyId, @ProdId, @PolicyStage, @EnrollDate,@FamilyId;
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
									SET @PolicyStatus = 1

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


								SELECT InsureeID FROM tblInsuree WHERE FamilyID IN (SELECT FamilyID FROM tblPolicy WHERE PolicyID=@NewPolicyId AND ValidityTo IS NULL) AND ValidityTo IS NULL ORDER BY InsureeID ASC


										DECLARE @NewCurrentInsureeId INT =0
										DECLARE CurNewCurrentInsuree CURSOR FOR 	
										SELECT InsureeID FROM tblInsuree WHERE FamilyID IN (SELECT FamilyID FROM tblPolicy WHERE PolicyID=@NewPolicyId AND ValidityTo IS NULL) AND ValidityTo IS NULL 
										ORDER BY InsureeID ASC
													OPEN CurNewCurrentInsuree
														FETCH NEXT FROM CurNewCurrentInsuree INTO @NewCurrentInsureeId
														WHILE @@FETCH_STATUS = 0
														BEGIN
														--Now we will insert new insuree in the table tblInsureePolicy
															EXEC uspAddInsureePolicy @NewCurrentInsureeId	
															FETCH NEXT FROM CurNewCurrentInsuree INTO @NewCurrentInsureeId
														END
														
													CLOSE CurNewCurrentInsuree
													DEALLOCATE CurNewCurrentInsuree						
								END 

					
								FETCH NEXT FROM CurPolicy INTO @PolicyId, @ProdId, @PolicyStage, @EnrollDate, @FamilyId;
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
		RETURN -1;
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
		RETURN -1;
	END CATCH




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
	-1	:	Uncaught exception
	0	:	All okay
	-1	:	Given family has no HOF
	-2	:	Insurance number of the HOF already exists
	-3	:	Duplicate Insurance number found
	-4	:	Duplicate receipt found
	

	*/
TRY --THE MAIN TRY
		--Create table variables
		--DECLARE @Result TABLE(ErrorMessage NVARCHAR(500))
		DECLARE @Family TABLE(FamilyId INT,InsureeId INT,LocationId INT, HOFCHFID nvarchar(12),Poverty NVARCHAR(1),FamilyType NVARCHAR(2),FamilyAddress NVARCHAR(200), Ethnicity NVARCHAR(1), ConfirmationNo NVARCHAR(12), ConfirmationType NVARCHAR(3),isOffline INT)
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
		NULLIF(T.F.value('(Poverty)[1]', 'BIT'), ''),
		NULLIF(T.F.value('(FamilyType)[1]', 'NVARCHAR(2)'), ''),
		NULLIF(T.F.value('(FamilyAddress)[1]', 'NVARCHAR(200)'), ''),
		NULLIF(T.F.value('(Ethnicity)[1]', 'NVARCHAR(1)'), ''),
		NULLIF(T.F.value('(ConfirmationNo)[1]', 'NVARCHAR(12)'), ''),
		NULLIF(T.F.value('(ConfirmationType)[1]', 'NVARCHAR(3)'), ''),
		T.F.value('(isOffline)[1]','INT')
		FROM @xml.nodes('Enrollment/Family') AS T(F);

		INSERT INTO @Insuree(InsureeId, FamilyId, CHFID, LastName, OtherNames, DOB, Gender, Marital, IsHead, Phone, CardIssued, Relationship, 
		Profession, Education, Email, TypeOfId, HFID, CurrentAddress, GeoLocation, CurrentVillage, PhotoPath, IdentificationNumber,isOffline,EffectiveDate)
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
					@EffectiveDate DATE

				
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
							DECLARE CurInsuree CURSOR FOR SELECT InsureeId, CHFID, isOffline,FamilyId FROM @Insuree WHERE isOffline = 1 OR CHFID NOT IN (SELECT CHFID FROM tblInsuree WHERE ValidityTo IS NULL);
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
							SELECT I.InsureeId, I.CHFID, 'Images\Updated\'PhotoFolder, dt.PhotoPath, @OfficerId OfficerId, GETDATE() PhotoDate, GETDATE() ValidityFrom, @AuditUserId AuditUserId
							FROM tblInsuree I 
							INNER JOIN @Insuree dt ON dt.CHFID = I.CHFID
							WHERE I.FamilyId = @CurFamilyId
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
					SELECT @HOFId = InsureeId FROM tblInsuree WHERE FamilyId = @FamilyId AND IsHead = 1
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
		RETURN -1;
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
							SELECT I.InsureeId, I.CHFID, 'Images\Updated\'PhotoFolder, dt.PhotoPath, @OfficerId OfficerId, GETDATE() PhotoDate, GETDATE() ValidityFrom, @AuditUserId AuditUserId
							FROM tblInsuree I 
							INNER JOIN @Insuree dt ON dt.CHFID = I.CHFID
							WHERE I.FamilyId = @FamilyId
							AND ValidityTo IS NULL;

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
								LEFT JOIN tblInsuree I ON I.CHFID = dt.CHFID 
								WHERE I.ValidityTo IS NULL AND I.InsureeID IS NULL AND dt.isOffline =0 
									)
							BEGIN
								--SET @FamilyId = (SELECT TOP 1 FamilyId FROM @Family)
								GOTO INSERTINSUREE;
							END
									
						ELSE
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
								
								UPDATE tblPhotos SET PhotoFolder = N'Images\Updated\',PhotoFileName = @PhotoFileName, OfficerID = @OfficerID, ValidityFrom = GETDATE(), AuditUserID = @AuditUserID 
								WHERE PhotoID = @PhotoID
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


								SELECT InsureeID FROM tblInsuree WHERE FamilyID IN (SELECT FamilyID FROM tblPolicy WHERE PolicyID=@NewPolicyId AND ValidityTo IS NULL) AND ValidityTo IS NULL ORDER BY InsureeID ASC


										DECLARE @NewCurrentInsureeId INT =0
										DECLARE CurNewCurrentInsuree CURSOR FOR 	
										SELECT InsureeID FROM tblInsuree WHERE FamilyID IN (SELECT FamilyID FROM tblPolicy WHERE PolicyID=@NewPolicyId AND ValidityTo IS NULL) AND ValidityTo IS NULL 
										ORDER BY InsureeID ASC
													OPEN CurNewCurrentInsuree
														FETCH NEXT FROM CurNewCurrentInsuree INTO @NewCurrentInsureeId
														WHILE @@FETCH_STATUS = 0
														BEGIN
														--Now we will insert new insuree in the table tblInsureePolicy
															EXEC uspAddInsureePolicy @NewCurrentInsureeId	
															FETCH NEXT FROM CurNewCurrentInsuree INTO @NewCurrentInsureeId
														END
														
													CLOSE CurNewCurrentInsuree
													DEALLOCATE CurNewCurrentInsuree						
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
		RETURN -1;
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
		RETURN -1;
	END CATCH





GO


IF NOT OBJECT_ID('uspExportOffLineExtract3') IS NULL
DROP PROCEDURE [dbo].[uspExportOffLineExtract3]
GO
CREATE PROCEDURE [dbo].[uspExportOffLineExtract3]
	 @RegionId INT = 0,
	 @DistrictId INT = 0,
	 @RowID as bigint = 0
	
AS
BEGIN
	SET NOCOUNT ON
	
	--**tblICDCodes**
	SELECT [ICDID],[ICDCode],[ICDName],[ValidityFrom],[ValidityTo],[LegacyID],[AuditUserID] FROM [dbo].[tblICDCodes] WHERE RowID > @RowID 
	
	--**HF**
	SELECT [HfID],[HFCode],[HFName],[LegalForm],[HFLevel],[HFSublevel],[HFAddress],[LocationId],[Phone],[Fax],[eMail],[HFCareType],[PLServiceID],[PLItemID],[AccCode],[OffLine],[ValidityFrom],[ValidityTo],[LegacyID],[AuditUserID] FROM [dbo].[tblHF] WHERE RowID > @RowID --AND (CASE @LocationId  WHEN 0 THEN 0 ELSE [DistrictID]  END) = @LocationId
	
	
	;WITH Family AS (
	SELECT F.[FamilyID]
	FROM [dbo].[tblFamilies] F 
	INNER JOIN tblVillages V ON V.VillageID = F.LocationId
	INNER JOIN tblWards W ON W.WardId = V.WardId
	INNER JOIN tblDistricts D ON D.DistrictId = W.DistrictId
	WHERE F.RowID > @RowID 
	
	AND (@RegionId =0 or (
	((CASE @DistrictId  WHEN 0 THEN 0 ELSE D.[DistrictID]  END) = @DistrictId) AND
	((CASE @DistrictId  WHEN 0 THEN  D.Region  ELSE @RegionId END) = @RegionId)
	))
	UNION 
	SELECT F.[FamilyID]
	FROM tblFamilies F 
	INNER JOIN tblInsuree I ON F.FamilyId = I.FamilyID
	INNER JOIN tblHF HF ON I.HFId = HF.HfID
	WHERE F.RowID > @RowID 
	AND (CASE @DistrictId  WHEN 0 THEN 0 ELSE HF.[LocationId]  END) = @DistrictId 
	)
	SELECT * INTO #FamiliesWProd From Family



	--**tblPayer**
	; WITH Payers As(
	SELECT [PayerID],[PayerType],[PayerName],[PayerAddress],P.[LocationId],[Phone],[Fax],[eMail],[ValidityFrom],[ValidityTo],[LegacyID],[AuditUserID] FROM [dbo].[tblPayer]  p
	LEFT JOIN uvwLocations L ON L.LocationId = p.LocationId
	WHERE RowID > @RowID  
		  AND ( L.RegionId = @RegionId OR @RegionId =0 OR P.LocationId IS NULL )  
		  AND (L.DistrictId =@DistrictId OR L.DistrictId IS NULL OR @DistrictId =0 )
	UNION ALL
	SELECT Pay.[PayerID],[PayerType],[PayerName],[PayerAddress],Pay.[LocationId],[Phone],[Fax],[eMail],Pay.[ValidityFrom], Pay.[ValidityTo], Pay.[LegacyID], Pay.[AuditUserID] 
	FROM [dbo].[tblPayer] Pay
	INNER JOIN tblPremium PR ON PR.PayerID = Pay.PayerID OR  PR.PayerID = Pay.LegacyID
	INNER JOIN tblPolicy PL ON PL.PolicyId = PR.PolicyId
	INNER JOIN tblFamilies F ON F.FamilyId = PL.FamilyID
	INNER JOIN tblVillages V ON V.VillageId = F.LocationId
	INNER JOIN tblWards W ON W.WardId = V.WardId
	INNER JOIN tblDistricts D ON D.DistrictID = W.DistrictId
	WHERE  Pay.RowID > @RowID 
		AND (((CASE @DistrictId  WHEN 0 THEN 0 ELSE D.[DistrictId]  END) = @DistrictId) OR D.Region = @RegionId) 
	
	)
	SELECT * FROM Payers Pay
	GROUP BY Pay.[PayerID],[PayerType],[PayerName],[PayerAddress],Pay.[LocationId],[Phone],[Fax],[eMail],Pay.[ValidityFrom], Pay.[ValidityTo], Pay.[LegacyID], Pay.[AuditUserID]
	

	--**tblOfficer**
	--SELECT [OfficerID],[Code],[LastName],[OtherNames],[DOB],[Phone],[DistrictID],[OfficerIDSubst],[WorksTo],[VEOCode],[VEOLastName],[VEOOtherNames],[VEODOB],[VEOPhone],[ValidityFrom],[ValidityTo],[LegacyID],[AuditUserID],EmailId FROM [dbo].[tblOfficer]  WHERE RowID > @RowID AND (CASE @LocationId  WHEN 0 THEN 0 ELSE [DistrictID]  END) = @LocationId
	; WITH Officer AS (
	SELECT [OfficerID],[Code],[LastName],[OtherNames],[DOB],[Phone],[LocationId],[OfficerIDSubst],[WorksTo],[VEOCode],[VEOLastName],[VEOOtherNames],[VEODOB],[VEOPhone],[ValidityFrom],[ValidityTo],[LegacyID],[AuditUserID],EmailId, PhoneCommunication,PermanentAddress FROM [dbo].[tblOfficer] 
	WHERE RowID > @RowID 
	AND (CASE @DistrictId  WHEN 0 THEN 0 ELSE [LocationId]  END) = @DistrictId
	UNION ALL
	 SELECT O.[OfficerID],[Code],O.[LastName],O.[OtherNames],O.[DOB],O.[Phone],O.[LocationId],[OfficerIDSubst],[WorksTo],[VEOCode],[VEOLastName],[VEOOtherNames],[VEODOB],[VEOPhone],O.[ValidityFrom],O.[ValidityTo],O.[LegacyID],O.[AuditUserID],EmailId, O.PhoneCommunication,O.PermanentAddress FROM [dbo].[tblOfficer] O 
	INNER JOIN tblPolicy P ON P.OfficerID = O.OfficerID
	INNER JOIN #FamiliesWProd F ON F.FamilyID =P.FamilyID
	UNION  ALL
	SELECT O.[OfficerID],[Code],[LastName],[OtherNames],[DOB],[Phone],O.[LocationId],[OfficerIDSubst],[WorksTo],[VEOCode],[VEOLastName],[VEOOtherNames],[VEODOB],[VEOPhone],O.[ValidityFrom], O.[ValidityTo], O.[LegacyID], O.[AuditUserID],EmailId, PhoneCommunication,PermanentAddress
	FROM [dbo].[tblOfficer]  O 
	INNER JOIN tblPolicy PL ON PL.OfficerId = O.OfficerID
	INNER JOIN tblFamilies F ON F.Familyid = PL.FamilyID
	INNER JOIN tblVillages V ON V.VillageID = F.LocationId
	INNER JOIN tblWards W ON W.WardId = V.WardId
	INNER JOIN tblDistricts D ON D.DistrictId = W.DistrictId
	WHERE O.RowID > @RowID AND ((CASE @DistrictId  WHEN 0 THEN 0 ELSE D.[DistrictID]  END) = @DistrictId OR D.Region =@RegionId)
	 )
	SELECT * FROM Officer O
	GROUP BY O.[OfficerID],[Code],O.[LastName],O.[OtherNames],O.[DOB],O.[Phone],O.[LocationId],[OfficerIDSubst],[WorksTo],[VEOCode],[VEOLastName],[VEOOtherNames],[VEODOB],[VEOPhone],O.[ValidityFrom],O.[ValidityTo],O.[LegacyID],O.[AuditUserID],EmailId, PhoneCommunication,PermanentAddress
	

	--**Product  Changed on 11.11.2017**
	

	; WITH Product AS (
	  SELECT [ProdID],[ProductCode],[ProductName],P.[LocationId],[InsurancePeriod],[DateFrom],[DateTo],[ConversionProdID],[LumpSum],[MemberCount],[PremiumAdult],[PremiumChild],[DedInsuree],[DedOPInsuree],[DedIPInsuree],[MaxInsuree],[MaxOPInsuree],[MaxIPInsuree],[PeriodRelPrices],[PeriodRelPricesOP],[PeriodRelPricesIP],[AccCodePremiums],[AccCodeRemuneration],[DedTreatment],[DedOPTreatment],[DedIPTreatment],[MaxTreatment],[MaxOPTreatment],[MaxIPTreatment],[DedPolicy],[DedOPPolicy],[DedIPPolicy],[MaxPolicy],[MaxOPPolicy],[MaxIPPolicy],[GracePeriod],[ValidityFrom],[ValidityTo],[LegacyID],[AuditUserID],[RegistrationLumpSum],[RegistrationFee],[GeneralAssemblyLumpSum],[GeneralAssemblyFee],[StartCycle1],[StartCycle2],[MaxNoConsultation],[MaxNoSurgery],[MaxNoDelivery],[MaxNoHospitalizaion],[MaxNoVisits],[MaxAmountConsultation],[MaxAmountSurgery],[MaxAmountDelivery],[MaxAmountHospitalization],[GracePeriodRenewal],[MaxInstallments],[WaitingPeriod]
		,RenewalDiscountPerc,RenewalDiscountPeriod,StartCycle3,StartCycle4,AdministrationPeriod,Threshold
		,MaxPolicyExtraMember,MaxPolicyExtraMemberIP,MaxPolicyExtraMemberOP,MaxCeilingPolicy,MaxCeilingPolicyIP,MaxCeilingPolicyOP, EnrolmentDiscountPeriod, EnrolmentDiscountPerc,MaxAmountAntenatal,MaxNoAntenatal,CeilingInterpretation,[Level1],[Sublevel1],[Level2],[Sublevel2],[Level3],[Sublevel3],[Level4],[Sublevel4],[ShareContribution],[WeightPopulation],WeightNumberFamilies,[WeightInsuredPopulation],[WeightNumberInsuredFamilies],[WeightNumberVisits],[WeightAdjustedAmount] FROM [dbo].[tblProduct]  P
		INNER JOIN uvwLocations L ON ISNULL(L.LocationId,0) = ISNULL(P.LocationId,0)
		WHERE  RowID > @RowID  
		AND (L.RegionId = @RegionId OR @RegionId =0 OR L.LocationId =0  )  
		AND (L.DistrictId =@DistrictId OR L.DistrictId IS NULL OR @DistrictId =0 )
		
		UNION  ALL
		
		SELECT Prod.[ProdID],[ProductCode],[ProductName],[LocationId],[InsurancePeriod],[DateFrom],[DateTo],[ConversionProdID],[LumpSum],[MemberCount],[PremiumAdult],[PremiumChild],[DedInsuree],[DedOPInsuree],[DedIPInsuree],[MaxInsuree],[MaxOPInsuree],[MaxIPInsuree],[PeriodRelPrices],[PeriodRelPricesOP],[PeriodRelPricesIP],[AccCodePremiums],[AccCodeRemuneration],[DedTreatment],[DedOPTreatment],[DedIPTreatment],[MaxTreatment],[MaxOPTreatment],[MaxIPTreatment],[DedPolicy],[DedOPPolicy],[DedIPPolicy],[MaxPolicy],[MaxOPPolicy],[MaxIPPolicy],[GracePeriod],Prod.[ValidityFrom],Prod.[ValidityTo],Prod.[LegacyID],Prod.[AuditUserID],[RegistrationLumpSum],[RegistrationFee],[GeneralAssemblyLumpSum],[GeneralAssemblyFee],[StartCycle1],[StartCycle2],[MaxNoConsultation],[MaxNoSurgery],[MaxNoDelivery],[MaxNoHospitalizaion],[MaxNoVisits],[MaxAmountConsultation],[MaxAmountSurgery],[MaxAmountDelivery],[MaxAmountHospitalization],[GracePeriodRenewal],[MaxInstallments],[WaitingPeriod]
		,RenewalDiscountPerc,RenewalDiscountPeriod,StartCycle3,StartCycle4,AdministrationPeriod,Threshold
		,MaxPolicyExtraMember,MaxPolicyExtraMemberIP,MaxPolicyExtraMemberOP,MaxCeilingPolicy,MaxCeilingPolicyIP,MaxCeilingPolicyOP, EnrolmentDiscountPeriod, EnrolmentDiscountPerc,MaxAmountAntenatal,MaxNoAntenatal,CeilingInterpretation,[Level1],[Sublevel1],[Level2],[Sublevel2],[Level3],[Sublevel3],[Level4],[Sublevel4],[ShareContribution],[WeightPopulation],WeightNumberFamilies,[WeightInsuredPopulation],[WeightNumberInsuredFamilies],[WeightNumberVisits],[WeightAdjustedAmount]
		 FROM tblProduct Prod
		INNER JOIN tblPolicy P ON Prod.ProdID = P.ProdID
		INNER JOIN #FamiliesWProd F ON F.FamilyID = P.FamilyID
	)
	SELECT * FROM Product Prod

	--ADDED
	UNION
	SELECT 
	Prod.[ProdID],[ProductCode],[ProductName],Prod.[LocationId],[InsurancePeriod],[DateFrom],[DateTo],[ConversionProdID],[LumpSum],[MemberCount],[PremiumAdult],[PremiumChild],[DedInsuree],[DedOPInsuree],[DedIPInsuree],[MaxInsuree],[MaxOPInsuree],[MaxIPInsuree],[PeriodRelPrices],[PeriodRelPricesOP],[PeriodRelPricesIP],[AccCodePremiums],[AccCodeRemuneration],[DedTreatment],[DedOPTreatment],[DedIPTreatment],[MaxTreatment],[MaxOPTreatment],[MaxIPTreatment],[DedPolicy],[DedOPPolicy],[DedIPPolicy],[MaxPolicy],[MaxOPPolicy],[MaxIPPolicy],[GracePeriod], Prod.[ValidityFrom], Prod.[ValidityTo], Prod.[LegacyID], Prod.[AuditUserID],[RegistrationLumpSum],[RegistrationFee],[GeneralAssemblyLumpSum],[GeneralAssemblyFee],[StartCycle1],[StartCycle2],[MaxNoConsultation],[MaxNoSurgery],[MaxNoDelivery],[MaxNoHospitalizaion],[MaxNoVisits],[MaxAmountConsultation],[MaxAmountSurgery],[MaxAmountDelivery],[MaxAmountHospitalization],[GracePeriodRenewal],[MaxInstallments],[WaitingPeriod]
	,RenewalDiscountPerc,RenewalDiscountPeriod,StartCycle3,StartCycle4,AdministrationPeriod,Threshold
	,MaxPolicyExtraMember,MaxPolicyExtraMemberIP,MaxPolicyExtraMemberOP,MaxCeilingPolicy,MaxCeilingPolicyIP,MaxCeilingPolicyOP, EnrolmentDiscountPeriod, EnrolmentDiscountPerc,MaxAmountAntenatal,MaxNoAntenatal,CeilingInterpretation,[Level1],[Sublevel1],[Level2],[Sublevel2],[Level3],[Sublevel3],[Level4],[Sublevel4],[ShareContribution],[WeightPopulation],WeightNumberFamilies,[WeightInsuredPopulation],[WeightNumberInsuredFamilies],[WeightNumberVisits],[WeightAdjustedAmount]
	 FROM tblProduct Prod WHERE ProdID IN (	SELECT ConversionProdID FROM Product WHERE NOT ConversionProdID IS NULL)
	 --END ADDED

	GROUP BY  Prod.[ProdID],[ProductCode],[ProductName],Prod.[LocationId],[InsurancePeriod],[DateFrom],[DateTo],[ConversionProdID],[LumpSum],[MemberCount],[PremiumAdult],[PremiumChild],[DedInsuree],[DedOPInsuree],[DedIPInsuree],[MaxInsuree],[MaxOPInsuree],[MaxIPInsuree],[PeriodRelPrices],[PeriodRelPricesOP],[PeriodRelPricesIP],[AccCodePremiums],[AccCodeRemuneration],[DedTreatment],[DedOPTreatment],[DedIPTreatment],[MaxTreatment],[MaxOPTreatment],[MaxIPTreatment],[DedPolicy],[DedOPPolicy],[DedIPPolicy],[MaxPolicy],[MaxOPPolicy],[MaxIPPolicy],[GracePeriod], Prod.[ValidityFrom], Prod.[ValidityTo], Prod.[LegacyID], Prod.[AuditUserID],[RegistrationLumpSum],[RegistrationFee],[GeneralAssemblyLumpSum],[GeneralAssemblyFee],[StartCycle1],[StartCycle2],[MaxNoConsultation],[MaxNoSurgery],[MaxNoDelivery],[MaxNoHospitalizaion],[MaxNoVisits],[MaxAmountConsultation],[MaxAmountSurgery],[MaxAmountDelivery],[MaxAmountHospitalization],[GracePeriodRenewal],[MaxInstallments],[WaitingPeriod]
	,RenewalDiscountPerc,RenewalDiscountPeriod,StartCycle3,StartCycle4,AdministrationPeriod,Threshold
	,MaxPolicyExtraMember,MaxPolicyExtraMemberIP,MaxPolicyExtraMemberOP,MaxCeilingPolicy,MaxCeilingPolicyIP,MaxCeilingPolicyOP, EnrolmentDiscountPeriod, EnrolmentDiscountPerc,MaxAmountAntenatal,MaxNoAntenatal,CeilingInterpretation,[Level1],[Sublevel1],[Level2],[Sublevel2],[Level3],[Sublevel3],[Level4],[Sublevel4],[ShareContribution],[WeightPopulation],WeightNumberFamilies,[WeightInsuredPopulation],[WeightNumberInsuredFamilies],[WeightNumberVisits],[WeightAdjustedAmount]
	
	--**End Product
	--**ProductItems**
	SELECT [ProdItemID],[tblProductItems].[ProdID],[ItemID],[LimitationType],[PriceOrigin],[LimitAdult],[LimitChild],[tblProductItems].[ValidityFrom] ,[tblProductItems].[ValidityTo],[tblProductItems].[LegacyID],[tblProductItems].[AuditUserID],[WaitingPeriodAdult],[WaitingPeriodChild],[LimitNoAdult],[LimitNoChild],LimitationTypeR,LimitationTypeE,LimitAdultR,LimitAdultE,LimitChildR,LimitChildE,CeilingExclusionAdult,CeilingExclusionChild FROM [dbo].[tblProductItems] 
	INNER JOIN [dbo].[tblProduct] P ON P.ProdID = tblProductItems.ProdID  
	INNER JOIN uvwLocations L ON ISNULL(L.LocationId,0) = ISNULL(P.LocationId,0)
	WHERE tblProductItems.RowID  > @RowID 
	    AND (L.RegionId = @RegionId OR @RegionId =0 OR L.LocationId =0  )  
		AND (L.DistrictId =@DistrictId OR L.DistrictId IS NULL OR @DistrictId =0 )

	--**ProductServices**
	SELECT [ProdServiceID],[dbo].[tblProductServices].[ProdID],[ServiceID],[LimitationType],[PriceOrigin],[LimitAdult],[LimitChild],[dbo].[tblProductServices].[ValidityFrom],[dbo].[tblProductServices].[ValidityTo],[dbo].[tblProductServices].[LegacyID],[dbo].[tblProductServices].[AuditUserID],[WaitingPeriodAdult],[WaitingPeriodChild],[LimitNoAdult],[LimitNoChild],LimitationTypeR,LimitationTypeE,LimitAdultR,LimitAdultE,LimitChildR,LimitChildE,CeilingExclusionAdult,CeilingExclusionChild FROM [dbo].[tblProductServices]
	 INNER JOIN [dbo].[tblProduct] P ON P.ProdID = tblProductServices.ProdID  
	 INNER JOIN uvwLocations L ON ISNULL(L.LocationId,0) = ISNULL(P.LocationId,0)
	WHERE tblProductServices.RowID  > @RowID 
	    AND (L.RegionId = @RegionId OR @RegionId =0 OR L.LocationId =0  )  
		AND (L.DistrictId =@DistrictId OR L.DistrictId IS NULL OR @DistrictId =0 ) 

	--**Product-RelDistr**
	SELECT [DistrID],[DistrType] ,[DistrCareType],[dbo].[tblRelDistr].[ProdID],[Period],[DistrPerc],[dbo].[tblRelDistr].[ValidityFrom],[dbo].[tblRelDistr].[ValidityTo],[dbo].[tblRelDistr].[LegacyID],[dbo].[tblRelDistr].[AuditUserID] 
	FROM [dbo].[tblRelDistr] 
	INNER JOIN [dbo].[tblProduct] P ON P.ProdID = tblRelDistr.ProdID   
	INNER JOIN uvwLocations L ON ISNULL(L.LocationId,0) = ISNULL(P.LocationId,0)
	WHERE [tblRelDistr].RowID  > @RowID 
	    AND (L.RegionId = @RegionId OR @RegionId =0 OR L.LocationId =0  )  
		AND (L.DistrictId =@DistrictId OR L.DistrictId IS NULL OR @DistrictId =0 ) 

	--**tblClaimAdmin**
	SELECT ClaimAdminId,ClaimAdminCode,LastName,OtherNames,DOB,CA.Phone,CA.HFId,CA.ValidityFrom,CA.ValidityTo,CA.LegacyId,CA.AuditUserId,EmailId 
	FROM tblClaimAdmin CA 
	INNER JOIN tblHF HF ON CA.HFId = HF.HfID 
	WHERE CA.RowId > @RowID
	AND (HF.LocationId = @DistrictId OR @DistrictId = 0)



	--********S tblOfficerVillage 
; WITH OfficerVillage AS (
	SELECT [OfficerID],[Code],[LastName],[OtherNames],[DOB],[Phone],[LocationId],[OfficerIDSubst],[WorksTo],[VEOCode],[VEOLastName],[VEOOtherNames],[VEODOB],[VEOPhone],[ValidityFrom],[ValidityTo],[LegacyID],[AuditUserID],EmailId, PhoneCommunication,PermanentAddress FROM [dbo].[tblOfficer] 
	WHERE RowID > @RowID 
	AND (CASE @DistrictId  WHEN 0 THEN 0 ELSE [LocationId]  END) = @DistrictId
	UNION ALL
	 SELECT O.[OfficerID],[Code],O.[LastName],O.[OtherNames],O.[DOB],O.[Phone],O.[LocationId],[OfficerIDSubst],[WorksTo],[VEOCode],[VEOLastName],[VEOOtherNames],[VEODOB],[VEOPhone],O.[ValidityFrom],O.[ValidityTo],O.[LegacyID],O.[AuditUserID],EmailId, O.PhoneCommunication,O.PermanentAddress FROM [dbo].[tblOfficer] O 
	INNER JOIN tblPolicy P ON P.OfficerID = O.OfficerID
	INNER JOIN #FamiliesWProd F ON F.FamilyID =P.FamilyID
	UNION  ALL
	SELECT O.[OfficerID],[Code],[LastName],[OtherNames],[DOB],[Phone],O.[LocationId],[OfficerIDSubst],[WorksTo],[VEOCode],[VEOLastName],[VEOOtherNames],[VEODOB],[VEOPhone],O.[ValidityFrom], O.[ValidityTo], O.[LegacyID], O.[AuditUserID],EmailId, PhoneCommunication,PermanentAddress
	FROM [dbo].[tblOfficer]  O 
	INNER JOIN tblPolicy PL ON PL.OfficerId = O.OfficerID
	INNER JOIN tblFamilies F ON F.Familyid = PL.FamilyID
	INNER JOIN tblVillages V ON V.VillageID = F.LocationId
	INNER JOIN tblWards W ON W.WardId = V.WardId
	INNER JOIN tblDistricts D ON D.DistrictId = W.DistrictId
	WHERE O.RowID > @RowID AND ((CASE @DistrictId  WHEN 0 THEN 0 ELSE D.[DistrictID]  END) = @DistrictId OR D.Region =@RegionId)
	 )
	SELECT OV.OfficerVillageId, OV.OfficerId, OV.LocationId, OV.ValidityFrom, OV.ValidityTo, OV.LegacyId, OV.AuditUserId FROM  tblOfficerVillages OV
	INNER JOIN OfficerVillage O ON O.OfficerID = OV.OfficerId
	GROUP BY OV.OfficerVillageId, OV.OfficerId, OV.LocationId, OV.ValidityFrom, OV.ValidityTo, OV.LegacyId, OV.AuditUserId
	
	DROP TABLE #FamiliesWProd

	--*******E tblOffficerVillage
END
GO
