/*
Lightning Web component: Scc_signInLWC
Author: CTS (Suresh Kalshetti)
Created Date: 03/04/2024
Reason: Backend logic for Scc_signInLWC
Modified Date: 16/04/2024
*/
/*********************************************************
  Component Name       : scc_signInLWC
  Created Date         : 06/10/2024  
  Author               : Cognizant 
  Description          : This component used in Login page the OOB features have been 
                         implemented to existing component to enhance login page functionality.
  Modifications Log
  06/10/2024      Monami           Initial Version
*********************************************************/

import { LightningElement,track,wire} from 'lwc';
import signIn from '@salesforce/apex/scc_signInLWCController.signIn';
import scc_signIn_Error_Message from '@salesforce/label/c.scc_signIn_Error_Message';
import scc_forgot_Password_Text from '@salesforce/label/c.scc_forgot_Password_Text';
import scc_new_User_Text from '@salesforce/label/c.scc_new_User_Text';
import scc_forgot_Password_Url from '@salesforce/label/c.scc_forgot_Password_Url';
import scc_self_Register_Url from '@salesforce/label/c.scc_self_Register_Url';
import scc_signIn from '@salesforce/label/c.scc_signIn';
import scc_username_Text from '@salesforce/label/c.scc_username_Text';
import scc_password_Text from '@salesforce/label/c.scc_password_Text';
import scc_signIn_No_SignIn_Text from '@salesforce/label/c.scc_signIn_No_SignIn_Text';
import scc_signIn_Order_Status_Text from '@salesforce/label/c.scc_signIn_Order_Status_Text';
import scc_signIn_Access_Code_Text from '@salesforce/label/c.scc_signIn_Access_Code_Text';
import scc_signIn_View_Invoice_Text from '@salesforce/label/c.scc_signIn_View_Invoice_Text';
import scc_signIn_SignIn_Text from '@salesforce/label/c.scc_signIn_SignIn_Text';
import scc_signIn_Dealer_Title from '@salesforce/label/c.scc_signIn_Dealer_Title';
import scc_signIn_Homeschool_Text from '@salesforce/label/c.scc_signIn_Homeschool_Text';
import scc_signIn_Private_Student_Text from '@salesforce/label/c.scc_signIn_Private_Student_Text';
import scc_signIn_Other_Student_Text from '@salesforce/label/c.scc_signIn_Other_Student_Text';
import scc_signIn_Footer_Text from '@salesforce/label/c.scc_signIn_Footer_Text';
import scc_signIn_Footer_Savvas_Support from '@salesforce/label/c.scc_signIn_Footer_Savvas_Support';
import scc_signIn_Footer_Terms_Text from '@salesforce/label/c.scc_signIn_Footer_Terms_Text';
import scc_signIn_Footer_Privacy_Text from '@salesforce/label/c.scc_signIn_Footer_Privacy_Text';
import scc_ipAddress_openApiEndpoint from '@salesforce/label/c.scc_ipAddress_openApiEndpoint';
import checkIpAddress from '@salesforce/apex/scc_IPAddressCheck.checkIpAddress';
import backgroundImage from "@salesforce/resourceUrl/scc_landingpage_bgimage";
import { CurrentPageReference } from 'lightning/navigation';
import {NavigationMixin} from 'lightning/navigation';
import scc_brand_logo_mobile from "@salesforce/resourceUrl/scc_brand_logo_mobile";
import backgroundImageMobile from "@salesforce/resourceUrl/scc_landingpage_bgimage_mobile";
import fetchCartDetailsGA from '@salesforce/apex/scc_googleAnalyticsController.fetchCartDetailsGA';
import getCartItemsGA from '@salesforce/apex/scc_googleAnalyticsController.getCartItemsGA';
//import { CurrentPageReference } from 'lightning/navigation';

//export default class Scc_signInLWC extends LightningElement {
export default class Scc_signInLWC extends NavigationMixin(LightningElement) {
  

     // Properties
    @track username=''; //Input username from user
    @track password;  // Input password from user
    errorCheck = false; //assigning default value for error
    @track openAccessCodeModal = false;
    @track openSIOPModal = false;
    @track scc_signIn_Error_Message; 
    @track isSignInDisabled= true; //Assigning value for Signin button
    @track rememberMeChecked = false;  //Handling remember me checkbox value
    @track openOrderStatusModal = false;
    @track openViewInvoice = false;
    @track isChecking = true;
    @track isLoading = true;
    @track accounID='';
    @track cartId ='';
    @track token = '';
    @track orderItemList=[];
    @track shippingAmount = 'N/A';
    @track siteId = "";
    @track taxAmount = 'N/A';
    @track customCartId="";
    @track siteName = "";
    @track subTotalPrice = "";
    @track promoCode = "";
    @track discountValue = "";
    @track totalPrice = "";
    @track rememberMeSessionValue='';
    @track userNameValue='';
    @track createCase='/MySavvasOrders/CreateCase';
    
    //Importing labels from Salesforce org
    labels = {
      scc_signIn_Error_Message,
      scc_forgot_Password_Text,
      scc_new_User_Text,
      scc_forgot_Password_Url,
      scc_self_Register_Url,
      scc_signIn,
      scc_username_Text,
      scc_password_Text,
      scc_signIn_No_SignIn_Text,
      scc_signIn_Order_Status_Text,
      scc_signIn_Access_Code_Text,
      scc_signIn_View_Invoice_Text,
      scc_signIn_SignIn_Text,
      scc_signIn_Dealer_Title,
      scc_signIn_Homeschool_Text,
      scc_signIn_Private_Student_Text,
      scc_signIn_Other_Student_Text,
      scc_signIn_Footer_Text,
      scc_signIn_Footer_Savvas_Support,
      scc_signIn_Footer_Terms_Text,
      scc_signIn_Footer_Privacy_Text,
      scc_ipAddress_openApiEndpoint,
      scc_brand_logo_mobile
      };

     
       get backgroundImageStyle() {
        return this.isMobileView() 
            ? `background-image: url(${backgroundImageMobile});` 
            : `background-image: url(${backgroundImage});`;
      }

      isMobileView() {
        return window.innerWidth <= 768; 
      }

      @wire(CurrentPageReference)
       setCurrentPageRef(pageRef) {
    
    
        if (pageRef.state.Source) {
            
            this.source = pageRef.state.Source;
            if(this.source == 'showOrderSearch'){            
              this.openOrderStatusModal = true;
             
            }
        }    

      this.rememberMeSessionValue = sessionStorage.getItem('rememberMeChecked');
      this.userNameValue =  sessionStorage.getItem('rememberMeCheckedUserName');
      if(this.rememberMeSessionValue == true || this.rememberMeSessionValue == 'true' ){
          this.rememberMeChecked = true;
          this.username =   this.userNameValue;
         
      }        
     }

   
    // Lifecycle Hook: Rendered Callback
    renderedCallback(){
      if(this.username == null ) //Callback of username field from saved cookies.
        this.getcookiedata();
         //   window.location.reload();
    }
    
    showAccessCodeModal() {
        this.openAccessCodeModal = true;
    }

    showSIOPModal() {
      this.openSIOPModal = true;
    }

    showViewInvoiceModal()
    {
      this.openViewInvoice = true;
    }

    showOrderStatusModal(){
      this.openOrderStatusModal = true;
    }
    // Lifecycle Hook: Connected Callback
    async connectedCallback(){
           // window.location.reload();
        const urlParams = new URLSearchParams(window.location.search);

        await fetch(scc_ipAddress_openApiEndpoint,{method:'GET'})
        .then(resp => resp.json())
        .then(resp=>{
            this.ipAddress = resp.ip;
 
            checkIpAddress({guestUserIpAddress:this.ipAddress}).then(result=>{
       
              if(result){
               
                this.isLoading = false;
              }
              else{
                
                this.isChecking = false;
              }
           });
        });
        var meta = document.createElement("meta");
        meta.setAttribute("name", "viewport");
        meta.setAttribute("content", "width=device-width, initial-scale=1.0");
        document.getElementsByTagName('head')[0].appendChild(meta);
        //To bye pass catche
        sessionStorage.setItem('UserFromOtherSide','false');
        //changes W-016271 from currentpage reference to urls params method
        if(urlParams.get('aid') !=undefined && urlParams.get('aid') !=null){
          this.accounID = urlParams.get('aid');
          sessionStorage.setItem('accounID',this.accounID);
        }
        if(urlParams.get('CartId') !=undefined && urlParams.get('CartId') !=null){
          this.cartId = urlParams.get('CartId');
          sessionStorage.setItem('CartId',this.cartId);
        }
        if(urlParams.get('Token') !=undefined && urlParams.get('Token') !=null){
          this.token = urlParams.get('Token');
          sessionStorage.setItem('Token',this.token);
         
        }
  
        //GA implementation starts
      if(this.cartId!='' && this.cartId!=undefined){
        //this.dispatchGARecords();
        await getCartItemsGA({cartId:this.cartId
        }).then(response => {
         
          for(let k of response){
               
                this.orderItemList.push({
                    ISBN10: k.Product2.ISBN10__c,
                    ISBN13: k.Product2.ISBN13__c,
                    categoryId: "",
                    categoryName: "",
                    productID: "",
                    productName: k.Product2.Name,
                    productSAPName: "",
                    programId: "",
                    programName: k.Product2.MasterProgram__c,
                    programURL: "",
                    quantity: k.Quantity,
                    shippingCharges: "",
                    subTotal: "",
                    taxes: "",
                    totalPrice: ""
                })
                            
          }
        }).catch(error => {
           
           })
        fetchCartDetailsGA({cartId: this.cartId})
           .then( response => {
        
            this.customCartId = response.CartId?response.CartId:"";
            this.siteId = response.SiteId?response.SiteId:"";
            this.siteName = response.SiteName?response.SiteName:"";
            this.subTotalPrice = response.SubTotal && response.SubTotal !=0  ? '$ '+response.SubTotal : '$ 0.00';
            this.promoCode = response.Coupon ? response.Coupon : '';
            this.discountValue = response.CouponDiscount  && response.CouponDiscount !=0 ? '-$ '+(response.CouponDiscount).replace('-','') : '$ 0.00';
            this.shippingAmount = response.ShippingAmount && response.ShippingAmount !=0 ? '$ '+response.ShippingAmount : 'N/A';
            this.taxAmount = response.Tax && response.Tax !=0 ? '$ '+response.Tax : 'N/A';
            this.totalPrice =  response.Total && response.Total !=0  ? '$ '+response.Total : '$ 0.00';
            this.dispatchGARecords(null);
        })
        .catch(error => {
           
        })
    }
    this.dispatchGARecords();
        //GA implementation ends
 
    //to catch escape keypress for accessibility
    
     this.template.addEventListener('keydown', this.handleKeydown.bind(this));

    }

    disconnectedCallback() {
      // Remove the keydown event listener when the component is removed from the DOM
      this.template.removeEventListener('keydown', this.handleKeydown);
    }
     @track terms ='/MySavvasOrders/terms-and-conditions';
    @track privacy='/MySavvasOrders/privacy';
  get dynamicprivacy(){
    const baseUrl = window.location.origin;
    return baseUrl+this.privacy;
  }
  get dynamicurl(){
    const baseUrl = window.location.origin;
    return baseUrl+this.terms;
  }

  get createCase(){
    const baseUrl = window.location.origin;
    return baseUrl+this.createCase;
  }

    dispatchGARecords(){
      this.dispatchEvent(new CustomEvent("placeorderdata",{
              detail:{
                  cart:{
                      cartId:this.cartId,
                      orderId:"",
                      shippingCharges: this.shippingAmount,
                      subTotal: this.subTotalPrice,
                      taxes: this.taxAmount,
                      totalPrice: this.totalPrice
                  },
                  form:{
                      formId: "",
                      formKeycode: "",
                      formName: "",
                      pid: ""
                  },
                  institution:{
                      InstitutionID: "",
                      InstitutionName: this.institutionName?this.institutionName:"",
                      InstitutionType: this.institutionType?this.institutionType:""
                  },
                  page:{
                      breadcrumb: "Login Page",
                      currentPromoCode: this.promoCode,
                      currentPromoDescription: this.promoCode?"Promo "+this.promoCode+" is applied.":"",
                      locator: "",
                      pageId: "",
                      pageName: "Login Page",
                      pageType: ""
                  },
                  pmdb:{
                      categoryId: "",
                      programId: "",
                      siteId: "",
                      solutionId: "",
                      subCategoryId: "",
                      subSolutionId: "",
                      subjectAreaId: ""
                  },
                  products:this.orderItemList,
                  program:{
                      programInfo:"",
                      categoryID: "",
                      categoryName: "",
                      programId: "",
                      programName: "",
                      programURL: ""
                  },
                  site:{
                      siteCategory: "",
                      siteDomain: "",
                      siteFamilyName: "",
                      siteId: this.siteId,
                      siteName: this.siteName
                  }
              }
      }));
    }

    //close popup when user press escape key -accessibility
    handleKeydown(event) {
      // Handle the keydown event
      if (event.key === 'Escape') {
         
          if(this.openOrderStatusModal){
            this.closeOrderStatusModal();
          }
          if(this.openAccessCodeModal){
            this.closeaccessmodalpopup();
          }
          if(this.openSIOPModal){
            this.closesiopmodalpopup();
          }
          if(this.openViewInvoice){
            this.closeviewinvoice();
          }
      }
    }
      
    //Method to handle Username change
      handleUserNameChange(event){
        
        this.username = event.target.value;
        this.signInCheck();
        if(this.rememberMeChecked == true){
              sessionStorage.setItem('rememberMeCheckedUserName',  this.username);
        }
      }
 
    //Method to handle Password change
      handlePasswordChange(event){
        
        this.password = event.target.value;
        this.signInCheck();
      }
    
    //handling Sign In button enable function.
     signInCheck(){
               if((this.username != undefined) && (this.password != undefined)){
                  this.isSignInDisabled =false ;
                }if((this.username == undefined ||this.username== '') || (this.password == undefined || this.password == '')){
                   this.isSignInDisabled =true ;
                }
        }

    //Method for Login logic
    handleLogin(event){
      if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
       if(this.username && this.password){

        event.preventDefault();
        //signIn({ username: this.username, password: this.password,accounID:this.accounID,cartId:this.cartId,token:this.token })
        signIn({ username: this.username, password: this.password})
            .then((result) => {
            
              window.location.href = result; // assign the result from apex class
              //window.open(result+'place-order');
            })
              //if user credential are wrong will throw custom error message
             .catch((error) => {
                this.error = error;     
                this.errorCheck = true;
                this.scc_signIn_Error_Message = error.body.message;
            });

        }
      }else{
        this.template.querySelector('.username-input').focus();
        event.preventDefault();
      }

    }
    // fetching Remember me checkbox value 
    handleChange(event) {
        this.rememberMeChecked = event.target.checked;
     
     if(this.rememberMeChecked == true ){
        sessionStorage.setItem('rememberMeChecked', 'true');
        sessionStorage.setItem('rememberMeCheckedUserName',  this.username);
       
     }
     else{
        sessionStorage.setItem('rememberMeChecked', '');
        sessionStorage.setItem('rememberMeCheckedUserName', '');
       
     }
            
    }

    //Creating a username cookie on browser
    setCookie() {
         var u = this.template.querySelector('[data-name="inputUsername"]').value;

        document.cookie='myUsername='+ u +';path=/'; //storing username in cookies
        
      }

    getcookiedata(){
        const cookies = document.cookie;
         window.setTimeout(() => {
          var user = this.getCookie('myUsername');
         }, 500);
    }
   
    // Calling saved cookie data on page load
    getCookie(cname){
        var name = cname +"=";
        var decodeCookie = decodeURIComponent(document.cookie);
        var ca = decodeCookie.split(';');

        for (let i = 0; i < ca.length; i++) {
            let cookiePair = ca[i].trim();
            if (cookiePair.startsWith('myUsername=')) {
              let value = cookiePair.substring('myUsername='.length);
              this.username = value;
              this.template.querySelector('[data-name="inputUsername"]').value=value;
              return value;
            }
          }
        return "";
    }
    
    
    closeaccessmodalpopup(){
     this.openAccessCodeModal = false;
     const button1 = this.template.querySelector(".guestAccessCodeLink");
      if(button1){
        setTimeout(() => {
          button1.focus();
        }, 100);
      }
    }

    closesiopmodalpopup(){
      this.openSIOPModal = false;
      const button2 = this.template.querySelector(".guestSiopLink");
      if(button2){
        setTimeout(() => {
          button2.focus();
        }, 100);
      }
     }

     closeviewinvoice()
     {
      this.openViewInvoice = false;
      const button3 = this.template.querySelector(".guestInvoiceLink");
      if(button3){
        setTimeout(() => {
          button3.focus();
        }, 100);
      }
     }

     closeOrderStatusModal(){
      this.openOrderStatusModal = false;
      const button = this.template.querySelector(".guestOrderStatusLink");
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }
     }


}