@isTest
public class TestStartAChatController {
    public static testMethod void testChatMethod1(){
        PageReference pageRef = Page.StartAChat;
      	Test.setCurrentPage(pageRef);
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
    	
        List<String> productList=new list<String>{'GradPoint','Pearson_Realize','Pearson_SuccessNet','SuccessMaker','SuccessNet_Plus'};
        list<Chat_Button_Settings__c> chatButtonSettingList=new list<Chat_Button_Settings__c>();
        For(String p:productList){
            Chat_Button_Settings__c cbs=new Chat_Button_Settings__c();
 			cbs.Name=p;
            
            String randStr = '';
            while (randStr.length() < 18) {
       			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
       			randStr += chars.substring(idx, idx+1);
    		}
            cbs.RecordIdOrURL__c=randStr;
        	cbs.Button__c=TRUE;
            chatButtonSettingList.add(cbs);
        }
        Chat_Button_Settings__c defaultBtn=new Chat_Button_Settings__c(Name='Default',RecordIdOrURL__c='DefaultButtonId');
        chatButtonSettingList.add(defaultBtn);
        Chat_Button_Settings__c defaultIcon=new Chat_Button_Settings__c(Name='Default Icon',RecordIdOrURL__c='DefaultIconURL');
        chatButtonSettingList.add(defaultIcon);
        Chat_Button_Settings__c OnlineIcon=new Chat_Button_Settings__c(Name='Online',RecordIdOrURL__c='OnlineIconURL');
        chatButtonSettingList.add(OnlineIcon);
        Chat_Button_Settings__c OfflineIcon=new Chat_Button_Settings__c(Name='Offline',RecordIdOrURL__c='OfflineIconURL');
        chatButtonSettingList.add(OfflineIcon);
        insert chatButtonSettingList;
        system.assertEquals(9,chatButtonSettingList.size());
        
        Test.startTest();
        StartAChatController controller=new StartAChatController();
        List<selectOption> options=controller.getPicklistvalues();
        system.assertEquals(6,options.size());
        For(String so:productList){
            controller.product=so;
            controller.selectProduct();
        }
        controller.product='Default';
        controller.selectProduct();
      	Test.stopTest();
    }
}