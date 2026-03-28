/*******************************************************************************************************
 * @Component Name: Scc_placeOrderCatalogLWC
 * @Description: Lightning web component for displaying Catalog.
 * @Created By: CTS
 * @Created On: 17/04/2024
 * *****************************************************************************************************
 * Modification Log:
 * -----------------------------------------------------------------------------------------------------
 * Developer        Date            Description
 * -----------------------------------------------------------------------------------------------------
 */
import { LightningElement, wire, track, api } from 'lwc';
import retrieveProductCategory from '@salesforce/apex/scc_ProductCatalogApexClass.retrieveProductCategory';
import getChildRecordsProductData from '@salesforce/apex/scc_ProductCatalogApexClass.getChildRecordsProductData';
import isGuestUser from '@salesforce/apex/scc_checkOutLWC_Controller.isGuestUser';
import deleteAllCartItems from '@salesforce/apex/scc_addItemsToCartController.deleteAllCartItems';
import getProductDetails from '@salesforce/apex/scc_ProductCatalogApexClass.getProductDetails';
import { RefreshEvent } from 'lightning/refresh';
import { refreshCartSummary } from 'commerce/cartApi';
import { loadStyle } from 'lightning/platformResourceLoader';
import catalogSearchTreeStylesheet from '@salesforce/resourceUrl/catalogSearchTreeStylesheet';
import scc_checkout_cart from "@salesforce/resourceUrl/scc_checkout_cart";
import scc_checkout_cart_white from "@salesforce/resourceUrl/scc_checkout_cart_white";
import guestCartDetails from '@salesforce/apex/scc_confirmAddress.guestCartDetails';
import { CartSummaryAdapter } from "commerce/cartApi";
import MESSAGE_CHANNEL from '@salesforce/messageChannel/scc_MessageChannel__c';
import { publish, MessageContext } from 'lightning/messageService';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
import getUserBillingAddress from '@salesforce/apex/scc_confirmAddress.getUserBillingAddress';
import getUserShippingAddress from '@salesforce/apex/scc_confirmAddress.getUserShippingAddress';
class productQuantityWrapper {
    productId; productDetails; quantity; disableQuantity;
    constructor(productId, productDetails, quantity = '', disableQuantity = true,) {
        this.productId = productId;
        this.productDetails = productDetails;
        this.quantity = quantity;
        this.disableQuantity = disableQuantity;
    }
}
export default class Scc_placeOrderCatalogLWC extends LightningElement {
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
    @track isGuest = false;
    selectedItemValue;
    showSideMenu = true;
    @track noData = true;
    @track filterCriteria;
    @track transformedDataLength = 0;
    @track totalCount = 0;
    @track productQuantityData = [];
    @track addSelectedToCartBtnDisabled = true;
    @track totalQuantity = 0
    @track itemsInCart = [];
    @track itemsList = [];
    @track addToCart = false;
    @track pageReLoad = true;
    @track clearCartBtnDisabled = true;
    @track reviewCartDisabled = true;
    @track reviewCartPage = false;
    @track clearCartItems = false;
    @track currentRecordId;
    @track showcatalog = true;
    @track selectedProducts = new Map();
    @track productsInCart = 0;
    @api userselection = [];
    @track userInputs = [];
    @track activeCartId;
    @track isModalOpen = false;
    @track enableLogs = false;
    labels = {
        scc_checkout_cart,
        scc_checkout_cart_white
    }
    filterSearchValue = '';
    @wire(MessageContext)
    messageContext;
    constructor() {
        super();
        this.userInputs = [];
        isGuestUser().then(response => {
            if (response) {
                this.isGuest = true;
                const urlParams = new URLSearchParams(window.location.search);
                this.activeCartId = urlParams.get('CartId');
                this.fetchcartDetails();
            }
        }).catch(error => {
            if (this.enableLogs) console.log('error in checking if it is a guest user', error);
        })
    }
    @track userStates = new Set();
    @track selectedStates = '';
    
   async connectedCallback() {
    await this.checkUserType();
    
    getEnableConsoleLogsTrue().then(response => {
        this.enableLogs = response;
        if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
    }).catch(error => {
        if (this.enableLogs) console.log('error is', error);
    });

    if (this.userselection) {
         this.userInputs=this.userselection;
        console.log('User selection in connectedCallback:', this.userselection);
    }

    this.initializeUserStates();
    
    this.template.addEventListener('keydown', this.handleKeydown.bind(this));
    window.addEventListener('placeOrdercatalogFilterFocus', this.focusfilterinput.bind(this));
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
            this.isInternalUser = Boolean(parsed[0].isInternal);
            
            if (this.enableLogs) {
                console.log('IsInternal value:', parsed[0].isInternal);
                console.log('Set isInternalUser to:', this.isInternalUser);
            }
        }
    } catch (error) {
        console.error('Error checking user type:', error);
        this.isInternalUser = false;
    }
}
async initializeUserStates() {
    try {
        // Step 1: Fetch all user-related states
        const [userInfoResp, billingAddresses, shippingAddresses] = await Promise.all([
            getUserInformation(),
            getUserBillingAddress(),
            getUserShippingAddress()
        ]);

         if (this.enableLogs) {
            console.log('\n=== Address Data Debug Information ===');
            
            console.log('\nBilling Addresses:');
            console.log('Total billing addresses:', billingAddresses.length);
            billingAddresses.forEach((addr, index) => {
                console.log(`\nBilling Address ${index + 1}:`);
                console.log('Full address object:', addr);
                console.log('State:', addr.State);
                console.log('Available fields:', Object.keys(addr));
            });
            
            console.log('\nShipping Addresses:');
            console.log('Total shipping addresses:', shippingAddresses.length);
            shippingAddresses.forEach((addr, index) => {
                console.log(`\nShipping Address ${index + 1}:`);
                console.log('Full address object:', addr);
                console.log('Province:', addr.Provionce); 
                console.log('Available fields:', Object.keys(addr));
            });
        }

        // Step 2: Parse user information
        let parsed = JSON.parse(userInfoResp);
        let userData = parsed[0];

        // Step 3: Initialize a Set for unique states
        this.userStates = new Set();

        // Step 4: Add standard billing and shipping states
        if (userData.billing_State) this.userStates.add(userData.billing_State.toUpperCase());
        if (userData.shipping_State) this.userStates.add(userData.shipping_State.toUpperCase());

        // Step 5: Add alternate billing states
        billingAddresses.forEach(addr => {
            if (addr.State) this.userStates.add(addr.State.toUpperCase());
        });

        // Step 6: Add alternate shipping states
        shippingAddresses.forEach(addr => {
            if (addr.Provionce) this.userStates.add(addr.Provionce.toUpperCase());
        });

        // Step 7: Set the selected states as a comma-separated string
        this.selectedStates = Array.from(this.userStates).join(',');

        if (this.enableLogs) {
            console.log('Final Collected States:', Array.from(this.userStates));
            console.log('Comma-separated States:', this.selectedStates);
        }

        // Step 8: Refresh product categories based on the collected states
        await this.refreshProductCategories();

    } catch (error) {
        console.error('Error initializing user states:', error);
    }
}

async refreshProductCategories() {
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

    disconnectedCallback() {
        this.template.removeEventListener('keydown', this.handleKeydown);
    }
    focusfilterinput() {
        setTimeout(() => {
            if (this.template.querySelector(".placeOrdercatalogFilter") != undefined) {
                this.template.querySelector(".placeOrdercatalogFilter").focus();
            }
        }, 100);
    }
    handleKeydown(event) {
        if (event.key === 'Escape') {
            if (this.isModalOpen) {
                this.closeModal();
            }
        }
    }
    renderedCallback() {
        loadStyle(this, catalogSearchTreeStylesheet).then(() => {
        }).catch(error => {
            if (this.enableLogs) console.error("Error in loading the colors")
        })
    }
    productSearchBtnSectionConfig = {
        addSelectedToCartBtnLabel: 'Add Selected (number) To Cart',
        addSelectedToCartBtnDisabled: true,
        clearCartBtnLabel: 'Clear Cart (number)',
        clearCartBtnDisabled: true,
        reviewCartLabel: 'Review Cart (number)',
        reviewCartDisabled: true,
        productAddedToCart: 0,
    }
    get displayProductSearchBtnSectionConfig() {
        let local_ProductSearchBtnSectionConfig = Object.assign({}, this.productSearchBtnSectionConfig);
        local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel = local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.clearCartBtnLabel = local_ProductSearchBtnSectionConfig.clearCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.reviewCartLabel = local_ProductSearchBtnSectionConfig.reviewCartLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        return local_ProductSearchBtnSectionConfig;
    }
    addSelectedToCartHandleClick(event) {
        if (!JSON.parse(this.template.querySelector('.add-to-cart').getAttribute('aria-disabled'))) {
            this.addToCart = true;
        }
    }
    handleQuantityChange(event) {
        this.totalQuantity = event.detail;
        if (this.totalQuantity > 0) {
            this.addSelectedToCartBtnDisabled = false;
        } else {
            this.addSelectedToCartBtnDisabled = true;
        }
    }
    get addToCartButtonLabel() {
        return `Add to Cart (${this.totalQuantity})`;
    }
    get clearCartButtonLabel() {
        return `Clear Cart (${this.productsInCart})`;
    }
    get reviewCartButtonLabel() {
        return `Review Cart (${this.productsInCart})`;
    }
    handleReviewCartCount() {
        this.selectedProducts = new Map();
        this.addSelectedToCartBtnDisabled = true;
        this.clearCartItems = false;
        this.addToCart = false;
        this.totalQuantity = 0;
        if (this.userInputs[0].guestCartId != '' && this.userInputs[0].guestCartId !== undefined) {
            this.refreshCart();
        } else {
            this.refreshSummary();
        }
        this.dispatchEvent(new RefreshEvent());
        const selectedCategoryIdwithnull = '';
        this.getChildRecordsProductData(selectedCategoryIdwithnull);
        this.showSideMenu = true;
    }
    handlerefreshevent() {
        if (this.userInputs[0].guestCartId != '' && this.userInputs[0].guestCartId !== undefined) {
            this.refreshCart();
        } else {
            this.refreshSummary();
        }
    }
    handleresetaddtocart() {
        this.addToCart = false
        this.addSelectedToCartBtnDisabled = true;
        this.clearCartItems = false;
        this.dispatchEvent(new RefreshEvent());
    }
    async refreshSummary() {
        const response = await refreshCartSummary()
            .then((result => {
                this.isLoading = false;
                this.isEmptyCart = true;
            }));
    }
    refreshCart() {
        let cartId = this.userInputs[0].guestCartId != '' ? this.userInputs[0].guestCartId : '';
        guestCartDetails({ guestCartId: cartId }).then(response => {
            if (response) {
                this.activeCartId = response.Id;
                this.productsInCart = this.convertToInt(response.TotalProductCount);
                this.isLoading = false;
                this.isEmptyCart = true;
                publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });
            }
        }).catch(error => {
            if (this.enableLogs) console.log('error in fetching guestCartDetails', error);
        })
    }
    clearCartHandleClick(event) {
        if (!JSON.parse(this.template.querySelector('.clear-cart').getAttribute('aria-disabled'))) {
            this.isModalOpen = true;
            setTimeout(() => {
                this.template.querySelector('.emailRprtCloseBtn').focus();
            }, 100);
            this.focusCloseButton();
        }
    }
    handleClearCart() {
        if (this.isGuest) {
            this.handleClearAllItems();
        } else {
            this.clearCartItems = true;
        }
        this.isModalOpen = false;
    }
    handleClearAllItems() {
        this.isLoading = true;
        deleteAllCartItems({ activeCartId: this.activeCartId })
            .then(() => {
                const customEvent = new CustomEvent('refreshevent');
                this.dispatchEvent(customEvent);
                this.refreshCart();
                this.setProductCount();
            })
            .catch((e) => {
                if (this.enableLogs) console.error('lwc delete all cart items error - ', e);
            });
    }
    setProductCount() {
        this.productsInCart = "0";
        this.clearCartBtnDisabled = true;
        this.reviewCartDisabled = true;
        publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });
    }
    closeModal() {
        this.isModalOpen = false;
        const button = this.template.querySelector(".clear-cart");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }
    }
    handleCancel() {
        this.isModalOpen = false;
        const button = this.template.querySelector(".clear-cart");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }
    }
    reviewCartHandleClick(event) {
        if (!JSON.parse(this.template.querySelector('.review-cart').getAttribute('aria-disabled'))) {
            this.showcatalog = false;
            this.reviewCartPage = true;
            this.nodata = true;
            const customEvent = new CustomEvent('hideparenttab');
            this.dispatchEvent(customEvent);
        }
    }
    convertToInt(value) {
        return parseInt(value, 10);
    }
    @wire(CartSummaryAdapter)
    setCartSummary({ data, error }) {
        if (data) {
            this.activeCartId = data.cartId;
            this.productsInCart = this.convertToInt(data.totalProductCount);
            if (this.productsInCart > 0) {
                this.clearCartBtnDisabled = false;
                this.reviewCartDisabled = false;
                this.clearCartItems = false;
            } else {
                this.clearCartBtnDisabled = true;
                this.reviewCartDisabled = true;
            }
            publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });
        } else if (error && !this.isGuest) {
            if (this.enableLogs) console.error(error);
            this.productsInCart = 0;
            this.activeCartId = '';
            this.setProductCount();
        }
    }
    setProductCount() {
        this.productsInCart = "0";
        this.clearCartBtnDisabled = true;
        this.reviewCartDisabled = true;
        publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });
    }
    fetchcartDetails() {
        guestCartDetails({ guestCartId: this.userInputs[0].guestCartId }).then(response => {
            if (response) {
                this.activeCartId = response.Id;
                this.productsInCart = this.convertToInt(response.TotalProductCount);
                if (this.productsInCart > 0) {
                    this.clearCartBtnDisabled = false;
                    this.reviewCartDisabled = false;
                    this.clearCartItems = false;
                } else {
                    this.clearCartBtnDisabled = true;
                    this.reviewCartDisabled = true;
                }
                publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });
            }
        }).catch(error => {
            if (this.enableLogs) console.log('error in fetching guestCartDetails', error);
            this.productsInCart = 0;
            this.setProductCount();
        })
    }
    get selectedItemsToCart() {
        let rowIndex = local_productQuantityData.filter(element => element.quantity === rowId);
        return 0;
    }
    loadData() {
        setTimeout(() => {
            this.isLoading = false;
        }, 2000);
    }
    handleSearchResultsAvailable() {
        this.showSideMenu = false;
    }

@wire(retrieveProductCategory, { selectedState: '$selectedStates' })
productCategoryListData({ data, error }) {
    if (data) {
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
    else if (error) {
        if (this.enableLogs) console.log(error);
    }
}
    resetSelection() {
        this.breadcrumbs = '';
        this.selectedCategoryId = '';
        this.productQuantityData = '';
        this.noData = true;
        this.transformedDataLength = 0;
        this.totalCount = 0;
        this.totalQuantity = 0;
        this.addSelectedToCartBtnDisabled = true;
        this.collapseAllGridItems();
        const scrollContainer = this.template.querySelector('.catalog-panel-list-wrapper');
        if (scrollContainer) {
            scrollContainer.scrollTop = 0;
        }
        this.dispatchEvent(new RefreshEvent());
    }
    collapseAllGridItems() {
        const tree = this.template.querySelector('lightning-tree');
        if (tree) {
            this.collapseItemsRecursively(tree.items);
        }
    }
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
    /*********************************************************
     * Function Name  : handleOnSelect
     * Author         : Your Name
     * Description    : Handles the selection event, identifies if the selected item is a leaf node,
     *                  fetches child records if necessary, and updates breadcrumbs.
     * Param          : event - The event object containing details about the selected item.
     ********************************************************/
    handleOnSelect(event) {
        this.noData = true;
        this.productData = []
        this.selectedCategoryId = '';
        const selectedCategoryId = event.detail.name;
        const selectedItem = this.findSelectedItem(selectedCategoryId, this.searchMenuData);
        if (selectedItem) {
            const isLeafNode = selectedItem.items.length === 0;
            if (isLeafNode) {
                this.getChildRecordsProductData(selectedCategoryId);
            } else {
                const selectedCategoryIdwithnull = '';
                this.getChildRecordsProductData(selectedCategoryIdwithnull);
                this.transformedDataLength = 0;
                this.totalCount = 0;
                this.productQuantityData = '';
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
     * Author         : Sudha rani pathivada
     * Description    : Adds the current item to the breadcrumbs and recursively adds its parent 
     *                  and grandparent items. Ensures breadcrumbs are built correctly with nested structure.
     * Param          : item - The current item to add to the breadcrumbs.
     *                  isLastNode - Boolean indicating if the current item is the last node in the breadcrumb trail.
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
    handleBreadcrumbUpdate() {
        this.breadcrumbs = [...this.breadcrumbs];
    }
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
     * Author         : Sudha rani pathivada
     * Description    : Searches for an item within a nested menu structure based on the selected category ID.
     *                  Utilizes recursion to traverse through nested items.
     * Param          : selectedCategoryId - The ID of the selected category to search for.
     *                  menuData - The nested menu data to search within.
     * Returns        : The selected category item if found, otherwise null.
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
     * Author         : Sudha rani Pathivada
     * Description    : Fetches child product records based on the selected row and then
     *                  fetches product details for those products. Updates the product data
     *                  and product quantity data accordingly.
     * Param          : selectedRow - The selected row ID to fetch child product records.
     ********************************************************/
getChildRecordsProductData(selectedRow) {
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
            this.productQuantityData = [];
            for (let oneProduct of this.productData) {
                let oneProductQuantity = new productQuantityWrapper(oneProduct.productId, oneProduct, '0', true);
                this.productQuantityData.push(oneProductQuantity);
            }
            if (this.productQuantityData.length > 0) {
                this.noData = false;
            }
        }
    })
    .catch(error => {
        if (this.enableLogs) console.error('Error:', error);
        this.noData = true;
        this.transformedDataLength = 0;
        this.totalCount = 0;
        this.productData = [];
    });
}
    /*********************************************************
     * Function Name  :handleBreadcrumbClick
     * Author         : Sudharani Pathivada 
     * Description    : 
     * Param          : selectedBreadcrumb - The selected breadcrumb object representing the grid item.
     ********************************************************/
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
                    this.transformedDataLength = 0;
                    this.totalCount = 0;
                    this.showSideMenu = true
                }
                this.collapseGridItem(selectedBreadcrumb);
            } else {
                if (this.enableLogs) console.error('Invalid breadcrumb index:', index);
            }
        }
    }
    /*********************************************************
     * Function Name  : collapseGridItem
     * Author         : Sudharani Pathivada 
     * Description    : Toggles the expansion state of the selected grid item and collapses its children if collapsing.
     * Param          : selectedBreadcrumb - The selected breadcrumb object representing the grid item.
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
            if (this.enableLogs) console.error('Selected Item not found');
        }
    }
    /*********************************************************
     * Function Name  : findItemByName
     * Author         : Sudharani Pathivada 
     * Description    : Finds and returns the item with the specified name within the provided items array.
     * Param          : name - The name of the item to find.
     *                : items - The array of items to search within.
     * Returns        : The item object if found, otherwise null.
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
     * Function Name  : collapseChildren
     * Author         : Sudharani Pathivada 
     * Description    : Collapses all child items of the provided item by setting their 'expanded' property to false.
     * Param          : item - The parent item whose children need to be collapsed.
     ********************************************************/
    collapseChildren(item) {
        if (item.items) {
            item.items.forEach(child => {
                child.expanded = false;
            });
        }
    }
    /*********************************************************
  * Function Name  : handleFilter
  * Author         : Sudha Rani Pathivada
  * Description    : Handles the filter input event to set the filter criteria based on the search term.
  *                  If the search term is less than 3 characters and not a valid number, the filter criteria is cleared.
  *                  Otherwise, the search term is split and filtered based on different conditions.
  * Param          : event - The event object containing the value of the filter input.
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
     * Author         : SudhaRani Pathivada
     * Description    : Handles the event to retrieve the selected product record and dispatches 
     *                  an event to notify another component to display the selected product title page.
     * Param          : event - The event object containing details about the selected product.
     ********************************************************/
    openChildTitlePage(event) {
        const selectedProductRecord = event.detail.parentSelectedProductRecord;
        const displayDEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                parentSelectedProductRecord: selectedProductRecord,
            }
        });
        this.dispatchEvent(displayDEvent);
    }
    /****************************************************************
     * Author         : Sudharani Pathivada
     * Description    : Toggles the visibility of the password hint tooltip by
     *                  switching the CSS classes to show or hide the tooltip.
     ****************************************************************/
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
     * Author         : Sudharani Pathivada
     * Description    : Handles the event to update the transformed data length and the total
     *                  count of filtered or original records based on the event details.
     * Param          : event - The event object containing details about the transformed data length
     *                  and the total count of filtered or original records.
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
    clearFilterInput() {
        if (this.filterSearchValue == '' || this.filterSearchValue == null) {
            this.filterSearchValue = '';
            this.filterCriteria = '';
        }
        else {
            this.filterSearchValue = '';
            this.filterCriteria = '';
        }
    }
    focusCloseButton() {
        const closeButton = this.template.querySelector('[data-id="closeButton"]');
        if (closeButton) {
            closeButton.focus();
        } else {
            if (this.enableLogs) console.error('Close button not found');
        }
    }
    focusOutClose(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.cancel-modal-button').focus();
            }
        }
    }
    focusOutButton(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.closebtnOnFocus').focus();
            }
        }
    }
// get selectedAddressState() {
//     if (this.userInputs && this.userInputs.length > 0) {
//         let states = [];
//         if (this.userInputs[0].billState) {
//             states.push(this.userInputs[0].billState);
//         }
//         if (this.userInputs[0].shipState) {
//             states.push(this.userInputs[0].shipState);
//         }
//         // If we have one or both states, return them as a comma-separated string
//         // If none, return null
//         return states.length > 0 ? states.join(',') : null;
//     }
//     return null;
// }

}