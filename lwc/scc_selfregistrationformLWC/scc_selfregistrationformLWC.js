/*********************************************************
  Component Name       : scc_selfregistrationformLWC
  Created Date         : 07/21/2024  
  Author               : Sudha Rani pathivada- Cognizant
  Description          :  this component used in  registration  page 
  
  Modifications Log
  <Date>       <Author>            <Modification>
  
*********************************************************/
import { LightningElement, track, wire } from 'lwc';
import verifyRegistration from '@salesforce/apex/scc_registrationformController.verifyRegistration';
import sendEmailtoCaseForMoreThanOneEmailId from '@salesforce/apex/scc_registrationformController.sendEmailtoCaseForMoreThanOneEmailId';
import sendEmailtoCaseForSchoolNotFound from '@salesforce/apex/scc_registrationformController.sendEmailtoCaseForSchoolNotFound';
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
import scc_selfRegistration_NoSchool_Found from '@salesforce/label/c.scc_selfRegistration_NoSchool_Found';
import scc_Populate_Required_Fields from '@salesforce/label/c.scc_Populate_Required_Fields';
import scc_emailAddress_Issue_Submitted from '@salesforce/label/c.scc_emailAddress_Issue_Submitted';
import scc_addSchool_Request_Submitted from '@salesforce/label/c.scc_addSchool_Request_Submitted';
import scc_brand_logo_mobile from "@salesforce/resourceUrl/scc_brand_logo_mobile";
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';

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
    @track showFirstNameLastName = true; // Show first name and last name fields by defaul

    @track showSchoolOptions = false;
    @track showSchoolNotFoundError = false;
    @track showNewRegistrationForm = false;
    @track companySchoolName = 'Company School'; // Default company school name
    @track companySchoolAddress = ''; // Company school address
    @track hideSelectSchool = false; // Flag to hide the 'Select School' 
    @track isregistereduser = false;// register user msg 
    @track isnotvalidcontact = false;
    @track IsAccountTypeValid = false;
    @track isNouser = false;
    @track showemailzipcode = true;
    @track showCheckboxes = false;
    @track selectedValues = [];
    arrowIcon = 'utility:down'; // Icon for the arrow button
    @track isAccesstype = false
    @track isalways = true
    @track isregiter = false
    @track firstPageheading = true;
    @track selectedEmail = '';
    @track selectedZipCode = '';
    @track accountNames = [];
    @track showZipCodeError = false;
    @track zipCodeError = '';
    @track selectSchool
    @track schoolOptions = [];
    @track selectedSchoolName;
    @track isRegistrationEnabled = true;
    @track isHeaders = true;
    @track street;
    @track city;
    @track postalcode;
    @track country;
    selectedcheckboxs = 'option2';
    @track showPopup = false;
    @track prevSelectedCheckbox = '';
    @track confirmButtonClicked = false;
    @track registredsuccessfull = false;
    @track showCreateCaseforMoreThanOneEmail = false;
    @track showCreateCaseforSchoolNotFound = false;
    @track showCreateCaseforMoreThanOneEmailLabel = false;
    @track showCreateCaseforSchoolNotFoundLabel = false;
    @track CreateCaseforMoreThanOneEmailMessage = scc_emailAddress_Issue_Submitted;
    @track CreateCaseforSchoolNotFound = scc_addSchool_Request_Submitted;
    @track populateRequiredFieldMessage = scc_Populate_Required_Fields
    @track schoolAddress = '';
    @track moreThanOneSchoolDescription = '';
    @track noSchoolFoundDescription = '';
    @track email = '';
    @track schoolDetailsEntered = false;
    @track schoolAddressEntered = false;
    @track schoolNameEntered = false;
    @track disableButton = true;
    @track enableLogs = false;

    labels = {
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
        scc_register_SchoolZip_Text,
        scc_selfRegistration_NoSchool_Found,
        scc_brand_logo_mobile
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
    nouser = CustomLabels.scc_isNouser;
    resetpurl = CustomLabels.scc_resetURL;
    loginUrl = CustomLabels.scc_loginURl;
    registrationsuccessfulemail = CustomLabels.scc_registrationsuccessfulemail
    inValidAccount = CustomLabels.scc_inValidAccount
    verificationResult;

    get verifyBtnClass() {
        return this.disableVerify ? true : false;

    }

    connectedCallback() {
        this.isRegistrationEnabled = this.selectedcheckboxs.includes('option2');
        this.showCreateCaseforMoreThanOneEmail = false;
        this.showCreateCaseforSchoolNotFound = false;
        //to catch escape keypress for accessibility
        this.template.addEventListener('keydown', this.handleKeydown.bind(this));
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
      });

    }

    disconnectedCallback() {
        // Remove the keydown event listener when the component is removed from the DOM
        this.template.removeEventListener('keydown', this.handleKeydown);
    }

    handleKeydown(event) {
        if (event.key === 'Escape') {
            if (this.showCreateCaseforMoreThanOneEmail) {
                this.closeModalMoreThanOneEmail();
            }
            else if (this.showCreateCaseforSchoolNotFound) {
                this.closeModalSchoolNotFound();
            }
            else if (!this.hideSelectSchool) {
                this.hideSelectSchool = true; // Hide the 'Select School' dropdown
            } else if (this.showPopup) {
                this.PopupCancel();
            } else if (this.registredsuccessfull) {
                this.handleSignInClick(event);
            }
        }
    }

    handleCheckboxChange(event) {
        this.selectedcheckboxs = event.detail.value
        this.prevSelectedCheckbox = this.selectedcheckboxs;
        if (this.selectedcheckboxs.length > 0) {
            this.isRegistrationEnabled = false
        }

        // Check if both options are unselected
        if (this.selectedcheckboxs.length === 0) {
            this.isRegistrationEnabled = true;
            this.showPopup = false; // Hide popup
            document.body.style.overflow = 'auto';
        }


        if (this.selectedcheckboxs.includes('option1') || (this.confirmButtonClicked)) {
            // 'option1' is selected, so show the popup
            this.showPopup = true;
            setTimeout(() => {
                this.template.querySelector('.confirm-purchase-auth-close-btn').focus();
            }, 100);
            document.body.style.overflow = 'hidden';
        }

        if (this.selectedcheckboxs.includes('option2') && (this.confirmButtonClicked)) {
            this.showPopup = true;
            document.body.style.overflow = 'hidden';
        }

        // Check if both 'option1' and 'option2' are selected
        if (this.selectedcheckboxs.includes('option1') && this.selectedcheckboxs.includes('option2')) {
            // Both options are selected, so hide the popup
            this.showPopup = true;
            document.body.style.overflow = 'hidden';

        }
        if (this.confirmButtonClicked) {
            this.showPopup = false;
            document.body.style.overflow = 'auto';
        }

        if (this.selectedcheckboxs.includes('option1')) {
            this.verificationResult.orderingEnabled = true;
        }
        else {
            this.verificationResult.orderingEnabled = false;
        }
        if (this.selectedcheckboxs.includes('option2')) {
            this.verificationResult.checkStatusPriceAvailability = true;
        }
        else {
            this.verificationResult.checkStatusPriceAvailability = false;
        }

    }
    handleVerify(event) {
        if (!this.isVerificationInitiated && !JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.verifyUserRegistration();
        }
    }


    handleFirstNameInputChange(event) {
        this.firstName = event.target.value;
        if (this.firstName == '' || this.firstName == undefined) {
            this.firstNameError = 'Please enter first name';
            this.showFirstNameError = true;
        } else {
            this.firstNameError = '';
            this.showFirstNameError = false;
        }
        this.checkInputsValidity();
    }

    handleLastNameInputChange(event) {
        this.lastName = event.target.value;
        if (this.lastName == '' || this.lastName == undefined) {
            this.LastNameError = 'Please enter last name';
            this.showLastNameError = true;
        } else {
            this.LastNameError = '';
            this.showLastNameError = false;
        }
        this.checkInputsValidity();
    }

    handleEmailInputChange(event) {
        this.email = event.target.value;

        if (!this.validateEmail(this.email)) {
            this.showEmailError = true;
            this.emailError = 'Please enter a valid email address (e.g., example@example.com)';
            this.disableVerify = true;
            // Disable verify button if email format is incorrect

        } else {
            this.showEmailError = false;
            this.emailError = '';
            this.disableVerify = false; // Enable verify button if email format is correct
            this.schoolEmail = this.email; // Update the email field if the format is correct
        }
        this.checkInputsValidity(); // Validate all inputs before enabling verify button

    }

    handleZipCodeChange(event) {
        const { value } = event.target;
        //const numericValue = value.replace(/\D/g, '');
        this.selectedZipCode = event.target.value;
        this.showZipCodeError = false;
        this.zipCodeError = '';
        console.log('this.selectedZipCode.length>>>',this.selectedZipCode.length);
        // Check if the entered ZIP code is valid
        if (this.selectedZipCode.length < 5) {
            
            this.showZipCodeError = true;
            this.zipCodeError = 'Please enter at least 5 characters.';
            this.showSchoolOptions = false;
            this.hideSelectSchool = true; // Hide the select element
            return;
        } else {
            this.showSchoolOptions = true; // Show the school options
            this.hideSelectSchool = false; // Show the select element
        }
        
        findAccountNames({ email: this.selectedEmail, zipCode: this.selectedZipCode })
            .then(result => {
                if (result && result.length > 0) {
                    this.schoolOptions = [
                        { value: 'default', label: this.labels.scc_selfRegistration_NoSchool_Found },
                        ...result.map(school => ({
                            value: school.accountId,
                            label: school.accountName,
                        }))
                    ];
                } else {
                    this.schoolOptions = [
                        { value: 'default', label: this.labels.scc_selfRegistration_NoSchool_Found }
                    ];
                    
                    if (this.enableLogs)  console.warn('No school options found.');
                }
                this.checkInputsValidity();
            })
            .catch(error => {
                if (this.enableLogs)  console.error('Error fetching school options:', error);
                this.schoolOptions = [
                    { value: 'default', label: 'No school is found in this zip code?' }
                ]; 
                this.checkInputsValidity();
            });
             
    }

    handleSchoolSelect(event) {
        //const selectSchool = event.target.value;
        const selectSchool = event.target.dataset.value
        this.selectSchool = selectSchool;
        if (selectSchool === 'default') {
            this.showNewRegistrationForm = true;
            this.schoolEmail = this.schoolEmail;
            this.selectedZipCode = "I don't see my school";
            this.companySchoolAddress = `${this.firstName} ${this.lastName}, ${this.schoolEmail}, ${this.selectedZipCode}`;
            this.showSchoolDetails = false; // Show school details with user-entered values
            this.disableVerify = true;
            this.isregiter = false;
            this.IsAccountTypeValid = false;
            this.isregistereduser = false
            this.showSchoolNotFoundError = true;
            this.showEmailError = false;
            this.showFirstNameError = false;
            this.showLastNameError = false;
            this.emailError = '';
            this.isnotvalidcontact = false
            this.firstNameError = '';
            this.LastNameError = '';
            this.firstPageheading = true;
            //this.isEmailDisabled=true;
            this.hideSelectSchool = true; // Hide the 'Select School' dropdown
            this.checkInputsValidity();
            setTimeout(() => {
                this.template.querySelector('.school-not-found-submit-case-link').focus();
            }, 100);
        } else {
            const selectedOption = this.schoolOptions.find(option => option.value === selectSchool);
            if (selectSchool) {
                this.fetchBuildingAddress(selectSchool);
                this.companySchoolAddress = this.selectedSchoolAddress; // Replace with actual school address
                this.schoolEmail = this.schoolEmail; // Clear email field for selected school
                this.selectedZipCode = this.selectedZipCode; // Clear zip code field for selected school
                this.showSchoolDetails = true;
                this.disableVerify = true;
                this.showSchoolNotFoundError = false;
                this.showEmailError = false;
                this.emailError = '';
                this.isregiter = false;
                this.firstPageheading = true;
                this.hideSelectSchool = true; // Hide the 'Select School' dropdown
                this.checkInputsValidity();
                setTimeout(() => {
                    this.template.querySelector('[data-id="schoolZipCode"]').focus();
                }, 100);
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

    // Call the Apex method to fetch building address based on selected school ID
    fetchBuildingAddress(selectSchool) {
        getBuildingAddress({ accountId: selectSchool })
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
               if (this.enableLogs)   console.error('Error fetching building address:', error);

            });
    }

    handleCaseSubmission() {
        const params = {
            firstName: this.firstName,
            lastName: this.lastName,
            schoolEmail: this.schoolEmail,
            selectedZipCode: this.selectedZipCode,
            companySchoolName: this.companySchoolName,
            description: this.moreThanOneSchoolDescription,
            street: this.street,
            city: this.city,
            state: this.state,
            postalCode: this.postalCode,
            country: this.country,
            isContactValid: this.verificationResult.isContactValid,
            isAccountValid: this.verificationResult.isAccountValid,
            message: this.verificationResult.message
        };

        sendEmailtoCaseForMoreThanOneEmailId(params)
            .then(result => {
                if (result) {

                    this.showCreateCaseforMoreThanOneEmailLabel = true;

                } else {
                    if (this.enableLogs)  console.error('Failed to send email for account mismatch');

                }
            })
            .catch(error => {
                if (this.enableLogs)  console.error('Error in handleCaseSubmission:', error);

            });
    }

    verifyUserRegistration() {
        const params = {
            firstName: this.firstName,
            lastName: this.lastName,
            schoolEmail: this.schoolEmail,
            selectedZipCode: this.selectedZipCode,
            companySchoolName: this.companySchoolName
        };
        if (this.enableLogs)  console.log("verifyuserregistration----", params);


        verifyRegistration(params)
            .then(result => {
                this.verificationResult = result;
                if (this.enableLogs)  console.log(result);
                if (result) {

                    if (result.isContactValid && result.isAccountValid && result.isUserValid) {
                        this.showNewRegistrationForm = true;
                        this.showFirstNameLastName = true;
                        this.showemailzipcode = true;
                        this.isregistereduser = true;
                        this.isnotvalidcontact = false
                        this.IsAccountTypeValid = false;
                        this.schoolEmail = this.schoolEmail; // Keep the user-entered email
                        this.selectedZipCode = this.selectedZipCode; // Keep the user-entered zip code
                        this.companySchoolAddress = `${this.firstName} ${this.lastName}, ${this.schoolEmail}, ${this.selectedZipCode}`; // Populate with user details
                        this.disableVerify = true; // Disable verify button
                        this.firstPageheading = false;
                        this.isregiter = false;
                        this.verificationResult = 'User is already registered. Please sign in or reset your password.';
                        setTimeout(() => {
                            this.template.querySelector('.alreadyReg-newSignIn').focus();
                        }, 100);
                    } else if ((!result.isContactValid || !result.isAccountValid) && !result.IsaccountTypenotincluded) {

                        this.showNewRegistrationForm = true;
                        this.showSchoolDetails = true
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
                        this.isregistereduser = false
                        this.hideSelectSchool = true; // Hide the 'Select School' dropdown
                        this.isnotvalidcontact = true
                        this.IsAccountTypeValid = false;
                        this.firstPageheading = false;
                        this.isregiter = false;
                        //  this.isnotvalidcontact = true;
                        this.disableButton = false;
                        setTimeout(() => {
                            this.template.querySelector('.not-a-valid-contact-submit-case').focus();
                        }, 100);
                    }
                    else if (result.IsaccountTypenotincluded) {
                        this.IsAccountTypeValid = true;
                        this.showNewRegistrationForm = true;
                        this.showSchoolDetails = true
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
                        this.isregistereduser = false
                        this.hideSelectSchool = true; // Hide the 'Select School' dropdown
                        this.isnotvalidcontact = false;

                        this.firstPageheading = false;
                        this.isregiter = false;
                        //  this.isnotvalidcontact = true;
                        this.disableButton = false;
                        setTimeout(() => {
                            this.template.querySelector('.not-a-valid-contact-submit-case').focus();
                        }, 100);
                    }

                    else {
                        this.isNouser = true;
                        this.isalways = false
                        this.isregiter = true;
                        this.isregistereduser = false;
                        this.isRegistrationEnabled = false;
                        this.showNewRegistrationForm = false;
                        this.showSchoolDetails = false
                        this.isAccesstype = true
                        this.firstPageheading = false;
                        this.showFirstNameLastName = false;
                        this.showemailzipcode = false;

                        this.disableVerify = false;


                        this.showSchoolNotFoundError = false;
                        this.showEmailError = false;
                        // this.emailError = '';
                        this.hideSelectSchool = true; // Hide the 'Select School' dropdown
                        this.isnotvalidcontact = false
                        setTimeout(() => {
                            this.template.querySelector('.selfRegister-form').scrollTo({ top: 0, behavior: 'smooth' });
                            this.template.querySelector('.access-type-checkbox-group').focus();
                        }, 100);
                    }

                }
            })

            .catch(error => {

                // Handle error
            });

    }


    checkboxOptions = [
        { label: 'Place orders', value: 'option1' },
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
        this.firstPageheading = true;
        this.isZipCodeDisabled = false;
        this.isAccesstype = false;
        this.isregiter = false;
        this.dispatchEvent(new RefreshEvent());


        this.signInUrl = window.location.origin + this.loginUrl;

        event.preventDefault();
        // Redirect to the sign-in URL
        window.location.href = this.signInUrl;

    }
    validateEmail() {
        const emailRegex = /.+@.+\..+/;
        return emailRegex.test(this.email);

    }

    // checkInputsValidity() { // commented due to  some additional validations code not removed for reference purpose 

    //     if (this.selectSchool === 'default') {

    //         // If the default school ID is selected, disable the verify button
    //         this.disableVerify = true;
    //     } else {
    //         // For other school selections, check the validity of other inputs
    //         this.disableVerify = !(
    //             this.firstName.trim() &&
    //             this.lastName.trim() &&
    //             this.validateEmail(this.schoolEmail) &&
    //             this.selectedZipCode.length === 5
    //         );
    //     }
    // }
    checkInputsValidity() {
   
    const isFirstNameValid = this.firstName.trim() !== '';
    const isLastNameValid = this.lastName.trim() !== '';
    const isEmailValid = this.validateEmail(this.schoolEmail);
    const isZipCodeValid = this.selectedZipCode.length >= 5;

    
    const isSchoolSelected = this.selectSchool && this.selectSchool !== 'default';
    
    this.disableVerify = !(
        isFirstNameValid &&
        isLastNameValid &&
        isEmailValid &&
        isZipCodeValid &&
        isSchoolSelected
    );    
}


    @track IsExistedUser = false;

    registerVerify() {
        this.isRegistrationEnabled = true;
        if (this.enableLogs)  console.log("registerVerify verificationResult list ", this.verificationResult);
        let response = this.verificationResult;
        if (this.verificationResult.isPermissionUpdated) {
            this.IsExistedUser = true
        }
        if (this.verificationResult.isContactValid && this.verificationResult.isAccountValid && (this.verificationResult.isNewUser || this.verificationResult.isPermissionUpdated)) {
            createUser({ response: this.verificationResult })
                .then(result => {
                   if (this.enableLogs)   console.log("result result result ", result);
                    if (result.includes('failed')) {

                        this.showNewRegistrationForm = true;
                        this.showSchoolDetails = true
                        this.showFirstNameLastName = true;
                        this.schoolEmail = this.schoolEmail;
                        this.selectedZipCode = this.selectedZipCode;
                        this.companySchoolAddress = `${this.firstName} ${this.lastName}, ${this.schoolEmail}, ${this.selectedZipCode}`;
                        this.disableVerify = true;
                        this.showSchoolNotFoundError = false;
                        this.showEmailError = false;
                        this.emailError = '';
                        this.isregistereduser = false
                        this.hideSelectSchool = true;
                        this.isnotvalidcontact = true
                        this.IsAccountTypeValid = false;
                        this.firstPageheading = false;
                        this.isregiter = false;
                        this.disableButton = false;
                        this.isNouser = false;
                        this.isalways = true
                        this.isRegistrationEnabled = true;
                        this.showNewRegistrationForm = true;
                        this.showSchoolDetails = true
                        this.isAccesstype = false
                        this.showemailzipcode = true;
                        this.showFirstNameLastName = true;
                        this.disableVerify = true;
                        this.registredsuccessfull = false
                        setTimeout(() => {
                            this.template.querySelector('.not-a-valid-contact-submit-case').focus();
                        }, 100);
                    }
                    else {
                        this.isregiter = false;
                        this.isAccesstype = false;
                        this.registredsuccessfull = true;
                        this.isNouser = false;
                        this.isHeaders = false;
                        setTimeout(() => {
                            this.template.querySelector('.good-news-success-close-btn').focus();
                        }, 100);
                    }
                })
                .catch(error => {
                    if (this.enableLogs)  console.error('Error creating user:', error);
                });
        } else {

            this.showNewRegistrationForm = true;
            this.showSchoolDetails = true
            this.showFirstNameLastName = true;
            this.schoolEmail = this.schoolEmail;
            this.selectedZipCode = this.selectedZipCode;
            this.companySchoolAddress = `${this.firstName} ${this.lastName}, ${this.schoolEmail}, ${this.selectedZipCode}`;
            this.disableVerify = true;
            this.showSchoolNotFoundError = false;
            this.showEmailError = false;
            this.emailError = '';
            this.isregistereduser = false
            this.hideSelectSchool = true;
            this.isnotvalidcontact = true
            this.IsAccountTypeValid = false;
            this.firstPageheading = false;
            this.isregiter = false;
            this.disableButton = false;
            setTimeout(() => {
                this.template.querySelector('.not-a-valid-contact-submit-case').focus();
            }, 100);
        }
    }

    handlePopupCancelKeyPress(event) {
        if (event.key === 'Enter') {
            this.PopupCancel();
        }
    }

    handleClose(event) {
        this.signInUrl = window.location.origin + this.loginUrl;
        event.preventDefault();
        // Redirect to the sign-in URL
        window.location.href = this.signInUrl;
        // this.registredsuccessfull = false;
        document.body.style.overflow = 'auto';
        this.selectedcheckboxs = this.selectedcheckboxs.filter(option => option !== 'option1');

        setTimeout(() => {
            if (this.template.querySelector('.access-type-checkbox-group')) {
                this.template.querySelector('.access-type-checkbox-group').focus();
            }
        }, 100);

    }
    PlaceorderConfirm() {
        // Handle confirm button click
        this.showPopup = false; // Close the popup
        document.body.style.overflow = 'auto';
        this.confirmButtonClicked = true;
        this.verificationResult.orderingEnabled = true;
    }
    PopupCancel() {
        // Handle cancel logic here
        this.showPopup = false; // Close the popup
        document.body.style.overflow = 'auto';
        // Deselect the "Place Orders" checkbox
        this.selectedcheckboxs = this.selectedcheckboxs.filter(option => option !== 'option1');
        this.verificationResult.orderingEnabled = false;
        //this.selectedcheckboxs = this.selectedcheckboxs.filter(option => option !== 'option1');
        setTimeout(() => {
            this.template.querySelector('.access-type-checkbox-group').focus();
        }, 100);
    }
    handleSignInClick(event) {
        this.signInUrl = window.location.origin + this.loginUrl;
        event.preventDefault();
        // Redirect to the sign-in URL
        window.location.href = this.signInUrl;

    }
    // added by sudha 
    handleresetYourPassword(event) {
        event.preventDefault();
        const baseUrl = window.location.origin
        // const resetUrl = `${baseUrl}${resetpurl}`;
        const resetUrl = window.location.origin + this.resetpurl;
        window.location.href = resetUrl;
    }
    @track terms = '/MySavvasOrders/terms-and-conditions';
    @track privacy = '/MySavvasOrders/privacy';
    get dynamicprivacy() {
        const baseUrl = window.location.origin;
        return baseUrl + this.privacy;
    }
    get dynamicurl() {
        const baseUrl = window.location.origin;
        return baseUrl + this.terms;
    }
    handleCaseSubmission(event) {

        this.showCreateCaseforMoreThanOneEmail = true;
        this.disableButton = false;
    }

    RegisterCancel(event) {
        this.signInUrl = window.location.origin + this.loginUrl;
        event.preventDefault();
        // Redirect to the sign-in URL
        window.location.href = this.signInUrl;
    }

    openModal() {
        this.showCreateCaseforMoreThanOneEmail = true;
    }
    closeModalSchoolNotFound() {
        this.showCreateCaseforSchoolNotFound = false;
        this.showCreateCaseforSchoolNotFoundLabel = false;
        this.disableButton = false;
        setTimeout(() => {
            this.template.querySelector('.school-not-found-submit-case-link').focus();
        }, 100);
    }

    closeModalMoreThanOneEmail() {
        // to close modal set isModalOpen tarck value as false
        this.showCreateCaseforMoreThanOneEmail = false;
        this.showCreateCaseforMoreThanOneEmailLabel = false;
        this.disableButton = false;
        setTimeout(() => {
            this.template.querySelector('.not-a-valid-contact-submit-case').focus();
        }, 100);
    }

    submitDetails() {
        this.showCreateCaseforMoreThanOneEmail = false;
        this.showCreateCaseforMoreThanOneEmailLabel = false;
        this.disableButton = false;
    }

    handleSendEmailtoCaseForMoreThanOneContact(event) {

        this.disableButton = true;
        const params = {
            firstName: this.firstName,
            lastName: this.lastName,
            schoolEmail: this.schoolEmail,
            selectedZipCode: this.selectedZipCode,
            companySchoolName: this.companySchoolName,
            description: this.moreThanOneSchoolDescription,
            street: this.street,
            city: this.city,
            state: this.state,
            postalCode: this.postalCode,
            country: this.country,
            isContactValid: this.verificationResult.isContactValid,
            isAccountValid: this.verificationResult.isAccountValid,
            message: this.verificationResult.message
        };
        this.disableButton = true;
        sendEmailtoCaseForMoreThanOneEmailId(params)
            .then(result => {
                this.verificationResult = result;
                if (result) {
                    this.showCreateCaseforMoreThanOneEmail = true;
                    this.showCreateCaseforMoreThanOneEmailLabel = true; // Added this line
                    this.disableButton = true;

                    setTimeout(() => {
                        this.template.querySelector('.morethanoneemail-submitcase-popup-close').focus();
                    }, 100);
                }
            })
            .catch(error => {

            });
    }

    showModalForSchoolNotFound() {

        if (this.firstName == '' || this.firstName == undefined) {
            this.firstNameError = 'Please enter first name';
            this.showFirstNameError = true;
        } else {
            this.firstNameError = '';
            this.showFirstNameError = false;
        }

        if (this.lastName == '' || this.lastName == undefined) {
            this.LastNameError = 'Please enter last name';
            this.showLastNameError = true;
        } else {
            this.LastNameError = '';
            this.showLastNameError = false;
        }

        if (this.schoolEmail == '' || this.schoolEmail == undefined) {
            this.emailError = 'Please enter Email';
            this.showEmailError = true;
        } else {
            this.emailError = '';
            this.showEmailError = false;
        }

        if (!this.showFirstNameError && !this.showLastNameError && !this.showEmailError) {
            this.showCreateCaseforSchoolNotFound = true;
            this.disableButton = true;
            setTimeout(() => {
                this.template.querySelector('.schoolnotfound-submitcase-popup-close').focus();
            }, 100);
        }

    }
    handleSendEmailtoCaseForNoSchoolFound(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.showCreateCaseforSchoolNotFound = true;
            this.disableButton = true;

            const params = {
                firstName: this.firstName,
                lastName: this.lastName,
                schoolEmail: this.schoolEmail,
                selectedZipCode: this.selectedZipCode,
                companySchoolName: this.companySchoolName,
                description: this.noSchoolFoundDescription,
                address: this.schoolAddress,
            };
            this.disableButton = true;
            sendEmailtoCaseForSchoolNotFound(params)
                .then(result => {
                    this.verificationResult = result;

                    if (result) {
                        this.showCreateCaseforSchoolNotFoundLabel = true;
                        this.disableButton = true;
                    }
                })
                .catch(error => {
                    // Handle error
                });
        }
    }


    handleNoSchoolFoundDescChange(event) {
        this.noSchoolFoundDescription = event.target.value;
        if (this.noSchoolFoundDescription == '' || this.noSchoolFoundDescription == undefined
        ) {
            this.schoolDetailsEntered = false;

        } else {
            this.schoolDetailsEntered = true;
            if (this.schoolDetailsEntered == true &&
                this.schoolAddressEntered == true &&
                this.schoolNameEntered == true
            ) {
                this.disableButton = false;
            } else {
                this.disableButton = true;
            }
        }
    }

    handleMoreThanOneEmailDescChange(event) {
        this.moreThanOneSchoolDescription = event.target.value;
    }

    handleAddressChange(event) {
        this.schoolAddress = event.target.value;
        if (this.schoolAddress == '' || this.schoolAddress == undefined) {
            this.schoolAddressEntered = false;

        } else {
            this.schoolAddressEntered = true;
            if (this.schoolDetailsEntered == true &&
                this.schoolAddressEntered == true &&
                this.schoolNameEntered == true
            ) {
                this.disableButton = false;
            } else {
                this.disableButton = true;
            }
        }

    }

    handleSchoolNameChange(event) {
        this.companySchoolName = event.target.value;
        if (this.companySchoolName == '' || this.companySchoolName == undefined) {
            this.schoolNameEntered = false;

        } else {
            this.schoolNameEntered = true;
            if (this.schoolDetailsEntered == true &&
                this.schoolAddressEntered == true &&
                this.schoolNameEntered == true
            ) {
                this.disableButton = false;
            } else {
                this.disableButton = true;
            }
        }

    }
    //Trap focus inside modal
    focusOutClose(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.confirm-purchase-auth-cancel-btn').focus();
            }
        }
    }
    focusOutButton(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.confirm-purchase-auth-close-btn').focus();
            }
        }
    }
    focusOutGoodNewsButton() {
        this.template.querySelector('.good-news-success-close-btn').focus();
    }
    focusOutGoodNewsClose() {
        this.template.querySelector('.good-news-success-gotosignIn-btn').focus();
    }
    focusOutMoreThanOneEmailClose(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.moreThanOneEmailPopupSubmitBtn').focus();
            }
        }
    }
    focusOutMoreThanOneEmailButton(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.morethanoneemail-submitcase-popup-close').focus();
            }
        }
    }
    focusOutSchoolNotFoundClose(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.schoolNotFoundPopupSubmitBtn').focus();
            }
        }
    }
    focusOutSchoolNotFoundButton(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.schoolnotfound-submitcase-popup-close').focus();
            }
        }
    }

    //handle Arrow key navgation
    handleKeyNavigation(event) {
        const items = this.template.querySelectorAll('.dropdown-item');
        let index = Array.from(items).indexOf(event.target);

        if (event.key === 'ArrowDown') {
            index = (index + 1) % items.length;
        } else if (event.key === 'ArrowUp') {
            index = (index - 1 + items.length) % items.length;
        }
        items[index].focus();
    }
    handlezipfocus() {
        this.zipCodeError = '';
        this.showZipCodeError = false;
    }

}