package janus

import audita.Auditable
import janus.pac.Concurso
import seguridad.Persona

class ObraOferente implements Auditable{

    Obra obra
    Persona oferente
    Date fecha
    Obra idJanus
    Concurso concurso
    String estado

    static auditable = true

    static mapping = {
        table 'obof'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'obof__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'obof__id'
            idJanus column: 'obrajnid'
            obra column: 'obra__id'
            oferente column: 'prsn__id'
            fecha column: 'oboffcha'
            concurso column: 'cncr__id'
            estado column: 'obofetdo'
        }
    }

    static constraints = {
        obra(blank: false, nullable: false)
        oferente(blank: false, nullable: false)
        fecha(blank: false, nullable: false)
    }
}
