package janus.pac


import org.springframework.dao.DataIntegrityViolationException

class TipoProcedimientoController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [tipoProcedimientoInstanceList: TipoProcedimiento.list([sort: 'descripcion']), params: params]
    } //list

    def form_ajax() {
        def tipoProcedimientoInstance = new TipoProcedimiento(params)
        if(params.id) {
            tipoProcedimientoInstance = TipoProcedimiento.get(params.id)
            if(!tipoProcedimientoInstance) {
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoProcedimientoInstance: tipoProcedimientoInstance]
    } //form_ajax

    def save() {

        params.sigla = params.sigla.toUpperCase();

        def tipoProcedimientoInstance
        if(params.id) {
            tipoProcedimientoInstance = TipoProcedimiento.get(params.id)
            if(!tipoProcedimientoInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            tipoProcedimientoInstance.properties = params
        }//es edit
        else {
            def existe= TipoProcedimiento.findBySigla(params.sigla)
            if(!existe)
                tipoProcedimientoInstance = new TipoProcedimiento(params)
            else{
             render "no_Código ya existente"
                return
            }
        } //es create
        if (!tipoProcedimientoInstance.save(flush: true)) {
            println("error al guardar el tipo " + tipoProcedimientoInstance.errors)
            render "no_Error al guardar el tipo"
        }else{
            render "ok_Tipo guardado correctamente"
        }
    } //save

    def show_ajax() {
        def tipoProcedimientoInstance = TipoProcedimiento.get(params.id)
        if (!tipoProcedimientoInstance) {
            redirect(action: "list")
            return
        }
        [tipoProcedimientoInstance: tipoProcedimientoInstance]
    } //show

    def delete() {
        def tipoProcedimientoInstance = TipoProcedimiento.get(params.id)
        if (!tipoProcedimientoInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            tipoProcedimientoInstance.delete(flush: true)
            render "ok_Tipo borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar el tipo " + tipoProcedimientoInstance.errors)
            render "no_Error al borrar el tipo"
        }
    } //delete
} //fin controller
