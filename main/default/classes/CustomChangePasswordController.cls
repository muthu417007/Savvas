public with sharing class CustomChangePasswordController {
    public String userName { get; set; }
    public String oldPassword { get; set; }
    public String newPassword { get; set; }
    public String confirmPassword { get; set; }
    public Boolean showChangePassword { get; set; }

    public CustomChangePasswordController() {
        // Retrieve the userId parameter from the URL
        userName = ApexPages.currentPage().getParameters().get('userName');
        showChangePassword = true;
        
        // You can perform additional logic here if needed
        // For example, verify that the userId is valid or retrieve user details
    }

    public PageReference changePassword() {
        if (newPassword != confirmPassword) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The new password and confirmation do not match.'));
            return null;
        }

        try {
            // Get the user by userId
            User user = [SELECT Id FROM User WHERE Username = :userName LIMIT 1];
            
            // Change the user's password
            System.setPassword(user.Id, newPassword);
            
            // Add success message and hide the change password panel
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your password has been changed successfully.'));
            showChangePassword = false;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred while changing your password: ' + e.getMessage()));
        }

        return null;
    }
}