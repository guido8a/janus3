package janus

import seguridad.Persona

class VolumenObraOfController {
    def buscadorService
    def preciosService
    def volObra(){

        def obra = Obra.get(params.id)
//        def volumenes = VolumenesObra.findAllByObra(obra)
        def volumenes = VolumenObraOferente.findAllByObra(obra)
        println "vlof: ${volumenes.size()}"

        def campos = ["codigo": ["Código", "string"], "nombre": ["Descripción", "string"]]

        [obra:obra,volumenes:volumenes,campos:campos]
    }

    def buscarRubroCodigo(){
        def rubro = Item.findByCodigoAndTipoItem(params.codigo?.trim(),TipoItem.get(2))
        if (rubro){
            if (rubro.persona.id.toInteger()==session.usuario.id.toInteger())
                render ""+rubro.id+"&&"+rubro.tipoLista?.id+"&&"+rubro.nombre+"&&"+rubro.unidad?.codigo
            else
                render "-1"
            return
        } else{
            render "-1"
            return
        }
    }





    def addItem(){
//        println "addItem "+params
        def obra= Obra.get(params.obra)
        def rubro = Item.get(params.rubro)
        def volumen
        if (params.id)
            volumen=VolumenesObra.get(params.id)
        else{
            volumen=VolumenesObra.findByObraAndItem(obra,rubro)
            if(!volumen)
                volumen=new VolumenesObra()
        }
        volumen.cantidad=params.cantidad.toDouble()
        volumen.orden=params.orden.toInteger()
        volumen.subPresupuesto=SubPresupuesto.get(params.sub)
        volumen.obra=obra
        volumen.item=rubro
        if (!volumen.save(flush: true)){
            println "error volumen obra "+volumen.errors
            render "error"
        }else{
            preciosService.actualizaOrden(volumen,"insert")
            redirect(action: "tabla",params: [obra:obra.id,sub:volumen.subPresupuesto.id])
        }
    }

    def tabla() {

        def usuario = session.usuario.id
        def persona = Persona.get(usuario)

        params.ord  = params.ord?:'1'

        def obra = Obra.get(params.obra)
        def valores
        def orden

        if (params.ord == '1') {
            orden = 'asc'
        } else {
            orden = 'desc'
        }

        preciosService.ac_rbroObraOf(obra.id)
        if (params.sub && params.sub != "-1") {
            valores = preciosService.rbro_pcun_v5_of(obra.id, params.sub, orden)
        } else {
            valores = preciosService.rbro_pcun_v4_of(obra.id, orden)
        }

        def subPres = VolumenObraOferente.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
        def estado = obra.estado
        def prch = 0
        def prvl = 0
        def indirecto = obra.totales / 100

        [subPres: subPres, subPre: params.sub, obra: obra, precioVol: prch, precioChof: prvl, indirectos: indirecto * 100,
         valores: valores, estado: estado, msg: params.msg, persona: persona]
    }

    def eliminarRubro(){
        def vol = VolumenesObra.get(params.id)
        def obra = vol.obra
        def orden = vol.orden
        preciosService.actualizaOrden(vol,"delete")
        vol.delete()
        redirect(action: "tabla",params: [obra:obra.id])

    }

    def buscaRubro() {

        def listaTitulos = ["Código", "Descripción","Unidad"]
        def listaCampos = ["codigo", "nombre","unidad"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaRubro", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-rubro").modal("hide");'
        funcionJs += '$("#item_id").val($(this).attr("regId"));$("#item_codigo").val($(this).attr("prop_codigo"));$("#item_nombre").val($(this).attr("prop_nombre"))'
        funcionJs += '}'
        def numRegistros = 20
        def extras = " and tipoItem = 2 and persona = ${session.usuario.id}"
        if (!params.reporte) {
            def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras) /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
            lista.pop()
            render(view: '../tablaBuscadorColDer', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
        } else {
            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Item
            session.funciones = funciones
            def anchos = [20, 80] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Item", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Rubros", anchos: anchos, extras: extras, landscape: true])
        }
    }
}
