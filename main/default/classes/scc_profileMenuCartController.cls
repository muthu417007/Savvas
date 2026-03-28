public without sharing class scc_profileMenuCartController {
    @AuraEnabled(cacheable=true)
    public static Integer getActiveCartCount() {
        Integer cartQuantity = 0;
        
        try {
            system.debug('entere7');
            Id userId = UserInfo.getUserId();
			system.debug('entere9');
            // Query active WebCart for the user, handle empty result
            List<WebCart> webCartData = [SELECT Id FROM WebCart
                                         WHERE OwnerId = :userId 
                                         AND Status = :scc_constantHelper.STATUS_ACTIVE 
                                         AND IsSecondary = :scc_constantHelper.FALSE_VALUE 
                                         ORDER BY CreatedDate DESC LIMIT 1];

            if (webCartData.isEmpty()) {
                return 0; // No active cart found
            }
				system.debug('entere20');
            String activeCartId = webCartData[0].Id;

            // Query cart items associated with the active cart, handle empty result
            List<CartItem> cartItems = [SELECT Quantity FROM CartItem WHERE CartId = :activeCartId];

            if (cartItems.isEmpty()) {
                return 0; // No cart items found
            }

            // Calculate total cart quantity
            for (CartItem item : cartItems) {
                cartQuantity += item.Quantity.intValue();
            }
            

        } catch (Exception e) {
            // Catch any unexpected errors and return 0
            System.debug('Error in getActiveCartCount: ' + e.getMessage());
            return 0;
        }

        return cartQuantity;    
    }
}