/************************************************************************ 
Name: RPAAccountSearch
Purpose: W-012205 - Search the Account in Salesforce database with the help of the Institution name and address data returned by the ML APIs.
		 Displays the found account in LWC palced on Order detail page.
History:
VERSION AUTHOR DATE       DETAIL                DESCRIPITOPN
1.0     CTS               INITIAL DEVELOPMENT   Methods search account by splitting the institution name 
												retuned by ML API combining with the alternate address.
************************************************************************/
public class RPAAccountSearch {
    public static set<String> accountIds  = new set<String>();
    public static map<String, RPA_Annotations__mdt> mapAnnotations = RPA_Annotations__mdt.getAll();
    public static map<String, String> metadata1 = getAnnotaionMap1(mapAnnotations);
    public static map<String, String> metadata2 = getAnnotaionMap2(mapAnnotations);
    // store the ids returned from this method on Order object. And use it to display records on LWC
    public static map<String, AddressMatchWrapper> searchAccount(RPAJSONParser.OrderWrapper ow)
    {
        String accName =  ow.account;
        String shipAccName = ow.shipAccName;
        String billAccName = ow.billAccName;
        map<String, AddressMatchWrapper> mapAccIdToAccAddWrapper = new map<String, AddressMatchWrapper>();

        if(String.isNotBlank(shipAccName)){
            mapAccIdToAccAddWrapper = getFinalMapToReturn(shipAccName, ow);
        }
        if((accountIds.size() == 0 ||  accountIds.size() > 5) && mapAccIdToAccAddWrapper.values().size() == 0 && String.isNotBlank(accName)){
            mapAccIdToAccAddWrapper = getFinalMapToReturn(accName, ow);
        }
        if((accountIds.size() == 0 ||  accountIds.size() > 5) && mapAccIdToAccAddWrapper.values().size() == 0 && String.isNotBlank(billAccName)){
            mapAccIdToAccAddWrapper = getFinalMapToReturn(billAccName, ow);
        }
        if(String.isBlank(ow.billAccName) && String.isBlank(ow.shipAccName) && String.isBlank(ow.account)){
            mapAccIdToAccAddWrapper = getFinalMapToReturn('', ow);
        }
        if(accountIds.size() <=10 && mapAccIdToAccAddWrapper.values().size() == 0){
            // when only accounts found, then compare the account billing address with address sent by ML
            accountIds = getFinalAccountIds(accountIds, ow);
            for(String accId : accountIds){
                mapAccIdToAccAddWrapper.put(accId, null);
            }
        }
        return mapAccIdToAccAddWrapper;
    }
    
    private static map<String, AddressMatchWrapper> getFinalMapToReturn(String accName, RPAJSONParser.OrderWrapper ow)
    {
        String street = ow.shipToStreet;
        String city = ow.shipToCity; 
        String zip = ow.shipToZip;
        String state = ow.shipToState;
        String billingStreet = ow.billToStreet;
        String billingCity = ow.billToCity;
        String billingZip = ow.billToZip; 
        String billingState = ow.billToState;
        String strName2 = '';
        String strName3 = '';
        String strName5 = '';
        String temp = '';
        list<Account> lstAccounts = new list<Account>();
        map<String, AddressMatchWrapper> mapAccIdToAccAddWrapper = new map<String, AddressMatchWrapper>();
        //search Accounts by name
        if(String.isNotBlank(accName)){
            String query1 = 'SELECT Id FROM Account ';
            strName5 = getMainWordFromName(accName, ow.contact);
            strName2 = getModifiedAccNameFromDD(accName,'2'); 
            temp = accName.split(' ')[0];
            strName3 = (!metadata1.keyset().contains(temp) && !metadata2.keyset().contains(temp))?temp:null;
            strName3 = String.isNotBlank(strName3)?'%'+strName3.removeend(',').trim()+'%':strName3;
            strName2 = String.isNotBlank(strName2)?'%'+strName2.removeend(',').trim()+'%':strName2;
            strName5 = String.isNotBlank(strName5)?'%'+strName5.removeend(',').trim()+'%':strName5;
            if(String.isNotBlank(strName3) && String.isNotBlank(strName2) && String.isNotBlank(strName5)){
                query1 += 'WHERE Name like :strName3  OR Name like: strName2 OR Name like: strName5 ';
            }
            if(String.isNotBlank(strName3) && String.isNotBlank(strName2) && String.isBlank(strName5)){
                query1 += 'WHERE Name like :strName3  OR Name like: strName2 ';
            }
            if(String.isNotBlank(strName3) && String.isNotBlank(strName5) && String.isBlank(strName2)){
                query1 += 'WHERE Name like :strName3  OR Name like: strName5 ';
            }
            if(String.isNotBlank(strName2) && String.isNotBlank(strName5) && String.isBlank(strName3)){
                query1 += 'WHERE Name like :strName2  OR Name like: strName5 ';
            }
            if(String.isNotBlank(strName5) && String.isBlank(strName3) && String.isBlank(strName2)){
                query1 = 'WHERE Name like :strName5 ';
            }
            if(String.isNotBlank(strName3) && String.isBlank(strName2) && String.isBlank(strName5)){
                query1 += ' WHERE Name like :strName3';
            }
            if(String.isNotBlank(strName2) && String.isBlank(strName3) && String.isBlank(strName5)){
                query1 += ' WHERE Name like :strName2';
            }
            query1 += 'LIMIT 5000';

            system.debug('Account query1--->'+query1);
            //find if there is a single account or multiple account which matches the Institution name sent by ML
            lstAccounts = Database.query(query1);
            for(Account acc : lstAccounts){
                accountIds.add(acc.Id);
            }  
           
            if(accountIds.size() > 0){ // try to find account by matching address and name sent by ML as it is
                if((String.isNotBlank(city) && String.isNotBlank(state) && String.isNotBlank(zip)) || 
                   (String.isNotBlank(billingCity) && String.isNotBlank(billingState) && String.isNotBlank(billingZip)) 
                  )
                {
                    mapAccIdToAccAddWrapper = searchAccountAddress(strName2, strName3, strName5, street, city, zip, state, 
                                                          billingStreet, billingCity, billingZip, billingState, accountIds);
                } 
            }
        }
        else
        {
            if((String.isNotBlank(city) && String.isNotBlank(state) && String.isNotBlank(zip)) || 
               (String.isNotBlank(billingCity) && String.isNotBlank(billingState) && String.isNotBlank(billingZip)) 
              )
            {
                mapAccIdToAccAddWrapper = searchAccountAddress('', '', '', street, city, zip, state, 
                                                      billingStreet, billingCity, billingZip, billingState, null);
            } 
        }
        return mapAccIdToAccAddWrapper;
    }
    
    //returns first 2 words and replaces string from dictionary
    private static String getModifiedAccNameFromDD(String name, String strCount)
    {
        String[] nameSubstring = name.split(' ');
        String finalNameString = '';
        // if name string contains any annotation from dictionary, replace it with equivalent value from dictionary
        if(nameSubstring.size() > 1){
            if(strCount == '2'){
                finalNameString = nameSubstring[0]+' '+nameSubstring[1];
                for(Integer i=0; i<2; i++){
                    if(metadata1.containsKey(nameSubstring[i].toLowerCase())){
                        finalNameString = finalNameString.replace(nameSubstring[i], metadata1.get(nameSubstring[i].toLowerCase()));
                    }
                    if(metadata2.containsKey(nameSubstring[i].toLowerCase())){
                        finalNameString.replace(nameSubstring[i], metadata2.get(nameSubstring[i].toLowerCase()));
                    }
                }
            }
        }
        if(String.isBlank(finalNameString)) finalNameString = name;
        return finalNameString;
    }
    
    //if more than 1 Account returned or no account returned in name search, search with address
    public static map<String, AddressMatchWrapper> searchAccountAddress(String accntName1, String accntName2, String accntName3,
                                                            String street, String city, String zip, 
                                                            String state, String billingStreet, String billingCity, 
                                                            String billingZip, String billingState, set<String> accntIds)
    {
        if(String.isNotBlank(accntName1) && accntName1.indexOf('%') < 0){
            accntName1 = '%'+accntName1+'%';
        }
        if(String.isNotBlank(accntName2) && accntName2.indexOf('%') < 0){
            accntName2 = '%'+accntName2+'%';
        }
        if(String.isNotBlank(accntName3) && accntName3.indexOf('%') < 0){
            accntName3 = '%'+accntName3+'%';
        }
        String stZip = '%'+zip+'%';
        if(zip.length() > 5){
            stZip ='%'+zip.left(5)+'%';
        }
        String strState = '%'+getUSStateCodesOrNames(state)+'%';
        String source = label.RPA_SAP_Source;
        String query = '';
        String strShipping = 'Shipping';
        String strBilling = 'Billing';
        //Boolean isShipping = false;
        AddressMatchWrapper amw;
        list<Account_Addresses__c> lstAccountAddress = new list<Account_Addresses__c>();
        map<String, AddressMatchWrapper> mapAccIdToAccAddWrapper = new map<String, AddressMatchWrapper>();
        // city, state and zip value should be prsent in at least one of the address
        if(String.isNotBlank(city) && String.isNotBlank(strState) && String.isNotBlank(zip))
        {
            //isShipping = true;
            String strCity = city.trim();
            city = '%'+strCity+'%';
            
            query = 'SELECT Account__c, Account__r.Name, Address_1__c, Address_2__c, Address_Type__c, '+ 
            +'City__c, Country__c, Id, Source__c, State__c, Zip_Code__c FROM Account_Addresses__c '+
            +'WHERE Account__c != null AND ( City__c =: strCity OR City__c like:city ) AND Zip_Code__c like :stZip'+ 
            +' AND ( State__c =: state OR State__c like :strState ) AND Source__c =: source AND Address_Type__c =: strShipping ';

            if(accntIds != null)
                query +='AND Account__c IN : accntIds ';

            if(String.isNotBlank(accntName1) && String.isNotBlank(accntName2) && String.isNotBlank(accntName3)) 
                query +='AND (Account__r.Name like :accntName1 OR Account__r.Name like :accntName2 OR Account__r.Name like :accntName3) ';
            
            if(String.isNotBlank(accntName1) && String.isNotBlank(accntName2) && String.isBlank(accntName3)) 
                query +='AND (Account__r.Name like :accntName1 OR Account__r.Name like :accntName2) ';

            if(String.isNotBlank(accntName1) && String.isNotBlank(accntName3) && String.isBlank(accntName2)) 
                query +='AND (Account__r.Name like :accntName1 OR Account__r.Name like :accntName3) ';

            if(String.isNotBlank(accntName2) && String.isNotBlank(accntName3) && String.isBlank(accntName1)) 
                query +='AND (Account__r.Name like :accntName2 OR Account__r.Name like :accntName3) ';

            if(String.isNotBlank(accntName1) && String.isBlank(accntName3) && String.isBlank(accntName2)) 
                query +='AND Account__r.Name like :accntName1 ';
    
            if(String.isNotBlank(accntName2) && String.isBlank(accntName1) && String.isBlank(accntName3)) 
                query +='AND Account__r.Name like :accntName2 ';

            if(String.isNotBlank(accntName3) && String.isBlank(accntName1) && String.isBlank(accntName2)) 
                query +='AND Account__r.Name like :accntName3 ';

            query+= 'LIMIT 100';

            if(String.isNotBlank(query))
                lstAccountAddress = Database.query(query);
        }

        if(!lstAccountAddress.isEmpty()){
            for(Account_Addresses__c aa : lstAccountAddress){
                if(String.isNotBlank(street)){
                    amw = new AddressMatchWrapper();
                    if(streetNumMatch(street, aa.Address_1__c, aa.Address_2__c) && streetAddressCompare(street, aa.Address_1__c, aa.Address_2__c))
                    {
                        amw.accAddId = aa.Id;
                        amw.shipOrBill = 'ship';
                        mapAccIdToAccAddWrapper.put(aa.Account__c, amw);
                        break;
                    }
                }
            }

            if(mapAccIdToAccAddWrapper.values().isEmpty()){
                for(Account_Addresses__c aa : lstAccountAddress){
                    if(String.isNotBlank(street)){
                        amw = new AddressMatchWrapper();
                        if(streetAddressCompare(street, aa.Address_1__c, aa.Address_2__c)){
                            amw.accAddId = aa.Id;
                            amw.shipOrBill = 'ship';
                            mapAccIdToAccAddWrapper.put(aa.Account__c, amw);
                            break;
                        }
                    }
                }
            }
        }
        
        if(mapAccIdToAccAddWrapper.values().isEmpty() && String.isNotBlank(billingCity) && String.isNotBlank(billingState) && String.isNotBlank(billingZip))
        {
            String strBillCity = billingCity.trim();
            billingCity = '%'+strBillCity+'%';
            strState = '%'+getUSStateCodesOrNames(billingState)+'%';
            if(billingZip.length() > 5){
                billingZip = billingZip.left(5);
            }
            billingZip = '%'+billingZip+'%';

            query = 'SELECT Account__c, Account__r.Name, Address_1__c, Address_2__c, Address_Type__c, '+ 
            +'City__c, Country__c, Id, Source__c, State__c, Zip_Code__c FROM Account_Addresses__c '+
            +'WHERE Account__c != null AND ( City__c =: strBillCity OR City__c like:billingCity ) AND Zip_Code__c like :billingZip AND ( State__c =: billingState OR State__c like :strState ) AND Source__c =: source AND Address_Type__c =: strBilling ';

            if(accntIds != null)
                query +='AND Account__c IN : accntIds ';
    
            if(String.isNotBlank(accntName1) && String.isNotBlank(accntName2) && String.isNotBlank(accntName3)) 
                query +='AND (Account__r.Name like :accntName1 OR Account__r.Name like :accntName2 OR Account__r.Name like :accntName3) ';
            
            if(String.isNotBlank(accntName1) && String.isNotBlank(accntName2) && String.isBlank(accntName3)) 
                query +='AND (Account__r.Name like :accntName1 OR Account__r.Name like :accntName2) ';

            if(String.isNotBlank(accntName1) && String.isNotBlank(accntName3) && String.isBlank(accntName2)) 
                query +='AND (Account__r.Name like :accntName1 OR Account__r.Name like :accntName3) ';

            if(String.isNotBlank(accntName2) && String.isNotBlank(accntName3) && String.isBlank(accntName1)) 
                query +='AND (Account__r.Name like :accntName2 OR Account__r.Name like :accntName3) ';

            if(String.isNotBlank(accntName1) && String.isBlank(accntName3) && String.isBlank(accntName2)) 
                query +='AND Account__r.Name like :accntName1 ';
    
            if(String.isNotBlank(accntName2) && String.isBlank(accntName1) && String.isBlank(accntName3)) 
                query +='AND Account__r.Name like :accntName2 ';

            if(String.isNotBlank(accntName3) && String.isBlank(accntName1) && String.isBlank(accntName2)) 
                query +='AND Account__r.Name like :accntName3 ';

            query+= 'LIMIT 100';

            if(String.isNotBlank(query))
                lstAccountAddress = Database.query(query);

                if(!lstAccountAddress.isEmpty()){
                    for(Account_Addresses__c aa : lstAccountAddress){   
                        if(String.isNotBlank(billingStreet)){
                            amw = new AddressMatchWrapper();
                            if(streetNumMatch(billingStreet, aa.Address_1__c, aa.Address_2__c) && streetAddressCompare(billingStreet, aa.Address_1__c, aa.Address_2__c)){
                                amw.accAddId = aa.Id;
                                amw.shipOrBill = 'bill';
                                mapAccIdToAccAddWrapper.put(aa.Account__c, amw);
                                break;
                            }
                        }
                    }
                    if(mapAccIdToAccAddWrapper.values().isEmpty()){
                        for(Account_Addresses__c aa : lstAccountAddress){
                            if(String.isNotBlank(billingStreet)){
                                amw = new AddressMatchWrapper();
                                if(streetAddressCompare(billingStreet, aa.Address_1__c, aa.Address_2__c)){
                                    amw.accAddId = aa.Id;
                                    amw.shipOrBill = 'bill';
                                    mapAccIdToAccAddWrapper.put(aa.Account__c, amw);
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        return mapAccIdToAccAddWrapper;
    }
    
    // some standard annotations are maintained in the custom metadata to help to search the Account
    private static map<String, String> getAnnotaionMap1(map<String, RPA_Annotations__mdt> mapAnnotations){
        map<String, String> mapToReturn = new map<String, String>();
        for(String rpaa : mapAnnotations.keyset()){
            mapToReturn.put(rpaa.toLowerCase(), mapAnnotations.get(rpaa).Abbreviation__c);
        }
        return mapToReturn;
    }
    
    private static map<String, String> getAnnotaionMap2(map<String, RPA_Annotations__mdt> mapAnnotations){
        map<String, String> mapToReturn = new map<String, String>();
        for(String rpaa : mapAnnotations.keyset()){
            mapToReturn.put(mapAnnotations.get(rpaa).Abbreviation__c.toLowerCase(), rpaa);
        }
        return mapToReturn;
    }
    
    // state codes are maintained in custom metadata, to help the address seacrh better
    private static String getUSStateCodesOrNames(String strState){
        String stateToReturn = '';
        map<String, RPA_US_State_Codes__mdt> mapUSStateCodes = RPA_US_State_Codes__mdt.getAll();
        map<String, String> mapStateNameToCode = new map<String, String>();
        for(RPA_US_State_Codes__mdt rusc : mapUSStateCodes.values()){
            if(rusc.Label.equalsIgnoreCase(strState)){
                stateToReturn = rusc.State_Code__c;
            }
            else if(strState == rusc.State_Code__c){
                stateToReturn = rusc.Label;
            }
        }
        return stateToReturn;
    }
    
    // to get street number from street address
    private static String getStreetNumber(String street){
        String streetNumber = '';
        Pattern streetPattern = Pattern.compile('^(\\b\\D+\\b)?\\s*(\\b.*?\\d.*?\\b)\\s*(\\b\\D+\\b)?$');
        Matcher m = streetPattern.matcher(street);
        if (m.find()){
            streetNumber = m.group(2);
            streetNumber = streetNumber.replaceAll('[^a-zA-Z0-9\\s+]', '');
            return streetNumber.trim();
        }
        return null;
    }

    // to check if street number is found in any of the addresses
    private static Boolean streetNumMatch(String street, String add1, String add2)
    {
        String stNum = getStreetNumber(street);
        if(String.isNotBlank(stNum)){
            Pattern streetPattern = Pattern.compile('([0-9]+)');
            Matcher m = streetPattern.matcher(stNum);
            if (m.find()){
                stNum = m.group(1);
            }
            if((String.isNotBlank(add1) && add1.containsIgnoreCase(stNum)) || 
               (String.isNotBlank(add2) && add2.containsIgnoreCase(stNum))){
                return true;
            } 
        }
        return false;
    }
    
    // to check if street address matches with with street address sent by ML
    private static Boolean streetAddressCompare(String street, String add1, String add2)
    {
        for(String str: street.split(' ')){
            if(String.isNotBlank(str) && !metadata1.keyset().contains(str) && !metadata2.keyset().contains(str)){
                if((String.isNotBlank(add1) && add1.containsIgnoreCase(str)) || 
                   (String.isNotBlank(add2) && add2.containsIgnoreCase(str))){
                    return true;
                }
            }
        }
        return false;
    }
    
    // returns set of account ids which found match
    private static set<String> getFinalAccountIds(set<String> accIds, RPAJSONParser.OrderWrapper ow)
    {
        String street = ow.shipToStreet;
        String city = ow.shipToCity; 
        String zip = ow.shipToZip;
        String state = ow.shipToState;
        String billingStreet = ow.billToStreet;
        String billingCity = ow.billToCity;
        String billingZip = ow.billToZip; 
        String billingState = ow.billToState;
        set<String> accIdsToReturn = new set<String>();
        for(Account acc : [SELECT Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet 
                           FROM Account 
                           WHERE Id IN : accIds
                           AND (BillingCity != null AND BillingPostalCode != null AND  BillingState!=null)]){
            if(acc.BillingCity.equalsIgnoreCase(city) && acc.BillingPostalCode.contains(zip) && (acc.BillingState.equalsIgnoreCase(state) || acc.BillingState.equalsIgnoreCase(getUSStateCodesOrNames(state)))){
                if(streetNumMatch(street, acc.BillingStreet, '')){
                    accIdsToReturn.add(acc.Id);
                    break;
                }
                else if(streetAddressCompare(street, acc.BillingStreet, '')){
                    accIdsToReturn.add(acc.Id);
                    break;
                }
            }
            else if(acc.BillingCity.equalsIgnoreCase(billingCity) && acc.BillingPostalCode.contains(billingZip) && (acc.BillingState.equalsIgnoreCase(billingState) || acc.BillingState.equalsIgnoreCase(getUSStateCodesOrNames(billingState))) )
            {
                if(streetNumMatch(billingStreet, acc.BillingStreet, '')){
                    accIdsToReturn.add(acc.Id);
                    break;
                }
                else if(streetAddressCompare(billingStreet, acc.BillingStreet, '')){
                    accIdsToReturn.add(acc.Id);
                    break;
                }
            }
        }
        if(accIdsToReturn.size() > 0)
            return accIdsToReturn;
        else
            return accIds;
    }
    
    // based on the sample POs tested, returns the possible main word from the institution name sent by ML API.
    public static String getMainWordFromName(String strAccName, String conName)
    {
        //String temp = strAccName;
        if(String.isNotBlank(strAccName)){
            if(String.isNotBlank(conName) && !strAccName.equalsIgnoreCase(conName)){
                conName = conName.toLowerCase().replaceAll('[^a-zA-Z\\s+]', '');
                for(String strName : conName.split(' ')){
                    if(strAccName.containsIgnoreCase(strName)){
                        strAccName = strAccName.replaceAll('(^|\\s+)'+strName+'(?=\\s+|$)','');
                    }
                }
            }
            strAccName = strAccName.toLowerCase();
            RPA_Annotations__mdt ram = new RPA_Annotations__mdt();
            for(String str : mapAnnotations.keyset()){
                ram = mapAnnotations.get(str);
                str = str.toLowerCase();
                if(ram.Replace__c && (strAccName.containsIgnoreCase(str) || strAccName.containsIgnoreCase(ram.label))){
                    if(strAccName.containsIgnoreCase(str))
                        strAccName = strAccName.replaceAll('(^|\\s+)'+str+'(?=\\s+|$)', ram.label);
                    else if(strAccName.containsIgnoreCase(ram.label))
                        strAccName = strAccName.replaceAll('(^|\\s+)'+ram.label+'(?=\\s+|$)', ram.Abbreviation__c);
                }
                if(!ram.Replace__c && strAccName.containsIgnoreCase(str)){
                    strAccName = strAccName.replaceAll('\'s', '');
                    strAccName = strAccName.replaceAll('(^|\\s+)'+str+'(?=\\s+|$)','');
                    strAccName = strAccName.replaceAll('[^a-zA-Z\\s+]', '');
                }
            }
        	return strAccName.trim();
        }
        return null;
    }
    
    public class AddressMatchWrapper{
        public String accAddId;
        public String shipOrBill;
    }
}