/*
LWC Component:scc_fedExTrackInfo
Author: CTS (Varshaa M)
Created Date: 
Reason: JS logic scc_fedExTrackInfo component.
Modified Date: 
*/
import { LightningElement, track, api } from 'lwc';
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import getTrackingDetails from '@salesforce/apex/scc_fedExTrackingService.getTrackingDetails';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class Scc_fedExTrackInfo extends LightningElement {
    @track fedExTrack = true;
    @track status = '';
    @track delivery_Detail = '';
    @track shipDate = '';
    @track actualDate = '';
    @track expectedDelivery = '';
    @track weight = '';
    @track weightUnit1 = '';
    @track weightUnit2 = '';
    @track dimensions = '';
    @track totalPieces = '';
    @track packaging = '';
    @track trackingDetails;
    @track trackingId = '';
    @track dateString = "2023-05-24T18:47:00-04:00";
    @track dayString = '';
    @track receivedBy = '';
    @api tracking;
    @api order;
    @track orderNumber;
    @track packagingUpperCase;
    @track eventsTrack = [];
    @track actualDeliveryDate = '';
    @track shipDate = '';
    @track shipmentDate = '';
    @track weightUnitValue1='';
    @track weightUnitValue2='';
    @track index=true;
    @track enableLogs = false;
    @track deliveryDetails = false;
    
    //approved icon
    approveIconUrl = imageIcons + '/Images/approved.png';

    connectedCallback() {
        this.isLoading1 = true;
        this.trackingId = this.tracking;
        this.getDetails();
        setTimeout(() => {
            this.isLoading1 = false;           
        }, 2000);

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
    }

    getDetails() {
        getTrackingDetails({ scc_Trackingid: this.trackingId }).then(response => {
            this.trackingDetails = JSON.parse(response);
            if(this.enableLogs){
                console.log('getTrackingDetails response is',response);
            }
            if (this.trackingDetails) {
                let results = this.trackingDetails.output.completeTrackResults[0].trackResults[0];
                this.trackingId = results.trackingNumberInfo.trackingNumber;//tracking number
                this.status = results.latestStatusDetail.description;// status
                this.weightUnit1 = results.packageDetails.weightAndDimensions.weight[0].unit;
                this.weightUnit2 = results.packageDetails.weightAndDimensions.weight[1].unit;
                this.weightUnitValue1 =results.packageDetails.weightAndDimensions.weight[0].value;
                this.weightUnitValue2 =results.packageDetails.weightAndDimensions.weight[1].value;
                this.weight = results.packageDetails.weightAndDimensions.weight[0].value + ' ' + this.weightUnit1.toLowerCase()+'s'+' / '+ results.packageDetails.weightAndDimensions.weight[1].value + ' ' + this.weightUnit2.toLowerCase()+'s';
                this.dimensions = results.packageDetails.weightAndDimensions.dimensions[0].length + 'x' + results.packageDetails.weightAndDimensions.dimensions[0].width + 'x' + results.packageDetails.weightAndDimensions.dimensions[0].height + ' ' + results.packageDetails.weightAndDimensions.dimensions[0].units.toLowerCase();
                this.totalPieces = results.packageDetails.count;
                this.packaging = results.packageDetails.packagingDescription.type.replace(/_/g, ' ');
                this.packaging=this.packaging.toLocaleLowerCase();
                this.packagingUpperCase = this.packaging.replace(/\b\w/g, char => char.toUpperCase());
                if(this.status =='Delivered')
                {
                    this.actualDate='N/A';
                }
                else{
                   this.actualDeliveryDate = results.dateAndTimes.find(dateTime => dateTime.type == 'ACTUAL_DELIVERY') ? results.dateAndTimes.find(dateTime => dateTime.type == 'ACTUAL_DELIVERY').dateTime:'';
                   if(this.actualDeliveryDate){
                        this.actualDate = new Intl.DateTimeFormat('en-US', {
                            year: 'numeric',
                            month: '2-digit',
                            day: '2-digit'
                        }).format(new Date(this.actualDeliveryDate));
                   }
                }

                this.shipDate = results.dateAndTimes.find(dateTime => dateTime.type == 'SHIP') ? results.dateAndTimes.find(dateTime => dateTime.type == 'SHIP').dateTime :'';
                if(this.shipDate){
                    this.shipmentDate = new Intl.DateTimeFormat('en-US', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit'
                    }).format(new Date(this.shipDate)); 
                }

                this.receivedBy = results.deliveryDetails.receivedByName;
                this.eventsTrack = this.groupEventsByDate(results.scanEvents);
                const delivery_det=results.scanEvents.find(dateTime => dateTime.eventDescription == 'Delivered');
                if(delivery_det){
                    this.deliveryDetails = true;
                    this.delivery_Detail=this.deliveryEvent(delivery_det);
                }
            }
        })
        .catch(error => { 
            if(this.enableLogs){
                console.log('error is',error); 
            }
        })
    }

    groupEventsByDate(eventsVal) {
        const groupedEvents = {};
        const groupedEvents2 = {};
        eventsVal.forEach(event => {
            const eventDate=event.date;
            //const dateKeyWTimeZone= eventDate.split('-')[0]+ 'T' +eventDate.split('T')[1].split('-')[0];
            const dateKeyWTimeZone= eventDate.split('-')[0]+'-'+eventDate.split('-')[1]+'-'+eventDate.split('-')[2];
            const dateKey = this.formatDateBase(dateKeyWTimeZone);
            const {formattedTimeBaseH, formattedTimeBaseM} = this.formatTimeBase(dateKeyWTimeZone);
            if (!groupedEvents[dateKey]) {
                groupedEvents[dateKey] = [];
            }
            const formattedDate = this.formatDate(dateKeyWTimeZone)
            const formattedTime  = this.formatTime(dateKeyWTimeZone);
            groupedEvents[dateKey].push({
                date: formattedDate,
                time: formattedTime,
                description: event.eventDescription,
                location: event.scanLocation.city+', '+ event.scanLocation.countryCode,
                hr: formattedTimeBaseH,
                min:formattedTimeBaseM
            });
        });
        const groupedEventsArray = [];
        for (const date in groupedEvents) {
            groupedEvents[date]= groupedEvents[date].sort((a,b)=> a.hr - b.hr);
            groupedEvents[date] = groupedEvents[date].sort((a, b) => 
            { 
                // Create a combined time value, for example, "hhmm"
                 let timeA = parseInt(`${a.hr.toString().padStart(2, '0')}${a.min.toString().padStart(2, '0')}`, 10); 
                 let timeB = parseInt(`${b.hr.toString().padStart(2, '0')}${b.min.toString().padStart(2, '0')}`, 10); 
                 return timeA - timeB;
             });
            groupedEvents[date].forEach(event=>{
                delete event.hr;
                delete event.min;
            });
            groupedEvents[date][0].isFirst= true;
            groupedEventsArray.push({ date, events: groupedEvents[date] });
        }
        return groupedEventsArray.sort((a, b) => new Date(a.date) - new Date(b.date));
    }

    handleClearClick(event) {
        this.fedExTrack = false;
    }

    formatDate(datetTime_str) {
        const dt = { weekday: 'long', month: '2-digit', day: '2-digit', year: 'numeric' };
        const dateTime = new Date(datetTime_str);
        const formattedDate = dateTime.toLocaleDateString('en-US', dt);
        return formattedDate;
    }

    formatTime(datetTime_str)
    {
        const dt = { weekday: 'long', month: '2-digit', day: '2-digit', year: 'numeric' };
        const tme = { hour: '2-digit', minute: '2-digit', hour12: true };
        const dateTime = new Date(datetTime_str);
        const formattedDate = dateTime.toLocaleDateString('en-US', dt);
        const formattedTime = dateTime.toLocaleTimeString('en-US', tme);
        return formattedTime;
    }

    formatDateBase(datetTimestring)
    {
        const dt = { month: '2-digit', day: '2-digit', year: 'numeric' };
        const dateTime = new Date(datetTimestring);
        const formattedDateBase = dateTime.toLocaleDateString('en-US', dt);
        return formattedDateBase;
    }

     formatTimeBase(datetTimestring)
    {
        const dt = { month: '2-digit', day: '2-digit', year: 'numeric' };
        const dateTime = new Date(datetTimestring);
        const formattedTimeBaseH = dateTime.getHours();
        const formattedTimeBaseM = dateTime.getMinutes();
        return { formattedTimeBaseH, formattedTimeBaseM} ;
    }

    deliveryEvent(event)
    {   
        const eventDate=event.date;
        const dateKeyWTimeZone= eventDate.split('-')[0]+ 'T' +eventDate.split('T')[1].split('-')[0];
        const formattedDate = this.formatDate(event.date)
        const formattedTime  = this.formatTime(dateKeyWTimeZone);      
        const description = event.eventDescription;
        const location = event.scanLocation.city+','+event.scanLocation.countryCode;
        return { date: formattedDate, time: formattedTime, description, location };
    }
}