/*
LWC Component:scc_orderStatusLWC
Author: CTS (Vaibhav Saptal)
Created Date: 03/04/2024
Reason: JS logic scc_orderStatusLWC component.
Modified Date: 22/04/2024
*/

import { LightningElement,track,wire,api } from 'lwc';

//Importing Apex classes
import getSearchByOptions  from '@salesforce/apex/scc_orderStatusLWC_Controller.getSearchByOptions';
import getOrderStatusOptions  from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusOptions';
import getCountrysOptions  from '@salesforce/apex/scc_orderStatusLWC_Controller.getCountrysOptions';
import getOrderStatusData  from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusData';
import getCriteriaOrderdata  from '@salesforce/apex/scc_orderStatusLWC_Controller.getCriteriaOrderdata';

//Enosix classes
import search from '@salesforce/apex/ensxtx_CTRL_DocumentSearch.search'; 
import getDetail from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getDetail' ;
import getInvoice from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getInvoice' 
import getDelivery from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getDelivery' ;
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

//changes for W-014104 US-87
import 	scc_OrderDetail_Requested_Shipment_Date_tooltip from "@salesforce/label/c.scc_OrderDetail_Requested_Shipment_Date_tooltip";



export default class Scc_orderStatusLWC extends LightningElement {
    //Variables initialization
    @track SearchByvalue= 'PO#';
    @track OrderStatusvalue = 'All';
    @track CountryValue = 'United States';
    @track PONumSelect = true;
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
    @track OrderStatusOptions1= [ { label: 'All', value: 'All' },{ label: 'Open', value: 'Open' },{ label: 'Cancelled', value: 'Cancelled' },{ label: 'FullFilled', value: 'FullFilled' }];
    @track CountrysOptions1=[{ label: 'United States', value: 'United States' },{ label: 'Canada', value: 'Canada' }];
    @track isLoading1 =false;
    @track CountrysOptions2;
    @track CountrysOptions3;
    @track PONum='';
    @track InvoNum = '';
    @track ISBnNum = '';
    @track DocContrNum = '';
    @track ZipNum = '';
    @track StateNum = '';
    @track CityNum ='';
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
    First ='<< First'
    Previous = '< Previous'
    next = 'Next >'
    Last = 'Last >>'
    pageSizeOptions = [5, 10, 15, 75, 100]; //Page size options
    records = []; //All records available in the data table
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    @track totalPages =1; //Total no.of pages
    pageNumber = 1; //Page number    
    recordsToDisplay = []; //Records to be displayed on the page

    @track data ;
    @track totalRecords;

    @track showOrderData = false;
    @track showShipmentData = false;
    
  
    @api getdatafrmhm;//changes for W-014196 US-163 

    @track documentNumber;//changes for W-014208 US-49
  
    //Datables colomns
    columns = [
        { label: 'PO #', fieldName: 'PO', type: 'text',initialWidth: 125, sortable: true},
        { label: 'Order #', fieldName: 'SAP_Document_Number',type: 'button', sortable: true,typeAttributes: { label: { fieldName: 'SAP_Document_Number',type:'text',class:'custom-button'},name:'viewRecords', target: '_blank',class:'custom-button',variant: 'base' },cellAttributes:{style:'transform:scale(0.75)'} },
        // { label: 'Order #', fieldName:'SAP_Document_Number', type: 'button', sortable: true},        
        { label: 'Order Date', fieldName: 'OrderDate',initialWidth: 125, type: 'Date', sortable: true },
        { label: 'Order Method', fieldName: 'OrderMethod',initialWidth: 125, type: 'text', sortable: true },
        { label: 'Total Items', fieldName: 'TotalItems',initialWidth: 125, type: 'text', sortable: true },
        { label: 'Total Units', fieldName: 'Totalunits',initialWidth: 125, type: 'text', sortable: true },
        { label: 'Ship To', fieldName: 'CustShpippingAddress', type: 'String', sortable: true},
        { label: 'Bill To', fieldName: 'CustBillingAddress', type: 'String', sortable: true},
    ];

    
    labels ={
        scc_home_Order_Entry_Period,scc_home_From,scc_home_To,scc_home_PO,scc_home_Document_Control,scc_home_Search_By,scc_home_ISBN,
        scc_home_Search,scc_home_Order_Status,scc_OrderStatus_Order_Search,scc_OrderStatus_Clear,scc_OrderStatus_Search_Criteria,scc_OrderStatus_Country,
        scc_OrderStatus_State_Province,scc_OrderStatus_Zip_Postal_Code,scc_OrderStatus_Invoice_Number,scc_OrderStatus_Customer_Name_begins_with,
        scc_OrderStatus_Customer_SAN,scc_OrderStatus_Search_Results,scc_OrderStatus_City,scc_OrderDetail_Requested_Shipment_Date_tooltip,scc_OrderStatus_No_Search_Result,
        scc_Order_Status_no_of_rows,scc_Order_Status_items
    }

    constructor(){
        super();
        this.OrderStatusvalue = 'All';

        getSalesDocFlow({ 
            documentNumber: '1000057111',
            itemNumber:''
        }) 
        .then(({ data, messages, pagingOptions }) => { 
            console.log('getSalesDocFlow data is',data) ;
            console.log(messages) 
            console.log(pagingOptions) 
        }) 
        .catch(error => { 
            // Catch any errors 
        }) 


        getInvoice({documentNumber: '7000043367'}) 
        .then(({data, messages}) => { 
            console.log('Invoice data is',data) 
            console.log(messages) 
        }) 
        .catch(error => { 
            // Catch any errors 
        }) 

        getDelivery({ documentNumber: '4000035333' }) 
        .then(({data, messages}) => { 
            console.log('Delivery data is',data) 
            console.log(messages) 
        }) 
        .catch(error => { 

            // Catch any errors 
        }) 

    } 




    connectedCallback(){
        this.isLoading1 = true;
        

        //changes for W-014196 US-163 starts
        console.log('sendDataToOrderStatus1',this.getdatafrmhm);

        
        if(this.getdatafrmhm){
            this.getdatafrmhm = JSON.parse(JSON.stringify(this.getdatafrmhm))
            console.log('sendDataToOrderStatus2',this.getdatafrmhm);
            let Search = this.getdatafrmhm.Search;
            this.SearchByvalue = Search;
            let even = {target:{value:Search}};
            this.handleSearchOptionChange(even);
            this.PONum=this.getdatafrmhm.PONum;
            this.ISBnNum =this.getdatafrmhm.ISBnNum;
            this.startDate=this.getdatafrmhm.startDate;
            this.endDate=this.getdatafrmhm.endDate;
            this.OrderStatusValue = this.getdatafrmhm.OrderStatusValue;
            this.InvoNum=this.getdatafrmhm.InvoNum;
            this.ZipNum =this.getdatafrmhm.ZipNum; 
            this.StateNum = this.getdatafrmhm.StateNum;
            this.CountryValue = this.getdatafrmhm.CountryValue;
            this.handleSearch();
        }
        //changes for W-014196 US-163 ends

        //get data from Apex
        getSearchByOptions({HomePage:false}).then(response =>{
            console.log('response is',response);
            let paser = JSON.parse(response);
            console.log('getSearchByOptions',paser);
            this.SearchByOptions1 = JSON.parse(response);
        }).catch(error =>{
            console.log('error is',error);
            this.isLoading1=false;
        })

        getOrderStatusOptions().then(response =>{
            console.log('response is',response);
            let paser = JSON.parse(response);
            console.log('getOrderStatusOptions',paser);
            this.OrderStatusOptions1 = JSON.parse(response);
        }).catch(error =>{
            console.log('error is',error);
            this.isLoading1=false;
        })

        getCountrysOptions().then(response =>{
            console.log('response is',response);
            let paser = JSON.parse(response);
            console.log('getCountrysOptions',paser);
            this.CountrysOptions2 = JSON.parse(response);
            this.CountrysOptions3= [...this.CountrysOptions1,...this.CountrysOptions2]
        }).catch(error =>{
            console.log('error is',error);
            this.isLoading1=false;
        })

        getOrderStatusData().then(response =>{
            console.log('response is',response);
            let paser = JSON.parse(response);
            console.log('getOrderStatusData',paser);
        }).catch(error =>{
            console.log('error is',error);
            this.isLoading1=false;
        })
        this.isLoading1 = false;
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


    get SearchByOptions(){
        return this.SearchByOptions1;
    }

    get noRecordsToDisplay(){
        return this.recordsToDisplay.length == 0;
    }


    get OrderStatusOptions(){
        return this.OrderStatusOptions1;
    }


    get CountryOptions(){
        return this.CountrysOptions3;
    }
    //Handlers for option changes
    handleOrderStatusOptionChange(event){
        this.OrderStatusvalue = event.target.value;
    }

    handleCountryOptionChange(event){
        this.CountryValue = event.target.value;

    }

    handleSearchOptionChange(event){
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

        if (this.SearchByvalue == 'PO#' || this.SearchByvalue == 'All Ship-To Locations' || this.SearchByvalue == 'Our Ship-To Locations Only'){
            this.PONumSelect = true;
            if(this.SearchByvalue == 'All Ship-To Locations' || this.SearchByvalue == 'Our Ship-To Locations Only'){
                this.locations = true;
            }
        }

        if (this.SearchByvalue == 'Invoice #'){
            this.InvoiceSelect = true;          
        }

        if (this.SearchByvalue == 'Containing ISBN'){
            this.ISBNselect = true;           
        }

        if (this.SearchByvalue == 'Order #'){
            this.DocumentNumSelect = true;       
        }

        if (this.SearchByvalue == 'Customer SAN'){
            this.SANSelect = true;       
        }

        if (this.SearchByvalue == 'Zip/Postal Code'){
            this.ZipSelect = true;      
        }

        if (this.SearchByvalue == 'State/Province'){
            this.StateSelect = true;      
        }

        if (this.SearchByvalue == 'Country'){
            this.CountrySelect = true;      
        }
    }

    handlePONumChange(event){
        this.PONum = event.target.value;
        // this.SearchDisabledReturn = false;
    }

    handleInvoNumChange(event){
        this.InvoNum = event.target.value
    }
    
    handleISBnNumChange(event){
        this.ISBnNum = event.target.value;
    }
    
    handleDocContrNumChange(event){
        this.DocContrNum = event.target.value;
    }

    handleZipNumChange(event){
        this.ZipNum = event.target.value;
    }

    handleStateNumChange(event){
        this.StateNum = event.target.value;
    }

    handleSANNumChange(event){
        this.SANNum = event.target.value;
    }

    handleCustNameChange(event){
        this.CustName = event.target.value;
    }

    handleStartDateChange(event){
        this.startDate = event.target.value;
    }

    handleEndDateChange(event){
        this.endDate = event.target.value;
    }

    handleCityNumChange(event){
        this.CityNum = event.target.value;
    }

    handleClearClick(){
        // this.subscribeMessage();
        this.showSearchResults = false;
        this.pageSize = this.pageSizeOptions[0];
        this.PONum='';
        this.InvoNum = '';
        this.ISBnNum = '';
        this.DocContrNum = '';
        this.ZipNum = '';
        this.StateNum = '';
        this.CityNum = '';
        this.SANNum = '';
        this.CustName = '';
        this.startDate = null;
        this.endDate = null;
        this.OrderStatusvalue = 'All';
        this.CountryValue = 'United States';
        this.SearchDisabledReturn = true;
    }

    get SearchDisabled(){
        if( (this.PONum != '' && this.SearchByvalue == 'PO#') ||  (this.InvoNum != '' && this.SearchByvalue == 'Invoice #') || (this.ISBnNum !='' && this.SearchByvalue == 'Containing ISBN') || (this.DocContrNum !='' && this.SearchByvalue == 'Order #') || (this.ZipNum !='' && this.SearchByvalue == 'Zip/Postal Code') || (this.CountryValue !='' && this.CustName !='') || (this.StateNum !='' && this.SearchByvalue == 'State/Province') ||(this.SANNum !='' && this.SearchByvalue == 'Customer SAN')
        || ((this.SearchByvalue == 'All Ship-To Locations' || this.SearchByvalue == 'Our Ship-To Locations Only') && (this.PONum != '' || this.ISBnNum !='' || (this.startDate !=null && this.endDate != null)))){
            console.log('this.SearchDisabledReturn ',this.SearchDisabledReturn );

            if(this.OrderStatusvalue='All' && (this.SearchByvalue == 'All Ship-To Locations' || this.SearchByvalue == 'Our Ship-To Locations Only') && (this.PONum == '' && this.ISBnNum =='' && (this.startDate ==null && this.endDate == null))){
                this.SearchDisabledReturn = true;
            }else{
                this.SearchDisabledReturn = false;
            }
            
        }else{
                this.SearchDisabledReturn = true; 
        }
        return this.SearchDisabledReturn;
    }


    //Method called when the action button is clicked in the Datatable
    handleRowAction(event){
        const actionname = event.detail.action.name
        console.log('event value is',event.detail);
        const row = event.detail.row;
        if(actionname == 'viewRecords'){
            this.orderDetailsSect = true;
            this.showOrderData = true;
        }  
        this.documentNumber = event.detail.row.SAP_Document_Number;
        this.getOrderSeatails();//changes for W-014208 US-49
        
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
    @track orderLineRecords=[];
    @track QtyClosed = 0;
    @track updatedStatusDate;
    @track deliveryInfo;
    getOrderSeatails(){
        this.isLoading1 = true;
        this.orderLineRecords=[];
        this.ShipToAccount='';
        this.ShipTo='';
                    getDetail({ documentNumber: this.documentNumber }) 
                    .then(({data, messages}) => { 
                        console.log('Sales Doc data is',data) ;
                        console.log(messages) ;
                        // this.orderLineRecords = [...data.ITEMS.asList];
                        // console.log('orderLineRecords are',this.orderLineRecords);
                        this.deliveryInfo = data;
                        this.orderNumber = data.SalesDocument;
                        this.CustomerPurchaseOrderNumber = data.CustomerPurchaseOrderNumber;
                        this.CustomerPurchaseOrderDate = data.CustomerPurchaseOrderDate;
                        this.OverallStatusDescription = data.STATUS.OverallStatusDescription;
                        this.CustomerPurchaseOrderType = data.ORDERDATA.CustomerPurchaseOrderType;
                        this.RequestedDeliveryDate = data.SALES.RequestedDeliveryDate;
                        for(let i=0;i<data.PARTNERS.asList.length;i++){
                            if(data.PARTNERS.asList[i].PartnerFunctionName =='Ship-to Party'){
                                this.ShipToAccount = data.PARTNERS.asList[i].PartnerNumber;
                                this.ShipTo = data.PARTNERS.asList[i].PartnerName +'|'+ data.PARTNERS.asList[i].Street+' '+ data.PARTNERS.asList[i].City+' '+data.PARTNERS.asList[i].PostalCode+' '+ data.PARTNERS.asList[i].Country; 
                            }
                        }

                        for(let i=0;i<data.ITEMS.asList.length;i++){
                            for(let j=0;j<data.ITEMS_SCHEDULE.asList.length;j++){
                                if(data.ITEMS.asList[i].SalesItem == data.ITEMS_SCHEDULE.asList[j].SalesItem){
                                    this.QtyClosed += data.ITEMS_SCHEDULE.asList[j].DeliveredQuantity;
                                }
                                if(data.ITEMS.asList[i].SalesItem == data.ITEMS_SCHEDULE.asList[j].SalesItem){
                                    if(data.ITEMS_SCHEDULE.asList[j].ScheduleLineDate > this.updatedStatusDate ){
                                        this.updatedStatusDate=data.ITEMS_SCHEDULE.asList[j].ScheduleLineDate;
                                    }else{
                                        this.updatedStatusDate=data.ITEMS_SCHEDULE.asList[j].ScheduleLineDate;
                                    }
                                }
                            }
                             this.orderLineRecords.push({
                                SalesItem:data.ITEMS.asList[i].SalesItem,
                                Material:data.ITEMS.asList[i].Material,
                                ItemDescription:data.ITEMS.asList[i].ItemDescription,
                                NetValueInDocumentCurrency:data.ITEMS.asList[i].NetValueInDocumentCurrency,
                                MaterialPricingGroupDescription:data.ITEMS.asList[i].MaterialPricingGroupDescription,
                                OrderQuantity:data.ITEMS.asList[i].OrderQuantity,
                                QtyClosed:this.QtyClosed,
                                TobeShipped:data.ITEMS.asList[i].OrderQuantity-this.QtyClosed,
                                Status:data.STATUS.OverallStatusDescription,
                                updatedStatusDate:this.updatedStatusDate

                            }) 
                        }

                    }) 
                    .catch(error => { 
                        this.isLoading1 = false;
                        console.log('error is',error);
                        // Catch any errors 
                    }) 
            setTimeout(()=>{
                this.isLoading1 = false;
            },2000);
        
    }
    //changes for W-014208 US-49 ends

    handleBackClick(){
        this.orderDetailsSect = false;
    }

    get recordsToDisplay(){
        return this.recordsToDisplay;
    }

    //handler for search button
    handleSearch(){
        this.isLoading1 = true;
        this.showSearchResults = true;
        console.log('this.PONum',this.PONum);
        console.log(typeof(this.PONum));
        console.log('this.startDate',this.startDate);
        console.log('this.endDate',this.endDate);
        console.log('this.DocContrNum',this.DocContrNum);
        console.log('this.SANNum',this.SANNum);
        
        if(this.OrderStatusvalue=='false'){
            this.OrderStatusvalue = 'All';
        }
        console.log('this.OrderStatusvalue',this.OrderStatusvalue);

       getCriteriaOrderdata({PO:this.PONum.trim(),ISBN:this.ISBnNum.trim(),startDate:this.startDate,endDate:this.endDate,orderStatus:this.OrderStatusvalue,
       OrderNum:this.DocContrNum.trim(),Zip:this.ZipNum.trim(),State:this.StateNum.trim(),City:this.CityNum.trim(),Country:this.CountryValue,CustNam:this.CustName.trim(),SAN:this.SANNum.trim(),Invo:this.InvoNum.trim(),SearchValue:this.SearchByvalue}).then(response =>{
            console.log('response is',response);
            let paser = JSON.parse(response);
            console.log('getCriteriaOrderdata',paser);
            this.data = JSON.parse(response);
            console.log('this.data ',this.data);
            this.records = this.data;
            this.pageSize = this.pageSizeOptions[0];
            this.totalRecords = this.data.length;
            this.paginationHelper(); // call helper menthod to update pagination logic 
            this.isLoading1 = false;
       }).catch(error =>{
            console.log('error is',error);
            this.isLoading1=false;
        })


        }

        handleOrderData(event){
            this.showOrderData = true;
            this.showShipmentData = false;
        }

        handleShipmentData(event){
            this.showShipmentData = true;
            this.showOrderData = false;
        }

        @track showDeliveryDetails = false;

        handleShipDetails(){
            this.showDeliveryDetails = true;
        }

        closeShowDeliveryDetails(){
            this.showDeliveryDetails = false;
        }

}