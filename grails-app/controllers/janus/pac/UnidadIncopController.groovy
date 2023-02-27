package janus.pac

import org.springframework.dao.DataIntegrityViolationException

class UnidadIncopController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [unidadIncopInstanceList: UnidadIncop.list(params), params: params]
    } //list

    def form_ajax() {
        def unidadIncopInstance = new UnidadIncop(params)
        if(params.id) {
            unidadIncopInstance = UnidadIncop.get(params.id)
            if(!unidadIncopInstance) {
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [unidadIncopInstance: unidadIncopInstance]
    } //form_ajax

    def save() {

        params.codigo = params.codigo.toUpperCase();

        def unidadIncopInstance
        if(params.id) {
            unidadIncopInstance = UnidadIncop.get(params.id)
            if(!unidadIncopInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            unidadIncopInstance.properties = params
        }//es edit
        else {
            def existe= UnidadIncop.findByCodigo(params.codigo)
            if(!existe)
                unidadIncopInstance = new UnidadIncop(params)
            else{
                render "no_Código ya existente"
                return
            }
        } //es create
        if (!unidadIncopInstance.save(flush: true)) {
            println("error al guardar la unidad " + unidadIncopInstance.errors)
            render "no_Error al guardar la unidad"
        }else{
            render "ok_Unidad guardada correctamente"

        }

    } //save

    def show_ajax() {
        def unidadIncopInstance = UnidadIncop.get(params.id)
        if (!unidadIncopInstance) {
            redirect(action: "list")
            return
        }
        [unidadIncopInstance: unidadIncopInstance]
    } //show

    def delete() {
        def unidadIncopInstance = UnidadIncop.get(params.id)
        if (!unidadIncopInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            unidadIncopInstance.delete(flush: true)
            render "ok_Unidad borrada correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar la unidad " + unidadIncopInstance.errors)
            render "no_Error al borrar la unidad"
        }
    } //delete
} //fin controller
