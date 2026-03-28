import { LightningElement, wire, track } from 'lwc';
import getBillingAddresses from '@salesforce/apex/scc_confirmAddress.getCurrentUserBillingAddress';
import getShippingAddresses from '@salesforce/apex/scc_confirmAddress.getCurrentUserBillingAddress';

export default class Testconfirmaddres2 extends LightningElement {
    @track billingAddresses = [];
    @track shippingAddresses = [];

    @wire(getBillingAddresses)
    wiredBillingAddresses({ error, data }) {
        if (data) {
            this.billingAddresses = data.map((address, index) => ({
                ...address,
                selected: index === 0,
                classNames: index === 0 ? 'address selected' : 'address'
            }));
        } else if (error) {
            // Handle error
        }
    }

    @wire(getShippingAddresses)
    wiredShippingAddresses({ error, data }) {
        if (data) {
            this.shippingAddresses = data.map((address, index) => ({
                ...address,
                selected: index === 0,
                classNames: index === 0 ? 'address selected' : 'address'
            }));
        } else if (error) {
            // Handle error
        }
    }

    handleMouseOver(event) {
        const addressId = event.currentTarget.dataset.id;
        const addressType = event.currentTarget.dataset.type;
        this.updateAddressStyle(addressId, addressType, 'hover');
    }

    handleMouseOut(event) {
        const addressId = event.currentTarget.dataset.id;
        const addressType = event.currentTarget.dataset.type;
        this.updateAddressStyle(addressId, addressType, 'unhover');
    }

    handleClick(event) {
        const addressId = event.currentTarget.dataset.id;
        const addressType = event.currentTarget.dataset.type;
        this.updateAddressSelection(addressId, addressType);
    }

    updateAddressStyle(addressId, type, action) {
        if (type === 'billing') {
            this.billingAddresses = this.billingAddresses.map(address => {
                if (address.Id === addressId) {
                    address.classNames = action === 'hover' ? 'address hovered' : 'address';
                    if (address.selected) {
                        address.classNames += ' selected';
                    }
                }
                return address;
            });
        } else {
            this.shippingAddresses = this.shippingAddresses.map(address => {
                if (address.Id === addressId) {
                    address.classNames = action === 'hover' ? 'address hovered' : 'address';
                    if (address.selected) {
                        address.classNames += ' selected';
                    }
                }
                return address;
            });
        }
    }

    updateAddressSelection(selectedId, type) {
        if (type === 'billing') {
            this.billingAddresses = this.billingAddresses.map(address => {
                address.selected = address.Id === selectedId;
                address.classNames = address.selected ? 'address selected' : 'address';
                return address;
            });
        } else {
            this.shippingAddresses = this.shippingAddresses.map(address => {
                address.selected = address.Id === selectedId;
                address.classNames = address.selected ? 'address selected' : 'address';
                return address;
            });
        }
    }
}