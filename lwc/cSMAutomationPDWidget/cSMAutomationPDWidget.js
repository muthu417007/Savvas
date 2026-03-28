import { LightningElement, wire, api } from 'lwc';
import getColorAndStatus from '@salesforce/apex/CSMAutomation_StackedBarGraphController.getColorAndStatus';
import getCSMUsers from '@salesforce/apex/CSMAutomation_StackedBarGraphController.getCSMUsers';
import getCurrentUserRole from '@salesforce/apex/CSMAutomation_StackedBarGraphController.getCurrentUserRole';
import getOpportunityIdsByUser from '@salesforce/apex/CSMAutomation_AcctStatusGraphController.getOpportunityIdsByUser';
import getAccountIdsAndNamesFromOpportunities from '@salesforce/apex/CSMAutomation_AcctStatusGraphController.getAccountIdsAndNamesFromOpportunities';
import getServiceAppointmentDataByAccounts from '@salesforce/apex/CSMAutomation_AcctStatusGraphController.getServiceAppointmentDataByAccounts';
import USER_ID from '@salesforce/user/Id';
import graphText from '@salesforce/label/c.CSM_Automation_StackedBarGraphText';
import { loadScript } from 'lightning/platformResourceLoader';
import chartjs from '@salesforce/resourceUrl/ChartJS';

export default class CSMAutomationPDWidget extends LightningElement {
    chart;
    chartJsInitialized = false;
    serviceAppointmentData = [];
    statusColorMappings = {};
    hasData = false;
    graphText = graphText;
    selectedUserId;
    csmUserOptions = [];
    isPicklistDisabled = true;
    userId;

    @api recordId;
    accountId;

    connectedCallback() {
        this.initializePicklist();
        this.userId = USER_ID;
        console.log('this.userId =>'+this.userId);
       // this.userId = '0056T000008PiHQQA0';
       // this.loadOpportunityIds();
    }

    @wire(getColorAndStatus)
    wiredStatusColorMappings({ error, data }) {
        if (data) {
            data.forEach(mapping => {
                this.statusColorMappings[mapping.Status__c] = {
                    color: mapping.Color__c,
                    description: mapping.Status_Description__c // Use Status_Description__c for tooltips
                };
            });
            this.renderChartIfNeeded();
        } else if (error) {
            console.error('Error fetching status color mappings:', error);
        }
    }

    @wire(getOpportunityIdsByUser, { userId: '$userId' })
    wiredgetOpportunityIdsByUser({ error, data }) {
        if (data) {
            this.loadAccountIds(data);
            console.log(' data Test=>'+JSON.stringify(data));
            this.renderChartIfNeeded();
            console.log('Test');
        }
        else if (error) {
            console.error(error);
        }
    }



    initializePicklist() {
        getCurrentUserRole().then(role => {
            this.isPicklistDisabled = (role !== 'Professional Services Manager');
            console.log('isPicklistDisabled=>'+this.isPicklistDisabled);
            this.fetchCSMUsers();
        }).catch(error => {
            console.error('Error fetching current user role:', error);
        });
    }

    fetchCSMUsers() {
        getCSMUsers().then(users => {
            this.csmUserOptions = users.map(user => {
                return { label: user.Name, value: user.Id };
            });
            console.log('csmUserOptions=>'+JSON.stringify(this.csmUserOptions));
            this.selectedUserId = this.userId; // Set the default value to the current user
        }).catch(error => {
            console.error('Error fetching CSM users:', error);
        });
    }

    handleUserChange(event) {
        this.selectedUserId = event.detail.value;
        console.log('this.selectedUserId=>'+this.selectedUserId);
        this.userId = this.selectedUserId;
    }

    // loadOpportunityIds() {
    //     getOpportunityIdsByUser({ userId: this.userId })
    //         .then(opportunityIds => {
    //             this.loadAccountIds(opportunityIds);
    //         })
    //         .catch(error => {
    //             console.error('Error fetching opportunity IDs:', error);
    //         });
    // }



    loadAccountIds(opportunityIds) {
        getAccountIdsAndNamesFromOpportunities({ opportunityIds: opportunityIds })
        .then(accountMap => {
            this.accountMap = accountMap;
            this.loadServiceAppointmentData(Object.keys(accountMap));
        })
        .catch(error => {
            console.error('Error fetching account IDs and names:', error);
        });
    }

    loadServiceAppointmentData(accountIds) {
        getServiceAppointmentDataByAccounts({ accountIds: accountIds })
            .then(data => {
                console.log('service data=>'+JSON.stringify(data));
                this.serviceAppointmentData = data;
                this.hasData = this.serviceAppointmentData.length > 0;
                this.renderChartIfNeeded();
            })
            .catch(error => {
                console.error('Error fetching service appointment data:', error);
            });
    }

    renderedCallback() {
        if (this.chartJsInitialized) {
            return;
        }
        this.chartJsInitialized = true;

        loadScript(this, chartjs)
            .then(() => {
                this.renderChartIfNeeded();
            })
            .catch(error => {
                console.error('Error loading ChartJS:', error);
            });
    }

    renderChartIfNeeded() {
        if (this.chartJsInitialized) {
            requestAnimationFrame(() => {
                this.initializeChart();
            });
        }
    }

    initializeChart() {
        const canvas = this.template.querySelector('canvas');
        if (!canvas) {
            console.error('Canvas element not found.');
            return;
        }

        const ctx = canvas.getContext('2d');
        if (!ctx) {
            console.error('Unable to get canvas context.');
            return;
        }

        if (this.chart) {
            this.chart.destroy();
        }

        let labels = [];
        let datasets = {};

		if (this.hasData) {
            // Populate labels with account names
            this.serviceAppointmentData.forEach(appointment => {
                const accountName = this.accountMap[appointment.accountId];
                if (!labels.includes(accountName)) {
                    labels.push(accountName);
                }
            });

            // Initialize datasets
            Object.keys(this.statusColorMappings).forEach(status => {
                datasets[status] = {
                    label: status,
                    data: new Array(labels.length).fill(0),
                    backgroundColor: this.statusColorMappings[status]?.color || this.getRandomColor()
                };
            });

            // Populate datasets
            this.serviceAppointmentData.forEach(appointment => {
                const accountName = this.accountMap[appointment.accountId];
                const labelIndex = labels.indexOf(accountName);
                if (labelIndex !== -1) {
                    if (!datasets[appointment.status]) {
                        datasets[appointment.status] = {
                            label: appointment.status,
                            data: new Array(labels.length).fill(0),
                            backgroundColor: this.getRandomColor()
                        };
                    }
                    datasets[appointment.status].data[labelIndex] = appointment.count;
                } else {
                    console.error(`Account ${appointment.accountId} not found in labels.`);
                }
            });
        } else {
            // If no data, provide empty labels and datasets to show axes
            labels = [''];
            datasets = {
                empty: {
                    label: '',
                    data: [0],
                    backgroundColor: 'rgba(0,0,0,0)'
                }
            };
        }

        const chartDatasets = Object.values(datasets);

        // Custom plugin to align the title to the top-left
        const customTitlePlugin = {
            beforeDraw: function(chart) {
                const ctx = chart.ctx;
                ctx.save();
                ctx.font = 'bold 16px Arial';  // Specify the desired font size and family
                ctx.fillStyle = '#666';   // Title color
                ctx.textAlign = 'left';
                ctx.textBaseline = 'top';
                const x = chart.chartArea.left - 45;  // Align with the left of the chart area
                const y = chart.chartArea.top - 40;  // Slight padding from the top
                ctx.fillText('', x, y);
                ctx.restore();
            }
        };

        // Adjust canvas size dynamically
        const canvasWidth = this.serviceAppointmentData.length > 6 ? 1500 : 600;
        canvas.width = canvasWidth;

        this.chart = new Chart(ctx, {
            type: 'horizontalBar',
            data: {
                labels: labels,
                datasets: chartDatasets
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                legend: {
                    display: this.hasData,
                    position: 'bottom',
                    labels: {
                        fontSize: 8,
                        fontFamily: 'Arial',
                        boxWidth: 20,
                        padding: 10,
                        usePointStyle: true,
                        generateLabels: function(chart) {
                            const original = Chart.defaults.global.legend.labels.generateLabels;
                            const labels = original.call(this, chart);

                            labels.forEach(label => {
                                label.pointStyle = 'rect';
                                const status = label.text;
                                label.tooltipText = this.statusColorMappings[status]?.description || `No description for ${status}`;
                            });

                            return labels;
                        }.bind(this)
                    },
                    onHover: function(event, legendItem) {
                        const canvas = this.chart.canvas;
                        canvas.title = legendItem.tooltipText; // Set the tooltip text on hover
                    },
                    onLeave: function(event, legendItem) {
                        const canvas = this.chart.canvas;
                        canvas.title = ''; // Clear the tooltip text on leave
                    }
                },
                title: {
                    display: false,  // Disable the default title to avoid duplication
                },
                layout: {
                    padding: {
                        left: 10,
                        right: 10,
                        top: 40,  // Add some top padding to avoid overlap with title
                        bottom: 10
                    }
                },
                scales: {
                    xAxes: [{
                        stacked: true,
                        gridLines: {
                            display: true,
                            color: 'rgba(0, 0, 0, 0.1)',
                            lineWidth: 1
                        },
                        ticks: {
                            beginAtZero: true,
                            fontSize: 8,
                            fontFamily: 'Arial',
                            stepSize: 1,
                            callback: function(value) {
                                return value;
                            }
                        },
                        scaleLabel: {
                            display: true,
                            labelString: 'Record Count',
                            fontSize: 12,
                            fontFamily: 'Arial'
                        }
                    }],
                    yAxes: [{
                        stacked: true,
                        gridLines: {
                            display: false
                        },
                        scaleLabel: {
                            display: true,
                            labelString: 'Account Name',
                            fontSize: 12,
                            fontFamily: 'Arial'
                        },
                        ticks: {
                            beginAtZero: true,
                            fontSize: 8,
                            fontFamily: 'Arial'
                        },
                        categoryPercentage: 0.9,
                        barPercentage: 0.9

                    }],
                    barThickness: 10,  // Adjust bar thickness
                    maxBarThickness: 10
                },
                tooltips: {
                    callbacks: {
                        label: function(tooltipItem, data) {
                            const dataset = data.datasets[tooltipItem.datasetIndex];
                            const value = dataset.data[tooltipItem.index];
                            return `${dataset.label}: ${value}`;
                        }
                    }
                }              
            },
            plugins: [customTitlePlugin]
        });
    }

    getRandomColor() {
        const letters = '0123456789ABCDEF';
        let color = '#';
        for (let i = 0; i < 6; i++) {
            color += letters[Math.floor(Math.random() * 16)];
        }
        return color;
    }
}