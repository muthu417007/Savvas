@isTest
private class SupportNoteControllerTest {

    static testMethod void myUnitTest() {
      
            User currentUser = [select id, title, firstname, lastname, email, phone, mobilephone, fax, street, city, state, postalcode, country
                                FROM User WHERE id =: UserInfo.getUserId()];

            Account a = new Account(name = 'test', BillingCity = 'city'); 
            insert a;
            Account b =  new Account(name = 'search', BillingCity = 'city', BillingState = 'ST', BillingPostalCode ='PostalCode');
            insert b;
            
            Contact c = new Contact();
  
            c.title = currentUser.title;
            c.firstname = 'search';
            c.lastname = currentUser.lastname;
            //c.email = currentUser.email; 6-21-2019 charles.teague@pearson.com to accomodate data validation rule.
            c.email = 'qwertyuiop987654@notarealemail.net';
            c.phone = currentUser.phone;
            c.mobilephone = currentUser.mobilephone;
            c.fax = currentUser.fax;
            c.mailingstreet = currentUser.street;
            c.mailingcity = currentUser.city;
            c.mailingstate = currentUser.state;
            c.mailingpostalcode = currentUser.postalcode;
            c.mailingcountry = currentUser.country;
            c.AccountId = b.Id;
            insert c;       
            system.debug('*** contact name: ' + c.name); 
        
        test.startTest();
        createNote('Account', (string)a.Id);
        createNote('Contact', (string)c.Id);
        test.stopTest();
    }
    
    private static void createNote(string noteType, string Id){
            
        PageReference pr = Page.AccountContactSupportNotes;
        pr.getParameters().put('Id',Id);
        pr.getParameters().put('noteType', noteType);
        Test.setCurrentPage(pr);   
        
        // create the controller
        SupportNoteController ctl = new SupportNoteController();
        // set search values
        ctl.nameCriteria = 'search';
        ctl.cityCriteria = 'city';
        ctl.stateCriteria = 'ST';
        ctl.zipCriteria = 'PostalCode';
        // perform search
        ctl.search();
        
        //exercise page
        ctl.addAll();
        ctl.removeAll();
        ctl.save();
        ctl.addAll();
        
        ctl.note.name = 'test';
        ctl.note.message__c = 'test';
        ctl.save();
        
        
        
    }
}