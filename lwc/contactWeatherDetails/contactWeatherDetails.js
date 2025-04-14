import { LightningElement, api, wire } from 'lwc';
import getWeatherForContact from '@salesforce/apex/WeatherLWCController.getWeatherForContact';
import refreshWeather from '@salesforce/apex/WeatherLWCController.refreshWeather';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { refreshApex } from '@salesforce/apex';

export default class ContactWeatherDetails extends LightningElement {
    @api recordId;
    weather;
    wiredResult;
    @api channelName = '/event/Weather_Update__e';
    subscription = {};
    @wire(getWeatherForContact, { contactId: '$recordId' })
    wiredWeather(result) {
        this.wiredResult = result;
        if (result.data) {
            this.weather = result.data;
        }
    }
    connectedCallback() {
        this.handleRefresh();
        this.registerErrorListener();
        this.subscribeToPlatformEvent();
    }
    subscribeToPlatformEvent() {
        const messageCallback = (response) => {
            console.log('New platform event received: ', response);
            const eventContactId = response.data.payload.ContactId__c;
            if (eventContactId === this.recordId) {
                this.handleRefresh();
                console.log('Contact match - refresh UI or publish LMS');
            }
        };

        subscribe(this.channelName, -1, messageCallback).then(response => {
            this.subscription = response;
            console.log('Subscribed to platform event: ', response.channel);
        });
    }
    registerErrorListener() {
        onError(error => {
            console.error('Error in platform event subscription: ', error);
        });
    }
    disconnectedCallback() {
        unsubscribe(this.subscription, response => {
            console.log('Unsubscribed from platform event:', response);
        });
    }

    async handleRefresh() {
        await refreshWeather({ contactId: this.recordId });
        await refreshApex(this.wiredResult);
    }
}