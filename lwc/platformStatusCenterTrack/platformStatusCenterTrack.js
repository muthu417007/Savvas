import { LightningElement, api, track } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import status from '@salesforce/resourceUrl/status';


export default class PlatformStatusCenterTrack extends LightningElement { 
    
		@track repos;
		openModal = false;

    handleOpenModal() {
        this.openModal = true;
    }
    handleCloseModal() {
        this.openModal = false;
    }
		

    buttoncolor = 'green slds-p-horizontal_small';
    get buttonClassName(){
        return this.buttoncolor;
    }
	OpenStatusPage(){
				window.open('https://status.savvas.com/');
		}
    connectedCallback (){
        let endPoint = "https://api.statuspage.io/v1/pages/k2m6ww736hqz/components?api_key=39dcde1b-8535-4d31-b93b-c774fcfe40a4";
        let oper = 0;
				
				fetch(endPoint, {
            method: "GET"
        })
        .then((response) => response.json()) 
        /* response.json() gives us back a promise
        we need to process the promise in .then()*/
        .then((repos) => {
            this.repos = repos;
						for(var repo in repos){
							console.log('debug' + repo);
								console.log(repos[repo]);
								console.log(repos[repo].name + repos[repo].status);
								 if(repos[repo].status !== 'operational'){
										this.oper= this.oper + 1;
								} 
					} 

						 if(this.oper == 2){
								this.buttoncolor = 'yellow';
								 console.log('inside yellow');
								
						}
						else if(this.oper>2){
								this. buttoncolor = 'red';
								console.log('red');
						}
						
        });
				
    }

    renderedCallback() {
        Promise.all([
            loadScript(this, status),
        ]);
    }

}