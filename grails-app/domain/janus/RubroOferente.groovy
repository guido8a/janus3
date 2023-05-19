package janus

import seguridad.Persona

class RubroOferente {

    Item rubro
    Item item
    Persona oferente
    Date fecha
    double cantidad
    double rendimiento = 1

    static auditable = true

    static mapping = {
        table 'rbof'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'rbof__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'rbof__id'
            rubro column: 'rbofcdgo'
            item column: 'item__id'
            fecha column: 'rboffcha'
            cantidad column: 'rbofcntd'
            rendimiento column: 'rbofrndt'
            oferente column: 'prsn__id'
        }
    }

    static constraints = {
        item(blank: false, nullable: false, attributes: [title: 'item'])
        cantidad(blank: true, nullable: true)
        rubro(blank: false, nullable: false, attributes: [title: 'rubro'])
        fecha(blank: true, nullable: true, attributes: [title: 'fecha'])
        rendimiento(blank: true, nullable: true)
        oferente(blank: false, nullable: false)
    }
}
