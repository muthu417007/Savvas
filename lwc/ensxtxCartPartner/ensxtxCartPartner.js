import { api, wire } from 'lwc';
import { CartSummaryAdapter } from 'commerce/cartApi';
import { CheckoutComponentBase, updateContactPointAddress, updateShippingAddress} from 'commerce/checkoutApi';
import getAppsettings from '@salesforce/apex/ensxtx_UTIL_GetAppSettings.getAppsettings';
import getPartner from '@salesforce/apex/ensxtx_CTRL_Cart.getPartner';
import searchPartners from '@salesforce/apex/ensxtx_CTRL_PartnerSearch.searchPartners';
import loadCountries from '@salesforce/apex/ensxtx_CTRL_OverrideAddress.loadCountries';
import savePartner from '@salesforce/apex/ensxtx_CTRL_Cart.savePartner';
import ensxtx_CartPartner_Button_PartnerSearch from '@salesforce/label/c.ensxtx_CartPartner_Button_PartnerSearch';
import ensxtx_CartPartner_Button_OverrideAddress from '@salesforce/label/c.ensxtx_CartPartner_Button_OverrideAddress';
import ensxtx_CartPartner_Message_PartnerSearch from '@salesforce/label/c.ensxtx_CartPartner_Message_PartnerSearch';
import ensxtx_OverrideAddress_Field_City from '@salesforce/label/c.ensxtx_OverrideAddress_Field_City';
import ensxtx_OverrideAddress_Field_Country from '@salesforce/label/c.ensxtx_OverrideAddress_Field_Country';
import ensxtx_OverrideAddress_Field_HouseNumber from '@salesforce/label/c.ensxtx_OverrideAddress_Field_HouseNumber';
import ensxtx_OverrideAddress_Field_PartnerName from '@salesforce/label/c.ensxtx_OverrideAddress_Field_PartnerName';
import ensxtx_OverrideAddress_Field_PartnerName2 from '@salesforce/label/c.ensxtx_OverrideAddress_Field_PartnerName2';
import ensxtx_OverrideAddress_Field_PostalCode from '@salesforce/label/c.ensxtx_OverrideAddress_Field_PostalCode';
import ensxtx_OverrideAddress_Field_Region from '@salesforce/label/c.ensxtx_OverrideAddress_Field_Region';
import ensxtx_OverrideAddress_Field_Street from '@salesforce/label/c.ensxtx_OverrideAddress_Field_Street';
import ensxtx_CartPartner_Title_Partner from '@salesforce/label/c.ensxtx_CartPartner_Title_Partner';
import ensxtx_CartPartner_Type_BP from '@salesforce/label/c.ensxtx_CartPartner_Type_BP';
import ensxtx_CartPartner_Type_SH from '@salesforce/label/c.ensxtx_CartPartner_Type_SH';
import ensxtx_Common_Loading from '@salesforce/label/c.ensxtx_Common_Loading';
import PartnerSearchModal from 'c/ensxtxPartnerSearchModal';
import CustomerSearchModal from 'c/ensxtxCustomerSearchModal';
import OverrideAddressModal from 'c/ensxtxOverrideAddressModal';

export default class EnsxtxCartPartner extends CheckoutComponentBase {
    @api appSettingsName;
    @api partnerFunction;
    @api partnerFunctionInternal;
    @api componentType;
    @api searchType;
    pagingOptions = {};

    isLoading = true;
    isEditMode = true;

    get PartnerName() {
        return this.partner.PartnerName;
    }
    set PartnerName(value) {
        this.partner.PartnerName = value;
    }

    get PartnerName2() {
        return this.partner.PartnerName2;
    }
    set PartnerName2(value) {
        this.partner.PartnerName2 = value;
    }
    
    get HouseNumber() {
        return this.partner.HouseNumber;
    }
    set HouseNumber(value) {
        this.partner.HouseNumber = value;
    }
    
    get Street() {
        return this.partner.Street;
    }
    set Street(value) {
        this.partner.Street = value;
    }
    
    get City() {
        return this.partner.City;
    }
    set City(value) {
        this.partner.City = value;
    }
    
    get Country() {
        return this.partner.Country;
    }
    set Country(value) {
        this.partner.Country = value;
    }
    
    get Region() {
        return this.partner.Region;
    }
    set Region(value) {
        this.partner.Region = value;
    }

    get PostalCode() {
        return this.partner.PostalCode;
    }
    set PostalCode(value) {
        this.partner.PostalCode = value;
    }

    isSameAsShipping;
    isNotShipping;
    sfObjectIdMap = {};
    messages = [];
    appSettings;
    allowAddressOverride = false;
    title;
    allCountries = [];
    allRegions = [];
    countryOptions = [];
    regionOptions = [];
    partner = {};

    label = {
        ensxtx_CartPartner_Button_OverrideAddress,
        ensxtx_CartPartner_Button_PartnerSearch,
        ensxtx_CartPartner_Message_PartnerSearch,
        ensxtx_OverrideAddress_Field_City,
        ensxtx_OverrideAddress_Field_Country,
        ensxtx_OverrideAddress_Field_HouseNumber,
        ensxtx_OverrideAddress_Field_PartnerName,
        ensxtx_OverrideAddress_Field_PartnerName2,
        ensxtx_OverrideAddress_Field_PostalCode,
        ensxtx_OverrideAddress_Field_Region,
        ensxtx_OverrideAddress_Field_Street,
        ensxtx_CartPartner_Title_Partner,
        ensxtx_CartPartner_Type_BP,
        ensxtx_CartPartner_Type_SH,
        ensxtx_Common_Loading
    };
    
    @wire(CartSummaryAdapter)
    wiredCartSummary({ error, data }) {
        if (data) {
            if (this.sfObjectIdMap.WebCart != data.cartId ||
                this.sfObjectIdMap.Account != data.accountId ||
                this.sfObjectIdMap.User != data.ownerId ||
                this.sfObjectIdMap.WebStore != data.webstoreId) 
            {
                this.sfObjectIdMap.WebCart = data.cartId;
                this.sfObjectIdMap.Account = data.accountId;
                this.sfObjectIdMap.User = data.ownerId;
                this.sfObjectIdMap.WebStore = data.webstoreId;
                this.getFromCart();
            }
        } else if (error) {
            // This is here for a demo when added as a componenet in Experience Builder.
            this.partner = {
                PartnerName: 'Emily',
                PartnerName2: 'Smith',
                HouseNumber: '3424',
                Street: 'Elm Tree Road',
                City: 'Waynesville',
                Country: 'US',
                Region: 'OH',
                PostalCode: '45068'
            };
            this.getCountries();
        }
    }

    async connectedCallback() {
        this.isLoading = true;
        this.isSameAsShipping = this.partnerFunction != 'SH';
        this.isNotShipping = this.partnerFunction != 'SH';
        this.pagingOptions.pageSize = 1000;
        this.pagingOptions.pageNumber = 1;
        this.getSettings(this.appSettingsName)
        .then(result => {
            this.title = this.formatString(this.label.ensxtx_CartPartner_Title_Partner, 
                [this.label['ensxtx_CartPartner_Type_' + this.partnerFunction]]);
            this.appSettings = JSON.parse(result).CartPartner;
            this.allowAddressOverride = this.appSettings.AllowAddressOverride?.filter(setting => 
                setting.PartnerFunction == this.partnerFunction)[0]?.allowAddressOverride;
        })
        .catch(err => {
            let message = err?.body?.message ? err.body.message : JSON.stringify(err);
            this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
            this.isLoading = false;
        });
    }
    
    async getSettings (paramAppSetting) {
        return await new Promise((resolve, reject) => {
            return resolve (getAppsettings({appsettingName:paramAppSetting}));
        });
    }

    formatString(string, params) {
        return string.replace(/{(\d+)}/g, (match, index) => {
            return typeof params[index] !== 'undefined' ? params[index] : match;
        });
    }

    setAspect(aspectMap) {
        this.isEditMode = !aspectMap.summary;
    }
    
    getFromCart() {
        this.isLoading = true;
        return getPartner({ 
            partnerFunction: this.partnerFunction, 
            sfObjectIdMap: this.sfObjectIdMap
        })
        .then((result) => {
            if (result.data) {
                this.partner = result.data;
                this.isSameAsShipping = this.isSameAsShipping && !this.partner;
                this.getCountries();
            } else {
                if (this.componentType != 'CustomerSearch') {
                    this.getPartners();
                } else {
                    this.getCountries();
                }

            }

        })
        .catch((err) => {
            let message = err?.body?.message ? err.body.message : JSON.stringify(err);
            this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
            this.isLoading = false;
        });
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
                            this.allCountries.filter(country=> !this.appSettings?.optionValuesToInclude?.Country.length > 0 || 
                                this.appSettings?.optionValuesToInclude?.Country.filter(include=>
                                    include==country.LAND1).length > 0).forEach(country => 
                                    {this.countryOptions.push({ label: country.LANDX, value: country.LAND1 });
                            });
                            if (result.data.ET_REGIONS_List) this.allRegions = result.data.ET_REGIONS_List;
                            this.setRegions();
                        }
                    }
                    if (!this.sfObjectIdMap.WebCart) {
                        this.messages.push({messageType: 'ERROR', message: 'No Cart found', key: '1'});
                    }
                    this.isLoading = false;
                }
            })
            .catch((err) => {
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

    getPartners() {
        return searchPartners({ 
            appSettings: this.appSettings, 
            sfObjectIdMap: this.sfObjectIdMap, 
            partnerFunction: this.partnerFunction, 
            partnerFunctionInternal: this.partnerFunctionInternal, 
            pagingOptions: this.pagingOptions,
            sortFields: null
        })
        .then((result) => {
            if (result) {
                this.pagingOptions = result.pagingOptions;
                this.messages = result.messages.map((message, index) => ({...message, key: index}));
                if (result.data) {
                    if (result.data.partners) {
                        result.data.partners.forEach(partner => {
                            if (partner.DefaultPartner) {
                                this.partner = partner;
                                this.partner.DefaultPartner = null;
                            }
                        });
                    }
                }
            }
            this.getCountries();
        })
        .catch((err) => {
            let message = err?.body?.message ? err.body.message : JSON.stringify(err);
            this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
            this.isLoading = false;
        });
    }

    saveToCart() {
        if (this.sfObjectIdMap.WebCart) {
            this.isLoading = true;
            return savePartner({ 
                partnerFunction: this.partnerFunction, 
                partner: this.partner,
                sfObjectIdMap: this.sfObjectIdMap
            })
            .then((result) => {
                if (result?.data?.Id) {
                    let cpaObj = {
                        addressId: result.data.Id,
                        addressType: result.data.AddressType,
                        name: result.data.Name,
                        firstName: result.data.AddressFirstName,
                        lastName: result.data.AddressLastName,
                        street: result.data.Street,
                        city: result.data.City,
                        region: result.data.StateCode || result.data.State,
                        country: result.data.CountryCode || result.data.Country,
                        postalCode: result.data.PostalCode
                    };
                    updateContactPointAddress(cpaObj)
                    .then((record) => {
                        let deliveryGroup = {
                            deliveryAddress: {
                                addressId: result.data.Id
                            }
                        }
                        updateShippingAddress(deliveryGroup);
                    }).catch(error => {
                        console.error(error);
                    });
                }
                this.isLoading = false;
            })
            .catch((err) => {
                let message = err?.body?.message ? err.body.message : JSON.stringify(err);
                this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
                this.isLoading = false;
            });
        }
    }

    async onSearch() {
        if (this.componentType == 'CustomerSearch') {
            let result = await CustomerSearchModal.open({
                size: 'large',
                partnerFunction: this.partnerFunction,
                partnerFunctionInternal: this.partnerFunctionInternal,
                partnerFunctionName: this.label['ensxtx_CartPartner_Type_' + this.partnerFunction],
                searchType: this.searchType,
                fieldSettings: this.appSettings?.CustomerSearchTable,
                searchParamFields: this.appSettings?.SearchParamFields,
                sfObjectIdMap: this.sfObjectIdMap,
                isAutoSearch: true
            })
            .catch((err) => {
                let message = err?.body?.message ? err.body.message : JSON.stringify(err);
                this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
            });
            if (result.action == 'Select') {
                Object.assign(this.partner, result.partner);
                this.saveToCart();
            }
        } else {
            let result = await PartnerSearchModal.open({
                size: 'large',
                partnerFunction: this.partnerFunction,
                partnerFunctionInternal: this.partnerFunctionInternal,
                partnerFunctionName: this.label['ensxtx_CartPartner_Type_' + this.partnerFunction],
                searchType: 'Partner',
                fieldSettings: this.appSettings?.PartnerSearchTable,
                searchParamFields: this.appSettings?.SearchParamFields,
                sfObjectIdMap: this.sfObjectIdMap,
                pageSize: this.appSettings?.PageSize,
                isSortable: this.appSettings?.AllowSort,
                sortFields: this.appSettings?.SortFields
            })
            .catch((err) => {
                let message = err?.body?.message ? err.body.message : JSON.stringify(err);
                this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
            });
            if (result.action == 'Select') {
                Object.assign(this.partner, result.partner);
                this.saveToCart();
            }
        }
    }

    async onOverrideAddress() {
        let result = await OverrideAddressModal.open({
            size: 'large',
            partnerFunction: this.partnerFunction,
            partnerFunctionName: this.label['ensxtx_CartPartner_Type_' + this.partnerFunction],
            partner: this.partner,
            optionValuesToInclude: this.appSettings?.optionValuesToInclude
        })
        .catch((err) => {
            let message = err?.body?.message ? err.body.message : JSON.stringify(err);
            this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
        });
        if (result.action == 'Save') {
            Object.assign(this.partner, result.partner);
            this.saveToCart();
        }
    }

    onSameAsShipping() {
        this.isSameAsShipping = !this.isSameAsShipping; 
        if (this.isSameAsShipping) {
            this.partner = {};
            this.saveToCart();
        }
    }
}