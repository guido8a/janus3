package janus.pac


import org.springframework.dao.DataIntegrityViolationException

class EstadoGarantiaController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [estadoGarantiaInstanceList: EstadoGarantia.list(params), params: params]
    } //list

    def form_ajax() {
        def estadoGarantiaInstance = new EstadoGarantia(params)
        if (params.id) {
            estadoGarantiaInstance = EstadoGarantia.get(params.id)
            if (!estadoGarantiaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Estado Garantia con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [estadoGarantiaInstance: estadoGarantiaInstance]
    } //form_ajax

    def save() {

        def existe = EstadoGarantia.findByCodigo(params.codigo)

        def estadoGarantiaInstance
        if (params.id) {
            estadoGarantiaInstance = EstadoGarantia.get(params.id)
            if (!estadoGarantiaInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            estadoGarantiaInstance.properties = params
        }//es edit
        else {
            if(!existe){
                estadoGarantiaInstance = new EstadoGarantia(params)
            }else{
                render "no_El código ingresado ya existe"
                return
            }

        } //es create
        if (!estadoGarantiaInstance.save(flush: true)) {
            println("error al guardar el estado de garantía" + estadoGarantiaInstance.errors)
            render "no_Error al guardar el estado de garantía"
        }else{
            render "ok_Estado de garantía guardada correctamente"
        }

    } //save


    def delete() {
        def estadoGarantiaInstance = EstadoGarantia.get(params.id)
        if (!estadoGarantiaInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            estadoGarantiaInstance.delete(flush: true)
            render "ok_Estado de garantía borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            render "no_Error al borrar el estado de garantía"
        }
    } //delete
} //fin controller
