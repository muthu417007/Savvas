/********************************************************************************************* 
* @Component Name  - Scc_home
* @description -  This component is used to display the recent orders of the customer.
* @Created By  - CTS - Zubiya
* @Created On - 06/14/2024 
* ********************************************************************************************/

import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { refreshApex } from '@salesforce/apex';
import No_Recent_Order from '@salesforce/resourceUrl/NoRecentOrder';   
import getOrderStatusData from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusData';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation'; 
import scc_home_Recent_Orders from "@salesforce/label/c.scc_home_Recent_Orders";
import scc_home_ViewAll from "@salesforce/label/c.scc_home_ViewAll";
import scc_home_PO from "@salesforce/label/c.scc_home_PO";
import scc_home_Document_Control from "@salesforce/label/c.scc_home_Document_Control";
import scc_home_Ship_To_Name from "@salesforce/label/c.scc_home_Ship_To_Name";
import scc_home_Order_Date from "@salesforce/label/c.scc_home_Order_Date";
import scc_home_Status from "@salesforce/label/c.scc_home_Status";
import scc_home_Bill_To_Name from "@salesforce/label/c.scc_home_Bill_To_Name";
import {IsConsoleNavigation,getFocusedTabInfo,refreshTab} from 'lightning/platformWorkspaceApi';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class Scc_home extends NavigationMixin(LightningElement) {
    @track isLoading = true;
    noRecentOrderImage = No_Recent_Order;   
    @track getOrderData = [];
    error;
    @track userName = '';
    @track accountName = ''; 
    @track isGuest = false;
    @track isInternal = false;
    @track isShowingCredits = false;
    @track enableLogs = false;
    
    labels = {
        scc_home_PO,
        scc_home_Ship_To_Name,
        scc_home_Recent_Orders,
        scc_home_Document_Control,
        scc_home_Order_Date,
        scc_home_Status,
        scc_home_ViewAll,
        scc_home_Bill_To_Name,
        scc_home_Recent_Credits: "Recently Viewed Credits"
    };

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

        this.initializeUserInformation();
        this.isLoading1 = true;
        this.fetchOrderData();

        this.dispatchEvent(new CustomEvent('home', {
            detail: {
                page: 'home'
            }
        }));
        this.refreshCurrentTab();
        refreshApex(this.getOrderData);
    }  

    @wire(IsConsoleNavigation) isConsoleNavigation;
    
    get recentViewHeading() {
        return this.isInternal ? (this.labelHeading || 'Recently Viewed Orders'):'Recent Orders';
    }
    get viewAllLinkText() {
        return this.isShowingCredits ? 'View All Credits' : this.labels.scc_home_ViewAll;
    }

    get recentViewType() {
        return this.isShowingCredits ? 'Credits' : 'Orders';
    }

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
        this.isLoading = true;
        getOrderStatusData({ isCredits: this.isShowingCredits })
            .then(response => {
                if(this.enableLogs){
                    console.log('getOrderStatusData response is',response);
                }
                if (response.startsWith('Error:')) {
                    if(this.enableLogs){
                        console.error(response);
                    }                    
                    this.error = response;
                } else {
                    let parsed = JSON.parse(response);
                    this.getOrderData = parsed.map(item => ({
                        ...item,
                    }));
                }
            })
            .catch(error => {   
                if(this.enableLogs){
                    console.log('error is', error);
                }
                this.error = error;
            })
            .finally(() => { 
                this.isLoading = false;
            });
    }

    initializeUserInformation() {
        getUserInformation()
            .then(response => {
                if(this.enableLogs){
                    console.log('getUserInformation response is',response);
                }
                const parsed = JSON.parse(response);
                if (parsed && parsed.length > 0) {
                    const data = parsed[0];
                    this.userName = data.userName ?? '';
                    this.accountName = data.accountName ?? '';
                    this.isInternal = data.isInternal 
                    this.isGuest = data.isGuest ?? false;
                } else {
                    if(this.enableLogs){
                        console.log('No data received or data array is empty');
                    }
                }
            })
            .catch(error => {
                if(this.enableLogs){
                    console.log('error is', error);
                }
            });
    }



    async refreshCurrentTab() {
        try {
            const focusedTabInfo = await getFocusedTabInfo();
            const { tabId } = focusedTabInfo;
            await refreshTab(tabId, { includeAllSubtabs: true });
        } catch (error) {   
            if(this.enableLogs){
                console.error('Error refreshing tab:', error);
            }
        }
    }
    
    get hasRecentOrder() {
        return !this.isLoading && this.getOrderData.length > 0;
    }

    get getRecentOrderCount() {
        return this.getOrderData.length;
    }

    viewAll() {
        const encodedValues = encodeDefaultFieldValues({
            Search: 'All Orders',
            PONum: '',
            ISBnNum: '',
            startDate: null,
            endDate: null,
            OrderStatusValue: 'All',
            InvoNum: '',
            ZipNum: '',
            StateNum: '',
            CountryValue: '',
            DocContrNum: '',
            isShowingCredits: this.isShowingCredits
        });

        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Order_Status__c'
            },
            state: {
                defaultFieldValues: encodedValues,
                Source: 'comp'
            }
        });
    }

    orderrecorddetail(event) {
        event.preventDefault();
        // Reset any previous state
        this.params = {};
        const encodedValues = encodeDefaultFieldValues({
                Search: 'Order #',
                PONum: '',
                ISBnNum: '',
                startDate: null,
                endDate: null,
                OrderStatusValue: 'All',
                InvoNum: '',
                ZipNum: '',
                StateNum: '',
                CountryValue: '',
                DocContrNum: event.target.dataset.id,
            });           
        if(this.isInternal==false && this.isGuest == false){
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: 'Order_Status__c'
                },
                state: {
                    defaultFieldValues: encodedValues,
                    Source: 'comp'
                }
            });
        }
        else if(this.isInternal==true && this.isGuest == false){
            this[NavigationMixin.Navigate]({
                type: 'standard__navItemPage',
                attributes: {
                    apiName: 'Order_Status'
                },
                state: {
                    c__Search:'Order #',
                    c__PONum:'',
                    c__ISBnNum:'',
                    c__startDate:null,
                    c__endDate:null,
                    c__OrderStatusValue:'All',
                    c__InvoNum:'',
                    c__ZipNum:'',
                    c__StateNum:'',
                    c__CountryValue:'',
                    c__DocContrNum:event.target.dataset.id,
                }
            });
        }    
    }

    toggleResultFields(event) {
        let parentDiv = event.target.closest(".dropdown-container-mobile");
        let arrayEle = parentDiv.querySelectorAll('.full-width-in-mobile');
        for (let i = 0; i < arrayEle.length; i++) {
            arrayEle[i].classList.toggle('slds-show');
        }
        event.target.classList.toggle("chevron-up");
    }
}