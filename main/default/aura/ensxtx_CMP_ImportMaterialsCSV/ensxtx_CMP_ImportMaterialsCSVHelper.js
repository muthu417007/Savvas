({
    loadAppSettings: function(component, helper) {
        return new Promise(function(resolve, reject) {
            console.log('init app settings');

            let appSettingsName = component.get('v.appSettingsName');
            let appSettingsKey = component.get('v.appSettingsKey');

            let staticResource = $A.get('$Resource.' + appSettingsName);
            let req = new XMLHttpRequest();

            req.open("GET", staticResource);
            req.addEventListener("load", $A.getCallback(function() {
                console.log('loaded app settings');
                let response = JSON.parse(req.response);
                let appSettings = response[appSettingsKey] ? response[appSettingsKey] : null;
                if (!appSettings) {
                    let messages = [{
                        messageType: 'ERROR', 
                        message: 'App Settings is not found on ' + appSettingsName + '. Please Configure the App Settings first.'
                    }];
                    component.set('v.messages', messages);
                }
                else {
                    component.set('v.appSettings', appSettings);
                }
                resolve();  
            }));
            req.send(null);
        })
    },

    buildColumns: function(component) {
        // The columns are setup in the app settings for this component
        let appSettings = component.get('v.appSettings');
        let columns = [];
        let csvColumns = [];
        if (appSettings) {
            let resultTable = appSettings.Table
            for (let keyField in resultTable){
                let field = resultTable[keyField];
                let label = field.customLabel ? $A.get('$Label.c.' + field.customLabel) : field.label;
                columns.push({
                    label: label,
                    fieldName: keyField,
                    type: field.type,
                    initialWidth: field.width,
                    isItemText: field.isItemText
                })
                csvColumns.push(label)
            }
        }

        component.set('v.columns', columns);
        component.set('v.csvColumns', csvColumns);
    },

    onHandleUpload: function(component, files, helper) {
        console.log('handle upload');

        let file = files[0];
        let isValidFile = this.validateFileExtension(file.name);

        if (isValidFile) {
            component.set('v.isValidFile', true);
            component.set('v.displaySpinner', true);
            component.set('v.messages', []);
            component.set('v.displayResults', []);

            let reader = new FileReader();
            reader.readAsText(file);
            reader.onload = (function(theFile) {
                return function(e) {
                    console.log('onload');
                    helper.csvToArray(component, e.target.result);
                    component.set('v.displaySpinner', false);
                };
            })(file);
        }
        else {
            component.set('v.isValidFile', false);
        }
    },

    validateFileExtension: function(fileName) {
        let fileExtension = '';
        if (fileName.lastIndexOf('.') > 0) {
            fileExtension = fileName.substring(fileName.lastIndexOf('.') + 1, fileName.length);
        }
        if (fileExtension.toLowerCase() === 'csv') {
            return true;
        }
        else return false;
    },

    csvToArray: function(component, csvString) {
        console.log('csvString: ' + csvString);
        let csvArray = this.parseCSV(csvString);
        let isValid = this.validateCSVColumn(component, csvArray[0]);

        if (isValid) {
            // Remove the first row as it's always the header;
            csvArray.shift();

            if (csvArray.length) {
                let addMaterials = [];
                let columns = component.get('v.columns');

                // Iterate through the rows and set the value to the proper property
                // To be shown on the table
                for (let rowIndex in csvArray) {
                    let row = csvArray[rowIndex];
                    let material = {};
                    for (let columnIndex in columns) {
                        let column = columns[columnIndex];
                        let value = row[columnIndex];

                        if (column.type === 'number') {
                            material[column.fieldName] = value ? parseInt(value) : null;
                        }
                        else {
                            material[column.fieldName] = value;
                        }
                    }
                    addMaterials.push(material);
                }

                component.set('v.displayResults', addMaterials);
                // Select all the rows. Keyfield is the default Id
                let selectedRows = addMaterials.map((row, index) => {
                    return 'row-' + index;
                })
                component.set('v.selectedRows', selectedRows);
            }
            else {
                let messages = component.get('v.messages');
                messages.push({
                    message: $A.get('$Label.c.ensxtx_ImportMaterial_Message_NoMaterialsCSV'),
                    messageType: 'ERROR'
                })
                component.set('v.messages', messages)
            }
        }
    },

    parseCSV: function(str) {
        // FROM https://stackoverflow.com/a/14991797
        let array = [];
        let quote = false;  // 'true' means we're inside a quoted field

        // Iterate over each character, keep track of current row and column (of the returned array)
        for (let row = 0, col = 0, index = 0; index < str.length; index++) {

            let currentChar = str[index]; 
            let nextChar = str[index + 1];

            array[row] = array[row] || [];             // Create a new row if necessary
            array[row][col] = array[row][col] || '';   // Create a new column (start with empty string) if necessary

            // If the current character is a quotation mark, and we're inside a
            // quoted field, and the next character is also a quotation mark,
            // add a quotation mark to the current column and skip the next character
            if (currentChar == '"' && quote && nextChar == '"') {
                array[row][col] += currentChar;
                ++index;
                continue;
            }

            // If it's just one quotation mark, begin/end quoted field
            if (currentChar == '"') {
                quote = !quote;
                continue;
            }

            // If it's a comma and we're not in a quoted field, move on to the next column
            if (currentChar == ',' && !quote) {
                ++col;
                continue;
            }

            // If it's a newline (CRLF) and we're not in a quoted field, skip the next character
            // and move on to the next row and move to column 0 of that new row
            if (currentChar == '\r' && nextChar == '\n' && !quote) {
                ++row; col = 0; ++index;
                continue;
            }

            // If it's a newline (LF or CR) and we're not in a quoted field,
            // move on to the next row and move to column 0 of that new row
            if (currentChar == '\n' && !quote) {
                ++row; col = 0;
                continue;
            }
            if (currentChar == '\r' && !quote) {
                ++row; col = 0;
                continue;
            }

            // Otherwise, append the current character to the current column
            array[row][col] += currentChar;
        }

        return array;
    },

    validateCSVColumn: function(component, headerColumns) {
        let csvColumns = component.get('v.csvColumns');
        let columnSet = new Set(csvColumns);
        let isValid = true;
        let invalidColumns = [];

        for (let columnIndex in headerColumns) {
            let column = headerColumns[columnIndex];
            if (!columnSet.has(column)) {
                invalidColumns.push(column);
            }
        }

        if (invalidColumns.length) {
            isValid = false;
            let message = $A.get('$Label.c.ensxtx_ImportMaterial_Message_InvalidColumns') + ' ' + invalidColumns.join(',');
            component.set('v.messages', [{
                message: message,
                messageType: 'ERROR'
            }])
        }

        return isValid;
    },

    saveToItems: function(component, event) {
        //convert Map to JSON
        let importTable = component.find('importTable');
        let selectedItemsList = importTable.getSelectedRows();
        let appSettingsTable = component.get('v.appSettings.Table');
        selectedItemsList.forEach(item => {
            for (const column in item) {
                let columnSetting = appSettingsTable[column];
                // Add the item texts if it's available
                if (columnSetting.isItemText) {
                    if (!item.ItemTexts) {
                        item.ItemTexts = []
                    }
                    item.ItemTexts.push({
                        TextID: column,
                        Text: item[column]
                    })
                }
            }
        })
        let itemJSONList = JSON.stringify(selectedItemsList);

        let evt = component.getEvent('selectMaterialsEvent');
        evt.setParams({selectedItems:itemJSONList});
        evt.fire();
        component.find('overlayLibImport').notifyClose();
    }
})