@isTest (SeeAllData=true)
public class TestContactTrigger {
	static testMethod void UpdateCampaignTracking() {
        List<CampaignMember> cmList = new List<CampaignMember>();
            
        //Creates list of accounts and contacts
		Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(10,0,10);
        List<Contact> contList = [Select ID, FirstName,LastName,Campaign_Tracking__c from Contact where accountId IN:accts];
        system.assertEquals(100,contList.size());
        
		Date todaysDate = Date.Today(); 
        
        //Creates Campaigns
        Campaign camp = new Campaign();
        camp.Name='TestClassCampaign'+todaysDate;
        camp.Product_Family__c='TestClassCampaign '+todaysDate;
		insert camp;
        
        //Add the contacts as Campaign members and update the campaign tracking field on the contact;
        for(Contact c:contList){
            Campaignmember cm= new Campaignmember();
            cm.ContactId = c.Id;
            cm.Status = 'Sent';
            cm.CampaignId=camp.Id;
            cmList.add(cm);
            c.Campaign_tracking__c=camp.Id;   
        }
        insert cmList;
        system.assertEquals(100,cmList.size());
        update contList;
        
    }
}