package janus.pac


import org.springframework.dao.DataIntegrityViolationException

class TipoAseguradoraController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [tipoAseguradoraInstanceList: TipoAseguradora.list(params), params: params]
    } //list

    def form_ajax() {
        def tipoAseguradoraInstance = new TipoAseguradora(params)
        if (params.id) {
            tipoAseguradoraInstance = TipoAseguradora.get(params.id)
            if (!tipoAseguradoraInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Tipo Aseguradora con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoAseguradoraInstance: tipoAseguradoraInstance]
    } //form_ajax

    def save() {

        params.codigo = params.codigo.toUpperCase();

        def existe = TipoAseguradora.findByCodigo(params.codigo)

        def tipoAseguradoraInstance
        if (params.id) {
            tipoAseguradoraInstance = TipoAseguradora.get(params.id)
            if (!tipoAseguradoraInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            tipoAseguradoraInstance.properties = params
        }//es edit
        else {
            if(!existe){
                tipoAseguradoraInstance = new TipoAseguradora(params)
            }else{
                render "no_El código ingresado ya existe"
                return
            }

        } //es create
        if (!tipoAseguradoraInstance.save(flush: true)) {
            println("error al guardar el tipo de aseguradora" + tipoAseguradoraInstance.errors)
            render "no_Error al guardar el tipo de aseguradora"
        }else{
            render "ok_Tipo de aseguradora guardada correctamente"
        }
    } //save

    def delete() {
        def tipoAseguradoraInstance = TipoAseguradora.get(params.id)
        if (!tipoAseguradoraInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            tipoAseguradoraInstance.delete(flush: true)
            render "ok_Tipo de aseguradora borrada correctamente"
        }
        catch (DataIntegrityViolationException e) {
            render "no_Error al borrar el tipo de aseguradora"
        }
    } //delete
} //fin controller
