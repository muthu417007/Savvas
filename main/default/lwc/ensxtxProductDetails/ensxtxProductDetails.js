import { LightningElement, api, wire, track } from 'lwc';
import { getSessionContext } from 'commerce/contextApi';
import { CartSummaryAdapter } from 'commerce/cartApi';
import { addItemToCart } from 'commerce/cartApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import communityId from '@salesforce/community/Id';
import userId from "@salesforce/user/Id";
import getWebStoreId from '@salesforce/apex/ensxtx_UTIL_B2BCommerce.getWebStoreId';
import getProduct from '@salesforce/apex/ensxtx_UTIL_B2BCommerce.getProduct';
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation';
import getPricingTiers from '@salesforce/apex/ensxtx_CTRL_Cart.getPricingTiers';
import addItemToList from '@salesforce/apex/ensxtx_CTRL_Cart.addItemToList';
import { resolve } from 'c/ensxtxCmsResourceResolver';
import ensxtx_CartPDP_Message_CartUpdated from '@salesforce/label/c.ensxtx_CartPDP_Message_CartUpdated';
import ensxtx_CartPDP_Message_Error from '@salesforce/label/c.ensxtx_CartPDP_Message_Error';
import ensxtx_CartPDP_Message_ListUpdated from '@salesforce/label/c.ensxtx_CartPDP_Message_ListUpdated';
import ensxtx_CartPDP_Message_LoadingProductInformation from '@salesforce/label/c.ensxtx_CartPDP_Message_LoadingProductInformation';


export default class EnsxtxProductDetails extends LightningElement {
    @api pdpAppSettingsName;
    @api appSettingsName;
    @api customDisplayFields;
    @api recordId;
    @api displayPrice;
    @api displayTax;
    @api displayConditions;
    @api displayConditionsValues;
    @api conditionsToDisplay;
    @api displayTiers = false;

    @track quantity = 1;

    label = {
        ensxtx_CartPDP_Message_CartUpdated,
        ensxtx_CartPDP_Message_Error,
        ensxtx_CartPDP_Message_ListUpdated,
        ensxtx_CartPDP_Message_LoadingProductInformation
    };

    displaySpinner = true;
    ensxtx_DS_Document_Detail;
    sfObjectIdMap = {};
    loadedPricingTiers;
    product;
    pdpInputParametersMap = {};

    @wire(CartSummaryAdapter)
    wiredCartSummary({ error, data }) {
        this.sfObjectIdMap.WebCart = undefined;
        if (data) {
            this.sfObjectIdMap.WebCart = data.cartId;
            if (data.accountId) this.sfObjectIdMap.Account = data.accountId;
            if (data.ownerId) this.sfObjectIdMap.User = data.ownerId;
            if (data.webstoreId) this.sfObjectIdMap.WebStore = data.webstoreId;
        } else if (error) {
            console.log(error);
        }
    }

    async connectedCallback() {
        this.displaySpinner = true;
        this.conditionsToDisplay = this.conditionsToDisplay ? this.conditionsToDisplay.split(',') : [];
        this.customDisplayFields = this.customDisplayFields ? this.customDisplayFields.split(',') : [];
        let sessionContext = await getSessionContext();
        this.sfObjectIdMap.Account = sessionContext.effectiveAccountId;
        this.loadedPricingTiers = undefined;
        this.retrieveProductDetails();
    }
   
    async retrieveProductDetails() {
        this.sfObjectIdMap.Product2 = this.recordId;
        this.sfObjectIdMap.User = userId;
        this.getWebStore()
        .then(result => {
            this.sfObjectIdMap.WebStore = result;
            this.loadProduct();
        })
        .catch((error) => {
            this.displaySpinner = false;
            console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: this.label.ensxtx_CartPDP_Message_Error,
                    messageData: [this.displayableProduct.name],
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
        });
    }
    
    async getWebStore () {
        return await new Promise((resolve, reject) => {
            return resolve (getWebStoreId({communityId: communityId}));
        });
    }

    async loadProduct () {
        getProduct({webStoreId: this.sfObjectIdMap.WebStore, productId: this.recordId, accountId: this.sfObjectIdMap.Account})
        .then((result) => {
            this.product = result;
            if (this.displayTiers && !this.loadedPricingTiers) {
                this.pricingTiers();
            } else this.simulateProduct();

        });
    }

    async pricingTiers() {
        getPricingTiers({ pdpAppSettingsName: this.pdpAppSettingsName, sfObjectIdMap: this.sfObjectIdMap })
        .then(({ data, messages }) => {
            console.log('getPricingTiers', data);
            if (data) {
                this.loadedPricingTiers = data.materialScales;
            }
            this.simulateProduct();
        });
    }

    async simulateProduct() {
        let productInfoList = this.sfObjectIdMap.Account ? [JSON.stringify({prodId: this.recordId, quantity: this.quantity})] : [];
        this.pdpInputParametersMap = {
            'Sales:SalesOrganization' : '0002',
            'Header:ShippingConditions' : 'DF'
        }
        productSimulation({ productInfoList: productInfoList, sfObjectIdMap: this.sfObjectIdMap, pdpAppSettingsName: this.pdpAppSettingsName, appSettingsName: this.appSettingsName, pdpInputParametersMap: this.pdpInputParametersMap })
        .then(({ data, messages }) => {
            console.log('productSimulation', data);
            this.displaySpinner = false;
            if (data) {
                this.ensxtx_DS_Document_Detail = data;
                if (this.conditionsToDisplay && this.conditionsToDisplay.length > 0 && this.ensxtx_DS_Document_Detail.ITEMS[0] && this.ensxtx_DS_Document_Detail.ITEMS[0].SBOItemConditions) {
                    this.ensxtx_DS_Document_Detail.ITEMS[0].SBOItemConditions = this.ensxtx_DS_Document_Detail.ITEMS[0]?.SBOItemConditions.filter(condition => 
                        this.conditionsToDisplay.filter(conditionToDisplay => conditionToDisplay == condition.ConditionType).length > 0);
                }
            }
        });
    }

    get displayableProduct() {
        return {
            price: this.ensxtx_DS_Document_Detail?.NetOrderValue,
            tax: this.ensxtx_DS_Document_Detail?.TaxAmount,
            availabilities: this.ensxtx_DS_Document_Detail?.ITEMS[0]?.ItemSchedules,
            pricingTiers: this.loadedPricingTiers,
            currencyIsoCode: this.ensxtx_DS_Document_Detail?.SalesDocumentCurrency,
            conditions: (this.ensxtx_DS_Document_Detail?.ITEMS[0]?.SBOItemConditions || {}),
            categoryPath: this.product?.primaryProductCategoryPath?.path.map(
                (category) => ({
                    id: category.id,
                    name: category.name
                })
            ),
            description: this.product?.fields?.Description,
            image: {
                alternativeText: this.product?.defaultImage?.alternativeText,
                url: resolve(this.product?.defaultImage?.url)
            },
            inStock: this.ensxtx_DS_Document_Detail?.ITEMS[0]?.ItemSchedules?.length > 1,
            name: this.product?.fields?.Name,
            sku: this.product?.fields?.StockKeepingUnit,
            customFields: Object.entries(
                this.product?.fields || Object.create(null)
            )
                .filter(([key]) => this.customDisplayFields.includes(key))
                .map(([key, value]) => ({ name: this.product?.attributeInfoMap?.[key]?.label || key, value }))
        };
    }

    get _isCartLocked() {
        const cartStatus = (this.cartSummary || {}).status;
        return cartStatus === 'Processing';
    }

    addToCart(event) {
        addItemToCart(this.recordId, event.detail.quantity)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: this.label.ensxtx_CartPDP_Message_CartUpdated,
                    variant: 'success',
                    mode: 'dismissable'
                })
            );
        })
        .catch((error) => {
            console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: this.label.ensxtx_CartPDP_Message_Error,
                    messageData: [this.displayableProduct.name],
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
        });
    }

    addToList(event) {
        addItemToList({webStoreId: this.sfObjectIdMap.WebStore, productId: this.recordId, accountId: this.sfObjectIdMap.Account, userId: this.sfObjectIdMap.User})
        .then((result) => {
            console.log('Wishlist Id='+result.data);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: this.label.ensxtx_CartPDP_Message_ListUpdated,
                    variant: 'success',
                    mode: 'dismissable'
                })
            );
        })
        .catch((error) => {
            console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: this.label.ensxtx_CartPDP_Message_Error,
                    messageData: [this.displayableProduct.name],
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
        });
    }

    updateQuantity(event) {
        this.displaySpinner = true;
        this.quantity = event.detail.quantity;
        this.simulateProduct()
        .catch((error) => {
            this.displaySpinner = false;
            console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: this.label.ensxtx_CartPDP_Message_Error,
                    messageData: [this.displayableProduct.name],
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
        });
    }
}