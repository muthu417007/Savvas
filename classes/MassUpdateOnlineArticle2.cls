global class MassUpdateOnlineArticle2 implements Database.Batchable < sObject > {
    global final List<String> articleNumberList;
    
        string objectName;                // name of article custom object
        string whereClause;				  // whereClause to identify articles that need to be updated
    
    global MassUpdateOnlineArticle2(string objectName, string whereClause) {
			this.objectName = objectName;
			this.whereClause = whereClause;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, ArticleNumber , KnowledgeArticleId FROM ' + this.objectName + ' WHERE PublishStatus = \'Online\' AND Language = \'en_US\' AND ' +
        		this.whereClause;
        system.debug('**** query: ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        List < String > articleNumbers = new List < String > ();
        for (Sobject s: scope) {
            String articleId = (String) s.get('KnowledgeArticleId');
            System.debug('Article Id: ' + articleId);
            Id draftArticleId = KbManagement.PublishingService.editOnlineArticle(articleId, true);  // returns new draft Article Id
            
            if (draftArticleId != null) {
                 articleNumbers.add((String)s.get('ArticleNumber'));
            }
        }
        
        List < String > articleIDsToPublish = new List < String > ();
        
        // Update newly created drafts
        List < sObject > articles = new List < sObject > ();
   	    String queryString = 'Select Id, ArticleNumber , KnowledgeArticleId FROM ' + this.objectName + ' WHERE PublishStatus = \'draft\' AND Language = \'en_US\'' +
        		' AND ArticleNumber IN: articleNumbers' ;
        List<sObject> draftArticles = database.query(queryString);
        
        for (sObject article: draftArticles ) {
        	/*************** this section of code will need to change based on requirements of user story *************************/
            article.put('IsVisibleInCsp', true);
        	/*************** END this section of code will need to change based on requirements of user story *************************/
            articleIDsToPublish.add((string) article.get('KnowledgeArticleId'));
            articles.add(article);
        }
        update articles;
        
        for (String articleId : articleIDsToPublish) {
            system.debug('Publishing ' + articleId);  
            KbManagement.PublishingService.publishArticle(articleId, true);
        }
        
    }
    global void finish(Database.BatchableContext BC) {
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob WHERE Id = : BC.getJobId()
        ];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {
            a.CreatedBy.Email
        };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Mass Article Update ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
            ' batches with ' + a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
            mail
        });
    }
}