public without sharing class pkb_ICOM_Controller{
    /*
    public final static String ARTICLE_TYPE_PARAM = 'at';
    
    public static String DEFAULT_SITE_NAME = Site.getName();
    
    
    public String articleType {
        get { return ApexPages.currentPage().getParameters().get(ARTICLE_TYPE_PARAM);}
    }
    
    public String articleTypeParam            { get { return ARTICLE_TYPE_PARAM; } }
    
    public pkb_ICOM_Controller pkbIcomCon { get { return this; } }
    
    public Boolean icomIsVisibleInPKB { get; protected set;}
    public pkb_ICOM_Controller(ApexPages.StandardController sc) {    
        KnowledgeArticle theArticle = (KnowledgeArticle)sc.getRecord();
        icomIsVisibleInPKB = false;
        if (theArticle != null && !isBlank(theArticle.Id)) {
            String l = ApexPages.currentPage().getParameters().get(pkb_Controller.LANGUAGE_PARAM);
            String selectedLanguage = '';
            if (!isBlank(l)) {
                selectedLanguage = String.escapeSingleQuotes(l);
            } else {
                String aux_lang = ApexPages.currentPage().getParameters().get('lang');
                if (!isBlank(aux_lang)) {
                    selectedLanguage = aux_lang;
                } else {
                    PKB__c kbSettings = PKB__c.getValues(DEFAULT_SITE_NAME);
                    Boolean multiLanguage =(kbSettings == null ? pkb_SettingsController.DEFAULT_MULTI_LANGUAGE : kbSettings.Multi_Language_Enabled__c);
                    if (!multiLanguage ) {
                        selectedLanguage = pkb_SettingsController.DEFAULT_LANGUAGE;
                    } else {
                        //use language from settings
                        String availableLanguages  = (kbSettings == null ? pkb_SettingsController.DEFAULT_LANGUAGE : kbSettings.Selected_Languages__c);
                        List<String> langs = (isBlank(availableLanguages) ? new List<String>{pkb_SettingsController.DEFAULT_LANGUAGE} : availableLanguages.split(';') );
                        selectedLanguage = langs.get(0);
                    }
                }
            }

            String q = '';
            String pub = pkb_Controller.DEFAULT_PUBLISH_STATUS;
            Id articleId = theArticle.Id;
            q += 'select isVisibleInPkb from KnowledgeArticleVersion';
            q += ' where PublishStatus = :pub and Language = :selectedLanguage and KnowledgeArticleId = :articleId limit 1';
            
            KnowledgeArticleVersion kav = (KnowledgeArticleVersion)Database.query(q);
            icomIsVisibleInPKB = kav.isVisibleInPkb;

        }
    }
    
    // jhicks 8/21/14
    public boolean printableView {get {return ApexPages.currentPage().getParameters().get('PrintableView') == 'true' ? true : false;}}
    
    public static Boolean isBlank(String s) {
        return ( s == null || s == '');
    }
    // url-formatted (e.g. key1=value1&key2=value2) string containing the params related to a search
    public String allSearchParams {
    get {
        String s;
         Map<String, String> params = ApexPages.currentPage().getParameters();
        List<String> keyValues = new List<String>();
        if(params.get(pkb_Controller.QUERY_PARAM)!=null)
        {
           keyValues.add(pkb_Controller.QUERY_PARAM+ '=' +EncodingUtil.urlEncode(params.get(pkb_Controller.QUERY_PARAM), 'UTF-8'));
        }
        if(params.get(pkb_Controller.LANGUAGE_PARAM)!=null)
        {
            keyValues.add(pkb_Controller.LANGUAGE_PARAM+ '=' +EncodingUtil.urlEncode(params.get(pkb_Controller.LANGUAGE_PARAM), 'UTF-8'));
        }
        if(params.get(pkb_Controller.CATEGORY_PARAM)!=null){
            keyValues.add(pkb_Controller.CATEGORY_PARAM+ '=' +EncodingUtil.urlEncode(params.get(pkb_Controller.CATEGORY_PARAM), 'UTF-8'));
        }
        if(params.get(pkb_Controller.CONTACT_US_PARAM)!=null)
        {
            keyValues.add(pkb_Controller.CONTACT_US_PARAM+ '=' +params.get(pkb_Controller.CONTACT_US_PARAM));
        }      
         if(params.get(ARTICLE_TYPE_PARAM)!=null)
        {
            keyValues.add(ARTICLE_TYPE_PARAM+ '=' +params.get(ARTICLE_TYPE_PARAM));
        }        
        
        // jhicks - added 8/21/14

         if(params.get('PrintableView')!=null)
        {
            keyValues.add('PrintableView' + '=' +params.get('PrintableView'));
        }   
        //             
        s = pkb_Controller.join(keyValues, '&');
      return s;
    }
  }
  */
 }