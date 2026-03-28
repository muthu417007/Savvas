/* --------------------------------------------------------------------------------------------
Name:        HomeSchoolGradeISBNClass
Description: This class is called from 'homeschoolDynamicGradeISBN' LWC component.
             1) This class will fetch the Grade and ISBN details from the Homeschool Grade ISBN Mapping metadata 
             2) Query the product description for the related ISBN and send the details to the LWC JS

Date         Version  Author             Summary of Changes
-----------  -------  -----------------  -------------------------------------------------------
02/22/2022     1.0     Soundhariya       February Monthly release

------------------------------------------------------------------------------------------------*/
public class HomeSchoolGradeISBNClass {
	@AuraEnabled(cacheable=true)  
    public static Map<String, List<String>> fetchISBNdetails(List<String> inputGrades){
        List<String> gradeList = new List<String>();
		List<String> isbnList = new List<String>();
		List<String> isbnFullList = new List<String>();
		Set<String> isbnFullSet = new Set<String>();
		Map<String,String> isbnDesc = new Map<String,String>();
        Map<String, List<String>> gradeISBNListMap = new Map<String, List<String>>();
		Map<String,List<String>> homeSchoolGradeISBNMap = new Map<String,List<String>>();
        system.debug('inputGrades: '+inputGrades);   
        for(String grade: inputGrades){
            gradeList.add('\''+grade+'\'');
        }
        List<Homeschool_Grade_ISBN_Mapping__mdt> homeschoolMeta = [Select ISBN__c,Grade__c from Homeschool_Grade_ISBN_Mapping__mdt where Grade__c in :inputGrades];
        if(homeschoolMeta.size()>0){
            for(Homeschool_Grade_ISBN_Mapping__mdt meta : homeschoolMeta){			
				  isbnList = meta.ISBN__c.split(';');
				  isbnFullList.addall(isbnList);
				  homeSchoolGradeISBNMap.put(meta.Grade__c, isbnList);
			}
			isbnFullSet.addAll(isbnFullList);
			system.debug('homeSchoolGradeISBNMap: '+homeSchoolGradeISBNMap);
			system.debug('isbnFullList: '+isbnFullList);
			system.debug('isbnFullSet: '+isbnFullSet);
			
            for(Digital_XREF__mdt prd : [Select id,Name__c,Bundle_ISBN__c from Digital_XREF__mdt where Bundle_ISBN__c in :isbnFullSet]){
				isbnDesc.put(prd.Bundle_ISBN__c,prd.Name__c);
            }
			for(String gradeData : homeSchoolGradeISBNMap.keyset()){
				for(String isbnData : homeSchoolGradeISBNMap.get(gradeData)){
					if(gradeISBNListMap.containskey(gradeData)){
						gradeISBNListMap.get(gradeData).add(isbnDesc.get(isbnData)+' - '+isbnData);
					}
					else{    
						gradeISBNListMap.put(gradeData, new List<String> {isbnDesc.get(isbnData)+' - '+isbnData});
					}
				}
				
			}
			
        }
        system.debug('gradeISBNListMap: '+gradeISBNListMap);          
        return gradeISBNListMap;
    }
}