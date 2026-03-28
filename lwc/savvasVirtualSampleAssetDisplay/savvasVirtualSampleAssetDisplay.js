import { LightningElement, api, track } from 'lwc';
import savvaasstyle from '@salesforce/resourceUrl/SavvasVirtualSampleImages';
import invokeAssetTrackingFlow from '@salesforce/apex/SavvasVirtualSampleAssetTrackingCtrl.invokeAssetTrackingFlow';
import authenticateDam from '@salesforce/apex/SavvasSampleResourcesLandingController.authenticateDam';
import { NavigationMixin } from 'lightning/navigation';
import conformingAsset from '@salesforce/label/c.Savvas_Virtual_Sample_Conforming_Asset';
import nonConformingAsset from '@salesforce/label/c.Savvas_Virtual_Sample_Non_Conforming_Asset';
import publicVideoAsset from '@salesforce/label/c.Savvas_Virtual_Sample_Public_Video_Asset';
import generateAccessToken from '@salesforce/apex/SavvasSampleResourcesLandingController.generateAccessToken';
const NUM_OF_TABS = 6;

export default class savvasVirtualSampleAssetDisplay extends NavigationMixin(LightningElement) {
    @api assetData = [];
    @api tab;
    einsteinUrl = savvaasstyle + '/Images/close.svg';
    playbtn = savvaasstyle + '/Images/assetPlayButton.png';
    arrow_icon = savvaasstyle + '/Images/arrow_btn.svg';
    isAsset = true;
    defaultSection = '';
    assetDetails = [];

    get tabs() {
        const tabs = [];
        for (let i = 1; i = NUM_OF_TABS; i++) {
            tabs.push({
                value: `${i}`,
                label: `Grade ${i}`,
                content: `Tab Content ${i}`,
            });
        }
        tabs.unshift({
            value: 0,
            label: 'All Grades'
        })
        return tabs;
    }
    //gets called on load of the component
    connectedCallback() {
        try {
            this.assetData = JSON.parse(JSON.stringify(this.assetData))
            this.handleAssetData(this.tab);
        }
        catch (error) {
            console.error(error);
        }
    }
    //gets called when a tab is selected. Asset details are updated based on the selected tab
    @api
    async handleAssetData(tabName) {
        try {
            this.assetDetails = [];
            let seqDetails = [];
            let tempDetails = [];
            this.defaultSection = '';
            this.assetData.forEach(element => {
                for (let key in element) {
                    if (key == tabName) {
                        tempDetails.push(element[key]);
                    }
                }
            });
            tempDetails.forEach(element => {
                for (let key in element) {
                    seqDetails.push({
                        key: key, value: element[key].sort((a, b) =>
                            (a.sequence > b.sequence) ? 1 : ((b.sequence > a.sequence) ? -1 : 0))
                    });
                }
            });
            tempDetails.forEach(element => {
                for (let key in element) {
                    let values = [];
                    let sequence = [];
                    element[key].forEach(ele => {
                        if (this.assetDetails.length == 0) {
                            if (ele.sequence != undefined && sequence.length < 3) {
                                values.push({
                                    assetId: ele.assetId,
                                    assetName: ele.assetName,
                                    assetType: ele.assetType,
                                    assetURL: ele.assetURL,
                                    assetItemId: ele.assetItemId,
                                    entityId: ele.entityId,
                                    sequence: ele.sequence,
                                    thumbnailId: ele.thumbnailId,
                                    isVideoAsset: ele.isVideoAsset,
                                    virtualsamplookup: ele.virtualsamplookup

                                })
                                sequence.push(ele.sequence);
                            }
                            else {
                                values.push({
                                    assetId: ele.assetId,
                                    assetName: ele.assetName,
                                    assetType: ele.assetType,
                                    assetURL: ele.assetURL,
                                    assetItemId: ele.assetItemId,
                                    entityId: ele.entityId,
                                    sequence: null,
                                    thumbnailId: ele.thumbnailId,
                                    isVideoAsset: ele.isVideoAsset,
                                    virtualsamplookup: ele.virtualsamplookup
                                })
                            }
                        }
                        else if (this.assetDetails.length > 0) {
                            if (ele.sequence != undefined && sequence.length < 3) {
                                values.push({
                                    assetId: ele.assetId,
                                    assetName: ele.assetName,
                                    assetType: ele.assetType,
                                    assetURL: ele.assetURL,
                                    assetItemId: ele.assetItemId,
                                    entityId: ele.entityId,
                                    sequence: ele.sequence,
                                    thumbnailId: ele.thumbnailId,
                                    isVideoAsset: ele.isVideoAsset,
                                    virtualsamplookup: ele.virtualsamplookup
                                })
                                sequence.push(ele.sequence);
                            }
                            else {
                                values.push({
                                    assetId: ele.assetId,
                                    assetName: ele.assetName,
                                    assetType: ele.assetType,
                                    assetURL: ele.assetURL,
                                    assetItemId: ele.assetItemId,
                                    entityId: ele.entityId,
                                    sequence: null,
                                    thumbnailId: ele.thumbnailId,
                                    isVideoAsset: ele.isVideoAsset,
                                    virtualsamplookup: ele.virtualsamplookup
                                })
                            }
                        }
                    });
                    this.assetDetails.push({
                        key: key,
                        value: values
                    })
                }
            })
            this.assetDetails.sort((a, b) => (a.key < b.key) ? 1 : -1);
            this.defaultSection = await this.assetDetails[0].key;
        }
        catch (error) {
            console.log(error)
        }
    }
  
    renderedCallback() {
        try {
            if (window.screen.width < 786) {
                let targetId = 'mobile';
                let element = this.template.querySelector(`[data-id="${targetId}"]`);
            }
            this.template.querySelectorAll('button').forEach(element => {
                element.addEventListener("click", evt => {
                    element.classList.toggle("active");
                    let panel = element.nextElementSibling;
                    if (panel.style.maxHeight) {
                        panel.style.maxHeight = null;
                    }
                    else {
                        panel.style.maxHeight = panel.scrollHeight + 'px';
                    }
                    this.template.querySelectorAll('button').forEach(el => {
                        let pan = el.nextElementSibling;
                        if (el != element) {
                            pan.style.maxHeight = null;
                        }
                    })
                })
            });
        }
        catch (error) {
            console.error(error);
        }
    }

    //is fired when user clicks on any asset. 
    handleOnClick(event) {
        try {
            let assetItemId = event.currentTarget.dataset.id;
            let data = '';
            for (const contentData of this.assetDetails) {
                data = contentData.value.find((element) => element.assetItemId === assetItemId);
                if (data) {
                    break;
                }
            }
            let entityId = data?.entityId;
            let assetType = data?.assetType;
            if (assetType === nonConformingAsset) {
                let url = data.assetURL;
                //used to get access token
                generateAccessToken({ sitecoreId: assetItemId })
                    .then(result => {
                        if (result) {
                            try {
                                url = url + '&authToken=' + result + '&sitecoreId=' + assetItemId;
                                this[NavigationMixin.Navigate]({
                                    "type": "standard__webPage",
                                    "attributes": {
                                        "url": url
                                    }

                                });
                            }
                            catch (error) {
                                console.error(error)
                            }
                        }
                    })
                    .catch(error => {
                    })
            }
            else if (assetType === conformingAsset) {
                let url = data.assetURL;
                //used to get the url from DAM
                authenticateDam({ entityId: entityId })
                    .then(result => {
                        let url = JSON.parse(JSON.stringify(JSON.parse(result))).renditions.preview[0].href;
                        this.isLoading = true;
                        this[NavigationMixin.Navigate]({
                            "type": "standard__webPage",
                            "attributes": {
                                "url": url,
                            }
                        }, true);
                    })
                    .catch(error => {
                        this.isLoading = true;
                    })
            }
            else if (assetType === publicVideoAsset) {
                let url = data.assetURL;
                this[NavigationMixin.Navigate]({
                    "type": "standard__webPage",
                    "attributes": {
                        "url": url
                    }
                });
            }
            let wrapperMap = {
                sampleAssetName: data.assetName,
                sampleAssetSitecoreId: data.assetItemId,
                virtualsampleProgramName: data.virtualsamplookup,
            }
            //flow is invoked to create asset tracking records
            invokeAssetTrackingFlow({ flowDetails: wrapperMap });
        }
        catch (error) {
            console.error(error)
        }
    }
}