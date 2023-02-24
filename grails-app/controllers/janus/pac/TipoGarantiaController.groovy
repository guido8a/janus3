package janus.pac


import org.springframework.dao.DataIntegrityViolationException

class TipoGarantiaController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [tipoGarantiaInstanceList: TipoGarantia.list(params), params: params]
    } //list

    def form_ajax() {
        def tipoGarantiaInstance = new TipoGarantia(params)
        if (params.id) {
            tipoGarantiaInstance = TipoGarantia.get(params.id)
            if (!tipoGarantiaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Tipo Garantia con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoGarantiaInstance: tipoGarantiaInstance]
    } //form_ajax

    def save() {

        params.codigo = params.codigo.toUpperCase();

        def existe = TipoGarantia.findByCodigo(params.codigo)

        def tipoGarantiaInstance
        if (params.id) {
            tipoGarantiaInstance = TipoGarantia.get(params.id)
            if (!tipoGarantiaInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto

            tipoGarantiaInstance.properties = params
        }//es edit
        else {
            if(!existe){
                tipoGarantiaInstance = new TipoGarantia(params)
            }else{
                render "no_El código ingresado ya existe"
                return
            }

        } //es create
        if (!tipoGarantiaInstance.save(flush: true)) {
            println("error al guardar el tipo de garantía" + tipoGarantiaInstance.errors)
            render "no_Error al guardar el tipo de garantía"
        }else{
            render "ok_Tipo de garantía guardada correctamente"
        }
    } //save

    def delete() {
        def tipoGarantiaInstance = TipoGarantia.get(params.id)
        if (!tipoGarantiaInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            tipoGarantiaInstance.delete(flush: true)
            render "ok_Tipo de garantía borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            render "no_Error al borrar el tipo de garantía"
        }
    } //delete
} //fin controller
