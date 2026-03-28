global class MassUpdateOnlineArticle { /* implements Database.Batchable < sObject > {

    global final List<String> articleNumberList;
    global MassUpdateOnlineArticle() {
      //  articleNumberList = xArticleNumbers.split(',');
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, ArticleNumber , KnowledgeArticleId FROM Faq__kav WHERE PublishStatus = \'Online\' AND Language = \'en_US\' AND ValidationStatus=\'Released External\' AND  IsVisibleInPkb=false';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        List < String > articleNumbers = new List < String > ();
        for (Sobject s: scope) {
            String articleId = (String) s.get('KnowledgeArticleId');
            System.debug('Article Id: ' + articleId);
            Id draftArticleId = KbManagement.PublishingService.editOnlineArticle(articleId, true);
            if (draftArticleId != null) {
                articleNumbers.add((String)s.get('ArticleNumber'));
            }
        }
        
        List < String > articleIDsToPublish = new List < String > ();
        
        // Update PKB Visisbility to true..
        List < FAQ__kav > articles = new List < FAQ__kav > ();
        for (FAQ__kav aricle: [SELECT Id, KnowledgeArticleId FROM FAQ__kav
            WHERE PublishStatus = 'draft'
            AND Language = 'en_US'
            AND ArticleNumber IN: articleNumbers
        ]) {
            aricle.IsVisibleInPkb = true;
            articleIDsToPublish.add(aricle.KnowledgeArticleId);
            articles.add(aricle);
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
    } */
}