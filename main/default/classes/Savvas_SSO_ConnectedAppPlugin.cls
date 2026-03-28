//poc
global class Savvas_SSO_ConnectedAppPlugin extends Auth.ConnectedAppPlugin{
    global override Boolean authorize(Id userId, Id connectedAppId, Boolean isAdminApproved, Auth.InvocationContext context) 
    {  
        System.debug('context'+context);
        List<PermissionSetAssignment> userPsaList = [
            SELECT PermissionSet.Name 
            FROM PermissionSetAssignment 
            WHERE AssigneeId =: userId
        ];
        if(!userPSAList.isEmpty()){
            for(PermissionSetAssignment userPSA : userPsaList){
                if(userPSA.PermissionSet.Name == 'Savvas_Worktext_Subscription_Permissions'){
                    isAdminApproved = true;
                }
                else{
                    isAdminApproved = false;
                }
            }
        } 
        return isAdminApproved;
    }

    // global override void modifySAMLResponse(Id authSession, Id connectedAppId, Dom.Document samlResponse) {
    //     List<PermissionSetAssignment> userPsaList = [
    //         SELECT PermissionSet.Name 
    //         FROM PermissionSetAssignment 
    //         WHERE AssigneeId =: userId
    //     ];
    //     // Retrieve the SAML assertion from the response
    //     Dom.XMLNode assertion = samlResponse.getRootElement()
    //         .getChildElement('Assertion', 'urn:oasis:names:tc:SAML:2.0:assertion');
        
    //     System.debug(assertion);
        
    //     // Check if the assertion is not null
    //     if (assertion != null) {
    //         if(!userPSAList.isEmpty()){
    //             for(PermissionSetAssignment userPSA : userPsaList){
    //                 if(userPSA.PermissionSet.Name != 'Savvas_Worktext_Subscription_Permissions'){
    //                      // Modify the assertion as needed
    //                         // Dom.XMLNode newAttribute = samlResponse.addChildElement('Attribute', 'urn:oasis:names:tc:SAML:2.0:assertion', null);
    //                         samlResponse.setAttribute('Assertion', 'urn:oasis:names:tc:SAML:2.0:status:Responder');
    //                 }
    //             }
    //         } 
    //     }
    //     // Serialize the XML back to a string
    //     String modifiedSamlResponse = samlResponse.toXmlString();
        
    //     // Call the super method with the modified SAML response
    //     super.modifySAMLResponse(authSession, connectedAppId, modifiedSamlResponse);
    // }
}