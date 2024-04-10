package janus


import org.springframework.dao.DataIntegrityViolationException

class ComunidadController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [comunidadInstanceList: Comunidad.list(params), comunidadInstanceTotal: Comunidad.count(), params: params]
    } //list

    def form_ajax() {
        println("params " + params)
        def comunidadInstance = new Comunidad(params)
        if (params.id) {
            comunidadInstance = Comunidad.get(params.id)
            if (!comunidadInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Comunidad con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [comunidadInstance: comunidadInstance, padre: params.padre ?: comunidadInstance?.parroquia?.id]
    } //form_ajax

    def save() {
        def comunidadInstance
        if (params.id) {
            comunidadInstance = Comunidad.get(params.id)
            if (!comunidadInstance) {
                render "no_No se encontró la comunidad"
                return
            }//no existe el objeto

        }//es edit
        else
        {
            comunidadInstance = new Comunidad(params)
        } //es create

        params.nombre = params.nombre.toUpperCase();
        comunidadInstance.properties = params

        if (!comunidadInstance.save(flush: true)) {
            println("error al guardar la comunidad " + comunidadInstance.errors)
            render "no_Error al guardar la comunidad"
        }else{
            render "ok_Guardado correctamente"
        }
    } //save

    def show_ajax() {
        def comunidadInstance = Comunidad.get(params.id)
        if (!comunidadInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Comunidad con id " + params.id
            redirect(action: "list")
            return
        }
        [comunidadInstance: comunidadInstance]
    } //show

    def borrarComunidad_ajax() {
        def comunidadInstance = Comunidad.get(params.id)
        if (!comunidadInstance) {
            render "no_Error al borrar la comunidad"
            return
        }

        try {
            comunidadInstance.delete(flush: true)
            render "ok_Comunidad borrada correctamente"
        }
        catch (e) {
            println("Error al borrar la comunidad " + comunidadInstance?.errors)
            render "no_Error al borrar la comunidad"
        }
    } //delete
} //fin controller
