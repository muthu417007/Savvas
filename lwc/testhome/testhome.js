import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { CurrentPageReference } from 'lightning/navigation';
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

export default class Testhome extends NavigationMixin(LightningElement) {
    @track orderData;
    @track error;
    @track userInfo;
    wiredOrderResult;
    wiredUserResult;
    
    noRecentOrderImage = No_Recent_Order;
    isShowingCredits = false;

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

    @wire(getOrderStatusData, { isCredits: false })
    wiredOrders(result) {
        this.wiredOrderResult = result;
        if (result.data) {
            this.orderData = JSON.parse(result.data);
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.orderData = undefined;
        }
    }

    @wire(getUserInformation)
    wiredUserInfo(result) {
        this.wiredUserResult = result;
        if (result.data) {
            this.userInfo = JSON.parse(result.data)[0];
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.userInfo = undefined;
        }
    }

    @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
        if (currentPageReference) {
            console.log('Current page reference:', currentPageReference);
            
            if (currentPageReference.type === 'standard__navItemPage' && 
                currentPageReference.attributes && 
                currentPageReference.attributes.apiName === 'Internal_Commerce_Home') {
                
                const previousPage = sessionStorage.getItem('previousPage');
                console.log('Previous page:', previousPage);
                
                if (previousPage === 'Order_Status') {
                    console.log('Coming from Order Status to Home, refreshing component...');
                    sessionStorage.removeItem('previousPage');
                    this.refreshComponent();
                }
            } else if (currentPageReference.type === 'standard__navItemPage' && 
                       currentPageReference.attributes && 
                       currentPageReference.attributes.apiName === 'Order_Status') {
                sessionStorage.setItem('previousPage', 'Order_Status');
            }
        }
    }

    refreshComponent() {
        console.log('Starting component refresh');
        return Promise.all([
            refreshApex(this.wiredOrderResult),
            refreshApex(this.wiredUserResult)
        ]).then(() => {
            console.log('Component data refreshed successfully');
        }).catch(error => {
            console.error('Error refreshing component data', error);
        });
    }

    connectedCallback() {
        console.log('ConnectedCallback');
        this.dispatchEvent(new CustomEvent('home', {
            detail: {
                page: 'home'
            }
        }));
    }

    get recentViewHeading() {
        return this.isShowingCredits ? this.labels.scc_home_Recent_Credits : "Recently Viewed Orders";
    }

    get viewAllLinkText() {
        return this.isShowingCredits ? 'View All Credits' : this.labels.scc_home_ViewAll;
    }

    get recentViewType() {
        return this.isShowingCredits ? 'Credits' : 'Orders';
    }

    get hasRecentOrder() {
        return this.orderData && this.orderData.length > 0;
    }

    get getRecentOrderCount() {
        return this.orderData ? this.orderData.length : 0;
    }

    showRecentOrders(event) {
        event.preventDefault();
        this.isShowingCredits = false;
        this.refreshComponent();
    }

    showRecentCredits(event) {
        event.preventDefault();
        this.isShowingCredits = true;
        this.refreshComponent();
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
        console.log('current order no', event.target.dataset.id);
        
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

        if (this.userInfo && !this.userInfo.isInternal && !this.userInfo.isGuest) {
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
        } else if (this.userInfo && this.userInfo.isInternal && !this.userInfo.isGuest) {
            this[NavigationMixin.Navigate]({
                type: 'standard__navItemPage',
                attributes: {
                    apiName: 'Order_Status'
                },
                state: {
                    c__Search: 'Order #',
                    c__PONum: '',
                    c__ISBnNum: '',
                    c__startDate: null,
                    c__endDate: null,
                    c__OrderStatusValue: 'All',
                    c__InvoNum: '',
                    c__ZipNum: '',
                    c__StateNum: '',
                    c__CountryValue: '',
                    c__DocContrNum: event.target.dataset.id,
                }
            });
        }
    }

    toggleResultFields(event) {
        let parentDiv = event.target.closest(".dropdown-container-mobile");
        let arrayEle = parentDiv.querySelectorAll('.full-width-in-mobile');
        console.log("parentDiv", parentDiv);
        console.log("arrayEle", arrayEle);
        for (let i = 0; i < arrayEle.length; i++) {
            arrayEle[i].classList.toggle('slds-show');
        }
        event.target.classList.toggle("chevron-up");
    }
}