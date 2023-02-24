package janus.pac

import org.springframework.dao.DataIntegrityViolationException

class TipoContratoController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [tipoContratoInstanceList: TipoContrato.list(params), params: params]
    } //list

    def form_ajax() {
        def tipoContratoInstance = new TipoContrato(params)
        if (params.id) {
            tipoContratoInstance = TipoContrato.get(params.id)
            if (!tipoContratoInstance) {
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoContratoInstance: tipoContratoInstance]
    } //form_ajax

    def save() {

        params.codigo = params.codigo.toUpperCase();

        def existe = TipoContrato.findByCodigo(params.codigo)

        def tipoContratoInstance
        if (params.id) {
            tipoContratoInstance = TipoContrato.get(params.id)
            if (!tipoContratoInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            tipoContratoInstance.properties = params
        }//es edit
        else {
            if(!existe){
                tipoContratoInstance = new TipoContrato(params)
            }else{
                render "no_El código ingresado ya existe"
                return
            }
        } //es create
        if (!tipoContratoInstance.save(flush: true)) {
            println("error al guardar el tipo de contrato" + tipoContratoInstance.errors)
            render "no_Error al guardar el tipo de contrato"
        }else{
            render "ok_Tipo de contrato guardado correctamente"
        }

    } //save


    def delete() {
        def tipoContratoInstance = TipoContrato.get(params.id)
        if (!tipoContratoInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            tipoContratoInstance.delete(flush: true)
            render "ok_Tipo de contrato borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("Error al borrar el tipo de contrato" + tipoContratoInstance.errors)
            render "no_Error al borrar el tipo de contrato"
        }
    } //delete
} //fin controller
