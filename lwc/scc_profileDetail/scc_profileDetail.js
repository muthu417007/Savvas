/*
Lightning Web component: scc_deliveryInfoLWC
Author: CTS (Varshaa)
Created Date: 27/07/2024
Reason: Profile Detail page
Modified Date: 
*/
import { LightningElement, track ,api, wire} from 'lwc';
import getUserDetails from '@salesforce/apex/scc_profileDetailController.getUserDetails';
import getAllowDropShip from '@salesforce/apex/scc_confirmAddress.getAllowDropShip';
import getRelatedShippingAddress from '@salesforce/apex/scc_confirmAddress.getCurrentUserShippingAddress';
import scc_billingAddress from '@salesforce/label/c.scc_billingAddress';
import scc_shippingAddress from '@salesforce/label/c.scc_shippingAddress';
import getBillingAddress from '@salesforce/apex/scc_confirmAddress.getCurrentUserBillingAddress';
import createCaseProfile from '@salesforce/apex/scc_EnosixOrderSubmissionErrors.createCaseProfile';
import sendEmailToUserProfile from '@salesforce/apex/scc_EnosixOrderSubmissionErrors.sendEmailToUserProfile';
import scc_profileUpdateType from "@salesforce/label/c.scc_profileUpdateType";
import scc_profileUpdateSuccess from '@salesforce/label/c.scc_profileUpdateSuccess';
import scc_profilePageContent from '@salesforce/label/c.scc_profilePageContent';
import scc_profileRequestDetails from '@salesforce/label/c.scc_profileRequestDetails';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class Scc_profileDetail extends LightningElement {

    @track showProfileDetail = true;
    @track showMultiAddressPage = true;
    @track userDetail;
    @track accountDetail;
    @track placeOrders = false;
    @track checkOrderStatus = false;
    @track requestOneTimeShipping = false;
    @track isGuest = false;
    @track isCheckedReport = true;
    @track requestDetails = false;
    @track showprofilepage = true;
   // @track isSubmitDisabled = true;
    @track inputValue='';
    @track showUpdated = false;
    @track isLoading1 = false;

    labels = scc_profileUpdateType;
    labelsVal = {
        scc_profileUpdateSuccess,
        scc_profilePageContent,
        scc_profileRequestDetails
    }
    viewallheldcart = false;
    showConfirmAddressPage = true;
    reviewCartPage = false;

    selectbillingAddress = scc_billingAddress;
    selectShippingAddress = scc_shippingAddress;
    singlebilladdress;
    filteredresult;
    filteredresultt;
    totalRecords = '';
    inpvalFilter = '';
    nameFilter = '';
    ZipFilter = '';
    selectedAcc = [];
    showChildComponent = false;

    @track isGuest = false;
    @track guestCartId = ''
    @track guestAccountId = '';
    @track billaddress;
    @track Shipaddress;
    @track totalBillToRecords;
    @track totalShipToRecords;
    @track lengthBillAddress;
    @track lengthShipAddress;
    @track billingaddreses;
    @track searchTerm = '';
    @track searchTermShip = '';
    @track billingaddreseses;
    @track filteredAddress;
    @track selectedAccountId;
    @track selectedShipAccountId;
    @track selectedAccount;
    @track selectedShip;
    @track selectedoption;
    @track isChecked = false;
    @track showShipAddressPage = false;
    @track showConfirmAddressPage = true;
    @track showSingleAddressPage = false;
    @track showShipAddressEmptyPage = false;
    @track selectedAddress;
    @track userInputs = [];
    @track sapUserSelectedBill = '';
    @track sapUserSelectedShip = '';
    @track sapUserSelectedBillCountry = '';
    @track userSelectedShipAddressId = '';
    @track shippingCity = '';
    @track shippingCountry = '';
    @track shippingState = '';
    @track shippingStreet = '';
    @track shippingZip = '';
    @track billingCity = '';
    @track billingState = '';
    @track billingStreet = '';
    @track billingZip = '';
    @track allowDropShip = false;
    @track schoolDis = false;
    @track showReviewCart = false;
    totalRecordsInShip = '';
    @track showAvailableShipping = true;
    @track reviewCartPage = false;
    @track billingAccountName;
    @track shippingAccountName;
    @track selectedBilling;
    @track selectedShipping;
    @track enableLogs = false;

    constructor() {
        super();       

        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if(this.enableLogs){
                console.log('getEnableConsoleLogsTrue response is',response);
            }
        }).catch(error => {
            if(this.enableLogs){
                console.log('error is', error);
            }
        })
    }

    connectedCallback() {

        this.getDetails();
        this.fetchBillingAddress();
        this.loadRelatedShipping();
    }

    getDetails() {
        getUserDetails()
            .then(result => {
                if(this.enableLogs){
                    console.log('User details result', result);
                }
                if (result) {
                    this.userDetail = result;                    
                    this.placeOrders = result.Ordering_Enabled;
                    this.checkOrderStatus=result.CheckStatusPriceAvailability;
                    this.requestOneTimeShipping = result.AllowDropShip_Enabled;
                    if(this.enableLogs){
                        console.log('User details result', this.userDetail);
                        console.log('Account details result', this.accountDetail);
                    }
                }
            })
            .catch(error => {
                if(this.enableLogs){
                    console.log('result error', error);
                }
            })
    }

    handleInputChange(event)
    {    
        this.inputValue = event.target.value;
    }

     get isSubmitDisabled() {
        let boolVal = false;
        if (this.inputValue == '') {
            boolVal = true;
        }
        return boolVal;
    }
    showSubmitDetails()
    {  
 if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
        this.isLoading1 = true;
        if(this.enableLogs){
        console.log('details',this.inputValue);
        console.log('name',this.userDetail.Name);
        console.log('email',this.userDetail.Email);
        console.log('type',this.labels);
        }
        createCaseProfile({description:this.inputValue,name:this.userDetail.Name,email:this.userDetail.Email,type:this.labels}).then(response => { 
            if(this.enableLogs){
            console.log('createCase response',response);  
            }
            if(response != ''){                  
            setTimeout(() => {
            this.isLoading1 = false;
            
        }, 2000);
                this.showprofilepage =true;
                this.showUpdated = true;
                this.requestDetails = false;
                if(this.enableLogs){
                console.log('response profile',response);
                }
            }
                
        }).catch(error => {
            if(this.enableLogs){
            console.log('error in creating case', error);
            }
        })
      } 
    }

    returnProductDetailpageOnclick() {

        this.showConfirmAddressPage = false;
        const item = {
            sapUserBill: this.selectedBilling.BillToNumber,
            sapUserShip: this.selectedShipping.ShipToNumber,
            oneTimeShip: this.isChecked,
            billCountry: this.selectedBilling.BillingCountry,
            shipAddressId: this.selectedShipping.AccShipId,
            shipCountry: this.selectedShipping.ShippingCountry,
            shipStreet: this.selectedShipping.ShipStreet,
            shipCity: this.selectedShipping.ShippingCity,
            shipState: this.selectedShipping.Provionce,
            shipZipCode: this.selectedShipping.PostalCode,
            billStreet: this.selectedBilling.BillinStreet,
            billCity: this.selectedBilling.State,
            billState: this.selectedBilling.BillingCountry,
            billZipCode: this.selectedBilling.ZipCode,
            schoolDistrict: this.selectedShipping.schoolDistrict,
            guestAccountId: this.guestAccountId,
            guestCartId: this.guestCartId,
            billingName: this.selectedBilling.AccountName,
            shippingName: this.selectedShipping.SAccountName
        };
        if(this.enableLogs){
        console.log('the user selectedinput items', item);
        }
        this.userInputs = [...this.userInputs, item];
        if(this.enableLogs){
        console.log('the user selectedinput', this.userInputs);
        }
        this.showChildComponent = true;
        this.showConfirmAddressPage = false;
    }

    @wire(getAllowDropShip)
    wiredAllowDropShip({ error, data }) {
        if (data) {
            if(this.enableLogs){
            console.log('data from getAllowDropShip ', data);
            }
            this.allowDropShip = data;
            if(this.enableLogs){
            console.log('getAllowDropShip ', this.allowDropShip);
            }
        } else if (error) {
            if(this.enableLogs){
            console.log('error in getAllowDropShip ', error);
            }
            this.error = error;

        }
    }

    fetchBillingAddress() {
        getBillingAddress({ guestAccountId: this.guestAccountId }).then(response => {
            if(this.enableLogs){
            console.log('getBillingAddress data', response);
            }
            this.billaddress = response;
            this.selectedAccountId = response[0].AccId;
            this.selectedBilling = this.billaddress.find(billing => billing.AccId === this.billaddress[0].AccId);            
            this.totalRecords = response.length;            
            this.showMultiAddressPage = true;
            this.billingaddreses = response;
            this.applyFilters();
            this.selectedAccount = response[0];
            this.selectedAcc = response[0];
            this.selectedAccountId = response[0].AccId;
        }).catch(error => {
            this.error = error;
            if(this.enableLogs){
            console.log('getBillingAddress error is', error);
            }
        })
    }

    showRequestDetails()
    {        
        this.showprofilepage = false;
        this.requestDetails = true;
        
    }
    renderedCallback() {        

    }


    handleAddressPick(event) {
        if(this.enableLogs){
        console.log('shippingAddress handleAddressPick: ' + JSON.stringify(event.detail));
        }
        this.selectedAccountId = event.currentTarget.dataset.recordId;
        this.loadRelatedShipping(this.selectedAccountId);
        if(this.enableLogs){
        console.log('selectedAccountId', this.selectedAccountId);
        }
    }
    handlecheckboxChange(event) {
        this.isChecked = event.target.checked;        
        if (this.isChecked == true) {
            this.showAvailableShipping = false;
            this.totalShipToRecords = 0;
            this.showShipAddressEmptyPage = true;
            this.showShipAddressPage = false;
        }
        else {
            this.totalShipToRecords = this.lengthShipAddress;
            this.showAvailableShipping = true;
            this.showShipAddressEmptyPage = false;
            this.showShipAddressPage = true;
        }
    }

    handleUserInputs(event) {
        this.searchTerm = event.target.value.toLowerCase();
        if(this.enableLogs){
        console.log('userinputs', this.searchTerm);
        }
        this.applyFilters();
    }

    clearFilterInputBill() {
        this.searchTerm = '';
        if(this.enableLogs){
        console.log('userinputs', this.searchTerm);
        }
        this.applyFilters();
    }

    handleUserInputsShip(event) {
        this.searchTermShip = event.target.value.toLowerCase();
        if(this.enableLogs){
        console.log('userinputs', this.searchTerm);
        }
        this.applyFilterss();
    }
    clearFilterInputShip() {
        this.searchTermShip = '';
        if(this.enableLogs){
            console.log('userinputs', this.searchTerm);
        }
        this.applyFilterss();
    }
    applyFilterss() {
        if (!this.Shipaddress) {
            this.filteredresultt = this.Shipaddress;
            return;
        }
        const searchter = this.searchTermShip;
        if(this.enableLogs){
        console.log('the value coming in ship filter is', this.Shipaddress, 'value in the ship search term is', searchter);
        }
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
        if(this.enableLogs){
        console.log('filtered list is', this.filteredresultt);
        }
        this.lengthShipAddress = this.filteredresultt.length;
        this.totalShipToRecords = this.lengthShipAddress;

        if (this.lengthShipAddress > 0) {
            this.showAvailableShipping = true;
            this.selectedShipAccountId = this.filteredresultt[0].AccShipId;
            this.selectedShipping = this.Shipaddress.find(shipping => shipping.AccShipId === this.selectedShipAccountId);
            this.showShipAddressPage = true;
            this.showShipAddressEmptyPage = false;
            if(this.enableLogs){
            console.log('344selectedShipping', this.selectedShipping, 'selectedBilling', this.selectedBilling);
            }
            this.isChecked = false;
        }

    }


    applyFilters() {
        if (!this.billingaddreses) {
            this.filteredresult = this.billingaddreses;
            return;
        }
        const searchte = this.searchTerm;
        if(this.enableLogs){
        console.log('the value coming in filter is', this.billingaddreses, 'value in the search term is', searchte)
        }
        this.filteredresult = this.billingaddreses.filter(billingadd => {           
            const zipfromacc = billingadd.ZipCode;
            const accountName = billingadd.AccountName;
            if ((zipfromacc == undefined || zipfromacc == '') && (accountName != undefined && accountName != '')) {                
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
                return (
                    (billingadd.ZipCode.toLowerCase().includes(searchte))
                );
            }

        });        

        this.showAvailableShipping = true;        
        this.lengthBillAddress = this.filteredresult.length;
        this.totalBillToRecords = this.lengthBillAddress;
        if (this.lengthBillAddress > 0) {
            this.selectedAccount = this.filteredresult[0];
            this.selectedAcc = this.filteredresult[0];
            this.selectedAccountId = this.filteredresult[0].AccId;
            this.selectedBilling = this.billaddress.find(billing => billing.AccId === this.selectedAccountId);           
            this.isChecked = false;
        }

    }

    handleRowClick(event) {
        this.selectedAccountId = event.currentTarget.dataset.recordId;
        this.selectedBilling = this.billaddress.find(billing => billing.AccId === this.selectedAccountId);
        this.showAvailableShipping = true;
        this.isChecked = false;        
    }

    loadRelatedShipping() {
        getRelatedShippingAddress({ guestAccountId: this.guestAccountId })
            .then(result => {
                this.Shipaddress = result;
                this.selectedShipping = this.Shipaddress.find(shipping => shipping.AccShipId === this.Shipaddress[0].AccShipId);                
                this.totalRecordsInShip = result.length;                            
                this.showSingleAddressPage = true;
                this.showShipAddressPage = true;                
                this.applyFilterss();
                if (this.filteredresultt && this.filteredresultt.length > 0) {
                    this.selectedShipAccountId = this.filteredresultt[0].AccShipId;
                    this.loadSingleShipaddress(this.selectedShipAccountId);
                }                
            })
            .catch(error => {
                this.cases = undefined;
                this.caseError = error;
            });
    }
    handleShipRowClick(event) {
        this.selectedShipAccountId = event.currentTarget.dataset.recordId;
        this.selectedShipping = this.Shipaddress.find(shipping => shipping.AccShipId === this.selectedShipAccountId);
        this.isChecked = false;       
    }
}