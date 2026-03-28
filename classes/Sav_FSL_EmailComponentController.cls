/**
 * ClassName: Sav_FSL_EmailComponentController
 * Description: W-013981, W-013981, To send Approval Process mail to Consultant, Manager & Dispatcher 
 * Author: Prerna
 * Created Date: 4 FEB 2024
 * Version: v1.0
 * Work no : W-013981,W-013981
 */

public class Sav_FSL_EmailComponentController {
 public id recId {get;set;}
    public string step {get;set;}
    
    public AssignedResource showAR {
        get{
            AssignedResource aR = [SELECT Id,ServiceResource.Name, ServiceAppointment.Sav_FSL_Appointment_Number__c, ServiceAppointment.EarliestStartTime,ServiceAppointment.Sav_FSL_Alternate_Date_Time3__c,ServiceAppointment.Account.Name,ServiceAppointment.State,ServiceAppointment.Sav_FSL_Delivery_Mode__c,ServiceAppointment.Sav_FSL_SA_Program__c,ServiceAppointment.Sav_FSL_Service_Type__c,ServiceAppointment.Id,Sav_FSL_ServiceResourceUser__r.Manager.Name,ServiceAppointment.Description from AssignedResource WHERE Id =: recId];
            return aR;
        }private set;
    }
    
    public String managerEmail{
        get{
            ProcessInstanceWorkitem workItems = [
            SELECT Id, ProcessInstanceId 
            FROM ProcessInstanceWorkitem 
            WHERE ProcessInstance.TargetObjectId = :recId limit 1];
                        
            List<ProcessInstanceNode> process = [select ProcessNodeName, NodeStatus, ProcessInstance.Id from ProcessInstanceNode where ProcessInstance.Id =: workItems.ProcessInstanceId AND NodeStatus = 'Pending'];
            
            for(ProcessInstanceNode p : process){
                if(p.ProcessNodeName == 'Step 1')
                {
                  step = 'Step 1';
                 
                }
                else
                {
                  step = 'Step 2';  
                
                }
                
            }
            
            return step;
            
        } private set;
    }
    
  

}