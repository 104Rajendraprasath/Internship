import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getMaintenanceLogs from '@salesforce/apex/EquipmentMaintenanceCtrl.getMaintenanceLogs';

const ACTIONS = [
    { label: 'View Details', name: 'view_details' }
];

const COLUMNS =[
    { label: 'Log Number', fieldName: 'Name' },
    { label: 'Service Date', fieldName: 'Service_Date__c', type: 'date' },
    { label: 'Technician', fieldName: 'Technician__c' },
    { label: 'Cost', fieldName: 'Cost__c', type: 'currency' },
    { type: 'action', typeAttributes: { rowActions: ACTIONS } }
];

export default class EquipmentMaintenance extends NavigationMixin(LightningElement) {
    @api recordId; // Automatically gets the Equipment__c Record ID
    
    columns = COLUMNS;
    @track logs =[];
    wiredLogsResult; // Used to refresh the apex wire

    // UI State variables
    isLoading = true;
    isModalOpen = false;

    // Summary calculation variables
    totalCost = 0;
    averageCost = 0;
    recentDate = 'N/A';

    // 1. Wire Apex Method
    @wire(getMaintenanceLogs, { equipmentId: '$recordId' })
    wiredLogs(result) {
        this.wiredLogsResult = result;
        if (result.data) {
            this.logs = result.data;
            this.calculateSummary(result.data);
            this.isLoading = false;
        } else if (result.error) {
            this.showToast('Error', 'Error loading maintenance logs.', 'error');
            this.isLoading = false;
        }
    }

    // 2. Calculate Summary Totals
    calculateSummary(data) {
        if (data && data.length > 0) {
            this.totalCost = data.reduce((sum, record) => sum + (record.Cost__c || 0), 0);
            this.averageCost = this.totalCost / data.length;
            // Because the Apex query sorts DESC, the first record is the most recent
            this.recentDate = data[0].Service_Date__c; 
        } else {
            this.totalCost = 0;
            this.averageCost = 0;
            this.recentDate = 'N/A';
        }
    }

    // 3. Handle Row Action (Navigation)
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'view_details') {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: row.Id,
                    objectApiName: 'Maintenance_Log__c',
                    actionName: 'view'
                }
            });
        }
    }

    // 4. Button Handlers
    handleRefresh() {
        this.isLoading = true;
        refreshApex(this.wiredLogsResult).finally(() => {
            this.isLoading = false;
            this.showToast('Success', 'Maintenance logs refreshed', 'success');
        });
    }

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }

    // 5. Form Handlers
    handleSuccess(event) {
        this.isModalOpen = false;
        this.showToast('Success', 'Maintenance Log created successfully!', 'success');
        
        // Refresh the datatable to show the newly created record
        this.isLoading = true;
        refreshApex(this.wiredLogsResult).finally(() => {
            this.isLoading = false;
        });
    }

    // Reusable Toast Message utility
    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
    // Add this getter to calculate the number of records
    get logCount() {
        return this.logs ? this.logs.length : 0;
    }
}