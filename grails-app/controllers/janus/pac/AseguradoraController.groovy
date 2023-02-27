package janus.pac


import org.springframework.dao.DataIntegrityViolationException

class AseguradoraController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [aseguradoraInstanceList: Aseguradora.list(params), aseguradoraTotal: Aseguradora.count(), params: params]
    } //list

    def form_ajax() {
        def aseguradoraInstance = new Aseguradora(params)
        if (params.id) {
            aseguradoraInstance = Aseguradora.get(params.id)
            if (!aseguradoraInstance) {
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [aseguradoraInstance: aseguradoraInstance]
    } //form_ajax

    def save() {
//        println("params" + params)

        def fecha

        if(params.fechaContacto){
            fecha = new Date().parse("dd-MM-yyyy", params.fechaContacto)
        }

        def aseguradoraInstance
        if (params.id) {
            aseguradoraInstance = Aseguradora.get(params.id)
            if(params.fechaContacto){
                params.fechaContacto=new Date().parse("dd-MM-yyyy",params.fechaContacto)
            }
            if (!aseguradoraInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            aseguradoraInstance.properties = params
        }//es edit
        else {
            params.fechaContacto = fecha
            aseguradoraInstance = new Aseguradora(params)
        } //es create

        if (!aseguradoraInstance.save(flush: true)) {
            render "no_Error al guardar la aseguradora"
        }else{
            render "ok_Aseguradora guardada correctamente"
        }

    } //save

    def show_ajax() {
        def aseguradoraInstance = Aseguradora.get(params.id)
        if (!aseguradoraInstance) {
            redirect(action: "list")
            return
        }
        [aseguradoraInstance: aseguradoraInstance]
    } //show

    def delete() {
        def aseguradoraInstance = Aseguradora.get(params.id)
        if (!aseguradoraInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            aseguradoraInstance.delete(flush: true)
            render "ok_Aseguradora borrada correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar la aseguradora " + aseguradoraInstance.errors)
            render "no_Error al borrar la aseguradora"
        }
    } //delete
} //fin controller
