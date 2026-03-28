/**
 * Author: Salesforce Services
 * Controller to Media Presentation Article Type.
 */
public class ArticleExtensionMediaPresentation extends ArticleExtension {
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
    public ArticleExtensionMediaPresentation(ApexPages.KnowledgeArticleVersionStandardController controller) {
        super(controller); 
        Media_Presentation__kav kavRecord = [SELECT Id, Attachment_1__Name__s, Attachment_2__Name__s, Attachment_3__Name__s from Media_Presentation__kav where Id= :articleVersion.id ]; 
        attachment1Name = kavRecord.Attachment_1__Name__s;
        attachment2Name = kavRecord.Attachment_2__Name__s;
        attachment3Name = kavRecord.Attachment_3__Name__s;        
        generateProblemDescriptior();
    }

    private void generateProblemDescriptior() {
        List < Media_Presentation__DataCategorySelection > artDC = [SELECT Id, DataCategoryName, DataCategoryGroupName, ParentId FROM Media_Presentation__DataCategorySelection WHERE ParentId = : articleVersion.id];
        if (!artDC.isempty()) {
            productFamily = new List<string>();
            problemDescriptor = new List<string>();
            for (Media_Presentation__DataCategorySelection a: artDC) {

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