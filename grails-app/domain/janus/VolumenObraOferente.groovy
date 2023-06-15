package janus

class VolumenObraOferente {

    SubPresupuesto subPresupuesto
    Item item
    Obra obra
    double cantidad
    int orden
//    int subpresupuestoOrden
    double precioUnitario
    double subtotal
    double dias
    String rutaCritica
    static auditable = true

    static mapping = {
        table 'vlof'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'vlof__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'vlof__id'
            subPresupuesto column: 'sbpr__id'
            obra column: 'obra__id'
            item column: 'item__id'
            cantidad column: 'vlofcntd'
            orden column: 'vlofordn'
//            subpresupuestoOrden column: 'sbprordn'
            precioUnitario column: 'vlofpcun'
            subtotal column: 'vlofsbtt'
            dias column: 'vlofdias'
            rutaCritica column: 'vlofrtcr'
        }
    }

    static constraints = {
        subPresupuesto(blank: false, nullable: false)
        obra(blank: false, nullable: false)
        item(blank: false, nullable: false)
        cantidad(blank: true, nullable: true)
        orden(blank: true, nullable: true)
//        subpresupuestoOrden(blank: true, nullable: true)
        precioUnitario(blank: true, nullable: true)
        subtotal(blank: true, nullable: true)
        dias(blank: true, nullable: true)
        rutaCritica(blank: true, nullable: true)
    }
}
