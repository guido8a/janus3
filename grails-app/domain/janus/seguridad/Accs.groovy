package janus.seguridad

import seguridad.Persona

class Accs implements Serializable {
    
    Date accsFechaInicial
    Date accsFechaFinal
    String accsObservaciones
    
    Persona usuario
    
    static mapping = {
        table 'accs'
        version false	
        id generator: 'identity'
        
        columns {
            id column: 'accs__id'
            usuario column:'usro__id'           
            accsFechaInicial column: 'accsfcin'
            accsFechaFinal column: 'accsfcfn'
            accsObservaciones column: 'accsobsr'
        }
    }
    
    static constraints = {
        accsFechaInicial(blank:false, nullable:false)
        accsFechaFinal(blank:false, nullable:false)
        accsObservaciones(blank:true, nullable:true)
    }
    
    
}
