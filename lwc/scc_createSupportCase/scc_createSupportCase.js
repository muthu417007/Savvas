/********************************************************************************************* 
* @Component Name  - scc_createSupportCase
* @description - Create case for user from mysavvasorder portal
* @Created By  - CTS - Sameer
* @Created On - 11/11/2024 
* ********************************************************************************************/
import { LightningElement, track, api, wire } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

//Importing labels
import scc_selectCaseCategory from "@salesforce/label/c.scc_selectCaseCategory";
import scc_UserName from "@salesforce/label/c.scc_UserName";
import scc_mySavvasUserId from "@salesforce/label/c.scc_mySavvasUserId";
import scc_emailAddress from "@salesforce/label/c.scc_emailAddress";
import scc_AccountName from "@salesforce/label/c.scc_AccountName";
import scc_AccountZipCode from "@salesforce/label/c.scc_AccountZipCode";
import scc_AdditionalDetailsOfIssue from "@salesforce/label/c.scc_AdditionalDetailsOfIssue";
import scc_createCaseHeader from "@salesforce/label/c.scc_createCaseHeader";
import scc_caseCreatedMessageLabel from "@salesforce/label/c.scc_caseCreatedMessageLabel";
import scc_caseCreatedMessageLabel1 from "@salesforce/label/c.scc_caseCreatedMessageLabel1";
import scc_selfRegistration_NoSchool_Found from '@salesforce/label/c.scc_selfRegistration_NoSchool_Found';

// import static resource css for internal user 
import { loadStyle } from 'lightning/platformResourceLoader';
import headmarkupstyle_static from '@salesforce/resourceUrl/headmarkupstyle_static';

//Import apex classes
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;
import getCreateCaseCategories from '@salesforce/apex/scc_headerLWC_Controller.getCreateCaseCategories' ;
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation' ;
import createCaseSendEmail from '@salesforce/apex/scc_EnosixOrderSubmissionErrors.createCaseSendEmail' ;
import createCaseForInternalUser from '@salesforce/apex/scc_EnosixOrderSubmissionErrors.createCaseForInternalUser' ;
import uploadFile from '@salesforce/apex/scc_EnosixOrderSubmissionErrors.uploadFile' ;
import findAccountNames from '@salesforce/apex/scc_findaccounts.findAccountNames';
import getCaseNumber from '@salesforce/apex/scc_EnosixOrderSubmissionErrors.getCaseNumber' ;

export default class Scc_createSupportCase  extends NavigationMixin(LightningElement){

    @track caseCategories='';
    @track userInfo;
    @track openCreateCaseForm = true;
    @track enableLogs = false;
    @track userName='';
    @track userId='';
    @track userEmail='';
    @track userAccountName='';
    @track userAccountPostalCode='';    
    @track caseDescription = '';
    @track showAccountCaseDescError = false;
    @track caseDescError = '';
    @track showCategoryError = false;
    @track categoryError = '';
    @track remainingCharacters = 4000;    
    @track Alias;
    @track selectedCaseCatagories='';
    @track selectedValue;
    @track submitDisabledReturn = true;
    @track verificationResult;
    @track showCaseCreatedMessageLabel = false;
    @track isLoading = false;
    @track isGuest = false;
    @track isExternal = false;
    @track isInternal = false;
    @track isDisabledOnly = true;
    @track email;
    @track atSymbol;
    @track dot;
    @track isEmailValid = false;
    @track recordId;
    @track showSchoolOptions = false;
    @track selectedZipCode = '';
    @track showZipCodeError = false;
    @track zipCodeError = '';
    @track showSchoolDetails = false;
    @track hideSelectSchool = false;
    @track schoolOptions = [];
    @track selectedEmail = '';
    @track showEmailError = false;
    @track emailError = '';
    @track showNameError = false;
    @track nameError = '';
    @track recordId;
    @track fileData;
    @track userNameInput;
    @track showAccountNameError = false;
    @track accountNameError = false;
    @track showCaseCreatedMessage = false;
    @track caseNumber;
    @track fileUploadMessage;
    @track fileUploaded = false;

    labels = {
        scc_selectCaseCategory,
        scc_UserName,
        scc_mySavvasUserId,
        scc_emailAddress,
        scc_AccountName,
        scc_AccountZipCode,
        scc_AdditionalDetailsOfIssue,
        scc_createCaseHeader,
        scc_caseCreatedMessageLabel,
        scc_caseCreatedMessageLabel1,
        scc_selfRegistration_NoSchool_Found
    }
    
    nameLabel = scc_selectCaseCategory;

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

        

        // fetch custom metadata - case categories and display in dropdown
        getCreateCaseCategories().then(response => {
            if(this.enableLogs){
                console.log('response>>>>',response);  
            }          
            let parsedResponse = JSON.parse(response);
            this.caseCategories = parsedResponse;
            if(this.enableLogs){
                console.log('caseCategories>>>>',this.caseCategories);
            }
        }).catch(error => {
            console.log('error is', error);
        })

        // fetch current logged in user information
        getUserInformation().then(response => {
            if(this.enableLogs){
                console.log('response>>>>',response);
            }            
            let parsedResponse = JSON.parse(response);
            this.userInfo = parsedResponse;  
            
            this.userAccountName = this.userInfo[0].accountName;
            this.selectedZipCode = this.userInfo[0].billingPostalCode;
            this.isGuest = this.userInfo[0].isGuest;   
            this.isInternal = this.userInfo[0].isInternal;

            if(this.enableLogs){                
                console.log('isGuest>>>>',this.isGuest);
                console.log('isInternal>>>>',this.isInternal);
            }  

            if(this.isGuest == false && this.isInternal == false){
                this.isExternal = true;                
            }
            
            
            if( this.isGuest == true){
                this.userEmail = '';
            } else {
                this.userEmail = this.userInfo[0].Email;
            }
            

            if(this.isInternal == true){
                this.userName = this.userInfo[0].fullName;
            }      
            else {
                this.userName = this.userInfo[0].userName;
            }
            
        }).catch(error => {
            console.log('error is', error);
        })
        
    }
    
    // load css for internal user
    renderedCallback() {
        loadStyle(this, headmarkupstyle_static)
            .then(() => {
            })
            .catch(error => {
                if (this.enableLogs) console.error("Error in loading the colors", error)
            });            
    }

    get getCaseCatagories() {
        return this.caseCategories;
    }     
          
    // This function validates email address and sets error message on field
    handleEmailInputChange(event) {
        this.userEmail = event.target.value;
               
        if(this.userEmail === '' || this.userEmail === null){
            this.showEmailError = true;         
            this.emailError = 'Enter email address';  
        }else if(!this.validateEmail(this.userEmail)) {  
            this.showEmailError = true;         
            this.emailError = 'Email must contain @ and .';                  
        } else {
            this.showEmailError = false;
            this.emailError = '';
        }                               
    }

    // This function checks if email address contains @ and dot (.) characters
    validateEmail() {        
        const emailRegex = /^\w{1,64}([\.-]\w{1,64})*@\w+([\.-]?\w+){0,64}(\.\w{2,13})+$/;
        return emailRegex.test(this.userEmail);
    }

    // This function checks if user name field and sets error message on field
    validateUserName(event) {
        this.userName= event.target.value;        
        if (this.userName === '' || this.userName === undefined || this.userName === null) {            
            this.showNameError = true;         
            this.nameError = 'Enter name'; 
        } else {
            this.showNameError = false;
            this.nameError = '';
        }    
        
    }

    // This function validates account name and sets error message
    validateAccountName(event) {
        this.userAccountName = event.target.value;
        if (this.userAccountName.length < 1) {
            this.showAccountNameError = true;
            this.accountNameError = 'Please enter account name';
        } else {
            this.showAccountNameError = false;
            this.accountNameError = '';
        }
    }

    // This function validates case description and sets error message
    validateCaseDescription(event) {
        this.caseDescription = event.target.value;
        if (this.caseDescription.length < 1) {
            this.showAccountCaseDescError = true;
            this.caseDescError = 'Please enter case description';
        } else {
            this.showAccountCaseDescError = false;
            this.caseDescError = '';
        }
    }

    // This function validates case category and sets error message
    validateCaseCategory(event) {
        this.selectedCaseCatagories = event.target.value;        

        if (!this.selectedCaseCatagories) {
            this.showCategoryError = true;
            this.categoryError = 'Please enter case category';
        } else {
            this.showCategoryError = false;
            this.categoryError = '';
        }
    }

    // This function validates uploaded file and sets message after file uploaded on page
    handleFileChange(event) {
        const file = event.target.files[0];
        const reader = new FileReader();
        reader.onload = () => {
            const base64 = reader.result.split(',')[1];
            this.fileData = {
                fileName: file.name,
                base64: base64
            };
        };
        if(this.enableLogs){  
        console.log('this.fileData>>>',this.fileData);
        }
        this.fileUploaded = true;
        this.fileUploadMessage = 'File uploaded successfully';
        reader.readAsDataURL(file);
    }
    
    // This function converts uploaded file to base64
    uploadFile() {
        const { fileName, base64 } = this.fileData;        
    }

    // This function sets message after file uploaded successfully
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        if(this.enableLogs){   
            console.log('No. of files uploaded : ' + uploadedFiles.length);        
        }
    }     

    // This function validates postal/ zip code and returns corresponding Account names 
    handleZipCodeChange(event) {
    this.selectedZipCode = event.target.value;
    if(this.isGuest === false){
        if(this.enableLogs){   
            console.log('this.selectedZipCode>>>',this.selectedZipCode);
            console.log('this.selectedZipCode.length>>>',this.selectedZipCode.length);       
        }
        if (this.selectedZipCode.length < 5) {            
            this.showZipCodeError = true;
            this.zipCodeError = 'Please enter at least 5 characters.';
            this.showSchoolOptions = false;
            this.hideSelectSchool = true; 
            return;
        } else {
            this.showZipCodeError = false;
            this.showSchoolOptions = false; 
            this.hideSelectSchool = false;
        }
    }

    if(this.isGuest === true){
        const { value } = event.target;        
        
        this.showZipCodeError = false;
        this.zipCodeError = '';
        if(this.enableLogs){   
            console.log('this.selectedZipCode>>>',this.selectedZipCode);
            console.log('this.selectedZipCode.length>>>',this.selectedZipCode.length);       
        }
        if (this.selectedZipCode.length < 5) {            
            this.showZipCodeError = true;
            this.zipCodeError = 'Please enter at least 5 characters.';
            this.showSchoolOptions = false;
            this.hideSelectSchool = true; 
            return;
        } else {
            this.showZipCodeError = false;
            this.showSchoolOptions = true; 
            this.hideSelectSchool = false;
        }
        
        findAccountNames({ email: this.selectedEmail, zipCode: this.selectedZipCode })
            .then(result => {

                if (this.enableLogs){
                    console.log('result.length',result.length);
                    console.log('result',result);
                }

                if (result && result.length > 0) {
                    this.schoolOptions = [
                        { value: "I don't see my school", label: this.labels.scc_selfRegistration_NoSchool_Found },
                        ...result.map(school => ({
                            value: school.accountId,
                            label: school.accountName,
                        }))
                    ];

                    if (this.enableLogs){
                        console.log('this.schoolOptions>>>',this.schoolOptions);
                    }
                    
                } else {
                    this.schoolOptions = [
                        { value: "I don't see my school", label: this.labels.scc_selfRegistration_NoSchool_Found }
                    ];
                    
                    if (this.enableLogs)  {
                        console.log('this.schoolOptions>>>',this.schoolOptions);
                        console.log('No school options found.');
                    }
                }                
            })
            .catch(error => {
                if (this.enableLogs){
                    console.log('Error fetching school options:', error);
                }  
                this.schoolOptions = [
                    { value: this.labels.scc_selfRegistration_NoSchool_Found, label: 'No school is found in this zip code?' }
                ];                 
            });
    }
                     
    }

    handlezipfocus() {
        this.zipCodeError = '';
        this.showZipCodeError = false;
    }

    // This function sets account name using selected postal / zip code drop down list
    handleSchoolSelect(event) { 
    if(this.isGuest === true){
        const selectSchool = event.target.dataset.value;        
        this.selectSchool = selectSchool;
        if (selectSchool === "I don't see my school") {           
            this.selectedZipCode = "I don't see my school";
            this.userAccountName = '';
            this.showAccountNameError = true;
            this.accountNameError = 'Please enter account name';
            this.hideSelectSchool = true;         
            setTimeout(() => {
                this.template.querySelector('.school-not-found-submit-case-link').focus();
            }, 100);
        } else {
            this.selectSchool = event.target.dataset.value; 
            if (this.enableLogs){
                
                console.log('this.selectSchool>>>>',this.selectSchool);
                console.log('selectSchool2 event>>>>',event);
                console.log('selectSchool2 event target>>>>',event.target);
                console.log('selectSchool2 event target dataset>>>>',event.target.dataset.value);
                console.log('selectSchool2 label>>>>',event.target.textContent);
                console.log('selectSchool2 value>>>>',event.target.value);
            }
            
            const selectedOption = this.schoolOptions.find(option => option.value === selectSchool);
            if (selectSchool) {                                
                this.userAccountName = event.target.textContent;  
                this.showAccountNameError = false;
                this.accountNameError = '';              
                setTimeout(() => {
                    this.template.querySelector('[data-id="schoolZipCode"]').focus();
                }, 100);
            }
            this.hideSelectSchool = true;
        }
    }       
        
    }

    handleSchoolSelectkeypress(event) {
        if (event.key === 'Enter') {
            this.handleSchoolSelect(event);
        } else if (event.key === 'ArrowDown' || event.key === 'ArrowRight') {
            if (event.target.nextSibling != null) {
                event.target.nextSibling.focus();
            }
        } else if (event.key === 'ArrowUp') {
            if (event.target.previousSibling != null) {
                event.target.previousSibling.focus();
            }
        }
    }

    handleCloseKeyPress(event) {
        if (event.key === 'Enter') {
            this.handleClose(event);
        }
    }
    
    // This function sets case category from value selected in dropdown
    handleCatgoriesChange(event){
        this.selectedCaseCatagories = event.detail.value;
                
        if ( this.selectedCaseCatagories === '') {                                   
            this.submitDisabled = true;          
        }

    }

    // This function sets case description value
    handleCaseDescription(event){
        this.caseDescription = event.detail.value;
        this.remainingCharacters = 4000 - this.caseDescription.length;        
    }

    get remainingCharactersMessage() {
        return `Remaining characters: ${this.remainingCharacters}`;
    }

    // This function create case
    handleSubmit() {
        if(this.enableLogs){   
            console.log('check this>>>', !JSON.parse(this.template.querySelector('.submit-button').getAttribute('aria-disabled')));
        }
    
        this.validateEmail();               
        
        if (!JSON.parse(this.template.querySelector('.submit-button').getAttribute('aria-disabled'))) {
            if(this.enableLogs){   
                console.log('this.submitDisabled>>>',this.submitDisabled);
            }
            if(this.submitDisabled == false){
                this.isLoading = true;      
                    if(this.enableLogs){                         
                        console.log('this.selectedCaseCatagories',this.selectedCaseCatagories);
                        console.log('this.userName',this.userName);
                        console.log('this.userEmail',this.userEmail);
                        console.log('this.caseDescription',this.caseDescription);
                        console.log('this.userAccountName',this.userAccountName);
                        console.log('this.selectedZipCode',this.selectedZipCode);
                        console.log('this.isInternal',this.isInternal);
                        console.log('this.isGuest',this.isGuest);
                    }
                    const params = {
                        caseCategory: this.selectedCaseCatagories,
                        name: this.userName,                        
                        email: this.userEmail,                        
                        caseDesc: this.caseDescription,
                        accountName: this.userAccountName,
                        accountZipCode: this.selectedZipCode,
                        internalUser: this.isInternal,
                        guestUser: this.isGuest,
                        accountid: this.selectSchool
                    };            
                    createCaseForInternalUser(params)
                        .then(result => {   
                            if(this.enableLogs){                         
                                console.log('result>>>>',result);
                            }
                            this.recordId = result;
                                
                                // fetch case number
                                getCaseNumber({ recordId: this.recordId }).then(response => {
                                    if(this.enableLogs){
                                        console.log('response>>>>',response);  
                                    }          
                                                                        
                                        this.caseNumber = response;
                                        this.isLoading = false;
                                        this.showCaseCreatedMessage = true;
                                        this.submitDisabledReturn = true;
                                        this.isLoading = false; 

                                    if(this.enableLogs){
                                        console.log('caseNumber>>>>',this.caseNumber);
                                    }
                                }).catch(error => {
                                    if(this.enableLogs){
                                    console.log('error is', error);
                                    }
                                })
                            
                                if(this.enableLogs){     
                                    console.log('result outside file>>>>',result);
                                    console.log('this.showCaseCreatedMessage without file',this.showCaseCreatedMessage);
                                    console.log('this.submitDisabledReturn without file',this.submitDisabledReturn);
                                    console.log('this.isLoading without file',this.isLoading);    
                                }

                                if(this.fileData){                                    
                                                                        
                                    this.uploadFileAsync();
                                    if(this.enableLogs){ 
                                        console.log('this.showCaseCreatedMessage with file', this.showCaseCreatedMessage);
                                        console.log('this.submitDisabledReturn with file', this.submitDisabledReturn);
                                        console.log('this.isLoading with file', this.isLoading);
                                    }
                                }                              
                            
                        })
                        .catch(error => {
                            console.log('Error ocurred during case creation for internal user');
                            console.log(error);
                            this.isLoading = false;
                        });                
                
            } 
        }                           
    }

    async uploadFileAsync() {
        const { fileName, base64 } = this.fileData;
        try {
            const result = await uploadFile({ fileName, base64Data: base64, recordId: this.recordId });
    
            if (this.enableLogs) {
                console.log('result inside file>>>>', result);
                
            }
        } catch (error) {
            console.log(error);
        }
    }

    // This function control disability of submit button 
    get submitDisabled(){
        if(this.enableLogs){   
            console.log('this.selectedCaseCatagories',this.selectedCaseCatagories);
            console.log('this.userName',this.userName);
            console.log('this.userEmail',this.userEmail);
            console.log('this.caseDescription',this.caseDescription);
            console.log('this.userAccountName',this.userAccountName);
            console.log('this.selectedZipCode',this.selectedZipCode);
            console.log('this.isInternal',this.isInternal);
            console.log('this.isGuest',this.isGuest);
            console.log('!this.validateEmail(this.userEmail) >>>',!this.validateEmail(this.userEmail) );
        }
        if (
            (this.isGuest === true && (!this.validateEmail(this.userEmail) || this.selectedCaseCatagories === '' || this.selectedZipCode === '' || (this.selectedZipCode !== null &&  this.selectedZipCode.length < 5) || this.selectedZipCode === null || this.selectedCaseCatagories === null || this.userEmail === '' || this.userName === '' || this.caseDescription === '' || this.userAccountName === ''))
            ||
            (this.isInternal === true && (!this.validateEmail(this.userEmail) || this.selectedCaseCatagories === ''  || this.selectedCaseCatagories === null || this.userEmail === '' || this.userName === '' || this.caseDescription === ''))
            ||
            (this.isGuest === false  && this.isInternal === false  && (this.selectedCaseCatagories === '' || this.selectedCaseCatagories === null || this.selectedZipCode === '' || (this.selectedZipCode !== null &&  this.selectedZipCode.length < 5) || this.selectedZipCode === null || this.userAccountName === '' || this.userEmail === '' || this.caseDescription === ''))
        ){
            this.submitDisabledReturn = true;
        } else {
            this.submitDisabledReturn = false;
        }
        return this.submitDisabledReturn;
    }

    

}