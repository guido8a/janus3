package janus

class DireccionController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [direccionInstanceList: Direccion.list(params), direccionInstanceTotal: Unidad.count(), params: params]
    } //list

    def form_ajax() {
        def direccionInstance = new Direccion(params)
        if(params.id) {
            direccionInstance = Direccion.get(params.id)
            if(!direccionInstance) {
                flash.clase = "alert-error"
                flash.message =  "No se encontró Direccion con id " + params.id
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [direccionInstance: direccionInstance]
    } //form_ajax

    def saveDireccion_ajax() {
        def direccion
        def texto = params.id ? 'actualizada' : 'creada'

        if(params.id){
            direccion = Direccion.get(params.id)
            if(!direccion){
                render "no_Error al guardar la dirección"
            }
        }else{
            direccion = new Direccion()
        }

        params.nombre = params.nombre.toUpperCase();
        params.jefatura = params.jefatura.toUpperCase();
        direccion.properties = params

        if(!direccion.save(flush:true)){
            println("error al guardar la dirección " + direccion.errors)
            render "no_Error al guardar la dirección"
        }else{
            render "ok_Dirección ${texto} correctamente"
        }
    } //save

    def show_ajax() {
        def direccionInstance = Direccion.get(params.id)
        [direccionInstance: direccionInstance]
    } //show

    def delete_ajax() {
        def direccionInstance = Direccion.get(params.id)
        if(!direccionInstance){
            render "no_Error al borrar la dirección"
        }else{
            try {
                direccionInstance.delete(flush: true)
                render "ok_Dirección borrada correctamente"
            }catch(e){
                println("error al borrar la dirección " + direccionInstance.errors)
                render "no_Error al borrar la dirección"
            }
        }

    } //delete
} //fin controller
