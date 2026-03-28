/********************************************************************************************* 
* @Component Name  - Scc_deleteItemsFromCart
* @description - Generalized Component to clear cart
* @Created By  - CTS-Muthukumar
* @Created On - 2024-05-1 
* ********************************************************************************************/
import { LightningElement,api, wire, track } from 'lwc';
import deleteAllCartItems from '@salesforce/apex/scc_addItemsToCartController.deleteAllCartItems';
import communityId from '@salesforce/community/Id';
import { CartSummaryAdapter } from "commerce/cartApi";
import { getSessionContext } from 'commerce/contextApi';
import { refreshCartSummary} from 'commerce/cartApi';
import clearPromoCode from '@salesforce/apex/scc_changeCartAsSecondary.clearPromoCode';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class Scc_deleteItemsFromCart extends LightningElement {
    activeCartId;
	currentaccountId;
    commId=communityId;
	@track enableLogs = false;

	 async connectedCallback() {
        let sessionContext = await getSessionContext();
         this.currentaccountId = sessionContext.effectiveAccountId;   

		 getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if(this.enableLogs){
                console.log('getEnableConsoleLogsTrue response is',response);
            }
        }).catch(error => {
            if(this.enableLogs){
                console.log('error is', error);
            }
        })
		            
    } 

    @wire(CartSummaryAdapter)
	setCartSummary({ data, error }) {
		if (data) {
			this.activeCartId = data.cartId;
			if(this.enableLogs){
			console.log('the current active cartid id',this.activeCartId,'and the current data getting is',data);
			}
            this.handleClearAllItems();
			if(this.enableLogs){
            console.log('the active cardid is ',data);
            console.log('the active cardid is ',this.activeCartId); 
			}
		} else if (error) {
			console.error(error);
		}
	}
	// calling apex method to clear curent cart
    handleClearAllItems(){
						this.isLoading = true;
						deleteAllCartItems({ activeCartId: this.activeCartId })
						.then(() => {
							  this.clearPromo();
						     const customEvent = new CustomEvent('refreshevent');
							 this.dispatchEvent(customEvent);
						})
						.catch((e) => {
							console.error('lwc delete all cart items error - ',e);
						});
					} 
	 clearPromo(){
		      clearPromoCode({ activeCartId: this.activeCartId})
				.then(() => {
					if(this.enableLogs){
						console.log('updated');
					}
				})
				.catch((e) => {
					console.error('clear promocode error ',e);
				}); 
	 }

    async refreshSummary(){
						const response = await refreshCartSummary()
						.then((result => {  
							this.isLoading = false;   
							this.isEmptyCart = true;   
						}));
					}
}