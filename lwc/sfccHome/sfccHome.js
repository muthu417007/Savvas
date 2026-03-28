/*********************************************************
  Component Name       : sfccHome
  Created Date         : 06/10/2024  
  Author               : Cognizant 
  Description          : This component used in Home page and functionality related to 
                         Recent Orders and redirecting to Order Status Page.
  
  Modifications Log
  06/10/2024     Zubiya           Initial Version
*********************************************************/

import { LightningElement,track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

//importing static resource
import No_Recent_Order from '@salesforce/resourceUrl/NoRecentOrder';   

//Importing Apex class
import getOrderStatusData from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusData';

//Importing labels
import scc_home_Recent_Orders from "@salesforce/label/c.scc_home_Recent_Orders";
import scc_home_ViewAll from "@salesforce/label/c.scc_home_ViewAll";
import scc_home_PO from "@salesforce/label/c.scc_home_PO";
import scc_home_Document_Control from "@salesforce/label/c.scc_home_Document_Control";
import scc_home_Ship_To_Name from "@salesforce/label/c.scc_home_Ship_To_Name";
import scc_home_Order_Date from "@salesforce/label/c.scc_home_Order_Date";
import scc_home_Status from "@salesforce/label/c.scc_home_Status";
//import scc_recentOrder_Error_Message from "@salesforce/label/c.scc_recentOrder_Error_Message";

export default class Scc_homeLWC extends NavigationMixin(LightningElement) {
  
   labels ={
        scc_home_PO,
        scc_home_Ship_To_Name,
        scc_home_Recent_Orders,
        scc_home_Document_Control,
        scc_home_Order_Date,
        scc_home_Status,
        scc_home_ViewAll,
        //scc_recentOrder_Error_Message
    };
    
   //Variables initialization
   noRecentOrderImage = No_Recent_Order;   
   getOrderData=[];     //All records available in the data table
   error;

//Initializes component and handles data loading
   connectedCallback() {
     this.isLoading1 = true;
      getOrderStatusData().then(response => {
            let parsed = JSON.parse(response);
            this.getOrderData = parsed.map(item => ({
                    ...item,
                    EffectiveDate: this.reformatDate(item.EffectiveDate)
                }));
        }).catch(error => {
            this.error = error;
        }).finally(()=>{ 
            this.isLoading1 = false;
        });

   }

 reformatDate(dateString) {
        const [year, month, day] = dateString.split('-');
        return `${month}/${day}/${year}`;
    }


//Checks if there are recent orders
   hasRecentOrder()
   {    
         this.getOrderData.length > 0;
   } 
//Returns count of recent orders   
   get getRecentOrderCount()
   {
        return this.getOrderData.length ;
   }


//Navigates to Order Status Page
   viewAll(){                            
        const encodedValues = encodeDefaultFieldValues({
            Search:'All Orders',
            PONum:'',
            ISBnNum:'',
            startDate:null,
            endDate:null,
            OrderStatusValue:'All',
            InvoNum:'',
            ZipNum:'',
            StateNum:'',
            CountryValue:'',
            DocContrNum:'',
          
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
}