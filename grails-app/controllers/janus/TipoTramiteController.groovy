package janus

class TipoTramiteController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [tipoTramiteInstanceList: TipoTramite.list(params), tipoTramiteInstanceTotal: TipoTramite.count(),  params: params]
    } //list

    def departamentos_ajax() {
        def tipoTramite = TipoTramite.get(params.tramite.toLong())
        return [tipoTramite: tipoTramite]
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

    def tablaTipoTramite_ajax () {
        def tipoTramite = TipoTramite.get(params.id)
        def departamentos = DepartamentoTramite.findAllByTipoTramite(tipoTramite)
        return [departamentos: departamentos, tipoTramite: tipoTramite]
    }

    def guardarDepartamentoTramite_ajax (){
        def tipoTramite = TipoTramite.get(params.tipoTramite)
        def rolTramite = RolTramite.get(params.rolTramite)
        def departamento = Departamento.get(params.departamento)

        def existente = DepartamentoTramite.findByTipoTramiteAndDepartamentoAndRolTramite(tipoTramite, departamento, rolTramite)

        if(existente){
            render "no_Ya existe un registro asignado con ese rol y coordinación"
        }else{
            def departamentoTramite = new DepartamentoTramite()
            departamentoTramite.properties = params

            if(!departamentoTramite.save(flush: true)){
                println("error al guardar el departamento tramite " + departamentoTramite.errors)
                render "no_Error al guardar el registro"
            }else{
                render "ok_Guardado correctamente"
            }
        }
    }

    def borrarDepartamentoTramite_ajax (){
        def departamentoTramite = DepartamentoTramite.get(params.id)

        try{
            departamentoTramite.delete(flush:true)
            render "ok_Registro borrado correctamente"
        }catch(e){
            render "no_Error al borrar el registro"
        }
    }


} //fin controller
