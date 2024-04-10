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
    }
})
