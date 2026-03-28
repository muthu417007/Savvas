import { LightningElement } from 'lwc';
import programicons from '@salesforce/resourceUrl/SavvasVirtualSampleImages';
import expiryLabel from '@salesforce/label/c.Expired_Info';
import getProgramDetails from '@salesforce/apex/SavvasVirtualSamplingCommunityController.getProgramDetails';
export default class SavvasVirtualSampleAllPrograms extends LightningElement {
    isLoading = false;
    showPermissionError = false;
    label = { expiryLabel };
    programImages = {
        programDoc: programicons + '/Images/program_doc.jpg',
        programCalender: programicons + '/Images/program_cal.jpg',
        programFailedFile: programicons + '/Images/program_doc_expired.jpg',
        programFailedCal: programicons + '/Images/program_cal_expired.jpg'
    }
    contentAccessData = [];
    programBannerData = [];
    assetDetails = [];
    programBanner = [];
    gradeDetails=[];
    showContent;
    contentId;
    isVirtualSample;
    programName;
    assetData;
    gradeData;

    //gets called on load of page
    async connectedCallback() {
       await Promise.all(this.getProgramDetails());
    }
        
    getProgramDetails(){
        try {
            getProgramDetails({})
                .then(result => {
                    this.contentAccessData = result.programList;
                    this.assetData = result.assetDetails;
                    this.gradeData = result.gradeDetails;
                    for (let key in result.programBannerData) {
                        if (result.programBannerData.hasOwnProperty(key)) {
                            this.programBannerData.push({ key: key, value: result.programBannerData[key] });
                        }
                    }
                    this.isLoading = true;
                })
                .catch(error => {
                    this.isLoading = true
                    console.error(error);
                })
        }
        catch (error) {
            console.error(error);
        }
    }

    //This event is fired when user clicks on any of the programs. Based on the program name master data is filtered and passed to child components
    openProgramData(event) {
        try {
            this.programBannerData.forEach(element => {
                if (element.key == event.target.dataset.item) {
                    this.programBanner.push(element.value);
                }
            })
            this.contentAccessData.forEach(element => {
                if (element.name == event.target.dataset.item) {
                    this.isVirtualSample = element.isVirtualSample;
                }
            });
            for (let key in this.assetData) {
                if (this.assetData.hasOwnProperty(key)) {
                    if (key == event.target.dataset.item) {
                        this.assetDetails.push(this.assetData[key]);
                    }
                }
            }
            for(let val in this.gradeData){
                if(this.gradeData.hasOwnProperty(val)){
                    if(val == event.target.dataset.item){
                        this.gradeDetails.push(this.gradeData[val])
                    }
                }
            }
            this.contentId = event.target.dataset.item;
            this.showContent = true;
            this.programName = event.target.dataset.item;
        }
        catch (ex) {
            console.error(error);
        }
    }
}