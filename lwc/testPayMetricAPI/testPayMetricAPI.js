import { LightningElement,track } from 'lwc';
import { loadStyle, loadScript } from "lightning/platformResourceLoader";
import Paymetric_Script from "@salesforce/resourceUrl/scc_Paymetric_Script";

import getAccessToken  from '@salesforce/apex/scc_PaymetricIntegrationController.getAccessToken';
import getCountrysOptions from '@salesforce/apex/scc_PaymetricIntegrationController.getCountrysOptions';
import getStatesOptions from '@salesforce/apex/scc_PaymetricIntegrationController.getStatesOptions';
import scc_iFrame_Url from '@salesforce/label/c.scc_iFrame_Url';
import scc_OrderStatus_Country from "@salesforce/label/c.scc_OrderStatus_Country";
export default class TestPayMetricAPI extends LightningElement {
scriptLoaded =false;
 @track accessToken;
    @track merchantGuid;
    @track signature;
    @track displayiFrame = false;
    @track iFrameUrl;
    @track selectedPayment = 'creditCard';
    @track poNumber ='';
    @track htmlContent;
    @track isAddressDifferent=false;
    @track CountrysOptions2;
    @track CountrysOptions3;
    @track stateOptions;
    @track CountryValue = 'USD';
    @track isCreditCardSelected = true;
    @track isPoSelected = false;
    @track stateValue;
    @track iframeRendered =false;
connectedCallback() {
     //const iframe = event.target;
        loadScript(this, Paymetric_Script)
           .then(() => {
               // Ensure the script is loaded
               this.scriptLoaded = true;
               console.log('Script loaded successfully.');
               console.log('iframe:::',iframe);  
               var iframe = this.template.querySelector('iframe[name="dieCommFrame"]');
               if(iframe){
                    console.log('Script loaded successfully@@@@.');
                    iframe.id = 'dieCommFrame';
                    iframe.src = 'https://cert-xiecomm.paymetric.com/diecomm/view/iframe/'+this.merchantGuid+'/'+this.accessToken+'/true';

                } 
                var iframe = this.template.querySelector('iframe[name="dieCommFrame"]');
                if (iframe) {
                    console.log('Script loaded successfully!!!!!.');
                    var theIframe = this.template.querySelector('iframe[name="dieCommFrame"]');
                    console.log('Script loaded successfully$$$$$.'+theIframe);
                     theIframe.onload = () =>{
                        console.log('Iframe loaded successfully********.');
                        $XIFrame.onload({
                        iFrameId: 'dieCommFrame',
                       /*targetUrl: iframe[0].getAttribute('https://cert-xiecomm.paymetric.com/diecomm/view/iframe/'+this.merchantGuid+'/'+this.accessToken+'/true'),*/
                        autosizewidth: true,
                        autosizeheight: true,
                        onSuccess: function (msg) {
                            console.log('A form for the merchant guid and access token combination is loading in the iFrame successfully.');
                        },
                        onError: function (msg) {
                            console.log(msg)
                            console.log('A form for the merchant guid and access token combination has FAILED to load.');
                        }
                    });
                }
                }
           })
           .catch(error => {
               console.error('Error loading script:', error);
        });

    }
    submitform(){ 
        	
        var iframe = this.template.querySelector('iframe[name="dieCommFrame"]');
        if (iframe) {
            $XIFrame.submit({
                iFrameId: 'dieCommFrame',
                targetUrl: 'https://cert-xiecomm.paymetric.com/diecomm/view/iframe/'+this.merchantGuid+'/'+this.accessToken+'/true',
                onSuccess: function (msg) {
                    var message = JSON.parse(msg);
                    if (message && message.data.HasPassed) {
                        //var accessToken = document.getElementById('AccessToken');
                        //var signedToken = document.getElementById('SignedToken');
                        console.log("Credit card data submitted !!");
                        // Now trigger the server side GET call to retrieve the token data & other CC data from Paymetric to proceed with pre auth.
                       // window.location = "${secureresponse}?id=" + accessToken.value + "&s=" + signedToken.value;
                    } else {
                        alert(message.data.Message);
                    }
                },
                onError: function (msg) {
                    console.log("Error Block !!");
                    alert(msg);
                }
            });
        }
    }
}