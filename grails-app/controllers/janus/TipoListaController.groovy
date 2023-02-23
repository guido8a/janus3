package janus


import org.springframework.dao.DataIntegrityViolationException

class TipoListaController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [tipoListaInstanceList: TipoLista.list(params).sort{it.codigo}, params: params]
    } //list

    def form_ajax() {
        def tipoListaInstance = new TipoLista(params)
        if(params.id) {
            tipoListaInstance = TipoLista.get(params.id)
            if(!tipoListaInstance) {
                flash.clase = "alert-error"
                flash.message =  "No se encontró Tipo Lista con id " + params.id
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoListaInstance: tipoListaInstance]
    } //form_ajax

    def save() {
        def tipoListaInstance

        params.codigo = params.codigo.toUpperCase();

        if(params.id) {
            tipoListaInstance = TipoLista.get(params.id)
            if(!tipoListaInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            tipoListaInstance.properties = params
        }//es edit
        else {
            tipoListaInstance = new TipoLista(params)
        } //es create
        if (!tipoListaInstance.save(flush: true)) {
            println("Error al guardar el tipo" + tipoListaInstance.errors)
            render "no_Error al guardar el tipo"
        }else{
            render "ok_Tipo guardado correctamente"
        }

    } //save

    def show_ajax() {
        def tipoListaInstance = TipoLista.get(params.id)
        if (!tipoListaInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Tipo Lista con id " + params.id
            redirect(action: "list")
            return
        }
        [tipoListaInstance: tipoListaInstance]
    } //show

    def delete() {
        def tipoListaInstance = TipoLista.get(params.id)
        if (!tipoListaInstance) {
        render "no_No se encontró el registro"
            return
        }

        try {
            tipoListaInstance.delete(flush: true)
            render "ok_Tipo borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("Error al borrar el tipo " + tipoListaInstance.errors)
            render "no_Error al borrar el tipo"
        }
    } //delete
} //fin controller
