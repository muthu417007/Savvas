/*
* class name: CaseTriggerForRPAIntegrationTest
* description: Test class that covers code for CaseTriggerForRPAIntegration, CaseTriggerCalloutQueueable.cls, EmailToCaseHandler.cls,   EmailService.cls
* created by: Praveen Tharala
*/

@isTest
public class CaseTriggerForRPAIntegrationTest {
    @testSetup
    static void testDataMethod(){
        EmailServiceConfig__c sConfig = new EmailServiceConfig__c();
        sConfig.host_url__c = 'http://1.1.1.1/infer';
        sConfig.RPAReConsciliation__c = 'http://1.1.1.1/token';
        sConfig.Content_Type__c = 'application/json';
        sConfig.SetupOwnerId = UserInfo.getOrganizationId();
        insert sConfig;
        
        map<String, String> mapMockResponse = new map<String, String>();
        Test.setMock(HttpCalloutMock.class, new CaseTriggerForRPAIntegrationTestMock(mapMockResponse));
        
        //insert Accounts
        List<Account> accountsToInsert = new list<Account>();
        accountsToInsert.add( new Account(Name = 'RPA Dummy Account', Type = 'Internal'));
        accountsToInsert.add( new Account(Name = 'St John Lutheran School', Type = 'Private School', BillingCity = 'WEST SENECA', BillingState = 'NY', BillingPostalCode = '14224-1892', BillingStreet = '355 HARLEM ROAD', BillingCountry = 'United States'));
        accountsToInsert.add( new Account(Name = 'Kacee Torgerson', Type = 'Clinic', BillingCity = 'Placerville', BillingState = 'CA', BillingPostalCode = '95667', BillingStreet = 'PO Box 1387', BillingCountry = 'United States'));
        accountsToInsert.add( new Account(Name = 'Shaena Torgerson', Type = 'Individual Educ', BillingCity = 'Corona', BillingState = 'CA', BillingPostalCode = '92880', BillingStreet = '7226 Spindlewood Drive', BillingCountry = 'United States'));
        accountsToInsert.add( new Account(Name = 'Canyon Crest Academy', Type = 'Public School', BillingCity = 'Encinitas', BillingState = 'CA', BillingPostalCode = '92024-3305', BillingStreet = '710 Encinitas Blvd', BillingCountry = 'United States'));
        accountsToInsert.add( new Account(Name = 'Erie 1 BOCES', Type = 'Public School', BillingCity = 'Encinitas', BillingState = 'CA', BillingPostalCode = '92024-3305', BillingStreet = '710 Encinitas Blvd', BillingCountry = 'United States'));
        accountsToInsert.add( new Account(Name = 'Avant Garde Academy Broward', Type = 'Public School', BillingCity = 'Hollywood', BillingState = 'FL', BillingPostalCode = '33020', BillingStreet = '2025 McKinley St', BillingCountry = 'United States'));
        accountsToInsert.add( new Account(Name = 'Avant Garde Academy Broward', Type = 'Public School', BillingCity = 'Hollywood', BillingState = 'FL', BillingPostalCode = '33020', BillingStreet = 'McKinley', BillingCountry = 'United States'));
        insert accountsToInsert;
        //Erie 1 BOCES
        //insert Contacts 
        List<Contact> contactsToInsert = new list<Contact>();
        contactsToInsert.add( new Contact(AccountId = accountsToInsert[1].Id, FirstName = 'Terrie', LastName = 'Licht', Email = 'office@stjohnnt.com'));
        contactsToInsert.add( new Contact(AccountId = accountsToInsert[2].Id, FirstName = 'Shaena', LastName = 'T', Email = 'test@sht.com'));
        //contactsToInsert.add( new Contact(AccountId = accountsToInsert[3].Id, FirstName = 'Margy', LastName = 'Lara', Email = 'test@sht.com'));
        //contactsToInsert.add( new Contact(AccountId = accountsToInsert[4].Id, FirstName = 'Margy', LastName = 'Lara', Email = 'test@sht.com'));
        contactsToInsert.add( new Contact(AccountId = accountsToInsert[5].Id, FirstName = 'Tom', LastName = 'Licht', Email = 'tom@litch1.com'));
        contactsToInsert.add( new Contact(AccountId = accountsToInsert[7].Id, FirstName = 'Tom', LastName = 'Licht', Email = 'businessmanager@agabroward.org'));
        insert contactsToInsert;
        
        //insert Account Address
        List<Account_Addresses__c> acntAddrsToInsert = new List<Account_Addresses__c>();
        acntAddrsToInsert.add(new Account_Addresses__c(Account__c = accountsToInsert[1].Id, 
                                                       Address_1__c ='355 HARLEM ROAD', 
                                                       Address_2__c = 'SERV EDUCATION CAMPUS SERVICE CTR',
                                                       Address_Type__c ='Billing',
                                                       City__c = 'WEST SENECA',
                                                       Country__c ='US',
                                                       ERP_Account_Name__c = 'ERIE 1 BD OF COOPERATIVE EDUCATION',ERP_Account_Number__c = '0002157046',
                                                       Source__c = 'SAP_USK12',
                                                       State__c = 'NY',
                                                       Zip_Code__c = '14224-1892'));

        acntAddrsToInsert.add(new Account_Addresses__c(Account__c = accountsToInsert[1].Id, 
                                                       Address_1__c ='6950 WARD RD', 
                                                       Address_Type__c ='Shipping',
                                                       City__c = 'NORTH TONAWANDA',
                                                       Country__c ='US',
                                                       ERP_Account_Name__c = 'ST JOHN LUTHERAN SCHOOL',ERP_Account_Number__c = '0002156407',
                                                       Source__c = 'SAP_USK12',
                                                       State__c = 'NY',
                                                       Zip_Code__c = '14120-1413'));
        
        acntAddrsToInsert.add(new Account_Addresses__c(Account__c = accountsToInsert[4].Id, 
                                                       Address_1__c ='5951 VILLAGE CENTER LOOP RD', 
                                                       Address_Type__c ='Billing',
                                                       City__c = 'SAN DIEGO',
                                                       Country__c ='US',
                                                       ERP_Account_Name__c = 'CANYON CREST ACADEMY',
                                                       ERP_Account_Number__c = '0002495822',
                                                       Source__c = 'SAP_USK12',
                                                       State__c = 'CA',
                                                       Zip_Code__c = '92130-2499'));
        
         acntAddrsToInsert.add(new Account_Addresses__c(Account__c = accountsToInsert[4].Id, 
                                                       Address_1__c ='710 ENCINITAS BLVD', 
                                                       Address_Type__c ='Shipping',
                                                       City__c = 'ENCINITAS',
                                                       Country__c ='US',
                                                       ERP_Account_Name__c = 'SAN DIEGUITO UNION HS DISTRICT',
                                                       ERP_Account_Number__c = '0002346703',
                                                       Source__c = 'SAP_USK12',
                                                       State__c = 'CA',
                                                       Zip_Code__c = '92024-3357'));
        
        insert acntAddrsToInsert;
        
        List<Case> cases = new List<Case>();
        
        Case c = new Case();
        c.Origin = 'Email';
        c.OwnerId = [select Id from Group where type='Queue' and Name = 'EMAIL CS K12 - New Order' limit 1].Id;
        c.Subject = 'Email Subject1';
        c.Description = 'Email Description1';
        
        Case c1 = new Case();
        c1.Origin = 'Email';
        c1.OwnerId = UserInfo.getUserId();
        c1.Subject = 'Email Subject2';
        c1.Description = 'Email Description2';
        
        cases.add(c);
        cases.add(c1);
        
        Test.startTest();
        insert cases;
        Test.stopTest();
        
        EmailMessage eM = new EmailMessage();
        eM.FromAddress = 'test@test.com';
        eM.ParentId = cases[0].Id;
        eM.Subject = 'Email Subject';
        eM.TextBody = 'Email Description';
        
        insert eM;
        
        Attachment a = new Attachment();
        a.ParentId = eM.Id;
        a.Body = Blob.valueOf('Test Attachment');
        a.Name = 'Test Attachment';
        a.ContentType = 'application/pdf';
        
        insert a;
        
        List<Case> cas = [select Id from Case];
        System.assert(cas.size() == 2);    
    }
    
    @isTest
    static void testRPAClassifyMethod(){
        map<String, String> mapMockResponse = new map<String, String>();
        Test.setMock(HttpCalloutMock.class, new CaseTriggerForRPAIntegrationTestMock(mapMockResponse));
        
        Case c = [select Id from Case where Subject = 'Email Subject1' limit 1];
        System.assert(c!=null);
        
        c.RPA_ORDER_AMOUNT__c = 2;
        
        Test.startTest();
        update c;
        EmailToCaseHandler.onCaseInsertorUpdate(String.valueOf(c.Id));
        Test.stopTest();
        
        c = [select Id, RPA_Classification__c from Case limit 1];
        System.assert(c.RPA_Classification__c == 'Others');
    }
    
    @isTest
    static void testRPACaseMethod(){
        map<String, String> mapMockResponse = new map<String, String>();
        Test.setMock(HttpCalloutMock.class, new CaseTriggerForRPAIntegrationTestMock(mapMockResponse));
        Case c = [select Id from Case where Subject = 'Email Subject1' limit 1];
        
        System.assert(c!=null);
        
        c.RPA_ORDER_AMOUNT__c = 2;
        c.RPA_Classification__c = 'Others';
        
        Test.startTest();
        update c;
        EmailToCaseHandler.onRPAAmountUpdate(c.Id);
        EmailToCaseHandler.onCaseUpdate(c.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testRPAUploadCaseMethod(){ //RPA Phase#3 dummy
        map<String, String> mapMockResponse = new map<String, String>();
        String dummy = '{"schema":{"fields":[{"name":"index","type":"integer"},{"name":"FileName","type":"string"},{"name":"Label","type":"string"},{"name":"Value","type":"string"},{"name":"X1","type":"string"},{"name":"Y1","type":"string"},{"name":"X2","type":"string"},{"name":"Y2","type":"string"},{"name":"Confidence_Score_Header","type":"string"},{"name":"Category","type":"string"},{"name":"LineNumber","type":"string"},{"name":"PageNo","type":"string"}],"primaryKey":["index"],"pandas_version":"1.4.0"},"data":[{"index":0,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"PONUMBER","Value":"TX0775-23","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":1,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"PODate","Value":"18-SEP-2022","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":2,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Street","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":3,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_city","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":4,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_State","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":5,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Zip","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":6,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Country","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":7,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_Street","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":8,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_city","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":9,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_State","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":10,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_Zip","Value":"14224-1892","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":11,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_Country","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":12,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Contact","Value":"Tom Licht","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":13,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_PhoneNum","Value":"716-693-9677","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":14,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Email","Value":"test@test.com","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":15,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Institution_Name","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":16,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Shipping_Institution_Name","Value":"abcd","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":17,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Billing_Institution_Name","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":18,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"ISBN","Value":"9780768581416","X1":393,"Y1":1930,"X2":1331,"Y2":1956,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":19,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"QUANTITY","Value":"3.00","X1":106,"Y1":1930,"X2":169,"Y2":1956,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":20,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"UNITPRICE","Value":"28.0000","X1":1940,"Y1":1930,"X2":2059,"Y2":1956,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":21,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"AMOUNT","Value":"84.00","X1":2360,"Y1":1930,"X2":2440,"Y2":1956,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":22,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"QUANTITY","Value":"1.00","X1":110,"Y1":2008,"X2":169,"Y2":2033,"Confidence_Score_Header":"0","Category":"Table","LineNumber":2,"PageNo":1},{"index":23,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"UNITPRICE","Value":"0.0100","X1":1959,"Y1":2008,"X2":2059,"Y2":2033,"Confidence_Score_Header":"0","Category":"Table","LineNumber":2,"PageNo":1},{"index":24,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"AMOUNT","Value":"0.01","X1":2378,"Y1":2008,"X2":2437,"Y2":2033,"Confidence_Score_Header":"0","Category":"Table","LineNumber":2,"PageNo":1}]}';
        mapMockResponse.put('dummy',dummy);
        Test.setMock(HttpCalloutMock.class, new CaseTriggerForRPAIntegrationTestMock(mapMockResponse));
        
        Case c = [select Id from Case where Subject = 'Email Subject1' limit 1];
        System.assert(c!=null);
        
        Test.startTest();
        EmailToCaseHandler.uploadFile(String.valueOf(c.Id));
        Test.stopTest();
        
        c = [select Id, RPA_ORDER_AMOUNT__c from Case limit 1];
        system.debug('Order Amount in test class---'+c.RPA_ORDER_AMOUNT__c);
        System.assert(c.RPA_ORDER_AMOUNT__c == 3);
        //system.assert([SELECT Id, Account__r.Name From Order__c where OrderType__c = 'RPA'].Account__r.Name == 'RPA Dummy Account');
    }
    
     @isTest
    static void testRPAOrderCreation(){ // non dummy
        map<String, String> mapMockResponse = new map<String, String>();
        String nondummy = '{"schema":{"fields":[{"name":"index","type":"integer"},{"name":"FileName","type":"string"},{"name":"Label","type":"string"},{"name":"Value","type":"string"},{"name":"X1","type":"string"},{"name":"Y1","type":"string"},{"name":"X2","type":"string"},{"name":"Y2","type":"string"},{"name":"Confidence_Score_Header","type":"string"},{"name":"Category","type":"string"},{"name":"LineNumber","type":"string"},{"name":"PageNo","type":"string"}],"primaryKey":["index"],"pandas_version":"1.4.0"},"data":[{"index":0,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"PONUMBER","Value":"TX0775-23","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":1,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"PODate","Value":"8/31/2022","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":2,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Street","Value":"St. John Lutheran, 6950 Ward Road, office@stjohnnt.com","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":3,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_city","Value":"North Tonawanda","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":4,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_State","Value":"NY","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":5,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Zip","Value":"14120","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":6,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Country","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":7,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_Street","Value":"Erie 1 BOCES, 355 Harlem Road","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":8,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_city","Value":"West Seneca","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":9,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_State","Value":"NY","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":10,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_Zip","Value":"14224-1892","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":11,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_Country","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":12,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Contact","Value":"T. Licht","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":13,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_PhoneNum","Value":"716-693-9677","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":14,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Email","Value":"office@stjohnnt.com","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":15,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Institution_Name","Value":"Erie 1 BOCES","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":16,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Shipping_Institution_Name","Value":"St. John Lutheran","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":17,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Billing_Institution_Name","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":18,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"ISBN","Value":"9780768581416","X1":393,"Y1":1930,"X2":1331,"Y2":1956,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":19,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"QUANTITY","Value":"3.00","X1":106,"Y1":1930,"X2":169,"Y2":1956,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":20,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"UNITPRICE","Value":"28.0000","X1":1940,"Y1":1930,"X2":2059,"Y2":1956,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":21,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"AMOUNT","Value":"84.00","X1":2360,"Y1":1930,"X2":2440,"Y2":1956,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":22,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"QUANTITY","Value":"1.00","X1":110,"Y1":2008,"X2":169,"Y2":2033,"Confidence_Score_Header":"0","Category":"Table","LineNumber":2,"PageNo":1},{"index":23,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"UNITPRICE","Value":"0.0100","X1":1959,"Y1":2008,"X2":2059,"Y2":2033,"Confidence_Score_Header":"0","Category":"Table","LineNumber":2,"PageNo":1},{"index":24,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"AMOUNT","Value":"0.01","X1":2378,"Y1":2008,"X2":2437,"Y2":2033,"Confidence_Score_Header":"0","Category":"Table","LineNumber":2,"PageNo":1}]}';
        mapMockResponse.put('nondummy',nondummy);
        Test.setMock(HttpCalloutMock.class, new CaseTriggerForRPAIntegrationTestMock(mapMockResponse));
        
        Case c = [select Id from Case where Subject = 'Email Subject1' limit 1];
        System.assert(c!=null);
        
        Test.startTest();
        EmailToCaseHandler.uploadFile(String.valueOf(c.Id));
        Test.stopTest();
        
        Order__c objOrder = [SELECT Id, Account__r.Name, RPA_Ship_to_SAP_Account_Number__c, RPA_Bill_to_SAP_Account_Number__c, InvoiceToAddress__c, InvoiceToContact__c, Account__c, ShipToAddress__c, Order_Date__c From Order__c where OrderType__c = 'RPA'];
        system.debug('205 Order in test class---'+objOrder);
        system.assert(objOrder.RPA_Ship_to_SAP_Account_Number__c == '0002156407');
        system.assert(objOrder.RPA_Bill_to_SAP_Account_Number__c == '0002157046');

        // Order reconciliation test
        system.debug('269 Order in test class---'+objOrder.Account__r.Name);
        objOrder.Review_Complete__c = true;
        update objOrder;
    }

    @isTest
    static void testRPAOrderCreation1(){ // non dummy, contact name and date in diff format
        map<String, String> mapMockResponse = new map<String, String>();
        String nondummy = '{"schema":{"fields":[{"name":"index","type":"integer"},{"name":"FileName","type":"string"},{"name":"Label","type":"string"},{"name":"Value","type":"string"},{"name":"X1","type":"string"},{"name":"Y1","type":"string"},{"name":"X2","type":"string"},{"name":"Y2","type":"string"},{"name":"Confidence_Score_Header","type":"string"},{"name":"Category","type":"string"},{"name":"LineNumber","type":"string"},{"name":"PageNo","type":"string"}],"primaryKey":["index"],"pandas_version":"1.4.0"},"data":[{"index":0,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"PONUMBER","Value":"TX0775-23","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":1,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"PODate","Value":"2 September 2018","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":2,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Street","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":3,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_city","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":4,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_State","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":5,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Zip","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":6,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Country","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":7,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_Street","Value":"Erie 1 BOCES, 355 Harlem Road","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":8,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_city","Value":"West Seneca","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":9,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_State","Value":"NY","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":10,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_Zip","Value":"14224-1892","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":11,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Bill_to_Country","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":12,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Contact","Value":"Tom Licht","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":13,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_PhoneNum","Value":"716-693-9677","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":14,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Ship_to_Email","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":15,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Institution_Name","Value":"Erie 1 BOCES","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":16,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Shipping_Institution_Name","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":17,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"Billing_Institution_Name","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":18,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"ISBN","Value":"9780768581416","X1":393,"Y1":1930,"X2":1331,"Y2":1956,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":19,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"QUANTITY","Value":"3.00","X1":106,"Y1":1930,"X2":169,"Y2":1956,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":20,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"UNITPRICE","Value":"28,00","X1":1940,"Y1":1930,"X2":2059,"Y2":1956,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":21,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"AMOUNT","Value":"84.00","X1":2360,"Y1":1930,"X2":2440,"Y2":1956,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":22,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"QUANTITY","Value":"1.00","X1":110,"Y1":2008,"X2":169,"Y2":2033,"Confidence_Score_Header":"0","Category":"Table","LineNumber":2,"PageNo":1},{"index":23,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"UNITPRICE","Value":"0.0100","X1":1959,"Y1":2008,"X2":2059,"Y2":2033,"Confidence_Score_Header":"0","Category":"Table","LineNumber":2,"PageNo":1},{"index":24,"FileName":"0775-Savvas-St. John Lutheran.OCR.xml","Label":"AMOUNT","Value":"10,1","X1":2378,"Y1":2008,"X2":2437,"Y2":2033,"Confidence_Score_Header":"0","Category":"Table","LineNumber":2,"PageNo":1}]}';
        mapMockResponse.put('nondummy',nondummy);
        Test.setMock(HttpCalloutMock.class, new CaseTriggerForRPAIntegrationTestMock(mapMockResponse));
        
        Case c = [select Id from Case where Subject = 'Email Subject1' limit 1];
        System.assert(c!=null);
        
        Test.startTest();
        EmailToCaseHandler.uploadFile(String.valueOf(c.Id));
        Test.stopTest();
        
        /*Order__c objOrder = [SELECT Id, Account__r.Name, RPA_Ship_to_SAP_Account_Number__c, RPA_Bill_to_SAP_Account_Number__c, InvoiceToAddress__c, InvoiceToContact__c, Account__c, ShipToAddress__c, Order_Date__c From Order__c where OrderType__c = 'RPA'];
        system.debug('233 Order in test class---'+objOrder);
        system.debug('234 Order in test class---'+objOrder.Account__r.Name);

        System.assert([SELECT RPA_Recon_Status__c FROM Order__c WHERE Id =: objOrder.Id].RPA_Recon_Status__c == 'Success');*/
    }

    @isTest
    static void testRPAOrderCreation2(){ // dummy with multiple matches
        map<String, String> mapMockResponse = new map<String, String>();
        String dummy = '{"schema":{"fields":[{"name":"index","type":"integer"},{"name":"FileName","type":"string"},{"name":"Label","type":"string"},{"name":"Value","type":"string"},{"name":"X1","type":"string"},{"name":"Y1","type":"string"},{"name":"X2","type":"string"},{"name":"Y2","type":"string"},{"name":"Confidence_Score_Header","type":"string"},{"name":"Category","type":"string"},{"name":"LineNumber","type":"string"},{"name":"PageNo","type":"string"}],"primaryKey":["index"],"pandas_version":"1.4.0"},"data":[{"index":0,"FileName":"1048296.OCR.xml","Label":"PONUMBER","Value":"1048296","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":1,"FileName":"1048296.OCR.xml","Label":"PODate","Value":"7/1/2022","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":2,"FileName":"1048296.OCR.xml","Label":"Ship_to_Street","Value":"Torgerson, Shaena T, 7226 Spindlewood Drive","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":3,"FileName":"1048296.OCR.xml","Label":"Ship_to_city","Value":"Corona","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":4,"FileName":"1048296.OCR.xml","Label":"Ship_to_State","Value":"CA","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":5,"FileName":"1048296.OCR.xml","Label":"Ship_to_Zip","Value":"92880","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":6,"FileName":"1048296.OCR.xml","Label":"Ship_to_Country","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":7,"FileName":"1048296.OCR.xml","Label":"Bill_to_Street","Value":"PO Box 1387","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":8,"FileName":"1048296.OCR.xml","Label":"Bill_to_city","Value":"Placerville","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":9,"FileName":"1048296.OCR.xml","Label":"Bill_to_State","Value":"CA","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":10,"FileName":"1048296.OCR.xml","Label":"Bill_to_Zip","Value":"95667","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":11,"FileName":"1048296.OCR.xml","Label":"Bill_to_Country","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":12,"FileName":"1048296.OCR.xml","Label":"Ship_to_Contact","Value":"Shaena T","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":13,"FileName":"1048296.OCR.xml","Label":"Ship_to_PhoneNum","Value":"(530)295-3566","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":14,"FileName":"1048296.OCR.xml","Label":"Ship_to_Email","Value":"storgerson@ieminc.org","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":15,"FileName":"1048296.OCR.xml","Label":"Institution_Name","Value":"Sky Mountain Charter School","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":16,"FileName":"1048296.OCR.xml","Label":"Shipping_Institution_Name","Value":"Torgerson,","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":17,"FileName":"1048296.OCR.xml","Label":"Billing_Institution_Name","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":18,"FileName":"1048296.OCR.xml","Label":"QUANTITY","Value":"1","X1":129,"Y1":1127,"X2":138,"Y2":1151,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":19,"FileName":"1048296.OCR.xml","Label":"UNITPRICE","Value":"$29.00","X1":2092,"Y1":1124,"X2":2191,"Y2":1151,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":20,"FileName":"1048296.OCR.xml","Label":"AMOUNT","Value":"$29.00","X1":2325,"Y1":1124,"X2":2424,"Y2":1151,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":21,"FileName":"1048296.OCR.xml","Label":"ISBN","Value":"9780133339758","X1":348,"Y1":1127,"X2":586,"Y2":1151,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1}]}';
        mapMockResponse.put('dummy', dummy);
        Test.setMock(HttpCalloutMock.class, new CaseTriggerForRPAIntegrationTestMock(mapMockResponse));
        
        Case c = [select Id from Case where Subject = 'Email Subject1' limit 1];
        System.assert(c!=null);
        
        Test.startTest();
        EmailToCaseHandler.uploadFile(String.valueOf(c.Id));
        Test.stopTest();
        /*Order__c objOrder = [SELECT Id, Account__r.Name, RPA_Ship_to_SAP_Account_Number__c, RPA_Bill_to_SAP_Account_Number__c, InvoiceToAddress__c, InvoiceToContact__c, Account__c, ShipToAddress__c, Order_Date__c From Order__c where OrderType__c = 'RPA'];
        system.debug('246 Order in test class---'+objOrder);
        system.debug('234 Order in test class---'+objOrder.Account__r.Name);

        // Order reconciliation test
        objOrder.Review_Complete__c = true;
        update objOrder;

        System.assert([SELECT RPA_Recon_Status__c FROM Order__c WHERE Id =: objOrder.Id].RPA_Recon_Status__c == 'Success');*/
    }

    @isTest
    static void testRPAOrderCreation3(){ // non dummy with billing address match
        map<String, String> mapMockResponse = new map<String, String>();
        String nondummy = '{"schema":{"fields":[{"name":"index","type":"integer"},{"name":"FileName","type":"string"},{"name":"Label","type":"string"},{"name":"Value","type":"string"},{"name":"X1","type":"string"},{"name":"Y1","type":"string"},{"name":"X2","type":"string"},{"name":"Y2","type":"string"},{"name":"Confidence_Score_Header","type":"string"},{"name":"Category","type":"string"},{"name":"LineNumber","type":"string"},{"name":"PageNo","type":"string"}],"primaryKey":["index"],"pandas_version":"1.4.0"},"data":[{"index":0,"FileName":"0000021745_04500.OCR.xml","Label":"PONUMBER","Value":"21745","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":1,"FileName":"0000021745_04500.OCR.xml","Label":"PODate","Value":"11/17/2022","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":2,"FileName":"0000021745_04500.OCR.xml","Label":"Ship_to_Street","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":3,"FileName":"0000021745_04500.OCR.xml","Label":"Ship_to_city","Value":"ENCINITAS","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":4,"FileName":"0000021745_04500.OCR.xml","Label":"Ship_to_State","Value":"CA","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":5,"FileName":"0000021745_04500.OCR.xml","Label":"Ship_to_Zip","Value":"92024-1111","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":6,"FileName":"0000021745_04500.OCR.xml","Label":"Ship_to_Country","Value":"United States","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":7,"FileName":"0000021745_04500.OCR.xml","Label":"Bill_to_Street","Value":"0000000014, CANYON CREST HIGH SCHOOL, 5951 VILLAGE CENTER LOOP RD","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":8,"FileName":"0000021745_04500.OCR.xml","Label":"Bill_to_city","Value":"SAN DIEGO","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":9,"FileName":"0000021745_04500.OCR.xml","Label":"Bill_to_State","Value":"CA","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":10,"FileName":"0000021745_04500.OCR.xml","Label":"Bill_to_Zip","Value":"92130","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":11,"FileName":"0000021745_04500.OCR.xml","Label":"Bill_to_Country","Value":" United States","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":12,"FileName":"0000021745_04500.OCR.xml","Label":"Ship_to_Contact","Value":"Margy Lara","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":13,"FileName":"0000021745_04500.OCR.xml","Label":"Ship_to_PhoneNum","Value":"760/753-6491","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":14,"FileName":"0000021745_04500.OCR.xml","Label":"Ship_to_Email","Value":"margy.lara@sduhsd.net","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":15,"FileName":"0000021745_04500.OCR.xml","Label":"Institution_Name","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":16,"FileName":"0000021745_04500.OCR.xml","Label":"Shipping_Institution_Name","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":17,"FileName":"0000021745_04500.OCR.xml","Label":"Billing_Institution_Name","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":18,"FileName":"0000021745_04500.OCR.xml","Label":"ISBN","Value":"9781418391157","X1":314,"Y1":1179,"X2":2177,"Y2":1425,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":19,"FileName":"0000021745_04500.OCR.xml","Label":"QUANTITY","Value":"3.00EA","X1":1419,"Y1":1179,"X2":1540,"Y2":1200,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":20,"FileName":"0000021745_04500.OCR.xml","Label":"UNITPRICE","Value":"83.50","X1":1738,"Y1":1180,"X2":1830,"Y2":1200,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":21,"FileName":"0000021745_04500.OCR.xml","Label":"AMOUNT","Value":"250.50","X1":2062,"Y1":1179,"X2":2176,"Y2":1200,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1}]}';
        mapMockResponse.put('nondummy', nondummy);
        Test.setMock(HttpCalloutMock.class, new CaseTriggerForRPAIntegrationTestMock(mapMockResponse));
        
        Case c = [select Id from Case where Subject = 'Email Subject1' limit 1];
        System.assert(c!=null);
        
        Test.startTest();
        EmailToCaseHandler.uploadFile(String.valueOf(c.Id));
        Test.stopTest();
        
        c = [select Id, RPA_ORDER_AMOUNT__c from Case limit 1];
        system.debug('Order Amount in test class---'+c.RPA_ORDER_AMOUNT__c);
        System.assert(c.RPA_ORDER_AMOUNT__c == 3);
    }

    @isTest
    static void testRPAOrderCreation4(){ 
        map<String, String> mapMockResponse = new map<String, String>();
        String nondummy = '{"schema":{"fields":[{"name":"index","type":"integer"},{"name":"FileName","type":"string"},{"name":"Label","type":"string"},{"name":"Value","type":"string"},{"name":"X1","type":"string"},{"name":"Y1","type":"string"},{"name":"X2","type":"string"},{"name":"Y2","type":"string"},{"name":"Confidence_Score_Header","type":"string"},{"name":"Category","type":"string"},{"name":"LineNumber","type":"string"},{"name":"PageNo","type":"string"}],"primaryKey":["index"],"pandas_version":"1.4.0"},"data":[{"index":0,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"PONUMBER","Value":"2022062301","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":1,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"PODate","Value":"2 9 2022","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":2,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_Street","Value":"Avant Garde Academy Broward, 2025 McKinley St","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":3,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_city","Value":"Hollywood","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":4,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_State","Value":"FL","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":5,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_Zip","Value":"33020","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":6,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_Country","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":7,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Bill_to_Street","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":8,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Bill_to_city","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":9,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Bill_to_State","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":10,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Bill_to_Zip","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":11,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Bill_to_Country","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":12,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_Contact","Value":"no attention contact found","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":13,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_PhoneNum","Value":"7548166153","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":14,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_Email","Value":"businessmanager@agabroward.org","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":15,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Institution_Name","Value":"Avant Garde Academy Broward","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":16,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Shipping_Institution_Name","Value":"Avant Garde Academy Broward","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":17,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Billing_Institution_Name","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":18,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"ISBN","Value":"9780328896530","X1":154,"Y1":1623,"X2":1133,"Y2":1652,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":19,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"UNITPRICE","Value":"0.000","X1":1737,"Y1":1622,"X2":1846,"Y2":1652,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1}]}';
        mapMockResponse.put('nondummy', nondummy);
        Test.setMock(HttpCalloutMock.class, new CaseTriggerForRPAIntegrationTestMock(mapMockResponse));
        
        Case c = [select Id from Case where Subject = 'Email Subject1' limit 1];
        System.assert(c!=null);
        
        Test.startTest();
        EmailToCaseHandler.uploadFile(String.valueOf(c.Id));
        Test.stopTest();
        /*Order__c objOrder = [SELECT Id, Account__r.Name, RPA_Ship_to_SAP_Account_Number__c, RPA_Bill_to_SAP_Account_Number__c, InvoiceToAddress__c, InvoiceToContact__c, Account__c, ShipToAddress__c, Order_Date__c From Order__c where OrderType__c = 'RPA'];
        system.debug('246 Order in test class---'+objOrder);
        system.debug('234 Order in test class---'+objOrder.Account__r.Name);

        // Order reconciliation test
        objOrder.Review_Complete__c = true;
        update objOrder;

        System.assert([SELECT RPA_Recon_Status__c FROM Order__c WHERE Id =: objOrder.Id].RPA_Recon_Status__c == 'Success');*/
    }

    
    @isTest
    static void testRPAOrderCreation5(){ 
        map<String, String> mapMockResponse = new map<String, String>();
        String nondummy = '{"schema":{"fields":[{"name":"index","type":"integer"},{"name":"FileName","type":"string"},{"name":"Label","type":"string"},{"name":"Value","type":"string"},{"name":"X1","type":"string"},{"name":"Y1","type":"string"},{"name":"X2","type":"string"},{"name":"Y2","type":"string"},{"name":"Confidence_Score_Header","type":"string"},{"name":"Category","type":"string"},{"name":"LineNumber","type":"string"},{"name":"PageNo","type":"string"}],"primaryKey":["index"],"pandas_version":"1.4.0"},"data":[{"index":0,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"PONUMBER","Value":"2022062301","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":1,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"PODate","Value":"September 2, 2022","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":2,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_Street","Value":"McKinley St","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":3,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_city","Value":"Hollywood","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":4,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_State","Value":"FL","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":5,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_Zip","Value":"33020","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":6,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_Country","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":7,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Bill_to_Street","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":8,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Bill_to_city","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":9,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Bill_to_State","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":10,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Bill_to_Zip","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":11,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Bill_to_Country","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":12,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_Contact","Value":"no attention contact found","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":13,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_PhoneNum","Value":"7548166153","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":14,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Ship_to_Email","Value":"businessmanager@agabroward.org","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":15,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Institution_Name","Value":"Avant Garde Academy Broward","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":16,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Shipping_Institution_Name","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":17,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"Billing_Institution_Name","Value":"","X1":"0","Y1":":","X2":"0","Y2":":","Confidence_Score_Header":"-1","Category":"Header","LineNumber":"","PageNo":1},{"index":18,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"ISBN","Value":"9780328896530","X1":154,"Y1":1623,"X2":1133,"Y2":1652,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1},{"index":19,"FileName":"PO_2022062301 Savvas - 6-12 (1) (1).OCR.xml","Label":"UNITPRICE","Value":"10t","X1":1737,"Y1":1622,"X2":1846,"Y2":1652,"Confidence_Score_Header":"0","Category":"Table","LineNumber":1,"PageNo":1}]}';
        mapMockResponse.put('nondummy', nondummy);
        Test.setMock(HttpCalloutMock.class, new CaseTriggerForRPAIntegrationTestMock(mapMockResponse));
        
        Case c = [select Id from Case where Subject = 'Email Subject1' limit 1];
        System.assert(c!=null);
        
        Test.startTest();
        EmailToCaseHandler.uploadFile(String.valueOf(c.Id));
        Test.stopTest();
       // Order__c objOrder = [SELECT Id, Account__r.Name, RPA_Ship_to_SAP_Account_Number__c, RPA_Bill_to_SAP_Account_Number__c, InvoiceToAddress__c, InvoiceToContact__c, Account__c, ShipToAddress__c, Order_Date__c From Order__c where OrderType__c = 'RPA'];
        //system.debug('246 Order in test class---'+objOrder);
        //system.debug('234 Order in test class---'+objOrder.Account__r.Name);

        // Order reconciliation test
       // objOrder.Review_Complete__c = true;
        //update objOrder;

        //System.assert([SELECT RPA_Recon_Status__c FROM Order__c WHERE Id =: objOrder.Id].RPA_Recon_Status__c == 'Success');
    }

    @isTest
    static void testWrapperClassCoverage(){ // non dummy with billing address match
    
        OrderCreationJSONWrapper.Fields ocf = new OrderCreationJSONWrapper.Fields();
        ocf.name = 'FileName';
        ocf.type = 'string';
        list<OrderCreationJSONWrapper.Fields> lstOCF = new list<OrderCreationJSONWrapper.Fields>();
        lstOCF.add(ocf);

        list<String> primaryKey = new list<String>{'index'};

        OrderCreationJSONWrapper.Schema objSchema = new OrderCreationJSONWrapper.Schema();
        objSchema.fields = lstOCF;
        objSchema.primaryKey = primaryKey;
        objSchema.pandas_version = '1.4.0';

        OrderCreationJSONWrapper ojw = new OrderCreationJSONWrapper();
        ojw.schema = objSchema;

        OrderCreationJSONWrapper.Data objData = new OrderCreationJSONWrapper.Data();
        objData.index = 0;
        objData.FileName = '0000021745_04500.OCR.xml';
        objData.Label = 'PONUMBER';
        objData.Value = '21745';
        objData.X1 = '0';
        objData.Y1 = ':';
        objData.X2 = '0';
        objData.Y2 = ':';
        objData.Confidence_Score_Header = '-1';
        objData.Category = 'Header';
        objData.LineNumber = '';
        objData.PageNo = 1;

        list<OrderCreationJSONWrapper.Data> lstData = new list<OrderCreationJSONWrapper.Data>{objData};
        ojw.data = lstData;
    }

    @isTest
    static void testRPAAccountSearch(){
        RPAAccountSearch.searchAccountAddress('Canyon', '', '', '710 ENCINITAS BLVD', 'ENCINITAS', '92024', 'CA', '', '', '', '', null);
        RPAAccountSearch.searchAccountAddress('', '', 'Canyon', '', '', '', '', '710 ENCINITAS BLVD', 'ENCINITAS', '92024-1234', 'CA', null);
        RPAAccountSearch.searchAccountAddress('', 'Canyon', '', '710 ENCINITAS BLVD', 'ENCINITAS', '92024-1234', 'CA', '', '', '', '', null);
        RPAAccountSearch.searchAccountAddress('', 'School', 'Canyon', '710 ENCINITAS BLVD', 'ENCINITAS', '92024-1234', 'CA', '', '', '', '', null);
        RPAAccountSearch.searchAccountAddress('School', '', 'Canyon', '710 ENCINITAS BLVD', 'ENCINITAS', '92024-1234', 'CA', '', '', '', '', null);
        RPAAccountSearch.searchAccountAddress('School', 'Canyon', '', '710 ENCINITAS BLVD', 'ENCINITAS', '92024-1234', 'CA', '', '', '', '', null);
        RPAAccountSearch.searchAccountAddress('Canyon', '', '', '', '', '', '', '710 ENCINITAS BLVD', 'ENCINITAS', '92024-1234', 'CA', null);
        RPAAccountSearch.searchAccountAddress('', 'Canyon', '', '', '', '', '', '710 ENCINITAS BLVD', 'ENCINITAS', '92024-1234', 'CA', null);
        RPAAccountSearch.getMainWordFromName('Dcmo', '');
        RPAAccountSearch.getMainWordFromName('Immaculate Heart Ctl', '');
        //RPAAccountSearch.searchAccountAddress(accntName1, accntName2, accntName3, street, city, zip, state, billingStreet, billingCity, billingZip, billingState, accntIds)
    }
}