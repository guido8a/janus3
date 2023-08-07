package janus.pac

import janus.Contrato

class GarantiaFinanciero {

    int id
    Contrato contrato
    String numeroGarantia
    int conceptoGarantia_id
    String conceptoGarantia
    int emisor_id
    String emisor
    int tipoGarantia_id
    String tipoGarantia
    String estado
    Date fechaGarantia
    Date desde
    Date hasta
    double monto
    int idFinanciero

    static auditable = true
    static mapping = {
        table 'grfi'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'grfi__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'grfi__id'
            contrato column: 'cntr__id'
            numeroGarantia column: 'grfinmro'
            conceptoGarantia_id column: 'grficnid'
            conceptoGarantia column: 'grficncp'
            emisor_id column: 'grfiemid'
            emisor column: 'grfiemis'
            tipoGarantia_id column: 'grfitpgr'
            tipoGarantia column: 'grfitipo'
            estado column: 'grfietdo'
            fechaGarantia column: 'grfifcha'
            desde column: 'grfifcin'
            hasta column: 'grfifcfn'
            monto column: 'grfimnto'
            idFinanciero column: 'grfiidfi'
        }
    }


    static constraints = {
        id(blank: false, nullable: false)
        contrato(blank: true, nullable: true)
        numeroGarantia(size: 0..15, blank: true, nullable: true)
        conceptoGarantia_id(blank: true, nullable: true)
        conceptoGarantia(size: 0..127, blank: true, nullable: true)
        emisor_id(blank: true, nullable: true)
        emisor(size: 0..127, blank: true, nullable: true)
        tipoGarantia_id(blank: true, nullable: true)
        tipoGarantia(size: 0..127, blank: true, nullable: true)
        estado(size: 0..31, blank: true, nullable: true)
        fechaGarantia(blank: true, nullable: true)
        desde(blank: true, nullable: true)
        hasta(blank: true, nullable: true)
        monto(blank: true, nullable: true)
        idFinanciero(blank: false, nullable: false)
    }
}
