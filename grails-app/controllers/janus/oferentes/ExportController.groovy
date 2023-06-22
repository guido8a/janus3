package janus.oferentes

import seguridad.Persona
import janus.VolumenesObra


class ExportController {

    def dbConnectionService

    def exportObra() {
        def cn = dbConnectionService.getConnection()
        def obra_id = 0

        println ">>>> ${params}"
        def sql = "select cncr__id from cncr where obra__id = ${params.obra}"
        println("sql:" + sql)

        def concurso = cn.rows(sql.toString())[0].cncr__id
        println "concurso: $concurso"

        sql = """
insert into obra(prsn__id, obrarvsr, obrainsp, cmnd__id, parr__id, tpob__id,
prog__id, edob__id, csob__id, lgar__id, obrachfr, obravlqt,
prsp__id, obracdgo, obranmbr, obradscr, obrafcin, obrafcfn,
obradsps, obradsvl, obrabfdi, obrabfin, obrabfpt, obraetdo,
obrarefe, obrafcha, obraofig, obraofsl, obrapz_a, obrapz_m,
obrapz_d, obraobsr, obratipo, rbpcfcha, obrammco, obrammsl,
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

//        obra_id = 4199  //borrar si ya funciona

        println " se ha creado la obra en oferentes con id: ${obra_id}"

        sql = "insert into vlof (sbpr__id,  item__id,  obra__id,  vlofcntd,  vlofordn, " +
                "sbprordn,  vlofpcun,  vlofsbtt,  vlofdias,  vlofrtcr) " +
                "select sbpr__id,  item__id,  ${obra_id},  vlobcntd,  vlobordn, " +
                "sbprordn,  vlobpcun,  vlobsbtt,  vlobdias,  vlobrtcr from vlob " +
                "where obra__id = ${params.obra} "
        println "inserta vlof: $sql"
        cn.execute(sql.toString())

        sql = "insert into obof (obra__id, prsn__id, oboffcha, obrajnid, cncr__id, obofetdo) " +
                "values( ${obra_id},  ${params.oferente}, '${new Date().format('yyyy-MM-dd HH:mm:ss')}', " +
                "${params.obra}, ${concurso}, 'N')"
        println "inserta obof: $sql"
        cn.execute(sql.toString())


        render "OK_Obra exportada correctamente"
    }

    def importarAProyectos() {
        def cn = dbConnectionService.getConnection()
        def obra_id = 0

        println "importar >>>> ${params}"

        def sql = "insert into vlob (sbpr__id, item__id, obra__id, vlobcntd, vlobordn, " +
                "sbprordn, vlobpcun, vlobsbtt, vlobdias, vlobrtcr) " +
                "select sbpr__id,  item__id, ${params.obra},  vlofcntd,  vlofordn, " +
                "sbprordn, vlofpcun, vlofsbtt, vlofdias, vlofrtcr from vlof " +
                "where obra__id = ${params.obra} "
        println "inserta vlob: $sql"
        cn.execute(sql.toString())

        sql = "update obof set obofetdo = 'C' where obra__id = ${params.obra} and obofetdo = 'N'"
        println "actualiza obof: $sql"
        cn.execute(sql.toString())

        //cambia el tipo de 'F' a 'O' para trabajarla en Proyectos, las obras tipo 'O' no se pueden desregistrar.
        sql = "update obra set obratipo = 'O' where obra__id = ${params.obra} and obratipo = 'F'"
        println "actualiza obra: $sql"
        cn.execute(sql.toString())


        render "OK_Obra importada correctamente"
    }

}
