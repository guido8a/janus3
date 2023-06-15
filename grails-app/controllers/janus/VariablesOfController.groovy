package janus

class VariablesOfController {

    def dbConnectionService

    def variables_ajax() {
        println params

        def obra = Obra.get(params.obra)
        def par = Parametros.list()
        if (par.size() > 0)
            par = par.pop()

        def volquetes = []
        def choferes = []

        [choferes: choferes, volquetes: volquetes, obra: obra, par: par]
    }

    def saveVar_ajax() {
        println "save vars aqui " + params

        if(!params.mecanico){
            render "no_No se pudo actualizar las variables, debe ingresar una cantidad válida en mecánico"
            return
        }

        def itemMecanico = Item.findByCodigo('009.001')
        def precioMecanico = Precio.findByItemAndOferente(itemMecanico, session.usuario)


        if (precioMecanico) {
            precioMecanico.precio = params.mecanico.toDouble()
            println "precio double "+precioMecanico.precio
            precioMecanico.save(flush: true)
        } else {

            precioMecanico = new Precio()
            precioMecanico.fecha = new Date()
            precioMecanico.item = itemMecanico
            precioMecanico.precio = params.mecanico.toDouble()
            precioMecanico.oferente = session.usuario

            if (precioMecanico.save(flush: true)) {

            } else {
                println(precioMecanico.errors)
            }
        }

        def obra = Obra.get(params.idObra)
        obra.properties = params

        if (obra.save(flush: true)) {
            render "ok_Variables guardadas correctamente"
        } else {
            println obra.errors
            render "no_Error al guardar las variables"
        }
    }

    def composicion() {
//        if (!params.id) {
//            params.id = "886"
//        }
        if (!params.tipo) {
            params.tipo = "-1"
        }
        if (!params.rend) {
            params.rend = "screen"
        }

        def obra = Obra.get(params.id)
        if (params.tipo == "-1") {
            params.tipo = "1,2,3"
        }

        def wsp = ""

        if(!params.sp) {
            params.sp = -1
        }

        if (params.sp.toString() != "-1") {
            wsp = "      AND v.sbpr__id = ${params.sp} \n"
        }

/*
        def sql = "SELECT\n" +
                "  v.voit__id                            id,\n" +
                "  i.itemcdgo                            codigo,\n" +
                "  i.itemnmbr                            item,\n" +
                "  u.unddcdgo                            unidad,\n" +
                "  v.voitcntd                            cantidad,\n" +
                "  v.voitpcun                            punitario,\n" +
                "  v.voittrnp                            transporte,\n" +
                "  v.voitpcun                            costo,\n" +
                "  (v.voitpcun)*v.voitcntd               total,\n" +
                "  d.dprtdscr                            departamento,\n" +
                "  s.sbgrdscr                            subgrupo,\n" +
                "  g.grpodscr                            grupo,\n" +
                "  g.grpo__id                            grid\n" +
                "FROM vlobitem v\n" +
                "INNER JOIN item i ON v.item__id = i.item__id\n" +
                "INNER JOIN undd u ON i.undd__id = u.undd__id\n" +
                "INNER JOIN dprt d ON i.dprt__id = d.dprt__id\n" +
                "INNER JOIN sbgr s ON d.sbgr__id = s.sbgr__id\n" +
                "INNER JOIN grpo g ON s.grpo__id = g.grpo__id AND g.grpo__id IN (${params.tipo})\n" +
                "WHERE v.obra__id = ${params.id} \n" +
                "  ORDER BY grid ASC"
*/



        def sql = "SELECT i.itemcdgo codigo, i.itemnmbr item, u.unddcdgo unidad, sum(v.voitcntd) cantidad, \n" +
                "v.voitpcun punitario, v.voittrnp transporte, v.voitpcun + v.voittrnp  costo, \n" +
                "sum((v.voitpcun + v.voittrnp) * v.voitcntd)  total, g.grpodscr grupo, g.grpo__id grid \n" +
                "FROM vlobitem v INNER JOIN item i ON v.item__id = i.item__id\n" +
                "INNER JOIN undd u ON i.undd__id = u.undd__id\n" +
                "INNER JOIN dprt d ON i.dprt__id = d.dprt__id\n" +
                "INNER JOIN sbgr s ON d.sbgr__id = s.sbgr__id\n" +
                "INNER JOIN grpo g ON s.grpo__id = g.grpo__id AND g.grpo__id IN (${params.tipo}) \n" +
                "WHERE v.obra__id = ${params.id} and v.voitcntd >0 \n" + wsp +
                "group by i.itemcdgo, i.itemnmbr, u.unddcdgo, v.voitpcun, v.voittrnp, v.voitpcun, \n" +
                "g.grpo__id, g.grpodscr " +
                "ORDER BY g.grpo__id ASC, i.itemcdgo"
//        println sql

        def sqlSP = "SELECT\n" +
                "  DISTINCT v.sbpr__id      id,\n" +
                "  s.sbprdscr               dsc,\n" +
                "  count(v.item__id)        count\n" +
                "FROM vlobitem v\n" +
                "  INNER JOIN sbpr s\n" +
                "    ON v.sbpr__id = s.sbpr__id\n" +
                "WHERE v.obra__id = ${params.id}\n" +
                "GROUP BY 1, 2"
//        println "SP:" + sqlSP

        def cn = dbConnectionService.getConnection()

        if (params.rend == "screen" || params.rend == "pdf") {
            def res = cn.rows(sql.toString())
            def sp = cn.rows(sqlSP.toString())
            return [res: res, obra: obra, tipo: params.tipo, rend: params.rend, sp: sp, spsel: params.sp, sub: params.sp]
        }
    }

}
