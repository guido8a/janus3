package janus.ejecucion


import org.springframework.dao.DataIntegrityViolationException

class TipoMultaController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [tipoMultaInstanceList: TipoMulta.list([sort: 'descripcion']), params: params]

    } //list

    def form_ajax() {
        def tipoMultaInstance = new TipoMulta(params)
        if(params.id) {
            tipoMultaInstance = TipoMulta.get(params.id)
            if(!tipoMultaInstance) {
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoMultaInstance: tipoMultaInstance]
    } //form_ajax

    def save() {
        def tipoMultaInstance
        if(params.id) {
            tipoMultaInstance = TipoMulta.get(params.id)
            if(!tipoMultaInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            tipoMultaInstance.properties = params
        }//es edit
        else {
            tipoMultaInstance = new TipoMulta(params)
        } //es create
        if (!tipoMultaInstance.save(flush: true)) {
            render "no_Error al guardar el tipo"
        }else{
            render "ok_Tipo guardado correctamente"
        }
    } //save

    def delete() {
        def tipoMultaInstance = TipoMulta.get(params.id)
        if (!tipoMultaInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            tipoMultaInstance.delete(flush: true)
            render "ok_Tipo borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            render "no_Error al borrar el tipo"
        }
    } //delete
} //fin controller
