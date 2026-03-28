public class AssetTriggerHandler {
    //Queries the contacts for Account with both MathXL and Easybridge.
    //Add the contacts with certain MDR Job codes to the campaign.
    public static void contWithEzBridgeAndMathXLAsset(set <ID> accountIdList){      
        set <ID> accWithEzBridge=new set<ID>();
        list<contact> contList= new list<contact>();
        list <CampaignMember> CampaignMemberList = new list<CampaignMember>();
        Map <ID,ID> CampaignMemberMap= new Map <ID,ID>();
        Campaign camp= new campaign();
        date currentDate=Date.today();
        string currentYear=string.valueof(currentDate.year());
        string campaignName='MathXL Campaign '+currentYear+':Trigger';       //Campaign name to query or create campaign using name
      
        //Query account that has existing EzBridge Asset
        for(asset ezBridge:[Select account.id from asset where account.id IN:accountIdList and Status!='Obsolete' and (product2.name like '%EasyBridge Auto%' or product2.name Like '%EasyBridgePlus%' or product2.name Like '%EasyBridge Plus%')]){
            accWithEzBridge.add(ezBridge.account.id);
        }
        
        if(accWithEzBridge.size()>0){
            //Get List of contacts with job codes. 204 - Assistan Principal,  008 - Director of Curriculum, 301 - Math Dept. Chairperson
            for(contact c:[Select ID, Name, email,MDR_Job_Code__c,Status__c from contact where Status__c= 'Active' and email!=null and MDR_ID__c!=null and Inactive__c=FALSE and accountId IN: accWithEzBridge]){  
                if(c.MDR_Job_Code__c!=NULL && (c.MDR_Job_Code__c.contains('204') || c.MDR_Job_Code__c.contains('008') || c.MDR_Job_Code__c.contains('301'))){
                 contList.add(c);
                }
            }
            
            if(contList.size()>0){
                
                //Query existing campaign
                try{
                    camp=[Select Id from campaign where name=:campaignName limit 1];
                }catch(QueryException qe){
                    //If the Campaign doesn't exist,  create a new campaign
                    camp.name=campaignName;
                    camp.IsActive=True;
                    camp.Status='In Progress';
                    camp.Type='Email';
                    insert camp;
                }
                
                //Query existing campaign members
                for(campaignmember cm: [Select Id,ContactId from campaignmember where contactId!=null and CampaignId=:camp.ID]){
                    campaignMemberMap.put(cm.contactid,cm.id);
                }
                
                //Add new contacts to the campaign if they aren't part of the campaign
                for(contact cont:contList){
                    if(campaignMemberMap.get(cont.Id)==null){
                        CampaignMemberlist.add(new CampaignMember(contactId=cont.Id,CampaignId=camp.Id,status='Sent'));        
                
                    }
                }
                insert campaignMemberList;
            }
        }
    }
    
    public static void handleAfterInsert(List < Asset > newAssets) {
        //Query list of MathXL Product ISBN's from the Product List Custom Settings
        List<Product_List_CS__c> MathXLISBN13List=Product_List_CS__c.getall().values();
        set<string>MathXLISBN13Set=new set<string>();
        for(Product_List_CS__c prod:MathXLISBN13List){
            if(prod.Product__c.equals('MathXL'))
            	MathXLISBN13Set.add(prod.ISBN13__c);
        }
        
        set<ID> accIdMathXL = new set<ID>();
        
        //Query All newly inserted assets
        for(Asset a: [Select account.id,product2.productcode from asset where Id IN: newAssets]){
            //If Asset is Math XL, add the account to the list
            if(MathXLISBN13Set.contains(a.Product2.productcode)){
                accIdMathXL.add(a.account.id);
            }
        }
        
        //If List of Account with Math XL is not empty,  Check if the account also has EasyBridge
        if(accIdMathXL .size()>0)
            contWithEzBridgeAndMathXLAsset(accIdMathXL);
    }
}