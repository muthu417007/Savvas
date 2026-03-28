@isTest
public class SavLibraryCmpControllerTest {

    //content workspaces aren't available to create via apex, so test classes are super limited, the only thing we can do is query the number of workspaces 
    //in the system we're in and confirm that the picklist length returned by our method is appropriate. 
    public static testMethod void testCustomPicklist(){
        List<ContentWorkspace> workspaces =[Select Id, Name, DeveloperName FROM ContentWorkspace ORDER BY Name DESC NULLS LAST];
        
        SAVLibraryCmpController cont = new SAVLibraryCmpController();
        VisualEditor.DynamicPickListRows rows =  cont.getValues();
        
        System.assert(rows.size() == workspaces.size());
    }
    
    public static testMethod void testDefaultValue(){
        SAVLibraryCmpController cont = new SAVLibraryCmpController();
        VisualEditor.DataRow row = cont.getDefaultValue();
        
        System.assert(row != null);
    }
    
    @isTest
    static void testGetLibraryContents(){
        
        List<ContentWorkspace> libraries =[Select Id, Name, DeveloperName FROM ContentWorkspace ORDER BY Name DESC NULLS LAST];
        List<ContentDocument> controllerQueryResults;
        ContentWorkspace workspace;
        
        if(!libraries.isEmpty()){
            workspace = libraries.get(0);
            List<ContentDocument> libraryQueryResults = [SELECT Id,Title,FileType FROM ContentDocument WHERE ParentId = :workspace.Id];
            
            controllerQueryResults = SAVLibraryCmpController.getLibraryContents(workspace.Name);
            System.assert(controllerQueryResults.size() == libraryQueryResults.size());
        } else {
            controllerQueryResults = SAVLibraryCmpController.getLibraryContents('');
            System.assert(controllerQueryResults.isEmpty());
        } 
    }
    
}