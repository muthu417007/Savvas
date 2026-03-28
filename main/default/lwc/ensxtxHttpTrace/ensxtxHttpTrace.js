import { LightningElement, api} from 'lwc';

export const formatXml = (xml) => {
    var formatted = '';
    var reg = new RegExp('(>)( ?)(<)(\/*)','g');
    xml = xml.replace(reg, '$1\r\n$3$4');
    var pad = 0;
    xml.split('\r\n').forEach((node) => {
        var indent = 0;
        if (node.match( /.+<\/\w[^>]*>$/ )) {
            indent = 0;
        } else if (node.match( /^<\/\w/ )) {
            if (pad != 0) {
                pad -= 1;
            }
        } else if (node.match( /^<\w([^>]*[^\/])?>.*$/ )) {
            indent = 1;
        } else {
            indent = 0;
        }

        var padding = '';
        for (var i = 0; i < pad; i++) {
            padding += '\t';
        }

        formatted += padding + node + '\r\n';
        pad += indent;
    });

    return formatted;
}

export default class EnsxtxHttpTrace extends LightningElement {
    @api httpTraces = []

    httpTrace = {}
    showHttpTrace = false
    columns = []

    connectedCallback() {
        this.columns = [
            {label: 'Request/Response', type: 'button-icon', typeAttributes: {name: 'request_response', iconName: 'utility:insert_tag_field', alternativeText: 'Request/Response'}},
            {label: 'Status Code', fieldName: 'ensxapp__Status_Code__c', type: 'text'},
            {label: 'RIO Name', fieldName: 'ensxapp__SBO_Name__c', type: 'text'},
            {label: 'Operation', fieldName: 'ensxapp__Operation__c', type: 'text'},
            {label: 'Execution Time (seconds)', fieldName: 'ensxapp__Execution_Time__c', type: 'text'},
            {label: 'Start Time', fieldName: 'ensxapp__Start_Time__c', type: 'date', typeAttributes: {hour: '2-digit', minute: '2-digit', second: '2-digit'}},
            {label: 'End Time', fieldName: 'ensxapp__End_Time__c', type: 'date', typeAttributes: {hour: '2-digit', minute: '2-digit', second: '2-digit'}},
        ]
    }

    handleRowAction(event) {
        let action = event.detail.action
        let row = event.detail.row

        switch (action.name) {
            case 'request_response':
                row.formattedRequest = formatXml(row.ensxapp__Request_Body__c)
                row.formattedResponse = formatXml(row.ensxapp__Response_Body__c)
                this.httpTrace = row
                this.showHttpTrace = true
        }
    }

    onClickBack(event) {
        this.showHttpTrace = false
        this.httpTrace = {}
    }
}