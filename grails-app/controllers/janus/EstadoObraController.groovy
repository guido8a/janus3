package janus


import org.springframework.dao.DataIntegrityViolationException

class EstadoObraController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [estadoObraInstanceList: EstadoObra.list(params), estadoObraInstanceTotal: EstadoObra.count(), params: params]
    } //list

    def form_ajax() {
        def estadoObraInstance = new EstadoObra(params)
        if (params.id) {
            estadoObraInstance = EstadoObra.get(params.id)
            if (!estadoObraInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró EstadoObra con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [estadoObraInstance: estadoObraInstance]
    } //form_ajax

    def save() {
        def estadoObraInstance

        params.codigo = params.codigo.toUpperCase();
        params.descripcion = params.descripcion.toUpperCase();

        def existe = EstadoObra.findByCodigo(params.codigo)

        if (params.id) {
            estadoObraInstance = EstadoObra.get(params.id)
            if (!estadoObraInstance) {
                render "no_Error al guardar el estado de obra"
            }//no existe el objeto
            estadoObraInstance.properties = params
        }else {
            if(!existe){
                estadoObraInstance = new EstadoObra(params)
            }else{
               render "no_El código ya existe"
            }
        } //es create

        if (!estadoObraInstance.save(flush: true)) {
            println("error al guardar el estado de obra " + estadoObraInstance.errors)
            render "no_Error al guardar el estado de obra"
        }else{
            render "ok_Estado de obra guardado correctamente"
        }
    } //save

    def show_ajax() {
        def estadoObraInstance = EstadoObra.get(params.id)
        if (!estadoObraInstance) {
            redirect(action: "list")
            return
        }
        [estadoObraInstance: estadoObraInstance]
    } //show

    def delete() {
        def estadoObraInstance = EstadoObra.get(params.id)
        if (!estadoObraInstance) {
            render "no_Error al borrar el estado de obra"
        }

        try {
            estadoObraInstance.delete(flush: true)
            render "ok_Estado de obra borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar el estado de obra  " + estadoObraInstance.errors)
            render "no_Error al borrar el estado de obra"
        }
    } //delete
} //fin controller
