import { LightningElement, track } from 'lwc';
import getAccessToken  from '@salesforce/apex/scc_PaymetricIntegrationController.getAccessToken';
import getCreditCardToken  from '@salesforce/apex/scc_PaymetricIntegrationController.getCreditCardToken';
import getCountrysOptions from '@salesforce/apex/scc_PaymetricIntegrationController.getCountrysOptions';
import getStatesOptions from '@salesforce/apex/scc_PaymetricIntegrationController.getStatesOptions';
import scc_iFrame_Url from '@salesforce/label/c.scc_iFrame_Url';
import scc_Credit_Card from "@salesforce/label/c.scc_Credit_Card";
import scc_Checkout_PO from "@salesforce/label/c.scc_Checkout_PO";
import scc_Checkout_PONumber from "@salesforce/label/c.scc_Checkout_PONumber";
import scc_Checkout_Zip from "@salesforce/label/c.scc_Checkout_Zip";
import scc_Checkout_Country from "@salesforce/label/c.scc_Checkout_Country";
import scc_Checkout_City from "@salesforce/label/c.scc_Checkout_City";
import scc_Checkout_Name from "@salesforce/label/c.scc_Checkout_Name";
import scc_Checkout_Street from "@salesforce/label/c.scc_Checkout_Street";
import scc_Checkout_Floor from "@salesforce/label/c.scc_Checkout_Floor";
import scc_Checkout_State from "@salesforce/label/c.scc_Checkout_State";
import scc_PO_Info_Text from "@salesforce/label/c.scc_PO_Info_Text";
import Paymetric_Script from "@salesforce/resourceUrl/scc_Paymetric_Script";
import pymtrx from "@salesforce/resourceUrl/pymtrx";
import { loadScript } from "lightning/platformResourceLoader";

export default class Scc_paymetric extends LightningElement {
    //static renderMode = "light";
    @track accessToken;
    @track merchantGuid;
    @track signature;
    @track displayiFrame = false;
    @track iFrameUrl;
    @track poNumber ='';
    @track isAddressDifferent=false;
    @track CountrysOptions2;
    @track CountrysOptions3;
    @track stateOptions;
    @track CountryValue = 'USD';
    @track isCreditCardSelected = true;
    @track isPoSelected = false;
    @track stateValue;
    @track iframeRendered =false;
    @track scriptLoaded =false;
    vfpageUrl;

    @track CountrysOptions1 = [{ label: 'United States', value: 'USD' }, { label: 'Canada', value: 'CAD' }];

    labels= {
        scc_iFrame_Url,
        scc_Checkout_Country,
        scc_PO_Info_Text,
        scc_Checkout_State,
        scc_Checkout_City,
        scc_Checkout_Name,
        scc_Checkout_Street,
        scc_Checkout_Floor,
        scc_Credit_Card,
        scc_Checkout_PO,
        scc_Checkout_Zip,
        scc_Checkout_PONumber
    }

    get CountryOptions() {
        return this.CountrysOptions3;
    }

    connectedCallback(){

        this.handleiFrameLoad();
        this.vfpageUrl = '/apex/PaymetricTest';
        window.myLwcComponent = this.template;
    }

    renderedCallback(){
    /*    if(!this.iframeRendered){
            loadScript(this, Paymetric_Script).then(() =>{
                console.log('script loaded');
                    
            })
            .catch(error => {
                console.log('load failed');
            })
        }
                loadScript(this, Paymetric_Script).then(() =>{
            console.log('script loaded');
            this.scriptLoaded = true;  
        })
        .catch(error => {
            console.log('load failed',JSON.stringify(error));
        })*/
        //loadScript(this,pymtrx).then(() =>console.log('pymtrxpymtrx'))
        //.catch( error => console.log('eeeeeeepymtrx',) )
    }

    handleiFrameLoad(){
        getAccessToken().then(response =>{
            console.log('access token response is',response);
            this.accessToken = response.accessToken;
            console.log('accessToken',this.accessToken);
            this.merchantGuid = response.merchantGuid;
            this.signature = response.signature;
            this.displayiFrame = true;
            this.htmlContent = response.iframe; 
            let urlparams = this.merchantGuid+'/'+this.accessToken+'/true';
            this.iFrameUrl = `${scc_iFrame_Url}${urlparams}`;
            console.log('iFrameUrl',this.iFrameUrl);
            console.log('host',window.location.origin)
        }).catch(error =>{
            console.log('access token error is',error);
        })
    }

    handlePaymentChange(event){
        console.log('pay',event.target);
        this.selectedPayment = event.target.value;
        if(event.target.value == 'creditCard'){
            this.isCreditCardSelected = true;
            this.isPoSelected = false;
        }else if(event.target.value == 'poMethod'){
            this.isCreditCardSelected = false;
            this.isPoSelected = true;
            this.iframeRendered = false;
        } 
    }

    handlePOChange(event){
        this.poNumber = event.detail.value;
    }

    handleCardAddressCheckbox(event){
        console.log('inside',event.detail);
        this.isAddressDifferent = event.detail.checked;
        if(this.isAddressDifferent){
            getCountrysOptions().then(response => {
                console.log('getCountrysOptions', JSON.parse(response));
                this.CountrysOptions2 = JSON.parse(response);
                this.CountrysOptions3 = [...this.CountrysOptions1, ...this.CountrysOptions2]
            }).catch(error => {
                console.log('error is', error);
                this.isLoading1 = false;
            })
            getStatesOptions({countryCode: this.CountryValue}).then(response => {
                console.log('getStatesOptions', JSON.parse(response));
                this.stateOptions = JSON.parse(response);
            }).catch(error => {
                console.log('error is', error);
                this.isLoading1 = false;
            })
        }
    }

    handleCardAddressChange(event){
        console.log('inside',event.target);
    }

    handleCountryOptionChange(event) {
        console.log('handleCountryOptionChange event',event.target.value);
        this.CountryValue = event.target.value;
        getStatesOptions({countryCode: this.CountryValue}).then(response => {
            console.log('getStatesOptions', JSON.parse(response));
            this.stateOptions = JSON.parse(response);
        }).catch(error => {
            console.log('error is', error);
            this.isLoading1 = false;
        })

    }

    handleStateOptionChange(event) {
        this.stateValue = event.target.value;
    }

    handleAddressCheck(){
        console.log('cardName',this.template.querySelector('.cardName').value);
        console.log('cardStreet',this.template.querySelector('.cardStreet'));
        console.log('cardFloor',this.template.querySelector('.cardFloor'));
        console.log('cardCity',this.template.querySelector('.cardCity'));
        console.log('cardZip',this.template.querySelector('.cardZip'));
        this.submitform();
    }

    IFrame_OnLoad(event) {  
        console.log('inside123');
        console.log('inside123',document.getElementsByName('dieCommFrame'));
        if(!this.iframeRendered){
            let urlparams = this.merchantGuid+'/'+this.accessToken+'/true';
            var url = `${scc_iFrame_Url}${urlparams}`;
            this.iframeRendered = true;
            var iframe = this.template.querySelector('iframe[name="dieCommFrame"]');
            console.log('iframe13::---',iframe);
            console.log('iframe13::-000',url);
            console.log('iframe13::-0001',window.myLwcComponent.querySelector('iframe[name="dieCommFrame"]'));
            loadScript(this, Paymetric_Script).then(() =>{
                console.log('script loaded');
                //this.scriptLoaded = true;  
                if (iframe) {
                    console.log('inside');
                     window.$XIFrame.onload({
                            iFrameId: 'dieCommFrame',
                            targetUrl: url,
                            autosizewidth: true,
                            autosizeheight: true,
    
                            onSuccess: function (msg) {
                                console.log('A form for the merchant guid and access token combination is loading in the iFrame successfully.');
                            },
                            onError: function (msg) {
    
                                console.log('A form for the merchant guid and access token combination has FAILED to load.',msg);
                            }
                        });
                }
            })
            
            
        }  
        
    }

    submitform(){ 
        console.log('inside123');
        const accessToken = this.accessToken;
        const signature = this.signature;
        const merchantGuid = this.merchantGuid;
        var iframe = this.template.querySelector('iframe[name="dieCommFrame"]');
            if (iframe) {
                let urlparams = this.merchantGuid+'/'+this.accessToken+'/true';
                var url = `${scc_iFrame_Url}${urlparams}`;
                console.log('inside submit',url);
                $XIFrame.submit({
                    iFrameId: 'dieCommFrame',
                    targetUrl: url,
                    onSuccess: function (msg) {
                        console.log('inside success');
                        var message = JSON.parse(msg);
                        if (message && message.data.HasPassed) {
                            console.log('accessToken1',accessToken);
                            console.log('signature',signature);
                            console.log('merchantGuid',merchantGuid);
                            console.log("Credit card data submitted !!");
                            getCreditCardToken({accessToken:accessToken,signature:signature,merchantGuid:merchantGuid}).then(response =>{
                                console.log('token response:',response);
                            }).catch(error => {
                                console.log('error is', error);
                            })   
							// Now trigger the server side GET call to retrieve the token data & other CC data from Paymetric to proceed with pre auth.
                           // window.location = "${secureresponse}?id=" + accessToken.value + "&s=" + signedToken.value;
                        } else {
                            alert(message.data.Message);
                        }
                    },
                    onError: function (msg) {
                        alert(msg);
                    }
                });
            }

    }

}