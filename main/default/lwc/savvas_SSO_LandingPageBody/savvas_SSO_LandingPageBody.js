import { LightningElement } from 'lwc';
import getUserAppAccessData from '@salesforce/apex/Savvas_SSO_LandingPageController.getUserAppAccessData';
import { NavigationMixin } from 'lightning/navigation';
import SAVVAS_SSO_IMAGES from '@salesforce/resourceUrl/Savvas_SSO_Images';

export default class Savvas_SSO_LandingPageBody extends NavigationMixin(LightningElement) {

    arrow_icon = SAVVAS_SSO_IMAGES + '/Images/arrow_btn.svg'
    isLoading = true
    userAppAccessData;
    isShowModal = false;
    appData;
    title;
    description;
    actionVerbiage;
    acsURL;

    //gets called on load of the component and set metadata details to variable
    connectedCallback() {
        getUserAppAccessData().then(result => {
            if (result && result.length > 0) {
                this.appData = result;
                this.userAppAccessData = result.map(item => {
                    return {
                        appSequence: item.appSequence ? item.appSequence : '',
                        imageUrl: item.appIcon ? (SAVVAS_SSO_IMAGES + item.appIcon) : '',
                        appTitle: item.appTitle ? item.appTitle : '',
                        appDescription: item.appDescription ? item.appDescription.substring(0,111) : '',
                        appActionVerbiage: item.appActionVerbiage ? item.appActionVerbiage : '',
                        acsURL: item.acsURL ? item.acsURL : '',
                        isReadMore : item.appDescription.length > 111 ? true : false
                    }
                })
                console.log(this.userAppAccessData);
                this.isLoading = false;
            }
        }).catch(error => {
            console.error(error)
        })
    }
    
    //is fired when user clicks on read more button 
    showModalBox(event) {
        this.isShowModal = true;
        this.title = event.currentTarget.dataset.id;
        this.appData.forEach(item => {
            if(this.title == item.appTitle) {
                this.description = item.appDescription;
                this.actionVerbiage = item.appActionVerbiage;
                this.acsURL = item.acsURL;
            }
        });

    }

    //is fired when user clicks on close icon in modal
    hideModalBox() {
        this.isShowModal = false;
    }
}