import { LightningElement, api, wire } from 'lwc';
import getContent from '@salesforce/apex/scc_mysavvasOrderContentCtrl.getContent';
export default class Scc_fetchCMSContent extends LightningElement {
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
                       console.log('Sfcc CMS content is',result);
                    }
                })
                .catch(error => {
                    console.error(error);
                       console.log('Sfcc CMS content error is',error);
                })
        }
        catch (error) {
            console.error(error)
               console.log('Sfcc CMS content catch block error is',error);
        }
    }

}