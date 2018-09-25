({
    
    dosearch : function(component, event, helper ) {
        var ssf = component.find("searchs");
        var ss = ssf.get("v.value");
        
        debugger;
        
        if ( ss == null || ss != null && ss.trim() == "" )
            return;
        var me = component.get("v.method");
        
		helper.callServer( component, me, function( response ){
           debugger;
            
            
            var rec = response;
            component.set("v.odata", rec );
			
            var rr = [];
            
            for( var x=0; x<rec.length; x++ ) {
                var vz = rec[x];
                var aa;
                if ( me == "c.find" ) 
                	aa = '<li class="slds-item"><a href="/auradocs/reference.app#reference?descriptor=c:'
                			+ vz.AuraDefinitionBundle.MasterLabel + '&amp;defType=component" target="_blank">' + vz.AuraDefinitionBundle.MasterLabel + '</a> ' + vz.DefType + '</li>';
                else if ( me == "c.findPage" )
                    aa = '<li class="slds-item"><a href="/lightning/setup/ApexPages/page?address=' + vz.Id  + '" target="_blank">' + vz.Name + ' </a> : ' + vz.ApiVersion + '</li>';
                 else if ( me == "c.findComponent" )
                    aa = '<li class="slds-item"><a href="/lightning/setup/ApexComponents/page?address=%2F' + vz.Id  + '" target="_blank">' + vz.Name + '</a> : ' + vz.ApiVersion + '</li>';
                else if ( me == "c.findApex" )
                    aa = '<li class="slds-item"><a href="/lightning/setup/ApexClasses/page?address=%2F' + vz.Id +  '" target="_blank">' + vz.Name + '</a> : ' + vz.ApiVersion + '</li>';    
                else if ( me == "c.findTrigger" )
                    aa = '<li class="slds-item"><a href="/lightning/setup/ApexTriggers/page?address=%2F' + vz.Id + '" target="_blank">' + vz.Name + '</a> : ' + vz.ApiVersion + '</li>';    
                    
                rr.push( aa );
            }
            
            component.set( "v.data", rr );
                
            if ( me != "c.findPage" &&  me != "c.findComponent" ) 
            component.set("v.showdep", true );
            
            
        }, {
            s: ss
        }, false );
		
	}
})