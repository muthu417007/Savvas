import { LightningElement } from 'lwc';
import retrieveTimesheetRecords from '@salesforce/apex/ManagerTimesheetController.retrieveTimesheetRecords';
import retrieveResourceUserId from '@salesforce/apex/ManagerTimesheetController.getServiceResourceUser';
import LightningConfirm from 'lightning/confirm';
import approveTimesheet from '@salesforce/apex/ManagerTimesheetController.approveTimesheet';
import rejectTimesheet from '@salesforce/apex/ManagerTimesheetController.rejectTimesheet';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
export default class ManagerViewPOC extends NavigationMixin(LightningElement) {
    columns = [ 
        { label: 'Service Resource', fieldName: 'serviceResourceUrl', sortable: "true", hideDefaultActions: true, type: 'url', typeAttributes: { label: { fieldName: 'serviceResourceName' }, target: '_self' }  },
        { label: 'Activity', fieldName: 'activity', hideDefaultActions: true, sortable: "true", initialWidth: 80},
        { label: 'Activity Type', fieldName: 'activityType', hideDefaultActions: true, sortable: "true", initialWidth: 80 },
        { label: 'Discipline', fieldName: 'discipline', hideDefaultActions: true, sortable: "true", initialWidth: 80},
        { label: 'Account', fieldName: 'accUrl', hideDefaultActions: true, type: 'url',sortable: "true", typeAttributes: { label: { fieldName: 'accName' } } },
        { label: 'Service Appointment', fieldName: 'serviceAppointmentUrl', hideDefaultActions: true, sortable: "true", type: 'url', typeAttributes: { label: { fieldName: 'serviceAppointment' }, target: '_self' }},
        { label: 'Period Start Date', fieldName: 'startDate', type: 'text', hideDefaultActions: true, cellAttributes: { alignment: 'center' }, sortable: "true", initialWidth: 100 },
        { label: 'Period End Date', fieldName: 'endDate', type: 'text', hideDefaultActions: true, sortable: "true", cellAttributes: { alignment: 'center' }, initialWidth: 100 },
        { label: 'Total Duration (In Hours)', fieldName: 'totalDuration', initialWidth: 80, hideDefaultActions: true, sortable: "true", cellAttributes: { alignment: 'center' }, initialWidth: 80 },
        { label: 'Approval Requested On', fieldName: 'submittedForApprovalOn', initialWidth: 158, type: 'date', sortable: "true", hideDefaultActions: true, cellAttributes: { alignment: 'center' } },
        { label: 'Approval Status', fieldName: 'status', sortable: "true", hideDefaultActions: true},
        { label: 'Has Submitter Comments?', fieldName: 'comments', sortable: "true", hideDefaultActions: true}
    ];
    sortBy='startDate'
    sortDirection='desc'

    userName = ''
    recordsToDisplay = []
    retrievedTimesheets = []
    clonedRetrievedTimesheets = []
    isLoading = false
    totalRecords = 0
    pageSize = 10
    totalPages
    pageNumber = 1
    pageSizeOptions = [10, 25, 50, 75, 100]
    selectedRows = []
    showErrorMessage = false
    errorMessage = ''
    showRejectModal = false
    rejectionComments = ''
    selectedRowIds=[]
    typingTimer
    serviceResourceUserId = '';

    connectedCallback() {
        this.getTimesheets()
    }

    constructor() {
        super();
        this.columns = this.columns.concat( [
            { type: 'action', typeAttributes: { rowActions: this.getRowActions } }
        ] );
    }

    getTimesheets() {
        let baseUrl='https://'+location.host+'/';
        this.isLoading = true
        const timezoneOffsetInMinutes = new Date().getTimezoneOffset();
        retrieveTimesheetRecords().then(result => {
            if(result.message=='Success'){
                this.showErrorMessage = false
                this.userName = result.userName
                this.errorMessage = ''
                this.retrievedTimesheets = result.timesheetList.map(item=>{
                   // console.log('item.StartDate',item.StartDate);
                   // console.log('item.EndDate',item.EndDate);
                    
                    const startDate = new Date(item.StartDate);
                    const endDate = new Date(item.EndDate);
                   // startDate.setMinutes(startDate.getMinutes() + timezoneOffsetInMinutes);
                   // endDate.setMinutes(endDate.getMinutes() + timezoneOffsetInMinutes);
                   // console.log('startDate '+startDate.toLocaleDateString());
                   // console.log('endDate '+endDate.toLocaleDateString());
                    let options = {month: 'short', day: 'numeric', year: 'numeric'};
                    let startDateFormatted = new Date(startDate).toLocaleDateString('en-US', options);
                    let endDateFormatted = new Date(endDate).toLocaleDateString('en-US', options);
                    return{
                        id: item.Id,
                        timesheetNumber: item.TimeSheetNumber,
                        idUrl: baseUrl+'lightning/n/Time_Sheet_Summary/',
                        serviceResourceUrl : item.ServiceResourceId?'/' + item.ServiceResourceId : '',
                        serviceResourceName: item.ServiceResourceId ? item.ServiceResource.Name : '',
                        activity: item.Sav_FSL_Activity__c ? item.Sav_FSL_Activity__c : 'Resourced Activity',
                        activityType: item.Sav_FSL_Activity_Type__c ? item.Sav_FSL_Activity_Type__c : '',
                        discipline: item.Sav_FSL_Discipline__c ? item.Sav_FSL_Discipline__c : '',
                        accUrl: item.Account__r ? (item.Account__r.Id ? '/' + item.Account__r.Id : '') : '',
                        accName: item.Account__r ? (item.Account__r.Name ? item.Account__r.Name : '') : '',
                        serviceAppointment:  item.ServiceAppointmentSubject__c ? item.ServiceAppointmentSubject__c: '',
                        serviceAppointmentUrl : item.Service_Appointment__c?'/'+item.Service_Appointment__c:'',
                        startDate: item.StartDate ? startDateFormatted : '',
                        endDate: item.EndDate ? endDateFormatted : '',
                        totalDuration: item.TotalDurationInHours ? item.TotalDurationInHours : '',
                        submittedForApprovalOn: item.Sav_FSL_Approval_Requested_On__c ? item.Sav_FSL_Approval_Requested_On__c : '',
                        status: item.Status,
                        comments: item.Comments__c ? 'Yes': 'No'
                    }
                })
                this.totalRecords = this.retrievedTimesheets.length
                this.pageSize = this.pageSizeOptions[0]
                this.clonedRetrievedTimesheets = [...this.retrievedTimesheets]
                this.paginationHelper()
            }else if(result.message=='No records found'){
                this.showErrorMessage = true
                this.errorMessage = 'No timesheet records found that require approval.'
            }
            else{
                this.showErrorMessage = true
                this.errorMessage = 'Unable to fetch records, please ensure you have the required permissions.'
            }
        })
    }

    getRowActions( row, doneCallback ) {

        const actions = [];
            actions.push( {
            'label': 'View Entries',
            'name': 'view'
        } );
        console.log('Actions - '+actions);
        setTimeout( () => {
            doneCallback( actions );
        }, 200 );
    }

    handleRowAction( event ) {

        const actionName = event.detail.action.name;
        const row = event.detail.row;
        const resourceId = row.serviceResourceUrl.substring(1)
        console.log('get event - '+event);
        console.log('on click - '+actionName);
        console.log('on click - '+resourceId);
        retrieveResourceUserId({
            serviceResourceId: resourceId
        }).then(result => {
            console.log(' result 1' + JSON.stringify(result));
            if (result) {
                this.serviceResourceUserId = result;
                console.log(' result;;;' + this.serviceResourceUserId);
                this[NavigationMixin.Navigate]({
                    type: 'standard__navItemPage',
                    attributes: {
                    apiName: 'Time_Sheet_Summary'
                    },
                    state: {
                    c__recordId: result
                    }
                });
            }
        })

        
    }

    handleClientSideSearch(event) {
        clearTimeout(this.typingTimer);
        this.searchKey = event.target.value
        this.typingTimer = setTimeout(() => {
            let searchKey = event.detail.value
            let tempArr = [] 
            if (searchKey != '') {
                this.clonedRetrievedTimesheets.forEach(item => {
                    let startDateString = new Date(item.startDate).toDateString().toLowerCase()
                    let endDateString = new Date(item.endDate).toDateString().toLowerCase()
                    let approvalDateString = new Date(item.submittedForApprovalOn).toDateString().toLowerCase()
                    if(
                        item.timesheetNumber.toLowerCase().includes(searchKey.toLowerCase()) ||
                        item.serviceResourceName.toLowerCase().includes(searchKey.toLowerCase()) ||
                        item.activity.toLowerCase().includes(searchKey.toLowerCase()) ||
                        item.activityType.toLowerCase().includes(searchKey.toLowerCase()) ||
                        item.discipline.toLowerCase().includes(searchKey.toLowerCase()) ||
                        item.accName.toLowerCase().includes(searchKey.toLowerCase()) ||
                        item.serviceAppointment.toLowerCase().includes(searchKey.toLowerCase()) ||
                        startDateString.includes(searchKey.toLowerCase()) ||
                        endDateString.includes(searchKey.toLowerCase()) ||
                        approvalDateString.includes(searchKey.toLowerCase()) ||
                        item.totalDuration.toString().includes(searchKey) ||
                        approvalDateString.includes(searchKey.toLowerCase()) ||
                        item.status.toLowerCase().includes(searchKey.toLowerCase())
                    ){
                        tempArr.push(item)
                    }
                })
                if (tempArr.length > 0) {
                    this.retrievedTimesheets = []
                    this.retrievedTimesheets = [...tempArr]
                    this.totalRecords = this.retrievedTimesheets.length
                    this.pageNumber = 1
                    this.paginationHelper()
                } else {
                    this.retrievedTimesheets = []
                    this.totalRecords = this.retrievedTimesheets.length
                    this.pageNumber = 1
                    this.paginationHelper()
                }
            } else {
                this.retrievedTimesheets = []
                this.retrievedTimesheets = [...this.clonedRetrievedTimesheets]
                this.totalRecords = this.retrievedTimesheets.length
                this.pageNumber = 1
                this.paginationHelper()
            }
        }, 200);
    }
    paginationHelper() {
        this.isLoading = true
        this.recordsToDisplay = []
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        if (this.totalPages <= 0) {
            this.totalPages = 1
        }
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.retrievedTimesheets[i]);
        }
        this.isLoading = false
    }
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
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
    getSelectedRows(event) {
        let rows = event.detail.selectedRows;
        this.selectedRowIds = [];
        rows.forEach(row => {
            if(row.status=='Submitted'){
                this.selectedRowIds.push(row.id)
            }
        })
        this.selectedRows = [];
        rows.forEach(row => {
            if(this.selectedRowIds.indexOf(row.id)!=-1){
                this.selectedRows.push(row)
            }
        })
    }
    async handleApprove() {
        const result = await LightningConfirm.open({
            message: 'This will approve the selected timesheets. Press \'ok\' to confirm or \'Cancel\' to go back to the list view.',
            theme: 'success',
            label: 'Confirm timesheet approval',
            // setting theme would have no effect
        })
        if (result) {
            let timesheetIdList = this.selectedRows.map(item => {
                return item.id
            })
            approveTimesheet({ idList: timesheetIdList }).then(success => {
                if(success){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Approved selected timesheet records.',
                            variant: 'success'
                        })
                    );
                    this.handleRefresh()
                }
                else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'The submitted request(s) seems to have some issues. Please contact your System Administrator for more information.',
                            variant: 'error'
                        })
                    );
                }
            })
        }
    }
    get buttonsDisabled() {
        if (this.selectedRows.length > 0) {
            return false
        } else {
            return true
        }
    }
    handleReject() {
        this.showRejectModal = true;
    }
    handleRefresh() {
        this.isLoading = true
        this.selectedRows = []
        this.getTimesheets()
        setTimeout(() => {
            this.isLoading = false
        }, 1000)
    }
    closeRejectModal() {
        this.showRejectModal = false
    }
    handleComments(event) {
        this.rejectionComments = event.detail.value
    }
    submitRejection() {
        let idList = this.selectedRows.map(item => {
            return item.id
        })
        this.showRejectModal = false
        rejectTimesheet({ idList: idList, rejectionComments: this.rejectionComments }).then(success => {
            if(success){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Rejected selected timesheet records.',
                        variant: 'success'
                    })
                );
                this.handleRefresh()
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'The submitted request(s) seems to have some issues. Please contact your System Administrator for more information.',
                        variant: 'error'
                    })
                );
            }
        })
    }
    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        // console.log(this.sortBy)
        this.sortDirection = event.detail.sortDirection;
        // console.log(this.sortDirection)
        this.sortData(this.sortBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.retrievedTimesheets));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.retrievedTimesheets = parseData;
        this.paginationHelper()
    }
}