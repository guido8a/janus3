package janus


import org.springframework.dao.DataIntegrityViolationException

class ItemController {

    def preciosService
    def dbConnectionService

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [itemInstanceList: Item.list(params), itemInstanceTotal: Item.count(), params: params]
    } //list

    def registrarPrecios() {

    }

    def precioVolumen() {

    }

    def mantenimientoPrecios() {

    }

    def tablaRegistrar() {
        if (!params.max || params.max == 0) {
            params.max = 100
        } else {
            params.max = params.max.toInteger()
        }
        if (!params.pag) {
            params.pag = 1;
        } else {
            params.pag = params.pag.toInteger()
        }
        params.offset = params.max * (params.pag - 1)

        def lugar = Lugar.get(params.lgar)
        def sql
        def tipo = Grupo.get(params.tipo)

        sql = "select distinct rbpc.item__id, item.itemcdgo "
        sql += "from rbpc, item"
        if (params.tipo != "-1") {
            sql += ", dprt, sbgr, grpo"
        }
        sql += " where rbpc.item__id=item.item__id and lgar__id = ${lugar.id} "
        if (params.tipo != "-1") {
            sql += "and item.dprt__id = dprt.dprt__id "
            sql += "and dprt.sbgr__id = sbgr.sbgr__id "
            sql += "and sbgr.grpo__id = grpo.grpo__id "
            sql += "and grpo.grpo__id = ${tipo.id}"
        }
        sql += " and rbpcrgst != 'R'"
        sql += " order by itemcdgo "

        def estado = "and r1.rbpcrgst!='R'"

//            println ">>" + sql

        def itemsIds = ""

        def cn = dbConnectionService.getConnection()
        cn.eachRow(sql.toString()) { row ->
            if (itemsIds != "") {
                itemsIds += ","
            }
            itemsIds += row[0]
        }

        if (itemsIds == "") itemsIds = '-1'

        def precios = preciosService.getPrecioRubroItemEstadoNoFecha(lugar, itemsIds, estado)
        def rubroPrecio = []
        precios.each {
            def pri = PrecioRubrosItems.get(it)
            rubroPrecio.add(pri)
        }


        if (params.tipo == '-1') {
            if (!params.totalRows) {
                sql = "select count(distinct rbpc.item__id) "
                sql += "from rbpc "
                sql += "where lgar__id=${lugar.id} "
                sql += " and rbpcrgst != 'R'"

                def totalCount
                cn.eachRow(sql.toString()) { row ->
                    totalCount = row[0]
                }

                params.totalRows = totalCount
                params.totalPags = Math.ceil(params.totalRows / params.max).toInteger()

                if (params.totalPags <= 10) {
                    params.first = 1
                    params.last = params.last = params.totalPags
                } else {
                    params.first = Math.max(1, params.pag.toInteger() - 5)
                    params.last = Math.min(params.totalPags, params.pag + 5)

                    def ts = params.last - params.first
                    if (ts < 9) {
                        def r = 10 - ts
                        params.last = Math.min(params.totalPags, params.last + r).toInteger()
                    }
                }
            }
            cn.close()
        } else {
            if (!params.totalRows) {
                sql = "select count(distinct rbpc.item__id) "
                sql += "from rbpc, item "
                sql += ", dprt, sbgr, grpo "
                sql += "where lgar__id=${lugar.id} "
                sql += "and rbpc.item__id = item.item__id "
                sql += "and item.dprt__id = dprt.dprt__id "
                sql += "and dprt.sbgr__id = sbgr.sbgr__id "
                sql += "and sbgr.grpo__id = grpo.grpo__id "
                sql += "and grpo.grpo__id =${tipo.id}"
                sql += " and rbpcrgst != 'R'"

                def totalCount
                cn.eachRow(sql.toString()) { row ->
                    totalCount = row[0]
                }
                params.totalRows = totalCount
                params.totalPags = Math.ceil(params.totalRows / params.max).toInteger()
                if (params.totalPags <= 10) {
                    params.first = 1
                    params.last = params.last = params.totalPags
                } else {
                    params.first = Math.max(1, params.pag.toInteger() - 5)
                    params.last = Math.min(params.totalPags, params.pag + 5)

                    def ts = params.last - params.first
                    if (ts < 9) {
                        def r = 10 - ts
                        params.last = Math.min(params.totalPags, params.last + r).toInteger()
                    }
                }
            }
            cn.close()
        }

        [rubroPrecio: rubroPrecio, params: params, lugar: lugar]
    }

    def tablaVolumen() {
        if (!params.max || params.max == 0) {
            params.max = 100
        } else {
            params.max = params.max.toInteger()
        }
        if (!params.pag) {
            params.pag = 1;
        } else {
            params.pag = params.pag.toInteger()
        }
        params.offset = params.max * (params.pag - 1)

        def f = new Date().parse("dd-MM-yyyy", params.fecha)

        f = f.format("yyyy-MM-dd")

        def tipoLugar = ""

        if (params.lgar == '-1') {
            tipoLugar = " IN (3,4,5)"
        } else {
            tipoLugar = " = " + params.lgar
        }

        def sqlLugares = "SELECT\n" +
                "  l.lgar__id id,\n" +
                "  l.lgardscr des,\n" +
                "  t.tplsdscr tipo\n" +
                "FROM lgar l\n" +
                "  INNER JOIN tpls t\n" +
                "    ON l.tpls__id = t.tpls__id\n" +
                "WHERE l.tpls__id ${tipoLugar}\n" +
                "ORDER BY 3, 2"

        def sqlPrecios = "SELECT\n" +
                "  r.rbpc__id      rbpc_id,\n" +
                "  i.item__id      item_id,\n" +
                "  l.lgar__id      lugar_id,\n" +
                "  l.lgardscr      lugar,\n" +
                "  i.itemnmbr      item,\n" +
                "  i.itemcdgo      codigo,\n" +
                "  u.unddcdgo      unidad,\n" +
                "  r.rbpcpcun      precio,\n" +
                "  r.rbpcfcha      fecha,\n" +
                "  i.tpls__id      tipo\n" +
                "FROM item i\n" +
                "  LEFT JOIN rbpc r\n" +
                "    ON i.item__id = r.item__id AND r.rbpcfcha <= '${f}'\n" +
                "  INNER JOIN undd u\n" +
                "    ON i.undd__id = u.undd__id\n" +
                "  LEFT JOIN lgar l\n" +
                "    ON r.lgar__id = l.lgar__id\n" +
                "WHERE i.tpls__id ${tipoLugar}\n" +
                "ORDER BY i.itemcdgo,l.lgardscr,r.rbpcfcha desc, i.item__id"

        def lugares = []

        def html = "<table class=\"table table-bordered table-striped table-hover table-condensed\" id=\"tablaPrecios\">"

        html += "<thead>"
        html += "<tr>"
        html += "<th rowspan='2'>Código</th>"
        html += "<th rowspan='2'>Item</th>"
        html += "<th rowspan='2'>Unidad</th>"
        def cn = dbConnectionService.getConnection()
        def arr = cn.rows(sqlLugares.toString())
        def precios = cn.rows(sqlPrecios.toString())
        cn.close()

        def r1 = "", r2 = "<tr>", last = arr[0]?.tipo, c = 1

        arr.eachWithIndex { row, index ->
            lugares.add(row.id)
            if (last != row.tipo) {
                r1 += "<th colspan='${c}'>${last}</th>"
                c = 1
                last = row.tipo
            } else {
                c++
            }
            if (index == arr.size() - 1) {
                r1 += "<th colspan='${c}'>${last}</th>"
            }
            r2 += "<th>${row.des}</th>"
        }
        r2 += "</tr>"

        html += r1
        html += r2

        html += "</tr>"
        html += "</thead>"

        html += "<tbody>"
        def body = ""
        last = null


        precios.eachWithIndex { row, int index ->
            if (last != row.item_id) {
                last = row.item_id
                if (index > 0) {
                    body += "</tr>"
                }
                body += "<tr>"
                body += "<td>${row.codigo}</td>"
                body += "<td>${row.item}</td>"
                body += "<td class='unidad'>${row.unidad}</td>"
                lugares.each { lugarId ->
                    def precio = precios.find {
                        it.item_id == row.item_id && it.lugar_id == lugarId
                    }
                    def prec = "", p = 0, rubro = "new", clase = ""
                    if (precio) {
                        prec = g.formatNumber(number: precio.precio, maxFractionDigits: 5, minFractionDigits: 5, locale: "ec")
                        p = precio.precio
                        if (precio.fecha.format("yyyy-MM-dd") == f) {
                            rubro = precio.rbpc_id
                        } else {
                            clase += "old "
                        }
                    }
                    if (params.lgar != "-1") {
                        clase += "editable"
                    }
                    body += "<td class='${clase} number' data-original='${p}' data-valor='${p}' data-lugar='${lugarId}' data-id='${rubro}' data-item='${row.item_id}'>" + prec + '</td>'
                }
            }
        }
        html += body
        html += "</tbody>"

        html += "</table>"

        return [html: html]
    }

    def tabla() {
        println "tabla " + params
        if (!params.max || params.max == 0) {
            params.max = 20
        } else {
            params.max = params.max.toInteger()
        }
        if (!params.pag) {
            params.pag = 1;
        } else {
            params.pag = params.pag.toInteger()
        }
        params.offset = params.max * (params.pag - 1)

        def f = new Date().parse("dd-MM-yyyy", params.fecha)

        def t = params.todos

        def lugar;
        def rubroPrecio;

        def tipo;

        if (t == "2") {
            lugar = Lugar.get(params.lgar)
            def sql
            tipo = Grupo.get(params.tipo)

            sql = "select distinct rbpc.item__id, item.itemcdgo "
            sql += "from rbpc, item"
            if (params.tipo != "-1") {
                sql += ", dprt, sbgr, grpo"
            }
            sql += " where lgar__id = ${lugar.id} "
            sql += "and rbpc.item__id = item.item__id and itemetdo = 'A' "
            if (params.tipo != "-1") {
                sql += "and item.dprt__id = dprt.dprt__id "
                sql += "and dprt.sbgr__id = sbgr.sbgr__id "
                sql += "and sbgr.grpo__id = grpo.grpo__id "
                sql += "and grpo.grpo__id = ${tipo.id}"
            }
            def estado = ""
            if (params.reg == "R") {
                sql += " and rbpcrgst = 'R'"
                estado = "and r1.rbpcrgst='R'"
            } else if (params.reg == "N") {
                sql += " and rbpcrgst != 'R'"
                estado = "and r1.rbpcrgst!='R'"
            }

            sql += " order by itemcdgo "
            sql += "limit ${params.max} "
            sql += "offset ${params.offset} "

            println "SQL:" + sql

            def itemsIds = ""

            def cn = dbConnectionService.getConnection()

            cn.eachRow(sql.toString()) { row ->
                if (itemsIds != "") {
                    itemsIds += ","
                }
                itemsIds += row[0]
            }

            if (itemsIds == ""){
                itemsIds = '-1'
            }

            def precios = preciosService.getPrecioRubroItemEstado(f, lugar, itemsIds, estado)

            rubroPrecio = []

            def totalPrueba

            precios.each {
                def pri = PrecioRubrosItems.get(it)
                rubroPrecio.add(pri)

            }

            if (params.tipo == '-1') {

                if (!params.totalRows) {
                    def sql3

                    sql3 = "select count(distinct rbpc.item__id) "
                    sql3 += "from rbpc "
                    sql3 += "where lgar__id = ${lugar.id} "
                    if (params.reg == "R") {
                        sql3 += " and rbpcrgst = 'R'"
                    } else if (params.reg == "N") {
                        sql3 += " and rbpcrgst != 'R'"
                    }

                    cn.eachRow(sql3.toString()) { row ->
                        if (itemsIds != "") {
                            itemsIds += ","
                        }
                        itemsIds += row[0]
                    }

                    if (itemsIds == ""){
                        itemsIds = '-1'
                    }

                    def precios3 = preciosService.getPrecioRubroItemEstado(f, lugar, itemsIds, estado)

                    rubroPrecio = []

                    def totalCount = 0
                    precios3.each {
                        def pri = PrecioRubrosItems.get(it)
                        rubroPrecio.add(pri)
                    }


                    if(rubroPrecio == []){
                        totalCount = 0
                    }else {
                        cn.eachRow(sql3.toString()) { row ->
                            totalCount= row[0]
                        }
                    }

                    params.totalRows = totalCount

                    if(params.totalRows == 0){
                        params.totalPags = 0
                    }else {
                        params.totalPags = Math.ceil(params.totalRows / params.max).toInteger()
                    }
//
                    if (params.totalPags <= 10) {
                        params.first = 1
                        params.last = params.last = params.totalPags
                    } else {
                        params.first = Math.max(1, params.pag.toInteger() - 5)
                        params.last = Math.min(params.totalPags, params.pag + 5)

                        def ts = params.last - params.first
                        if (ts < 9) {
                            def r = 10 - ts
                            params.last = Math.min(params.totalPags, params.last + r).toInteger()
                        }
                    }
                }
                cn.close()
            } else {
//                println("entro2")
                if (!params.totalRows) {
                    def sql2

                    sql2 = "select count(distinct rbpc.item__id) "
                    sql2 += "from rbpc, item "
                    sql2 += ", dprt, sbgr, grpo "
                    sql2 += "where lgar__id=${lugar.id} "
                    sql2 += "and rbpc.item__id = item.item__id "
                    sql2 += "and item.dprt__id = dprt.dprt__id "
                    sql2 += "and dprt.sbgr__id = sbgr.sbgr__id "
                    sql2 += "and sbgr.grpo__id = grpo.grpo__id "
                    sql2 += "and grpo.grpo__id =${tipo.id}"
                    if (params.reg == "R") {
                        sql2 += " and rbpcrgst = 'R'"
                    } else if (params.reg == "N") {
                        sql2 += " and rbpcrgst != 'R'"
                    }
//                    println("**" + sql)

                    cn.eachRow(sql2.toString()) { row ->
//                println "\t" + row[0]
                        if (itemsIds != "") {
                            itemsIds += ","
                        }
                        itemsIds += row[0]
                    }

                    if (itemsIds == ""){
                        itemsIds = '-1'
                    }

                    def precios2 = preciosService.getPrecioRubroItemEstado(f, lugar, itemsIds, estado)

                    rubroPrecio = []

                    def totalCount = 0
                    def totalCount1 = 0
                    precios2.each {
                        def pri = PrecioRubrosItems.get(it)
                        rubroPrecio.add(pri)
                    }

                    if(rubroPrecio == []){
                       totalCount = 0
                    }else {
                      cn.eachRow(sql2.toString()) { row ->
//                            println("row" + (row))
                            totalCount= row[0]
                        }
                    }

                    params.totalRows = totalCount
//
                    if(params.totalRows == 0){
                        params.totalPags = 0
                    }else {
                        params.totalPags = Math.ceil(params.totalRows / params.max).toInteger()
                    }
//
                    if (params.totalPags <= 10) {
                        params.first = 1
                        params.last = params.last = params.totalPags
                    } else {
                        params.first = Math.max(1, params.pag.toInteger() - 5)
                        params.last = Math.min(params.totalPags, params.pag + 5)

                        def ts = params.last - params.first
                        if (ts < 9) {
                            def r = 10 - ts
                            params.last = Math.min(params.totalPags, params.last + r).toInteger()
                        }
                    }
                }
                cn.close()
            }

        }

        [rubroPrecio: rubroPrecio, params: params, lugar: lugar]
    }

    def actualizarRegistro() {
        //item=145629_0.12601_true&item=478_0.11000_true&item=650_0.29000_false
        //      idRubroPrecio_precio_registrado
        //          0           1       2
        if (params.item instanceof java.lang.String) {
            params.item = [params.item]
        }
        def oks = "", nos = ""
        params.item.each {
            def parts = it.split("_")
//            println ">>" + parts

            def rubroId = parts[0]
            def precio = parts[1]
            def reg = parts[2] == 'true' ? 'R' : 'N'

            def rubroPrecioInstance = PrecioRubrosItems.get(rubroId);

            rubroPrecioInstance.precioUnitario = precio.toDouble()
            rubroPrecioInstance.registrado = reg

            if (!rubroPrecioInstance.save(flush: true)) {
                println "item controller l 547: " + "error " + parts
                if (nos != "") {
                    nos += ","
                }
                nos += "#" + rubroId
            } else {
                if (oks != "") {
                    oks += ","
                }
                oks += "#" + rubroId
            }
        }
        render oks + "_" + nos
    }

    def actualizarVol() {

//        println params
        if (params.item instanceof java.lang.String) {
            params.item = [params.item]
        }

        def oks = "", nos = ""

        params.item.each {
            def parts = it.split("_")
            def rubroId = parts[0]
            def itemId = parts[1]
            def lugarId = parts[2]

            def nuevoPrecio = parts[3].toDouble()
            def nuevaFecha = parts[4]

            nuevaFecha = new Date().parse("dd-MM-yyyy", nuevaFecha);

            def rubroPrecioInstance

            if (rubroId == "new") {
                rubroPrecioInstance = new PrecioRubrosItems();
            } else {
                rubroPrecioInstance = PrecioRubrosItems.get(rubroId);
            }

            rubroPrecioInstance.item = Item.get(itemId)
            rubroPrecioInstance.lugar = Lugar.get(lugarId)
            rubroPrecioInstance.fecha = nuevaFecha
            rubroPrecioInstance.precioUnitario = nuevoPrecio
            rubroPrecioInstance.fechaIngreso = nuevaFecha
            rubroPrecioInstance.registrado = "N"

            if (!rubroPrecioInstance.save(flush: true)) {
                println "item controller l 601: " + "error " + parts
                if (nos != "") {
                    nos += ","
                }
                nos += "#" + rubroId
            } else {
                if (oks != "") {
                    oks += ","
                }
                oks += "#" + rubroId
            }

        }
        render oks + "_" + nos
    }


    def actualizar() {

//        println("parmas actualizar precios" + params)
        if (params.item instanceof java.lang.String) {
            params.item = [params.item]
        }

        def oks = "", nos = ""

        params.item.each {
            def parts = it.split("_")
            def rubroId = parts[0]
            def nuevoPrecio = parts[1]
            def nuevaFecha = parts[2]

            nuevaFecha = new Date().parse("dd-MM-yyyy", nuevaFecha);

            def rubroPrecioInstanceOld = PrecioRubrosItems.get(rubroId);
            def precios = PrecioRubrosItems.withCriteria {
                  eq("fecha", nuevaFecha)
                  eq("lugar", rubroPrecioInstanceOld.lugar)
                  eq("item", rubroPrecioInstanceOld.item)
            }.size()

            def rubroPrecioInstance
            if (precios == 0) {
                rubroPrecioInstance = new PrecioRubrosItems();
                rubroPrecioInstance.properties = rubroPrecioInstanceOld.properties
                rubroPrecioInstance.id = null
            } else {
                rubroPrecioInstance = rubroPrecioInstanceOld
            }
            rubroPrecioInstance.precioUnitario = nuevoPrecio.toDouble();
            rubroPrecioInstance.registrado = "N"
            rubroPrecioInstance.fecha = nuevaFecha

            if (!rubroPrecioInstance.save(flush: true)) {
                println "item controller l 656: " + "error " + parts
                if (nos != "") {
                    nos += ","
                }
                nos += "#" + rubroId
            } else {
                if (oks != "") {
                    oks += ","
                }
                oks += "#" + rubroId
            }
        }
        render oks + "_" + nos
    }


    def form_ajax() {
        def itemInstance = new Item(params)
        if (params.id) {
            itemInstance = Item.get(params.id)
            if (!itemInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Item con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [itemInstance: itemInstance]
    } //form_ajax

    def save() {
        def itemInstance
        if (params.id) {
            itemInstance = Item.get(params.id)
            if (!itemInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Item con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            itemInstance.properties = params
        }//es edit
        else {
            itemInstance = new Item(params)
        } //es create
        if (!itemInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Item " + (itemInstance.id ? itemInstance.id : "") + "</h4>"

            str += "<ul>"
            itemInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex { arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(action: 'list')
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Item " + itemInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Item " + itemInstance.id
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def itemInstance = Item.get(params.id)
        if (!itemInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Item con id " + params.id
            redirect(action: "list")
            return
        }
        [itemInstance: itemInstance]
    } //show

    def delete() {
        def itemInstance = Item.get(params.id)
        if (!itemInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Item con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            itemInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Item " + itemInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Item " + (itemInstance.id ? itemInstance.id : "")
            redirect(action: "list")
        }
    } //delete


    def historicoEspecificaciones(){

    }

    def tablaHistorico_ajax() {
        def cn = dbConnectionService.getConnection()
        def sql = "select item.item__id, itemcdgo, itemnmbr, ares.itemcdes, aresruta, aresespe, itemfoto " +
                "from item, ares where ares.itemcdes = item.itemcdes and tpit__id = 2 and " +
                "itemnmbr ilike '%${params.criterio}%'"
        println "sql: $sql"
        def data = cn.rows(sql.toString())

        return [datos: data]
    }

    def tablaArchivosHistoricos_ajax() {
        def item = Item.get(params.id)
        def cdes = item.codigoEspecificacion
        def items = Item.findAllByCodigoEspecificacion(cdes)
        def ids = items.id.flatten().join(' ')
        def codigos = items.codigo.flatten().join(', ')
        def nombres = items.nombre.flatten().join('<br>')
        def arch = ""

        def filtrados = []
        File[] archivos
        def ruta = '/var/janus/rubros'
        File carpeta = new File(ruta)
        def partes
        if (carpeta.exists()) {
            if (carpeta.isDirectory()) {
                archivos = carpeta.listFiles()
                for (int i = 0; i < archivos.length; i++) {
                    if (archivos[i].getName().endsWith('pdf')) {
                        arch = archivos[i].getName()
//                        println "$arch"
                        try {
                            partes = arch.split("_")[2]
                        } catch (e) {
                            partes = ""
                        }
//                        if (arch.contains('800')) println "----------- $arch  --> $partes"
                        if ((partes != "") && ids.contains(partes)) {
//                            println "añade: $arch"
                            def filtrado = arch
                            filtrados.add(filtrado)
                        }
                    }
                }
            }
        }
        println "se han halla ${archivos.size()} archivos en la carpeta: $ruta"
//        println(" > " + filtrados)

        return [cdes: cdes, datos: filtrados, codigos: codigos, ids: ids, nombres: nombres]
    }

    def downloadFile() {
        def ext = "pdf"
        def nombre = params.id + "." + ext
        def folder = "rubros"
        def path = "/var/janus/" + folder + File.separatorChar + nombre
//        println "path " + path
        def file = new File(path)
        if (file.exists()) {
            def b = file.getBytes()
            response.setContentType(ext == 'pdf' ? "application/pdf" : "image/" + "pdf")
            response.setHeader("Content-disposition", "attachment; filename=" + params.id)
            response.setContentLength(b.length)
            response.getOutputStream().write(b)
        } else {

        }
    }

} //fin controller
