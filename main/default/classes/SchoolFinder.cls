/*
@Author : Cognizant Team
@name : SchoolFinder
@CreateDate : 09-Dec-2022
@Description This class gets called on the landing page of Savvas Learning Portal. 
*/
@RestResource(urlMapping='/schoolFinder/*')
global class SchoolFinder {
    /*
@Author : Cognizant Team
@name : fetchSchoolOptions
@Description : Method to return school details based on BillingPostalCode or BillingCity or BillingState or County__c
*/   
    @HttpPost
    global static void fetchSchoolOptions() {
        List<schoolDetails> schoolDetailsList = new List<schoolDetails>();
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        try{
            APIRequestBody requestDetails = (APIRequestBody)JSON.deserialize(requestBody, APIRequestBody.class);
            if(requestDetails!=null){
                String zipCode = requestDetails.zipCode;
                zipCode = zipCode.trim();
                String emailId = requestDetails.email;
                Boolean isEmailAvailable = requestDetails.isEmailAvailable;
                RestResponse response = RestContext.response;
                response.addHeader('Access-Control-Allow-Origin', Label.Sitecore_URL_to_whitelist);
                response.addHeader('Access-Control-Allow-Header', 'Origin,X-Requested-With,Content-Type,Accept');
                List<Contact> contactList=new List<contact>();
                if(String.isNotBlank(emailId)){
                    String query = 'SELECT Id,FirstName,LastName,Email,AccountId FROM Contact WHERE Email =:emailId LIMIT 1';
                    contactList = Database.query(query);
                }
                if(isEmailAvailable || !isEmailAvailable){
                    if(zipCode.length() >= 0) {
                        Map<String, Savvas_Sample_Resources_Account_Type__c> accountType = Savvas_Sample_Resources_Account_Type__c.getAll();
                        List<String> accountTypes = new List<String>();
                        if(!accountType.isEmpty()){
                            for(Savvas_Sample_Resources_Account_Type__c actType : accountType.values()){
                                accountTypes.add(actType.Type__c.removeStart('\'').removeEnd('\''));
                            }
                        }
                        String accountTypeString = String.join(accountTypes, ','); 
                        String varAccountStatus = 'Active';
                        String varUnitedStates = 'United States';
                        String varCanada = 'Canada';
                        String query = 'SELECT Id,Name,MDR_PID__c,Account_Owner_Display__c,Website,Phone,OwnerId,Owner.Phone,Owner.Email,Owner.Title,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,BillingLatitude,BillingLongitude,BillingGeocodeAccuracy,BillingAddress,County__c FROM Account WHERE (BillingCountry=: varUnitedStates OR BillingCountry=: varCanada) AND MDR_PID__c!=NULL AND Account_Status__c=:varAccountStatus AND Type IN:';
                        query+= 'accountTypes AND ';
                        String zipDetails = zipCode.containsWhitespace()?zipCode.deleteWhitespace():zipCode;
                        zipDetails = zipDetails.contains('-')?zipDetails.replaceAll('-', ''):zipDetails;
                        if(zipDetails.isNumeric()){
                            zipCode =  zipCode + '%';
                            query+=' BillingPostalCode LIKE: zipCode Order by Name asc LIMIT 50000';
                        }
                        else{
                            zipCode = zipCode+'%';
                            query+=' (BillingPostalCode LIKE: zipCode ';
                            query+= ' OR BillingCity LIKE: zipCode )  Order by Name asc LIMIT 50000';
                        }
                        List<Account> lstAccount = Database.query(query);
                        for(Account eachAccount : lstAccount){
                            schoolDetails newSchoolDetail = new schoolDetails();
                            newSchoolDetail.schoolName = eachAccount.Name;
                            newSchoolDetail.schoolRep = eachAccount.Account_Owner_Display__c;
                            newSchoolDetail.schoolRepId = eachAccount.OwnerId;
                            newSchoolDetail.schoolRepTitle = eachAccount.Owner.Title;
                            newSchoolDetail.schoolRepPhone = eachAccount.Owner.phone;
                            newSchoolDetail.schoolRepEmail = eachAccount.Owner.Email;
                            newSchoolDetail.schoolRepWebsite = eachAccount.Website;
                            newSchoolDetail.street = eachAccount.BillingStreet;
                            newSchoolDetail.city = eachAccount.BillingCity;
                            newSchoolDetail.state = eachAccount.BillingState;
                            newSchoolDetail.postalCode = eachAccount.BillingPostalCode;
                            newSchoolDetail.country =  eachAccount.BillingCountry;
                            newSchoolDetail.county = eachAccount.County__c;
                            newSchoolDetail.mdrpid = eachAccount.MDR_PID__c;
                            if(!contactList.isEmpty()){
                                newSchoolDetail.isValidContact = true;
                            }
                            else{
                                newSchoolDetail.isValidContact = false;
                            }
                            schoolDetailsList.add(newSchoolDetail);
                        }
                        if(!schoolDetailsList.isEmpty()){
                            response.responseBody = Blob.valueOf(JSON.serialize(schoolDetailsList));
                            response.statusCode = 200;
                        }
                        else{
                            response.responseBody = Blob.valueOf(JSON.serialize('No Data Found'));
                            response.statusCode = 200;
                        }
                    } 
                    else {
                        response.responseBody= Blob.valueOf('more than 0 digits required...');
                        response.statusCode = 400;
                    }
                }
                else{
                    response.responseBody = Blob.valueOf(JSON.serialize('No Data Found'));
                    response.statusCode = 200;
                }
                if(Boolean.valueOf(Label.Savvas_Insert_Logs)){
                    Integration_Logs__c integrationLog = new Integration_Logs__c(Type__c='School Finder',Request_Body__c =requestBody,Response_Body__c = (response.responseBody).toString().length()>1000?((response.responseBody).toString()).subString(0,1000):(response.responseBody).toString(),Status__c = 'Success');
                    Insert integrationLog;
                }
            }
        }
        catch(Exception e){
            RestResponse response = RestContext.response;
            response.responseBody = Blob.valueOf(JSON.serialize('Some error occuried '+e.getMessage()));
            if(Boolean.valueOf(Label.Savvas_Insert_Logs)){
                Integration_Logs__c integrationLog = new Integration_Logs__c(Type__c='School Finder',Request_Body__c =requestBody,Response_Body__c = JSON.serialize(response.responseBody),Status__c = 'Error');
                Insert integrationLog;
            }
        }
    }
    Public class schoolDetails{
        Public String schoolName{get;set;}
        Public Boolean isValidContact{get;set;}
        Public string schoolRep{get;set;}
        Public string schoolRepId{get;set;}
        Public string schoolRepTitle{get;set;}
        Public string schoolRepPhone{get;set;}
        Public string schoolRepEmail{get;set;}
        Public string schoolRepWebsite{get;set;}
        Public String street{get;set;}
        Public String city{get;set;}
        Public String state{get;set;}
        Public String postalCode{get;set;}
        Public String country{get;set;}
        Public String county{get;set;}
        Public string mdrpid{get;set;}
    }
    class APIRequestBody{
        String zipCode{get;set;}
        String email{get;set;}
        Boolean isEmailAvailable{get;set;}
    }
}