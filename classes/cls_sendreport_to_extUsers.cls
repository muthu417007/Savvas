/*
Class Name: cls_sendreport_to_extUsers
Purpose : This class is used to send report to external users(Pearson Employees) who are not in salesforce.
          Utilize ApexReport__mdt metadata type to configure Email addresses, Email body and Subject. Use Metadata lable
          to configure report(use report developer name) which to send in email.
          
*/
public class cls_sendreport_to_extUsers{

    /*
        toemails : to Emails - configured in Custom metadata type ApexReport__mdt
        Emailbody : Body of the email - configured in Custom metadata ApexReport__mdt
        Subject : Email Subject - configured in Custom metadata ApexReport__mdt
    */
    @future(callout=true)
    public static void sendReport(string rptDevloperName,List<string> toemails,string Emailbody,string Subject){
        try{
            System.Debug('rptDevloperName+++'+rptDevloperName);
            List <Report> reportList = [SELECT Id,DeveloperName,Name FROM Report where DeveloperName =:rptDevloperName];
            if(reportList.size()>0){
                String reportId = (String)reportList.get(0).get('Id');
                
                //Get Report Name
                string reportName=(String)reportList.get(0).get('Name');
                
                
                Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
                Blob content =null;
                if(!Test.isRunningTest()){
                    //get instance Url
                    String instanceName = URL.getSalesforceBaseUrl().toExternalForm();
                    string url=instanceName+'/servlet/PrintableViewDownloadServlet?isdtp=p1&reportId='+reportId;
                    ApexPages.PageReference objPage = new ApexPages.PageReference(url);
                    content=objPage.getContent();
                }
                
                Messaging.EmailFileAttachment objMsgEmailAttach = new Messaging.EmailFileAttachment();
                objMsgEmailAttach.setFileName(reportName+'.xls');
                
                objMsgEmailAttach.setBody(content);
                objMsgEmailAttach.setContentType('text/xls');
                email.setSubject(Subject);
                
                List<Messaging.EmailFileAttachment> attach=new List<Messaging.EmailFileAttachment>();
                attach.add(objMsgEmailAttach);
                email.setFileAttachments(attach);  
                
                cls_EmailService  service=new cls_EmailService(email);
                service.body= Emailbody; 
                service.isHtml=true;
                service.toAddresses=toemails;
                service.displayName='Salesforce report';
                service.subject=reportName;
                service.sendMail();
            }
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
        }
    
    }

}