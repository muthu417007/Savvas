import { LightningElement, api, wire } from 'lwc';
import getContent from '@salesforce/apex/SavvasVirtualSamplesSideBannerCtrl.getContent';
import fetchCssFileFromAttachment from '@salesforce/apex/SavvasVirtualSamplesSideBannerCtrl.fetchCssFileFromAttachment';
import { loadStyle } from 'lightning/platformResourceLoader';
import { NavigationMixin } from 'lightning/navigation';
import contactURL from '@salesforce/label/c.Savvas_Virtual_Samples_Side_banner_contact_URL';
import defaultCSS from '@salesforce/label/c.Savvas_Virtual_Sample_Side_Banner_Default_CSS';


export default class savvasDefaultSideBanner extends NavigationMixin(LightningElement) {

    @api contentId;
    @api programBanner;
    label = {
        contactURL,
        defaultCSS
    };
    body;
    error;
    detailsCMS = {
        needFurther: '',
        help: '',
        topImage: '',
        logo: '',
        laptop: '',
        curriculum: '',
        gain: '',
        savvasRealize: ''
    };
    sideBannerCSS;
    isLoading = false;

    //execute css files from the attachments
    @wire(fetchCssFileFromAttachment, { title: defaultCSS })
    wiredCssData({ data, error }) {
        if (data) {
            this.isLoading = true;
            this.sideBannerCSS = data;
        }
        else if (error) {
            console.error(error)
        }
    }
    //executed on load of page. fetchCssFileFromAttachment is used to feth the css file
    connectedCallback() {
        try {
            let wrapperMap = {
                contentId: 'Savvas CMS Default Side Banner',
                page: 0,
                pageSize: 15,
                language: 'en_US',
                filterby: 'savvas_CMS_Default_Side_Banner'

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

    //used to navigated to savvas contact us page
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