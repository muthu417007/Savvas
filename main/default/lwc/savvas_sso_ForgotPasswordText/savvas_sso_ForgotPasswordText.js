import { LightningElement } from 'lwc';
import Savvas_SSO_Applications from '@salesforce/label/c.Savvas_SSO_Applications';
export default class Savvas_SSO_ForgotPasswordText extends LightningElement {

 label = {Savvas_SSO_Applications}
     isShowToolTip = false;
    
    //is fired when user hover on hyperlink text 
    showToolTip() {
         this.isShowToolTip = true;
    }
    //is fired when user hover out hyperlink text 
    HideToolTip() {
         this.isShowToolTip = false;
    }
}