import { LightningElement,track,api,wire } from 'lwc';

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


//Import apex classes

//changes for W-014196 US-163 starts
import getSearchByOptions  from '@salesforce/apex/scc_orderStatusLWC_Controller.getSearchByOptions';
import getOrderStatusOptions  from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusOptions';
import getCountrysOptions  from '@salesforce/apex/scc_orderStatusLWC_Controller.getCountrysOptions';
//Changes for W-014075 US-96 
import getOrderStatusData  from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusData';
import {APPLICATION_SCOPE,createMessageContext,MessageContext,publish,releaseMessageContext,subscribe,unsubscribe} from 'lightning/messageService';
import scc_MessageChannel from '@salesforce/messageChannel/scc_MessageChannel__c'; 
import scc_OrderStatus_Invoice_Number from "@salesforce/label/c.scc_OrderStatus_Invoice_Number";
import scc_OrderStatus_Country from "@salesforce/label/c.scc_OrderStatus_Country";
import scc_OrderStatus_State_Province from "@salesforce/label/c.scc_OrderStatus_State_Province";
import scc_OrderStatus_Zip_Postal_Code from "@salesforce/label/c.scc_OrderStatus_Zip_Postal_Code";
import scc_recentOrder_Error_Message from "@salesforce/label/c.scc_recentOrder_Error_Message";
//changes for W-014196 US-163 ends



export default class Scc_homeLWC extends LightningElement {
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
    @track OrderStatusValue = [{ label: 'All', value: 'All' },{ label: 'Open', value: 'Open' },{ label: 'Cancelled', value: 'Cancelled' },{ label: 'Fulfilled', value: 'Fulfilled' }];

    @track PONumSelect = true;
    @track ISBNselect = false;
    @track InvoiceSelect = false;
    @track DocumentNumSelect = false;
    @track CountrysOptions1=[{ label: 'United States', value: 'United States' },{ label: 'Canada', value: 'Canada' }];
    @track CountrysOptions2;
    @track CountrysOptions3;
    @track SearchDisabledReturn = true;
    @track showTableData = true;
    //changes for W-014196 US-163 ends

    @wire(MessageContext) messageContext;

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

    constructor() {
        super();
        //changes for W-014196 US-163 starts
        getSearchByOptions({HomePage:true}).then(response =>{
            console.log('response is',response);
            let paser = JSON.parse(response);
            console.log('getSearchByOptions',paser);
            this.SearchByOptions1 = JSON.parse(response);
        }).catch(error =>{
            console.log('error is',error);
            // this.isLoading1=false;
        })

        getOrderStatusOptions().then(response =>{
            console.log('response is',response);
            let paser = JSON.parse(response);
            console.log('getOrderStatusOptions',paser);
            this.OrderStatusOptions1 = JSON.parse(response);
        }).catch(error =>{
            console.log('error is',error);
            // this.isLoading1=false;
        })

        getCountrysOptions().then(response =>{
            console.log('response is',response);
            let paser = JSON.parse(response);
            console.log('getCountrysOptions',paser);
            this.CountrysOptions2 = JSON.parse(response);
            this.CountrysOptions3= [...this.CountrysOptions1,...this.CountrysOptions2]
        }).catch(error =>{
            console.log('error is',error);
            this.isLoading1=false;
        })
          
        //Changes for W-014075 US-96 
        getOrderStatusData().then(response =>{
            console.log('response is',response);
            let paser = JSON.parse(response);
            console.log('getOrderStatusData',paser);
            this.tableData = paser;
            this.items=this.tableData.length;
            if(this.items<=0){
                this.showTableData = false;
            }
            }).catch(error =>{
            console.log('error is',error);
            this.isLoading1=false;
           })
            this.isLoading1 = false;

        //changes for W-014196 US-163 ends

        this.data='Possible Shipment Delays......assddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd'
        // this.tableData=[
        //     {id:1, colomn1:'9145677899001',PO:'PO#'},
        //     {id:2, colomn1:'9145677899002',PO:'PO#'},
        //     {id:3, colomn1:'9145677899002',PO:'PO#'},
        //     {id:4, colomn1:'9145677899002',PO:'PO#'},
        //     {id:5, colomn1:'9145677899002',PO:'PO#'},
        //     {id:6, colomn1:'9145677899002',PO:'PO#'},
        //     {id:7, colomn1:'9145677899002',PO:'PO#'},
        //     {id:8, colomn1:'9145677899002',PO:'PO#'},
        //     {id:9, colomn1:'9145677899002',PO:'PO#'},
        //     {id:10, colomn1:'9145677899002',PO:'PO#'},
        //     {id:11, colomn1:'9145677899002',PO:'PO#'},
        //     {id:12, colomn1:'9145677899002',PO:'PO#'}
        // ]
      
        this.heldCartData=[
            {id:1, colomn1:'9145677899001',PO:'PO#'},
            {id:2, colomn1:'9145677899002',PO:'PO#'}
        ]

        this.cartItems=this.heldCartData.length;
        this.richtext='A lightning-radio-group component represents a group of radio buttons that permit only one button to be selected at a time. The component renders radio button <input> elements and assigns the same value to the name attribute for each element. The common name attribute joins the elements in a group. If you select any radio button in that group, any previously selected button in the group is deselected.' 
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
        
        console.log('this.SearchByvalue ',this.SearchByvalue );
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

    get SearchDisabled(){
        if( (this.PONum != '' && this.SearchByvalue == 'PO#') ||  (this.InvoNum != '' && this.SearchByvalue == 'Invoice #') || (this.ISBnNum !='' && this.SearchByvalue == 'Containing ISBN') || (this.DocContrNum !='' && this.SearchByvalue == 'Order #') ){
            console.log('this.SearchDisabledReturn ',this.SearchDisabledReturn );
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
}