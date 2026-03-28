import { LightningElement,track,api,wire } from 'lwc';
import scc_OrderStatusReportTracking from "@salesforce/label/c.scc_OrderStatusReportTracking";// added by sudha W-014819
import scc_OrderStatusReportSummary from "@salesforce/label/c.scc_OrderStatusReportSummary";// added by sudha W-014819
import scc_OrderStatusReportDetail from "@salesforce/label/c.scc_OrderStatusReportDetail";// added by sudha W-014819
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import scc_calender_icon from "@salesforce/resourceUrl/scc_calender_icon";
import getOrderStatusOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusOptions';
import getOrderEntryOptions from '@salesforce/apex/scc_editReportController.getOrderEntryOptions';
import getOrderItemData from '@salesforce/apex/testeditcontroller.getOrderItemData';
//  import SELECTED_REPORT_DATA from '@salesforce/messageChannel/scc_reportMessageChannel__c';
// import { publish, MessageContext } from 'lightning/messageService';
export default class TestEditCriteria extends LightningElement {
 @api fromcomponent
    //track 
    @track editedreportName='';
    @track Last_N_MONTH='';
     @track includeAllISBNs = true;
     @track includeAllPOs = true; 
     @track specificISBNs = '';
     @track specificPOs = '';
     @track closeDisabled = true;
    @track runreportDisabled = true;
    @track showclosewindow=false;
    startDate='';
    endDate='';
    OrderStatusValue;
    orderEntryPeriod;
    isbnValues = '';
    poValues = '';
    @track isbns=[];
    showEditPage=true;
    @track saveDisabled=false
@track ipos =[];
@track SortOrderOptions1    =  [{ label: 'Zip', value: 'Zip' },{ label: 'ISBN', value: 'ISBN' }, { label: 'Order Entry Date', value: 'Order Entry Date' }, { label: 'PO #', value: 'PO #' }, { label: 'State', value: 'State' }];
@track SortOrderOptions2   =  [{ label: 'Zip', value: 'Zip' },{ label: 'ISBN', value: 'ISBN' }, { label: 'Order Entry Date', value: 'Order Entry Date' }, { label: 'PO #', value: 'PO #' }, { label: 'State', value: 'State' }];
@track SortOrderOptions3   =  [{ label: 'Zip', value: 'Zip' },{ label: 'ISBN', value: 'ISBN' }, { label: 'Order Entry Date', value: 'Order Entry Date' }, { label: 'PO #', value: 'PO #' }, { label: 'State', value: 'State' }];
@track OrderStatusOptions1  = [{ label: 'All', value: 'All' }, { label: 'Open', value: 'Open' }, { label: 'Cancelled', value: 'Cancelled' }, { label: 'FullFilled', value: 'FullFilled' }];
@track OrderEntryOptions1   = [{ label: 'Last 12 months', value: 'Last_12_months' }, { label: 'Last 18 months', value: 'Last_18_months' }, { label: 'Last_24_months', value: 'Last_24_months' }, 

{ label: 'Last 3 months', value: '3' },
{ label: '	Last 36 months', value: 'Last_36_months' },
{ label: '	Last 6 months', value: 'Last_6_months' },{ label: 'Last month', value: '	Last_month' }];
//api
@api editedreport;
@track valuefromC =false;
connectedCallback() {
    this.editedreportName = this.editedreport;
    this.setDescription();
    console.log('editdname from ',this.editedreportName);
    console.log('editdname from ',this.editedreport);

    getOrderStatusOptions().then(response => {
            console.log('response is', response);
            let paser = JSON.parse(response);
            console.log('getOrderStatusOptions', paser);
            this.OrderStatusOptions1 = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })
        getOrderEntryOptions().then(response => {
            console.log('response is', response);
            let paser = JSON.parse(response);
         
            this.OrderEntryOptions1 = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })

}
//  @wire(MessageContext)
//     messageContext;
setDescription() {
        switch (this.SearchByvalue) {
            case 'Order Status Report – Summary':
                this.editedreportName = scc_OrderStatusReportSummary;
                break;
            case 'Order Status Report – Detail':
                this.editedreportName = scc_OrderStatusReportDetail;
                break;
            case 'Order Status Report – Tracking':
                this.editedreportName = scc_OrderStatusReportTracking;
                break;
            case 'Custom Report':
                this.editedreportName = 'Description for Custom Report';
                break;
            default:
                this.editedreportName = '';
        }
    }
     

     labels = {
        scc_OrderStatusReportTracking,
        scc_OrderStatusReportSummary,
        scc_OrderStatusReportDetail,
        scc_calender_icon
    }
     alertIcon = imageIcons + '/Images/alert.png';

 handleCheckboxChange(event) {
        const field = event.target.dataset.id;
        console.log(field,'field');
        if (field === 'include-all-isbns') {
            this.includeAllISBNs = event.target.checked;
        } else if (field === 'include-all-pos') {
            this.includeAllPOs = event.target.checked;
        }
        console.log(this.includeAllPOs,'this.includeAllPOs');
    }
 handleSpecificISBNsChange(event) {

        this.specificISBNs = event.target.value;
        const rawInput = event.target.value;
        console.log(rawInput)
        const lines = rawInput.split('\n');
        console.log(lines)
        const cleanedLines = lines.map(line => line.trim().replace(/[^\dA-Za-z]/g, ''));
        console.log(cleanedLines)
        const nonEmptyLines = cleanedLines.filter(line => line.length > 0);
        console.log(nonEmptyLines)
        this.isbns = nonEmptyLines;
        console.log(this.isbns)
         this.checkEnableRunReport();
    }

 handleSpecificPOsChange(event) {
        this.specificPOs = event.target.value;
        const rawInput = event.target.value;
        console.log(rawInput)
        const lines = rawInput.split('\n');
        console.log(lines)
        const cleanedLines = lines.map(line => line.trim().replace(/[^\dA-Za-z]/g, ''));
        console.log(cleanedLines)
        const nonEmptyLines = cleanedLines.filter(line => line.length > 0);
        console.log(nonEmptyLines)
        this.ipos = nonEmptyLines;
        console.log(this.ipos)
         this.checkEnableRunReport();
    }
get isISBNDisabled() {
        return this.includeAllISBNs;
         this.checkEnableRunReport();
    }

 get isPODisabled() {
        return this.includeAllPOs;
    }
 get OrderStatusOptions() {
        return this.OrderStatusOptions1;
    }
 get OrderEntryOptions (){
        return this.OrderEntryOptions1;
    }
handleStartDateChange(event) {
        this.startDate = event.target.value;
        this.formatStartDate=new Date(this.startDate)
        console.log(' this.startDate',this.startDate);
        this.checkEnableRunReport();
    }

 handleEndDateChange(event) {
        this.endDate = event.target.value;
        this.formatEndDate=new Date(this.endDate)
         console.log(' this.endDate',this.endDate);
        this.checkEnableRunReport();
    }

handleOrderStatusOptionChange(event) {
        this.OrderStatusValue = event.target.value;
        

        console.log(' this.OrderStatusValue',this.OrderStatusValue);
        this.checkEnableRunReport();

    }
   

handleOrderEntrOptionChange(event){
    this.orderEntryPeriod = event.target.value;
   
    if(this.orderEntryPeriod=='Last month'){
    this.Last_N_MONTH='1';
    }
    if(this.orderEntryPeriod=='Last 3 months'){
    this.Last_N_MONTH='3';
    }
    if(this.orderEntryPeriod=='Last 6 months'){
    this.Last_N_MONTH='6';
    }
    if(this.orderEntryPeriod=='Last 12 months'){
    this.Last_N_MONTH='12';
    }
    if(this.orderEntryPeriod=='Last 18 months'){
    this.Last_N_MONTH='18';
    }
    if(this.orderEntryPeriod=='Last 24 months'){
    this.Last_N_MONTH='24';
    }
    if(this.orderEntryPeriod=='Last 36 months'){
    this.Last_N_MONTH='36';
    }
     console.log(' this.Last_N_MONTH',this.Last_N_MONTH);
        this.checkEnableRunReport();
    }

 handleSearchOptionChange1(event) {
        this.SortOrder1 = event.target.value;
        this.checkEnableRunReport();
        console.log(this.SortOrder1)
    }
 handleSearchOptionChange2(event) {
        this.SortOrder2 = event.target.value;
        this.checkEnableRunReport();
        console.log(this.SortOrder2)
    }
 handleSearchOptionChange3(event) {
        this.SortOrder3 = event.target.value;
        this.checkEnableRunReport();
        console.log(this.SortOrder3)
    }
checkEnableRunReport() {
        this.runreportDisabled = !(
            this.startDate ||
            this.endDate ||this.orderEntryPeriod ||
            this.OrderStatusValue ||
            this.SortOrder1 ||this.SortOrder2 ||this.SortOrder3||
            (!this.includeAllISBNs && this.specificISBNs) ||
            (!this.includeAllPOs && this.specificPOs)
        );
        this.closeDisabled = !(
            this.startDate ||
            this.endDate ||this.orderEntryPeriod ||
            this.OrderStatusValue ||
            this.SortOrder1 ||this.SortOrder2 ||this.SortOrder3||
            (!this.includeAllISBNs && this.specificISBNs) ||
            (!this.includeAllPOs && this.specificPOs)
        );
 }

 handleRunReport() {
     this.valuefromC=true;
       this.showEditPage=false;
     console.log(this.Last_N_MONTH);
     console.log('form ',this.fromcomponent)
     console.log(this.isbns);
     console.log(this.OrderStatusValue);
      console.log(this.SortOrder1);
       console.log(this.SortOrder2);
        console.log(this.SortOrder3);
        getOrderItemData({ 
            startDate: this.formatStartDate,
            endDate: this.formatStartDate,
            orderStatus: this.OrderStatusValue,
            poList : this.ipos,
          isbnList : this.isbns,
            SortOrder1: this.SortOrder1,
            SortOrder2: this.SortOrder2,
            SortOrder3: this.SortOrder3,           
            orderEntryPeriod: this.Last_N_MONTH,
            
        })
         
     .then(data => { 
             this.records = data
                console.log('this.records', this.records);
                //data retrived caaling b comp
               
              
                    const resultsEvent = new CustomEvent('dataretrieved', {
                    detail: { results: this.records,valuefromC:this.valuefromC, editedreport: this.editedreport,}
                  
                         
                 });
                 this.dispatchEvent(resultsEvent);
                
                  
                 
   
    
            })
 
           
//         .then(data => { 
//             this.records = data
//     const payload = {
//         reportData: JSON.stringify(this.records) 
//     };

//     publish(this.messageContext, SELECTED_REPORT_DATA, payload);
//     console.log('Message published:', payload);
// })

            .catch(error => {
                this.error = error;
                console.error('Error fetching summary report:', error);
            });
              
    }


handleClose(){
    this.showclosewindow=true;
}
closeModal(){
    this.showclosewindow=false;
}
handleOpen(){
    this.showEditPage=false;
     console.log('open button clicked');
        this.dispatchEvent(new CustomEvent('open', { 
            detail: { 
                editedreport: this.editedreport,
                recordsData: this.recordsData
            }
        }));
    }
 handleCancel(){
      this.showclosewindow=false;
}
     
 @track savereport=false;
@track isDisabled=true;

@track radioOptions=[
    {
        label:'enable text area', value:'enable'}
    
];

@track Description="this is save report"
saveahander(){
    this.savereport=true
}
handleradioChange(event) {
    //     const field = event.target.dataset.id;
    //     console.log(field,'field');
    //     if (field === 'include-all-description') {
    //         this.includeDescription = event.detail.value;
    //     } 
    //     console.log(this.includeDescription,'this.includeDescription');
    // }

    this.value=event.traget.value;
    if(this.value ==='enable'){
        this.isDisabled=false;
        this.Description=this.Description;
    }
}
}