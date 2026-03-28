/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-10-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class testDocSearchClass {

        //@AuraEnabled(cacheable=true)
        @AuraEnabled
public static String getDocSearchByOptions(Boolean HomePage, Boolean isAdvanced, Boolean isInternal) {
    // Retrieve the current user information
    List<User> usr = [SELECT ID, Profile.Name, IsEmployee__c, Contact.AccountID, Contact.Account.SAP_Account_Id__c, contact.name, contact.Account.name 
                      FROM User WHERE Id = :UserInfo.getUserId()];

    // Initialize the query
    String query = 'SELECT MasterLabel, isGuest__c, Label__c, IsInternal__c, IsAdvanced_Search_Allowed__c, Is_Quick_Search_Allowed__c, IsExternal__c, Priority__c, IsActive__c ' +
                   'FROM scc_searchByOptionsDoc__mdt WHERE IsActive__c = true ';

    // Apply HomePage filter if needed
    if (HomePage) {
        query += ' AND IsHomepage__c = true ';
    }

    // Apply filters based on user type and isInternal flag
    if (usr[0].IsEmployee__c) {

    } else {
        // External users
        if (usr[0].Profile.Name == 'MySavvasOrders Profile') {
            query += ' AND isGuest__c = true ';
        } else if (usr[0].Profile.Name == 'Savvas External Users Base Profile') {
            query += ' AND IsExternal__c = true ';
        } else {
            // For any other external user profiles, if needed
            query += ' AND IsExternal__c = true ';
        }

        // Apply filters for quick and advanced searches for external users
        if (isAdvanced) {
            query += ' AND IsAdvanced_Search_Allowed__c = true ';
        } else {
            query += ' AND Is_Quick_Search_Allowed__c = true ';
        }
    }

    // Order the results
    query += ' ORDER BY Priority__c ASC NULLS LAST';

    // Debug output to verify the query
    System.debug('query is ' + query);

    // Execute the query and process the results
    List<scc_searchByOptionsDoc__mdt> scc_searchByOptionsData = Database.query(query);
    List<getSearchByOptionsWrapper> getSearchByOptionsWrap = new List<getSearchByOptionsWrapper>();
    for (scc_searchByOptionsDoc__mdt option : scc_searchByOptionsData) {
        getSearchByOptionsWrap.add(new getSearchByOptionsWrapper(option.Label__c, option.Label__c)); 
    }

    return JSON.serialize(getSearchByOptionsWrap);
}


@AuraEnabled
public static String getCriteriaDocdata(Map<String,String> docRequestData){
    system.debug('Received data is'+docRequestData);
    String SearchByvalue = docRequestData.get('SearchByvalue');
    String InvoNum = docRequestData.get('InvoNum');
    String PONum = docRequestData.get('PONum');
    String InvoiceStatus = docRequestData.get('InvoiceStatus');
    Boolean isAdvanced = Boolean.valueOf(docRequestData.get('isAdvanced'));
    Date startDate = Date.valueOf(docRequestData.get('startDate'));
    Date endDate = Date.valueOf(docRequestData.get('endDate'));

    Date invoiceDate1;
    set<getCriteriaDocwrapper> getCriteriaDocDataToSend = new set<getCriteriaDocwrapper>();
    User currentUser = [SELECT ID, Profile.Name, IsEmployee__c, Contact.AccountID, Contact.Account.SAP_Account_Id__c, contact.name, contact.Account.name FROM User WHERE id = :UserInfo.getUserID()];
    String query;

    if(SearchByvalue == 'Invoice' || SearchByvalue =='Invoice & Proof of Delivery (if available)' || SearchByvalue == 'Proof of Delivery (if available)'){
        query = 'SELECT Signature__c, SAP_Invoice_Id__r.Invoice_Amount__c,SAP_Invoice_Id__r.Invoice_Created_Date__c, SAP_Invoice_Id__r.Invoice_Number__c,SAP_Invoice_Id__r.Pay_Status__c, SAP_Invoice_Id__r.Order__r.Account_PO_Number__c,SAP_Invoice_Id__r.Order__r.AccountId,SAP_Invoice_Id__r.Order__r.SAP_Document_Number__c,SAP_Invoice_Id__r.Order__r.Order_Status_Code__c FROM SAP_Package__c WHERE ';
        
        if(!currentUser.IsEmployee__c && (currentUser.Profile.Name =='Savvas External Users Base Profile' || currentUser.Profile.Name =='Customer Community Login User')){      
            String userAccountId = currentUser.Contact.AccountID;
            query += ' SAP_Invoice_Id__r.Order__r.AccountId = :userAccountId AND ';
        }
        
        if(InvoNum !=null && InvoNum !=''){
             query += ' (SAP_Invoice_Id__r.Order__r.SAP_Document_Number__c=:InvoNum OR SAP_Invoice_Id__r.Invoice_Number__c=:InvoNum) ';
        }
        
        if(PONum !='' && PONum !=null && isAdvanced != false){
            query += ' AND SAP_Invoice_Id__r.Order__r.Account_PO_Number__c=:PONum ';
        }
        
        if(InvoiceStatus !='' && InvoiceStatus !=null && isAdvanced != false && InvoiceStatus !='All'){
            if(InvoiceStatus == 'Closed'){
                InvoiceStatus = 'FULLFILLED';
            }
            query += ' AND SAP_Invoice_Id__r.Order__r.Order_Status_Code__c=:InvoiceStatus ';
        }
        
        if(startDate !=null && isAdvanced != false){
            query += ' AND SAP_Invoice_Id__r.Invoice_Created_Date__c >=:startDate ';
        }
        
        if(endDate !=null && isAdvanced != false){
            query += ' AND SAP_Invoice_Id__r.Invoice_Created_Date__c <=:endDate ';
        }
        
        System.debug('query'+query);
        List<SAP_Package__c> InvoiceData = Database.query(query);
        System.debug('InvoiceData'+InvoiceData);
        
        for(SAP_Package__c inv:InvoiceData){
            getCriteriaDocwrapper doctoSend = new getCriteriaDocwrapper();
            doctoSend.invoice = String.isNotBlank(inv.SAP_Invoice_Id__r.Invoice_Number__c) ? inv.SAP_Invoice_Id__r.Invoice_Number__c : '';
            doctoSend.deliveryProof = String.isNotBlank(inv.Signature__c) ? inv.Signature__c : '';
            doctoSend.PO = String.isNotBlank(inv.SAP_Invoice_Id__r.Order__r.Account_PO_Number__c) ? inv.SAP_Invoice_Id__r.Order__r.Account_PO_Number__c : '';
            doctoSend.SAP_Document_Number = String.isNotBlank(inv.SAP_Invoice_Id__r.Order__r.SAP_Document_Number__c) ? inv.SAP_Invoice_Id__r.Order__r.SAP_Document_Number__c : '';
            if(inv.SAP_Invoice_Id__r.Invoice_Created_Date__c !=null){
                invoiceDate1 = inv.SAP_Invoice_Id__r.Invoice_Created_Date__c;
                doctoSend.invoiceDate = String.valueOf(invoiceDate1.month())+'/'+String.valueOf(invoiceDate1.day())+'/'+String.valueOf(invoiceDate1.year());
            }else{
                doctoSend.invoiceDate = '';
            }
            doctoSend.invoiceAmount = String.isNotBlank(inv.SAP_Invoice_Id__r.Invoice_Amount__c) ? inv.SAP_Invoice_Id__r.Invoice_Amount__c : '';
            doctoSend.payStatus = inv.SAP_Invoice_Id__r.Pay_Status__c;
            getCriteriaDocDataToSend.add(doctoSend);
        }
    }
    
    if(SearchByvalue == 'Credit Memo'){
        String orderType = 'ZCRC';
        query = 'SELECT Id, Invoice_Amount__c, Invoice_Created_Date__c,Invoice_Number__c,Order__r.AccountId,Order__r.PoNumber__c, Order__r.SAP_Document_Number__c,Order__r.SAP_Order_Type__c,Pay_Status__c FROM SAP_Invoice__c WHERE Order__r.SAP_Order_Type__c =:orderType ';
      
        if(!currentUser.IsEmployee__c && (currentUser.Profile.Name =='Savvas External Users Base Profile' || currentUser.Profile.Name =='Customer Community Login User')){      
            String userAccountId = currentUser.Contact.AccountID;
            query += ' AND Order__r.AccountId=:userAccountId '; 
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
    
    if(SearchByvalue == 'Debit Memo'){
        String orderType1 = 'ZDMR';
        query = 'SELECT Id, Invoice_Amount__c,Pay_Status__c,Invoice_Created_Date__c,Invoice_Number__c,Order__r.AccountId,Order__r.PoNumber__c, Order__r.SAP_Document_Number__c,Order__r.SAP_Order_Type__c FROM SAP_Invoice__c WHERE Order__r.SAP_Order_Type__c =:orderType1 ';
        
        if(!currentUser.IsEmployee__c && (currentUser.Profile.Name =='Savvas External Users Base Profile' || currentUser.Profile.Name =='Customer Community Login User')){      
            String userAccountId = currentUser.Contact.AccountID;
            query += ' AND Order__r.AccountId=:userAccountId '; 
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