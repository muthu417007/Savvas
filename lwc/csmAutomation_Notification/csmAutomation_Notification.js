import { LightningElement,wire } from 'lwc';
import getCustomNotificationData from '@salesforce/apex/CSMAutomation_NotificationController.getCustomNotificationData';

export default class CSMAutomation_Notification extends LightningElement {
    columns = [
        { label: 'Notification Name', fieldName: 'Name__c' },
        { label: 'Type', fieldName: 'Notification_Type__c' },
        { label: 'Subscribe', fieldName: 'Subscribe', type: 'boolean' }
    ];

    data = [];
    error;

    @wire(getCustomNotificationData)
    wiredCustomNotificationData({ data, error }) {
        if (data) {
            this.data = data;
            console.log('data=>'+data);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = [];
        }
    }
}