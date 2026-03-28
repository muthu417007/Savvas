/************************************************************************ 
Name: RPAJSONParser
Purpose: W-012203 - Parse the response from ML's Order creation(/DataExtraction) API.
History:
VERSION AUTHOR DATE       DETAIL                DESCRIPITOPN
1.0     CTS    			  INITIAL DEVELOPMENT   Methods to parse the JSON, search Account and Contact based on the parsed data and create Order
************************************************************************/
public class RPAJSONParser {

    public static String shipAccName  = '';
    public static String billAccName  = '';
    public static String accName  = '';
    
/******************************************************************************** 
* Description: Extracts the Order details from JSON returned by ML /DataExtraction API
*********************************************************************************/
    public static void parseOrderJSON(String orderJSON, String caseId)
    {
        OrderCreationJSONWrapper ocjw = (OrderCreationJSONWrapper)JSON.deserialize(orderJSON, OrderCreationJSONWrapper.class);
        if(String.isBlank(ocjw.DocType)){
            map<String, RPA_Response_JSON_Field_Mapping__mdt> mapEd = RPA_Response_JSON_Field_Mapping__mdt.getAll();
            map<String, String> mapOrderFields = new map<String, String>();
            map<String, String> mapOliFields = new map<String, String>();
            RPA_Response_JSON_Field_Mapping__mdt objRJFM;
            
            for(String nameEmailDomain : mapEd.keySet()){
                objRJFM = mapEd.get(nameEmailDomain);
                if(objRJFM.Entity__c == 'Order'){
                    mapOrderFields.put(objRJFM.SF_Field_Name__c, objRJFM.JSON_Field_Name__c);
                }
                if(objRJFM.Entity__c == 'Order Line Item'){
                    mapOliFields.put(objRJFM.SF_Field_Name__c, objRJFM.JSON_Field_Name__c);
                }
            }
            map<String, OrderLineItemWrapper> mapLineNoToOLI = new map<String, OrderLineItemWrapper>();
            OrderWrapper ow = new OrderWrapper();
            OrderLineItemWrapper oliw;
            for(OrderCreationJSONWrapper.Data objData : ocjw.data){
                // for Order
                if(objData.LineNumber == ''){
                    if(objData.Label == mapOrderFields.get('Contact')){
                        ow.contact = objData.Value != 'no attention contact found'?objData.Value:'';
                    }
                    if(objData.Label == mapOrderFields.get('Email')){
                        Boolean isValidEmail = validateEmail(objData.Value);
                        ow.email = isValidEmail?objData.Value:null;
                    }
                    if(objData.Label == mapOrderFields.get('Phone')){
                        ow.phone = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Account')){
                        ow.account = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Shipping Account')){
                        ow.shipAccName = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Billing Account')){
                        ow.billAccName = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Billing city')){
                        ow.billToCity = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Billing Country')){
                        ow.billToCountry = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Billing State')){
                        ow.billToState = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Billing Street')){
                        ow.billToStreet = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Billing Zip')){
                        ow.billToZip = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Shipping city')){
                        ow.shipToCity = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Shipping Country')){
                        ow.shipToCountry = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Shipping State')){
                        ow.shipToState = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Shipping Street')){
                        ow.shipToStreet = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('Shipping Zip')){
                        ow.shipToZip = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('PONUMBER')){
                        ow.ponumber = objData.Value;
                    }
                    if(objData.Label == mapOrderFields.get('PODate')){
                        ow.podate = objData.Value;
                    }
                }
                else {
                    if(mapLineNoToOLI.containsKey(objData.PageNo+'-'+objData.LineNumber)){
                        oliw = mapLineNoToOLI.get(objData.PageNo+'-'+objData.LineNumber);
                        oliw = getOLIFromJSON(objData, mapOliFields, oliw);
                        mapLineNoToOLI.put(objData.PageNo+'-'+objData.LineNumber, oliw);
                    }
                    else {
                        oliw = new OrderLineItemWrapper();
                        oliw.lineNum = objData.LineNumber;
                        oliw = getOLIFromJSON(objData, mapOliFields, oliw);
                        mapLineNoToOLI.put(objData.PageNo+'-'+objData.LineNumber, oliw);
                    }
                }
            }
            try{
                map<String, OrderLineItemWrapper> mapTemp = new map<String, OrderLineItemWrapper>();
                for(OrderLineItemWrapper oli : mapLineNoToOLI.values()){
                    mapTemp.put(oli.isbn+'_'+oli.quantity+'_'+oli.price, oli);
                }
                createOrder(caseId, ow, mapTemp);
            }
            catch(Exception ex){
                system.debug('Exception---->'+ex.getMessage()+'--get line number---'+ex.getLineNumber());
            }
        }
    }
    
/******************************************************************************** 
* Description: Extracts the Order Line Item details from JSON returned by ML /DataExtraction API
*********************************************************************************/
    private static OrderLineItemWrapper getOLIFromJSON(OrderCreationJSONWrapper.Data objData, map<String, String> mapOliFields, OrderLineItemWrapper objOLI){
        if(objData.Label == mapOliFields.get('Quantity')){
            objOLI.quantity = objData.Value;
        }
        if(objData.Label == mapOliFields.get('Price')){
            if(objData.Value.indexOf(',') > 0)
                objOLI.price = removeComma(objData.Value);
            else
                objOLI.price = objData.Value;
        }
        if(objData.Label == mapOliFields.get('ISBN')){
            objOLI.isbn = objData.Value;
        }
        if(objData.Label == mapOliFields.get('Unit of Measure')){
            objOLI.unitOfMeasure = objData.Value;
        }
        if(objData.Label == mapOliFields.get('Amount')){
            if(objData.Value.indexOf(',') > 0)
                objOLI.amount = removeComma(objData.Value);
            else
                objOLI.amount = objData.Value;
        }
        if(objData.Label == mapOliFields.get('Description')){
            objOLI.description = objData.Value;
        }
        return objOLI;           
    }
    
/******************************************************************************** 
* Description: Creates Order in SF using the parsed details.
*********************************************************************************/
    private static void createOrder(String caseId, OrderWrapper ow, map<String, OrderLineItemWrapper> mapLineNoToOLI){
        
        String accId = '';
        String shipAddId = '';
        String billAddId = ''; 
        String accAddIds = ''; //comma separated account address ids
        
        list<OrderLineItem__c> oliList = new list<OrderLineItem__c>();
        map<String, RPAAccountSearch.AddressMatchWrapper> mapAccIdToAccAddWrapper = new map<String, RPAAccountSearch.AddressMatchWrapper>();
        mapAccIdToAccAddWrapper = findAccount(ow);
        RPAAccountSearch.AddressMatchWrapper amw = new RPAAccountSearch.AddressMatchWrapper();
        // if there is only one account found, associate it to Order
        if(mapAccIdToAccAddWrapper.size() == 1){
            for(String strAccId : mapAccIdToAccAddWrapper.keyset()){
                amw = new RPAAccountSearch.AddressMatchWrapper();
                accId = strAccId;
                amw = mapAccIdToAccAddWrapper.get(strAccId);
                if(amw != null){
                    if(amw.shipOrBill == 'ship'){
                        shipAddId = amw.accAddId;
                    }
                    else {
                        billAddId = amw.accAddId;
                    }
                }
            }
        }
        else if(mapAccIdToAccAddWrapper.size() > 1){
            for(String strAccId : mapAccIdToAccAddWrapper.keyset()){
                //if there is no matching account address but still there are matching accounts with name
                if(mapAccIdToAccAddWrapper.get(strAccId) == null){
                    accAddIds += strAccId + ',';
                }
                else{
                    accAddIds += mapAccIdToAccAddWrapper.get(strAccId).accAddId +',';
                }
            }
            //Get RPA dummy account
            //Associate Order to dummy account
            accId = getRPADummyAccount().Id;
        }
        else if(mapAccIdToAccAddWrapper.size() == 0){
            //Get RPA dummy account
            //Associate Order to dummy account
            accId = getRPADummyAccount().Id;
        }
        ContactWrapper conWrap = new ContactWrapper();
        conWrap = findContact(mapAccIdToAccAddWrapper.keyset(), ow);
        mapAccIdToAccAddWrapper = new map<String, RPAAccountSearch.AddressMatchWrapper>();
        if(amw != null && amw.shipOrBill == 'ship' && String.isBlank(billAddId) && String.isNotBlank(ow.billToCity) && String.isNotBlank(ow.billToState) && String.isNotBlank(ow.billToZip))
        {
            //search for billing address
            mapAccIdToAccAddWrapper = RPAAccountSearch.searchAccountAddress(billAccName, String.isBlank(billAccName)?shipAccName:'', accName, '', '', '', '', ow.billToStreet, ow.billToCity, ow.billToZip, ow.billToState, null);
            if(mapAccIdToAccAddWrapper.size() > 0){
                billAddId = mapAccIdToAccAddWrapper.values()[0].accAddId;
            }
            else{
                String an1 = accName.split(' ')[0]+'%';
                mapAccIdToAccAddWrapper = RPAAccountSearch.searchAccountAddress(an1, '', '', '', '', '', '', ow.billToStreet, ow.billToCity, ow.billToZip, ow.billToState, null);
                if(mapAccIdToAccAddWrapper.size() > 0){
                    billAddId = mapAccIdToAccAddWrapper.values()[0].accAddId;
                }
            }
        }
        else if(amw != null && amw.shipOrBill == 'bill' && String.isBlank(shipAddId) && String.isNotBlank(ow.shipToCity) && String.isNotBlank(ow.shipToZip) && String.isNotBlank(ow.shipToState))
        {
            //search for shipping address
            mapAccIdToAccAddWrapper = RPAAccountSearch.searchAccountAddress(shipAccName, billAccName, accName, ow.shipToStreet, ow.shipToCity, ow.shipToZip, ow.shipToState, '', '', '', '', null);
            if(mapAccIdToAccAddWrapper.size() > 0){
                shipAddId = mapAccIdToAccAddWrapper.values()[0].accAddId;
            }
            else {
                String an2 = accName.split(' ')[0]+'%';
                mapAccIdToAccAddWrapper = RPAAccountSearch.searchAccountAddress(an2, '', '', ow.shipToStreet, ow.shipToCity, ow.shipToZip, ow.shipToState, '', '', '', '', null);
                if(mapAccIdToAccAddWrapper.size() > 0){
                    shipAddId = mapAccIdToAccAddWrapper.values()[0].accAddId;
                }
            }
        }
        Order__c objOrder = new Order__c(
            ShipToContact__c = conWrap.contype == 'ship'?conWrap.conId:null,
            InvoiceToContact__c = conWrap.contype == 'bill'?conWrap.conId:null,
            DeliverToContact__c = conWrap.contype == 'other'?conWrap.conId:null,
            OrderType__c = 'RPA',
            Account__c = accId,
            ShipConfirmationEmail__c = ow.email,
            Case__c = caseId,
            ShipToAddress__c = String.isBlank(shipAddId)?null:shipAddId,
            DeliverToAddress__c = String.isBlank(shipAddId)?null:shipAddId,
            InvoiceToAddress__c = String.isBlank(billAddId)?null:billAddId,
            PONumber__c = ow.ponumber,
            Order_Date__c = String.isNotBlank(ow.podate)?getValidDate(ow.podate):null,
            RPA_Phone__c = ow.phone.equalsIgnoreCase('no phone number found')?null:ow.phone,
            Contact_Name__c = ow.contact,
            Institution_Name__c = ow.account,
            Ship_to_Street__c = ow.shipToStreet,
            Ship_to_City__c = ow.shipToCity,
            Ship_to_State__c = ow.shipToState,
            Ship_to_Zip__c = ow.shipToZip,
            Ship_to_Country__c = ow.shipToCountry,
            Bill_to_Street__c = ow.billToStreet,
            Bill_to_City__c = ow.billToCity,
            Bill_to_State__c = ow.billToState,
            Bill_to_Country__c = ow.billToCountry,
            Bill_to_Zip__c = ow.billToZip,
            Ship_to_Phone__c = ow.phone,
            Account_Address_Ids__c = accAddIds,
            OrderSource__c = 'rpa'
        );
        insert objOrder;
        
        OrderLineItem__c oli;
        
        for(OrderLineItemWrapper oliw : mapLineNoToOLI.values()){
            // do not create oli when there is no isbn
            if(String.isNotBlank(oliw.isbn)){
                if(String.isBlank(oliw.quantity) && String.isBlank(oliw.price)) continue;
                else if(String.isNotBlank(oliw.quantity) && oliw.quantity.isAlpha() && oliw.quantity.isAlphaSpace()) continue;
                else{
                    Decimal price = 0.0;
                    oli = new OrderLineItem__c();
                    oli.Order__c = objOrder.Id;
                    oli.ItemDescription__c = oliw.description;
                    
                    if(String.isNotBlank(oliw.price)&&!oliw.price.isAlpha()&&!oliw.price.isAlphaSpace()){
                        price = Double.valueOf(getDecimalFromString(oliw.price));
                    }
                    if(price.setScale(2) == 0.00){
                        oli.Free_Item_Quantity__c = (String.isNotBlank(oliw.quantity)&&!oliw.quantity.isAlpha()&&!oliw.quantity.isAlphaSpace())?Double.valueOf(getDecimalFromString(oliw.quantity)):null; 
                    }
                    else{
                        oli.ItemQuantity__c = (String.isNotBlank(oliw.quantity)&&!oliw.quantity.isAlpha()&&!oliw.quantity.isAlphaSpace())?Double.valueOf(getDecimalFromString(oliw.quantity)):null;
                    }  
                    oli.UnitOfMeasure__c = oliw.unitOfMeasure;
                    oli.Price__c = price;
                    oli.Ordered_Item__c = getValidISBN(oliw.isbn);
                    oli.LineNo__c = String.isNotBlank(oliw.lineNum)?Integer.valueOf(oliw.lineNum):null;            
                    oliList.add(oli);
                }  
            }
        }
        // add try/catch
        insert oliList;
    }
/******************************************************************************** 
* Description: Searches for the matching Account details in SF that matches the institution name and address detail sent by ML.
*********************************************************************************/
    private static map<String, RPAAccountSearch.AddressMatchWrapper> findAccount(OrderWrapper ow)
    {        
        map<String, RPAAccountSearch.AddressMatchWrapper> mapAccIdToAccAddWrapper = new map<String, RPAAccountSearch.AddressMatchWrapper>();
        mapAccIdToAccAddWrapper = RPAAccountSearch.searchAccount(ow);
        return mapAccIdToAccAddWrapper;
    }
/******************************************************************************** 
* Description: Searches for the matching Contact details in SF that matches the contact name under the institution name sent by ML API.
*********************************************************************************/
    private static ContactWrapper findContact(set<String> accIds, OrderWrapper ow){
        
        String conNameToSearch = '';
        String conNameToSearch1 = '';
        String conName1 = '';
        String fname = '';
        String name = ow.contact;
        String email = ow.email;
        list<Contact> conList = new list<Contact>();
        ContactWrapper conWrap = new ContactWrapper();
        shipAccName  = RPAAccountSearch.getMainWordFromName(ow.shipAccName, ow.contact);
        billAccName  = RPAAccountSearch.getMainWordFromName(ow.billAccName, ow.contact);
        accName  = RPAAccountSearch.getMainWordFromName(ow.account, ow.contact);
        
        if(String.isNotBlank(email)){
            conList = [SELECT Id, AccountId, Account.Name, email FROM Contact WHERE email != null AND email =: email LIMIT 100];
        }
        if(conList.size() > 0){
            for(Contact con : conList){
                if(String.isNotBlank(shipAccName) && compareStrings(con.Account.Name, shipAccName)){
                    conWrap.conId = con.Id;
                    conWrap.contype = 'ship';
                    return conWrap;
                }
                else if(String.isNotBlank(billAccName) && compareStrings(con.Account.Name, billAccName)){
                    conWrap.conId = con.Id;
                    conWrap.contype = 'bill';
                    return conWrap;
                }
                else if(String.isNotBlank(accName) && compareStrings(con.Account.Name, accName)){
                    conWrap.conId = con.Id;
                    conWrap.contype = 'other';
                    return conWrap;
                }
            }
        }
        if(String.isNotBlank(name)){
            name = name.replaceAll('[^a-zA-Z\\s+]', '');
            String[] nameArray = name.split(' ');
            if(nameArray.size() == 1)
                conNameToSearch = '%'+nameArray[0].trim()+'%';
            if(nameArray.size() >= 2){
                fname = nameArray[0].trim().removeend('.');
                if(nameArray[0].trim().length() <=2 ){
                    conNameToSearch = '%'+nameArray[1].trim()+'%';
                }
                else{
                    conNameToSearch = nameArray[1].trim()+' '+nameArray[0].trim()+'%';
                    conName1 = '%'+nameArray[1].trim()+'%';
                    conNameToSearch1 = nameArray[0].trim()+' '+nameArray[1].trim()+'%';
                }
            }
            
            String query = 'SELECT Id, AccountId, Account.Name, email FROM Contact WHERE (AccountId IN: accIds OR Account.ParentId IN: accIds) ';
            if(String.isNotBlank(conNameToSearch) && String.isNotBlank(conNameToSearch1)){
                query += 'AND (Name like : conNameToSearch OR Name like : conNameToSearch1) ';
            }
            else if(String.isNotBlank(conNameToSearch) && String.isBlank(conNameToSearch1)){
                query += 'AND Name like : conNameToSearch ';
            }
            else if(String.isNotBlank(conNameToSearch1) && String.isBlank(conNameToSearch)){
                query += 'AND Name like : conNameToSearch1 ';
            }
            query += 'LIMIT 100';
            conList = Database.query(query);
            if(conList.size() == 1){
                conWrap.conId = conList[0].Id;
                String strAccName = conList[0].Account.Name;
                if(String.isNotBlank(shipAccName) && compareStrings(strAccName, shipAccName)){
                    conWrap.contype = 'ship';
                }
                else if(String.isNotBlank(billAccName) && compareStrings(strAccName, billAccName)){
                    conWrap.contype = 'bill';
                }
                else if(String.isNotBlank(accName) && compareStrings(strAccName, accName)){
                    conWrap.contype = 'other';
                }
                return conWrap;
            }
            else if(conList.size() > 1){
                for(Contact con : conList){
                    if(String.isNotBlank(shipAccName) && compareStrings(con.Account.Name, shipAccName)){
                        conWrap.conId = con.Id;
                        conWrap.contype = 'ship';
                        return conWrap;
                    }
                    else if(String.isNotBlank(billAccName) && compareStrings(con.Account.Name, billAccName)){
                        conWrap.conId = con.Id;
                        conWrap.contype = 'bill';
                        return conWrap;
                    }
                    else if(String.isNotBlank(accName) && compareStrings(con.Account.Name, accName)){
                        conWrap.conId = con.Id;
                        conWrap.contype = 'other';
                        return conWrap;
                    }
                }
            }
            else {
                String searchQuery = 'FIND ';
                String searchword = '';
                if(String.isNotBlank(conNameToSearch) && String.isNotBlank(conNameToSearch1)){
                    conNameToSearch = conNameToSearch.removeStart('%');
                    conNameToSearch = conNameToSearch.removeEnd('%');
                    conNameToSearch1 = conNameToSearch1.removeStart('%');
                    conNameToSearch1 = conNameToSearch1.removeEnd('%');
                    searchword = '{'+conNameToSearch+' OR '+conNameToSearch1+'}';
                }
                else if(String.isNotBlank(conNameToSearch) && String.isBlank(conNameToSearch1)){
                    conNameToSearch = conNameToSearch.removeStart('%');
                    conNameToSearch = conNameToSearch.removeEnd('%');
                    searchword = '{'+conNameToSearch+'}';
                }
                else if(String.isNotBlank(conNameToSearch1) && String.isBlank(conNameToSearch)){
                    conNameToSearch1 = conNameToSearch1.removeStart('%');
                    conNameToSearch1 = conNameToSearch1.removeEnd('%');
                    searchword = '{'+conNameToSearch1+'}';
                }
                searchQuery = String.escapeSingleQuotes(searchQuery + searchword) + 'IN NAME FIELDS RETURNING Contact( Id, AccountId, Account.Name, email )';
                //searchQuery = searchQuery + searchword + 'IN NAME FIELDS RETURNING Contact( Id, AccountId, Account.Name, email )';
                List<List<sObject>> searchContacts = search.query(searchQuery);
                conList = ((List<Contact>)searchContacts[0]);
                if(conList.size() > 0){
                    for(Contact con :conList){
                        if(String.isNotBlank(shipAccName) && compareStrings(con.Account.Name, shipAccName)){
                            conWrap.conId = con.Id;
                            conWrap.contype = 'ship';
                            return conWrap;
                        }
                        else if(String.isNotBlank(accName) && compareStrings(con.Account.Name, accName)){
                            conWrap.conId = con.Id;
                            conWrap.contype = 'other';
                            return conWrap; 
                        }
                        else if(String.isNotBlank(billAccName) && compareStrings(con.Account.Name, billAccName)){
                            conWrap.conId = con.Id;
                            conWrap.contype = 'bill';
                            return conWrap;
                        }
                    }
                }
                else {
                    if(String.isNotBlank(fname)){
                        for(Contact con :[SELECT Id, Name, FirstName, AccountId, Account.Name 
                                          FROM Contact 
                                          WHERE Name like : conName1 AND FirstName like : fname+'%' LIMIT 100]){
                            system.debug('in for l.no.458---'+fname);
                            if(con.Name.startsWith(fname)){
                                if(String.isNotBlank(shipAccName) && compareStrings(con.Account.Name, shipAccName)){
                                    conWrap.conId = con.Id;
                                    conWrap.contype = 'ship';
                                    return conWrap;
                                }
                                else if(String.isNotBlank(accName) && compareStrings(con.Account.Name, accName)){
                                    conWrap.conId = con.Id;
                                    conWrap.contype = 'other';
                                    return conWrap; 
                                }
                                else if(String.isNotBlank(billAccName) && compareStrings(con.Account.Name, billAccName)){
                                    conWrap.conId = con.Id;
                                    conWrap.contype = 'bill';
                                    return conWrap;
                                }
                            }
                        }
                    }
                } 
            }
        }
        return conWrap;
    }
    
    private static Boolean validateEmail(String email) {
        Boolean res = true;
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        if (!MyMatcher.matches()) 
            res = false;
        return res; 
    }
    
    private static String removeComma(String num){
        String str = String.join(num.split(','),'');
        return str;
    }
    
    private static String getDecimalFromString(String strDec){
        String decReg = '[0-9]+\\.[0-9]+';
        String intReg = '[0-9]+';
        Pattern myPattern = Pattern.compile(decReg);
        Matcher myMatcher;
        if(String.isNotBlank(strDec)){
            myMatcher = myPattern.matcher(strDec);
            while (myMatcher.find()) { 
                System.debug(myMatcher.group()); 
                return myMatcher.group();
            }
            myPattern = Pattern.compile(intReg);
            myMatcher = myPattern.matcher(strDec);
            while (myMatcher.find()) { 
                System.debug(myMatcher.group()); 
                return myMatcher.group();
            }
            try{
                Integer.valueOf(strDec);
                return strDec;
            }
            catch(Exception e){
                system.debug('message-->'+e.getMessage());
                return '0.00';
            }
        }
        return '0.00';
    }
    /******************************************************************************** 
* Description: Returns the RPA dummy Account. This Account is associated to Order when there are no Account match is found or there are multiple Account match is found.
*********************************************************************************/
    private static Account getRPADummyAccount(){
        return [SELECT Id FROM Account WHERE Name =:'RPA Dummy Account' LIMIT 1][0];//put string in label
    }
    
    private static Date getValidDate(String strDate){
        try {
            return Date.valueOf(strDate);
        } catch (Exception ex) {
            system.debug('----message---'+ex.getMessage());
        }
        try{
            String finalFormat = '';
            String mon ='';
            String day ='';
            String year ='';
            //11/09/2022
            if(strDate.indexOf('/') > 0){
                String[] dateparam = strDate.split('/');
                mon = Integer.valueOf(dateparam[0]) < 10 ? '0'+dateparam[0]:dateparam[0];
                day = Integer.valueOf(dateparam[1]) < 10 ? '0'+dateparam[1]:dateparam[1];
                year = dateparam[2].length() == 2? '20'+dateparam[2]:dateparam[2];
            }
            else { 
                
                map<String, String> months = new map<String, String>();
                months.put('january','01');
                months.put('february','02');
                months.put('march','03');
                months.put('april','04');
                months.put('may','05');
                months.put('june','06');
                months.put('july','07');
                months.put('august','08');
                months.put('september','09');
                months.put('october','10');
                months.put('november','11');
                months.put('december','12');

                map<String, String> monthsShortcut = new map<String, String>();
                for(string str : months.keyset()){
                    monthsShortcut.put(str.substring(0,3),months.get(str));
                }

                String[] dateStrArray;
                if(strDate.indexOf('-') > 0){//18-SEP-2022
                    dateStrArray = strDate.split('-');
                }
                else{
                    dateStrArray = strDate.split(' ');
                }
                
                if(months.containsKey(dateStrArray[1].trim().toLowerCase())){ //2 September 2022 
                    mon = months.get(dateStrArray[1].trim().toLowerCase());
                    day = Integer.valueOf(dateStrArray[0].trim()) < 10 ? '0'+dateStrArray[0].trim():dateStrArray[0].trim();
                }//September 2, 2022
                else if(months.containsKey(dateStrArray[0].trim().toLowerCase())){
                    mon = months.get(dateStrArray[0].trim().toLowerCase());
                    day = removeComma(dateStrArray[1].trim());
                    day = Integer.valueOf(day) < 10 ? '0'+day:day;
                }
                else if(monthsShortcut.containsKey(dateStrArray[1].trim().toLowerCase())){ //2 September 2022 
                    mon = monthsShortcut.get(dateStrArray[1].trim().toLowerCase());
                    day = Integer.valueOf(dateStrArray[0].trim()) < 10 ? '0'+dateStrArray[0].trim():dateStrArray[0].trim();
                }//September 2, 2022
                else if(monthsShortcut.containsKey(dateStrArray[0].trim().toLowerCase())){
                    mon = monthsShortcut.get(dateStrArray[0].trim().toLowerCase());
                    day = removeComma(dateStrArray[1].trim());
                    day = Integer.valueOf(day) < 10 ? '0'+day:day;
                }
                else{//2 9 2022
                    mon = dateStrArray[0].trim();
                    day = Integer.valueOf(dateStrArray[1].trim()) < 10 ? '0'+dateStrArray[1].trim():dateStrArray[1].trim();
                }
                year = dateStrArray[2].trim().length() == 2? '20'+dateStrArray[2].trim():dateStrArray[2].trim();  
            }
            finalFormat = year+'-'+mon+'-'+day;
            if(String.isNotBlank(finalFormat))
                return Date.valueOf(finalFormat);
            else {
                return Date.valueOf(strDate);
            }
        }
        catch(Exception e){
            system.debug('----message---'+e.getMessage());
            return null;
        } 
    }
    
    private static String getValidISBN(String strISBN){
        strISBN = strISBN.replaceAll('[^0-9\\s+]', '');
        Pattern pat = Pattern.compile('([0-9]+\\-[0-9])');
        Pattern pat1 = Pattern.compile('([0-9]+)');
        Matcher matcher = pat.matcher(strISBN);
        while (matcher.find()) {
            return matcher.group();
        } 
        matcher = pat1.matcher(strISBN);
        while (matcher.find()) {
            return matcher.group();
        } 
        return null;
    }
    
    private static Boolean compareStrings(String str1, String str2)
    {
        for(String str: str2.split(' ')){
            if(String.isNotBlank(str1) && String.isNotBlank(str) && str1.containsIgnoreCase(str)){
                return true;
            }
        }
        return false;
    }
    
    public class OrderWrapper
    {
        public string contact;
        public string account;
        public string phone;
        public string email;
        public string podate;
        public string ponumber;
        public string shipAccName;
        public string shipToStreet;
        public string shipToCity;
        public string shipToZip;
        public string shipToState;
        public string shipToCountry;
        public string billAccName;
        public string billToStreet;
        public string billToCity;
        public string billToZip;
        public string billToState;
        public string billToCountry;
    }
    
    public class OrderLineItemWrapper
    {
        String quantity;
        String price;
        String isbn;
        String unitOfMeasure;
        String amount;
        String description;
        String lineNum;
    }
    
    public class ContactWrapper {
        String conId ='';
        String contype = '';
    }
}