package janus

import janus.pac.TipoProcedimiento
import seguridad.Persona

class VolumenObraController {
    def buscadorService
    def preciosService
    def dbConnectionService

    def volObra() {

        def grupoFiltrado = Grupo.findAllByCodigoNotIlikeAndCodigoNotIlikeAndCodigoNotIlike('1', '2', '3');
        def subpreFiltrado = []
        def var
        def listaRbro = [1: 'Materiales', 2: 'Mano de obra', 3: 'Equipos']
        def listaItems = [1: 'Nombre', 2: 'Código']

//        println "grupo "+grupoFiltrado.id
//        def grupos = Grupo.list([sort: "descripcion"])
        subpreFiltrado = SubPresupuesto.findAllByGrupo(grupoFiltrado[0],[sort:"descripcion"])
//        println("-->>" + subpreFiltrado)

        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def direccion = Direccion.get(persona?.departamento?.direccion?.id)
        def grupo = Grupo.findAllByDireccion(direccion)
//
        println("direccion:" + direccion)
        println("grupo:" + grupo)

        def subPresupuesto1 = []
        if(grupo) subPresupuesto1 = SubPresupuesto.findAllByGrupoInList(grupo)

        def obra = Obra.get(params.id)
        def volumenes = VolumenesObra.findAllByObra(obra)

//        def personasUtfpu = Persona.findAllByDepartamento(Departamento.findByCodigo('UTFPU'))
//        def responsableObra = obra?.responsableObra?.id
        def duenoObra = 0

//        personasUtfpu.each{
//            if(it.id == responsableObra ){
//                duenoObra = 1
//            }
//        }

        duenoObra = esDuenoObra(obra)? 1 : 0

        def valorMenorCuantia = TipoProcedimiento.findBySigla("MCD")?.techo?:  210000
        def valorLicitacion = TipoProcedimiento.findBySigla("LICO")?.minimo?: 30000000

        def campos = ["codigo": ["Código", "string"], "nombre": ["Descripción", "string"]]
        println "valores: valorLicitacion: $valorLicitacion, valorMenorCuantia: $valorMenorCuantia"

        [obra: obra, volumenes: volumenes, campos: campos, subPresupuesto1: subPresupuesto1, grupoFiltrado: grupoFiltrado,
         subpreFiltrado: subpreFiltrado, grupos: grupoFiltrado, persona: persona, vmc: valorMenorCuantia, duenoObra: duenoObra,
         valorLicitacion: valorLicitacion, listaRbro: listaRbro, listaItems: listaItems]
    }

    def cargarSubpres() {
//        println("params" + params)
        def grupo = Grupo.get(params.grupo)
        def subs = SubPresupuesto.findAllByGrupo(grupo,[sort:"descripcion"])
        [subs: subs]
    }



    def setMontoObra() {
        def tot = params.monto
        try {
            tot = tot.toDouble()
        } catch (e) {
            tot = 0
        }
//        println " total de la obra:; $tot"
        def obra = Obra.get(params.obra)
        if (obra.valor != tot) {
            obra.valor = tot
            obra.save(flush: true)
        }

        // actualiza el rendimiento de rubros transporte TR%
        /** existe el peligro de que este rubro sea actualizado en otra obra mientras se procesa la obra actual **/
        preciosService.ac_transporteDesalojo(obra.id)

        render "ok"
    }

    def cargaCombosEditar() {

        def sub = SubPresupuesto.get(params.id)
        def grupo = sub?.grupo
        def subs = SubPresupuesto.findAllByGrupo(grupo,[sort:"descripcion"])
        [subs: subs, sub: sub]
    }


    def buscarRubroCodigo() {
//        println "aqui "+params
        def rubro = Item.findByCodigoAndTipoItem(params.codigo?.trim()?.toUpperCase(), TipoItem.get(2))
        if (rubro) {
            render "" + rubro.id + "&&" + rubro.tipoLista?.id + "&&" + rubro.nombre + "&&" + rubro.unidad?.codigo
            return
        } else {
            render "-1"
            return
        }
    }


    def addItem() {
//        println "addItem " + params
        def obra = Obra.get(params.obra)
//        def rubro2 = Item.get(params.rubro)
//        def rubro = Item.get(params.id)
        def rubro = Item.findByCodigoIlike(params.cod)
        def sbpr = SubPresupuesto.get(params.sub)
        def volumen
        def msg = ""
//        if (params.vlob_id)
        if (params.id)
            volumen = VolumenesObra.get(params.id)
        else {

            volumen = new VolumenesObra()
//            def v=VolumenesObra.findByItemAndObra(rubro,obra)
            println "from VolumenesObra where obra=${obra.id} and item=${rubro.id} and subPresupuesto=${sbpr.id}"
//            def v = VolumenesObra.findAll("from VolumenesObra where obra=${obra.id} and item=${rubro.id} and subPresupuesto=${sbpr.id}")
            def v = VolumenesObra.findAllByObraAndItemAndSubPresupuesto(obra, rubro, sbpr)
            println "----v "+v
            if (v.size() > 0) {
                v = v.pop()
                if (params.override == "1") {
                    v.cantidad += params.cantidad.toDouble()
                    v.save(flush: true)
                    redirect(action: "tabla", params: [obra: obra.id, sub: v.subPresupuesto.id, ord: 1])
                    return
                } else {
                    msg = "error"
                    render msg
                    return
                }
            }
        }
//        println "volumn :" + volumen

        volumen.cantidad = params.cantidad.toDouble()
        volumen.orden = params.orden.toInteger()
        volumen.subPresupuesto = SubPresupuesto.get(params.sub)
        volumen.obra = obra
        volumen.item = rubro
        volumen.descripcion = params.dscr

        if (!volumen.save(flush: true)) {
            println "error volumen obra " + volumen.errors
            render "error"
        } else {
            preciosService.actualizaOrden(volumen, "insert")
            redirect(action: "tabla", params: [obra: obra.id, sub: volumen.subPresupuesto.id, ord: 1])
        }
    }

    def copiarItem() {

        println "copiarItem "+params

        def obra = Obra.get(params.obra)
        def rubro = Item.get(params.rubro)
        def sbprDest = SubPresupuesto.get(params.subDest)
        def sbpr = SubPresupuesto.get(params.sub)
        def itemVolumen = VolumenesObra.findByItemAndSubPresupuestoAndObra(rubro, sbpr, obra)
        def itemVolumenDest = VolumenesObra.findByItemAndSubPresupuestoAndObra(rubro, sbprDest, obra)
        def volumen
        def cont = 10000
//        def volu = VolumenesObra.list()

            if (itemVolumenDest) {
                render "no_No se puede copiar el rubro, ya existe en el subpresupuesto de destino"
                return true
            } else {
                volumen = VolumenesObra.findByObraAndItemAndSubPresupuesto(obra, rubro, sbprDest)
                if (volumen == null)
                    volumen = new VolumenesObra()
            }


        if(params.canti){
            volumen.cantidad = params.canti.toDouble()
        }else{
            volumen.cantidad = itemVolumen.cantidad.toDouble()
        }

//        volumen.orden = (volu.orden.size().toInteger()) + 1
        volumen.orden = cont++
        volumen.subPresupuesto = SubPresupuesto.get(params.subDest)
        volumen.obra = obra
        volumen.item = rubro
        if (!volumen.save(flush: true)) {
            render "no_No se puede copiar el rubro"
        } else {
            render "ok_Rubro copiado correctamente"
            preciosService.actualizaOrden(volumen, "insert")

        }
    }

    /** carga tabla de detalle de volúmenes de obra **/
    def tabla() {
        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def direccion = Direccion.get(persona?.departamento?.direccion?.id)
        def grupo = Grupo.findAllByDireccion(direccion)
        def subPresupuesto1 = []
        if(grupo) subPresupuesto1 = SubPresupuesto.findAllByGrupoInList(grupo)
        def obra = Obra.get(params.obra)

        def duenoObra = 0
        def valores
        def orden

        if (params.ord == '1') {
            orden = 'asc'
        } else {
            orden = 'desc'
        }

        // actualiza el rendimiento de rubros transporte TR% si la obra no está registrada y herr. menor
        if(obra.estado != 'R') {
            preciosService.ac_transporteDesalojo(obra.id)
            preciosService.ac_rbroObra(obra.id)
        }

        if (params.sub && params.sub != "-1") {
            valores = preciosService.rbro_pcun_v5(obra.id, params.sub, orden)
        } else {
            valores = preciosService.rbro_pcun_v4(obra.id, orden)
        }

        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
        def estado = obra.estado

        duenoObra = esDuenoObra(obra)? 1 : 0

        [subPres: subPres, subPre: params.sub, obra: obra, valores: valores,
         subPresupuesto1: subPresupuesto1, estado: estado, msg: params.msg, persona: persona, duenoObra: duenoObra]
    }

    def esDuenoObra(obra) {

        def dueno = false
        def funcionElab = Funcion.findByCodigo('E')
        def personasUtfpu = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, Persona.findAllByDepartamento(Departamento.findByCodigo('UTFPU')))
        def responsableRol = PersonaRol.findByPersonaAndFuncion(obra?.responsableObra, funcionElab)
        def persona = Persona.get(session.usuario.id)

        if (responsableRol) {
            println "${obra?.responsableObra?.departamento?.id} ==== ${Persona.get(session.usuario.id).departamento?.id}"

            if (personasUtfpu.contains(responsableRol) && persona.departamento.codigo == 'UTFPU') {
                dueno = true
            } else if (obra?.responsableObra?.departamento?.direccion?.id == persona.departamento?.direccion?.id) {
                dueno = true
            }
        }
        dueno
    }

    def eliminarRubro() {
        println "elm rubro " + params
        def vol = VolumenesObra.get(params.id)
        def obra = vol.obra
        def orden = vol.orden
        def msg = "ok"
        def cronos = Cronograma.findAllByVolumenObra(vol)
        cronos.each { c ->
            if (c.porcentaje == 0) {
                c.delete(flush: true)
            } else {
                msg = "Error no se puede borrar el rubro porque esta presente en el cronograma con un valor diferente de cero."
            }
        }

        try {
            if (msg == "ok") {
                preciosService.actualizaOrden(vol, "delete")
                vol.delete(flush: true)
            }

        } catch (e) {
            println "e " + e
            msg = "Error"
        }

        render msg
//        redirect(action: "tabla", params: [obra: obra.id, sub: vol.subPresupuesto.id, ord: 1, msg: msg])


    }

    def copiarRubros() {

        def obra = Obra.get(params.obra)
        def volumenes = VolumenesObra.findAllByObra(obra)
        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()

        return [obra: obra, volumenes: volumenes, subPres: subPres]

    }

    def tablaCopiarRubro() {
        println "params copiar rubro: $params"

        def obra = Obra.get(params.obra)

        def valores
        if (params.sub && params.sub != "null") {
            valores = preciosService.rbro_pcun_v3(obra.id, params.sub)
        } else {
            valores = preciosService.rbro_pcun_v2(obra.id)
        }

        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()

        def precios = [:]
        def prch = 0
        def prvl = 0
        def indirecto = obra.totales / 100

        preciosService.ac_rbroObra(obra.id)

        [precios: precios, subPres: subPres, subPre: params.sub, obra: obra, precioVol: prch, precioChof: prvl,
         indirectos: indirecto * 100, valores: valores]
    }


    def buscaRubro() {

        def listaTitulos = ["Código", "Descripción", "Unidad"]
        def listaCampos = ["codigo", "nombre", "unidad"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaRubro", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-rubro").modal("hide");'
        funcionJs += '$("#item_id").val($(this).attr("regId"));$("#item_codigo").val($(this).attr("prop_codigo"));$("#item_nombre").val($(this).attr("prop_nombre"))'
        funcionJs += '}'
        def numRegistros = 20
        def extras = " and tipoItem = 2 and codigo not like 'H%'"  // no lista los que inician con H
        if (!params.reporte) {
            def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras) /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
            lista.pop()
            render(view: '../tablaBuscadorColDer', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Item
            session.funciones = funciones
            def anchos = [20, 80] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Item", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Rubros", anchos: anchos, extras: extras, landscape: true])
        }
    }

    def eliminarSubpre () {
//        println("params eliminar sub " + params)
        def subpresupuesto = SubPresupuesto.get(params.sub)
        def obra = Obra.get(params.obra)
        def volumenes = VolumenesObra.findAllBySubPresupuestoAndObra(subpresupuesto, obra)
        def cronogramas = Cronograma.findAllByVolumenObraInList(volumenes)
        def errores = 0

        if(cronogramas){
            render "NO_No se puede borrar el subpresupuesto, uno o mas rubros ya se encuentran en el cronograma!"
        }else{
            volumenes.each {v->
                if(!v.delete(flush:true)){
                    errores += v.errors.getErrorCount()
                }
            }
//            println("errores " + errores)
            if(errores == 0){
                render "OK_Subpresupuesto borrado correctamente"
            }else{
                render "NO_Error al borrar el subpresupuesto"
            }
        }
    }

    def listaRubros(){
        println "listaItems" + params
        def datos;
//        def listaRbro = ['grpo__id', 'grpo__id', 'grpo__id']
        def listaRbro = ['itemnmbr', 'itemcdgo']
        def listaItems = ['itemnmbr', 'itemcdgo']

        def select = "select item__id, itemnmbr, itemcdgo, unddcdgo " +
                "from item, undd, dprt, sbgr "
        def txwh = "where tpit__id = 2 and undd.undd__id = item.undd__id and dprt.dprt__id = item.dprt__id and " +
                "sbgr.sbgr__id = dprt.sbgr__id "
        def sqlTx = ""
//        def item = listaRbro[params.buscarTipo.toInteger()-1]
        def bsca = listaItems[params.buscarPor.toInteger()-1]
        def ordn = listaRbro[params.ordenar.toInteger()-1]

        txwh += " and $bsca ilike '%${params.criterio}%'"
        sqlTx = "${select} ${txwh} order by ${ordn} limit 100 ".toString()
        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
        [data: datos]
    }
}
