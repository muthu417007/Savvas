import { LightningElement, wire } from 'lwc';
import getBillingAddress from '@salesforce/apex/scc_confirmAddress.getUserBillingAddress';
import getRelatedShippingAddress from '@salesforce/apex/scc_confirmAddress.getUserShippingAddress';
export default class Scc_reportsLWC extends LightningElement {
  
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
        this.selectedAccountId = data[0].AccId;
      
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

    if (this.selectedAccountId) {
        const billingInputs = this.template.querySelectorAll('input[name="BillingAddresss"]');
        billingInputs.forEach(input => {
            console.log('insideBillingAddress',this.selectedAccountId,'inputs',input);

            if (input.value === this.selectedAccountId) {
                input.checked = true;
            }


        });
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
        this.applyFilters();
   }
   clearFilterInputBill(){
        this.searchTerm = '';
        console.log('userinputs', this.searchTerm);
        this.applyFilters();
   }

   handleUserInputsShip(event) {
        this.searchTermShip = event.target.value.toLowerCase();
        console.log('userinputs', this.searchTerm);
        this.applyFilterss();
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


    }
    
}