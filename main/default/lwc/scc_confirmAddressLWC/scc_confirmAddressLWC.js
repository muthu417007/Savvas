/********************************************************************************************* 
* @Component Name  - Scc_confirmAddressLWC
* @description - Component to display user's billing and shipping address on place order tab
* @Created By  - CTS-Muthukumar
* @Created On - 2024-04-15 
* ********************************************************************************************/

import { LightningElement, track, wire } from 'lwc';
import isGuestUser from '@salesforce/apex/scc_checkOutLWC_Controller.isGuestUser';
import getBillingAddress from '@salesforce/apex/scc_confirmAddress.getCurrentUserBillingAddress';
import { CurrentPageReference } from 'lightning/navigation'; //Added by Zubiya for multi page
//import { decodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getAllowDropShip from '@salesforce/apex/scc_confirmAddress.getAllowDropShip';
import getRelatedShippingAddress from '@salesforce/apex/scc_confirmAddress.getCurrentUserShippingAddress';
import scc_billingAddress from '@salesforce/label/c.scc_billingAddress';
import scc_shippingAddress from '@salesforce/label/c.scc_shippingAddress';
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import scc_checkout_cart from "@salesforce/resourceUrl/scc_checkout_cart";
import updateAddress from '@salesforce/apex/scc_addItemsToCartController.updateAddress';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class Scc_confirmAddressLWC extends LightningElement {

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
    infoIconUrl = imageIcons + '/Images/info.png';

    @track isGuest = false;
    @track guestCartId=''
    @track guestAccountId ='';
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
    @track showMultiAddressPage = false;
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
    @track allowDropShip= false;
    @track schoolDis = false;
    @track showReviewCart=false;
    totalRecordsInShip = '';
    @track showAvailableShipping = true;
    @track reviewCartPage = false;
    @track billingAccountName;
    @track shippingAccountName;
    @track  selectedBilling;
    @track selectedShipping;
    @track checkuoutCartIcon;
    @track showCheckout = false;
    @track redirectCheckout = false;
    @track soldToNumber='';
    @track enableLogs = false;

    constructor(){
         
        super();
        isGuestUser().then(response => {            
            if(response){
                this.isGuest = true;                
                const urlParams = new URLSearchParams(window.location.search);
                this.guestCartId = urlParams.get('CartId');
                this.guestAccountId = urlParams.get('aid');                
                this.fetchBillingAddress();
                this.loadRelatedShipping();
            }else{
                this.fetchBillingAddress();                
                this.loadRelatedShipping();
            }
        }).catch(error => {
            console.log('error in checking if it is a guest user', error);
        })

    }
    connectedCallback() {
        
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
        
         if(sessionStorage.getItem('accounID') !=null && sessionStorage.getItem('CartId') !=null && sessionStorage.getItem('Token') !=null && sessionStorage.getItem('UserFromOtherSide') !=null ){
            if( sessionStorage.getItem('UserFromOtherSide') == 'true'){            
            this.checkuoutCartIcon = scc_checkout_cart;
            this.showCheckout = true;
             }
        }
    }
    handleCheckout(){
        this.callApexMethod();
        this.showConfirmAddressPage = false;
    }
    callApexMethod() {
     this.showConfirmAddressPage = false;
        if(this.isChecked == true){
            this.soldToNumber = this.selectedBilling.BillToNumber;
        }else{
            this.soldToNumber = this.selectedShipping.ShipToNumber;
        }
        const item = {
            sapUserBill: this.selectedBilling.BillToNumber,
            sapUserShip:  this.soldToNumber,
            oneTimeShip: this.isChecked,
            billCountry: this.selectedBilling.BillingCountry,
            shipAddressId: this.selectedShipping.AccShipId,
            shipCountry:this.selectedShipping.ShippingCountry,
            shipStreet:this.selectedShipping.ShipStreet,
            shipCity:this.selectedShipping.ShippingCity,
            shipState:this.selectedShipping.Provionce,
            shipZipCode:this.selectedShipping.PostalCode,
            billStreet:this.selectedBilling.BillinStreet,
            billCity:this.selectedBilling.BillingCity,
            billState:this.selectedBilling.State,
            billZipCode:this.selectedBilling.ZipCode,
            schoolDistrict:this.selectedShipping.schoolDistrict,
            guestAccountId:this.guestAccountId,
            guestCartId:this.guestCartId,
            billingName:this.selectedBilling.AccountName,
            shippingName:this.selectedShipping.SAccountName
        };
        this.userInputs = [...this.userInputs, item];
        if(this.enableLogs){
        console.log('the user selectedinput items', item);
        console.log('the user selectedinput', this.userInputs);
        console.log('this.userInputs proceed to checkout',this.userInputs);
        }
     updateAddress({ userInputs: this.userInputs })
        .then(result => {
            if(this.enableLogs){
             console.log('result is',result);
            }
        })
        .catch(
           error => {
                 console.log('Error:', error);
           }
        )
        .finally(() => {
            this.redirectCheckout = true;
        })
    }

    @wire(CurrentPageReference)       //Added by Zubiya for Multi page
    setCurrentPageRef(pageRef) {    
    
        if (pageRef.state.Source) {            
            this.source = pageRef.state.Source;

            if(this.source == 'showHeldCarts'){              
              this.viewallheldcart = true; 
              this.showConfirmAddressPage = false;
              this.reviewCartPage = false;
           
            }
            else{
                this.viewallheldcart = false;  
                this.reviewCartPage = false;
            }

          if(this.source == 'reviewHeldCart' || this.source == 'reviewCart' ){               
               this.reviewCartPage = true;
               this.viewallheldcart = false; 
               this.showChildComponent = false;
               this.showConfirmAddressPage = false;
               this.redirectCheckout = false;
          }
    
        }
        else{
            if(this.reviewCartPage == true){

            }else{            
            this.reviewCartPage = false;
            }
        }
}

    returnProductDetailpageOnclick() {
      
        this.showConfirmAddressPage = false;
        if(this.isChecked == true){
            this.soldToNumber = this.selectedBilling.BillToNumber;
        }else{
            this.soldToNumber = this.selectedShipping.ShipToNumber;
        }
        const item = {
            sapUserBill: this.selectedBilling.BillToNumber,
            sapUserShip:  this.soldToNumber,
            oneTimeShip: this.isChecked,
            billCountry: this.selectedBilling.BillingCountry,
            shipAddressId: this.selectedShipping.AccShipId,
            shipCountry:this.selectedShipping.ShippingCountry,
            shipStreet:this.selectedShipping.ShipStreet,
            shipCity:this.selectedShipping.ShippingCity,
            shipState:this.selectedShipping.Provionce,
            shipZipCode:this.selectedShipping.PostalCode,
            billStreet:this.selectedBilling.BillinStreet,
            billCity:this.selectedBilling.BillingCity,
            billState:this.selectedBilling.State,
            billZipCode:this.selectedBilling.ZipCode,
            schoolDistrict:this.selectedShipping.schoolDistrict,
            guestAccountId:this.guestAccountId,
            guestCartId:this.guestCartId,
            billingName:this.selectedBilling.AccountName,
            shippingName:this.selectedShipping.SAccountName
        };
        
        this.userInputs = [...this.userInputs, item];
        if(this.enableLogs){
        console.log('the user selectedinput', this.userInputs);
        console.log('the user selectedinput items', item);
        }
        this.showChildComponent = true;
        this.showConfirmAddressPage = false;
    }
    @wire(getAllowDropShip)
    wiredAllowDropShip({ error, data }) {
        if (data) { 
            if(this.enableLogs){
            console.log('data from getAllowDropShip ',data);
            }
            this.allowDropShip= data;            
        } else if (error) {
            if(this.enableLogs){
            console.log('error in getAllowDropShip ',error);
            }
            this.error = error;

        }
    }

    fetchBillingAddress(){
        getBillingAddress({guestAccountId:this.guestAccountId}).then(response => {
            if(this.enableLogs){
            console.log('getBillingAddress data', response);
            }
            this.billaddress = response;
              this.selectedAccountId = response[0].AccId;
            this.selectedBilling=this.billaddress.find(billing => billing.AccId === this.billaddress[0].AccId);            
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

    renderedCallback() {

        if (this.selectedAccountId) {               
            const billingInputs = this.template.querySelectorAll('input[name="BillingAddresss"]');
            billingInputs.forEach(input => {
                if (input.value === this.selectedAccountId) {
                    input.checked = true;
                }
            });
        }

        if (this.selectedShipAccountId) {
            const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
            shippingInputs.forEach(input => {
                if (input.value === this.selectedShipAccountId) {
                    input.checked = true;
                }
            });
        }
            
        }
    

        handleAddressPick(event) {            
            this.selectedAccountId = event.currentTarget.dataset.recordId;
            this.loadRelatedShipping(this.selectedAccountId);            
        }
        handlecheckboxChange(event) {
            this.isChecked = event.target.checked;            
            if (this.isChecked == true) {
                this.showAvailableShipping = false;
                this.totalShipToRecords = 0 ;
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
            this.applyFilters();
        }
        clearFilterInputBill(){
            this.searchTerm = '';
            this.applyFilters();
        }

        handleUserInputsShip(event) {
            this.searchTermShip = event.target.value.toLowerCase();            
            this.applyFilterss();
        }
        clearFilterInputShip(){
            this.searchTermShip = '';           
            this.applyFilterss();
        }
        applyFilterss() {
        if (!this.Shipaddress) {
            this.filteredresultt = this.Shipaddress;
            return;
        }
        const searchter = this.searchTermShip;       
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
        this.lengthShipAddress = this.filteredresultt.length;
        this.totalShipToRecords = this.lengthShipAddress;

        if (this.lengthShipAddress > 0) {
            this.showAvailableShipping = true;
            this.selectedShipAccountId = this.filteredresultt[0].AccShipId; 
            this.selectedShipping=this.Shipaddress.find(shipping => shipping.AccShipId === this.selectedShipAccountId);
            this.showShipAddressPage = true;
            this.showShipAddressEmptyPage = false;            
            this.isChecked = false;
        }
        
    }


    applyFilters() {
        if (!this.billingaddreses) {
            this.filteredresult = this.billingaddreses;
            return;
        }
        const searchte = this.searchTerm;
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
            this.selectedAccountId =this.filteredresult[0].AccId;
            this.selectedBilling=this.billaddress.find(billing => billing.AccId === this.selectedAccountId);            
            this.isChecked = false;
        }

    }

    handleRowClick(event) {
        this.selectedAccountId = event.currentTarget.dataset.recordId;
        this.selectedBilling=this.billaddress.find(billing => billing.AccId === this.selectedAccountId);
        this.showAvailableShipping = true;
        this.isChecked = false;        
    }

    loadRelatedShipping() {        
        getRelatedShippingAddress({  guestAccountId:this.guestAccountId })
            .then(result => {
                this.Shipaddress = result;
                this.selectedShipping=this.Shipaddress.find(shipping => shipping.AccShipId === this.Shipaddress[0].AccShipId);                
                this.totalRecordsInShip =  result.length;                
                if(this.totalRecords < 2 && this.totalRecordsInShip < 2 &&  this.allowDropShip == false){
                    this.showMultiAddressPage = false;
                    this.showSingleAddressPage = true;   
                    this.showShipAddressPage = true;        
                }
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
        this.selectedShipping=this.Shipaddress.find(shipping => shipping.AccShipId === this.selectedShipAccountId);
        this.isChecked = false;        
    }
}