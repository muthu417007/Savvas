import { LightningElement, track, api, wire } from 'lwc';
import isGuestUser from '@salesforce/apex/scc_checkOutLWC_Controller.isGuestUser';
import getGuestCartDetails from '@salesforce/apex/scc_PaymetricIntegrationController.getGuestCartDetails';
import cartSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.cartSimulation';
import getServiceLvlOptions from '@salesforce/apex/scc_checkOutLWC_Controller.getServiceLvlOptions';
import getShippingInstructionOptions from '@salesforce/apex/scc_checkOutLWC_Controller.getShippingInstructionOptions';
import updateShipAddress from '@salesforce/apex/scc_checkOutLWC_Controller.updateShipAddress';
import updateLicenseToAddress from '@salesforce/apex/scc_checkOutLWC_Controller.updateLicenseToAddress';
import createOrderRecord from '@salesforce/apex/scc_checkOutLWC_Controller.createOrderRecord';
import createGuestOrderRecord from '@salesforce/apex/scc_checkOutLWC_Controller.createGuestOrderRecord';
import getAccessToken from '@salesforce/apex/scc_PaymetricIntegrationController.getAccessToken';
import getCreditCardToken from '@salesforce/apex/scc_PaymetricIntegrationController.getCreditCardToken';
import getCountrysOptions from '@salesforce/apex/scc_PaymetricIntegrationController.getCountrysOptions';
import getStatesOptions from '@salesforce/apex/scc_PaymetricIntegrationController.getStatesOptions';
import updatePoNum from '@salesforce/apex/scc_checkOutLWC_Controller.updatePoNum';
import getCurrShipTo from '@salesforce/apex/scc_checkOutLWC_Controller.getCurrShipTo';
import scc_iFrame_Url from '@salesforce/label/c.scc_iFrame_Url';
import scc_Credit_Card from "@salesforce/label/c.scc_Credit_Card";
import scc_Institution_Name from "@salesforce/label/c.scc_Institution_Name";
import scc_Institution_Type from "@salesforce/label/c.scc_Institution_Type";
import scc_Instution_Iam from "@salesforce/label/c.scc_Instution_Iam";
import scc_Checkout_PO from "@salesforce/label/c.scc_Checkout_PO";
import scc_Checkout_PONumber from "@salesforce/label/c.scc_Checkout_PONumber";
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
import getRelatedShippingAddress from '@salesforce/apex/scc_checkOutLWC_Controller.getCurrentUserShippingAddress';
import scc_register_FirstName_Text from '@salesforce/label/c.scc_register_FirstName_Text';
import scc_register_LastName_Text from '@salesforce/label/c.scc_register_LastName_Text';
import scc_checkOut_ContactInfo_Text from '@salesforce/label/c.scc_checkOut_ContactInfo_Text';
import scc_checkOut_Phone_Text from '@salesforce/label/c.scc_checkOut_Phone_Text';
import scc_checkOut_Order_Email_Text from '@salesforce/label/c.scc_checkOut_Order_Email_Text';
import scc_checkOut_Shipment_mail_Text from '@salesforce/label/c.scc_checkOut_Shipment_mail_Text';
import scc_checkOut_OrderInfo_Text from '@salesforce/label/c.scc_checkOut_OrderInfo_Text';
import scc_Cancel_Back_Order_Text from '@salesforce/label/c.scc_Cancel_Back_Order_Text';
import scc_checkOut_Back_Order_Text from '@salesforce/label/c.scc_checkOut_Back_Order_Text';
import scc_checkOut_Requested_Ship_Text from '@salesforce/label/c.scc_checkOut_Requested_Ship_Text';
import scc_checkout_ShipDate_HelpText from '@salesforce/label/c.scc_checkout_ShipDate_HelpText';
import scc_checkOut_PromoCode_Text from '@salesforce/label/c.scc_checkOut_PromoCode_Text';
import scc_checkOut_BillingInfo_Text from '@salesforce/label/c.scc_checkOut_BillingInfo_Text';
import scc_checkOut_BillTo_Text from '@salesforce/label/c.scc_checkOut_BillTo_Text';
import scc_checkOut_ShippingInfo_Text from '@salesforce/label/c.scc_checkOut_ShippingInfo_Text';
import scc_checkOut_ShipTo_Attention_Text from '@salesforce/label/c.scc_checkOut_ShipTo_Attention_Text';
import scc_checkOut_ShipTo_Attention_HelpText from '@salesforce/label/c.scc_checkOut_ShipTo_Attention_HelpText';
import scc_checkOut_ShipTo_Text from '@salesforce/label/c.scc_checkOut_ShipTo_Text';
import scc_checkOut_Ship_Service_Text from '@salesforce/label/c.scc_checkOut_Ship_Service_Text';
import scc_checkOut_DeliveryInfo_Text from '@salesforce/label/c.scc_checkOut_DeliveryInfo_Text';
import scc_checkOut_Warehouse_Text from '@salesforce/label/c.scc_checkOut_Warehouse_Text';
import scc_checkOut_ContactMail_Text from '@salesforce/label/c.scc_checkOut_ContactMail_Text';
import scc_checkOut_ContactPhone_Text from '@salesforce/label/c.scc_checkOut_ContactPhone_Text';
import scc_checkOut_Back_Order_HelpText from '@salesforce/label/c.scc_checkOut_Back_Order_HelpText';
import scc_checkOut_Ship_Service_HelpText from '@salesforce/label/c.scc_checkOut_Ship_Service_HelpText';
import scc_reviewCartPage_SummaryHelpText from "@salesforce/label/c.scc_reviewCartPage_SummaryHelpText";
import scc_checkout_License_Helptext from "@salesforce/label/c.scc_checkout_License_Helptext";
import scc_checkOut_Filter_HelpText from "@salesforce/label/c.scc_checkOut_Filter_HelpText";
import scc_checkout_Shipping_Level_Helptext from "@salesforce/label/c.scc_checkout_Shipping_Level_Helptext";
import getPromoCode from '@salesforce/apex/scc_reviewCartPageController.getPromoCode';
import updateShipServiceLvel from '@salesforce/apex/scc_checkOutLWC_Controller.updateShipServiceLvel';
import scc_checkout_cart from "@salesforce/resourceUrl/scc_checkout_cart";
import scc_checkout_cart_white from "@salesforce/resourceUrl/scc_checkout_cart_white";
import scc_calender_icon from "@salesforce/resourceUrl/scc_calender_icon";
import fetchCartDetails from '@salesforce/apex/scc_checkOutLWC_Controller.fetchCartDetails';
import getUserdata from '@salesforce/apex/scc_checkOutLWC_Controller.getUserdata';
import digitalProductCheck from '@salesforce/apex/scc_reviewCartPageController.digitalProductsCheck';
import fetchCartDetailsGA from '@salesforce/apex/scc_googleAnalyticsController.fetchCartDetailsGA';
import getCartItemsGA from '@salesforce/apex/scc_googleAnalyticsController.getCartItemsGA';
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
import scc_creditCheckErrorMsg from "@salesforce/label/c.scc_creditCheckErrorMsg";

export default class Scc_checkOutLWC extends LightningElement {

    filteredresultt;
    nameLabel = scc_Checkout_Name;
    streetLabel = scc_Checkout_Street;
    cityLabel = scc_Checkout_City;
    floorLabel = scc_Checkout_Floor;
    zipLabel = scc_Checkout_Zip;
    stateLabel = scc_Checkout_State;
    countryLabel = scc_Checkout_Country;
    institutionTypeLabel = scc_Institution_Type;
    iAmLabel = scc_Instution_Iam;
    @api cartId;
    @track isGuest = false;
    @track isRubiconAccount = false;
    @track isBillAddressSame = true;
    @track accessToken;
    @track merchantGuid;
    @track signature;
    @track displayiFrame = false;
    @track iFrameUrl;
    @track poNumber = '';
    @track cardName = '';
    @track cardFloor = '';
    @track cardStreet = '';
    @track cardCity = '';
    @track cardZip = '';
    @track billName = '';
    @track billFloor = '';
    @track billStreet = '';
    @track billCity = '';
    @track billZip = '';
    @track billState = '';
    @track billCountry = '';
    @track billCountryName = '';
    @track cardBillingCountry = '';
    @track cardBillingState = '';
    @track cardBillingZip = '';
    @track cardBillingCity = '';
    @track cardBillingStreet = '';
    @track cardBillingName = '';
    @track shipName = '';
    @track shipFloor = '';
    @track shipStreet = '';
    @track shipCity = '';
    @track shipZip = '';
    @track shipState = '';
    @track shipCountry = 'US';
    @track shipCountryName = '';
    @track isShipDisabled = false;
    @track isAddressDifferent = false;
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
    @track iframeRendered = false;
    @track CountrysOptions1 = [{ label: 'United States', value: 'US' }, { label: 'Canada', value: 'CA' }];
    @track scriptLoad = false;
    @track currencyCode = 'USD';
    @track paymentError = false;
    @track internationalShipping = false;
    @track displayInstitution = false;
    @track institutionType = '';
    @track iAm = '';
    guestCartId = ''
    guestAccountId = '';
    internationalShipService = [{ label: 'International Standard Shipping', value: 'ISS' }];
    internationalServiceValue = 'ISS';
    @track showErrorMSG = false;
    @track enableLogs = false;
    @track authfail = false;

    @track firstName = '';
    @track lastName = '';
    @track phone = '';
    @track email = '';
    @track ship_email = '';
    @track CancelBackOrderDate = null;
    @track RequestedShipDate = null;
    @track BillToAttention = '';
    @track ShipToAttention = '';
    @track WarehouseText = '';
    @track DeliveryContactPhone = '';
    @track DeliveryContactEmail = '';
    @track totalPrice;
    @track ShippingInstructionOptions1;
    @track ShippingInstructionValue;
    @track openModal = false;
    @track closeModal = true;
    @track openLicenseToModal = false;
    @track closeLicenseToModal = true;
    @track totalShipToRecords;
    @track searchTermShip = '';
    @track Shipaddress;
    @track lengthShipAddress;
    @track selectedShip;
    @track isChecked = false;
    @track selectedShipAccountId;
    @track isChangeAddDisabled = true;
    @track isReviewOrderDisabled = true;
    @track showShipAddressEmptyPage = false;
    @track showShipAddressPage = false;
    @track ShowLicenseAddress = false;
    @track isProvisionDisabled = true;
    @track showReviewOrderDetails = false;
    @track checkOutPage = true;
    @track discountValue;
    @track serviceOptions = [];
    @track serviceValue = '';
    @track activeOrderId;
    @track shippingServiceLevel;
    @track deliveryInstruction;
    @track cardData = {};
    @track lName = '';
    @track lStreet = '';
    @track lCity = '';
    @track lProvince = '';
    @track lCountry = '';
    @track lPostalCode = '';
    @track guestCartSubtotal;
    @track guestCartTotal;
    @track guestCartDiscount;
    @track guestCartPromo = '';
    @track guestCartShipping = 'N/A';
    @track shippingAmount = 'N/A';
    @track taxAmount = 'N/A';
    @track guestCartTax = 'N/A';
    @track guestCartRetrieved = false;
    @track showErrorMessage = false;
    @track errorMessage = '';
    @track showShipChangeButton = false;
    @track showLicense = false;
    @track showInstitutionName = false;
    @track institutionName = '';
    @track showLoader = true;
    newPromoCode;
    value = '';
    sections = [];
    @track oneTimeShipping = false;
    @track institutionPresent = false;
    @track institutionDetails;
    @track promoCode = '';
    @track promoCodeValue = '';
    orderItemList = [];//GA
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog = '';
    @track internalStatus = '';
    @track guestUserSiteCore;
    @track selectedAccountId;
    @track selectedAccountLicenseId;
    @track oneTimeShipName = '';
    @track oneTimeShipStreet = '';
    @track oneTimeShipCity = '';
    @track oneTimeShipProvince = '';
    @track oneTimeShipCountry = '';
    @track oneTimeShipPostalCode = '';
    @track oneTimeShippingName = '';
    @track shippingFloor = '';
    @track shippingStreet = '';
    @track alternateLicense = false;
    @track sameLicense = true;
    @track shippingNameS = '';
    @track shippingNumberS = '';
    @track shippingStreetS = '';
    @track shippingCityS = '';
    @track shippingStateS = '';
    @track shippingzipCodeS = '';
    @track shippingCountryS = '';
    @track disableCountry = true;

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
        scc_checkOut_BillingInfo_Text,
        scc_checkOut_BillTo_Text,
        scc_checkOut_ShippingInfo_Text,
        scc_checkOut_ShipTo_Attention_Text,
        scc_checkOut_ShipTo_Attention_HelpText,
        scc_checkOut_ShipTo_Text,
        scc_checkOut_Ship_Service_Text,
        scc_checkOut_DeliveryInfo_Text,
        scc_checkOut_Warehouse_Text,
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
        scc_Checkout_PO,
        scc_Checkout_Zip,
        scc_Checkout_PONumber,
        scc_CreditCardAddress,
        scc_checkout_License_Helptext,
        scc_checkout_Shipping_Level_Helptext,
        scc_ZipHelpText,
        scc_checkOut_Filter_HelpText,
        scc_checkout_cart,
        scc_checkout_cart_white,
        scc_calender_icon,
        scc_Cancel_Back_Order_Text,
        scc_Institution_Type,
        scc_Instution_Iam,
        scc_Institution_Name,
        scc_creditCheckErrorMsg
    }

    fetchdigitalProductCheck() {
        digitalProductCheck({ guestcartId: this.guestCartId })
            .then(result => {
                if (this.enableLogs) console.log('wireddigitalProductCheck', result);
                this.showLicense = result;
            })
            .catch(error => {
                if (this.enableLogs) {
                    console.log('wireddigitalProductCheckerror', error);
                }
            })
    }

    @wire(getServiceLvlOptions)
    wiredOptions({ error, data }) {
        if (data) {
            this.serviceOptions = JSON.parse(data);
            if (this.serviceOptions.length > 0) {
                this.serviceValue = this.serviceOptions[0].value;
            }
        } else if (error) {
            if (this.enableLogs) {
                console.log('error', error);
            }
        }
    }

    constructor() {
        super();
        isGuestUser().then(response => {
            if (this.enableLogs) console.log('isGuestUser1', response);
            if (response) {
                this.showLoader = true;
                this.isGuest = true;
                this.isShipDisabled = true;
                const urlParams = new URLSearchParams(window.location.search);
                this.guestCartId = urlParams.get('CartId');
                this.cartId = this.guestCartId;
                this.guestAccountId = urlParams.get('aid');
                if (this.enableLogs) console.log('cartId', this.guestCartId, ' accountId', this.guestAccountId);
                this.fetchShipCountryOptions();
                this.guesCartSimulateCall();
                this.fetchdigitalProductCheck();
                this.updatePoNumber(this.guestCartId, this.guestAccountId);
            } else {
                this.fetchdigitalProductCheck();
                getShippingInstructionOptions().then(response => {
                    if (this.enableLogs) console.log('response is', response);
                    let paser = JSON.parse(response);
                    this.ShippingInstructionOptions1 = JSON.parse(response);
                }).catch(error => {
                    console.log('guest user error is', error);
                })
                this.handlecurrShipTo();
            }
        }).catch(error => {
            console.log('error is', error);
        })
        //changes for W-014196 US-163 starts
        this.handleiFrameLoad();
        this.loadRelatedShipping();
        this.fetchShipCountryOptions();
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
        getStatesOptions({ countryCode: 'USD' }).then(response => {
            if (this.enableLogs) console.log('getStatesOptions', JSON.parse(response));
            this.shipStateOptions = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })
        this.oneTimeShipCountry = 'US';
    }
    updatePoNumber(cardId, accountId) {
        updatePoNum({ webcartId: cardId, currentaccountId: accountId }).then(response => {
            if (this.enableLogs) console.log('update ponumber response', response);
        }).catch(error => {
            this.error = error;
            if (this.enableLogs) {
                console.log('getBillingAddress error is', error);
            }
        })
    }

    value = 'Same Location as Ship To';
    get provisionOptions() {
        return [
            { label: 'Same Location as Ship To', value: 'Same Location as Ship To', isChecked: this.option1Select },
            { label: 'Alternate Location / Address', value: 'Alternate Location / Address', isChecked: this.option2Select }
        ];
    }

    get institutionTypeOptions() {
        return [
            { label: 'Public', value: 'Public' },
            { label: 'Private', value: 'Private' },
            { label: 'Catholic', value: 'Catholic' },
            { label: 'Diocese', value: 'Diocese' },
            { label: 'Other', value: 'Other' }
        ];
    }

    get iAmOptions() {
        return [
            { label: 'Teacher', value: 'Teacher' },
            { label: 'Parent', value: 'Parent' },
            { label: 'Administrator', value: 'Administrator' },
            { label: 'Homeschooler', value: 'Homeschooler' },
            { label: 'Other', value: 'Other' }
        ];
    }

    get cardCountryOptions() {
        return this.cardCountryOptions;
    }

    get billCountryOptions() {
        return this.billCountryOptions;
    }
    get shipCountryOptions() {
        return this.shipCountryOptions
    }
    customCartId = "";
    siteId = "";
    siteName = "";
    async connectedCallback() {
        this.guestUserSiteCore = sessionStorage.getItem('UserFromSiteCore');
        window.addEventListener('preAuthFailure', (event) => {
            if (this.enableLogs) console.log('inside preAuthFailure', event.detail.preAuthFail);
            if (event.detail.preAuthFail) {
                this.clearValues();
            }
        });
        window.addEventListener('preAuthSuccess', (event) => {
            if (this.enableLogs) console.log('inside preAuthSuccess', event.detail.response);
            if (event.detail.response.preAuthResponse == 'Success' && !this.isGuest) {
                this.createOrder(event.detail.response);
            } else if (event.detail.response.preAuthResponse == 'Success' && this.isGuest) {
                this.createGuestOrder(event.detail.response);
            }
        });
        window.addEventListener('preAuthErrorMessage', (event) => {
            if (event.detail.preAuthErrorMessage) {
                if (this.enableLogs) console.log('inside event', event.detail.preAuthErrorMessage);
                this.showErrorMessage = true;
                this.errorMessage = event.detail.preAuthErrorMessage;
            }
        });
        await isGuestUser().then(response => {
            if (this.enableLogs) console.log('isGuestUser1', response);
            if (response) {
                this.isGuest = true;
                const urlParams = new URLSearchParams(window.location.search);
                this.guestCartId = urlParams.get('CartId');
                this.cartId = this.guestCartId;
                this.guestAccountId = urlParams.get('aid');
            }
        }).catch(error => {
            console.log('error is', error);
        })
        if (this.isGuest) {
            await getGuestCartDetails({ guestCartId: this.guestCartId, guestAccountId: this.guestAccountId }).then(response => {
                if (this.enableLogs) console.log('getGuestCartDetails response is', response);
                this.isRubiconAccount = response.isRubiconAccount ? true : false;
                this.guestCartSubtotal = this.formatPrice(response.SubTotal && response.SubTotal != 0 ? '$ ' + response.SubTotal : '$ 0.00');
                this.promoCode = response.Coupon ? response.Coupon : '';
                this.promoCodeValue = response.Coupon ? response.Coupon : '';
                this.discountValue = response.CouponDiscount && response.CouponDiscount != 0 ? '-$ ' + (response.CouponDiscount).replace('-', '') : '-';
                this.guestCartShipping = this.formatPrice(response.ShippingAmount && response.ShippingAmount != 0 ? '$ ' + response.ShippingAmount : 'N/A');
                this.guestCartTax = this.formatPrice(response.Tax && response.Tax != 0 ? '$ ' + response.Tax : 'N/A');
                this.guestCartTotal = this.formatPrice(response.Total && response.Total != 0 ? '$ ' + response.Total : '$ 0.00');
                this.guestCartRetrieved = true;
                this.displayInstitution = response.DisplayInstitution == 'true' ? true : false;
                if (response.institutionName != '') {
                    this.showInstitutionName = true;
                    this.institutionName = response.institutionName;
                }
            }).catch(error => {
                console.log('error is', error);
            })
        }

        await getCartItemsGA({
            cartId: this.cartId
        }).then(response => {
            if (this.enableLogs) console.log('response of cartItem is', response);
            for (let k of response) {
                this.orderItemList.push({
                    ISBN10: k.Product2.ISBN10__c ? k.Product2.ISBN10__c : "",
                    ISBN13: k.Product2.ISBN13__c ? k.Product2.ISBN13__c : "",
                    categoryId: "",
                    categoryName: "",
                    productID: "",
                    productName: k.Product2.Name ? k.Product2.Name : "",
                    productSAPName: "",
                    programId: "",
                    programName: k.Product2.MasterProgram__c ? k.Product2.MasterProgram__c : "",
                    programURL: "",
                    quantity: k.Quantity ? k.Quantity : "",
                    shippingCharges: "",
                    subTotal: "",
                    taxes: "",
                    totalPrice: ""
                })

            }
        }).catch(error => {
            console.log('error is', error);
        })
        fetchCartDetailsGA({ cartId: this.cartId })
            .then(response => {
                this.customCartId = response.CartId ? response.CartId : "";
                this.siteId = response.SiteId ? response.SiteId : "";
                this.siteName = response.SiteName ? response.SiteName : "";
                this.subTotalPrice = this.formatPrice(response.SubTotal && response.SubTotal != 0 ? '$ ' + response.SubTotal : '$ 0.00');
                this.promoCode = response.Coupon ? response.Coupon : '';
                this.discountValue = response.CouponDiscount && response.CouponDiscount != 0 ? '-$ ' + (response.CouponDiscount).replace('-', '') : '-';
                this.shippingAmount = this.formatPrice(response.ShippingAmount && response.ShippingAmount != 0 ? '$ ' + response.ShippingAmount : 'N/A');
                this.taxAmount = this.formatPrice(response.Tax && response.Tax != 0 ? '$ ' + response.Tax : 'N/A');
                this.totalPrice = this.formatPrice(response.Total && response.Total != 0 ? '$ ' + response.Total : '$ 0.00');
                this.dispatchGARecords(null);
            })
            .catch(error => {
                console.log('Fetch Cart  error>>>>', error);
            })

        const elements = this.template.querySelectorAll('.slds-visual-picker__figure');
        if (this.enableLogs) console.log('Found elements:', elements.length);
        elements.forEach((el, index) => {
            if (this.enableLogs) console.log(`Element ${index}:`, el.outerHTML);
        });

        if (this.enableLogs) console.log('Debugging default selection on connectedCallback');

        //Delay the selection to ensure elements are fully rendered
        setTimeout(() => {
            this.selectDefaultElement();
        }, 500);

        this.template.addEventListener('keydown', this.handleKeydown.bind(this));

    }
    disconnectedCallback() {
        this.template.removeEventListener('keydown', this.handleKeydown);
    }

    //close popup when user press escape key -accessibility
    handleKeydown(event) {
        // Handle the keydown event
        if (event.key === 'Escape') {

            if (this.openLicenseToModal) {
                this.closeLicenseToModal1();
            }
            else if (this.openModal) {
                this.closeModal1();
            }
            else if (this.showPromoConfirmation) {
                this.closePromoPopUp();
            }
            else if (this.showInvalidPromo) {
                this.closeInvalidPromoPopUp();
            }
        }
    }

    selectDefaultElement() {
        const radioInputs = this.template.querySelectorAll('input[name="shipping-address"]');
        if (this.enableLogs) console.log('Shipping address inputs found:', radioInputs);

        if (radioInputs.length > 0) {
            radioInputs[0].checked = true;
            this.selectedShipAccountId = radioInputs[0].value;

            const visualPickerFigures = this.template.querySelectorAll('.slds-visual-picker__figure');
            if (visualPickerFigures.length > 0) {
                visualPickerFigures[0].classList.add('slds-is-selected');
                if (this.enableLogs) console.log('Selected shipping address:', visualPickerFigures[0].outerHTML);
            }
        }

        // Attach event listeners
        radioInputs.forEach(radio => {
            radio.addEventListener('change', this.handleAddressChange.bind(this));
        });
    }

    // Handle the address change event
    handleAddressChange(event) {
        const selectedId = event.target.value;
        this.template.querySelectorAll('.slds-visual-picker__figure').forEach(picker => {
            picker.classList.remove('slds-is-selected');
        });

        const selectedInput = this.template.querySelector(`input[value="${selectedId}"]`);
        if (selectedInput) {
            const parentDiv = selectedInput.closest('.slds-visual-picker');
            if (parentDiv) {
                const selectedPicker = parentDiv.querySelector('.slds-visual-picker__figure');
                if (selectedPicker) {
                    selectedPicker.classList.add('slds-is-selected');
                    if (this.enableLogs) console.log('New selected shipping address:', selectedPicker.outerHTML);
                }
            }
        }
        this.selectedShipAccountId = selectedId;
        this.isChangeAddDisabled = false;
    }


    renderedCallback() {

        if (this.selectedAccountId) {
            const shippingInputs = this.template.querySelectorAll('input[name="shipping-addres"]');
            shippingInputs.forEach(input => {
                if (input.value === this.selectedAccountId) {
                    input.checked = true;
                }
            });
        }
        if (this.selectedAccountLicenseId) {
            const shippingInputs = this.template.querySelectorAll('input[name="shipping-address-license"]');
            shippingInputs.forEach(input => {
                if (input.value === this.selectedAccountLicenseId) {
                    input.checked = true;
                }
            });
        }

        if (this.scriptLoad) {
            return;
        }
        this.scriptLoad = true;

        loadScript(this, Paymetric_Script)
            .then(() => {
                if (this.enableLogs) console.log('script loaded');
            })
            .catch(error => {
                console.log('script load failed');
            });
    }

    // Method to attach event listeners to shipping address radio inputs
    attachChangeListeners() {
        // Select the shipping address inputs (radio buttons)
        const radioInputs = this.template.querySelectorAll('input[name="shipping-address"]');
        if (this.enableLogs) console.log('Attaching change event listeners to:', radioInputs.length, 'inputs');

        // Attach change event listener to each radio input
        if (radioInputs.length > 0) {
            radioInputs.forEach((radio, index) => {
                if (this.enableLogs) console.log(`Attaching change event to radio button ${index}`, radio);
                radio.addEventListener('change', this.handleAddressChange.bind(this));
            });
        } else {
            if (this.enableLogs) {
                console.log('No shipping address inputs found to attach listeners.');
            }
        }
    }

    dispatchGARecords(event) {
        if (event != null) {
            this.dispatchEvent(new CustomEvent("placeorderdata", event));
        }
        else {
            this.dispatchEvent(new CustomEvent("placeorderdata", {
                detail: {
                    cart: {
                        cartId: this.cartId,
                        orderId: "",
                        shippingCharges: this.isGuest ? this.guestCartShipping : this.shippingAmount,
                        subTotal: this.isGuest ? this.guestCartSubtotal : this.subTotalPrice,
                        taxes: this.isGuest ? this.guestCartTax : this.taxAmount,
                        totalPrice: this.isGuest ? this.guestCartTotal : this.totalPrice
                    },
                    form: {
                        formId: "",
                        formKeycode: "",
                        formName: "",
                        pid: ""
                    },
                    institution: {
                        InstitutionID: "",
                        InstitutionName: this.institutionName ? this.institutionName : "",
                        InstitutionType: this.institutionType ? this.institutionType : ""
                    },
                    page: {
                        breadcrumb: "Checkout",
                        currentPromoCode: this.promoCode,
                        currentPromoDescription: this.promoCode != "" ? "Promo " + this.promoCode + " is applied." : "",
                        locator: "",
                        pageId: "",
                        pageName: "Checkout",
                        pageType: ""
                    },
                    pmdb: {
                        categoryId: "",
                        programId: "",
                        siteId: "",
                        solutionId: "",
                        subCategoryId: "",
                        subSolutionId: "",
                        subjectAreaId: ""
                    },
                    products: this.orderItemList,
                    program: {
                        programInfo: "",
                        categoryID: "",
                        categoryName: "",
                        programId: "",
                        programName: "",
                        programURL: ""
                    },
                    site: {
                        siteCategory: "",
                        siteDomain: "",
                        siteFamilyName: "",
                        siteId: this.siteId,
                        siteName: this.siteName
                    }
                }
            }));
        }
    }
    fetchUserData() {
        getUserdata().then(response => {
            if (this.enableLogs) console.log('response is', response);
            let parseData = JSON.parse(JSON.stringify(response));
            this.firstName = parseData[0].FirstName ? parseData[0].FirstName : '';
            this.lastName = parseData[0].LastName;
            this.email = parseData[0].Email;
            this.ship_email = parseData[0].Email;
            this.DeliveryContactEmail = parseData[0].Email;
            this.DeliveryContactPhone = parseData[0].Phone ? parseData[0].Phone : '';
            this.testPhone = parseData[0].Phone ? parseData[0].Phone : '';
            this.phone = parseData[0].Phone ? parseData[0].Phone : '';
            if (this.phone != '') {
                this.format(this.phone);
            }
        }).catch(error => {
            console.log('guest user error is', error);
        })
    }
    format(phone) {
        let input = phone;

        input = input.replace(/[^0-9.]/g, '');
        if (input.length > 3 && input.length <= 6) {
            input = input.replace(/^(\d{3})(\d+)/, '$1-$2');
        } else if (input.length > 6 && input.length <= 10) {
            input = input.replace(/^(\d{3})(\d{3})(\d+)/, '$1-$2-$3');
        }
        else if (input.length > 10) {
            input = input.replace(/^(\d{3})(\d{3})(\d{4})(\d+)/, '$1-$2-$3');
        }

        this.testPhone = input;
        this.phone = input;
        this.DeliveryContactPhone = input;
    }
    formatPrice(price) {
        if (this.enableLogs) {
            console.log('Price input:', price, 'Type:', typeof price);
        }
        if (price === null || price === undefined || price === '') {
            return 'N/A';
        }
        try {
            let numericPrice = typeof price === 'string' ? parseFloat(price.replace(/[^0-9.-]+/g, '')) : price;
            if (isNaN(numericPrice)) {
                return 'N/A';
            }
            // Format to 2 decimal places and add commas
            let formattedPrice = numericPrice.toFixed(2);
            return '$' + formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        } catch (error) {
            console.error('Error formatting price:', error, 'Price value:', price);
            return 'N/A';
        }
    }


    handleFetchCartData() {
        fetchCartDetails({ cartId: this.cartId })
            .then(response => {
                if (this.enableLogs) console.log('fetchCartData checkout>>>', response);
                this.showLoader = false;
                let subTotalPriceVal = response.SubTotal && response.SubTotal != 0 ? '$ ' + response.SubTotal : '$ 0.00';
                this.subTotalPrice = this.formatPrice(subTotalPriceVal);
                //this.newPromoCode = response.Coupon ? response.Coupon : '';
                this.promoCode = response.Coupon ? response.Coupon : '';
                this.promoCodeValue = response.Coupon ? response.Coupon : '';
                this.discountValue = response.CouponDiscount && response.CouponDiscount != 0 ? '-$ ' + (response.CouponDiscount).replace('-', '') : '-';
                this.shippingAmount = this.formatPrice(response.ShippingAmount && response.ShippingAmount != 0 ? '$ ' + response.ShippingAmount : 'N/A');

                this.taxAmount = this.formatPrice(response.Tax && response.Tax != 0 ? '$ ' + response.Tax : 'N/A');
                let totalPriceVal = response.Total && response.Total != 0 ? '$ ' + response.Total : '$ 0.00';
                this.totalPrice = this.formatPrice(totalPriceVal);
            })
            .catch(error => {
                console.log('Fetch Cart checkout error>>>>', error);
            })
    }

    fetchGuestCartDetails() {
        getGuestCartDetails({ guestCartId: this.guestCartId, guestAccountId: this.guestAccountId }).then(response => {
            if (this.enableLogs) console.log('getGuestCartDetails response is', response);
            this.showLoader = false;
            this.isRubiconAccount = response.isRubiconAccount ? true : false;
            this.guestCartSubtotal = this.formatPrice(response.SubTotal && response.SubTotal != 0 ? '$ ' + response.SubTotal : '$ 0.00');
            this.promoCode = response.Coupon ? response.Coupon : '';
            this.promoCodeValue = response.Coupon ? response.Coupon : '';
            this.discountValue = response.CouponDiscount && response.CouponDiscount != 0 ? '-$ ' + (response.CouponDiscount).replace('-', '') : '-';
            this.guestCartShipping = this.formatPrice(response.ShippingAmount && response.ShippingAmount != 0 ? '$ ' + response.ShippingAmount : 'N/A');
            this.guestCartTax = this.formatPrice(response.Tax && response.Tax != 0 ? '$ ' + response.Tax : 'N/A');
            this.guestCartTotal = this.formatPrice(response.Total && response.Total != 0 ? '$ ' + response.Total : '$ 0.00');
            this.guestCartRetrieved = true;
            this.displayInstitution = response.DisplayInstitution == 'true' ? true : false;
            if (response.institutionName != '') {
                this.showInstitutionName = true;
                this.institutionName = response.institutionName;
            }
            if (this.isRubiconAccount) {
                this.isRubiconAccount = true;
                this.isShipDisabled = true;
                this.shipCountry = 'CA';
                const selectedOption = this.shipCountryOptions.find(option => option.value === this.shipCountry);
                if (selectedOption) {
                    this.shipCountryName = selectedOption.label;
                }
                if (this.enableLogs) console.log('isRubiconAccount', this.isRubiconAccount);
                let currencyCode = 'CAD';
                getStatesOptions({ countryCode: currencyCode }).then(response => {
                    if (this.enableLogs) console.log('getStatesOptions', JSON.parse(response));
                    this.shipStateOptions = JSON.parse(response);
                }).catch(error => {
                    console.log('error is', error);
                    this.isLoading1 = false;
                })
            }
        }).catch(error => {
            console.log('error is', error);
        })
    }


    guesCartSimulateCall() {
        cartSimulation({ cartId: this.guestCartId, appSettingsName: 'ensxtx_SR_enosixWebCartB2BAppSettings' })
            .then(({ data, messages }) => {
                if (this.enableLogs) console.log('cartSimulation data>>>', data);
                if (this.enableLogs) console.log('cartSimulation message>>>', messages);
                messages.forEach(item => {
                    let enosixMSg = item.message;
                    if (this.enableLogs) console.log('TransactLogsensxtx_Message__c', enosixMSg);
                    const regex = /credit check/i;
                    this.showErrorMSG = (regex.test(enosixMSg));
                });
                if (data != undefined && data.IsSuccess) {
                    if (this.enableLogs) console.log('Cart Simulation successful');
                }
                this.responseBody = JSON.stringify(data.TransactLogs);
                this.logType = 'Enosix Cart Simulation';
                this.requestBody = this.guestCartId;
                this.statusLog = 'Success';
                this.internalStatus = '';
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_checkOutLWC/guesCartSimulateCall/cartSimulation');
            })
            .catch(error => {
                console.log('cart simulation error>>>>', error);
                this.logType = 'Enosix Cart Simulation';
                this.requestBody = this.guestCartId;
                this.statusLog = 'Error';
                this.internalStatus = JSON.stringify(error);
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_checkOutLWC/guesCartSimulateCall/cartSimulation');
            }).finally(() => {
                if (this.guestUserSiteCore == null) {
                    sessionStorage.setItem('UserFromSiteCore', 'true');
                    window.location.reload();
                }
                this.fetchGuestCartDetails();
            });

    }

    clearValues() {
        this.isReviewOrderDisabled = false;
        this.iframeRendered = false;
        this.isAddressDifferent = false;
        this.cardName = '';
        this.cardCity = '';
        this.cardCountry = '';
        this.cardFloor = '';
        this.cardState = '';
        this.cardZip = '';
        this.cardStreet = '';
        this.handleiFrameLoad();
    }



    focusCloseButton() {
        // Find the close button using data-id attribute
        const closeButton = this.template.querySelector('[data-id="closeButton"]');
        if (closeButton) {
            // Focus on the close button
            closeButton.focus();
        } else {
            console.error('Close button not found');
        }
    }

    @track curaddress;
    @track licenseCurAddress = {};
    @track cartId;
    @track subTotalPrice;
    handlecurrShipTo() {
        getCurrShipTo().then(response => {
            if (this.enableLogs) console.log('response is', response);
            let paser = response;
            this.curaddress = [...paser];
            this.cartId = this.curaddress[0].Id;
            this.oneTimeShipping = this.curaddress[0].Specify_One_Time_Shipping__c;
            this.cardBillingName = this.curaddress[0].BillingName__c;
            this.cardBillingStreet = this.curaddress[0].BillingStreet;
            this.cardBillingCity = this.curaddress[0].BillingCity;
            this.cardBillingZip = this.curaddress[0].BillingPostalCode;
            this.cardBillingState = this.curaddress[0].BillingState;
            this.cardBillingCountry = this.curaddress[0].BillingCountry;
            this.currencyCode = this.curaddress[0].BillingCountry === 'Canada' ? 'CAD' : 'USD';
        }).catch(error => {
            console.log('error is', error);
            // this.isLoading1=false;
        }).finally(() => {
            this.cartSimulateCall();
        });
    }

    handleiFrameLoad() {
        getAccessToken().then(response => {
            if (this.enableLogs) console.log('access token response is', response);
            this.accessToken = response.accessToken;
            this.merchantGuid = response.merchantGuid;
            this.signature = response.signature;
            this.displayiFrame = true;
            let urlparams = this.merchantGuid + '/' + this.accessToken + '/true';
            this.iFrameUrl = `${scc_iFrame_Url}${urlparams}`;
        }).catch(error => {
            console.log('access token error is', error);
        })
    }

    handlePaymentChange(event) {
        this.selectedPayment = event.target.value;
        if (event.target.value == 'creditCard') {
            this.isCreditCardSelected = true;
            this.isPoSelected = false;
        } else if (event.target.value == 'poMethod') {
            this.isCreditCardSelected = false;
            this.isPoSelected = true;
            this.iframeRendered = false;
        }
    }

    handlePOChange(event) {
        this.poNumber = event.target.value;
    }

    handleServiceOptionChange(event) {
        this.serviceValue = event.target.value;
        updateShipServiceLvel({ cartID: this.cartId, shippingServiceLevel: this.serviceValue })
            .then(result => {
                if (this.enableLogs) console.log('Shipping Service level updated Successfully');
            })
            .catch(error => {
                this.caseError = error;
            });
    }

    get curaddress1() {
        return this.curaddress;
    }

    get licaddress() {
        return this.licenseCurAddress;
    }

    handlebillAddressCheckbox(event) {
        this.isBillAddressSame = event.detail.checked;
        if (!this.isBillAddressSame) {
            this.billCountry = 'US';
            let currencyBillCode = 'USD';
            getCountrysOptions().then(response => {
                this.CountrysOptions2 = JSON.parse(response);
                this.billCountryOptions = [...this.CountrysOptions1, ...this.CountrysOptions2];
                if (this.enableLogs) console.log('billCountryOptions', this.billCountryOptions);
            }).catch(error => {
                console.log('error is', error);
                this.isLoading1 = false;
            })
            getStatesOptions({ countryCode: currencyBillCode }).then(response => {
                if (this.enableLogs) console.log('getStatesOptions', JSON.parse(response));
                this.billStateOptions = JSON.parse(response);
            }).catch(error => {
                console.log('error is', error);
                this.isLoading1 = false;
            })
        }
    }

    handleCardAddressCheckbox(event) {
        this.isAddressDifferent = event.detail.checked;
        if (this.isAddressDifferent) {
            this.cardCountry = 'US';
            this.currencyCode = 'USD';
            getCountrysOptions().then(response => {
                this.CountrysOptions2 = JSON.parse(response);
                this.cardCountryOptions = [...this.CountrysOptions1, ...this.CountrysOptions2];
            }).catch(error => {
                console.log('error is', error);
                this.isLoading1 = false;
            })
            getStatesOptions({ countryCode: this.currencyCode }).then(response => {
                if (this.enableLogs) console.log('getStatesOptions', JSON.parse(response));
                this.cardStateOptions = JSON.parse(response);
            }).catch(error => {
                console.log('error is', error);
            })
        }
    }

    fetchShipCountryOptions() {
        getCountrysOptions().then(response => {
            this.CountrysOptions2 = JSON.parse(response);
            this.shipCountryOptions = [...this.CountrysOptions1, ...this.CountrysOptions2];
            if (this.enableLogs) console.log('shipCountryOptions', this.shipCountryOptions);
        }).catch(error => {
            console.log('fetchShipCountryOptions error is', error);
        })
    }

    handleBillAddressChange(event) {
        if (event.target.label == this.nameLabel) {
            this.billName = event.target.value;
        }
        if (event.target.label == this.streetLabel) {
            this.billStreet = event.target.value;
        }
        if (event.target.label == this.floorLabel) {
            this.billFloor = event.target.value;
        }
        if (event.target.label == this.cityLabel) {
            this.billCity = event.target.value;
        }
        if (event.target.label == this.zipLabel) {
            this.billZip = event.target.value;
        }
        if (event.target.label == this.stateLabel) {
            this.billState = event.detail.value;
        }
    }

    handleCardAddressChange(event) {
        if (event.target.label == this.nameLabel) {
            this.cardName = event.target.value;
        }
        if (event.target.label == this.streetLabel) {
            this.cardStreet = event.target.value;
        }
        if (event.target.label == this.floorLabel) {
            this.cardFloor = event.target.value;
        }
        if (event.target.label == this.cityLabel) {
            this.cardCity = event.target.value;
        }
        if (event.target.label == this.zipLabel) {
            this.cardZip = event.target.value;
        }
        if (event.target.label == this.stateLabel) {
            this.cardState = event.detail.value;
        }
    }

    handleShipAddressChange(event) {
        if (event.target.label == this.nameLabel) {
            this.shipName = event.target.value;
        }
        if (event.target.label == this.streetLabel) {
            this.shipStreet = event.target.value;
        }
        if (event.target.label == this.floorLabel) {
            this.shipFloor = event.target.value;
        }
        if (event.target.label == this.cityLabel) {
            this.shipCity = event.target.value;
        }
        if (event.target.label == this.zipLabel) {
            this.shipZip = event.target.value;
        }
        if (event.target.label == this.stateLabel) {
            this.shipState = event.detail.value;
        }
        if (event.target.label == this.institutionTypeLabel) {
            this.institutionType = event.target.value;
            this.dispatchGARecords(null);
        }
        if (event.target.label == this.iAmLabel) {
            this.iAm = event.target.value;
        }
    }

    handleBillCountryOptionChange(event) {
        this.billCountry = event.target.value;
        if (this.enableLogs) console.log('billCountry', this.billCountry);
        const selectedOption = this.billCountryOptions.find(option => option.value === this.billCountry);
        if (selectedOption) {
            this.billCountryName = selectedOption.label;
        }
        var currencyCode = '';
        if (this.billCountry == 'CA') {
            currencyCode = 'CAD';
        } else {
            currencyCode = 'USD';
        }
        getStatesOptions({ countryCode: currencyCode }).then(response => {
            if (this.enableLogs) console.log('getStatesOptions', JSON.parse(response));
            this.billStateOptions = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })
    }

    handleCardCountryOptionChange(event) {
        this.cardCountry = event.target.value;
        if (this.enableLogs) console.log('this.cardCountry     ', this.cardCountry);
        if (this.cardCountry == 'CA') {
            this.currencyCode = 'CAD';
        } else {
            this.currencyCode = 'USD';
        }
        getStatesOptions({ countryCode: this.currencyCode }).then(response => {
            if (this.enableLogs) console.log('getStatesOptions', JSON.parse(response));
            this.cardStateOptions = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })
    }

    handleShipCountryOptionChange(event) {
        if (event.target.label == this.countryLabel) {
            this.oneTimeShipCountry = event.detail.value;
            this.shipCountry = event.target.value;
            console.log(this.shipCountry, this.oneTimeShipCountry);
        }
        this.shipCountry = event.target.value;
        const selectedOption = this.shipCountryOptions.find(option => option.value === this.shipCountry);
        if (selectedOption) {
            this.shipCountryName = selectedOption.label;
        }
        if (this.shipCountry != 'US' && !this.isRubiconAccount) {
            this.internationalShipping = true;
        } else {
            this.internationalShipping = false;
        }
        var currencyCode = '';
        if (this.shipCountry == 'CA') {
            currencyCode = 'CAD';
        } else {
            currencyCode = 'USD';
        }
        getStatesOptions({ countryCode: currencyCode }).then(response => {
            if (this.enableLogs) console.log('getStatesOptions', JSON.parse(response));
            this.shipStateOptions = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })
    }

    handleProvisionChange(event) {
        if (event.target.value == 'Alternate Location / Address') {
            this.isProvisionDisabled = false;
            this.alternateLicense = true;
            this.sameLicense = false;
        } else {
            this.isProvisionDisabled = true;
            this.ShowLicenseAddress = false;
            this.alternateLicense = false;
            this.sameLicense = true;
        }
    }

    IFrame_OnLoad(event) {
        if (!this.iframeRendered) {
            this.iframeRendered = true;
            window.iframeContent = this.template.querySelector('iframe[name="dieCommFrame"]');
            var iframe = this.template.querySelector('iframe[name="dieCommFrame"]');
            if (this.enableLogs) console.log('iframe fetched', iframe);
            if (iframe) {
                $XIFrame.onload({
                    iFrameId: 'dieCommFrame',
                    targetUrl: iframe.src,
                    autosizewidth: true,
                    autosizeheight: true,
                    onSuccess: function (msg) {
                        if (this.enableLogs) {
                            console.log('A form for the merchant guid and access token combination is loading in the iFrame successfully.');
                        }
                    },
                    onError: function (msg) {
                        if (this.enableLogs) {
                            console.log('A form for the merchant guid and access token combination has FAILED to load.', msg);
                        }
                    }
                });
            }
        }

    }

    submitform() {
        const accessToken = this.accessToken;
        const signature = this.signature;
        const merchantGuid = this.merchantGuid;
        if (this.isGuest == true) {
            if (this.isAddressDifferent == false) {
                if (!this.isBillAddressSame) {
                    this.cardName = this.billName;
                    this.cardZip = this.billZip;
                    this.cardStreet = this.billStreet;
                    this.cardCity = this.billCity;
                    this.cardCountry = this.billCountry;
                    this.cardState = this.billState;
                } else {
                    this.cardName = this.shipName;
                    this.cardZip = this.shipZip;
                    this.cardStreet = this.shipStreet;
                    this.cardCity = this.shipCity;
                    this.cardCountry = this.shipCountry;
                    this.cardState = this.shipState;
                }
            }

        } else {
            if (this.isAddressDifferent == false) {
                this.cardName = this.cardBillingName;
                this.cardZip = this.cardBillingZip;
                this.cardStreet = this.cardBillingStreet;
                this.cardCity = this.cardBillingCity;
                this.cardCountry = this.cardBillingCountry;
                this.cardState = this.cardBillingState;
            }

        }
        const cardAddressMap = {
            cardName: this.cardName,
            cardZip: this.cardZip,
            cardStreet: this.cardStreet,
            cardCity: this.cardCity,
            cardCountry: this.cardCountry,
            cardState: this.cardState,
            currencyCode: this.currencyCode
        };
        if (this.enableLogs) console.log('cardAddressMap', cardAddressMap);
        const isAddressDifferent = this.isAddressDifferent;
        const cartId = this.cartId;

        var iframe = this.template.querySelector('iframe[name="dieCommFrame"]');
        if (iframe) {
            $XIFrame.submit({
                iFrameId: 'dieCommFrame',
                targetUrl: iframe.src,
                onSuccess: function (msg) {
                    var message = JSON.parse(msg);
                    if (this.enableLogs) console.log('submit message', message)
                    if (message && message.data.HasPassed) {
                        if (this.enableLogs) console.log("Credit card data submitted !!");
                        if (this.enableLogs) console.log('cartId1', cartId);
                        getCreditCardToken({
                            accessToken: accessToken,
                            signature: signature,
                            merchantGuid: merchantGuid,
                            isAddressDifferent: isAddressDifferent,
                            cardAddressMap: cardAddressMap,
                            cartId: cartId,
                        }).then(response => {
                            if (this.enableLogs) console.log('token response:', response);
                            if (response.preAuthResponse == 'Success') {
                                window.dispatchEvent(new CustomEvent('preAuthSuccess', { detail: { response } }));
                            } else {

                                var preAuthErrorMessage = response.preAuthResponse;
                                window.dispatchEvent(new CustomEvent('preAuthErrorMessage', { detail: { preAuthErrorMessage } }));
                            }
                        }).catch(error => {
                            console.log('error is', error);
                            // alert('Something went wrong during card validation. Please try again after some time.');
                            this.authfail = true;
                            var preAuthFail = true;
                            window.dispatchEvent(new CustomEvent('preAuthFailure', { detail: { preAuthFail } }));
                        })
                    } else {
                        // alert('Something went wrong during card validation. Please try again after some time.');
                        this.authfail = true;
                        var preAuthFail = true;
                        window.dispatchEvent(new CustomEvent('preAuthFailure', { detail: { preAuthFail } }));
                        if (this.enableLogs) {
                            console.log('submit else', message.data.Message);
                        }
                    }
                },
                onError: function (msg) {
                    //  alert('Something went wrong during card validation. Please try again after some time.');
                    this.authfail = true;
                    var preAuthFail = true;
                    window.dispatchEvent(new CustomEvent('preAuthFailure', { detail: { preAuthFail } }));
                    if (this.enableLogs) {
                        console.log('submit error', msg);
                    }
                }
            });
        }

    }



    get isReviewOrdrDisabled1() {
        if ((this.firstName != '')
            && (this.lastName != '') && (this.phone != '') && (this.email != '') &&
            (this.DeliveryContactPhone != '') && (this.DeliveryContactEmail != '') && (this.phone.length == 12) && (this.DeliveryContactPhone.length == 12)
        ) {

            if (this.isCreditCardSelected && this.isAddressDifferent) {
                if (this.cardName != '' && this.cardCity != '' && this.cardCountry != '' && this.cardState != '' && this.cardStreet != '' && this.cardZip != '') {
                    this.isReviewOrderDisabled = false;
                } else {
                    this.isReviewOrderDisabled = true;
                }
            } else if (this.isPoSelected && !this.isGuest && this.poNumber != '') {
                this.isReviewOrderDisabled = false;
            } else if (this.isPoSelected && !this.isGuest && this.poNumber == '') {
                this.isReviewOrderDisabled = true;
            } else if (this.isCreditCardSelected && !this.isAddressDifferent) {
                this.isReviewOrderDisabled = false;
            }
        } else {
            this.isReviewOrderDisabled = true;
        }
        if (this.isReviewOrderDisabled == false && this.oneTimeShipping == true) {
            if (this.oneTimeShipCountry != '' && this.oneTimeShipProvince != '' && this.oneTimeShipPostalCode != '' && this.oneTimeShipCity != '' && this.shippingStreet != '' && this.oneTimeShipName != '') {
                this.isReviewOrderDisabled = false;
            } else {
                this.isReviewOrderDisabled = true;
            }
        }
        return this.isReviewOrderDisabled;
    }

    get isGuestReviewOrdrDisabled() {
        if ((this.firstName != '')
            && (this.lastName != '') && (this.phone != '') && (this.email != '') &&
            (this.shipName != '') && (this.shipStreet != '') && (this.shipCity != '') && (this.shipState != '') && (this.shipCountry != '') &&
            (this.shipZip != '') && (this.phone.length == 12)
        ) {
            if (this.isCreditCardSelected && this.isAddressDifferent) {
                if (this.cardName != '' && this.cardCity != '' && this.cardCountry != '' && this.cardState != '' && this.cardStreet != '' && this.cardZip != '') {
                    this.isReviewOrderDisabled = false;
                } else {
                    this.isReviewOrderDisabled = true;
                }
            } else if (this.isCreditCardSelected && !this.isAddressDifferent) {
                this.isReviewOrderDisabled = false;
            }
            if (!this.isBillAddressSame) {
                if (this.billName != '' && this.billStreet != '' && this.billCity != '' && this.billState != '' && this.billCountry != '' && this.billZip != '') {
                    this.isReviewOrderDisabled = false;
                } else {
                    this.isReviewOrderDisabled = true;
                }
            }
        } else {
            this.isReviewOrderDisabled = true;
        }
        return this.isReviewOrderDisabled;
    }

    handleReviewOrder() {
        this.authfail = false;
        if (!JSON.parse(this.template.querySelector('.Cart-button2').getAttribute('aria-disabled'))) {

            this.isReviewOrderDisabled = true;
            if (this.enableLogs) console.log('license', this.showLicense, 'onetimeshipping', this.oneTimeShipping);

            if (this.showLicense == true && this.isGuest == false) {
                if (this.sameLicense == true) {
                    if (this.oneTimeShipping == true) {
                        this.shippingNameS = this.oneTimeShipName;
                        this.shippingNumberS = '';
                        this.shippingCityS = this.oneTimeShipCity
                        this.shippingStreetS = this.oneTimeShipStreet;
                        this.shippingStateS = this.oneTimeShipProvince;
                        this.shippingzipCodeS = this.oneTimeShipPostalCode;
                        this.shippingCountryS = this.oneTimeShipCountry;
                    } else {
                        this.shippingNameS = this.curaddress[0].Shipto_name__c;
                        this.shippingNumberS = this.curaddress[0].SAP_Shipto__c;
                        this.shippingCityS = this.curaddress[0].Shipping_City__c;
                        this.shippingStreetS = this.curaddress[0].Shipping_Street__c;
                        this.shippingStateS = this.curaddress[0].Shipping_State__c;
                        this.shippingzipCodeS = this.curaddress[0].Shipping_Zip_Code__c;
                        this.shippingCountryS = this.curaddress[0].Shipping_Country__c;
                    }
                    if (this.enableLogs) console.log('name', this.shippingNameS, ' city ', this.shippingCityS, ' state ', this.shippingStateS, ' country ', this.shippingCountryS, ' street ', this.shippingStreetS, ' numbr', this.shippingNumberS, ' zipcode', this.shippingzipCodeS);
                    updateLicenseToAddress({
                        cartID: this.cartId,
                        name: this.shippingNameS,
                        street: this.shippingStreetS,
                        city: this.shippingCityS,
                        state: this.shippingStateS,
                        country: this.shippingCountryS,
                        postalCode: this.shippingzipCodeS,
                        shipToNumber: this.shippingNumberS

                    })
                        .then(result => {
                            if (this.oneTimeShipping == true) {
                                this.handleOneTimeShipAddress();
                            }
                            if (this.isCreditCardSelected) {
                                this.submitform();
                            } else if (!this.isGuest && this.isPoSelected && !this.oneTimeShipping) {
                                this.createOrder();
                            }

                        })
                        .catch(error => {
                            this.caseError = error;
                            console.log('error', error);
                            if (this.oneTimeShipping == true) {
                                this.handleOneTimeShipAddress();
                            }
                            if (this.isCreditCardSelected) {
                                this.submitform();
                            } else if (!this.isGuest && this.isPoSelected && !this.oneTimeShipping) {
                                this.createOrder();
                            }

                        })
                } else {
                     if (this.oneTimeShipping == true) {
                        this.handleOneTimeShipAddress();
                    }
                    if (this.isCreditCardSelected) {
                        this.submitform();
                    } else if (!this.isGuest && this.isPoSelected && !this.oneTimeShipping) {
                        this.createOrder();
                    }
                   
                }
            } else {
                 if (this.oneTimeShipping == true) {
                    this.handleOneTimeShipAddress();
                }
                if (this.isCreditCardSelected) {
                    this.submitform();
                } else if (!this.isGuest && this.isPoSelected && !this.oneTimeShipping) {
                    this.createOrder();
                }
               
            }
        }
    }

    get options() {
        return this.options;
    }

    createGuestOrder(event) {
        this.institutionDetails = {
            displayInstitution: this.displayInstitution,
            institutionName: this.institutionName,
            institutionType: this.institutionType,
            iAm: this.iAm
        }
        const shipAddressMap = {
            shipName: this.shipName,
            shipFloor: this.shipFloor,
            shipZip: this.shipZip,
            shipStreet: this.shipStreet,
            shipCity: this.shipCity,
            shipCountry: this.shipCountry,
            shipState: this.shipState,
        };
        var billAddressMap = {};
        if (!this.isBillAddressSame) {
            billAddressMap = {
                billName: this.billName,
                billFloor: this.billFloor,
                billZip: this.billZip,
                billStreet: this.billStreet,
                billCity: this.billCity,
                billCountry: this.billCountry,
                billState: this.billState,
            };
        }
        createGuestOrderRecord({
            firstName: this.firstName.trim(), lastName: this.lastName.trim(), phone: this.phone.trim(), email: this.email, ship_email: this.ship_email,
            RequestedShipDate: this.RequestedShipDate, ShipToAttention: this.ShipToAttention,
            cartId: this.guestCartId, guestAccountId: this.guestAccountId, promoCd: this.promoCode, shippingServiceLvl: this.serviceValue,
            cardDetails: event, shipAddressMap: shipAddressMap, isBillAddressSame: this.isBillAddressSame, billAddressMap: billAddressMap, institutionDetails: this.institutionDetails

        }).then(response => {
            if (this.enableLogs) console.log('response is', response);
            this.activeOrderId = response;
            setTimeout(() => {
                this.showReviewOrderDetails = true;
            }, 2000);
            this.checkOutPage = false;
        }).catch(error => {
            console.log('error is', error);
            // alert('Something went wrong during order creation. Please try again after some time.');
            this.authfail = true;
            this.isLoading1 = false;
            this.clearValues();
        }).finally(() => {

        });
    }

    createOrder(event) {
        createOrderRecord({
            firstName: this.firstName.trim(), lastName: this.lastName.trim(), phone: this.phone.trim(), email: this.email, ship_email: this.ship_email,
            RequestedShipDate: this.RequestedShipDate, BillToAttention: this.BillToAttention, ShipToAttention: this.ShipToAttention, Warehouse: this.WarehouseText,
            DeliveryContactPhone: this.DeliveryContactPhone.trim(), DeliveryContactEmail: this.DeliveryContactEmail.trim(), cartID: this.cartId, promoCd: this.promoCode, shippingServiceLvl: this.serviceValue, delivryInstruction: this.deliveryInstruction,
            isCreditCardSelected: this.isCreditCardSelected, cardDetails: event, poNumber: this.poNumber, isProvisionDisabled: this.isProvisionDisabled, lName: this.lName, lStreet: this.lStreet, lCity: this.lCity, lCountry: this.lCountry, lPostalCode: this.lPostalCode

        }).then(response => {
            if (this.enableLogs) console.log('response is', response);
            this.activeOrderId = response;
            setTimeout(() => {
                this.showReviewOrderDetails = true;
            }, 2000);
            this.checkOutPage = false;
        }).catch(error => {
            console.log('error is', error);
            // alert('Something went wrong during order creation. Please try again after some time.');
            this.authfail = true;
            this.isLoading1 = false;
            this.clearValues();
        }).finally(() => {

        });
    }

    loadRelatedShipping() {
        getRelatedShippingAddress()
            .then(result => {
                this.Shipaddress = result;
                if (this.enableLogs) console.log('result of load related ship address is', this.Shipaddress);
                this.applyFilterss();
            })
            .catch(error => {
                this.cases = undefined;
                this.caseError = error;
            });
    }
    testPhone = '';

    handlePhoneNumberInput(event) {
        let input1 = event.target.value.replace(/\D/g, '');
        //let input = input1.substring(0,10);
        let input = input1.slice(0, 10);
        input = input.replace(/[^0-9.]/g, '');
        if (input.length > 3 && input.length <= 6) {
            input = input.replace(/^(\d{3})(\d+)/, '$1-$2');
        } else if (input.length > 6 && input.length <= 10) {
            input = input.replace(/^(\d{3})(\d{3})(\d+)/, '$1-$2-$3');
        }
        else if (input.length > 10) {
            input = input.replace(/^(\d{3})(\d{3})(\d{4})(\d+)/, '$1-$2-$3');
        }
        if (event.target.name == 'Phone') {
            this.phone = input;
            event.target.value = input;
            this.testPhone = this.phone;
        } else if (event.target.name == 'DeliveryContactPhone') {
            this.DeliveryContactPhone = input;
            event.target.value = input;
        }
    }


    handleReviewOrderData(event) {
        if (event.target.name == 'FirstName') {
            this.firstName = event.target.value;
        }

        if (event.target.name == 'LastName') {
            this.lastName = event.target.value;
        }

        if (event.target.name == 'Phone') {
            this.phone = event.target.value;
        }

        if (event.target.name == 'OrderConfirmationEmail') {
            this.email = event.target.value;
        }

        if (event.target.name == 'ShipmentConfirmationEmail') {
            this.ship_email = event.target.value;
        }

        if (event.target.name == 'RequestedShipDate') {
            this.RequestedShipDate = event.target.value;
        }

        if (event.target.name == 'BillToAttention') {
            this.BillToAttention = event.target.value;
        }

        if (event.target.name == 'ShipToAttention') {
            this.ShipToAttention = event.target.value;
        }

        if (event.target.name == 'WarehousText') {
            this.WarehouseText = event.target.value;
        }

        if (event.target.name == 'DeliveryContactPhone') {
            this.DeliveryContactPhone = event.target.value;
        }

        if (event.target.name == 'DeliveryContactEmail') {
            this.DeliveryContactEmail = event.target.value;
        }

        if (event.target.name == 'PromoCode') {
            this.promoCode = event.target.value;
        }

        if (event.target.name == 'radioGroup1') {
            this.shippingServiceLevel = event.target.value;
        }

        if (event.target.name == 'shipping/delivery Instruction') {
            this.deliveryInstruction = event.detail.value;
        }
    }

    get ShippingInstructionOptions() {
        return this.ShippingInstructionOptions1;
    }

    handleOrderStatusChange(event) {
        this.ShippingInstructionValue = event.target.value;
    }

    closeModal1() {
        this.openModal = false;
        this.selectedAccountId = '';
        this.closeModal = true;
        this.searchTermShip = '';
        this.resetModalState();
        const button = this.template.querySelector(".shipto-address-change-link");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }
        this.isChangeAddDisabled = true;

    }

    showLicenseToAddressModal() {
        this.openLicenseToModal = true;
        this.closeLicenseToModal = false;
        this.loadRelatedShipping();
    }

    closeLicenseToModal1() {
        this.selectedAccountLicenseId = '';
        this.isChangeAddDisabled = true;
        this.openLicenseToModal = false;
        this.closeLicenseToModal = true;
        this.isChangeAddDisabled = true;
        this.searchTermShip = '';

    }
    clearFilterInput() {
        this.searchTermShip = '';
        this.applyFilterss();
    }

    handleUserInputsShip(event) {
        this.searchTermShip = event.target.value.toLowerCase();
        this.applyFilterss();
    }

    applyFilterss() {
        if (!this.Shipaddress) {
            this.filteredresultt = this.Shipaddress;
            return;
        }
        const searchter = this.searchTermShip;
        if (this.enableLogs) console.log('the value coming in ship filter is', this.Shipaddress, 'value in the ship search term is', searchter)
        this.filteredresultt = this.Shipaddress.filter(Shipaddresss => {
            const shipAccName = Shipaddresss.SAccountName;
            const shipPostalCode = Shipaddresss.PostalCode;
            if (shipAccName == undefined && shipAccName == '' && shipPostalCode == undefined && shipPostalCode == '') {
                return;
            }
            if (shipAccName !== undefined && shipAccName !== '' && shipPostalCode !== undefined && shipPostalCode !== '') {

                return (
                    (Shipaddresss.SAccountName.toLowerCase().includes(searchter))
                    || (Shipaddresss.PostalCode.toLowerCase().includes(searchter))

                );
            }
            if ((shipAccName != undefined && shipAccName != '') && (shipPostalCode == undefined || shipPostalCode == '')) {
                return (
                    (Shipaddresss.SAccountName.toLowerCase().includes(searchter))

                );
            }
            if ((shipAccName == undefined || shipAccName == '') && (shipPostalCode != undefined && shipPostalCode != '')) {
                return (
                    (Shipaddresss.PostalCode.toLowerCase().includes(searchter))

                );
            }
        });
        if (this.enableLogs) console.log('filtered list is', this.filteredresultt);
        this.lengthShipAddress = this.filteredresultt.length;
        this.totalShipToRecords = this.lengthShipAddress;

        if (this.lengthShipAddress > 1) {
            this.showShipChangeButton = true;
        }

    }

    @track sName;
    @track sStreet;
    @track sCity;
    @track sProvince;
    @track sCountry;
    @track sPostalCode;
    @track sSAPShipto;
    @track lSAPShipto


    handleShipRowClick(event) {
        this.sName = event.target.dataset.addressName;
        this.sStreet = event.target.dataset.addressStreet;
        this.sCity = event.target.dataset.addressCity;
        this.sProvince = event.target.dataset.addressProvionce;
        this.sCountry = event.target.dataset.addressCountry;
        this.sPostalCode = event.target.dataset.addressPostalCode;
        this.selectedShipAccountId = event.currentTarget.dataset.recordId;
        this.sSAPShipto = event.target.dataset.shipToNumber;
        this.isChangeAddDisabled = false;
    }

    handleLicenseRowClick(event) {
        this.lName = event.target.dataset.addressName;
        this.lStreet = event.target.dataset.addressStreet;
        this.lCity = event.target.dataset.addressCity;
        this.lProvince = event.target.dataset.addressProvionce;
        this.lCountry = event.target.dataset.addressCountry;
        this.lPostalCode = event.target.dataset.addressPostalCode;
        this.lSAPShipto = event.target.dataset.shipToNumber;
        this.lelectedShipAccountId = event.currentTarget.dataset.recordId;
        this.isChangeAddDisabled = false;

    }

    handleChange(event) {
        this.newPromoCode = (event.target.value).toUpperCase();
        this.promoCodeValue = (event.target.value).toUpperCase();
        if (this.enableLogs) console.log("newPromo>>", this.newPromoCode);
    }

    @api childCartPage = false;

    closeShowDeliveryDetails() {
        this.childCartPage = true;
        this.dispatchEvent(new CustomEvent('closecheckout', {
            detail: this.childCartPage

        }));
        if (this.enableLogs) console.log("cart value in checkout" + this.childCartPage);
    }
    resetModalState() {
        this.isChangeAddDisabled = true;
        this.selectedShipAccountId = null;
    }

    showchangeAddressModal() {
        this.resetModalState();
        this.openModal = true;
        this.closeModal = false;
        setTimeout(() => {
            this.attachChangeListeners();
        }, 500);

        setTimeout(() => {
            this.template.querySelector('.emailRprtCloseBtn').focus();
        }, 100);

        this.focusCloseButton();
    }

    handleUpdateShipAddress(event) {
        this.searchTermShip = '';
        this.selectedAccountId = '';
        if (!JSON.parse(this.template.querySelector('.changeAddress').getAttribute('aria-disabled'))) {

            if (!this.isChangeAddDisabled) {
                if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
                    updateShipAddress({
                        cartID: this.cartId, name: this.sName, street: this.sStreet, city: this.sCity,
                        province: this.sProvince, postalCode: this.sPostalCode, country: this.sCountry, shipToNumber: this.sSAPShipto
                    })
                        .then(result => {
                            if (this.enableLogs) console.log('Address Updated Successfully');
                            this.curaddress = [...this.curaddress]; // Trigger reactivity
                            // Update the main view address
                            const selectedAddress = this.filteredresultt.find(addr => addr.AccShipId === this.selectedShipAccountId);
                            if (selectedAddress) {
                                this.curaddress[0] = {
                                    Account: { Name: selectedAddress.SAccountName },
                                    Shipto_name__c: selectedAddress.SAccountName,
                                    Shipping_City__c: selectedAddress.ShippingCity,
                                    Shipping_Country__c: selectedAddress.ShippingCountry,
                                    Shipping_State__c: selectedAddress.Provionce,
                                    Shipping_Street__c: selectedAddress.ShipStreet,
                                    Shipping_Zip_Code__c: selectedAddress.PostalCode
                                };
                            }
                            this.openModal = false;
                        })
                        .catch(error => {
                            this.caseError = error;
                        })

                        .finally(() => {
                            if (this.enableLogs) {
                                console.log('this.curraddres', this.curaddress);
                            }
                            setTimeout(() => {
                                this.selectDefaultElement();
                            }, 500);

                            this.openModal = false;

                        });
                }
            }
        }
        this.isChangeAddDisabled = true;
    }


    SaveLicenseMethod(event) {
        this.searchTermShip = '';
        this.selectedAccountLicenseId = '';
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            updateLicenseToAddress({
                cartID: this.cartId, name: this.lName, street: this.lStreet, city: this.lCity,
                province: this.lProvince, postalCode: this.lPostalCode, country: this.lCountry, shipToNumber: this.lSAPShipto
            })
                .then(result => {
                    if (this.enableLogs) console.log('Address Updtaed Successfully');
                    this.ShowLicenseAddress = true;
                    this.licenseCurAddress = {
                        accountName: this.lName,
                        Lcity: this.lCity,
                        lStreet: this.lStreet,
                        lProvionce: this.lProvince,
                        lPostalcode: this.lPostalCode,
                        lCountry: this.lCountry
                    };

                    this.openLicenseToModal = false;
                    this.closeLicenseToModal = true;
                })
                .catch(error => {
                    this.caseError = error;
                    console.log('error', error);
                })
        }
        this.isChangeAddDisabled = true;
    }



    handleOneTimeAddressChange(event) {
        this.oneTimeShipName = event.target.oneTimeShippingName;
        this.oneTimeShipStreet = event.target.street;
        this.oneTimeShipCity = event.target.city;
        this.oneTimeShipProvince = event.target.province;
        this.oneTimeShipCountry = event.target.country;
        this.oneTimeShipPostalCode = event.target.postalCode;
    }
    handleOneTimeShipAddressChange(event) {

        if (event.target.label == this.nameLabel) {
            this.oneTimeShipName = event.target.value;
        }
        if (event.target.label == this.streetLabel) {
            this.shippingStreet = event.target.value;
        }
        if (event.target.label == this.floorLabel) {
            this.shippingFloor = event.target.value;
            this.shipFloor = event.target.value;
        }
        if (event.target.label == this.cityLabel) {
            this.oneTimeShipCity = event.target.value;
            this.shipCity = event.target.value;
        }
        if (event.target.label == this.zipLabel) {
            this.oneTimeShipPostalCode = event.target.value;
            this.shipZip = event.target.value;
        }
        if (event.target.label == this.stateLabel) {
            this.oneTimeShipProvince = event.detail.value;
            this.shipState = event.detail.value;
        }
        if (event.target.label == this.countryLabel) {
            this.oneTimeShipCountry = event.detail.value;
            this.shipCountry = event.target.value;
        }
        this.oneTimeShipStreet = this.shippingFloor + ' ' + this.shippingStreet;

    }

    handleOneTimeShipAddress(event) {
        updateShipAddress({
            cartID: this.cartId, name: this.oneTimeShipName, street: this.oneTimeShipStreet, city: this.oneTimeShipCity,
            province: this.oneTimeShipProvince, postalCode: this.oneTimeShipPostalCode, country: this.oneTimeShipCountry, shipToNumber: ''
        })
            .then(result => {
                if (this.enableLogs) console.log('One time Ship Address Updtaed Successfully');
                if (!this.isCreditCardSelected) {
                    this.createOrder();
                }
            })
            .catch(error => {
                if (!this.isCreditCardSelected) {
                    this.createOrder();
                }
                this.caseError = error;

            })
    }

    cartSimulateCall() {
        if (this.enableLogs) console.log('inside cartSimulation call - this.activeCartId>>>', this.cartId);
        const cartSimulateBefore = Date.now();
        cartSimulation({ cartId: this.cartId, appSettingsName: 'ensxtx_SR_enosixWebCartB2BAppSettings' })
            .then(({ data, messages }) => {
                const cartSimulateAfter = Date.now();
                if (this.enableLogs) console.log('Cart Simulate load time in seconds is', (cartSimulateAfter - cartSimulateBefore) / 1000);
                if (this.enableLogs) console.log('cartSimulation data>>>', data);
                messages.forEach(item => {
                    let enosixMSg = item.message;
                    if (this.enableLogs) console.log('TransactLogsensxtx_Message__c', enosixMSg);
                    const regex = /credit check/i;
                    this.showErrorMSG = (regex.test(enosixMSg));
                });
                this.responseBody = JSON.stringify(data.TransactLogs);
                this.logType = 'Enosix Cart Simulation';
                this.requestBody = this.cartId;
                this.statusLog = 'Success';
                this.internalStatus = '';
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_checkOutLWC/cartSimulateCall/cartSimulation');
            })
            .catch(error => {
                console.log('cart simulation error>>>>', error);
                this.logType = 'Enosix Cart Simulation';
                this.requestBody = this.cartId;
                this.statusLog = 'Error';
                this.internalStatus = JSON.stringify(error);
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_checkOutLWC/cartSimulateCall/cartSimulation');
            })
            .finally(() => {
                this.handleFetchCartData();
                this.fetchUserData();
            })
    }

    @track showPromoConfirmation = false;
    @track showInvalidPromo = false;
    @track discountValue;
    @track finalPrice;

    handleApplyClick() {
        if (this.enableLogs) console.log('Current promoCode:', this.promoCode, '   New promoCode: ', this.newPromoCode);

        if (this.promoCode == '' || this.promoCode == null) {
            this.updatePromoCode();
        }
        else if (this.newPromoCode !== this.promoCode) {
            this.showPromoConfirmation = true;
        }
        setTimeout(() => {
            this.template.querySelector('.closebtnOnFocus').focus();
        }, 100);

        this.focusCloseButton();
    }

    closePromoPopUp() {
        this.showPromoConfirmation = false;
        const button = this.template.querySelector(".apply-btn");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }

    }
    updatePromoCode() {
        getPromoCode({ promocode: this.newPromoCode, activeCartId: this.cartId })
            .then(result => {
                if (this.enableLogs) console.log('im in handle review cart', result);
                if (result) {
                    this.promoCode = this.newPromoCode;
                    this.promoCodeValue = this.newPromoCode;
                    if (this.isGuest) {
                        this.guesCartSimulateCall();
                    } else {
                        this.cartSimulateCall();
                    }
                } else {
                    this.discountValue = 0.00;
                    this.promoCodeValue = ''; // Clear the promo code
                    if (this.enableLogs) console.log('Invalid Discount Value');
                    this.showInvalidPromo = true; // Show the invalid promo popup
                }
            })
            .catch(error => {
                console.log('updatePromoCode error', error);
                this.cases = undefined;
                this.caseError = error;
            });


        this.showPromoConfirmation = false;
        this.showLoader = true;
        setTimeout(() => {
            this.showLoader = false;
        }, 1000);

        setTimeout(() => {
            this.template.querySelector('.closebtnOnFocus').focus();
        }, 100);

        this.focusCloseButton();



    }
    closeInvalidPromoPopUp() {
        this.showInvalidPromo = false;
        this.promoCodeValue = ''; // Clear the promo code field
        const button = this.template.querySelector(".apply-btn");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }

    }

    //Trap focus inside modal
    focusOutClose(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                if (this.template.querySelector('.Change-Address')) {
                    this.template.querySelector('.Change-Address').focus();
                }
            }
        }
    }
    focusOutButton(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.closebtnOnFocus').focus();
            }
        }
    }

    createLogs(logType, requestBody, responseBody, statusLog, internalStatus, entryPoint) {
        createIntegrationLogsLWC1({ logType: logType, requestBody: requestBody, responseBody: responseBody, status: statusLog, internalStatus: internalStatus, entryPoint: entryPoint })
            .then(result => {
                if (this.enableLogs) console.log('result is', result);
            })
            .catch(error => {
                if (this.enableLogs) {
                    console.log('error is', error);
                }
            })
    }

}