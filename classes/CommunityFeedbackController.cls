public class CommunityFeedbackController {

    public Community_Feedback__c fbInfo {get; set;}
    public boolean recordSaved {get; set;}
    public string errorMsg {get; set;}

    // Create properties for the non-VF component input fields generated
    // by the reCAPTCHA JavaScript.
 
    public String captchaPublicKey { 
        get { return reCAPTCHA.publicKey; }
    }
    
    public String challenge { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_challenge_field');
        }
    }
    
    public String response  { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_response_field');
        }
    }    
    
    public Boolean captchaVerified { get; private set; }     
    
	public CommunityFeedbackController(ApexPages.StandardController ctrl) {
		fbInfo = new Community_Feedback__c();
        this.captchaVerified = false;
	    //fbInfo= (Community_Feedback__c) ctrl.getRecord();
        system.debug('***'+fbInfo.id);
        system.debug('***'+fbInfo.role__c);
	}
    
    
    public pageReference save() {
    	// validate all fields are not null
    	system.debug('***** fbInfo: ' + fbInfo.Role__c);
    	system.debug('***** fbInfo: ' + fbInfo.Suggestions__c);
    	if (fbInfo.Role__c==null &&
			fbInfo.Communities_Account__c== null &&
			fbInfo.Used_Support_Number__c== null &&
			fbInfo.Article_Search__c== null &&
			fbInfo.Helpful_Information__c== null &&
			fbInfo.Suggestions__c == '')  {
		     
		    errorMsg =  'Please complete one or more fields in order to submit Feedback';
                 return null;
			}
			
    	
        // Validate Captcha
        if (challenge =='' || challenge == null || response =='' || response== null) {
 		    errorMsg =  'Please complete the verification text prior to submitting.';
                 return null;
          }
        this.captchaVerified = reCAPTCHA.verify(challenge, response);         
        if(!this.captchaVerified) {
        	errorMsg = 'Verification text inacurrate. Please enter text as shown in image.';
         	return null;   
        }    
        
        insert fbInfo;
        recordSaved = true;
        return null;
    }
}