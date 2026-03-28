import { LightningElement, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import savvaasstyle from '@salesforce/resourceUrl/SavvasVirtualSampleImages';
export default class SavvasVirtualSampleProgramContainer extends LightningElement {
    @api programBannerData;
    @api assetDetails;
    @api assetUrlTracking;
    @api assetNameTracking;
    @api gradeDetails;
    programRightBanner;
    showProgramRightBanner;

    //method is executed on load
    connectedCallback() {
        try {
            this.programBannerData = JSON.parse(JSON.stringify(this.programBannerData));
            this.assetDetails = JSON.parse(JSON.stringify(this.assetDetails));
            this.gradeDetails = JSON.parse(JSON.stringify(this.gradeDetails));
            this.programRightBanner = this.programBannerData[0].programRightBanner;
            this.showProgramRightBanner = (this.programRightBanner === "None") ? false :true;
        }
        catch (Ex) {
        console.error(Ex)  
        }
    }

    //method is used to load css
    renderedCallback() {
        try {
            Promise.all([
                loadStyle(this, savvaasstyle + '/css/style.css')
            ]).then(() => {
            })
                .catch(error => {
                  console.error(error)
                });
        }
        catch (Ex) {
         console.error(Ex)   
        }
    }
}