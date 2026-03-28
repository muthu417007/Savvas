import { LightningElement, track } from 'lwc';
import getUserInformation from '@salesforce/apex/scc_Internal_UserInfoController.getUserInformation';
import fetchCustomAlertMessage from '@salesforce/apex/scc_fetchCustomAlertMessage.fetchAlertMessage';
export default class Scc_AlertMsg extends LightningElement {

    @track userInfo = {};
    @track error;
    @track IsAdmin = false;
    @track showPopup = false;
    data;
    alertHeading;
    alertContent;

    connectedCallback() {
        this.fetchUserInformation();
    }
    fetchUserInformation() {
        getUserInformation()
            .then((result) => {                
                this.userInfo = JSON.parse(result);
                if (this.userInfo.isAdmin === true) {
                    this.showPopup = false;
                }
                else {                  
                    fetchCustomAlertMessage().then(response => {
                        this.data =response;
                        this.alertContent=response.Alert_Content__c;
                        this.alertHeading=response.Alert_Heading__c;
                        this.showPopup = true;                       
                    }).catch(error => {
                     console.log('fetchCustomAlertMessage error is ', error);
                    })
                 
                }              
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.userInfo = undefined;
            });
    }

    closePopup() {
        this.showPopup = false;
    }

}