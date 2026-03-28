public class CISO_Resource_List_Controller {
@AuraEnabled(cacheable=true)
    public static List<ContentDocument> getFolderContents(String Folder_Name) {
        
		ContentFolder Folder=[Select Id,Name from ContentFolder Where Name = :Folder_Name];
        List<ContentDocument> contentDocuments = new List<ContentDocument>();
        Integer maxTitleSize =50;
		List<ContentFolderItem> Folder_Items =[SELECT Id FROM ContentFolderItem where ParentContentFolderId =:Folder.Id];  
        for(ContentFolderItem Folder_Item : Folder_Items )
        {
             for(ContentDocument doc: [SELECT Id,Title,Description,FileType FROM ContentDocument Where Id =: Folder_Item.Id]) 
         		{
                
                if(doc.Title.length() > maxTitleSize ){
    				doc.Title = doc.Title.substring(0, maxTitleSize);
				}
            	contentDocuments.add(doc);
           
			}
        }       
             
        return contentDocuments;
        }
}