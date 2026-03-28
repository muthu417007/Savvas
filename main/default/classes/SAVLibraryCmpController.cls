global class SAVLibraryCmpController extends VisualEditor.DynamicPickList{

    //aura exposed search query that can be referenced in our js file, returns a content version list of documents for the given library name string
    @AuraEnabled(cacheable=true)
    public static List<ContentDocument> getLibraryContents(String libraryName) {

        ContentWorkspace workspace = [SELECT Id FROM ContentWorkspace WHERE Name = :libraryName LIMIT 1];
        List<ContentDocument> contentDocuments = new List<ContentDocument>();
        Integer maxTitleSize =35;
        
        for(ContentDocument doc: [SELECT Id,Title,FileType FROM ContentDocument WHERE ParentId = :workspace.Id]) {
                
                if(doc.Title.length() > maxTitleSize ){
    				doc.Title = doc.Title.substring(0, maxTitleSize);
				}
            contentDocuments.add(doc);
           
        }
             
        return contentDocuments;
    }

    //override super classes from abstract class for dynamic picklists.
    //we build the picklists based off of the workspaces available for authoring files
    global override VisualEditor.DataRow getDefaultValue(){

            List<ContentWorkspace> defaultWorkspace = [SELECT Id,Name, DeveloperName FROM ContentWorkspace WHERE Name = 'Savvas Community'];
            if (defaultWorkspace.size()>0) 
                return new VisualEditor.DataRow(defaultWorkspace[0].Name, defaultWorkspace[0].Name);
            
        
            return new VisualEditor.DataRow('---', '---');
    }

    global override VisualEditor.DynamicPickListRows getValues() {

        VisualEditor.DynamicPickListRows  picklistValues = new VisualEditor.DynamicPickListRows();

        for (ContentWorkspace workspace: [Select Id, Name, DeveloperName FROM ContentWorkspace ORDER BY Name DESC NULLS LAST]){
            picklistValues.addRow(new VisualEditor.DataRow(workspace.Name, workspace.Name));
        }

        return picklistValues;

    }

}