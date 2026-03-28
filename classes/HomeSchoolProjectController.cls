/* -----------------------------------------------------------------------------------------------------------------------
Name:        HomeSchoolProjectController
Description: This class is called from Homeschool project Flow. This will extract the 13 digit ISBN numbers given in Case description



Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
12/02/2022     1.0     Smitha Prabhu      Initial Release


-------------------------------------------------------------------------------------------------------------------------- */
public class HomeSchoolProjectController {
    /*Method Name : getTenDigitISBN
     *Arguments : inputFromFlow - Bundle ISBN, ISBN, Description details will be getting from Case 
	 *This method will create ZNOC Winshuttle records for each case with Bundle ISBN, ISBN values updated
	*/
    @InvocableMethod (label='Get ISBN values')
    public static void getTenDigitISBN(list<GetValueInputs> inputFromFlow){
        list<ZNOC_Winshuttle__c> lstWinshuttleToInsert = new list<ZNOC_Winshuttle__c>();
        list<String> lstISBN13Digits;
        ZNOC_Winshuttle__c objWinshuttle;
        for(GetValueInputs input : inputFromFlow){
            objWinshuttle = input.winshuttle;
            lstISBN13Digits = new list<String>();
            lstISBN13Digits = getISBN13Digits(input.Description);
            objWinshuttle.Bundle_ISBN__c = String.join(lstISBN13Digits, ',');
            objWinshuttle.ISBN_10__c = getISBN10Digits(lstISBN13Digits);
            lstWinshuttleToInsert.add(objWinshuttle);
        }
        try{           
        	Database.insert(lstWinshuttleToInsert, false);
        }
        catch(Exception e){
            system.debug('HomeSchoolProjectController exception: '+e.getMessage());
        }
    }
    /*Class Name : GetValueInputs
	 *Wrapper Class to get the values from Flow
	*/
    public class GetValueInputs{
        @InvocableVariable(label='ZNOC_Winshuttle' required=true)
        public ZNOC_Winshuttle__c winshuttle;
        
        @InvocableVariable(label='Description' required=true)
        public String Description;
    }
    
   /*Method Name : getISBN13Digits
     *Arguments : caseDescSubStr - This contains case description
	 *This method will get the 13 digit ISBN value from the description
	*/
    public static list<String> getISBN13Digits(String caseDescSubStr){
        list<String> lst13DigitISBNs = new list<String>();
        Pattern pat = Pattern.compile('([0-9]{13}+)');
        Matcher matcher = pat.matcher(caseDescSubStr);
        while (matcher.find()) {
            lst13DigitISBNs.add(matcher.group());
        } 
        return lst13DigitISBNs;
    }
    
    /*Method Name : getISBN10Digits
     *Arguments : lst13DigitISBNs - This contains Bundle ISBN value
	 *This method will get the 10 digit ISBN value for the respective Bundle ISBN value
	*/
    public static String getISBN10Digits(list<String> lst13DigitISBNs){
        list<string> lstFinalISBN10 = new list<string>();
        for(Digital_XREF__mdt objDX : [SELECT ISBN10__c FROM Digital_XREF__mdt WHERE Bundle_ISBN__c IN: lst13DigitISBNs])
        {
            lstFinalISBN10.add(objDX.ISBN10__c);
        }
        return String.join(lstFinalISBN10, ',');
    }
}