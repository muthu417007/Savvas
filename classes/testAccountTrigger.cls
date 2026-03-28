@istest
public class testAccountTrigger {
    public static testMethod void testAccountDoNotContactTrigger(){

        /*Recordtype r = [select ID, name,isactive,SobjectType from recordtype where sObjectType='Account' and name like '%Schools%' limit 1];
        Account parentAcc=new Account(Name='Parent Account',Recordtypeid=r.Id,type='Public District');
        insert parentAcc;
        Account ChildAcc=new Account(Name='Child Account', Recordtypeid=r.Id,type='Public School',parentid=parentAcc.id);
        insert ChildAcc;
        Account GrandChildAcc=new Account(Name='GrandChild Account',Recordtypeid=r.Id,type='Public School',parentid=ChildAcc.id);
        insert GrandChildAcc;
        
        parentAcc.Do_Not_Contact__c=True;
        parentAcc.Do_Not_Contact_End_Date__c=Date.Today()+10;
        parentAcc.Do_Not_Contact_Reason__c='Do Not Contact Account';
        update parentAcc; 
        
        Integer NumDoNotContactAcc=[Select count() from account where Do_Not_Contact__c=True];
        system.assertEquals(2,NumDoNotContactAcc);*/
    }

}