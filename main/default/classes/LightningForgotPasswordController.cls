// global class LightningForgotPasswordController {

//     public LightningForgotPasswordController() {

//     }

//     @AuraEnabled
//     public static String forgotPassword(String username, String checkEmailUrl) {
//         try {
//             Site.forgotPassword(username);
//             ApexPages.PageReference checkEmailRef = new PageReference(checkEmailUrl);
//             if(!Site.isValidUsername(username)) {
//                 return Label.Site.invalid_email;
//             }
//             aura.redirect(checkEmailRef);
//             return null;
//         }
//         catch (Exception ex) {
//             return ex.getMessage();
//         }
//     }

//     @AuraEnabled
//     global static String setExperienceId(String expId) {    
//         // Return null if there is no error, else it will return the error message 
//         try {
//             if (expId != null) {
//                 Site.setExperienceId(expId);               
//             }
//             return null; 
//         } catch (Exception ex) {
//             return ex.getMessage();            
//         }        
//     } 
// }

global class LightningForgotPasswordController {


    public LightningForgotPasswordController() {
    }

    @AuraEnabled
    public static Boolean sccForgotPassword(String username){
        try{
            if (Site.isValidUsername(username)) {
                Boolean status = Site.forgotPassword(username);
                if(status){
                    return true;
                }
                else{
                    return false;
                }
            }
            else{
                return false;
            }
        }
        catch(Exception e){
            System.debug(e.getLineNumber() + ' ==> ' + e.getMessage());
            return false;
        }
    }

    @AuraEnabled
    public static String forgotPassword(String username, String checkEmailUrl) {
        try {
            // Check if the username is valid
            if (!Site.isValidUsername(username)) {
                return 'Custom error message: Invalid username'; // Custom error message for invalid username
            }


            // Proceed with password reset
            Site.forgotPassword(username);


            // Create a PageReference for redirecting
            ApexPages.PageReference checkEmailRef = new PageReference(checkEmailUrl);
            aura.redirect(checkEmailRef);


            return null; // Return null if no errors
        } catch (Exception ex) {
            return 'Custom error message: ' + ex.getMessage(); // Custom error message for other exceptions
        }
    }


    @AuraEnabled
    global static String setExperienceId(String expId) {
        try {
            if (expId != null) {
                Site.setExperienceId(expId);
            }
            return null;
        } catch (Exception ex) {
            return 'Custom error message: ' + ex.getMessage(); // Custom error message for exceptions
        }
    }
}