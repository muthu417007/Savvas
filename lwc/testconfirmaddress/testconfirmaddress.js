import { LightningElement, track, wire } from 'lwc';
// import getshow from '@salesforce/apex/testconfirmaddress.check';
export default class GrandBirthdayWish extends LightningElement {
    @track webcartName='';
    @track check= false;
    @track errorMessage='';
    handleCartNameChange(event){
       this.webcartName=event.target.value;
       const regex=/salesforce test/i;
       console.log(regex.test(this.webcartName));
       this.errorMessage=this.webcartName;
    }
   

}