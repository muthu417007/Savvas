import { LightningElement,track,wire,api } from 'lwc';
import cartSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.cartSimulation'; 
import getOrderStatusCodes from '@salesforce/apex/scc_orderDetail_Controller.getOrderStatusCodes'; 
import getOrderMethodCodes from '@salesforce/apex/ordermethod.getOrderMethodCodes'; 
// import { CurrentPageReference } from 'lightning/navigation';
// import { decodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
// import { CartSummaryAdapter } from 'commerce/cartApi'; 



//Importing Apex classes
import getSearchByOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getSearchByOptions';
import getOrderStatusOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusOptions';
import getCountrysOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getCountrysOptions';
import getOrderStatusData from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusData';
import getCriteriaOrderdata from '@salesforce/apex/scc_orderStatusLWC_Controller.getCriteriaOrderdata';

//Enosix classes

import search from '@salesforce/apex/ensxtx_CTRL_DocumentSearch.search';
import getDetail from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getDetail';
import getInvoice from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getInvoice';
import getDelivery from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getDelivery';
import getSalesDocFlow from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getSalesDocFlow';
import createSAPOrder from '@salesforce/apex/ensxtx_CTRL_Cart.createSalesDocument';



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

//changes for W-014104 US-87
import scc_OrderDetail_Requested_Shipment_Date_tooltip from "@salesforce/label/c.scc_OrderDetail_Requested_Shipment_Date_tooltip";

//importing static resources
import {loadStyle} from 'lightning/platformResourceLoader';
import ORDER_STATUS_EXT_CSS from '@salesforce/resourceUrl/scc_ORDER_STATUS_EXT_CSS';
import scc_noResults from "@salesforce/resourceUrl/scc_noResults";

export default class TestPlaceOrder extends LightningElement {

    //Variables initialization
    @track SearchByvalue = 'PO#';
    @track OrderStatusValue = 'All';
    @track CountryValue = 'United States';
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
    { label: 'Customer SAN', value: 'Customer SAN' }
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

    //added by Vaibhav in new test component
    @track lineStatus;
    @track statusData;
    @track methodData;

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
        scc_noResults
    }

    // @wire(CurrentPageReference)
    // setCurrentPageRef(pageRef) {
    //     if (pageRef.state.defaultFieldValues) {
    //         const decodedValues = decodeDefaultFieldValues(pageRef.state.defaultFieldValues);
    //         console.log('decodedValues',decodedValues);
    //     }
    // }

    
    // @wire(getOrderStatusCodes)
    // wiredgetOrderStatusCodes({data, error}) {
    //     if (data) {
    //         console.log('data is',data);
    //     } else if (error) {
    //         console.log('error is',error);
    //     }
    // }

constructor(){
    super();
    
    getOrderStatusCodes() 
    .then(data => { 
        console.log('getOrderStatusCodes',data); 
        console.log('BL status is',data['BL']);
        this.statusData = data;
    }) 
    .catch(error => { 
        console.log(error); 
    }) 

    getOrderMethodCodes() 
    .then(data => { 
        console.log('getOrderMethodCodes',data); 
        console.log('BL status is',data['CAMS']);
        this.methodData = data;
    }) 
    .catch(error => { 
        console.log(error); 
    }) 

    createSAPOrder({ recordId: '801W400000579bcIAA', appSettingsName: 'ensxtx_SR_enosixOrderB2BAppSettings' })
    .then( data => {
      console.log('createSAPOrder response>>>', data);
      let parseData1 = JSON.parse(data);
      console.log('createSAPOrder data>>>', parseData1);
    })
    .catch(error => {
      console.log('createSAPOrder error>>>>',error);
    })
    .finally(()=>{
    });
    
}
@track showSIOP =false;
handleSubmitOrder(){
    this.showSIOP = true;
}

closeSubmitOrder(){
    this.showSIOP = false;
}

connectedCallback(){
    // cartSimulation({ cartId: '0a6W40000000zLFIAY', appSettingsName: 'ensxtx_SR_enosixWebCartB2BAppSettings' }) 
    // .then(({ data, messages }) => { 
    //     console.log('cartSimulation', data); 
    // }) 
    // .catch(error => { 
    //     console.log(error); 
    // }) 
    // .finally(() => this.loading = false); 

    this.getOrderSeatails();
}

 //changes for W-014208 US-49 starts
 @track orderNumber;
 @track CustomerPurchaseOrderDate;
 @track CustomerPurchaseOrderNumber;
 @track OverallStatusDescription;
 @track CustomerPurchaseOrderType;
 @track RequestedDeliveryDate;
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
 @track deliveryInfo;
 @track deliveryNumber ='';
 @track invoiceNumber = '';
 @track shipDate = '';
 @track grossAmount ='';
 @track netOrderValue = '';
 @track taxAmount = '';
 @track shipData ={};
 @track isLoading1 = false;

 @track toBeShipped = 0;
 @track lineMaterial;




 getOrderSeatails() {
     this.isLoading1 = true;
     this.orderLineRecords = [];
     this.addressInfoRecords = [];
     this.shipmentNumbers = [];
     this.shipmentInfoRecords =[];
     this.ShipToAccount = '';
     this.ShipTo = '';

     //1000057162
     getDetail({ documentNumber:'1000057111' })
         .then(({ data, messages }) => {
             console.log('Sales Doc data is', data);
             console.log(messages);
             // this.orderLineRecords = [...data.ITEMS.asList];
             // console.log('orderLineRecords are',this.orderLineRecords);
             this.deliveryInfo = data;
             this.orderNumber = data.SalesDocument;
             this.CustomerPurchaseOrderNumber = data.CustomerPurchaseOrderNumber;
             this.CustomerPurchaseOrderDate = data.CustomerPurchaseOrderDate;
             this.OverallStatusDescription = data.STATUS.OverallStatusDescription;
             if(data.STATUS.OverallStatusDescription.toUpperCase() =='COMPLETED'){
                 this.OverallStatusDescription ='Fulfilled';
             }
             this.CustomerPurchaseOrderType = data.ORDERDATA.CustomerPurchaseOrderType;
             this.CustomerPurchaseOrderType = this.methodData[this.CustomerPurchaseOrderType];
             //this.CustomerPurchaseOrderType = data.SALES.SalesDocumentTypeDescription;
             this.RequestedDeliveryDate = data.SALES.RequestedDeliveryDate;
             for (let i = 0; i < data.PARTNERS.asList.length; i++) {
                 // this.billTo = false;
                 // this.shipTo = false;
                 // this.licenseTo =false;
                 if (data.PARTNERS.asList[i].PartnerFunctionName == 'Ship-to Party') {
                     this.ShipToAccount = data.PARTNERS.asList[i].PartnerNumber;
                     this.ShipTo = data.PARTNERS.asList[i].PartnerName + '|' + data.PARTNERS.asList[i].Street + ' ' + data.PARTNERS.asList[i].City + ' ' + data.PARTNERS.asList[i].PostalCode + ' ' + data.PARTNERS.asList[i].Country;
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

                //  for (let j = 0; j < data.ITEM_STATUS.asList.length; j++) {
                    if (data.ITEMS.asList[i].SalesItem == data.ITEM_STATUS.asList[i].SalesItem) {
                        this.lineStatus = data.ITEM_STATUS.asList[i].ItemSTAT;
                        this.lineMaterial = data.ITEM_STATUS.asList[i].ISBN;
                    }
                // }

                if(this.statusData[data.ITEM_STATUS.asList[i].ItemSTAT].toUpperCase() == 'SHIPPED') {
                     this.QtyClosed = data.ITEMS.asList[i].OrderQuantity;
                     this.toBeShipped = '';
                 }else{
                    this.QtyClosed = '';
                    this.toBeShipped = data.ITEMS.asList[i].OrderQuantity;
                 }

                 this.orderLineRecords.push({
                     id:i,
                     SalesItem: data.ITEMS.asList[i].SalesItem,
                     Material: this.lineMaterial,
                     ItemDescription: data.ITEMS.asList[i].ItemDescription,
                     NetValueInDocumentCurrency: data.ITEMS.asList[i].NetValueInDocumentCurrency,
                     MaterialPricingGroupDescription: data.ITEMS.asList[i].MaterialPricingGroupDescription,
                     OrderQuantity: data.ITEMS.asList[i].OrderQuantity,
                     QtyClosed: this.QtyClosed,
                     TobeShipped: this.toBeShipped,
                     // Status: data.STATUS.OverallStatusDescription,
                     updatedStatusDate: this.updatedStatusDate,
                     Discount: data.ITEMS.asList[i].MaterialPricingGroupDescription,
                     LineStatus: this.statusData[this.lineStatus],
                     backOrderOrCancelled:false,
                     Reason:'',
                     iconName:'',
                     orderdetail:'',
                     pickedQty:0,
                     shippedQty:0
                 })
             }

             // this.orderLineRecords.forEach((row) => {
             //     this.template.querySelector(`[data-index="${row.id}"]`).style.setProperty('--content', `'${row.Reason}'`);
             // });
         })
         .catch(error => {
             this.isLoading1 = false;
             console.log('error is', error);
             // Catch any errors 
         })
         .finally(()=>{
            //  this.records = this.orderLineRecords;
            //  this.pageSize = this.pageSizeOptions[0];
            //  this.totalRecords = this.orderLineRecords.length;
            //  this.paginationHelper(); // call helper menthod to update pagination logic 
         })

    
        }
    }