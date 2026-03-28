/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_FederationIdUtility
    @CreateDate : 11-June-2024
    @Description: This class acts as an user trigger helper for federation id update.
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 07-July-2024
    @TicketNumber: W-015496
*/
public class Savvas_SSO_FederationIdUtility {
    /*
    *  Method Name : setFederationId
    *  Description : Set Federation Id on new users
    *  param : List<User>
    *  return : void
    */
    public static void setFederationId(List<User> newUsers) {
        String profileId = System.Label.Savvas_External_Base_Profile_Id;
        if(String.isNotBlank(profileId)){
            for (User user : newUsers) {
                // Check if the user's profile Id matches the expected profile Id
                if (user.ProfileId == profileId && String.isBlank(user.FederationIdentifier)) {
                    user.FederationIdentifier = user.Email;
                }
            }
        }
    }
    /*
    *  Method Name : updateFederationId
    *  Description : Update federation Id on updated users
    *  param : List<User>
    *  return : void
    */
    public static void updateFederationId(List<User> updatedUsers) {
        String profileId = System.Label.Savvas_External_Base_Profile_Id;
        if(String.isNotBlank(profileId)){
            for (User user : updatedUsers){
                if (!user.IsActive && !user.IsPortalEnabled){
                    user.FederationIdentifier = null;
                }
                else if(user.profileId == profileId && String.isBlank(user.FederationIdentifier)){
                    if(user.Email.contains('savvas.com')){
                        user.FederationIdentifier = user.Email + '.external';
                    }
                    else{
                        user.FederationIdentifier = user.Email;
                    }
                }
            }
        }
    }
}