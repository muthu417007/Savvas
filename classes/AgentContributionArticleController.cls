public class AgentContributionArticleController {
    /*
    // The constructor must take a ApexPages.KnowledgeArticleVersionStandardController as an argument
    public AgentContributionArticleController(ApexPages.KnowledgeArticleVersionStandardController ctl) {
        SObject article = ctl.getRecord();   //this is the SObject for the new article. 
                                             //It can optionally be cast to the proper article type, e.g. FAQ__kav article = (FAQ__kav) ctl.getRecord();
       
        System.debug( article);
        String sourceId = ctl.getSourceId(); //this returns the id of the case that was closed.
        Case c = [select subject, Problem_Resolution__c, Problem_Descriptor_Map__c, Product_Family__c from Case where id=:sourceId];
        System.debug(c);
        article.put('title', c.subject);  //this overrides the default behavior of pre-filling the title of the article with the subject of the closed case. 
        article.put('Details__c',c.Problem_Resolution__c);  
        
        //set case values to string
        string descriptorField = c.Problem_Descriptor_Map__c;
        string productfamilyField = c.Product_Family__c;
        
        //Define X. Data Category internal names cannot start with a number, so SFDC prepends an 'X' to the internal name
        string prependedChar = 'X';
        
        //regular expressions to be used for replacing
        string underscoreChar = '_';
        string specialCharPatterns = '[ /-]+';
        string ampersandPattern = ' & ';
        string spacedashspacePattern = ' - ';
        string poundPattern = ' # ';
        
        if (descriptorField != null) {

            //Problem Descriptor Map field: replace special chars with underscores
            descriptorField = descriptorField.replaceAll(ampersandPattern, underscoreChar);
            descriptorField = descriptorField.replaceAll(spacedashspacePattern, underscoreChar);
            descriptorField = descriptorField.replaceAll(poundPattern, underscoreChar);
            descriptorField = descriptorField.replaceAll(specialCharPatterns, underscoreChar);
            
            //Check if name begins with a number before assigning it to a data category
            string firstdescriptorChar = descriptorField.left(1);
            
            if (firstdescriptorChar.IsNumeric()){
                descriptorField = prependedChar + descriptorField;
            }
            
            //add the case values to the data categories
            ctl.selectDataCategory('Problem_Descriptor', descriptorField);  //Only one category per category group can be specified.
        }
            
        if (productfamilyField != null) {

            //Product Family field: replace special chars with underscores
            productfamilyField = productfamilyField.replaceAll(ampersandPattern, underscoreChar);
            productfamilyField = productfamilyField.replaceAll(spacedashspacePattern, underscoreChar);
            productfamilyField = productfamilyField.replaceAll(poundPattern, underscoreChar);
            productfamilyField = productfamilyField.replaceAll(specialCharPatterns, underscoreChar);
            
            //Check if name begins with a number before assigning it to a data category
            string firstproductfamilyChar = productfamilyField.left(1);
        
            if (firstproductfamilyChar.IsNumeric()){
                productfamilyField = prependedChar + productfamilyField;
            }
        
            //add the case values to the data categories
            ctl.selectDataCategory('Product_Family', productfamilyField); //Only one category per category group can be specified.
        }
    } */
}