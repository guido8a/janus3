package janus.pac


import org.springframework.dao.DataIntegrityViolationException

class AnioController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [anioInstanceList: Anio.list(params).sort{it.anio}, params: params]
    } //list

    def form_ajax() {
        def anioInstance = new Anio(params)
        if (params.id) {
            anioInstance = Anio.get(params.id)
            if (!anioInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Anio con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [anioInstance: anioInstance]
    } //form_ajax

    def save() {
        def anioInstance
        if (params.id) {
            anioInstance = Anio.get(params.id)
            if (!anioInstance) {
                render "no_No se encontró el año"
                return
            }//no existe el objeto
            anioInstance.properties = params
        }//es edit
        else {

            def existe = Anio.findAllByAnio(params.anio)

            if(!existe){
                anioInstance = new Anio(params)
            }else{
                render "no_El año ingresado ya existe"
                return
            }

        } //es create
        if (!anioInstance.save(flush: true)) {
            println("Error al guardar el año" + anioInstance.errors)
            render "no_Error al guardar el año"
        }else{
            render "ok_Año guardado correctamente"
        }
    } //save

    def show_ajax() {
        def anioInstance = Anio.get(params.id)
        if (!anioInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Anio con id " + params.id
            redirect(action: "list")
            return
        }
        [anioInstance: anioInstance]
    } //show

    def delete() {
        def anioInstance = Anio.get(params.id)
        if (!anioInstance) {
            render "no_No se encontró el año"
            return
        }

        try {
            anioInstance.delete(flush: true)
            render "ok_Año borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar el año "  + anioInstance.errors)
            render "no_Error al borrar el año"
        }
    } //delete
} //fin controller
