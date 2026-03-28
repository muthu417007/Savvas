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

//Importing Apex classes
import getSearchByOptions from '@salesforce/apex/scc_internal_orderStatusLWC_Controller.getSearchByOptions';
import getOrderStatusOptions from '@salesforce/apex/scc_internal_orderStatusLWC_Controller.getOrderStatusOptions';
import getCountrysOptions from '@salesforce/apex/scc_internal_orderStatusLWC_Controller.getCountrysOptions';
import getOrderStatusData from '@salesforce/apex/scc_internal_orderStatusLWC_Controller.getOrderStatusData';
import getCriteriaOrderdata from '@salesforce/apex/scc_internal_orderStatusLWC_Controller.getCriteriaOrderdata';
import getOrderStatusCodes from '@salesforce/apex/scc_internal_orderDetail_Controller.getOrderStatusCodes'; 
import getOrderMethodCodes from '@salesforce/apex/scc_internal_orderDetail_Controller.getOrderMethodCodes'; 
import itemsStatushelper from '@salesforce/apex/scc_internal_orderDetail_Controller.itemsStatushelper'; 
import itemsDueDate from '@salesforce/apex/scc_internal_orderDetail_Controller.itemsDueDate'; 
import getLogProStatus from '@salesforce/apex/scc_internal_orderDetail_Controller.getLogProStatus'; 
import getOrderCancelCode from '@salesforce/apex/scc_internal_orderDetail_Controller.getOrderCancelCode'; 
import getSIOPurl from '@salesforce/apex/scc_checkSIOPRegistration.getSIOPurl';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation'; 

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

//changes for W-014104 US-87
import scc_OrderDetail_Requested_Shipment_Date_tooltip from "@salesforce/label/c.scc_OrderDetail_Requested_Shipment_Date_tooltip";

//importing static resources
import {loadStyle} from 'lightning/platformResourceLoader';
import ORDER_STATUS_EXT_CSS from '@salesforce/resourceUrl/scc_ORDER_STATUS_EXT_CSS';
import scc_noResults from "@salesforce/resourceUrl/scc_noResults";
import scc_calender_icon from "@salesforce/resourceUrl/scc_calender_icon";



export default class Scc_orderStatusLWC extends LightningElement {
     @track source;
     @track decodedValues;

    @wire(CurrentPageReference)       //Added by Zubiya for Multi page
    setCurrentPageRef(pageRef) {
       
        if (pageRef.state.Source) {
            this.source = pageRef.state.Source;
        }
       
         if (pageRef.state.defaultFieldValues) {      

            this.decodedValues = decodeDefaultFieldValues(pageRef.state.defaultFieldValues); 
            console.log('decodedValues',this.decodedValues);

        }

         
    }




   
 //Variables initialization
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
    @track SearchByOptions1 = [{ label: 'PO#', value: 'PO#' },
    { label: 'Invoice #', value: 'Invoice #' },
    { label: 'Containing ISBN', value: 'Containing ISBN' },
    { label: 'Order #', value: 'Order #' },
    { label: 'All Ship-To Locations', value: 'All Ship-To Locations' },
    { label: 'Our Ship-To Locations Only', value: 'Our Ship-To Locations Only' },
    { label: 'Zip/Postal Code', value: 'Zip/Postal Code' },
    { label: 'State/Province', value: 'State/Province' },
    { label: 'Country', value: 'Country' },
    // { label: 'Customer SAN', value: 'Customer SAN' }
    ];
//   @track SearchByOptions1 =
//     [{ label: 'PO#', value: 'PO#' },
//     { label: 'Invoice #', value: 'Invoice #' },
//     { label: 'Containing ISBN', value: 'Containing ISBN' },
//     { label: 'Order #', value: 'Order #' },
//      { label: 'Customer Account #', value: 'Customer Account' },
//     // { label: 'All Ship-To Locations', value: 'All Ship-To Locations' },
//     // { label: 'Our Ship-To Locations Only', value: 'Our Ship-To Locations Only' },
//     { label: 'Zip/Postal Code', value: 'Zip/Postal Code' },
//     { label: 'State/Province', value: 'State/Province' },
//     { label: 'Country', value: 'Country' },
//      { label: 'Customer Name', value: 'Customer Name' }
//     ];
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
    @track startDate = null;
    @track endDate = null;
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
    recordsToDisplay = []; //Records to be displayed on the page

    @track data;
    @track totalRecords;

    @track showOrderData = false;
    @track showShipmentData = false;
    @track isCssLoaded = false;

    @api getdatafrmhm;//changes for W-014196 US-163 

    @track activeTab;

    @track activeTabValue;

    @track documentNumber;//changes for W-014208 US-49
    @track allOrdersSelect = false;//changes for W-014384 US-184

    @track lineStatus;
    @track statusData;
    @track methodData;
    @track isGuest=false;
    @track expectedDueDate='';
   

    //Datables colomns
    columns = [
        { label: 'PO #', fieldName: 'PO', type: 'text', initialWidth: 125, sortable: true },
        { label: 'Order #', fieldName: 'SAP_Document_Number', type: 'button', sortable: true, typeAttributes: { label: { fieldName: 'SAP_Document_Number', type: 'text', class: 'custom-button' }, name: 'viewRecords', target: '_blank', class: 'custom-button', variant: 'base' }, cellAttributes: { style: 'transform:scale(0.75)' } },
        // { label: 'Order #', fieldName:'SAP_Document_Number', type: 'button', sortable: true},        
        { label: 'Order Date', fieldName: 'OrderDate', initialWidth: 125, type: 'Date',typeAttributes: {
   month: "numeric",
    day: "numeric",   
    year: "numeric"
}, sortable: true },
        { label: 'Order Method', fieldName: 'OrderMethod', initialWidth: 125, type: 'text', sortable: true },
        { label: 'Total Items', fieldName: 'TotalItems', initialWidth: 125, type: 'text', sortable: true },
        { label: 'Total Units', fieldName: 'Totalunits', initialWidth: 125, type: 'text', sortable: true },
        { label: 'Ship To', fieldName: 'CustShpippingAddress', type: 'String', sortable: true },
        { label: 'Bill To', fieldName: 'CustBillingAddress', type: 'String', sortable: true },
    ];

    orderDetailColumns=[
        { label: scc_OrderDetail_Seq, fieldName: 'SalesItem', type: 'text', initialWidth: 100, sortable: true },
        { label: scc_home_ISBN, fieldName: 'Material', type: 'text', initialWidth: 100, sortable: true },
        { label: scc_OrderDetail_Title, fieldName: 'ItemDescription', type: 'text', initialWidth: 150, sortable: true },
        { label: scc_OrderDetail_Price, fieldName: 'NetValueInDocumentCurrency', type: 'text', initialWidth: 100, sortable: true },
        { label: scc_OrderDetail_Pricing_Method, fieldName: 'MaterialPricingGroupDescription', type: 'text', initialWidth: 100, sortable: true },
        { label: scc_OrderDetail_Discount, fieldName: 'Discount', type: 'text', initialWidth: 100, sortable: true },
        { label: scc_OrderDetail_Qty_Ordered, fieldName: 'OrderQuantity', type: 'text', initialWidth: 125, sortable: true },
        // { label: scc_OrderDetail_Qty_Closed, fieldName: 'QtyClosed', type: 'text', initialWidth: 125, sortable: true },
        { label: scc_OrderDetail_Qty_Closed, fieldName: 'QtyClosed',initialWidth: 125, type: 'button', sortable: true, typeAttributes: { label: { fieldName: 'QtyClosed', type: 'text', class: 'custom-button' }, name: 'viewRecords1', target: '_blank', class: 'custom-button', variant: 'base' }, cellAttributes: { style: 'transform:scale(0.75)' } },      
        { label: scc_OrderDetail_To_be_shipped, fieldName: 'TobeShipped', type: 'text', initialWidth: 125, sortable: true },
        { label: scc_home_Status, fieldName: 'LineStatus', type: 'text', initialWidth: 100, sortable: true,cellAttributes:{ iconName:{fieldName:'iconName'}, iconPosition:'right',class:{fieldName:'orderdetail'},datatext:{fieldName:'Reason'} }},
        //{ label: scc_home_Status, fieldName: 'LineStatus', type: 'text', initialWidth: 100, sortable: true},
        //{ fieldName: 'iconName', type: 'button', initialWidth: 10,typeAttributes: {iconName: { fieldName: 'iconName' },title: { fieldName: 'Reason' }, alternativeText: 'Info',variant: 'base'} },
        { label: scc_OrderDetail_Status_Updated, fieldName: 'updatedStatusDate', type: 'text', initialWidth: 125, sortable: true },
    ];

    addressDetailColums=[
        { label: 'Account', fieldName: 'account', type: 'text', initialWidth: 100, sortable: true },
        { label: 'Name', fieldName: 'name', type: 'text', initialWidth: 250, sortable: true },
        { label: 'Address', fieldName: 'address', type: 'text', initialWidth: 600, sortable: true },
        //{ label: 'Bill To', fieldName: 'billTo', type: 'button', initialWidth: 100, sortable: true,typeAttributes:{readOnly:true,type:'boolean' }},
        { label: 'Bill To', fieldName: 'billTo', type: 'boolean', initialWidth: 100, sortable: true },
        { label: 'Ship To', fieldName: 'shipTo', type: 'boolean', initialWidth: 100, sortable: true },
        { label: 'License To', fieldName: 'licenseTo', type: 'boolean', initialWidth: 100, sortable: true },
    ]

    shipInfoColumns=[
        //{ label: 'Invoice #', fieldName: 'invoiceNumber', type: 'text', initialWidth: 125, sortable: true },
        { label: 'Invoice #', fieldName: 'invoiceNumber', type: 'button', sortable: true, typeAttributes: { label: { fieldName: 'invoiceNumber', type: 'text', class: 'custom-button' }, name: 'viewRecords2', target: '_blank', class: 'custom-button', variant: 'base' }, cellAttributes: { style: 'transform:scale(0.75)' } }, 
        { label: 'Shipment Date', fieldName: 'shipDate', type: 'text', initialWidth: 150, sortable: true },
        { label: 'Cartons', fieldName: 'cartons', type: 'text', initialWidth: 125, sortable: true },
        { label: 'Weight', fieldName: 'weight', type: 'text', initialWidth: 125, sortable: true },
        { label: 'Shipped Lines', fieldName: 'shippedLines', type: 'text', initialWidth: 150, sortable: true },
        { label: 'Shipped Units', fieldName: 'shippedUnits', type: 'text', initialWidth: 150, sortable: true },
        { label: 'Status', fieldName: 'shipstatus', type: 'text', initialWidth: 125, sortable: true },
        { label: 'Invoice Total', fieldName: 'grossAmount', type: 'text', initialWidth: 125, sortable: true },
    ]

    labels = {
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
        scc_noResults,
        scc_calender_icon,scc_OrderStatus_SIOP_Order,scc_OrderStatus_SIOP_Order_Note,scc_OrderStatus_SIOP_Order_Register_Participants
    }

    constructor() {
        super();
    }

    connectedCallback() {

        this.isLoading1 = true;

    const urlParams = new URLSearchParams(window.location.search);
    const creditDebitDocNum = urlParams.get('c__creditDebitDocNum');

    if (creditDebitDocNum) {
        console.log('Received Credit/Debit Document Number:', creditDebitDocNum);
        this.handleCreditDebitNavigation(creditDebitDocNum);
    } 


        if(this.decodedValues !=null){
            let Search = this.decodedValues.Search;
            //console.log('decodedValues2',this.decodedValues);
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
            this.StateNum = this.decodedValues .StateNum;
            this.CountryValue = this.decodedValues.CountryValue;
            let countStatusEve = { target: { value: this.decodedValues.CountryValue } };
            this.handleCountryOptionChange(countStatusEve);
            this.DocContrNum =  this.decodedValues.DocContrNum; 
            this.handleSearch();  
        }

        //get data from Apex
        getSearchByOptions({ HomePage: false }).then(response => {
           // console.log('response is', response);
            let paser = JSON.parse(response);
            console.log('getSearchByOptions', paser);
            this.SearchByOptions1 = JSON.parse(response);
            this.internalSearchByOptions=JSON.parse(response);
        }).catch(error => {
            //console.log('error is', error);
            this.isLoading1 = false;
        })

        getOrderStatusOptions().then(response => {
           // console.log('response is', response);
            let paser = JSON.parse(response);
            //console.log('getOrderStatusOptions', paser);
            this.OrderStatusOptions1 = JSON.parse(response);
        }).catch(error => {
            //console.log('error is', error);
            this.isLoading1 = false;
        })

        getCountrysOptions().then(response => {
            //console.log('response is', response);
            let paser = JSON.parse(response);
            //console.log('getCountrysOptions', paser);
            this.CountrysOptions2 = JSON.parse(response);
            this.CountrysOptions3 = [...this.CountrysOptions1, ...this.CountrysOptions2]
        }).catch(error => {
           //console.log('error is', error);
            this.isLoading1 = false;
        })

        getOrderStatusData().then(response => {
           // console.log('response is', response);
            let paser = JSON.parse(response);
            //console.log('getOrderStatusData', paser);
        }).catch(error => {
            //console.log('error is', error);
            this.isLoading1 = false;
        })

        getOrderStatusCodes() 
        .then(data => { 
            //console.log('getOrderStatusCodes',data); 
           // console.log('BL status is',data['BL']);
            this.statusData = data;
        }) 
        .catch(error => { 
            console.log(error); 
        }) 

        getOrderMethodCodes() 
        .then(data => { 
           // console.log('getOrderMethodCodes',data); 
            //console.log('BL status is',data['CAMS']);
            this.methodData = data;
        }) 
        .catch(error => { 
            console.log(error); 
        }) 

        getUserInformation().then(response =>{
           // console.log('response is',response);
            let paser = JSON.parse(response);
            let data = paser[0];
            //console.log(data);
            this.userName = data.userName;
            this.accountName=data.accountName;
            this.isGuest = data.isGuest;
        }).catch(error =>{
            //console.log('error is',error);
        })


        this.isLoading1 = false;
    }


handleCreditDebitNavigation(creditDebitDocNum) {
    this.orderDetailsSect = true;
    this.showOrderData = true;
    this.documentNumber = creditDebitDocNum;
    this.getOrderSeatails(creditDebitDocNum);
}

  isRenderedCallbackCalled = false
    renderedCallback(){ 

    if (this.source == 'comp' && this.isRenderedCallbackCalled==false){     //Added by Zubiya for muti page
            if(this.template.querySelector('.search-fields-group').classList.contains("slds-show")){
                this.template.querySelector('.search-fields-group').classList.toggle("slds-hide");
                this.template.querySelector('.slds-icon-utility-chevronup').classList.toggle("chevron-up");      
                this.isRenderedCallbackCalled = true;
            }
        }


        if(this.isCssLoaded) return
        this.isCssLoaded = true
        loadStyle(this, ORDER_STATUS_EXT_CSS).then(()=>{
            //console.log("Loaded Successfully")
        }).catch(error=>{ 
            //console.error("Error in loading the colors")
        })
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


    // JS function to handel pagination logic 
    paginationHelper() {
        this.recordsToDisplay = [];
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number 
        if (this.totalPages <= 1) {
            this.totalPages = 1;
        }

        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }

        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.records[i]);
        }
        console.log('this.recordsToDisplay for Nasreen',this.recordsToDisplay);
    }

    onHandleSort(event) {
        console.log('onHandleSort :: ', event.detail);
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        console.log('sortData :: ', fieldname, direction);
        let parseData = JSON.parse(JSON.stringify(this.recordsToDisplay));
        let keyValue = (element) => {
            return element[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((xElement, yElement) => {
            xElement = keyValue(xElement) ? keyValue(xElement) : '';
            yElement = keyValue(yElement) ? keyValue(yElement) : '';
            return isReverse * ((xElement > yElement) - (yElement > xElement));
        });
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

    get orderLineRecords1(){
        return JSON.parse(JSON.stringify(this.orderLineRecords));
    }
    //Handlers for option changes
    handleOrderStatusOptionChange(event) {
        this.OrderStatusValue = event.detail.value;
        console.log('this.OrderStatusValue',this.OrderStatusValue);
    }

    handleCountryOptionChange(event) {
        console.log('handleCountryOptionChange event',event.target.value);
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

        if (this.SearchByvalue == 'All Orders'){
            this.allOrdersSelect = true;      
        }

    }

    handlePONumChange(event) {
        this.PONum = event.target.value;
        // this.SearchDisabledReturn = false;
    }

    handleInvoNumChange(event) {
        this.InvoNum = event.target.value
    }

    handleISBnNumChange(event) {
        this.ISBnNum = event.target.value;
    }

    handleDocContrNumChange(event) {
        this.DocContrNum = event.target.value;
    }

    handleZipNumChange(event) {
        this.ZipNum = event.target.value;
    }

    handleStateNumChange(event) {
        this.StateNum = event.target.value;
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

    handleClearClick() {
        // this.subscribeMessage();
        this.showSearchResults = false;
        this.pageSize = this.pageSizeOptions[0];
        this.PONum = '';
        this.InvoNum = '';
        this.ISBnNum = '';
        this.DocContrNum = '';
        if(this.isGuest == false){
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
        this.SearchDisabledReturn = true;
    }

    get SearchDisabled() {
        if ((this.PONum != '' && this.SearchByvalue == 'PO#') || (this.SearchByvalue == 'All Orders') || (this.InvoNum != '' && this.SearchByvalue == 'Invoice #') || (this.ISBnNum != '' && this.SearchByvalue == 'Containing ISBN') || (this.DocContrNum != '' && this.SearchByvalue == 'Order #') || (this.ZipNum != '' && this.SearchByvalue == 'Zip/Postal Code') || (this.CountryValue != '' && this.CustName != '') || (this.StateNum != '' && this.SearchByvalue == 'State/Province') || (this.SANNum != '' && this.SearchByvalue == 'Customer SAN')
           // || ((this.SearchByvalue == 'All Ship-To Locations' || this.SearchByvalue == 'Our Ship-To Locations Only') && (this.PONum != '' || this.ISBnNum != '' || (this.startDate != null && this.endDate != null)))) {
            || ((this.SearchByvalue == 'All Ship-To Locations' || this.SearchByvalue == 'Our Ship-To Locations Only'))) {
                console.log('this.SearchDisabledReturn ', this.SearchDisabledReturn);

            // if (this.OrderStatusValue == 'All' && (this.SearchByvalue == 'All Ship-To Locations' || this.SearchByvalue == 'Our Ship-To Locations Only') && (this.PONum == '' && this.ISBnNum == '' && (this.startDate == null && this.endDate == null))) {
            //     this.SearchDisabledReturn = true;
            // } else {
            //     this.SearchDisabledReturn = false;
            // }
            this.SearchDisabledReturn = false;

        } else {
            this.SearchDisabledReturn = true;
        }
        return this.SearchDisabledReturn;
    }


    //Method called when the action button is clicked in the Datatable
    handleRowAction(event) {
        const actionname = event.detail.action.name
        console.log('event value is', event.detail);
        const row = event.detail.row;
        if (actionname == 'viewRecords') {
            this.orderDetailsSect = true;
            this.showOrderData = true;
        }
        this.documentNumber = event.detail.row.SAP_Document_Number;
        // this.getactiveTabValue='order';
        this.getOrderSeatails();//changes for W-014208 US-49
    }
    //added by Vaibhav to include new UI table change
    @track siopOrd=false;
    handleOrderNumClick(event){
        console.log('Order Number for Nasreen',event.target.dataset);
        //this.siopOrd = event.target.dataset.siopord;
        if(event.target.dataset.siopord == 'true' || event.target.dataset.siopord == true){
            console.log('inside siop loop');
            this.siopOrd = true; 
        }else{
            this.siopOrd = false; 
        }
        console.log('this.siopOrd',this.siopOrd);
        this.documentNumber = event.target.dataset.name;
        this.orderDetailsSect = true;
        this.getOrderSeatails();

    }

    handleRegisterSIOP(){
        this.getSIOPDetails();
    }

    getSIOPDetails(){
        getSIOPurl({orderNum:this.documentNumber})
        .then(result=> {
            console.log('result url IIis',result);
            window.open(result,'_blank');
        })
        .catch(error=> {
            console.log('result error',error);
        })

    }

    //changes for W-014208 US-49 starts
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
    @track deliveryInfo=[];
    @track deliveryNumber ='';
    @track invoiceNumber = '';
    @track shipDate = '';
    @track grossAmount ='';
    @track netOrderValue = '';
    @track taxAmount = '';
    @track shipData ={};
    @track discountValue;
    @track toBeShipped = 0;
    @track lineMaterial;
    @track shipItemstoCheck=[];
    @track backOrderDueDatecheck=[];
    @track cancelledReasonCode=[];
    @track packedItemstoCheck=[];
    @track beingPackedCheck=[];
    @track shipNoInvoItemstoCheck=[];
    @track backOrderOrCancelled = false;
    @track beingPacked= false;

    get backOrderOrCancelled1(){
        return this.backOrderOrCancelled;
    }
       formatDate(date) {
        const [year, month, day] = date.split('-');
        return `${month}/${day}/${year}`;
    }


    getOrderSeatails() {
        this.isLoading1 = true;
        this.orderLineRecords = [];
        this.addressInfoRecords = [];
        this.shipmentNumbers = [];
        this.shipmentInfoRecords =[];
        this.ShipToAccount = '';
        this.ShipTo = '';
        this.shipItemstoCheck=[];
        this.packedItemstoCheck = [];
        this.backOrderDueDatecheck=[];
        this.beingPackedCheck=[];
        this.cancelledReasonCode=[];
        this.shipNoInvoItemstoCheck=[];
        this.backOrderOrCancelled = false;
        this.beingPacked = false;
        this.deliveryInfo=[];
        //console.time("Sales Doc Time is");
        const salesDocBefore = Date.now();
        //console.log('sales doc time before call',salesDocBefore);
        
         const documentNumberToUse = creditDebitDocNum || this.documentNumber;
    const isCredit = !!creditDebitDocNum; // Boolean flag to indicate if it's a credit/debit document

    getDetail({ documentNumber: documentNumberToUse, isCredit: isCredit })
        .then(({ data, messages }) => {
                //console.timeEnd("Sales Doc Time is");
                const salesDocAfter = Date.now();
                //console.log('sales doc time after call',salesDocAfter);
                console.log('Sales Doc api load time in seconds is', (salesDocAfter - salesDocBefore) / 1000);

                console.log('Sales Doc data is', data);
                console.log(messages);
                // this.orderLineRecords = [...data.ITEMS.asList];
                // console.log('orderLineRecords are',this.orderLineRecords);
                //this.deliveryInfo = data;
                this.orderNumber = data.SalesDocument;
                this.CustomerPurchaseOrderNumber = data.CustomerPurchaseOrderNumber;
                this.CustomerPurchaseOrderDate = this.formatDate(data.CustomerPurchaseOrderDate);
                this.OverallStatusDescription = data.STATUS.OverallStatusDescription;
                if(data.STATUS.OverallStatusDescription.toUpperCase() =='COMPLETED'){
                    this.OverallStatusDescription ='Fulfilled';
                }
                //this.CustomerPurchaseOrderType = data.ORDERDATA.CustomerPurchaseOrderType;
                this.CustomerPurchaseOrderType = data.ORDERDATA.CustomerPurchaseOrderType;
                this.CustomerPurchaseOrderType = this.methodData[this.CustomerPurchaseOrderType];
                this.RequestedDeliveryDateFormat = data.SALES.RequestedDeliveryDate;
                this.RequestedDeliveryDate = this.formatDate(this.RequestedDeliveryDateFormat);
                for (let i = 0; i < data.PARTNERS.asList.length; i++) {
                    // this.billTo = false;
                    // this.shipTo = false;
                    // this.licenseTo =false;
                    if (data.PARTNERS.asList[i].PartnerFunctionName == 'Ship-to Party') {
                        this.ShipToAccount = data.PARTNERS.asList[i].PartnerNumber;
                        this.ShipTo = data.PARTNERS.asList[i].PartnerName +' '+ '|' +' '+data.PARTNERS.asList[i].Street + ' ' + data.PARTNERS.asList[i].City + ' ' + data.PARTNERS.asList[i].PostalCode + ' ' + data.PARTNERS.asList[i].Country;
                        this.billTo = false;//changes for W-014117 US-150
                        this.shipTo = true;//changes for W-014117 US-150
                        this.licenseTo =false;//changes for W-014117 US-150
                    }
                    //changes for W-014117 US-150 starts
                    if(data.PARTNERS.asList[i].PartnerFunctionName =='Bill-to Party'){
                        this.billTo = true;
                        this.shipTo = false;
                        this.licenseTo =false;
                    }

                    if(data.PARTNERS.asList[i].PartnerFunctionName =='License-to Party'){
                        this.billTo = false;
                        this.shipTo = false;
                        this.licenseTo =true;
                    }

                    if(data.PARTNERS.asList[i].PartnerFunctionName =='License-to Party' || data.PARTNERS.asList[i].PartnerFunctionName =='Bill-to Party'
                    || data.PARTNERS.asList[i].PartnerFunctionName =='Ship-to Party'){
                        this.addressInfoRecords.push({
                            id:i,
                            account:data.PARTNERS.asList[i].PartnerNumber,
                            name:data.PARTNERS.asList[i].PartnerName,
                            address:data.PARTNERS.asList[i].Street+' '+ data.PARTNERS.asList[i].City+' '+data.PARTNERS.asList[i].PostalCode+' '+ data.PARTNERS.asList[i].Country,
                            billTo: this.billTo,
                            shipTo:this.shipTo,
                            licenseTo:this.licenseTo,
                            SAN:'WFC'
                        })
                    }
                    //changes for W-014117 US-150 ends

                }
                this.deliveryInfo.push({
                    orderNumber:this.orderNumber,
                    CustomerPurchaseOrderNumber:this.CustomerPurchaseOrderNumber,
                    CustomerPurchaseOrderDate: this.CustomerPurchaseOrderDate,
                    CustomerPurchaseOrderType:this.CustomerPurchaseOrderType,
                    RequestedDeliveryDate:this.RequestedDeliveryDate,
                    OverallStatusDescription:this.OverallStatusDescription,
                    ShipToAccount:this.ShipToAccount,
                    ShipTo:this.ShipTo
                });

                for (let i = 0; i < data.ITEMS.asList.length; i++) {

                    for (let j = 0; j < data.ITEMS_SCHEDULE.asList.length; j++) {
                        if (data.ITEMS.asList[i].SalesItem == data.ITEMS_SCHEDULE.asList[j].SalesItem) {
                            this.QtyClosed += data.ITEMS_SCHEDULE.asList[j].DeliveredQuantity;
                        }
                        if (data.ITEMS.asList[i].SalesItem == data.ITEMS_SCHEDULE.asList[j].SalesItem) {
                            if (data.ITEMS_SCHEDULE.asList[j].ScheduleLineDate > this.updatedStatusDate) {
                                this.updatedStatusDate = data.ITEMS_SCHEDULE.asList[j].ScheduleLineDate;
                            } else {
                                this.updatedStatusDate = data.ITEMS_SCHEDULE.asList[j].ScheduleLineDate;
                            }
                        }
                    }
                    this.lineMaterial = data.ITEMS.asList[i].Material ;

                    if (data.ITEMS.asList[i].MaterialPricingGroupDescription.includes('Price') && data.ITEMS.asList[i].Discount !=0) {
                        this.discountValue = data.ITEMS.asList[i].MaterialPricingGroupDescription.replace('Price', '');
                    }else{
                        this.discountValue = '';
                    }
                
                    // this.orderLineRecords.push({
                    //     id:i,
                    //     SalesItem: data.ITEMS.asList[i].SalesItem,
                    //     Material: this.lineMaterial,
                    //     ItemDescription: data.ITEMS.asList[i].ItemDescription,
                    //     NetValueInDocumentCurrency: data.ITEMS.asList[i].NetValueInDocumentCurrency,
                    //     MaterialPricingGroupDescription: data.ITEMS.asList[i].MaterialPricingGroupDescription,
                    //     OrderQuantity: data.ITEMS.asList[i].OrderQuantity,
                    //     QtyClosed: this.QtyClosed,
                    //     TobeShipped: this.toBeShipped,
                    //     // Status: data.STATUS.OverallStatusDescription,
                    //     updatedStatusDate:this.formatDate(this.updatedStatusDate),
                    //     Discount: this.discountValue,
                    //     LineStatus: this.statusData[this.lineStatus],
                    //     backOrderOrCancelled:this.backOrderOrCancelled,
                    //     Reason:'',
                    //     iconName:'',
                    //     orderdetail:''
                    // })

                    this.orderLineRecords.push({
                        id:i,
                        SalesItem: data.ITEMS.asList[i].SalesItem,
                        Material: this.lineMaterial,
                        ItemDescription: data.ITEMS.asList[i].ItemDescription,
                        NetValueInDocumentCurrency: data.ITEMS.asList[i].NetValueInDocumentCurrency,
                        MaterialPricingGroupDescription: data.ITEMS.asList[i].MaterialPricingGroupDescription,
                        OrderQuantity: data.ITEMS.asList[i].OrderQuantity,
                        QtyClosed: '',
                        TobeShipped: '',
                        // Status: data.STATUS.OverallStatusDescription,
                        updatedStatusDate:this.formatDate(this.updatedStatusDate),
                        Discount: this.discountValue,
                        LineStatus: '',
                        backOrderOrCancelled:false,
                        beingPacked:false,
                        Reason:'',
                        iconName:'',
                        orderdetail:'',
                        QtyShipped:'',
                        QtyInvoiced:'',
                        PONumber:data.CustomerPurchaseOrderNumber,
                        ParcelID:data.ITEMS.asList[i].ParcelID,
                        weight:data.ITEMS.asList[i].GrossWeight,
                        ParcelQty:''
                    })
                }

                for(let i=0;i<this.orderLineRecords.length;i++){
                    for (let j = 0; j < data.ITEM_STATUS.asList.length; j++) {
                    if (this.orderLineRecords[i].SalesItem == data.ITEM_STATUS.asList[j].SalesItem) {
                        console.log('inside item staus');
                        //this.orderLineRecords[i].LineStatus = data.ITEM_STATUS.asList[j].ItemSTAT;
                        this.orderLineRecords[i].LineStatus = this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT];
                        //this.orderLineRecords[i].Material = data.ITEM_STATUS.asList[j].ISBN;
                       // this.lineMaterial = data.ITEM_STATUS.asList[i].ISBN; 
                    
                    if(this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'SHIPPED') {
                        // this.backOrderOrCancelled = false;
                        // this.QtyClosed = data.ITEMS.asList[i].OrderQuantity;
                        // this.toBeShipped = '';
                        this.orderLineRecords[i].backOrderOrCancelled = false;
                        this.orderLineRecords[i].TobeShipped = '';
                       // this.orderLineRecords[i].QtyClosed = data.ITEMS.asList[i].OrderQuantity;
                       this.orderLineRecords[i].QtyClosed = data.ITEM_STATUS.asList[j].SalesItemQuantity;
                        this.shipItemstoCheck.push(
                           //itemNum:[i],
                           //ISBN:data.ITEM_STATUS.asList[i].ISBN
                           //data.ITEMS.asList[i].Material 
                          data.ITEM_STATUS.asList[j].Material
                        );
                    }else{
                       if(this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'PICKED/PACKED (NOT SHIPPED)') {
                        this.packedItemstoCheck.push(
                            //itemNum:[i],
                            //ISBN:data.ITEM_STATUS.asList[i].ISBN  
                            //data.ITEM_STATUS.asList[i].ISBN 
                            //data.ITEMS.asList[i].Material 
                            data.ITEM_STATUS.asList[j].Material
                        )
                        this.beingPackedCheck.push(
                        
                            data.ITEM_STATUS.asList[j].Material
                        );
                       }
                       if(this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'BACK ORDERED' || this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'CANCELLED') {
                            //this.backOrderOrCancelled = true;
                            console.log('inside back order');
                            
                        if(this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'BACK ORDERED')
                        {
                             this.backOrderDueDatecheck.push(
                                data.ITEM_STATUS.asList[j].Material
                                 );
                                if(this.backOrderDueDatecheck)
                                {
                                    this.backOrderDueDateUpdate();
                                }
                
                             console.log('backorderduedate',this.backOrderDueDatecheck);
                        }
                         if(this.statusData[data.ITEM_STATUS.asList[j].ItemSTAT].toUpperCase() == 'CANCELLED')
                        {
                             this.cancelledReasonCode.push(
                                data.ITEM_STATUS.asList[j].ItemRejectionReason
                                 );
                                 if(this.cancelledReasonCode)
                                 {
                                    this.cancelledOrderReason();
                                 }
                                
                             console.log('cancelledReasonCode',this.cancelledReasonCode);
                        }
                            this.backOrderOrCancelled = true;
                            this.orderLineRecords[i].backOrderOrCancelled = true;

                       }else{
                            this.backOrderOrCancelled = false;
                            this.orderLineRecords[i].backOrderOrCancelled = false;
                       }
                       //this.QtyClosed = '';
                       //this.toBeShipped = data.ITEMS.asList[i].OrderQuantity;
                       this.orderLineRecords[i].QtyClosed = '';
                       this.orderLineRecords[i].TobeShipped  = data.ITEM_STATUS.asList[j].SalesItemQuantity;
                    }
                }
                }
                }

                console.log('this.orderLineRecords are',this.orderLineRecords);

            })
            .catch(error => {
                this.isLoading1 = false;
                console.log('error is', error);
                // Catch any errors 
            })
            .finally(()=>{
                this.records = this.orderLineRecords;
                this.pageSize = this.pageSizeOptions[0];
                this.totalRecords = this.orderLineRecords.length;
                this.paginationHelper(); // call helper menthod to update pagination logic 
                this.getInvShipDetails();
                if(this.packedItemstoCheck.length>0){
                    this.packedItemsStatusUpdate();
                }
            
                
                this.isLoading1 = false;
            })
    }
    //changes for W-014208 US-49 ends

    getInvShipDetails(){
        //console.time("Sales Doc flow Time is");
        const salesDocFlowBefore = Date.now();
        getSalesDocFlow({ 
            documentNumber: this.documentNumber,
            itemNumber:''
        }) 
        .then(({ data, messages, pagingOptions }) => {  
            //console.timeEnd("Sales Doc flow Time is");
            const salesDocFlowAfter = Date.now();
            console.log('Sales Doc flow api load time in seconds is', (salesDocFlowAfter - salesDocFlowBefore) / 1000);
            console.log('sales flow documents are',data);
            for(let i=0;i<data.length;i++){
                console.log('data[i].DocumentCategoryText',data[i].DocumentCategoryText);
                // if(data[i].DocumentCategoryText =='Delivery'){
                //     this.deliveryNumber = data[i].SalesDocument;
                //     console.log('this.deliveryNumber ',this.deliveryNumber );
                // }
                if(data[i].DocumentCategoryText =='Invoice-Dlv Rltd'){
                    // this.invoiceNumber = data[i].SalesDocument;
                    // console.log('this.invoiceNumber ',this.invoiceNumber );
                    this.shipmentNumbers.push({
                        invoiceNumber:data[i].SalesDocument,
                        deliveryNumber:data[i].OriginatingDocument
                    })
                }

            }

        }) 
        .catch(error => { 
            console.log('error is',error); 
        })
        .finally(() => {
            this.updateOrderLineStatus();
            this.getShipmentDetails(); 
        });
    }

    updateOrderLineStatus(){
        if(this.shipItemstoCheck.length > 0){
            this.shippedItemStatusUpdate();
        }
    }

    shippedItemStatusUpdate(){
        console.log('this.shipItemstoCheck',this.shipItemstoCheck);
        
        if(this.shipmentNumbers.length == 0){
            // for(let j=0;j<this.orderLineRecords.length;j++){
            //     if(this.shipItemstoCheck.includes(this.orderLineRecords[j].Material)){
            //         this.shipNoInvoItemstoCheck.push()
            //     }
            // }
            itemsStatushelper({items:this.shipItemstoCheck})
            .then(result =>{
                console.log('shipItemstoCheck data from apex',result);
                const digitalProds = ['OLS','AMD','BOL','SUL','SEM','SER','DSB','OLC'];
                const category = ['ZOSW','ZOS'];
                for(let j=0;j<this.orderLineRecords.length;j++){
                    // console.log('inside if inside order line record check');
                    for (let i=0;i<result.length;i++){
                        if( this.orderLineRecords[j].Material==result[i].ISBN10__c){
                                // console.log('inside if inside ISBN check');
                            if(category.includes(result[i].Item_Category_Group_ID__c)){
                                // console.log('inside if being fulfil');
                                this.orderLineRecords[j].LineStatus='Invoiced';
                            }
                            if(digitalProds.includes(result[i].Product_Type_ID__c)){
                                // console.log('inside if being Packed');
                                this.orderLineRecords[j].LineStatus='Fulfilled';
                            }
                            
                        }
                    }
    
                }
            })
            .catch(error => {
                console.log('error is',error);
            })
            .finally(() => {
                this.records = this.orderLineRecords;
    
            })
        }
    }

    packedItemsStatusUpdate(){
        console.log('this.packedItemstoCheck',this.packedItemstoCheck);
        itemsStatushelper({items:this.packedItemstoCheck})
        .then(result =>{
            console.log('packedItemstoCheck data from apex',result);
            const digitalProducts = ['OLS','AMD','BOL','SUL','SEM','SER','DSB','OLC'];
            for(let j=0;j<this.orderLineRecords.length;j++){
                // console.log('inside if inside order line record check');
                for (let i=0;i<result.length;i++){
                    if( this.orderLineRecords[j].Material==result[i].ISBN10__c){
                            // console.log('inside if inside ISBN check');
                        if(digitalProducts.includes(result[i].Product_Type_ID__c)){
                            // console.log('inside if being fulfil');
                            this.orderLineRecords[j].LineStatus='Being Fulfilled';
                        }else{
                            // console.log('inside if being Packed');
                            this.orderLineRecords[j].LineStatus='Being Packed';
                            this.orderLineRecords[j].beingPacked=true;
                            this.beingPacked=true;
                            if(this.orderLineRecords[j].beingPacked)
                            {
                                this.beingPackedStatusUpdate();
                            }
                        }
                        
                    }
                }

            }
        })
        .catch(error => {
            console.log('error is',error);
        })
        .finally(() => {
            this.records = this.orderLineRecords;

        })
    }
    //Added for W-014103
    beingPackedStatusUpdate()
    { 
        console.log('beingpacked',this.beingPackedCheck);
        getLogProStatus({itemsPacked:this.beingPackedCheck})
        .then(result =>{

            console.log('beingPackedCheck data from apex',result);
            if(result)
            { 
             

             for(let j=0;j<this.orderLineRecords.length;j++){
              
                for (let i=0;i<result.length;i++)
                {
                    
                     
                        console.log('Packed',result[j]);
                        if(result[j] =='' || result[j]==null )
                        { 
                         this.orderLineRecords[j].Reason='In Queue';
                         console.log(' orderLineRecords[j].Reason being packed',this.orderLineRecords[j].Reason);
                        }
                        else
                        {
                            
                         this.orderLineRecords[j].Reason= result[j];
                         console.log(' orderLineRecords[j].Reason being packed',this.orderLineRecords[j].Reason);
                        }
                    
                    
                    
                }

            }
            }
            else
            {
                 for(let j=0;j<this.orderLineRecords.length;j++){
                       this.orderLineRecords[j].Reason='In Queue';
                       console.log(' orderLineRecords[j].Reason being packed',this.orderLineRecords[j].Reason);
                 }
            }

        })
        .catch(error => {
            console.log('error is',error);
        })
        .finally(() => {
            this.records = this.orderLineRecords;

        })
    }


    getShipmentDetails(){
        this.shipmentInfoRecords=[];
        this.shipData = {};
        //hard coded values
        // this.shipmentInfoRecords.push({
        //     id:1,
        //     invoiceNumber:'7000043367',
        //     shipDate:'12345',
        //     grossAmount:'12345',
        //     netOrderValue:'12345',
        //     taxAmount:'12345',
        //     cartons:'',
        //     weight:0,
        //     shippedLines:'',
        //     shippedUnits:0,
        //     shipstatus:'Shipped',
        //     transportation:'12345',
        //     deliveryNumber:'4000030911'
        // })
        //hard coded values        
                // Calling Sales Doc Flow data using Order number as input
                console.log('this.shipmentNumbers',this.shipmentNumbers);
            for(let i=0;i<this.shipmentNumbers.length;i++){
                //console.time("Invoice doc Time is");
                const invoiceBefore = Date.now();
                getInvoice({documentNumber: this.shipmentNumbers[i].invoiceNumber}) 
                .then(({data, messages}) => { 
                //console.timeEnd("Invoice doc Time is");
                const invoiceAfter = Date.now();
                console.log('Invoice Document api load time in seconds is', (invoiceAfter - invoiceBefore) / 1000);
                    this.isLoading1 = true;
                    console.log('Invoice data is',data) 
                    console.log(messages) 
                    this.shipData = data;
                    this.shipDate = this.shipData.ShipDate;
                    this.grossAmount = this.shipData.GrossAmount;
                    this.netOrderValue = this.shipData.NetOrderValue;
                    this.taxAmount = this.shipData.TaxAmount;

                    this.shipmentInfoRecords.push({
                        id:i,
                        invoiceNumber:this.shipData.BillingDocument,
                        shipDate:this.formatDate(this.shipData.ShipDate),
                        grossAmount:this.shipData.GrossAmount,
                        netOrderValue:this.shipData.NetOrderValue,
                        taxAmount:this.shipData.TaxAmount,
                        cartons:'',
                        weight:0,
                        shippedLines:'',
                        shippedUnits:0,
                        shipstatus:'',
                        transportation:this.shipData.Transportation,
                        deliveryNumber:this.shipmentNumbers[i].deliveryNumber
                    })
                    this.isLoading1 = false;
                }) 
                .catch(error => { 
                    console.log('error is',error); 
                })
                .finally(() => {
                    if(this.shipmentNumbers[i].deliveryNumber !='' && this.shipmentNumbers[i].deliveryNumber !=null){
                    //console.time("Delivery doc Time is");
                    const deliveryBefore = Date.now();
                    getDelivery({ documentNumber: this.shipmentNumbers[i].deliveryNumber}) 
                    .then(({data, messages}) => { 
                        //console.timeEnd("Delivery doc Time is");
                        const deliveryAfter = Date.now();
                        console.log('Delivery Document api load time in seconds is', (deliveryAfter - deliveryBefore) / 1000);
                        console.log('Delivery data is',data) ;
                        console.log(messages) ;
                        this.shipmentInfoRecords[i].cartons = data.Carton;
                        this.shipmentInfoRecords[i].shippedLines = data.ITEMS.asList.length;
                        for(let j=0;j<data.ITEMS.asList.length;j++){
                            this.shipmentInfoRecords[i].weight += data.ITEMS.asList[j].GrossWeight;
                            this.shipmentInfoRecords[i].shippedUnits += data.ITEMS.asList[j].QtyShipped;
                            this.shipmentInfoRecords[i].shipstatus = data.DeliveryStatus;
                        }
                    }) 
                    .catch(error => { 
                        console.log('error is',error); 
                    }) 
                }
                });

            }
            console.log('this.shipmentInfoRecords',this.shipmentInfoRecords);
    }



    handleTabClick(event) {
        let selectedTab = event.detail.value;
        if (selectedTab == 'Bill To') {
            console.log('Delivery Info', this.deliveryInfo);
        }
    }


    handleBackClick() {
        this.records = this.data;
        this.pageSize = this.pageSizeOptions[0];
        this.totalRecords = this.data.length;
        this.paginationHelper(); // call helper menthod to update pagination logic 
        this.orderDetailsSect = false;
    }

    get recordsToDisplay() {
        return this.recordsToDisplay;
    }

    //handler for search button
    handleSearch() {
        // this.recordsToDisplay = [];
        // this.totalRecords =0;
        this.isLoading1 = true;
        this.showSearchResults = true;
        console.log('this.PONum', this.PONum);
        console.log(typeof (this.PONum));
        console.log('this.startDate', this.startDate);
        console.log('this.endDate', this.endDate);
        console.log('this.DocContrNum', this.DocContrNum);
        console.log('this.SANNum', this.SANNum);
        console.log('this.CustName ',this.CustName);
        // if (this.OrderStatusValue == 'false') {
        //     this.OrderStatusValue = 'All';
        // }
        console.log('this.OrderStatusValue', this.OrderStatusValue);

        getCriteriaOrderdata({
            PO: this.PONum.trim(), ISBN: this.ISBnNum.trim(), startDate: this.startDate, endDate: this.endDate, orderStatus: this.OrderStatusValue,
            OrderNum: this.DocContrNum.trim(), Zip: this.ZipNum.trim(), State: this.StateNum.trim(), City: this.CityNum.trim(), Country: this.CountryValue, CustNam: this.CustName.trim(), SAN: this.SANNum.trim(), Invo: this.InvoNum.trim(), SearchValue: this.SearchByvalue
        }).then(response => {
            console.log('response is', response);
            let paser = JSON.parse(response);
            console.log('getCriteriaOrderdata', paser);
            this.data = JSON.parse(response);
            console.log('this.data ', this.data);
            this.records = this.data;
            this.pageSize = this.pageSizeOptions[0];
            this.totalRecords = this.data.length;
            if(this.totalRecords == 1){
                //let eve = {target:{dataset:{name:this.data[0].SAP_Document_Number,siopord:this.data[0].siopOrder}}};
                let eve = {target:{dataset:{name:this.data[0].SAP_Document_Number}}};
                this.documentNumber = this.data.SAP_Document_Number;
                this.handleOrderNumClick(eve);
            }
            this.paginationHelper(); // call helper menthod to update pagination logic 
            this.isLoading1 = false;
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })


    }

    handleOrderData(event) {
        this.showOrderData = true;
        this.showShipmentData = false;
    }

    handleShipmentData(event) {
        this.showShipmentData = true;
        this.showOrderData = false;
    }

    @track showDeliveryDetails = false;
    @track invoiceInfo;
    handleShipDetails() {
        //this.showDeliveryDetails = true;
        let eve = {target:{dataset:{id:'tab-default-2__item'}}};
        this.handleActive(eve);
    }

    handleInvoiceNumClick(event){
        // console.log('event.target.dataset',event.target.dataset);
        this.invoiceInfo = event.target.dataset;
        this.showDeliveryDetails = true;
    }

    closeShowDeliveryDetails(event) {
        this.showDeliveryDetails = false;
        setTimeout(()=>{
            let eve = {target:{dataset:{id:'tab-default-2__item'}}};
            this.handleActive(eve);
          }, 50);
    }

    handleActive(event) {
        // console.log('event.target.dataset.id tab click',event.target.dataset.id);
        //event.preventDefault();
        this.template.querySelectorAll('.slds-tabs_default__item').forEach((ele)=>{
            if(ele.classList.contains('slds-is-active')){
                ele.classList.remove('slds-is-active');
                ele.setAttribute('aria-selected','false');
                ele.tabindex=-1;
            }
            else if(event.target.dataset.id == ele.dataset.id){
                ele.classList.add('slds-is-active');
                ele.setAttribute('aria-selected','true');
                ele.tabindex="0";
            }
            
        })
        this.template.querySelectorAll("[data-name=tabpanel]").forEach((ele)=>{
            if(event.target.dataset.id == ele.dataset.id){
                if(!ele.classList.contains("slds-show")){
                    ele.classList.remove("slds-hide");
                    ele.classList.add("slds-show");
                }
            }
            else if(ele.classList.contains("slds-show")){
                ele.classList.remove("slds-show");
                ele.classList.add("slds-hide");
            }
        })
    }
    toggleSearchFields(event){
        this.template.querySelector('.search-fields-group').classList.toggle("slds-hide");
        event.target.classList.toggle("chevron-up");
    }


     //Added for W-014778
    backOrderDueDateUpdate(){
        console.log('this.backOrderDueDatecheck',this.backOrderDueDatecheck);
        if(this.backOrderDueDatecheck){
           itemsDueDate({itemsDue:this.backOrderDueDatecheck})
           .then(result =>{
            if(result)
            {
                console.log('Result backorder',result);
             for(let j=0;j<this.orderLineRecords.length;j++){
              
                for (let i=0;i<result.length;i++){
                    if( this.orderLineRecords[j].Material==result[i].ISBN10__c){
          
                        if(result[i].Due_In_Stock_Date__c!=null)
                        {
                            this.orderLineRecords[j].Reason= result[i].Due_In_Stock_Date__c;
                        } 
                        else{
                            this.orderLineRecords[j].Reason= 'Not Yet Established';
                        }
                        console.log('orderline backorder', this.orderLineRecords[j].Reason);
                    }
                }

            }
            }
           })  
        
        .catch(error => {
            console.log('error is',error);
        })
        
        .finally(() => {
            this.records = this.orderLineRecords;

        })
        }
    }

        //Added for W-014778
    cancelledOrderReason(){
        console.log('this.cancelledReasonCode',this.cancelledReasonCode);
        if(this.cancelledReasonCode){
           getOrderCancelCode({itemsCancel:this.cancelledReasonCode})
           .then(result =>{
            if(result)
            {
                console.log('cancel result',result);
             for(let j=0;j<this.orderLineRecords.length;j++){
              
                for (let i=0;i<result.length;i++){
                         this.orderLineRecords[j].Reason= result[i].Reason__c;
                         console.log(' orderLineRecords[j].Reason',this.orderLineRecords[j].Reason);
                    
                }

            }
            }
           })  
        
        .catch(error => {
            console.log('error is',error);
        })
        
        .finally(() => {
            this.records = this.orderLineRecords;

        })
        }
    }


}