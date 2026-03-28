import { LightningElement, track, wire, api } from 'lwc';
//Importing Apex classes
import getDocSearchByOptions from '@salesforce/apex/scc_documentSearchLWC_Controller.getDocSearchByOptions';
import getCriteriaDocdata from '@salesforce/apex/scc_documentSearchLWC_Controller.getCriteriaDocdata';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation'; 
import getBillingAddress from '@salesforce/apex/scc_confirmAddress.getUserBillingAddress';
import getRelatedShippingAddress from '@salesforce/apex/scc_confirmAddress.getUserShippingAddress';

//Importing labels
import scc_home_Search from "@salesforce/label/c.scc_home_Search";
import scc_OrderStatus_Clear from "@salesforce/label/c.scc_OrderStatus_Clear";
import scc_home_From from "@salesforce/label/c.scc_home_From";
import scc_home_To from "@salesforce/label/c.scc_home_To";
import scc_home_Order_Date from "@salesforce/label/c.scc_home_Order_Date";
import scc_emailDocumentSuccess from "@salesforce/label/c.scc_emailDocumentSuccess";

//importing static resources
import scc_noResults from "@salesforce/resourceUrl/scc_noResults";
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import scc_email_icon_white from '@salesforce/resourceUrl/scc_email_icon_white';
import scc_email_icon_blue from '@salesforce/resourceUrl/scc_email_icon_blue';
import scc_calender_icon from "@salesforce/resourceUrl/scc_calender_icon";
import {loadStyle} from 'lightning/platformResourceLoader';
import headmarkupstyle_static from '@salesforce/resourceUrl/headmarkupstyle_static';

//import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import generateRADARRequest from '@salesforce/apex/scc_documents_RADAR_Controller.generateRADARRequest'; 
import {viewAndDownloadPdf} from 'c/scc_exportRADAR_PdfLWC';
//import { RefreshEvent } from 'lightning/refresh';


export default class Scc_documentSearchLWC extends LightningElement {  
     alertIcon = imageIcons + '/Images/alert.png';
 //Variables initialization
    @track SearchByvalue = '';
    @track InvoiceSelect = false;
    @track SearchByOptions1 =[];
    @track isLoading1 = false;
    @track InvoNum = '';
    @track SearchDisabledReturn = true;
    @track orderDetailsSect = false;
    @track showSearchResults = false;
    @track sortDirection;
    @track sortedBy;
    @track selectedDocuments='';
    @track allSelected='';
    @track isAllChecked=false;
    @track isEachChecked =false;
   // @track showSendDoc=false;
    @track valEmail='';
    @track disableDoc = true;
    @track requestData;
    @track emailUpdated='';
    @track emailIcon =scc_email_icon_white;
   @track popupEmailIcon = scc_email_icon_white;
    First = '<< First'
    Previous = '< Previous'
    next = 'Next >'
    Last = 'Last >>'
    pageSizeOptions = [15, 30, 45, 60]; 
    records = []; 
    totalRecords = 0; 
    pageSize; 
    @track totalPages = 1; 
    pageNumber = 1; 
    recordsToDisplay = [];
    @track data;
    @track totalRecords;
    @track isGuest=false;
    @track isInternal=false;
    @track CustomerName= false;
    @track isAdvanced = false;
    @track showInvoiceEmail = false;   
    @track Email=''; 
    @track showEmailMessage = false;
    isViewScChecked = true;
    isEmailChecked = false;
    sendEmail = true;
    showCheckBox = false;
    InvoiceStatusValue = 'All';
    PONum ='';
    startDate = null;
    endDate = null;
    minimumDate = null;
    accNumber = '';
    @track showStatementEmailMessage = false;

    //newly added
    @track monthOptions = [{ label: 'January', value: '01' }, { label: 'February', value: '02' }, 
                           { label: 'March', value: '03' }, { label: 'April', value: '04' },
                           { label: 'May', value: '05' }, { label: 'June', value: '06' },
                           { label: 'July', value: '07' }, { label: 'August', value: '08' },
                           { label: 'September', value: '09' }, { label: 'October', value: '10' },
                           { label: 'November', value: '11' }, { label: 'December', value: '12' }
                        ];

    @track InvoiceStatusOptions = [{label:'All',value:'All'},{label:'Open',value:'Open'},{label:'Closed',value:'Closed'}];
    
    @track yearOptions = [{ label: 'Current Year', value: 'Current Year' }, { label: 'Last Year', value: 'Last Year' }, { label: 'Prior Year', value: 'Prior Year' }];
    

    labels = {
        scc_home_Search,
        scc_OrderStatus_Clear,
        scc_noResults,
        scc_email_icon_white,
        scc_email_icon_blue,
        scc_calender_icon,
        scc_home_From,
        scc_emailDocumentSuccess,
        scc_home_To,scc_home_Order_Date
    }
    @track confirmAddress = false; // Default to false

    constructor() {
        super();
        console.log('constructor Calling');
        getUserInformation().then(response => {
            console.log('response is', response);
            let paser = JSON.parse(response);
            let data = paser[0];
            console.log(data);
            this.userName = data.userName;
            this.accountName = data.accountName;
            this.isGuest = data.isGuest;
            this.isInternal = data.isInternal;
            this.accNumber = data.AccountNumber;
            console.log('IsInternal', this.isInternal);
            
            // Set confirmAddress based on user type
            if (!this.isInternal) {
                this.confirmAddress = true; // Only for external users
            } else {
                this.confirmAddress = false; // For internal users
            }
        }).catch(error => {
            console.log('error is', error);
        });
    }
    
    connectedCallback() { 
        this.callSearchOptions();
        this.handleDates();
    }
    formatDate(date) {
        const [year, month, day] = date.split('-');
        return `${month}/${day}/${year}`;
    }

    handleDates(){
        const today = new Date();
        const threeMonthsAgo = new Date(today);
        const twentyFourMonthsAgo = new Date(today);
        twentyFourMonthsAgo.setMonth(today.getMonth() - 24);
        threeMonthsAgo.setMonth(today.getMonth() - 3);
        this.startDate = threeMonthsAgo.toISOString().split('T')[0];
            //console.log('this.startDate ',this.startDate);
        this.endDate = today.toISOString().split('T')[0];
         //console.log('this.endDate ',this.endDate);
        this.minimumDate = twentyFourMonthsAgo.toISOString().split('T')[0];
         //console.log('this.minimumDate ',this.minimumDate);
    }

    callSearchOptions(){
        this.isLoading1 = true;
        getDocSearchByOptions({ 
            HomePage: false,
            isAdvanced: this.isAdvanced,
            isInternal: this.isInternal  
        }).then(response => {
            console.log('response is', response);
            let paser = JSON.parse(response);
            console.log('getDocSearchByOptions', paser);
            this.SearchByOptions1 = JSON.parse(response);
            this.isLoading1 = false;
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })
    }

    
    handleInvoNumChange(event) {
        this.InvoNum = event.target.value
    }

    handleInvoiceStatusOptionChange(event){
        this.InvoiceStatusValue = event.target.value;
    }

    handlePONumChange(event){
        this.PONum = event.target.value;
    }

    handleStartDateChange(event){
        this.startDate = event.target.value;
    }

    handleEndDateChange(event){
        this.endDate = event.target.value;
    }

    //pagination handlers
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }

    @track base64String;
    @track iFrameUrl;
   handleInvoice(event) {
    const requestData = {
        documentNumber: event.target.dataset.invoiceNumber,
        opeartion: this.SearchByvalue,
        emailId: '',
        Combined: 'N',
        IncludePOD: 'N',
        accountNumber: this.accNumber,
        month: this.monthValue,
        year: this.yearValue
    };

    if (this.isViewScChecked) {
        generateRADARRequest({
            requestData: requestData
        }).then(data => {
            console.log('data', data);
            this.base64String = JSON.parse(data);
        })
        .catch(error => {
            console.log('error', error);
        }).finally(() => {
            if (this.base64String != null && this.base64String != '') {
                let valRetn = viewAndDownloadPdf(this.base64String);
                // Handle PDF viewing here
            }
        });
    } else if (this.isEmailChecked) {
        // Handle email logic here
        this.showEmailDoc();
    }
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

    get startDate(){
        return this.startDate;
    }

    get endDate(){
        return this.endDate;
    }

    get SearchByOptions() {
        return this.SearchByOptions1;
    }

    get noRecordsToDisplay() {
        return this.recordsToDisplay.length == 0;
    }

    get InvoiceStatusOptions(){
        return InvoiceStatusOptions;
    }

    get isAdvanced(){
        return this.isAdvanced;
    }

    handleDocPrefChange(event){
        if(event.target.name == 'View on Screen'){
            this.isViewScChecked = true;
            this.isEmailChecked = false;
            this.showCheckBox = false;
            this.showEmailMessage = false;
            this.showStatementEmailMessage = false;
            //this.sendEmail = false;
        }

        if(event.target.name == 'Email'){
            this.isViewScChecked = false;
            this.isEmailChecked = true;
            this.showCheckBox = true;
            //this.sendEmail = false;
        }
    }
    handlecheck(event)
    {
        this.allSelected   = event.target.checked;
        
        let selectedInvoiceArray = [];
        // if(allSelected)
        // {
        //     this.recordsToDisplay.forEach(records => {
        //         selectedInvoiceArray.push(records.invoice);
        //     });
        // }
        // else{
        //     this.selectedDocuments = '';
        // }
        //this.selectedDocuments = selectedInvoiceArray.join(';');
        const checkboxes= this.template.querySelectorAll('input.invoicecheckbox');
        this.selectedDocuments = '';
        checkboxes.forEach(checkbox =>{
            checkbox.checked=this.allSelected;
            if(this.allSelected)
            {
                this.selectedDocuments +=`${checkbox.value};`;
                console.log('selectedDocuments',this.selectedDocuments);
            }
            else{
                 this.selectedDocuments = '';
            }
            });
            const selectedCount = this.selectedDocuments ? this.selectedDocuments.split(';').length:0;
            if(selectedCount > 0 && selectedCount <= 5)
            {
                this.sendEmail = false;
                this.emailIcon=scc_email_icon_blue;
            }
            else
            {
                this.sendEmail = true;
                this.emailIcon=scc_email_icon_white;
            }

    }
    handleDocEmailChange(event)
    {
        const value = event.target.name;
        console.log('value of radio',value);
         if(event.target.name == 'all'){
            this.isAllChecked = true;
            this.isEachChecked = false;
            //this.showSendDoc = true;
           
        }

        if(event.target.name == 'each'){
            this.isEachChecked = true;
            //this.showSendDoc = true;
            this.isAllChecked =false;
            
           
        }
        if(event.target.name == 'email')
        {
            this.valEmail = event.target.value;
            console.log('email',this.valEmail);
            const emailArray = this.valEmail.split(',').map(email=>email.trim());
            let semiColonSeperated = this.valEmail.replace(/,/g,';');
            console.log('semicolon',semiColonSeperated);
            this.emailUpdated = semiColonSeperated.replace(/\s*;\s*/g, ';').trim();
        }
    }
showSendDoc(event)
{
    if (!JSON.parse(event.target.getAttribute('aria-disabled')))
  {
 console.log('email seperated', this.emailUpdated);
    console.log('selectedDocuments',this.selectedDocuments);
    //this.closeModal();
    //event.preventDefault();
   this.showInvoiceEmail = false;
   
    this.handleSubmit();
   }



}
  handleSubmit() {

  
    //let semiColonSeperated = this.Email.replace(/,/g,';');
    console.log('email seperated', this.emailUpdated);
    console.log('selectedDocuments',this.selectedDocuments);
        if(this.isAllChecked)
        {
            this.requestData = {
            documentNumber: this.selectedDocuments,
            opeartion: this.SearchByvalue,
            emailId: this.emailUpdated,
            Combined: 'Y',
            IncludePOD: 'N',
            accountNumber: this.accNumber,
            month: this.monthValue,
            year: this.yearValue
          }
        }
        else if(this.isEachChecked)
        {
            this.requestData = {
            documentNumber: this.selectedDocuments,
            opeartion: this.SearchByvalue,
            emailId: this.emailUpdated,
            Combined: 'N',
            IncludePOD: 'N',
            accountNumber: this.accNumber,
            month: this.monthValue,
            year: this.yearValue
          }
        }
          console.log('this.requestData',this.requestData);
          generateRADARRequest({
            requestData: this.requestData
          }).then(data => {
            console.log('data', data);
            this.base64String = JSON.parse(data);
          })
            .catch(error => {
              console.log('error', error);
            })

      
      .catch(error => {
        console.log('result error', error);
      })
      //this.handleRefresh();
      this.showEmailMessage = true;
      this.showStatementEmailMessage = true;
     // this.dispatchEvent(new RefreshEvent());

  

}
handleRefresh()
{
    this.valEmail='';
    const checkboxes= this.template.querySelectorAll('input.invoicecheckbox');
    this.selectedDocuments = '';
    this.sendEmail = true;
    checkboxes.forEach(checkbox =>{
    checkbox.checked= false;
    })
    this.isEachChecked = false;
    this.isAllChecked = false;

}
   

    handlecheckbox(event)
    {
        
        const invoiceid = event.target.value;
        const isChecked = event.target.checked;
        let selectedInvoiceArray = this.selectedDocuments ? this.selectedDocuments.split(';'):[];
        if(isChecked)
        {
            if(!selectedInvoiceArray.includes(invoiceid))
            {
                selectedInvoiceArray.push(invoiceid);
            }
        }
            else
            {
             selectedInvoiceArray = selectedInvoiceArray.filter(docId=>docId!==invoiceid);   
            }
            this.selectedDocuments = selectedInvoiceArray.join(';');
            const selectedCount = this.selectedDocuments ? this.selectedDocuments.split(';').length:0;
            console.log('count',selectedCount);
            if(selectedCount > 0 && selectedCount <= 5)
            {
                this.sendEmail = false;
                this.emailIcon=scc_email_icon_blue;
            }
            else
            {
                this.sendEmail = true;
                this.emailIcon=scc_email_icon_white;
            }
            console.log('Selected Documents',this.selectedDocuments);
        //     if(this.selectedDocuments.length <= 5 )
        //     {
        //         this.selectedDocuments.push(invoiceid);
        //         this.sendEmail = false;
        //         console.log('Selected Documents',this.selectedDocuments);
        //     }

        //     else 
        //     {
        //         this.sendEmail = true;
        //     }
        // }
        // else{
        //    this.selectedDocuments = this.selectedDocuments.filter(docId=>docId!==invoiceid);
        //     console.log('Selected Documents',this.selectedDocuments);
        //     this.sendEmail = true;
        // }
        //  if(this.selectedDocuments.length === 0 || this.selectedDocuments.length > 5)
        // {
        //         this.sendEmail = true;
        // }
    }

    get disableDocEmail() {
        console.log('this.valemail',this.valEmail);
        console.log('this.all',this.isAllChecked);
        console.log('this.each',this.isEachChecked);
     if (this.valEmail != '' && (this.isAllChecked == true || this.isEachChecked == true)) {

            this.disableDoc = false;
     } 
     else {
       this.disableDoc = true;
     }
     return this.disableDoc;
     
      
    }

    @track StatementSelect;
    @track DebitMemoSelect;
    @track CreditMemoSelect;
    @track yearValue = '';
    @track monthValue = '';
    @track isStatementSelected = false;
    @track billingAccountNumber = '';

    handleSearchOptionChange(event) {
        this.handleClearClick();
        this.SearchByvalue = event.target.value;

        this.InvoiceSelect = false;
        this.DebitMemoSelect = false;
        this.StatementSelect = false;
        this.CreditMemoSelect = false;
        this.isStatementSelected = this.SearchByvalue === 'Statement';

        if (this.SearchByvalue == 'Invoice' || this.SearchByvalue =='Invoice & Proof of Delivery (if available)' || this.SearchByvalue == 'Proof of Delivery (if available)') {
            this.InvoiceSelect = true;
        }

        if (this.SearchByvalue == 'Statement') {
            this.StatementSelect = true;
        }

        if (this.SearchByvalue == 'Debit Memo') {
            this.DebitMemoSelect = true;
        }

        if (this.SearchByvalue == 'Credit Memo') {
            this.CreditMemoSelect = true;
        }
    }

    handleMonthOptionChange(event){
        this.monthValue = event.target.value;
    }

    handleYearOptionChange(event){
        this.yearValue = event.target.value;
    }
    handleBillingAccountChange(event) {
        this.billingAccountNumber = event.target.value;
        this.accNumber = event.target.value;
    }

    handleClearClick(event) {
    //   if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
        if (!JSON.parse(this.template.querySelector('.clear-button').getAttribute('aria-disabled'))) {
        this.recordsToDisplay =[];
        this.showSearchResults = false;
        this.InvoNum='';
        this.monthValue = '';
        this.yearValue = '';
        this.PONum = '';
        this.InvoiceStatusValue = 'All';
        this.billingAccountNumber = ''; 
        this.handleDates();
        this.showEmailMessage=false;
        this.showStatementEmailMessage = false;
        this.sendEmail=true;
        this.handleRefresh();
       }
    }



    get SearchDisabled() {
        if(this.isAdvanced == false){
            if ((this.InvoNum != '')) {
                console.log('this.SearchDisabledReturn ', this.SearchDisabledReturn);
                this.SearchDisabledReturn = false;
    
            } else {
                if((this.monthValue !='' && this.yearValue !='')){
                    this.SearchDisabledReturn = false;
                }else{
                    this.SearchDisabledReturn = true;
                }
                
            }
        }

        if(this.isAdvanced == true){
            if ((this.InvoNum != '' || this.PONum !='' || (this.startDate !=null && this.endDate !=null))) {
                console.log('this.SearchDisabledReturn ', this.SearchDisabledReturn);
                this.SearchDisabledReturn = false;
    
            } else {
                this.SearchDisabledReturn = true;
            }
        }

        return this.SearchDisabledReturn;
    }

    formatDate(date) {
        const [year, month, day] = date.split('-');
        return `${month}/${day}/${year}`;
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
    @track sapShipTo ='';
    @track sapBillTo ='';
    handleSearch(event) {
    if (!JSON.parse(this.template.querySelector('.search-button').getAttribute('aria-disabled'))) {
        this.isLoading1 = true;
        this.showEmailMessage = false;
        this.showStatementEmailMessage = false;
        this.handleRefresh();
        if(!!this.selectedShipping){
            this.sapShipTo = this.selectedShipping.ShipToNumber;
        }

        if(!!this.selectedBilling){
            this.sapBillTo = this.selectedBilling.BillToNumber;
        }

        const docRequestData ={
            SearchByvalue: this.SearchByvalue,
            InvoNum:this.InvoNum,
            PONum:this.PONum,
            InvoiceStatus: this.InvoiceStatusValue,
            startDate: this.startDate,
            endDate: this.endDate,
            monthValue: this.monthValue,
            yearValue: this.yearValue,
            isAdvanced: this.isAdvanced,
            billingAccountNumber: this.isInternal ? this.billingAccountNumber : null,
            SAP_ShipTo: this.sapShipTo,
            SAP_BillTo: this.sapBillTo
        };
         if(this.SearchByvalue == 'Statement') {
            if (this.isViewScChecked) {
                let ev = {target:{dataset:{invoiceNumber:''}}};
                this.handleInvoice(ev);
            } else if (this.isEmailChecked) {
                this.showEmailDoc(event);
            }
            this.isLoading1 = false;
        } else {
            this.recordsToDisplay = [];
            this.totalRecords =0;
            this.showSearchResults = true;
            console.log('docRequestData',docRequestData);
            getCriteriaDocdata({
                docRequestData:docRequestData
            }).then(response => {
                console.log('response is', response);
                let paser = JSON.parse(response);
                console.log('getCriteriaOrderdata', paser);
                this.data = JSON.parse(response);
                console.log('this.data ', this.data);
                this.records = this.data;
                this.pageSize = this.pageSizeOptions[0];
                this.totalRecords = this.data.length;

                this.paginationHelper(); // call helper method to update pagination logic 
                if(this.totalRecords == 1){
                    let ev = {target:{dataset:{invoiceNumber:data[0].invoice}}};
                    this.handleInvoice(ev);
                }
                this.isLoading1 = false;
            }).catch(error => {
                console.log('error is', error);
                this.isLoading1 = false;
            })

        }
      }
    }

    handleActive(event) {
        console.log('this.isAdvanced',this.isAdvanced);
        const tab = event.target.dataset.id;
        if(tab == 'tab-default-2__item'){
            this.handleClearClick();
            this.isAdvanced = true;
            this.SearchByvalue = '';
            this.InvoiceSelect = false;
            this.CreditMemoSelect = false;
            this.DebitMemoSelect = false;
            this.StatementSelect = false;
            this.isViewScChecked = true;
            this.isEmailChecked = false;
            this.callSearchOptions();
        }
        
        if(tab == 'tab-default-1__item'){
            this.handleClearClick();
            this.isAdvanced = false;
            this.SearchByvalue = '';
            this.InvoiceSelect = false;
            this.CreditMemoSelect = false;
            this.DebitMemoSelect = false;
            this.StatementSelect = false;
            this.isViewScChecked = true;
            this.isEmailChecked = false;
            this.callSearchOptions();
        }
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


    billaddress;
    selectedAccountId;
    billingaddreses;
    Shipaddress;
    searchTerm = '';
    searchTermShip = '';
    totalRecordsInShip;
    filteredresult = [];
    filteredresultt = [];
    totalRecords = '';
    selectedAcc = [];
    selectedBilling;
    selectedShipping;
    lengthBillAddress;
    totalBillToRecords;
    totalShipToRecords
    selectedAccount;
    selectedShipAccount;
    previouslySelected;
    showMultiAddressPage = false;
    showSingleAddressPage = false;
    showShipAddressPage = false;
    showShipAddressEmptyPage = false; 
    isChecked = false;
  
  
  
  @wire(getBillingAddress)
  wiredBillAddresss({ error, data }) {
      if (data) {
          this.billaddress = data;
          this.selectedBilling=this.billaddress.find(billing => billing.AccId === this.billaddress[0].AccId);
          console.log('this.selectedBilling',this.selectedBilling);
          this.totalRecords = data.length;
          this.billingaddreses = data;
          this.applyFilters();
          console.log('totalrecords', this.totalRecords);
          console.log('billingaddress', this.billaddress);
          this.selectedAccount = data[0];
          //this.selectedAccountId = data[0].AccId;
        
      } else if (error) {
          this.error = error;
             console.log('errorbillingaddressloadfirst', error);
      }
  }
  
  @wire(getRelatedShippingAddress)
  wiredShipAddress({ error, data }) {
      if (data) {
              this.Shipaddress = data;
              this.totalRecordsInShip =  data.length;
              if(this.totalRecords > 1 || this.totalRecordsInShip > 1 ){
              this.showMultiAddressPage = true;   
              this.showShipAddressEmptyPage = true; 
              this.isChecked = true;
             console.log( 'this.showMultiAddressPage = true');      
              }else{
                  this.showMultiAddressPage = false; 
                  this.selectedShipping=this.Shipaddress.find(shipping => shipping.AccShipId === this.Shipaddress[0].AccShipId);
                  this.showShipAddressEmptyPage = false;
                      console.log( 'this.showMultiAddressPage = false');  
              }
              this.showSingleAddressPage = true;
              this.applyFilterss();        
              }
  
          else if (error) {
          this.error = error;
      }
  
  }
    renderedCallback() {

    loadStyle(this, headmarkupstyle_static)
            .then(() => {
                // console.log("Loaded Successfully")
            })
            .catch(error => {
                // console.error("Error in loading the colors", error)
            });
  
      if (this.selectedAccountId) {
          const billingInputs = this.template.querySelectorAll('input[name="BillingAddresss"]');
          billingInputs.forEach(input => {
              console.log('insideBillingAddress',this.selectedAccountId,'inputs',input);
  
              if (input.value === this.selectedAccountId) {
                  input.checked = true;
              }
  
  
          });
      }


      if(this.showInvoiceEmail){
         this.focusCloseButton();
      }
  
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


    handleRowClick(event) {
          console.log('onclickBilladdres');
          this.selectedAccountId = event.currentTarget.dataset.recordId;
          this.selectedBilling=this.billaddress.find(billing => billing.AccId === this.selectedAccountId);
          console.log('this.selectedBilling',this.selectedBilling);
         
    }
    handleShipRowClick(event) {
        console.log('onclickshipaddres');
          this.selectedShipAccountId = event.currentTarget.dataset.recordId;
          this.selectedShipping=this.Shipaddress.find(shipping => shipping.AccShipId === this.selectedShipAccountId);
          this.showShipAddressEmptyPage = false;
          console.log('this.selectedShipping',this.selectedShipping);
          this.isChecked = false;
          const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
          shippingInputs.forEach(input => {
                          console.log('insideshippingAddress',this.selectedShipAccountId,'inputs',input);
              if (input.value === this.selectedShipAccountId) {
                
                  input.checked = true;
              }
          });
  
         
  
    }
    handlecheckboxChange(event) {
          this.isChecked = event.target.checked;
          console.log('im in the handel check box ', this.isChecked)
          if (this.isChecked == true) {
              this.selectedShipping = [];
              this.showShipAddressEmptyPage= true;
          const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
          shippingInputs.forEach(input => {
                          console.log('insideshippingAddress',this.selectedShipAccountId,'inputs',input);
              if (input.value === this.selectedShipAccountId) {
                  console.log('this.selectedShipAccountId',this.selectedShipAccountId);
                  input.checked = false;
                  this.handlechangemethod();
              }
          });
          }
          else {
              this.selectedShipAccountId =  this.Shipaddress[0].AccShipId;
              this.selectedShipping=this.Shipaddress.find(shipping => shipping.AccShipId === this.selectedShipAccountId);
              this.showShipAddressEmptyPage = false;
              this.showShipAddressPage = true;
              const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
              shippingInputs.forEach(input => {
                          console.log('insideshippingAddress',this.selectedShipAccountId,'inputs',input);
              if (input.value === this.selectedShipAccountId) {
                
                  input.checked = true;
              }
          });
             
          }
    }
    handlechangemethod(){
            if (this.selectedShipAccountId) {
          console.log('highlightsection');
          const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
          shippingInputs.forEach(input => {
                          console.log('insideshippingAddress',this.selectedShipAccountId,'inputs',input);
              if (input.value === this.selectedShipAccountId) {
                 
                  input.checked = false;
              }
          });
      }
    }
    handleUserInputs(event) {
          this.searchTerm = event.target.value.toLowerCase();
          console.log('userinputs', this.searchTerm);
          if(this.searchTerm.length>=3 || this.searchTerm==''){
            this.applyFilters();
          }

          
     }
     clearFilterInputBill(){
          this.searchTerm = '';
          console.log('userinputs', this.searchTerm);
          this.applyFilters();
     }
  
     handleUserInputsShip(event) {
          this.searchTermShip = event.target.value.toLowerCase();
          console.log('userinputs', this.searchTerm);
          if(this.searchTermShip.length>=3 || this.searchTermShip==''){
            this.applyFilterss();
          }
          
     }
     clearFilterInputShip(){
          this.searchTermShip = '';
          console.log('userinputs', this.searchTerm);
          this.applyFilterss();
     }
  
     applyFilters() {
  
          if (!this.billingaddreses) {
              console.log('billingempty');
              this.filteredresult = this.billingaddreses;
              return;
          }
          const searchte = this.searchTerm;
          console.log('the value coming in filter is', this.billingaddreses, 'value in the search term is', searchte)
          this.filteredresult = this.billingaddreses.filter(billingadd => {
              console.log('the value coming in filter is', this.billingaddreses, 'value in the search term is', searchte);
              console.log('name and zip value is', billingadd.AccountName, billingadd.ZipCode);
              const zipfromacc = billingadd.ZipCode;
              const accountName = billingadd.AccountName;
              if ((zipfromacc == undefined || zipfromacc == '') && (accountName != undefined && accountName != '')) {
                  console.log('im in if class of filtered billadress');
                  return (
                      (billingadd.AccountName.toLowerCase().includes(searchte))
                  );
              }
             if (zipfromacc == undefined && zipfromacc == '' && accountName == undefined && accountName == '') {
                return;
               }
              if (zipfromacc !== undefined && zipfromacc !== '' && accountName !== undefined && accountName !== '') {
              return (
                       (billingadd.AccountName.toLowerCase().includes(searchte))
                      || (billingadd.ZipCode.toLowerCase().includes(searchte))
              );
             }
             if ((accountName == undefined || accountName == '') && (zipfromacc != undefined && zipfromacc != '')) {
                  console.log('im in if class of filtered billadress');
                  return (
                      (billingadd.ZipCode.toLowerCase().includes(searchte))
                  );
              }
  
          });
          console.log('im in initial');
         // this.selectedAccountId =this.filteredresult[0].AccId;
          this.showAvailableShipping = true;
          console.log('filtered list is', this.filteredresult);
          this.lengthBillAddress = this.filteredresult.length;
          this.totalBillToRecords = this.lengthBillAddress;
          
      }
    applyFilterss() {
      if (!this.Shipaddress) {
          this.filteredresultt = this.Shipaddress;
          return;
      }
      const searchter = this.searchTermShip;
      console.log('the value coming in ship filter is', this.Shipaddress, 'value in the ship search term is', searchter);
      this.filteredresultt = this.Shipaddress.filter(Shipaddresss => {
          const shipAccName = Shipaddresss.SAccountName;
          const shipPostalCode = Shipaddresss.PostalCode;
          if (shipAccName == undefined && shipAccName == '' && shipPostalCode == undefined && shipPostalCode == '') {
              return;
          }
          if (shipAccName !== undefined && shipAccName !== '' && shipPostalCode !== undefined && shipPostalCode !== '') {
              return (
                  (Shipaddresss.SAccountName.toLowerCase().includes(searchter)) ||
                  (Shipaddresss.PostalCode.toLowerCase().includes(searchter))
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
      console.log('filtered list is', this.filteredresultt);
      this.lengthShipAddress = this.filteredresultt.length;
      this.totalShipToRecords = this.lengthShipAddress;
      if(this.totalShipToRecords > 0){
      this.selectedShipAccount = this.filteredresultt[0].AccShipId;
      }
  
      }

      returnProductDetailpageOnclick(){
        this.confirmAddress = false;
      }

showEmailDoc(event) {
    if (event && !JSON.parse(event.target.getAttribute('aria-disabled'))) {
        this.showInvoiceEmail = true;
        if (this.SearchByvalue == 'Statement') {
            // For Statements, we don't have multiple documents to select
            this.sendEmail = false;
            this.emailIcon = this.labels.scc_email_icon_blue;
        } else {
            if (this.selectedDocuments.length === 0 || this.selectedDocuments.length > 5) {
                this.sendEmail = false;
                this.emailIcon = this.labels.scc_email_icon_blue;
            }
        }
    }
} 
      closeModal()
      {
        this.showInvoiceEmail = false;
        console.log('button',this.sendEmail);
        console.log('Count',this.selectedCount);
        console.log('selected doc',this.selectedDocuments);
        //this.handleRefresh();
        //this.dispatchEvent(new RefreshEvent());

      const button = this.template.querySelector(".email-button");
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }

      }
//added by zubiya
 //Trap focus inside modal
    focusOutClose(event) {
      var related = event.relatedTarget;
      if(related != undefined){
        if(related.getAttribute('data-index') != 0) { 
          this.template.querySelector('.cancel-modal-button').focus();
        }
      }
    }
  focusOutButton(event){
      var related = event.relatedTarget;
      if(related != undefined){
        if(related.getAttribute('data-index') != 0) { 
          this.template.querySelector('.guestOrderStatusClose').focus();
        }
      }
    }
}