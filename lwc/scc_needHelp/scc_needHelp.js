/*********************************************************
  Component Name       : scc_needHelp
  Created Date         : 06/09/2024  
  Author               : Cognizant
  Description          : This component used in Home page to render the other apps links for login user.
  Modifications Log
  06/09/2024      Monami             Initial Version
*********************************************************/
import { LightningElement,track,wire } from 'lwc';
import scc_need_help_icon from "@salesforce/resourceUrl/scc_need_help_icon";
import checkSIOPWorkTextUser from '@salesforce/apex/scc_checkSIOPRegistration.checkSIOPWorkTextUser'; 
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
import scc_needHelpFAQ from "@salesforce/label/c.scc_needHelpFAQ";
import scc_needHelpFAQLink from "@salesforce/label/c.scc_needHelpFAQLink";
import scc_header_WorkText_TX_URL from "@salesforce/label/c.scc_header_WorkText_TX_URL";
import scc_header_Workbook_URL from "@salesforce/label/c.scc_header_Workbook_URL";
import scc_header_FAQ_URL from "@salesforce/label/c.scc_header_FAQ_URL";
import scc_needHelpSiteTraining from "@salesforce/label/c.scc_needHelpSiteTraining";
import scc_needHelpContactMysavvasOrders from "@salesforce/label/c.scc_needHelpContactMysavvasOrders";
import scc_needHelpContactCustomer from "@salesforce/label/c.scc_needHelpContactCustomer";
import scc_otherAppsWorktextNational from "@salesforce/label/c.scc_otherAppsWorktextNational";
import scc_needHelpWorktext from "@salesforce/label/c.scc_needHelpWorktext";
import scc_otherAppsSIOP from "@salesforce/label/c.scc_otherAppsSIOP";
import scc_workbooks from "@salesforce/label/c.scc_workbooks";
import scc_novels from "@salesforce/label/c.scc_novels";
import scc_header_SIOP_Registration_URL from "@salesforce/label/c.scc_header_SIOP_Registration_URL";
import scc_header_WorkText_National_URL from "@salesforce/label/c.scc_header_WorkText_National_URL";
import {NavigationMixin} from 'lightning/navigation';
import validateCartsData from '@salesforce/apex/scc_headerLWC_Controller.validateCartsData';
import changeActiveCartAsSecondary from '@salesforce/apex/scc_changeCartAsSecondary.changeActiveCartAsSecondary';
import changeHeldToActiveCart from '@salesforce/apex/scc_changeCartAsSecondary.changeHeldToActiveCart';
import scc_contactCustomerSupport from "@salesforce/label/c.scc_contactCustomerSupport";
import scc_header_LICALL_Link from "@salesforce/label/c.scc_header_LICALL_Link";
import scc_header_LICALL_URL from "@salesforce/label/c.scc_header_LICALL_URL";
import scc_LICALL_Dealers from "@salesforce/label/c.scc_LICALL_Dealers";
import {publish,MessageContext} from "lightning/messageService";
import cartChanged from "@salesforce/messageChannel/lightning__commerce_cartChanged";
import scc_MessageChannel from '@salesforce/messageChannel/scc_MessageChannel__c';
import scc_header_Novel_TX_ONLY_URL from "@salesforce/label/c.scc_header_Novel_TX_ONLY_URL";
import scc_needHelpContactEmail from '@salesforce/label/c.scc_needHelpContactEmail';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
export default class Scc_needHelp extends NavigationMixin(LightningElement) {
@track isOpen = false; 
@track isOpenOtherApps =false;
@track showSIOP = false;
@track accountID;
@track cartID;
@track token;
@track updatedAccountID;
@track showWorkTextNational = false;
@track accType = '';
@track isLicall = false;
@track productsInCart;
@track enableLogs = false;
labels = {
    scc_need_help_icon,scc_header_SIOP_Registration_URL,
    scc_needHelpFAQ,
    scc_needHelpSiteTraining,
    scc_needHelpContactMysavvasOrders,
    scc_needHelpContactCustomer,
    scc_otherAppsWorktextNational,
    scc_needHelpWorktext,
    scc_otherAppsSIOP,
    scc_workbooks,
    scc_novels,
    scc_needHelpFAQLink,
    scc_header_WorkText_National_URL,
    scc_header_WorkText_TX_URL,
    scc_header_Workbook_URL,
    scc_header_FAQ_URL,
    scc_contactCustomerSupport,
    scc_header_LICALL_URL,
    scc_header_LICALL_Link,
    scc_header_Novel_TX_ONLY_URL,
    scc_LICALL_Dealers,
    scc_needHelpContactEmail
}
    @wire(MessageContext) messageContext;
    constructor() {
        super();
        if(sessionStorage.getItem('accounID') !=null && sessionStorage.getItem('CartId') !=null && sessionStorage.getItem('Token') !=null){
            this.validateCart();
        }
    }
   connectedCallback(){
    getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
    checkSIOPWorkTextUser() 
      .then(data => { 
          for(let i=0; i<data.length; i++){
              if(data[i].PermissionSet.Name == 'Savvas_SIOP_Permissions'){
                  this.showSIOP = true;
              }
              if(data[i].PermissionSet.Name == 'Savvas_Worktext_Subscription_Permissions'){
                this.showWorkTextNational = true;
              }
          }
      }) 
      .catch(error => { 
          if (this.enableLogs) console.log(error); 
      }) 
        getUserInformation().then(response => {
            let paser = JSON.parse(response);
            let data = paser[0];
            this.accType = data.accountType;
            if(this.labels.scc_LICALL_Dealers.includes(this.accType)){
                this.isLicall = true;
            }
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        })
      this.template.addEventListener('keydown', this.handleKeydown.bind(this));
      setTimeout(() => {
        this.template.querySelector('.otherAppMenu li:first-child a').setAttribute("tabindex", "0");
      }, 5000);
   }
   disconnectedCallback() {
    this.template.removeEventListener('keydown', this.handleKeydown);
  }
  handleKeydown(event) {
    if (event.key === 'Escape') {
        if(this.template.querySelector('.need-help-nav').classList.contains('isOpen')){
            this.hideDropdown();
            this.template.querySelector('.need-help-nav button').focus();
        }
        else if(this.template.querySelector('.other-apps-nav').classList.contains('isOpen')){
            this.hideDropdownOtherApps();
            this.template.querySelector('.other-apps-nav button').focus();
        }
    }
  }
   validateCart(){   
        this.accountID = sessionStorage.getItem('accounID');
        this.cartID = sessionStorage.getItem('CartId');
        this.token = sessionStorage.getItem('Token');   
        validateCartsData({accountID:this.accountID,cartID:this.cartID,Token:this.token})
        .then((result) => {
                result = JSON.parse(result);
                this.updatedAccountID = result.accountId;
                this.productsInCart = result.cartQuantity;
                this.changeToCurrentCart();
        })
        .catch((error) => {
            if (this.enableLogs) console.log('error',error);
        })     
   }
   changeToCurrentCart(){
        changeActiveCartAsSecondary({ activeAccountId: this.updatedAccountID })
        .then(result => {
            sessionStorage.setItem('UserFromOtherSide', true);
            changeHeldToActiveCart({ cartId:  this.cartID }).then(response => {
                })
                .catch(error => {
                    if (this.enableLogs) console.log('the error is',error);
                })
                this.navigateCheckBillingAdresses();     
        })
        .catch(error => {
            if (this.enableLogs) console.log('the error is',error)
        })
        .finally(() => {
        });
   }
   navigateCheckBillingAdresses(){
                this[NavigationMixin.Navigate] ({
                    type: 'comm__namedPage',
                    attributes: {
                            name : 'Place_Order__c',  
                    }
                    })
                    publish(this.messageContext, scc_MessageChannel, { cartCount:this.productsInCart}); 
   }
   toggleDropdown() {
       this.template.querySelector('.need-help-nav').classList.toggle('isOpen');
       this.isOpen = !this.isOpen;
   }
   hideDropdown(){
      this.template.querySelector('.need-help-nav').classList.remove('isOpen');
      this.isOpen = false;
   }
   showDropdown(){
    this.template.querySelector('.need-help-nav').classList.add('isOpen');
    this.isOpen = true;
   }
   toggleDropdownOtherApps(){
       this.template.querySelector('.other-apps-nav').classList.toggle('isOpen');
       this.isOpenOtherApps = !this.isOpenOtherApps;
   }
   hideDropdownOtherApps(){
      this.template.querySelector('.other-apps-nav').classList.remove('isOpen');
      this.isOpenOtherApps = false;
   }
   showDropdownOtherApps(){
      this.template.querySelector('.other-apps-nav').classList.add('isOpen');
      this.isOpenOtherApps = true;
   }
   handleFirstMenuClick(e){
    if(e.key === 'Tab'){
        this.hideDropdown();
    }else{
        this.handleUpDownClick(e);
    }
   }
   otherappFirstLinkClick(e){
    if(e.key === 'Tab'){
        this.hideDropdownOtherApps();
    }else{
        this.handleUpDownClick(e);
    }
   }
   handleUpDownClick(event){
        if(event.key === 'ArrowDown' || event.key === 'ArrowRight'){
            if(event.target.parentNode.nextSibling != null){
                event.target.parentNode.nextSibling.children[0].focus();
                event.preventDefault();
            }else{
                event.preventDefault();
              }
        }else if(event.key === 'ArrowUp'){
            if(event.target.parentNode.previousSibling != null){
                event.target.parentNode.previousSibling.children[0].focus();
                event.preventDefault();
            }else{
                event.preventDefault();
              }
        }else if(event.key === 'Tab'){
            this.hideDropdown();
        }
   }
   handleUpDownClickOtherApps(event){
        if(event.key === 'ArrowDown' || event.key === 'ArrowRight'){
            if(event.target.parentNode.nextSibling != null){
                event.target.parentNode.nextSibling.children[0].focus();
                event.preventDefault();
            }else{
                event.preventDefault();
              }
        }else if(event.key === 'ArrowUp'){
            if(event.target.parentNode.previousSibling != null){
                event.target.parentNode.previousSibling.children[0].focus();
                event.preventDefault();
            }else{
                event.preventDefault();
              }
        }else if(event.key === 'Tab'){
            this.hideDropdownOtherApps();
        }
   }
    handleNeedHelp()
    {
         this[NavigationMixin.Navigate] ({
        type: 'comm__namedPage',
        attributes: {
                name : 'FAQ__c'  
        },
        })
    }
    handleSiteTraining(){
        this[NavigationMixin.Navigate] ({
        type: 'comm__namedPage',
        attributes: {
                name : 'SiteTraining__c'  
        },
        })
    }
    handleEmailClick(event) {
    event.preventDefault();
    window.open(this.labels.scc_needHelpContactEmail, '_blank');
    }

    handleCreateCase(){
        this[NavigationMixin.Navigate] ({
            type: 'comm__namedPage',
            attributes: {
                    name : 'Create_mySavvas_Order_Case__c'  
                    
            },
            })
    }
}