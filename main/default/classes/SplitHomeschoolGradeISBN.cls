/* -----------------------------------------------------------------------------------------------------------------------
Name:        SplitHomeschoolGradeISBN
Description: This class is called from 'HomeSchool Online Access - CS Subflow' Flow. This will split selected Grades and its respective ISBN's 


Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
02/22/2022     1.0     Soundhariya       February Monthly release

-------------------------------------------------------------------------------------------------------------------------- */
public class SplitHomeschoolGradeISBN {
    @InvocableMethod (label='Split Homeschool Grade/ISBN')
    public static List<GradeISBNResponse> getGradeIsbnDetails(List<GetGradeISBN> inputFromFlow){
        system.debug('inputFromFlow--->'+inputFromFlow);
		CodeTitleWrapper productCodeTitleWrp;
        GetGradeISBN flowInput = inputFromFlow[0];	
		List<GradeISBNResponse> outputList = new List<GradeISBNResponse>();
		GradeISBNResponse flowOutput = new GradeISBNResponse();
		flowOutput.gradeDesc = '';
		flowOutput.titleISBNDesc = '';
		for(String grade : flowInput.selectedGradeList){
			productCodeTitleWrp = new CodeTitleWrapper();
			if(grade == '0' && flowInput.gradeISBNKGList.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 0@',flowInput.gradeISBNKGList);
				flowOutput.gradeKISBN = productCodeTitleWrp.codeVal;
				flowOutput.gradeKTitle = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- Kindergarden'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 0@',flowInput.gradeISBNKGList,'Kindergarden') + '\n' + '\n';
			}
			else if(grade == '1' && flowInput.gradeISBN1List.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 1@',flowInput.gradeISBN1List);
				flowOutput.grade1ISBN = productCodeTitleWrp.codeVal;
				flowOutput.grade1Title = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- 1st Grade'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 1@',flowInput.gradeISBN1List,'1st') + '\n' + '\n';
			}
			else if(grade == '2' && flowInput.gradeISBN2List.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 2@',flowInput.gradeISBN2List);
				flowOutput.grade2ISBN = productCodeTitleWrp.codeVal;
				flowOutput.grade2Title = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- 2nd Grade'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 2@',flowInput.gradeISBN2List,'2nd') + '\n' + '\n';
			}
			else if(grade == '3' && flowInput.gradeISBN3List.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 3@',flowInput.gradeISBN3List);
				flowOutput.grade3ISBN = productCodeTitleWrp.codeVal;
				flowOutput.grade3Title = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- 3rd Grade'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 3@',flowInput.gradeISBN3List,'3rd') + '\n' + '\n';
			}
			else if(grade == '4' && flowInput.gradeISBN4List.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 4@',flowInput.gradeISBN4List);
				flowOutput.grade4ISBN = productCodeTitleWrp.codeVal;
				flowOutput.grade4Title = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- 4th Grade'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 4@',flowInput.gradeISBN4List,'4th') + '\n' + '\n';
			}
			else if(grade == '5' && flowInput.gradeISBN5List.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 5@',flowInput.gradeISBN5List);
				flowOutput.grade5ISBN = productCodeTitleWrp.codeVal;
				flowOutput.grade5Title = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- 5th Grade'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 5@',flowInput.gradeISBN5List,'5th') + '\n' + '\n';
			}
			else if(grade == '6' && flowInput.gradeISBN6List.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 6@',flowInput.gradeISBN6List);
				flowOutput.grade6ISBN = productCodeTitleWrp.codeVal;
				flowOutput.grade6Title = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- 6th Grade'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 6@',flowInput.gradeISBN6List,'6th') + '\n' + '\n';
			}
			else if(grade == '7' && flowInput.gradeISBN7List.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 7@',flowInput.gradeISBN7List);
				flowOutput.grade7ISBN = productCodeTitleWrp.codeVal;
				flowOutput.grade7Title = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- 7th Grade'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 7@',flowInput.gradeISBN7List,'7th') + '\n' + '\n';
			}
			else if(grade == '8' && flowInput.gradeISBN8List.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 8@',flowInput.gradeISBN8List);
				flowOutput.grade8ISBN = productCodeTitleWrp.codeVal;
				flowOutput.grade8Title = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- 8th Grade'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 8@',flowInput.gradeISBN8List,'8th') + '\n' + '\n';
			}
			else if(grade == '9' && flowInput.gradeISBN9List.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 9@',flowInput.gradeISBN9List);
				flowOutput.grade9ISBN = productCodeTitleWrp.codeVal;
				flowOutput.grade9Title = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- 9th Grade'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 9@',flowInput.gradeISBN9List,'9th') + '\n' + '\n';
			}
			else if(grade == '10' && flowInput.gradeISBN10List.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 10@',flowInput.gradeISBN10List);
				flowOutput.grade10ISBN = productCodeTitleWrp.codeVal;
				flowOutput.grade10Title = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- 10th Grade'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 10@',flowInput.gradeISBN10List,'10th') + '\n' + '\n';
			}
			else if(grade == '11' && flowInput.gradeISBN11List.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 11@',flowInput.gradeISBN11List);
				flowOutput.grade11ISBN = productCodeTitleWrp.codeVal;
				flowOutput.grade11Title = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- 11th Grade'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 11@',flowInput.gradeISBN11List,'11th') + '\n' + '\n';
			}
			else if(grade == '12' && flowInput.gradeISBN12List.size()>0){					
				productCodeTitleWrp = populateGradeISBN(grade,'@Grade 12@',flowInput.gradeISBN12List);
				flowOutput.grade12ISBN = productCodeTitleWrp.codeVal;
				flowOutput.grade12Title = productCodeTitleWrp.titleVal;
				flowOutput.gradeDesc = flowOutput.gradeDesc+'- 12th Grade'+'\n';
				flowOutput.titleISBNDesc = flowOutput.titleISBNDesc + titleISBNformatting('@Grade 12@',flowInput.gradeISBN12List,'12th') + '\n' + '\n';
			}
		}
		system.debug('grade descr: '+flowOutput.gradeDesc);
		outputList.add(flowOutput);
		return outputList;
       
    }    
    public class GetGradeISBN{
        @InvocableVariable(required=true) public List<String> selectedGradeList;
		@InvocableVariable(required=true) public List<String> gradeISBNKGList;
        @InvocableVariable(required=true) public List<String> gradeISBN1List;
		@InvocableVariable(required=true) public List<String> gradeISBN2List;
		@InvocableVariable(required=true) public List<String> gradeISBN3List;
		@InvocableVariable(required=true) public List<String> gradeISBN4List;
		@InvocableVariable(required=true) public List<String> gradeISBN5List;
		@InvocableVariable(required=true) public List<String> gradeISBN6List;
		@InvocableVariable(required=true) public List<String> gradeISBN7List;
		@InvocableVariable(required=true) public List<String> gradeISBN8List;
		@InvocableVariable(required=true) public List<String> gradeISBN9List;
		@InvocableVariable(required=true) public List<String> gradeISBN10List;
		@InvocableVariable(required=true) public List<String> gradeISBN11List;
		@InvocableVariable(required=true) public List<String> gradeISBN12List;
		
    }	
	public class GradeISBNResponse {
		@InvocableVariable public String gradeKISBN;
		@InvocableVariable public String gradeKTitle;
		@InvocableVariable public String grade1ISBN;
		@InvocableVariable public String grade1Title;
		@InvocableVariable public String grade2ISBN;
		@InvocableVariable public String grade2Title;
		@InvocableVariable public String grade3ISBN;
		@InvocableVariable public String grade3Title;
		@InvocableVariable public String grade4ISBN;
		@InvocableVariable public String grade4Title;
		@InvocableVariable public String grade5ISBN;
		@InvocableVariable public String grade5Title;
		@InvocableVariable public String grade6ISBN;
		@InvocableVariable public String grade6Title;
		@InvocableVariable public String grade7ISBN;
		@InvocableVariable public String grade7Title;
		@InvocableVariable public String grade8ISBN;
		@InvocableVariable public String grade8Title;
		@InvocableVariable public String grade9ISBN;
		@InvocableVariable public String grade9Title;
		@InvocableVariable public String grade10ISBN;
		@InvocableVariable public String grade10Title;
		@InvocableVariable public String grade11ISBN;
		@InvocableVariable public String grade11Title;
		@InvocableVariable public String grade12ISBN;
		@InvocableVariable public String grade12Title;
		@InvocableVariable public String gradeDesc;
		@InvocableVariable public String titleISBNDesc;
	   
   }
   /*
    Method Name : populateGradeISBN
    Descrption : This method will split the Product title and Product ISBN code from the Title and Code combination
	and assign to the wrapper class variables.
   */
   public static CodeTitleWrapper populateGradeISBN(String gradeNo, String gradeVal,List<String> gradeISBNList){
	
		List<String> codeTitleList = new List<String>();
		String pdtCode;
		String pdtTitle; 
		List<String> pdtCodeList = new List<String>();
		List<String> pdtTitleList = new List<String>();
		CodeTitleWrapper wrap = new CodeTitleWrapper();
			for(string str : gradeISBNList){
				pdtCode = str.substringbefore(gradeVal).right(13);
				pdtTitle = str.substringbefore(' - '+pdtCode);
				pdtCodeList.add(pdtCode);
				pdtTitleList.add(pdtTitle);
			}			
			wrap.codeVal = String.join(pdtCodeList, '; ');
			wrap.titleVal = String.join(pdtTitleList, '; ');
			return wrap;
  }
     /*
    Method Name : titleISBNformatting
    Descrption : This method will format the Title and Code combination to display the Product details in Case descrption
   */
  public static String titleISBNformatting(String gradeVal, List<String> gradeISBNList,String gradeName){
	  String eachVal= '';
	  String formattedTitle;
	  for(String val : gradeISBNList){
		  eachVal = eachVal+'- '+val.substringbefore(gradeVal)+'\n';
	  }
	  formattedTitle = gradeName+' Product(s) Purchased:'+'\n'+eachVal;
	  return formattedTitle;
  }
  
	public class CodeTitleWrapper {
		public String codeVal;
		public String titleVal;
	}   
   
    
}