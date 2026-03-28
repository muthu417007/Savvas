import { LightningElement,track,api } from 'lwc';
//import getSummaryReport from '@salesforce/apex/scc_Custom_ReportsController.summaryReport';
import getDetailReport from '@salesforce/apex/scc_Custom_ReportsController.detailReport';
import sendReportEmail from '@salesforce/apex/scc_reportEmailService.sendReportEmail';
import saveOrUpdateReportFilters from '@salesforce/apex/scc_ReportFilterController.saveOrUpdateReportFilters';
import fetchCustomReportData from '@salesforce/apex/scc_editReportController.fetchCustomReportData';
import fetchReportDetails from '@salesforce/apex/scc_editReportController.fetchReportDetails';
import { RefreshEvent } from 'lightning/refresh';
import scc_OrderStatusReportTracking from "@salesforce/label/c.scc_OrderStatusReportTracking";// added by sudha W-014819
import scc_OrderStatusReportSummary from "@salesforce/label/c.scc_OrderStatusReportSummary";// added by sudha W-014819
import scc_OrderStatusReportDetail from "@salesforce/label/c.scc_OrderStatusReportDetail";// added by sudha W-014819
import imageIcons from '@salesforce/resourceUrl/scc_Images';
export default class scc_View_Run_Report_LWC extends LightningElement {
    excelIcon =  imageIcons + '/Images/excel.png';
    emailIcon = imageIcons + '/Images/EmailIconWithoutColor.png';
    @track showEmailReportPopup = false;
    @track emailAddresses = [];
    @track emailInput = '';
    @track isDisabled = true;
    @track isoverrideDisabled=true;
    @track isLoading= false;
 labels = {
        scc_OrderStatusReportTracking,
        scc_OrderStatusReportSummary,
        scc_OrderStatusReportDetail
    }
    @track Description='';
    @track recordsToDisplay = [];
    @api selectedreport;
    @api showdetailpage;
    @api shipnum;
    @api billnum;
    @track closingchild=false;
    closeDisabled = true
    @track OrderStatusReport=false; //
    //editcriteriaDisabled = true;
    @track showSummaryReport = false;
    @track showDetailReport = false;
    @track showTrackingReport = false;
     @track EditedReportName;
    runreportDisabled = true
    emailDisabled=true
    saveDisabled=true
    @track records=[];
     First = '<< First'
    Previous = '< Previous'
    next = 'Next >'
    Last = 'Last >>'
    pageSizeOptions = [15, 30, 45, 60]; //Page size options
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    @track totalPages = 1; //Total no.of pages
    pageNumber = 1; //Page number    
    closeDisabled =true ;
    editcriteriaDisabled =true ;
   // runreportDisabled  =true ;
    @track displayedRecords=0;
    // c comp values 
    @track showPopup =false;
    @track gotformC =false
    isdetailedopen=false;
    @api childrecords;
    @api customdescription;
    @api cmsg
    @api editedreport;
    @api originalreporttype;
    @track Detailopenafteredits=false;
     get bDisableFirst() {
        return this.pageNumber == 1;
    }

    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }


    get SearchByOptions() {
        return this.SearchByOptions1;
    }

    get noRecordsToDisplay() {
        return this.recordsToDisplay.length == 0;
    }
     handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }

    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }

    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }

    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }

    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }


    // JS function to handel pagination logic 
    paginationHelper() {
        this.recordsToDisplay = [];
        console.log(this.recordsToDisplay);
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        console.log(this.totalPages);
        // set page number 
        if (this.totalPages <= 1) {
            this.totalPages = 1;
        }

        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
      console.log(this.pageNumber);
        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.records[i]);
            this.displayedRecords=this.recordsToDisplay.length;
        }
        console.log('this.recordsToDisplay',this.recordsToDisplay);
    }
@track displayedReportName='';
@track oldoriginalReportName='';
@track selectedReportName='';
    // connectedCallback
    connectedCallback() {
       this.customReportDescription=this.customdescription;
       this.oldoriginalReportName =this.originalreporttype;
       this.maintainsourceoforiginalreport=this.originalreporttype;
       this.selectedReportName=this.editedreport;
        this.selectedValue = 'SaveAS';
        console.log('this.Description ', this.customReportDescription);
        console.log('show Custom report Name with [Custom] with this selectedReportName ', this.selectedReportName);
        console.log('this.Description ', this.customReportDescription);
         console.log('this.oldoriginalReportName ', this.oldoriginalReportName);
        this.handleDefaultSelection();
        this.records = this.childrecords;

        this.EditedReportName = this.editedreport;
        this.msg = this.cmsg;
        console.log('component B1 is notified ', this.childrecords);
         console.log('maintainsourceoforiginalreport ', this.maintainsourceoforiginalreport);
        console.log('component B1 is notified with originalreporttype ', this.originalreporttype);
        console.log('component B2 is notified ', this.editedreport);
        console.log('component B 3is notified ', this.cmsg);
         if (this.editedreport.endsWith('[custom]')) {
            this.displayedReportName = this.editedreport.replace(' [custom]', '');
            this.Description=this.customReportDescription;
        } else {
            // For standard reports, use the name as is
            this.displayedReportName = this.editedreport;
        }


        if (this.msg === true) { 
              this.seteditvalues();
              console.log('name ', this.selectedreport);
 
            this.isdetailedopen == true
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.emailDisabled = false;
            this.saveDisabled = true
            // this.gotformC=true;
            this.handledata();// handle data call  when  edit criteria component render from  Parent Component directly 
            this.setDescription();
        }
        if (this.msg === false) { // this is intial loading  and after closing the report detail and ediit report page 
            console.log('this.billnum ', this.billnum);
            console.log('this.shipnum ', this.shipnum);
            console.log(this.showdetailpage, '@@@@@@@@@@@@@@@');
            this.setDescription();

            this.EditedReportName = this.selectedreport
            console.log('EditedReportName', this.EditedReportName);
            this.setvalues();
        }
    }
    setvalues() {
          console.log('calling 1');
        if (this.selectedreport && this.selectedreport.endsWith('[custom]')) {
            console.log(this.selectedreport);
              console.log('calling 2');
            this.loadCustomReportData();
        
            
        }
        if (this.selectedreport === 'Order Status Report – Summary') {
            this.OrderStatusReport = true;
            this.showSummaryReport = true;
            this.showDetailReport = false;
            this.showTrackingReport = false;
            this.isdetailedopen = this.showdetailpage;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = true
            this.fetchDetailReport();
        }
        if (this.selectedreport === 'Order Status Report – Detail') {
            this.OrderStatusReport = true;
            this.showDetailReport = true;
            this.showSummaryReport = false;
            this.showTrackingReport = false;
            this.isdetailedopen = this.showdetailpage;
            console.log(this.isdetailedopen);
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = true
          
            this.fetchDetailReport();
            
            console.log('this.fetchDetailReport();', this.fetchDetailReport());
        }
        if (this.selectedreport === 'Order Status Report – Tracking') {
            this.OrderStatusReport = true;
            this.showDetailReport = false;
            this.showSummaryReport = false;
            this.showTrackingReport = true;
            this.isdetailedopen = this.showdetailpage;
            console.log(this.isdetailedopen);
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = true
            this.fetchDetailReport();
        }
    }
    // set edit valued for only when  edit criteria component reder from parent component
    seteditvalues() {
        this.selectedReportName=this.selectedreport
         console.log('calling seteditvalues',this.selectedreport);
          console.log('show Custom report Name with [Custom] with this selectedReportName ', this.selectedReportName);
          console.log('calling originalreporttype',this.originalreporttype);
         if (this.selectedreport && this.selectedreport.endsWith('[custom]')) {
            console.log(this.selectedreport);
              console.log('calling 2');
              switch (this.originalreporttype) {
                    case 'Order Status Report – Summary':
                            this.OrderStatusReport = true;
                           this.OrderStatusReport = true;
                            this.showSummaryReport = true;
                            this.showDetailReport = false;
                            this.showTrackingReport = false;
                            this.isdetailedopen = this.showdetailpage;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = false
           

                        break;
                    case 'Order Status Report – Detail':
                            this.OrderStatusReport = true;
                        this.showDetailReport = true;
                        this.showSummaryReport = false;
                        this.showTrackingReport = false;
                        this.isdetailedopen = this.showdetailpage;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = false
           
                        break;
                    case 'Order Status Report – Tracking':
                    this.isdetailedopen = this.showdetailpage;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = false
           
                        this.OrderStatusReport = true;
            this.showDetailReport = false;
            this.showSummaryReport = false;
            this.showTrackingReport = true;
                        break;
                    default:
                        console.log('No specific report type matched');
                        break;
                }
         }

        if (this.selectedreport === 'Order Status Report – Summary') {
            console.log('Summary',this.selectedreport);
            this.OrderStatusReport = true;
            this.showSummaryReport = true;
            this.showDetailReport = false;
            this.showTrackingReport = false;
            this.isdetailedopen = this.showdetailpage;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = false

        }
        if (this.selectedreport === 'Order Status Report – Detail') {
            console.log('Detail');
            this.OrderStatusReport = true;
            this.showDetailReport = true;
            this.showSummaryReport = false;
            this.showTrackingReport = false;
            this.isdetailedopen = this.showdetailpage;
            console.log(this.isdetailedopen);
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = false
          

        }
        if (this.selectedreport === 'Order Status Report – Tracking') {
             console.log('Tracking');
            this.OrderStatusReport = true;
            this.showDetailReport = false;
            this.showSummaryReport = false;
            this.showTrackingReport = true;
            this.isdetailedopen = this.showdetailpage;
            console.log(this.isdetailedopen);
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = false
          
           
        }
    }
    //  dynamically Description feild will update 
    // setDescription() {
    //     switch (this.selectedreport) {
    //         case 'Order Status Report – Summary':
    //             this.Description = scc_OrderStatusReportSummary;
    //             break;
    //         case 'Order Status Report – Detail':
    //             this.Description = scc_OrderStatusReportDetail;
    //             break;
    //         case 'Order Status Report – Tracking':
    //             this.Description = scc_OrderStatusReportTracking;
    //             break;
    //         case 'Custom Report':
    //             this.Description = 'Description for Custom Report';
    //             break;
    //         default:
    //             this.Description = '';
    //     }
    // }
//     setDescription() {
//         const standardDescriptions = {
//             'Order Status Report – Summary': scc_OrderStatusReportSummary,
//             'Order Status Report – Detail': scc_OrderStatusReportDetail,
//             'Order Status Report – Tracking': scc_OrderStatusReportTracking
//         };

//         if (standardDescriptions[this.editedreport]) {
//             // Set the description from the predefined list if it matches
//             this.Description = standardDescriptions[this.editedreport];
//         } 

// if (this.editedreport.endsWith('[custom]')) {
//             this.Description = this.customdescription;
//         } 

//     }
     setDescription() {
    const standardDescriptions = {
        'Order Status Report – Summary': scc_OrderStatusReportSummary,
        'Order Status Report – Detail': scc_OrderStatusReportDetail,
        'Order Status Report – Tracking': scc_OrderStatusReportTracking
    };

    
    console.log('Edited Report:', this.editedreport);

    
    
   

    if (this.editedreport && standardDescriptions[this.editedreport]) {
        
        this.Description = standardDescriptions[this.editedreport];
        console.log('Standard report description set:', this.Description);
    } else if (this.editedreport && this.editedreport.endsWith('[custom]')) {
        
        this.Description = this.customReportDescription; 
        console.log('Custom report description set:', this.Description);
    } else {
       
        console.log('No matching conditions for setting description');
    }
}

    // track variables for updating dates 
    @track minDateElement;
    @track maxDateElement;
    @track minOrderDateFirst15;
    @track maxOrderDateFirst15;
    // fetchSummaryReport() {
    //     getSummaryReport()
    //         .then(data => {
              
    //             this.records = data
    //         this.pageSize = this.pageSizeOptions[0];
    //         this.totalRecords = this.records.length;
    //         this.calculateDateRange();
    //         this.paginationHelper();

    //         })
    //         .catch(error => {
    //             this.error = error;
    //             console.error('Error fetching summary report:', error);
    //         });
              
    // }
// calculate the dates 
 calculateDateRange(){

     if (Array.isArray(this.records) && this.records.length > 0) {
            const orderDates = this.records.map(record => new Date(record.orderDate));
    //  const orderDates = this.records.map(record => new Date(record.orderDate));
                const first15Records = this.records.slice(0, 15);
                const orderDatesFirst15 = first15Records.map(record => new Date(record.orderDate));

                // Find minimum and maximum dates for the first 15 records
                this.minOrderDateFirst15 = this.formatDate(new Date(Math.min(...orderDatesFirst15)));
                this.maxOrderDateFirst15 = this.formatDate(new Date(Math.max(...orderDatesFirst15)));

                
                // Find minimum and maximum dates
               this.minOrderDate = this.formatDate(new Date(Math.min(...orderDates)));
                this.maxOrderDate = this.formatDate(new Date(Math.max(...orderDates)));
            //    console.log('Data fetched from Apex:', JSON.stringify(data));
                console.log('Minimum Order Date for All Records:', this.minOrderDateAll);
                console.log('Maximum Order Date for All Records:', this.maxOrderDateAll);
                console.log('Minimum Order Date for First 15 Records:', this.minOrderDateFirst15);
                console.log('Maximum Order Date for First 15 Records:', this.maxOrderDateFirst15);
                } else {
            console.error('Records is not an array or is empty:', this.records);
        }
    }
  
 fetchDetailReport() {    
        getDetailReport({BillTo :this.billnum ,ShipTo :this.shipnum })
            .then(data => {
            console.log('Detail Reports Records',data);  
            this.records = data
            console.log('Detail rEports Records',this.records);
            this.pageSize = this.pageSizeOptions[0];
            this.totalRecords = this.records.length;
            this.paginationHelper();
            this.calculateDateRange();  
            //this.orderDate = this.formatDate(this.records.orderDate);            

            })
            .catch(error => {
                this.error = error;
                console.error('Error fetching detail report:', error);
            });
              
    }
// // loadCustomReportData() {
//      console.log('Data fetched for custom report:',this.selectedreport );
//         fetchCustomReportData({ reportNameWithCustom: this.selectedreport })
         
//             .then(result => {
//                 console.log('Data fetched for custom report:', result);
//                 this.records = result;
//                  console.log('Data fetched for custom report2:', this.records);
//             console.log('Detail rEports Records',this.records);
//             this.pageSize = this.pageSizeOptions[0];
//             this.totalRecords = this.records.length;
//             this.paginationHelper();
//             this.calculateDateRange(); 
//             })
//             .catch(error => {
//                 console.error('Error fetching custom report data:', error);
//             });
//     }


   formatDate(date) {
        const month = (date.getMonth() + 1).toString().padStart(2, '0');
        const day = date.getDate().toString().padStart(2, '0');
        const year = date.getFullYear();
        return `${month}/${day}/${year}`;
    }


    runreporthander(){
        console.log('called')
        this.isdetailedopen=true;
        this.OrderStatusReport=true;
    }
    
//  download report
loadCustomReportData() {
    console.log('Data fetched for custom report:', this.selectedreport);
    fetchCustomReportData({ reportNameWithCustom: this.selectedreport })
        .then(result => {
            console.log('Data fetched for custom report:', result);
            this.records = result;
            console.log('Data fetched for custom report2:', this.records);
           
            //this.Description = result.description;
            // Reset flags
           // this.OrderStatusReport = false;
           // this.showSummaryReport = false;
           // this.showDetailReport = false;
           // this.showTrackingReport = false;

            // Set flags based on originalReport
            if (this.records.length > 0) {
                let originalReportName = this.records[0].originalReport;
                this.maintainsourceoforiginalreport = originalReportName;
               // this.Description = this.records[0].description;
                console.log('Original Report Name:', this.maintainsourceoforiginalreport);
                
                switch (originalReportName) {
                    case 'Order Status Report – Summary':
                            this.OrderStatusReport = true;
                           this.OrderStatusReport = true;
                            this.showSummaryReport = true;
                            this.showDetailReport = false;
                            this.showTrackingReport = false;
                            this.isdetailedopen = this.showdetailpage;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false;
            this.saveDisabled = true;
           

                        break;
                    case 'Order Status Report – Detail':
                            this.OrderStatusReport = true;
                        this.showDetailReport = true;
                        this.showSummaryReport = false;
                        this.showTrackingReport = false;
                        this.isdetailedopen = this.showdetailpage;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = true;
           
                        break;
                    case 'Order Status Report – Tracking':
                    this.isdetailedopen = this.showdetailpage;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = true
           
                        this.OrderStatusReport = true;
            this.showDetailReport = false;
            this.showSummaryReport = false;
            this.showTrackingReport = true;
                        break;
                    default:
                        console.log('No specific report type matched');
                        break;
                }
            }
             this.pageSize = this.pageSizeOptions[0];
            this.totalRecords = this.records.length;
            this.paginationHelper();
            this.calculateDateRange();
        })
        
        .catch(error => {
            console.error('Error fetching custom report data:', error);
        });
}

  handleExport(){
        // Prepare CSV content 
        // let csvContent = 'data:text/csv;charset=utf-8,'; 
        // Add header row
        let csvContent='';
        let relatedColumns =[];
        let fileName = '';
        if(this.showSummaryReport){
            relatedColumns = [
                { label: 'PO #', fieldName: 'PO' },
                { label: 'ISBN', fieldName: 'isbn13' },
                { label: 'Title Description', fieldName: 'productDescription' },
                { label: 'Order Date', fieldName: 'orderDate' },
                { label: 'Order #', fieldName: 'orderNumber' },
                { label: 'Ordered Qty', fieldName: 'orderedQuantity' },
                { label: 'Shipped Qty', fieldName: 'shippedQuantity' },
                { label: 'Backorder Qty', fieldName: 'backorderQuantity' },
                { label: 'Due Date', fieldName: 'dueDate' },
                { label: 'On Hold Qty', fieldName: 'holdQuantity' },
                { label: 'Shippable Quantity', fieldName: 'shippedQuantity' },
                { label: 'Cancelled Quantity', fieldName: 'cancelledQuantity' },
                { label: 'Ship-to Account #', fieldName: 'shipAccount' },
                { label: 'Ship-to Account Name', fieldName: 'shipAccountName' },
                { label: 'City', fieldName: 'city' },
                { label: 'State', fieldName: 'state' }

            ];
            fileName = 'Order Status Report – Summary.csv';
            //relatedColumns = ['PO#', 'ISBN', 'Title Description', 'Order Date', 'Order#', 'Ordered Qty', 'Shipped Qty', 'Backorder Qty', 'Due Date', 'On Hold Qty'];
        }
        else if(this.showDetailReport){
            relatedColumns = [
                { label: 'PO #', fieldName: 'PO' },
                { label: 'ISBN', fieldName: 'isbn13' },
                { label: 'Title Description', fieldName: 'productDescription' },
                { label: 'Order Date', fieldName: 'orderDate' },
                { label: 'Order #', fieldName: 'orderNumber' },
                { label: 'Ordered Qty', fieldName: 'orderedQuantity' },
                { label: 'Invoice #', fieldName: 'invoiceNumber' },
                { label: 'Status', fieldName: 'status' },
                { label: 'Quantity', fieldName: 'quantity' },
                { label: 'Reason', fieldName: 'reason' },
                { label: 'Ship Date', fieldName: 'shipDate' },
                { label: 'Due Date', fieldName: 'dueDate' },
                { label: 'Backorder Cancel Date', fieldName: 'backorderCancelDate' },
                { label: 'Future Ship Date', fieldName: 'futureShipDate' },
                { label: 'Ship-to Account #', fieldName: 'shipAccount' },
                { label: 'Ship-to Account Name', fieldName: 'shipAccountName' },
                { label: 'City', fieldName: 'city' },
                { label: 'State', fieldName: 'state' }
            ];
            fileName = 'Order Status Report – Detail.csv';
            //relatedColumns = ['PO#', 'ISBN', 'Title Description', 'Order Date', 'Order#', 'Ordered Qty', 'Invoice #', 'Status', 'Quantity', 'Reason'];
        }
        else if(this.showTrackingReport){
            relatedColumns = [
                { label: 'PO #', fieldName: 'PO' },
                { label: 'ISBN', fieldName: 'isbn13' },
                { label: 'Title Description', fieldName: 'productDescription' },
                { label: 'Order Date', fieldName: 'orderDate' },
                { label: 'Order #', fieldName: 'orderNumber' },
                { label: 'Ordered Qty', fieldName: 'orderedQuantity' },
                { label: 'Invoice #', fieldName: 'invoiceNumber' },
                { label: 'Ship Date', fieldName: 'shipDate' },
                { label: 'Shipping Method', fieldName: 'carrierName' },
                { label: 'Parcel ID', fieldName: 'parcelID' },
                { label: 'Tracking #', fieldName: 'trackingNumber' },
                { label: 'Signature', fieldName: 'signature' },
                { label: 'Ship-to Account #', fieldName: 'shipAccount' },
                { label: 'Ship-to Account Name', fieldName: 'shipAccountName' },
                { label: 'City', fieldName: 'city' },
                { label: 'State', fieldName: 'state' }

            ];
            fileName = 'Order Status Report – Tracking.csv';
            //relatedColumns = ['PO#', 'ISBN', 'Title Description', 'Order Date', 'Order#', 'Ordered Qty', 'Invoice #', 'Status', 'Quantity', 'Reason'];
        }
        // const headers = this.relatedColumns.map(col =>
        // col.label).join(',');
        csvContent+= relatedColumns.map(col => col.label ).join(',')+'\r\n';
        
        console.log('csv content header',csvContent);
        //csvContent += headers+'\r\n'; 
        // Add data rows 
        this.recordsToDisplay.forEach((record,index) => {
            const row = relatedColumns.map(col =>{
                let value= record[col.fieldName];
                if(value == null || value === undefined)
                {
                    value='';
                }
                value=`"${value.toString().replace(/"/g,'""')}"`;
                return value;
            }).join(',');
            console.log('row ${index}:',row);
            csvContent += row + '\r\n';
        });
        console.log('csv con',csvContent)
            
        console.log('csv content with rec',csvContent);
        // Create download link 
        const blob = new Blob([csvContent], {type:'text/csv;charset=utf-8;'});
        
        //const encodedUri = encodeURI(csvContent);
        const link = document.createElement('a'); 
        const url = URL.createObjectURL(blob);
        //const orderNumber = this.showSummaryReport === true ? '' : 'AccessCodeOrder';
        //const fileName =`${orderNumber}.csv`;
        console.log('FileName',fileName);
        link.setAttribute('href', url); 
        link.setAttribute('download', fileName);
        document.body.appendChild(link);
            
        link.click(); 

        document.body.removeChild(link); 
        URL.revokeObjectURL(url);
    }
    // editCriteria handler
@track breadcrumbDisplaymsg=true;

     editCriteriaHander(){
            this.editCriteria= true 
            this.OrderStatusReport=false;
            this.breadcrumbDisplaymsg=true;

    }

  //  handeld event from edit editCriteria comp 
    handleDataRetrieved(event) {
        // Handle data received from child component
        const fetchedRecords = event.detail.results;
        this.records = fetchedRecords;
        this.gotformC = event.detail.valuefromC;
       // const editmsg = event.detail.enableSaveButton;
        
        this.saveDisabled=  false; // here enabling save button after came from edits
        
      

        this.seteditvalues();
        this.pageNumber = 1;
        this.pageSize = this.pageSizeOptions[0];
        this.totalRecords = this.records.length;

        this.paginationHelper();

        this.editCriteria = false; // Close the edit criteria modal
        this.isdetailedopen = true;
        this.OrderStatusReport = true;

        this.editCriteriaMsg = true;
        console.log('fromA with edit handleDataRetrieved ', this.records);
        console.log('this.handleDataRetrieved', this.gotformC);
         console.log('handleDataRetrieved Detailopenafteredits', this.saveDisabled);
    }
// this event  will notify when   edit called directly from parent , A to C to B 
    handledata() {

        this.records = this.childrecords;
        console.log(this.records);
        this.calculateDateRange();
        console.log(this.childrecords);
        

        this.pageNumber = 1;
        this.pageSize = this.pageSizeOptions[0];
        this.totalRecords = this.records.length;
        console.log(this.totalRecords);
        this.paginationHelper();
        this.editCriteria = false; // Close the edit criteria modal
        this.isdetailedopen = true;
        this.OrderStatusReport = true;
        this.editCriteriaMsg = true;
        this.saveDisabled=false;
        console.log('handledata ', this.records);
        console.log('handledata', this.gotformC)
    }
    // this is main close button 
detailhandleClose() {
        console.log('got from c',this.gotformC);
          if (this.gotformC == true || this.cmsg==true) {
            this.showPopup = true;
        } else {
           console.log('Detail Close button clicked without value',this.cmsg);
        // Dispatch an event to notify the parent component to close this view without sending any value
        // this.dispatchEvent(new CustomEvent('detailclose'));
         this.dispatchEvent(new CustomEvent('detailclose', {
        detail: {
           cmsg :this.cmsg
        }
    }));
        this.isdetailedopen = false;
        this.OrderStatusReport=false;
        //this.cmsg=false
        this.dispatchEvent(new RefreshEvent());
        }
        
    }
   // intial stage close button
    handleClose() {
    console.log('Close button clicked');
    // Dispatch an event to notify the parent component to close this view and send the selected value
    this.dispatchEvent(new CustomEvent('close', { 
      detail: { value: this.selectedreport }
    }));
  }
 
    handleOpen(event) {
        console.log('open  button clicked');
        //this.records = JSON.parse(JSON.stringify(event.detail.recordsData));
        this.records = event.detail.recordsData;
        //  this.gotformC=event.detail.valuefromC;
        this.EditedReportName = event.detail.editedreport;
        this.editCriteria = false;
        //console.log('fronhandleopen',this.gotformC);
        this.OrderStatusReport = true;
        this.calculateDateRange();

        // Dispatch an event to notify the parent component to close this view and send the selected value
        // this.dispatchEvent(new CustomEvent('open', { 
        //   detail: { value: this.selectedreport }
        // }));
    }
    // close showpopup
    CancelDetailHandler() {
        this.showPopup = false;
    }
    // popup close report detail  button 
    CloseDeailhander() {
        console.log('Detail Close button clicked from showpopup value popu plus and page will be closed');
        this.cmsg = false;
        console.log(this.cmsg);
        console.log('Detail Close button clicked from showpopup value');
        // this.dispatchEvent(new CustomEvent('detailclose'));
        //Dispatch an event to notify the parent component to close this view without sending any value
        this.dispatchEvent(new CustomEvent('detailclose', {
            detail: {
                cmsg: this.cmsg
            }
        }));
        console.log('Detail Close button clicked from showpopup value', this.cmsg);
        this.isdetailedopen = false;
        this.OrderStatusReport = false;


        this.dispatchEvent(new RefreshEvent());
    }

    msgfromc() {
        this.gotformC = event.detail.valuefromC;
        console.log('this.msgfromc', this.gotformC);
    }
    closeEmailReportModal(){
       this.showEmailReportPopup = false;
   }
   handleOpenEmailReportModal(){
       this.showEmailReportPopup = true;
   }
   handleEmailInput(event){
       this.emailInput = event.target.value;

        if(event.type=='keypress'){
        if(event.keyCode===8 || event.keyCode===46){
            this.emailIcon = imageIcons + '/Images/EmailIconWithColor.png';
            this.isDisabled = false;
        }
        if(event.keyCode === 13 && !this.isDisabled){
            event.preventDefault();
            this.emailIcon = imageIcons + '/Images/EmailIconWithoutColor.png';
            this.isDisabled = true;
            this.emailHandler();
        }
      }else{
        if(this.emailInput!='' && this.emailInput!=undefined){
           this.emailIcon = imageIcons + '/Images/EmailIconWithColor.png';
           this.isDisabled = false;
       }
       else{
           this.emailIcon = imageIcons + '/Images/EmailIconWithoutColor.png';
           this.isDisabled = true;
       }
      }

       if(this.emailInput!='' && this.emailInput!=undefined){
           this.emailIcon = imageIcons + '/Images/EmailIconWithColor.png';
           this.isDisabled = false;
       }
       else{
           this.emailIcon = imageIcons + '/Images/EmailIconWithoutColor.png';
           this.isDisabled = true;
       }
       
       
   }
   emailHandler(){

       this.isLoading= true;
        this.emailIcon = imageIcons + '/Images/EmailIconWithoutColor.png';
        this.isDisabled = true;
         try {
             this.emailAddresses = this.emailInput.split(",").map(email=> email.trim());
             console.log('this.emailAddresses',this.emailAddresses);
             console.log('raw records Data:', this.records);
            const reportData = this.records.map(record => JSON.stringify(record));
            console.log('Parsed Report Data:', reportData);
            sendReportEmail({
                emailAddresses:this.emailAddresses ,
                reportType: this.selectedreport,
                reportData: JSON.stringify(reportData) 
            })
                .then(() => {
                    // Success handler
                    this.dispatchEvent(new CustomEvent('emailsent'));
                    this.isLoading= false;
                    console.log('Email sent successfully');
                   
                })
                .catch(error => {
                    // Error handler
                    this.isLoading= false;
                    console.error('Error sending email:', error);
                  
                });
        } catch (error) {
            // Handle JSON parsing errors
            this.isLoading= false;
            console.error('JSON Parsing Error:', error);
           
        }
        
    }

// save report variables save report functionality starts from here 
 @track message = '';
 @track reportName='';
 @track NewDescription='';
 @track ExistedReport=false;
 @track isSaveButtonDisabled = true;
 @track SaveAsDescription='';
 @track savereport=false;
@track isDisabled=true;
@track Description='';
@track isInputsavedisabled=false;
@track selectedValue = 'SaveAS'; 

closeDetailModal(){
    this.showPopup=false;
}
closesaveModal(){
    this.savereport=false;
}
@track isRadioDisabled=false;
saveahander() {    
console.log('this is save');
        this.setDescription();
        this.savereport = true; 
        this.message=this.Description;
        this.descriptionUpdated = false;
        this.isRadioDisabled = !this.selectedReportName.endsWith('[custom]');
        console.log('Entered this.isRadioDisabled',this.isRadioDisabled);
}     
 handleCustomSave() {
        console.log('Entered handleCustomSave',this.maintainsourceoforiginalreport);
       const standardReports = ['Order Status Report – Summary', 'Order Status Report – Detail', 'Order Status Report – Tracking'];
       let isStandardReport = standardReports.includes(this.maintainsourceoforiginalreport);
       console.log(isStandardReport)
        if (this.records && this.records.length > 0) {
            console.log('Records are available, processing the first record');
            const firstItem = this.records[0];

            if (this.selectedValue === 'OverideExistedreport') {
                this.NewDescription = this.message;
                this.reportName = this.displayedReportName;
                this.ExistedReport = true;
                console.log('Records are available, processing the', this.NewDescription);
            } if (this.selectedValue === 'SaveAS') {
                
                this.reportName = this.newReportName;
                this.NewDescription = this.SaveAsDescription;
                this.ExistedReport = false;
                 console.log('SaveAS', this.newReportName);
                 console.log('SaveAS', this.SaveAsDescription);
            }

       
            
            const filterParams = {
                userId: firstItem.loggedInUserId,
                isbnList: firstItem.isbnList.join(';'),
                poList: firstItem.poList.join(';'),
                startDate: firstItem.startDate || '',
                endDate: firstItem.endDate || '',
                orderStatus: firstItem.orderStatus || '',
                sortOrder1: firstItem.sortOrder1 || '',
                sortOrder2: firstItem.sortOrder2 || '',
                sortOrder3: firstItem.sortOrder3 || '',
                orderEntryPeriod: firstItem.orderEntryPeriod || '',
                Name: this.reportName,
                Description: this.NewDescription,
                standardReport:this.ExistedReport,
                orginalReport:isStandardReport ? this.maintainsourceoforiginalreport : 'Custom'
            };

           
            console.log(`userId: ${filterParams.userId}`);
            console.log(`isbnList: ${filterParams.isbnList}`);
            console.log(`poList: ${filterParams.poList}`);
            console.log(`startDate: ${filterParams.startDate}`);
            console.log(`endDate: ${filterParams.endDate}`);
            console.log(`orderStatus: ${filterParams.orderStatus}`);
            console.log(`sortOrder1: ${filterParams.sortOrder1}`);
            console.log(`sortOrder2: ${filterParams.sortOrder2}`);
            console.log(`sortOrder3: ${filterParams.sortOrder3}`);
            console.log(`orderEntryPeriod: ${filterParams.orderEntryPeriod}`);
            console.log(`Name: ${filterParams.Name}`);
            console.log(`Name: ${filterParams.Description}`);

            // Call Apex method to save the filter
            saveOrUpdateReportFilters({ filterParamsList: [filterParams] }) 
                .then(result => {
                    console.log('Report filter saved with Id:', result);
                    const reportId = result[0];
                     console.log('Extracted report ID:', reportId);
                     return fetchReportDetails({ reportId: reportId });
                              })
                      .then(details => {
                        this.savereport=false;
                console.log('Fetched Details:', details);
                this.records=details;
                switch (this.maintainsourceoforiginalreport) {

                    case 'Order Status Report – Summary':
                            this.OrderStatusReport = true;
                           this.OrderStatusReport = true;
                            this.showSummaryReport = true;
                            this.showDetailReport = false;
                            this.showTrackingReport = false;
                            this.isdetailedopen = true;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = false
           

                        break;
                    case 'Order Status Report – Detail':
                            this.OrderStatusReport = true;
                        this.showDetailReport = true;
                        this.showSummaryReport = false;
                        this.showTrackingReport = false;
                        this.isdetailedopen = true;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = false
           
                        break;
                    case 'Order Status Report – Tracking':
                    this.isdetailedopen =true;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = false
           
                        this.OrderStatusReport = true;
            this.showDetailReport = false;
            this.showSummaryReport = false;
            this.showTrackingReport = true;
                        break;
                }  
            this.pageSize = this.pageSizeOptions[0];
            this.totalRecords = this.records.length;
            this.paginationHelper();
            this.calculateDateRange();
            this.isInputsavedisabled=false;
            this.isoverrideDisabled=true;
                
                })
                .catch(error => {
                console.error('Error in process:', error);
            });
    }
}
    renderedCallback() {
      //this.isRadioDisabled = !this.selectedReportName.endsWith('[custom]');
      //console.log( 'renderedCallback',this.isRadioDisabled );
        if (this.savereport && !this.descriptionUpdated) {
            const textArea = this.template.querySelector('.arvicon-input1');
            if (textArea) {
                textArea.value = this.Description;
                this.descriptionUpdated = true; // Set flag to true after updating
            }
        }
        //console.log('from redered',this.selectedValue);
    }
    // handleOverideradioChange(event) {
    //     this.selectedValue = event.target.value;
    //     console.log('Radio button selected:', this.selectedValue);

    //     if (this.selectedValue === 'OverideExistedreport') {
    //         this.isDisabled = false
    //         this.issavedisabled = true;
    //         this.SaveAsDescription = '';
    //         this.newReportName = '';
    //         this.isSaveButtonDisabled = false
    //     }
    //     else {
    //         this.isDisabled = true;
    //         this.issavedisabled = false;

    //     }
    // }
   handleOverideradioChange(event) {
    this.selectedValue = event.target.value;
    console.log('Radio button selected:', this.selectedValue);

    // Check if the selected report ends with '[custom]'
   // const isCustomReport = this.selectedReportName.endsWith('[custom]');

    if (this.selectedValue === 'OverideExistedreport') {
        // Enable or disable the text area and override option based on the type of report
       
        this.isoverrideDisabled = false; //!isCustomReport
        this.isInputsavedisabled = true;
        
        //this.isoverrideDisabled = !isCustomReport;
        this.isSaveButtonDisabled = false
        this.SaveAsDescription = '';
        this.newReportName = '';
    } else {
        this.isoverrideDisabled = true;
        this.isInputsavedisabled = false;
        // Optionally reset the selectedValue if you need to deselect the radio button
        this.selectedValue = null;
    }
}
 handleDefaultSelection() {
     if (this.selectedValue === 'SaveAS') {
            this.isoverrideDisabled = true
            this.isInputsavedisabled = false;
            this.isSaveButtonDisabled = true;
        }
        else {
            this.isoverrideDisabled = false;
            this.isInputsavedisabled = false;

        }
 }
    handleSaveasRadioChange(event) {
        this.selectedValue = event.target.value;
        console.log('Radio button selected:', this.selectedValue);
//this.handleDefaultSelection();
        if (this.selectedValue === 'SaveAS') {
            this.isoverrideDisabled = true
            this.isInputsavedisabled = false;
            this.isSaveButtonDisabled = true;
        }
        else {
            this.isoverrideDisabled = false;
            this.isInputsavedisabled = false;

        }
    }
    handledescription(event) {
        this.Description = event.target.value;
    }

     handleDescriptionChange(event) {
        this.message = event.target.value; 
        this.isSaveButtonDisabled=true
        console.log(this.message);
    }
  handleReportNameChange(event) {
        this.newReportName = event.target.value;
        console.log(this.newReportName)
         this.updateButtonState();
    }
   
    handleSaveAsDescription(event){
        this.SaveAsDescription= event.target.value;
        this.updateButtonState();
    }
    updateButtonState() {
    
    const description = this.SaveAsDescription || '';
    const reportName = this.newReportName || '';

   
    if (description.trim() !== '' && reportName.trim() !== '') {
        this.isSaveButtonDisabled = false;
    } else {
        this.isSaveButtonDisabled = true; // Disable the button if either field is empty
    }
}
handleSaveCancel(){
this.savereport=false;
}
}