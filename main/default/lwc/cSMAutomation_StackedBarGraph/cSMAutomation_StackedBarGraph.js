import { LightningElement, wire, api } from 'lwc';
import getCSMRecord from '@salesforce/apex/CSMAutomation_StackedBarGraphController.getCSMRecord';
import getServiceAppointmentData from '@salesforce/apex/CSMAutomation_StackedBarGraphController.getServiceAppointmentData';
import getColorAndStatus from '@salesforce/apex/CSMAutomation_StackedBarGraphController.getColorAndStatus';
import graphText from '@salesforce/label/c.CSM_Automation_StackedBarGraphText';
import getChildAccounts from '@salesforce/apex/CSMAutomation_StackedBarGraphController.getChildAccounts';
import { loadScript } from 'lightning/platformResourceLoader';
import chartjs from '@salesforce/resourceUrl/ChartJS';

export default class CSMAutomation_StackedBarGraph extends LightningElement {
    chart;
    chartJsInitialized = false;
    serviceAppointmentData = [];
    statusColorMappings = {};
    hasData = false;
    graphText = graphText;

    @api recordId;
    accountId;
    accountName;

    childAccounts = [];
    selectedAccountId;
    accountOptions = [];
  
    @wire(getCSMRecord, { csmObjectId: '$recordId' })
    wiredAccountId({ error, data }) {
        console.log('data=>'+JSON.stringify(data));
        if (data) {
            this.accountId = data.Account_Name_V2__c;   // Account related to CSM object (parent account Id)
            this.accountName = data.Account_Name_V2__r.Name; // Account Name
            this.selectedAccountId = this.accountId;  // Set parent account as default
            this.fetchChildAccounts();
            this.fetchServiceAppointmentData();
        } else if (error) {
            console.error('Error fetching account ID:', error);
        }
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

    // Method to fetch child accounts of the parent account
    fetchChildAccounts() {
        getChildAccounts({ accountId: this.accountId })
            .then(result => {
                let options = [];

                // Add parent account as the first option with dynamic label (accountName)
                options.push({ label: this.accountName, value: this.accountId });

                // Add child accounts to the options
                result.forEach(account => {
                    options.push({ label: account.Name, value: account.Id });
                });

                this.accountOptions = options;  // Set options for the combobox
            })
            .catch(error => {
                console.error('Error fetching child accounts:', error);
            });
    }

    fetchServiceAppointmentData() {
        getServiceAppointmentData({ accountId: this.selectedAccountId })  // Use selectedAccountId instead of accountId
            .then(data => {
                this.serviceAppointmentData = data;
                this.hasData = this.serviceAppointmentData.length > 0;
                this.renderChartIfNeeded();
            })
            .catch(error => {
                console.error('Error fetching service appointment data:', error);
            });
    }

    handleAccountChange(event) {
        this.selectedAccountId = event.detail.value;
        this.fetchServiceAppointmentData();
 
    }

    renderedCallback() {
        if (this.chartJsInitialized) {
            return;
        }
        this.chartJsInitialized = true;

        loadScript(this, chartjs)
            .then(() => {
                //
                const scrollContainer = this.template.querySelector('.chart-container1');
                console.log('scrollContainer',scrollContainer);
                scrollContainer.style.height = '500px';
                scrollContainer.style.overflowY = auto;
                console.log('scrollContainer',scrollContainer);
                               // this.renderChartIfNeeded();
                                this.initializeChart();
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
            // Populate labels
            this.serviceAppointmentData.forEach(appointment => {
                if (!labels.includes(appointment.isbnProduct)) {
                    labels.push(appointment.isbnProduct);
                }
            });
const baseHeight = 400;
const additionalHeight = 40 * labels.length;
canvas.style.height = `${Math.min(additionalHeight, 800)}px`;
            // Initialize datasets
            Object.keys(this.statusColorMappings).forEach(status => {
                datasets[status] = {
                    label: status,
                    data: new Array(labels.length).fill(0),
                    backgroundColor: this.statusColorMappings[status].color || this.getRandomColor()
                };
            });

            // Populate datasets
            this.serviceAppointmentData.forEach(appointment => {
                const labelIndex = labels.indexOf(appointment.isbnProduct);
                if (labelIndex !== -1) {
                    if (!datasets[appointment.status]) {
                        // If the status is not in the mapping, create a new dataset with a random color
                        datasets[appointment.status] = {
                            label: appointment.status,
                            data: new Array(labels.length).fill(0),
                            backgroundColor: this.getRandomColor()
                        };
                    }
                    datasets[appointment.status].data[labelIndex] = appointment.count;
                } else {
                    console.error(`ISBN Product ${appointment.isbnProduct} not found in labels.`);
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
                ctx.fillText('Service Appointment Status by ISBN Product', x, y);
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
                        bottom: 5
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
                            labelString: 'ISBN Product',
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