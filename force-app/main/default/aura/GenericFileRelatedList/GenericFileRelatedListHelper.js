({
    getRelatedDocuments : function(component, event) {
        var action = component.get("c.getRelatedDocs");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set('v.cdList', response.getReturnValue());
            }else if(state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
     
    deleteDocument : function(component, event, docId) {
        var action = component.get("c.deleteDoc");
        action.setParams({
            docId : docId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                this.getRelatedDocuments(component, event);
            }else if(state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
     
    downloadDocument : function(component, event, docId) {
        var action = component.get("c.getDocURL");
        action.setParams({
            docId : docId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": response.getReturnValue()
                });
                urlEvent.fire();
            }else if(state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    }
})