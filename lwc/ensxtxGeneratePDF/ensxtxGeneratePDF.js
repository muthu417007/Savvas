import { api,LightningElement } from 'lwc'
import getDocList from '@salesforce/apex/ensxtx_CTRL_GeneratePDF.getDocumentsList'
import ensxtx_Common_Loading from '@salesforce/label/c.ensxtx_Common_Loading'
import ensxtx_PDF_NotAvailable from '@salesforce/label/c.ensxtx_PDF_NotAvailable'
import ensxtx_PDF_SalesDoc_Action from '@salesforce/label/c.ensxtx_PDF_SalesDoc_Action'
import ensxtx_PDF_SalesDoc_ConditionType from '@salesforce/label/c.ensxtx_PDF_SalesDoc_ConditionType'
import ensxtx_PDF_SalesDoc_ConditionTypeDesc from '@salesforce/label/c.ensxtx_PDF_SalesDoc_ConditionTypeDesc'
import ensxtx_PDF_SalesDoc_Download from '@salesforce/label/c.ensxtx_PDF_SalesDoc_Download'
import ensxtx_PDF_SalesDoc_Language from '@salesforce/label/c.ensxtx_PDF_SalesDoc_Language'
import ensxtx_PDF_SalesDoc_Preview from '@salesforce/label/c.ensxtx_PDF_SalesDoc_Preview'
import ensxtx_PDF_SalesDoc_Title from '@salesforce/label/c.ensxtx_PDF_SalesDoc_Title'

export default class EnsxtxGeneratePDF extends LightningElement {
    @api documentNumber
    @api outputApplication
    @api displayLanguage
    @api displayConditionType
    @api displayConditionTypeDescription
    @api displayPreview
    @api displayDownload

    loading = true
    documentResults = []
    messages = []
    icon = "custom:custom18"

    label = {
        ensxtx_Common_Loading,
        ensxtx_PDF_NotAvailable,
        ensxtx_PDF_SalesDoc_Action,
        ensxtx_PDF_SalesDoc_ConditionType,
        ensxtx_PDF_SalesDoc_ConditionTypeDesc,
        ensxtx_PDF_SalesDoc_Download,
        ensxtx_PDF_SalesDoc_Language,
        ensxtx_PDF_SalesDoc_Preview,
        ensxtx_PDF_SalesDoc_Title,
    }

    connectedCallback() {
        getDocList({
            docNum : this.documentNumber,
            messageType : '',
            outputApplication : this.outputApplication
        })
        .then(({ data, messages}) => {
            this.documentResults = data
            if (messages?.length) {
                this.messages = messages.map((message, index) => ({...message, key: index}))
            }
        })
        .catch(response => {
            console.log(response)
            this.messages = [
                {
                    key: 1,
                    messageType: 'ERROR',
                    message: response.body.message
                }
            ]
        })
        .finally (()=>{
            this.loading = false
        })
    }

    handlePreviewPDF(event) {
        this.getDocument(event.currentTarget.dataset.id, false)
    }

    handleDownloadPDF(event) {
        this.getDocument(event.currentTarget.dataset.id, true)
    }

    getDocument(docMessageType, isDownload) {
        this.loading = true
        getDocList({
            docNum : this.documentNumber,
            messageType : docMessageType,
            outputApplication : this.outputApplication
        })
        .then(({data, messages}) => {
            const result =  data?.[0]
            if (result?.PDF_B64STR) {
                const link = document.createElement('a')
                link.target = '_blank'
                if (isDownload) {
                    const documentPrefix = { 'V2':'Delivery', 'V3':'Invoice' }[this.outputApplication] || 'SalesDocument'
                    const fileName = documentPrefix + '_' + result.ConditionTypeDescription + '_' + this.documentNumber + '.pdf'
                    link.download = fileName
                    link.href = `data:application/pdf;base64,${result.PDF_B64STR}`
                } else {
                    // Create a Blob from Base64
                    const byteCharacters = atob(result.PDF_B64STR)
                    const byteNumbers = new Array(byteCharacters.length)
                    for (let i = 0; i < byteCharacters.length; i++) {
                        byteNumbers[i] = byteCharacters.charCodeAt(i)
                    }
                    const blob = new Blob([new Uint8Array(byteNumbers)], {
                        type: 'application/pdf'
                    })
                    link.href = URL.createObjectURL(blob)
                }
                document.body.appendChild(link)
                link.click()
                link.remove()
                if (!isDownload) { URL.revokeObjectURL(link.href) }
            } else {
                if (messages?.length) {
                    this.messages = messages.map((message, index) => ({...message, key: index}))
                } else {
                    this.messages = [
                        {
                            key: 1,
                            messageType: 'ERROR',
                            message: ensxtx_PDF_NotAvailable
                        }
                    ]
                }
            }
        })
        .catch(response => {
            console.log(response)
            this.messages = [
                {
                    key: 1,
                    messageType: 'ERROR',
                    message: response.body.message
                }
            ]
        })
        .finally (()=>{
            this.loading = false
        })
    }
}