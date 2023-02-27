package janus


import org.springframework.dao.DataIntegrityViolationException

class FuenteFinanciamientoController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [fuenteFinanciamientoInstanceList: FuenteFinanciamiento.list([sort: 'descripcion']), params: params]
    } //list

    def form_ajax() {
        def fuenteFinanciamientoInstance = new FuenteFinanciamiento(params)
        if (params.id) {
            fuenteFinanciamientoInstance = FuenteFinanciamiento.get(params.id)
            if (!fuenteFinanciamientoInstance) {
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [fuenteFinanciamientoInstance: fuenteFinanciamientoInstance]
    } //form_ajax

    def save() {

        params.descripcion = params.descripcion.toUpperCase();

        def existe = FuenteFinanciamiento.findByDescripcion(params.descripcion)

        def fuenteFinanciamientoInstance
        if (params.id) {
            fuenteFinanciamientoInstance = FuenteFinanciamiento.get(params.id)
            if (!fuenteFinanciamientoInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            fuenteFinanciamientoInstance.properties = params
        }//es edit
        else {
            if(existe){
                render "no_Ya existe una fuente de financiamiento con ese nombre"
                return
            }else{
                fuenteFinanciamientoInstance = new FuenteFinanciamiento(params)
            }

        } //es create
        if (!fuenteFinanciamientoInstance.save(flush: true)) {
            render "no_Error al guardar la fuente"
        }else{
            render "ok_Fuente guardada correctamente"
        }
    } //save

    def delete() {
        def fuenteFinanciamientoInstance = FuenteFinanciamiento.get(params.id)
        if (!fuenteFinanciamientoInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            fuenteFinanciamientoInstance.delete(flush: true)
            render "ok_Fuente borrada correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar la fuente " + fuenteFinanciamientoInstance.errors)
            render "no_Error al la fuente"
        }
    } //delete
} //fin controller
