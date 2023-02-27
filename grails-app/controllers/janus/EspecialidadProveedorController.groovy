package janus


import org.springframework.dao.DataIntegrityViolationException

class EspecialidadProveedorController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
//        params.max = Math.min(params.max ? params.int('max') : 10, 100)
//        [especialidadProveedorInstanceList: EspecialidadProveedor.list(params), especialidadProveedorInstanceTotal: EspecialidadProveedor.count(), params: params]
        [especialidadProveedorInstanceList: EspecialidadProveedor.list([sort: 'descripcion']),  params: params]
    } //list

    def form_ajax() {
        def especialidadProveedorInstance = new EspecialidadProveedor(params)
        if (params.id) {
            especialidadProveedorInstance = EspecialidadProveedor.get(params.id)
            if (!especialidadProveedorInstance) {
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [especialidadProveedorInstance: especialidadProveedorInstance]
    } //form_ajax

    def save() {

        def existe = EspecialidadProveedor.findByDescripcion(params.descripcion)

        def especialidadProveedorInstance
        if (params.id) {
            especialidadProveedorInstance = EspecialidadProveedor.get(params.id)
            if (!especialidadProveedorInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            especialidadProveedorInstance.properties = params
        }//es edit
        else {
            if(existe){
                render "no_Ya existe un registro con este nombre"
                return
            }else{
                especialidadProveedorInstance = new EspecialidadProveedor(params)
            }

        } //es create
        if (!especialidadProveedorInstance.save(flush: true)) {
            render "no_Error al guardar la especialidad"
        }else{
            render "ok_Especialidad guardada correctamente"
        }
    } //save

    def delete() {
        def especialidadProveedorInstance = EspecialidadProveedor.get(params.id)
        if (!especialidadProveedorInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            especialidadProveedorInstance.delete(flush: true)
            render "ok_Especialidad borrada correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar la especialidad " + fuenteFinanciamientoInstance.errors)
            render "no_Especialidad al la fuente"
        }
    } //delete
} //fin controller
