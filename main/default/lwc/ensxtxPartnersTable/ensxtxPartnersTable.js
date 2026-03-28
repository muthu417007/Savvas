import { LightningElement, api } from 'lwc';
import ensxtx_PartnersTable_Button_OverrideAddress from '@salesforce/label/c.ensxtx_PartnersTable_Button_OverrideAddress';
import ensxtx_PartnersTable_Button_Search from '@salesforce/label/c.ensxtx_PartnersTable_Button_Search';
import ensxtx_PartnersTable_Description_Contact from '@salesforce/label/c.ensxtx_PartnersTable_Description_Contact';
import ensxtx_PartnersTable_Description_ShipTo from '@salesforce/label/c.ensxtx_PartnersTable_Description_ShipTo';
import ensxtx_PartnersTable_Description_SoldTo from '@salesforce/label/c.ensxtx_PartnersTable_Description_SoldTo';
import ensxtx_PartnersTable_Table_ContactPerson from '@salesforce/label/c.ensxtx_PartnersTable_Table_ContactPerson';
import ensxtx_PartnersTable_Table_EmailAddress from '@salesforce/label/c.ensxtx_PartnersTable_Table_EmailAddress';
import ensxtx_PartnersTable_Table_PartnerFunction from '@salesforce/label/c.ensxtx_PartnersTable_Table_PartnerFunction';
import ensxtx_PartnersTable_Table_PartnerName from '@salesforce/label/c.ensxtx_PartnersTable_Table_PartnerName';
import ensxtx_PartnersTable_Table_PartnerNumber from '@salesforce/label/c.ensxtx_PartnersTable_Table_PartnerNumber';
import ensxtx_PartnersTable_Table_Personnel from '@salesforce/label/c.ensxtx_PartnersTable_Table_Personnel';
import ensxtx_PartnersTable_Table_TelePhoneNumber from '@salesforce/label/c.ensxtx_PartnersTable_Table_TelePhoneNumber';
import ensxtx_PartnersTable_Table_Vendor from '@salesforce/label/c.ensxtx_PartnersTable_Table_Vendor';
import PartnerSearchModal from 'c/ensxtxPartnerSearchModal';
import CustomerSearchModal from 'c/ensxtxCustomerSearchModal';
import OverrideAddressModal from 'c/ensxtxOverrideAddressModal';

export default class EnsxtxPartnersTable extends LightningElement {
    @api soldToParty;
    @api appSettings;
    @api fieldSettings;
    @api fieldSettingsPartnerSearch;
    @api fieldSettingsCustomerSearch;
    @api partners;
    @api allPartners;
    @api salesArea;
    @api salesOrg;
    @api distChannel;
    @api division;
    @api optionValuesToInclude;
    @api isReadOnly;

    displayedPartners = [];
    displayedFieldSettings = {};

    label = {
        ensxtx_PartnersTable_Button_OverrideAddress,
        ensxtx_PartnersTable_Button_Search,
        ensxtx_PartnersTable_Description_Contact,
        ensxtx_PartnersTable_Description_ShipTo,
        ensxtx_PartnersTable_Description_SoldTo,
        ensxtx_PartnersTable_Table_ContactPerson,
        ensxtx_PartnersTable_Table_EmailAddress,
        ensxtx_PartnersTable_Table_PartnerFunction,
        ensxtx_PartnersTable_Table_PartnerName,
        ensxtx_PartnersTable_Table_PartnerNumber,
        ensxtx_PartnersTable_Table_Personnel,
        ensxtx_PartnersTable_Table_TelePhoneNumber,
        ensxtx_PartnersTable_Table_Vendor
    };
    
    async connectedCallback() {
        this.displayedFieldSettings = {...this.fieldSettings};
        if (!this.displayedFieldSettings.PartnerName) this.displayedFieldSettings.PartnerName = {};
        if (!this.displayedFieldSettings.CustomerNumber) this.displayedFieldSettings.CustomerNumber = {};
        if (!this.displayedFieldSettings.Vendor) this.displayedFieldSettings.Vendor = {};
        if (!this.displayedFieldSettings.PersonnelNumber) this.displayedFieldSettings.PersonnelNumber = {};
        if (!this.displayedFieldSettings.ContactPersonNumber) this.displayedFieldSettings.ContactPersonNumber = {};
        if (!this.displayedFieldSettings.TelePhoneNumber) this.displayedFieldSettings.TelePhoneNumber = {};
        if (!this.displayedFieldSettings.EmailAddress) this.displayedFieldSettings.EmailAddress = {};
        this.displayedPartners = this.partners.map(partner => {
            let displayedPartner = {...partner};
            displayedPartner.partnerFunction = partner.CustomLabel_PartnerFunctionName && partner.CustomLabel_PartnerFunctionName in this.label ? 
                this.label[partner.CustomLabel_PartnerFunctionName] : partner.PartnerFunctionName;
            displayedPartner.PartnerNameDisplay = (partner.PartnerName ? partner.PartnerName : '') + ' ' + 
                (partner.PartnerName2 ? partner.PartnerName2 : '');
            return displayedPartner;
        });
    }

    async onSearch(event) {
        console.log(event);
        let partner = event.target.name;
        if (partner.ComponentType == 'CustomerSearch') {
            let searchParams = {};
            if (partner.SearchType == 'Contact' || partner.SearchType == 'Personnel') searchParams.customerNumber = this.soldToParty;
            let result = await CustomerSearchModal.open({
                size: 'large',
                partnerFunction: partner.PartnerFunction,
                partnerFunctionInternal: partner.PartnerFunctionInternal,
                partnerFunctionName: partner.partnerFunction,
                searchType: partner.SearchType,
                fieldSettings: this.fieldSettingsCustomerSearch,
                isAutoSearch: partner.autoSearch,
                searchParams: searchParams
            })
            .catch((err) => {
                console.log('PartnerSearch modal error', err);
                let message = err?.body?.message ? err.body.message : JSON.stringify(err);
                this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
            });
            console.log(result);
            if (result.action == 'Select') {
                this.addSelectedPartner(result.partner);
            }
        } else {
            let searchParamFields = [
                {
                    sapField: "CustomerNumber",
                    defaultValue: this.soldToParty
                },
                {
                    sapField: "SalesOrganization",
                    defaultValue: this.salesArea?.SalesOrganization ? this.salesArea.SalesOrganization : this.salesOrg
                },
                {
                    sapField: "DistributionChannel",
                    defaultValue: this.salesArea?.DistributionChannel ? this.salesArea.DistributionChannel : this.distChannel
                },
                {
                    sapField: "Division",
                    defaultValue: this.salesArea?.Division ? this.salesArea.Division : this.division
                }
            ];
            let result = await PartnerSearchModal.open({
                size: 'large',
                partnerFunction: partner.PartnerFunction,
                partnerFunctionInternal: partner.PartnerFunctionInternal,
                partnerFunctionName: partner.partnerFunction,
                searchType: partner.SearchType,
                searchParamFields: searchParamFields,
                fieldSettings: this.fieldSettingsPartnerSearch
            })
            .catch((err) => {
                console.log('PartnerSearch modal error', err);
                let message = err?.body?.message ? err.body.message : JSON.stringify(err);
                this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
            });
            console.log(result);
            if (result.action == 'Select') {
                this.addSelectedPartner(result.partner);
            }
        }
    }

    async onOverrideAddress(event) {
        console.log(event);
        let partner = event.target.name;
        let result = await OverrideAddressModal.open({
            size: 'large',
            partnerFunction: partner.PartnerFunction,
            partnerFunctionName: partner.partnerFunction,
            partner: partner,
            optionValuesToInclude: this.optionValuesToInclude
        })
        .catch((err) => {
            console.log('PartnerSearch modal error', err);
            let message = err?.body?.message ? err.body.message : JSON.stringify(err);
            this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
        });
        console.log(result);
        if (result.action == 'Save') {
            this.addSelectedPartner(result.partner);
        }
    }

    addSelectedPartner (selectedPartner)
    {
        if (!selectedPartner.CustomerNumber && 
            !selectedPartner.Vendor && 
            !selectedPartner.PersonnelNumber && 
            !selectedPartner.ContactPersonNumber)
        {
            let customerNumber = this.soldToParty;
            let allPartners = this.allPartners;
            for (let key in allPartners) {
                let partner = allPartners[key];
                if (selectedPartner.PartnerFunction === partner.PartnerFunction && partner.CustomerNumber) {
                    customerNumber = partner.CustomerNumber;
                }
            }
            selectedPartner.CustomerNumber = customerNumber;
        }

        let newPartners = [...this.partners];
        let isFound = false;
        for (let key in this.partners) {
            let partner = {...this.partners[key]};
            if (selectedPartner.PartnerFunction === partner.PartnerFunction) {
                partner.CustomerNumber = selectedPartner.CustomerNumber;
                partner.Vendor = selectedPartner.Vendor;
                partner.ContactPersonNumber = selectedPartner.ContactPersonNumber;
                partner.PersonnelNumber = selectedPartner.PersonnelNumber;
                partner.PartnerName = selectedPartner.PartnerName;
                partner.PartnerName2 = selectedPartner.PartnerName2;
                partner.HouseNumber = selectedPartner.HouseNumber;
                partner.Street = selectedPartner.Street;
                partner.City = selectedPartner.City;
                partner.Region = selectedPartner.Region;
                partner.PostalCode = selectedPartner.PostalCode;
                partner.Country = selectedPartner.Country;
                partner.TelephoneNumber = selectedPartner.TelephoneNumber;
                partner.EmailAddress = selectedPartner.EmailAddress;
                partner.isChanged = selectedPartner.isChanged;
                newPartners[key] = partner;
                isFound = true;
                break;
            }
        }
        if (!isFound) {
            newPartners.push(selectedPartner);
        }
        this.displayedPartners = newPartners.map(partner => {
            let displayedPartner = {...partner};
            displayedPartner.partnerFunction = partner.CustomLabel_PartnerFunctionName && partner.CustomLabel_PartnerFunctionName in this.label ? 
                this.label[partner.CustomLabel_PartnerFunctionName] : partner.PartnerFunctionName;
            displayedPartner.PartnerNameDisplay = (partner.PartnerName ? partner.PartnerName : '') + ' ' + 
                (partner.PartnerName2 ? partner.PartnerName2 : '');
            return displayedPartner;
        });

        const partnerChange = new CustomEvent('partnerchange', {
            bubbles: true,
            composed: true,
            detail: {
                partners: newPartners
            }
        });

        this.dispatchEvent(partnerChange);
    }
}