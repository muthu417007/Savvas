/*
Lightning Web component: scc_deliveryInfoLWC
Author: CTS (Suresh Kalshetti)
Created Date: 19/04/2024
Reason: Delivery Information of Order (A5)
Modified Date: 29/04/2024
*/
import { LightningElement,track,api } from 'lwc';
import getDelivery from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getDelivery' ;
import getInvoice from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getInvoice' ;
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;
import getSign from '@salesforce/apex/scc_orderDetail_Controller.getSign';
import getShipperLink from '@salesforce/apex/scc_orderDetail_Controller.getShipperLink';
import scc_OrderDetail_Requested_Shipment_Date_tooltip from "@salesforce/label/c.scc_OrderDetail_Requested_Shipment_Date_tooltip";
import scc_delivery_Carrier_Name from "@salesforce/label/c.scc_delivery_Carrier_Name";
import scc_delivery_Delivery_Date from "@salesforce/label/c.scc_delivery_Delivery_Date";
import scc_delivery_Status from "@salesforce/label/c.scc_delivery_Status";
import scc_delivery_Parcel_Qty from "@salesforce/label/c.scc_delivery_Parcel_Qty";
import scc_delivery_Parcel_Weight from "@salesforce/label/c.scc_delivery_Parcel_Weight";
import scc_delivery_Signature from "@salesforce/label/c.scc_delivery_Signature";
import scc_delivery_Parcel_ID from "@salesforce/label/c.scc_delivery_Parcel_ID";
import scc_delivery_Tracking_Number from "@salesforce/label/c.scc_delivery_Tracking_Number";
import scc_OrderStatus_Ship_To_Account from "@salesforce/label/c.scc_OrderStatus_Ship_To_Account";
import scc_OrderStatus_Requested_Shipment_Date from "@salesforce/label/c.scc_OrderStatus_Requested_Shipment_Date";
import scc_OrderDetail_Ship_To from "@salesforce/label/c.scc_OrderDetail_Ship_To";
import scc_OrderDetail_Order_Method from "@salesforce/label/c.scc_OrderDetail_Order_Method";
import scc_home_PO from "@salesforce/label/c.scc_home_PO";
import scc_home_Status from "@salesforce/label/c.scc_home_Status";
import scc_home_Document_Control from "@salesforce/label/c.scc_home_Document_Control";
import scc_home_Order_Date from "@salesforce/label/c.scc_home_Order_Date";
import scc_delivery_Delivery_Info from "@salesforce/label/c.scc_delivery_Delivery_Info";
import scc_delivery_DocumentCategoryText from "@salesforce/label/c.scc_delivery_DocumentCategoryText";
import scc_document_not_found_errormsg from "@salesforce/label/c.scc_document_not_found_errormsg";
import scc_OrderDetail_Filfilment_Progress_Note from "@salesforce/label/c.scc_OrderDetail_Filfilment_Progress_Note";
import scc_orderDetail_shippingMethod from "@salesforce/label/c.scc_orderDetail_shippingMethod";
import imageIcons from '@salesforce/resourceUrl/scc_Images'; 
import generateRADARRequest from '@salesforce/apex/scc_documents_RADAR_Controller.generateRADARRequest';
import getThirdPartyTrack from '@salesforce/apex/scc_orderDetail_Controller.getThirdPartyTrack';
import {viewAndDownloadPdf} from 'c/scc_exportRADAR_PdfLWC';
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';

export default class Scc_deliveryInfoLWC extends LightningElement {
    @track data;
    @track documentNumber;
    @api getDeliverydata; // Calling order data from Order status page    
    @track dataReceived;
    @track deliveryNumber = '';
    @track displayDeliveryRecords = [];
    @track displayDeliveryRecordsData;
    @track displayDeliveryTitles = [];
    @track isLoading2 = false;
    @track trackingId;
    @track showFedexTrackingInfo = false;
    @track displayNonFedEx = false;
    @track showFedEx = false;
    @track showFedExThirdParty = false;
    @track displayNonFedExThirdParty = false;
    @track carrierName = '';
    @api orderLineRecords;
    @api invoiceInfo;
    orderNumber;
    CustomerPurchaseOrderNumber;
    CustomerPurchaseOrderDate;
    OverallStatusDescription;
    CustomerPurchaseOrderType;
    RequestedDeliveryDate;
    ShipToAccount;
    ShipTo;
    showPacakegeDetails = false;
    showFedExCarrier = false;
    @track titles = [];
    @track invoiceItemsData;
    @track displayPackageContent = [];
    @track tracking;
    @track parcel;
    @track totalParcelWeight = 0;
    @track totalShippedUnits = 0;
    @track parcelStatus;
    @track signature = '';
    @track datedelivery = '';
    @track shipLink = '';
    @track showModel = false;
    @track showthirdParty = false;
    @track thirdParty;
    @track tracklist = [];
    pageSizeOptions = [15, 30, 45, 60];
    alertIcon = imageIcons + '/Images/alert.png';
    sortIcon = imageIcons + '/Images/sort.png';
    pageSize
    pageNumber = 1;
    totalPages
    recordsToDisplay = [];
    totalRecords
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog = '';
    @track internalStatus = '';
    @track orderLineRecordsMap;
    @track deleiveryHUMap;
    @track deliveryHuItemsMap;
    @track deliveryItmsMap;
    @track deliveryItmsMap1;
    @track orderLineRecordsMap1;
    @track enableLogs = false;
    @api shippingStreet;
    @api shippingCity;
    @api shippingState;
    @api shippingPostalCode;
    @api ShipToAccount;
    @api shipToAccName1;
    @track docNotFound = false;
    @track selectedSortField = '';
    @track sortDirection = '';
    @track sortedBy = '';
    @track isSorted = false;
    @track shipclick = false;
    @track gotShipLink = false;
    @track displayLink = false;
    @track base64String;
    @track extHUIdArray=[];
    @track shippingMethod;
    @track thirdPartyCarrier = [];
    @track sortOptions = [{
            label: 'ISBN',
            value: 'ISBN'
        },
        {
            label: 'Title',
            value: 'Title'
        },
        {
            label: 'PO#',
            value: 'CustomerPurchaseOrderNumber'
        },
        {
            label: 'Price',
            value: 'Price'
        },
        {
            label: 'Pricing Method',
            value: 'PricingMethod'
        },
        {
            label: 'Discount',
            value: 'Discount'
        },
        {
            label: 'Qty Ordered',
            value: 'QtyOrdered'
        },
        {
            label: 'Qty Shipped',
            value: 'QtyShipped'
        }
    ];

    //Importing labels for the data table
    labels = {
        scc_OrderDetail_Requested_Shipment_Date_tooltip,
        scc_delivery_Carrier_Name,
        scc_delivery_Delivery_Date,
        scc_delivery_Status,
        scc_delivery_Parcel_Qty,
        scc_delivery_Parcel_Weight,
        scc_delivery_Signature,
        scc_delivery_Parcel_ID,
        scc_delivery_Tracking_Number,
        scc_OrderStatus_Ship_To_Account,
        scc_OrderStatus_Requested_Shipment_Date,
        scc_OrderDetail_Ship_To,
        scc_OrderDetail_Order_Method,
        scc_home_PO,
        scc_home_Status,
        scc_home_Document_Control,
        scc_home_Order_Date,
        scc_delivery_Delivery_Info,
        scc_delivery_DocumentCategoryText,
        scc_document_not_found_errormsg,
        scc_OrderDetail_Filfilment_Progress_Note,
        scc_orderDetail_shippingMethod
    }

    constructor() {
        super();
    }

    // Calling Order data from Order Status page and mapping it for header order details
    connectedCallback() {
        this.docNotFound = false;
        this.isLoading2 = true;
        this.dataReceived = this.getDeliverydata;
        this.deliverDataMap();
        this.deliveryNumber = this.invoiceInfo.deliveryNumber;
        this.invoiceNumber = this.invoiceInfo.invoiceNumber;
        this.getInvoiceCallData();
        this.isLoading2 = false;
        this.template.addEventListener('keydown', this.handleKeydown.bind(this));

        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if(this.enableLogs) {
                console.log('getEnableConsoleLogsTrue response is', response);
                console.log('orderLineRecords', this.orderLineRecords);
                console.log('invoiceInfo', this.invoiceInfo);
                console.log('this.getDeliverydata', this.getDeliverydata);
            }
        }).catch(error => {
            if(this.enableLogs) {
                console.log('error is', error);
            }
        })
    }

    disconnectedCallback() {
        // Remove the keydown event listener when the component is removed from the DOM
        this.template.removeEventListener('keydown', this.handleKeydown);
    }

    //close popup when user press escape key -accessibility
    handleKeydown(event) {
        // Handle the keydown event
        if(event.key === 'Escape') {
            if(this.showModel) {
                this.closeModal();
            }
        }
    }

    get displayDeliveryRecords() {
        return this.displayDeliveryRecords;
    }

    get titles1() {
        return this.titles
    }

    get displayPackageContent1() {
        return this.displayPackageContent;
    }

    getInvoiceCallData() {
        getInvoice({
                documentNumber: this.invoiceNumber
            })
            .then(({
                data,
                messages
            }) => {
                this.responseBody = JSON.stringify(data);
                this.invoiceItemsData = data;
                if(this.enableLogs) {
                    console.log('this.invoiceItemsData', this.invoiceItemsData);
                }
                this.logType = 'Enosix Invoice Doc';
                this.requestBody = this.invoiceNumber;
                this.statusLog = 'Success';
                this.internalStatus = '';
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_deliveryInfoLWC/getInvoiceCallData/getInvoice');

            })
            .catch(error => {
                if(this.enableLogs) {
                    console.log('error is', error);
                }
                this.logType = 'Enosix Invoice Doc';
                this.requestBody = this.invoiceNumber;
                this.statusLog = 'Error';
                this.internalStatus = JSON.stringify(error);
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_deliveryInfoLWC/getInvoiceCallData/getInvoice');
            })
            .finally(() => {
                this.getDeliveryInfo();
            })
    }


    formatDate(date) {
        const [year, month, day] = date.split('-');
        return `${month}/${day}/${year}`;
    }


    formatDeliveryDate(dateString) {
        if(!dateString) return '';
        const date = new Date(dateString);
        const month = String(date.getUTCMonth() + 1).padStart(2, '0'); // Months are zero-based
        const day = String(date.getUTCDate()).padStart(2, '0');
        const year = date.getUTCFullYear();
        return `${month}/${day}/${year}`;
    }


    //Calling Delivery Class from Enosix and mapping data for Delivery information table
    getDeliveryInfo() {
        this.extHUIdArray =[];
        this.displayDeliveryRecords = [];
        this.displayDeliveryTitles = [];
        if(this.deliveryNumber) {
            getDelivery({
                    documentNumber: this.deliveryNumber
                })
                .then(({
                    data,
                    messages
                }) => {
                    if(this.enableLogs) {
                        console.log('Delivery Data is', data);
                    }
                    this.responseBody = JSON.stringify(data);
                    this.displayDeliveryRecordsData = data;
                    this.carrierName = this.displayDeliveryRecordsData.CarrierName;
                    for(let i = 0; i < this.displayDeliveryRecordsData.HU.asList.length; i++) {
                        this.extHUIdArray.push(this.displayDeliveryRecordsData.HU.asList[i].ExtHUID);
                        this.displayDeliveryRecords.push({
                            ExtHUID: this.displayDeliveryRecordsData.HU.asList[i].ExtHUID,
                            SalesItem1: 'NA',
                            ParcelID: '',
                            GrossWeight: this.displayDeliveryRecordsData.HU.asList[i].GrossWeight.toFixed(2),
                            Status: 'Shipped',
                            DeliveryDate: this.datedelivery,
                            Signature: this.signature,
                            ParcelQty: 0,
                            IntHUNumber: parseInt(this.displayDeliveryRecordsData.HU.asList[i].IntHUNumber),
                            DeliveryItem: '',
                            carrierName: this.carrierName                            
                        })
                    }
                    if(this.carrierName) {
                      // this.getCarrierLink();
                       this.getCarrier();
                    }
                    this.logType = 'Enosix Delivery Doc';
                    this.requestBody = this.deliveryNumber;
                    this.statusLog = 'Success';
                    this.internalStatus = '';
                    this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_deliveryInfoLWC/getDeliveryInfo/getDelivery');
                })
                .catch(error => {
                    if(this.enableLogs) {
                        console.log('error is', error);
                    }
                    this.logType = 'Enosix Delivery Doc';
                    this.requestBody = this.deliveryNumber;
                    this.statusLog = 'Error';
                    this.internalStatus = JSON.stringify(error);
                    this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_deliveryInfoLWC/getDeliveryInfo/getDelivery');
                })
                .finally(() => {
                    this.getHUItemsInformation();
                    this.getTitleInformation();
                    this.getSignInformation();
                });
        } else {
            this.getTitleInformation();
            this.getCarrierLink();
        }
    }


    formatPrice(price) {
        if(typeof price == 'string') {
            price = price ? parseFloat(price).toFixed(2) : price;
        }
        if(typeof price === 'number') {
            let formattedPrice = price.toFixed(2);
            formattedPrice = formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            return formattedPrice;
        } else {
            return price;
        }
    }

    getTitleInformation() {
        this.titles = [];
        this.orderLineRecordsMap = new Map(this.orderLineRecords.map(item => [item.SalesItem, item]));
        let invoiceItemsData1 = this.invoiceItemsData.ITEMS.asList;
        const invoiceItemsDataMap1 = new Map(invoiceItemsData1.map(item => [item.ItemNumber, item]));
        if(this.deliveryNumber) {
            this.displayDeliveryRecordsData = JSON.parse(JSON.stringify(this.displayDeliveryRecordsData));
            const ditmp1 = this.displayDeliveryRecordsData.ITEMS.asList;
            this.deliveryItmsMap = new Map(ditmp1.map(item => [item.DeliveryItem, item]));
            for(let i = 0; i < this.displayDeliveryRecordsData.HU_ITEMS.asList.length; i++) {
                let SalesOrderItem = this.deliveryItmsMap.get(this.displayDeliveryRecordsData.HU_ITEMS.asList[i].DeliveryItem).SalesOrderItem;
                this.titles.push({
                    ISBN: this.orderLineRecordsMap.get(SalesOrderItem).Material,
                    Title: this.orderLineRecordsMap.get(SalesOrderItem).ItemDescription,
                    Price: this.orderLineRecordsMap.get(SalesOrderItem).NetValueInDocumentCurrency,
                    PricingMethod: this.orderLineRecordsMap.get(SalesOrderItem).MaterialPricingGroupDescription,
                    Discount: this.orderLineRecordsMap.get(SalesOrderItem).Discount,
                    QtyOrdered: this.orderLineRecordsMap.get(SalesOrderItem).OrderQuantity,
                    QtyShipped: this.displayDeliveryRecordsData.HU_ITEMS.asList[i].HUItemQuantity,
                    ParcelID: this.orderLineRecordsMap.get(SalesOrderItem).ParcelID,
                    intHunumber: parseInt(this.displayDeliveryRecordsData.HU_ITEMS.asList[i].IntHUNumber)
                })
            }
        } else {
            for(let i = 0; i < this.invoiceItemsData.ITEMS.asList.length; i++) {
                let SalesOrderItem1 = this.invoiceItemsData.ITEMS.asList[i].ItemNumber;
                this.titles.push({
                    ISBN: this.orderLineRecordsMap.get(SalesOrderItem1).Material,
                    Title: this.orderLineRecordsMap.get(SalesOrderItem1).ItemDescription,
                    Price: this.orderLineRecordsMap.get(SalesOrderItem1).NetValueInDocumentCurrency,
                    PricingMethod: this.orderLineRecordsMap.get(SalesOrderItem1).MaterialPricingGroupDescription,
                    Discount: this.orderLineRecordsMap.get(SalesOrderItem1).Discount,
                    QtyOrdered: this.orderLineRecordsMap.get(SalesOrderItem1).OrderQuantity,
                    QtyShipped: '',
                    ParcelID: '',
                    intHunumber: '',
                })
            }
        }
        this.records = this.titles;
        this.pageSize = this.pageSizeOptions[0];
        this.totalRecords = this.titles.length;
        this.paginationHelper(); // call helper menthod to update pagination logic  
    }

    getHUItemsInformation() {
        const ditmp2 = this.displayDeliveryRecordsData.ITEMS.asList;
        this.deliveryItmsMap1 = new Map(ditmp2.map(item => [item.DeliveryItem, item]));
        this.orderLineRecordsMap1 = new Map(this.orderLineRecords.map(item => [item.SalesItem, item]));

        for(let i = 0; i < this.displayDeliveryRecordsData.HU_ITEMS.asList.length; i++) {
            let SalesOrderItem = this.deliveryItmsMap1.get(this.displayDeliveryRecordsData.HU_ITEMS.asList[i].DeliveryItem).SalesOrderItem;
            for(let j = 0; j < this.displayDeliveryRecords.length; j++) {
                if(parseInt(this.displayDeliveryRecords[j].IntHUNumber) == parseInt(this.displayDeliveryRecordsData.HU_ITEMS.asList[i].IntHUNumber)) {
                    this.displayDeliveryRecords[j].ParcelID = this.orderLineRecordsMap1.get(SalesOrderItem).ParcelID;
                    this.displayDeliveryRecords[j].ParcelQty += this.displayDeliveryRecordsData.HU_ITEMS.asList[i].HUItemQuantity;
                }
            }
        }
    }

    getSignInformation(){
        getSign({
                trackId: this.extHUIdArray
            })
            .then(data => {
                if(this.enableLogs){
                    console.log('getsign data is',data);
                }
                let extIDMap = new Map(data.map(item => [item.Tracking_Number__c, item]));
                if(this.enableLogs){
                    console.log('this.displayDeliveryRecords',this.displayDeliveryRecords);
                    console.log('extIDMap',extIDMap);  
                }                  
                for(let i = 0; i < this.displayDeliveryRecords.length; i++) {
                    let Ident = this.displayDeliveryRecords[i].ExtHUID;
                    if(extIDMap.get(Ident)){
                        this.signature = extIDMap.get(Ident).Signature__c;
                        this.datedelivery = extIDMap.get(Ident).Delivery_Date__c;
                        this.displayDeliveryRecords[i].Signature = this.signature;
                        this.displayDeliveryRecords[i].DeliveryDate = this.formatDeliveryDate(this.datedelivery);
                        if(this.signature) {
                            this.displayDeliveryRecords[i].Status = 'Delivered';
                        } else {
                            this.displayDeliveryRecords[i].Status = 'Shipped';
                        }                                
                    }
                }
            })
            .catch(error => {
                console.log('error is', error);
            })
    }

    // Data mapping for Order Detail on Delivery information page.
    deliverDataMap() {
        this.orderNumber = this.getDeliverydata[0].orderNumber;
        this.CustomerPurchaseOrderNumber = this.getDeliverydata[0].CustomerPurchaseOrderNumber;
        this.CustomerPurchaseOrderDate = this.getDeliverydata[0].CustomerPurchaseOrderDate;
        this.OverallStatusDescription = this.getDeliverydata[0].OverallStatusDescription;
        this.CustomerPurchaseOrderType = this.getDeliverydata[0].CustomerPurchaseOrderType;
        this.RequestedDeliveryDate = this.getDeliverydata[0].RequestedDeliveryDate;
        this.ShipToAccount = this.getDeliverydata[0].ShipToAccount;
        this.ShipTo = this.getDeliverydata[0].ShipTo;
        this.shippingMethod = this.getDeliverydata[0].shippingMethod;
    }

    handleShipQtyClick() {
        this.shipclick = true;
        let eve = {
            target: {
                dataset: {
                    id: 'tab-default-2__item'
                }
            }
        };
        this.handleActive(eve);
    }

    handleShipDetails(event) {
        event.preventDefault();
        this.trackingId = event.target.dataset.name;
        this.orderNumber = this.getDeliverydata[0].orderNumber;
        if(this.showFedEx) {
            this.showFedexTrackingInfo = true;
            setTimeout(() => {
                if(this.template.querySelector('.fedexDetailPageCloseBtn')) {
                    this.template.querySelector('.fedexDetailPageCloseBtn').focus();
                }
            }, 100);
        } else if(this.showFedExThirdParty) {
            this.showFedexTrackingInfo = true;
            setTimeout(() => {
                if(this.template.querySelector('.fedexDetailPageCloseBtn')) {
                    this.template.querySelector('.fedexDetailPageCloseBtn').focus();
                }
            }, 100);
        }

        this.closeModal();
    }

    handleShipNonFedEx(event) {
        if(this.shipLink){
            let shippingLink = this.shipLink+event.target.dataset.name;
            window.open(shippingLink);
        }
    }

    getCarrierLink() {
        
        getThirdPartyTrack({
                invoicenumber: this.invoiceNumber
            })
            .then(data => {
                if(this.enableLogs){
                    console.log('data of thirdparty', data);
                }
                if(data != '' && data != null) {
                    for(let j = 0; j < data.length; j++) {
                        if(data[j].ThirdParty_Tracking_Number__c) {
                           // this.carrierName += data[j].carrier_name__c;
                           this.thirdPartyCarrier.push(this.getCarrierCode(data[j].carrier_name__c));
                           // this.thirdParty = data[j].ThirdParty_Tracking_Number__c;
                            //this.tracklist = this.thirdParty.split(',').map(number => number.trim());
                            this.showthirdParty = true;
                            this.showFedEx = false;
                            this.displayNonFedEx = false;
                            this.showFedExThirdParty = false;
                            this.displayNonFedExThirdParty = false;
                        } else {
                           //this.getCarrier();
                        }

                        let status ='Shipped';
                        if(data[j].Signature__c){
                            status ='Delivered';
                        }else{
                            status = 'Shipped';
                        }
                        let carrierCode = this.getCarrierCode(data[j].carrier_name__c);

                        
                        this.displayDeliveryRecords.push({
                            ExtHUID: data[j].ThirdParty_Tracking_Number__c,
                            SalesItem1: 'NA',
                            ParcelID: data[j].Parcel_ID_Number__c,
                            GrossWeight: '',
                            Status: status,
                            DeliveryDate: this.formatDeliveryDate(data[j].Delivery_Date__c),
                            Signature: data[j].Signature__c,
                            ParcelQty: '',
                            IntHUNumber: '',
                            DeliveryItem: '',
                            carrierName:'',
                            carrierCode:carrierCode,
                            shipperLink:'',
                            showFedExThirdParty:false,
                            displayNonFedExThirdParty:false,
                            trackList:data[j].ThirdParty_Tracking_Number__c,
                            gotThirdShipLink:false
                        })                     
                    }
                    this.invoiceInfo.cartons = data.length;
                    this.getShipperLinkThirdParty();
                } else {
                    //this.getCarrier();
                }
            })
            .catch(error => {
                console.log('error is', error);
            })
    }

    getCarrierCode(carrierCode) {
        if(parseInt(carrierCode)){
            carrierCode = parseInt(carrierCode);
            carrierCode = carrierCode.toString();
        }else{
            carrierCode = carrierCode;
        }
        return carrierCode;
    }

    getShipperLinkThirdParty() {
     //for(let i = 0; i < this.tracklist.length; i++) {
            //this.trackingId = this.tracklist[i];
            getShipperLink({
                  //  trackingId: this.tracklist[i],
                    trackingId:'',
                    shipperName: this.carrierName,
                    isThirdParty:true,
                    thirdPartyCarrier: this.thirdPartyCarrier
                })
                .then(data => {
                    if(data) {
                        if(this.enableLogs){
                            console.log('link data',data);
                        }         
                        let shipperLinkMap = new Map(data.map(item => [item.ShipperCode__c, item]));     
                        if(this.enableLogs){ 
                            console.log('shipperLinkMap',shipperLinkMap); 
                        }       
                        for(let j = 0; j < this.displayDeliveryRecords.length; j++) {  
                            let cc = this.displayDeliveryRecords[j].carrierCode;                          
                            if(shipperLinkMap.get(cc)) {
                                if(shipperLinkMap.get(cc).ShipperLink__c){
                                    this.displayDeliveryRecords[j].shipperLink = shipperLinkMap.get(cc).ShipperLink__c;
                                    this.displayDeliveryRecords[j].gotThirdShipLink = true;
                                }else{
                                    this.displayDeliveryRecords[j].gotThirdShipLink = false;
                                }
                                this.displayDeliveryRecords[j].carrierName = shipperLinkMap.get(cc).ShipperName__c;
                                if(shipperLinkMap.get(cc).ShipperName__c.toUpperCase().includes('FED')) {
                                    this.displayDeliveryRecords[j].showFedExThirdParty = true;
                                }else{
                                    this.displayDeliveryRecords[j].displayNonFedExThirdParty = true;
                                } 
                            }
                        }

                        if(this.enableLogs){ 
                            console.log('this.displayDeliveryRecords',this.displayDeliveryRecords); 
                        } 
                    }
                })
                .catch(error => {
                    console.log('error is', error);
                })
        //}
    }

    getCarrier() {
        this.displayNonFedEx = true;
        this.thirdPartyCarrier = [];
        //for(let i = 0; i < this.displayDeliveryRecordsData.HU.asList.length; i++) {
          //  this.trackingId = this.displayDeliveryRecordsData.HU.asList[i].ExtHUID;
            getShipperLink({
                  //  trackingId: this.displayDeliveryRecordsData.HU.asList[i].ExtHUID,
                    trackingId:'',
                    shipperName: this.carrierName,
                    isThirdParty:false,
                    thirdPartyCarrier:this.thirdPartyCarrier
                })
                .then(data => {
                    if(data) {
                        if(this.enableLogs){
                            console.log('link data', data);
                        }
                        if(data.length >0){
                            this.gotShipLink = true;
                        }else{
                            this.gotShipLink = false;
                        }                        
                        for(let j = 0; j < data.length; j++) {
                            if(data[j].ShipperCode__c == 'FED') {
                                this.showFedEx = true;
                                this.displayNonFedEx = false;
                            } else if(data[j].ShipperCode__c == 'POE') {
                                this.displayNonFedEx = true;
                                this.shipLink = data[j].ShipperLink__c;
                            } else {
                                this.displayNonFedEx = true;
                               // this.shipLink = data[j].ShipperLink__c + this.displayDeliveryRecordsData.HU.asList[i].ExtHUID;
                               this.shipLink = data[j].ShipperLink__c;
                            }

                        }
                    }else{
                        this.gotShipLink = false;
                    }
                })
                .catch(error => {
                    console.log('error is', error);
                })
       // }
    }

    get showFedExThirdParty(){
        return this.showFedExThirdParty;
    }



    handletrackdetails1(event) {
        this.shipLink = event.target.dataset.shipperlink;
        this.displayLink = event.target.dataset.link;
        this.thirdParty = event.target.dataset.thirdparty1;
        this.tracklist = this.thirdParty.split(',').map(number => number.trim());
        this.showFedExThirdParty = true;
        this.displayNonFedExThirdParty = false;
        this.modalOpen();
    }

    handletrackdetails2(event) {
        this.shipLink = event.target.dataset.shipperlink;
        this.displayLink = event.target.dataset.link;
        this.thirdParty = event.target.dataset.thirdparty1;
        this.tracklist = this.thirdParty.split(',').map(number => number.trim());        
        this.showFedExThirdParty = false;
        this.displayNonFedExThirdParty = true;
        this.modalOpen();
    }

    modalOpen(){
        this.showModel = true;
        setTimeout(() => {
            this.template.querySelector('.guestOrderStatusClose').focus();
        }, 100);
    }

    closeModal() {
        this.showModel = false;
        this.showFedExThirdParty = false;
        this.displayNonFedExThirdParty = false;
        setTimeout(() => {
            if(this.template.querySelectorAll('.fedexTrackNum')[0]) {
                this.template.querySelectorAll('.fedexTrackNum')[0].focus();
            }
        }, 100);
    }

    focusOutClose() {
        if(this.template.querySelector('.fedextrackingNum')) {
            this.template.querySelector('.fedextrackingNum').focus();
        }
    }

    focusOutButton(event) {
        var related = event.relatedTarget;
        if(related != undefined) {
            if(!related.classList.contains('fedextrackingNum')) {
                if(this.template.querySelector('.guestOrderStatusClose')) {
                    this.template.querySelector('.guestOrderStatusClose').focus();
                }
            }
        }
    }

    handleInvoice() {
        this.docNotFound = false;
        const requestData = {
            documentNumber: this.invoiceNumber,
            opeartion: 'Invoice',
            emailId: '',
            Combined: 'N',
            IncludePOD: 'N',
            accountNumber: '',
            month: '',
            year: ''
        }
        generateRADARRequest({
                requestData: requestData
            }).then(data => {
                if(this.enableLogs){
                    console.log('data', data);
                }
                this.base64String = JSON.parse(data);
            })
            .catch(error => {
                console.log('error', error);
            }).finally(() => {
                if(this.base64String != '' && this.base64String != null) {
                    let valRetn = viewAndDownloadPdf(this.base64String);
                } else {
                    this.docNotFound = true;
                }
            });
    }


    handleParcelDetails(event) {
        const intHunumber = event.target.dataset.inthunumber;
        this.tracking = '';
        this.parcel = '';
        this.parcelStatus = '';
        this.showPacakegeDetails = true;
        this.tracking = event.target.dataset.tracking;
        this.parcel = event.target.dataset.parcel;
        this.parcelStatus = event.target.dataset.status;
        this.getPackageContents(intHunumber);
    }


    getPackageContents(value) {
        this.displayPackageContent = [];
        this.totalParcelWeight = 0;
        this.totalShippedUnits = 0;
        this.displayDeliveryRecordsData = JSON.parse(JSON.stringify(this.displayDeliveryRecordsData));
        this.orderLineRecordsMap = new Map(this.orderLineRecords.map(item => [item.SalesItem, item]));
        const ditmp = this.displayDeliveryRecordsData.ITEMS.asList;
        this.deliveryItmsMap = new Map(ditmp.map(item => [item.DeliveryItem, item]));
        const invoiceItemsData = this.invoiceItemsData.ITEMS.asList;
        const invoiceItemsDataMap = new Map(invoiceItemsData.map(item => [item.ItemNumber, item]));

        for(let i = 0; i < this.displayDeliveryRecordsData.HU_ITEMS.asList.length; i++) {
            if(this.displayDeliveryRecordsData.HU_ITEMS.asList[i].IntHUNumber === value) {
                let SalesOrderItem = this.deliveryItmsMap.get(this.displayDeliveryRecordsData.HU_ITEMS.asList[i].DeliveryItem).SalesOrderItem;
                this.totalParcelWeight += parseFloat((this.orderLineRecordsMap.get(SalesOrderItem).weight));
                this.totalParcelWeight = this.totalParcelWeight;
                this.totalShippedUnits += this.displayDeliveryRecordsData.HU_ITEMS.asList[i].HUItemQuantity;
                this.displayPackageContent.push({
                    ISBN: this.orderLineRecordsMap.get(SalesOrderItem).Material,
                    Title: this.orderLineRecordsMap.get(SalesOrderItem).ItemDescription,
                    OrderQuantity: this.orderLineRecordsMap.get(SalesOrderItem).OrderQuantity,
                    QtyShipped: '',
                    TobeShipped: '',
                    GrossWeight: (this.orderLineRecordsMap.get(SalesOrderItem).weight / this.displayDeliveryRecordsData.HU_ITEMS.asList[i].HUItemQuantity).toFixed(2),
                    ParcelQty: this.displayDeliveryRecordsData.HU_ITEMS.asList[i].HUItemQuantity,
                    SalesItem: this.displayDeliveryRecordsData.HU_ITEMS.asList[i].HUItem,
                    InvoiceQty: invoiceItemsDataMap.get(SalesOrderItem).ActualInvoicedQuantity,
                    ExtWeight: this.orderLineRecordsMap.get(SalesOrderItem).weight
                });
            }
        }

        this.records = this.displayPackageContent;
        this.pageSize = this.pageSizeOptions[0];
        this.totalRecords = this.displayPackageContent.length;
        this.paginationHelper(); // call helper menthod to update pagination logic  
    }




    closeParcelDetails() {
        this.shipclick = true;
        this.showPacakegeDetails = false;
        setTimeout(() => {
            let eve = {
                target: {
                    dataset: {
                        id: 'tab-default-2__item'
                    }
                }
            };
            this.handleActive(eve);
        }, 50);
        this.records = this.titles;
        this.pageSize = this.pageSizeOptions[0];
        this.totalRecords = this.titles.length;
        this.paginationHelper(); // call helper menthod to update pagination logic  
    }


    closeFedexTrackingInfo() {
        this.showFedexTrackingInfo = false;
    }


    closeShowDeliveryDetails(event) {
        this.dispatchEvent(new CustomEvent('closeshipdetails'));
    }


    handleActive(event) {
        if(this.shipclick == false) {
            event.preventDefault();
        }
        this.template.querySelectorAll('.slds-tabs_default__item').forEach((ele) => {
            if(ele.classList.contains('slds-is-active')) {
                ele.classList.remove('slds-is-active');
                ele.setAttribute('aria-selected', 'false');
                ele.tabindex = -1;
            }
            if(event.target.dataset.id == ele.dataset.id) {
                ele.classList.add('slds-is-active');
                ele.setAttribute('aria-selected', 'true');
                ele.tabindex = "0";
            }

        })
        this.template.querySelectorAll("[data-name=tabpanel]").forEach((ele) => {
            if(event.target.dataset.id == ele.dataset.id) {
                if(!ele.classList.contains("slds-show")) {
                    ele.classList.remove("slds-hide");
                    ele.classList.add("slds-show");
                }
            } else if(ele.classList.contains("slds-show")) {
                ele.classList.remove("slds-show");
                ele.classList.add("slds-hide");
            }
        })
        this.shipclick = false;
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
        if(this.totalPages <= 1) {
            this.totalPages = 1;
        }


        if(this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if(this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }


        // set records to display on current page
        for(let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if(i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.records[i]);
        }
    }

    //Button getters
    get bDisableFirst() {
        return this.pageNumber == 1;
    }


    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }


    get recordsToDisplay1() {
        return this.recordsToDisplay;
    }

    handleSortFieldChange(event) {
        this.selectedSortField = event.target.value;
        // Reset sort direction and isSorted flag when a new field is selected
        this.sortDirection = '';
        this.isSorted = false;
    }

    handleSortClick(event) {
        event.preventDefault();
        if(this.selectedSortField) {
            if(!this.isSorted) {
                // First click after selecting a field, sort ascending
                this.sortDirection = 'asc';
                this.isSorted = true;
            } else {
                // Subsequent clicks, toggle sort direction
                this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
            }
            this.sortedBy = this.selectedSortField;
            this.sortData(this.sortedBy, this.sortDirection);
            this.paginationHelper();
        }
    }

    sortData(fieldName, direction) {
        if(!direction) {
            // If no direction is specified, return the original unsorted data
            return;
        }

        let parseData = JSON.parse(JSON.stringify(this.records));
        let isReverse = direction === 'asc' ? 1 : -1;

        parseData.sort((x, y) => {
            // Handle potential null or undefined values
            let a = ((x && x[fieldName]) || '').toString().toLowerCase();
            let b = ((y && y[fieldName]) || '').toString().toLowerCase();

            // Check if the field is numeric (Price, Discount, QtyOrdered, QtyShipped)
            if(['Price', 'Discount', 'QtyOrdered', 'QtyShipped'].includes(fieldName)) {
                return isReverse * (Number(a) - Number(b));
            }

            // For other fields, use alphanumeric sorting
            let aParts = a.match(/([a-z]+)|(\d+)/gi) || [];
            let bParts = b.match(/([a-z]+)|(\d+)/gi) || [];

            // Compare each part
            for(let i = 0; i < Math.min(aParts.length, bParts.length); i++) {
                if(aParts[i] !== bParts[i]) {
                    // If both parts are numeric, compare as numbers
                    if(!isNaN(aParts[i]) && !isNaN(bParts[i])) {
                        return isReverse * (Number(aParts[i]) - Number(bParts[i]));
                    }
                    // Otherwise, compare as strings
                    return isReverse * (aParts[i] > bParts[i] ? 1 : -1);
                }
            }
            // If all parts are the same up to this point, compare lengths
            return isReverse * (aParts.length - bParts.length);
        });

        this.records = parseData;
    }

    createLogs(logType, requestBody, responseBody, statusLog, internalStatus, entryPoint) {
        createIntegrationLogsLWC1({
                logType: logType,
                requestBody: requestBody,
                responseBody: responseBody,
                status: statusLog,
                internalStatus: internalStatus,
                entryPoint: entryPoint
            })
            .then(result => {

            })
            .catch(error => {
                console.log('error is', error);
            })
    }

}