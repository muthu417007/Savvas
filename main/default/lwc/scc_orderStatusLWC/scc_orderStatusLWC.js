/*
LWC Component:scc_orderStatusLWC
Author: CTS (Vaibhav Saptal)
Created Date: 03/04/2024
Reason: JS logic scc_orderStatusLWC component.
Modified Date: 02/05/2024
*/

import { LightningElement, track, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation'; //Added by Zubiya for multi page
import { decodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { loadStyle } from 'lightning/platformResourceLoader';
import headmarkupstyle_static from '@salesforce/resourceUrl/headmarkupstyle_static';
//Importing Apex classes
import getSearchByOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getSearchByOptions';
import getStatesOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getStatesOptions';
import getOrderStatusOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusOptions';
import getCountrysOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getCountrysOptions';
import getOrderStatusData from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusData';
import getCriteriaOrderdata from '@salesforce/apex/scc_orderStatusLWC_Controller.getCriteriaOrderdata';
import getOrderStatusCodes from '@salesforce/apex/scc_orderDetail_Controller.getOrderStatusCodes';
import getOrderMethodCodes from '@salesforce/apex/scc_orderDetail_Controller.getOrderMethodCodes';
import itemsStatushelper from '@salesforce/apex/scc_orderDetail_Controller.itemsStatushelper';
import itemsDueDate from '@salesforce/apex/scc_orderDetail_Controller.itemsDueDate';
import getLogProStatus from '@salesforce/apex/scc_orderDetail_Controller.getLogProStatus';
import getOrderCancelCode from '@salesforce/apex/scc_orderDetail_Controller.getOrderCancelCode';
import getSIOPurl from '@salesforce/apex/scc_checkSIOPRegistration.getSIOPurl';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
import updateOrder from '@salesforce/apex/scc_orderStatusLWC_Controller.updateOrder';
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import { refreshApex } from '@salesforce/apex';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;
//Enosix classes
import search from '@salesforce/apex/ensxtx_CTRL_DocumentSearch.search';
import getDetail from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getDetail';
import getInvoice from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getInvoice';
import getDelivery from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getDelivery';
import getSalesDocFlow from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getSalesDocFlow';
//Importing labels
import scc_home_Order_Entry_Period from "@salesforce/label/c.scc_home_Order_Entry_Period";
import scc_home_From from "@salesforce/label/c.scc_home_From";
import scc_home_To from "@salesforce/label/c.scc_home_To";
import scc_home_PO from "@salesforce/label/c.scc_home_PO";
import scc_home_Document_Control from "@salesforce/label/c.scc_home_Document_Control";
import scc_home_Search_By from "@salesforce/label/c.scc_home_Search_By";
import scc_home_ISBN from "@salesforce/label/c.scc_home_ISBN";
import scc_home_Search from "@salesforce/label/c.scc_home_Search";
import scc_home_Order_Status from "@salesforce/label/c.scc_home_Order_Status";
import scc_OrderStatus_Customer_Name_begins_with from "@salesforce/label/c.scc_OrderStatus_Customer_Name_begins_with";
import scc_OrderStatus_Order_Search from "@salesforce/label/c.scc_OrderStatus_Order_Search";
import scc_OrderStatus_Clear from "@salesforce/label/c.scc_OrderStatus_Clear";
import scc_OrderStatus_Search_Criteria from "@salesforce/label/c.scc_OrderStatus_Search_Criteria";
import scc_OrderStatus_Country from "@salesforce/label/c.scc_OrderStatus_Country";
import scc_OrderStatus_State_Province from "@salesforce/label/c.scc_OrderStatus_State_Province";
import scc_OrderStatus_Zip_Postal_Code from "@salesforce/label/c.scc_OrderStatus_Zip_Postal_Code";
import scc_OrderStatus_Invoice_Number from "@salesforce/label/c.scc_OrderStatus_Invoice_Number";
import scc_OrderStatus_Customer_SAN from "@salesforce/label/c.scc_OrderStatus_Customer_SAN";
import scc_OrderStatus_Search_Results from "@salesforce/label/c.scc_OrderStatus_Search_Results";
import scc_OrderStatus_City from "@salesforce/label/c.scc_OrderStatus_City";
import scc_OrderStatus_No_Search_Result from "@salesforce/label/c.scc_OrderStatus_No_Search_Result";
import scc_Order_Status_no_of_rows from "@salesforce/label/c.scc_Order_Status_no_of_rows";
import scc_Order_Status_items from "@salesforce/label/c.scc_Order_Status_items";
import scc_OrderStatus_Ship_To_Account from "@salesforce/label/c.scc_OrderStatus_Ship_To_Account";
import scc_OrderStatus_Requested_Shipment_Date from "@salesforce/label/c.scc_OrderStatus_Requested_Shipment_Date";
import scc_OrderDetail_Order_Detail from "@salesforce/label/c.scc_OrderDetail_Order_Detail";
import scc_OrderDetail_Return_to_Order_Search from "@salesforce/label/c.scc_OrderDetail_Return_to_Order_Search";
import scc_OrderDetail_Order_Method from "@salesforce/label/c.scc_OrderDetail_Order_Method";
import scc_home_Status from "@salesforce/label/c.scc_home_Status";
import scc_home_Order_Date from "@salesforce/label/c.scc_home_Order_Date";
import scc_OrderDetail_Filfilment_Progress_Note from "@salesforce/label/c.scc_OrderDetail_Filfilment_Progress_Note";
import scc_OrderDetail_Order_Line_Detail from "@salesforce/label/c.scc_OrderDetail_Order_Line_Detail";
import scc_OrderDetail_Seq from "@salesforce/label/c.scc_OrderDetail_Seq";
import scc_OrderDetail_Title from "@salesforce/label/c.scc_OrderDetail_Title";
import scc_OrderDetail_Price from "@salesforce/label/c.scc_OrderDetail_Price";
import scc_OrderDetail_Pricing_Method from "@salesforce/label/c.scc_OrderDetail_Pricing_Method";
import scc_OrderDetail_Discount from "@salesforce/label/c.scc_OrderDetail_Discount";
import scc_OrderDetail_Qty_Ordered from "@salesforce/label/c.scc_OrderDetail_Qty_Ordered";
import scc_OrderDetail_Qty_Closed from "@salesforce/label/c.scc_OrderDetail_Qty_Closed";
import scc_OrderDetail_To_be_shipped from "@salesforce/label/c.scc_OrderDetail_To_be_shipped";
import scc_OrderDetail_Status_Updated from "@salesforce/label/c.scc_OrderDetail_Status_Updated";
import scc_OrderDetail_Shipped from "@salesforce/label/c.scc_OrderDetail_Shipped";
import scc_OrderDetail_Ship_To from "@salesforce/label/c.scc_OrderDetail_Ship_To";
import scc_OrderStatus_SIOP_Order from "@salesforce/label/c.scc_OrderStatus_SIOP_Order";
import scc_OrderStatus_SIOP_Order_Note from "@salesforce/label/c.scc_OrderStatus_SIOP_Order_Note";
import scc_OrderStatus_SIOP_Order_Register_Participants from "@salesforce/label/c.scc_OrderStatus_SIOP_Order_Register_Participants";
import scc_Order_Status_SIOP_Conf_Order from "@salesforce/label/c.scc_Order_Status_SIOP_Conf_Order";
import scc_Order_Status_WorkTextPO_Note from "@salesforce/label/c.scc_Order_Status_WorkTextPO_Note";
import scc_orderDetail_title_Finder_URL from "@salesforce/label/c.scc_orderDetail_title_Finder_URL";
import scc_OrderStatus_Required_Fields_Error from "@salesforce/label/c.scc_OrderStatus_Required_Fields_Error";
import scc_Insert_Logs from "@salesforce/label/c.scc_Insert_Logs";
import scc_orderDetail_shipMethod_NextDay from "@salesforce/label/c.scc_orderDetail_shipMethod_NextDay";
import scc_orderDetail_shippingMethod from "@salesforce/label/c.scc_orderDetail_shippingMethod";
import scc_orderDetail_shipMethod_Regular from "@salesforce/label/c.scc_orderDetail_shipMethod_Regular";
import scc_orderDetail_shipMethod_secondDay from "@salesforce/label/c.scc_orderDetail_shipMethod_secondDay";
//changes for W-014104 US-87
import scc_OrderDetail_Requested_Shipment_Date_tooltip from "@salesforce/label/c.scc_OrderDetail_Requested_Shipment_Date_tooltip";
//importing static resources
import ORDER_STATUS_EXT_CSS from '@salesforce/resourceUrl/scc_ORDER_STATUS_EXT_CSS';
import scc_noResults from "@salesforce/resourceUrl/scc_noResults";
import scc_calender_icon from "@salesforce/resourceUrl/scc_calender_icon";
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import {NavigationMixin} from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

export default class Scc_orderStatusLWC extends NavigationMixin(LightningElement) {
    @track source;
    @track decodedValues;
    alertIcon = imageIcons + '/Images/alert.png';
    sortIcon = imageIcons + '/Images/sort.png';
    @track params;
    stateLabel = scc_OrderStatus_State_Province + ' *';
    @track showOrderDetailsFlag;
    @track searchcriterieexpanded = true;
    @track SearchByvalue = '';
    @track OrderStatusValue = 'All';
    @track CountryValue = '';
    @track PONumSelect = false;
    @track InvoiceSelect = false;
    @track ISBNselect = false;
    @track DocumentNumSelect = false;
    @track SANSelect = false;
    @track ZipSelect = false;
    @track StateSelect = false;
    @track CountrySelect = false;
    @track workTextMatch = false;
    @track stateOptions;
    @track SAPDocumentNumber = '';
    @track ZipCode = '';
    @track CustomerAccount = false
    @track isBillToSelected = true;
    @track isShipToSelected = false;
    @track billToValue = '';
    @track shipToValue = '';
    @track selectedValue = 'BillTo';
    @track showDeliveryDetails = false;
    @track invoiceInfo;
    @track openSearchPage= true 
    @track SearchByOptions1 = [{ label: 'PO#', value: 'PO#' },
                                { label: 'Invoice #', value: 'Invoice #' },
                                { label: 'Containing ISBN', value: 'Containing ISBN' },
                                { label: 'Order #', value: 'Order #' },
                                { label: 'All Ship-To Locations', value: 'All Ship-To Locations' },
                                { label: 'Our Ship-To Locations Only', value: 'Our Ship-To Locations Only' },
                                { label: 'Zip/Postal Code', value: 'Zip/Postal Code' },
                                { label: 'State/Province', value: 'State/Province' },
                                { label: 'Country', value: 'Country' },
                                { label: 'Customer Name', value: 'Customer Name' },// added by sudha
                                { label: '	Customer Account', value: '	Customer Account' }// added by sudha
                             ];
    @track OrderStatusOptions1 = [{ label: 'All', value: 'All' }, { label: 'Open', value: 'Open' }, { label: 'Cancelled', value: 'Cancelled' }, { label: 'FullFilled', value: 'FullFilled' }];
    @track CountrysOptions1 = [{ label: 'United States', value: 'United States' }, { label: 'Canada', value: 'Canada' }];
    @track isLoading1 = false;
    @track CountrysOptions2;
    @track CountrysOptions3;
    @track PONum = '';
    @track InvoNum = '';
    @track ISBnNum = '';
    @track DocContrNum = '';
    @track ZipNum = '';
    @track StateNum = '';
    @track CityNum = '';
    @track SANNum = '';
    @track CustName = '';
    @track startDate;
    @track endDate;
    @track SearchDisabledReturn = true;
    @track locations = false;
    @track orderDetailsSect = false;
    @track showSearchResults = false;
    @track sortDirection;
    @track sortedBy;
    First = '<< First'
    Previous = '< Previous'
    next = 'Next >'
    Last = 'Last >>'
    pageSizeOptions = [15, 30, 45, 60]; //Page size options
    records = []; //All records available in the data table
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    @track totalPages = 1; //Total no.of pages
    pageNumber = 1; //Page number    
    @track recordsToDisplay = []; //Records to be displayed on the page
    @track data;
    @track totalRecords;
    @track showOrderData = false;
    @track showShipmentData = false;
    @track isCssLoaded = false;
    @track orderno = '';
    @api getdatafrmhm;//changes for W-014196 US-163 
    @track activeTab;
    @track activeTabValue;
    @track documentNumber;//changes for W-014208 US-49
    @track allOrdersSelect = false;//changes for W-014384 US-184
    @track lineStatus;
    @track statusData;
    @track methodData;
    @track isGuest = true;
    @track expectedDueDate = '';
    @track isInternal = false// added by sudha
    @track CustomerName = false;// added by sudha
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog = '';
    @track internalStatus = '';
    @track orderNumber;
    @track CustomerPurchaseOrderDate;
    @track CustomerPurchaseOrderNumber;
    @track OverallStatusDescription;
    @track CustomerPurchaseOrderType;
    @track RequestedDeliveryDate;
    @track RequestedDeliveryDateFormat;
    @track ShipToAccount;
    @track ShipTo;
    @track orderLineRecords = [];
    @track addressInfoRecords = [];//changes for W-014117 US-150
    @track billTo = false;//changes for W-014117 US-150
    @track shipTo = false;//changes for W-014117 US-150
    @track licenseTo = false;//changes for W-014117 US-150
    @track shipmentInfoRecords = [];
    @track shipmentNumbers = [];
    @track QtyClosed = 0;
    @track updatedStatusDate;
    @track deliveryInfo = [];
    @track deliveryNumber = '';
    @track invoiceNumber = '';
    @track shipDate = '';
    @track grossAmount;
    @track netOrderValue;
    @track taxAmount;
    @track transportation;
    @track shipData = {};
    @track discountValue;
    @track toBeShipped = 0;
    @track lineMaterial;
    @track shipItemstoCheck = [];
    @track backOrderDueDatecheck = [];
    @track cancelledReasonCode = [];
    @track packedItemstoCheck = [];
    @track beingPackedCheck = [];
    @track shipNoInvoItemstoCheck = [];
    @track backOrderOrCancelled = false;
    @track beingPacked = false;
    @track shipToAcc = '';
    @track shipToAddress = '';
    @track shipToAccName = '';
    @track billToAcc = '';
    @track billToAddress = '';
    @track billToAccName = '';
    @track licenseToAcc = '';
    @track licenseToAddress = '';
    @track licenseToAccname = '';
    @track billToTabSelected = false;
    @track AcId = '';
    @track cancelledItems;
    @track shippedItems;
    @track shippingStreet = '';
    @track shippingCity = '';
    @track shippingState = '';
    @track shippingPostalCode = '';
    @track billingStreet = '';
    @track billingCity = '';
    @track billingState = '';
    @track billingPostalCode = '';
    @track billToAccName1 = '';
    @track shipToAccName1 = '';
    @track previousParams = {};
    @track enableLogs = false;
    @track remianingItems;
    @track sortField = 'PO#';
    @track sortDirection = '';  // Initially empty
    @track sortedBy = 'PO';
    @track showErrorMessage = false;
    @track errorMessage = '';
    @track siopOrd = false;
    @track fullUrl = '';
    @track pricingConditions;
    @track pricingConditionsMap;
    @track beingPackedArray=[];
    @track shippingMethod;

    labels = {
        scc_OrderStatus_Required_Fields_Error,
        scc_home_Order_Entry_Period,
        scc_home_From,
        scc_home_To,
        scc_home_PO,
        scc_home_Document_Control,
        scc_home_Search_By,
        scc_home_ISBN,
        scc_home_Search,
        scc_home_Order_Status,
        scc_OrderStatus_Order_Search,
        scc_OrderStatus_Clear,
        scc_OrderStatus_Search_Criteria,
        scc_OrderStatus_Country,
        scc_OrderStatus_State_Province,
        scc_OrderStatus_Zip_Postal_Code,
        scc_OrderStatus_Invoice_Number,
        scc_OrderStatus_Customer_Name_begins_with,
        scc_OrderStatus_Customer_SAN,
        scc_OrderStatus_Search_Results,
        scc_OrderStatus_City,
        scc_OrderDetail_Requested_Shipment_Date_tooltip,
        scc_OrderStatus_No_Search_Result,
        scc_Order_Status_no_of_rows,
        scc_Order_Status_items, scc_OrderStatus_Ship_To_Account,
        scc_OrderStatus_Requested_Shipment_Date, scc_OrderDetail_Order_Detail, scc_OrderDetail_Return_to_Order_Search,
        scc_OrderDetail_Ship_To, scc_OrderDetail_Order_Method, scc_home_Status, scc_home_Order_Date, scc_OrderDetail_Filfilment_Progress_Note,
        scc_OrderDetail_Order_Line_Detail, scc_OrderDetail_Seq, scc_OrderDetail_Title, scc_OrderDetail_Price, scc_OrderDetail_Pricing_Method, scc_OrderDetail_Discount,
        scc_OrderDetail_Qty_Ordered, scc_OrderDetail_Qty_Closed, scc_OrderDetail_To_be_shipped, scc_OrderDetail_Status_Updated, scc_OrderDetail_Shipped,
        scc_noResults,scc_calender_icon, scc_OrderStatus_SIOP_Order, scc_OrderStatus_SIOP_Order_Note, scc_OrderStatus_SIOP_Order_Register_Participants, scc_Order_Status_SIOP_Conf_Order, scc_Order_Status_WorkTextPO_Note,
        scc_Insert_Logs,scc_orderDetail_title_Finder_URL,scc_orderDetail_shipMethod_secondDay,scc_orderDetail_shipMethod_Regular,scc_orderDetail_shipMethod_NextDay,scc_orderDetail_shippingMethod
    }

    constructor() {
        super();
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if(this.enableLogs){
                console.log('getEnableConsoleLogsTrue response is',response);
            }
        }).catch(error => {
                console.log('error is', error);
        })

        getUserInformation().then(response => {
            if(this.enableLogs){
                console.log('getUserInformation response is',response);
            }
            let paser = JSON.parse(response);
            let data = paser[0];
            this.userName = data.userName;
            this.accountName = data.accountName;
            this.isGuest = data.isGuest;
            this.isInternal = data.isInternal;
        }).catch(error => {
            console.log('error is', error);
        })
    }

    handleMaterialClick(event) {
        const material = event.currentTarget.dataset.material;
        const url1 = this.labels.scc_orderDetail_title_Finder_URL;
        const baseUrl = `${url1}`;
        this.fullUrl = `${baseUrl}?isbn=${material}`;
        window.open(this.fullUrl, '_blank');
    }
    
    resetComponentState() {
        this.SearchByvalue = '';
        this.OrderStatusValue = 'All';
        this.CountryValue = '';
        this.PONum = '';
        this.InvoNum = '';
        this.ISBnNum = '';
        this.DocContrNum = '';
        this.ZipNum = '';
        this.StateNum = '';
        this.CityNum = '';
        this.SANNum = '';
        this.CustName = '';
        this.endDate = null;
        this.orderDetailsSect = false;
        this.showOrderData = false;
        this.showSearchResults = false;
        this.records = [];
        this.recordsToDisplay = [];
        this.totalRecords = 0;
        this.pageNumber = 1;
        this.decodedValues = {};
        this.params = {};
    }

   @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            const newParams = currentPageReference.state;
            if (JSON.stringify(newParams) !== JSON.stringify(this.previousParams)) {
                this.previousParams = { ...newParams };
            }
            this.params = newParams;
            if (this.params.defaultFieldValues) {
                this.decodedValues = decodeDefaultFieldValues(this.params.defaultFieldValues);
            }
            if (this.params.Source) {
                this.source = this.params.Source;
            }         
            if (this.isInternal == true && this.params.c__DocContrNum != null) {
                let Search = this.params.c__Search;
                this.SearchByvalue = Search;
                let even = { target: { value: Search } };
                this.handleSearchOptionChange(even);
                this.PONum = this.params.c__PONum;
                this.ISBnNum = this.params.c__ISBnNum;
                this.startDate = this.params.c__startDate;
                this.endDate = this.params.c__endDate;
                this.OrderStatusValue = this.params.c__OrderStatusValue;
                let ordStatusEve = { detail: { value: this.params.c__OrderStatusValue } };
                this.handleOrderStatusOptionChange(ordStatusEve);
                this.InvoNum = this.params.c__InvoNum;
                this.ZipNum = this.params.c__ZipNum;
                this.StateNum = this.params.c__StateNum;
                this.CountryValue = this.params.c__CountryValue;
                let countStatusEve = { target: { value: this.params.c__CountryValue } };
                this.handleCountryOptionChange(countStatusEve);
                this.DocContrNum = this.params.c__DocContrNum;
                this.handleSearch();
            }
        }
    }

    showOrderDetails() {
        this.orderDetailsSect = true;
        this.showOrderData = true;
        this.getOrderSeatails();
    }

    async connectedCallback() {
        this.isLoading1 = true;
        const urlParams = new URLSearchParams(window.location.search);
        await getUserInformation().then(response => {
            let paser = JSON.parse(response);
            let data = paser[0];
            this.userName = data.userName;
            this.accountName = data.accountName;
            this.isGuest = data.isGuest;
            this.isInternal = data.isInternal;
        }).catch(error => {
            console.log('error is', error);
        })

        getSearchByOptions({ HomePage: false }).then(response => {
            let paser = JSON.parse(response);
            this.SearchByOptions1 = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })

        getOrderStatusOptions().then(response => {
            let paser = JSON.parse(response);
            this.OrderStatusOptions1 = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })

        getCountrysOptions().then(response => {
            let paser = JSON.parse(response);
            this.CountrysOptions2 = JSON.parse(response);
            this.CountrysOptions3 = [...this.CountrysOptions1, ...this.CountrysOptions2]
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })

        getOrderStatusCodes().then(data => {
            this.statusData = data;
        })
        .catch(error => {
            console.log(error);
        })

        getStatesOptions().then(response => {
            this.stateOptions = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
        })

        this.ZipNum = urlParams.get('ZipCode')?urlParams.get('ZipCode'):'';
        this.AcId = urlParams.get('AccountId')?urlParams.get('AccountId'):'';
        if ((this.isInternal == false || this.isGuest == true) && urlParams.get('SAPDocumentNumber') != null && ((urlParams.get('ZipCode') != null && urlParams.get('ZipCode') != '') || (urlParams.get('AccountId') != null && urlParams.get('AccountId') != ''))) {
            let Search = 'Order #';
            this.SearchByvalue = Search;
            let even = { target: { value: Search } };
            this.handleSearchOptionChange(even);
            this.PONum = '';
            this.ISBnNum = '';
            this.startDate = null;
            this.endDate = null;
            this.OrderStatusValue = '';
            let ordStatusEve = { detail: { value: 'All' } };
            this.handleOrderStatusOptionChange(ordStatusEve);
            this.InvoNum = '';
            if(urlParams.get('ZipCode') != null && urlParams.get('ZipCode') != '' && urlParams.get('ZipCode').length >= 5){
                this.ZipNum = '%' + urlParams.get('ZipCode') + '%';
            } else {
                this.ZipNum = '';
            }
            this.StateNum = '';
            this.CountryValue = '';
            let countStatusEve = { target: { value: '' } };
            this.handleCountryOptionChange(countStatusEve);
            this.DocContrNum = urlParams.get('SAPDocumentNumber');
            if(urlParams.get('AccountId') != null && urlParams.get('AccountId') != '' && urlParams.get('ZipCode') != null && urlParams.get('ZipCode') != '' && urlParams.get('ZipCode').length >= 5){
                this.ZipNum = '%' + urlParams.get('ZipCode') + '%';
                this.AcId = '';
            } else if(urlParams.get('AccountId') != null && urlParams.get('AccountId') != '' && urlParams.get('ZipCode') != null && urlParams.get('ZipCode') != '' && urlParams.get('ZipCode').length < 5){ 
                this.AcId = '';
                this.ZipNum = '';
            } else if ((urlParams.get('AccountId') != null && urlParams.get('AccountId') !='') && (urlParams.get('ZipCode') == null && urlParams.get('ZipCode') == '')){
                this.AcId = urlParams.get('AccountId');
                this.ZipNum = '';
            } else if(urlParams.get('AccountId') == null && urlParams.get('AccountId') == '' && urlParams.get('ZipCode') != null && urlParams.get('ZipCode') != '' && urlParams.get('ZipCode').length >= 5){ 
                this.AcId = '';
                this.ZipNum = '%' + urlParams.get('ZipCode') + '%';
            }
            this.orderDetailsSect=true;
            this.handleSearch();
        }

        if (this.isInternal == true && Object.keys(this.params).length != 0 && urlParams.get('this.params.c__orderNumber') == null && urlParams.get('ZipCode') == null) {
            let Search = this.params.c__Search;
            this.SearchByvalue = Search;
            let even = { target: { value: Search } };
            this.handleSearchOptionChange(even);
            this.PONum = this.params.c__PONum;
            this.ISBnNum = this.params.c__ISBnNum;
            this.startDate = this.params.c__startDate;
            this.endDate = this.params.c__endDate;
            this.OrderStatusValue = this.params.c__OrderStatusValue;
            let ordStatusEve = { detail: { value: this.params.c__OrderStatusValue } };
            this.handleOrderStatusOptionChange(ordStatusEve);
            this.InvoNum = this.params.c__InvoNum;
            this.ZipNum = this.params.c__ZipNum;
            this.StateNum = this.params.c__StateNum;
            this.CountryValue = this.params.c__CountryValue;
            let countStatusEve = { target: { value: this.params.c__CountryValue } };
            this.handleCountryOptionChange(countStatusEve);
            this.DocContrNum = this.params.c__DocContrNum;
            this.orderDetailsSect=true;
            this.handleSearch();
        }

        if (this.isInternal == false && this.isGuest== false) {
            if (this.decodedValues != null && urlParams.get('SAPDocumentNumber') == null && urlParams.get('ZipCode') == null) {
                let Search = this.decodedValues.Search;
                this.SearchByvalue = Search;
                let even = { target: { value: Search } };
                this.handleSearchOptionChange(even);
                this.PONum = this.decodedValues.PONum;
                this.ISBnNum = this.decodedValues.ISBnNum;
                this.startDate = this.decodedValues.startDate
                this.endDate = this.decodedValues.endDate;
                this.OrderStatusValue = this.decodedValues.OrderStatusValue;
                let ordStatusEve = { detail: { value: this.decodedValues.OrderStatusValue } };
                this.handleOrderStatusOptionChange(ordStatusEve);
                this.InvoNum = this.decodedValues.InvoNum;
                this.ZipNum = this.decodedValues.ZipNum;
                this.StateNum = this.decodedValues.StateNum;
                this.CountryValue = this.decodedValues.CountryValue;
                let countStatusEve = { target: { value: this.decodedValues.CountryValue } };
                this.handleCountryOptionChange(countStatusEve);
                this.DocContrNum = this.decodedValues.DocContrNum;               
                this.handleSearch();
            }
        }
        
        if (this.isGuest  == true && this.isInternal==false ) {
            let Search = this.decodedValues.Search;
            this.SearchByvalue = Search;
            let even = { target: { value: Search } };
            this.handleSearchOptionChange(even);
            this.PONum = this.decodedValues.PONum;
            this.ISBnNum = this.decodedValues.ISBnNum;
            this.startDate = this.decodedValues.startDate
            this.endDate = this.decodedValues.endDate;
            this.OrderStatusValue = this.decodedValues.OrderStatusValue;
            let ordStatusEve = { detail: { value: this.decodedValues.OrderStatusValue } };
            this.handleOrderStatusOptionChange(ordStatusEve);
            this.InvoNum = this.decodedValues.InvoNum;
            this.ZipNum = this.decodedValues.ZipNum;
            this.StateNum = this.decodedValues.StateNum;
            this.CountryValue = this.decodedValues.CountryValue;
            let countStatusEve = { target: { value: this.decodedValues.CountryValue } };
            this.handleCountryOptionChange(countStatusEve);
            this.DocContrNum = this.decodedValues.DocContrNum;
                this.orderDetailsSect=true;
            this.handleSearch();
        }
        this.isLoading1 = false;
    }

    addCustomStyles() {
        const style = document.createElement('style');
        style.innerText = `
            .sort-icon-link:focus {
                outline: none;
                box-shadow: none;
            }
        `;
        this.template.querySelector('a').appendChild(style);
    }

    //handler for search button
    handleSearch() {
        this.recordsToDisplay = [];
        this.isLoading1 = true;
        this.workTextMatch = false;
        if(this.ZipNum != null && this.ZipNum !='' && this.ZipNum.length < 5){ 
            this.isLoading1 = false;
            this.showSearchResults = true;
            return '';
        }
        getCriteriaOrderdata({
            PO: this.PONum.trim(), ISBN: this.ISBnNum.trim(), startDate: this.startDate, endDate: this.endDate, orderStatus: this.OrderStatusValue,
            OrderNum: this.DocContrNum.trim(), Zip: this.ZipNum.trim(), State: this.StateNum.trim(), City: this.CityNum.trim(), Country: this.CountryValue, CustNam: this.CustName.trim(), SAN: this.SANNum.trim(), Invo: this.InvoNum.trim(), SearchValue: this.SearchByvalue,
            BillTo: this.billToValue, Shipto: this.shipToValue, Acid: this.AcId
        }).then(response => {
            if(this.enableLogs){
                console.log('Response received:', response);
            }
            this.showSearchResults = true;
            this.data = JSON.parse(response);
            this.records = this.data;
            this.pageSize = this.pageSizeOptions[0];
            this.totalRecords = this.data.length;
            if (this.data[0].workTextPO == true) {
                this.workTextMatch = true;
            }
            if (this.totalRecords > 1) {
                this.orderDetailsSect = false;
            }else if (this.totalRecords == 1) {
                let eve = { target: { dataset: { name: this.data[0].SAP_Document_Number, siopord: this.data[0].siopOrder } } };
                this.documentNumber = this.data.SAP_Document_Number;
                this.orderDetailsSect=true 
                this.handleOrderNumClick(eve);
            }
            this.paginationHelper(); // call helper menthod to update pagination logic 
            this.isLoading1 = false;
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })
        .finally(() => {

        })
    }

    formatISBNTo13Characters(str) {
        // Remove leading zeros
        let trimmedStr = str.replace(/^0+/, '');
        // Ensure the string has exactly 13 characters
        if (trimmedStr.length > 13) {
            return trimmedStr.slice(-13);  // Keep the last 13 characters
        } else {
            return trimmedStr.padStart(13, '0');  // Pad with leading zeros if less than 13 characters
        }
    }

     getOrderSeatails() {
        this.isLoading1 = true;
        this.orderLineRecords = [];
        this.addressInfoRecords = [];
        this.shipmentNumbers = [];
        this.cancelledItems = [];
        this.remianingItems = [];
        this.shippedItems = [];
        this.shipmentInfoRecords = [];
        this.ShipToAccount = '';
        this.ShipTo = '';
        this.shipItemstoCheck = [];
        this.packedItemstoCheck = [];
        this.backOrderDueDatecheck = [];
        this.beingPackedCheck = [];
        this.cancelledReasonCode = [];
        this.shipNoInvoItemstoCheck = [];
        this.backOrderOrCancelled = false;
        this.beingPacked = false;
        this.deliveryInfo = [];
        this.CustomerPurchaseOrderNumber ='';
        this.orderNumber = '';
        this.CustomerPurchaseOrderDate ='';
        this.RequestedDeliveryDate ='';
        this.OverallStatusDescription='';
        let shippingItems = [];
        getDetail({ documentNumber: this.documentNumber })
            .then(({ data, messages }) => {
                this.responseBody = JSON.stringify(data);
                if(this.enableLogs){
                    console.log('Sales Doc data is', data);
                    console.log('Sales Doc message is', messages);
                }
                data = JSON.parse(JSON.stringify(data));
                this.orderNumber = data.SalesDocument;
                this.CustomerPurchaseOrderNumber = data.CustomerPurchaseOrderNumber;
                this.CustomerPurchaseOrderDate = this.formatDate(data.CustomerPurchaseOrderDate);
                this.RequestedDeliveryDateFormat = data.SALES.RequestedDeliveryDate;
                this.RequestedDeliveryDate = this.formatDate(this.RequestedDeliveryDateFormat);
                this.getShippingMethod(data);
                this.compareAddresses(data);

                for (let i = 0; i < data.ITEMS.asList.length; i++) {
                    this.lineMaterial = '';
                    if (data.ITEMS.asList[i].MaterialPricingGroupDescription.includes('Price') && data.ITEMS.asList[i].Discount != 0) {
                        this.discountValue = data.ITEMS.asList[i].MaterialPricingGroupDescription.replace('Price', '');
                    } else {
                        this.discountValue = '';
                    }

                    let itemPrice;
                    if(data.ITEMS.asList[i].OrderQuantity == 0){
                        itemPrice = this.formatPrice((data.ITEMS.asList[i].KZWI1).toFixed(2));
                    }else{
                        itemPrice = this.formatPrice((data.ITEMS.asList[i].KZWI1/data.ITEMS.asList[i].OrderQuantity).toFixed(2));
                    }

                    this.orderLineRecords.push({
                        id: i+1,
                        SalesItem: data.ITEMS.asList[i].SalesItem,
                        Material: this.lineMaterial,
                        ItemDescription: data.ITEMS.asList[i].ISBN ? data.ITEMS.asList[i].ISBN:(data.ITEMS.asList[i].ItemDescription ? data.ITEMS.asList[i].ItemDescription:''),
                        NetValueInDocumentCurrency:itemPrice,
                       // MaterialPricingGroupDescription: data.ITEMS.asList[i].MaterialPricingGroupDescription,
                        MaterialPricingGroupDescription: '',
                        OrderQuantity: data.ITEMS.asList[i].OrderQuantity,
                        QtyClosed: '',
                        TobeShipped: '',
                        updatedStatusDate: '',
                        Discount: this.discountValue,
                        LineStatus: '',
                        backOrderOrCancelled: false,
                        beingPacked: false,
                        Reason: '',
                        iconName: '',
                        orderdetail: '',
                        QtyShipped: '',
                        QtyInvoiced: '',
                        PONumber: data.CustomerPurchaseOrderNumber,
                        ParcelID: data.ITEMS.asList[i].ParcelID,
                        weight: data.ITEMS.asList[i].GrossWeight.toFixed(2),
                        ParcelQty: '',
                        Material1:data.ITEMS.asList[i].Material,    
                        IntHUNumber:'',
                        reasonCode:''
                    })
                }

                for (let i = 0; i < this.orderLineRecords.length; i++) {
                    for (let j = 0; j < data.ITEM_STATUS.asList.length; j++) {
                        if(!!this.orderLineRecords[i]){
                            if(!!data.ITEM_STATUS.asList[j]){
                        if (this.orderLineRecords[i].SalesItem == data.ITEM_STATUS.asList[j].SalesItem) {
                            this.orderLineRecords[i].LineStatus = this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT] ? this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT]:'';
                            this.orderLineRecords[i].updatedStatusDate = data.ITEM_STATUS.asList[j].StatusDate ? this.formatDate(data.ITEM_STATUS.asList[j].StatusDate):'';                            
                            this.orderLineRecords[i].Material = data.ITEM_STATUS.asList[j].ISBN ? data.ITEM_STATUS.asList[j].ISBN:this.formatISBNTo13Characters(data.ITEM_STATUS.asList[j].Material);
                            if(this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT] != undefined){

                                if(this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'SHIPPED'){
                                    this.shippedItems.push( data.ITEMS.asList[j].Material);
                                }

                                if (this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'CANCELLED'){
                                    this.cancelledItems.push( data.ITEMS.asList[j].Material);
                                }

                                if(this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() != 'SHIPPED' && this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() != 'CANCELLED'){
                                    this.remianingItems.push( data.ITEMS.asList[j].Material);
                                }

                                if (this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'SHIPPED') {
                                    this.orderLineRecords[i].backOrderOrCancelled = false;
                                    this.orderLineRecords[i].TobeShipped = '';
                                    this.orderLineRecords[i].QtyClosed = data.ITEM_STATUS.asList[j].SalesItemQuantity;
                                    shippingItems.push(data.ITEM_STATUS.asList[j].ISBN ? data.ITEM_STATUS.asList[j].ISBN:this.formatISBNTo13Characters(data.ITEM_STATUS.asList[j].Material));
                                } else {
                                    if (this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'PICKED/PACKED (NOT SHIPPED)') {
                                        this.packedItemstoCheck.push(
                                            data.ITEM_STATUS.asList[j].ISBN
                                        )
                                        this.beingPackedCheck.push(
                                            data.ITEM_STATUS.asList[j].Material
                                        );

                                        this.orderLineRecords[i].QtyClosed = '';
                                        this.orderLineRecords[i].TobeShipped = data.ITEM_STATUS.asList[j].SalesItemQuantity;                                    
                                    }
                                    if (this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'BACK ORDERED' || this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'CANCELLED'
                                        || this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'ON HOLD') {

                                        if (this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'BACK ORDERED') {                                            
                                            this.orderLineRecords[i].Reason =  data.ITEM_STATUS.asList[j].StockDueInDate? ('Expected Due Date: ' +this.formatDate(data.ITEM_STATUS.asList[j].StockDueInDate)):'Expected Due Date: Not Yet Established';
                                            this.orderLineRecords[i].QtyClosed = '';
                                            this.orderLineRecords[i].TobeShipped = data.ITEM_STATUS.asList[j].SalesItemQuantity;
                                        }
                                        if (this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'CANCELLED' || this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'ON HOLD') {
                                            this.cancelledReasonCode.push(
                                                data.ITEM_STATUS.asList[j].ItemRejectionReason
                                            );
                                            if(this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'CANCELLED'){
                                                this.orderLineRecords[i].QtyClosed = data.ITEM_STATUS.asList[j].SalesItemQuantity;;
                                                this.orderLineRecords[i].TobeShipped = '';  
                                                this.orderLineRecords[i].reasonCode = data.ITEM_STATUS.asList[j].ItemRejectionReason ? data.ITEM_STATUS.asList[j].ItemRejectionReason:'';
                                            }else{
                                                this.orderLineRecords[i].QtyClosed = '';
                                                this.orderLineRecords[i].TobeShipped = data.ITEM_STATUS.asList[j].SalesItemQuantity;
                                                this.orderLineRecords[i].reasonCode = data.ITEM_STATUS.asList[j].ItemRejectionReason ? data.ITEM_STATUS.asList[j].ItemRejectionReason:'';
                                            }                                      
                                        }
                                        this.backOrderOrCancelled = true;
                                        this.orderLineRecords[i].backOrderOrCancelled = true;

                                    } else {
                                        this.backOrderOrCancelled = false;
                                        this.orderLineRecords[i].backOrderOrCancelled = false;
                                        this.orderLineRecords[i].QtyClosed = '';
                                        this.orderLineRecords[i].TobeShipped = data.ITEM_STATUS.asList[j].SalesItemQuantity;
                                    }
                                }
                            }else{
                                    this.orderLineRecords[i].TobeShipped = data.ITEM_STATUS.asList[j].SalesItemQuantity;
                            }
                        }
                    }
                    }
                }
                }
                this.shipItemstoCheck = [...shippingItems];
                this.getPricingMethod(data.CONDITIONS.asList);
                this.logType = 'Enosix Sales Doc Detail';
                this.requestBody = this.documentNumber;
                this.statusLog = 'Success';
                this.internalStatus = '';
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus,'scc_orderStatusLWC/getOrderSeatails/getDetail');
            })
            .catch(error => {
                this.isLoading1 = false;
                console.log('error is', error);
                this.logType = 'Enosix Sales Doc Detail';
                this.requestBody = this.documentNumber;
                this.statusLog = 'Error';
                this.internalStatus = JSON.stringify(error);
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus,'scc_orderStatusLWC/getOrderSeatails/getDetail');
                // Catch any errors 
            })
            .finally(() => {
                if(!!this.orderNumber){
                    this.records = this.orderLineRecords;
                    this.pageSize = this.pageSizeOptions[0];
                    this.totalRecords = this.orderLineRecords.length;
                    this.paginationHelper(); // call helper menthod to update pagination logic 
                    this.getInvShipDetails();
                    if (this.packedItemstoCheck.length > 0) {
                        this.packedItemsStatusUpdate();
                    }
                    if (this.cancelledReasonCode) {
                        this.cancelledOrderReason();
                    }
                    this.calculateOverallStatus();
                }
                this.isLoading1 = false;
            })
    }

    getShippingMethod(data){
        this.shippingMethod ='';
        if(data.SHIPPING.ShippingConditions){
            if(data.SHIPPING.ShippingConditions == 'AC'){
                this.shippingMethod = this.labels.scc_orderDetail_shipMethod_NextDay;
            }else if(data.SHIPPING.ShippingConditions == 'AF'){
                this.shippingMethod = this.labels.scc_orderDetail_shipMethod_secondDay;
            }else{
                this.shippingMethod = this.labels.scc_orderDetail_shipMethod_Regular;
            }
        }else{
            this.shippingMethod = 'N/A';
        }
    }

    getPricingMethod(data){
        this.pricingConditions = [...JSON.parse(JSON.stringify(data))];
        this.pricingConditions= this.pricingConditions.reduce((acc, condition) => {
            if (condition.CalculationType === 'C' && (condition.ConditionType === 'ZNET' || condition.ConditionType === 'ZCON')) {
                acc.push(condition);
            }
            return acc;
        }, []);   
        this.pricingConditionsMap = new Map(this.pricingConditions.map(item => [item.ConditionItemNumber, item]));
        for (let j = 0; j < this.orderLineRecords.length; j++) {
            let SalesItem = this.orderLineRecords[j].SalesItem;
            let conditionType = this.pricingConditionsMap.get(SalesItem) ? this.pricingConditionsMap.get(SalesItem).ConditionType:'';
            if(conditionType == 'ZNET'){
                this.orderLineRecords[j].MaterialPricingGroupDescription = 'Net Price';
            }
            if(conditionType == 'ZCON'){
                this.orderLineRecords[j].MaterialPricingGroupDescription = 'Contract Price';
            }
        }
    }

    calculateOverallStatus(){
        if(this.remianingItems.length > 0){
            this.OverallStatusDescription = 'Open';
        }else{
            if(this.shippedItems.length > 0 && this.shippedItems.length == this.orderLineRecords.length){
                this.OverallStatusDescription = 'Fulfilled';
            }else{
                if(this.cancelledItems.length > 0 && (this.cancelledItems.length + this.shippedItems.length) == this.orderLineRecords.length && this.shippedItems.length > 0){
                    this.OverallStatusDescription = 'Fulfilled';
                }else if(this.cancelledItems.length > 0 && this.cancelledItems.length == this.orderLineRecords.length){
                    this.OverallStatusDescription = 'Cancelled';
                }else{
                    this.OverallStatusDescription = 'Open';
                }
            }            
        }
        this.deliveryInfo[0].OverallStatusDescription = this.OverallStatusDescription;
    }

    isRenderedCallbackCalled = false
    renderedCallback() {
        if (this.source == 'comp' && this.isRenderedCallbackCalled == false) {     //Added by Zubiya for muti page
            if (this.template.querySelector('.search-fields-group').classList.contains("slds-show")) {
                this.template.querySelector('.search-fields-group').classList.toggle("slds-hide");
                this.template.querySelector('.slds-icon-utility-chevronup').classList.toggle("chevron-up");
                this.isRenderedCallbackCalled = true;
            }
        }
        //Added by zubiya
        if (this.isCssLoaded) return
        this.isCssLoaded = true
        loadStyle(this, ORDER_STATUS_EXT_CSS).then(() => {

        }).catch(error => {
           console.error("Error in loading the colors")
        });
        loadStyle(this, headmarkupstyle_static).then(() => {

        }).catch(error => {
            console.error("Error in loading the colors")
        });
    }

    //pagination handlers
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }

    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }

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

    paginationHelper() {
        this.recordsToDisplay = [];
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        }else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        // Calculate start and end index
        const startIndex = (this.pageNumber - 1) * this.pageSize;
        const endIndex = Math.min(startIndex + this.pageSize, this.totalRecords);
        // Slice the records array to get the current page's records
        this.recordsToDisplay = this.records.slice(startIndex, endIndex);
    }

    get sortOptions() {
        return [
            { label: 'PO#', value: 'PO#' },

        ];
    }

    handleSortClick(event) {
        event.preventDefault();
        if (!this.sortDirection) {
            // First click, sort ascending
            this.sortDirection = 'asc';
        } else {
            // Toggle between asc and desc
            this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
        }
        this.sortData(this.sortedBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let recordsDisplay = this.recordsToDisplay;
        let parseData = JSON.parse(JSON.stringify(recordsDisplay));
        
        if (direction) {  // Only sort if a direction is specified
            let isReverse = direction === 'asc' ? 1 : -1;
            parseData.sort((x, y) => {
                // Handle potential null or undefined values
                let a = ((x && x[fieldname]) || '').toString().toLowerCase();
                let b = ((y && y[fieldname]) || '').toString().toLowerCase();
                
                // Split the string into text and numeric parts
                let aParts = a.match(/([a-z]+)|(\d+)/gi) || [];
                let bParts = b.match(/([a-z]+)|(\d+)/gi) || [];
                
                // Compare each part
                for (let i = 0; i < Math.min(aParts.length, bParts.length); i++) {
                    if (aParts[i] !== bParts[i]) {
                        // If both parts are numeric, compare as numbers
                        if (!isNaN(aParts[i]) && !isNaN(bParts[i])) {
                            return isReverse * (Number(aParts[i]) - Number(bParts[i]));
                        }
                        // Otherwise, compare as strings
                        return isReverse * (aParts[i] > bParts[i] ? 1 : -1);
                    }
                }
                // If all parts are the same up to this point, compare lengths
                return isReverse * (aParts.length - bParts.length);
            });
        }
        this.recordsToDisplay = parseData;
    }

    //Button getters
    get bDisableFirst() {
        return this.pageNumber == 1;
    }

    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }


    get SearchByOptions() {
        return this.SearchByOptions1;
    }

    get noRecordsToDisplay() {
        return this.recordsToDisplay.length == 0;
    }


    get OrderStatusOptions() {
        return this.OrderStatusOptions1;
    }


    get CountryOptions() {
        return this.CountrysOptions3;
    }

    get orderLineRecords1() {
        return JSON.parse(JSON.stringify(this.orderLineRecords));
    }
    //Handlers for option changes
    handleOrderStatusOptionChange(event) {
        this.OrderStatusValue = event.detail.value;
    }

    handleCountryOptionChange(event) {
        this.CountryValue = event.target.value;
    }

    handleSearchOptionChange(event) {
        this.handleClearClick();
        this.SearchByvalue = event.target.value;
        this.PONumSelect = false;
        this.InvoiceSelect = false;
        this.ISBNselect = false;
        this.DocumentNumSelect = false;
        this.SANSelect = false;
        this.ZipSelect = false;
        this.StateSelect = false;
        this.CountrySelect = false;
        this.locations = false;
        this.allOrdersSelect = false;
        this.CustomerAccount = false;
        this.CustomerName = false;

        if (this.SearchByvalue == 'PO#' || this.SearchByvalue == 'All Ship-To Locations' || this.SearchByvalue == 'Our Ship-To Locations Only') {
            this.PONumSelect = true;
            if (this.SearchByvalue == 'All Ship-To Locations' || this.SearchByvalue == 'Our Ship-To Locations Only') {
                this.locations = true;
            }
        }

        if (this.SearchByvalue == 'Invoice #') {
            this.InvoiceSelect = true;
        }

        if (this.SearchByvalue == 'Containing ISBN') {
            this.ISBNselect = true;
        }

        if (this.SearchByvalue == 'Order #') {
            this.DocumentNumSelect = true;
        }

        if (this.SearchByvalue == 'Customer SAN') {
            this.SANSelect = true;
        }

        if (this.SearchByvalue == 'Zip/Postal Code') {
            this.ZipSelect = true;
        }

        if (this.SearchByvalue == 'State/Province') {
            this.StateSelect = true;
        }

        if (this.SearchByvalue == 'Country') {
            this.CountrySelect = true;
        }

        if (this.SearchByvalue == 'All Orders') {
            this.allOrdersSelect = true;
        }
        if (this.SearchByvalue == 'Customer Account #') {
            this.CustomerAccount = true;
        }
        if (this.SearchByvalue == 'Customer Name') {
            this.CustomerName = true;
        }
    }

    handlePONumChange(event) {
        this.PONum = event.target.value;
    }

    handleInvoNumChange(event) {
        this.InvoNum = event.target.value
    }

     handleISBnNumChange(event) {
        this.ISBnNum = event.target.value;
        this.showErrorMessage = false; // Reset error message when ISBN changes
    }

    handleDocContrNumChange(event) {
        this.DocContrNum = event.target.value;
    }

    handleZipNumChange(event) {
        this.ZipNum = event.target.value;

    }

    handleStateNumChange(event) {
        this.StateNum = event.detail.value;
    }

    handleSANNumChange(event) {
        this.SANNum = event.target.value;
    }

    handleCustNameChange(event) {
        this.CustName = event.target.value;
    }

    handleStartDateChange(event) {
        this.startDate = event.target.value;

    }

    handleEndDateChange(event) {
        this.endDate = event.target.value;

    }

    handleCityNumChange(event) {
        this.CityNum = event.target.value;
    }


    handleRadioChange(event) {
        this.selectedValue = event.target.value;
        if (this.selectedValue === 'BillTo') {
            this.isBillToSelected = true;
            this.isShipToSelected = false;
        } else {
            this.isBillToSelected = false;
            this.isShipToSelected = true;
        }
        this.updateCustomerAccountValue();
    }

    handleInputChange(event) {
        const inputValue = event.target.value;
        if (this.selectedValue === 'BillTo') {
            this.billToValue = inputValue;
        } else if (this.selectedValue === 'ShipTo') {
            this.shipToValue = inputValue;
        }
        this.updateCustomerAccountValue();
    }

    updateCustomerAccountValue() {

    }

    get isBillToInputDisabled() {
        return this.selectedValue !== 'BillTo';
    }

    get isShipToInputDisabled() {
        return this.selectedValue !== 'ShipTo';
    }
    //end by sudha

    //clear button click separated to add the condition for aria-disabled true/false for accessibility
    handleClearButtonClick() {
        if (!JSON.parse(this.template.querySelector('.clear-button').getAttribute('aria-disabled'))) {
            this.handleClearClick();
        }
    }

    handleClearClick() {
        this.showSearchResults = false;
        this.pageSize = this.pageSizeOptions[0];
        this.PONum = '';
        this.InvoNum = '';
        this.ISBnNum = '';
        this.DocContrNum = '';
        if (this.isGuest == false) {
            this.ZipNum = '';
        }
        this.StateNum = '';
        this.CityNum = '';
        this.SANNum = '';
        this.CustName = '';
        this.startDate = null;
        this.endDate = null;
        this.OrderStatusValue = 'All';
        this.CountryValue = '';
        // this.CustomerAccount = '';
        if (this.isInternal == true) {
            this.CustName = '';
        }
        this.isBillToSelected = '';// added by sudha
        this.isShipToSelected = '';// added by sudha
        this.billToValue = '';// added by sudha
        this.shipToValue = '';// added by sudha
        this.SearchDisabledReturn = true;
        // Clear the error message
        this.showErrorMessage = false;
        this.errorMessage = '';
    }

    get SearchDisabled() {
    if (
        // Internal State/Province search - all three fields required
        (this.isInternal === true && this.SearchByvalue === 'State/Province' && 
            this.StateNum !== '' && this.CityNum !== '' && this.CustName !== '') ||
        // External State/Province search - only state required
        (this.isInternal === false && this.SearchByvalue === 'State/Province' && 
            this.StateNum !== '') ||
        // Regular PO search
        (this.PONum !== '' && this.SearchByvalue === 'PO#') ||
        // All Orders search
        (this.SearchByvalue === 'All Orders') ||
        // Invoice search
        (this.InvoNum !== '' && this.SearchByvalue === 'Invoice #') ||
        // ISBN search
        (this.ISBnNum !== '' && this.SearchByvalue === 'Containing ISBN') ||
        // Order number search
        (this.DocContrNum !== '' && this.SearchByvalue === 'Order #') ||
        // Zip code search
        (this.ZipNum !== '' && this.SearchByvalue === 'Zip/Postal Code') ||
        // Internal zip code search
        (this.ZipNum !== '' && this.SearchByvalue === 'Zip/Postal Code' && this.isInternal === true) ||
        // Country and customer name search
        (this.CountryValue !== '' && this.CustName !== '') ||
        // SAN search
        (this.SANNum !== '' && this.SearchByvalue === 'Customer SAN') ||
        // Customer name search
        (this.CustName !== '' && this.SearchByvalue === 'Customer Name') ||
        // Customer account searches
        (this.shipToValue !== '' && this.SearchByvalue === 'Customer Account #') ||
        (this.billToValue !== '' && this.SearchByvalue === 'Customer Account #') ||
        // Internal ISBN search with additional fields
        ((this.ISBnNum !== '' && (this.ZipNum !== '' || this.StateNum !== '')) && 
            this.SearchByvalue === 'Containing ISBN' && this.isInternal === true) ||
        // Ship-to locations search
        ((this.SearchByvalue === 'All Ship-To Locations' || 
            this.SearchByvalue === 'Our Ship-To Locations Only') && 
            this.startDate !== null && this.endDate !== null)
    ) {
        this.SearchDisabledReturn = false;
    } else {
        this.SearchDisabledReturn = true;
    }
    return this.SearchDisabledReturn;
}

    //Method called when the action button is clicked in the Datatable
    handleRowAction(event) {
        const actionname = event.detail.action.name
        const row = event.detail.row;
        if (actionname == 'viewRecords') {
            this.orderDetailsSect = true;
            this.showOrderData = true;
        }
        this.documentNumber = event.detail.row.SAP_Document_Number;
        this.getOrderSeatails();//changes for W-014208 US-49
    }

    //added by Vaibhav to include new UI table change
    handleOrderNumClick(event) {
        if (event.target.dataset.siopord == 'true' || event.target.dataset.siopord == true) {
            this.siopOrd = true;
        } else {
            this.siopOrd = false;
        }
        this.documentNumber = event.target.dataset.name;
        this.orderDetailsSect = true;
        this.getOrderSeatails();

        setTimeout(() => {
            this.template.querySelector('.return-to-search-button').focus();
        }, 50);

        if (this.isInternal) {
            this.updateOrder();
        }
    }

    handleOrderNumClickKeypress(event) {
        if (event.key === 'Enter') {
            this.handleOrderNumClick(event);
        }
    }

    handleRegisterSIOP() {
        this.getSIOPDetails();
    }
    //added by zubiya

    updateOrder() {
        updateOrder({ orderId: this.documentNumber })
            .then(result => {

            })
            .catch(error => {
               console.log('result error', error);
            })
    }

    getSIOPDetails() {
        getSIOPurl({ orderNum: this.documentNumber })
            .then(result => {
                if(this.enableLogs){
                    console.log('result url IIis', result);
                }                
                window.open(result, '_blank');
            })
            .catch(error => {
                console.log('result error', error);
            })
    }

    get backOrderOrCancelled1() {
        return this.backOrderOrCancelled;
    }

    formatDate(date) {
        const [year, month, day] = date.split('-');
        return `${month}/${day}/${year}`;
    }

    formatPrice(price) {
        price =price ? parseFloat(price):price;
        if (typeof price === 'number') {
            let formattedPrice = price.toFixed(2);
            formattedPrice = formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            return formattedPrice;
        } else {
            return price;
        }
    }

    //changes for W-014208 US-49 ends
    compareAddresses(data) {
       this.ShipToAccount='';
       this.ShipTo='';
       this.shipToAcc='';
       this.shipToAddress='';
       this.shipToAccName='';
       this.billToAcc='';
       this.billToAddress='';
       this.billToAccName='';
       this.licenseToAcc='';
       this.licenseToAddress=''; 
       this.licenseToAccname='';
       this.shippingStreet = '';
       this.shippingCity = '';
       this.shippingState = '';
       this.shippingPostalCode = '';
       this.billingStreet = '';
       this.billingCity = '';
       this.billingState = '';
       this.billingPostalCode = '';
       this.billToAccName1 = '';
       this.shipToAccName1 = '';       
       try{
        for (let i = 0; i < data.PARTNERS.asList.length; i++) {
            if (data.PARTNERS.asList[i].PartnerFunctionName.includes('Ship-to') || data.PARTNERS.asList[i].PartnerFunctionName.includes('Ship to')) {
                this.ShipToAccount = data.PARTNERS.asList[i].PartnerNumber;
                this.ShipTo = data.PARTNERS.asList[i].PartnerName + ' ' + '|' + ' '
                this.ShipTo += data.PARTNERS.asList[i].Street ? (data.PARTNERS.asList[i].Street+','):'' +' '+'';
                this.shippingStreet = data.PARTNERS.asList[i].Street ? (data.PARTNERS.asList[i].Street+''):'' +' '+'';
                this.ShipTo += data.PARTNERS.asList[i].City ? (data.PARTNERS.asList[i].City+','):''+' '+'';
                this.shippingCity = data.PARTNERS.asList[i].City ? (data.PARTNERS.asList[i].City+', '+''):''+' '+'';
                this.ShipTo += data.PARTNERS.asList[i].Region ? (data.PARTNERS.asList[i].Region+' '):''+' '+'';
                this.shippingState = data.PARTNERS.asList[i].Region ? (data.PARTNERS.asList[i].Region+' '+''):''+' '+'';
                this.ShipTo += data.PARTNERS.asList[i].PostalCode ? (data.PARTNERS.asList[i].PostalCode+','):''+' '+'';
                this.shippingPostalCode = data.PARTNERS.asList[i].PostalCode ? (data.PARTNERS.asList[i].PostalCode):''+' '+'';
                this.ShipTo += data.PARTNERS.asList[i].Country ? (data.PARTNERS.asList[i].Country):'' +' '+'';
                this.shipToAcc = data.PARTNERS.asList[i].PartnerNumber;
                this.shipToAddress = data.PARTNERS.asList[i].PartnerName + ' ' ;
                this.shipToAddress += data.PARTNERS.asList[i].Street ? (data.PARTNERS.asList[i].Street+','):'' +' '+'';
                this.shipToAddress += data.PARTNERS.asList[i].City ? (data.PARTNERS.asList[i].City+','):''+' '+'';
                this.shipToAddress += data.PARTNERS.asList[i].Region ? (data.PARTNERS.asList[i].Region+' '):''+' '+'';
                this.shipToAddress += data.PARTNERS.asList[i].PostalCode ? (data.PARTNERS.asList[i].PostalCode+''):''+' '+'';
                this.shipToAccName = data.PARTNERS.asList[i].PartnerName;
                this.shipToAccName1 = data.PARTNERS.asList[i].PartnerName+'';
            }
            //changes for W-014117 US-150 starts
            if (data.PARTNERS.asList[i].PartnerFunctionName.includes('Bill-to') || data.PARTNERS.asList[i].PartnerFunctionName.includes('Bill to')) {
                this.billToAcc = data.PARTNERS.asList[i].PartnerNumber;
                this.billToAddress = data.PARTNERS.asList[i].PartnerName + ' ';
                this.billToAddress += data.PARTNERS.asList[i].Street ? (data.PARTNERS.asList[i].Street+','):'' +' '+'';
                this.billingStreet = data.PARTNERS.asList[i].Street ? (data.PARTNERS.asList[i].Street+' '):'' +' '+'';
                this.billToAddress += data.PARTNERS.asList[i].City ? (data.PARTNERS.asList[i].City+','):''+' '+'';
                this.billingCity = data.PARTNERS.asList[i].City ? (data.PARTNERS.asList[i].City+', '):''+' '+'';
                this.billToAddress += data.PARTNERS.asList[i].Region ? (data.PARTNERS.asList[i].Region+' '):''+' '+'';
                this.billingState = data.PARTNERS.asList[i].Region ? (data.PARTNERS.asList[i].Region+' '):''+' '+'';
                this.billToAddress += data.PARTNERS.asList[i].PostalCode ? (data.PARTNERS.asList[i].PostalCode+''):''+' '+'';
                this.billingPostalCode = data.PARTNERS.asList[i].PostalCode ? (data.PARTNERS.asList[i].PostalCode):''+' '+'';
                this.billToAccName = data.PARTNERS.asList[i].PartnerName;
                this.billToAccName1 = data.PARTNERS.asList[i].PartnerName+' ';
            }

            if (data.PARTNERS.asList[i].PartnerFunctionName.includes('License-to') || data.PARTNERS.asList[i].PartnerFunctionName.includes('License to')) {
                this.licenseToAcc = data.PARTNERS.asList[i].PartnerNumber;
                this.licenseToAddress = data.PARTNERS.asList[i].PartnerName + ' ';
                this.licenseToAddress += data.PARTNERS.asList[i].Street ? (data.PARTNERS.asList[i].Street+','):'' +' '+'';
                this.licenseToAddress += data.PARTNERS.asList[i].City ? (data.PARTNERS.asList[i].City+','):''+' '+'';
                this.licenseToAddress += data.PARTNERS.asList[i].Region ? (data.PARTNERS.asList[i].Region+' '):''+' '+'';
                this.licenseToAddress += data.PARTNERS.asList[i].PostalCode ? (data.PARTNERS.asList[i].PostalCode+''):''+' '+'';
                this.licenseToAccname = data.PARTNERS.asList[i].PartnerName;
            }
        }

        if ((this.billToAcc == this.shipToAcc && this.billToAddress == this.shipToAddress) && (this.billToAcc == this.licenseToAcc && this.billToAddress == this.licenseToAddress)) {
            if (this.billToAcc != '' && this.billToAccName != '' && this.billToAddress != '') {
                this.addressInfoRecords.push({
                    id: 1,
                    account: this.billToAcc,
                    name: this.billToAccName,
                    address: this.billToAddress,
                    billTo: true,
                    shipTo: true,
                    licenseTo: true,
                    SAN: 'WFC'
                })
            }
        } else if ((this.billToAcc == this.shipToAcc && this.billToAddress == this.shipToAddress) && (this.billToAcc != this.licenseToAcc && this.billToAddress != this.licenseToAddress)) {
            if (this.billToAcc != '' && this.billToAccName != '' && this.billToAddress != '') {
                this.addressInfoRecords.push({
                    id: 1,
                    account: this.billToAcc,
                    name: this.billToAccName,
                    address: this.billToAddress,
                    billTo: true,
                    shipTo: true,
                    licenseTo: false,
                })
            }
            if (this.licenseToAcc != '' && this.licenseToAccname != '' && this.licenseToAddress != '') {
                this.addressInfoRecords.push({
                    id: 2,
                    account: this.licenseToAcc,
                    name: this.licenseToAccname,
                    address: this.licenseToAddress,
                    billTo: false,
                    shipTo: false,
                    licenseTo: true,
                    SAN: 'WFC'
                })
            }

        } else if ((this.billToAcc != this.shipToAcc && this.billToAddress != this.shipToAddress) && (this.billToAcc == this.licenseToAcc && this.billToAddress == this.licenseToAddress)) {
            if (this.billToAcc != '' && this.billToAccName != '' && this.billToAddress != '') {
                this.addressInfoRecords.push({
                    id: 1,
                    account: this.billToAcc,
                    name: this.billToAccName,
                    address: this.billToAddress,
                    billTo: true,
                    shipTo: false,
                    licenseTo: true,
                    SAN: 'WFC'
                })
            }
            if (this.shipToAcc != '' && this.shipToAccName != '' && this.shipToAddress != '') {
                this.addressInfoRecords.push({
                    id: 2,
                    account: this.shipToAcc,
                    name: this.shipToAccName,
                    address: this.shipToAddress,
                    billTo: false,
                    shipTo: true,
                    licenseTo: false,
                    SAN: 'WFC'
                })
            }

        } else if ((this.billToAcc != this.shipToAcc && this.billToAddress != this.shipToAddress) && (this.shipToAcc == this.licenseToAcc && this.shipToAddress == this.licenseToAddress)) {
            if (this.billToAcc != '' && this.billToAccName != '' && this.billToAddress != '') {
                this.addressInfoRecords.push({
                    id: 1,
                    account: this.billToAcc,
                    name: this.billToAccName,
                    address: this.billToAddress,
                    billTo: true,
                    shipTo: false,
                    licenseTo: false,
                    SAN: 'WFC'
                })
            }
            if (this.shipToAcc != '' && this.shipToAccName != '' && this.shipToAddress != '') {
                this.addressInfoRecords.push({
                    id: 2,
                    account: this.shipToAcc,
                    name: this.shipToAccName,
                    address: this.shipToAddress,
                    billTo: false,
                    shipTo: true,
                    licenseTo: true,
                    SAN: 'WFC'
                })
            }

        } else if ((this.billToAcc != this.shipToAcc && this.billToAddress != this.shipToAddress) && (this.billToAcc != this.licenseToAcc && this.billToAddress != this.licenseToAddress)) {
            if (this.billToAcc != '' && this.billToAccName != '' && this.billToAddress != '') {
                this.addressInfoRecords.push({
                    id: 1,
                    account: this.billToAcc,
                    name: this.billToAccName,
                    address: this.billToAddress,
                    billTo: true,
                    shipTo: false,
                    licenseTo: false,
                    SAN: 'WFC'
                })
            }

            if (this.shipToAcc != '' && this.shipToAccName != '' && this.shipToAddress != '') {
                this.addressInfoRecords.push({
                    id: 2,
                    account: this.shipToAcc,
                    name: this.shipToAccName,
                    address: this.shipToAddress,
                    billTo: false,
                    shipTo: true,
                    licenseTo: false,
                    SAN: 'WFC'
                })
            }

            if (this.licenseToAcc != '' && this.licenseToAccname != '' && this.licenseToAddress != '') {
                this.addressInfoRecords.push({
                    id: 3,
                    account: this.licenseToAcc,
                    name: this.licenseToAccname,
                    address: this.licenseToAddress,
                    billTo: false,
                    shipTo: false,
                    licenseTo: true,
                    SAN: 'WFC'
                })
            }


        }

        if(this.addressInfoRecords.length === 0){
            if (this.billToAcc != '' && this.billToAccName != '' && this.billToAddress != '') {
                this.addressInfoRecords.push({
                    id: 1,
                    account: this.billToAcc,
                    name: this.billToAccName,
                    address: this.billToAddress,
                    billTo: true,
                    shipTo: false,
                    licenseTo: false,
                    SAN: 'WFC'
                })
            }

            if (this.shipToAcc != '' && this.shipToAccName != '' && this.shipToAddress != '') {
                this.addressInfoRecords.push({
                    id: 2,
                    account: this.shipToAcc,
                    name: this.shipToAccName,
                    address: this.shipToAddress,
                    billTo: false,
                    shipTo: true,
                    licenseTo: false,
                    SAN: 'WFC'
                })
            }

            if (this.licenseToAcc != '' && this.licenseToAccname != '' && this.licenseToAddress != '') {
                this.addressInfoRecords.push({
                    id: 3,
                    account: this.licenseToAcc,
                    name: this.licenseToAccname,
                    address: this.licenseToAddress,
                    billTo: false,
                    shipTo: false,
                    licenseTo: true,
                    SAN: 'WFC'
                })
            }
        }
        
        this.deliveryInfo.push({
                                orderNumber: this.orderNumber,
                                CustomerPurchaseOrderNumber: this.CustomerPurchaseOrderNumber,
                                CustomerPurchaseOrderDate: this.CustomerPurchaseOrderDate,
                                CustomerPurchaseOrderType: this.CustomerPurchaseOrderType,
                                RequestedDeliveryDate: this.RequestedDeliveryDate,
                                OverallStatusDescription: this.OverallStatusDescription,
                                ShipToAccount: this.ShipToAccount,
                                ShipTo: this.ShipTo,
                                shippingMethod:this.shippingMethod
                            });

        } catch(error) {
            console.error('An error occurred:', error.message);
        }
    }


    getInvShipDetails() {
        getSalesDocFlow({
            documentNumber: this.documentNumber,
            itemNumber: ''
        })
        .then(({ data, messages, pagingOptions }) => {
            this.responseBody = JSON.stringify(data);
            if( this.enableLogs){
                console.log('getSalesDocFlow: data: ',data);
            }
            for (let i = 0; i < data.length; i++) {
                if (data[i].DocumentCategoryText == 'Invoice-Dlv Rltd') {
                    this.shipmentNumbers.push({
                        invoiceNumber: data[i].SalesDocument,
                        deliveryNumber: data[i].OriginatingDocument,
                        id: i,
                        shipDate: 'NA',
                        grossAmount: 0,
                        netOrderValue: 0,
                        taxAmount: 0,
                        cartons: 0,
                        weight: 0,
                        shippedLines: 0,
                        shippedUnits: 0,
                        shipstatus: 'NA',
                        transportation: 0,
                    })
                }

                if (data[i].DocumentCategoryText == 'Invoice-Order Rltd') {
                    this.shipmentNumbers.push({
                        invoiceNumber: data[i].SalesDocument,
                        deliveryNumber:'',
                        id: i,
                        shipDate: '',
                        grossAmount: 0,
                        netOrderValue: 0,
                        taxAmount: 0,
                        cartons: '',
                        weight: '',
                        shippedLines: '',
                        shippedUnits: '',
                        shipstatus: '',
                        transportation: 0,
                    })
                }                
            }
            this.logType = 'Enosix Sales Doc Flow';
            this.requestBody = this.documentNumber;
            this.statusLog = 'Success';
            this.internalStatus = '';
            this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus,'scc_orderStatusLWC/getInvShipDetails/getSalesDocFlow');
        })
        .catch(error => {
            console.log('error is', error);
            this.logType = 'Enosix Sales Doc Flow';
            this.requestBody = this.documentNumber;
            this.statusLog = 'Error';
            this.internalStatus = JSON.stringify(error);
            this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus,'scc_orderStatusLWC/getInvShipDetails/getSalesDocFlow');
        })
        .finally(() => {
            this.shipmentInfoRecords = this.shipmentNumbers;
            this.updateOrderLineStatus();
            this.getShipmentDetails();
            this.getDeliveryDetails();
        });
    }

    updateOrderLineStatus() {
        if (this.shipItemstoCheck.length > 0) {
            this.shippedItemStatusUpdate();
        }
    }

    shippedItemStatusUpdate() {
        if(this.enableLogs){
            console.log('this.shipItemstoCheck', this.shipItemstoCheck);
        }       
        this.shipItemstoCheck = JSON.parse(JSON.stringify(this.shipItemstoCheck));
        if (this.shipItemstoCheck.length > 0) {
            itemsStatushelper({ items: this.shipItemstoCheck })
                .then(result => {
                    if(this.enableLogs){
                        console.log('shipItemstoCheck data from apex', result);
                    }
                    const digitalProds = ['OLS', 'AMD', 'BOL', 'SUL','DSB', 'OLC'];
                    const category = ['ZOSW', 'ZOS'];
                    for (let j = 0; j < this.orderLineRecords.length; j++) {
                        for (let i = 0; i < result.length; i++) {
                            if (this.orderLineRecords[j].Material == result[i].ISBN10__c ||
                                this.orderLineRecords[j].Material == result[i].ISBN13__c ||
                                this.orderLineRecords[j].Material == result[i].ProductCode
                            ) {
                                if (category.includes(result[i].Item_Category_Group_ID__c)) {
                                    this.orderLineRecords[j].LineStatus = 'Invoiced';
                                }
                                if (digitalProds.includes(result[i].Product_Type_ID__c)) {
                                    this.orderLineRecords[j].LineStatus = 'Fulfilled';
                                }
                            }
                        }

                    }
                })
                .catch(error => {
                    console.log('error is', error);
                })
                .finally(() => {
                    this.records = this.orderLineRecords;
                })
        }
    }

    packedItemsStatusUpdate() {
        if(this.enableLogs){
            console.log('this.packedItemstoCheck', this.packedItemstoCheck);
        }
        itemsStatushelper({ items: this.packedItemstoCheck })
            .then(result => {
                if(this.enableLogs){
                    console.log('packedItemstoCheck data from apex', result);
                }
                const digitalProducts = ['OLS', 'AMD', 'BOL', 'SUL','DSB', 'OLC'];
                for (let j = 0; j < this.orderLineRecords.length; j++) {
                    for (let i = 0; i < result.length; i++) {
                        if (this.orderLineRecords[j].Material == result[i].ISBN10__c ||
                            this.orderLineRecords[j].Material == result[i].ISBN13__c ||
                            this.orderLineRecords[j].Material == result[i].ProductCode
                        ) {
                            if (digitalProducts.includes(result[i].Product_Type_ID__c)) {
                                this.orderLineRecords[j].LineStatus = 'Being Fulfilled';
                            } else {
                                this.orderLineRecords[j].LineStatus = 'Being Packed';
                                this.orderLineRecords[j].beingPacked = true;
                                this.beingPacked = true;
                                if (this.orderLineRecords[j].beingPacked) {
                                    this.orderLineRecords[j].Reason = 'In Queue';
                                    this.beingPackedArray.push(
                                        this.orderLineRecords[j].Material1
                                    );
                                }
                            }

                        }
                    }

                }
                this.beingPackedStatusUpdate(this.beingPackedArray);
            })
            .catch(error => {
                console.log('error is', error);
            })
            .finally(() => {
                this.records = this.orderLineRecords;

            })
    }

    //Added for W-014103
    beingPackedStatusUpdate(itemToCheck) {
        if(this.enableLogs){
            console.log('this.beingPackedArray', this.beingPackedArray);
        }
        getLogProStatus({ itemsPacked: itemToCheck,orderNumber:this.orderNumber })
            .then(result => {
                if(this.enableLogs){
                    console.log('beingPackedCheck data from apex', result);
                }
                if (result) {
                    for (let j = 0; j < this.orderLineRecords.length; j++) {
                        for (let i = 0; i < result.length; i++) {
                            if (this.orderLineRecords[j].Material1 == result[i].ISBN) {
                                if (result[i] == '' || result[i] == null) {
                                    this.orderLineRecords[j].Reason = 'In Queue';
                                }else {
                                    this.orderLineRecords[j].Reason = result[i].status;
                                }
                            }
                        }
                    }
                }
            })
            .catch(error => {
                console.log('error is', error);
            })
            .finally(() => {
                this.records = this.orderLineRecords;

            })
    }

    getShipmentDetails() {
        this.shipData = {};
        for (let i = 0; i < this.shipmentNumbers.length; i++) {
            getInvoice({ documentNumber: this.shipmentNumbers[i].invoiceNumber })
                .then(({ data, messages }) => {
                    if(this.enableLogs){
                        console.log('getInvoice data from enosix', data);
                    }
                    this.isLoading1 = true;
                    this.responseBody = JSON.stringify(data);
                    this.shipmentInfoRecords[i].id= i;
                    this.shipmentInfoRecords[i].shipDate=data.ShipDate? this.formatDate(data.ShipDate):'';
                    this.shipmentInfoRecords[i].grossAmount = data.GrossAmount? this.formatPrice(data.GrossAmount.toFixed(2)):0.00;
                    this.shipmentInfoRecords[i].netOrderValue = data.NetProduct? this.formatPrice(data.NetProduct.toFixed(2)):0.00;
                    this.shipmentInfoRecords[i].taxAmount=data.TaxAmount ? this.formatPrice(data.TaxAmount.toFixed(2)):0.00;
                    this.shipmentInfoRecords[i].transportation= data.Transportation ? this.formatPrice(data.Transportation.toFixed(2)):0.00;
                    this.isLoading1 = false;
                    this.logType = 'Enosix Invoice Doc';
                    this.requestBody = this.shipmentNumbers[i].invoiceNumber;
                    this.statusLog = 'Success';
                    this.internalStatus = '';
                    this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus,'scc_orderStatusLWC/getInvShipDetails/getInvoice');
                })
                .catch(error => {
                    console.log('error is', error);
                    this.logType = 'Enosix Invoice Doc';
                    this.requestBody = this.shipmentNumbers[i].invoiceNumber;
                    this.statusLog = 'Error';
                    this.internalStatus = JSON.stringify(error);
                    this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus,'scc_orderStatusLWC/getInvShipDetails/getInvoice');
                })
                .finally(() => {

                });
        }
    }

   getDeliveryDetails(){
        for (let i = 0; i < this.shipmentInfoRecords.length; i++) {
            if(this.shipmentInfoRecords[i].deliveryNumber){
                getDelivery({ documentNumber: this.shipmentInfoRecords[i].deliveryNumber })
                    .then(({ data, messages }) => {
                        if(this.enableLogs){
                            console.log('getDelivery data from enosix', data);
                        }
                        this.responseBody = JSON.stringify(data);
                        this.shipmentInfoRecords[i].cartons = data.Carton;
                        this.shipmentInfoRecords[i].shippedLines = data.HU_ITEMS.asList.length;
                        if(data.HU_ITEMS.asList.length > 0){
                            for (let j = 0; j < data.HU_ITEMS.asList.length; j++) {
                                this.shipmentInfoRecords[i].shippedUnits += data.HU_ITEMS.asList[j].HUItemQuantity;                                    
                            }
                        }
                        this.shipmentInfoRecords[i].shipstatus = data.DeliveryStatus;
                        this.shipmentInfoRecords[i].weight = data.ExtWeight.toFixed(2);
                        this.logType = 'Enosix Delivery Doc';
                        this.requestBody = this.shipmentNumbers[i].deliveryNumber;
                        this.statusLog = 'Success';
                        this.internalStatus = '';
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus,'scc_orderStatusLWC/getInvShipDetails/getDelivery');
                    })
                    .catch(error => {
                        console.log('error is', error);
                        this.logType = 'Enosix Delivery Doc';
                        this.requestBody = this.shipmentNumbers[i].deliveryNumber;
                        this.statusLog = 'Error';
                        this.internalStatus = JSON.stringify(error);
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus,'scc_orderStatusLWC/getInvShipDetails/getDelivery');
                    })                
            }
        }
    }

    handleTabClick(event) {
        let selectedTab = event.detail.value;
    }


    handleBackClick() {
        this.billToTabSelected = false;
        if(this.isGuest == true){
            const encodedValues = encodeDefaultFieldValues({           
        });
        this[NavigationMixin.Navigate] ({
            type: 'comm__namedPage',
            attributes: {
                    name : 'Login'  //Api name
            },
            state: {
            defaultFieldValues: encodedValues,
                Source : 'showOrderSearch'
            }
            })        
        }else{
            this.records = this.data;
            this.pageSize = this.pageSizeOptions[0];
            this.totalRecords = this.data.length;
            this.paginationHelper(); // call helper menthod to update pagination logic 
            this.orderDetailsSect = false;
        }
    }

    get recordsToDisplay() {
        return this.recordsToDisplay;
    }

    handleSearchButtonClick() {
    if (!JSON.parse(this.template.querySelector('.search-button').getAttribute('aria-disabled'))) {
        if (this.isInternal && this.SearchByvalue === 'State/Province') {
            if (!this.StateNum || !this.CityNum || !this.CustName) {
                this.showErrorMessage = true;
                this.errorMessage = this.labels.scc_OrderStatus_Required_Fields_Error;
                return;
            }
        }
        if (this.isInternal && this.SearchByvalue === 'Containing ISBN' && !this.ZipNum && !this.StateNum) {
            this.showErrorMessage = true;
            this.errorMessage = 'State/Province OR Zip/Postal Code are required';
            return;
        }
        
        this.showErrorMessage = false;
        this.handleSearch();
    }
}
   
    handleOrderData(event) {
        this.showOrderData = true;
        this.showShipmentData = false;
    }

    handleShipmentData(event) {
        this.showShipmentData = true;
        this.showOrderData = false;
    }

   
    handleShipDetails() {
        let eve = { target: { dataset: { id: 'tab-default-2__item' } } };
        this.handleActive(eve);
    }

    handleInvoiceNumClick(event) {
        this.invoiceInfo = event.target.dataset;
        this.showDeliveryDetails = true;
    }

    handleInvoiceNumClickKeypress(event) {
        if (event.key === 'Enter') {
            this.handleInvoiceNumClick(event);
        }
    }

    closeShowDeliveryDetails(event) {
        this.showDeliveryDetails = false;
        setTimeout(() => {
            let eve = { target: { dataset: { id: 'tab-default-2__item' } } };
            this.handleActive(eve);
        }, 50);
    }

    handleActive(event) {
         this.billToTabSelected = false;
        this.template.querySelectorAll('.slds-tabs_default__item').forEach((ele) => {
            if (ele.classList.contains('slds-is-active')) {
                ele.classList.remove('slds-is-active');
                ele.setAttribute('aria-selected', 'false');
                ele.tabindex = -1;
            }
            if (event.target.dataset.id == ele.dataset.id) {
                ele.classList.add('slds-is-active');
                ele.setAttribute('aria-selected', 'true');
                ele.tabindex = "0";
            }

        })
        this.template.querySelectorAll("[data-name=tabpanel]").forEach((ele) => {
            if (event.target.dataset.id == ele.dataset.id) {
                if (!ele.classList.contains("slds-show")) {
                    ele.classList.remove("slds-hide");
                    ele.classList.add("slds-show");
                }
            }
            else if (ele.classList.contains("slds-show")) {
                ele.classList.remove("slds-show");
                ele.classList.add("slds-hide");
            }
        })
        if(event.target.dataset.id == 'tab-default-1__item'){
            this.billToTabSelected = false;
            setTimeout(() => {
                this.template.querySelector('.orderTableFirstCell').focus();
            }, 100);
        }else if(event.target.dataset.id == 'tab-default-2__item'){
            this.billToTabSelected = false;
            setTimeout(() => {
                this.template.querySelector('.shipmentTableFirstCell').focus();
            }, 100);
        }else if(event.target.dataset.id == 'tab-default-3__item'){
            this.billToTabSelected = true;
            setTimeout(() => {
                this.template.querySelector('.billToTableFirstCell').focus();
            }, 100);
        }
    }

    toggleSearchFields(event) {
        this.template.querySelector('.search-fields-group').classList.toggle("slds-hide");
        event.target.classList.toggle("chevron-up");
        this.searchcriterieexpanded = !this.searchcriterieexpanded;
    }

    toggleSearchFieldsKeypress(event) {
        if (event.key === 'Enter') {
            this.toggleSearchFields(event);
        }
    }

    //Added for W-014778
    backOrderDueDateUpdate() {
        if(this.enableLogs){
            console.log('this.backOrderDueDatecheck', this.backOrderDueDatecheck);
        }        
        if (this.backOrderDueDatecheck) {
            itemsDueDate({ itemsDue: this.backOrderDueDatecheck })
                .then(result => {
                    if (result) {
                        if(this.enableLogs){
                            console.log('Result backorder', result);
                        }                        
                        for (let j = 0; j < this.orderLineRecords.length; j++) {
                            for (let i = 0; i < result.length; i++) {
                                if (this.orderLineRecords[j].Material == result[i].ISBN10__c ||
                                    this.orderLineRecords[j].Material == result[i].ISBN13__c ||
                                    this.orderLineRecords[j].Material == result[i].ProductCode
                                ) {
                                    if (result[i].Due_In_Stock_Date__c != null) {
                                        this.orderLineRecords[j].Reason = result[i].Due_In_Stock_Date__c;
                                    }else{
                                        this.orderLineRecords[j].Reason = 'Not Yet Established';
                                    }
                                }
                            }
                        }
                    }
                })
                .catch(error => {
                    console.log('error is', error);
                })
                .finally(() => {
                    this.records = this.orderLineRecords;
                })
        }
    }

    //Added for W-014778
    cancelledOrderReason() {
        if(this.enableLogs){
            console.log('this.cancelledReasonCode', this.cancelledReasonCode);
        }
        if (this.cancelledReasonCode) {
            getOrderCancelCode({ itemsCancel: this.cancelledReasonCode })
                .then(result => {
                    if (result) {
                        if(this.enableLogs){
                            console.log('cancel result', result);
                        }
                        const resultMap = new Map(result.map(item => [item.ReasonCode__c, item]));
                        for (let j = 0; j < this.orderLineRecords.length; j++) {
                            if(this.orderLineRecords[j].reasonCode !=null && this.orderLineRecords[j].reasonCode !=''){
                                let code = this.orderLineRecords[j].reasonCode;
                                let reason = resultMap.get(code).Reason__c ? resultMap.get(code).Reason__c:'';
                                if (reason != '') {
                                    this.orderLineRecords[j].Reason = reason;
                                }
                            }
                        }
                    }
                })
                .catch(error => {
                    console.log('error is', error);
                })
                .finally(() => {
                    this.records = this.orderLineRecords;
                })
        }
    }

    createLogs(logType, requestBody, responseBody, statusLog, internalStatus,entryPoint) {
            createIntegrationLogsLWC1({ logType: logType, requestBody: requestBody, responseBody: responseBody, status: statusLog, internalStatus: internalStatus,entryPoint:entryPoint})
            .then(result => {

            })
            .catch(error => {
                console.log('error is', error);
            })
    }

}