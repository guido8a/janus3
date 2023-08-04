package seguridad

import janus.Parametros

class InicioController {

    def dbConnectionService
    def diasLaborablesService

    def index() {
        def cn = dbConnectionService.getConnection()
        def prms = []
        def acciones = "'3. Rubros', 'Registro de Obras', '3. Concursos', 'Contratos', 'Reportes'"
        def tx = "select accndscr from prms, accn where prfl__id = " + Prfl.findByNombre(session.perfil.toString()).id +
                " and accn.accn__id = prms.accn__id and accndscr in (${acciones})"
        println "sql: $tx"
        cn.eachRow(tx) { d ->
            prms << d.accndscr
        }
        cn.close()
        def empr = Parametros.get(1)

        //println "formula "
        //oferentesService.copiaFormula(1457,1485)
        // println " crono "
        //oferentesService.copiaCrono(1457,1485)
        println "--> $prms"
        return [prms: prms, empr: empr]
    }

    def inicio() {
        redirect(action: "index")
    }


    def parametros() {

    }

    def variables() {
        def paux = Parametros.get(1);
        def par = Parametros.list()
        def total1 = (paux?.indiceCostosIndirectosObra ?: 0) + (paux?.administracion ?: 0) + (paux?.indiceAlquiler ?: 0) +
                (paux?.indiceCostosIndirectosVehiculos ?: 0) + (paux?.indiceCostosIndirectosTimbresProvinciales ?: 0) +
                (paux?.indiceCostosIndirectosPromocion ?: 0) + (paux?.indiceCostosIndirectosGarantias ?: 0) +
                (paux?.indiceSeguros ?: 0) + (paux?.indiceCostosIndirectosCostosFinancieros ?: 0) +
                (paux?.indiceSeguridad ?: 0)
//        def total2 = (obra?.indiceCampo ?: 0) + (obra?.indiceCostosIndirectosCostosFinancieros ?: 0) + (obra?.indiceCostosIndirectosGarantias ?: 0) + (obra?.indiceCampamento ?: 0)
        def total3 = (total1 ?: 0) + (paux?.indiceUtilidad ?: 0)

//        def total1 = (paux?.indiceAlquiler ?: 0) + (paux?.administracion ?: 0) + (paux?.indiceCostosIndirectosMantenimiento ?: 0) + (paux?.indiceProfesionales ?: 0) + (paux?.indiceSeguros ?: 0)  + (paux?.indiceSeguridad ?: 0)
//        def total2 = (paux?.indiceCampo ?: 0) + (paux?.indiceCostosIndirectosCostosFinancieros ?: 0) + (paux?.indiceCostosIndirectosGarantias ?: 0) + (paux?.indiceCampamento ?: 0)
//        def total3 = (total1 ?:0 ) + (total2 ?: 0) + (paux?.impreso ?: 0) + (paux?.indiceUtilidad ?: 0)

        paux.totales = total3
        paux.save(flush: true)

        return [paux: paux, par: par, totalCentral: total1, totalObra: total3]
    }

    /** carga datos desde un CSV - utf-8: si ya existe lo actualiza
     * */
    def leeCSV() {
//        println ">>leeCSV.."
        def contador = 0
        def cn = dbConnectionService.getConnection()
        def estc
        def rgst = []
        def cont = 0
        def repetidos = 0
        def procesa = 5
        def crea_log = false
        def inserta
        def fcha
        def magn
        def sqlp
        def directorio
//        def tipo = 'prueba'
        def tipo = 'prod'

        if (grails.util.Environment.getCurrent().name == 'development') {
            directorio = '/home/guido/proyectos/monitor/data/'
        } else {
            directorio = '/home/obras/data/'
        }

        if (tipo == 'prueba') { //botón: Cargar datos Minutos
            procesa = 5
            crea_log = false
        } else {
            procesa = 100000000000
            crea_log = true
        }

        def nmbr = ""
        def arch = ""
        def cuenta = 0
        def fechas = []
        new File(directorio).traverse(type: groovy.io.FileType.FILES, nameFilter: ~/.*\.csv/) { ar ->
            nmbr = ar.toString() - directorio
            arch = nmbr.substring(nmbr.lastIndexOf("/") + 1)

            /*** procesa las 5 primeras líneas del archivo  **/
            def line
            cont = 0
            repetidos = 0
            ar.withReader('UTF-8') { reader ->
                print "Cargando datos desde: $ar "
                while ((line = reader.readLine()) != null) {
                    println ">>${line}"
                    if(cuenta == 0){
                        rgst = line.split('\t')
                        rgst = rgst*.trim()
//                        println "ultimo: ${rgst[-1]}"
                        fechas = poneFechas(rgst)
                        cuenta++
                    } else if(cuenta < procesa && line?.size() > 20) {
                        rgst = line.split('\t')
                        rgst = rgst*.trim()
                        println "***** $rgst"
                        if(rgst[6]) {
                            inserta = cargaData(rgst, fechas)
                            cont += inserta.insertados
                            repetidos += inserta.repetidos
                            cuenta++
                        }
                    } else {
                        break
                    }
                }
            }
            println "---> archivo: ${ar.toString()} --> cont: $cont, repetidos: $repetidos"
        }
//        return "Se han cargado ${cont} líneas de datos y han existido : <<${repetidos}>> repetidos"
        render "Se han cargado ${cont} líneas de datos y han existido : <<${repetidos}>> repetidos"
    }


    def cargaData(rgst, fechas) {
        def errores = ""
        def cnta = 0
        def insertados = 0
        def repetidos = 0
        def cn = dbConnectionService.getConnection()
        def sqlParr = ""
        def sql = ""
        def cntn = 0
        def tx = ""
        def fcds = ""
        def fchs = ""
        def zona = ""
        def nombres
        def nmbr = "", apll = "", login = "", orden = 0
        def id = 0
        def resp = 0

        println "\ninicia cargado de datos para $rgst"
        println "fechas: $fechas"
        cnta = 0
        if (rgst[1].toString().size() > 0) {
            tx = rgst[2]
//            sqlParr = "select parr__id from parr where parrnmbr ilike '%${tx}%'"
            sqlParr = "select cntn__id from cntn, prov where cntnnmbr ilike '%${tx}%' and " +
                    "prov.prov__id = cntn.prov__id and provnmbr ilike '${rgst[0].toString().trim()}'"
            println "sqlParr: $sqlParr"
            cntn = cn.rows(sqlParr.toString())[0]?.cntn__id
//            sql = "select count(*) nada from unej where unejnmbr = '${rgst[3].toString().trim()}'"
//            println "parr: $parr"
            if (!cntn) {
                sqlParr = "select prov__id from prov where provnmbr ilike '%${rgst[0]}%'"
                def prov = cn.rows(sqlParr.toString())[0]?.prov__id
                if (prov) {
                    sqlParr = "insert into cntn(cntn__id, prov__id, cntnnmbr, cntnnmro) " +
                            "values (default, ${prov}, '${rgst[2]}', '${rgst[1]}') returning cntn__id"
                    cn.eachRow(sqlParr.toString()) { d ->
                        cntn = d.cntn__id
                    }
                    println "cntn --> $cntn"
                }
                println "no existe cantón: ${rgst[0]} ${rgst[3]} ${tx} --> cntn: ${cntn}"
//                println "sql: $sqlParr"
            }
            sql = "select count(*) nada from smfr where cntn__id = '${cntn}'"
            cnta = cn.rows(sql.toString())[0]?.nada

            if (cntn && (cnta == 0)) {
                def i = 0
                fechas.each { f ->
                    tx = f.split(' ')
                    fcds = new Date().parse("yyyy-MM-dd", tx[0]).format('yyyy-MM-dd')
                    fchs = new Date().parse("yyyy-MM-dd", tx[1]).format('yyyy-MM-dd')
                    sql = "insert into smfr (smfr__id, cntn__id, smfrcolr, smfrdsde, smfrhsta) " +
                        "values(default, '${cntn}', ${rgst[4+i]}, '${fcds}', '${fchs}') "
                        "returning smfr__id"
                    println "sql ---> ${sql}"

                    try {
                        cn.eachRow(sql.toString()) { d ->
                            id = d.smfr__id
                            insertados++
                            orden++
                        }
                        println "---> id: ${id}"
                    } catch (Exception ex) {
                        repetidos++
                        println "Error principal $ex"
                        println "sql: $sql"
                    }
                    i++
                }

            }
        }
        cnta++
        return [errores: errores, insertados: insertados, repetidos: repetidos]
    }

    def cargaItems(rgst) {
        def errores = ""
        def cnta = 0
        def insertados = 0
        def repetidos = 0
        def cn = dbConnectionService.getConnection()
        def sqlsbgr = ""
        def sql = ""
        def grpo = 0, sbgr = 0, dprt = 0, undd = 0, item = 0, cdgo = ""
        def fcha = ""
        def id = 0
        def resp = 0

        println "\n inicia cargado de datos para $rgst"
        cnta = 0
        if (rgst[1].toString().size() > 0) {
            grpo = rgst[0] == 'M' ? '1' : rgst[0] == 'MO' ? '2' : '3'
            undd = rgst[5] == 'u' ? '22' : rgst[5] == 'm' ? '12' : '6'
            sqlsbgr = "select sbgr__id from sbgr where grpo__id = $grpo and sbgrcdgo ilike '${rgst[1].toString().trim()}'"
            println "sqlSbgr: $sqlsbgr"
            sbgr = cn.rows(sqlsbgr.toString())[0]?.sbgr__id

            println "grpo: $grpo, sbgr: $sbgr"
            if (sbgr) {
                cdgo = "${rgst[1].toString().trim()}.${rgst[2].toString().trim()}.${completa(rgst[3].toString().trim())}"
                sqlsbgr = "select dprt__id from dprt where sbgr__id = $sbgr and dprtcdgo ilike '%${rgst[2]}%'"
                dprt = cn.rows(sqlsbgr.toString())[0]?.dprt__id
                println "sqlsbgr: $sqlsbgr"
                println "dprt: ${rgst[2]} --> dprt__id: ${dprt}"

                if (dprt) {
                    sqlsbgr = "insert into item(item__id, undd__id, tpit__id, dprt__id, itemcdgo, itemnmbr," +
                            "itempeso, itemtrps, itemtrvl, itemrndm, tpls__id) " +
                            "values (default, ${undd}, 1, ${dprt}, '${cdgo}', '${rgst[4].toString().trim()}', " +
                            "0,0,0,0, 1) returning item__id"
                    println "--> $sqlsbgr"
                    cn.eachRow(sqlsbgr.toString()) { d ->
                        item = d.item__id
                    }
                    println "item --> $item"
                }
            }

            rgst[6] = rgst[6] ?: ''
            println "precio: ${rgst[6]}, ${rgst[6]?.size()}"
            if (rgst[6]?.size() > 2) {
                sql = "select count(*) nada from rbpc where item__id = ${item}"
                cnta = cn.rows(sql.toString())[0]?.nada
                println "sql ---> ${sql}"
                def lgar = (grpo == '1' ? 2 : 4)
                if (item && (cnta == 0)) {
                    /* crea la precio */
                    sql = "insert into rbpc (rbpc__id, item__id, lgar__id, rbpcfcha, rbpcpcun, rbpcfcin, " +
                            "rbpcrgst) " +
                            "values(default, ${item}, ${lgar}, '1-may-2021', ${rgst[6]}, '1-may-2021', 'N') " +
                            "returning rbpc__id"
                    println "sql ---> ${sql}"

                    try {
                        cn.eachRow(sql.toString()) { d ->
                            id = d.rbpc__id
                            insertados++
                        }
                    } catch (Exception ex) {
                        repetidos++
//                    println "Error taller $ex"
                        println "Error rbpc ${rgst[6]}"
//                    println "sql: $sql"
                    }
                }
            }
        }

        cnta++
        return [errores: errores, insertados: insertados, repetidos: repetidos]
    }

    def poneFechas(rgst) {
        def fechas = rgst[(4..-1)]
        def ddds = 0, mmds = 0, ddhs = 0, mmhs = 0, data = []
        def lsFecha = []
//        println "==>${fechas}"
        fechas.each {f ->
            data = f.split(' ')
            ddds = data[0]
            mmds = meses(data[1])
            ddhs = data[3]
            mmhs = meses(data[4])
            def fcin = new Date().parse("dd-MM-yyyy", "${ddds}-${mmds}-2020")
            def fcfn = new Date().parse("dd-MM-yyyy", "${ddhs}-${mmhs}-2020")
            lsFecha.add("${fcin.format('yyyy-MM-dd')} ${fcfn.format('yyyy-MM-dd')}")
//            println "..${fcin.format('yyyy-MM-dd')} - ${fcfn.format('yyyy-MM-dd')}"
        }
        return lsFecha
    }

    def meses(mes) {
        def mess = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre',
          'noviembre', 'diciembre']
        return mess.indexOf(mes) + 1
    }

    def verifica() {
        def prsn = Persona.list()
        println "personas ok"
        def unej = UnidadEjecutora.list()
        println "Unidades ok"
        def dtor = convenio.DatosOrganizacion.list()
        println "DatosOrganizacion ok"
        render "ok"
    }

    def insertaEtor(unej, raza, nmro) {
        def cn = dbConnectionService.getConnection()
        def sql = "insert into etor (etor__id, unej__id, raza__id, etornmro) " +
                "values(default, ${unej}, ${raza}, ${nmro})"
        println "sql2: $sql"
        try {
            cn.execute(sql.toString())
        } catch (Exception ex) {
            println "Error insertaEtor $ex"
            println "Error sql: $sql"
        }
    }

    def insertaCtgr(unej, tpct, vlor) {
        def cn = dbConnectionService.getConnection()
        def sql = "insert into ctgr (ctgr__id, unej__id, tpct__id, ctgrvlor) " +
                "values(default, ${unej}, ${tpct}, '${vlor}')"
//        println "insertaCtgr: $sql"
        try {
            cn.execute(sql.toString())
        } catch (Exception ex) {
            println "Error insertaCtgr $ex"
            println "Error sql: $sql"
        }
    }

    def insertaNecd(unej, ndfr) {
        def cn = dbConnectionService.getConnection()
        def sql = "insert into necd (necd__id, unej__id, ndfr__id) " +
                "values(default, ${unej}, ${ndfr})"
//        println "insertaNecd: $sql"
        try {
            cn.execute(sql.toString())
        } catch (Exception ex) {
            println "Error insertaNecd $ex"
            println "Error sql: $sql"
        }
    }

    def hallaResponsable(nmbr) {
        def apll = nmbr.split(' ').last()
        def cn = dbConnectionService.getConnection()
        def sql = "select prsn__id from prsn where prsnapll ilike '%${apll.toString().toLowerCase()}%' "
//        println "sql2: $sql"
        cn.rows(sql.toString())[0].prsn__id
    }


    /** carga datos desde un CSV - utf-8: si ya existe lo actualiza
     * */

    def grafico() {

    }


    def indexOf() {
    }

    def verificarServicio_ajax(){
        def estado = Parametros.list().first()
        return [estado : estado.servicio == 'S']
    }

    def guardarServicio_ajax(){
        def parametros = Parametros.get(1)
        def estadoActual = parametros.servicio

        if(estadoActual == 'S'){
            parametros.servicio = 'N'
        }else{
            parametros.servicio = 'S'
        }

        if(!parametros.save(flush: true)){
            render "no_Error al cambiar el estado del servicio"
        }else{
            render "ok_Cambiado correctamente"
        }

    }


}
