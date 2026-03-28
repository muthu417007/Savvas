/**************************************************************************************** 
* @Class Name  - scc_forgotPassword_controller
* @description - used to return true or false based on username present
* @Created By  - CTS-balamurugan D
* @Created On - 2024-07-22
* ***************************************************************************************/ 
public class scc_forgotPassword_controller {
    @AuraEnabled
    public static Boolean sccForgotPassword(String username){    
        if (Site.isValidUsername(username)){
            Boolean status = Site.forgotPassword(username);
            system.debug(status);
			return status;
        }
        else{  
            return false;
       	}
    }
}