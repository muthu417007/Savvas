import { LightningElement, wire, track } from 'lwc';
//import { loadStyle } from 'lightning/platformResourceLoader';
//import CatalogGlobalStyleSheet from '@salesforce/resourceUrl/CatalogGlobalStyleSheet';
import retrieveProductCategory from '@salesforce/apex/scc_ProductCatalogApexClass.retrieveProductCategory';
//import getChildRecords from '@salesforce/apex/CatalogApexClass.getChildRecords';
import getChildRecordsProductData from '@salesforce/apex/scc_ProductCatalogApexClass.getChildRecordsProductData';
import getProductDetails from '@salesforce/apex/scc_ProductCatalogApexClass.getProductDetails';
import { RefreshEvent } from 'lightning/refresh';

/*********************************************************
  Component Name       : scc_catalogLWC
  Created Date         : 05/21/2024  
  Author               : Sudha Rani pathivada- Cognizant
  Description          : Nested component for scc_place  criteria search component  Holds the lightning-tree for all ProductCategories
  
  Modifications Log
  <Date>       <Author>            <Modification>
  
*********************************************************/
export default class scc_catalogLWC extends LightningElement {
    // @track productKeyword = 'gradek';
    @track productKeyword = '';
    @track productData = [];
    primaryKey = 'Id';
    gridColumns = [];
    productCategoryList = undefined;
    searchMenuData;
    parentsWithChildIds = new Set();
    breadcrumbs = [];
    restructuredData = {}
    selectedField
    isSubitem = false;
    @track selectedItem;
    @track isLoading = true;
    selectedItemValue;
    showSideMenu = true;
    @track noData = true;
    @track filterCriteria;
    @track transformedDataLength = 0;
    @track totalCount = 0;


 /*********************************************************
    Function Name  : columns
    Author         : sanika 
    Description    :  displying columns
    Param          : event
   
    ********************************************************/
    columns = [
        { label: 'ISBN', fieldName: 'ISBN', type: 'button', typeAttributes: { label: { fieldName: 'ISBN', type: 'text' }, name: 'viewRecords', target: '_blank', class: 'custom-button', variant: 'base' }, sortable: true },
        { label: 'Title Description', fieldName: 'Title_Description', sortable: true, type: 'text' },
        { label: 'Type', fieldName: 'Type', type: 'text', sortable: true, wrapText: true },
        { label: 'Grade Level', fieldName: 'Grade_Level', type: 'text', sortable: true },
        { label: 'Copyright', fieldName: 'Copyright', type: 'text', sortable: true },
        { label: 'Status', fieldName: 'Status', type: 'text', sortable: true },
        { label: 'Price', type: 'button-icon', initialWidth: 80, typeAttributes: { name: 'infoPrice', iconName: 'utility:hourglass', variant: 'border-filled', alternativeText: 'Info' }, sortable: true, hideDefaultActions: true }
    ];
/*********************************************************
    Function Name  : spinner 
    Author         : Sudharani Pathivada 
    Description    : The spinner will continue to display until the tree items are displayed."
    Param          : event - The click event object.
   
    ********************************************************/

    /* Spinner  added by sudha */
    loadData() {
        setTimeout(() => {
            this.isLoading = false;
        }, 2000); // Simulated 2 seconds delay
    }


/*********************************************************
    Function Name  : handleBreadcrumbClick
    Author         : Sudharani Pathivada 
    Description    : Handles the click event on breadcrumbs to navigate through hierarchical data.
    Param          : event - The click event object.
   
    ********************************************************/

    
    handleBreadcrumbClick(event) {
        const index = parseInt(event.target.dataset.index, 10);
        if (!isNaN(index)) {
            // Update the breadcrumbs array
            this.breadcrumbs = this.breadcrumbs.slice(0, index + 1);
            this.breadcrumbs[index].isLastNode = true;
            // Update the grid based on the selected breadcrumb
            const selectedBreadcrumb = this.breadcrumbs[index];
            if (selectedBreadcrumb) {
                const isLeafNode = !selectedBreadcrumb.nestedItems || selectedBreadcrumb.nestedItems.length === 0;
                if (isLeafNode) {
                    // Fetch child records only if it is a leaf node
                    this.getChildRecordsProductData(selectedBreadcrumb.name);
                } else {
                    // It's not a leaf node, do nothing or handle as needed
                    const selectedCategoryIdwithnull = '';
                    this.getChildRecordsProductData(selectedCategoryIdwithnull);
                    this.showSideMenu=true
                    this.productData = '';
                    // this.noData=false;
                }
                //console.log('Selected Breadcrumb caaling from handle braedcrumb :', this.getChildRecords(selectedBreadcrumb.name));
                // Update the grid to display menu items corresponding to the clicked breadcrumb
                this.collapseGridItem(selectedBreadcrumb);
            } else {
                console.error('Invalid breadcrumb index:', index);
            }
        }
    }

  /*********************************************************
 * Function Name  : collapseGridItem
 * Author         : Sudharani Pathivada 
 * Description    : Toggles the expansion state of the selected grid item and collapses its children if collapsing.
 * Param          : selectedBreadcrumb - The selected breadcrumb object representing the grid item.
 ********************************************************/

    collapseGridItem(selectedBreadcrumb) {
        const tree = this.template.querySelector('lightning-tree');
        const selectedItem = this.findItemByName(selectedBreadcrumb.name, tree.items);
        //console.log('Selected Item:', selectedItem);
        if (selectedItem) {
            selectedItem.expanded = !selectedItem.expanded; // Toggle the expansion state
            // Collapse all child items recursively if the item is being collapsed
            if (!selectedItem.expanded) {
                this.collapseChildren(selectedItem);
            }
            // Force re-render to reflect the changes
            tree.items = [...tree.items];
        } else {
            console.error('Selected Item not found');
        }
    }
/*********************************************************
 * Function Name  : findItemByName
 * Author         : Sudharani Pathivada 
 * Description    : Finds and returns the item with the specified name within the provided items array.
 * Param          : name - The name of the item to find.
 *                : items - The array of items to search within.
 * Returns        : The item object if found, otherwise null.
 ********************************************************/
    findItemByName(name, items) {
        for (let item of items) {
            if (item.name === name) {
                return item;
            }
            if (item.items) {
                let foundItem = this.findItemByName(name, item.items);
                if (foundItem) {
                    return foundItem;
                }
            }
        }
        return null;
    }
/*********************************************************
 * Function Name  : collapseChildren
 * Author         : Sudharani Pathivada 
 * Description    : Collapses all child items of the provided item by setting their 'expanded' property to false.
 * Param          : item - The parent item whose children need to be collapsed.
 ********************************************************/
    collapseChildren(item) {
        if (item.items) {
            item.items.forEach(child => {
                child.expanded = false; // Collapse the child item
                // Recursively collapse its children
            });
        }
    }



    /*********************************************************
 * Function Name  : productCategoryListData
 * Author         : Sanika 
 * Description    : Handles the data retrieved from the Apex wire method 'retrieveProductCategory'.
 * Param          : data - The data received from the wire method.
 *                : error - The error object if any error occurred during data retrieval.
 ********************************************************/

    /* fetching all grid data from apex */
    @wire(retrieveProductCategory) productCategoryListData({ data, error }) {
        if (data) {
            let obj = { data: data };
            this.productCategoryList = Object.assign({}, obj);
            // console.log('data after retriving is \n', data);
            this.productCategoryList.data.forEach(currentItem => {
                //TODO : currentItem
               // console.log(currentItem);
                if (currentItem.childProductCategoryList != undefined && currentItem.childProductCategoryList.length) {
                    this.parentsWithChildIds.add(currentItem.productCategoryId);
                }
            });
            this.searchMenuData = this.displayProductCategoryData();
            this.loadData();
            console.log('searchMenuData', this.searchMenuData);
        }
        else if (error) {
            console.log(error);
        }
    };
  /*********************************************************
 * Function Name  : resetSelection
 * Author         : sudha rani pathivada
 * Description    : Resets the selected category, product data, breadcrumbs, and collapses all grid items.
 ********************************************************/
    resetSelection() {
        this.breadcrumbs = '';
        this.selectedCategoryId = '';
        this.productData = '';
        // console.log('reset request');
        this.noData = true;
        this.totalCount=0;
        this.transformedDataLength=0;
        this.collapseAllGridItems();
        const scrollContainer = this.template.querySelector('.wrapword');
    if (scrollContainer) {
        scrollContainer.scrollTop = 0;
    }
        this.dispatchEvent(new RefreshEvent());
    }
    /*********************************************************
 * Function Name  : collapseAllGridItems
 * Author         : Sudha rani pathivada
 * Description    : Recursively collapses all child items of the provided items.
 * Param          : items - The array of items to collapse.
 ********************************************************/
    collapseAllGridItems() {
        const tree = this.template.querySelector('lightning-tree');
        if (tree) {
            // Collapse all grid items recursively
            this.collapseItemsRecursively(tree.items);
        }
    }
   /*********************************************************
 * Function Name  : collapseItemsRecursively
 * Author         : Sudha rani pathivada
 * Description    : Recursively collapses all child items of the provided items.
 * Param          : items - The array of items to collapse.
 ********************************************************/
    collapseItemsRecursively(items) {
        if (items) {
            items.forEach(item => {
                item.expanded = false; // Collapse the item
                if (item.items) {
                    this.collapseItemsRecursively(item.items); // Collapse its children recursively
                }
            });
        }
    }
    /**************   added by sanika  *******************/
    displayProductCategoryData() {
        if (this.productCategoryList?.data != undefined && this.productCategoryList?.data.length) {
           // console.log('after process data');
            let objectToJSON = JSON.stringify(this.productCategoryList.data);
            objectToJSON = objectToJSON.replace(/productCategoryId/g, 'name');
            objectToJSON = objectToJSON.replace(/productCategoryName/g, 'label');
            objectToJSON = objectToJSON.replace(/childProductCategoryList/g, 'items');
            objectToJSON = objectToJSON.replace(/"_children"\s*:\s*\[\],?/g, '    ');
            let JSONtoObjectValue = JSON.parse(objectToJSON);
            //console.log(JSONtoObjectValue);
            //console.log('check data processing:>>:' + JSON.stringify(JSONtoObjectValue));
            return JSONtoObjectValue;
        }
        return undefined;
    }
    get menuClass() {
        return this.showSideMenu ? 'menu' : 'menu hidden';
    }
    // toggleMenu() {
    //     this.showSideMenu = !this.showSideMenu;
    // }
    toggleMenu() {
        this.showSideMenu = !this.showSideMenu;
        
       
        // Ensure tooltips are hidden when menu is toggled
        this.taskTypeHelpTextClasscatalog = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        this.taskTypeHelpTextClasscatalog1 = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    }
    connectedCallback() {
       // console.log(this.productCategoryList);
    }

    clickToCollapseAll(e) {
        const grid = this.template.querySelector('lightning-tree');
        grid.collapseAll();

    }
    // renderedCallback() {
    //     loadStyle(this, CatalogGlobalStyleSheet).then(() => {
    //        // console.log("Loaded Successfully")
    //     }).catch(error => {
    //        // console.error("Error in loading the colors")
    //     })
    // }

  /*********************************************************
 * Function Name  : handleOnSelect
 * Author         : sudharani pathivada
 * Description    : Handles the selection event when a menu item is clicked.
 * Param          : event - The selection event object.
 ********************************************************/
    handleOnSelect(event) {
        const selectedCategoryId = event.detail.name;
        //this.getChildRecords(selectedCategoryId);
        const selectedItem = this.findSelectedItem(selectedCategoryId, this.searchMenuData);
        if (selectedItem) {
            const isLeafNode = selectedItem.items.length === 0;
            if (isLeafNode) {
                // Fetch child records only if it is a leaf node
                this.getChildRecordsProductData(selectedCategoryId);
            } else {
                // It's not a leaf node, do nothing or handle as needed
                const selectedCategoryIdwithnull = '';
                this.getChildRecordsProductData(selectedCategoryIdwithnull);
                this.productData = '';
                // this.noData=false;
            }
            // Clear breadcrumbs
            this.breadcrumbs = [];
            // Add breadcrumbs for the selected item and its ancestors
            this.addBreadcrumb(selectedItem);
            // Trigger breadcrumb update after adding breadcrumbs
            //console.log("Added breadcrumbs:", this.breadcrumbs);
            this.handleBreadcrumbUpdate();
        } else {
            //console.log('Selected Item Not Found');
        }
    }
/*********************************************************
 * Function Name  : addBreadcrumb
 * Author         : sudharani pathivada
 * Description    : Adds breadcrumbs for the selected item and its ancestors.
 * Param          : item - The selected item to add to breadcrumbs.
 *                  isLastNode - Boolean flag indicating if the item is the last node in the hierarchy (default: true).
 ********************************************************/
    addBreadcrumb(item, isLastNode = true) {
        // Check if the current item has nested items
        const hasNestedItems = !!item.items?.length;
        // const url = `/product-category/${item.name}`; 
        // Add the current item to breadcrumbs with isLastNode property
        this.breadcrumbs.unshift({
            name: item.name,
            label: item.label,
            isLastNode: isLastNode,
            expanded: hasNestedItems,
            nestedItems: hasNestedItems ? item.items : []
            //url:url
        });

        // Check if there's a parent item
        if (item.parentProductCategoryId) {
            // Find the parent item
            const parent = this.findParent(item.parentProductCategoryId, this.searchMenuData);

            // Ensure parent exists and it's not already in breadcrumbs to avoid infinite recursion
            if (parent && !this.breadcrumbs.some(crumb => crumb.label === parent.label)) {
                // If the current item is not the last node, pass false for isLastNode parameter
                const isLast = !hasNestedItems;
                this.addBreadcrumb(parent, false);
            }
        }
        // Check if there's a grandparent item
        if (item.grandparentProductCategoryId) {
            // Find the grandparent item
            const grandparent = this.findParent(item.grandparentProductCategoryId, this.searchMenuData);

            // Ensure grandparent exists and it's not already in breadcrumbs to avoid infinite recursion
            if (grandparent && !this.breadcrumbs.some(crumb => crumb.label === grandparent.label)) {
                // If the current item is not the last node, pass false for isLastNode parameter
                // const isLast = !hasNestedItems;
                this.addBreadcrumb(grandparent, false);
            }
        }
    }
    /*********************************************************
 * Function Name  : handleBreadcrumbUpdate
 * Author         : Sudha rani 
 * Description    : Updates the breadcrumbs array to trigger re-rendering of breadcrumb component.
 ********************************************************/
    handleBreadcrumbUpdate() {
        this.breadcrumbs = [...this.breadcrumbs];
        
    }

/*********************************************************
 * Function Name  : findParent
 * Author         : Sudha rani 
 * Description    : Finds the parent item in the menu data hierarchy.
 * Param          : parentCategoryId - The ID of the parent category.
 *                  menuData - The hierarchical menu data.
 * Returns        : The parent item if found, otherwise null.
 ********************************************************/
    findParent(parentCategoryId, menuData) {
        for (const category of menuData) {
            if (category.name === parentCategoryId) {
                return category; // Return the item if found at this level
            } else if (category.items) {
                // Recursive call to search for the selected item within nested items
                const parentItem = this.findParent(parentCategoryId, category.items);
                if (parentItem) {
                    return parentItem; // Return the item if found within nested items
                }
            }
        }
        return null; // Return null if the selected item is not found
    }

/*********************************************************
 * Function Name  : findSelectedItem
 * Author         : Sudha rani 
 * Description    : Finds the selected item in the menu data hierarchy.
 * Param          : selectedCategoryId - The ID of the selected category.
 *                  menuData - The hierarchical menu data.
 * Returns        : The selected item if found, otherwise null.
 ********************************************************/
    findSelectedItem(selectedCategoryId, menuData) {
        for (const category of menuData) {
            if (category.name === selectedCategoryId) {
                return category; // Return the item if found at this level
            } else if (category.items) {
                // Recursive call to search for the selected item within nested items
                const selectedItem = this.findSelectedItem(selectedCategoryId, category.items);
                if (selectedItem) {
                    return selectedItem; // Return the item if found within nested items
                }
            }
        }
        return null; // Return null if the selected item is not found
    }
/*********************************************************
 * Function Name  : getChildRecordsProductData
 * Author         : Sudha rani 
 * Description    : Retrieves child records based on the selected row ID.
 * Param          : selectedRow - The ID of the selected row.
 ********************************************************/

    getChildRecordsProductData(selectedRow) {
        let prodIds = [];
        getChildRecordsProductData({ selectedRowId: selectedRow })
            .then((result) => {
                result.forEach(category => {            
                    category.ProductCategoryProducts.forEach(product => {
                
                        prodIds.push(product.Product.Id);
                    });
                });
                if (prodIds.length > 0) {
                    // Call the Apex method getProductDetails imperatively
                    getProductDetails({ prodId: prodIds })
                        .then(result => {
                        
                            this.productData = result
                        
                            this.noData = false;
                        })
                        .catch(error => {
                            console.error('Error fetching product details:', error);
                            this.noData = true;
                        });
                } else {
                  //  console.log('No product IDs found.');
                    this.noData = true;
                }
            })
            .catch(error => {
               console.error('Error fetching category details:', error);
                this.noData = true;
            });
    }



   /*********************************************************
 * Function Name  : handleFilter
 * Author         : Sudha rani 
 * Description    : Handles the filter event to filter data based on search criteria.
 * Param          : event - The filter event object.
 ********************************************************/


   
    handleFilter(event) {
        const searchTerm = event.target.value.trim();
        if (!searchTerm || searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm)) {
            this.filterCriteria = '';
        } else {
            const searchTerms = searchTerm.split(/\s+/).filter(term => term);
            if (searchTerms.length > 1) {
                this.filterCriteria = searchTerm;
            } else if (/^\d{10,13}$/.test(searchTerm)) {
                this.filterCriteria = searchTerm;
            } else if (/^\d{1,5}$/.test(searchTerm)) {
                this.filterCriteria = searchTerm;
            } else {
                this.filterCriteria = searchTerm;
            }
        }
    }
   /*********************************************************
 * Function Name  : openChildTitlePage
 * Author         : Sudha Pathivada
 * Description    : Opens the child title page and dispatches a custom event.
 * Param          : event - The event object.
 ********************************************************/
    openChildTitlePage(event) {
      //  console.log('hi helo');
        this.showProductTitlePage = true;
        this.showSideMenu = false;
        this.noData = false;
        this.isLoading = false;
        this.displayProductCategoryData = false;
        const getdatafromchild = event.detail.parentSelectedProductRecord;
        //   this.pageRecordCount = event.detail.displayedRecords;
       // console.log('hi pageRecordCount', pageRecordCount);
      //  console.log('hi helo1', getdatafromchild);
        const selectedProductRecord = {
            ISBN: getdatafromchild.ISBN,
            productId: getdatafromchild.productId,
            Title_Description: getdatafromchild.Title_Description,
            Grade_Level: getdatafromchild.Grade_Level,
            Copyright: getdatafromchild.Copyright,
            Status: getdatafromchild.Status,
            Type: getdatafromchild.Type,
            Price: getdatafromchild.Price
        };
        //console.log('hi helo2', selectedProductRecord)
        const displayDEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                parentSelectedProductRecord: selectedProductRecord,
            }
        });
        this.dispatchEvent(displayDEvent);
       // console.log('yesopend', this.dispatchEvent);
    }

    /*********************************************************
 * Function Name  : togglePasswordHint
 * Author         : Sudha Pathivada
 * Description    : Toggles the visibility of the password hint popup.
 ********************************************************/
    taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHint() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClass = this.taskTypeHelpTextClass == hideCss ? showCss : hideCss;

    }
    taskTypeHelpTextClassfilter = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHintfilter() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClassfilter = this.taskTypeHelpTextClassfilter == hideCss ? showCss : hideCss;

    }
//   togglePasswordHintcatalog(event) {
//         if (event.type === 'mouseover') {
//             this.taskTypeHelpTextClasscatalog = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
//         } else if (event.type === 'mouseout') {
//             this.taskTypeHelpTextClasscatalog = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
//         }
//     }

//     togglePasswordHintcatalog1(event) {
//         if (event.type === 'mouseover') {
//             this.taskTypeHelpTextClasscatalog1 = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
//         } else if (event.type === 'mouseout') {
//             this.taskTypeHelpTextClasscatalog1 = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
//         }
  taskTypeHelpTextClasscatalog = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHintcatalog() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClasscatalog = this.taskTypeHelpTextClasscatalog == hideCss ? showCss : hideCss;
    }
     taskTypeHelpTextClasscatalog1 = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHintcatalog1() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClasscatalog1 = this.taskTypeHelpTextClasscatalog1 == hideCss ? showCss : hideCss;
    
    }
    /*********************************************************
 * Function Name  : handleTransformedDataLength
 * Author         : Sudha rani  pathivada 
 * Description    : Handles the transformed data length event and updates the component's data or UI.
 * Param          : event - The transformed data length event object.
 ********************************************************/
    handleTransformedDataLength(event) {
        this.transformedDataLength = event.detail.transformedDataLength;
        if (event.detail.totalFilteredRecords) {
            this.totalFilteredRecords = event.detail.totalFilteredRecords;
            this.totalCount = this.totalFilteredRecords; // Update totalCount with totalFilteredRecords
        } else {
            this.totalCount = event.detail.totalCount; // Update totalCount with original totalRecords
        }
        // Update parent component's data or UI based on the length of the transformed data received from the child component
    }
 /*********************************************************
 * Function Name  : handleSearchResultsAvailable
 * Author         : Sudha rani  pathivada 
 * Description    : Handles the showSideMenu event and updates the component's  UI.
 * Param          : event - SearchResultsAvailable event object.
 ********************************************************/
   handleSearchResultsAvailable() {
        // Close the toggle menu when search results are available
        this.showSideMenu = false;
    }
}