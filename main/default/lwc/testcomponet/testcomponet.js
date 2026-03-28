import { LightningElement, track ,wire,api} from 'lwc';
import verifyRegistration from '@salesforce/apex/scc_registrationformController.verifyRegistration';
import findAccountNames from '@salesforce/apex/scc_findaccounts.findAccountNames';
import getBuildingAddress from '@salesforce/apex/scc_findaccounts.getBuildingAddress';
import createUser from '@salesforce/apex/scc_registrationformController.createUser';
import { CustomLabels } from 'c/scc_customlablesLWC';
//import createUser from '@salesforce/apex/AutocreatedConfigSelfReg.createUser';

export default class RegistrationForm extends LightningElement {
    @track firstName = '';
    @track lastName = '';
    @track schoolEmail = '';
    @track selectedZipCode = '';
    @track disableVerify = true;
    @track showEmailError = false;
    @track emailError = '';
    @track showZipCodeError = false;
    @track zipCodeError = '';
    @track showSchoolDetails = false;
    @track showFirstNameLastName = true; // Show first name and last name fields by default
   // @track schoolOptions;
    @track showSchoolOptions = false;
    @track showSchoolNotFoundError = false;
    @track showNewRegistrationForm = false;
    @track companySchoolName = 'Company School'; // Default company school name
    @track companySchoolAddress = ''; // Company school address
    @track hideSelectSchool = false; // Flag to hide the 'Select School' 
    @track isregistereduser = false;// register user msg 
    @track isnotvalidcontact=false;
    @track isNouser=false;
    @track showemailzipcode= true;
    @track showCheckboxes = false;
    @track selectedValues = [];
    arrowIcon = 'utility:down'; // Icon for the arrow button
    @track isAccesstype =false
    @track isalways= true 
    @track isregiter = false
    @track firstPageheading= true ;
     @track selectedEmail = '';
    @track selectedZipCode = '';
    @track accountNames = [];
    @track showZipCodeError = false;
    @track zipCodeError = '';
        @track selectSchool
   @track schoolOptions=[];
        @track selectedSchoolName;  
        @track isRegistrationEnabled= true;
         @track isHeaders = true;

            @track street;
                @track city ;
                @track postalcode;
                 @track country;
                 selectedcheckboxs = 'option2';
                     @track showPopup = false;
                     @track prevSelectedCheckbox = '';
@track confirmButtonClicked = false;
@track registredsuccessfull= false;

@track dropdownVisible = true; // Set to true initially for expanded view
 
 
    toggleDropdown() {
        this.dropdownVisible = !this.dropdownVisible;
    }
 
 
    get dropdownClass() {
        return this.dropdownVisible ? 'dropdown-visible' : 'dropdown-hidden';
    }
 registerMsg = CustomLabels.scc_Register_New_User;
firstPageHeading = CustomLabels.scc_firstPageheading;
firstPageHeading2 = CustomLabels.scc_firstPageheading2;
isRegisteredUser = CustomLabels.scc_isregistereduser;
signInPage = CustomLabels.scc_Sign_in_Page;
resetYourPassword = CustomLabels.scc_resetyourpassword;
isNotValidContact = CustomLabels.scc_isnotvalidcontact;
isNotValidContact2 = CustomLabels.scc_isnotvalidcontact2;
submitACase = CustomLabels.scc_submit_a_case;
isNoUser3 = CustomLabels.scc_isNouser3;
isNoUser4 = CustomLabels.scc_isNouser4;
userID = CustomLabels.scc_User_ID;
companyName = CustomLabels.scc_Company_School_Name;
goodNewsRegistered = CustomLabels.scc_Good_news_Registered;
registeredSuccessfully = CustomLabels.scc_registredsuccessfull;
selectAccessType = CustomLabels.scc_Select_Access_Type;
accountWillBeUsedTo = CustomLabels.scc_Account_will_be_used_to;
address = CustomLabels.scc_Address;
companySchoolNameNotFoundPlease = CustomLabels.scc_Company_School_Name_Not_Found_Please;
toGetYourSchoolAdded = CustomLabels.scc_to_get_your_school_added;
pleaseConfirmAuthorization = CustomLabels.scc_Please_confirm_that_you_are_authorized_to_place_orders_for_the_school_or_dis;
placeOrderConfirmation = CustomLabels.scc_Place_Order_Confirmation;
nouser=CustomLabels.scc_isNouser;
 resetPasswordurl=CustomLabels.scc_resetURL;
 loginUrl=CustomLabels.scc_loginURl;

verificationResult ;


 get verifyBtnClass() {
    return this.disableVerify ? 'true' : 'false';
    
}

connectedCallback() {
console.log( window.location.origin);
    console.log(window.location.href);
     
       this.isRegistrationEnabled = this.selectedcheckboxs.includes('option2');
       console.log(this.selectedcheckboxs.includes('option2'));
    console.log('Initial state of registration button:', this.isRegistrationEnabled);
    }
    

    
      handleCheckboxChange(event) {

          console.log(this.showPopup)
          this.selectedcheckboxs = event.detail.value
   //    = checkboxGroup.value // Initialize as an empty array if undefined

        this.prevSelectedCheckbox = this.selectedcheckboxs;
         console.log('Selected options:', this.selectedcheckboxs);

    // Check if any option is selected
    if(this.selectedcheckboxs.length > 0)
    {
        this.isRegistrationEnabled =false
    }
    console.log('Selected options:', this.selectedcheckboxs);
    console.log('Registration button enabled:', this.isRegistrationEnabled);

    // Check if both options are unselected
    if (this.selectedcheckboxs.length === 0) {
        this.isRegistrationEnabled = true;
        this.showPopup = false; // Hide popup
        console.log('Both options are unselected. Disabling registration button.');
    } 
   

    if (this.selectedcheckboxs.includes('option1')||(this.confirmButtonClicked) ){
        // 'option1' is selected, so show the popup
        this.showPopup = true;
        console.log('selctedoption1',this.showPopup)
    } 


    if (this.selectedcheckboxs.includes('option2') && (this.confirmButtonClicked)){
this.showPopup = true;
console.log('selctedoption12',this.showPopup)
    }




   // Check if both 'option1' and 'option2' are selected
    if (this.selectedcheckboxs.includes('option1') && this.selectedcheckboxs.includes('option2')){
        // Both options are selected, so hide the popup
        this.showPopup = true;
        console.log(this.showPopup)
        console.log('selctedoption3',this.showPopup)
    }

    // Check if the confirm button was clicked
    if (this.confirmButtonClicked) {
        // If the confirm button was clicked, hide the popup
        this.showPopup = false;
        console.log('selctedoption4',this.showPopup)
    }



}

           
      
handleVerify() {
        if (!this.isVerificationInitiated) {
            this.verifyUserRegistration();
            this.isFirstNameDisabled = true;
            this.isLastNameDisabled = true;
            this.isEmailDisabled = true;
            this.isZipCodeDisabled = true;
           

             
        }
           
    }
        
    
    
    handleFirstNameInputChange(event) {
        this.firstName = event.target.value;
         console.log('Email Input Changed:',this.firstName);
        this.checkInputsValidity();
       console.log('handleFirstNameInputChange if :', this.disableVerify);
    }

    handleLastNameInputChange(event) {
        this.lastName = event.target.value;
         console.log('Email Input Changed:',this.lastName);
        this.checkInputsValidity();
          console.log('handleLastNameInputChange if :', this.disableVerify);
        
    }

   handleEmailInputChange(event) {
    const email = event.target.value;
    console.log('123',email);
    if (!this.validateEmail(email)) {
        this.showEmailError = true;
        this.emailError = 'Please enter a valid email address (e.g., example@example.com)';
        this.disableVerify = true;
         // Disable verify button if email format is incorrect
         console.log('handleEmailInputChange if :', this.disableVerify);
    } else {
        this.showEmailError = false;
        this.emailError = '';
        this.disableVerify = false; // Enable verify button if email format is correct
        this.schoolEmail = email; // Update the email field if the format is correct
    }
    this.checkInputsValidity(); // Validate all inputs before enabling verify button
   console.log('handleEmailInputChange :', this.disableVerify);
    }

    
        handleZipCodeChange(event) {
            
    const { value } = event.target;
    const numericValue = value.replace(/\D/g, '');
    this.selectedZipCode = value;
    console.log('entered handleZipCodeChange:', this.selectedZipCode);
    event.target.value = numericValue;
    // Reset error state
    this.showZipCodeError = false;
    this.zipCodeError = '';

    // Check if the entered ZIP code is valid
    if (numericValue.length !== 5) {
        this.showZipCodeError = true;
        this.zipCodeError = 'Please enter a valid 5-digit zip code.';
          this.showSchoolOptions = false;
        return; // Exit early if ZIP code is invalid
    }
else{
     
    this.showSchoolOptions=true;
}
    // Debounce API call to avoid excessive requests
    clearTimeout(this.zipCodeChangeTimeout);
    this.zipCodeChangeTimeout = setTimeout(() => {
        // Show loading spinner or similar UI feedback
        this.loadingSchoolOptions = true;

        // Call the API to fetch account names based on email and ZIP code
        findAccountNames({ email: this.selectedEmail, zipCode: value })
            .then(result => {
                 console.log('Result from Apex method:', JSON.stringify(result));
                if (result && result.length > 0) {
                    this.showSchoolOptions = true;
                     this.schoolOptions = result.map(Account => ({
                        label: Account.accountName,
                        value: Account.accountId
                    }));
                  //  console.log('Result from Apex method:', JSON.stringify(options));
                    
                    this.showSchoolOptions = true;
                    console.log('Retrieved school options:', this.schoolOptions);
                } else {
                    this.showSchoolOptions = true;
                    this.schoolOptions = [];
                    console.warn('No school options found.');
                }
            })
            .catch(error => {
                console.error('Error fetching account names:', error);
                // Handle error appropriately, e.g., show error message to user
                this.showSchoolOptions = false;
                this.schoolOptions = [];
            })
            .finally(() => {
                // Hide loading spinner or similar UI feedback
                this.loadingSchoolOptions = false;
            });
    }, 500); // Adjust debounce timeout as needed
}


        
     

    handleSchoolSelect(event) {
        const selectSchool = event.target.value;
         this.selectSchool = selectSchool;
         console.log(',selectSchool123'+selectSchool);


        if (selectSchool === 'default') {
         console.log('entered default selectionlast1:', this.selectSchool);
        this.showNewRegistrationForm = true;
            this.showFirstNameLastName = false; // Hide first name and last name fields
            // Populate with user-entered email and zip code
            this.schoolEmail = this.schoolEmail;
            this.selectedZipCode = this.selectedZipCode;
            // Set the company school address based on the user's inputs
            this.companySchoolAddress = `${this.firstName} ${this.lastName}, ${this.schoolEmail}, ${this.selectedZipCode}`;
            this.showSchoolDetails = false; // Show school details with user-entered values
            this.disableVerify = true;
            this.isregiter=false;
            this.showSchoolNotFoundError = true;
            this.showEmailError = false;
            this.emailError = '';
            this.firstPageheading= true;
            this.isEmailDisabled=true;
            this.hideSelectSchool = true; // Hide the 'Select School' dropdown
            this.checkInputsValidity();
                  console.log('entered default selectionlast1:', this.disableVerify);
            
        } else {
         const selectedOption = this.schoolOptions.find(option => option.value === selectSchool);
      
        console.log('entered schhold selection2:', this.selectedOption);

          
            if (selectSchool) {
               console.log('entered schhold selection1:', this.selectSchool);
            this.fetchBuildingAddress(selectSchool);
            
               console.log('entered schhold selection2:', this.selectedSchoolName);
                //this.selectedSchoolName = selectedSchool.Name;
              //  this.companySchoolName = selectedSchool.Name; // Set the company school name
                this.companySchoolAddress =  this.selectedSchoolAddress ; // Replace with actual school address
                this.schoolEmail = this.schoolEmail; // Clear email field for selected school
                this.selectedZipCode = this.selectedZipCode; // Clear zip code field for selected school
                this.showSchoolDetails = true;
                this.disableVerify = true;
                this.showSchoolNotFoundError = false;
                this.showEmailError = false;
                this.emailError = '';
                this.isregiter=false;
                this.firstPageheading= true;
                this.hideSelectSchool = true; // Hide the 'Select School' dropdown
                 console.log('selectedSchool1:', this.disableVerify);
                 this.checkInputsValidity();
            }
        
        }
 
    }

// Call the Apex method to fetch building address based on selected school ID
     fetchBuildingAddress(selectSchool) {
        getBuildingAddress({ accountId:selectSchool})
            .then(result => {
                if (result) {
                  
                this.street = result.street;
                this.city = result.city;  
                this.state = result.state;
                this.postalCode = result.postalCode;
                this.country = result.country;
                this.companySchoolName = result.companyName;

                console.log('Street:', this.street);
                console.log('City:', this.city);
                console.log('Postal Code:', this.postalCode);
                console.log('Country:', this.country);
                console.log('Company/School Name:', this.companySchoolName);

                }
            })
            .catch(error => {
                console.error('Error fetching building address:', error);
                
            });
    }


    

    handleCaseSubmission() {
        // Handle case submission logic here
        // This method will be called when the "Submit a case" button is clicked
        // You can implement logic to open a modal or navigate to a case submission page
    }
verifyUserRegistration() {
    const params = {
        firstName: this.firstName,
        lastName: this.lastName,
        schoolEmail: this.schoolEmail,
        selectedZipCode: this.selectedZipCode,
        companySchoolName: this.companySchoolName
    };

    verifyRegistration(params)
        .then(result => {
            //let jsonString = JSON.stringify(result);
            console.log('Response:', result);
        this.verificationResult = result;
          console.log('Response:1',  this.verificationResult);  
             // this.verificationResult = jsonString;   
                console.log('Response:2',  this.verificationResult);  
            if (result) {
                if (result.isContactValid && result.isAccountValid && result.isUserValid) {
                    console.log('All conditions are valid');
                  this.showNewRegistrationForm = true;
                    this.showFirstNameLastName = false;
                    this.showemailzipcode=true;
                 this.isregistereduser = true;
                 console.log('is reg'+this.isregistereduser);
                this.schoolEmail = this.schoolEmail; // Keep the user-entered email
                this.selectedZipCode = this.selectedZipCode; // Keep the user-entered zip code
                this.companySchoolAddress = `${this.firstName} ${this.lastName}, ${this.schoolEmail}, ${this.selectedZipCode}`; // Populate with user details
                this.disableVerify = true; // Disable verify button
                this.firstPageheading= false;
                this.isregiter=false;
                this.verificationResult = 'User is already registered. Please sign in or reset your password.';
                   
                } else if (!result.isContactValid || !result.isAccountValid) {
                   
                    console.log('Contact or Account is not valid');
                     this.showNewRegistrationForm = true;
                     this.showSchoolDetails=true
            this.showFirstNameLastName = false; // Hide first name and last name fields
            // Populate with user-entered email and zip code
            this.schoolEmail = this.schoolEmail;
            this.selectedZipCode = this.selectedZipCode;
            // Set the company school address based on the user's inputs
            this.companySchoolAddress = `${this.firstName} ${this.lastName}, ${this.schoolEmail}, ${this.selectedZipCode}`;
             // Show school details with user-entered values
            this.disableVerify = true;
            this.showSchoolNotFoundError = false;
            this.showEmailError = false;
            this.emailError = '';
            this.hideSelectSchool = true; // Hide the 'Select School' dropdown
             this.isnotvalidcontact= true
             this.firstPageheading= false;
             this.isregiter=false;
              
                } else {
                    
                    console.log('user need  to create');
                    this.isNouser=true;
                    this.isalways=false
                  this.isregiter=true
                  this.isRegistrationEnabled = false;
                    this.showNewRegistrationForm = false;
                     this.showSchoolDetails=false
                     this.isAccesstype=true
                     this.firstPageheading= false;
            this.showFirstNameLastName = false; // Hide first name and last name fields
            // Populate with user-entered email and zip code
            //this.schoolEmail = this.schoolEmail;
           // this.selectedZipCode = this.selectedZipCode;
            // Set the company school address based on the user's inputs
            //this.companySchoolAddress = `${this.firstName} ${this.lastName}, ${this.schoolEmail}, ${this.selectedZipCode}`;
             // Show school details with user-entered values
           this.disableVerify = false;
                this.showemailzipcode=false;

            this.showSchoolNotFoundError = false;
            this.showEmailError = false;
           // this.emailError = '';
            this.hideSelectSchool = true; // Hide the 'Select School' dropdown
             this.isnotvalidcontact= false
             console.log( 'this.isRegistrationEnabled', this.isRegistrationEnabled);
                }
            }
        })
        .catch(error => {
            console.error('Error:', error);
            // Handle error
        });

}

 

    checkboxOptions = [
        { label: 'Place Orders', value: 'option1' },
        { label: 'Check order status &price &avilability', value: 'option2' }
    ];

    toggleCheckboxes() {
        this.showCheckboxes = !this.showCheckboxes;
        this.arrowIcon = this.showCheckboxes ? 'utility:up' : 'utility:down';
    }


   
    handleCancel() {
        this.firstName = '';
        this.lastName = '';
        this.schoolEmail = '';
        this.selectedZipCode = '';
        this.disableVerify = true;
        this.showEmailError = false;
        this.emailError = '';
        this.showZipCodeError = false;
        this.zipCodeError = '';
        this.showSchoolDetails = false;
        this.selectedSchoolName = '';
        this.selectedSchoolAddress = '';
        this.schoolOptions = [];
        this.showSchoolOptions = false;
        this.showSchoolNotFoundError = false; // Hide school not found error message
        this.showNewRegistrationForm = false; // Hide new registration form
        this.showFirstNameLastName = true; // Show first name and last name fields again
        this.hideSelectSchool = false; // Show the 'Select School' dropdown again
        this.isregistereduser = false;
        this.isnotvalidcontact = false;
        this.isNouser = false;
        this.showemailzipcode = true
        this.isFirstNameDisabled = false;
            this.isLastNameDisabled = false;
            this.isEmailDisabled = false;
            this.firstPageheading= true;
            this.isZipCodeDisabled = false;
           this.isAccesstype= false;
           this.isregiter=false;
          

           console.log(this.isAccesstype);
    }
     validateEmail(email) {
        const emailRegex = /.+@.+\..+/;
        return emailRegex.test(email);
        
    }

    checkInputsValidity() {
         console.log('firstNamecheckInputsValidity:', this.firstName.trim());
    console.log('lastNamecheckInputsValidity:', this.lastName.trim());
    console.log('validateEmailcheckInputsValidity:', this.validateEmail(this.schoolEmail));
    console.log('selectedZipCodecheckInputsValidity:', this.selectedZipCode.trim());
    console.log('selectedSchoolIdcheckInputsValidity:', this.selectedSchoolId);
        
    // Check if all required fields are filled out and in correct format
  /*  this.disableVerify = !(
        this.firstName.trim() &&
        this.lastName.trim() &&
        this.validateEmail(this.schoolEmail) &&
        this.selectedZipCode.trim() &&
        this.selectedSchoolId
    );
        console.log('checkInputsValidity:', this.disableVerify);
    
}*/
if (this.selectSchool === 'default') {

        // If the default school ID is selected, disable the verify button
        this.disableVerify = true;
    } else {
        // For other school selections, check the validity of other inputs
        this.disableVerify = !(
            this.firstName.trim() &&
            this.lastName.trim() &&
            this.validateEmail(this.schoolEmail) &&
            this.selectedZipCode.trim()
        );
    }
}

      /* registerVerify(){
    /*if (this.verificationResult) {
        // Parse the JSON string to convert it into a JavaScript object
        let verificationResultObj = JSON.stringify(this.verificationResult);
        //let verificationResultObj = JSON.parse(this.verificationResult);
console.log('jsonresult',verificationResultObj);
        // Call the createUser Apex method
        createUser({ response: this.verificationResult })
            .then(result => {
                // Handle success response if needed
                console.log('User created successfully:', result);
                // For example, show a success message or navigate to a different page
            })
            .catch(error => {
                // Handle error response if needed
                console.error('Error creating user:', error);
                // For example, show an error message to the user
            });
   /* } else {
        console.error('Verification result is undefined');
    }
}*/
    registerVerify() {
   
        console.log(this.verificationResult);
        let response=this.verificationResult;
        if (this.verificationResult.isContactValid && this.verificationResult.isAccountValid && this.verificationResult.isNewUser) {
        createUser({ response: this.verificationResult })
        .then(result => {
          if(result){
              console.log('test result',this.verificationResult);
              console.log('test',result)
             this.isregiter=false;
             this.isAccesstype=false;
             this.showCheckboxes=false;
             this.registredsuccessfull=true;
             this.isNouser=false;
             this.isHeaders=false;
            console.log('test1',this.isregiter);
            console.log('test2',this.isAccesstyp);
            console.log('test3',this.showCheckboxes);
               
          }
        
          else{
           ('user not created ');
            // For example, show a success message or navigate to a different page
          }
        })
        .catch(error => {
            // Handle error response if needed
            console.error('Error creating user:', error);
            // For example, show an error message to the user
        });
    } else {
        console.error('Verification result is undefined');
    }
}

       // this.disableVerify = !(this.firstName && this.lastName && this.validateEmail(this.schoolEmail) && this.selectedZipCode && this.selectedZipCode.length === 5);
    
handleClose() {
        this.showPopup = false;
        this.selectedcheckboxs = this.selectedcheckboxs.filter(option => option !== 'option1');
    }
   PlaceorderConfirm() {
        // Handle confirm button click
        this.showPopup = false; // Close the popup
     this.confirmButtonClicked = true;
        // Implement logic for confirming the authorization to place orders
      //  this.selectedcheckboxs = this.selectedcheckboxs.filter(option => option !== 'option1');
    
   }
    PopupCancel(){

        // Handle cancel logic here
        this.showPopup = false; // Close the popup
        // Deselect the "Place Orders" checkbox
        this.selectedcheckboxs = this.selectedcheckboxs.filter(option => option !== 'option1');
        //this.selectedcheckboxs = this.selectedcheckboxs.filter(option => option !== 'option1');
    }
    handleSignInClick(event) {
         this.signInUrl = window.location.origin + this.loginUrl;
        // Prevent default behavior of the anchor tag
        event.preventDefault();
        // Redirect to the sign-in URL
        window.location.href = this.signInUrl;
        console.log(this.signInUrl);
    }
   
   handleCaseSubmission(event) {
        this.reseturl = window.location.origin + this.resetPasswordurl;
        // Prevent default behavior of the anchor tag
        event.preventDefault();
        // Redirect to the sign-in URL
        window.location.href = this.reseturl;
        console.log(this.reseturl);
    }
    RegisterCancel(){
        this.signInUrl = window.location.origin + this.loginUrl;
      
    
    
        event.preventDefault();
        
        window.location.href = this.signInUrl;
        console.log(this.signInUrl);
}
}