import { LightningElement, api, wire } from 'lwc';
import getContent from '@salesforce/apex/SavvasVirtualSamplesSideBannerCtrl.getContent';
import fetchCssFileFromAttachment from '@salesforce/apex/SavvasVirtualSamplesSideBannerCtrl.fetchCssFileFromAttachment';
import { loadStyle } from 'lightning/platformResourceLoader';
import { NavigationMixin } from 'lightning/navigation';
import contactURL from '@salesforce/label/c.Savvas_Virtual_Samples_Side_banner_contact_URL';
import realizeCSS from '@salesforce/label/c.Savvas_Virtual_Samples_Side_Banner_Realize_CSS';

export default class savvasSideBanner extends NavigationMixin(LightningElement) {

    @api contentId;
    @api programBanner;
    label = {
        contactURL,
        realizeCSS
    };
    detailsCMS = {
        needFurther: '',
        help: '',
        topImage: '',
        logo: '',
        laptop: '',
        curriculum: '',
        gain: '',
        savvasRealize: '',
    };
    body;
    error;
    sideBannerCSS;
    isLoading = false;

    //execute css files from the attachments
    @wire(fetchCssFileFromAttachment, { title: realizeCSS })
    wiredCssData({ data, error }) {
        if (data) {
            this.isLoading = true;
            this.sideBannerCSS = data;
        }
        else if (error) {
            console.error(error)
        }
    }
    //get the Side Banner CMS Content on component load
    connectedCallback() {
        try {
            let wrapperMap = {
                contentId: 'Savvas Virtual CMS Side Banner',
                page: 0,
                pageSize: 15,
                language: 'en_US',
                filterby: 'savvas_Virtual_CMS_Side_Banner'

            }
            getContent({
                contentDetails: wrapperMap
            })
                .then(result => {
                    if (result) {
                        this.detailsCMS = {
                            needFurther: result.NeedFurther.value,
                            help: result.Help.value,
                            topImage: result.TopImage.url,
                            logo: result.Logo.url,
                            laptop: result.Laptop.url,
                            curriculum: result.Curriculum.value,
                            gain: result.Gain.value,
                            savvasRealize: htmlDecode(result.SavvasRealize.value)
                        }
                    }
                })
                .catch(error => {
                    console.error(error)
                })
        }
        catch (error) {
            console.error(error)
        }
    }
    //used to load css
    renderedCallback() {
        Promise.all([
            loadStyle(this, this.sideBannerCSS)
        ]).then(() => {

        }).catch(error => {
            console.error(error)

        })
    }
    // Loads the contact URL
    navigateToSalesRepURL() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.label.contactURL
            }
        });
    }

}
//used to decode html and make it understandable for lightning-formatter-rich-text
function htmlDecode(input) {
    var doc = new DOMParser().parseFromString(input, 'text/html');
    let parsedstring = doc.documentElement.textContent;
    return parsedstring;
}