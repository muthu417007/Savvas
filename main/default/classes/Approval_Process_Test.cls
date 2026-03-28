@isTest
public class Approval_Process_Test {
    public static testMethod void PossitiveCase(){
                Account CpQacc = new Account(name = 'Approval Test',Industry = 'Telecomm',billingcity = 'New York',BillingState='PA',BillingCountry='United States');
                insert CpQacc;
                ID oid = [select ID from User where userrole.name like '%AGM%' and Profile.Name = 'ICOM Sales Rep' and Isactive=true limit 1 ].id;
                Opportunity CpqOpp = new Opportunity(Name = 'Approval Opportunity', AccountId = CpQacc.Id, 
                                                     StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD',ownerid = oid );
                insert CpqOpp;
        
        		ID NonAGMOpp = [select ID from User where userrole.name like '%General%' and Profile.Name = 'ICOM Sales Mgr' and Isactive=true limit 1 ].id;
                Opportunity NonOpp = new Opportunity(Name = 'Approval Opportunity', AccountId = CpQacc.Id, 
                                                     StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD',ownerid = NonAGMOpp );
                insert NonOpp;
                //Insert valid Quote
        		CameleonCPQ__Quote__c cpqQuote = new CameleonCPQ__Quote__c(Name = 'Approval Quote',CameleonCPQ__Status__c = 'Needs_Review',CPQ_Mandatory_Flag__c  =true, CPQOpportunityId__c = CpqOpp.Id,CameleonCPQ__AccountId__c = CpQacc.Id);
        		insert cpqQuote;
       			//Approval submmi
                Approval.ProcessSubmitRequest appvalid = new Approval.ProcessSubmitRequest();
                appvalid.setObjectId(cpqQuote.id);
                Approval.ProcessResult result = Approval.process(appvalid);
        		
                
                ProcessInstance pi = [SELECT TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId = :cpqQuote.Id];   
                System.assertEquals(pi.TargetObjectId,cpqQuote.Id);
                System.Debug(pi);
                
        
        	               
                Test.StartTest();
        		schApprovalProcess obj=new schApprovalProcess();
                obj.execute(null);
                Test.StopTest();
        		
	}

}