trigger CaseCommissionSharing on Case (after insert) {
    List<CaseShare> csl = new List<CaseShare>();
    List<id> caseOwners = new List<id>();
    for(Case c:trigger.New){
      caseOwners.add(c.OwnerId);
    }
    system.debug(caseOwners);
    Map<Id,User> UserMap = new Map<Id,User>([select id, ManagerId, Manager.ManagerId, Manager.Manager.UserRole.Name from User where id in:caseOwners]);
    system.debug(UserMap);
    RecordType FinanceWorkflowRecordType = [select id from RecordType where DeveloperName='Finance_Workflow' limit 1];
    for(Case c : trigger.new){
        if(c.RecordTypeId==FinanceWorkflowRecordType.id){
            CaseShare csRep = new CaseShare();
            csRep.CaseId = c.Id;
            csRep.CaseAccessLevel='Read';
            csRep.UserOrGroupId = c.Sales_Rep_Name__c;
            csl.add(csRep);
            
            if(UserMap.get(c.OwnerId).ManagerId != null){
                CaseShare csMan = new CaseShare();
                csMan.CaseId = c.Id;
                csMan.CaseAccessLevel='Edit';
                csMan.UserOrGroupId = UserMap.get(c.OwnerId).ManagerId;
                csl.add(csMan);
            
                if(UserMap.get(c.OwnerId).Manager.ManagerId != null){
                    if(UserMap.get(c.OwnerId).Manager.Manager.UserRole.Name != 'Managing Director Higher Ed'){
                        CaseShare csManMan = new CaseShare();
                        csManMan.CaseId = c.Id;
                        csManMan.CaseAccessLevel='Edit';
                        csManMan.UserOrGroupId = UserMap.get(c.OwnerId).Manager.ManagerId;
                        csl.add(csManMan);
                    }
                }
            }
        }
    }
    system.debug(csl);
    if(csl.size()>0){
        Database.SaveResult[] lsr = Database.insert(csl,false);
    }
}