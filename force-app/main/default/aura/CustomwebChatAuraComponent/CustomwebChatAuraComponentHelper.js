/*
 * @Author: kyrie zhao
 * @Date: 2024-04-09 23:31:19
 * @LastEditors: kyrie zhao
 * @LastEditTime: 2024-04-16 23:09:20
 * @Description: 
 */
({
    closeWork: function (cmp, evt, hlp) {
        var omniAPI = cmp.find("omniToolkit");
        omniAPI.getAgentworks().then(function (result) {
            var works = JSON.parse(result.works);
            var work = works[0];
            omniAPI.closeAgentwork({
                workId: work.workId
            }).then(function (res) {
                if (res) {
                    console.log("Closed work successfully");
                } else {
                    console.log("Close work failed");
                }
            }).catch(function (error) {
                console.log(error);
            })
        });
    },
    acceptWork: function(cmp, evt, hlp) {
        var omniAPI = cmp.find("omniToolkit");
        omniAPI.getAgentworks().then(function (result) {
            var works = JSON.parse(result.works);
            var work = works[0];
            omniAPI.acceptAgentWork({
                workId: work.workId
            }).then(function (res) {
                if (res) {
                    console.log("Accepted work successfully");
                } else {
                    console.log("Accept work failed");
                }
            }).catch(function (error) {
                console.log(error);
            });
        })
    },
    publishMessage: function (cmp, message) { 
        var messagePayload = {
            message: message
        }
        var messageChannel = cmp.find ("messageChannel");
        messageChannel.publish(messagePayload);
    },
    replyMsg : function(component, event, helper) {
        var lmsData = event.getParam("lmsData");
        let action = component.get('c.agentReplyToLineUser');
        let messageList = [];
        let message = {
            "type": 'text',
            "text": lmsData.value
        }
        messageList.push(message);
        console.log('**** component.get( :',component.get('v.recordId'))
        let param = {
            "recordId": component.get('v.recordId'),
            "messageList":messageList
        }
        action.setParams(param);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                console.log('**** result :',result)
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"type": 'error',"title":"","message":state});
                toastEvent.fire();
            }
            component.set('v.displaySpinner',false);
        });
        $A.enqueueAction(action);
    },
})
