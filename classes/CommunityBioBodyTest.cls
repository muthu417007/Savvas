/* -----------------------------------------------------------------------------------------------------------------------
Name: CommunityBioBodyTest
Description: Test Class for Community_Bio_Body created as part of W-012179

Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
19/12/2022     1.0     Soundhariya       Test Class for Community_Bio_Body created as part of W-012179
------------------------------------------------------------------------------------------------------------------------- */
@isTest
public class CommunityBioBodyTest{
    @isTest
    static void getBioBodyTest(){
        Test.startTest();    
        Community_Bio_Body.getBioBody('Christine_Bio');
        List<StaticResource> stResource = [SELECT Body FROM StaticResource  WHERE  Name = 'Christine_Bio'];
        system.assert(stResource.size()>=1);
        Test.stopTest();        
    }    
}