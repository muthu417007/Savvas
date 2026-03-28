/*********************************************************
  Component Name       : sfccHomeOrderStatusSearch
  Created Date         : 06/10/2024  
  Author               : Cognizant 
  Description          : This component used in Home page and functionality related to 
                         search Order Status and redirecting to Order Status Page.
  
  Modifications Log
  06/10/2024     Zubiya           Initial Version
*********************************************************/

import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { loadStyle } from 'lightning/platformResourceLoader';
import headmarkupstyle_static from '@salesforce/resourceUrl/headmarkupstyle_static';

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

//Import apex classes
import getSearchByOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getSearchByOptions';
import getOrderStatusOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusOptions';
import getCountrysOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getCountrysOptions';
import getStatesOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getStatesOptions';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
//Import static resource
import scc_calender_icon from "@salesforce/resourceUrl/scc_calender_icon";

export default class Scc_homeLWC extends NavigationMixin(LightningElement) {

    @track SearchByOptions1;
    @track OrderStatusOptions1;
    @track SearchByvalue = 'PO#';
    @track OrderStatusValue = [{ label: 'All', value: 'All' }, { label: 'Open', value: 'Open' }, { label: 'Cancelled', value: 'Cancelled' }, { label: 'Fulfilled', value: 'Fulfilled' }];
    @track OrderStatusValue = '';
    @track PONumSelect = true;
    @track ISBNselect = false;
    @track InvoiceSelect = false;
    @track DocumentNumSelect = false;
    @track CountrysOptions1 = [{ label: 'United States', value: 'United States' }, { label: 'Canada', value: 'Canada' }];
    @track CountrysOptions2;
    @track CountrysOptions3;
    @track SearchDisabledReturn = true;
    @track stateOptions;
    stateLabel = scc_OrderStatus_State_Province;

    //For Internal User
    @track userName = '';
    @track accountName = '';
    @track isGuest = false;
    @track isInternal = false;
   @track selectedSearchByOption = 'PO#';

    labels = {
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
        scc_OrderStatus_Zip_Postal_Code,
        scc_calender_icon

    };

    constructor() {
        super();
        getSearchByOptions({ HomePage: true }).then(response => {
            let paser = JSON.parse(response);
            this.SearchByOptions1 = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
        })

        getOrderStatusOptions().then(response => {
            let paser = JSON.parse(response);
            this.OrderStatusOptions1 = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
        })

        getCountrysOptions().then(response => {
            let paser = JSON.parse(response);
            this.CountrysOptions2 = JSON.parse(response);
            this.CountrysOptions3 = [...this.CountrysOptions1, ...this.CountrysOptions2]
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })
        getStatesOptions().then(response => {
            this.stateOptions = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
        })
    }

    @track PONum = '';
    @track ISBnNum = '';
    @track InvoNum = '';
    @track startDate;
    @track endDate;
    @track CountryValue = '';
    @track StateNum = '';
    @track ZipNum = '';
    @track DocContrNum = '';

    handleArrowClick(event) {
    this.template.querySelector('select').focus();
    }

    handleNumChange(event) {
        if (event.target.name == 'PONum') {
            this.PONum = event.target.value;
        }

        if (event.target.name == 'ISBnNum') {
            this.ISBnNum = event.target.value;
        }

        if (event.target.name == 'startDate') {
            this.startDate = event.target.value;
        }

        if (event.target.name == 'endDate') {
            this.endDate = event.target.value;
        }

        if (event.target.name == 'InvoNum') {
            this.InvoNum = event.target.value;
        }

        if (event.target.name == 'ZipNum') {
            this.ZipNum = event.target.value;
        }

        if (event.target.name == 'StateNum') {
            this.StateNum = event.target.value;
        }

        if (event.target.name == 'DocContrNum') {
            this.DocContrNum = event.target.value;
        }
    }

    handleOrderStatusChange(event) {
        this.OrderStatusValue = event.target.value;
    }

    handleCountryOptionChange(event) {
        this.CountryValue = event.target.value;
    }

    handleStateNumChange(event) {
        this.StateNum = event.detail.value;
    }

    handleSearchByChange(event) {
        this.SearchByvalue = event.target.value;
        this.PONumSelect = false;
        this.ISBNselect = false;
        this.InvoiceSelect = false;
        this.DocumentNumSelect = false;
        if (this.SearchByvalue == 'PO#') {
            this.PONumSelect = true;
        }
        if (this.SearchByvalue == 'Containing ISBN') {
            this.ISBNselect = true;
        }
        if (this.SearchByvalue == 'Invoice #') {
            this.InvoiceSelect = true;
        }
        if (this.SearchByvalue == 'Order #') {
            this.DocumentNumSelect = true;
        }
    }

    get SearchByOptions() {
        return this.SearchByOptions1;
    }

    get CountryOptions() {
        return this.CountrysOptions3;
    }

    get OrderStatusOptions() {
        return this.OrderStatusOptions1;
    }

    renderedCallback() {
        loadStyle(this, headmarkupstyle_static).then(() => {
        }).catch(error => {
        })
    }

    //Extracts parameters from the current page and redirects to the “Order Status” page. 
    handleSearch(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            const encodedValues = encodeDefaultFieldValues({
                Search: this.SearchByvalue,
                PONum: this.PONum,
                ISBnNum: this.ISBnNum,
                startDate: this.startDate,
                endDate: this.endDate,
                OrderStatusValue: this.OrderStatusValue,
                InvoNum: this.InvoNum,
                ZipNum: this.ZipNum,
                StateNum: this.StateNum,
                CountryValue: this.CountryValue,
                DocContrNum: this.DocContrNum
            });
            if (this.isInternal == false) {
                this[NavigationMixin.Navigate]({
                    type: 'comm__namedPage',
                    attributes: {
                        name: 'Order_Status__c'  //Api name
                    },
                    state: {
                        defaultFieldValues: encodedValues,
                        Source: 'comp'
                    }
                });
            }
            else {

                this[NavigationMixin.Navigate]({
                    type: 'standard__navItemPage',
                    attributes: {
                        apiName: 'Order_Status'
                    },
                    state: {
                        // defaultFieldValues: encodedValues
                        c__Search: this.SearchByvalue,
                        c__PONum: this.PONum,
                        c__ISBnNum: this.ISBnNum,
                        c__startDate: this.startDate,
                        c__endDate: this.endDate,
                        c__OrderStatusValue: this.OrderStatusValue,
                        c__InvoNum: this.InvoNum,
                        c__ZipNum: this.ZipNum,
                        c__StateNum: this.StateNum,
                        c__CountryValue: this.CountryValue,
                        c__DocContrNum: this.DocContrNum
                    }
                });
            }
        }
    }

    // Determines if search functionality should be disabled based on input values.
    get SearchDisabled() {
        if ((this.PONum != '' && this.SearchByvalue == 'PO#') || (this.InvoNum != '' && this.SearchByvalue == 'Invoice #') || (this.ISBnNum != '' && this.SearchByvalue == 'Containing ISBN') || (this.DocContrNum != '' && this.SearchByvalue == 'Order #')) {
            this.SearchDisabledReturn = false;
        } else {
            this.SearchDisabledReturn = true;
        }
        return this.SearchDisabledReturn;
    }

    connectedCallback() {
        getUserInformation().then(response => {
            let paser = JSON.parse(response);
            let data = paser[0];
            this.userName = data.userName;
            this.accountName = data.accountName;
            this.isGuest = data.isGuest;
            this.isInternal = data.isInternal;
        }).catch(error => {
            console.log('error is', error);
        })
        this.isLoading1 = false;
    }
}