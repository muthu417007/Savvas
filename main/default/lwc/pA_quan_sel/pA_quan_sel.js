import { LightningElement, api } from 'lwc';

export default class PA_quan_sel extends LightningElement {
    @api quantity = 0;

    increaseQuantity() {
        this.quantity++;
        this.dispatchEvent(new CustomEvent('quantitychange', { detail: this.quantity }));
    }

    decreaseQuantity() {
        if (this.quantity > 0) {
            this.quantity--;
            this.dispatchEvent(new CustomEvent('quantitychange', { detail: this.quantity }));
        }
    }
}