package janus

class UnidadController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [unidadInstanceList: Unidad.list(params), unidadInstanceTotal: Unidad.count(), params: params]
    } //list

    def form_ajax() {
        def unidadInstance = new Unidad(params)
        if (params.id) {
            unidadInstance = Unidad.get(params.id)
            if (!unidadInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Unidad con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [unidadInstance: unidadInstance]
    } //form_ajax

    def saveUnidad_ajax() {
        def unidad
        def texto = params.id ? 'actualizada' : 'creada'

        if(params.id){
            unidad = Unidad.get(params.id)
            if(!unidad){
                render "no_Error al guardar la unidad"
            }
        }else{
            unidad = new Unidad()
        }

        params.descripcion = params.descripcion.toUpperCase();
        unidad.properties = params

        if(!unidad.save(flush:true)){
            println("error al guardar la unidad " + unidad.errors)
            render "no_Error al guardar la unidad"
        }else{
            render "ok_Unidad ${texto} correctamente"
        }
    } //save

    def show_ajax() {
        def unidadInstance = Unidad.get(params.id)
        [unidadInstance: unidadInstance]
    } //show

    def delete_ajax() {
        def unidadInstance = Unidad.get(params.id)
        if(!unidadInstance){
            render "no_Error al borrar la unidad"
        }else{
            try {
                unidadInstance.delete(flush: true)
                render "ok_Unidad borrada correctamente"
            }catch(e){
                println("error al borrar la unidad " + unidadInstance.errors)
                render "no_Error al borrar la unidad"
            }
        }
    } //delete
} //fin controller
