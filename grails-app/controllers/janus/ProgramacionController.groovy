package janus


import org.springframework.dao.DataIntegrityViolationException

class ProgramacionController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [programacionInstanceList: Programacion.list(params), programacionInstanceTotal: Programacion.count(), params: params]
    } //list

    def form_ajax() {
        def programacionInstance = new Programacion(params)
        if (params.id) {
            programacionInstance = Programacion.get(params.id)
            if (!programacionInstance) {
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [programacionInstance: programacionInstance]
    } //form_ajax

    def form_ext_ajax() {
        def grupo = params.grupo
        def programacionInstance = new Programacion(params)

        if (params.id) {
            programacionInstance = Programacion.get(params.id)
            if (!programacionInstance) {
            } //no existe el objeto
        } //es edit
        return [programacionInstance: programacionInstance, grupo: grupo]
    } //form_ajax

    def save() {

        params.descripcion = params.descripcion.toUpperCase();

        def fechaI;
        def fechaF;
        def band = 0;

        if(params.fechaInicio){
            fechaI = new Date().parse("dd-MM-yyyy", params.fechaInicio)
        }

        if(params.fechaFin){
            fechaF = new Date().parse("dd-MM-yyyy", params.fechaFin)
        }

        params.fechaInicio = fechaI
        params.fechaFin = fechaF

        if(fechaI && fechaF){
            if(fechaI >= fechaF){
                band = 1
            }else{
                band = 0
            }
        }else{
            band = 0;
        }

        if(band == 0){
            def programacionInstance

            if (params.id) {
                programacionInstance = Programacion.get(params.id)
                if (!programacionInstance) {
                    render "no_No se encontró la programación"
                }//no existe el objeto
            }//es edit
            else {
                programacionInstance = new Programacion(params)
            } //es create

            programacionInstance.properties = params

            if (!programacionInstance.save(flush: true)) {
                println("error al guardar la programación " + programacionInstance.errors)
                render "no_Error al guardar la programación"
            } else {
                render "ok_Programación guardada correctamente"
            }
        }else{
            render "no_No se puede crear la Programación la Fecha Fin debe ser mayor a la Fecha Inicio"
        }


    } //save

    def save_ext() {
//        println("params" + params)
        def programacionInstance, message

        if (params.fechaInicio) {
            params.fechaInicio = new Date().parse("dd-MM-yyyy", params.fechaInicio)
        }
        if (params.fechaFin) {
            params.fechaFin = new Date().parse("dd-MM-yyyy", params.fechaFin)
        }

        if(params.fechaInicio >= params.fechaFin){
          render "error"
          return
        }else{

        if (params.id) {
            programacionInstance = Programacion.get(params.id)
            if (!programacionInstance) {
                message = "No se encontró Programacion con id " + params.id
                println message
                render "error"
                return
            }//no existe el objeto
            programacionInstance.properties = params
        }//es edit
        else {
            programacionInstance = new Programacion(params)

        } //es create
        if (!programacionInstance.save(flush: true)) {
            def str = "<h4>No se pudo guardar Programacion " + (programacionInstance.id ? programacionInstance.id : "") + "</h4>"

            str += "<ul>"
            programacionInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex { arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            message = str
            println message
            render "error"
            return
        }

        if (params.id) {
            message = "Se ha actualizado correctamente la Programacion " + programacionInstance.descripcion
        } else {
            message = "Se ha creado correctamente la Programacion " + programacionInstance.id
        }
        println message

        def sel = g.select(id: "programacion", name: "programacion.id", "class": "programacion required", from: Programacion.list(), value: programacionInstance.id, optionValue: "descripcion",
                optionKey: "id", title: "Programa")
        render sel

        }
    } //save

    def show_ajax() {
        def programacionInstance = Programacion.get(params.id)
        if (!programacionInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Programacion con id " + params.id
            redirect(action: "list")
            return
        }
        [programacionInstance: programacionInstance]
    } //show

    def delete() {
        def programacionInstance = Programacion.get(params.id)
        if (!programacionInstance) {
            render "no_No se encontró la programación"
        }

        try {
            programacionInstance.delete(flush: true)
            render "ok_Programación borrada correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al guardar la programación " + programacionInstance.errors)
            render "no_Error al guardar la programación"
        }
    } //delete
} //fin controller
