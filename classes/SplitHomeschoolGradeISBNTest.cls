/* -----------------------------------------------------------------------------------------------------------------------
Name:        SplitHomeschoolGradeISBNTest
Description: This is test class for SplitHomeschoolGradeISBN.
Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
02/22/2022     1.0     Soundhariya      Initial Release
-------------------------------------------------------------------------------------------------------------------------- */
@isTest
public class SplitHomeschoolGradeISBNTest {
	@isTest(seeAllData = false)
	public static void getOrdersTest(){
		List<String> selectedGrades = new List<String>{'0','1','2','3','4','5','6','7','8','9','10','11','12'};
		List<String> gradeKGProducts = new List<String>{'Test-9123456789123@Grade 0@'};
		List<String> grade1Products = new List<String>{'Test-9123456789123@Grade 1@'};
		List<String> grade2Products = new List<String>{'Test-9123456789123@Grade 2@'};
		List<String> grade3Products = new List<String>{'Test-9123456789123@Grade 3@'};
		List<String> grade4Products = new List<String>{'Test-9123456789123@Grade 4@'};
		List<String> grade5Products = new List<String>{'Test-9123456789123@Grade 5@'};
		List<String> grade6Products = new List<String>{'Test-9123456789123@Grade 6@'};
		List<String> grade7Products = new List<String>{'Test-9123456789123@Grade 7@'};
		List<String> grade8Products = new List<String>{'Test-9123456789123@Grade 8@'};
		List<String> grade9Products = new List<String>{'Test-9123456789123@Grade 9@'};
		List<String> grade10Products = new List<String>{'Test-9123456789123@Grade 10@'};
		List<String> grade11Products = new List<String>{'Test-9123456789123@Grade 11@'};
		List<String> grade12Products = new List<String>{'Test-9123456789123@Grade 12@'};
		
        List<SplitHomeschoolGradeISBN.GetGradeISBN> inputList = new List<SplitHomeschoolGradeISBN.GetGradeISBN>();
        SplitHomeschoolGradeISBN.GetGradeISBN inputFromFlow  = new SplitHomeschoolGradeISBN.GetGradeISBN();
        inputFromFlow.selectedGradeList = selectedGrades;
        inputFromFlow.gradeISBNKGList = gradeKGProducts;
		inputFromFlow.gradeISBN1List = grade1Products;
		inputFromFlow.gradeISBN2List = grade2Products;
		inputFromFlow.gradeISBN3List = grade3Products;
		inputFromFlow.gradeISBN4List = grade4Products;
		inputFromFlow.gradeISBN5List = grade5Products;
		inputFromFlow.gradeISBN6List = grade6Products;
		inputFromFlow.gradeISBN7List = grade7Products;
		inputFromFlow.gradeISBN8List = grade8Products;
		inputFromFlow.gradeISBN9List = grade9Products;
		inputFromFlow.gradeISBN10List = grade10Products;
		inputFromFlow.gradeISBN11List = grade11Products;
		inputFromFlow.gradeISBN12List = grade12Products;
        inputList.add(inputFromFlow);
        Test.startTest();     
        system.assert(SplitHomeschoolGradeISBN.getGradeIsbnDetails(inputList).size()>0);
        Test.stopTest();
	}
	
}