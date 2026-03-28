/**
 * Author: Salesforce Services
 * Controller to FAQ Article Type.
 */
public class ArticleExtensionFAQ extends ArticleExtension {
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
    
    public ArticleExtensionFAQ(ApexPages.KnowledgeArticleVersionStandardController controller) {
    	super(controller); 
        FAQ__kav kavRecord = [SELECT Id, Attachment_1__Name__s, Attachment_2__Name__s, Attachment_3__Name__s from FAQ__kav where Id= :articleVersion.id ]; 
        attachment1Name = kavRecord.Attachment_1__Name__s;
        attachment2Name = kavRecord.Attachment_2__Name__s;
        attachment3Name = kavRecord.Attachment_3__Name__s;        
        generateProblemDescriptior();
    }

    private void generateProblemDescriptior() {
        List < FAQ__DataCategorySelection > artDC = [SELECT Id, DataCategoryName, DataCategoryGroupName, ParentId FROM FAQ__DataCategorySelection WHERE ParentId = : articleVersion.id];
        if (!artDC.isempty()) {
           // productFamily = 'Product Family: ';
            // problemDescriptor = 'Problem Description: ';
            productFamily = new List<string>();
            problemDescriptor = new List<string>();
            for (FAQ__DataCategorySelection a: artDC) {
                if (a.DataCategoryName != 'All') {
                    if (a.DatacategoryGroupName == 'Product_Family') {
                        //if (productFamily != null && productFamily != '') {
                        //    productFamily += a.DataCategoryName + ',';
                        // }
   
   						productFamily.add(a.DataCategoryName);
                        existsProductFamily = true;
                       
                    } else if (a.DatacategoryGroupName == 'Problem_Descriptor') {
                       // if (problemDescriptor != null && problemDescriptor != '') {
                       //     problemDescriptor += a.DataCategoryName + '<br/>';
                       // }
                       
                       problemDescriptor.add(a.DataCategoryName);
                       existsProblemDescriptor = true;
                    }
                }
            }
           // productFamily = productFamily.substring(0, productFamily.length() - 1);
           // problemDescriptor = problemDescriptor.substring(0, problemDescriptor.length() - 5);
        }
    } */
}