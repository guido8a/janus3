package janus

import org.springframework.dao.DataIntegrityViolationException

class ProvinciaController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def form_ajax() {
        def provinciaInstance = new Provincia(params)
        if(params.id) {
            provinciaInstance = Provincia.get(params.id)
        } //es edit
        return [provinciaInstance: provinciaInstance]
    } //form_ajax

    def save() {

        def provinciaInstance

        params.nombre = params.nombre.toUpperCase()

        if(params.id) {
            provinciaInstance = Provincia.get(params.id)
            if(!provinciaInstance) {
                render "no_No se encontró la provincia"
                return
            }//no existe el objeto

            if(provinciaInstance?.numero?.toInteger() == params.numero.toInteger()){
                provinciaInstance.properties = params
            }else{
                if(Provincia.findAllByNumero(params.numero)){
                    render "no_Ya existe una provincia registrada con este número!"
                    return
                }else{
                    provinciaInstance.properties = params
                }
            }
        }//es edit
        else {
            if(Provincia.findAllByNumero(params.numero)){
                render "no_Ya existe una provincia registrada con este número!"
                return
            }else{
                provinciaInstance = new Provincia(params)
            }
        } //es create
        if (!provinciaInstance.save(flush: true)) {
            render "no_Error al guardar la provincia"
        }else{
            if(params.id) {
                render  "ok_Se ha actualizado correctamente la Provincia "
            } else {
                render "ok_Se ha creado correctamente la Provincia "
            }
        }
    } //save

    def show_ajax() {
        def provinciaInstance = Provincia.get(params.id)
        [provinciaInstance: provinciaInstance]
    } //show

    def delete() {
        def provinciaInstance = Provincia.get(params.id)
        if (!provinciaInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Provincia con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            provinciaInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message =  "Se ha eliminado correctamente Provincia " + provinciaInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message =  "No se pudo eliminar Provincia " + (provinciaInstance.id ? provinciaInstance.id : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller
