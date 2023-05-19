package janus

import audita.Auditable
import seguridad.Persona

class ObraOferente implements Auditable{

    Obra obra
    Persona oferente
    Date fecha
    static auditable = true

    static mapping = {
        table 'obof'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'obof__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'obof__id'
            obra column: 'obra__id'
            oferente column: 'prsn__id'
            fecha column: 'oboffcha'
        }
    }

    static constraints = {
        obra(blank: false, nullable: false)
        oferente(blank: false, nullable: false)
        fecha(blank: false, nullable: false)
    }
}
