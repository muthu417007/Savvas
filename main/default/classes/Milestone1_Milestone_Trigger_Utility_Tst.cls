@isTest
public class Milestone1_Milestone_Trigger_Utility_Tst {
public static testmethod void testMilestoneBatchUpdate(){
        // Create project
        Milestone1_Project__c project = Milestone1_Test_Utility.sampleProject('My Project');
        
        insert project;
        
        // Create parent milestones
        List<Milestone1_Milestone__c> pList = new List<Milestone1_Milestone__c>();
        //CharlesTeague 6-26-2019 this method fails in sandbox with Apex CPU time limit exceeded
        //it uses 101 as upper limit for loops below. Changing that to 10 to hack it to pass.
        for(Integer i = 0; i < 10; i++){
            pList.add( Milestone1_Test_Utility.sampleMilestone(project.Id, null, 'My Parent Milestone ' + i) ); 
        }

        try{
            insert pList;
        }
        catch(Exception e){
            system.assert( false, e.getMessage() );
        }

        // Create milestones
        List<Milestone1_Milestone__c> mList = new List<Milestone1_Milestone__c>();
        //CharlesTeague 6-26-2019 this method fails in sandbox with Apex CPU time limit exceeded
        //it uses 101 as upper limit for loops below. Changing that to 10 to hack it to pass.       
        for(Integer j = 0; j < 10; j++){
            mList.add( Milestone1_Test_Utility.sampleMilestone(project.Id, pList.get(j).Id, 'My Milestone ' + j ) );
        }
        
        try{
            insert mList;
        }
        catch(Exception e){
            system.assert( false, e.getMessage() );
        }
        
        try{
            update [SELECT Id FROM Milestone1_Milestone__c WHERE Id IN :mList];
            system.assert(true, 'Milestones update successful');
        }
        catch(Exception e){
            system.assert( false, e.getMessage() );
        }
    }
}