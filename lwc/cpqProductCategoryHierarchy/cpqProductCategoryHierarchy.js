import { LightningElement, api, wire, track } from "lwc";
import getCategoryData from "@salesforce/apex/CpqProductSelectionCtrl.getCategoryData";

export default class CpqProductCategoryHierarchy extends LightningElement {
    
    // General variables
    title = 'Select by Category';
    @api preselectedRow = [];
    
    // Controlls spinner visibility
    @track isLoaded = false;

    // Variables used for Apex
    @track gridDataReady = false;
    @track soql;
    @track gridData;
    @track error;

    //Variables from parent Property
    @api productCategoryApi;
    @api parentField;
    @api colNameApi;
    @api masterCategoryId;
    @api gridColumns;

    // Sends this back to Parent so that ProductList cmp can use it
    // NEW updated to an empty array of Ids
    @api selectedCategoryIds = [];
    
    //Ticket W-014415: Breadcrumb array passed up to Parent
    @api breadcrumbItems = [];


    /*
    *********************************************************
    Function Name  : connectedCallback
    Author         : Frank Berni
    Description    : on load of component - calls buildSOQL statement to set up the soql variable for fetchRecords to return all sub-categories belonging to the Master category
    Param          : 
    return         : 
    ********************************************************
    */
    connectedCallback() {
        console.log('ProductCategoryHierarchy connectedCallback:');
        // Checking that this component has all of its necessary information
        console.log('productCategoryApi: ' + this.productCategoryApi);
        console.log('parentField: ' + this.parentField);
        console.log('colNameApi: ' + this.colNameApi);
        console.log('MasterCategoryId: ' + this.masterCategoryId);
        console.log('GridColumns: ' + JSON.stringify(this.gridColumns));
        
        // Begin logic of building tree-grid
        this.buildSOQL();
        this.fetchRecords(this.masterCategoryId, true);

        //  Spinner logic (0.5 seconds)
        setTimeout(() => {
            this.isLoaded = true;
        }, 500);
        
    }

    /*
    *********************************************************
    Function Name  : buildSOQL
    Author         : Frank Berni
    Description    : Takes the colNameAPi, parentField and productCategoryApi from parent along with Id to generate the SELECT and FROM clauses for a SOQL query
    Param          : 
    return         : soql
    ********************************************************
    */
    buildSOQL() {
        // console.log('buildSOQL');
        // Takes strings from colNameAPI and splits them from the comma and adds them to list a map
        let cols = this.colNameApi.split(",").map((item) => item.trim());

        // Pushes Id and ParentCategoryId to cols
        cols.push("Id");
        cols.push(this.parentField);
        cols = [...new Set(cols)];

        // Builds the Select clause using the columns joined by commas and uses the ProductCategory API Name
        let soql = `SELECT ${cols.join(",")} FROM ${this.productCategoryApi}`;
        this.soql = soql;
        // console.log('soql: ' + this.soql );
    }

    /*
    *********************************************************
    Function Name  : handleRowToggle
    Author         : Frank Berni
    Description    : Tied to ontoggle event. When a row gets expanded it calls fetchRecords with the current rowName and onLoad false.
    Param          : event
    return         : More child categories that belong to that current row
    ********************************************************
    */
    handleRowToggle(event) {
        console.log('handleRowToggle');
        // console.log('event.detail', event.detail);
        // console.log('event.detail', JSON.stringify(event.detail));
        const rowName = event.detail.name;
        if (!event.detail.hasChildrenContent && event.detail.isExpanded) {
            console.log('Calling fetchRecords');
            console.log('rowName: ' + rowName);
            this.fetchRecords(rowName, false);
        }
    }

    /*
    *********************************************************
    Function Name  : getSelectedName
    Author         : Frank Berni
    Description    : Tied to onrowselection event. When a checkbox is checked for a row, it saves its Id to the preselectedRow array
                    Then redirects user to ProductList
    Param          : event
    return         : adds to preselectedRow
    ********************************************************
    */
    getSelectedName(event) {
        console.log('getSelectedName');

        this.selectedCategoryIds = event.detail.selectedRows.map(row => row.Id);
        console.log('this.selectedCategoryIds: ' + JSON.stringify(this.selectedCategoryIds));

        const selectedRows = event.detail.selectedRows;
        console.log('selectedRows: ' + JSON.stringify(selectedRows));

        // NEW updating so the breadcrumb uses the last selected category 
        // Ticket W-014415: Constructs the breadcrumbItems array
        if(selectedRows.length > 0) {
            console.log('building breadcrumb')
            // NEW feeding in selectedRows into help function to update breadcrumbs
            this.updateBreadcrumb(selectedRows);
        }

        // Ticket W-014415: Creates and dispatches an event to send breadcrumbItems to parent component
        this.handleUpdateBreadcrumbs();

         // NEW removed handleFilterProducts and assigning it to a new button
        
    }

    /*
    *********************************************************
    Function Name  : fetchRecords
    Author         : Frank Berni
    Description    : Calls getCategoryData from Apex. OnLoad it returns the first list of child categories from Master category. !OnLoad returns the child categories for the expanded row
    Param          : JS (parentId, onLoad) - getCategoryData(soql, parentField, recordId)
    return         : gridData
    ********************************************************
    */
    fetchRecords(parentId, onLoad) {
        console.log('child fetchRecords()');
        console.log('parentId: ' + parentId + '| onLoad: ' + onLoad);
        console.log('soql: ' + this.soql + '| parentField: ' + this.parentField + '| recordId: ' + parentId);
        
        // Call Apex class
        getCategoryData({
            soql: this.soql,
            parentField: this.parentField,
            recordId: parentId,
        })
        .then((data) => {
            if (data) {
            data = JSON.parse(JSON.stringify(data));
            let formatData = [];

            // Creates map of returned data
            data.map((e) => {
                let obj = e.record;
                if (e["hasChildrenContent"]) {
                    // _children is very important so that lightning tree grid renders the nested rows appropriately
                    obj["_children"] = [];
                }
                formatData.push(obj);
            });
            // console.log('formatData: ' + JSON.stringify(formatData));

            // OnLoad - set up the gridData per usual
            if (onLoad) {
                console.log('onLoad is True, writing to gridData');
                this.gridData = formatData;
                // console.log('gridData: ' + JSON.stringify(this.gridData));
            
            // !OnLoad - reformat gridData based on the Id of the row being expanded. getNewDataWithChildren is called to help keep track of child categories with or without children
            } else {
                console.log('onLoad is false, calling getNewDataWithChildren');
                // console.log('parentId: ' + parentId + '| gridData: ' + JSON.stringify(this.gridData) + '| formatData: ' + JSON.stringify(formatData));
                this.gridData = this.getNewDataWithChildren(
                    parentId,
                    this.gridData,
                    formatData
                );
            }
            }
        })
        .catch((error) => {
            if (error) {
                console.log('Error: ' + error);
                this.error = "Unknown error";
                if (Array.isArray(error.body)) {
                    this.error = error.body.map((e) => e.message).join(", ");
                } else if (typeof error.body.message === "string") {
                    this.error = error.body.message;
                }
            }
        });
    }

    /*
    *********************************************************
    Function Name  : getNewDataWithChildren
    Author         : Frank Berni
    Description    : Takes the current rowName's Id, gridData and formatData to format each row depending on if they have children or not
    Param          : rowName, data, children
    return         : row
    ********************************************************
    */
    getNewDataWithChildren(rowName, data, children) {
        // console.log('getNewDataWithChildren()');
        // console.log('rowName: ' + rowName + '| data: ' + JSON.stringify(data) + '| children: ' + JSON.stringify(children));
        return data.map((row) => {
            // console.log('row: ' + JSON.stringify(row));
            // console.log('row._children: ' + JSON.stringify(row._children));
            let hasChildrenContent = false;
            if (
                Object.prototype.hasOwnProperty.call(row, "_children") &&
                Array.isArray(row._children) &&
                row._children.length > 0
            ) {
                hasChildrenContent = true;
            }

            if (row.Id === rowName) {
                // console.log('row.Id and rowName are the same assigning row._children');
                row._children = children;
            } else if (hasChildrenContent) {
                // console.log('hasChildrenContent is true, calling getNewDataWithChildren for current row');
                this.getNewDataWithChildren(rowName, row._children, children);
            }
            // console.log('returned row: ' + JSON.stringify(row));
            return row;
        });
    }

    /*
    *********************************************************
    Function Name  : handleFilterProducts
    Author         : Frank Berni
    Description    : Uses the catgeory Id and passes it to the Parent component for the Product List component
    Param          : 
    return         : dispatchEvent for filterproducts
    ********************************************************
    */
       handleFilterProducts() {
        console.log('handleFilterProducts child:');
        const selectEvent = new CustomEvent('filterproducts', {
            // NEW updated categoryIds name
            detail : {categoryIds: this.selectedCategoryIds}
        });
        // resets the preselectedRow when user comes back to tree-grid 
        // NEW removed preselectedRow reset
        console.log('selectEvent: ' + selectEvent);
        this.dispatchEvent(selectEvent);
    }

    /* NEW
    *********************************************************
    Function Name  : clearSelection
    Author         : Frank Berni
    Description    : Clears all previously selected categories
    Param          : 
    return         : selectedCategoryIds returns null
    ********************************************************
    */
    clearSelection() {
        // resets selectedCategoryIds
        this.selectedCategoryIds = [];
        // Clears all selected rows in tree grid
        this.template.querySelector('lightning-tree-grid').selectedRows = [];
    }
    
    /*
    *********************************************************
    Function Name  : updateBreadcrumb
    Author         : Frank Berni
    Description    : Ticket W-014415: creates the breadcrumbItems array used by lightning-breadcrumb used the selectedRow
    Param          : selectedRow
    return         : this.breadcrumbItems
    ********************************************************
    */
    updateBreadcrumb(selectedRow) {
        console.log('updateBreadcrumb');
        console.log('selectedRow', JSON.stringify(selectedRow));
        // Resets breadcrumb
        this.breadcrumbItems = [];

        // NEW singling out the last category id in the selectedRow array
        let latestRow = selectedRow[selectedRow.length - 1];
        console.log('latestRow', JSON.stringify(latestRow));

        // NEW using a combined name of all categories chosen
        let combinedCategoryName = '';
        for (let i = 0; i < selectedRow.length; i++) {
            const category = selectedRow[i];
            // Concatenate each chosen category's name 
            combinedCategoryName += category.Name;
            // If loop is not on the final index add spacing between each selected category
            if (i != (selectedRow.length - 1)) {
                combinedCategoryName += ' | ';
            }
        }
        console.log('combinedCategoryName', combinedCategoryName);

        // Adds the select row to it
        this.breadcrumbItems.push({
            // NEW setting combined name to label for better visibility on categories chosen
            label: combinedCategoryName,
            value: latestRow.Id
        });
        console.log('breadcrumbItems', JSON.stringify(this.breadcrumbItems));

        // NEW updated so latestRow is passed in
        // Calls this function to add additional parent categories to the breadcrumb array
        this.findParentCategories(latestRow);
    }

    /*
    *********************************************************
    Function Name  : findParentCategories
    Author         : Frank Berni
    Description    : Ticket W-014415: helper function for updateBreadcrumb - finds Parent Categories and adds them to breadcrumbItems array and then reorders it based on hierarchy
    Param          : selectedRow
    return         : this.breadcrumbItems
    ********************************************************
    */
    findParentCategories(selectedRow) {
        // console.log('findParentCategories');
        // console.log('selectedRow', JSON.stringify(selectedRow));
        
        // When a selectedRow has a ParentCategoryId find it in the gridData and add to breadCrumbItems
        if (selectedRow.ParentCategoryId) {
            // console.log('this.gridData', JSON.stringify(this.gridData));
            let parentCategory = this.gridData.find(category => category.Id === selectedRow.ParentCategoryId);
            // console.log('parentCategory', JSON.stringify(parentCategory));

            // This finds level 3 and deeper Categories
            if (!parentCategory) {
                parentCategory = this.findParentInChildren(selectedRow.ParentCategoryId, this.gridData);
            }
            
            // This finds level 2 Categories
            if(parentCategory) {
                // unshift will arrange the element to the front of the array
                this.breadcrumbItems.unshift({
                    label: parentCategory.Name,
                    value: parentCategory.Id
                });
                // console.log('this.breadcrumbItems', JSON.stringify(this.breadcrumbItems));
                // Calls this function again if parentCategory has a ParentCategoryId
                this.findParentCategories(parentCategory);
            }
        }
    }

    /*
    *********************************************************
    Function Name  : findParentInChildren
    Author         : Frank Berni
    Description    : Ticket W-014415: helper function for findParentCategories - 
                     For nested levels beyond level 2 - finds Parent Categories for findParentCategories
    Param          : selectedRow
    return         : parentCategory or foundInChild
    ********************************************************
    */
    findParentInChildren(parentId, children) {
        // console.log('findParentInChildren');
        // console.log('parentId', JSON.stringify(parentId));
        // console.log('children', JSON.stringify(children));
        // loop through children array
        for (let i = 0; i < children.length; i++) {
            const child = children[i];
            // console.log('child', JSON.stringify(child));
            // Check that there is _children for that child
            if (child._children) {
                // find the matching category 
                const parentCategory = child._children.find(category => category.Id === parentId);
                // console.log('parentCategory', JSON.stringify(parentCategory));
                // if so, return that match
                if (parentCategory) {
                    return parentCategory;
                // if not, call function again until it is found
                } else {
                    const foundInChild = this.findParentInChildren(parentId, child._children);
                    // console.log('foundInChild', JSON.stringify(foundInChild));
                    if(foundInChild) {
                        return foundInChild;
                    }
                }
            }
        }
        // Otherwise return empty
        return null;
    }

    /*
    *********************************************************
    Function Name  : handleUpdateBreadcrumbs
    Author         : Frank Berni
    Description    : Ticket W-014415: Dispatches event to parent and makes the breadcrumbItems available
    Param          : 
    return         : dispatchEvent(breadCrumbEvent)
    ********************************************************
    */
    handleUpdateBreadcrumbs() {
        console.log('handleUpdateBreadcrumbs');
        const breadCrumbEvent = new CustomEvent('updatebreadcrumbs', {
            detail : {breadcrumbs: this.breadcrumbItems}
        });
        console.log('breadCrumbEvent: ' + breadCrumbEvent);
        this.dispatchEvent(breadCrumbEvent);
    }
}