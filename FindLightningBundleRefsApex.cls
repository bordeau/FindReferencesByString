public with sharing class FindLightningBundleRefsApex {
    
    public static List<auradefinition> auradefs {
        get {
            if (auradefs == null ) {
                auradefs = [select Id, auradefinitionbundle.masterlabel, deftype, source from auradefinition where 
                                   auradefinitionbundle.namespaceprefix ='' and deftype != 'STYLE' and deftype != 'DOCUMENTATION'
                                  order by auradefinitionbundle.masterlabel];
            }
            return auradefs;
        }
        set;
    } 
    
    public static List<ApexPage> apexpages {
        get {
            if ( apexpages == null ) {
                apexpages = [select Id, Name, ApiVersion, Markup, NamespacePrefix   from ApexPage 
                                   where NamespacePrefix=null
                                  order by Name];
            }
			return apexpages;
        }
        set;
    }
    
    public static List<apexclass> apexclasses {
        get {
            if ( apexclasses == null ) {
                apexclasses = [select name, apiversion, body from apexclass where NamespacePrefix = null order by name];
            }
			return apexclasses;
        }
        set;
    }

    public static List<ApexComponent> apexcomponents {
        get {
            if ( apexcomponents == null ) {
                apexcomponents = [select Id, Name, ApiVersion, Markup, NamespacePrefix from ApexComponent where NamespacePrefix = null order by name];
            }
			return apexcomponents;
        }
        set;
    }
    
    public static List<apextrigger> apextriggers {
        get {
            if ( apextriggers == null ) {
                apextriggers = [select name, apiversion, body from apextrigger where NamespacePrefix = null order by name];
            }
			return apextriggers;
        }
        set;
    }
       
    @AuraEnabled
    public static List<auradefinition> find(string s ) {
        List<auradefinition> r = new List<auradefinition>();
        
        for( auradefinition z : auradefs )
            if ( z.source.containsIgnoreCase(s) )
            	r.add( z );
            
        return r;       
    }
    
    public static auradefinition getme(string sz) {
        for( auradefinition adz : auradefs )
            if ( sz == adz.auradefinitionbundle.masterlabel )
            	return adz;
        
        return null;
    }
    
    public static apexclass getmeapex(string sz) {
        for( apexclass adz : apexclasses )
            if ( sz == adz.Name )
            	return adz;
        
        return null;
    }
    
    public static apextrigger getmetrigger(string sz) {
        for( apextrigger adz : apextriggers )
            if ( sz == adz.Name )
            	return adz;
        
        return null;
    }
    
    public static list<string> sobjects {
        get {
            if ( sobjects == null ) {
                sobjects = new list<string>();
                Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

                for( string s : gd.keySet() )
                    sobjects.add( s );
            }
            return sobjects;
        }
        set;
    }
    
    @AuraEnabled
    public static List<string> findDep( list<string> s ) {
    	list<string> r = new list<string>();
        // component dependencies
        for( string sz : s ) {
            for( auradefinition ad : auradefs ) {
                if ( ad.source.containsIgnoreCase( sz ) && ad.AuraDefinitionBundle.MasterLabel != sz )                   
                    r.add( '{ "t":"lc", "tz": "ref by", "dt": "' + ad.DefType +'", "src" : "' + sz + '", "ml" : "' + ad.AuraDefinitionBundle.MasterLabel  + '", "id": ""}' );
            }
            auradefinition me = getme( sz );
            if ( me != null ) {
                for( auradefinition ad : auradefs ) {
                    if ( me.source.containsIgnoreCase( ad.AuraDefinitionBundle.MasterLabel ) && ad.AuraDefinitionBundle.MasterLabel != sz )                   
                        r.add( '{ "t":"lc", "tz":"calls", "dt": "' + ad.DefType +'", "src" : "' + sz + '", "ml" : "' + ad.AuraDefinitionBundle.MasterLabel  + '", "id": ""}' );
                }
                for( string ss : sobjects ) {
                    if ( me.source.containsIgnoreCase( ss ) )                   
                        r.add( '{ "t":"so", "tz":"uses", "src" : "' + sz + '", "ml" : "' + ss  + '", "id": ""}' );
                }
            }
            
            for(  apexclass sc : apexclasses ) {
                if ( sc.body.containsIgnoreCase( sz ))                   
                    r.add( '{ "t":"ac", "tz":"ref by", "dt":"", "src" : "' + sz + '", "ml" : "' + sc.Name  + '", "id":"' + sc.Id + '"}' );
            }
            if ( me != null )
                for(  apexclass sc : apexclasses ) {
                if ( me.source.containsIgnoreCase( sc.Name ))                   
                    r.add( '{ "t":"ac", "tz":"calls", "dt":"", "src" : "' + sz + '", "ml" : "' + sc.Name  + '", "id":"' + sc.Id + '"}' );
            }
        }
        
        
        return r;
        
    }
    
    @AuraEnabled
    public static List<string> findApexDep( list<string> s ) {
    	list<string> r = new list<string>();
        // component dependencies
        for( string sz : s ) {
            for( auradefinition ad : auradefs ) {
                if ( ad.source.containsIgnoreCase( sz )  )                   
                    r.add( '{ "t":"lc", "tz":"ref by", "src" : "' + sz + '", "ml" : "' + ad.AuraDefinitionBundle.MasterLabel  + '", "id": ""}' );
            }
            apexclass me = getmeapex( sz );
            if ( me != null ) {
                for( auradefinition ad : auradefs ) {
                    if ( me.body.containsIgnoreCase( ad.AuraDefinitionBundle.MasterLabel ) && ad.AuraDefinitionBundle.MasterLabel != sz )                   
                        r.add( '{ "t":"lc", "tz":"ref by", "src" : "' + sz + '", "ml" : "' + ad.AuraDefinitionBundle.MasterLabel  + '", "id": ""}' );
                }
                for( string ss : sobjects ) {
                    if ( me.body.containsIgnoreCase( ss ) )                   
                        r.add( '{ "t":"so", "tz":"uses", "src" : "' + sz + '", "ml" : "' + ss  + '", "id": ""}' );
                }
                
            }
            
            for(  apexclass sc : apexclasses  ) {
                if ( sc.body.containsIgnoreCase( sz ) && sz != sc.Name )                   
                    r.add( '{ "t":"ac", "tz":"calls", "src" : "' + sz + '", "ml" : "' + sc.Name  + '", "id":"' + sc.Id + '"}' );
            }
            if ( me != null )
                for(  apexclass sc : apexclasses  ) {
                if ( me.body.containsIgnoreCase( sc.Name ) && sz != sc.Name )                   
                    r.add( '{ "t":"ac", "tz":"refs", "src" : "' + sz + '", "ml" : "' + sc.Name  + '", "id":"' + sc.Id + '"}' );
            }
        }
        
        
        return r;
        
    }
    
    @AuraEnabled
    public static List<string> findTriggerDep( list<string> s ) {
    	list<string> r = new list<string>();
        // component dependencies
        for( string sz : s ) {
            
            apextrigger me = getmetrigger( sz );
            if ( me != null )
                for(  apexclass sc : apexclasses  ) {
                if ( me.body.containsIgnoreCase( sc.Name ) && sz != sc.Name )                   
                    r.add( '{ "t":"ac", "tz":"refs", "src" : "' + sz + '", "ml" : "' + sc.Name  + '", "id":"' + sc.Id + '"}' );
            }
        }
        
        
        return r;
        
    }
    
    @AuraEnabled
    public static List<ApexPage> findPage(string s ) {
        List<ApexPage> r = new List<ApexPage>();
        
        for( ApexPage z : apexpages )
            if ( z.Markup.containsIgnoreCase(s) )
            	r.add( z );
            
        return r;       
    }
    
    @AuraEnabled
    public static List<ApexComponent> findComponent(string s ) {
        List<ApexComponent> r = new List<ApexComponent>();
        
        for( ApexComponent z : apexcomponents )
            if ( z.Markup.containsIgnoreCase(s) )
            	r.add( z );
    
        return r;    
    }
    
    @AuraEnabled
    public static List<apexclass> findApex(string s ) {
        List<apexclass> r2 = new List<apexclass>();
        
        for( apexclass z : apexclasses )
            if (z.body.containsIgnoreCase(s) )
            	r2.add( z );
        
        return r2;   
    }
    
    @AuraEnabled
    public static List<apextrigger> findTrigger(string s ) {
        List<apextrigger> r2 = new List<apextrigger>();
        
        for( apextrigger z : apextriggers )
            if (z.body.containsIgnoreCase(s) )
            	r2.add( z );
            
        return r2;
    }

}
