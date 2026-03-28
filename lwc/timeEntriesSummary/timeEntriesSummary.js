import {
    LightningElement,
    wire
} from 'lwc';
import USER_NAME from '@salesforce/schema/User.Name';
import USER_ID from '@salesforce/user/Id';
import {
    getRecord, getFieldValue
} from 'lightning/uiRecordApi';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import createOthersTS from '@salesforce/apex/Sav_FSL_TimeSheetcontroller.createOthersTS';
import getTimeSheets from '@salesforce/apex/Sav_FSL_TimeSheetcontroller.getTimeSheets';
import wireTimeSheetOthers from '@salesforce/apex/Sav_FSL_TimeSheetcontroller.wireTimeSheetOthers';
import getMetadata from '@salesforce/apex/Sav_FSL_TimeSheetcontroller.getMetadata';
import saveTimesheets from '@salesforce/apex/Sav_FSL_TimeSheetcontroller.saveTimesheets';
import saveTimesheetEntries from '@salesforce/apex/Sav_FSL_TimeSheetcontroller.saveTimesheetEntries';
import deleteTimeSheet from '@salesforce/apex/Sav_FSL_TimeSheetcontroller.deleteTimeSheet';

import getWOActivityType from '@salesforce/apex/Sav_FSL_TimeSheetcontroller.getWOActivityType';
import getWODisciplines from '@salesforce/apex/Sav_FSL_TimeSheetcontroller.getWODisciplines';
//UI
import icon from "@salesforce/resourceUrl/timesheet_icons";
import cstmStatic from '@salesforce/resourceUrl/savstatic';
import { CurrentPageReference } from 'lightning/navigation';//deepika
import {
    loadStyle,
    loadScript
} from 'lightning/platformResourceLoader';
//Custom Labeles
import SaveTimeEntries from '@salesforce/label/c.SaveTimeEntries';
import NoServiceTimeEntries from '@salesforce/label/c.NoServiceTimeEntries';
import TimeEntryIncrements from '@salesforce/label/c.TimeEntryIncrements';
import MaxHoursAllowed from '@salesforce/label/c.MaxHoursAllowed';
import SubmitSuccessMessage from '@salesforce/label/c.SubmitSuccessMessage';
import NoServiceAppointments from '@salesforce/label/c.NoServiceAppointments';
import TimeSheetsCompliance from '@salesforce/label/c.TimeSheetsCompliance';
import NoSAEntriesCompliance from '@salesforce/label/c.NoSAEntriesCompliance';
const FIELDS = ['User.Name'];
export default class TimeEntriesSummary extends NavigationMixin(LightningElement) {
    SaveTimeEntries = SaveTimeEntries;
    NoServiceTimeEntries = NoServiceTimeEntries;
    TimeEntryIncrements = TimeEntryIncrements;
    MaxHoursAllowed = MaxHoursAllowed;
    SubmitSuccessMessage = SubmitSuccessMessage;
    NoServiceAppointments = NoServiceAppointments;
    TimeSheetsCompliance = TimeSheetsCompliance;
    NoSAEntriesCompliance = NoSAEntriesCompliance;

    TimeSheetsCompliance = this.TimeSheetsCompliance;

    // calendar static resource
    calendar_ico = icon + '/savs-icons/calendar8.png';
    left_arrow_ico = icon + '/savs-icons/left-darrow.png';
    right_arrow_ico = icon + '/savs-icons/right-darrow.png';

    currentUserName
    startDate
    endDate
    weekDays = []
    daydateMap = new Map();
    timeSheetRecords
    othersTimeSheetRecord
    mainTimesheetMappedData = []
    otherTimesheetMappedData = []
    noRecordsFound = false
    noRecordsFoundErrorMessage = this.NoServiceAppointments
    noSAEntry = this.NoSAEntriesCompliance
    noOtherRecordsFound = false
    noOtherRecordsFoundErrorMessage = 'No records found for this date range.'
    metadataMasterList
    isLoading = false
    activityTypeOptions = []

    timeSheetEntries = []
    timesheets = []
    //
    activityTypeHeaderOptions = []
    headerDisiplineOptions = []
    enableAccName = false;

    //

    timeTotalsArray = []
    mondayTotal = 0
    tuesdayTotal = 0
    wednesdaytotal = 0
    thursdayTotal = 0
    fridayTotal = 0
    saturdayTotal = 0
    sundayTotal = 0

    mondayHours
    tuesdayHours
    wednesdayHours
    thursdayHours
    fridayHours
    saturdayHours
    sundayHours

    showError = false;
    errorMessage = '';

    isDisabled = true;
    timesheetsUpdateList = []
    userRecordId;
    userData
    isDisabledCreteRecord = true;

    
    @wire(CurrentPageReference)
        getStateParameters(currentPageReference) {
            if (currentPageReference && currentPageReference.state['c__recordId']) {
                this.userRecordId= currentPageReference.state['c__recordId'];
        }
        this.timesheets = [];
        this.setWeekDays(new Date())
        this.onLoadData();
    }   
    renderedCallback() {
        Promise.all([
            loadStyle(this, cstmStatic + '/css/main.css')
        ]).then(() => {
            console.log('file loaded');
        });
    }

    
   @wire(getRecord, { recordId: '$userRecordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading user name',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            this.userData = data;
            this.currentUserName = this.userData.fields.Name.value;
        }
    }
    connectedCallback() {
        this.setWeekDays(new Date())
        getWOActivityType().then(result => {
            if (result) {
                let options = [];
                this.activityTypeHeaderOptions = result.map(option => {
                    return {
                        label: option,
                        value: option
                    };
                });
            } else {
            }
        })

        //to get header disicpline values from apex
        getWODisciplines().then(result => {
            if (result) {

                let options = [];
                this.headerDisiplineOptions = result.map(option => {
                    return {
                        label: option,
                        value: option
                    };
                });
            } else {
            }
        })


        this.onLoadData(); //reload
        this.currentUserName = this.username;
        getMetadata().then(result => {
            if (result) {
                this.metadataMasterList = result
            } else {
            }
        })

    }

    prevweekHandler() {
        var today = new Date(this.startDate);
        const userTimeZoneOffset = today.getTimezoneOffset() / 60;
        var previousWeek = (new Date(today.getFullYear(), today.getMonth(), today.getDate() - 1));
        previousWeek.setUTCHours(-userTimeZoneOffset,23,59,59);
        this.setWeekDays(previousWeek);
        this.timesheets = [];
    }
    nextweekHandler() {
        var today = new Date(this.startDate);
        const userTimeZoneOffset = today.getTimezoneOffset() / 60;
        var nextWeek = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 9);
        nextWeek.setUTCHours(-userTimeZoneOffset,0,0,0);
        this.setWeekDays(nextWeek);
        this.timesheets = [];
    }

    //reload
    setWeekDays(startDate) {
      let todayDate = new Date();
        this.datetoday = todayDate.toISOString();
        let dayOfWeek = startDate.getDay()
        let mondayDate = new Date(startDate.getTime() - ((dayOfWeek ==0 ? 7 :dayOfWeek) - 1) * 24 * 60 * 60 * 1000)
        let dayStartDate = new Date(mondayDate.getTime() + 0 * 24 * 60 * 60 * 1000)
        let dayendDate = new Date(mondayDate.getTime() + 6 * 24 * 60 * 60 * 1000)
        this.startDate = this.formatDate(dayStartDate)
        this.endDate = this.formatDate(dayendDate)	
        if (this.endDate >= this.formatDate(todayDate)) {
            this.isDisablednextWeek = true;
            this.myClass = 'nextDisabled';
        } else {
            this.isDisablednextWeek = false;
            this.myClass = '';
        }
        this.weekDays = [];
        for (let i = 0; i < 7; i++) {
            let dayDate = new Date(mondayDate.getTime() + i * 24 * 60 * 60 * 1000);
            let dayLabel = this.getDayLabel(i);
            this.daydateMap.set(dayLabel, this.formatDate(dayDate));
            this.weekDays.push({
                index: i,
                label: dayLabel,
                date: this.formatDate(dayDate),
                hours: 0
            });
        }
        // this.timesheets=[];	
        this.onLoadData();
    }

    onLoadData() {
        this.noRecordsFound = false
        this.timeSheetRecords = [];
        this.mainTimesheetMappedData = [];
        this.othersTimeSheetRecord = ''
        this.otherTimesheetMappedData = [];
        getTimeSheets({
            userId: this.userRecordId, // deepika 
            weekDate: this.startDate,
            EndDt: this.endDate
        }).then(result => {
            if (result) {
                this.timeSheetRecords = result
                this.mainTimesheetMappedData = this.timeSheetRecords.map(item => {
                    return {
                        Id: item.Id,
                        Sav_FSL_WorkOrderSubject__c: item.Sav_FSL_WorkOrderSubject__c,
                        ServiceAppointmentSubject__c: item.ServiceAppointmentSubject__c,
                        Sav_FSL_Activity_Type__c: item.Sav_FSL_Activity_Type__c,
                        Sav_FSL_Activity__c: item.Sav_FSL_Activity__c,
                        Sav_FSL_Discipline__c: item.Sav_FSL_Discipline__c,
                        Status: item.Status,
                        Comments__c: item.Comments__c,
                        Sav_FSL_Section__c: item.Sav_FSL_Section__c,
                        TotalDurationInHours: item.TotalDurationInHours,
                        Sav_FSL_Monday__c: item.Sav_FSL_Monday__c ? item.Sav_FSL_Monday__c : '0',
                        Sav_FSL_Tuesday__c: item.Sav_FSL_Tuesday__c ? item.Sav_FSL_Tuesday__c : '0',
                        Sav_FSL_Wednesday__c: item.Sav_FSL_Wednesday__c ? item.Sav_FSL_Wednesday__c : '0',
                        Sav_FSL_Thursday__c: item.Sav_FSL_Thursday__c ? item.Sav_FSL_Thursday__c : '0',
                        Sav_FSL_Friday__c: item.Sav_FSL_Friday__c ? item.Sav_FSL_Friday__c : '0',
                        Sav_FSL_Saturday__c: item.Sav_FSL_Saturday__c ? item.Sav_FSL_Saturday__c : '0',
                        Sav_FSL_Sunday__c: item.Sav_FSL_Sunday__c ? item.Sav_FSL_Sunday__c : '0',
                        isDisabled: (item.Status == 'Approved' || item.Status == 'Submitted') ? true : false
                    }
                })
                this.combineIntoTimesheets()
                this.parseTotalsOnLoad()
            } else {
                this.parseTotalsOnLoad()	
                this.noRecordsFound = true
            }
        })
        //this.noRecordsFound = false	

        wireTimeSheetOthers({
            serviceResourceUser: this.userRecordId,
            startDate: this.startDate,
            endDate: this.endDate
        }).then(result => {
            if (result) {
                this.othersTimeSheetRecord = result
                this.otherTimesheetMappedData = this.othersTimeSheetRecord.map(item => {
                    /* if (item.Sav_FSL_Activity__c == 'PILOT-STANDARD-FY24') {	
                         this.enableAccName = true;	
                     }	
                     else {	
                         this.enableAccName = false;	
                     }*/
                    return {
                        Id: item.Id,
                        Sav_FSL_Activity__c: item.Sav_FSL_Activity__c,
                        Sav_FSL_Activity_Type__c: item.Sav_FSL_Activity_Type__c,
                        Sav_FSL_Discipline__c: item.Sav_FSL_Discipline__c,
                        Sav_FSL_activityTypeOptions__c: item.Sav_FSL_activityTypeOptions__c,
                        Sav_FSL_Break_During_Delivery_Of__c: item.Sav_FSL_Break_During_Delivery_Of__c,
                        Sav_FSL_Territory__c: item.Sav_FSL_Territory__c,
                        Sav_FSL_State__c: item.Sav_FSL_State__c,
                        Comments__c: item.Comments__c,
                        Sav_FSL_Account_Name__c: item.Sav_FSL_Account_Name__c,
                        Sav_FSL_Section__c: item.Sav_FSL_Section__c,
                        Account__c: item.Account__c,
                        Sav_FSL_Monday__c: item.Sav_FSL_Monday__c ? item.Sav_FSL_Monday__c : '0',
                        Sav_FSL_Tuesday__c: item.Sav_FSL_Tuesday__c ? item.Sav_FSL_Tuesday__c : '0',
                        Sav_FSL_Wednesday__c: item.Sav_FSL_Wednesday__c ? item.Sav_FSL_Wednesday__c : '0',
                        Sav_FSL_Thursday__c: item.Sav_FSL_Thursday__c ? item.Sav_FSL_Thursday__c : '0',
                        Sav_FSL_Friday__c: item.Sav_FSL_Friday__c ? item.Sav_FSL_Friday__c : '0',
                        Sav_FSL_Saturday__c: item.Sav_FSL_Saturday__c ? item.Sav_FSL_Saturday__c : '0',
                        Sav_FSL_Sunday__c: item.Sav_FSL_Sunday__c ? item.Sav_FSL_Sunday__c : '0',
                        Status: item.Status,
                        isDisabled: (item.Status == 'Approved' || item.Status == 'Submitted') ? true : false
                    }
                })
                this.combineIntoTimesheets()
                this.parseTotalsOnLoad()
            } else {
                this.parseTotalsOnLoad()	
                this.noOtherRecordsFound = true
            }
        })
    }
    //END
    //
    handleDelete(event) {
        const tsRecordId = event.target.dataset.id;
        this.isLoading = true;
        deleteTimeSheet({
            userID: this.userRecordId,
            startDate: this.startDate,
            endDate: this.endDate,
            rowId: tsRecordId
        }).then(result => {
            this.isLoading = false;
            // console.log('I am in delete js' + result.length)
            if (result) {
                this.othersTimeSheetRecord = result
                this.otherTimesheetMappedData = this.othersTimeSheetRecord.map(item => {
                    return {
                        Id: item.Id,
                        Sav_FSL_Activity__c: item.Sav_FSL_Activity__c,
                        Sav_FSL_Activity_Type__c: item.Sav_FSL_Activity_Type__c,
                        Sav_FSL_Discipline__c: item.Sav_FSL_Discipline__c,
                        Sav_FSL_activityTypeOptions__c: item.Sav_FSL_activityTypeOptions__c,
                        Sav_FSL_Break_During_Delivery_Of__c: item.Sav_FSL_Break_During_Delivery_Of__c,
                        Sav_FSL_Territory__c: item.Sav_FSL_Territory__c,
                        Sav_FSL_Section__c: item.Sav_FSL_Section__c,
                        Sav_FSL_State__c: item.Sav_FSL_State__c,
                        Comments__c: item.Comments__c,
                        Sav_FSL_Monday__c: item.Sav_FSL_Monday__c ? item.Sav_FSL_Monday__c : '0',
                        Sav_FSL_Tuesday__c: item.Sav_FSL_Tuesday__c ? item.Sav_FSL_Tuesday__c : '0',
                        Sav_FSL_Wednesday__c: item.Sav_FSL_Wednesday__c ? item.Sav_FSL_Wednesday__c : '0',
                        Sav_FSL_Thursday__c: item.Sav_FSL_Thursday__c ? item.Sav_FSL_Thursday__c : '0',
                        Sav_FSL_Friday__c: item.Sav_FSL_Friday__c ? item.Sav_FSL_Friday__c : '0',
                        Sav_FSL_Saturday__c: item.Sav_FSL_Saturday__c ? item.Sav_FSL_Saturday__c : '0',
                        Sav_FSL_Sunday__c: item.Sav_FSL_Sunday__c ? item.Sav_FSL_Sunday__c : '0',
                        Account__c: item.Account__c,
                        Account__c: item.Account__c ? item.Account__c : '',
                        Sav_FSL_Account_Name__c: item.Sav_FSL_Account_Name__c ? item.Sav_FSL_Account_Name__c : '',
                        Status: item.Status,
                        isDisabled: (item.Status == 'Approved' || item.Status == 'Submitted') ? true : false
                    }
                })
                this.combineIntoTimesheets()
            } else {
                this.noOtherRecordsFound = true
                this.otherTimesheetMappedData = [];
                this.combineIntoTimesheets()
            }
        })
    }
    //
    getwireTimeSheetOthers() {
        createOthersTS({
            userID: this.userRecordId,
            startDate: this.startDate,
            endDate: this.endDate
        }).then(result => {
            if (result) {
                this.othersTimeSheetRecord = result
                this.otherTimesheetMappedData = this.othersTimeSheetRecord.map(item => {
                    return {
                        Id: item.Id,
                        Sav_FSL_Activity__c: item.Sav_FSL_Activity__c,
                        Sav_FSL_Activity_Type__c: item.Sav_FSL_Activity_Type__c,
                        Sav_FSL_Discipline__c: item.Sav_FSL_Discipline__c,
                        Sav_FSL_activityTypeOptions__c: item.Sav_FSL_activityTypeOptions__c,
                        Sav_FSL_Break_During_Delivery_Of__c: item.Sav_FSL_Break_During_Delivery_Of__c,
                        Sav_FSL_Territory__c: item.Sav_FSL_Territory__c,
                        Sav_FSL_Section__c: item.Sav_FSL_Section__c,
                        Sav_FSL_State__c: item.Sav_FSL_State__c,
                        Comments__c: item.Comments__c,
                        Sav_FSL_Monday__c: item.Sav_FSL_Monday__c ? item.Sav_FSL_Monday__c : '0',
                        Sav_FSL_Tuesday__c: item.Sav_FSL_Tuesday__c ? item.Sav_FSL_Tuesday__c : '0',
                        Sav_FSL_Wednesday__c: item.Sav_FSL_Wednesday__c ? item.Sav_FSL_Wednesday__c : '0',
                        Sav_FSL_Thursday__c: item.Sav_FSL_Thursday__c ? item.Sav_FSL_Thursday__c : '0',
                        Sav_FSL_Friday__c: item.Sav_FSL_Friday__c ? item.Sav_FSL_Friday__c : '0',
                        Sav_FSL_Saturday__c: item.Sav_FSL_Saturday__c ? item.Sav_FSL_Saturday__c : '0',
                        Sav_FSL_Sunday__c: item.Sav_FSL_Sunday__c ? item.Sav_FSL_Sunday__c : '0',
                        Account__c: item.Account__c,
                        Sav_FSL_Account_Name__c: item.Sav_FSL_Account_Name__c ? item.Sav_FSL_Account_Name__c : '',
                        Status: item.Status,
                        isDisabled: (item.Status == 'Approved' || item.Status == 'Submitted') ? true : false
                    }
                })
                this.combineIntoTimesheets()
            } else {
                this.noOtherRecordsFound = true
            }
        })
    }

    combineIntoTimesheets() {
     if (this.mainTimesheetMappedData.length > 0 && this.otherTimesheetMappedData.length == 0) {
            this.timesheets = [...this.mainTimesheetMappedData]
            this.parseTotalsOnLoad()
        }
        else if (this.mainTimesheetMappedData.length > 0 && this.otherTimesheetMappedData.length > 0) {
            this.timesheets = [...this.mainTimesheetMappedData, ...this.otherTimesheetMappedData]
            this.parseTotalsOnLoad()
        }
        else if (this.mainTimesheetMappedData.length == 0 && this.otherTimesheetMappedData.length > 0) {
            this.timesheets = [...this.otherTimesheetMappedData]
            this.parseTotalsOnLoad()
        }
        else{
             this.timesheets = [];
            this.parseTotalsOnLoad()
        }

        var disableCheckArr = [];
        // var disablesaveNsubmit = false;
        this.timesheets.forEach(item => {
            if (item.Status == 'Approved' || (item.Status == 'Submitted')) {
                disableCheckArr.push(1);
            } else {
                disableCheckArr.push(0);
            }
        });
        if (disableCheckArr.indexOf(0) == -1) {
            this.showError = true;
            // document.getElementById("save").removeAttribute("disabled");
        } else {
            this.showError = false;
            //  document.getElementById("save").setAttribute("disabled", "disabled");
        }
    }
    parseTotalsOnLoad() {
        let mon = 0
        let tue = 0
        let wed = 0
        let thurs = 0
        let fri = 0
        let sat = 0
        let sun = 0
        if(this.timesheets.length > 0){
          this.timesheets.forEach(item => {
            mon += parseFloat(item.Sav_FSL_Monday__c)
            tue += parseFloat(item.Sav_FSL_Tuesday__c)
            wed += parseFloat(item.Sav_FSL_Wednesday__c)
            thurs += parseFloat(item.Sav_FSL_Thursday__c)
            fri += parseFloat(item.Sav_FSL_Friday__c)
            sat += parseFloat(item.Sav_FSL_Saturday__c)
            sun += parseFloat(item.Sav_FSL_Sunday__c)
        })
        }
       
        this.mondayTotal = mon
        this.tuesdayTotal = tue
        this.wednesdaytotal = wed
        this.thursdayTotal = thurs
        this.fridayTotal = fri
        this.saturdayTotal = sat
        this.sundayTotal = sun
    }

    formatDate(date) {
        let year = date.getFullYear();
        let month = this.addLeadingZero(date.getMonth() + 1);
        let day = this.addLeadingZero(date.getDate());
        return `${year}-${month}-${day}`;
    }
    addLeadingZero(number) {
        return number < 10 ? '0' + number : number;
    }
    getDayLabel(index) {
        let days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        return days[index];
    }
    get activityOptions() {
        let activityList = []
        this.metadataMasterList.forEach(item => {
            activityList.push({
                label: item.Label,
                value: item.Label
            })
        })
        return activityList
    }
    //header activity type onchange method
    handleHeaderActivityTypeChange(event) {
        let dataId = event.target.dataset.id
        let value = event.detail.value
        let index = this.mainTimesheetMappedData.findIndex(item => item.Id === dataId)
        if (index != -1) {
            this.mainTimesheetMappedData[index].Sav_FSL_Activity_Type__c = value
        }
        let timesheetsIndex = this.timesheets.findIndex(item => item.Id === dataId)
        if (timesheetsIndex != -1) {
            let timesheetRecord = this.timesheets[timesheetsIndex]
            timesheetRecord.Sav_FSL_Activity_Type__c = value
        }
    }

    //header Discipline onchange method
    handleHeaderDisciplineChange(event) {
        let dataId = event.target.dataset.id
        let value = event.detail.value
        let index = this.mainTimesheetMappedData.findIndex(item => item.Id === dataId)
        if (index != -1) {
            this.mainTimesheetMappedData[index].Sav_FSL_Discipline__c = value
        }
        let timesheetsIndex = this.timesheets.findIndex(item => item.Id === dataId)
        if (timesheetsIndex != -1) {
            let timesheetRecord = this.timesheets[timesheetsIndex]
            timesheetRecord.Sav_FSL_Discipline__c = value
        }
    }

    handleComments(event) {
        let dataId = event.detail.id
        let comments = event.detail.comments
        let index = this.mainTimesheetMappedData.findIndex(item => item.Id === dataId)
        if (index != -1) {
            this.mainTimesheetMappedData[index].Comments__c = comments
        }
        let timesheetsIndex = this.timesheets.findIndex(item => item.Id === dataId)
        if (timesheetsIndex != -1) {
            this.timesheets[timesheetsIndex].Comments__c = comments
        }
    }


    handleActivityCombobox(event) {
        this.isLoading = true
        let dataId = event.target.dataset.id
        let value = event.detail.value
        let index = this.otherTimesheetMappedData.findIndex(item => item.Id === dataId)
        let metadataIndex = this.metadataMasterList.findIndex(item => item.Label === value)
        let activityTypes = this.metadataMasterList[metadataIndex].Activity_Type__c
        if (value == 'PILOT-STANDARD-FY24') {
            this.enableAccName = true;
        }
        else {
            this.enableAccName = false;
        }
        if (index != -1) {
            this.otherTimesheetMappedData[index].Sav_FSL_Activity__c = value
            this.otherTimesheetMappedData[index].Sav_FSL_activityTypeOptions__c = activityTypes
        }
        let timesheetsIndex = this.timesheets.findIndex(item => item.Id === dataId)
        if (timesheetsIndex != -1) {
            let timesheetRecord = this.timesheets[timesheetsIndex]
            timesheetRecord.Sav_FSL_Activity__c = value
            timesheetRecord.Sav_FSL_activityTypeOptions__c = activityTypes
        }

        setTimeout(() => {
            this.isLoading = false
        }, 200);
    }
    handleActivityTypeChange(event) {
        this.isLoading = true
        let dataId = event.detail.dataId
        let value = event.detail.value
        let index = this.otherTimesheetMappedData.findIndex(item => item.Id === dataId)
        this.otherTimesheetMappedData[index].Sav_FSL_Activity_Type__c = value
        let timesheetsIndex = this.timesheets.findIndex(item => item.Id === dataId)
        if (timesheetsIndex != -1) {
            let timesheetRecord = this.timesheets[timesheetsIndex]
            timesheetRecord.Sav_FSL_Activity_Type__c = value
        }
        setTimeout(() => {
            this.isLoading = false
        }, 200);
    }
    handleDisciplineChange(event) {
        this.isLoading = true
        let dataId = event.detail.dataId
        let value = event.detail.value
        let index = this.otherTimesheetMappedData.findIndex(item => item.Id === dataId)
        this.otherTimesheetMappedData[index].Sav_FSL_Discipline__c = value
        let timesheetsIndex = this.timesheets.findIndex(item => item.Id === dataId)
        if (timesheetsIndex != -1) {
            let timesheetRecord = this.timesheets[timesheetsIndex]
            timesheetRecord.Sav_FSL_Discipline__c = value
        }
        setTimeout(() => {
            this.isLoading = false
        }, 200);
    }
    handleStateChange(event) {
        this.isLoading = true
        let dataId = event.detail.dataId
        let value = event.detail.value
        let index = this.otherTimesheetMappedData.findIndex(item => item.Id === dataId)
        this.otherTimesheetMappedData[index].Sav_FSL_State__c = value
        let timesheetsIndex = this.timesheets.findIndex(item => item.Id === dataId)
        if (timesheetsIndex != -1) {
            let timesheetRecord = this.timesheets[timesheetsIndex]
            timesheetRecord.Sav_FSL_State__c = value
        }
        setTimeout(() => {
            this.isLoading = false
        }, 200);
    }
    handleAccChange(event) {
        // let dataId = event.detail.dataId
        const dataId = event.target.dataset.id
        let value = event.detail.value
        let index = this.otherTimesheetMappedData.findIndex(item => item.Id === dataId)
        this.otherTimesheetMappedData[index].Sav_FSL_Account_Name__c = value
        let timesheetsIndex = this.timesheets.findIndex(item => item.Id === dataId)
        if (timesheetsIndex != -1) {
            let timesheetRecord = this.timesheets[timesheetsIndex]
            timesheetRecord.Sav_FSL_Account_Name__c = value
        }
    }
    accountChangeHandler(event) {
        let value = event.detail.value
        let label = event.detail.label
        let dataId = event.detail.dataId
        let index = this.otherTimesheetMappedData.findIndex(item => item.Id === dataId)
        if (index != -1) {
            this.otherTimesheetMappedData[index].Sav_FSL_Account_Name__c = label
            this.otherTimesheetMappedData[index].Account__c = value
        }
        let timesheetsIndex = this.timesheets.findIndex(item => item.Id === dataId)
        if (timesheetsIndex != -1) {
            this.timesheets[timesheetsIndex].Sav_FSL_Account_Name__c = label
            this.timesheets[timesheetsIndex].Account__c = value
        }
    }
    handleTerritoryChange(event) {
        this.isLoading = true
        let dataId = event.detail.dataId
        let value = event.detail.value
        let index = this.otherTimesheetMappedData.findIndex(item => item.Id === dataId)
        this.otherTimesheetMappedData[index].Sav_FSL_Territory__c = value
        let timesheetsIndex = this.timesheets.findIndex(item => item.Id === dataId)
        if (timesheetsIndex != -1) {
            let timesheetRecord = this.timesheets[timesheetsIndex]
            timesheetRecord.Sav_FSL_Territory__c = value
        }
        setTimeout(() => {
            this.isLoading = false
        }, 200);
    }
    handleBreakChange(event) {
        this.isLoading = true
        let dataId = event.detail.dataId
        let value = event.detail.value
        let index = this.otherTimesheetMappedData.findIndex(item => item.Id === dataId)
        this.otherTimesheetMappedData[index].Sav_FSL_Break_During_Delivery_Of__c = value
        let timesheetsIndex = this.timesheets.findIndex(item => item.Id === dataId)
        if (timesheetsIndex != -1) {
            let timesheetRecord = this.timesheets[timesheetsIndex]
            timesheetRecord.Sav_FSL_Break_During_Delivery_Of__c = value
        }
        setTimeout(() => {
            this.isLoading = false
        }, 200);
    }
    handleMondayChange(event) {
        event.target.value = event.target.value.replace(/[^\d.]/g, "")
        this.mondayHours = event.target.value ? event.target.value : '0'
        const rowId = event.target.dataset.id
        if (this.validateEnteredHours(this.mondayHours)) {
            event.target.setCustomValidity('')
            event.target.reportValidity()
            this.showError = false;
            this.errorMessage = '';
            let date = event.target.dataset.day
            // UI Data setup
            let mainTimesheetsIndex = this.mainTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (mainTimesheetsIndex != -1) {
                let mainTimesheetsRecord = this.mainTimesheetMappedData[mainTimesheetsIndex]
                mainTimesheetsRecord.Sav_FSL_Monday__c = this.mondayHours
            }
            let othersTimesheetsIndex = this.otherTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (othersTimesheetsIndex != -1) {
                let otherTimesheetsRecord = this.otherTimesheetMappedData[othersTimesheetsIndex]
                otherTimesheetsRecord.Sav_FSL_Monday__c = this.mondayHours
            }
            // Time Sheet Data Setup
            let timesheetsIndex = this.timesheets.findIndex(item => item.Id === rowId)
            if (timesheetsIndex != -1) {
                let timesheetRecord = this.timesheets[timesheetsIndex]
                timesheetRecord.Sav_FSL_Monday__c = this.mondayHours
            }
            //Time Entry Data Setup
            const timesheetEntry = this.timeSheetEntries.find(p => p.TimeSheetId === rowId && p.StartTime === this.daydateMap.get(date));
            if (timesheetEntry) {
                timesheetEntry.Sav_Duration__c = this.mondayHours;
            }
            if (!timesheetEntry) {
                this.timeSheetEntries.push({
                    TimeSheetId: rowId,
                    StartTime: this.daydateMap.get(date),
                    Sav_Duration__c: this.mondayHours
                });
            }
            this.mondayTotal = 0
            this.timesheets.forEach(item => {
                if (item.Sav_FSL_Monday__c != '') {
                    this.mondayTotal += parseFloat(parseFloat(item.Sav_FSL_Monday__c).toFixed(2))
                } else {
                    this.mondayTotal += 0
                }
            })
        } else {
            this.showError = true;
            this.errorMessage = ('Invalid Time Increments')
            event.target.setCustomValidity()
            event.target.reportValidity()
            if (this.mondayHours <= 24) {
                const eventT = new ShowToastEvent({
                    title: 'Error',
                    message: this.TimeEntryIncrements,
                    variant: 'error',
                });
                this.dispatchEvent(eventT);
            }

        }
    }
    handleTuesdayChange(event) {
        event.target.value = event.target.value.replace(/[^\d.]/g, "")
        this.tuesdayHours = event.target.value ? event.target.value : '0'
        const rowId = event.target.dataset.id;
        if (this.validateEnteredHours(this.tuesdayHours)) {
            event.target.setCustomValidity('')
            event.target.reportValidity()
            this.showError = false;
            this.errorMessage = '';
            let date = event.target.dataset.day;
            // UI Data setup
            let mainTimesheetsIndex = this.mainTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (mainTimesheetsIndex != -1) {
                let mainTimesheetsRecord = this.mainTimesheetMappedData[mainTimesheetsIndex]
                mainTimesheetsRecord.Sav_FSL_Tuesday__c = this.tuesdayHours
            }
            let othersTimesheetsIndex = this.otherTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (othersTimesheetsIndex != -1) {
                let otherTimesheetsRecord = this.otherTimesheetMappedData[othersTimesheetsIndex]
                otherTimesheetsRecord.Sav_FSL_Tuesday__c = this.tuesdayHours
            }
            // Time Sheet Data Setup
            let timesheetsIndex = this.timesheets.findIndex(item => item.Id === rowId)
            if (timesheetsIndex != -1) {
                let timesheetRecord = this.timesheets[timesheetsIndex]
                timesheetRecord.Sav_FSL_Tuesday__c = this.tuesdayHours
            }



            //Time Entry Data Setup
            const timesheetEntry = this.timeSheetEntries.find(p => p.TimeSheetId === rowId && p.StartTime === this.daydateMap.get(date));
            if (timesheetEntry) {
                timesheetEntry.Sav_Duration__c = this.tuesdayHours;
            }
            if (!timesheetEntry) {
                this.timeSheetEntries.push({
                    TimeSheetId: rowId,
                    StartTime: this.daydateMap.get(date),
                    Sav_Duration__c: this.tuesdayHours
                });
            }
            this.tuesdayTotal = 0;
            this.timesheets.forEach(item => {
                if (item.Sav_FSL_Tuesday__c != '') {
                    this.tuesdayTotal += parseFloat(parseFloat(item.Sav_FSL_Tuesday__c).toFixed(2))
                } else {
                    this.tuesdayTotal += 0
                }
            })
        } else {
            this.showError = true;
            this.errorMessage = ('Invalid Time Increments')
            // event.target.setCustomValidity('Invalid Input')
            event.target.reportValidity()
            if (this.tuesdayHours <= 24) {
                const eventT = new ShowToastEvent({
                    title: 'Error',
                    message: this.TimeEntryIncrements,
                    variant: 'error',
                });
                this.dispatchEvent(eventT);
            }
        }
    }
    handleWednesdayChange(event) {
        event.target.value = event.target.value.replace(/[^\d.]/g, "")
        this.wednesdayHours = event.target.value ? event.target.value : '0'
        const rowId = event.target.dataset.id;
        let date = event.target.dataset.day;
        if (this.validateEnteredHours(this.wednesdayHours)) {
            event.target.setCustomValidity('')
            event.target.reportValidity()
            this.showError = false;
            this.errorMessage = '';
            // UI Data setup
            let mainTimesheetsIndex = this.mainTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (mainTimesheetsIndex != -1) {
                let mainTimesheetsRecord = this.mainTimesheetMappedData[mainTimesheetsIndex]
                mainTimesheetsRecord.Sav_FSL_Wednesday__c = this.wednesdayHours
            }
            let othersTimesheetsIndex = this.otherTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (othersTimesheetsIndex != -1) {
                let otherTimesheetsRecord = this.otherTimesheetMappedData[othersTimesheetsIndex]
                otherTimesheetsRecord.Sav_FSL_Wednesday__c = this.wednesdayHours
            }
            // Time Sheet data Mapping
            let timesheetsIndex = this.timesheets.findIndex(item => item.Id === rowId)
            if (timesheetsIndex != -1) {
                let timesheetRecord = this.timesheets[timesheetsIndex]
                timesheetRecord.Sav_FSL_Wednesday__c = this.wednesdayHours
            }


            // Time sheet entry data map
            const timesheetEntry = this.timeSheetEntries.find(p => p.TimeSheetId === rowId && p.StartTime === this.daydateMap.get(date));
            if (timesheetEntry) {
                timesheetEntry.Sav_Duration__c = this.wednesdayHours;
            }
            if (!timesheetEntry) {
                this.timeSheetEntries.push({
                    TimeSheetId: rowId,
                    StartTime: this.daydateMap.get(date),
                    Sav_Duration__c: this.wednesdayHours
                });
            }
            this.wednesdaytotal = 0;
            this.timesheets.forEach(item => {
                if (item.Sav_FSL_Wednesday__c != '') {
                    this.wednesdaytotal += parseFloat(parseFloat(item.Sav_FSL_Wednesday__c).toFixed(2))
                } else {
                    this.wednesdaytotal += 0
                }
            })
        } else {
            this.showError = true;
            event.target.reportValidity()
            if (this.wednesdayHours <= 24) {
                const eventT = new ShowToastEvent({
                    title: 'Error',
                    message: this.TimeEntryIncrements,
                    variant: 'error',
                });
                this.dispatchEvent(eventT);
            }
        }
    }
    handleThursdayChange(event) {
        event.target.value = event.target.value.replace(/[^\d.]/g, "")
        this.thursdayHours = event.target.value ? event.target.value : '0'
        if (this.validateEnteredHours(this.thursdayHours)) {
            const rowId = event.target.dataset.id;
            let date = event.target.dataset.day;
            event.target.setCustomValidity('')
            event.target.reportValidity()
            this.showError = false;
            this.errorMessage = '';
            // UI Data setup
            let mainTimesheetsIndex = this.mainTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (mainTimesheetsIndex != -1) {
                let mainTimesheetsRecord = this.mainTimesheetMappedData[mainTimesheetsIndex]
                mainTimesheetsRecord.Sav_FSL_Thursday__c = this.thursdayHours
            }
            let othersTimesheetsIndex = this.otherTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (othersTimesheetsIndex != -1) {
                let otherTimesheetsRecord = this.otherTimesheetMappedData[othersTimesheetsIndex]
                otherTimesheetsRecord.Sav_FSL_Thursday__c = this.thursdayHours
            }
            //Timesheet Data
            let timesheetsIndex = this.timesheets.findIndex(item => item.Id === rowId)
            if (timesheetsIndex != -1) {
                let timesheetRecord = this.timesheets[timesheetsIndex]
                timesheetRecord.Sav_FSL_Thursday__c = this.thursdayHours
            }



            //time sheet entry data
            const timesheetEntry = this.timeSheetEntries.find(p => p.TimeSheetId === rowId && p.StartTime === this.daydateMap.get(date));
            if (timesheetEntry) {
                timesheetEntry.Sav_Duration__c = this.thursdayHours;
                //console.log('heyEntry');
            }
            if (!timesheetEntry) {
                this.timeSheetEntries.push({
                    TimeSheetId: rowId,
                    StartTime: this.daydateMap.get(date),
                    Sav_Duration__c: this.thursdayHours
                });
            }
            this.thursdayTotal = 0;
            this.timesheets.forEach(item => {
                if (item.Sav_FSL_Thursday__c != '') {
                    this.thursdayTotal += parseFloat(parseFloat(item.Sav_FSL_Thursday__c).toFixed(2))
                } else {
                    this.thursdayTotal += 0
                }
            })
        } else {
            this.showError = true;
            // this.errorMessage = ('Invalid Time Increments')
            //  event.target.setCustomValidity('Invalid Input')
            event.target.reportValidity()
            if (this.thursdayHours <= 24) {
                const eventT = new ShowToastEvent({
                    title: 'Error',
                    message: this.TimeEntryIncrements,
                    variant: 'error',
                });
                this.dispatchEvent(eventT);
            }
        }
    }
    handleFridayChange(event) {
        event.target.value = event.target.value.replace(/[^\d.]/g, "")
        this.fridayHours = event.target.value ? event.target.value : '0'
        //Validation Code
        if (this.validateEnteredHours(this.fridayHours)) {
            event.target.setCustomValidity('')
            event.target.reportValidity()
            this.showError = false;
            this.errorMessage = '';
            const rowId = event.target.dataset.id;
            let date = event.target.dataset.day;
            // UI Data setup
            let mainTimesheetsIndex = this.mainTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (mainTimesheetsIndex != -1) {
                let mainTimesheetsRecord = this.mainTimesheetMappedData[mainTimesheetsIndex]
                mainTimesheetsRecord.Sav_FSL_Friday__c = this.fridayHours
            }
            let othersTimesheetsIndex = this.otherTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (othersTimesheetsIndex != -1) {
                let otherTimesheetsRecord = this.otherTimesheetMappedData[othersTimesheetsIndex]
                otherTimesheetsRecord.Sav_FSL_Friday__c = this.fridayHours
            }
            // Time Sheet Data
            let timesheetsIndex = this.timesheets.findIndex(item => item.Id === rowId)
            if (timesheetsIndex != -1) {
                let timesheetRecord = this.timesheets[timesheetsIndex]
                timesheetRecord.Sav_FSL_Friday__c = this.fridayHours
            }
            //
            //Time Sheet Data entry
            const timesheetEntry = this.timeSheetEntries.find(p => p.TimeSheetId === rowId && p.StartTime === this.daydateMap.get(date));
            if (timesheetEntry) {
                timesheetEntry.Sav_Duration__c = this.fridayHours;
            }
            if (!timesheetEntry) {
                this.timeSheetEntries.push({
                    TimeSheetId: rowId,
                    StartTime: this.daydateMap.get(date),
                    Sav_Duration__c: this.fridayHours
                });
            }
            this.fridayTotal = 0;
            this.timesheets.forEach(item => {
                if (item.Sav_FSL_Friday__c != '') {
                    this.fridayTotal += parseFloat(parseFloat(item.Sav_FSL_Friday__c).toFixed(2))
                } else {
                    this.fridayTotal += 0
                }
            })
        } else {
            this.showError = true;
            //  this.errorMessage = ('Invalid Time Increments')
            // event.target.setCustomValidity('Invalid Input')
            event.target.reportValidity()
            if (this.fridayHours <= 24) {
                const eventT = new ShowToastEvent({
                    title: 'Error',
                    message: this.TimeEntryIncrements,
                    variant: 'error',
                });
                this.dispatchEvent(eventT);
            }
        }
    }
    handleSaturdayChange(event) {
        event.target.value = event.target.value.replace(/[^\d.]/g, "")
        this.saturdayHours = event.target.value ? event.target.value : '0'
        //Validation Code
        if (this.validateEnteredHours(this.saturdayHours)) {
            event.target.setCustomValidity('')
            event.target.reportValidity()
            this.showError = false;
            this.errorMessage = '';
            const rowId = event.target.dataset.id;
            let date = event.target.dataset.day;
            // UI Data setup
            let mainTimesheetsIndex = this.mainTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (mainTimesheetsIndex != -1) {
                let mainTimesheetsRecord = this.mainTimesheetMappedData[mainTimesheetsIndex]
                mainTimesheetsRecord.Sav_FSL_Saturday__c = this.saturdayHours
            }
            let othersTimesheetsIndex = this.otherTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (othersTimesheetsIndex != -1) {
                let otherTimesheetsRecord = this.otherTimesheetMappedData[othersTimesheetsIndex]
                otherTimesheetsRecord.Sav_FSL_Saturday__c = this.saturdayHours
            }
            // Time Sheet Data
            let timesheetsIndex = this.timesheets.findIndex(item => item.Id === rowId)
            if (timesheetsIndex != -1) {
                let timesheetRecord = this.timesheets[timesheetsIndex]
                timesheetRecord.Sav_FSL_Saturday__c = this.saturdayHours
            }
            //
            //Time Sheet Data entry
            const timesheetEntry = this.timeSheetEntries.find(p => p.TimeSheetId === rowId && p.StartTime === this.daydateMap.get(date));
            if (timesheetEntry) {
                timesheetEntry.Sav_Duration__c = this.saturdayHours;
            }
            if (!timesheetEntry) {
                this.timeSheetEntries.push({
                    TimeSheetId: rowId,
                    StartTime: this.daydateMap.get(date),
                    Sav_Duration__c: this.saturdayHours
                });
            }
            this.saturdayTotal = 0;
            this.timesheets.forEach(item => {
                if (item.Sav_FSL_Saturday__c != '') {
                    this.saturdayTotal += parseFloat(parseFloat(item.Sav_FSL_Saturday__c).toFixed(2))
                } else {
                    this.saturdayTotal += 0
                }
            })
        } else {
            this.showError = true;
            //   this.errorMessage = ('Invalid Time Increments')
            event.target.setCustomValidity('Invalid Input')
            event.target.reportValidity()
            if (this.saturdayHours <= 24) {
                const eventT = new ShowToastEvent({
                    title: 'Error',
                    message: this.TimeEntryIncrements,
                    variant: 'error',
                });
                this.dispatchEvent(eventT);
            }
        }

    }
    handleSundayChange(event) {
        event.target.value = event.target.value.replace(/[^\d.]/g, "")
        this.sundayHours = event.target.value ? event.target.value : '0'
        //Validation Code
        if (this.validateEnteredHours(this.sundayHours)) {
            event.target.setCustomValidity('')
            event.target.reportValidity()
            this.showError = false;
            this.errorMessage = '';
            const rowId = event.target.dataset.id;
            let date = event.target.dataset.day;
            // UI Data setup
            let mainTimesheetsIndex = this.mainTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (mainTimesheetsIndex != -1) {
                let mainTimesheetsRecord = this.mainTimesheetMappedData[mainTimesheetsIndex]
                mainTimesheetsRecord.Sav_FSL_Sunday__c = this.sundayHours
            }
            let othersTimesheetsIndex = this.otherTimesheetMappedData.findIndex(item => item.Id === rowId)
            if (othersTimesheetsIndex != -1) {
                let otherTimesheetsRecord = this.otherTimesheetMappedData[othersTimesheetsIndex]
                otherTimesheetsRecord.Sav_FSL_Sunday__c = this.sundayHours
            }
            // Time Sheet Data
            let timesheetsIndex = this.timesheets.findIndex(item => item.Id === rowId)
            if (timesheetsIndex != -1) {
                let timesheetRecord = this.timesheets[timesheetsIndex]
                timesheetRecord.Sav_FSL_Sunday__c = this.sundayHours
            }
            //Time Sheet Data entry
            const timesheetEntry = this.timeSheetEntries.find(p => p.TimeSheetId === rowId && p.StartTime === this.daydateMap.get(date));
            if (timesheetEntry) {
                timesheetEntry.Sav_Duration__c = this.sundayHours;
            }
            if (!timesheetEntry) {
                this.timeSheetEntries.push({
                    TimeSheetId: rowId,
                    StartTime: this.daydateMap.get(date),
                    Sav_Duration__c: this.sundayHours
                });
            }
            this.sundayTotal = 0;
            this.timesheets.forEach(item => {
                if (item.Sav_FSL_Sunday__c != '') {
                    this.sundayTotal += parseFloat(parseFloat(item.Sav_FSL_Sunday__c).toFixed(2))
                } else {
                    this.sundayTotal += 0
                }
            })
        } else {
            this.showError = true;
            // this.errorMessage = ('Invalid Time Increments')
            // event.target.setCustomValidity('Invalid Input')
            event.target.reportValidity()
            if (this.sundayHours <= 24) {
                const eventT = new ShowToastEvent({
                    title: 'Error',
                    message: this.TimeEntryIncrements,
                    variant: 'error',
                });
                this.dispatchEvent(eventT);
            }
        }

    }
    validateEnteredHours(hours) {
        let flag = false
        if (hours.indexOf('.') != -1) {
            let hoursArr = hours.toString().split('.')
            let integerPart = hoursArr[0]
            let decimalPart = hoursArr[1]
            if (parseInt(integerPart) >= 0 && parseInt(integerPart) <= 23) {
                flag = true
            }
            else {
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: this.MaxHoursAllowed,
                    variant: 'error',
                });
                this.dispatchEvent(event);

            }
            if (decimalPart.length != 0 && decimalPart != '0' && decimalPart != '00' && decimalPart != '5' && decimalPart != '25' && decimalPart != '50' && decimalPart != '75') {
                flag = false
            }
        } else {
            if (hours && parseInt(hours) >= 0 && parseInt(hours) <= 24) {
                flag = true
            }
            else {
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: this.MaxHoursAllowed,
                    variant: 'error',
                });
                this.dispatchEvent(event);

            }
        }
        return flag
    }
    //Save Button
    errorMessageCombo = '';

    handleOthersTSCreate() {
        this.isLoading = true
        this.getwireTimeSheetOthers();
        setTimeout(() => {
            this.isLoading = false
        }, 200);
    }

    isModalOpen = false;

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

    //Prabhakar
    isModalOpenSubmit = false;
    closeModalSubmit() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpenSubmit = false;
    }

    //
    buttonName = '';

    submitDetails() {
        this.isModalOpen = false;
        this.isModalOpenSubmit = false;
        saveTimesheets({
            timesheets: this.timesheets,
            statusValue: this.buttonName
        })
            .then(result => {
                // Handle success
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: this.buttonName == 'save' ? this.SaveTimeEntries : this.SubmitSuccessMessage,
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                // Handle error
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error saving timesheets: ' + error.body.message,
                        variant: 'error'
                    })
                );
            });
        //TSE
        saveTimesheetEntries({
            TimeSheetEntries: this.timeSheetEntries
        })
            .then(result => {
                // Handle success
                this.timesheetsUpdateList = [];
                this.timeSheetEntries = [];

            })
            .catch(error => {
                // Handle error
                this.buttonName = '';

            });
        /* this[NavigationMixin.Navigate]({
             type: 'standard__app',
             attributes: {
                 //appTarget: '_blank',
                 appPageReference: {
                     type: 'standard__navItemPage',
                     attributes: {
                         apiName: 'Savvas_Time_sheet_App'
                     }
                 }
             }
         });*/
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }
    handleSaveMethod(statusValueFrom) {
        saveTimesheets({
            timesheets: this.timesheets,
            statusValue: statusValueFrom
        })
            .then(result => {
                // Handle success
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: this.buttonName == 'save' ? this.SaveTimeEntries : this.SubmitSuccessMessage,
                        variant: 'success'
                    })
                );

            })
            .catch(error => {
                // Handle error
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error saving timesheets: ' + error.body.message,
                        variant: 'error'
                    })
                );
            });
        //TSE
        saveTimesheetEntries({
            TimeSheetEntries: this.timeSheetEntries
        })
            .then(result => {
                // Handle success
                this.timesheetsUpdateList = [];
                this.timeSheetEntries = [];
            })
            .catch(error => {
                // Handle error
            });
    }
    saveBtnHandler(event) {
        this.buttonName = event.target.name;
        let mainTimesheetValuesArr = [];
        let othersTimesheetValuesArr = [];
        this.timesheets.forEach(item => {
            if (item.Sav_FSL_Section__c == 'SA') {
                if ((item.Sav_FSL_Monday__c == '0' && item.Sav_FSL_Tuesday__c == '0' && item.Sav_FSL_Wednesday__c == '0'
                    && item.Sav_FSL_Thursday__c == '0' && item.Sav_FSL_Friday__c == '0')) {
                    mainTimesheetValuesArr.push(0);
                } else {
                    mainTimesheetValuesArr.push(1);
                }

            }
            if (item.Sav_FSL_Section__c == 'Others') {
                if ((item.Sav_FSL_Monday__c == '0' && item.Sav_FSL_Tuesday__c == '0' && item.Sav_FSL_Wednesday__c == '0'
                    && item.Sav_FSL_Thursday__c == '0' && item.Sav_FSL_Friday__c == '0' && item.Sav_FSL_Saturday__c == '0' && item.Sav_FSL_Sunday__c)) {
                    othersTimesheetValuesArr.push(0);
                } else {
                    othersTimesheetValuesArr.push(1);
                }

            }

        });
        //Nothing - Nothing
        if (mainTimesheetValuesArr.indexOf(1) == -1 && othersTimesheetValuesArr.indexOf(1) == -1) {
            const event = new ShowToastEvent({
                title: 'Error',
                message: this.NoServiceTimeEntries,
                variant: 'error',
            });
            this.dispatchEvent(event);
        }
        //Something - Nothing
        if (mainTimesheetValuesArr.indexOf(1) != -1 && othersTimesheetValuesArr.indexOf(1) == -1) {
            if (this.buttonName == 'save') {
                this.handleSaveMethod(this.buttonName);
            }
            else {
                this.isModalOpenSubmit = true;
            }

        }
        //Nothing - Something
        if (mainTimesheetValuesArr.indexOf(1) == -1 && othersTimesheetValuesArr.indexOf(1) != -1) {
            this.isModalOpen = true;
        }
        //Something - Something
        if (mainTimesheetValuesArr.indexOf(1) != -1 && othersTimesheetValuesArr.indexOf(1) != -1) {

            if (this.buttonName == 'save') {

                this.handleSaveMethod(this.buttonName);
            }
            else {
                this.isModalOpenSubmit = true;
            }

        }

    }


}