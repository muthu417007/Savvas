import { LightningElement, api } from 'lwc';

// Import custom labels
import ensxapp__Pager_Previous from '@salesforce/label/ensxapp.Pager_Previous';
import ensxapp__Pager_Next from '@salesforce/label/ensxapp.Pager_Next';
import ensxapp__Pager_FirstPage from '@salesforce/label/ensxapp.Pager_FirstPage';
import ensxapp__Pager_LastPage from '@salesforce/label/ensxapp.Pager_LastPage';
import ensxapp__Pager_Total_Records from '@salesforce/label/ensxapp.Pager_Total_Records';

export default class EnsxtxPagination extends LightningElement {
    @api pagingOptions

    pageSizes = [
        { label: 5, value: 5 },
        { label: 10, value: 10 },
        { label: 25, value: 25 },
        { label: 50, value: 50 },
        { label: 100, value: 100 }
    ]

    label = {
        ensxapp__Pager_Previous,
        ensxapp__Pager_Next,
        ensxapp__Pager_FirstPage,
        ensxapp__Pager_LastPage,
        ensxapp__Pager_Total_Records
    }

    get pages() {
        return Math.ceil(this.pagingOptions.totalRecords / this.pagingOptions.pageSize)
    }

    get page_size() {
        return this.pagingOptions.pageSize
    }

    get previous_disabled() {
        return this.pagingOptions.pageNumber < 2
    }

    get next_disabled() {
        return this.pagingOptions.pageNumber >= this.pages
    }

    handlePageSizeChange(event) {
        this.handlePagingOptionsChange({ ...this.pagingOptions, pageSize: event.detail.value, pageNumber: 1 })
    }

    handlePreviousSelect() {
        this.handlePagingOptionsChange({ ...this.pagingOptions, pageNumber: this.pagingOptions.pageNumber - 1 })
    }

    handleNextSelect() {
        this.handlePagingOptionsChange({ ...this.pagingOptions, pageNumber: this.pagingOptions.pageNumber + 1 })
    }

    handleFirstSelect() {
        this.handlePagingOptionsChange({ ...this.pagingOptions, pageNumber: 1 })
    }

    handleLastSelect() {
        this.handlePagingOptionsChange({ ...this.pagingOptions, pageNumber: this.pages })
    }

    handlePageSelection = (event) => {
        this.handlePagingOptionsChange({ ...this.pagingOptions, pageNumber: event.currentTarget.dataset.page })
    }

    handlePagingOptionsChange(pagingOptions) {
        this.dispatchEvent(new CustomEvent('pagingchange', {
            detail: {
                pagingOptions
            }
        }))
    }
}