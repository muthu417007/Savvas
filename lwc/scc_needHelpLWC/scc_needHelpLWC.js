/*********************************************************
  Component Name       : scc_needHelpLWC
  Created Date         : 06/09/2024  
  Author               : Cognizant
  Description          : This component used in Home page to render the other apps links for login user.
  
  Modifications Log
  06/09/2024      Monami             Initial Version
*********************************************************/
import { LightningElement, track } from 'lwc';
import scc_contactCustomerSupport from "@salesforce/label/c.scc_contactCustomerSupport";
import scc_needHelpKMArticle from "@salesforce/label/c.scc_needHelpKMArticle";
import { loadStyle } from 'lightning/platformResourceLoader';
import headmarkupstyle_static from '@salesforce/resourceUrl/headmarkupstyle_static';
import getUserType from '@salesforce/apex/scc_accessCodeController.getUserType';
import scc_needHelpContactEmail from '@salesforce/label/c.scc_needHelpContactEmail';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
import { NavigationMixin } from 'lightning/navigation';

export default class Scc_needHelpLWC extends NavigationMixin(LightningElement) {
    @track scc_contactCustomerSupportURL = scc_contactCustomerSupport;
    @track scc_needHelpKMArticle = scc_needHelpKMArticle;
    @track showNeedhelp = false;
    @track showFAQ = false;
    @track showEntireComponent = false;
    @track isInternalUser = false;
    @track showSiteTraining = false;
    @track enableLogs = false;
    labels = {
        scc_needHelpContactEmail
    }
    connectedCallback() {
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
        this.checkUserType();
    }

    checkUserType() {
        getUserType()
            .then(result => {
                let parsedResult = JSON.parse(result);
                this.isInternalUser = parsedResult.isInternal;
                this.accountId = parsedResult.accountId;
                this.updateDisplay();
            })
            .catch(error => {
                if (this.enableLogs) console.error('Error fetching user type:', error);
            });
    }

    updateDisplay() {
        if (!this.isInternalUser) {
            this.showEntireComponent = false;
            this.showFAQ = true;
            this.showNeedhelp = false;
        } else {
            this.showEntireComponent = true;
        }
    }

    renderedCallback() {
        loadStyle(this, headmarkupstyle_static)
            .then(() => {
            })
            .catch(error => {
            });
        if (this.showFAQ) {
            this.setupQuestionRefs();
        }
    }

    handleFAQ() {
        this.showFAQ = true;
        this.showEntireComponent = false;
    }

    handleSiteTraining() {
        this.showSiteTraining = true;
        this.showFAQ = false;
        this.showEntireComponent = false;
    }

    setupQuestionRefs() {
        this.template.querySelectorAll('[id^="question"]').forEach(el => {
            el.dataset.ref = el.id;
        });
    }

    scrollToQuestion(event) {
    event.preventDefault();
    const questionId = event.target.getAttribute('href').substring(1);
    const element = this.template.querySelector(`[data-ref="${questionId}"]`);
    if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
    }

    handleNavigate() {       
        this.showCreateCase = true;
        this.showEntireComponent = false;
    }
}