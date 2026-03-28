/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_ChangePasswordController
    @CreateDate : 04-June-2024
    @Description: This class is handler for set password functionality.
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 04-June-2024
    @Ticket Number: W-014596
*/
public with sharing class Savvas_SSO_ChangePasswordController {

    // Variables
    public String newPassword {get; set {newPassword = value == null ? value : value.trim(); }}
    public String verifyNewPassword {get; set {verifyNewPassword = value == null ? value : value.trim(); }} 
    public String charactersIcon {get; set;}
    public String letterIcon {get; set;}
    public String numbersIcon {get; set;}
    public String specialCharacterIcon {get; set;}
    public String charactersColor {get; set;}
    public String letterColor {get; set;}
    public String numberColor {get; set;}
    public String specialCharacterColor {get; set;}
    public String logoutUrl {get; set;}
    public Boolean verifyPWDError {get; set;}
    public String verifyPWDStyle {get; set;}
    public Boolean newPasswordEmptyError {get; set;}
    public Boolean verifyPWDEmptyError {get; set;}
    public String errorMessage {get; set;}
    Public Boolean errorCheck {get; set;}
    
    // Constructor
    public Savvas_SSO_ChangePasswordController() {
        charactersIcon = Savvas_SSO_ConstantsUtil.ellipse;
        letterIcon = Savvas_SSO_ConstantsUtil.ellipse;
        numbersIcon = Savvas_SSO_ConstantsUtil.ellipse;
        specialCharacterIcon = Savvas_SSO_ConstantsUtil.ellipse;
        logoutUrl = Savvas_SSO_ConstantsUtil.logoutUrl;
        verifyPWDError = False;
        verifyPWDStyle = Savvas_SSO_ConstantsUtil.vrfyPwdInput;
        newPasswordEmptyError = False;
        verifyPWDEmptyError = False;
        errorCheck = false;
    }
    
    /*
    *  Method Name : changePassword
    *  Description : Different validations for password change
    *  param : NA
    *  return : PageReference
    */
    public PageReference changePassword() {
        try{
            if(String.isNotBlank(newPassword)){
                newPasswordEmptyError = False;
                if(String.isNotBlank(verifyNewPassword)){
                    verifyPWDEmptyError = False;
                        verifyPWDError = True;
                        verifyPWDStyle = Savvas_SSO_ConstantsUtil.vrfyPwdInputError;
                    if(charactersIcon != Savvas_SSO_ConstantsUtil.ellipse){
                        if(newPassword.length()>=8 && !(verifyNewPassword.length()>=8)){
                            charactersIcon = Savvas_SSO_ConstantsUtil.redCross;
                            charactersColor = Savvas_SSO_ConstantsUtil.colorRed;
                        }
                        else{
                            charactersIcon = Savvas_SSO_ConstantsUtil.greenTick;
                            charactersColor = Savvas_SSO_ConstantsUtil.colorGreen;
                        }
                    }
                    if(letterIcon != Savvas_SSO_ConstantsUtil.ellipse){
                        if(!newPassword.replaceAll('[^A-Za-z]','').equals(verifyNewPassword.replaceAll('[^A-Za-z]',''))){
                            letterIcon = Savvas_SSO_ConstantsUtil.redCross;
                            letterColor = Savvas_SSO_ConstantsUtil.colorRed;
                        }
                        else{
                            letterIcon = Savvas_SSO_ConstantsUtil.greenTick;
                            letterColor = Savvas_SSO_ConstantsUtil.colorGreen;
                        }
                    }
                    if(numbersIcon != Savvas_SSO_ConstantsUtil.ellipse){
                        if(!newPassword.replaceAll('[^0-9]','').equals(verifyNewPassword.replaceAll('[^0-9]',''))){
                            numbersIcon = Savvas_SSO_ConstantsUtil.redCross;
                            numberColor = Savvas_SSO_ConstantsUtil.colorRed;
                        }
                        else{
                            numbersIcon = Savvas_SSO_ConstantsUtil.greenTick;
                            numberColor = Savvas_SSO_ConstantsUtil.colorGreen;   
                        }
                    }
                    if(specialCharacterIcon != Savvas_SSO_ConstantsUtil.ellipse){
                        if(!newPassword.replaceAll('[A-Za-z0-9]','').equals(verifyNewPassword.replaceAll('[A-Za-z0-9]',''))){
                            specialCharacterIcon = Savvas_SSO_ConstantsUtil.redCross;
                            specialCharacterColor=Savvas_SSO_ConstantsUtil.colorRed;
                        }
                        else{
                            specialCharacterIcon = Savvas_SSO_ConstantsUtil.greenTick;
                            specialCharacterColor = Savvas_SSO_ConstantsUtil.colorGreen;   
                        }
                    }
                    if(newPassword.equals(verifyNewPassword)){
                        newPasswordEmptyError = False;
                        verifyPWDEmptyError = False;
                        verifyPWDError = False;
                        verifyPWDStyle = Savvas_SSO_ConstantsUtil.vrfyPwdInput;
                    }
                }
                else{
                    verifyPWDEmptyError = True;
                    verifyPWDError = False;
                    verifyPWDStyle = Savvas_SSO_ConstantsUtil.vrfyPwdInput;
                }
            }
            else{
                charactersIcon = Savvas_SSO_ConstantsUtil.ellipse;
                letterIcon = Savvas_SSO_ConstantsUtil.ellipse;
                numbersIcon = Savvas_SSO_ConstantsUtil.ellipse;
                specialCharacterIcon = Savvas_SSO_ConstantsUtil.ellipse;
                charactersColor = '';
                letterColor = '';
                numberColor = '';
                specialCharacterColor='';
                newPasswordEmptyError = True;
                verifyPWDError = False;
                verifyPWDStyle = Savvas_SSO_ConstantsUtil.vrfyPwdInput;
            }
            PageReference pr = Site.changePassword(newPassword, verifyNewPassword);
            if(pr!=null){
                errorCheck = False;
                return pr;
            }
            else{
                for(ApexPages.message m : apexPages.getMessages()){
                    errorCheck = False;
                    if(m.getSummary().equalsIgnoreCase(Savvas_SSO_ConstantsUtil.passwordErrorMsg)){
                        errorMessage = m.getSummary().replace('Error: ','');
                        errorCheck = True;
                        return pr;
                    }
                }
                return pr;
            }
        }
        catch(Exception ex){
            System.debug(ex.getMessage());
            return null;
        }
    }     

    /*
    *  Method Name : updateIcons
    *  Description : Update validation icons 
    *  param : NA
    *  return : void
    */
    public void updateIcons(){
        try{
            if(String.isNotBlank(newPassword)){
                if(newPassword.length()>=8){     
                    charactersIcon = Savvas_SSO_ConstantsUtil.greenTick;
                    charactersColor = Savvas_SSO_ConstantsUtil.colorGreen;
                }
                else{
                    charactersIcon = Savvas_SSO_ConstantsUtil.ellipse;
                    charactersColor = '';
                }
                Pattern letterPattern = Pattern.compile('.*[A-Za-z]+.*');
                Matcher letterMatcher = letterPattern.matcher(newPassword);
                if(letterMatcher.matches()){
                    letterIcon = Savvas_SSO_ConstantsUtil.greenTick;
                    letterColor = Savvas_SSO_ConstantsUtil.colorGreen;
                }
                else{
                    letterIcon = Savvas_SSO_ConstantsUtil.ellipse;
                    letterColor = '';
                }
                
                Pattern numberPattern = Pattern.compile('.*[0-9]+.*');
                Matcher numberMatcher = numberPattern.matcher(newPassword);
                if(numberMatcher.matches()){
                    numbersIcon = Savvas_SSO_ConstantsUtil.greenTick;
                    numberColor = Savvas_SSO_ConstantsUtil.colorGreen;
                }
                else{
                    numbersIcon = Savvas_SSO_ConstantsUtil.ellipse;
                    numberColor = '';
                }
                Pattern specialCharacterPattern = Pattern.compile('.*[^A-Za-z0-9]+.*');
                Matcher specialCharacterMatcher = specialCharacterpattern.matcher(newPassword);
                
                if(specialCharacterMatcher.matches()){
                    specialCharacterIcon = Savvas_SSO_ConstantsUtil.greenTick;
                    specialCharacterColor=Savvas_SSO_ConstantsUtil.colorGreen;
                }
                else{
                    specialCharacterIcon = Savvas_SSO_ConstantsUtil.ellipse;
                    specialCharacterColor='';
                }
                newPasswordEmptyError = False;
            }
            else if(!String.isNotBlank(verifyNewPassword)){
                charactersIcon = Savvas_SSO_ConstantsUtil.ellipse;
                letterIcon = Savvas_SSO_ConstantsUtil.ellipse;
                numbersIcon = Savvas_SSO_ConstantsUtil.ellipse;
                specialCharacterIcon = Savvas_SSO_ConstantsUtil.ellipse;
                newPasswordEmptyError = True;
                verifyPWDEmptyError = False;
                charactersColor = '';
                letterColor = '';
                numberColor = '';
                specialCharacterColor='';
            }
            else{
                verifyPWDError = False;
                verifyPWDStyle = Savvas_SSO_ConstantsUtil.vrfyPwdInput;
                newPasswordEmptyError = True;
                verifyPWDEmptyError = False;
                charactersIcon = Savvas_SSO_ConstantsUtil.ellipse;
                letterIcon = Savvas_SSO_ConstantsUtil.ellipse;
                numbersIcon = Savvas_SSO_ConstantsUtil.ellipse;
                specialCharacterIcon = Savvas_SSO_ConstantsUtil.ellipse;
                charactersColor = '';
                letterColor = '';
                numberColor = '';
                specialCharacterColor='';         
            }        
        }
        catch(Exception ex){
            System.debug(ex.getMessage());
        }
    }	
}