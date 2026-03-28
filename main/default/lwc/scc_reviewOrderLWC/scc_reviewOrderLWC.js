import { LightningElement,api,track,wire } from 'lwc';
import isGuestUser from '@salesforce/apex/scc_checkOutLWC_Controller.isGuestUser';
import getGuestCartDetails from '@salesforce/apex/scc_PaymetricIntegrationController.getGuestCartDetails';
import fetchOrderData from '@salesforce/apex/scc_checkOutLWC_Controller.fetchOrderData';
import getUserFriendlyErrorMessage from '@salesforce/apex/scc_EnosixOrderSubmissionErrors.getUserFriendlyErrorMessage';
import sendEmailToUser from '@salesforce/apex/scc_EnosixOrderSubmissionErrors.sendEmailToUser';
import updateCartStatus from '@salesforce/apex/scc_checkOutLWC_Controller.updateCartStatus';
import updateCartAndOrder from '@salesforce/apex/scc_EnosixOrderSubmissionErrors.updateCartAndOrder';
import fetchOrderItemData from '@salesforce/apex/scc_checkOutLWC_Controller.fetchOrderItemData';
import fetchCartDetails from '@salesforce/apex/scc_checkOutLWC_Controller.fetchCartDetails';
import scc_checkOut_ContactInfo_Text from '@salesforce/label/c.scc_checkOut_ContactInfo_Text';
import scc_reviewCartPage_SummaryHelpText from "@salesforce/label/c.scc_reviewCartPage_SummaryHelpText";
import scc_Order_Status_items from "@salesforce/label/c.scc_Order_Status_items";
import cartSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.cartSimulation';
import createSAPOrder from '@salesforce/apex/ensxtx_CTRL_Cart.createSalesDocument';
import {NavigationMixin} from 'lightning/navigation';
import getAllowDropShip from '@salesforce/apex/scc_confirmAddress.getAllowDropShip';
import callCloneOrderFunction from '@salesforce/apex/scc_cloneOrderController.cloneOrderController';
import getRelatedShippingAddress from '@salesforce/apex/scc_cloneOrderController.getCurrentUserShippingAddress';
import checkRestrictedCartItems from '@salesforce/apex/scc_cloneOrderController.checkRestrictedCartItems';
import scc_cloneOrder_message from "@salesforce/label/c.scc_cloneOrder_message";
import scc_Order_Case_Submitted from "@salesforce/label/c.scc_Order_Case_Submitted";
import scc_Guest_Order_Success_Message from "@salesforce/label/c.scc_Guest_Order_Success_Message";
import scc_cloneOrder_restricted_message from "@salesforce/label/c.scc_cloneOrder_restricted_message";
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import scc_brand_logo_mobile from "@salesforce/resourceUrl/scc_brand_logo_mobile";
import scc_checkout_cart from "@salesforce/resourceUrl/scc_checkout_cart";
import scc_checkout_cart_white from "@salesforce/resourceUrl/scc_checkout_cart_white";
import scc_print_icon from "@salesforce/resourceUrl/scc_print_icon";
import scc_Please_Wait_While_Your_Order_Is_Placed from '@salesforce/label/c.scc_Please_Wait_While_Your_Order_Is_Placed';
import scc_Clone_Order_Help_Text from '@salesforce/label/c.scc_Clone_Order_Help_Text';
import scc_Thank_You_For_Order_Confirmation_Text from '@salesforce/label/c.scc_Thank_You_For_Order_Confirmation_Text';
import scc_Cancel_Order_Date_Text from '@salesforce/label/c.scc_Cancel_Order_Date_Text';
import scc_Requested_Ship_Date from '@salesforce/label/c.scc_Requested_Ship_Date';
import scc_DFDomesticGround from '@salesforce/label/c.scc_DFDomesticGround';
import scc_AFDomesticAir from '@salesforce/label/c.scc_AFDomesticAir';
import scc_ACDomesticNextDay from '@salesforce/label/c.scc_ACDomesticNextDay';
import getSIOPurl from '@salesforce/apex/scc_checkSIOPRegistration.getSIOPurl';
import getSIOPOrderNumber from '@salesforce/apex/scc_checkSIOPRegistration.getSIOPOrderNumber';
import scc_Institution_Name from "@salesforce/label/c.scc_Institution_Name";
import scc_Institution_Type from "@salesforce/label/c.scc_Institution_Type";
import scc_Instution_Iam from "@salesforce/label/c.scc_Instution_Iam";
import fetchOrderItemDetails from '@salesforce/apex/scc_googleAnalyticsController.fetchOrderItemDetails';
import fetchCartDetailsGA from '@salesforce/apex/scc_googleAnalyticsController.fetchCartDetailsGA';
import { APPLICATION_SCOPE, createMessageContext, MessageContext, publish, releaseMessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import scc_MessageChannel from '@salesforce/messageChannel/scc_MessageChannel__c';
import scc_survey_link from "@salesforce/label/c.scc_survey_link";
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import digitalProductCheck from '@salesforce/apex/scc_reviewCartPageController.digitalProductsCheck';
import getSurveyPopupVisibility from '@salesforce/apex/scc_SurveyPopupController.getSurveyPopupVisibility';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
export default class Scc_reviewOrderLWC extends NavigationMixin(LightningElement) {
    alertIcon = imageIcons + '/Images/alert.png';
    @api childCartPage = false;
    @track totalPrice;
    @track promoCode;
    @track discountValue;
    @api orderId;
    @api cartId;
    @api institution;
    recordsToDisplay = []; //Records to be displayed on the page
    records = []; //No.of records to be displayed per page
    @track totalPages = 1; //Total no.of pages
    pageNumber = 1; //Page number
    @track showSIOP =false;
    @track isLoading3=false;
    @track isGuest = false;
    @track isRubiconAccount = false;
    guestCartId=''
    guestAccountId ='';
    @track guestCartSubtotal;
    @track guestCartTotal;
    @track guestCartDiscount;
    @track guestCartPromo;
    @track guestCartShipping = 'N/A';
    @track guestCartTax = 'N/A';
    @track productsInCart = '';
    @track enableLogs = false; 

    //Clone order
    @track openCloneModal = false;
    @track selectedAccountId;
    @track totalShipToRecords = 0;
    @track userInputs = [];
    @track searchTermShip ='';
    @track Shipaddress;
    @track lengthShipAddress;
    @track selectedShip;
    @track sName;
    @track shipName='';
    @track shippingCity = '';
    @track shippingCountry = '';
    @track shippingState = '';
    @track shippingStreet = '';
    @track shippingZip = '';
    @track ShippingToNumber='';
    @track addressNotSelected = true;
    @track allowDropShip= false;
    @track searchter= '';
    @track isChecked = false;
    @track showAvailableShipping = true;
    @track lengthShipAddress;
    @track selectedShipAddress = false;
    @track openReviewCartPage = false;
    @track activeCartId; 
    @track isRestrictedItem = false;
    @track lockMessage = false;
    @track displayError = false;
    @track caseSubmitted = false;
    @track errorMessage = '';
    @track contactSupport = true;
    @track isContactSupport = false;
    @track surveyModal = false;
    @track showRegistSIOPButton = false;
    crossIconUrl = imageIcons + '/Images/cross.png';
    lockIconUrl = imageIcons + '/Images/Lock.png';
    totalRecords = 0;
    pageSizeOptions = [15, 25, 50, 75, 100];
    pageNumber = 1; //Page number 
    numberOfRows = '15';
    displayedRecords=0;
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog ='';
    @track internalStatus ='';
    @track showLicense = false;
    @track oneTimeShipping = false;
    @track LicenseName='';
    @track controllModal=false;
    @track showLoader= true;


     @wire(MessageContext) messageContext;

    @wire(checkRestrictedCartItems, {cartId:'$cartId'})
     getRestrictedItems({data, error}){
         if(data){
             this.isRestrictedItem = data;
             this.lockMessage = true;
             this.allowDropShip = false;
          if (this.enableLogs)  console.log('checkRestrictedCartItems ',data);
        }
        else if(error){
            if (this.enableLogs) console.log('checkRestrictedCartItems error',error);
        }
        else{
            this.isRestrictedItem = data;
            this.lockMessage = false;
            if (this.enableLogs) console.log('checkRestrictedCartItems ',data);

        }
     }

    labels ={
        scc_checkOut_ContactInfo_Text,
        scc_DFDomesticGround,
        scc_AFDomesticAir,
        scc_ACDomesticNextDay,        
        scc_reviewCartPage_SummaryHelpText,
        scc_brand_logo_mobile,
        scc_Order_Status_items,
        scc_cloneOrder_message,
        scc_cloneOrder_restricted_message,
        scc_checkout_cart,
        scc_checkout_cart_white,
        scc_Please_Wait_While_Your_Order_Is_Placed,
        scc_Clone_Order_Help_Text,
        scc_Thank_You_For_Order_Confirmation_Text,
        scc_Cancel_Order_Date_Text,
        scc_Requested_Ship_Date,
        scc_print_icon,
        scc_Order_Case_Submitted,
        scc_Guest_Order_Success_Message,
        scc_Institution_Type,
        scc_Instution_Iam,
        scc_Institution_Name,
        scc_survey_link,
    }

    constructor() {
        super();
        this.pageSize = this.pageSizeOptions[0];
        isGuestUser().then(response => {            
           if (this.enableLogs) console.log('isGuestUser1',response);
            if(response){
                this.isGuest = true;
                const urlParams = new URLSearchParams(window.location.search);
                this.guestCartId = urlParams.get('CartId');
                this.cartId = this.guestCartId;
                this.guestAccountId = urlParams.get('aid');
                this.guesCcartSimulateCall();
                 if (this.enableLogs) console.log('institution',this.institution);
                this.fetchdigitalProductCheck();
                if(this.institution.displayInstitution){
                    this.displayInstitution = this.institution.displayInstitution;
                    this.institutionName = this.institution.institutionName;
                    this.institutionType = this.institution.institutionType;
                    this.iAm = this.institution.iAm;
                }
            }else{
                this.cartSimulateCall();
                this.fetchdigitalProductCheck();
            }
        }).catch(error => {
           if (this.enableLogs)  console.log('error is', error);
        })
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
       });
    }
    fetchdigitalProductCheck() {
        digitalProductCheck({ guestcartId: this.guestCartId })
            .then(result => {
               if (this.enableLogs) console.log('wireddigitalProductCheck', result);
                this.showLicense = result;
            })
            .catch(error => {
               if (this.enableLogs)  console.log('wireddigitalProductCheckerror', error);
            })
    }
    ISBN10 ="";
    ISBN13 ="";
    orderNumberID="";
    productName="";
    programName="";
    shippingCharges1="";
    orderItemList = [];
    customCartId ="";
    siteId = ""; 
    siteName = "";
    async connectedCallback(){
        await isGuestUser().then(response => {            
          if (this.enableLogs)  console.log('isGuestUser1',response);
            if(response){
                this.isGuest = true;
                const urlParams = new URLSearchParams(window.location.search);
                this.guestCartId = urlParams.get('CartId');
                this.cartId = this.guestCartId;
                this.guestAccountId = urlParams.get('aid');
               if (this.enableLogs) console.log('cartId connected',this.guestCartId);
               if (this.enableLogs) console.log('accountId connected',this.guestAccountId);
            }
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        })
       if (this.enableLogs) console.log("IsGuest connectedCallback", this.isGuest);
        if(this.isGuest){
            await getGuestCartDetails({guestCartId:this.cartId, guestAccountId:this.guestAccountId}).then(response => {
               if (this.enableLogs) console.log('getGuestCartDetails response is', response);
                this.isRubiconAccount = response.isRubiconAccount ? true : false;
                this.guestCartSubtotal = this.formatPrice(response.SubTotal && response.SubTotal != 0 ? '$ '+response.SubTotal : '$ 0.00');
                this.promoCode = response.Coupon ? response.Coupon : '';
                this.guestCartDiscount = response.CouponDiscount && response.CouponDiscount != 0 ? '-$ '+(response.CouponDiscount).replace('-','') : '$ 0.00';
                this.guestCartShipping =this.formatPrice( response.ShippingAmount && response.ShippingAmount !=0 ? '$ '+response.ShippingAmount : 'N/A');
                this.guestCartTax =this.formatPrice( response.Tax && response.Tax !=0 ? '$ '+response.Tax : 'N/A');
                this.guestCartTotal = this.formatPrice( response.Total && response.Total !=0 ? '$ '+response.Total : '$ 0.00');
                this.guestCartRetrieved = true;
                this.showLoader= false;
            }).catch(error => {
                if (this.enableLogs) console.log('error is', error);
            })
        }
        await fetchOrderItemDetails({ordrId:this.orderId
        }).then(response => {
         if (this.enableLogs) console.log('response of OrderItem is', response);
          let parseData = JSON.parse(JSON.stringify(response));
          this.records = JSON.parse(JSON.stringify(response));
          //this.recordsToDisplay = parseData;
          this.recordsToDisplay= parseData.map(item => ({
                ...item,
                ListPrice: this.formatPrice(item.ListPrice),
                UnitPrice:this.formatPrice(item.UnitPrice)
            }));
          this.records = this.recordsToDisplay;
          this.ISBN10 = parseData[0].ISBN10;
          this.ISBN13 = parseData[0].ISBN13;
          this.productName = parseData[0].productName;
          this.programName = parseData[0].programName;
          this.orderNumberID = parseData[0].orderNumber;
          this.requestedDeliveryDate = parseData[0].Requested_Delivery_Date!=null ? this.formatDate(parseData[0].Requested_Delivery_Date) : '';
          if (this.enableLogs) console.log('records >>>>', this.records);
          for(let k of parseData){
                this.orderItemList.push({
                    ISBN10: k.ISBN10?k.ISBN10:"",
                    ISBN13: k.ISBN13?k.ISBN13:"",
                    categoryId: "",
                    categoryName: "",
                    productID: "",
                    productName: k.Name?k.Name:"",
                    productSAPName: "",
                    programId: "",
                    programName: k.programName?k.programName:"",
                    programURL: "",
                    quantity: k.Quantity?k.Quantity:"",
                    shippingCharges: "",
                    subTotal: "",
                    taxes: "",
                    totalPrice: ""
                })
                            
          }
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
           })
        fetchCartDetailsGA({cartId: this.cartId})
           .then( response => {
            if (this.enableLogs) console.log('fetchCartData data>>>', response);
            this.customCartId = response.CartId?response.CartId:"";
            this.siteId = response.SiteId?response.SiteId:"";
            this.siteName = response.SiteName?response.SiteName:"";
            this.totalPrice = this.formatPrice(response.SubTotal && response.SubTotal !=0  ? '$ '+response.SubTotal : '$ 0.00');
            this.promoCode = response.Coupon ? response.Coupon : '';
            this.discountValue = response.CouponDiscount  && response.CouponDiscount !=0 ? '-$ '+(response.CouponDiscount).replace('-','') : '$ 0.00';
            this.shippingCharges = this.formatPrice(response.ShippingAmount && response.ShippingAmount !=0 ? '$ '+response.ShippingAmount : 'N/A');
            this.tax =this.formatPrice( response.Tax && response.Tax !=0 ? '$ '+response.Tax : 'N/A');
            this.finalPrice = this.formatPrice( response.Total && response.Total !=0  ? '$ '+response.Total : '$ 0.00');
            this.dispatchGAEvent();
        })
        .catch(error => {
             if (this.enableLogs) console.log('Fetch Cart  error>>>>',error);
        })
            
        this.isLoading3 = true;
        if (this.enableLogs) console.log('isGuest',this.isGuest);
        if (this.enableLogs) console.log('the order id coming from checkout',this.orderId);
        this.handleLoadOrderData();
        this.handleLoadOrderItemData();
        this.isLoading3 = false;
       this.template.addEventListener('keydown', this.handleKeydown.bind(this));
        this.PopupVisibility();

    }
    dispatchGAEvent(){
        this.dispatchEvent(new CustomEvent("revieworder",{
                detail:{
                    cart:{
                        cartId:this.cartId,
                        orderId:this.orderNum,
                        shippingCharges: this.isGuest?this.guestCartShipping:this.shippingCharges,
                        subTotal: this.isGuest?this.guestCartSubtotal:this.totalPrice,
                        taxes: this.isGuest?this.guestCartTax:this.tax,
                        totalPrice: this.isGuest?this.guestCartTotal:this.finalPrice
                    },
                    form:{
                        formId: "",
                        formKeycode: "",
                        formName: "",
                        pid: ""
                    },
                    institution:{
                        InstitutionID: "",
                        InstitutionName: this.institutionName?this.institutionName:"",
                        InstitutionType: this.institutionType?this.institutionType:""
                    },
                    page:{
                        breadcrumb: this.orderConfirm == true? "Order Confirmation":"Review Order",
                        currentPromoCode: this.promoCode,
                        currentPromoDescription: this.promoCode!=""?"Promo "+this.promoCode+" is applied.":"",
                        locator: "",
                        pageId: "",
                        pageName: this.orderConfirm == true? "Order Confirmation":"Review Order",
                        pageType: ""
                    },
                    pmdb:{
                        categoryId: "",
                        programId: "",
                        siteId: "",
                        solutionId: "",
                        subCategoryId: "",
                        subSolutionId: "",
                        subjectAreaId: ""
                    },
                    products:this.orderItemList,
                    program:{
                        programInfo:"",
                        categoryID: "",
                        categoryName: "",
                        programId: "",
                        programName: "",
                        programURL: ""
                    },
                    site:{
                        siteCategory: "",
                        siteDomain: "",
                        siteFamilyName: "",
                        siteId: this.siteId,
                        siteName: this.siteName
                    }
                    

                }
            }))
    }


   disconnectedCallback() {
        // Remove the keydown event listener when the component is removed from the DOM
        this.template.removeEventListener('keydown', this.handleKeydown);
    }

     handleKeydown(event) {
        // Handle the keydown event
        if (event.key === 'Escape') {
            if(this.surveyModal){
                this.handleCloseSurveyModalClick();
            }
            else if(this.openCloneModal){
                this.closeModal1();
            }
            
        }
    }

    @track displayInstitution = false;
    @track institutionName;
    @track institutionType;
    @track iAm;
    @track contactName ='';
    @track phone ='';
    @track orderConfirmationEmail ='';
    @track shipmentConfirmationEmail ='';
    @track billToAttention ='';
    @track shipToAttention ='';
    @track cancelBackOrderDate ='';
    @track warehouse ='';
    @track pCode='';
    @track shippingAccount='';
    @track shippingStreet1='';
    @track ShippingCity1='';
    @track ShippingState1='';
    @track ShippingCountry1='';
    @track ShippingPostalCode1='';
    @track shippingCharges = 'N/A';
    @track tax = 'N/A';
    @track shippingServiceLevel='';
    @track orderConfirm = false;
    @track orderNum = '';
    @track isPurchaseOrder = false;
    @track shippingInstruction = '';
    @track billName='';
    @track BillingStreet1='';
    @track BillingCity1='';
    @track BillingState1='';
    @track BillingCountry1='';
    @track ShippingPostalCode='';
    @track sapShipTo='';
    @track sapBillTo='';
    @track sapLicenceTo='';
    @track LicenceToStreet ='';
    @track LicenseToCity = '';
    @track LicenseToPostalCode='';
    @track LicenseToState ='';
    @track LicenseToCountry= '';
    @track deliveryPhone='';
    @track deliveryEmail='';
    @track requestedDeliveryDate='';
    @track orderData;

    formatDate(date) {
        const [year, month, day] = date.split('-');
        return `${month}/${day}/${year}`;
    }
    formatPrice(price) {
    if(this.enableLogs){
       if (this.enableLogs)   console.log('Price input:', price, 'Type:', typeof price);
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
        return '$'+ formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    } catch (error) {
        console.error('Error formatting price:', error, 'Price value:', price);
        return 'N/A';
    }
}

    transformedServiceLevel(shipcond){
        switch(shipcond){
            case 'DF':
               return scc_DFDomesticGround ;
            case 'AF':
                return scc_AFDomesticAir ;
            case 'AC':
                 return scc_ACDomesticNextDay ;
            case 'ISS':
                return 'International Standard Shipping' ;
            default :
                 return 'N/A';
        }
    }
    transformedDiscount(dis){
        switch(dis){
            case 'ZNET':
               return 'Net' ;
            case 'ZCON':
                return 'Con' ;

            default :
                 return '';
        }
    }

    handleLoadOrderData(){
       fetchOrderData({ordrId:this.orderId
        }).then(response => {
          if (this.enableLogs) console.log('fetchOrderData response', response);
            this.orderData = JSON.parse(JSON.stringify(response));
            let data = this.orderData.map(service =>{
                return{
                    ...service,
                    Shipping_Conditions__c: this.transformedServiceLevel(service.Shipping_Conditions__c)
                };
            });
            this.contactName = data[0].Contact_First_Name__c+' '+data[0].Contact_Last_Name__c;
            this.phone = data[0].BillingPhoneNumber;
            this.orderConfirmationEmail = data[0].Customer_Email__c;
            this.shipmentConfirmationEmail = data[0].Shipment_Confirmation_Email__c;
            this.billToAttention = data[0].Attention_Billing__c;
            this.shipToAttention = data[0].Attention_Shipping__c;
            this.warehouse = data[0].Warehouse_text__c;
            this.pCode = data[0].Coupon__c;
            this.shipName = data[0].ShipTo_Name__c;
            this.shippingAccount= data[0].AccountId.Name;
            this.shippingStreet1 = data[0].ShippingStreet;
            this.ShippingCity1 = data[0].ShippingCity;
            this.ShippingState1 = data[0].ShippingState;
            this.ShippingCountry1 = data[0].ShippingCountry;
            this.ShippingPostalCode1 = data[0].ShippingPostalCode;
            this.shippingServiceLevel= data[0].Shipping_Conditions__c;
            this.orderNum = data[0].OrderNumber;
            this.isPurchaseOrder = data[0].isPOSelected__c;
            this.PurchaseOrderNum= data[0].PoNumber__c;
            this.shippingInstruction = data[0].Shipping_instruction__c;
            this.billName = data[0].BillingName__c;
            this.BillingStreet1 = data[0].BillingStreet;
            this.BillingCity1 = data[0].BillingCity;
            this.BillingState1 = data[0].BillingState;
            this.BillingCountry1 = data[0].BillingCountry;
            this.BillingPostalCode1 = data[0].BillingPostalCode;
            this.sapShipTo = data[0].SAP_Shipto__c;
            this.sapBillTo = data[0].SAP_BillTo__c;
            this.sapLicenceTo =data[0].License_Partner__c;
            this.LicenceToStreet = data[0].License_To__Street__s;
            this.LicenseToCity = data[0].License_To__City__s;
            this.LicenseToPostalCode = data[0].License_To__PostalCode__s;
            this.LicenseToState= data[0].License_To_State__c;
            this.LicenseToCountry = data[0].License_To_Country__c;
            this.LicenseName= data[0].License_To_Name__c;
            this.oneTimeShipping = data[0].	Has_One_Time_Ship__c;
            this.deliveryEmail = data[0].Delivery_Contact_Email__c;
            this.deliveryPhone = data[0].Delivery_Contact_Phone__c;
            this.showLoader= false;
        }).catch(error => {
            if (this.enableLogs)  console.log('error is', error);
        })
    }

    handleLoadOrderItemData(){
        fetchOrderItemData({ordrId:this.orderId
        }).then(response => {
         if (this.enableLogs)  console.log('response of OrderItem is', response);
          let parseData = JSON.parse(JSON.stringify(response));
          let data = JSON.parse(JSON.stringify(response));
          this.records  = data.map(discount =>{
                return{
                    ...discount,
                    Discount: this.transformedDiscount(discount.Discount),
                    ListPrice: this.formatPrice(discount.ListPrice),
                    UnitPrice:this.formatPrice(discount.UnitPrice)
                };
            });

         // this.recordsToDisplay = parseData;
          this.recordsToDisplay= parseData.map(item => ({
                ...item,
                ListPrice: this.formatPrice(item.ListPrice),
                UnitPrice:this.formatPrice(item.UnitPrice)
            }));
          
          this.requestedDeliveryDate = parseData[0].Requested_Delivery_Date!=null ? this.formatDate(parseData[0].Requested_Delivery_Date) : '';
          this.totalRecords = response.length;
          this.totalCount = response.length;
          if (this.enableLogs) console.log('records >>>>', this.records);
          this.paginationHelper();
        }).catch(error => {
            if (this.enableLogs)  console.log('error is', error);
           })
    }
    @track plusValue=0.00;
    @track finalPrice;

    cartSimulateCall() {
        if (this.enableLogs) console.log('inside cartSimulation call - this.activeCartId>>>', this.cartId);
        cartSimulation({ cartId: this.cartId, appSettingsName: 'ensxtx_SR_enosixWebCartB2BAppSettings' })
        .then(data => {
            if (this.enableLogs) console.log('cartSimulation data>>>', data);
            this.responseBody = JSON.stringify(data.TransactLogs);
            this.logType ='Enosix Cart Simulation';
            this.requestBody = this.cartId;
            this.statusLog= 'Success';
            this.internalStatus='';
            this.createLogs(this.logType,this.requestBody,this.responseBody,this.statusLog,this.internalStatus,'Scc_reviewOrderLWC/cartSimulateCall/cartSimulation');
        })
        .catch(error => {
            if (this.enableLogs)  console.log('cart simulation error>>>>',error);
            this.logType ='Enosix Cart Simulation';
            this.requestBody =this.cartId;
            this.statusLog= 'Error';
            this.internalStatus=JSON.stringify(error);
            this.createLogs(this.logType,this.requestBody,this.responseBody,this.statusLog,this.internalStatus,'Scc_reviewOrderLWC/cartSimulateCall/cartSimulation');
        })
        .finally(() => {
            this.handleFetchCartData();
        });
    }

    guesCcartSimulateCall() {
        cartSimulation({ cartId: this.cartId, appSettingsName: 'ensxtx_SR_enosixWebCartB2BAppSettings' })
        .then(({ data, messages }) => {
            if (this.enableLogs) console.log('cartSimulation data>>>', data);
            if (this.enableLogs) console.log('cartSimulation message>>>', messages);
            if(data!= undefined && data.IsSuccess){
                if (this.enableLogs) console.log('Cart Simulation successful');
            }
            this.responseBody = JSON.stringify(data.TransactLogs);
            this.logType ='Enosix Cart Simulation';
            this.requestBody = this.cartId;
            this.statusLog= 'Success';
            this.internalStatus='';
            this.createLogs(this.logType,this.requestBody,this.responseBody,this.statusLog,this.internalStatus,'Scc_reviewOrderLWC/guesCcartSimulateCall/cartSimulation');
        })
        .catch(error => {
             if (this.enableLogs) console.log('cart simulation error>>>>',error);
            this.logType ='Enosix Cart Simulation';
            this.requestBody =this.cartId;
            this.statusLog= 'Error';
            this.internalStatus=JSON.stringify(error);
            this.createLogs(this.logType,this.requestBody,this.responseBody,this.statusLog,this.internalStatus,'Scc_reviewOrderLWC/guesCcartSimulateCall/cartSimulation');
        }).finally(() => {
            this.fetchGuestCartDetails();
        });
    }

    fetchGuestCartDetails(){
        getGuestCartDetails({guestCartId:this.cartId, guestAccountId:this.guestAccountId}).then(response => {
            if (this.enableLogs) console.log('getGuestCartDetails response is', response);
            this.isRubiconAccount = response.isRubiconAccount ? true : false;
            this.guestCartSubtotal = this.formatPrice(response.SubTotal && response.SubTotal != 0 ? '$ '+response.SubTotal : '$ 0.00');
            this.promoCode = response.Coupon ? response.Coupon : '';
            this.guestCartDiscount = response.CouponDiscount && response.CouponDiscount != 0 ? '-$ '+(response.CouponDiscount).replace('-','') : '$ 0.00';
            this.guestCartShipping =this.formatPrice( response.ShippingAmount && response.ShippingAmount !=0 ? '$ '+response.ShippingAmount : 'N/A');
            this.guestCartTax = this.formatPrice(response.Tax && response.Tax !=0 ? '$ '+response.Tax : 'N/A');
            this.guestCartTotal = this.formatPrice( response.Total && response.Total !=0 ? '$ '+response.Total : '$ 0.00');
            this.guestCartRetrieved = true;
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        })
    }

    handleFetchCartData() {
        if (this.enableLogs) console.log('inside fetchCartData call - this.activeCartId>>>', this.cartId);
        fetchCartDetails({cartId: this.cartId})
           .then( response => {
            if (this.enableLogs) console.log('fetchCartData data>>>', response);
            this.totalPrice = this.formatPrice( response.SubTotal && response.SubTotal !=0  ? '$ '+response.SubTotal : '$ 0.00');
            this.promoCode = response.Coupon ? response.Coupon : '';
            this.discountValue = response.CouponDiscount  && response.CouponDiscount !=0 ? '-$ '+(response.CouponDiscount).replace('-','') : '$ 0.00';
            this.shippingCharges = this.formatPrice( response.ShippingAmount && response.ShippingAmount !=0 ? '$ '+response.ShippingAmount : 'N/A');
            this.tax = this.formatPrice(response.Tax && response.Tax !=0 ? '$ '+response.Tax : 'N/A');
            this.finalPrice = this.formatPrice( response.Total && response.Total !=0  ? '$ '+response.Total : '$ 0.00');
            
        })
        .catch(error => {
            if (this.enableLogs) console.log('Fetch Cart  error>>>>',error);
        })
    }

    closeShowDeliveryDetails(){
        this.childCartPage = true;
        this.dispatchEvent(new CustomEvent('closecheckout', {
            detail: this.childCartPage
            
        }));
       if (this.enableLogs)  console.log("cart value in submit order"+ this. childCartPage);
    }

    
    closeSIOPPopup(){
      this.showSIOP = false;
      this.handleRegisterSIOP();
    }

    paginationHelper() {
        this.recordsToDisplay = [];
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        if (this.totalPages <= 1) {
            this.totalPages = 1;
        }

        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }

        // set records to display on current page 
        if (this.enableLogs) console.log('this.pageNumber>>>',this.pageNumber);
        if (this.enableLogs) console.log('this.pageSize>>>',this.pageSize);
        
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.records[i]);
        }
        if (this.enableLogs) console.log('this.recordsToDisplay for Nasreen',this.recordsToDisplay);
    }

    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }

    // Event handler for navigating to previous page
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }
    // Event handler for navigating to new page
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }
    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }
    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    
    PopupVisibility() {
         getSurveyPopupVisibility()
                .then(result => {
                this.controllModal = result;
                if (this.controllModal) { 
                    if (this.enableLogs) console.log('Opening survey modal');
                    } 
                    })
                    .catch(error => { 
                       if (this.enableLogs)  console.error('Error fetching survey popup visibility:', error); 
                     this.controllModal = false; 
                        });
    }
    handleSubmitOrder(){
        this.isLoading3 = true;
        createSAPOrder({ recordId: this.orderId , appSettingsName: 'ensxtx_SR_enosixOrderB2BAppSettings' })
        .then(({ data, messages }) => {
         if (this.enableLogs)  console.log('createSAPOrder response>>>', data);
          this.responseBody = JSON.stringify(data.TransactLogs);
            if(data.IsSuccess){
                this.orderNum = data.SalesDocument;
                this.orderConfirm = true;
                this.productsInCart = 0;
                
                this.dispatchGAEvent();
                 
                publish(this.messageContext, scc_MessageChannel, { cartCount: this.productsInCart });
              if(this.controllModal){
              this.surveyModal=true;
              }
              else{
                 this.surveyModal=false;
              }
                updateCartAndOrder({cartId: this.cartId, orderId: this.orderId}).then(response => { 
                    if(response){     
                       if (this.enableLogs)  console.log('updateCartAndOrder',response); 
                         
                    }
                }).catch(error => {
                    if (this.enableLogs) console.log('error in updateCartAndOrder', error);
                })
                if(data.SalesDocument !=null){
                    this.checkSIOPIsbn();
                }
            }else{
                var logs = data.TransactLogs;
                var errorCode;
                logs.forEach(log => {
                    if (log.ensxtx_MessageType__c == 'ERROR' && log.ensxtx_Message__c != 'Sales document  was not changed') {
                        errorCode = log.ensxtx_SAP_Error_Code__c;
                    }
                });
               if (this.enableLogs)  console.log('error message response>>>', errorCode);
                getUserFriendlyErrorMessage({ errorCode: errorCode, cartId: this.cartId}).then(response => { 
                    if (this.enableLogs) console.log('orderSubmissionError response',response);  
                    if(response){     
                        this.displayError = true;    
                        this.errorMessage = response.errorMessage;
                        this.contactSupport = response.support == 'true' ? true : false;
                    }
                }).catch(error => {
                   if (this.enableLogs)  console.log('error in fetching orderSubmissionError', error);
                })

                updateCartStatus({cartId: this.cartId}).then(response => { 
                    if(response){     
                       if (this.enableLogs)  console.log('updateCartStatus',response); 
                    }
                }).catch(error => {
                   if (this.enableLogs)  console.log('error in updateCartStatus', error);
                })
            }

            this.logType ='Enosix Order Simulation';
            this.requestBody = this.orderId;
            this.statusLog= 'Success';
            this.internalStatus='';
            this.createLogs(this.logType,this.requestBody,this.responseBody,this.statusLog,this.internalStatus,'Scc_reviewOrderLWC/handleSubmitOrder/createSAPOrder');
          
        })
        .catch(error => {
          if (this.enableLogs) console.log('createSAPOrder error>>>>',error);
          alert('Something went wrong. Please try submitting the order again.');
          this.logType ='Enosix Order Simulation';
          this.requestBody =this.orderId;
          this.statusLog= 'Error';
          this.internalStatus=JSON.stringify(error);
          this.createLogs(this.logType,this.requestBody,this.responseBody,this.statusLog,this.internalStatus,'Scc_reviewOrderLWC/handleSubmitOrder/createSAPOrder');
        })
        .finally(()=>{
          this.isLoading3 = false;
        });
    }

    handleSupportClick(){
        this.isContactSupport = true;
    }

    hanldeSupportSubmit(event){
        this.isContactSupport = false;
        var caseDetails = event.detail;
        if (this.enableLogs) console.log('caseDetails',caseDetails);
        var caseNumber = caseDetails.caseNumber;
        var email = caseDetails.email;
        if (this.enableLogs) console.log('caseNumber',caseNumber);
        if (this.enableLogs) console.log('email',email);
        if(caseNumber != ''){
            this.displayError = false;
            this.caseSubmitted = true;
            sendEmailToUser({ caseNumber: caseNumber, email: email})
            .then(result => {
               if (this.enableLogs)  console.log("email sent successfully");
            })
            .catch(error => {
               if (this.enableLogs)  console.log('error in sending email', error);
            });
        }
    }

    checkSIOPIsbn(){
      this.isLoading3 = true;
       if (this.enableLogs) console.log('this.recordsToDisplay check siop isbn',this.recordsToDisplay);
      for(let i=0;i<this.recordsToDisplay.length;i++){
        if(this.recordsToDisplay[i].siopOrder == true || this.recordsToDisplay[i].siopOrder == 'true'){
          this.showSIOP = true;
          break;
        }
      }
      this.isLoading3 = false;
      if(this.showSIOP == false){
      }
    }
    

    returnHome(){
        // Navigate to a URL
        this[NavigationMixin.Navigate](
            {
              type: "comm__namedPage",
              attributes: {
                name: "Home",
              },
            },
            true, // Replaces the current page in your browser history with the URL
          );
     
    }


    //Clone Order
    @wire(getAllowDropShip)
    wiredAllowDropShip({ error, data }) {
    if (data) { 
        if (this.enableLogs)  console.log('data from getAllowDropShip ',data);
        this.allowDropShip= data;
    } else if (error) {
         if (this.enableLogs)  console.log('error in getAllowDropShip ',error);
        this.error = error;

    }
    }
    clearFilterInput(){
         this.searchTermShip = '';
         this.applyFilterss();
    }

     
    filteredresultt;
      closeModal1() {
        this.openCloneModal = false;
        this.closeModal = true;
        this.selectedShipAccountId = '';
        const button = this.template.querySelector(".clonebtn");
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }
    }

    handleCloseSurveyModalClick(event){
        this.surveyModal = false;
        const button = this.template.querySelector(".home-link");
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }
    }

    handleTakeSurveyClick(){
       
        if(this.labels.scc_survey_link.trim() !=''){
            this[NavigationMixin.Navigate]({
                "type": "standard__webPage",
                "attributes": {
                    "url": this.labels.scc_survey_link
                }
            });
        }
        
    }

       handleCloneClick() {
        this.openCloneModal = true;
        this.closeModal = false;
        this.loadRelatedShipping();
        setTimeout(() => {
                this.template.querySelector('.cloneOrderCloseBtn').focus();
              }, 100);

           this.focusCloseButton();

    }
    loadRelatedShipping() {
        getRelatedShippingAddress({isRestricted:this.isRestrictedItem})
            .then(result => {
                this.Shipaddress = result;
                if (this.enableLogs) console.log('result of load related ship address is', this.Shipaddress);
                this.applyFilterss();
                this.selectedShip = result[0];
                this.loadSingleShipaddress(this.selectedShip.AccShipId);
            })
            .catch(error => {
                this.cases = undefined;
                this.caseError = error;
            });
    }
     handleUserInputsShip(event) {
        this.searchTermShip = event.target.value.toLowerCase();
        if (this.enableLogs) console.log('userinputs', this.searchTerm);
        this.applyFilterss();
    }

    applyFilterss() {
        if (!this.Shipaddress) {
            this.filteredresultt = this.Shipaddress;
            return;
        }
        this.searchter = this.searchTermShip;
        this.filteredresultt = this.Shipaddress.filter(Shipaddresss => {
            const shipAccName = Shipaddresss.SAccountName;
            const shipPostalCode = Shipaddresss.PostalCode;
            if (shipAccName == undefined && shipAccName == '' && shipPostalCode == undefined && shipPostalCode == '') {
                return;
            }
            if (shipAccName !== undefined && shipAccName !== '' && shipPostalCode !== undefined && shipPostalCode !== '') {

                return (
                    (Shipaddresss.SAccountName.toLowerCase().includes(this.searchter))
                    || (Shipaddresss.PostalCode.toLowerCase().includes(this.searchter))

                );
            }
            if ((shipAccName != undefined && shipAccName != '') && (shipPostalCode == undefined || shipPostalCode == '')) {
                return (
                    (Shipaddresss.SAccountName.toLowerCase().includes(this.searchter))

                );
            }
            if ((shipAccName == undefined || shipAccName == '') && (shipPostalCode != undefined && shipPostalCode != '')) {
                return (
                    (Shipaddresss.PostalCode.toLowerCase().includes(this.searchter))

                );
            }
            if (this.enableLogs) console.log('end of the ship filter', this.filteredresultt);

        });
       if (this.enableLogs)  console.log('filtered list is', this.filteredresultt);
        this.lengthShipAddress = this.filteredresultt.length;
        this.totalShipToRecords = this.lengthShipAddress;

    }
     handlecheckboxChange(event) {
        this.isChecked = event.target.checked;
       if (this.enableLogs)  console.log('im in the handel check box ', this.isChecked)
        if (this.isChecked == true) {
             this.showAvailableShipping = false;
              this.addressNotSelected = false;
              this.totalShipToRecords = 0 ;
        }else{
             this.showAvailableShipping = true;
             this.totalShipToRecords = this.lengthShipAddress;
             if(this.selectedShipAddress == true){
                 this.addressNotSelected = false;
             }else{
                 this.addressNotSelected = true;
             }
        }}
        renderedCallback(){
                if (this.selectedAccountId) {
        const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
        shippingInputs.forEach(input => {
            if (input.value === this.selectedAccountId) {
                input.checked = true;
            }
        });

        }
       

        }
        handleShipRowClick(event) {
        this.selectedShipAddress = true;
        this.selectedAccountId = event.currentTarget.dataset.recordId;
        if (this.enableLogs) console.log('selectedAccountId',this.selectedAccountId);
                  this.addressNotSelected = false;
       if (this.enableLogs) {        
        if (this.enableLogs) console.log('address Name',event.target.dataset.addressName);
        if (this.enableLogs) console.log('address City',event.target.dataset.addressCity);
        if (this.enableLogs) console.log('address Street',event.target.dataset.addressStreet);
        if (this.enableLogs) console.log('address provionce',event.target.dataset.addressProvionce);
        if (this.enableLogs) console.log('address Postal Code',event.target.dataset.addressPostalCode);
        if (this.enableLogs) console.log('address Country',event.target.dataset.addressCountry);
        if (this.enableLogs) console.log('address ShipToNumber',event.target.dataset.addressShipToNumber);
       }
        this.sName = event.target.dataset.addressName;
        this.shippingStreet = event.target.dataset.addressStreet;
        this.shippingCity = event.target.dataset.addressCity;
        this.shippingState = event.target.dataset.addressProvionce;
        this.shippingCountry = event.target.dataset.addressCountry;
        this.shippingZip = event.target.dataset.addressPostalCode;
        this.selectedShipAccountId = event.currentTarget.dataset.recordId;
        this.ShippingToNumber =  event.target.dataset.addressShipToNumber;
        this.isChangeAddDisabled = false;
      
    }
    handleUpdateCloneOrder(){
       if (!JSON.parse(this.template.querySelector('.Change-Address').getAttribute('aria-disabled'))) {

          const item = {
            sapUserShip: this.ShippingToNumber,
            oneTimeShip: this.isChecked,
            shipAddressId: this.selectedShipAccountId,
            shipCountry:this.shippingCountry,
            shipStreet:this.shippingStreet,
            shipCity:this.shippingCity,
            shipState:this.shippingState,
            shipZipCode:this.shippingZip
        };
        this.userInputs = [...this.userInputs, item];
        if (this.isChecked == true) {
                      const item = {
            sapUserShip: '',
            oneTimeShip: this.isChecked,
            shipAddressId: '',
            shipCountry:'',
            shipStreet:'',
            shipCity:'',
            shipState:'',
            shipZipCode:''
        };
        this.userInputs = [...this.userInputs, item];
           if (this.enableLogs) console.log('this.userInputs', this.userInputs);
        }

        callCloneOrderFunction({ currentcartId: this.cartId,userInputs:this.userInputs })
        .then(result => {
            if (this.enableLogs) console.log('result is',result);
            this.openReviewCartPage = true;
    })
    .catch(error => {
            this.cases = undefined;
            this.caseError = error;
        });

    }
}
handlePrin(){
        const printContent = this.template.querySelector('.print-only').innerHTML;
        const printWindow = window.open('', '_blank', 'width=1000,height=600');
        printWindow.document.write(`
            <html>
                <head>
                    <title>Print</title>
                    <style>
                    
                    </style>
                    <img src={labels.scc_brand_logo_mobile} alt="cart icon" /> 
                      
                </head>
                <body>
                   
                     ${printContent}
                </body>
            </html>
        `);
        printWindow.document.close();
        printWindow.print();
        printWindow.onafterprint = function () {
            printWindow.close();

        };
    }

      handlePrint() {
        // Select the print-only content
        const printContent = this.template.querySelector('.print-only').innerHTML;
        // Create a new window for printing
        const printWindow = window.open('', '', 'height=600,width=1000');
        // Write the content to the new window
        printWindow.document.write('<html><head><title>Print Content</title>');
        // Copy the current document's styles to the new window
        const styleSheets = Array.from(document.styleSheets).map(sheet => {
            try {
                return sheet.href ? `<link rel="stylesheet" href="${sheet.href}">` : `<style>${Array.from(sheet.cssRules).map(rule => rule.cssText).join('')}</style>`;
            } catch (e) {
                return '';
            }
        }).join('');

        printWindow.document.write(styleSheets);
        printWindow.document.write('</head><body>');
        printWindow.document.write('<div>' + printContent + '</div>');
        printWindow.document.write('</body></html>');
        // Close the document to complete the writing process
        printWindow.document.close();
        // Wait for the new window's content to load before printing
        printWindow.onload = function() {
            printWindow.focus();
            printWindow.print();
            printWindow.close();
        };
    }


    handleRegisterSIOP(){
        if (this.enableLogs) console.log('this.orderId',this.orderId);
        getSIOPOrderNumber({ orderID: this.orderId})
        .then( data => {
          if (this.enableLogs) console.log('getSIOPOrderNumber response>>>', data);
          this.ordernum = data[0].SAP_Document_Number__c;
        })
        .catch(error => {
          if (this.enableLogs) console.log('getSIOPOrderNumber error>>>>',error);
        })
        .finally(()=>{
            this.getSIOPDetails();
        });

       
    }

    getSIOPDetails(){
        getSIOPurl({orderNum:this.ordernum})
        .then(result=> {
            if (this.enableLogs) console.log('result url IIis',result);
           window.open(result,'_blank');
        })
        .catch(error=> {
           if (this.enableLogs)  console.log('result error',error);
        })
        .finally(()=>{
        });

    }

    createLogs(logType, requestBody, responseBody, statusLog, internalStatus,entryPoint) {
        createIntegrationLogsLWC1({ logType: logType, requestBody: requestBody, responseBody: responseBody, status: statusLog, internalStatus: internalStatus,entryPoint:entryPoint})
        .then(result => {
            if (this.enableLogs) console.log('result is', result);
        })
        .catch(error => {
            if (this.enableLogs) console.log('error is', error);
        })
    }

focusCloseButton() {
        // Find the close button using data-id attribute
        const closeButton = this.template.querySelector('[data-id="closeButton"]');
        if (closeButton) {
            // Focus on the close button
            closeButton.focus();
        } else {
            if (this.enableLogs) console.error('Close button not found');
        }
    }
 
  //Trap focus inside modal
    focusOutClose(event) {
      var related = event.relatedTarget;
      if(related != undefined){
        if(related.getAttribute('data-index') != 0) { 
            if(this.template.querySelector('.Change-Address')){
          this.template.querySelector('.Change-Address').focus();
            }
        }
      }
    }
  focusOutButton(event){
      var related = event.relatedTarget;
      if(related != undefined){
        if(related.getAttribute('data-index') != 0) { 
          this.template.querySelector('.closebtnOnFocus').focus();
        }
      }
    }
  }