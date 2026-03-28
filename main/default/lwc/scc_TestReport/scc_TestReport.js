import { LightningElement, track, wire } from 'lwc';

import { CurrentPageReference } from 'lightning/navigation'; //Added by Zubiya for quick report
import { decodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

//Apex
import getReportOptions from '@salesforce/apex/scc_Custom_ReportsController.getReportOptions';// added by sudha W-014819
import getBillingAddress from '@salesforce/apex/scc_confirmAddress.getUserBillingAddress';
import getRelatedShippingAddress from '@salesforce/apex/scc_confirmAddress.getUserShippingAddress';
import { RefreshEvent } from 'lightning/refresh';

//labels
import scc_OrderStatusReportTracking from "@salesforce/label/c.scc_OrderStatusReportTracking";// added by sudha W-014819
import scc_OrderStatusReportSummary from "@salesforce/label/c.scc_OrderStatusReportSummary";// added by sudha W-014819
import scc_OrderStatusReportDetail from "@salesforce/label/c.scc_OrderStatusReportDetail";// added by sudha W-014819
export default class scc_custom_Report_LWC extends LightningElement {



    //track // added by sudha W-014819
    @track viewSampleDisabled = true;
    deletereportDisabled = true
    editcriteriaDisabled = true;
    runreportDisabled = true
    @track SearchByOptions = [];
    @track SearchByvalue = '';
    @track Description = '';
    @track SelectedValue = false;
    OrderStatusReportSummary = false;
    OrderStatusReportDetail = false;
    OrderStatusReportTracking = false;
    CustomReport = false;
    @track isSelectedviewsample=false;
    @track selectedReportType ='';
    @track mainPage=true;
    @track detailpageopen=false;
    @track showpageopen =false
    @track billToNumber ;
    @track ShipToNumber;
    @track selectedBilling;
    @track records=[];
    @track msgfromc=false
    @track isEmailSent = false;
    
    labels = {
        scc_OrderStatusReportTracking,
        scc_OrderStatusReportSummary,
        scc_OrderStatusReportDetail
    }
    //edit component variables
    @track editCriteria =false;
    @track EditedReportName ='';
// ended by sudha //
  // Mutliaddreess code start 
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
  lengthBillAddress;
  totalBillToRecords;
  totalShipToRecords
  selectedAccount;
  selectedShipAccount;
  previouslySelected;
  showMultiAddressPage = false;
  showSingleAddressPage = false;
  isChecked = true;


  @wire(CurrentPageReference)      //added by zubiya
           
   getStateParameters(currentPageReference){
       console.log('currentPageReference', currentPageReference.state);
       if(currentPageReference){       
             if (currentPageReference.state.defaultFieldValues) { 
                console.log('inside if condition' );
               this.decodedValues = decodeDefaultFieldValues(currentPageReference.state.defaultFieldValues); 
             }
          
       }
   }




@wire(getBillingAddress)
wiredBillAddresss({ error, data }) {
    if (data) {
        this.billaddress = data;
        this.selectedBilling=this.billaddress.find(billing => billing.AccId === this.billaddress[0].AccId);
        console.log('default selected billto number is',this.selectedBilling);
        this.billToNumber = this.selectedBilling.BillToNumber;
        console.log('default selected billto number is',this.billToNumber);
        this.totalRecords = data.length;
        this.billingaddreses = data;
        console.log('billingaddressloadfirst', data);
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
            console.log( 'this.showMultiAddressPage = true');      
            }else{
                this.showMultiAddressPage = false; 
                console.log( 'this.showMultiAddressPage = false');  
            }
            console.log('result of load related ship address is', this.Shipaddress);
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
            if (input.value === this.selectedAccountId) {
                input.checked = true;
            }
        });
    }
    // if (this.selectedShipAccountId) {
    //     console.log('highlightsection');
    //     const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
    //     shippingInputs.forEach(input => {
    //                     console.log('insideshippingAddress',this.selectedShipAccountId,'inputs',input);
    //         if (input.value === this.selectedShipAccountId) {
               
    //             input.checked = true;
    //         }
    //     });
    // }
  }
  handleRowClick(event) {
        console.log('onclickBilladdres');
        this.selectedAccountId = event.currentTarget.dataset.recordId;
        this.billToNumber = event.target.getAttribute('data-attribute-billtonumber');
        console.log('userselected billto number',this.billToNumber);
        console.log('this.selectedAccountId',this.selectedAccountId);     
  }
  handleShipRowClick(event) {
      console.log('onclickshipaddres');
        this.selectedShipAccountId = event.currentTarget.dataset.recordId;
        this.ShipToNumber = event.target.getAttribute('data-attribute-ShipToNumber');
        console.log('userselectedshipto number',this.ShipToNumber);
        this.isChecked = false;
        const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
        shippingInputs.forEach(input => {
            if (input.value === this.selectedShipAccountId) {              
                input.checked = true;
            }
        });      

  }
  handlecheckboxChange(event) {
        this.isChecked = event.target.checked;
        console.log('im in the handel check box ', this.isChecked)
        if (this.isChecked == true) {
            this.ShipToNumber = '';
            const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
            shippingInputs.forEach(input => {
                if (input.value === this.selectedShipAccountId) {
                console.log('this.selectedShipAccountId',this.selectedShipAccountId);
                input.checked = false;
                this.handlechangemethod();
            }
        });
        }
        else {
            this.selectedShipAccountId = '';
        }
  }
  handlechangemethod(){
        if (this.selectedShipAccountId) {
        console.log('highlightsection');
        const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
        shippingInputs.forEach(input => {
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
    if(this.totalShipToRecords > 0){
    this.selectedShipAccount = this.filteredresultt[0].AccShipId;
    }

    }

    // Mutliaddreess code end 

// added by sudha // Custom ReportCode W-014819 //

    connectedCallback() {
        this.loadReportOptions();

//added by zubiya for quick report
if(this.decodedValues !=null){
    console.log('this.decodedValues ',this.decodedValues );
    let Search = this.decodedValues.Search;
    console.log('decodedValues',this.decodedValues);
    this.SearchByvalue = Search;
    // let even = { target: { value: Search } };
    // this.handleSearchOptionChange(even);

    this.runreportDisabled = false;
    this.runreporthander();  
}


    }
 @track optionsMap = new Map(); 
 @track customReportDescription='';
    // loadReportOptions() {
    //     getReportOptions()
    //         .then(result => {
    //             this.SearchByOptions = JSON.parse(result).map(option => {
    //                 return { label: option.label, value: option.value,description: option.description };
    //             });
               
    //         })
    //         .catch(error => {
    //             console.error('Error fetching metadata options', error);
    //         });
    // }
    loadReportOptions() {
        getReportOptions()
            .then(result => {
                const options = JSON.parse(result);
                console.log(options);
                this.SearchByOptions = options.map(option => {
                    return { label: option.label, value: option.value };
                });
                   options.forEach(option => {
                
                this.optionsMap.set(option.value, {
                    description: option.description,
                    source: option.source,
                    originalReportType : option.originalReportType
                   // originalReportType = option.originalReportType
            
            });
        })
                  console.log('optionsMap contents:', Array.from(this.optionsMap.entries()));
            })
              
            .catch(error => {
                console.error('Error fetching report options', error);
            });
            console.log("Loaded options:", JSON.stringify(this.SearchByOptions));

// Inside your setDescription method, add logs to trace the values:
console.log("Searching for value:", this.SearchByvalue);
console.log("Available options:", JSON.stringify(this.SearchByOptions));
    }

    handleSearchOptionChange(event) {
        this.SearchByvalue = event.detail.value;
          const selectedOption = this.optionsMap.get(this.SearchByvalue); 
          console.log('selectedOption:', this.SearchByvalue);
          console.log('selectedOption:', selectedOption);
          
         /* const selectedOption = this.optionsMap.get(this.SearchByvalue);
          if (selectedOption && selectedOption.source === 'custom') {
        this.EditedReportName = `${this.SearchByvalue} [custom]`; 
        console.log('savvascustom', this.EditedReportName);
    } 
     else {
        this.EditedReportName = this.SearchByvalue; // Normal report name for metadata
         console.log('standard', this.EditedReportName);
    }*/
    if (selectedOption) {
          console.log('iuselectedOption:', selectedOption);
        if (selectedOption.source === 'custom') {
            this.EditedReportName = `${this.SearchByvalue} [custom]`;
            this.selectedReportType = `${this.SearchByvalue} [custom]`;
           
            console.log('Custom Report Selected:', this.EditedReportName);
            console.log('Custom Report Selected:', this.selectedReportType);
        } else {
            this.EditedReportName = this.SearchByvalue; 
            console.log('Standard Report Selected:', this.EditedReportName);
        }
    }
      //   this.selectedDescription = this.optionsMap.get(selectedValue) || 'No description available';
        //this.EditedReportName = this.SearchByvalue;
        if (this.SearchByvalue && this.SearchByvalue.trim() !== '') {
            this.SelectedValue = true;
            this.viewSampleDisabled=false;
            this.deletereportDisabled=true;
            this.editcriteriaDisabled=false;
            this.runreportDisabled=false
        } else {
            this.SelectedValue = false;
        }
        this.setDescription();
    }
   /* setDescription() {
        switch (this.SearchByvalue) {
            case 'Order Status Report – Summary':
                this.Description = scc_OrderStatusReportSummary;
                break;
            case 'Order Status Report – Detail':
                this.Description = scc_OrderStatusReportDetail;
                break;
            case 'Order Status Report – Tracking':
                this.Description = scc_OrderStatusReportTracking;
                break;
            case 'Custom Report':
                this.Description = 'Description for Custom Report';
                break;
            default:
                this.Description = '';
        }
    }*/
    @track originalReportType='';
     setDescription() {
        const standardDescriptions = {
            'Order Status Report – Summary': scc_OrderStatusReportSummary,
            'Order Status Report – Detail': scc_OrderStatusReportDetail,
            'Order Status Report – Tracking': scc_OrderStatusReportTracking
        };

        if (standardDescriptions[this.SearchByvalue]) {
            // Set the description from the predefined list if it matches
            this.Description = standardDescriptions[this.SearchByvalue];
        } //else {
           //console.log('searchedoptionfrom else',this.SearchByvalue);
          // const selectedOption = this.optionsMap.find(option =>
            //option.label.trim().toLowerCase() === this.SearchByvalue.trim().toLowerCase()
    
    //);
// @track customReportDescription='';
//     else {
//          const selectedOption = this.optionsMap.get(this.SearchByvalue); 
//         console.log('searchedoptionfrom else',this.SearchByvalue);
//         // Directly use the value to get the description from optionsMap
//         // this.Description = this.optionsMap.get(this.SearchByvalue) || 'No description available';
//         console.log('Set description from optionsMap:', this.Description);
//     }
// //console.log('searchedoptionfrom else',selectedOption);
// this.Description = selectedOption ? selectedOption.description : '';
//         }
else {
        // If no standard description, try to get from optionsMap
        const selectedOption = this.optionsMap.get(this.SearchByvalue);
        if (selectedOption) {
            this.Description = selectedOption.description;
            this.customReportDescription= selectedOption.description;
            this.originalReportType = selectedOption.originalReportType
                console.log('Custom Description Set from optionsMap:', this.Description);
                console.log('Custom originalReportType :', this.originalReportType);
        } else {
            this.Description = 'No description available'; 
                console.log('No description found for:', this.SearchByvalue);
        }
    }
     }
    
    viewSamplehander(){
        this.mainPage=false;
        this.isSelectedviewsample =true;
        
         this.showpageopen=false
         const selectedOption = this.optionsMap.get(this.SearchByvalue); 
          if (selectedOption.source === 'custom') {
            this.EditedReportName = `${this.SearchByvalue} [custom]`;
            this.selectedReportType = `${this.SearchByvalue} [custom]`;
           
            console.log('Custom Report Selected:', this.EditedReportName);
            console.log('Custom Report Selected:', this.selectedReportType);
            }else{
        this.selectedReportType=this.SearchByvalue;
            }
        console.log('viewSamplehander',this.selectedReportType);
        console.log(this.SearchByvalue);
    }
    runreporthander(){
    this.mainPage=false;
    this.isSelectedviewsample =true;
    const selectedOption = this.optionsMap.get(this.SearchByvalue); 
          if (selectedOption.source === 'custom') {
            this.EditedReportName = `${this.SearchByvalue} [custom]`;
            this.selectedReportType = `${this.SearchByvalue} [custom]`;
           
            console.log('Custom Report Selected:', this.EditedReportName);
            console.log('Custom Report Selected:', this.selectedReportType);
            }else{
        this.selectedReportType=this.SearchByvalue;
            }
    this.detailpageopen=true;
    this.showpageopen=this.detailpageopen;
    //this.selectedReportType= this.SearchByvalue;
    console.log( 'SHOW',this.showpageopen);
    console.log(  'REPORT',this.selectedReportType);
    }
editcriteriahander(){
    this.editCriteria=true
      this.mainPage=false;
      console.log('EditedReportName',this.EditedReportName);

}
    handleClose(event) {
    this.mainPage=true
    console.log('Handle close event');
    this.SearchByvalue = event.detail.value; // Update the dropdown value
    this.isSelectedviewsample = false;
    console.log('Updated SearchByvalue:', this.SearchByvalue);
  }
   handleDetailClose(event) {
        // Handle the detail close event, which does not send any value// for runreport 
        console.log('Detail closed');
        // Reset to initial state or handle as necessary
        this.msgfromc = event.detail.cmsg;
         console.log('Detail closed',this.msgfromc);
        this.mainPage = true; 
         this.SearchByvalue='';
         this.Description ='';
         this.SelectedValue='';
         this.showpageopen=false;
        this.viewSampleDisabled = true;
    this.deletereportDisabled = true
    this.editcriteriaDisabled = true;
    this.runreportDisabled = true
    this.editCriteria=false;
    this.detailpageopen=false;
        this.isSelectedviewsample = false;
        this.dispatchEvent(new RefreshEvent());
         
    }
    @track originalReportTypefromEdit='';
    handleDataRetrieved(event){
    this.isSelectedviewsample=true;
    this.msgfromc=true;
      const fetchedRecords = event.detail.results;
      this.selectedReportType=event.detail.editedreport;
      this.originalReportTypefromEdit=event.detail.originalReportType;

            this.records = fetchedRecords;
     console.log('recived handleDataRetrieved ');
}
handleOpen(){
        console.log('handleDataRetrieved 5');
       
       this.mainPage = true; 
         this.SearchByvalue='';
         this.Description ='';
         this.SelectedValue='';
         this.showpageopen=false;
        this.viewSampleDisabled = true;
    this.deletereportDisabled = true
    this.editcriteriaDisabled = true;
    this.runreportDisabled = true
        this.isSelectedviewsample = false;
        this.editCriteria=false;
        this.msgfromc=false;
         
   
    

    }
    handleEmailSent(){
        this.isSelectedviewsample = false;
        this.editCriteria = false;
        this.showMultiAddressPage = false;
        this.mainPage = true;
        this.isEmailSent = true;
        this.SearchByvalue = '';
        this.SelectedValue = false;
        this.viewSampleDisabled = true;
        this.runreportDisabled = true;
        this.editcriteriaDisabled = true;
    }
}