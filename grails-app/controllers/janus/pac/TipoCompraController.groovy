package janus.pac

import org.springframework.dao.DataIntegrityViolationException

class TipoCompraController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [tipoCompraInstanceList: TipoCompra.list([sort: 'descripcion']), params: params]
    } //list

    def form_ajax() {
        def tipoCompraInstance = new TipoCompra(params)
        if (params.id) {
            tipoCompraInstance = TipoCompra.get(params.id)
            if (!tipoCompraInstance) {
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoCompraInstance: tipoCompraInstance]
    } //form_ajax

    def save() {
        def tipoCompraInstance
        if (params.id) {
            tipoCompraInstance = TipoCompra.get(params.id)
            if (!tipoCompraInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            tipoCompraInstance.properties = params
        }//es edit
        else {
            tipoCompraInstance = new TipoCompra(params)
        } //es create

        if (!tipoCompraInstance.save(flush: true)) {
            render "no_Error al guardar el tipo"
        }else{
            render "ok_Tipo guardado correctamente"
        }
    } //save


    def delete() {
        def tipoCompraInstance = TipoCompra.get(params.id)
        if (!tipoCompraInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            tipoCompraInstance.delete(flush: true)
            render "ok_Tipo borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar el tipo " + tipoCompraInstance.errors)
            render "no_Error al el tipo"
        }
    } //delete
} //fin controller
