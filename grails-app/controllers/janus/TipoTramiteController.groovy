package janus

import groovy.json.JsonBuilder

class TipoTramiteController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [tipoTramiteInstanceList: TipoTramite.list(params), tipoTramiteInstanceTotal: TipoTramite.count(),  params: params]
    } //list

    def addDep() {
        def dep = new DepartamentoTramite([
                tipoTramite: TipoTramite.get(params.tipo.toLong()),
                rolTramite: RolTramite.get(params.rol.toLong()),
                departamento: Departamento.get(params.dep.toLong())
        ])

        if (dep.save(flush: true)) {
            render "OK_" + dep.id
        } else {
            println "Error al guardar tipo tramite - rol - departamento: " + dep.errors
            render "NO"
        }
    }

    def delDep() {
        def dep = DepartamentoTramite.get(params.id.toLong())
        def ok = "OK"
        try {
            dep.delete(flush: true)
        } catch (e) {
            println e
            ok = "NO"
        }
        render ok
    }

    def departamentos_ajax() {
        def tipoTramite = TipoTramite.get(params.tramite.toLong())

        def dps = []
        DepartamentoTramite.findAllByTipoTramite(tipoTramite).each { dep ->
            dps.add([
                    id: dep.id,
                    departamento: dep.departamento.descripcion,
                    departamento_id: dep.departamentoId,
                    rol: dep.rolTramite.descripcion,
                    rol_id: dep.rolTramiteId
            ])
        }
        def json = new JsonBuilder(dps)

        return [tipoTramite: tipoTramite, departamentos: json]
    }

    def checkCd_ajax() {
        if (params.id) {
            def tipoTramite = TipoTramite.get(params.id)

            if (params.codigo == tipoTramite.codigo.toString()) {
                render true
            } else {
                def tiposTramite = TipoTramite.findAllByCodigoIlike(params.codigo)
                if (tiposTramite.size() == 0) {
                    render true
                } else {
                    render false
                }
            }
        } else {
            def tiposTramite = TipoTramite.findAllByCodigoIlike(params.codigo)
            if (tiposTramite.size() == 0) {
                render true
            } else {
                render false
            }
        }
    }

    def form_ajax() {
        def tipoTramiteInstance = new TipoTramite(params)
        if (params.id) {
            tipoTramiteInstance = TipoTramite.get(params.id)
            if (!tipoTramiteInstance) {
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoTramiteInstance: tipoTramiteInstance]
    } //form_ajax

    def saveTipoTramite_ajax() {
        def tipoTramiteInstance
        def texto = params.id ? 'actualizado' : 'creado'

        if(params.id){
            tipoTramiteInstance = TipoTramite.get(params.id)
            if(!tipoTramiteInstance){
                render "no_Error al guardar el tipo de trámite"
            }
        }else{
            tipoTramiteInstance = new TipoTramite()
        }

        params.codigo = params.codigo.toUpperCase()
        tipoTramiteInstance.properties = params

        if(!tipoTramiteInstance.save(flush:true)){
            println("error al guardar  el tipo de trámite " + tipoTramiteInstance.errors)
            render "no_Error al guardar el tipo de trámite"
        }else{
            render "ok_Tipo de trámite ${texto} correctamente"
        }

    } //save

    def show_ajax() {
        def tipoTramiteInstance = TipoTramite.get(params.id)
        [tipoTramiteInstance: tipoTramiteInstance]
    } //show

    def delete() {
        def tipoTramiteInstance = TipoTramite.get(params.id)

        if (!tipoTramiteInstance) {
            render "no_Error al borrar el tipo de trámite"
        }

        def hijos = TipoTramite.countByPadre(tipoTramiteInstance)
        def departamentos = DepartamentoTramite.countByTipoTramite(tipoTramiteInstance)
        def tramites = Tramite.countByTipoTramite(tipoTramiteInstance)

        if (departamentos > 0 || hijos > 0 || tramites > 0) {
            flash.message = "El tipo de trámite tiene "
            def str = ""
            if (departamentos > 0) {
                str += departamentos + " departamento${departamentos == 1 ? '' : 's'}"
            }
            if (hijos > 0) {
                if (str != "") {
                    str += ","
                }
                str += hijos + " hijo${hijos == 1 ? '' : 's'}"
            }
            if (tramites > 0) {
                if (str != "") {
                    str += ","
                }
                str += tramites + " trámite${tramites == 1 ? '' : 's'}"
            }
            render "no_Error al borrar el tipo de trámite: ${str}"
        }

        try {
            tipoTramiteInstance.delete(flush: true)
            render "ok_Tipo de trámite borrado correctamente"
        }
        catch (e) {
            println("error al borrar el tipo de trámite" + tipoTramiteInstance.errors)
            render "no_Error al borrar el tipo de trámite"
        }
    } //delete
} //fin controller
