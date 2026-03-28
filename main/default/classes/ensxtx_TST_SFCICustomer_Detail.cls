/// enosiX Inc. Generated Apex Model
/// Generated On: 9/22/2023 2:18:49 PM
/// SAP Host: From REST Service On: https://agility-power-3456-dev-ed.scratch.my.salesforce.com
/// CID: From REST Service On: https://agility-power-3456-dev-ed.scratch.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2
/// This file is a manually merged model and the CREDIT_DATA comes from the ECC model and CREDIT_SEGMENT comes from S4

@isTest
public with sharing class ensxtx_TST_SFCICustomer_Detail
{
    public class Mockensxtx_SBO_SFCICustomer_Detail implements
        ensxsdk.EnosixFramework.DetailSBOInitMock,
        ensxsdk.EnosixFramework.DetailSBOCommandMock,
        ensxsdk.EnosixFramework.DetailSBOGetMock,
        ensxsdk.EnosixFramework.DetailSBOSaveMock
    {
        public ensxsdk.EnosixFramework.DetailObject executeInitialize(ensxsdk.EnosixFramework.DetailObject initialState) { return null; }
        public ensxsdk.EnosixFramework.DetailObject executeCommand(String command, ensxsdk.EnosixFramework.DetailObject obj) { return null; }
        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key) { return null; }
        public ensxsdk.EnosixFramework.DetailObject executeSave(ensxsdk.EnosixFramework.DetailObject obj) { return null; }
    }

    @isTest
    static void testSBO()
    {
        ensxtx_SBO_SFCICustomer_Detail sbo = new ensxtx_SBO_SFCICustomer_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCICustomer_Detail.class, new Mockensxtx_SBO_SFCICustomer_Detail());
        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.command(null, null));
        System.assertEquals(null, sbo.getDetail(null));
        System.assertEquals(null, sbo.save(null));
    }

    @isTest
    static void testSFCICustomer()
    {
        ensxtx_SBO_SFCICustomer_Detail.SFCICustomer result = new ensxtx_SBO_SFCICustomer_Detail.SFCICustomer();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.SFCICustomer.class, result.getType(), 'getType() does not match object type.');

        result.registerReflectionForClass();

        result.CustomerNumber = 'X';
        System.assertEquals('X', result.CustomerNumber);

        result.Title = 'X';
        System.assertEquals('X', result.Title);

        result.TitleName = 'X';
        System.assertEquals('X', result.TitleName);

        result.Name = 'X';
        System.assertEquals('X', result.Name);

        result.Name2 = 'X';
        System.assertEquals('X', result.Name2);

        result.SearchTerm1 = 'X';
        System.assertEquals('X', result.SearchTerm1);

        result.HouseNumber = 'X';
        System.assertEquals('X', result.HouseNumber);

        result.Street = 'X';
        System.assertEquals('X', result.Street);

        result.City = 'X';
        System.assertEquals('X', result.City);

        result.PostalCode = 'X';
        System.assertEquals('X', result.PostalCode);

        result.Region = 'X';
        System.assertEquals('X', result.Region);

        result.RegionDescription = 'X';
        System.assertEquals('X', result.RegionDescription);

        result.Country = 'X';
        System.assertEquals('X', result.Country);

        result.CountryName = 'X';
        System.assertEquals('X', result.CountryName);

        result.POBox = 'X';
        System.assertEquals('X', result.POBox);

        result.POBoxPostalCode = 'X';
        System.assertEquals('X', result.POBoxPostalCode);

        result.CompanyPostalCode = 'X';
        System.assertEquals('X', result.CompanyPostalCode);

        result.Language = 'X';
        System.assertEquals('X', result.Language);

        result.LanguageDesc = 'X';
        System.assertEquals('X', result.LanguageDesc);

        result.TelephoneNumber = 'X';
        System.assertEquals('X', result.TelephoneNumber);

        result.TelephoneNumberExtension = 'X';
        System.assertEquals('X', result.TelephoneNumberExtension);

        result.MobileNumber = 'X';
        System.assertEquals('X', result.MobileNumber);

        result.FaxNumber = 'X';
        System.assertEquals('X', result.FaxNumber);

        result.FaxNumberExtension = 'X';
        System.assertEquals('X', result.FaxNumberExtension);

        result.EMailAddress = 'X';
        System.assertEquals('X', result.EMailAddress);

        result.TimeZone = 'X';
        System.assertEquals('X', result.TimeZone);

        result.TimeZoneText = 'X';
        System.assertEquals('X', result.TimeZoneText);

        result.TransportationZone = 'X';
        System.assertEquals('X', result.TransportationZone);

        result.TransportationZoneDescription = 'X';
        System.assertEquals('X', result.TransportationZoneDescription);

        result.CustomerAccountGroup = 'X';
        System.assertEquals('X', result.CustomerAccountGroup);

        result.AccountGroupName = 'X';
        System.assertEquals('X', result.AccountGroupName);

        result.DEMO = 'X';
        System.assertEquals('X', result.DEMO);

        //Test child collections
        System.assertNotEquals(null,result.COMPANY_DATA.getAsList());
        System.assertNotEquals(null,result.SALES_DATA.getAsList());
        System.assertNotEquals(null,result.PAYMENT_DATA.getAsList());
        System.assertNotEquals(null,result.CREDIT);
        System.assertNotEquals(null,result.CREDIT_DATA.getAsList());
        System.assertNotEquals(null,result.SALES_TEXT.getAsList());
        System.assertNotEquals(null,result.USER_DEFINED.getAsList());
        System.assertNotEquals(null,result.SALES_USER_DEFINED.getAsList());
        System.assertNotEquals(null,result.COMPANY_USER_DEFINED.getAsList());
        System.assertNotEquals(null,result.CREDIT_DATA_USER_DEFINED.getAsList());
        System.assertNotEquals(null,result.CONTACTS.getAsList());
        System.assertNotEquals(null,result.CREDIT_SEGMENT.getAsList());
    }

    @isTest
    static void testCOMPANY_DATA()
    {
        ensxtx_SBO_SFCICustomer_Detail.COMPANY_DATA childObj = new ensxtx_SBO_SFCICustomer_Detail.COMPANY_DATA();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.COMPANY_DATA.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.CompanyCode = 'X';
        System.assertEquals('X', childObj.CompanyCode);

        childObj.CompanyCodeDescription = 'X';
        System.assertEquals('X', childObj.CompanyCodeDescription);

        childObj.ReconciliationAccount = 'X';
        System.assertEquals('X', childObj.ReconciliationAccount);

        childObj.TermsofPaymentKey = 'X';
        System.assertEquals('X', childObj.TermsofPaymentKey);

        childObj.TermsOfPaymentDescription = 'X';
        System.assertEquals('X', childObj.TermsOfPaymentDescription);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testSALES_DATA()
    {
        ensxtx_SBO_SFCICustomer_Detail.SALES_DATA childObj = new ensxtx_SBO_SFCICustomer_Detail.SALES_DATA();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.SALES_DATA.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.SalesOrganization = 'X';
        System.assertEquals('X', childObj.SalesOrganization);

        childObj.SalesOrganizationName = 'X';
        System.assertEquals('X', childObj.SalesOrganizationName);

        childObj.DistributionChannel = 'X';
        System.assertEquals('X', childObj.DistributionChannel);

        childObj.DistributionChannelName = 'X';
        System.assertEquals('X', childObj.DistributionChannelName);

        childObj.Division = 'X';
        System.assertEquals('X', childObj.Division);

        childObj.DivisionName = 'X';
        System.assertEquals('X', childObj.DivisionName);

        childObj.SalesDistrict = 'X';
        System.assertEquals('X', childObj.SalesDistrict);

        childObj.SalesDistrictName = 'X';
        System.assertEquals('X', childObj.SalesDistrictName);

        childObj.SalesOffice = 'X';
        System.assertEquals('X', childObj.SalesOffice);

        childObj.SalesOfficeName = 'X';
        System.assertEquals('X', childObj.SalesOfficeName);

        childObj.SalesGroup = 'X';
        System.assertEquals('X', childObj.SalesGroup);

        childObj.SalesGroupName = 'X';
        System.assertEquals('X', childObj.SalesGroupName);

        childObj.DeliveryPlant = 'X';
        System.assertEquals('X', childObj.DeliveryPlant);

        childObj.DeliveryPlantName = 'X';
        System.assertEquals('X', childObj.DeliveryPlantName);

        childObj.PriceGroup = 'X';
        System.assertEquals('X', childObj.PriceGroup);

        childObj.PriceGroupDescription = 'X';
        System.assertEquals('X', childObj.PriceGroupDescription);

        childObj.CustomerPricingProcedure = 'X';
        System.assertEquals('X', childObj.CustomerPricingProcedure);

        childObj.CustomerPricProcedureDesc = 'X';
        System.assertEquals('X', childObj.CustomerPricProcedureDesc);

        childObj.PriceListType = 'X';
        System.assertEquals('X', childObj.PriceListType);

        childObj.PriceListTypeDescription = 'X';
        System.assertEquals('X', childObj.PriceListTypeDescription);

        childObj.StatisticsGroup = 'X';
        System.assertEquals('X', childObj.StatisticsGroup);

        childObj.StatisticsGroupDescription = 'X';
        System.assertEquals('X', childObj.StatisticsGroupDescription);

        childObj.ShippingConditions = 'X';
        System.assertEquals('X', childObj.ShippingConditions);

        childObj.ShippingConditionDescription = 'X';
        System.assertEquals('X', childObj.ShippingConditionDescription);

        childObj.CompleteDeliveryDefined = true;
        System.assertEquals(true, childObj.CompleteDeliveryDefined);

        childObj.MaximumNoOfPartialDelivery = 'X';
        System.assertEquals('X', childObj.MaximumNoOfPartialDelivery);

        childObj.TermsofPaymentKey = 'X';
        System.assertEquals('X', childObj.TermsofPaymentKey);

        childObj.TermsOfPaymentDescription = 'X';
        System.assertEquals('X', childObj.TermsOfPaymentDescription);

        childObj.CurrencyKey = 'X';
        System.assertEquals('X', childObj.CurrencyKey);

        childObj.TaxClassification = 'X';
        System.assertEquals('X', childObj.TaxClassification);

        childObj.TaxClassificationDescription = 'X';
        System.assertEquals('X', childObj.TaxClassificationDescription);

        childObj.CustomerGroup1 = 'X';
        System.assertEquals('X', childObj.CustomerGroup1);

        childObj.CustomerGroup1Name = 'X';
        System.assertEquals('X', childObj.CustomerGroup1Name);

        childObj.CustomerBlock = 'X';
        System.assertEquals('X', childObj.CustomerBlock);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testPAYMENT_DATA()
    {
        ensxtx_SBO_SFCICustomer_Detail.PAYMENT_DATA childObj = new ensxtx_SBO_SFCICustomer_Detail.PAYMENT_DATA();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.PAYMENT_DATA.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.PaymentCardID = 'X';
        System.assertEquals('X', childObj.PaymentCardID);

        childObj.PaymentCardType = 'X';
        System.assertEquals('X', childObj.PaymentCardType);

        childObj.PaymentCardTypeDesc = 'X';
        System.assertEquals('X', childObj.PaymentCardTypeDesc);

        childObj.CardNumber = 'X';
        System.assertEquals('X', childObj.CardNumber);

        childObj.DefaultPaymentCard = true;
        System.assertEquals(true, childObj.DefaultPaymentCard);

        childObj.CreditCardName = 'X';
        System.assertEquals('X', childObj.CreditCardName);

        childObj.CardHolderName = 'X';
        System.assertEquals('X', childObj.CardHolderName);

        childObj.CardCategory = 'X';
        System.assertEquals('X', childObj.CardCategory);

        childObj.CardCategoryDescription = 'X';
        System.assertEquals('X', childObj.CardCategoryDescription);

        childObj.ValidFromDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ValidFromDate);

        childObj.ValidToDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ValidToDate);

        childObj.X_RemoveCard = true;
        System.assertEquals(true, childObj.X_RemoveCard);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testCREDIT()
    {
        ensxtx_SBO_SFCICustomer_Detail.CREDIT childObj = new ensxtx_SBO_SFCICustomer_Detail.CREDIT();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.CREDIT.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.CreditLimit = 1.5;
        System.assertEquals(1.5, childObj.CreditLimit);

        childObj.CreditAvailable = 1.5;
        System.assertEquals(1.5, childObj.CreditAvailable);

        childObj.CurrencyKey = 'X';
        System.assertEquals('X', childObj.CurrencyKey);

        childObj.CreditManagmentBlock = true;
        System.assertEquals(true, childObj.CreditManagmentBlock);

        childObj.ValidToDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ValidToDate);

        childObj.ChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ChangeDate);

        childObj.CreditAnalyst = 'X';
        System.assertEquals('X', childObj.CreditAnalyst);

        childObj.CustomerCreditGroup = 'X';
        System.assertEquals('X', childObj.CustomerCreditGroup);

        childObj.ResubmissionDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ResubmissionDate);

        childObj.CalculatedCreditLimit = 1.5;
        System.assertEquals(1.5, childObj.CalculatedCreditLimit);

        childObj.SpecialAttentionRequired = true;
        System.assertEquals(true, childObj.SpecialAttentionRequired);

        childObj.LimitIsZero = true;
        System.assertEquals(true, childObj.LimitIsZero);

        childObj.CreditBlockReason = 'X';
        System.assertEquals('X', childObj.CreditBlockReason);

        childObj.CreditLimitRequested = 1.5;
        System.assertEquals(1.5, childObj.CreditLimitRequested);

        childObj.AutomaticLimitRequest = true;
        System.assertEquals(true, childObj.AutomaticLimitRequest);

        childObj.RequestedValidToDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.RequestedValidToDate);

        childObj.RequestDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.RequestDate);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testCREDIT_DATA()
    {
        ensxtx_SBO_SFCICustomer_Detail.CREDIT_DATA childObj = new ensxtx_SBO_SFCICustomer_Detail.CREDIT_DATA();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.CREDIT_DATA.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.CreditControlArea = 'X';
        System.assertEquals('X', childObj.CreditControlArea);

        childObj.CreditControlAreaDescription = 'X';
        System.assertEquals('X', childObj.CreditControlAreaDescription);

        childObj.CurrencyKey = 'X';
        System.assertEquals('X', childObj.CurrencyKey);

        childObj.CreditLimit = 1.5;
        System.assertEquals(1.5, childObj.CreditLimit);

        childObj.CustomerAccountNumber = 'X';
        System.assertEquals('X', childObj.CustomerAccountNumber);

        childObj.CreditLimitUsed = 1.5;
        System.assertEquals(1.5, childObj.CreditLimitUsed);

        childObj.CreditHorizonDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreditHorizonDate);

        childObj.Receivables = 1.5;
        System.assertEquals(1.5, childObj.Receivables);

        childObj.SpecialLiabilities = 1.5;
        System.assertEquals(1.5, childObj.SpecialLiabilities);

        childObj.SalesValue = 1.5;
        System.assertEquals(1.5, childObj.SalesValue);

        childObj.CreditExposure = 1.5;
        System.assertEquals(1.5, childObj.CreditExposure);

        childObj.TotalSecuredReceivables = 1.5;
        System.assertEquals(1.5, childObj.TotalSecuredReceivables);

        childObj.Blocked = true;
        System.assertEquals(true, childObj.Blocked);

        childObj.RiskCategory = 'X';
        System.assertEquals('X', childObj.RiskCategory);

        childObj.RiskCategoryDescription = 'X';
        System.assertEquals('X', childObj.RiskCategoryDescription);

        childObj.CreditRepresentativeGroup = 'X';
        System.assertEquals('X', childObj.CreditRepresentativeGroup);

        childObj.CreditRepresentativeGroupDescription = 'X';
        System.assertEquals('X', childObj.CreditRepresentativeGroupDescription);

        childObj.CustomerCreditGroup = 'X';
        System.assertEquals('X', childObj.CustomerCreditGroup);

        childObj.CustomerCreditGroupDescription = 'X';
        System.assertEquals('X', childObj.CustomerCreditGroupDescription);

        childObj.CustomerGroup = 'X';
        System.assertEquals('X', childObj.CustomerGroup);

        childObj.CustomerGroupDescription = 'X';
        System.assertEquals('X', childObj.CustomerGroupDescription);

        childObj.ReferenceDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ReferenceDate);

        childObj.LastInternalReview = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.LastInternalReview);

        childObj.NextInternalReview = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.NextInternalReview);

        List<string> keyFields = new List<string>{ 'KKBER' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testSALES_TEXT()
    {
        ensxtx_SBO_SFCICustomer_Detail.SALES_TEXT childObj = new ensxtx_SBO_SFCICustomer_Detail.SALES_TEXT();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.SALES_TEXT.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.SalesOrganization = 'X';
        System.assertEquals('X', childObj.SalesOrganization);

        childObj.DistributionChannel = 'X';
        System.assertEquals('X', childObj.DistributionChannel);

        childObj.Division = 'X';
        System.assertEquals('X', childObj.Division);

        childObj.TextID = 'X';
        System.assertEquals('X', childObj.TextID);

        childObj.TextLanguage = 'X';
        System.assertEquals('X', childObj.TextLanguage);

        childObj.TextIDDescription = 'X';
        System.assertEquals('X', childObj.TextIDDescription);

        childObj.FirstLine = 'X';
        System.assertEquals('X', childObj.FirstLine);

        childObj.MoreTextExists = true;
        System.assertEquals(true, childObj.MoreTextExists);

        childObj.Text = 'X';
        System.assertEquals('X', childObj.Text);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testUSER_DEFINED()
    {
        ensxtx_SBO_SFCICustomer_Detail.USER_DEFINED childObj = new ensxtx_SBO_SFCICustomer_Detail.USER_DEFINED();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.USER_DEFINED.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.FIELD = 'X';
        System.assertEquals('X', childObj.FIELD);

        childObj.VALUE = 'X';
        System.assertEquals('X', childObj.VALUE);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testSALES_USER_DEFINED()
    {
        ensxtx_SBO_SFCICustomer_Detail.SALES_USER_DEFINED childObj = new ensxtx_SBO_SFCICustomer_Detail.SALES_USER_DEFINED();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.SALES_USER_DEFINED.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.SalesOrganization = 'X';
        System.assertEquals('X', childObj.SalesOrganization);

        childObj.DistributionChannel = 'X';
        System.assertEquals('X', childObj.DistributionChannel);

        childObj.Division = 'X';
        System.assertEquals('X', childObj.Division);

        childObj.FIELD = 'X';
        System.assertEquals('X', childObj.FIELD);

        childObj.VALUE = 'X';
        System.assertEquals('X', childObj.VALUE);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testCOMPANY_USER_DEFINED()
    {
        ensxtx_SBO_SFCICustomer_Detail.COMPANY_USER_DEFINED childObj = new ensxtx_SBO_SFCICustomer_Detail.COMPANY_USER_DEFINED();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.COMPANY_USER_DEFINED.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.CompanyCode = 'X';
        System.assertEquals('X', childObj.CompanyCode);

        childObj.FIELD = 'X';
        System.assertEquals('X', childObj.FIELD);

        childObj.VALUE = 'X';
        System.assertEquals('X', childObj.VALUE);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testCREDIT_DATA_USER_DEFINED()
    {
        ensxtx_SBO_SFCICustomer_Detail.CREDIT_DATA_USER_DEFINED childObj = new ensxtx_SBO_SFCICustomer_Detail.CREDIT_DATA_USER_DEFINED();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.CREDIT_DATA_USER_DEFINED.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.KKBER = 'X';
        System.assertEquals('X', childObj.KKBER);

        childObj.FIELD = 'X';
        System.assertEquals('X', childObj.FIELD);

        childObj.VALUE = 'X';
        System.assertEquals('X', childObj.VALUE);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testCONTACTS()
    {
        ensxtx_SBO_SFCICustomer_Detail.CONTACTS childObj = new ensxtx_SBO_SFCICustomer_Detail.CONTACTS();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.CONTACTS.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.ContactPersonNumber = 'X';
        System.assertEquals('X', childObj.ContactPersonNumber);

        childObj.FirstName = 'X';
        System.assertEquals('X', childObj.FirstName);

        childObj.LastName = 'X';
        System.assertEquals('X', childObj.LastName);

        childObj.Name = 'X';
        System.assertEquals('X', childObj.Name);

        childObj.VIPPartner = 'X';
        System.assertEquals('X', childObj.VIPPartner);

        childObj.DepartmentNumber = 'X';
        System.assertEquals('X', childObj.DepartmentNumber);

        childObj.Function = 'X';
        System.assertEquals('X', childObj.Function);

        childObj.Authority = 'X';
        System.assertEquals('X', childObj.Authority);

        childObj.HigherPartner = 'X';
        System.assertEquals('X', childObj.HigherPartner);

        childObj.SalesEmployee = 'X';
        System.assertEquals('X', childObj.SalesEmployee);

        childObj.Gender = 'X';
        System.assertEquals('X', childObj.Gender);

        childObj.DateOfBirth = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.DateOfBirth);

        childObj.MaritalStatus = 'X';
        System.assertEquals('X', childObj.MaritalStatus);

        childObj.CallFrequency = 'X';
        System.assertEquals('X', childObj.CallFrequency);

        childObj.BuyingHabits = 'X';
        System.assertEquals('X', childObj.BuyingHabits);

        childObj.Notes = 'X';
        System.assertEquals('X', childObj.Notes);

        childObj.HouseNumber = 'X';
        System.assertEquals('X', childObj.HouseNumber);

        childObj.Street = 'X';
        System.assertEquals('X', childObj.Street);

        childObj.City = 'X';
        System.assertEquals('X', childObj.City);

        childObj.PostalCode = 'X';
        System.assertEquals('X', childObj.PostalCode);

        childObj.Region = 'X';
        System.assertEquals('X', childObj.Region);

        childObj.RegionDescription = 'X';
        System.assertEquals('X', childObj.RegionDescription);

        childObj.Country = 'X';
        System.assertEquals('X', childObj.Country);

        childObj.CountryName = 'X';
        System.assertEquals('X', childObj.CountryName);

        childObj.TimeZone = 'X';
        System.assertEquals('X', childObj.TimeZone);

        childObj.TimeZoneText = 'X';
        System.assertEquals('X', childObj.TimeZoneText);

        childObj.TransportationZone = 'X';
        System.assertEquals('X', childObj.TransportationZone);

        childObj.TransportationZoneDescription = 'X';
        System.assertEquals('X', childObj.TransportationZoneDescription);

        childObj.POBox = 'X';
        System.assertEquals('X', childObj.POBox);

        childObj.POBoxPostalCode = 'X';
        System.assertEquals('X', childObj.POBoxPostalCode);

        childObj.CompanyPostalCode = 'X';
        System.assertEquals('X', childObj.CompanyPostalCode);

        childObj.Language = 'X';
        System.assertEquals('X', childObj.Language);

        childObj.LanguageDesc = 'X';
        System.assertEquals('X', childObj.LanguageDesc);

        childObj.TelephoneNumber = 'X';
        System.assertEquals('X', childObj.TelephoneNumber);

        childObj.TelephoneNumberExtension = 'X';
        System.assertEquals('X', childObj.TelephoneNumberExtension);

        childObj.MobileNumber = 'X';
        System.assertEquals('X', childObj.MobileNumber);

        childObj.FaxNumber = 'X';
        System.assertEquals('X', childObj.FaxNumber);

        childObj.FaxNumberExtension = 'X';
        System.assertEquals('X', childObj.FaxNumberExtension);

        childObj.EMailAddress = 'X';
        System.assertEquals('X', childObj.EMailAddress);

        childObj.DefaultCommunicationMethod = 'X';
        System.assertEquals('X', childObj.DefaultCommunicationMethod);

        childObj.DefaultCommunicationMethodDescription = 'X';
        System.assertEquals('X', childObj.DefaultCommunicationMethodDescription);

        childObj.Extension1 = 'X';
        System.assertEquals('X', childObj.Extension1);

        childObj.Extension2 = 'X';
        System.assertEquals('X', childObj.Extension2);

        childObj.AddressNotes = 'X';
        System.assertEquals('X', childObj.AddressNotes);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testCREDIT_SEGMENT()
    {
        ensxtx_SBO_SFCICustomer_Detail.CREDIT_SEGMENT childObj = new ensxtx_SBO_SFCICustomer_Detail.CREDIT_SEGMENT();
        System.assertEquals(ensxtx_SBO_SFCICustomer_Detail.CREDIT_SEGMENT.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.CreditSegment = 'X';
        System.assertEquals('X', childObj.CreditSegment);

        childObj.CreditSegmentDescription = 'X';
        System.assertEquals('X', childObj.CreditSegmentDescription);

        childObj.Partner = 'X';
        System.assertEquals('X', childObj.Partner);

        childObj.CreditLimit = 1.5;
        System.assertEquals(1.5, childObj.CreditLimit);

        childObj.Amount = 1.5;
        System.assertEquals(1.5, childObj.Amount);

        childObj.OrderCurrency = 'X';
        System.assertEquals('X', childObj.OrderCurrency);

        childObj.CreditManagmentBlock = true;
        System.assertEquals(true, childObj.CreditManagmentBlock);

        childObj.ValidToDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ValidToDate);

        childObj.ChangeDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ChangeDate);

        childObj.CustomerCreditGroup = 'X';
        System.assertEquals('X', childObj.CustomerCreditGroup);

        childObj.ResubmissionDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ResubmissionDate);

        childObj.CalculatedCreditLimit = 1.5;
        System.assertEquals(1.5, childObj.CalculatedCreditLimit);

        childObj.SpecialAttentionRequired = true;
        System.assertEquals(true, childObj.SpecialAttentionRequired);

        childObj.LimitIsZero = true;
        System.assertEquals(true, childObj.LimitIsZero);

        childObj.CreditBlockReason = 'X';
        System.assertEquals('X', childObj.CreditBlockReason);

        childObj.CreditBlockReasonDescription = 'X';
        System.assertEquals('X', childObj.CreditBlockReasonDescription);

        childObj.CreditLimitRequested = 1.5;
        System.assertEquals(1.5, childObj.CreditLimitRequested);

        childObj.AutomaticLimitRequest = true;
        System.assertEquals(true, childObj.AutomaticLimitRequest);

        childObj.RequestedValidToDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.RequestedValidToDate);

        childObj.RequestDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.RequestDate);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
}