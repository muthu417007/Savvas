import { LightningElement, api, wire } from 'lwc';
import cartSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.cartSimulation';
import { CartSummaryAdapter } from 'commerce/cartApi';

export default class EnsxtxCartSapSimulate extends LightningElement {
    @api appSettingsName;
    @api sapButtonLabel;
    loading = false;
    cartId;

    @wire(CartSummaryAdapter)
    wiredCartSummary({ error, data }) {
        if (data) {
            this.cartId = data.cartId;
        } else if (error) {
            console.log(error);
        }
    }

    handleSAPSimulateButtonClicked() {
        this.loading = true;
        cartSimulation({ cartId: this.cartId, appSettingsName: this.appSettingsName })
        .then(({ data, messages }) => {
            console.log('cartSimulation', data);
            window.location.reload();
        })
        .catch(error => {
            console.log(error);
        })
        .finally(() => this.loading = false);
    }
}