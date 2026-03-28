import { LightningElement,track,api,wire } from 'lwc';
import { getContent } from 'experience/cmsDeliveryApi';
import siteId from '@salesforce/site/Id';
export default class Input1 extends LightningElement {
    @track selectedDate;
    @track formattedDate;

        @api
    contentKey;

    data;

    @wire(getContent, {channelOrSiteId: siteId, contentKeyOrId: '$contentKey'})
    onGetContent({ error, data }) {
        if (data) {
            this.data = data;
            console.log('cms content is ',  this.data,data);
        }  else if (error) {
        this.error = error;
            console.log('cms content is error',  error);
    }
    }

    handleDateChange(event) {
        this.selectedDate = event.target.value;
        this.formattedDate = this.formatDate(this.selectedDate);
    }

    formatDate(date) {
        if (!date) return '';
        const d = new Date(date);
        const month = (d.getMonth() + 1).toString().padStart(2, '0');
        const day = d.getDate().toString().padStart(2, '0');
        const year = d.getFullYear();
        return `${month}/${day}/${year}`;
    }
     convertToInt(value){
        return parseInt(value,10);
    }
    connectedCallback() {
        let a=10.50;
        let b= 20.00;
        let c= "123abc";
        let d="abc123"
        console.log(a,b,c,d);
        let e=this.convertToInt(a);
        let f=this.convertToInt(b);
        let g=this.convertToInt(c);
        let h=this.convertToInt(d);
        console.log(e,f,g,h);
    }


}