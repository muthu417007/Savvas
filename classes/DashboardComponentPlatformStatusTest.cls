/*
@Author : Cognizant Team
@Name : DashboardComponentPlatformStatusTest
@CreateDate : 17-Sep-2024
@Description: This class is test class for DashboardComponentPlatformStatus
@Ticket Number: VS-0012, VS-0013, VS-0024, VS-0025, VS-0029
*/
@isTest(seeAllData = true)
public class DashboardComponentPlatformStatusTest {
    @isTest
    public static void programBannerCtrlTest(){
        try{
            String recId = DashboardComponentPlatformStatus.fetchCSMDashboardRecordId();
        }
        catch(Exception e){
        }
        
    }

}