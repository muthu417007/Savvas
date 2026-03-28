trigger SpendRequestApprovalsBeforeInsert on Gifting_Request__c (before insert) {
  
  
    //Getting Role Hierarchy
    Map<String, UserRole> roleMap = new Map<String, UserRole>();
    roleMap = new Map<String, UserRole>([SELECT Id, Name, parentRoleId FROM UserRole]); 
        
     User mgmUser =   [SELECT id, name FROM user WHERE id IN ( SELECT userOrGroupId FROM groupmember WHERE Group.Name = 'Spend Request MGM Marketing Approver') AND isActive = TRUE Limit 1];
     User financeUser = [SELECT id FROM user WHERE id IN ( SELECT userOrGroupId FROM groupmember WHERE Group.Name = 'Spend Request Marketing Finance Approver') AND isActive = TRUE Limit 1 ];
     Id mgmApproverId =  mgmUser.id;
     String mgmApprover =  mgmUser.name;
     Id financeApproverId = financeUser.id;  
     List <String> mgmRoleList = new List<String>();
       String financeArea; 
      Map<string,FinanceApprovers__c> mapFinApprovers = FinanceApprovers__c.getAll();  
          
       
     for( Gifting_Request__c gr : Trigger.new ){
         mgmRoleList.add( 'MGM ' + gr.sales_Market__c );
     }
      
     List<User> mgmUserList =  [Select u.id, u.Name, u.UserRoleId, u.UserRole.Name
                           From User u where u.UserRole.Name in :mgmRoleList and isActive = TRUE]; 
     Map<String,User> RoleNameToUserMap = new Map<string,user>();
     for(User u:mgmUserList){
        RoleNameToUserMap.put(u.UserRole.Name,u);
     }                      
  
                           
    for( Gifting_Request__c gr : Trigger.new )
    {
     
      // we calculate the approvers
        id roleId;
              
        Integer count = 1;
                
        
        
        if (gr.Department__c == 'Marketing') {
              // setting the values to be updated
              gr.MGM__c = mgmApproverId;
              gr.Finance_Approver__c = financeApproverId;                           
        } else {
           if (!String.isBlank(gr.Sales_Market__c)){
            
            //Sales
            String mgmRole = 'MGM ' + gr.sales_Market__c;
            mgmUser =  RoleNameToUserMap.get(mgmRole);
            
            mgmApproverId =  mgmUser.id;
            mgmApprover =  mgmUser.name;
            roleId = mgmUser.UserRoleId;
            
                                  
            //loop thru hierarchy to get parentRoles
            while (String.isEmpty(financeArea) && count<3){
           
                 if(roleMap!=null && roleMap.containsKey(roleId))
                    {
                        UserRole financeRole = roleMap.get(roleId);
                        if (financeRole.Name.contains('Sales South East')){
                           financeApproverId = mapFinApprovers.get('South East').Approver_User_Id__c;
                           financeArea = 'SOUTH EAST';
                             
                       }  
                       if (financeRole.Name.contains('Sales West')){
                          financeApproverId = mapFinApprovers.get('West').Approver_User_Id__c;
                          financeArea = 'WEST';
                       }  
                       if (financeRole.Name.contains('Sales North Central')){
                          financeApproverId = mapFinApprovers.get('North Central').Approver_User_Id__c;
                          financeArea = 'NORTH CENTRAL';
                       }  
                      roleId = financeRole.ParentRoleId;
                  }
                  count++; 
             }
            // setting the values to be updated
           gr.MGM__c = mgmApproverId;
           gr.Sales_Area__c = financeArea;
           gr.Finance_Approver__c = financeApproverId;
          }
        }
        //setting the automatic approval for values less than $12.50
       if (gr.Amount_per_person__c <= 12.50) {
           gr.Comments__c = 'Automatic Approval. Request less than $12.50.';
      }
       
    }     
      
}