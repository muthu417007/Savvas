import { LightningElement, wire, track } from 'lwc';
import getUsersInHierarchyWithCount from '@salesforce/apex/CSMAutomation_UserHierarchyController.getUsersInHierarchyWithCount';
import getAccountsForSelectedUsers from '@salesforce/apex/CSMAutomation_UserHierarchyController.getAccountsForSelectedUsers';

export default class UserHierarchyComboBox extends LightningElement {
    @track userOptions = [];
    @track selectedUserIds = [];
    @track accountOptions = [];
    @track selectedAccountIds = [];
    isLoading = true;
    error;

    // Store the logged-in user ID separately
    loggedInUserId;

    // Fetch user hierarchy data
    @wire(getUsersInHierarchyWithCount)
    wiredUsers({ error, data }) {
        if (data) {
            this.isLoading = false;

            // Populate user options
            this.userOptions = data.users.map(user => ({
                label: user.Name,
                value: user.Id,
            }));

            // Store the logged-in user ID
            this.loggedInUserId = data.loggedInUser.Id;

            // Initialize with the logged-in user's ID
            this.selectedUserIds = [this.loggedInUserId];

            // Fetch accounts for the logged-in user
            this.loadAccounts([this.loggedInUserId]);
            this.error = undefined;
        } else if (error) {
            this.isLoading = false;
            this.error = error;
            this.userOptions = [];
        }
    }

    // Fetch accounts related to selected users dynamically
    loadAccounts(userIds) {
        if (!userIds || userIds.length === 0) {
            console.warn('No user IDs provided. Clearing account options.');
            this.accountOptions = [];
            this.selectedAccountIds = [];
            return;
        }

        getAccountsForSelectedUsers({ userIds })
            .then((data) => {
                // Map account options for the dual-listbox
                this.accountOptions = data.preselectedAccounts.map(account => ({
                    label: account.Name,
                    value: account.Id,
                }));

                // Preselect all accounts
                this.selectedAccountIds = this.accountOptions.map(account => account.value);
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.accountOptions = [];
            });
    }

    // Handle user selection change
    handleUserChange(event) {
        this.selectedUserIds = event.detail.value;

        // Check if the logged-in user is removed
        if (!this.selectedUserIds.includes(this.loggedInUserId)) {
            // Clear preselected accounts if the logged-in user is removed
            this.accountOptions = [];
            this.selectedAccountIds = [];
        }

        // Fetch accounts for the updated list of selected users
        this.loadAccounts(this.selectedUserIds);
    }

    // Handle account selection change
    handleAccountChange(event) {
        this.selectedAccountIds = event.detail.value;
    }
}