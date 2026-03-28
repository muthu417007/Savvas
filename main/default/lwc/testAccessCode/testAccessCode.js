import { LightningElement, track } from 'lwc';
import searchOrders from '@salesforce/apex/scc_accessCodeController.searchOrders';
import getRelatedRecords from '@salesforce/apex/scc_accessCodeController.getRelatedRecords';
import getUserType from '@salesforce/apex/scc_accessCodeController.getUserType';
import errormessage from '@salesforce/label/c.scc_productcriteriaerrormessage';
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import { loadScript } from "lightning/platformResourceLoader";
import writeExcelFile from "@salesforce/resourceUrl/scc_write_excel_file";
import scc_code_redemption_hover_message from '@salesforce/label/c.scc_code_redemption_hover_message';
import sendResendAccess from '@salesforce/apex/scc_resend_AccessCode_Controller.sendResendAccess';


const columns = [
    { label: 'PO#', fieldName: 'PO_Number__c' },
    {
        label: 'Order#',
        fieldName: 'SAP_Document_Number__c',
        type: 'button',
        typeAttributes: {
            label: { fieldName: 'SAP_Document_Number__c' },
            name: 'view_order',
            variant: 'base'
        }
    },
    { label: 'Order Date', fieldName: 'CreatedDate' },
    { label: 'Order Method', fieldName: 'SAP_Order_Method__c' },
    { label: 'Order Items', fieldName: 'Total_Items__c' },
    { label: 'Order Units', fieldName: 'Order_Total_Units__c' },
    { label: 'Ship To', fieldName: 'ShippingAddress' },
    { label: 'Bill To', fieldName: 'BillingAddress' },
];

const relatedColumns = [
    { label: 'PO#', fieldName: 'PO_Number__c' },
    { label: 'Order#', fieldName: 'SAP_Document_Number__c' },
    { label: 'Order Date', fieldName: 'EffectiveDate' },
    { label: 'ISBN', fieldName: 'ProductCode__c' },
    { label: 'Title Description', fieldName: 'Title_Description__c' },
    { label: 'E-Access Code', fieldName: 'EAccess_Code__c' },
    { label: 'Email Recipient', fieldName: 'Customer_Email__c' },
    { label: 'Code Redemption', fieldName: 'No_Of_Redemptions__c' },
];

const PAGE_SIZE_OPTIONS = [
    { label: '15', value: '15' },
    { label: '20', value: '20' },
    { label: '25', value: '25' },
];

const columnHeader = ['PO#', 'Order#', 'Order Date', 'ISBN',  'Title Description', 'EAccess Code','Email Recipient','Code Redemption'];

export default class TestAccessCode extends LightningElement {
    searchIconUrl = imageIcons + '/Images/search.png';
    infoIconUrl = imageIcons + '/Images/info.png';
    noResult = imageIcons + '/Images/no_result.png';
    excelIcon =  imageIcons + '/Images/excel.png';
    @track orders = [];
    @track columns = columns;
    @track relatedColumns = relatedColumns;
    @track error;
    @track poNumber = '';
    @track orderNumber = '';
    @track sapDocumentNumber;
    @track isbn = '';
    isSearchDisabled = true;
    @track relatedRecords = [];
    @track pagedRelatedRecords = [];
    @track isRelatedView = false;
    @track currentPage = 1;
    @track pagedOrders = [];
    @track showResults = false;
    @track totalPages = 1;
    @track totalCount = 0;
    @track transformedDataLength = 0;
    @track pageSizeOptions = PAGE_SIZE_OPTIONS;
    @track pageSize = 15; 
    @track bDisableFirst = true;
    @track bDisableLast = true;
    @track bDisableNext = true;
    @track displayPageSize = '15';
    @track orderId1 ='';
    @track bDisableFirstRelated = true;
    @track bDisableLastRelated = true;
    @track bDisableNextRelated = true;
    @track displayPageSizeRelated = '15';
    @track pageSizeRelated = 15;
    @track pageSizeOptionsRelated = PAGE_SIZE_OPTIONS;
    @track transformedDataLengthRelated = 0;
    @track totalCountRelated = 0;
    @track totalPagesRelated = 1;
    @track currentPageRelated = 1;
    @track columnHeader = columnHeader;
    @track isInternalUser = false;
    @track accountId = '';
    @track librariesLoaded = false;
    @track isOpen = false;

    searchResultErrorMessage = errormessage;
    showSearchResultErrorMessage = false;

    labels={
        scc_code_redemption_hover_message
    }

    get searchButtonClass() {
        return this.isSearchDisabled ? 'searchButtonDisabled' : 'searchButton';
    }

    connectedCallback() {
        getUserType()
            .then(result => {
                let parsedResult = JSON.parse(result);
                this.isInternalUser = parsedResult.isInternal;
                this.accountId = parsedResult.accountId;
                console.log('this.isInternalUser:', this.isInternalUser);
                console.log('User type:', this.isInternalUser ? 'Internal' : 'External');
                console.log('Account ID:', this.accountId);
            })
            .catch(error => {
                console.error('Error fetching user type:', error);
            });
    }

    renderedCallback(){
        if (this.librariesLoaded) return;
        this.librariesLoaded = true;
        loadScript(this, writeExcelFile)
            .then(async (data) => {
                console.log("success------>>>", data);
            })
            .catch(error => {
                console.log("failure------>>>>", error);
            });
    }


    // handleInputChange(event) {
    //     const field = event.target.name;
    //     if (field === 'poNumber') {
    //         this.poNumber = event.target.value;
    //     } else if (field === 'orderNumber') {
    //         this.orderNumber = event.target.value;
    //     } else if (field === 'isbn') {
    //         this.isbn = event.target.value;
    //     }
    //     this.isSearchDisabled = false;
    // }
    handleInputChange(event) {
    const field = event.target.name;
    if (field === 'poNumber') {
        this.poNumber = event.target.value;
    } else if (field === 'orderNumber') {
        this.orderNumber = event.target.value;
    } else if (field === 'isbn') {
        this.isbn = event.target.value;
    }
    this.isSearchDisabled = !(this.poNumber.length >= 3 || this.orderNumber.length >= 3 || this.isbn.length >= 3);
}

    // handleSearch() {
    //     this.isSearchDisabled = true;
    //     searchOrders({ poNumber: this.poNumber, orderNumber: this.orderNumber, isbn: this.isbn })
    //         .then(result => {
    //             this.showResults = true;
    //             this.error = undefined;
    //             console.log('search results ->', result);
    //             console.log('result ->' + JSON.stringify(result));
    //                 this.showSearchResultErrorMessage = (result.length === 0);
                
    //             this.orders = result.map(item => {
    //                 const shippingAddress = item.ShippingAddress ? `${item.ShippingAddress.street}, ${item.ShippingAddress.city}, ${item.ShippingAddress.state} ${item.ShippingAddress.postalCode}, ${item.ShippingAddress.country}` : '';
    //                 const billingAddress = item.BillingAddress ? `${item.BillingAddress.street}, ${item.BillingAddress.city}, ${item.BillingAddress.state} ${item.BillingAddress.postalCode}, ${item.BillingAddress.country}` : '';
    //                 const createdDate = new Date(item.CreatedDate).toLocaleDateString();

    //                 return {
    //                     ...item,
    //                     ShippingAddress: shippingAddress,
    //                     BillingAddress: billingAddress,
    //                     CreatedDate: createdDate
    //                 };
    //             });

    //             if (result && result.length === 1) {
    //                 const singleOrder = result[0];
    //                 this.showRelatedRecords(singleOrder.Id);
    //                 this.showResults = false;
    //             }

    //             this.paginateData();
    //         })
    //         .catch(error => {
    //             this.error = error;
    //             this.orders = undefined;
    //             console.error('Error searching orders:', error);
    //         });
    // }

    // showRelatedRecords(orderId) {
    //     this.isRelatedView = true;
    //     getRelatedRecords({ orderId: orderId })
    //         .then(result => {
    //             console.log('related result ->', result);
    //             this.sapDocumentNumber = '';
    //             this.relatedRecords = this.flattenRecords(result);
    //             console.log('related result', this.relatedRecords);
    //             this.error = undefined;
    //             this.showSearchResultErrorMessage = (this.relatedRecords.length === 0);
    //             this.sapDocumentNumber = result[0].SAP_Document_Number__c;
                

    //             if (result.length > 0) {
    //                 this.sapDocumentNumber = result[0].SAP_Document_Number__c;
    //             }

    //             if (result.length === 0) {
    //                 this.totalPagesRelated = 1;
    //                 this.updateRelatedButtons();
    //             }
    //             this.paginateRelatedData();
    //         })
    //         .catch(error => {
    //             this.error = error;
    //             this.relatedRecords = undefined;
    //             this.totalPagesRelated = 1;
    //             console.error('Error getting related records:', error);
    //         });
    // }
    handleSearch() {
    this.isSearchDisabled = true;
    searchOrders({ poNumber: this.poNumber, orderNumber: this.orderNumber, isbn: this.isbn })
        .then(result => {
            this.showResults = true;
            this.error = undefined;
            console.log('search results ->', result);
            console.log('result ->' + JSON.stringify(result));
            this.showSearchResultErrorMessage = (result.length === 0);


            this.orders = result.map(item => {
                const shippingAddress = item.ShippingAddress ? `${item.ShippingAddress.street}, ${item.ShippingAddress.city}, ${item.ShippingAddress.state} ${item.ShippingAddress.postalCode}, ${item.ShippingAddress.country}` : '';
                const billingAddress = item.BillingAddress ? `${item.BillingAddress.street}, ${item.BillingAddress.city}, ${item.BillingAddress.state} ${item.BillingAddress.postalCode}, ${item.BillingAddress.country}` : '';
                const createdDate = new Date(item.CreatedDate).toLocaleDateString();


                return {
                    ...item,
                    ShippingAddress: shippingAddress,
                    BillingAddress: billingAddress,
                    CreatedDate: createdDate
                };
            });


            if (result && result.length === 1) {
                const singleOrder = result[0];
                // 10/07
                this.sapDocumentNumber = singleOrder.SAP_Document_Number__c;

                this.showRelatedRecords(singleOrder.Id);
                this.showResults = false;
            } else {
                this.paginateData();
            }
        })
        .catch(error => {
            this.error = error;
            this.orders = undefined;
            console.error('Error searching orders:', error);
        });
}

handleOrderClick(event) {
    const orderId = event.target.dataset.id;
    this.orderId1 = event.target.dataset.id;
    const sapDocumentNumber = event.target.dataset.sapNumber;


    if (orderId && sapDocumentNumber) {
        console.log('Order Clicked:', orderId, sapDocumentNumber);
        this.showRelatedRecords(orderId, sapDocumentNumber);
    } else {
        console.error('Order ID or SAP Document Number is missing.');
    }
}

formatDate(dateString) {
    const date = new Date(dateString);
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    return `${month}/${day}/${year}`;
}

showRelatedRecords(orderId, sapDocumentNumber) {
    this.isRelatedView = true;
    this.sapDocumentNumber = sapDocumentNumber;
    console.log('Fetching related records for order:', orderId);

    getRelatedRecords({ orderId: orderId })
        .then(result => {
            console.log('Related records result:', result);
            this.relatedRecords = this.flattenRecords(result);
            this.error = undefined;
            this.showSearchResultErrorMessage = (this.relatedRecords.length === 0);

            if (result.length > 0 && !this.sapDocumentNumber){
                this.sapDocumentNumber = result[0].SAP_Document_Number__c;
            }

            if (result.length === 0) {
                this.totalPagesRelated = 1;
                this.updateRelatedButtons();
            }
            this.paginateRelatedData();
        })
        .catch(error => {
            this.error = error;
            this.relatedRecords = undefined;
            this.totalPagesRelated = 1;
            console.error('Error getting related records:', error);
        });
}

flattenRecords(records) {
    return records.map(record => {
        return {
            ...record,
            EffectiveDate: this.formatDate(record.EffectiveDate)
        };
    });
}



// showRelatedRecords(orderId, sapDocumentNumber) {
//     this.isRelatedView = true;
    
//     this.sapDocumentNumber = sapDocumentNumber;


//     getRelatedRecords({ orderId: orderId })
//         .then(result => {
//             console.log('related result ->', result);
//             this.relatedRecords = this.flattenRecords(result);
//             console.log('related result', this.relatedRecords);
//             this.error = undefined;
//             this.showSearchResultErrorMessage = (this.relatedRecords.length === 0);


//             if (result.length === 0) {
//                 this.totalPagesRelated = 1;
//                 this.updateRelatedButtons();
//             }
//             this.paginateRelatedData();
//         })
//         .catch(error => {
//             this.error = error;
//             this.relatedRecords = undefined;
//             this.totalPagesRelated = 1;
//             console.error('Error getting related records:', error);
//         });
// }

    flattenRecords(records) {
        return records.map(record => {
            return record;
        });
    }

    handleClear() {
        this.poNumber = '';
        this.orderNumber = '';
        this.isbn = '';
        this.isSearchDisabled = true;
        this.showResults = false;
        this.orders = [];
        this.relatedRecords = [];
        this.pagedRelatedRecords = [];
        this.pagedOrders = [];
        this.currentPage = 1;
        this.totalPages = 1;
        this.showSearchResultErrorMessage = false;
        this.isRelatedView = false;
        this.error = undefined;
        this.transformedDataLength = 0;
        this.transformedDataLengthRelated = 0;
        this.totalCount = 0;
        this.totalCountRelated = 0;
        this.bDisableFirst = true;
        this.bDisableLast = true;
        this.bDisableNext = true;
        this.bDisableFirstRelated = true;
        this.bDisableLastRelated = true;
        this.bDisableNextRelated = true;
    }

    // handleRowAction(event) {
    //     const actionName = event.detail.action.name;
    //     const row = event.detail.row;

    //     if (actionName === 'view_order') {
    //         this.showRelatedRecords(row.Id);
    //     }
    // }
    handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;


    if (actionName === 'view_order') {
        this.showRelatedRecords(row.Id, row.SAP_Document_Number__c);
    }
}

handleResend(){
    console.log('Resending the Access Codes...');
}


    handleClose() {
        this.isRelatedView = false;
        this.relatedRecords = [];
        this.pagedRelatedRecords = [];
        this.disableRelatedPrevious = true;
        this.disableRelatedNext = true;
        this.showSearchResultErrorMessage = false;
    }
    //Added by Sagar for Resend Access Code W-014807
    handleResendForAccess() {

    this.isOpen = true;
  }
  sendResendAceessCode(event) {

    const eAddress = event.detail;
    const orderIdForAccessCode = this.orderId1;

    sendResendAccess({ eAddrs: eAddress, orderId: orderIdForAccessCode })

      .then(() => {
        this.isOpen = false;
      })

      .catch(error => { console.error('Error: ', error); });

  }

  cancelResend(event) {

    this.isOpen = event.detail;
  }

    firstPageRelated() {
        this.currentPageRelated = 1;
        this.paginateRelatedData();
    }

    previousPageRelated() {
        if (this.currentPageRelated > 1) {
            this.currentPageRelated -= 1;
            this.paginateRelatedData();
        }
    }

    nextPageRelated() {
        if (this.currentPageRelated < this.totalPagesRelated) {
            this.currentPageRelated += 1;
            this.paginateRelatedData();
        }
    }

    lastPageRelated() {
        this.currentPageRelated = this.totalPagesRelated;
        this.paginateRelatedData();
    }

    handlePageSizeChangeRelated(event) {
        this.pageSizeRelated = parseInt(event.target.value, 10);
        this.displayPageSizeRelated = event.target.value;

        this.currentPageRelated = 1;
        this.paginateRelatedData();
    }

    paginateRelatedData() {
        const start = (this.currentPageRelated - 1) * this.pageSizeRelated;
        const end = start + parseInt(this.pageSizeRelated, 10);
        this.pagedRelatedRecords = this.relatedRecords.slice(start, end);
        console.log('Start index:' , start );
        console.log('End index:' , end);
        console.log('pagedRelatedRecords:' , this.pagedRelatedRecords );
        this.totalPagesRelated =  Math.ceil(this.relatedRecords.length / this.pageSizeRelated);
        this.updateRelatedButtons();
        this.transformedDataLengthRelated = this.pagedRelatedRecords.length;
        // this.totalPagesRelated =  Math.ceil(this.relatedRecords.length / this.pageSizeRelated);
        console.log('check total pages:>>:'+this.totalPages);

        if(this.totalPagesRelated == 0){

            this.totalPagesRelated = 1;

        }
       this.totalCountRelated = this.relatedRecords.length;
    }

    updateRelatedButtons() {
        this.bDisableFirstRelated = this.currentPageRelated === 1;
        this.bDisableLastRelated = this.currentPageRelated === this.totalPagesRelated || this.relatedRecords.length === 0;
        this.bDisableNextRelated = this.currentPageRelated >= this.totalPagesRelated;
    }

    get pageNumberRelated() {
        return this.currentPageRelated;
    }

    get totalPagesRelated() {
        if (this.totalPagesRelated !== 0) {
            return this.totalPagesRelated;
        } else {
            return 1;
        }
    }

    firstPage() {
        this.currentPage = 1;
        this.paginateData();
    }

    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage -= 1;
            this.paginateData();
        }
    }

    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage += 1;
            this.paginateData();
        }
    }

    lastPage() {
        this.currentPage = this.totalPages;
        this.paginateData();
    }

    handlePageSizeChange(event) {
        this.pageSize = parseInt(event.target.value, 10);
        this.displayPageSize = event.target.value;

        this.currentPage = 1;
        this.paginateData();
    }

    paginateData() {
        const start = (this.currentPage - 1) * parseInt(this.pageSize, 10);
        const end = start + parseInt(this.pageSize, 10);
        this.pagedOrders = this.orders.slice(start, end);
        console.log('Start index:' , start );
        console.log('End index:' , end);
        console.log('pagedOrders:' , this.pagedOrders );
        this.totalPages = Math.ceil(this.orders.length / this.pageSize);
        this.updateButtons();
        this.transformedDataLength = this.pagedOrders.length;
        // this.totalPages = Math.ceil(this.orders.length / parseInt(this.pageSize, 10));
        console.log('check total pages:>>:'+this.totalPages);

        if(this.totalPages == 0){

            this.totalPages = 1;

        }
        this.totalCount = this.orders.length;
    }

    updateButtons() {
        this.bDisableFirst = this.currentPage === 1;
        this.bDisableLast = this.currentPage === this.totalPages || this.orders.length === 0;
        this.bDisableNext = this.currentPage >= this.totalPages;
    }

    get pageNumber() {
        return this.currentPage;
    }

    get totalPages() {
        if (this.totalPages !== 0) {
            return this.totalPages;
        } else {
            return 1;
        }
    }

    taskTypeHelpTextClassCount = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground countInfo-poppup slds-hide';
    togglePasswordHintCount() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground countInfo-poppup slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground countInfo-poppup';
        this.taskTypeHelpTextClassCount = this.taskTypeHelpTextClassCount == hideCss ? showCss : hideCss;

    }
     taskTypeHelpTextClassCode = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHintCode() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClassCode= this.taskTypeHelpTextClassCode == hideCss ? showCss : hideCss;

    }

    objectsData = [
        // Object #1
        {
            name: 'John Smith',
            dateOfBirth: new Date(),
            cost: 1800,
            paid: true
        },
        // Object #2
        {
            name: 'Alice Brown Alice Brown Alice Brown Alice Brown Alice Brown Alice Brown',
            dateOfBirth: new Date(),
            cost: 2600,
            paid: false
        }
    ];
    schemaObj = [
        // Column #1
        {
            column: 'Name',
            type: String,
            wrap: 'true',
            color: '#ccaaaa',
            value: student => student.name
        },
        // Column #2
        {
            column: 'Date of Birth',
            type: Date,
            format: 'mm/dd/yyyy',
            value: student => student.dateOfBirth
        },
        // Column #3
        {
            column: 'Cost',
            type: Number,
            format: '#,##0.00',
            value: student => student.cost
        },
        // Column #4
        {
            column: 'Paid',
            type: Boolean,
            value: student => student.paid
        }
    ];

    handleExport(){

          // Prepare CSV content 
            // let csvContent = 'data:text/csv;charset=utf-8,'; 
             // Add header row
            let csvContent='';
            const headers = this.relatedColumns.map(col =>
            col.label).join(',');
             /*csvContent+= this.relatedColumns.map(col => 
                 col.label ).join(',');*/
             
             console.log('csv content header',csvContent);
              csvContent += headers+'\r\n'; 
              // Add data rows 
              this.pagedRelatedRecords.forEach((record,index) => {
                  const row = this.relatedColumns.map(col =>{
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
              try{
                  if(!this.isInternalUser){
                      const link = document.createElement('a'); 
                        console.log('link '+link);
                        const url = URL.createObjectURL(blob);
                        console.log('url '+url);
                        const orderNumber = this.pagedRelatedRecords.length > 0 ? this.pagedRelatedRecords[0].SAP_Document_Number__c : 'AccessCodeOrder';
                        const fileName =`${orderNumber}.csv`;
                        console.log('FileName',fileName);
                        link.setAttribute('href', url); 
                        link.setAttribute('download', fileName);
                        document.body.appendChild(link);
                            
                        link.click(); 

                        document.body.removeChild(link); 
                        URL.revokeObjectURL(url);
                  }
                  else{
                    this.excelDownload();
                  }
              }
              catch(error){
                  console.log('excel error',error);
              }
        }

        async excelDownload() {
            console.log('before excel download');
        // When passing `objects` and `schema`.
            await writeXlsxFile(this.objectsData, {
                schema: this.schemaObj,
                fileName: 'file.xlsx'
            })
            console.log('after excel download');
        }
}