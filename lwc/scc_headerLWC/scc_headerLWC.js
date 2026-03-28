import { LightningElement,track,wire } from 'lwc';
import {APPLICATION_SCOPE,createMessageContext,MessageContext,publish,releaseMessageContext,subscribe,unsubscribe} from 'lightning/messageService';
import scc_MessageChannel from '@salesforce/messageChannel/scc_MessageChannel__c'; 

import getUserInformation  from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';

import scc_header_Profile from "@salesforce/label/c.scc_header_Profile";
import scc_header_Other_Apps from "@salesforce/label/c.scc_header_Other_Apps";
import scc_header_WorkText_National from "@salesforce/label/c.scc_header_WorkText_National";
import scc_header_WorkText_National_URL from "@salesforce/label/c.scc_header_WorkText_National_URL";
import scc_header_WorkText_TX from "@salesforce/label/c.scc_header_WorkText_TX";
import scc_header_WorkText_TX_URL from "@salesforce/label/c.scc_header_WorkText_TX_URL";
import scc_header_SIOP_Registration from "@salesforce/label/c.scc_header_SIOP_Registration";
import scc_header_SIOP_Registration_URL from "@salesforce/label/c.scc_header_SIOP_Registration_URL";
import scc_header_Workbook from "@salesforce/label/c.scc_header_Workbook";
import scc_header_Workbook_URL from "@salesforce/label/c.scc_header_Workbook_URL";
import scc_header_Novel_TX from "@salesforce/label/c.scc_header_Novel_TX";
import scc_header_Novel_TX_URL from "@salesforce/label/c.scc_header_Novel_TX_URL";
import scc_header_Sign_Out from "@salesforce/label/c.scc_header_Sign_Out";
import scc_header_Sign_Out_URL from "@salesforce/label/c.scc_header_Sign_Out_URL";
import scc_header_Need_help from "@salesforce/label/c.scc_header_Need_help";
import scc_header_FAQ from "@salesforce/label/c.scc_header_FAQ";
import scc_header_FAQ_URL from "@salesforce/label/c.scc_header_FAQ_URL";
import scc_header_Site_Training from "@salesforce/label/c.scc_header_Site_Training";
import scc_header_Site_Training_URL from "@salesforce/label/c.scc_header_Site_Training_URL";
import scc_header_Contact_Commerce_Cloud_Support from "@salesforce/label/c.scc_header_Contact_Commerce_Cloud_Support";
import scc_header_Contact_Commerce_Cloud_Support_URL from "@salesforce/label/c.scc_header_Contact_Commerce_Cloud_Support_URL";
import scc_header_Contact_Customer_Service_Support from "@salesforce/label/c.scc_header_Contact_Customer_Service_Support";
import scc_header_Contact_Customer_Service_Support_URL from "@salesforce/label/c.scc_header_Contact_Customer_Service_Support_URL";
import scc_header_Home from "@salesforce/label/c.scc_header_Home";
import scc_header_Order_Status from "@salesforce/label/c.scc_header_Order_Status";
import scc_header_Check_Price_Availability from "@salesforce/label/c.scc_header_Check_Price_Availability";
import scc_header_Place_Order from "@salesforce/label/c.scc_header_Place_Order";
import scc_header_File_Claim from "@salesforce/label/c.scc_header_File_Claim";
import scc_header_Generate_Requests from "@salesforce/label/c.scc_header_Generate_Requests";
import scc_header_Request_Documents from "@salesforce/label/c.scc_header_Request_Documents";
import scc_header_Check_Access_Code from "@salesforce/label/c.scc_header_Check_Access_Code";
import scc_header_Site_Name_Description from "@salesforce/label/c.scc_header_Site_Name_Description";

import scc_brand_logo from "@salesforce/resourceUrl/scc_brand_logo";
import scc_need_help_icon from "@salesforce/resourceUrl/scc_need_help_icon";
import scc_profile_avatar from "@salesforce/resourceUrl/scc_profile_avatar";
import scc_brand_logo_mobile from "@salesforce/resourceUrl/scc_brand_logo_mobile";

import { getSessionContext } from 'commerce/contextApi';
import changeIsSecondaryTrue from '@salesforce/apex/scc_changeCartAsSecondary.changeActiveCartAsSecondary'
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class Scc_headerLWC extends LightningElement {

    labels = {
        scc_header_Profile,
        scc_header_Other_Apps,
        scc_header_WorkText_National,
        scc_header_WorkText_National_URL,
        scc_header_WorkText_TX,
        scc_header_WorkText_TX_URL,
        scc_header_SIOP_Registration,
        scc_header_SIOP_Registration_URL,
        scc_header_Workbook,
        scc_header_Workbook_URL,
        scc_header_Novel_TX,
        scc_header_Novel_TX_URL,
        scc_header_Sign_Out,
        scc_header_Sign_Out_URL,
        scc_header_Need_help,
        scc_header_FAQ,
        scc_header_FAQ_URL,
        scc_header_Site_Training,
        scc_header_Site_Training_URL,
        scc_header_Contact_Commerce_Cloud_Support,
        scc_header_Contact_Commerce_Cloud_Support_URL,
        scc_header_Contact_Customer_Service_Support,
        scc_header_Contact_Customer_Service_Support_URL,
        scc_header_Home,
        scc_header_Order_Status,
        scc_header_Check_Price_Availability,
        scc_header_Place_Order,
        scc_header_File_Claim,
        scc_header_Generate_Requests,
        scc_header_Request_Documents,
        scc_header_Check_Access_Code,
        scc_header_Site_Name_Description,
        scc_brand_logo,
        scc_need_help_icon,
        scc_profile_avatar,
        scc_brand_logo_mobile
    };

    @track homeClass = '';
    @track OrderStatusClass = '';
    @track CheckPriceAvailabilityclass='';
    @track PlaceOrderClass='';
    @track FileClaimClass='';
    @track GenerateRequestsClass='';
    @track RequestDocumentsClass='';
    @track CheckAccessCodeClass='';
    @track userName='';
    @track accountName='';
    @track userdata;
    @track isLoading = false;
    @track tab;
    @track showSiteDesc=true;
    @track currentaccountId ;
    @track enableLogs = false;

    @wire(MessageContext) messageContext;
   
    //changes for W-014196 US-163 starts
    renderedCallback(){
        this.subscribeMessage();
    }

   subscribeMessage(){
        subscribe(this.messageContext,scc_MessageChannel,(message)=>{this.handleMessage(message)},{scope:{APPLICATION_SCOPE}})
    }

    handleMessage(message){        
        this.receivedMessage=message.lmsData.value;
        this.showSiteDesc=false;
        this.homeClass = '';
        this.OrderStatusClass='';
        this.CheckPriceAvailabilityClass='';
        this.PlaceOrderClass='';
        this.FileClaimClass='';
        this.GenerateRequestsClass='';
        this.RequestDocumentsClass='';
        this.CheckAccessCodeClass='';

        if(this.receivedMessage =='OrderStatus'){
            this.OrderStatusClass='active';
        }
       if(this.receivedMessage =='home'){
            this.homeClass='active';
              this.PlaceOrderClass='';
        } 
        
    }
    //changes for W-014196 US-163 ends

    constructor(){
        super();
    }

    connectedCallback(){
        this.isLoading = true;
        this.homeClass = 'active';
        getUserInformation().then(response =>{
            if(this.enableLogs){
            console.log('response is',response);
            }
            let paser = JSON.parse(response);
            let data = paser[0];
            if(this.enableLogs){
            console.log(data);
            }
            this.userName = data.userName;
            this.accountName=data.accountName
        }).catch(error =>{
            console.log('error is',error);
            this.isLoading=false;
        })
        this.isLoading=false;

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

    handleTabClick(event) {

        this.homeClass = '';
        this.OrderStatusClass='';
        this.CheckPriceAvailabilityClass='';
        this.PlaceOrderClass='';
        this.FileClaimClass='';
        this.GenerateRequestsClass='';
        this.RequestDocumentsClass='';
        this.CheckAccessCodeClass='';

       
        const tabName = event.target.dataset.tab;
        this.tab = event.target.dataset.tab;

        
        const message={
            lmsData:{
                value:this.tab
            }
        }
        publish(this.messageContext,scc_MessageChannel,message)


        this[`${tabName}Class`] = 'active';

        if(tabName =='home'){
            this.showSiteDesc=true;
        }else{
            this.showSiteDesc=false;
        }
    }

    showDropdownMenu = false;
    showDropdownMenuProf = false;

    showDropdown() {
        this.showDropdownMenu = true;
    }

    hideDropdown() {
        this.showDropdownMenu = false;
    }
    
    showProfDropdown() {
        this.showDropdownMenuProf = true;
    }

    hideProfDropdown() {
        this.showDropdownMenuProf = false;
    }

    profileLink(){
        this.tabName1 = 'owedCoresLink';
    }

     async connectedCallback() {
        let sessionContext = await getSessionContext();
         this.currentaccountId = sessionContext.effectiveAccountId;
         if(this.enableLogs){
            console.log('current user account Id' +  this.currentaccountId);
         }
    } 

      updateCart(){        
        changeIsSecondaryTrue({ activeAccountId: this.currentaccountId })
            .then(result => {
                if(this.enableLogs){
                    console.log('success');
                }
            })
            .catch(error => {
                this.cases = undefined;
                this.caseError = error;
                console.log('the error is',this.caseError)
            });
    }

}