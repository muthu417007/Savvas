@isTest
public class TestContactSegmentationByAsset {
    public static testMethod void testContSegByAsset(){
        PageReference pageRef = Page.ContactSegmentationByAssetPage;
      	Test.setCurrentPage(pageRef);
        date myDate=Date.today();
        Integer day=myDate.dayOfYear();
        list<Asset> assetList=new list<Asset>();
        list<Contact> contList=new list<Contact>();
        list<Account> accList=new List<account>();
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(5,0,5);
        Product2 prod=new Product2(Name = 'Test Product'+day,ProductCode='Test Product '+day,MasterProgram__c='Envision Math');
      	insert prod;
        
      	//Create assets on Accounts and Update account Address
      	for(Integer a=0;a<5;a++){
          Asset asst=new asset(Name = 'Product Asset '+a,Accountid=accts[a].Id,product2id=prod.Id,InstallDate=mydate,UsageEndDate=mydate+365);
          assetList.add(asst);
          accts[a].BillingState='CA';
          accts[a].BillingPostalCode='94560';
          accts[a].BillingCountry='United States';
          accts[a].Enrollment__c=3500;
          accts[a].District_ELL_Percentage__c=20;
		  accts[a].AIM_Per_Pupil__c=75;
		  accts[a].Title_1__c=100;
		  accts[a].African_Am__c=25;
		  accts[a].Asian_Percent__c=20;
		  accts[a].Caucasian_Percent__c=25;
		  accts[a].Hispanic_Percent__c=15;
		  accts[a].Native_Am_Percent__c=10;
		  accts[a].Test_Score_Math_Gr4__c=65;
		  accts[a].Test_Score_Math_Gr8__c=75;
		  accts[a].Test_Score_Reading_Gr4__c=70;
		  accts[a].Test_Score_Reading_Gr8__c=80;
          accList.add(accts[a]);
        }
      	insert assetList;
      	update accList;
      
      	MasterProgram__c mp=new MasterProgram__c();
      	mp.name='MP Name '+day;
      	mp.Master_Program__c='Envision Math';
      	insert mp;
      
      	Integer i=0;
        for(Contact c:[Select id,name,email from Contact where accountid IN:accts]){
            c.status__c='Active';
            c.Marketing_Email_Opt_Out__c=FALSE;
            c.MDR_ID__c=c.AccountId+'-'+i;
            c.Inactive__c=FALSE;
            c.MDR_Job_Code__c='204-Teacher';
            contList.add(c);
            i++;
        }
      	Update contList;
      	system.assertEquals(25,contList.size());
      	Test.startTest();
      
      	ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(contList);
      	ContactSegmentationByAssetController controller=new ContactSegmentationByAssetController();
      	ContactSegmentationByAssetController contactsController = new ContactSegmentationByAssetController(stdSetController);
      	
        //Test for the Master Program Selection
        Controller.MPleftselected=new list<string>{'Envision Math','Reading'};	
      	Controller.MPselectclick();
      	Controller.getMPSelectedValues();
        Controller.queryContacts();
        Controller.MPrightselected.add('Reading');
      	Controller.MPunselectclick();
      	Controller.getMPunSelectedValues();
        
        //Test for Account state selection
        Controller.AccStateLeftSelected=new list<string>{'NY','CA'};
        Controller.AccStateselectclick();
        Controller.getAccStateSelectedValues();
        Controller.AccStateRightSelected.add('NY');
        Controller.AccStateunselectclick();
        Controller.getAccStateunSelectedValues();
        
        //Test for the ISBN selection
        Controller.ISBN13='Test Product '+day+','+'1234567890123';
        Controller.ISBNselectclick();
        Controller.queryContacts();
        Controller.MPrightselected.add('Envision Math');
        Controller.MPunselectclick();
        Controller.ISBN13='1111222233333';
        Controller.ISBNselectclick();
        Controller.getISBNSelectedValues();
        Controller.ISBNrightselected=new list<string>{'1234567890123','1111222233333'};
        Controller.ISBNunselectclick();
        Controller.queryContacts();
        
        //Test for Job Codes
        Controller.Titles='Teacher,Director,Supervisor';
        Controller.TitlesSelectclick();
        Controller.Titles='204';
        Controller.TitlesSelectclick();
        Controller.getTitlesSelectedValues();
        Controller.SelectedContactTitle='Title';
        Controller.Titlesrightselected=new list<string>{'Director,Supervisor'};
        Controller.TitlesUnselectclick();
        Controller.Titlesrightselected.add('Teacher');
        Controller.TitlesUnselectclick();
        Controller.queryContacts();
        
        Controller.enrollStartRange=2000;
        Controller.enrollEndRange=4000;
        Controller.ELLStartRange=15;
        Controller.ELLEndRange=25;
        Controller.AIMStartRange=65;
        Controller.AIMEndRange=75;
        Controller.Title1StartRange=100;
        Controller.Title1EndRange=120;
        Controller.AfricanAmStartRange=20;
        Controller.AfricanAmEndRange=30;
        Controller.AsianStartRange=20;
        Controller.AsianEndRange=25;
        Controller.CaucasianStartRange=20;
        Controller.CaucasianEndRange=30;
        Controller.HispanicStartRange=15;
        Controller.HispanicEndRange=20;
        Controller.NativeAmStartRange=5;
        Controller.NativeAmEndRange=15;
        Controller.MathGrade4StartRange=60;
        Controller.MathGrade4EndRange=70;
        Controller.MathGrade8StartRange=70;
        Controller.MathGrade8EndRange=80;
        Controller.ReadingGrade4StartRange=65;
        Controller.ReadingGrade4EndRange=75;
        Controller.ReadingGrade8StartRange=75;
        Controller.ReadingGrade8EndRange=85;
        Controller.myTeamsAccounts=TRUE;
        Controller.installStartDate=mydate-10;
        Controller.installEndDate=mydate+10;
        Controller.expireStartDate=mydate+300;
        Controller.expireEndDate=mydate+400;
        Controller.noEmail=TRUE;
        Controller.SelectedContactTitle='MDR Job Codes';
        
      	Controller.queryContacts();
      	list<Contact> ContactResult=Controller.getContactsQuery();
      	system.assertNotEquals(0,ContactResult.size());
        integer pageNum=Controller.pageNumber;
      	integer rSize=Controller.ResultSize;
      	integer pSize=Controller.ResultPageSize;
      	boolean nextPage=Controller.hasNext;
      	Controller.next();
      	boolean prevPage=Controller.hasPrevious;
      	Controller.prev();
      	Controller.firstPage();
      	Controller.lastPage();
      	Test.stopTest();
	}
    
    public static testMethod void testContSegByAssetAddToCampaign(){
        PageReference pageRef = Page.ContactSegmentationByAssetPage;
      	Test.setCurrentPage(pageRef);
        date myDate=Date.today();
        Integer day=myDate.dayOfYear();
        list<Asset> assetList=new list<Asset>();
        list<Contact> contList=new list<Contact>();
        Campaign thisCampaign=new Campaign(Name='Test Contact Segmentation'+myDate,Status='Planned',isActive=TRUE);
        insert thisCampaign;
       	ApexPages.currentPage().getParameters().put('Id',thisCampaign.Id);
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(5,0,10);
        Account testAcc=[Select ID,name,ownerid from account where ID in: accts limit 1];

        Product2 prod=new Product2(Name = 'Test Product'+day,ProductCode='Test Product '+day,MasterProgram__c='Envision Math');
      	insert prod;
        
        //Create assets on Accounts
        for(Integer a=0;a<5;a++){
          Asset asst=new asset(Name = 'Product Asset '+a,Accountid=accts[a].Id,product2id=prod.Id,InstallDate=mydate,UsageEndDate=mydate+365);
          assetList.add(asst);
        }
        insert assetList;
      
      	MasterProgram__c mp=new MasterProgram__c();
      	mp.name='MP Name '+day;
      	mp.Master_Program__c='Envision Math';
      	insert mp;
      
      	Integer i=0;
        for(Contact c:[Select id,name,email from Contact where accountid IN:accts]){
            c.status__c='Active';
            c.Marketing_Email_Opt_Out__c=FALSE;
            c.MDR_ID__c=c.AccountId+'-'+i;
            c.Inactive__c=FALSE;
            c.MDR_Job_Code__c='204-Teacher';
            contList.add(c);
            i++;
        }
      	Update contList;
      	system.assertEquals(50,contList.size());
        
        //Insert first contact on the Campaign
        Campaignmember newCampMember=new Campaignmember(ContactId=contList[0].Id,CampaignId=thisCampaign.Id,status='Sent');
        insert newCampMember;
        
      	Test.startTest();
      
      	ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(contList);
      	ContactSegmentationByAssetController controller=new ContactSegmentationByAssetController();
      	ContactSegmentationByAssetController contactsController = new ContactSegmentationByAssetController(stdSetController);
      	
        //Test for the Master Program Selection
        Controller.MPleftselected=new list<string>{'Envision Math','Reading'};
      	Controller.MPselectclick();
      	Controller.getMPSelectedValues();
        Controller.acc=testAcc;
      	Controller.queryContacts();
      	list<Contact> ContactResult=Controller.getContactsQuery();
      	system.assertNotEquals(0,ContactResult.size());
        Controller.addtoCampaign();
      	Test.stopTest();
	}
}