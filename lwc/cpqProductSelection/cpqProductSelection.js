import { LightningElement, api, track, wire } from 'lwc';
import getMasterCategoryId from "@salesforce/apex/CpqProductSelectionCtrl.getMasterCategoryId";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import PRODUCT_CATEGORY from "@salesforce/schema/ProductCategory"

export default class CpqProdSelection extends LightningElement {
    // Using ProductCategoryProduct object junction object between ProductCategory and Product2
    @track categoryProducts = [];
    
    // The Quote's record Id
    @api recordId;
    @api xdm;
    @api cd;
    @track error;
    @track isLoaded = false;

    // Ticket W-014415: Controls breadcrumb and visibility
    @track breadcrumbItems = [];
    @track showBackOnProductList = false;

    // Controls visibility of ProductCategoryHierarchy
    @track showCategoryTree = false;
    
    // Variables passing To ProductCategoryHierarchy
    productCategoryApi = 'ProductCategory';
    parentField = 'ParentCategoryId';
    colNameApi = 'Name';
    @track masterCategoryId;
    @track gridColumns = [];

    // Controls visibility for ProductList component
    @track showProductList = false;
    
    // Information for CpqProductList
    // NEW W-015738 update this to an empty array
    @track selectedCategoryIds = [];
    // searchTerms
    @track savedSearchTerm = '';
    @track termSearch;
    @track warnUserSearch = false;

    // Controls visibility for ProductCart
    @track showProductCart = false;

    

    // Conditional label - tied to Save & Exit Button
    get saveExitLabel() {
        if (this.showProductCart) {
            return 'Save & Exit'
        } else {
            return 'Close'
        }
    }

    // Conditional help message to guide user
    get helpMessage() {
        if (this.showProductCart) {
            return 'All current existing Quote Lines. Click Save & Exit to return to the Quote Line Editor and refresh it'
        } else if (this.showProductList) {
            return 'Select one or more Products and then click Add Selected Products'
        } else {
            return 'Please Filter your Products by Category or Search for ISBN Number or Description'
        }
    }

    // Conditional title for Product List based on which search was used
    get productListTitle() {
        if (this.termSearch) {
            return 'Products matching "' + this.termSearch + '"'
        } 
        else {
            // NEW changing verbiage to plural
            return 'Products matching these Categories';
        }
    }

    // On Load
    connectedCallback() {
        console.log('Parent connectedCallback');
        console.log('XDM', this.xdm);
        console.log('CD', this.cd);

        // Spinner logic (1 second)
        setTimeout(() => {
            this.isLoaded = true;
        }, 1000);
    }

    /*
    *********************************************************
    Function Name  : objectInformation
    Author         : Frank Berni
    Description    : function uses the Product Category API to set up columns for ProductCategoryHierarchy component
    Param          : objectApiName
    return         : gridColumns
    ********************************************************
    */
    @wire(getObjectInfo, { objectApiName: PRODUCT_CATEGORY })
    objectInformation({ data, error }) {
        // console.log('objectInformation');
        if (data) {
        // console.log('data: ' + JSON.stringify(data));    
        this.colNameApi.split(",").map((item) => {
            item.trim();
            this.gridColumns.push({
            label: data.fields[item].label,
            fieldName: item,
            type: "text",
            });
        });
        // console.log('gridColumns: ' + JSON.stringify(this.gridColumns));
        }
    }

    /*
    *********************************************************
    Function Name  : wiredGetMasterCategoryId
    Author         : Frank Berni
    Description    : Calls getMasterCategoryId to have available for ProductCategoryHierarchy component
    Param          : 
    return         : masterCategoryId
    ********************************************************
    */
    @wire(getMasterCategoryId)
    wiredGetMasterCategoryId({error, data}) {
        console.log('wiredGetMasterCategoryId');
        console.log('recordId: ' + this.recordId);
        if(data) {
            console.log('data: ' + JSON.stringify(data));
            this.masterCategoryId = data;
            this.showCategoryTree = true;
        } else if(error) {
             // Throw toast message for user
             console.log('error: ' + error);
             if (Array.isArray(error.body)) {
                 this.error = error.body.map(e => e.message).join(', ');
             } else if (error.body && typeof error.body.message === 'string') {
                 this.error = error.body.message;
             } else if(typeof error === 'string'){
                 this.error = error;
             }
             this.template.querySelector('c-cpq-toast').showToast('error', 'Error finding Master Category RecordId:', this.error);
             console.log('Error getCategoryProductsByCategory: ', JSON.stringify(this.error));
        }
    }
  
    /*
    *********************************************************
    Function Name  : handleFilterProducts
    Author         : Frank Berni
    Description    : Takes the categoryIds chosen and sends it to the ProductList. showProductList is set to true
    Param          : event
    return         : showProductList
    ********************************************************
    */
    handleFilterProducts(event) {
        // NEW updated variable name
        console.log('handleFilterProducts');
        this.selectedCategoryIds = [];
        this.selectedCategoryIds = event.detail.categoryIds;
        console.log('selectedCategoryIds: ' + this.selectedCategoryIds);
        if (this.selectedCategoryIds) {
            // hides CategoryHierarchy Tree and shows ProductList adds display:none to style tag for c-cpq-product-category-hierarchy
            this.hideCategoryTree();
            this.showCategoryTree = false;
            this.showProductList = true;
            this.termSearch = '';
        }
    }

    /*
    *********************************************************
    Function Name  : handleShowCart
    Author         : Frank Berni
    Description    : Function to reveals the ProductCart
    Param          : event
    return         : showProductCart
    ********************************************************
    */
    handleShowCart(event) {
        console.log('handleShowCart Parent');
        this.showProductList = false;
        this.showProductCart = true;
        console.log('showProductCart: ' + this.showProductCart);
    }

    /*
    *********************************************************
    Function Name  : handleSaveExit
    Author         : Frank Berni
    Description    : Tied to the Close/Save & Exit button and calls doClose function
    Param          : event
    return         : 
    ********************************************************
    */
    handleSaveExit(event) {
        console.log('handleSaveExit');
        this.doClose();
    }

    /*
    *********************************************************
    Function Name  : doClose
    Author         : Frank Berni
    Description    : Function uses xdm and cd to control closing popup window and refresh the Quote Line Editor
    Param          : event
    return         : 
    ********************************************************
    */
    async doClose() {
        console.log('doClose');
        // debugger; // this freezes code execution and allows code debugging in the browser console
        // console.log('cd');
        // console.log(this.cd);
        let _cd = JSON.parse(JSON.stringify(this.cd));
        console.log('_cd', _cd);

        _cd.redirect.save = false;
        _cd.redirect.auto = true;
        _cd.actions = ['Reload']; //this reloads the parent page after closing

        console.log('_cd after', _cd);

        let rpc = new this.xdm.Rpc(
        {},
        {
            remote: {
            postMessage: {}
            },
            local: {
            postMessage: function(){}
            }
        }
        );
        
        rpc.postMessage(JSON.stringify(_cd));
        console.log('rpc message posted!');
    }

    /*
    *********************************************************
    Function Name  : handleHideCategories
    Author         : Frank Berni
    Description    : Hides category hierarchy tree when on ProductList
    Param          : event
    return         : 
    ********************************************************
    */
     handleHideCategories(event) {
        console.log('handleHideCategories');
        this.showCategoryTree = false;
     }

    /*
    *********************************************************
    Function Name  : handleBackFromList
    Author         : Frank Berni
    Description    : Back button under ProductList is clicked, CategoryHierarchy will render and ProductList will disappear
    Param          : event
    return         : 
    ********************************************************
    */
    handleBackFromList(event) {
        console.log('handleBackFromList');
        // Clearing all stored values and resetting visibility
        this.savedSearchTerm = '';
        this.termSearch = '';
        // NEW reset categoryIds
        this.categoryIds = [];
        this.warnUserSearch = false;
        this.showProductList = false;
        this.showCategoryTree = true;
        // have javascript remove display:none to style tag for c-cpq-product-category-hierarchy
        this.renderCategoryTree();
    }

    /*
    *********************************************************
    Function Name  : handleBackFromCart
    Author         : Frank Berni
    Description    : Back button under ProductCart, ProductList will render and ProductCart will disappear
    Param          : event
    return         : 
    ********************************************************
    */
    handleBackFromCart(event) {
        console.log('handleBackFromCart');
        this.showProductCart = false;
        this.showProductList = true;
    }

    /*
    *********************************************************
    Function Name  : handleCategoriesFromCart
    Author         : Frank Berni
    Description    : Back button under ProductCart, CategoryHierarchy will render and ProductCart will disappear
    Param          : event
    return         : 
    ********************************************************
    */
    handleCategoriesFromCart(event) {
        console.log('handleCategoriesFromCart');
        // Clearing all stored values and resetting visibility
        this.savedSearchTerm = '';
        this.termSearch = '';
        // NEW reset categoryIds
        this.categoryIds = [];
        this.warnUserSearch = false;
        this.showProductCart = false;
        // Ticket W-014415 streamlining Back to Categories button so it renders on ProductList when ISBN13/Description search is used
        this.showProductList = false;
        this.showBackOnProductList = false;
        this.showCategoryTree = true;
        this.renderCategoryTree();
    }
    
    /*
    *********************************************************
    Function Name  : handleSearchChange
    Author         : Frank Berni
    Description    : Ticket W-014412: Search bar input function - updates savedSearchTerm after every new value entered
    Param          : event
    return         : 
    ********************************************************
    */
    handleSearchChange(event) {
        this.savedSearchTerm = event.target.value;
        // uses CSS to hide categoryTree
        this.hideCategoryTree();
        console.log('this.savedSearchTerm', this.savedSearchTerm);
    }

    /*
    *********************************************************
    Function Name  : handleSearchClick
    Author         : Frank Berni
    Description    : Ticket W-014412: Search button - uses termSearch to call Apex 
    Param          : event
    return         : 
    ********************************************************
    */
    handleSearchClick(event) {
        console.log('handleSearchClick');
        
        // Validation check to warn User to enter text first
        if(!this.savedSearchTerm) {
            this.warnUserSearch = true;
            return;
        }

        this.termSearch = this.savedSearchTerm;
        this.warnUserSearch = false;
        // If the categoryIds was populated before clicking this button, clear its value
        if (this.termSearch) {
            // NEW reset categoryIds
            this.categoryIds = [];
        }
        console.log('termSearch: ' + this.termSearch);
        if (this.termSearch) {
            // Hides CategoryHierarchy and reveals ProductList;
            this.showCategoryTree = false;
            this.showProductList = true;
            // Ticket W-014415 render the Back to Categories Button
            this.showBackOnProductList = true;
        }
    }

    /*
    *********************************************************
    Function Name  : handleEnterSearch
    Author         : Frank Berni
    Description    : Tied to ISBN/Description search - allows user to search by pressing Enter on input field
    Param          : event
    return         : 
    ********************************************************
    */
    handleEnterSearch(event) {
        if (event.key === 'Enter') {
            // Using template.querySelector to find the search button and click it
            const searchButton = this.template.querySelector('[data-id="search-button"]');
            if (searchButton) {
                searchButton.click();
            }
        }
    }

    /*
    *********************************************************
    Function Name  : handleUpdateBreadcrumbs
    Author         : Frank Berni
    Description    : Ticket W-014415:Tied to breadcrumbs - assigns breadcrumbs array from CategoryHierarchy tree to breadcrumbItems
    Param          : event
    return         : this.breadcrumbItems
    ********************************************************
    */
    handleUpdateBreadcrumbs(event) {
        console.log('handleUpdateBreadcrumbs');
        this.breadcrumbItems = event.detail.breadcrumbs;
        console.log('breadcrumbItems: ' + this.breadcrumbItems);

    }

    /*
    *********************************************************
    Function Name  : handleUpdateBreadcrumbs
    Author         : Frank Berni
    Description    : Ticket W-014415:Tied to breadcrumbs - clicking breadcrumb category link - sends user to CategoryHierarchyTree (MVP vers)
    Param          : event
    return         : this.breadcrumbItems
    ********************************************************
    */
    handleBreadCrumbClick(event) {
        console.log('handledBreadCrumbClick');
        const categoryIds = event.target.value;
        console.log('categoryIds', JSON.stringify(categoryIds));
        // This redirects user back to Category Hierarchy Tree
        this.handleBackFromList(event);
    }

    /*
    *********************************************************
    Function Name  : hideCategoryTree
    Author         : Frank Berni
    Description    : Ticket W-014415: Uses querySelector to assign style.display = none so treeGrid keeps its previous state when hidden
    Param          : 
    return         : 
    ********************************************************
    */
    hideCategoryTree() {
        console.log('hideCategoryTree');
        const categoryTree = this.template.querySelector('.categoryTree');
        console.log(JSON.stringify(categoryTree));
        if(categoryTree) {
            categoryTree.style.display = 'none';
        }
    }

    /*
    *********************************************************
    Function Name  : renderCategoryTree
    Author         : Frank Berni
    Description    : Ticket W-014415: Uses querySelector to assign style.display = block so treeGrid keeps its previous state when revealed
    Param          : 
    return         : 
    ********************************************************
    */
    renderCategoryTree() {
        console.log('renderCategoryTree');
        const categoryTree = this.template.querySelector('.categoryTree');
        console.log(JSON.stringify(categoryTree));
        if(categoryTree) {
            categoryTree.style.display = 'block';
        }
    }

}