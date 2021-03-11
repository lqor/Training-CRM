({
    handleClick : function(cmp) {
        var action = cmp.get("c.saveAll");
        action.setParams({ trainingId : cmp.get("v.recordId") });

        console.log(cmp.get("v.recordId"));
 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("SUCCESS: " + response.getReturnValue());
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type" : "success",
                    "title": "Success!",
                    "message": "You can find PDFs in attachments of participants"
                });
                resultsToast.fire();

                // Close the action panel
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else if (state === "INCOMPLETE") {

            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
 

        $A.enqueueAction(action);

        
    }
})