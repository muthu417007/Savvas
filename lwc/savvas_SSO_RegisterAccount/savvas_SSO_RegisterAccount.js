import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import fetchRegistrationDetails from '@salesforce/apex/Savvas_SSO_LoginPageController.fetchRegistrationDetails';
import savvaasstyle from '@salesforce/resourceUrl/Savvas_SSO_Images';
export default class Savvas_SSO_RegisterAccount extends LightningElement {

    arrow_icon = savvaasstyle + '/Images/arrow_btn.svg';
    appName;
    redirectURL;
    url;
    startURL;

    //get relay state param from the login URL
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        try{
            if(currentPageReference){
                let paramString = currentPageReference.state?.startURL.split('?')[1];
                let queryString = new URLSearchParams(paramString);
                for(let pair of queryString.entries()) {
                    if(pair[0] == 'RelayState' && pair[1] != ''){
                        this.appName = pair[1];
                    }
                }            
            }
        } catch(error){
            console.error();
        }
    }

    //gets called on load of the component and fetch the URL from metadata
    connectedCallback(){
        if(this.appName){
            fetchRegistrationDetails({appName:this.appName}).then(result=>{
                if(result){
                    this.redirectURL = result;
    
                }
            }).catch(error=>{
                console.error(error);
            })
        }
    }

}