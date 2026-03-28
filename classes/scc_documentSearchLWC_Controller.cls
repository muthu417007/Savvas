/*
Apex Class:scc_documentSearchLWC_Controller
Author: CTS (Vaibhav Saptal)
Created Date: 22/07/2024
Reason: Bakend logic document search LWC component.
Modified Date: 17/10/2024
*/
public with sharing class scc_documentSearchLWC_Controller {    
    /**
*  Description: This method queries search by options from custom metadata      
*  @name: getDocSearchByOptions
*  @param:No parameters
*  @return: String values of search by options
*  @throws exception- 
*/
    
    //@AuraEnabled(cacheable=true)
    @AuraEnabled
    public static String getDocSearchByOptions(Boolean HomePage, Boolean isAdvanced, Boolean isInternal) {
        try{
            List<User> usr = [SELECT ID, Profile.Name, IsEmployee__c, Contact.AccountID, Contact.Account.SAP_Account_Id__c, contact.name, contact.Account.name 
                              FROM User WHERE Id = :UserInfo.getUserId()];
            String query = 'SELECT MasterLabel, isGuest__c, Label__c, IsInternal__c, IsAdvanced_Search_Allowed__c, Is_Quick_Search_Allowed__c, IsExternal__c, Priority__c, IsActive__c ' +
                'FROM scc_searchByOptionsDoc__mdt WHERE IsActive__c = true ';
            
            if (HomePage) {
                query += ' AND IsHomepage__c = true ';
            }
            
            if (usr[0].IsEmployee__c) {
                
            } else {
                if (usr[0].Profile.Name == scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE) {
                    query += ' AND isGuest__c = true ';
                } else if (usr[0].Profile.Name == scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE) {
                    query += ' AND IsExternal__c = true ';
                } else {
                    query += ' AND IsExternal__c = true ';
                }
                if (isAdvanced) {
                    query += ' AND IsAdvanced_Search_Allowed__c = true ';
                } else {
                    query += ' AND Is_Quick_Search_Allowed__c = true ';
                }
            }
            query += ' ORDER BY Priority__c ASC NULLS LAST';
            System.debug('query is ' + query);
            
            List<scc_searchByOptionsDoc__mdt> scc_searchByOptionsData = Database.query(query);
            List<getSearchByOptionsWrapper> getSearchByOptionsWrap = new List<getSearchByOptionsWrapper>();
            for (scc_searchByOptionsDoc__mdt option : scc_searchByOptionsData) {
                getSearchByOptionsWrap.add(new getSearchByOptionsWrapper(option.Label__c, option.Label__c)); 
            }
            
            return JSON.serialize(getSearchByOptionsWrap);
            
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get document search options:'+e.getMessage()+e.getCause());
        }            
    }
    
    /**
*  Description: This method queries document details from SAP Package,SAP Invoice and Order based on different Criteria's     
*  @name: getCriteriaOrderdata
*  @param:Parameters like PO,Dates,Status,Document Number,Search by Values etc.
*  @return: String values of Document Details
*  @throws exception- When any issues while querying the data or assigning the data wrapper variables.
*/      
    @AuraEnabled
    public static String getCriteriaDocdata(Map<String,String> docRequestData){
        try{
            system.debug('Received data is'+docRequestData);
            String SearchByvalue = docRequestData.get('SearchByvalue');
            String InvoNum = docRequestData.get('InvoNum');
            String PONum = docRequestData.get('PONum');
            String InvoiceStatus = docRequestData.get('InvoiceStatus');
            Boolean isAdvanced = Boolean.valueOf(docRequestData.get('isAdvanced'));
            Date startDate = Date.valueOf(docRequestData.get('startDate'));
            Date endDate = Date.valueOf(docRequestData.get('endDate'));
            String SAP_ShipTo = docRequestData.get('SAP_ShipTo');
            String SAP_BillTo = docRequestData.get('SAP_BillTo');
            
            Date invoiceDate1;
            set<getCriteriaDocwrapper> getCriteriaDocDataToSend = new set<getCriteriaDocwrapper>();
            User currentUser = [SELECT Id, Profile.Name, IsEmployee__c, Contact.AccountID, Contact.Account.SAP_Account_Id__c, contact.name, contact.Account.name,contact.Account.AccountNumber FROM User WHERE id = :UserInfo.getUserID()];
            String query;
            
            if((SearchByvalue == scc_constantHelper.INVOICE) || (SearchByvalue ==scc_constantHelper.INVOICE_AND_POD) || (SearchByvalue == scc_constantHelper.POD)){
                query ='SELECT Invoice_Amount__c,Invoice_Created_Date__c, Invoice_Number__c,Pay_Status__c, Order__r.PoNumber__c,Order__r.AccountId,Order__r.SAP_Document_Number__c,Order__r.Order_Status_Code__c,Order__r.SAP_Shipto__c,Order__r.SAP_BillTo__c,Order__r.License_Partner__c,(select Signature__c from Savvas_Packages__r ';
                String na = 'NA';
                query += ' WHERE Signature__c !=:na) ';
                query += ' FROM SAP_Invoice__c WHERE ';
                
                if(!currentUser.IsEmployee__c && (currentUser.Profile.Name ==scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE || currentUser.Profile.Name ==scc_constantHelper.CUSTOMER_COMMUNITY_PLUS_LOGIN_USER)){      
                    String userAccountId = currentUser.Contact.AccountID;
                    String userAccountNumber =currentUser.Contact.Account.AccountNumber;// added by sudha
                    query += '(Order__r.AccountId = :userAccountId OR Order__r.License_Partner__c = :userAccountNumber) '; //ADDED BY SUDHA
                }else{
                    query += ' Order__r.SAP_Document_Number__c != null ';
                }
                
                if(InvoNum !=null && InvoNum !=''){
                    query += ' AND (Order__r.SAP_Document_Number__c=:InvoNum OR Invoice_Number__c=:InvoNum) ';
                }
                
                if(PONum !='' && PONum !=null && isAdvanced != false){
                    query += ' AND Order__r.PoNumber__c=:PONum ';
                }
                
                if(InvoiceStatus !='' && InvoiceStatus !=null && isAdvanced != false && InvoiceStatus !='All'){
                    if(InvoiceStatus == 'Closed'){
                        InvoiceStatus = 'FULLFILLED';
                    }
                    query += ' AND Order__r.Order_Status_Code__c=:InvoiceStatus ';
                }
                
                if(startDate !=null && isAdvanced != false){
                    query += ' AND Invoice_Created_Date__c >=:startDate ';
                }
                
                if(endDate !=null && isAdvanced != false){
                    query += ' AND Invoice_Created_Date__c <=:endDate ';
                }
                
                if(SAP_ShipTo !=null && SAP_ShipTo !=''){
                    query += ' AND Order__r.SAP_Shipto__c=:SAP_ShipTo ';
                    
                }
                
                if(SAP_BillTo !=null && SAP_BillTo !=''){
                    query += ' AND Order__r.SAP_BillTo__c=:SAP_BillTo ';
                }
                
                
                
                System.debug('query'+query);
                List<SAP_Invoice__c> InvoiceData = Database.query(query);
                System.debug('InvoiceData'+InvoiceData);
                
                for(SAP_Invoice__c inv:InvoiceData){
                    getCriteriaDocwrapper doctoSend = new getCriteriaDocwrapper();
                    doctoSend.invoice = String.isNotBlank(inv.Invoice_Number__c) ? inv.Invoice_Number__c : '';
                    doctoSend.deliveryProof = 'NA';
                    doctoSend.PO = String.isNotBlank(inv.Order__r.PoNumber__c) ? inv.Order__r.PoNumber__c : '';
                    doctoSend.SAP_Document_Number = String.isNotBlank(inv.Order__r.SAP_Document_Number__c) ? inv.Order__r.SAP_Document_Number__c : '';
                    if(inv.Invoice_Created_Date__c !=null){
                        invoiceDate1 = inv.Invoice_Created_Date__c;
                        doctoSend.invoiceDate = String.valueOf(invoiceDate1.month())+'/'+String.valueOf(invoiceDate1.day())+'/'+String.valueOf(invoiceDate1.year());
                    }else{
                        doctoSend.invoiceDate = '';
                    }
                    doctoSend.invoiceAmount = String.isNotBlank(inv.Invoice_Amount__c) ? inv.Invoice_Amount__c : '';
                    doctoSend.payStatus = inv.Pay_Status__c;
                    if(inv.Savvas_Packages__r.size() > 0){
                        for (Integer i=0;i< inv.Savvas_Packages__r.size();i++) {
                            String sign = String.isNotBlank(inv.Savvas_Packages__r[i].Signature__c) ? inv.Savvas_Packages__r[i].Signature__c:''; 
                            if(sign !='NA'){
                                doctoSend.deliveryProof = String.isNotBlank(inv.Savvas_Packages__r[i].Signature__c) ? inv.Savvas_Packages__r[i].Signature__c:''; 
                            }
                        }                    
                    }
                    getCriteriaDocDataToSend.add(doctoSend);
                }
            }
            
            if(SearchByvalue == scc_constantHelper.CREDIT_MEMO){
                String orderType = 'ZCRC';
                query = 'SELECT Id, Invoice_Amount__c, Invoice_Created_Date__c,Invoice_Number__c,Order__r.AccountId,Order__r.PoNumber__c, Order__r.SAP_Document_Number__c,Order__r.SAP_Order_Type__c,Pay_Status__c,Order__r.SAP_Shipto__c,Order__r.SAP_BillTo__c,Order__r.License_Partner__c FROM SAP_Invoice__c WHERE Order__r.SAP_Order_Type__c =:orderType ';
                
                if(!currentUser.IsEmployee__c && (currentUser.Profile.Name ==scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE || currentUser.Profile.Name ==scc_constantHelper.CUSTOMER_COMMUNITY_PLUS_LOGIN_USER)){      
                    String userAccountId = currentUser.Contact.AccountID;
                    String userAccountNumber =currentUser.Contact.Account.AccountNumber;// added by sudha
                    query += ' AND (Order__r.AccountId=:userAccountId OR Order__r.License_Partner__c=:userAccountNumber)'; 
                }
                
                if(InvoNum !=null && InvoNum !=''){
                    query += ' AND (Invoice_Number__c=:InvoNum OR Order__r.SAP_Document_Number__c=:InvoNum) ';
                }                
                
                if(PONum !='' && PONum !=null && isAdvanced != false){
                    query += ' AND Order__r.PoNumber__c=:PONum ';
                }
                
                if(startDate !=null && isAdvanced != false){
                    query += ' AND Invoice_Created_Date__c >=:startDate ';
                }
                
                if(endDate !=null && isAdvanced != false){
                    query += ' AND Invoice_Created_Date__c <=:endDate ';
                }
                
                if(SAP_ShipTo !=null && SAP_ShipTo !=''){
                    query += ' AND Order__r.SAP_Shipto__c=:SAP_ShipTo ';
                    
                }
                
                if(SAP_BillTo !=null && SAP_BillTo !=''){
                    query += ' AND Order__r.SAP_BillTo__c=:SAP_BillTo ';
                }
                
                System.debug('query'+query);
                List<SAP_Invoice__c> InvoiceDataCreditMemo = Database.query(query);                
                System.debug('InvoiceDataCreditMemo'+InvoiceDataCreditMemo);
                
                for(SAP_Invoice__c inv:InvoiceDataCreditMemo){
                    getCriteriaDocwrapper doctoSend1 = new getCriteriaDocwrapper();
                    doctoSend1.invoice = String.isNotBlank(inv.Invoice_Number__c) ? inv.Invoice_Number__c : '';
                    doctoSend1.deliveryProof = 'NA';
                    doctoSend1.PO = String.isNotBlank(inv.Order__r.PoNumber__c) ? inv.Order__r.PoNumber__c : '';
                    doctoSend1.SAP_Document_Number = String.isNotBlank(inv.Order__r.SAP_Document_Number__c) ? inv.Order__r.SAP_Document_Number__c : '';
                    if(inv.Invoice_Created_Date__c !=null){
                        invoiceDate1 = inv.Invoice_Created_Date__c;
                        doctoSend1.invoiceDate = String.valueOf(invoiceDate1.month())+'/'+String.valueOf(invoiceDate1.day())+'/'+String.valueOf(invoiceDate1.year());
                    }else{
                        doctoSend1.invoiceDate = '';
                    }
                    
                    doctoSend1.invoiceAmount = String.isNotBlank(inv.Invoice_Amount__c) ? inv.Invoice_Amount__c: '';
                    if(inv.Pay_Status__c !=null){
                        doctoSend1.payStatus = inv.Pay_Status__c;
                    }
                    getCriteriaDocDataToSend.add(doctoSend1);
                }
            }
            
            if(SearchByvalue == scc_constantHelper.DEBIT_MEMO){
                String orderType1 = 'ZDMR';
                query = 'SELECT Id, Invoice_Amount__c,Pay_Status__c,Invoice_Created_Date__c,Invoice_Number__c,Order__r.AccountId,Order__r.PoNumber__c, Order__r.SAP_Document_Number__c,Order__r.SAP_Order_Type__c,Order__r.SAP_Shipto__c,Order__r.SAP_BillTo__c,Order__r.License_Partner__c FROM SAP_Invoice__c WHERE Order__r.SAP_Order_Type__c =:orderType1 ';
                
                if(!currentUser.IsEmployee__c && (currentUser.Profile.Name ==scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE || currentUser.Profile.Name ==scc_constantHelper.CUSTOMER_COMMUNITY_PLUS_LOGIN_USER)){      
                    String userAccountId = currentUser.Contact.AccountID;
                    String userAccountNumber =currentUser.Contact.Account.AccountNumber;// added by sudha
                    query += ' AND (Order__r.AccountId=:userAccountId OR Order__r.License_Partner__c=:userAccountNumber)';
                }
                
                if(InvoNum !=null && InvoNum !=''){
                    query += ' AND (Invoice_Number__c=:InvoNum OR Order__r.SAP_Document_Number__c=:InvoNum) ';
                }
                
                if(PONum !='' && PONum !=null && isAdvanced != false){
                    query += ' AND Order__r.PoNumber__c=:PONum ';
                }
                
                if(startDate !=null && isAdvanced != false){
                    query += ' AND Invoice_Created_Date__c >=:startDate ';
                }
                
                if(endDate !=null && isAdvanced != false){
                    query += ' AND Invoice_Created_Date__c <=:endDate ';
                }   
                
                if(SAP_ShipTo !=null && SAP_ShipTo !=''){
                    query += ' AND Order__r.SAP_Shipto__c=:SAP_ShipTo ';
                    
                }
                
                if(SAP_BillTo !=null && SAP_BillTo !=''){
                    query += ' AND Order__r.SAP_BillTo__c=:SAP_BillTo ';
                }
                
                System.debug('query'+query);
                List<SAP_Invoice__c> InvoiceDataDebitMemo = Database.query(query); 
                System.debug('InvoiceDataDebitMemo'+InvoiceDataDebitMemo);
                
                for(SAP_Invoice__c inv:InvoiceDataDebitMemo){
                    getCriteriaDocwrapper doctoSend2 = new getCriteriaDocwrapper();
                    doctoSend2.invoice = String.isNotBlank(inv.Invoice_Number__c) ? inv.Invoice_Number__c : '';
                    doctoSend2.deliveryProof = 'NA';
                    doctoSend2.PO = String.isNotBlank(inv.Order__r.PoNumber__c) ? inv.Order__r.PoNumber__c : '';
                    doctoSend2.SAP_Document_Number = String.isNotBlank(inv.Order__r.SAP_Document_Number__c) ? inv.Order__r.SAP_Document_Number__c : '';
                    if(inv.Invoice_Created_Date__c !=null){
                        invoiceDate1 = inv.Invoice_Created_Date__c;
                        doctoSend2.invoiceDate = String.valueOf(invoiceDate1.month())+'/'+String.valueOf(invoiceDate1.day())+'/'+String.valueOf(invoiceDate1.year());
                    }else{
                        doctoSend2.invoiceDate = '';
                    }
                    
                    doctoSend2.invoiceAmount = String.isNotBlank(inv.Invoice_Amount__c) ? inv.Invoice_Amount__c: '';
                    if(inv.Pay_Status__c !=null){
                        doctoSend2.payStatus = inv.Pay_Status__c;
                    }
                    getCriteriaDocDataToSend.add(doctoSend2);
                }            
            } 
            return JSON.serialize(getCriteriaDocDataToSend); 
            
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            return '';
        }
    }
    
    //wrapper class for search by options 
    public class getSearchByOptionsWrapper{
        public String label;
        public String value;
        getSearchByOptionsWrapper(String label,String value){
            this.label = label;
            this.value = value;
        }
        
    }
    
    public class getCriteriaDocwrapper{
        @AuraEnabled public String invoice;
        @AuraEnabled public String deliveryProof;
        @AuraEnabled public String PO;
        @AuraEnabled public String SAP_Document_Number;
        @AuraEnabled public String invoiceDate;
        @AuraEnabled public String invoiceAmount;
        @AuraEnabled public Boolean payStatus;    
    }
    
}