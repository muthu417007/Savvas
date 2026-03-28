/*********************************************************
  Component Name       : scc_catalogLWC
  Created Date         : 05/21/2024  
  Author               : Sudha Rani pathivada- Cognizant
  Description          : Nested component for scc_place  criteria search component  Holds the lightning-tree for all ProductCategories
  Modifications Log
  <Date>       <Author>            <Modification>
*********************************************************/
import { LightningElement, wire, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import catalogSearchTreeStylesheet from '@salesforce/resourceUrl/catalogSearchTreeStylesheet';
import retrieveProductCategory from '@salesforce/apex/scc_ProductCatalogApexClass.retrieveProductCategory';
import getChildRecordsProductData from '@salesforce/apex/scc_ProductCatalogApexClass.getChildRecordsProductData';
import getProductDetails from '@salesforce/apex/scc_ProductCatalogApexClass.getProductDetails';
import { RefreshEvent } from 'lightning/refresh';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
import getUserBillingAddress from '@salesforce/apex/scc_confirmAddress.getUserBillingAddress';
import getUserShippingAddress from '@salesforce/apex/scc_confirmAddress.getUserShippingAddress';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
export default class scc_catalogLWC extends LightningElement {
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
    filterSearchValue = '';
    @track enableLogs = false;
    columns = [
        { label: 'ISBN', fieldName: 'ISBN', type: 'button', typeAttributes: { label: { fieldName: 'ISBN', type: 'text' }, name: 'viewRecords', target: '_blank', class: 'custom-button', variant: 'base' }, sortable: true },
        { label: 'Title Description', fieldName: 'Title_Description', sortable: true, type: 'text' },
        { label: 'Type', fieldName: 'Type', type: 'text', sortable: true, wrapText: true },
        { label: 'Grade Level', fieldName: 'Grade_Level', type: 'text', sortable: true },
        { label: 'Copyright', fieldName: 'Copyright', type: 'text', sortable: true },
        { label: 'Status', fieldName: 'Status', type: 'text', sortable: true },
        { label: 'Price', type: 'button-icon', initialWidth: 80, typeAttributes: { name: 'infoPrice', iconName: 'utility:hourglass', variant: 'border-filled', alternativeText: 'Info' }, sortable: true, hideDefaultActions: true }
    ];
    loadData() {
        setTimeout(() => {
            this.isLoading = false;
        }, 2000);
    }
    handleBreadcrumbClick(event) {
        const index = parseInt(event.target.dataset.index, 10);
        if (!isNaN(index)) {
            this.breadcrumbs = this.breadcrumbs.slice(0, index + 1);
            this.breadcrumbs[index].isLastNode = true;
            const selectedBreadcrumb = this.breadcrumbs[index];
            if (selectedBreadcrumb) {
                const isLeafNode = !selectedBreadcrumb.nestedItems || selectedBreadcrumb.nestedItems.length === 0;
                if (isLeafNode) {
                    this.getChildRecordsProductData(selectedBreadcrumb.name);
                } else {
                    const selectedCategoryIdwithnull = '';
                    this.getChildRecordsProductData(selectedCategoryIdwithnull);
                    this.showSideMenu = true
                    this.productData = '';
                }
                this.collapseGridItem(selectedBreadcrumb);
            } else {
                if (this.enableLogs) console.error('Invalid breadcrumb index:', index);
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
        if (selectedItem) {
            selectedItem.expanded = !selectedItem.expanded;
            if (!selectedItem.expanded) {
                this.collapseChildren(selectedItem);
            }
            tree.items = [...tree.items];
        } else {
            if (this.enableLogs) console.error('Selected Item not found');
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
                child.expanded = false;
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
@wire(retrieveProductCategory, { selectedState: '$selectedStates' })
    productCategoryListData({ data, error }) {
        if (data) {
            if (this.enableLogs) {
                console.log('Retrieved product categories for', 
                    this.isInternalUser ? 'internal user' : 'external user');
            }
            let obj = { data: data };
            this.productCategoryList = Object.assign({}, obj);
            if (this.enableLogs) console.log('data after retrieving is \n', data);
            this.productCategoryList.data.forEach(currentItem => {
                if (currentItem.childProductCategoryList != undefined && currentItem.childProductCategoryList.length) {
                    this.parentsWithChildIds.add(currentItem.productCategoryId);
                }
            });
            this.searchMenuData = this.displayProductCategoryData();
            this.loadData();
            if (this.enableLogs) console.log('searchMenuData', this.searchMenuData);
        }
        else if (error) {
            if (this.enableLogs) console.log(error);
        }
    }
;
    /*********************************************************
   * Function Name  : resetSelection
   * Author         : sudha rani pathivada
   * Description    : Resets the selected category, product data, breadcrumbs, and collapses all grid items.
   ********************************************************/
    resetSelection() {
        this.breadcrumbs = '';
        this.selectedCategoryId = '';
        this.productData = '';
        this.noData = true;
        this.totalCount = 0;
        this.transformedDataLength = 0;
        this.collapseAllGridItems();
        const scrollContainer = this.template.querySelector('.catalog-panel-list-wrapper');
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
                item.expanded = false;
                if (item.items) {
                    this.collapseItemsRecursively(item.items);
                }
            });
        }
    }
    displayProductCategoryData() {
        if (this.productCategoryList?.data != undefined && this.productCategoryList?.data.length) {
            let objectToJSON = JSON.stringify(this.productCategoryList.data);
            objectToJSON = objectToJSON.replace(/productCategoryId/g, 'name');
            objectToJSON = objectToJSON.replace(/productCategoryName/g, 'label');
            objectToJSON = objectToJSON.replace(/childProductCategoryList/g, 'items');
            objectToJSON = objectToJSON.replace(/"_children"\s*:\s*\[\],?/g, '    ');
            let JSONtoObjectValue = JSON.parse(objectToJSON);
            if (this.enableLogs) console.log('check data processing:>>:' + JSON.stringify(JSONtoObjectValue));
            return JSONtoObjectValue;
        }
        return undefined;
    }
    get menuClass() {
        return this.showSideMenu ? 'menu' : 'menu hidden';
    }
    toggleMenu() {
        this.showSideMenu = !this.showSideMenu;
        this.taskTypeHelpTextClasscatalog = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        this.taskTypeHelpTextClasscatalog1 = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    }
    handleKeyPress(event) {
        if (event.key === 'Enter' || event.key === ' ') {
            this.toggleMenu();
        }
    }

connectedCallback() {
    // First check user type
    this.checkUserType()
        .then(() => {
            // Only continue with other initialization after user type is determined
            return getEnableConsoleLogsTrue();
        })
        .then(response => {
            this.enableLogs = response;
            if (this.enableLogs) {
                console.log('getEnableConsoleLogsTrue response is', response);
                console.log('Is Internal User:', this.isInternalUser);
            }
        })
        .catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });

    window.addEventListener('pNacatalogFilterFocus', this.focusfilterinput.bind(this));
}

async checkUserType() {
    try {
        const userInfoResp = await getUserInformation();
        if (this.enableLogs) {
            console.log('Raw userInfoResp:', userInfoResp);
        }

        let parsed = JSON.parse(userInfoResp);
        if (this.enableLogs) {
            console.log('Parsed user info:', parsed);
        }

        if (parsed && parsed.length > 0) {
            // Use explicit boolean check
            this.isInternalUser = Boolean(parsed[0].isInternal);
            
            if (this.enableLogs) {
                console.log('IsInternal value from backend:', parsed[0].isInternal);
                console.log('Set isInternalUser to:', this.isInternalUser);
            }
            
            if (this.isInternalUser) {
                this.selectedStates = '';
                if (this.enableLogs) console.log('Internal user - no state filtering');
            } else {
                if (this.enableLogs) console.log('External user - retrieving states');
                await this.retrieveUserAndAddresses();
            }
        }
    } catch (error) {
        console.error('Error checking user type:', error);
        console.error('Error details:', JSON.stringify(error));
        this.isInternalUser = false;
    }
}


    async retrieveUserAndAddresses() {
        if (this.isInternalUser) return;

        try {
            const [userInfoResp, billingAddresses, shippingAddresses] = await Promise.all([
                getUserInformation(),
                getUserBillingAddress(),
                getUserShippingAddress()
            ]);

            let parsed = JSON.parse(userInfoResp);
            let data = parsed[0];
            let userStatesSet = new Set();

            if (data.billing_State) {
                userStatesSet.add(data.billing_State);
                if (this.enableLogs) console.log('Added billing state:', data.billing_State);
            }
            if (data.shipping_State) {
                userStatesSet.add(data.shipping_State);
                if (this.enableLogs) console.log('Added shipping state:', data.shipping_State);
            }

            if (billingAddresses) {
                billingAddresses.forEach(addr => {
                    if (addr.State) {
                        userStatesSet.add(addr.State);
                        if (this.enableLogs) console.log('Added billing address state:', addr.State);
                    }
                });
            }

            if (shippingAddresses) {
                shippingAddresses.forEach(addr => {
                    if (addr.Provionce) {
                        userStatesSet.add(addr.Provionce);
                        if (this.enableLogs) console.log('Added shipping address state:', addr.Provionce);
                    }
                });
            }

            this.userStates = userStatesSet;
            this.selectedStates = Array.from(userStatesSet).join(',');
            
            if (this.enableLogs) {
                console.log('userStates Set:', this.userStates);
                console.log('selectedStates string:', this.selectedStates);
            }

            await this.refreshProductCategories();

        } catch (error) {
            if (this.enableLogs) {
                console.error('Error retrieving user info or addresses:', error);
            }
        }
    }


refreshProductCategories() {
    if (this.enableLogs) {
        console.log('Starting refreshProductCategories');
        console.log('Current selectedStates:', this.selectedStates);
    }
    
    return retrieveProductCategory({ selectedState: this.selectedStates })
        .then(data => {
            if (data) {
                if (this.enableLogs) {
                    console.log('Retrieved categories data:', JSON.stringify(data));
                }
                
                let obj = { data: data };
                this.productCategoryList = Object.assign({}, obj);
                this.productCategoryList.data.forEach(currentItem => {
                    if (currentItem.childProductCategoryList != undefined && currentItem.childProductCategoryList.length) {
                        this.parentsWithChildIds.add(currentItem.productCategoryId);
                    }
                });
                this.searchMenuData = this.displayProductCategoryData();
                this.loadData();
            }
        })
        .catch(error => {
            if (this.enableLogs) {
                console.error('Error in refreshProductCategories:', error);
                console.error('Error details:', JSON.stringify(error));
            }
        });
}


    
    focusfilterinput() {
        setTimeout(() => {
            if (this.template.querySelector(".pNacatalogFilter") != undefined) {
                this.template.querySelector(".pNacatalogFilter").focus();
            }
        }, 100);
    }
    clickToCollapseAll(e) {
        const grid = this.template.querySelector('lightning-tree');
        grid.collapseAll();
    }
    renderedCallback() {
        loadStyle(this, catalogSearchTreeStylesheet).then(() => {
        }).catch(error => {
            if (this.enableLogs) console.error("Error in loading the colors")
        })
    }
    @track selectedCategoryId = '';
    /*********************************************************
   * Function Name  : handleOnSelect
   * Author         : sudharani pathivada
   * Description    : Handles the selection event when a menu item is clicked.
   * Param          : event - The selection event object.
   ********************************************************/
    handleOnSelect(event) {
        this.noData = true;
        this.productData = []
        this.selectedCategoryId = '';
        this.selectedCategoryId = event.detail.name;
        if (this.enableLogs) console.log('selectedCategoryId', this.selectedCategoryId);
        const selectedItem = this.findSelectedItem(this.selectedCategoryId, this.searchMenuData);
        if (selectedItem) {
            const isLeafNode = selectedItem.items.length === 0;
            if (isLeafNode) {
                this.getChildRecordsProductData(this.selectedCategoryId);
            } else {
                const selectedCategoryIdwithnull = '';
                this.getChildRecordsProductData(selectedCategoryIdwithnull);
                this.productData = '';
            }
            this.breadcrumbs = [];
            this.addBreadcrumb(selectedItem);
            this.handleBreadcrumbUpdate();
        } else {
            if (this.enableLogs) console.log('Selected Item Not Found');
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
        const hasNestedItems = !!item.items?.length;
        this.breadcrumbs.unshift({
            name: item.name,
            label: item.label,
            isLastNode: isLastNode,
            expanded: hasNestedItems,
            nestedItems: hasNestedItems ? item.items : []
        });
        if (item.parentProductCategoryId) {
            const parent = this.findParent(item.parentProductCategoryId, this.searchMenuData);
            if (parent && !this.breadcrumbs.some(crumb => crumb.label === parent.label)) {
                const isLast = !hasNestedItems;
                this.addBreadcrumb(parent, false);
            }
        }
        if (item.grandparentProductCategoryId) {
            const grandparent = this.findParent(item.grandparentProductCategoryId, this.searchMenuData);
            if (grandparent && !this.breadcrumbs.some(crumb => crumb.label === grandparent.label)) {
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
                return category;
            } else if (category.items) {
                const parentItem = this.findParent(parentCategoryId, category.items);
                if (parentItem) {
                    return parentItem;
                }
            }
        }
        return null;
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
                return category;
            } else if (category.items) {
                const selectedItem = this.findSelectedItem(selectedCategoryId, category.items);
                if (selectedItem) {
                    return selectedItem;
                }
            }
        }
        return null;
    }
    /*********************************************************
     * Function Name  : getChildRecordsProductData
     * Author         : Sudha rani 
     * Description    : Retrieves child records based on the selected row ID.
     * Param          : selectedRow - The ID of the selected row.
     ********************************************************/
getChildRecordsProductData(selectedRow) {
    // Initialize prodIds array at the start
    let prodIds = [];
    
    if (this.enableLogs) {
        console.log('Selected Row:', selectedRow);
        console.log('Selected States:', this.selectedStates);
    }

    getChildRecordsProductData({ 
        selectedRowId: selectedRow,
        selectedState: this.isInternalUser ? '' : this.selectedStates 
    })
    .then((result) => {
        if (this.enableLogs) console.log('Category Results:', result);
        
        // Process results to collect product IDs
        if (result && result.length > 0) {
            result.forEach(category => {
                if (category.ProductCategoryProducts) {
                    category.ProductCategoryProducts.forEach(product => {
                        if (product.Product && product.Product.Id) {
                            prodIds.push(product.Product.Id);
                        }
                    });
                }
            });
            
            // Only proceed with getProductDetails if we have products
            if (prodIds.length > 0) {
                return getProductDetails({ prodId: prodIds });
            } else {
                this.noData = true;
                this.productData = [];
                return Promise.reject('No products found for this category');
            }
        } else {
            this.noData = true;
            this.productData = [];
            return Promise.reject('No category data found');
        }
    })
    .then(result => {
        if (result) {
            this.productData = result;
            const updateEvent = new CustomEvent('productdataupdate', { 
                detail: { productData: this.productData } 
            });
            this.dispatchEvent(updateEvent);
            if (this.enableLogs) console.log('Product Data:', this.productData);
            this.noData = false;
            this.selectedCategoryId = '';
        }
    })
    .catch(error => {
        if (this.enableLogs) console.error('Error:', error);
        this.noData = true;
        this.productData = [];
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
        this.filterSearchValue = searchTerm;
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
        this.showProductTitlePage = true;
        this.showSideMenu = false;
        this.noData = false;
        this.isLoading = false;
        this.displayProductCategoryData = false;
        const getdatafromchild = event.detail.parentSelectedProductRecord;
        const selectedProductRecord = {
            ISBN: getdatafromchild.ISBN,
            productId: getdatafromchild.productId,
            Title_Description: getdatafromchild.Title_Description,
            Grade_Level: getdatafromchild.Grade_Level,
            Copyright: getdatafromchild.Copyright,
            Status: getdatafromchild.Status,
            Type: getdatafromchild.Type,
            Price: getdatafromchild.Price,
            isInternalUser: getdatafromchild.isInternalUser,
            DisplayPrice: getdatafromchild.DisplayPrice,
            ListPrice: getdatafromchild.ListPrice,
            NetPrice: getdatafromchild.NetPrice,
            Discount: getdatafromchild.Discount,
            UserStatus: getdatafromchild.UserStatus,
            countryCodeISO: getdatafromchild.countryCodeISO,
            accountId: getdatafromchild.accountId
        };
        const displayDEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                parentSelectedProductRecord: selectedProductRecord,
            }
        });
        this.dispatchEvent(displayDEvent);
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
            this.totalCount = this.totalFilteredRecords;
        } else {
            this.totalCount = event.detail.totalCount;
        }
    }
    /*********************************************************
    * Function Name  : handleSearchResultsAvailable
    * Author         : Sudha rani  pathivada 
    * Description    : Handles the showSideMenu event and updates the component's  UI.
    * Param          : event - SearchResultsAvailable event object.
    ********************************************************/
    handleSearchResultsAvailable() {
        this.showSideMenu = false;
    }
    clearFilterInput() {
        this.filterSearchValue = '';
        this.filterCriteria = '';
    }
    @track userStates = new Set();
    @track selectedStates = '';
    @track isInternalUser = false;

}