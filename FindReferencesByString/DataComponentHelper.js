({
    callServer : function( component, method, callback, params, storable ) {
        var compEvent = component.getEvent( "loading" );
        compEvent.fire();

        var action = component.get( method );
        if (params) {
            action.setParams( params );
        }

        if ( storable ) {
            action.setStorable();
        }

        else {
            action.setStorable( { "ignoreExisting": "true" });
        }

        action.setCallback( this, function( response ) {

            var state = response.getState();

            if ( state === "SUCCESS" ) {

                callback.call( this, response.getReturnValue() );   // pass returned value to callback function
            }
            else if ( state === "ERROR" ) {

                // generic error handler
                var errors = response.getError();
                if ( errors ) {
                    console.log( "Errors", errors );
                    if ( errors[0] && errors[0].message ) {
                        throw new Error( "Error" + errors[0].message );
                    }
                }
                else {
                    throw new Error( "Unknown Error" );
                }
            }
            var compEvent = component.getEvent( "doneloading" );
            compEvent.fire();
        });

        $A.enqueueAction( action );
    }
})
