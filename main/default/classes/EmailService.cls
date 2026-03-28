// Class Name: EmailService
// Description: Make callout to external Email Service
// Created By:
public class EmailService {
    
    EmailService()
    {        
    }
    
    //Fetching data from email service for ML api
    
    public static string GetData(string body)
    {         
        EmailServiceConfig__c emailServiceConfig = EmailServiceConfig__c.getOrgDefaults();
        
        try{
            HttpRequest request = new HttpRequest();
            request.setEndpoint(emailServiceConfig.host_url__c );//  ('http://3.22.96.64:8083/6/infer');
            request.setMethod('POST');
            request.setHeader('Content-Type', emailServiceConfig.Content_Type__c); //'application/json;charset=UTF-8'
           
            request.setBody(body);
            
            Http http = new Http();
            HTTPResponse res = http.send(request);
           
            return res.getBody();
        }catch (Exception e){
           
            return 'exception in case insert: '+e;
        }
    }
    
    //call the reconsilation service to update the ML server if classification is modified.  
    
    @future(callout=true)
    public static void UpdateData(string body)
    {       
        EmailServiceConfig__c emailServiceConfig = EmailServiceConfig__c.getOrgDefaults();
       
        try{
            HttpRequest request = new HttpRequest();
            request.setEndpoint(emailServiceConfig.RPAReConsciliation__c);//  ('http://3.22.96.64:8083/6/infer');
            request.setMethod('POST');
            request.setHeader('Content-Type', emailServiceConfig.Content_Type__c); //'application/json;charset=UTF-8'
           
            request.setBody(body);
            
            Http http = new Http();
            HTTPResponse res = http.send(request);
           
        } catch (Exception e){
            system.debug('exception in case update: '+e);
           // return 'exception in case update: '+e;
        }
    }
    
    
}