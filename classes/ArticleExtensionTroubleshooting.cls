/**
 * Author: Salesforce Services
 * Controller to FAQ Article Type.
 */
public class ArticleExtensionTroubleshooting extends ArticleExtension {
    /*
    public List<string> productFamily {
        get;
        set;
    }
    
  
    public boolean existsProductFamily{
    	get;
    	set;
    }  
    
    public List<string> problemDescriptor {
        get;
        set;
    }
  
    public boolean existsProblemDescriptor{
    	get;
    	set;
    }  

    public string attachment1Name {
		get;
        set;
    }    

    public string attachment2Name {
		get;
        set;
    }

    public string attachment3Name {
		get;
        set;
    } 
    public ArticleExtensionTroubleshooting(ApexPages.KnowledgeArticleVersionStandardController controller) {
        super(controller); 
        Troubleshooting__kav kavRecord = [SELECT Id, Attachment_1__Name__s, Attachment_2__Name__s, Attachment_3__Name__s from Troubleshooting__kav where Id= :articleVersion.id ]; 
        attachment1Name = kavRecord.Attachment_1__Name__s;
        attachment2Name = kavRecord.Attachment_2__Name__s;
        attachment3Name = kavRecord.Attachment_3__Name__s;        
        generateProblemDescriptior();
    }

    private void generateProblemDescriptior() {
        List < Troubleshooting__DataCategorySelection > artDC = [SELECT Id, DataCategoryName, DataCategoryGroupName, ParentId FROM Troubleshooting__DataCategorySelection WHERE ParentId = : articleVersion.id];
        if (!artDC.isempty()) {
            productFamily = new List<string>();
            problemDescriptor = new List<string>();
            for (Troubleshooting__DataCategorySelection a: artDC) {

 
                if (a.DataCategoryName != 'All') {
                    if (a.DatacategoryGroupName == 'Product_Family') {
   						productFamily.add(a.DataCategoryName);
                        existsProductFamily = true;
                    } else if (a.DatacategoryGroupName == 'Problem_Descriptor') {
                       problemDescriptor.add(a.DataCategoryName);
                       existsProblemDescriptor = true;
                    }
                }
            }
        }
    } */
}