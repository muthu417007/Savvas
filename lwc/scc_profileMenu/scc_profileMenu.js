/*********************************************************
Component Name       : scc_profileMenu
Created Date         : 06/09/2024  
Author               : Cognizant
Description          : This component used in Home page and functionality related to Logout and Profile of login user.

Modifications Log
06/09/2024      Monami             Initial Version
*********************************************************/
import { LightningElement, track, wire } from 'lwc';
import scc_profile_avatar from "@salesforce/resourceUrl/scc_profile_avatar"; //Load image from Static Resource
import {NavigationMixin} from "lightning/navigation";
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { getSessionContext } from 'commerce/contextApi';
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import changeIsSecondaryTrue from '@salesforce/apex/scc_changeCartAsSecondary.changeActiveCartAsSecondary';
import getActiveCartCount from '@salesforce/apex/scc_addItemsToCartController.getActiveCartCount';
import getUserInformation  from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
import scc_cartIconHover from "@salesforce/label/c.scc_cartIconHover";
import MESSAGE_CHANNEL from '@salesforce/messageChannel/scc_MessageChannel__c';
import { subscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';

const LOGOUTPAGEREF = {
type: "comm__loginPage",
attributes: {
    actionName: "logout"
}
};

export default class Scc_profileMenu extends NavigationMixin(LightningElement) {

  labels = {
      scc_profile_avatar,
      scc_cartIconHover
  }
  @track enableLogs = false;
  @track isOpen = false;
  @track quantity=0;
  @track isCartEmpty =false;
  @track showBadge = false;
  currentaccountId
  @track userName
  accountName
  carticon = imageIcons + '/Images/cart.png';
  @wire(MessageContext)
  messageContext;

  @wire(getActiveCartCount)
  getCartCount({data, error}) {
    if(data>0){
      this.isCartEmpty =false;
      this.quantity= data;
    }
    else if(data<1){
      this.isCartEmpty =true;
    }
    if(data >= 100)
    {
      this.showBadge = true;
    }else
    {
      this.showBadge = false;
    }
    if(error){
      
      console.log("cart count error ", error);
      
    }
  }
connectedCallback(){
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

    getUserInformation().then(response =>{
         if(this.enableLogs) console.log('Raw response:', response);
    let paser = JSON.parse(response);
    if(this.enableLogs) console.log('Parsed response:', paser);
    let data = paser[0];
    if(this.enableLogs) console.log('Data object:', data);
    this.userName = data.userName;
    if(this.enableLog) console.log('Set username to:', this.userName);
        this.accountName=data.accountName;
        this.currentaccountId = data.accountId;
    }).catch(error =>{
      if(this.enableLogs){
        console.log('error is',error);
      }
    })
    this.subscribeMessageChannel();
    this.template.addEventListener('keydown', this.handleKeydown.bind(this));
}

disconnectedCallback() {
  this.template.removeEventListener('keydown', this.handleKeydown);
}

handleKeydown(event) {
  if (event.key === 'Escape') {
    this.hideDropdown();
    this.template.querySelector('.profile-dropdown button').focus();
  }
}

subscribeMessageChannel() {
      if (this.subscription) {
          return;
      }
      this.subscription = subscribe(
          this.messageContext,
          MESSAGE_CHANNEL,
          
          (message) => { this.handleSubscribeMessage(message) },          
          { scope: APPLICATION_SCOPE }
      );
  }
handleSubscribeMessage(message)
{
this.quantity  = message.cartCount;
if(this.quantity >0)
  {
    this.isCartEmpty = false;
  }
  else if (this.quantity < 1) {
    this.isCartEmpty = true;
  }
  if(this.quantity >= 100)
  {
      this.showBadge = true;
  }else
  {
      this.showBadge = false;
  }
}

get hasItems()
{
  return this.quantity;
}

reviewcart()
{
  if (!JSON.parse(this.template.querySelector('.add-to-cart').getAttribute('aria-disabled'))) {
  const encodedValues = encodeDefaultFieldValues({
           
  });

    this[NavigationMixin.Navigate] ({
      type: 'comm__namedPage',
      attributes: {
              name : 'Place_Order__c'  
      },
      state:{
        defaultFieldValues: encodedValues,
        Source : 'reviewCart'
      }
      })
  }
}
handleProfilePage()
{
  this[NavigationMixin.Navigate] ({
      type: 'comm__namedPage',
      attributes: {
              name : 'profiledetail__c'  
      }
      })
}
  toggleDropdown() {      
      this.template.querySelector('.profile-dropdown').classList.toggle('isOpen');
      this.isOpen = !this.isOpen;      
  }
  hideDropdown(){
    this.isOpen = false;
    this.template.querySelector('.profile-dropdown').classList.remove('isOpen');    
  }
  showDropdown(){
    this.isOpen = true;
    this.template.querySelector('.profile-dropdown').classList.add('isOpen');
    }
    handleSignOut(){
      changeIsSecondaryTrue({ activeAccountId: this.currentaccountId })
          .then(result => {
              
          })
          .catch(error => {
            if(this.enableLogs){
              console.log('the error is',error);
            }
          })
          .finally(() => {
            this[NavigationMixin.Navigate](LOGOUTPAGEREF);
        });
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

  get ariaLabel() {
  return `Review Cart. ${this.quantity} item${this.quantity > 1 ? 's' : ''} in cart`;
  }
  get profileMenuAriaLabel() {
  return `Hi ${this.userName}, Profile`;
  }
}