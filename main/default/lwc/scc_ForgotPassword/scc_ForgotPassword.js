/********************************************************************************************* 
* @Component Name  - Scc_ForgotPassword
* @description - This component is used to reset the password
* @Created By  - CTS - Swagata Dasgupta
* @Created On - 09/13/2024 
* ********************************************************************************************/
import { LightningElement, track } from 'lwc';
import sccForgotPassword from '@salesforce/apex/scc_forgotPassword_controller.sccForgotPassword';
import scc_signIn_Footer_Text from '@salesforce/label/c.scc_signIn_Footer_Text';
import scc_signIn_Footer_Savvas_Support from '@salesforce/label/c.scc_signIn_Footer_Savvas_Support';
import scc_signIn_Footer_Terms_Text from '@salesforce/label/c.scc_signIn_Footer_Terms_Text';
import scc_signIn_Footer_Privacy_Text from '@salesforce/label/c.scc_signIn_Footer_Privacy_Text';
import scc_savvas_application_list from '@salesforce/label/c.scc_savvas_application_list';
import scc_my_savvas_orders_login_url from '@salesforce/label/c.scc_my_savvas_orders_login_url';
import scc_my_savvas_orders_checkPassword_url from '@salesforce/label/c.scc_my_savvas_orders_checkPassword_url';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class Scc_ForgotPassword extends LightningElement {
    @track emailValue='';
    @track isShowToolTip = false;
    @track invalid_message = false;
    @track enableLogs = false;

    labels={
        scc_signIn_Footer_Text,
        scc_signIn_Footer_Savvas_Support,
        scc_signIn_Footer_Terms_Text,
        scc_signIn_Footer_Privacy_Text,
        scc_savvas_application_list,
        scc_my_savvas_orders_login_url,
        scc_my_savvas_orders_checkPassword_url
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
    }

    handleInput(event){
        this.emailValue = event.target.value;
    }

    submitHandler(){
        sccForgotPassword({username:this.emailValue}).then(result=>{
            if(this.enableLogs){
                console.log('result is',result);
            }
            if(result){
                this.invalid_message = false;
                window.location.assign(this.labels.scc_my_savvas_orders_checkPassword_url);
            }else{
                this.invalid_message = true;
                this.template.querySelector('.email-input').focus();
            }
        })
        .catch(error=>{
            if(this.enableLogs){
                console.log('error is',error);
            }
        })
    }
    
    //is fired when user hover on hyperlink text 
    showToolTip() {
         this.isShowToolTip = true;
    }
    //is fired when user hover out hyperlink text 
    HideToolTip() {
         this.isShowToolTip = false;
    }
}