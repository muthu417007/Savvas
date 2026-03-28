Public without sharing class PortalUserProvisioning  implements Database.Batchable<sObject>, Database.Stateful {



     // global variables for stats
        
        integer recordsCreated = 0;
        integer errorsFound = 0;

        List<string> errorLog = new List<string>();
        
        string whereClause;
        string userNameSuffix;
    

    /*  This batch class is called with two parameters:
    *   (1) the Where clause for determining which Contact records to process (in single quotes)
    *   (2) the User Name suffix (sandbox name) to assign to the User Name field.  If running
    *       in Production, this should be a set of single quotes with nothing between them.
    *   
    *    How to invoke batch from Developer Console (Execute Anonymous Window):
    
    *        Database.executeBatch(new PortalUserProvisioning('createdDate >= system.today.addDays(-366) and account.premier__c == true','ICOM5R2DEV'));

    *    will create a user with their email address + '.ICOM5R2DEV' as the user name.
    
    *        Database.executeBatch(new PortalUserProvisioning('createdDate >= system.today.addDays(-366) and account.premier__c == true',''));

    *    will create a user with their email address  as the user name (for Production)
    */
       
    public PortalUserProvisioning(string whereClause, string userNameSuffix) {
    	
    	this.whereClause = whereClause;
    	
    	this.userNameSuffix = userNameSuffix == '' ? '' : '.'+userNameSuffix;
    	
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        
        	string query = 'select Id, FirstName, LastName, Email from Contact where ' + this.whereClause;
            
			system.debug('**** [PortalUserProvisioning] Query: ' + query);
			
       		 return Database.getQueryLocator(query);

    }   
    
    /*
    *
    */
    
    public void execute(Database.BatchableContext BC, List<Contact> contacts){
        
		List<User> users = new List<User>();       

        for (Contact c : contacts) {
        	user u = PortalUtils.createPortalUserFromContact(c, this.userNameSuffix);
        	if (u != null)
        	    users.add(u);
        	else {
        		string s =  c.Id + ',' + c.firstName+' '+c.lastName +','+c .email+','+ 'Unable to create User record.\n';
        		errorLog.add(s);
        	}
	    }			

			 
			
			Database.SaveResult[] results = database.insert(users, false);
			   
		        For (integer i = 0; i < results.size(); i++ ){
			    	//system.debug('*****: i: ' +i);
		              if (!results[i].isSuccess()) {
		                Database.Error[] e = results[i].getErrors();
						String s =  users[i].contactId + ',' + users[i].firstName+' '+users[i].lastName +','+users[i].email+','+users[i].userName+','+e[0].getMessage()+'\n';
						errorLog.add(s);
						errorsFound++;
						system.debug('***** error: ' + s);
		              }
		              else {
		              		recordsCreated++;
		              }
				   				
			   	}	   		
        
  		
            
    }
    
    public void finish(Database.BatchableContext BC){


			string content = 'Contact Id, Contact Name,Email,UserName, Error Message\n';
			for (String e : errorLog) 
				content += e;
 
			/* create email & attachment & send to user running this process */
			List<messaging.EmailFileAttachment> attachments = new List<messaging.EmailFileattachment>();
 			messaging.EmailFileAttachment att = new messaging.Emailfileattachment();
 			att.setBody(blob.valueOf(content));
 			att.setContentType('plain/txt');
 			att.setFileName('User Provisioning Stats.csv');
       		attachments.add(att);

			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			List<string> toAddresses = new List<string>();
			toAddresses.add(userInfo.getUserEmail());
			mail.setToAddresses(toAddresses);
			String dtTag = System.now().format('MM/dd/yyyy HH:mm');
			string subject = 'User Provisioning Stats - ' + dtTag;
			
			mail.setSubject(subject);
			string msgText = 'User Records Created: ' + recordsCreated +
			                  '.\n Errors Found: ' + errorsFound+'\n\n' +  'Refer to attached file for error details.';
			system.debug('***** msgText: ' + msgText);
			mail.setPlainTextBody(msgText);
       		mail.setFileAttachments(attachments);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });


    }

}