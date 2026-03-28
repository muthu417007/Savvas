@isTest (SeeAllData=true)
public class testLeadCreation{
	static testMethod void myUnitTest() {
        list <Campaign> campList=new list<Campaign>();
        
        //Creates 2 different Campaigns
        For(Integer i=0;i<2;i++){
        	Campaign c = new Campaign();
        	c.Name='TestClassCampaign'+i;
        	c.Product_Family__c='TestClassCampaign '+i;
            campList.add(c);
        }       
        insert campList;
        
        //Creates lead
        Lead l = new Lead();
        l.lastname='TestClassLead';
        l.firstname='FirstName';
        l.company='TestClassLead';
        l.Campaign__c=campList[0].id;
        l.Phone='555-555-5555';
        l.Campaign_Tracking__c='OldCampaignTracking';
        insert l;
        
        //Add lead to the second Campaign
        CampaignMember cm=new CampaignMember();
        cm.LeadId=l.id;
        cm.Status='Sent';
        cm.CampaignId=campList[1].id;
        insert cm;
        
        l.Campaign_Tracking__c=campList[1].id;
        update l;        
        
    }
}