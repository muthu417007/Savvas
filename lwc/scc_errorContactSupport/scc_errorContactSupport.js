/********************************************************************************************* 
* @Component Name  - Scc_errorContactSupport
* @description - This component is used to display the error message in case of order submission error
* @Created By  - CTS - Dhiyaneswari K
* @Created On - 07/16/2024 
* ********************************************************************************************/
import { LightningElement, api, track } from 'lwc';
import scc_ContactSupport from "@salesforce/label/c.scc_ContactSupport";
import scc_Order_Submission_Error from "@salesforce/label/c.scc_Order_Submission_Error";
import getUserDetails from "@salesforce/apex/scc_EnosixOrderSubmissionErrors.getUserDetails";
import createCase from '@salesforce/apex/scc_EnosixOrderSubmissionErrors.createCase';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class Scc_errorContactSupport extends LightningElement {
    @api cartid;
    @track input='';
    userName;
    userEmail;
    isSubmitDisabled = true;
    typeLabel = scc_Order_Submission_Error;
    @track enableLogs = false;

    labels = {
        scc_ContactSupport,
        scc_Order_Submission_Error
    }
   
    connectedCallback(){
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

        getUserDetails({cartId: this.cartid}).then(response => { 
            if(this.enableLogs){
                console.log('user details are',response);
            }
            if(response){     
                this.userName = response.Name;    
                this.userEmail = response.Email;
            }
        }).catch(error => {
            if(this.enableLogs){
                console.log('error is', error);
            }
        })
    }

    get isSubmitDisabled1(){
        if(this.input != ''){
            this.isSubmitDisabled = false;
        }else{
            this.isSubmitDisabled = true;
        }
        return this.isSubmitDisabled;
    }

    handleSubmit(){
        createCase({cartId: this.cartid,description:this.input,name:this.userName,email:this.userEmail,type:this.typeLabel}).then(response => { 
            if(this.enableLogs){
                console.log('create case response is',response);
            }
            if(response != ''){  
                const caseDetails={
                    caseNumber:response,
                    email:this.userEmail,
                };   
                const submitEvent = new CustomEvent('submit', {
                    detail: caseDetails
                });
                this.dispatchEvent(submitEvent); 
            }
        }).catch(error => {
            if(this.enableLogs){
                console.log('error is', error);
            }
        })        
    }

    handleInputChange(event) {
        this.input = event.target.value;
    }
}