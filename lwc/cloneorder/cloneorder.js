import { LightningElement,track, wire, api } from 'lwc';
import getAllowDropShip from '@salesforce/apex/scc_confirmAddress.getAllowDropShip';
import callCloneOrderFunction from '@salesforce/apex/scc_cloneOrderController.cloneOrderController';
import getRelatedShippingAddress from '@salesforce/apex/scc_cloneOrderController.getCurrentUserShippingAddress';
import checkRestrictedCartItems from '@salesforce/apex/scc_cloneOrderController.checkRestrictedCartItems';
import checkSchoolDistrict from '@salesforce/apex/scc_cloneOrderController.checkSchoolDistrict';
import imageIcons from '@salesforce/resourceUrl/scc_Images';

//import getRelatedShippingAddress from '@salesforce/apex/scc_checkOutLWC_Controller.getCurrentUserShippingAddress';
export default class Cloneorder extends LightningElement {
    @track openCloneModal = false;
    @track selectedAccountId;
    @track totalShipToRecords = 0;
    @track userInputs = [];
    @track searchTermShip ='';
    @track Shipaddress;
    @track lengthShipAddress;
    @track selectedShip;
    @track sName;
    @track shippingCity = '';
    @track shippingCountry = '';
    @track shippingState = '';
    @track shippingStreet = '';
    @track shippingZip = '';
    @track ShippingToNumber;
    @track addressNotSelected = true;
    @track allowDropShip= false;
    @track searchter= '';
    @track isChecked = false;
    @track showAvailableShipping = true;
    @track lengthShipAddress;
    @track selectedShipAddress = false;
    @track isRestrictedItem = false;
    @api cartId = '';
    crossIconUrl = imageIcons + '/Images/cross.png';
    lockIconUrl = imageIcons + '/Images/Lock.png';lockIconUrl = imageIcons + '/Images/Lock.png';

    
    @wire(getAllowDropShip)
    wiredAllowDropShip({ error, data }) {
    if (data) { 
         console.log('data from getAllowDropShip ',data);
        this.allowDropShip= data;
        console.log('getAllowDropShip ',this.allowDropShip);
    } else if (error) {
          console.log('error in getAllowDropShip ',error);
        this.error = error;

    }
    }

    @wire(checkRestrictedCartItems, {cartId:'$cartId'})
     getRestrictedItems({data, error}){
        console.log('checkRestrictedCartItems ');
         if(data){
             this.isRestrictedItem = data;
            console.log('checkRestrictedCartItems ',data);
        }
        else if(error){
            console.log('checkRestrictedCartItems error',error);
        }
        else{
            this.isRestrictedItem = data;
            console.log('checkRestrictedCartItems ',data);
        }
     }

    clearFilterInput(){
         this.searchTermShip = '';
    }

     
    filteredresultt;
      closeModal1() {
        this.openCloneModal = false;
        this.closeModal = true;
        this.selectedShipAccountId = '';
    }

       handleCloneClick() {
        this.openCloneModal = true;
        this.closeModal = false;
        this.loadRelatedShipping();
    }
    loadRelatedShipping() {
        // console.log('im in the loadrelatedshipaddress',AccountId);
        getRelatedShippingAddress()
            .then(result => {
                this.Shipaddress = result;
                console.log('result of load related ship address is', this.Shipaddress);
                this.applyFilterss();
                this.selectedShip = result[0];
                this.loadSingleShipaddress(this.selectedShip.AccShipId);
                console.log('im in the loadrelatedshipaddress result', this.Shipaddress);
                console.log('im in the 2st');

            })
            .catch(error => {
                this.cases = undefined;
                this.caseError = error;
            });
    }
     handleUserInputsShip(event) {
        this.searchTermShip = event.target.value.toLowerCase();
        console.log('userinputs', this.searchTerm);
        this.applyFilterss();
    }

    applyFilterss() {
        if (!this.Shipaddress) {
            this.filteredresultt = this.Shipaddress;
            return;
        }
        this.searchter = this.searchTermShip;
        console.log('the value coming in ship filter is', this.Shipaddress, 'value in the ship search term is', this.searchter)
        this.filteredresultt = this.Shipaddress.filter(Shipaddresss => {
            const shipAccName = Shipaddresss.SAccountName;
            const shipPostalCode = Shipaddresss.PostalCode;
            if (shipAccName == undefined && shipAccName == '' && shipPostalCode == undefined && shipPostalCode == '') {
                console.log('im in the 1st condition of ship filter');
                return;
            }
            if (shipAccName !== undefined && shipAccName !== '' && shipPostalCode !== undefined && shipPostalCode !== '') {
                console.log('im in the 2nd condition of ship filter');

                return (
                    (Shipaddresss.SAccountName.toLowerCase().includes(this.searchter))
                    || (Shipaddresss.PostalCode.toLowerCase().includes(this.searchter))

                );
            }
            if ((shipAccName != undefined && shipAccName != '') && (shipPostalCode == undefined || shipPostalCode == '')) {
                console.log('im in the 3rd condition of ship filter');
                return (
                    (Shipaddresss.SAccountName.toLowerCase().includes(this.searchter))

                );
            }
            if ((shipAccName == undefined || shipAccName == '') && (shipPostalCode != undefined && shipPostalCode != '')) {
                console.log('im in the 4th condition of ship filter');
                return (
                    (Shipaddresss.PostalCode.toLowerCase().includes(this.searchter))

                );
            }
            console.log('end of the ship filter', this.filteredresultt);

        });
        console.log('filtered list is', this.filteredresultt);
        this.lengthShipAddress = this.filteredresultt.length;
        this.totalShipToRecords = this.lengthShipAddress;

    }
     handlecheckboxChange(event) {
        this.isChecked = event.target.checked;
        console.log('im in the handel check box ', this.isChecked)
        if (this.isChecked == true) {
             this.showAvailableShipping = false;
              this.addressNotSelected = false;
              this.totalShipToRecords = 0 ;
        }else{
             this.showAvailableShipping = true;
             this.totalShipToRecords = this.lengthShipAddress;
             if(this.selectedShipAddress == true){
                 this.addressNotSelected = false;
             }else{
                 this.addressNotSelected = true;
             }
        }}
        renderedCallback(){
                if (this.selectedAccountId) {
        const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
        shippingInputs.forEach(input => {
            if (input.value === this.selectedAccountId) {
                input.checked = true;
            }
        });
    }
        }
        handleShipRowClick(event) {
        this.selectedShipAddress = true;
        this.selectedAccountId = event.currentTarget.dataset.recordId;
        this.addressNotSelected = false;
        if(this.isRestrictedItem){
            checkSchoolDistrict({accountId:this.selectedAccountId})
            .then(result=>{
                console.log('checkSchoolDistrictResult ',result);
                if(result){
                    this.addressNotSelected = true;
                }
                else{
                    this.addressNotSelected = false;
                }
            })
            .catch(error=>{
                console.log('checkSchoolDistrictError ',error);
            })
        }
        console.log('address Name',event.target.dataset.addressName);
        console.log('address City',event.target.dataset.addressCity);
        console.log('address Street',event.target.dataset.addressStreet);
        console.log('address provionce',event.target.dataset.addressProvionce);
        console.log('address Postal Code',event.target.dataset.addressPostalCode);
        console.log('address Country',event.target.dataset.addressCountry);
        console.log('address ShipToNumber',event.target.dataset.addressShipToNumber);
        
        this.sName = event.target.dataset.addressName;
        this.shippingStreet = event.target.dataset.addressStreet;
        this.shippingCity = event.target.dataset.addressCity;
        this.shippingState = event.target.dataset.addressProvionce;
        this.shipCountry = event.target.dataset.addressCountry;
        this.shippingZip = event.target.dataset.addressPostalCode;
        this.selectedShipAccountId = event.currentTarget.dataset.recordId;
        this.ShippingToNumber =  event.currentTarget.dataset.addressShiptonumber;

        // this.isChecked = false;
         this.isChangeAddDisabled = false;

        //this.selectedAccount=accountId;
        console.log('im in the 2nd handle click', this.selectedShipAccountId);
        console.log('change address button', this.isChangeAddDisabled);
    }
    handleUpdateCloneOrder(){
          const item = {
            sapUserShip: this.ShippingToNumber,
            oneTimeShip: this.isChecked,
            shipAddressId: this.selectedShipAccountId,
            shipCountry:this.shippingCountry,
            shipStreet:this.shippingStreet,
            shipCity:this.shippingCity,
            shipState:this.shippingState,
            shipZipCode:this.shippingZip
        };
        this.userInputs = [...this.userInputs, item];
        if (this.isChecked == true) {
             this.userInputs =[] ;
        }

        callCloneOrderFunction({ currentcartId: '0a6W40000001KMTIA2',userInputs:this.userInputs })
        .then(result => {
            console.log('result is',result);

    })
    .catch(error => {
            this.cases = undefined;
            this.caseError = error;
        });


}
}