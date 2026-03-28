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

    chartHeightAdjusted = false;
    lastISBNCount = null;
    adjustHeightTimeout = null;

    @api recordId;
    accountId;
    accountName;

    childAccounts = [];
    selectedAccountId;
    accountOptions = [];

    @wire(getCSMRecord, { csmObjectId: '$recordId' })
    wiredAccountId({ error, data }) {
        if (data) {
            this.accountId = data.Account_Name_V2__c;
            this.accountName = data.Account_Name_V2__r.Name;
            this.selectedAccountId = this.accountId;
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
                    description: mapping.Status_Description__c
                };
            });
            this.renderChartIfNeeded();
        } else if (error) {
            console.error('Error fetching status color mappings:', error);
        }
    }

    fetchChildAccounts() {
        getChildAccounts({ accountId: this.accountId })
            .then(result => {
                let options = [];
                options.push({ label: this.accountName, value: this.accountId });
                result.forEach(account => {
                    options.push({ label: account.Name, value: account.Id });
                });
                this.accountOptions = options;
            })
            .catch(error => {
                console.error('Error fetching child accounts:', error);
            });
    }

    fetchServiceAppointmentData() {
        getServiceAppointmentData({ accountId: this.selectedAccountId })
            .then(data => {
                this.serviceAppointmentData = data;
                this.hasData = this.serviceAppointmentData.length > 0;
                this.renderChartIfNeeded(); // Re-render chart after fetching new data
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
                this.renderChartIfNeeded();
            })
            .catch(error => {
                console.error('Error loading ChartJS:', error);
            });
    }

    renderChartIfNeeded() {
        if (this.chartJsInitialized && Object.keys(this.statusColorMappings).length > 0) {
            requestAnimationFrame(() => {

                // Destroy the existing chart before re-rendering
                if (this.chart) {
                    this.chart.destroy();
                }

                // Initialize chart with the latest data
                this.initializeChart();

                // Reset flags for height adjustment
                this.chartHeightAdjusted = false;
                this.adjustChartHeight();
            });
        }
    }

    adjustChartHeight() {
        const container = this.template.querySelector('.chart-container');
        const canvas = this.template.querySelector('canvas');
        const isbnCount = this.serviceAppointmentData.length;

        // Ensure the chart, container, and canvas are ready
        if (!this.chart || !container || !canvas) {
            console.warn('Chart or container is not initialized yet.');
            return;
        }

        // Skip adjustment if data is not available
        if (isbnCount === 0) {
           return;
        }

        if (this.chartHeightAdjusted) {
            return;
        }

        if (isbnCount > 10) {
            // Handle cases where ISBN count exceeds 10
            container.style.maxHeight = '320px';
            container.style.overflowY = 'auto';
            const dynamicHeight = isbnCount * 20; // Adjust height dynamically based on ISBN count
            canvas.style.height = `${dynamicHeight}px`;
            this.chart.options.maintainAspectRatio = false;
        } else {
            // Handle cases where ISBN count is 10 or less
            container.style.maxHeight = '320px';
            container.style.overflowY = 'hidden';

            // Dynamically adjust height for fewer ISBNs to prevent cropping
            const staticHeight = Math.max(isbnCount * 23, 200); // Ensure a minimum height of 200px
            canvas.style.height = `${staticHeight}px`;
            this.chart.options.maintainAspectRatio = false; // Disable aspect ratio for better fit
        }

        // Mark adjustment as complete to prevent re-execution
        this.chartHeightAdjusted = true;

        // Update chart to apply new dimensions
        this.chart.update();
    }

    initializeChart() {
        const canvas = this.template.querySelector('canvas');
        const ctx = canvas.getContext('2d');

        if (!canvas || !ctx) {
            console.error('Canvas element not found or unable to get context.');
            return;
        }

        let labels = [];
        let datasets = {};
        let isEmpty = false;

        if (this.hasData) {
            this.serviceAppointmentData.forEach(appointment => {
                if (!labels.includes(appointment.isbnProduct)) {
                    labels.push(appointment.isbnProduct);
                }
            });

            Object.keys(this.statusColorMappings).forEach(status => {
                datasets[status] = {
                    label: status,
                    data: new Array(labels.length).fill(0),
                    backgroundColor: this.statusColorMappings[status].color || this.getRandomColor()
                };
            });

            this.serviceAppointmentData.forEach(appointment => {
                const labelIndex = labels.indexOf(appointment.isbnProduct);
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
                    console.error(`ISBN Product ${appointment.isbnProduct} not found in labels.`);
                }
            });
        } else {
            // Empty state: adjust labels and datasets for no data
            isEmpty = true;
            datasets = {
                empty: {
                    label: 'No Data',
                    data: [0],
                    backgroundColor: 'rgba(200, 200, 200, 0.5)'
                }
            };
        }

        const chartDatasets = Object.values(datasets);

        const customTitlePlugin = {
            beforeDraw: function(chart) {
                const ctx = chart.ctx;
                const chartArea = chart.chartArea;

                const defaultLeft = 200;
                const x = chartArea.left > defaultLeft ? chartArea.left - 35 : defaultLeft;
                const y = chartArea.top > 20 ? chartArea.top - 35 : 20;

                ctx.save();
                ctx.font = 'bold 16px Arial';
                ctx.fillStyle = '#666';
                ctx.textAlign = 'left';
                ctx.textBaseline = 'top';

                ctx.fillText('Service Appointment Status by ISBN Product', x, y);
                ctx.restore();
            }
        };

        // Adjust the canvas height based on whether data exists
        const canvasWidth = isEmpty ? 600 : this.serviceAppointmentData.length > 6 ? 1500 : 600;
        const canvasHeight = isEmpty ? 150 : 400; // Smaller height for empty state
        canvas.width = canvasWidth;
        canvas.height = canvasHeight;

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
                        fontSize: 12,
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
                        top: 40,  // Add more padding at the top to make sure the title and x-axis don't overlap
                        bottom: 5  // Add more space at the bottom for the legend and x-axis labels
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
                            fontSize: 14,
                            fontFamily: 'Arial',
                            stepSize: 1,
                            callback: function(value) {
                                return value;
                            }
                        },
                        scaleLabel: {
                            display: true,
                            labelString: 'Record Count',
                            fontSize: 14,
                            fontFamily: 'Arial',
                            fontStyle : 'bold'
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
                            fontSize: 14,
                            fontFamily: 'Arial',
                             fontStyle : 'bold'
                        },
                        ticks: {
                            beginAtZero: true,
                            fontSize: 10,
                            fontFamily: 'Arial'
                        },
                        categoryPercentage: 0.9,
                        barPercentage: 0.9
                    }],
                    barThickness: 10,
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

    // Generate a random color
    getRandomColor() {
        const letters = '0123456789ABCDEF';
        let color = '#';
        for (let i = 0; i < 6; i++) {
            color += letters[Math.floor(Math.random() * 16)];
        }
        return color;
    }
}