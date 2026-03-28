/**
 * An apex page controller that supports self registration of users in communities that allow self registration 
 * @date 2014-08-26
 * @author Wojciech Migas
 * @Modified Date 2024-08-06
 * @Modified By Cognizant Team
 * @Ticket Number: W-014716
 */
public without sharing class CommunitiesSelfRegController {

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String casenumber {get; set;}    
    /**
     * Class constructor
     * 
     * @date 2014-08-25
     * @author Wojciech Migas
     * @return void
     */
    public CommunitiesSelfRegController() {
        casenumber = ApexPages.currentPage().getParameters().get('caseNumber');
    }
    
    /**
     * Add page messages
     * 
     * @date 2014-08-26
     * @author Wojciech Migas
     * @param ApexPages.Severity severity Page message severity
     * @param String message Message text
     * @return void
     */
    private void addMessage(ApexPages.Severity severity, String message) {
        ApexPages.Message msg = new ApexPages.Message(severity, message);
        ApexPages.addMessage(msg);
    }

    /**
     * Create new user for fiven email address and case number
     * Method search for contact matching given email address which is associated with case matching given case number.
     * If there is matching contact, method checks if user has been created for the contact object. If not, check if nickname
     * is avialble. If yes, updates contact's details and create new user.
     * 
     * @date 2014-08-26
     * @author Wojciech Migas
     * @param ApexPages.Severity severity Page message severity
     * @param String message Message text
     * @return void
     */
    public PageReference registerUser() {
        
        if (email.contains('@pearson.com')) {
            addMessage(
                ApexPages.Severity.ERROR,
                '<font color="red"><b>Pearson Employees: If you submitted a case on behalf of your customer, and your email address is attached to the case email, you must enter through your Salesforce account. If you do not have a Salesforce account, talk to your manager about requesting access.<b></font>'
            );
            return null;
        }
        //@todo - discus if we have to check case record type and update case status
        //descision on 25-08-2014 - Not at this moment
        Contact c = PortalUtils.getContactByCaseNumberAndEmail(casenumber, email);
        if (c==null) {
            addMessage(
                ApexPages.Severity.ERROR,
                '<font color="red"><b>There is no case matching given case number and email address.<b></font>'
            );
            return null;
        }        
        /* W-014716: SSO implementation starts - check for existing user and based on condition display message to UI */
		Integer isContactExistFlag = PortalUtils.checkIfContactHasExistingUser(c.Id);
        if (isContactExistFlag != 0) {
            
            if(isContactExistFlag == 1){
                addMessage(
                	ApexPages.Severity.ERROR,
                	'<font color="red"><b>User already exists, if you forgot password, please use this <a href="' + PortalUtils.getUrlForPage(Page.ForgotPassword) + '">link</a><b></font>'
            	);
            }
            else if(isContactExistFlag == 2){
                addMessage(
                	ApexPages.Severity.INFO,
                	'<font color="green"><b>Access granted to the customer care community, please <a href="' + Site.getBaseUrl() + '/s/login">login</a> with your current credentials<b></font>'
            	);
            }  
            return null;
        }
        /** SSO Implementation end **/
        
        //we handle all expected error, so if there is any error below, it means that's something 
        //has been changed (model, validation rules etc)
        Savepoint sp = Database.setSavepoint();
        try {
            c.FirstName = firstName;
            c.LastName = lastName;

            User u = PortalUtils.createPortalUserFromContact(c);

            Integer counter = 0;
            while (PortalUtils.checkNickNameAvailability(u.CommunityNickname)==false) {
                String nicknameSuffix = String.valueOf(counter++);
                DateTime dt = Datetime.now();
                nicknameSuffix += String.valueOf(dt.getTime());
                u.CommunityNickname = u.CommunityNickname.left(40 - nicknameSuffix.length()) + nicknameSuffix;    
            }
            insert u;
            
            /** W-014715,W-014716: Display message afetr assigning PS and sending activation mail to new user **/
            if (PortalUtils.assignPSAndSendMail(u)) {
                addMessage(
                    ApexPages.Severity.INFO,
                    '<font color="green"><b>Thank you for submitting the form. Please check your inbox for the Community activation email.<b></font>'
                );
            } else {
                addMessage(
                    ApexPages.Severity.ERROR,
                    '<font color="red"><b>An unexpected error occured. Please try again.<b></font>'
                );
                return null;
            }
        } catch (Exception e) {
            ApexPages.Message msg = new ApexPages.Message(
                ApexPages.Severity.ERROR,
                'An unexpected error occured. Please try again.'
            );
            ApexPages.addMessage(msg);            
            Database.rollback(sp);
            PortalUtils.logException(e, 'CommunitiesSelfRegController::registerUser');
        }
        return null;
    }
}