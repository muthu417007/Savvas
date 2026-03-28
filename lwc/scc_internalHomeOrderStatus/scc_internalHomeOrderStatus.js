/*********************************************************
  Component Name       : sfccHomeOrderStatusSearch
  Created Date         : 06/10/2024  
  Author               : Cognizant 
  Description          : This component used in Home page and functionality related to 
                         search Order Status and redirecting to Order Status Page.
  
  Modifications Log
  06/10/2024     Zubiya           Initial Version
*********************************************************/

import { LightningElement,track,api,wire } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

//Importing labels
import scc_home_PO from "@salesforce/label/c.scc_home_PO";
import scc_home_Document_Control from "@salesforce/label/c.scc_home_Document_Control";
import scc_home_Order_Status from "@salesforce/label/c.scc_home_Order_Status";
import scc_home_Search_By from "@salesforce/label/c.scc_home_Search_By";
import scc_home_ISBN from "@salesforce/label/c.scc_home_ISBN";
import scc_home_From from "@salesforce/label/c.scc_home_From";
import scc_home_To from "@salesforce/label/c.scc_home_To";
import scc_OrderStatus_Invoice_Number from "@salesforce/label/c.scc_OrderStatus_Invoice_Number";
import scc_OrderStatus_Country from "@salesforce/label/c.scc_OrderStatus_Country";
import scc_OrderStatus_State_Province from "@salesforce/label/c.scc_OrderStatus_State_Province";
import scc_OrderStatus_Zip_Postal_Code from "@salesforce/label/c.scc_OrderStatus_Zip_Postal_Code";
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

//Import apex classes
import getSearchByOptions  from '@salesforce/apex/scc_orderStatusLWC_Controller.getSearchByOptions';
import getOrderStatusOptions  from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusOptions';
import getCountrysOptions  from '@salesforce/apex/scc_orderStatusLWC_Controller.getCountrysOptions';


export default class scc_internalHomeOrderStatus extends NavigationMixin(LightningElement) {   

//Variables initialization
    @track SearchByOptions1;
    @track OrderStatusOptions1;
    @track SearchByvalue = 'PO#';
    @track OrderStatusValue = [{ label: 'All', value: 'All' },{ label: 'Open', value: 'Open' },{ label: 'Cancelled', value: 'Cancelled' },{ label: 'Fulfilled', value: 'Fulfilled' }];
    @track OrderStatusValue = 'All';
    @track PONumSelect = true;
    @track ISBNselect = false;
    @track InvoiceSelect = false;
    @track DocumentNumSelect = false;
    @track CountrysOptions1=[{ label: 'United States', value: 'United States' },{ label: 'Canada', value: 'Canada' }];
    @track CountrysOptions2;
    @track CountrysOptions3;
    @track SearchDisabledReturn = true;
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
     @track enableLogs = false;

    labels ={
        scc_home_PO,
        scc_home_Document_Control,
        scc_home_Order_Status,
        scc_home_Search_By,
        scc_home_ISBN,
        scc_home_From,
        scc_home_To,    
        scc_OrderStatus_Invoice_Number,
        scc_OrderStatus_Country,
        scc_OrderStatus_State_Province,
        scc_OrderStatus_Zip_Postal_Code
      
    };

   constructor() {
        super();
        //changes for W-014196 US-163 starts
        getSearchByOptions({HomePage:true}).then(response =>{
            
            let paser = JSON.parse(response);
            if(this.enableLogs){
            console.log('response is',response);
            console.log('getSearchByOptions',paser);
            }
            this.SearchByOptions1 = JSON.parse(response);
        }).catch(error =>{
            if(this.enableLogs){
            console.log('error is',error);
            }           
        })

        getOrderStatusOptions().then(response =>{
            
            let paser = JSON.parse(response);
            if(this.enableLogs){
            console.log('response is',response);
            console.log('getOrderStatusOptions',paser);
            }
            this.OrderStatusOptions1 = JSON.parse(response);
        }).catch(error =>{
            if(this.enableLogs){
            console.log('error is',error);
            }            
        })

        getCountrysOptions().then(response =>{
            
            let paser = JSON.parse(response);
            if(this.enableLogs){
            console.log('response is',response);
            console.log('getCountrysOptions',paser);
            }
            this.CountrysOptions2 = JSON.parse(response);
            this.CountrysOptions3= [...this.CountrysOptions1,...this.CountrysOptions2]
        }).catch(error =>{
            if(this.enableLogs){
            console.log('error is',error);
            }
            this.isLoading1=false;
        })

    }

   connectedcallback(){
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

    get OrderStatusOptions() {
        return this.OrderStatusOptions1;
    }

   
//Extracts parameters from the current page and redirects to the “Order Status” page. 
   handleSearch(){       
        const encodedValues = encodeDefaultFieldValues({
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
            DocContrNum:this.DocContrNum
        });

        this[NavigationMixin.Navigate] ({
            type: 'comm__namedPage',
            attributes: {
                name : 'Order_Status__c'  //Api name
            },
            state: {
                defaultFieldValues: encodedValues,
                Source : 'comp'
            }
        })
    
    }

// Determines if search functionality should be disabled based on input values.
    get SearchDisabled(){
        if( (this.PONum != '' && this.SearchByvalue == 'PO#') ||  (this.InvoNum != '' && this.SearchByvalue == 'Invoice #') || (this.ISBnNum !='' && this.SearchByvalue == 'Containing ISBN') || (this.DocContrNum !='' && this.SearchByvalue == 'Order #') ){            
                this.SearchDisabledReturn = false;
        }else{
                this.SearchDisabledReturn = true; 
        }
        return this.SearchDisabledReturn;
    }

    

}