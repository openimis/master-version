TRUNCATE TABLE tblTempExpenditureRange;
TRUNCATE TABLE tblTempDisease;
TRUNCATE TABLE tblTempNumberInsureeCurrent;
TRUNCATE TABLE tblTempPremiumCollection;
TRUNCATE TABLE tblTempNumberInsureeAcquired;
TRUNCATE TABLE tblTempNumberPolicyCurrent;
TRUNCATE TABLE tblTempNumberPoliciesSold;
TRUNCATE TABLE tblTempPolicyRenewal;
TRUNCATE TABLE tblTempNumberPolicyExpired;
TRUNCATE TABLE tblTempServiceExpenditures;
TRUNCATE TABLE tblTempItemExpenditures;
TRUNCATE TABLE tblTempServiceUtilization;
TRUNCATE TABLE tblTempItemUtilization;
TRUNCATE TABLE tblTempHospitalAdmissions;
TRUNCATE TABLE tblTempVisits;
TRUNCATE TABLE tblTempHospitalDays;
TRUNCATE TABLE tblTempClaimSent;
TRUNCATE TABLE tblTempAmountClaimed;
TRUNCATE TABLE tblTempAmountApproved;
TRUNCATE TABLE tblTempAmountRejected;
TRUNCATE TABLE tblTempNumberFeedbackSent;
TRUNCATE TABLE tblTempNumberFeedbackResponded;
TRUNCATE TABLE tblTempNumberFeedbackAnswerYes;
TRUNCATE TABLE tblTempExpenditure;
TRUNCATE TABLE tblTempOverallAssessment;
TRUNCATE TABLE tblTempPopulation;
TRUNCATE TABLE tblTempClaimEntered;
TRUNCATE TABLE tblTempClaimSubmitted;
TRUNCATE TABLE tblTempClaimProcessed;
TRUNCATE TABLE tblTempClaimRejected;
TRUNCATE TABLE tblTempPremiumAllocation;
TRUNCATE TABLE tblTempClaimValuated;
TRUNCATE TABLE tblTempAmountValuated;
TRUNCATE TABLE tblTempNumberOfInsuredHouseholds;

TRUNCATE TABLE tblFactNumberInsureeCurrent;
TRUNCATE TABLE tblFactNumberInsureeAquired;
TRUNCATE TABLE tblFactNumberPolicyCurrent;
TRUNCATE TABLE tblFactNumberPoliciesSold;
TRUNCATE TABLE tblFactNumberPoliciesRenewed;
TRUNCATE TABLE tblFactNumberPoliciesExpired;
TRUNCATE TABLE tblFactPremiumCollected;
TRUNCATE TABLE tblFactServiceExpenditures;
TRUNCATE TABLE tblFactItemExpenditures;
TRUNCATE TABLE tblFactUtilizationServices;
TRUNCATE TABLE tblFactUtilizationItems;
TRUNCATE TABLE tblFactAdmissions;
TRUNCATE TABLE tblFactVisits;
TRUNCATE TABLE tblFactHospitalDays;
TRUNCATE TABLE tblFactSentClaims;
TRUNCATE TABLE tblFactAmountClaimed;
TRUNCATE TABLE tblFactAmountApproved;
TRUNCATE TABLE tblFactAmountRejected;
TRUNCATE TABLE tblFactNumberFeedbacksSent;
TRUNCATE TABLE tblFactNumberFeedbacksResponded;
TRUNCATE TABLE tblFactNumberFeedbacksAnswerYes;
TRUNCATE TABLE tblFactExpendituresInsureesRange;
TRUNCATE TABLE tblFactNumberInsureesRange;
TRUNCATE TABLE tblFactOverAllAssessment;
TRUNCATE TABLE tblFactPopulation;
TRUNCATE TABLE tblFactClaimEntered;
TRUNCATE TABLE tblFactClaimSubmitted;
TRUNCATE TABLE tblFactClaimProcessed;
TRUNCATE TABLE tblFactClaimRejected;
TRUNCATE TABLE tblFactPremiumAllocation;
TRUNCATE TABLE tblFactClaimValuated;
TRUNCATE TABLE tblFactAmountValuated;
TRUNCATE TABLE tblFactNumberOfInsuredHouseholds;

DELETE FROM tblDimProducts;
DBCC CHECKIDENT('tblDimProducts', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimAge;
DBCC CHECKIDENT('tblDimAge', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimGender
DBCC CHECKIDENT('tblDimGender', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimCareType
DBCC CHECKIDENT('tblDimCareType', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimDisease
DBCC CHECKIDENT('tblDimDisease', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimProviders
DBCC CHECKIDENT('tblDimProviders', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimPayers
DBCC CHECKIDENT('tblDimPayers', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimOfficers
DBCC CHECKIDENT('tblDimOfficers', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimQuestions
DBCC CHECKIDENT('tblDimQuestions', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimExpenditure
DBCC CHECKIDENT('tblDimExpenditure', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimCategoryCare
DBCC CHECKIDENT('tblDimCategoryCare', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimItems
DBCC CHECKIDENT('tblDimItems', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimServices
DBCC CHECKIDENT('tblDimServices', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimTime
DBCC CHECKIDENT('tblDimTime', RESEED, 0) WITH NO_INFOMSGS;
DELETE FROM tblDimRegion
DBCC CHECKIDENT('tblDimRegion', RESEED, 0) WITH NO_INFOMSGS;
