({
    //Get Related Docs
    doInit : function(component, event, helper) {
        helper.getRelatedDocuments(component, event); 
    },
     
    //Redirect To User Record
    handleRedirectToUserRecord: function (component, event, helper) {
        var recordId = event.currentTarget.getAttribute("data-Id")
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "Detail"
        });
        navEvt.fire();
    },
     
    //Preview Selected File
    handleSelectedDocPreview : function(component,event,helper){ 
        $A.get('e.lightning:openFiles').fire({
            recordIds: [event.currentTarget.getAttribute("data-Id")]
        });
    },
     
    //Handle Selected Action
    handleSelectedAction: function(component, event, helper) {
        var docId = event.getSource().get("v.value");
        var selectedMenuValue = event.detail.menuItem.get("v.value");
        switch(selectedMenuValue) {
            case "Delete":
                helper.deleteDocument(component, event, docId);
                break;
            case "Download":
                helper.downloadDocument(component, event, docId);
                break;
        }
    }
})