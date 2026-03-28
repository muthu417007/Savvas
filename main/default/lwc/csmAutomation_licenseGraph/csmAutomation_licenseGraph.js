import { LightningElement } from 'lwc';
import processLicenseData from '@salesforce/apex/CSMAutomation_LicenseWidgetController.processLicenseData';
import calculateExpiringLicenses from '@salesforce/apex/CSMAutomation_LicenseWidgetController.calculateExpiringLicenses';
import { loadScript } from 'lightning/platformResourceLoader';
import CHART_JS from '@salesforce/resourceUrl/ChartJS';

export default class CsmAutomation_licenseGraph extends LightningElement {
    chartUtilization;
    chartExpiration;
    isChartJsInitialized = false;

    connectedCallback() {
        this.loadChartJsLibrary();
    }

    loadChartJsLibrary() {
        if (this.isChartJsInitialized) {
            return;
        }

        loadScript(this, CHART_JS)
            .then(() => {
                this.isChartJsInitialized = true;
                this.fetchUtilizationData();
                this.fetchExpirationData();
            })
            .catch((error) => {
                console.error('Error loading Chart.js', error);
            });
    }

    fetchUtilizationData() {
        processLicenseData()
            .then((data) => {
                this.renderUtilizationChart(data);
            })
            .catch((error) => {
                console.error('Error fetching utilization data', error);
            });
    }

    fetchExpirationData() {
        calculateExpiringLicenses()
            .then((data) => {
                this.renderExpirationChart(data);
            })
            .catch((error) => {
                console.error('Error fetching expiration data', error);
            });
    }

    renderUtilizationChart(data) {
        const labels = data.map((item) => item.label);
        const counts = data.map((item) => item.count);
    
        // Get the canvas for License Utilization
        const canvas = this.template.querySelector('.license-utilization');
        const ctx = canvas.getContext('2d');
    
        if (this.chartUtilization) {
            this.chartUtilization.destroy();
        }
    
        this.chartUtilization = new Chart(ctx, {
            type: 'horizontalBar',
            data: {
                labels: labels,
                datasets: [
                    {
                        data: counts,
                        backgroundColor: ['#F4D03F', '#E74C3C', '#2ECC71', '#3498DB', '#F39C12'],
                        borderColor: ['#D4AC0D', '#C0392B', '#27AE60', '#2980B9', '#D68910'],
                        borderWidth: 1,
                    },
                ],
            },
            options: this.getChartOptions(),
        });
    }
    
    renderExpirationChart(data) {
        const labels = data.map((item) => item.label);
        const counts = data.map((item) => item.count);
    
        // Get the canvas for License Expiration
        const canvas = this.template.querySelector('.license-expiration');
        const ctx = canvas.getContext('2d');
    
        if (this.chartExpiration) {
            this.chartExpiration.destroy();
        }
    
        this.chartExpiration = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [
                    {
                        data: counts,
                        backgroundColor: ['#E74C3C', '#F5B041'],
                        borderColor: ['#C0392B', '#F39C12'],
                        borderWidth: 1,
                    },
                ],
            },
            options: this.getChartOptions(),
        });
    }
    
    getChartOptions() {
        return {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                xAxes: [
                    {
                        ticks: {
                            beginAtZero: true,
                            stepSize: 50,
                            fontColor: '#333',
                            fontSize: 12,
                        },
                        gridLines: {
                            display: true, 
                            color: '#d3d3d3',
                            lineWidth: 1,
                            drawBorder: true,
                            drawTicks: true,
                        },
                        scaleLabel: {
                            display: true,
                            fontSize: 14,
                        },
                    },
                ],
                yAxes: [
                    {
                        ticks: {
                            fontColor: '#333',
                            fontSize: 12,
                        },
                        gridLines: {
                            display: true, 
                            color: '#d3d3d3',
                            lineWidth: 1,
                            drawBorder: true,
                            drawTicks: true,
                        },
                        scaleLabel: {
                            display: true,
                            fontSize: 14,
                        },
                        categoryPercentage: 0.9,
                        barPercentage: 0.9,
                    },
                ],
                barThickness: 10,
                maxBarThickness: 10
            },
            legend: {
                display: false, // Disable the legend
            },
            tooltips: {
                enabled: true,
            },
        };
    }    
}