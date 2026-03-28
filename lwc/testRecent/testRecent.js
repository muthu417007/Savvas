import { LightningElement,track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

//importing static resource
import No_Recent_Order from '@salesforce/resourceUrl/NoRecentOrder';   

//Importing Apex class
import getOrderStatusData from '@salesforce/apex/testRecentController.getOrderStatusData';
//import getInternalOrderStatusData from '@salesforce/apex/scc_orderStatusLWC_Controller.getInternalOrderStatusData';

//Importing labels
import scc_home_Recent_Orders from "@salesforce/label/c.scc_home_Recent_Orders";
import scc_home_ViewAll from "@salesforce/label/c.scc_home_ViewAll";
import scc_home_PO from "@salesforce/label/c.scc_home_PO";
import scc_home_Document_Control from "@salesforce/label/c.scc_home_Document_Control";
import scc_home_Ship_To_Name from "@salesforce/label/c.scc_home_Ship_To_Name";
import scc_home_Order_Date from "@salesforce/label/c.scc_home_Order_Date";
import scc_home_Status from "@salesforce/label/c.scc_home_Status";
import scc_home_Bill_To_Name from "@salesforce/label/c.scc_home_Bill_To_Name";
//import scc_recentOrder_Error_Message from "@salesforce/label/c.scc_recentOrder_Error_Message";
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation'; 
export default class TestRecent extends NavigationMixin(LightningElement) {
  
   labels ={
        scc_home_PO,
        scc_home_Ship_To_Name,
        scc_home_Recent_Orders,
        scc_home_Document_Control,
        scc_home_Order_Date,
        scc_home_Status,
        scc_home_ViewAll,
        scc_home_Bill_To_Name
        //scc_recentOrder_Error_Message
    };
    
   //Variables initialization
   noRecentOrderImage = No_Recent_Order;   
   getOrderData=[];     //All records available in the data table
   error;
   //added  by sudha W-15025
   @track userName='';
 @track accountName =''; 
 @track isGuest = false;
 @track isInternal = false;
 @track isShowingCredits = false;

 showRecentOrders(event) {
        event.preventDefault();
        this.isShowingCredits = false;
        this.fetchOrderData();
    }

    showRecentCredits(event) {
        event.preventDefault();
        this.isShowingCredits = true;
        this.fetchOrderData();
    }
    fetchOrderData() {
        this.isLoading1 = true;
        getOrderStatusData({ isCredits: this.isShowingCredits })
            .then(response => {
                console.log('Response from fetchOrderdata:', response); // Log the response
                if (response.startsWith('Error:')) {
                    console.error(response);
                    this.error = response;
                } else {
                    let parsed = JSON.parse(response);
                    this.getOrderData = parsed.map(item => ({
                        ...item,
                    }));
                }
            })
            .catch(error => {
                console.error('Error:', error); // Log the error
                this.error = error;
            })
            .finally(() => { 
                this.isLoading1 = false;
            });
    }
    

 initializeUserInformation() {
        getUserInformation()
            .then(response => {
                console.log('Raw response:', response);
                const parsed = JSON.parse(response);
                console.log('Parsed response:', parsed);

                if (parsed && parsed.length > 0) {
                    const data = parsed[0];
                    console.log('User data:', data);

                    this.userName = data.userName ?? '';
                    this.accountName = data.accountName ?? '';
                    this.isInternal = data.isInternal ?? false;
                    this.isGuest = data.isGuest ?? false;

                    console.log('UserName:', this.userName);
                    console.log('AccountName:', this.accountName);
                    console.log('IsInternal:', this.isInternal);
                    console.log('IsGuest:', this.isGuest);
                } else {
                    console.error('No data received or data array is empty');
                }
            })
            .catch(error => {
                console.error('Error fetching user information', error);
            });
    }

 connectedCallback() {
    console.log('ConnectedCallback');
    this.initializeUserInformation();
    console.log('ConnectedCallback');
    this.isLoading1 = true;
    console.log('ConnectedCallback123', this.isInternal);
    this.fetchOrderData();
    console.log('ConnectedCallback1234');

    getOrderStatusData().then(response => {
        console.log('ConnectedCallback123', response);
        let parsed = JSON.parse(response);
        this.getOrderData = parsed.map(item => ({
            ...item,
            // EffectiveDate: this.reformatDate(item.EffectiveDate)
        }));
    }).catch(error => {
        this.error = error;
    }).finally(() => { 
        this.isLoading1 = false;
    });
    this.dispatchEvent(new CustomEvent('home', {
        detail:{
            page:'home'
        }
    }))
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

   orderrecorddetail(event)
   {
        console.log('current order no',event.target.dataset.id);
        const encodedValues = encodeDefaultFieldValues({
            Search:'Order #',
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
            Orderno:event.target.dataset.id,
          
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

   toggleResultFields(event){
        let parentDiv = event.target.closest(".dropdown-container-mobile");
        let arrayEle = parentDiv.querySelectorAll('.full-width-in-mobile');
        console.log("parentDiv", parentDiv);
        console.log("arrayEle", arrayEle);
        for (let i = 0; i < arrayEle.length; i++ ) {
            arrayEle[i].classList.toggle('slds-show');
        }
        event.target.classList.toggle("chevron-up");
    }
}