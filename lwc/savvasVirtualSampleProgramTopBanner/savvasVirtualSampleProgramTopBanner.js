import { LightningElement, api, wire } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import savvaasstyle from '@salesforce/resourceUrl/SavvasVirtualSampleImages';
import fetchCssFileFromAttachment from '@salesforce/apex/SavvasVirtualSamplesProgramBannerCtrl.fetchCssFileFromAttachment';
import programTopCSS from '@salesforce/label/c.Savvas_Virtual_Sample_Program_Banner_CSS';

export default class SavvasVirtualSampleProgramTopBanner extends LightningElement {
    @api programBannerData;
    label = { programTopCSS };
    playbtn = savvaasstyle + '/Images/play_button.png';
    isLoading = false;
    programCSS;
    programData;
    programDescription;

    @wire(fetchCssFileFromAttachment, { title: programTopCSS })
    wiredCssData({ data, error }) {
        if (data) {
            this.isLoading = true;
            this.programCSS = data;
        }
        else if (error) {
            console.error(error)
        }
    }

    //executed on load of page. fetchCssFileFromAttachment is used to fetch css file
    connectedCallback() {
        try {
            this.programData = this.programBannerData[0];
            this.programDescription = htmlDecode(this.programData.programDescription)
        }
        catch (Ex) {
            console.error(Ex)
        }
    }

    //used to load css
    renderedCallback() {
        Promise.all([
            loadStyle(this, this.programCSS)
        ]).then(() => {
        }).catch(error => {
            console.error(error)
        })
    }
}
//method to parse from string to html
function htmlDecode(input) {
    var doc = new DOMParser().parseFromString(input, 'text/html');
    let parsedstring = doc.documentElement.textContent;
    return parsedstring;
}