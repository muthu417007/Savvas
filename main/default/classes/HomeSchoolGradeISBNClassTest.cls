/* -----------------------------------------------------------------------------------------------------------------------
Name:        HomeSchoolGradeISBNClassTest
Description: This is test class for HomeSchoolGradeISBNClass.
Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
02/22/2022     1.0     Soundhariya      Initial Release
-------------------------------------------------------------------------------------------------------------------------- */
@isTest
public class HomeSchoolGradeISBNClassTest {
	@testsetup
	public static void testsetUp(){
		TestDataFactory.createProduct('Test1','9781418364113','HANDWRITING 2022 HOMESCHOOL PRINT AND DIGITAL ACCESS 1-YEAR GRADE K');
	}
	@isTest(seeAllData = false)
	public static void getGradesTest(){
		List<String> gradeList = new List<String>();
		gradeList.add('0');
		Test.startTest();
        	system.assert(HomeSchoolGradeISBNClass.fetchISBNdetails(gradeList).size() > 0);
        Test.stopTest();
	}
	
}