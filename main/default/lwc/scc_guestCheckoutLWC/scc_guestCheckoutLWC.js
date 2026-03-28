import { LightningElement, track, api, wire } from 'lwc';
import isGuestUser from '@salesforce/apex/scc_checkOutLWC_Controller.isGuestUser';
import getServiceLvlOptions from '@salesforce/apex/scc_checkOutLWC_Controller.getServiceLvlOptions';
import createOrderRecord from '@salesforce/apex/scc_checkOutLWC_Controller.createOrderRecord';
import getAccessToken from '@salesforce/apex/scc_PaymetricIntegrationController.getAccessToken';
import getCreditCardToken from '@salesforce/apex/scc_PaymetricIntegrationController.getCreditCardToken';
import getCountrysOptions from '@salesforce/apex/scc_PaymetricIntegrationController.getCountrysOptions';
import getStatesOptions from '@salesforce/apex/scc_PaymetricIntegrationController.getStatesOptions';
import scc_iFrame_Url from '@salesforce/label/c.scc_iFrame_Url';
import scc_Credit_Card from "@salesforce/label/c.scc_Credit_Card";
import scc_Checkout_Zip from "@salesforce/label/c.scc_Checkout_Zip";
import scc_Checkout_Country from "@salesforce/label/c.scc_Checkout_Country";
import scc_Checkout_City from "@salesforce/label/c.scc_Checkout_City";
import scc_Checkout_Name from "@salesforce/label/c.scc_Checkout_Name";
import scc_Checkout_Street from "@salesforce/label/c.scc_Checkout_Street";
import scc_Checkout_Floor from "@salesforce/label/c.scc_Checkout_Floor";
import scc_CreditCardAddress from "@salesforce/label/c.scc_CreditCardAddress";
import scc_Checkout_State from "@salesforce/label/c.scc_Checkout_State";
import scc_PO_Info_Text from "@salesforce/label/c.scc_PO_Info_Text";
import scc_ZipHelpText from "@salesforce/label/c.scc_ZipHelpText";
import Paymetric_Script from "@salesforce/resourceUrl/scc_Paymetric_Script";
import { loadScript } from "lightning/platformResourceLoader";
import scc_register_FirstName_Text from '@salesforce/label/c.scc_register_FirstName_Text';
import scc_register_LastName_Text from '@salesforce/label/c.scc_register_LastName_Text';
import scc_checkOut_ContactInfo_Text from '@salesforce/label/c.scc_checkOut_ContactInfo_Text';
import scc_checkOut_Phone_Text from '@salesforce/label/c.scc_checkOut_Phone_Text';
import scc_checkOut_Order_Email_Text from '@salesforce/label/c.scc_checkOut_Order_Email_Text';
import scc_checkOut_Shipment_mail_Text from '@salesforce/label/c.scc_checkOut_Shipment_mail_Text';
import scc_checkOut_OrderInfo_Text from '@salesforce/label/c.scc_checkOut_OrderInfo_Text';
import scc_checkOut_Back_Order_Text from '@salesforce/label/c.scc_checkOut_Back_Order_Text';
import scc_checkOut_Requested_Ship_Text from '@salesforce/label/c.scc_checkOut_Requested_Ship_Text';
import scc_checkout_ShipDate_HelpText from '@salesforce/label/c.scc_checkout_ShipDate_HelpText';
import scc_checkOut_PromoCode_Text from '@salesforce/label/c.scc_checkOut_PromoCode_Text';
import scc_checkOut_BillTo_Text from '@salesforce/label/c.scc_checkOut_BillTo_Text';
import scc_checkOut_ShippingInfo_Text from '@salesforce/label/c.scc_checkOut_ShippingInfo_Text';
import scc_checkOut_ShipTo_Attention_Text from '@salesforce/label/c.scc_checkOut_ShipTo_Attention_Text';
import scc_checkOut_ShipTo_Attention_HelpText from '@salesforce/label/c.scc_checkOut_ShipTo_Attention_HelpText';
import scc_checkOut_ShipTo_Text from '@salesforce/label/c.scc_checkOut_ShipTo_Text';
import scc_checkOut_Ship_Service_Text from '@salesforce/label/c.scc_checkOut_Ship_Service_Text';
import scc_checkOut_ContactMail_Text from '@salesforce/label/c.scc_checkOut_ContactMail_Text';
import scc_checkOut_ContactPhone_Text from '@salesforce/label/c.scc_checkOut_ContactPhone_Text';
import scc_checkOut_Back_Order_HelpText from '@salesforce/label/c.scc_checkOut_Back_Order_HelpText';
import scc_checkOut_Ship_Service_HelpText from '@salesforce/label/c.scc_checkOut_Ship_Service_HelpText';
import scc_reviewCartPage_SummaryHelpText from "@salesforce/label/c.scc_reviewCartPage_SummaryHelpText";
import scc_checkout_Shipping_Level_Helptext from "@salesforce/label/c.scc_checkout_Shipping_Level_Helptext";
import getPromoCode from '@salesforce/apex/scc_reviewCartPageController.getPromoCode';
import updateShipServiceLvel from '@salesforce/apex/scc_checkOutLWC_Controller.updateShipServiceLvel';

export default class Scc_guestCheckoutLWC extends LightningElement {
    filteredresultt;

    //static renderMode = 'light';
    nameLabel = scc_Checkout_Name;
    streetLabel = scc_Checkout_Street;
    cityLabel = scc_Checkout_City;
    floorLabel = scc_Checkout_Floor;
    zipLabel = scc_Checkout_Zip;
    stateLabel = scc_Checkout_State;
    @track isGuest = false;
    @track isBillAddressSame = true;
    @track accessToken;
    @track merchantGuid;
    @track signature;
    @track displayiFrame = false;
    @track iFrameUrl;
    @track poNumber ='';
    @track cardName ='';
    @track cardFloor ='';
    @track cardStreet ='';
    @track cardCity ='';
    @track cardZip ='';
    @track billName ='';
    @track billFloor ='';
    @track billStreet ='';
    @track billCity ='';
    @track billZip ='';
    @track billState = '';
    @track billCountry = '';
    @track shipName ='';
    @track shipFloor ='';
    @track shipStreet ='';
    @track shipCity ='';
    @track shipZip ='';
    @track shipState = '';
    @track shipCountry = '';
    @track isAddressDifferent=false;
    @track CountrysOptions2;
    @track billCountryOptions;
    @track cardCountryOptions;
    @track shipCountryOptions;
    @track cardStateOptions;
    @track billStateOptions;
    @track shipStateOptions;
    @track isCreditCardSelected = true;
    @track isPoSelected = false;
    @track cardState = '';
    @track cardCountry = 'US';
    @track iframeRendered =false;
    @track CountrysOptions1 = [{ label: 'United States', value: 'US' }, { label: 'Canada', value: 'CA' }];
    @track scriptLoad = false;
    @track currencyCode = 'USD';
    @track paymentError = false;
    accountId ='';

    @track firstName = '';
    @track lastName = '';
    @track phone = '';
    @track email = '';
    @track ship_email = '';
    @track CancelBackOrderDate = null;
    @track RequestedShipDate = null;
    @track ShipToAttention='';
    @api totalPrice;
    @track isReviewOrderDisabled = true;
    @track showReviewOrderDetails = false;
    @track checkOutPage = true;
    @api promoCode;
    @api discountValue;
    @track serviceOptions = [];
    @track serviceValue ='';
    @track activeOrderId;
    showLoader = false;
    newPromoCode;
    
    labels = {
        scc_reviewCartPage_SummaryHelpText,
        scc_register_FirstName_Text,
        scc_register_LastName_Text,
        scc_checkOut_ContactInfo_Text,
        scc_checkOut_Phone_Text,
        scc_checkOut_Order_Email_Text,
        scc_checkOut_Shipment_mail_Text,
        scc_checkOut_OrderInfo_Text,
        scc_checkOut_Back_Order_Text,
        scc_checkOut_Requested_Ship_Text,
        scc_checkout_ShipDate_HelpText,
        scc_checkOut_PromoCode_Text,
        scc_checkOut_BillTo_Text,
        scc_checkOut_ShippingInfo_Text,
        scc_checkOut_ShipTo_Attention_Text,
        scc_checkOut_ShipTo_Attention_HelpText,
        scc_checkOut_ShipTo_Text,
        scc_checkOut_Ship_Service_Text,
        scc_checkOut_ContactMail_Text,
        scc_checkOut_ContactPhone_Text,
        scc_checkOut_Back_Order_HelpText,
        scc_checkOut_Ship_Service_HelpText,
        scc_iFrame_Url,
        scc_Checkout_Country,
        scc_PO_Info_Text,
        scc_Checkout_State,
        scc_Checkout_City,
        scc_Checkout_Name,
        scc_Checkout_Street,
        scc_Checkout_Floor,
        scc_Credit_Card,
        scc_Checkout_Zip,
        scc_CreditCardAddress,
        scc_checkout_Shipping_Level_Helptext,
        scc_ZipHelpText
    }

    @wire(isGuestUser)
    wiredIsGuestUser({error, data}){
        if(data != undefined){
            console.log('isGuestUser',data);
            this.isGuest = data;
        }else if(error){
            console.error('Error checking user type:',error);
        }
        console.log('isGuest:',this.isGuest);
    }

    @wire(getServiceLvlOptions)
    wiredOptions({error, data}){
        if(data){
            this.serviceOptions = JSON.parse(data);
            if(this.serviceOptions.length > 0){
                this.serviceValue = this.serviceOptions[0].value;
            }
        }else if(error){
            console.log('error', error);
        }
    }

    constructor() {
        console.log('inside constructor');
        isGuestUser().then(response => {            
            console.log('isGuestUser1',response);
        }).catch(error => {
            console.log('error is', error);
        })
        super();
        this.handleiFrameLoad();
    }
    
    get cardCountryOptions() {
        return this.cardCountryOptions;
    }

    get billCountryOptions() {
        return this.billCountryOptions;
    }

    connectedCallback() {
        console.log('inside connectedCallback');
        this.fetchShipCountryOptions();
        window.addEventListener('preAuthFailure', (event) => {
            console.log('inside preAuthFailure',event.detail.preAuthFail);
            if(event.detail.preAuthFail){
                console.log('inside event', event.detail.preAuthFail);
                this.clearValues();
            }
        });
        window.addEventListener('preAuthSuccess', (event) => {
            console.log('inside preAuthSuccess',event.detail.response);
            if(event.detail.response.preAuthResponse == 'Success'){
                this.createOrder(event.detail.response);
            }
        });
        const urlParams = new URLSearchParams(window.location.search);
        this.cartId = urlParams.get('CartId');
        this.accountId = urlParams.get('aid');
        console.log('cartId',this.cartId);
        console.log('accountId',this.accountId);
    }

    clearValues(){
        console.log('inside clearValues');
        this.iframeRendered = false;
        this.isAddressDifferent = false;
        this.cardName = '';
        this.cardCity ='';
        this.cardCountry = '';
        this.cardFloor = '';
        this.cardState = '';
        this.cardZip = '';
        this.cardStreet = '';
        this.handleiFrameLoad();
    }

    renderedCallback(){
        if(this.scriptLoad){
            return;
        }
        this.scriptLoad = true;  

        loadScript(this, Paymetric_Script)
        .then(() =>{
            console.log('script loaded');
        })
        .catch(error => {
            console.log('script load failed');
        });
    }

    @track cartId;
    
    handleiFrameLoad(){
        getAccessToken().then(response =>{
            console.log('access token response is',response);
            this.accessToken = response.accessToken;
            this.merchantGuid = response.merchantGuid;
            this.signature = response.signature;
            this.displayiFrame = true;
            let urlparams = this.merchantGuid+'/'+this.accessToken+'/true';
            this.iFrameUrl = `${scc_iFrame_Url}${urlparams}`;
        }).catch(error =>{
            console.log('access token error is',error);
        })
    }

    handleServiceOptionChange(event){
        console.log('handleServiceOptionChange',event.target.value);
        this.serviceValue = event.target.value;
        updateShipServiceLvel({cartID:this.cartId,shippingServiceLevel:this.serviceValue })
        .then(result => {
            console.log('Shipping Service level updated Successfully');
        })
        .catch(error => {
            this.caseError = error;
        });
    }

    handlebillAddressCheckbox(event){
        this.isBillAddressSame = event.detail.checked;
        if(!this.isBillAddressSame){
            getCountrysOptions().then(response => {
                this.CountrysOptions2 = JSON.parse(response);
                this.billCountryOptions = [...this.CountrysOptions1, ...this.CountrysOptions2];
                console.log('billCountryOptions',this.billCountryOptions);
            }).catch(error => {
                console.log('error is', error);
                this.isLoading1 = false;
            })
        }
    }

    handleCardAddressCheckbox(event){
        this.isAddressDifferent = event.detail.checked;
        if(this.isAddressDifferent){
            this.cardCountry = 'US';
            this.currencyCode = 'USD';
            getCountrysOptions().then(response => {
                this.CountrysOptions2 = JSON.parse(response);
                this.cardCountryOptions = [...this.CountrysOptions1, ...this.CountrysOptions2];
                console.log('cardCountryOptions',this.cardCountryOptions);
            }).catch(error => {
                console.log('error is', error);
                this.isLoading1 = false;
            })
            getStatesOptions({countryCode: this.currencyCode}).then(response => {
                console.log('getStatesOptions', JSON.parse(response));
                this.cardStateOptions = JSON.parse(response);
            }).catch(error => {
                console.log('error is', error);
            })
        }
    }

    fetchShipCountryOptions(){
        getCountrysOptions().then(response => {
            this.CountrysOptions2 = JSON.parse(response);
            this.shipCountryOptions = [...this.CountrysOptions1, ...this.CountrysOptions2];
            console.log('shipCountryOptions',this.shipCountryOptions);
        }).catch(error => {
            console.log('fetchShipCountryOptions error is', error);
        })
    }

    handleBillAddressChange(event){
        if(event.target.label == this.nameLabel){
            this.billName = event.target.value;
        }
        if(event.target.label == this.streetLabel){
            this.billStreet = event.target.value;
        }
        if(event.target.label == this.floorLabel){
            this.billFloor = event.target.value;
        }
        if(event.target.label == this.cityLabel){
            this.billCity = event.target.value;
        }
        if(event.target.label == this.zipLabel){
            this.billZip = event.target.value;
        }
        if(event.target.label == this.stateLabel){
            this.billState = event.detail.value;
        }
    }

    handleCardAddressChange(event){
        if(event.target.label == this.nameLabel){
            this.cardName = event.target.value;
        }
        if(event.target.label == this.streetLabel){
            this.cardStreet = event.target.value;
        }
        if(event.target.label == this.floorLabel){
            this.cardFloor = event.target.value;
        }
        if(event.target.label == this.cityLabel){
            this.cardCity = event.target.value;
        }
        if(event.target.label == this.zipLabel){
            this.cardZip = event.target.value;
        }
        if(event.target.label == this.stateLabel){
            this.cardState = event.detail.value;
        }
    }

    handleShipAddressChange(event){
        if(event.target.label == this.nameLabel){
            this.shipName = event.target.value;
        }
        if(event.target.label == this.streetLabel){
            this.shipStreet = event.target.value;
        }
        if(event.target.label == this.floorLabel){
            this.shipFloor = event.target.value;
        }
        if(event.target.label == this.cityLabel){
            this.shipCity = event.target.value;
        }
        if(event.target.label == this.zipLabel){
            this.shipZip = event.target.value;
        }
        if(event.target.label == this.stateLabel){
            this.shipState = event.detail.value;
        }
    }

    handleBillCountryOptionChange(event){
        this.billCountry = event.target.value;
        console.log('billCountry',this.billCountry);
        var currencyCode = '';
        if(this.billCountry == 'CA'){
            currencyCode = 'CAD';
        }else{
            currencyCode = 'USD';
        }
        getStatesOptions({countryCode: currencyCode}).then(response => {
            console.log('getStatesOptions', JSON.parse(response));
            this.billStateOptions = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })
    }

    handleCardCountryOptionChange(event) {
        console.log('handleCountryOptionChange',event.target);
        console.log('handleCountryOptionChange1',event.detail);
        this.cardCountry = event.target.value;
        console.log('cardCountry',this.cardCountry);
        if(this.cardCountry == 'CA'){
            this.currencyCode = 'CAD';
        }else{
            this.currencyCode = 'USD';
        }
        getStatesOptions({countryCode: this.currencyCode}).then(response => {
            console.log('getStatesOptions', JSON.parse(response));
            this.cardStateOptions = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })
    }

    handleShipCountryOptionChange(event) {
        this.shipCountry = event.target.value;
        console.log('shipCountry',this.shipCountry);
        var currencyCode = '';
        if(this.shipCountry == 'CA'){
            currencyCode = 'CAD';
        }else{
            currencyCode = 'USD';
        }
        getStatesOptions({countryCode: currencyCode}).then(response => {
            console.log('getStatesOptions', JSON.parse(response));
            this.shipStateOptions = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })
    }

    IFrame_OnLoad(event) {  
        if(!this.iframeRendered){
            this.iframeRendered = true;
            window.iframeContent = this.template.querySelector('iframe[name="dieCommFrame"]');
            var iframe = this.template.querySelector('iframe[name="dieCommFrame"]');
            console.log('iframe fetched',iframe);
            if (iframe) {
                $XIFrame.onload({
                    iFrameId: 'dieCommFrame',
                    targetUrl: iframe.src,
                    autosizewidth: true,
                    autosizeheight: true,
                    onSuccess: function (msg) {
                        console.log('A form for the merchant guid and access token combination is loading in the iFrame successfully.');
                    },
                    onError: function (msg) {
                        console.log('A form for the merchant guid and access token combination has FAILED to load.',msg);
                    }
                });
            }
        }  
        
    }

    submitform(){ 
        const accessToken = this.accessToken;
        const signature = this.signature;
        const merchantGuid = this.merchantGuid;
        const cardAddressMap = {
            cardName:this.cardName,
            cardZip:this.cardZip,
            cardStreet:this.cardStreet,
            cardCity:this.cardCity,
            cardCountry:this.cardCountry,
            cardState:this.cardState,
            currencyCode:this.currencyCode
        };
        const isAddressDifferent = this.isAddressDifferent;
        const cartId = this.cartId;
        
        var iframe = this.template.querySelector('iframe[name="dieCommFrame"]');
            if (iframe) {
                $XIFrame.submit({
                    iFrameId: 'dieCommFrame',
                    targetUrl: iframe.src,
                    onSuccess: function (msg) {
                        var message = JSON.parse(msg);
                        console.log('submit message',message)
                        if (message && message.data.HasPassed) {
                            console.log("Credit card data submitted !!");
                            console.log('cartId1',cartId);
                            getCreditCardToken({accessToken:accessToken,
                                signature:signature,
                                merchantGuid:merchantGuid,
                                isAddressDifferent:isAddressDifferent,
                                cardAddressMap:cardAddressMap,
                                cartId:cartId,
                            }).then(response =>{
                                console.log('token response:',response);
                                if(response.preAuthResponse == 'Success'){
                                    window.dispatchEvent(new CustomEvent('preAuthSuccess',{detail: {response}}));
                                }else{
                                    alert(response.preAuthResponse);
                                    var preAuthFail = true;
                                    window.dispatchEvent(new CustomEvent('preAuthFailure',{detail: {preAuthFail}}));
                                }
                            }).catch(error => {
                                console.log('error is', error);
                                alert('Something went wrong. Please try again after some time.');
                                var preAuthFail = true;
                                window.dispatchEvent(new CustomEvent('preAuthFailure',{detail: {preAuthFail}}));
                            })   
                        } else {
                            alert('Something went wrong. Please try again after some time.');
                            var preAuthFail = true;
                            window.dispatchEvent(new CustomEvent('preAuthFailure',{detail: {preAuthFail}}));
                            console.log('submit else',message.data.Message);
                        }
                    },
                    onError: function (msg) {
                        alert('Something went wrong. Please try again after some time.');
                        var preAuthFail = true;
                        window.dispatchEvent(new CustomEvent('preAuthFailure',{detail: {preAuthFail}}));
                        console.log('submit error',msg);
                    }
                });
            }

    }

    get isReviewOrdrDisabled1(){
        if((this.firstName != '')
        && (this.lastName != '')&& (this.phone != '')&& (this.email != '')&& (this.ship_email != '')&&(this.CancelBackOrderDate != null)&&
        (this.RequestedShipDate != null)&& (this.DeliveryContactPhone != '')&& (this.DeliveryContactEmail != '')
        ){
            if(this.isCreditCardSelected && this.isAddressDifferent){
                if(this.cardName != '' && this.cardCity != '' && this.cardCountry != '' && this.cardState != '' && this.cardStreet != '' && this.cardZip != ''){
                    this.isReviewOrderDisabled = false;
                }else{
                    this.isReviewOrderDisabled = true;
                }
            }else if(this.isCreditCardSelected && !this.isAddressDifferent){
                this.isReviewOrderDisabled = false;
            }
        }else{
            this.isReviewOrderDisabled = true;
        }
        return this.isReviewOrderDisabled;
    }

    handleReviewOrder(){
        console.log('FirstName',this.firstName);
        console.log('lastName',this.lastName);
        console.log('phone',this.phone);
        console.log('email',this.email);
        console.log('ship_email',this.ship_email);
        console.log('CancelBackOrderDate',this.CancelBackOrderDate);
        console.log('RequestedShipDate',this.RequestedShipDate);
        console.log('Bill_To_Attention',this.BillToAttention);
        console.log('Ship_To_Attention',this.ShipToAttention);
        console.log('Warehouse_Text',this.WarehouseText);
        console.log('Delivery_Contact_Phone',this.DeliveryContactPhone);
        console.log('Delivery_Contact_Email',this.DeliveryContactEmail);
        console.log('Promo Code',this.promoCode);
        console.log('Shipping Service Level',this.serviceValue);
        console.log('Shipping/Delivery Instruction',this.deliveryInstruction)
        
        if(this.isCreditCardSelected){
            this.submitform();
        }
   }
    
    get options(){
        return this.options;
    }

    createOrder(event){
        createOrderRecord({
            firstName:this.firstName.trim(), lastName:this.lastName.trim(), phone:this.phone.trim(), email:this.email.trim(), ship_email:this.ship_email.trim(), CancelBackOrderDate:this.CancelBackOrderDate.trim(),
              RequestedShipDate:this.RequestedShipDate.trim(), BillToAttention:this.BillToAttention.trim(), ShipToAttention:this.ShipToAttention.trim(), Warehouse: this.WarehouseText.trim(),
               DeliveryContactPhone:this.DeliveryContactPhone.trim(), DeliveryContactEmail:this.DeliveryContactEmail.trim(), cartID:this.cartId.trim(), promoCd:this.promoCode.trim(), shippingServiceLvl:this.serviceValue, delivryInstruction:this.deliveryInstruction,
               isCreditCardSelected: this.isCreditCardSelected, cardDetails:event, poNumber:this.poNumber, isProvisionDisabled:this.isProvisionDisabled,lName:this.lName,lStreet:this.lStreet,lCity:this.lCity,lCountry:this.lCountry,lPostalCode:this.lPostalCode

            }).then(response => {
                console.log('response is', response);
                this.activeOrderId = response;
            }).catch(error => {
                console.log('error is', error);
                this.isLoading1 = false;
            }).finally(() => {
               this.showReviewOrderDetails = true;
               this.checkOutPage = false;
           });
    }

    handlePhoneNumberInput(event){
        let input = event.target.value;
        console.log('input',input);
        input = input.replace(/[^0-9.]/g,'');

        if(input.length > 3 && input.length<=6){
            input = input.replace(/^(\d{3})(\d+)/, '$1-$2');
        }else if(input.length >6){
            input = input.replace(/^(\d{3})(\d{3})(\d+)/, '$1-$2-$3');
        }
        this.phone = input;
    }


    handleReviewOrderData(event) {
        if(event.target.name == 'FirstName'){
            this.firstName = event.target.value;
        }

        if(event.target.name == 'LastName'){
            this.lastName = event.target.value;
        }

        if(event.target.name == 'Phone'){
            this.phone = event.target.value;
        }

        if(event.target.name == 'OrderConfirmationEmail'){
            this.email = event.target.value;
        }

        if(event.target.name == 'ShipmentConfirmationEmail'){
            this.ship_email = event.target.value;
        }

        if(event.target.name == 'CancelBackOrderDate'){
            this.CancelBackOrderDate = event.target.value;
        }

        if(event.target.name == 'RequestedShipDate'){
            this.RequestedShipDate = event.target.value;
        }

        if(event.target.name == 'PromoCode'){
            this.promoCode = event.target.value;
        }

        if(event.target.name == 'radioGroup1'){
            this.shippingServiceLevel = event.target.value;
        }

        if(event.target.name == 'ShipToAttention'){
            this.ShipToAttention = event.target.value;
        }
    }

    handleChange() {
        let updatePromoCode = event.target.value; 
        // this.promoCode = event.target.value;
        this.newPromoCode = updatePromoCode;
        console.log("old"+ this.promoCode);
        console.log("new"+ this.newPromoCode);
    }
    
    @track showPromoConfirmation = false;
    @track showInvalidPromo = false;
    handleApplyClick() {
        this.showPromoConfirmation = true;
    }
    closePromoPopUp(){
        this.showPromoConfirmation = false;
    }
    updatePromoCode() {
        getPromoCode({ promocode: this.newPromoCode })
            .then(result => {
                console.log('im in handle review cart', result);
                if (result) {
                    this.promoCode = this.newPromoCode;
                } else {
                    this.discountValue = 0.00;
                    this.promoCode = ''; // Clear the promo code
                    console.log('Invalid Discount Value');
                    this.showInvalidPromo = true; // Show the invalid promo popup
                }
            })
            .catch(error => {
                this.cases = undefined;
                this.caseError = error;
            });

        this.showPromoConfirmation = false;
        this.showLoader = true;
        setTimeout(() => {
            this.showLoader = false;
        }, 1000);
    }
    closeInvalidPromoPopUp() {
        this.showInvalidPromo = false;
        this.promoCode = ''; // Clear the promo code field
    }
}