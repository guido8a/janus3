package janus.oferentes

import seguridad.Persona
import janus.VolumenesObra


class ExportController {

    def dbConnectionService

    def exportObra() {
        def cn = dbConnectionService.getConnection()
        def obra_id = 0

        println ">>>> ${params}"

        def sql = """
insert into obra(prsn__id, obrarvsr, obrainsp, cmnd__id, parr__id, tpob__id,
prog__id, edob__id, csob__id, lgar__id, obrachfr, obravlqt,
prsp__id, obracdgo, obranmbr, obradscr, obrafcin, obrafcfn,
obradsps, obradsvl, obrabfdi, obrabfin, obrabfpt, obraetdo,
obrarefe, obrafcha, obraofig, obraofsl, obrapz_a, obrapz_m,
obrapz_d, obraobsr, obratipo, rbpcfcha, obrammco, obrammsl,
obrafcsl, obraftrd, obravlcd, obracpvl, obraftvl, obraftps,
obrardtp, obrasito, obrafrpl, obraindi, indignrl, indiimpr,
indiutil, indicntr, inditotl, obravlor, obrammpr, obraprft,
indiutil, indicntr, inditotl, obravlor, obrammpr, obraprft,
obrammfn, obraantc, obrarjst, indidrob, indimntn, indiadmn,
indigrnt, indicsfn, indivhcl, indiprmo, inditmbr, dpto__id,
obraplzo, obradsmj, obradsca, obradses, obrabarr, obralong,
obralatt, lgarps01, lgarvl00, lgarvl01, lgarvl02, lgarlsmq,
obraplmq, obraplpr, ofrt__id, obradseq, obradsrp, obradscb,
obradsmc, obradssl, obratrnp, obracrdn, dptodstn, obralqdc,
obratrcm, obratrac, itemtrcm, itemtrac, obrammio, obraanxo,
prsnfrio, dircdstn, obraobin, obrafcii, obralgvi, obraanvi,
obraetsf, obrammsf, obradsda, indialqr, indiprof, indimate,
indisgro, indicmpo, indicmpm, indigaob, cpac__id
) select 
prsn__id, obrarvsr, obrainsp, cmnd__id, parr__id, tpob__id,
prog__id, edob__id, csob__id, lgar__id, obrachfr, obravlqt,
prsp__id, obracdgo||'-OF', obranmbr, obradscr, obrafcin, obrafcfn,
obradsps, obradsvl, obrabfdi, obrabfin, obrabfpt, 'N',
obrarefe, obrafcha, obraofig, obraofsl, obrapz_a, obrapz_m,
obrapz_d, obraobsr, 'F', rbpcfcha, obrammco, obrammsl,
obrafcsl, obraftrd, obravlcd, obracpvl, obraftvl, obraftps,
obrardtp, obrasito, obrafrpl, obraindi, indignrl, indiimpr,
indiutil, indicntr, inditotl, obravlor, obrammpr, obraprft,
obrammfn, obraantc, obrarjst, indidrob, indimntn, indiadmn,
indigrnt, indicsfn, indivhcl, indiprmo, inditmbr, dpto__id,
obraplzo, obradsmj, obradsca, obradses, obrabarr, obralong,
obralatt, lgarps01, lgarvl00, lgarvl01, lgarvl02, lgarlsmq,
obraplmq, obraplpr, ofrt__id, obradseq, obradsrp, obradscb,
obradsmc, obradssl, obratrnp, obracrdn, dptodstn, obralqdc,
obratrcm, obratrac, itemtrcm, itemtrac, obrammio, obraanxo,
prsnfrio, dircdstn, obraobin, obrafcii, obralgvi, obraanvi,
obraetsf, obrammsf, obradsda, indialqr, indiprof, indimate,
indisgro, indicmpo, indicmpm, indigaob, cpac__id
from obra where obra__id = ${params.obra} returning obra__id 
"""

        cn.eachRow(sql.toString()) { d ->
            obra_id = d.obra__id
        }

//        obra_id = 4197  //borrar si ya funciona

        println " se ha creado la obra en oferentes con id: ${obra_id}"

        sql = "insert into vlof (sbpr__id,  item__id,  obra__id,  vlofcntd,  vlofordn, " +
                "sbprordn,  vlofpcun,  vlofsbtt,  vlofdias,  vlofrtcr) " +
                "select sbpr__id,  item__id,  ${obra_id},  vlobcntd,  vlobordn, " +
                "sbprordn,  vlobpcun,  vlobsbtt,  vlobdias,  vlobrtcr from vlob " +
                "where obra__id = ${params.obra} "
        println "inserta rbof: $sql"
        cn.execute(sql.toString())

        sql = "insert into obof (obra__id, prsn__id, oboffcha, obrajnid, cncr__id) " +
                "values( ${obra_id},  ${params.oferente}, '${new Date().format('yyyy-MM-dd HH:mm:ss')}' )"
        cn.execute(sql.toString())


        render "OK_Obra exportada correctamente"
    }

}
