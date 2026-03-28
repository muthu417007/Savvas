import { LightningElement, wire, track, api } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getWorkOrderList from '@salesforce/apex/Sav_FSL_WorkOrderLightningDataTable.getWorkOrderList';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import ContactMobile from '@salesforce/schema/Case.ContactMobile';

const columns = [
    { 
        label: 'Work Order Number',
        fieldName: 'WorkOrderNumber',
        type:'Auto Number',
        sortable: true
    },
    {
        label: 'Subject',
        fieldName: 'Subject',
        type: 'Text',
        sortable: true
    },
       { 
        label: 'Service Type',
        fieldName: 'Sav_FSL_Service_Type__c',
        type:'Picklist',
        sortable: true
    },
    {
        label: 'Material Number Long Title',
        fieldName: 'Sav_FSL_Material_Number_Title__c',
        type:'Text',
        sortable: true
    },
    { 
        label: 'Parent Account',
        fieldName: 'Parent Account',
        type:'Formula (Text)',
        sortable: true
    },
    { 
        label: 'Priority',
        fieldName: 'Priority',
        type:'Picklist',
        sortable: true
    },{ 
        label: 'Status',
        fieldName: 'Status',
        type:'Picklist',
        sortable: true
    },
    { 
        label: 'Number Of Sessions',
        fieldName: 'Sav_FSL_Sessions__c',
        type:'Number',
        sortable: true
    },
    { 
        label: 'SAP Order Quantity',
        fieldName: 'Sav_FSL_SAP_Order_Quantity__c',
        type:'Number',
        sortable: true
    },
    {
        label: 'Service Appointment Count',
        fieldName: 'ServiceAppointmentCount',
        type: 'Number',
        sortable: true
    }
];

export default class createServiceRequestOnWO extends LightningElement {
    @track columns = columns
    @track error;
    @track data;
    @track noData;

    @api OpportunityId ;

    @api 
    title;

    async connectedCallback(){
        //defined a varibale
        try{
            if(this.OpportunityId){
                const result = await getWorkOrderList({OpportunityId:this.OpportunityId});
                console.log('Results--');
                console.log(JSON.stringify(result));
              /*  if (result.length !== 0) {
                    this.data = result;
                    this.title = 'PAID Service WORK ORDERS - '+result[0].Sav_FSL_Opportunity__r.Name;
                }
                else if(result.length === 0){
                    console.log('no data section');
                    this.noData = 'No current WorkOrder associated Opportunity found';
                } */
                if(result.isSuccess === true){
                        this.data = result.response;
                        this.title = 'PAID Service WORK ORDERS - '+result.response[0].Sav_FSL_Opportunity__r.Name;
                }
                if(result.response == '' || result.response == undefined || result.response == null){
                 this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Application Error',
                                message: 'This Opportunity has no Work Order associated to it.',
                                variant: 'error',
                            }),
                        );
                }
        }    
  
        }catch(error){
            this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Application Error',
                                message: error.body.message,
                                variant: 'error',
                            }),
                        );
        }    
    }    
    
    //this.checkSubmit=true;
    noRowSelected = true;
    rowSelected = false;
    @api
    selectedRows = [];

    @api
    difference;

    @api
    selectedButtonId; //Property that'll store the buttonId

    @api
    buttonId; //Unique button Id

    @api
    availableActions = [];

     @api
    sessionsXqty;

    @api
    ServiceAppCount;

    @api
    selectedWo_Id;

    @api
    selectedWo_Name;

    workOrderLst = [];

    getSelectedName(event) {
        this.selectedRows = event.detail.selectedRows;
        //alert('>>>>>'+this.selectedRows.length);
        if(this.selectedRows.length !== 0){
            //alert('>>>>>'+this.selectedRows.length);
            this.noRowSelected=false;
            this.rowSelected = true;
            this.workOrderLst = this.template.querySelector('lightning-datatable').getSelectedRows();
            console.log(this.workOrderLst[0]);
            this.sessionsXqty = ((this.workOrderLst[0].Sav_FSL_SAP_Order_Quantity__c * this.workOrderLst[0].Sav_FSL_Sessions__c));
            this.ServiceAppCount = this.workOrderLst[0].ServiceAppointmentCount;
            this.difference = ((this.workOrderLst[0].Sav_FSL_SAP_Order_Quantity__c * this.workOrderLst[0].Sav_FSL_Sessions__c) - this.workOrderLst[0].ServiceAppointmentCount);
            this.selectedWo_Id = (this.workOrderLst[0].Id);
            this.selectedWo_Name = (this.workOrderLst[0].WorkOrderNumber);
            console.log(this.workOrderLst[0].Sav_FSL_SAP_Order_Quantity__c);
            console.log(this.workOrderLst[0].Sav_FSL_Sessions__c);
            console.log(this.workOrderLst[0].ServiceAppointmentCount);
            console.log('Difference - '+this.difference);
        }
        else if(this.selectedRows.length == 0){
            this.noRowSelected=true;
            this.rowSelected = false;
        }
    }

    handleNavigation(event) {
        this.selectedButtonId = event.target.label; //Setting the buttonId when button is clicked.
        /** Navigating to next screen */
        if (this.availableActions.find(action => action === 'NEXT')) {
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }

    clearSelection(event){
        this.template.querySelector('lightning-datatable').selectedRows=[];
        this.noRowSelected=true;
        this.rowSelected = false;
    }
}