/*
 * @Author: kyrie zhao
 * @Date: 2024-04-09 23:31:19
 * @LastEditors: kyrie zhao
 * @LastEditTime: 2024-04-15 15:15:53
 * @Description: 
 */
({
    sendMessage: function(component, event, helper) {
        var message = event.getParam("lmsData");
        console.log('**** message lmsData :',message)
        var conversationKit = component.find("conversationKit");
        console.log('**** conversationKit :',conversationKit)
        var recordId = component.get("v.recordId");
        console.log('**** message.action  :',message.action )
        if (message.action == 'closeChat') {
            helper.closeWork(component);
        } else if (message.action === 'acceptWork') {
            helper.acceptWork(component);
        } else {
            helper.replyMsg(component, event, helper);

            // conversationKit.sendMessage({
            //     recordId: recordId,
            //     message: {
            //         text: message.value
            //     }
            // }).then(function (result) {
            //     if (result) {
            //         console.log("Successfully sent message");
            //     } else {
            //         console.log("Failed to send message");
            //     };
            // });
        }
    },
    onAgentSend: function (cmp, evt, helper) {
        var content = evt.getParam("content");
        var timestamp = evt.getParam("timestamp");
        var name = evt.getParam("name");
        var recordId = evt.getParam("recordId");
        // Publish data to Lightning Message Channel
        var message = {
            content: content,
            timestamp: timestamp,
            name: name,
            recordid: recordId,
            type: 'Agent'
        }
        var messageChannel = cmp.find("messageChannel");
        messageChannel.publish(message);
    },
    onNewMessage: function (cmp, evt, helper) {
        var content = evt.getParam('content');
        var timestamp = evt.getParam('timestamp');
        var name = evt.getParam("name");
        var recordId = evt.getParam('recordId');
        var type = evt.getParam('type');
        //  Publish data to Lightning Message Channel
        var message = {
            content: content,
            timestamp: timestamp,
            name: name,
            recordid: recordId,
            type: "Customer"
        };
        console.log('**** message :',message)
        var messageChannel = cmp.find("messageChannel");
        messageChannel.publish(message);
    },
    getAgentWorks: function(cmp, evt, hlp) {
        var omniAPI = cmp.find("omniToolkit");
        omniAPI.getAgentWorks().then(function(result) {
            var works = JSON.parse(result.works);
            console.log('First Agent Work ID is: ' +  works[0].workId);
            console.log('Assigned Entity Id of the first Agent Work is: ' + works[0].workItemId);
            console.log('Is first Agent Work Engaged: ' + works[0].isEngaged);
        }).catch(function(error) {
            console.log(error);
        });
    },
    onConnectionError : function(component, event, helper) {
        console.log("Network Connection Error.");
        var error = event.getParam('error');
        console.log(error);
    }, 
    onLoginSuccess : function(component, event, helper) {
        console.log("Login success.");
        var statusId = event.getParam('statusId');
        console.log(statusId);
    }, 
    onStatusChanged : function(component, event, helper) {
        console.log("Status changed.");
        var statusId = event.getParam('statusId');
        var channels = event.getParam('channels');
        var statusName = event.getParam('statusName');
        var statusApiName = event.getParam('statusApiName');
        console.log(statusId);
        console.log(channels);
        console.log(statusName);
        console.log(statusApiName);
    }, 
    
})
