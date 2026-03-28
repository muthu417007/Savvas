import { LightningElement,track,api,wire } from 'lwc';
// import {NavigationMixin} from 'lightning/navigation';//added by Zubiya for Multipage design
// import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

import scc_home_PO from "@salesforce/label/c.scc_home_PO";
import scc_home_Ship_To_Name from "@salesforce/label/c.scc_home_Ship_To_Name";
import scc_home_Recent_Orders from "@salesforce/label/c.scc_home_Recent_Orders";
import scc_home_Document_Control from "@salesforce/label/c.scc_home_Document_Control";
import scc_home_Order_Date from "@salesforce/label/c.scc_home_Order_Date";
import scc_home_Status from "@salesforce/label/c.scc_home_Status";
import scc_home_Order_Status from "@salesforce/label/c.scc_home_Order_Status";
import scc_home_Quick_Reports from "@salesforce/label/c.scc_home_Quick_Reports";
import scc_home_Reports from "@salesforce/label/c.scc_home_Reports";
import scc_home_Held_Carts from "@salesforce/label/c.scc_home_Held_Carts";
import scc_home_Date from "@salesforce/label/c.scc_home_Date";
import scc_home_Items from "@salesforce/label/c.scc_home_Items";
import scc_home_Show_on_Screen from "@salesforce/label/c.scc_home_Show_on_Screen";
import scc_home_Email_to from "@salesforce/label/c.scc_home_Email_to";
import scc_home_Search_By from "@salesforce/label/c.scc_home_Search_By";
import scc_home_ISBN from "@salesforce/label/c.scc_home_ISBN";
import scc_home_Order_Entry_Period from "@salesforce/label/c.scc_home_Order_Entry_Period";
import scc_home_Delivery_Method from "@salesforce/label/c.scc_home_Delivery_Method";
import scc_home_Cart_Name from "@salesforce/label/c.scc_home_Cart_Name";
import scc_home_From from "@salesforce/label/c.scc_home_From";
import scc_home_To from "@salesforce/label/c.scc_home_To";
import scc_home_Search from "@salesforce/label/c.scc_home_Search";
import scc_home_ViewAll from "@salesforce/label/c.scc_home_ViewAll";
import scc_home_Run from "@salesforce/label/c.scc_home_Run";
import scc_heldCartMessage from "@salesforce/label/c.scc_heldCartMessage";
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

//Import apex classes

//changes for W-014196 US-163 starts
import getSearchByOptions  from '@salesforce/apex/scc_orderStatusLWC_Controller.getSearchByOptions';
import getOrderStatusOptions  from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusOptions';
import getCountrysOptions  from '@salesforce/apex/scc_orderStatusLWC_Controller.getCountrysOptions';
import getUserInformation  from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
//Changes for W-014075 US-96 
import getOrderStatusData  from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusData';
import {APPLICATION_SCOPE,createMessageContext,MessageContext,publish,releaseMessageContext,subscribe,unsubscribe} from 'lightning/messageService';
import scc_MessageChannel from '@salesforce/messageChannel/scc_MessageChannel__c'; 
import scc_OrderStatus_Invoice_Number from "@salesforce/label/c.scc_OrderStatus_Invoice_Number";
import scc_OrderStatus_Country from "@salesforce/label/c.scc_OrderStatus_Country";
import scc_OrderStatus_State_Province from "@salesforce/label/c.scc_OrderStatus_State_Province";
import scc_OrderStatus_Zip_Postal_Code from "@salesforce/label/c.scc_OrderStatus_Zip_Postal_Code";
import scc_recentOrder_Error_Message from "@salesforce/label/c.scc_recentOrder_Error_Message";
import getHeldCartRecords  from '@salesforce/apex/scc_FetchHeldCart_Controller.getHeldCartRecords';
import changeActiveCartAsSecondary from '@salesforce/apex/scc_changeCartAsSecondary.changeActiveCartAsSecondary';
import changeHeldToActiveCart from '@salesforce/apex/scc_changeCartAsSecondary.changeHeldToActiveCart';
import Id from "@salesforce/user/Id";
//changes for W-014196 US-163 ends



export default class Scc_homeLWC extends LightningElement {
// export default class Scc_homeLWC extends NavigationMixin(LightningElement) { //added by Zubiya for Multipage design
    @track data='';
    @track tableData=[];
    @track heldCartData =[];
    @track richtext='';
    @track items;
    @track cartItems;
    //changes for W-014196 US-163 starts
    @track SearchByOptions1;
    @track OrderStatusOptions1;
    @track SearchByvalue = 'PO#';
    @track OrderStatusValue = 'All';
    @track PONumSelect = true;
    @track ISBNselect = false;
    @track InvoiceSelect = false;
    @track DocumentNumSelect = false;
    @track CountrysOptions1=[{ label: 'United States', value: 'United States' },{ label: 'Canada', value: 'Canada' }];
    @track CountrysOptions2;
    @track CountrysOptions3;
    @track SearchDisabledReturn = true;
    @track showTableData = true;
    @track userId = Id;
    @track orderno;
    parentValue = true;
    error;
    //changes for W-014196 US-163 ends

    @wire(MessageContext) messageContext;
    @api tabselection = false;
    @track showHeldCartMsg = false;
    showheldcart=0;
    @track receivedMessage;
    @track heldCartId = '';
    @track cartId = '';
    @track enableLogs = false;

    labels ={
        scc_home_PO,
        scc_home_Ship_To_Name,
        scc_home_Recent_Orders,
        scc_home_Document_Control,
        scc_home_Order_Date,
        scc_home_Status,
        scc_home_Order_Status,
        scc_home_Quick_Reports,
        scc_home_Reports,
        scc_home_Held_Carts,
        scc_heldCartMessage,
        scc_home_Date,
        scc_home_Items,
        scc_home_Show_on_Screen,
        scc_home_Email_to,
        scc_home_Search_By,
        scc_home_ISBN,
        scc_home_Order_Entry_Period,
        scc_home_Delivery_Method,
        scc_home_Cart_Name,
        scc_home_From,
        scc_home_To,
        scc_home_Search,
        scc_home_ViewAll,
        scc_home_Run,
        scc_OrderStatus_Invoice_Number,
        scc_OrderStatus_Country,
        scc_OrderStatus_State_Province,
        scc_OrderStatus_Zip_Postal_Code,
        scc_recentOrder_Error_Message
    };

    
    formatDate(dateString) {
        if (!dateString) return '';
        
        const date = new Date(dateString);
        const month = String(date.getUTCMonth() + 1).padStart(2, '0'); // Months are zero-based
        const day = String(date.getUTCDate()).padStart(2, '0');
        const year = date.getUTCFullYear();

        return `${month}/${day}/${year}`;
    }

    constructor() {
        super();
        //changes for W-014196 US-163 starts
        getSearchByOptions({HomePage:true}).then(response =>{            
            let paser = JSON.parse(response);            
            this.SearchByOptions1 = JSON.parse(response);
        }).catch(error =>{
            if(this.enableLogs){                    
            console.log('error is',error); 
            }           
        })

        
        getHeldCartRecords().then(response =>{            
            let paser = JSON.parse(JSON.stringify(response));            
            this.heldCartData = paser.map(order => {
                return {
                    ...order,
                    CreatedDate: this.formatDate(order.CreatedDate)
                };
            });

            this.cartItems = this.heldCartData.length;
        }).catch(error =>{
            if(this.enableLogs){
            console.log('error is',error);            
            }
        })

        getOrderStatusOptions().then(response =>{           
            let paser = JSON.parse(response);            
            this.OrderStatusOptions1 = JSON.parse(response);
        }).catch(error =>{
            if(this.enableLogs){
            console.log('error is',error);            
            }
        })

        getCountrysOptions().then(response =>{            
            let paser = JSON.parse(response);            
            this.CountrysOptions2 = JSON.parse(response);
            this.CountrysOptions3= [...this.CountrysOptions1,...this.CountrysOptions2]
        }).catch(error =>{
            if(this.enableLogs){
            console.log('error is',error);
            }
            this.isLoading1=false;
        })            
        
        getOrderStatusData().then(response =>{            
            let paser = JSON.parse(response);            
            this.tableData = paser.map(item => ({
                    ...item,
                    EffectiveDate: this.reformatDate(item.EffectiveDate)
                }));
;
            this.items=this.tableData.length;
            if(this.items<=0){
                this.showTableData = false;
            }
            }).catch(error =>{
                if(this.enableLogs){
                    console.log('error is',error);
                }
            this.isLoading1=false;
           })
            this.isLoading1 = false;        

        this.data='Possible Shipment Delays......assddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd'        
    }

    connectedCallback(){         
         if(this.tabselection == true){
          this.showHeldCartMsg = true;                  
         }else{
           this.showHeldCartMsg = false ;
         }
        this.isLoading = true;
        this.homeClass = 'active';

        getUserInformation().then(response =>{            
            let paser = JSON.parse(response);
            let data = paser[0];            
            this.userName = data.userName;
            this.currentaccountId=data.accountId;
        }).catch(error =>{
            if(this.enableLogs){
            console.log('error is',error);
            }
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

    reformatDate(dateString) {
        const [year, month, day] = dateString.split('-');
        return `${month}/${day}/${year}`;
    }


    //changes for W-014196 US-163 starts
    @track PONum ='';
    @track ISBnNum ='';
    @track InvoNum = '';
    @track startDate;    
    @track endDate;
    @track CountryValue = 'United States';
    @track StateNum='';
    @track ZipNum = '';
    @track DocContrNum = '';    

    handleNumChange(event){
        if(event.target.name == 'PONum'){
            this.PONum = event.target.value;
        }

        if(event.target.name == 'ISBnNum'){
            this.ISBnNum = event.target.value;
        }

        if(event.target.name == 'startDate'){
            this.startDate = event.target.value;
        }
     

        if(event.target.name == 'endDate'){
            this.endDate = event.target.value;
        } 

        if(event.target.name == 'InvoNum'){
            this.InvoNum = event.target.value;
        }

        if(event.target.name == 'ZipNum'){
            this.ZipNum = event.target.value;
        }

        if(event.target.name == 'StateNum'){
            this.StateNum = event.target.value;
        }

        if(event.target.name == 'DocContrNum'){
            this.DocContrNum = event.target.value;
        } 
        
    }

    handleOrderStatusChange(event){
        this.OrderStatusValue = event.target.value;
    }

    handleCountryOptionChange(event){
        this.CountryValue = event.target.value;
    }
    //changes for W-014196 US-163 ends
    
    handleChange(event){
        this.richtext=event.target.value;
    }

    handleSearchByChange(event){
        this.SearchByvalue = event.target.value;
        this.PONumSelect = false;
        this.ISBNselect = false;
        this.InvoiceSelect = false;
        this.DocumentNumSelect = false;
                
        if(this.SearchByvalue == 'PO#'){
            this.PONumSelect = true;
        }

        if(this.SearchByvalue == 'Containing ISBN'){
            this.ISBNselect = true;
        }

        if(this.SearchByvalue == 'Invoice #'){
            this.InvoiceSelect = true;
        }

        if(this.SearchByvalue == 'Order #'){
            this.DocumentNumSelect = true;
        }
    
    }

    get SearchByOptions(){
        return this.SearchByOptions1;
    }

    get CountryOptions(){
        return this.CountrysOptions3;
    }

    //changes for W-014383 US-183 starts
    handleOrderViewAll(){
        this.SearchByvalue = 'All Orders';
        this.handleSearch();
    }
    //changes for W-014383 US-183 ends
    
    //changes for W-014196 US-163 starts
    

    handleSearch(){
        
        const message={
            lmsData:{
                value:'OrderStatus'
            }
        }

        let detail ={
            orderStatusData:{
                value:{
                    Search:this.SearchByvalue,
                    PONum:this.PONum,
                    ISBnNum:this.ISBnNum,
                    startDate:this.startDate,
                    endDate:this.endDate,
                    OrderStatusValue:this.OrderStatusValue,
                    InvoNum:this.InvoNum,
                    ZipNum:this.ZipNum,
                    StateNum:this.StateNum,
                    CountryValue:this.CountryValue,
                    DocContrNum: this.DocContrNum
                } 
            }
        }

        let eve = new CustomEvent('hmsearchclk',{detail});
        this.dispatchEvent(eve);

        publish(this.messageContext,scc_MessageChannel,message);
    }

    handleViewAllHeldCarts(){
        const message={
            lmsData:{
                value:'viewAllHeldCarts'
            }
        }

        let detail ={
            viewHeldCarts:{
                value:{
                    userId:this.userId
                } 
            }
        }

        let eve = new CustomEvent('displayViewAllHeldCartsPage',{detail});
        this.dispatchEvent(eve);

        publish(this.messageContext,scc_MessageChannel,message);
    }

    openReviewHeldCarts(event){
        
        this.heldCartId = event.currentTarget.dataset.id;
        if(this.enableLogs){
        console.log('event.currentTarget.dataset.id>>>',event.currentTarget.dataset.id);
        console.log('this.currentaccountId>>>',this.currentaccountId);
        console.log('this.heldCartId>>>',this.heldCartId);
        }
        changeActiveCartAsSecondary({ activeAccountId: this.currentaccountId })
            .then(result => {
                if(this.enableLogs){    
                    console.log('changeActiveCartAsSecondary result>>>>',result);
                }
                changeHeldToActiveCart({ cartId:  this.heldCartId }).then(response => {                    
                        const message={
                            lmsData:{
                                value:'openReviewHeldCarts'
                            }
                        }
                
                        let detail ={
                            reviewHeldCarts:{
                                value:{
                                    //cartId:this.heldCartId
                                    
                                } 
                            }
                        }                        
                        let eve = new CustomEvent('displayReViewAllHeldCartsPage',{detail});
                        this.dispatchEvent(eve);

                        publish(this.messageContext,scc_MessageChannel,message);

                    })
                    .catch(error => {
                        if(this.enableLogs){
                        console.log('the error is',error);
                        }
                    })
                    
            })
            .catch(error => {
                if(this.enableLogs){
                console.log('the error is',error)
                }
            });
        
    }

    get SearchDisabled(){
        if( (this.PONum != '' && this.SearchByvalue == 'PO#') ||  (this.InvoNum != '' && this.SearchByvalue == 'Invoice #') || (this.ISBnNum !='' && this.SearchByvalue == 'Containing ISBN') || (this.DocContrNum !='' && this.SearchByvalue == 'Order #') ){            
                this.SearchDisabledReturn = false;
        }else{
                this.SearchDisabledReturn = true; 
        }
        return this.SearchDisabledReturn;
    }
    
    //changes for W-014196 US-163 ends


    get deliveryMethodOptions() {
        return [
            { label: this.labels.scc_home_Show_on_Screen, value: 'option1' },
            { label: this.labels.scc_home_Email_to, value: 'option2' },
        ];
    }
    
    handleorderDetails(event){
        const encodedValues = encodeDefaultFieldValues({
            orderno:this.orderno,
            page:'home'
            
        });
        this.orderno = event.target.dataset.id;
        this[NavigationMixin.Navigate] ({
            type: 'comm__namedPage',
            attributes: {
                   name : 'scc_orderStatusLWC__c'              
            },
          state: {
            defaultFieldValues: encodedValues,
          }
         }) 

    }
    
    openHeldCart(event){        
        this.heldCartId = event.currentTarget.dataset.id;        
        
        //Added for W-014938- Varshaa
        changeActiveCartAsSecondary({ activeAccountId: this.currentaccountId })
            .then(result => {
                if(this.enableLogs){
                    console.log('held cart success');
                }
                
            })
            .catch(error => {
                this.cases = undefined;
                this.caseError = error;
                if(this.enableLogs){
                console.log('the error is',this.caseError)
                }
            });
        

            changeHeldToActiveCart({ cartId:  this.heldCartId }).then(response => {
                if(this.enableLogs){
                    console.log(response);
                    console.log('active cart success');
                }
                
            })
            .catch(error => {
                if(this.enableLogs){    
                console.log('the error is',error);
                }
            })
            //End  W-014938
            this.showHeldCartMsg = false;
            this.reviewCartPage = true;
            if(this.enableLogs){
                    
            console.log('this.showHeldCartMsg>>>',this.showHeldCartMsg);
            console.log('this.reviewCartPage>>>',this.reviewCartPage);
            console.log('after event.detail>>>',event.detail);
            }
            
        
    }
    
    
    
}