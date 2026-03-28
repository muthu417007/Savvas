@isTest
public class AccountTriggerHandler_TEST {
    @isTest
    public static void test1(){
        /*test.startTest();
        Date olddate=Date.newInstance(2023, 12, 12);
        Account acc=new Account(name='Test1',Do_Not_Contact__c=false,Do_Not_Contact_End_Date__c=olddate,type='Public District');
        insert acc;
        
        Account childacc=new Account(name='TestChild1',Do_Not_Contact__c=false,ParentId=acc.Id,Do_Not_Contact_End_Date__c=olddate,type='Public District');
        insert childacc;
        
        acc.Do_Not_Contact__c=true;
        acc.Do_Not_Contact_End_Date__c=Date.newInstance(2026, 12, 9);
        acc.Do_Not_Contact_Reason__c='Test Purpose';
        update acc;
        test.stopTest();*/
    }
    
     @isTest
    public static void test2(){
        /*test.startTest();
        Date olddate=Date.newInstance(2028, 12, 12);
        Account acc=new Account(name='Test1',Do_Not_Contact__c=true,Do_Not_Contact_End_Date__c=olddate,Do_Not_Contact_Reason__c='Test',type='Public District');
        insert acc;
        
        Account childacc=new Account(name='TestChild1',Do_Not_Contact__c=false,ParentId=acc.Id,Do_Not_Contact_End_Date__c=olddate,type='Public District');
        insert childacc;
        
        acc.Do_Not_Contact__c=false;
        acc.Do_Not_Contact_End_Date__c=Date.newInstance(2026, 12, 9);
        //acc.Do_Not_Contact_Reason__c='Test Purpose';
        update acc;
        test.stopTest();*/
    }

}