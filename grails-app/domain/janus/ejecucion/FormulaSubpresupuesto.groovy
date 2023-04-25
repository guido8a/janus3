package janus.ejecucion

import audita.Auditable
import janus.SubPresupuesto

class FormulaSubpresupuesto implements Auditable {

    SubPresupuesto subPresupuesto
    FormulaPolinomicaReajuste reajuste

    static mapping = {

        table 'fpsp'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'fpsp__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'fpsp__id'
            subPresupuesto column: 'sbpr__id'
            reajuste column: 'fprj__id'

        }
    }

    static constraints = {
    }
}
