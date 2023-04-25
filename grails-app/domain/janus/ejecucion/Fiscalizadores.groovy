package janus.ejecucion

import audita.Auditable
import janus.Contrato
import seguridad.Persona

class Fiscalizadores implements Auditable {

     Persona persona
     Contrato contrato
     Date    fechaInicio
     Date    fechaFinalizacion

    static auditable = true

    static mapping = {

        table 'fscl'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'fscl__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'fscl__id'
            contrato column: 'cntr__id'
            persona column: 'prsn__id'
            fechaInicio column: 'fsclfcin'
            fechaFinalizacion column: 'fsclfcfn'
        }



    }

    static constraints = {

        fechaFinalizacion(blank: true, nullable: true)
        fechaInicio(blank: true, nullable: true)

    }
}
