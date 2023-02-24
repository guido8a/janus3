package janus.pac


import org.springframework.dao.DataIntegrityViolationException

class TipoDocumentoGarantiaController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [tipoDocumentoGarantiaInstanceList: TipoDocumentoGarantia.list(params), params: params]
    } //list

    def form_ajax() {
        def tipoDocumentoGarantiaInstance = new TipoDocumentoGarantia(params)
        if (params.id) {
            tipoDocumentoGarantiaInstance = TipoDocumentoGarantia.get(params.id)
            if (!tipoDocumentoGarantiaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Tipo Documento Garantia con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoDocumentoGarantiaInstance: tipoDocumentoGarantiaInstance]
    } //form_ajax

    def save() {

        params.codigo = params.codigo.toUpperCase();

        def existe = TipoDocumentoGarantia.findByCodigo(params.codigo)
        def tipoDocumentoGarantiaInstance
        if (params.id) {
            tipoDocumentoGarantiaInstance = TipoDocumentoGarantia.get(params.id)
            if (!tipoDocumentoGarantiaInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            tipoDocumentoGarantiaInstance.properties = params
        }//es edit
        else {
            if(!existe){
                tipoDocumentoGarantiaInstance = new TipoDocumentoGarantia(params)
            }else{
               render "no_El código ingresado ya existe"
                return
            }

        } //es create
        if (!tipoDocumentoGarantiaInstance.save(flush: true)) {

        }else{
            render "ok_Tipo de Documento guardado correctamente"
        }
    } //save

    def delete() {
        def tipoDocumentoGarantiaInstance = TipoDocumentoGarantia.get(params.id)
        if (!tipoDocumentoGarantiaInstance) {
           render "no_No se encontró el registro"
            return
        }

        try {
            tipoDocumentoGarantiaInstance.delete(flush: true)
        render "ok_Tipo de documento guardado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("Error al borrar el tipo de documento" + tipoDocumentoGarantiaInstance.errors)
         render "no_Error al borrar el tipo de documento"
        }
    } //delete
} //fin controller
