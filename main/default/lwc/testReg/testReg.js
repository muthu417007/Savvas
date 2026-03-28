import { LightningElement, track ,wire} from 'lwc';
import verifyRegistration from '@salesforce/apex/scc_registrationformController.verifyRegistration';
import findAccountNames from '@salesforce/apex/scc_findaccounts.findAccountNames';
import getBuildingAddress from '@salesforce/apex/scc_findaccounts.getBuildingAddress';
import createUser from '@salesforce/apex/scc_registrationformController.createUser';
import { RefreshEvent } from 'lightning/refresh';
import { CustomLabels } from 'c/scc_customlablesLWC';
import scc_landingpage_bgimage from "@salesforce/resourceUrl/scc_landingpage_bgimage";
import scc_signIn_Dealer_Title from '@salesforce/label/c.scc_signIn_Dealer_Title';
import scc_signIn_Homeschool_Text from '@salesforce/label/c.scc_signIn_Homeschool_Text';
import scc_signIn_Private_Student_Text from '@salesforce/label/c.scc_signIn_Private_Student_Text';
import scc_signIn_Other_Student_Text from '@salesforce/label/c.scc_signIn_Other_Student_Text';
import scc_signIn_Footer_Text from '@salesforce/label/c.scc_signIn_Footer_Text';
import scc_signIn_Footer_Savvas_Support from '@salesforce/label/c.scc_signIn_Footer_Savvas_Support';
import scc_signIn_Footer_Terms_Text from '@salesforce/label/c.scc_signIn_Footer_Terms_Text';
import scc_signIn_Footer_Privacy_Text from '@salesforce/label/c.scc_signIn_Footer_Privacy_Text';
import scc_register_FirstName_Text from '@salesforce/label/c.scc_register_FirstName_Text';
import scc_register_LastName_Text from '@salesforce/label/c.scc_register_LastName_Text';
import scc_register_SchoolEmail_Text from '@salesforce/label/c.scc_register_SchoolEmail_Text';
import scc_register_SchoolZip_Text from '@salesforce/label/c.scc_register_SchoolZip_Text';
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

    labels= {
        scc_landingpage_bgimage,
        scc_signIn_Dealer_Title,
        scc_signIn_Homeschool_Text,
        scc_signIn_Private_Student_Text,
        scc_signIn_Other_Student_Text,
        scc_signIn_Footer_Text,
        scc_signIn_Footer_Savvas_Support,
        scc_signIn_Footer_Terms_Text,
        scc_signIn_Footer_Privacy_Text,
        scc_register_FirstName_Text,
        scc_register_LastName_Text,
        scc_register_SchoolEmail_Text,
        scc_register_SchoolZip_Text
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
registrationsuccessfulemail=CustomLabels.scc_registrationsuccessfulemail

verificationResult ;

 get verifyBtnClass() {
    return this.disableVerify ? 'true' : 'false';
    
}

connectedCallback() {

     /*this.signInUrl = window.location.origin + '/MySavvasOrders/login';
     this.reseturl = window.location.origin + '/MySavvasOrders/ForgotPassword';*/
       this.isRegistrationEnabled = this.selectedcheckboxs.includes('option2');
       
    
    }
    

    
      handleCheckboxChange(event) {

          console.log(this.showPopup)
          this.selectedcheckboxs = event.detail.value
   

        this.prevSelectedCheckbox = this.selectedcheckboxs;
        

    
    if(this.selectedcheckboxs.length > 0)
    {
        this.isRegistrationEnabled =false
    }
    

    // Check if both options are unselected
    if (this.selectedcheckboxs.length === 0) {
        this.isRegistrationEnabled = true;
        this.showPopup = false; // Hide popup
        document.body.style.overflow = 'auto';
    } 
   

    if (this.selectedcheckboxs.includes('option1')||(this.confirmButtonClicked) ){
        // 'option1' is selected, so show the popup
        this.showPopup = true;
        document.body.style.overflow = 'hidden';
    } 


    if (this.selectedcheckboxs.includes('option2') && (this.confirmButtonClicked)){
this.showPopup = true;
document.body.style.overflow = 'hidden';
    }




   // Check if both 'option1' and 'option2' are selected
    if (this.selectedcheckboxs.includes('option1') && this.selectedcheckboxs.includes('option2')){
        // Both options are selected, so hide the popup
        this.showPopup = true;
        document.body.style.overflow = 'hidden';
        
    }

    // Check if the confirm button was clicked
    if (this.confirmButtonClicked) {
        // If the confirm button was clicked, hide the popup
        this.showPopup = false;
        document.body.style.overflow = 'auto';
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
        
        this.checkInputsValidity();
       
    }

    handleLastNameInputChange(event) {
        this.lastName = event.target.value;
         
        this.checkInputsValidity();
          
        
    }

   handleEmailInputChange(event) {
    const email = event.target.value;
   
    if (!this.validateEmail(email)) {
        this.showEmailError = true;
        this.emailError = 'Please enter a valid email address (e.g., example@example.com)';
        this.disableVerify = true;
         // Disable verify button if email format is incorrect
         
    } else {
        this.showEmailError = false;
        this.emailError = '';
        this.disableVerify = false; // Enable verify button if email format is correct
        this.schoolEmail = email; // Update the email field if the format is correct
    }
    this.checkInputsValidity(); // Validate all inputs before enabling verify button
   
    }

    
//         handleZipCodeChange(event) {
            
//     const { value } = event.target;
//     const numericValue = value.replace(/\D/g, '');
//     this.selectedZipCode = value;
//     console.log(this.selectedZipCode);
   
//     event.target.value = numericValue;
//     // Reset error state
//     this.showZipCodeError = false;
//     this.zipCodeError = '';

//     // Check if the entered ZIP code is valid
//     if (numericValue.length !== 5) {
//         this.showZipCodeError = true;
//         this.zipCodeError = 'Please enter a valid 5-digit zip code.';
//           this.showSchoolOptions = false;
//         return; // Exit early if ZIP code is invalid
//     }
// else{
     
//     this.showSchoolOptions=true;
// }
   
//     clearTimeout(this.zipCodeChangeTimeout);
//     this.zipCodeChangeTimeout = setTimeout(() => {
//         // Show loading spinner or similar UI feedback
       
// console.log(this.loadingSchoolOptions);
//         // Call the API to fetch account names based on email and ZIP code
//         findAccountNames({ email: this.selectedEmail, zipCode: value })
//             .then(result => {
                 
//                 if (result && result.length > 0) {
//                     this.showSchoolOptions = true;
//                      this.schoolOptions = result.map(Account => ({
//                         label: Account.accountName,
//                         value: Account.accountId
//                     }));
//                     console.log('Result from Apex method:', JSON.stringify(options));
                    
//                     this.showSchoolOptions = true;
//                     this.hideSelectSchool=false;
                    
//                 } else {
//                     this.showSchoolOptions = true;
//                     this.schoolOptions = [];
//                     console.warn('No school options found.');
//                 }
//             })
//             .catch(error => {
               
//                 // Handle error appropriately, e.g., show error message to user
//                 this.showSchoolOptions = false;
//                 this.schoolOptions = [];
//             })
//             .finally(() => {
//                 // Hide loading spinner or similar UI feedback
//                 this.loadingSchoolOptions = false;
//                 console.log('Result from Apex method:', this.loadingSchoolOptions);
//             });
//     }, 500); // Adjust debounce timeout as needed
// }


//    handleZipCodeChange(event) {
//         const value = event.target.value;
//         const numericValue = value.replace(/\D/g, '');
//         this.selectedZipCode = numericValue;
//         this.showZipCodeError = false;
//         this.zipCodeError = '';

//         if (numericValue.length !== 5) {
//             this.showZipCodeError = true;
//             this.zipCodeError = 'Please enter a valid 5-digit zip code.';
//             this.showSchoolOptions = false;
//             return;
//         }

//         // Show loading state
       
//         this.showSchoolOptions = true;
//         this.hideSelectSchool = false;

//         clearTimeout(this.zipCodeChangeTimeout);
//         this.zipCodeChangeTimeout = setTimeout(() => {
//             findAccountNames({ email: this.selectedEmail, zipCode: numericValue })
//                 .then(result => {
//                     console.log(result);
//                     if (result && result.length > 0) {
//                         this.schoolOptions = result.map(account => ({
//                             label: account.Name,
//                             value: account.Id
//                         }));
//                          console.log(this.schoolOptions);
//                     } else {
//                         this.schoolOptions = [{ label: 'No school is found in this zip code?', value: 'default' }];
//                     }
//                     this.showSchoolOptions = true;
//                     this.hideSelectSchool = false;
//                 })
//                 .catch(error => {
//                     console.error('Error fetching school options:', error);
//                     this.schoolOptions = [{ label: 'No school is found in this zip code?', value: 'default' }];
//                     this.showSchoolOptions = true;
//                     this.hideSelectSchool = false;
//                 });
//         }, 500); // Adjust debounce timeout as needed
//     }

 handleZipCodeChange(event) {
    const { value } = event.target;
    const numericValue = value.replace(/\D/g, '');
    this.selectedZipCode = numericValue; // Store the numeric value in selectedZipCode
    // Reset error state
    this.showZipCodeError = false;
    this.zipCodeError = '';
    
    // Check if the entered ZIP code is valid
    if (numericValue.length !== 5) {
        this.showZipCodeError = true;
        this.zipCodeError = 'Please enter a valid 5-digit zip code.';
        this.showSchoolOptions = false;
        this.hideSelectSchool = true; // Hide the select element
        return;
    } else {
        this.showSchoolOptions = true; // Show the school options
        this.hideSelectSchool = false; // Show the select element
    }
    
    // Call the API to fetch account names based on email and ZIP code
   findAccountNames({ email: this.selectedEmail, zipCode: numericValue })
            .then(result => {
                if (result && result.length > 0) {
                    this.schoolOptions = [
                        { value: 'default', label: 'No school is found in this zip code?' },
                        ...result.map(school => ({
                            value: school.accountId,
                            label: school.accountName,
                        }))
                    ];
                } else {
                    this.schoolOptions = [
                        { value: 'default', label: 'No school is found in this zip code?' }
                    ];
                    console.warn('No school options found.');
                }
            })
            .catch(error => {
                console.error('Error fetching school options:', error);
                this.schoolOptions = [
                    { value: 'default', label: 'No school is found in this zip code?' }
                ]; // Reset school options
            });
    }


     

    handleSchoolSelect(event) {
        const selectSchool = event.target.dataset.value
        console.log('Selected school:', selectSchool);

         this.selectSchool = selectSchool;
         console.log('Selected school:', this.selectSchool);
console.log('Default option selected, state updated');


        if (selectSchool === 'default') {
            console.log('Selected school:', selectSchool);
         
        this.showNewRegistrationForm = true;
            //this.showFirstNameLastName = false; // Hide first name and last name fields
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
            //this.isEmailDisabled=true;
            this.hideSelectSchool = true; // Hide the 'Select School' dropdown
            this.checkInputsValidity();
                 
            
        } else {
         const selectedOption = this.schoolOptions.find(option => option.value === selectSchool);
      
        

          
            if (selectSchool) {
               
            this.fetchBuildingAddress(selectSchool);
            
               
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
           
        this.verificationResult = result;
          console.log(result)
             // this.verificationResult = jsonString;   
                 
            if (result) {
                if (result.isContactValid && result.isAccountValid && result.isUserValid) {
                   
                  this.showNewRegistrationForm = true;
                    this.showFirstNameLastName = true;
                    this.showemailzipcode=true;
                 this.isregistereduser = true;
                 
                this.schoolEmail = this.schoolEmail; // Keep the user-entered email
                this.selectedZipCode = this.selectedZipCode; // Keep the user-entered zip code
                this.companySchoolAddress = `${this.firstName} ${this.lastName}, ${this.schoolEmail}, ${this.selectedZipCode}`; // Populate with user details
                this.disableVerify = true; // Disable verify button
                this.firstPageheading= false;
                this.isregiter=false;
                this.verificationResult = 'User is already registered. Please sign in or reset your password.';
                   
                } else if (!result.isContactValid || !result.isAccountValid) {
                   
                   
                     this.showNewRegistrationForm = true;
                     this.showSchoolDetails=true
            this.showFirstNameLastName = true; // Hide first name and last name fields
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
                    
                    
                    this.isNouser=true;
                    this.isalways=false
                  this.isregiter=true
                  this.isRegistrationEnabled = false;
                    this.showNewRegistrationForm = false;
                     this.showSchoolDetails=false
                     this.isAccesstype=true
                     this.firstPageheading= false;
            this.showFirstNameLastName = false; // Hide first name and last name fields
           
           this.disableVerify = false;
                this.showemailzipcode=false;

            this.showSchoolNotFoundError = false;
            this.showEmailError = false;
           // this.emailError = '';
            this.hideSelectSchool = true; // Hide the 'Select School' dropdown
             this.isnotvalidcontact= false
             
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
        { label: 'Check Order Status & Price & Availability', value: 'option2' }
    ];        

    toggleCheckboxes() {
        // this.showCheckboxes = !this.showCheckboxes;
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
           this.dispatchEvent(new RefreshEvent());

           console.log(this.isAccesstype);
    }
     validateEmail(email) {
        const emailRegex = /.+@.+\..+/;
        return emailRegex.test(email);
        
    }

    checkInputsValidity() {

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

     
    registerVerify() {
   
        console.log(this.verificationResult);
        let response=this.verificationResult;
        if (this.verificationResult.isContactValid && this.verificationResult.isAccountValid && this.verificationResult.isNewUser) {
        createUser({ response: this.verificationResult })
        .then(result => {
          if(result){
             
             this.isregiter=false;
             this.isAccesstype=false;
            // this.showCheckboxes=true;
             this.registredsuccessfull=true;
             this.isNouser=false;
             this.isHeaders=false;
            
               
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

       
    
handleClose() {
        this.showPopup = false;
        document.body.style.overflow = 'auto';
        this.selectedcheckboxs = this.selectedcheckboxs.filter(option => option !== 'option1');
    }
   PlaceorderConfirm() {
        // Handle confirm button click
        this.showPopup = false; // Close the popup
        document.body.style.overflow = 'auto';
     this.confirmButtonClicked = true;
        // Implement logic for confirming the authorization to place orders
      //  this.selectedcheckboxs = this.selectedcheckboxs.filter(option => option !== 'option1');
    
   }
    PopupCancel(){

        // Handle cancel logic here
        this.showPopup = false; // Close the popup
        document.body.style.overflow = 'auto';
        // Deselect the "Place Orders" checkbox
        this.selectedcheckboxs = this.selectedcheckboxs.filter(option => option !== 'option1');
        //this.selectedcheckboxs = this.selectedcheckboxs.filter(option => option !== 'option1');
    }
    handleSignInClick(event) {
        this.signInUrl = window.location.origin + this.loginUrl;
        event.preventDefault();
        // Redirect to the sign-in URL
        window.location.href = this.signInUrl;
        console.log(this.signInUrl);
    }
   
   handleCaseSubmission(event) {
        this.signInUrl = window.location.origin + this.resetPasswordurl;
        event.preventDefault();
        // Redirect to the sign-in URL
        window.location.href = this.reseturl;
        console.log(this.reseturl);
    }
    RegisterCancel(){
    this.signInUrl = window.location.origin + this.loginUrl;
        event.preventDefault();
        // Redirect to the sign-in URL
        window.location.href = this.signInUrl;
        console.log(this.signInUrl);
}
}