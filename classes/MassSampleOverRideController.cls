public class MassSampleOverRideController {

    public MassSampleOverRideController(ApexPages.StandardController controller) {
        String SampleRequestID = ApexPages.CurrentPage().getParameters().get('id');

    }
    public PageReference launchMassSample(){
        String SampleRequestID = ApexPages.CurrentPage().getParameters().get('id');
       	SampleRequest__c sample = [Select ID,Number_of_Contacts__c,Number_of_Generic_Contacts__c from SampleRequest__c where ID=:SampleRequestId];
        if((sample.Number_of_Generic_Contacts__c== 0 && sample.Number_of_Contacts__c == 0)){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Request does not contain any account/contact');
            ApexPages.addMessage(myMsg);
        }else{
            return new PageReference('/apex/MassSampleIFRAME?id='+SampleRequestID);
        }
        return null;
    }

}