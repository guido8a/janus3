package janus.ejecucion

import audita.Auditable

class EstadoPlanilla implements Auditable{

      String codigo
      String nombre

    static auditable = true
    static mapping = {

        table 'edpl'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'edpl__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'edpl__id'
            codigo column: 'edplcdgo'
            nombre column: 'edpldscr'
        }


    }

    static constraints = {

        codigo(blank: true, nullable: true)
        nombre(blank: true, nullable: true)

    }
}
