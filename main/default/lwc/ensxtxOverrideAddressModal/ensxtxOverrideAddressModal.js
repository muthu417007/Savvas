import LightningModal from 'lightning/modal';
import { api } from 'lwc';
import loadCountries from '@salesforce/apex/ensxtx_CTRL_OverrideAddress.loadCountries';
import ensxtx_Common_Loading from '@salesforce/label/c.ensxtx_Common_Loading';
import ensxtx_OverrideAddress_Button_Cancel from '@salesforce/label/c.ensxtx_OverrideAddress_Button_Cancel';
import ensxtx_OverrideAddress_Button_Save from '@salesforce/label/c.ensxtx_OverrideAddress_Button_Save';
import ensxtx_OverrideAddress_Field_City from '@salesforce/label/c.ensxtx_OverrideAddress_Field_City';
import ensxtx_OverrideAddress_Field_Country from '@salesforce/label/c.ensxtx_OverrideAddress_Field_Country';
import ensxtx_OverrideAddress_Field_HouseNumber from '@salesforce/label/c.ensxtx_OverrideAddress_Field_HouseNumber';
import ensxtx_OverrideAddress_Field_PartnerName from '@salesforce/label/c.ensxtx_OverrideAddress_Field_PartnerName';
import ensxtx_OverrideAddress_Field_PartnerName2 from '@salesforce/label/c.ensxtx_OverrideAddress_Field_PartnerName2';
import ensxtx_OverrideAddress_Field_PostalCode from '@salesforce/label/c.ensxtx_OverrideAddress_Field_PostalCode';
import ensxtx_OverrideAddress_Field_Region from '@salesforce/label/c.ensxtx_OverrideAddress_Field_Region';
import ensxtx_OverrideAddress_Field_Street from '@salesforce/label/c.ensxtx_OverrideAddress_Field_Street';
import ensxtx_OverrideAddress_Title_Address from '@salesforce/label/c.ensxtx_OverrideAddress_Title_Address';

export default class EnsxtxOverrideAddressModal extends LightningModal {
    @api partnerFunction;
    @api partnerFunctionName;
    @api partner;
    @api optionValuesToInclude;

    isLoading = false;

    get PartnerName() {
        return this.modifiedPartner.PartnerName;
    }
    set PartnerName(value) {
        this.modifiedPartner.PartnerName = value;
    }

    get PartnerName2() {
        return this.modifiedPartner.PartnerName2;
    }
    set PartnerName2(value) {
        this.modifiedPartner.PartnerName2 = value;
    }
    
    get HouseNumber() {
        return this.modifiedPartner.HouseNumber;
    }
    set HouseNumber(value) {
        this.modifiedPartner.HouseNumber = value;
    }
    
    get Street() {
        return this.modifiedPartner.Street;
    }
    set Street(value) {
        this.modifiedPartner.Street = value;
    }
    
    get City() {
        return this.modifiedPartner.City;
    }
    set City(value) {
        this.modifiedPartner.City = value;
    }
    
    get Country() {
        return this.modifiedPartner.Country;
    }
    set Country(value) {
        this.modifiedPartner.Country = value;
    }
    
    get Region() {
        return this.modifiedPartner.Region;
    }
    set Region(value) {
        this.modifiedPartner.Region = value;
    }

    get PostalCode() {
        return this.modifiedPartner.PostalCode;
    }
    set PostalCode(value) {
        this.modifiedPartner.PostalCode = value;
    }
    
    messages = [];
    title;
    allCountries = [];
    allRegions = [];
    countryOptions = [];
    regionOptions = [];
    modifiedPartner = {};

    customLabel = {
        ensxtx_Common_Loading,
        ensxtx_OverrideAddress_Button_Cancel,
        ensxtx_OverrideAddress_Button_Save,
        ensxtx_OverrideAddress_Field_City,
        ensxtx_OverrideAddress_Field_Country,
        ensxtx_OverrideAddress_Field_HouseNumber,
        ensxtx_OverrideAddress_Field_PartnerName,
        ensxtx_OverrideAddress_Field_PartnerName2,
        ensxtx_OverrideAddress_Field_PostalCode,
        ensxtx_OverrideAddress_Field_Region,
        ensxtx_OverrideAddress_Field_Street,
        ensxtx_OverrideAddress_Title_Address
    };

    formatString(string, params) {
        return string.replace(/{(\d+)}/g, (match, index) => {
            return typeof params[index] !== 'undefined' ? params[index] : match;
        });
    }

    async connectedCallback() {
        if (this.partner) this.modifiedPartner = {...this.partner};
        this.title = this.formatString(this.customLabel.ensxtx_OverrideAddress_Title_Address, 
            [this.partnerFunctionName]);
        this.getCountries();
    }

    getCountries () {
        this.isLoading = true;
        return loadCountries()
            .then((result) => {
                if (result) {
                    this.messages = result.messages.map((message, index) => ({...message, key: index}));
                    if (result.data) {
                        if (result.data.ET_OUTPUT_List) {
                            this.allCountries = result.data.ET_OUTPUT_List.filter(item => item.LAND1);
                            this.countryOptions = [];
                            this.allCountries.filter(country=> !this.optionValuesToInclude?.Country?.length > 0 || 
                                this.optionValuesToInclude?.Country.filter(include=>
                                    include==country.LAND1).length > 0).forEach(country => 
                                    {this.countryOptions.push({ label: country.LANDX, value: country.LAND1 });
                            });
                            if (result.data.ET_REGIONS_List) this.allRegions = result.data.ET_REGIONS_List;
                            this.setRegions();
                        }
                    }
                }
                this.isLoading = false;
            })
            .catch((err) => {
                console.log('loadCountries error', err);
                let message = err?.body?.message ? err.body.message : JSON.stringify(err);
                this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
                this.isLoading = false;
            });
    }
    
    setRegions() {
        if (this.Country) {
            this.regionOptions = [];
            this.allRegions.filter(region=> region.LAND1 === this.Country).forEach(region => {
                this.regionOptions.push({ label: region.BEZEI, value: region.REGIO });
            });
        }
    }

    onChange(event) {
        if (event.target.name == 'Country') {
            this.Country = event.target.value;
            this.setRegions();
        }
    }

    onSave() {
        this.template.querySelectorAll('lightning-input').forEach(currentItem => {
            this.modifiedPartner[currentItem.name] = currentItem.value;
        });
        this.template.querySelectorAll('lightning-combobox').forEach(currentItem => {
            this.modifiedPartner[currentItem.name] = currentItem.value;
        });
        this.modifiedPartner.isOverrideAddress = true;
        this.close({action: 'Save', partner: this.modifiedPartner});
    }

    onCancel() {
        this.close({action: 'Cancel'});
    }
}