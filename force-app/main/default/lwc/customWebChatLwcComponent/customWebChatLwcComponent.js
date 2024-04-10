import { LightningElement, wire, api, track } from 'lwc';
import SAMPLEMC from '@salesforce/messageChannel/SampleMessageChannel__c';
import CHAT_COMPONENT_CHANNEL from '@salesforce/messageChannel/SampleMessageChannelNew__c';
import { MessageContext, publish,subscribe } from 'lightning/messageService';

export default class CustomWebChatLwcComponent extends LightningElement {
    
    @api
    recordId = "";

    inputValue = "";

    @wire(MessageContext)
    messageContext

    handleInputChange(event) {
        this.inputValue = event.target.value;
        console.log('**** this.inputValue  :',this.inputValue )
    }
    handlePublish() {
        const message = {
            lmsData: {
                value: this.inputValue
            }
        }
        console.log('**** message.lmsData :',message.lmsData.value)
        publish(this.messageContext, SAMPLEMC, message);
    }
       
    handleCloseChat() {
        const message = {
            lmsData: {
                action: 'closeChat'
            }
        };
        console.log('**** message :',message)
        publish(this.messageContext, SAMPLEMC, message);
    }


    handleAcceptwork(){
        const message = {
            lmsData: {
                action: 'acceptWork'
            }
        }
        console.log('**** message :',message)
        publish (this.messageContext, SAMPLEMC, message);
    }

    @track agentMessage = "";
    @track agentTimestamp = ""; 
    @track agentName = "";
    @track agentRecordId = "";
    @track customerMessage = ""
    @track customerTimestamp = "";
    @track customerName = "";
    @track customerRecordId = "";

    @track receivedAgentMessages = [];
    @track receivedCustomerMessages = [];

    @track receivedMessages = [];
    @track inboundmessage;


    connectedCallback() {
        // Subscribe to the Lightning Message Channel
        this.subscribeToMessageChannel();
        console.log("Recived Messages ", this.receivedMessages);
        // I Load data from Local storage when the component is connected
        const storedMessages = localStorage.getItem("chatMessages");
        if (storedMessages) {
            this.receivedMessages = JSON.parse(storedMessages);
        }
    }

    subscribeToMessageChannel() {
        subscribe(this.messageContext, CHAT_COMPONENT_CHANNEL, (message) => {
            this.handleMessage(message);
        });
    }   

    handleMessage(message) {
        // Handle received message data
        if (message.content && message.timestamp) {
            this.receivedMessages.push({
                content: message.content,
                timestamp: message.timestamp,
                name: message.name,
                recordId: message.recordId,
                type: message.type
            });
            localStorage.setItem('chatMessages', JSON.stringify(this.receivedMessages));
            // After adding the message, scroll to the bottom
            this.scrollToBottom();
        }
        this. receivedMessages = [...this.receivedMessages];
    }

    // Scroll to the bottom of the chat container
    scrollToBottom() {
        const chatContainer = this.template.querySelector('.chat-component');
        if (chatContainer) {
            window.requestAnimationFrame(() => {
                chatContainer.scrollTop = chatContainer.scrollHeight;
            })
        }
    }

    get processedMessages() {
        return this.receivedMessages.map((message) => ({
            ...message,
            messageClass: message.type == 'Agent' ? 'slds-chat-listitem slds-chat-listitem_outbound' : 'slds-chat-listitem slds-chat-listitem_inbound',
            contentClass: message.type == 'Agent' ? 'slds-chat-message__text slds-chat-message__text_outbound' : 'slds-chat-message__text slds-chat-message__text_inbound'
        }));
    }

    get agentMessage(){
        return message.type === 'Agent' ? 'slds-chat-message__text slds-chat-message__text_outbound' : 'slds-chat-message__text slds-chat-message__text_inbound';
    }

    get agentMessgaelistItem(){
        return message.type = 'Agent' ? 'slds-chat-listitem slds-chat-listitem_outbound' : 'slds-chat-listitem slds-chat-listitem_inbound';
    }
}