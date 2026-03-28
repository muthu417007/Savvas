public abstract class ArticleExtension {
    /*
    public string                      caseID {get; set;}
    public string                      kaID{get;set;}
    public boolean                     isPopup {get; set;}

    public SObject         articleVersion {get; set;}
    
    public List<CaseArticle> casesAttached;
    public List<KnowledgeArticleVersion> similarArticles;
    public List<KnowledgeArticleVersionHistory> articleHistory;
    public string keyWords;
    
    public ArticleExtension(ApexPages.KnowledgeArticleVersionStandardController controller) {

        articleVersion = (SObject) controller.getRecord();
        caseID = ApexPages.currentPage().getParameters().get('caseid');
        
        System.debug(articleVersion);
        
        kaID = (String)articleVersion.get('KnowledgeArticleId');
        
        
        if (ApexPages.currentPage().getParameters().get('popup') != null &&
            ApexPages.currentPage().getParameters().get('popup').equals('true'))
            isPopup = true;
        else isPopup = false;
        
    }
    
    public integer getNumOfCreatedArticleByAuthor(){
      Id articleVersionCreatedById = (Id)articleVersion.get('CreatedById');
      return 
        [SELECT 
            count() 
         FROM KnowledgeArticle
         WHERE 
           CreatedById =  :articleVersionCreatedById ];
    }
    
    public List<CaseArticle> getCasesAttached(){
      return ( kaID != null) ?
        [SELECT 
           CaseArticle.Id, 
           CaseArticle.CaseId, 
           CaseArticle.Case.CaseNumber, 
           CaseArticle.Case.OwnerId, 
           CaseArticle.Case.Subject 
         FROM 
           CaseArticle
         WHERE 
           CaseArticle.KnowledgeArticleId =  :kaID ] :
        new List<CaseArticle>();
    }
    
    public void attachToCase(){
        CaseArticle ca = new CaseArticle();
        ca.CaseID = caseID;
        ca.KnowledgeArticleId = kaID;
        insert ca;
    }
    
    // no longer used jhicks 10/9/14
    public List<KnowledgeArticleVersion> getSimilarArticles() {
        String strKeyword = (String)articleVersion.get('Title');
        if (articleVersion.get('Summary') != null) {
            strKeyword += ' ' + (String)articleVersion.get('Summary');
        }
        
        strKeyword = String.escapeSingleQuotes(strKeyword);
        
        String q = 'FIND \''+strKeyword +'\' IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, Title, ArticleNumber, Summary, KnowledgeArticleId, ArticleType,urlName where PublishStatus = \'online\' and Language = \''+ articleVersion.get('Language') +'\' and Id != \''+ articleVersion.get('Id')+'\') LIMIT 5';
        
        List<List<SObject>> searchList = Search.query(q);
        return (List<KnowledgeArticleVersion>) searchList[0];
    }

    public List < KnowledgeArticleVersionHistory > getArticleHistory(){
            if(articleHistory !=null){
                return articleHistory;
            }
            List < KnowledgeArticleVersionHistory > articleHistory2 = [SELECT CreatedById, CreatedBy.FirstName, CreatedBy.SmallPhotoUrl, CreatedBy.LastName FROM KnowledgeArticleVersionHistory WHERE ParentId = :kaID ];

            Map < String, KnowledgeArticleVersionHistory > mapArticleHistory = new Map < String, KnowledgeArticleVersionHistory > ();

            for (Integer i = 0; i < articleHistory2.size(); i++) {
                mapArticleHistory.put(articleHistory2[i].CreatedById, articleHistory2[i]);
            }
            articleHistory = mapArticleHistory.values();
            return articleHistory;
    }  */
}