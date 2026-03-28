@isTest
public class TestResourceMgmtUserSearchController {
	public static testMethod void testResourceController1() {
    	PageReference pageRef = Page.ResourceManagementUserSearchPage;
      	Test.setCurrentPage(pageRef);
        Recordtype r = [select ID, name,isactive,SobjectType from recordtype where sObjectType='Account' and name like '%Schools%' limit 1];
		Account acc = new Account(Name='Test Resource Account',type='Internal',Recordtypeid=r.Id);
  		insert acc;
        
        //Insert Test Contacts
        List<Contact> contList = new List<Contact>();
        for (Integer c=0;c<20;c++){
              contList.add(new Contact(FirstName='Test'+c,
                                   LastName='Contact'+c,
                                   AccountId=acc.ID,
                                   Email='Test'+c+'.'+'Contact'+c+'@test.com',
                      			   Resource_Type__c='FT Sales',
                       			   Status__c='Active',
                                   Nearest_Major_City__c='Albany, GA')                       				
                      );
         }
        insert contList;
        List<Contact> insertedContact = [Select ID,Resource_Type__c,Nearest_Major_City__c,status__c from contact where accountid=:acc.id];
        system.assertEquals(20, insertedContact.size());
        Qualification_Workshop__c workshop = new Qualification_Workshop__c(Product_Skill__c='enVisionmath',Discipline__c='Diagnostic & Research Services',
                                                                           title__c='112922-enVisionMATH 2015 Lesson Study (2015)');
        insert workshop;
		Qualification_Type__c qualType = new Qualification_Type__c(Name='Test Qualification Type');
        insert qualType;
        list <Qualification__c> qualList=new list<Qualification__c>();
        list <Attributes__c> attList=new list<Attributes__c>();
        for(contact cont:insertedContact){
            Qualification__c qual=new Qualification__c(Contact__c=cont.Id,Qualifications__c='Certified',Qualifiaction_Type__c=qualType.Id,Workshop__c=workshop.Id);
            qualList.add(qual);
            Attributes__c att=new Attributes__c(Contact__c=cont.id,Detail__c='1-5 Years',Type__c='Certification');
            attList.add(att);
        }
        insert qualList;
        insert attList;
        
        Test.startTest();
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(qualList);
        ResourceManagementUserSearchController controller=new ResourceManagementUserSearchController();
        ResourceManagementUserSearchController consultant = new ResourceManagementUserSearchController(stdSetController);
        consultant.workshops=workshop;
        consultant.workshopTitle=workshop.Title__c;
        consultant.competencies=qualList[0];
        consultant.cont=insertedContact[0];
        consultant.getWorkshopTitleList();           
        consultant.att=attList[0];
        list<Qualification__c> qualifiedUser=consultant.getConsultants();
        system.assertEquals(20,qualifiedUser.size());
        consultant.lastPage();
        consultant.firstPage();
        consultant.next();
        consultant.prev();
        Boolean next=consultant.hasNext;
        Boolean prev=consultant.hasPrevious;
        Integer pNum=consultant.PageNumber;
        Integer resultSize=consultant.ResultSize;
        Integer resultPSize=consultant.ResultPageSize;
        PageReference pf=consultant.resetFilter();
        PageReference exportToEx=consultant.exportToExcel();
        Test.stopTest();
    }
    public static testMethod void testResourceController2() {
    	PageReference pageRef = Page.ResourceManagementUserSearchPage;
      	Test.setCurrentPage(pageRef);
        Recordtype r = [select ID, name,isactive,SobjectType from recordtype where sObjectType='Account' and name like '%Schools%' limit 1];
		Account acc = new Account(Name='Test Resource Account 2',type='Internal',Recordtypeid=r.Id);
  		insert acc;
        
        //Insert Test Contacts
		Contact cont=new Contact(FirstName='Joe',
                    LastName='Moe',
                    AccountId=acc.ID,
                    Email='Joe'+'.'+'Moe'+'@test.com',
                    Resource_Type__c='FT Sales',
                    Status__c='Active',
                    Nearest_Major_City__c='Albany, GA');                       				
 
		insert cont;
        Qualification_Workshop__c workshop = new Qualification_Workshop__c(Product_Skill__c='enVisionmath',Discipline__c='Diagnostic & Research Services',
                                                                           title__c='112922-enVisionMATH 2015 Lesson Study (2015)');
        insert workshop;
		Qualification_Type__c qualType = new Qualification_Type__c(Name='Test Qualification Type');
        insert qualType;
        list <Qualification__c> qualList=new list<Qualification__c>();
        list <Attributes__c> attList=new list<Attributes__c>();
		Qualification__c qual=new Qualification__c(Contact__c=cont.Id,Qualifications__c='Certified',Qualifiaction_Type__c=qualType.Id,Workshop__c=workshop.Id);
        Attributes__c att=new Attributes__c(Contact__c=cont.id,Detail__c='1-5 Years');   
        insert qual;
        insert att;
        
        Test.startTest();
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(qualList);
        ResourceManagementUserSearchController controller=new ResourceManagementUserSearchController();
        ResourceManagementUserSearchController consultant = new ResourceManagementUserSearchController(stdSetController);
        consultant.workshops=workshop;
        consultant.filterWorkshopTitle=workshop.Title__c;
        consultant.competencies=qual;
        consultant.cont=cont;
        consultant.getWorkshopTitleList();           
        consultant.att=att;
        list<Qualification__c> qualifiedUser=consultant.getConsultants();
        system.assertEquals(1,qualifiedUser.size());
        Test.stopTest();
    }
    public static testMethod void testResourceController3() {
    	PageReference pageRef = Page.ResourceManagementUserSearchPage;
      	Test.setCurrentPage(pageRef);
        Recordtype r = [select ID, name,isactive,SobjectType from recordtype where sObjectType='Account' and name like '%Schools%' limit 1];
		Account acc = new Account(Name='Test Resource Account 3',type='Internal',Recordtypeid=r.Id);
  		insert acc;
        
        //Insert Test Contacts
		Contact cont=new Contact(FirstName='Joy',
                    LastName='Coe',
                    AccountId=acc.ID,
                    Email='Joy'+'.'+'Coe'+'@test.com',
                    Resource_Type__c='FT Sales',
                    Status__c='Active',
                    Nearest_Major_City__c='Albany, GA');                       				
 
		insert cont;
        Qualification_Workshop__c workshop = new Qualification_Workshop__c(Product_Skill__c='enVisionmath',Discipline__c='Diagnostic & Research Services',
                                                                           title__c='112922-enVisionMATH 2015 Lesson Study (2015)');
        insert workshop;
		Qualification_Type__c qualType = new Qualification_Type__c(Name='Test Qualification Type');
        insert qualType;
        list <Qualification__c> qualList=new list<Qualification__c>();
        list <Attributes__c> attList=new list<Attributes__c>();
		Qualification__c qual=new Qualification__c(Contact__c=cont.Id,Qualifications__c='Certified',Qualifiaction_Type__c=qualType.Id,Workshop__c=workshop.Id);
        insert qual;
        Attributes__c att=new Attributes__c(Contact__c=cont.id,Type__c='Certification');  
        insert att;
        
        Test.startTest();
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(qualList);
        ResourceManagementUserSearchController controller=new ResourceManagementUserSearchController();
        ResourceManagementUserSearchController consultant = new ResourceManagementUserSearchController(stdSetController);
        consultant.workshops=workshop;
        consultant.workshopTitle=workshop.Title__c;
        consultant.competencies=qual;
        consultant.cont=cont;
        consultant.getWorkshopTitleList();           
        consultant.att=att;
        list<Qualification__c> qualifiedUser=consultant.getConsultants();
        system.assertEquals(1,qualifiedUser.size());
        Test.stopTest();
    }
}