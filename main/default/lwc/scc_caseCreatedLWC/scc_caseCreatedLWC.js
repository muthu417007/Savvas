import { LightningElement, track , api} from 'lwc';

import scc_caseCreatedMessageLabel from "@salesforce/label/c.scc_caseCreatedMessageLabel";

//Import apex classes
import getCaseNumber from '@salesforce/apex/scc_EnosixOrderSubmissionErrors.getCaseNumber' ;
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class Scc_caseCreatedLWC extends LightningElement {
    
    labels = {
        scc_caseCreatedMessageLabel
    }

    @track caseNumber;
    @api recordId;
    @track isLoading = true;
    @track enableLogs = false;

    constructor() {
        super();
        
        // fetch custom label - enable log to enable logs in this script
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if(this.enableLogs){
                console.log('getEnableConsoleLogsTrue response is',response);
            }
        }).catch(error => {
            if(this.enableLogs){
                console.log('error is', error);
            }
        })
    }

    connectedCallback(){        
        this.isLoading = true; 
        // fetch custom number
        getCaseNumber({ recordId: this.recordId }).then(response => {
            if(this.enableLogs){
                console.log('response>>>>',response);  
            }          
            
            setTimeout(() => {
                this.caseNumber = response;
                this.isLoading = false; 
            }, 2000); 
            if(this.enableLogs){
                console.log('caseNumber>>>>',this.caseNumber);
            }
        }).catch(error => {
            if(this.enableLogs){
            console.log('error is', error);
            }
        })
    }
}