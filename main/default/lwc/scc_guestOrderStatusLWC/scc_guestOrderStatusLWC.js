/********************************************************************************************* 
* @Component Name  - Scc_guestOrderStatusLWC
* @description - Order Status for guest users
* @Created By  - CTS - Vaibhav
* @Created On - 06/11/2024 
* ********************************************************************************************/
import { LightningElement,track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import errormsg from '@salesforce/label/c.scc_siopNotValidOrder';
import errorMessageHelp from '@salesforce/label/c.scc_siopErrorMessage';
import getCriteriaOrderdata from '@salesforce/apex/scc_orderStatusLWC_Controller.getCriteriaOrderdata';
import scc_home_Order_Status from "@salesforce/label/c.scc_home_Order_Status";
import scc_home_PO from "@salesforce/label/c.scc_home_PO";
import scc_home_Search_By from "@salesforce/label/c.scc_home_Search_By";
import scc_OrderStatus_Zip_Postal_Code from "@salesforce/label/c.scc_OrderStatus_Zip_Postal_Code";
import scc_OrderStatus_Invoice_Number from "@salesforce/label/c.scc_OrderStatus_Invoice_Number";
import scc_home_Document_Control from "@salesforce/label/c.scc_home_Document_Control";
import scc_guestOrderStatus_Order_not_found from "@salesforce/label/c.scc_guestOrderStatus_Order_not_found";
import scc_guestOrderStatus_Check_Order_Status from "@salesforce/label/c.scc_guestOrderStatus_Check_Order_Status";
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class Scc_guestOrderStatusLWC extends NavigationMixin(LightningElement) {   
  incorrectAttempts = 0;
  @track openModal = true;
  @track closeModall = false;
  @track showerrormsg = false;
  @track showErrorMessage = false;
  @track Zipcode = '';
  @track ordernum = '';
  @track invoiceNum = '';
  @track poNum = '';
  @track isGoDisabled = true;
  errormessage = errormsg;
  errorMessageHelpContact = errorMessageHelp;
  @track SearchByvalue = 'PO#';
  @track SearchByOptions = [{label: 'PO#',value: 'PO#'}, {label: 'Invoice #',value: 'Invoice #'}, {label: 'Order #',value: 'Order #'}];
  @track PONumb = true;
  @track invoiceNumb = false;
  @track orderNumb = false;
  @track isLoading = false;
  @track enableLogs = false;

  labels = {
      scc_home_Search_By,
      scc_home_PO,
      scc_home_Order_Status,
      scc_OrderStatus_Zip_Postal_Code,
      scc_OrderStatus_Invoice_Number,
      scc_home_Document_Control,
      scc_guestOrderStatus_Order_not_found,
      scc_guestOrderStatus_Check_Order_Status
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
      //to catch escape keypress for accessibility
      this.template.addEventListener('keydown', this.handleKeydown.bind(this));
  }

  disconnectedCallback() {
      // Remove the keydown event listener when the component is removed from the DOM
      this.template.removeEventListener('keydown', this.handleKeydown);
  }

  isRenderedCallbackCalled = false
  renderedCallback() {
      if(this.isRenderedCallbackCalled == false) {
          const closeBtn = this.template.querySelector(".guestOrderStatusClose");
          closeBtn.focus();
          this.isRenderedCallbackCalled = true;
      }
  }

  get SearchByOptions() {
      return this.SearchByOptions;

  }

  get OrderStatusOptions() {
      return this.OrderStatusOptions1;
  }

  handleSearchOptionChange(event) {
      this.SearchByvalue = event.target.value;
      this.PONumb = false;
      this.invoiceNumb = false;
      this.orderNumb = false;
      this.ordernum = '';
      this.invoiceNum = '';
      this.poNum = '';
      this.showerrormsg = false;

      if(this.SearchByvalue == 'PO#') {
          this.PONumb = true;
      }

      if(this.SearchByvalue == 'Invoice #') {
          this.invoiceNumb = true;
      }

      if(this.SearchByvalue == 'Order #') {
          this.orderNumb = true;
      }

  }

  showModal() {
      this.openModal = true;
  }

  handleZipcodeChange(event) {
      this.Zipcode = event.target.value;
  }

  handleNumChange(event) {
      if(event.target.dataset.id == 'Order#') {
          this.ordernum = event.target.value;
      }

      if(event.target.dataset.id == 'Invoice #') {
          this.invoiceNum = event.target.value;
      }

      if(event.target.dataset.id == 'PO#') {
          this.poNum = event.target.value;
      }
  }

  handleNumChange1(event) {
      this.ordernum = event.target.value;
  }

  handleGo(event) {
      event.preventDefault();
      if(!JSON.parse(event.target.getAttribute('aria-disabled'))) {
          this.handleSearch();
      } else {
          this.template.querySelector('.zipcode-input').focus();
          event.preventDefault();
      }
  }

  handleSearch() {
      this.showerrormsg = false;
      this.isLoading = true; // Start loading
      let SearchByvalue;
      if(this.ordernum != '') {
          SearchByvalue = 'Order #';
      }

      if(this.poNum != '') {
          SearchByvalue = 'PO#';
      }

      if(this.invoiceNum != '') {
          SearchByvalue = 'Invoice #';
      }

      if(this.Zipcode.length < 5) {
          this.showerrormsg = true;
          return '';
      }
      const encodedValues = encodeDefaultFieldValues({
          Search: SearchByvalue,
          PONum: this.poNum,
          ISBnNum: '',
          startDate: null,
          endDate: null,
          OrderStatusValue: '',
          InvoNum: this.invoiceNum,
          ZipNum: this.Zipcode,
          StateNum: '',
          CountryValue: '',
          DocContrNum: this.ordernum
      });


      getCriteriaOrderdata({
          PO: this.poNum.trim(),
          ISBN: '',
          startDate: null,
          endDate: null,
          orderStatus: '',
          OrderNum: this.ordernum.trim(),
          Zip: this.Zipcode.trim(),
          State: '',
          City: '',
          Country: '',
          CustNam: '',
          SAN: '',
          Invo: this.invoiceNum,
          SearchValue: SearchByvalue
      }).then(response => {
          if(this.enableLogs){
              console.log('response is', JSON.parse(response));
          }
          let data = JSON.parse(response);
          if(data.length > 0) {
              this[NavigationMixin.Navigate]({
                  type: 'comm__namedPage',
                  attributes: {
                      name: 'Guest_Order_Status__c' //Api name
                  },
                  state: {
                      defaultFieldValues: encodedValues,
                  }
              })
          } else {
              this.showerrormsg = true;
              setTimeout(() => {
                  this.template.querySelector('.order-not-found-error').focus();
                  setTimeout(() => {
                      this.template.querySelector('.zipcode-input').focus();
                  }, 100);
              }, 100);
              if(this.enableLogs){
                console.log('Order not found');
              }
          }
          let paser = JSON.parse(response);

      }).catch(error => {
          if(this.enableLogs){
              console.log('error is', error);
          }
      }).finally(() => {
          this.isLoading = false;
      });
  }

  get inputsCheck() {
      if((this.Zipcode != '' && this.ordernum != '') || (this.Zipcode != '' && this.invoiceNum != '') || (this.Zipcode != '' && this.poNum != '')) {
          this.isGoDisabled = false;
      } else {
          this.isGoDisabled = true;
      }

      return this.isGoDisabled;
  }

  // To close popup
  closeModal() {
      const sendCustomEventToClosePopup = new CustomEvent("closepopup");
      this.dispatchEvent(sendCustomEventToClosePopup);

  }


  //Trap focus inside modal
  focusOutClose(event) {
      var related = event.relatedTarget;
      if(related != undefined) {
          if(related.getAttribute('data-index') != 0) {
              this.template.querySelector('.siop-modal-button').focus();
          }
      }
  }
  focusOutButton(event) {
      var related = event.relatedTarget;
      if(related != undefined) {
          if(related.getAttribute('data-index') != 0) {
              this.template.querySelector('.guestOrderStatusClose').focus();
          }
      }
  }

  handleKeydown(event) {
      // Handle the keydown event
      if(event.key === 'Escape') {
          if(this.openModal) {
              this.closeModal();
          }
      }
  }
}