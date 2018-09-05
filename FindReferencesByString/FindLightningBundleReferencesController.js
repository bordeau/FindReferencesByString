({
	doInit : function(component, event, helper) {
        component.set("v.pp", true );
        helper.dosearch( component, event, helper );
        var me = component.get("v.method");
        if ( me == "c.findPage") {
            component.set("v.title", "Search for string in VF Pages");
            component.set("v.showdep", false );
        }
        else if ( me == "c.findComponent") {
            component.set("v.title", "Search for string in VF Component");
            component.set("v.showdep", false );
        }
        else if ( me == "c.findApex")
            component.set("v.title", "Search for string in Apex Class");
        else if ( me == "c.findTrigger")
            component.set("v.title", "Search for string in Apex Trigger");

	},
    doInit2 : function(component, event, helper) {
  		component.set("v.pp", false );
        var c = component.get("v.data");
        if ( c == null )
        	helper.dosearch( component, event, helper );
    },
    reset: function(component, event, helper) {
        component.set("v.search", null );
        component.set("v.data", null );
        component.set("v.data2", null );
        component.set("v.odata", null );
    },
    doDepend : function(component, event, helper) {
  		var dd = component.get("v.odata" );
        var jj = new Array();
        var me = component.get("v.method");

        for( var i=0; i<dd.length; i++ ) {
            var o = dd[i];
            if ( o != null ) {
                if ( me == "c.find")
                    jj.push( o.AuraDefinitionBundle.MasterLabel );
                else
                    jj.push( o.Name );
            }
        }

        if ( me == "c.find")
            me = "c.findDep";
        else if ( me == "c.findApex")
            me = "c.findApexDep";
        else if ( me == "c.findTrigger")
            me = "c.findTriggerDep";

        helper.callServer( component, me, function( response ){

            var jj = new Array();
            if ( response != null ) {


            for( var y=0; y<response.length; y++ ) {
            	var yz = response[y];
                var j = JSON.parse( yz );
                jj.push( j);
            }


            var rr = [];

            for( var x=0; x<jj.length; x++ ) {
                var vz = jj[x];
                var aa;
                if ( vz.t == "lc" )
                	aa = '<li class="slds-item"><a href="/auradocs/reference.app#reference?descriptor=c:'
                    + vz.src + '&amp;defType=component" target="_blank">' + vz.src + '</a> ' +  vz.tz + ' lightning component: <a href="/auradocs/reference.app#reference?descriptor=c:'
                    + vz.ml + '&amp;defType=component" target="_blank">' + vz.ml + '</a></li>';
                else if ( vz.t == "so")
                    aa = '<li class="slds-item"><a href="/auradocs/reference.app#reference?descriptor=c:'
                    + vz.src + '&amp;defType=component" target="_blank">' + vz.src + '</a> ' +  vz.tz + ' sobject: <a href="/lightning/setup/ApexClasses/page?address=%2F' + vz.Id  +
                         '" target="_blank">' + vz.ml + ' </a></li>';
                else
                    aa = '<li class="slds-item"><a href="/auradocs/reference.app#reference?descriptor=c:'
                    + vz.src + '&amp;defType=component" target="_blank">' + vz.src + '</a> ' +  vz.tz + ' apex: <a href="/lightning/setup/ApexClasses/page?address=%2F' + vz.Id  +
                         '" target="_blank">' + vz.ml + ' </a></li>';

                rr.push( aa );
            }

            component.set( "v.data2", rr );

            }

        }, {
            s: jj
        }, false );
    }
})
