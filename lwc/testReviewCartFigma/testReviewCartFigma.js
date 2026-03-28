import { LightningElement } from 'lwc';
import scc_cart_item_img from "@salesforce/resourceUrl/scc_cart_item_img";
import scc_delete_icon from "@salesforce/resourceUrl/scc_delete_icon";
import scc_checkout_cart from "@salesforce/resourceUrl/scc_checkout_cart";
export default class TestReviewCartFigma extends LightningElement {
    labels = {
        scc_cart_item_img,
        scc_delete_icon,
        scc_checkout_cart
    }
    toggleDropdown(){
        console.log("toggle dropdown---");
        this.template.querySelector('.need-help-nav').classList.toggle('isOpen');
    }
    hideDropdown(){
        console.log("hide dropdown---");
        this.template.querySelector('.need-help-nav').classList.remove('isOpen');
    }
    showDropdown(){
        console.log("show dropdown---");
        this.template.querySelector('.need-help-nav').classList.add('isOpen');
    }
}