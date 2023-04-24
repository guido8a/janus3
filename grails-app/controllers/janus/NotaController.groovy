package janus


import org.springframework.dao.DataIntegrityViolationException

class NotaController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [notaInstanceList: Nota.list(params), params: params]
    } //list

    def form_ajax() {
        def notaInstance = new Nota(params)
        if (params.id) {
            notaInstance = Nota.get(params.id)
            if (!notaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Nota con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [notaInstance: notaInstance]
    } //form_ajax

    def guardarNotaPresupuesto() {

        if (params.piePaginaSel) {
            if (params.piePaginaSel != '-1'){
                params.id = params.piePaginaSel
            }else{
                params.id = null
            }
        }

        def notaInstance
        if (params.id) {
            notaInstance = Nota.get(params.id)
            if (!notaInstance) {
                render "no_Nota no encontrada"
                return
            }//no existe el objeto
        }//es edit
        else {
            notaInstance = new Nota()
        } //es create

        notaInstance.properties = params

        if (!notaInstance.save(flush: true)) {
            println("error al guardar la nota" + notaInstance.errors)
            render "no_Error al guardar la nota"
        }else{
            render "ok_Nota guardada correctamente"
        }
    } //save

    def saveNota () {
        def dia = new Date()
//        println ("params saveNota "+ params)
        if (params.piePaginaSel) {
            if (params.piePaginaSel != '-1'){
                params.id = params.piePaginaSel
            }else{
                params.id = null
            }
        }

        def notaInstance = null

        if (params.id) {

            notaInstance = Nota.get(params.id)
            if (!notaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Nota con id " + params.id
//                redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
                return
            }//no existe el objeto
            notaInstance.properties = params
        }//es edit
        else {

            if(params.adicional == '' && params.texto == ''){


            }else {

                notaInstance = new Nota()
                if(params.descripcion == ''){

                    notaInstance.descripcion = "Nota " + dia.format("dd-MM-yyyy")
                    notaInstance.adicional = params.adicional
                    notaInstance.texto = params.texto
                }else {

                    notaInstance.descripcion = params.descripcion
                    notaInstance.adicional = params.adicional
                    notaInstance.texto = params.texto
                }

            }

        } //es create

        if (notaInstance && notaInstance.save(flush: true)) {

//            if (params.id) {
//                flash.clase = "alert-success"
//                flash.message = "Se ha actualizado correctamente la Nota " + notaInstance.descripcion
//            } else {
//                flash.clase = "alert-success"
//                flash.message = "Se ha creado correctamente la Nota " + notaInstance.descripcion
//            }

            render "ok_"+notaInstance?.id


        } else {
            flash.clase = "alert-error"
            def str
            if(notaInstance) {
                str = "<h4>No se pudo guardar Nota " + (notaInstance.id ? notaInstance.id : "") + "</h4>"

                str += "<ul>"
                notaInstance.errors.allErrors.each { err ->
                    def msg = err.defaultMessage
                    err.arguments.eachWithIndex {  arg, i ->
                        msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                    }
                    str += "<li>" + msg + "</li>"
                }
                str += "</ul>"
            } else {
//                str = "No se pudo guardar porque la descripción y el texto están vacíos"
            }

            flash.message = str
            render "ok"
//            redirect(action: 'list')
            return

        }


    }

    //save notaMemo

    def saveNotaMemo() {

        def fecha = new Date();

        if (params.selMemo) {
            if (params.selMemo != '-1'){
                params.id = params.selMemo
            }else{
                params.id = null
            }
        }

        def notaInstance
        if (params.id) {
            notaInstance = Nota.get(params.id)
            if (!notaInstance) {
                render "no_Nota no encontrada"
                return
            }//no existe el objeto
        }//es edit
        else {
            notaInstance = new Nota()
            notaInstance.adicional = params.pie
            notaInstance.texto = params.texto
            notaInstance.tipo = 'memo'
            notaInstance.descripcion = "Nota Memo " + fecha.format("dd-MM-yyyy");
        } //es create

        notaInstance.adicional = params.pie
        notaInstance.texto = params.texto

        if (!notaInstance.save(flush: true)) {
            println("error al guardar la nota " + notaInstance.errors)
            render "no_Error al guardar la nota"
        }else{
            render "ok_Nota guardada correctamente"
        }
    } //save

    def saveNotaFormu() {

        def fecha = new Date();

        if (params.selFormu) {
            if (params.selFormu != '-1'){
                params.id = params.selFormu
            }else{
                params.id = null
            }
        }

        def notaInstance
        if (params.id) {
            notaInstance = Nota.get(params.id)
            if (!notaInstance) {
                render "no_Nota no encontrada"
                return
            }//no existe el objeto
        }//es edit
        else {
            notaInstance = new Nota()
            notaInstance.tipo = 'formula'
            notaInstance.descripcion = "Nota Formula " + fecha.format("dd-MM-yyyy");
        } //es create

        notaInstance.texto = params.texto

        if (!notaInstance.save(flush: true)) {
            println("error al guardar la nota " + notaInstance.errors)
            render "no_Error al guardar la nota"
        }else{
            render "ok_Nota guardada correctamente"
        }
    } //save

    def delete() {

        def notaInstance = Nota.get(params.id)

        if (!notaInstance) {
            render "no_No se encontró la nota"
            return
        }

        try {
            notaInstance.delete(flush:true)
            render "ok_Nota borrada correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar la nota " + notaInstance.errors)
            render "no_Error al borrar la nota"
        }
    } //delete
} //fin controller