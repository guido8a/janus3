package janus

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona

class AuxiliarController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [auxiliarInstanceList: Auxiliar.list(params), params: params]
    } //list

    def textosFijos (){
        def pr = janus.ReportesController
        def nota = new Nota();
        def auxiliar = new Auxiliar();
        def auxiliarFijo = Auxiliar.get(1);
        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def personas = Persona.list()
        def departamentos = Departamento.list()
        def detalle
        def precios = [:]
        def prch = 0
        def prvl = 0
        def total1 = 0;
        def total2 = 0;
        def totalPrueba = 0
        def totales
        def totalPresupuesto=0;
        def totalPresupuestoBien=0;
        [nota: nota, auxiliar: auxiliar, auxiliarFijo: auxiliarFijo, totalPresupuesto: totalPresupuesto,totalPresupuestoBien: totalPresupuestoBien, persona: persona]
    }

    def form_ajax() {
        def auxiliarInstance = new Auxiliar(params)
        if(params.id) {
            auxiliarInstance = Auxiliar.get(params.id)
            if(!auxiliarInstance) {
                flash.clase = "alert-error"
                flash.message =  "No se encontró Auxiliar con id " + params.id
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [auxiliarInstance: auxiliarInstance]
    } //form_ajax

    def save() {
        def auxiliarInstance
        if(params.id) {
            auxiliarInstance = Auxiliar.get(params.id)
            if(!auxiliarInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Auxiliar con id " + params.id
                redirect(action: '')
                return
            }//no existe el objeto
            auxiliarInstance.properties = params
        }//es edit
        else {
            auxiliarInstance = new Auxiliar(params)
        } //es create
        if (!auxiliarInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Auxiliar " + (auxiliarInstance.id ? auxiliarInstance.id : "") + "</h4>"

            str += "<ul>"
            auxiliarInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(action: 'list')
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Auxiliar " + auxiliarInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Auxiliar " + auxiliarInstance.id
        }
        redirect(action: 'list')
    } //save


    def saveTextoFijo() {

        def auxiliarInstance
        if(params.id) {
            auxiliarInstance = Auxiliar.get(params.id)
            if(!auxiliarInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Auxiliar con id " + params.id
                redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
                return
            }//no existe el objeto
            auxiliarInstance.properties = params
        }//es edit
        else {
            auxiliarInstance = new Auxiliar(params)
        } //es create
        if (!auxiliarInstance.save(flush: true)) {
            flash.clase = "alert-error"
//            def str = "<h4>No se pudo guardar Auxiliar " + (auxiliarInstance.id ? auxiliarInstance.id : "") + "</h4>"
            def str = "<h4>No se pudo guardar el texto en Textos Fijos " + (auxiliarInstance.id ? auxiliarInstance.id : "") + "</h4>"

            str += "<ul>"
            auxiliarInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
//            flash.message = "Se ha actualizado correctamente Auxiliar " + auxiliarInstance.id
            flash.message = "Se ha actualizado correctamente el texto en Textos Fijos "
        } else {
            flash.clase = "alert-success"
//            flash.message = "Se ha creado correctamente Auxiliar " + auxiliarInstance.id
            flash.message = "Se ha creado correctamente el texto en Textos Fijos "
        }
        redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
    } //saveTextoFijo


    def saveDoc() {
         def auxiliarInstance
        if(params.id) {
            auxiliarInstance = Auxiliar.get(params.id)
            if(!auxiliarInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Auxiliar con id " + params.id
                redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
                return
            }//no existe el objeto
            auxiliarInstance.properties = params
        }//es edit
        else {
            auxiliarInstance = new Auxiliar(params)
        } //es create
        if (!auxiliarInstance.save(flush: true)) {
            flash.clase = "alert-error"
//            def str = "<h4>No se pudo guardar Auxiliar " + (auxiliarInstance.id ? auxiliarInstance.id : "") + "</h4>"
            def str = "<h4>No se pudo guardar la nota " + (auxiliarInstance.id ? auxiliarInstance.id : "") + "</h4>"

            str += "<ul>"
            auxiliarInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
//            flash.message = "Se ha actualizado correctamente Auxiliar " + auxiliarInstance.id
            flash.message = "Se ha actualizado correctamente la nota en F. Polinómica "
        } else {
            flash.clase = "alert-success"
//            flash.message = "Se ha creado correctamente Auxiliar " + auxiliarInstance.id
            flash.message = "Se ha creado correctamente la nota en F. Polinómica"
        }
        redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
    } //save

    def savePiePaginaTF() {
        def auxiliarInstance
        if(params.id) {
            auxiliarInstance = Auxiliar.get(params.id)
            if(!auxiliarInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Auxiliar con id " + params.id
                redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
                return
            }//no existe el objeto
            auxiliarInstance.properties = params
        }//es edit
        else {
            auxiliarInstance = new Auxiliar(params)
        } //es create
        if (!auxiliarInstance.save(flush: true)) {
            flash.clase = "alert-error"
//            def str = "<h4>No se pudo guardar Auxiliar " + (auxiliarInstance.id ? auxiliarInstance.id : "") + "</h4>"
            def str = "<h4>No se pudo guardar el pie de página" + (auxiliarInstance.id ? auxiliarInstance.id : "") + "</h4>"

            str += "<ul>"
            auxiliarInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
//            flash.message = "Se ha actualizado correctamente Auxiliar " + auxiliarInstance.id
            flash.message = "Se ha actualizado el pie de página en Textos Fijos "
        } else {
            flash.clase = "alert-success"
//            flash.message = "Se ha creado correctamente Auxiliar " + auxiliarInstance.id
            flash.message = "Se ha creado el pie de página en Textos Fijos"
        }
        redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
    } //save











    def saveMemoPresu() {
//        println(params)
        def auxiliarInstance
        if(params.id) {
            auxiliarInstance = Auxiliar.get(params.id)
            if(!auxiliarInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Auxiliar con id " + params.id
                redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
                return
            }//no existe el objeto
            auxiliarInstance.properties = params
        }//es edit
        else {
            auxiliarInstance = new Auxiliar(params)
        } //es create
        if (!auxiliarInstance.save(flush: true)) {
            flash.clase = "alert-error"
//            def str = "<h4>No se pudo guardar Auxiliar " + (auxiliarInstance.id ? auxiliarInstance.id : "") + "</h4>"
            def str = "<h4>No se pudo guardar el texto en Adm. Directa " + (auxiliarInstance.id ? auxiliarInstance.id : "") + "</h4>"

            str += "<ul>"
            auxiliarInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
//            flash.message = "Se ha actualizado correctamente Auxiliar " + auxiliarInstance.id
            flash.message = "Se ha actualizado correctamente el texto en Adm. Directa"
        } else {
            flash.clase = "alert-success"
//            flash.message = "Se ha creado correctamente Auxiliar " + auxiliarInstance.id
            flash.message = "Se ha creado correctamente el texto en Adm. Directa"
        }
        redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
    } //save


    def saveMemoAdj() {

        println("params adj:" + params)

        def auxiliarInstance
        if(params.id) {
            auxiliarInstance = Auxiliar.get(params.id)
            if(!auxiliarInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Auxiliar con id " + params.id
                redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
                return
            }//no existe el objeto
            auxiliarInstance.properties = params
        }//es edit
        else {
            auxiliarInstance = new Auxiliar(params)
        } //es create
        if (!auxiliarInstance.save(flush: true)) {
            flash.clase = "alert-error"
//            def str = "<h4>No se pudo guardar Auxiliar " + (auxiliarInstance.id ? auxiliarInstance.id : "") + "</h4>"
            def str = "<h4>No se pudo guardar el adjunto en Adm. Directa " + (auxiliarInstance.id ? auxiliarInstance.id : "") + "</h4>"

            str += "<ul>"
            auxiliarInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
//            flash.message = "Se ha actualizado correctamente Auxiliar " + auxiliarInstance.id
            flash.message = "Se ha actualizado el texto adjunto en Adm. Directa "
        } else {
            flash.clase = "alert-success"
//            flash.message = "Se ha creado correctamente Auxiliar " + auxiliarInstance.id
            flash.message = "Se ha creado el texto adjunto en Adm. Directa "
        }
        redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
    } //save




    def saveText() {
        def auxiliarInstance
        if(params.id) {
            auxiliarInstance = Auxiliar.get(params.id)
            if(!auxiliarInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Auxiliar con id " + params.id
                redirect(controller: 'auxiliar', action: 'textosFijos')
                return
            }//no existe el objeto
            auxiliarInstance.properties = params
        }//es edit
        else {
            auxiliarInstance = new Auxiliar(params)
        } //es create
        if (!auxiliarInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Auxiliar " + (auxiliarInstance.id ? auxiliarInstance.id : "") + "</h4>"

            str += "<ul>"
            auxiliarInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(controller: 'auxiliar', action: 'textosFijos')
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Auxiliar " + auxiliarInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Auxiliar " + auxiliarInstance.id
        }
        redirect(controller: 'auxiliar', action: 'textosFijos')
    } //save




    def show_ajax() {
        def auxiliarInstance = Auxiliar.get(params.id)
        if (!auxiliarInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Auxiliar con id " + params.id
            redirect(action: "list")
            return
        }
        [auxiliarInstance: auxiliarInstance]
    } //show

    def delete() {
        def auxiliarInstance = Auxiliar.get(params.id)
        if (!auxiliarInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Auxiliar con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            auxiliarInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message =  "Se ha eliminado correctamente Auxiliar " + auxiliarInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message =  "No se pudo eliminar Auxiliar " + (auxiliarInstance.id ? auxiliarInstance.id : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller
