package janus


import org.springframework.dao.DataIntegrityViolationException

class ClaseObraController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [claseObraInstanceList: ClaseObra.list(params), claseObraInstanceTotal: ClaseObra.count(), params: params]
    } //list

    def form_ext_ajax() {

        def grupo = params.grupo

        def claseObraInstance = new ClaseObra(params)
        if (params.id) {
            claseObraInstance = ClaseObra.get(params.id)
            if (!claseObraInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró ClaseObra con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [claseObraInstance: claseObraInstance, grupo: grupo]
    } //form_ajax

    def save_ext() {

        def grupo = Grupo.get(params.grupo)
        params.grupo = grupo

        params.descripcion = params.descripcion.toUpperCase()

        def clases = ClaseObra.list()
        def clasesOrdenadas = ClaseObra.list(sort: 'codigo' )
        def codigos = []
        clasesOrdenadas.each {
            codigos += it?.codigo
        }

        def claseObraInstance, message
        if (params.id) {
            claseObraInstance = ClaseObra.get(params.id)
            if (!claseObraInstance) {
                    render "no_No existe la clase de obra"
            }//no existe el objeto

        }//es edit
        else {
            claseObraInstance = new ClaseObra(params)
            claseObraInstance.codigo = (codigos?.last() ? (codigos?.last()  + 1) : 1)
        } //es create

        claseObraInstance.properties = params


        if(!claseObraInstance.save(flush: true)) {
            println("error al guardar la clase de obra " + claseObraInstance.errors)
            render "no_Error al guardar la clase de obra"
        }else{
            render "ok_Clase de obra guardada correctamente"
        }

    } //save

    def form_ajax() {
        def claseObraInstance = new ClaseObra(params)
        if (params.id) {
            claseObraInstance = ClaseObra.get(params.id)
            if (!claseObraInstance) {
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [claseObraInstance: claseObraInstance]
    } //form_ajax

    def save() {

        def clasesOrdenadas = ClaseObra.list(sort: 'codigo' )
        def codigos = []
        def claseObraInstance

        clasesOrdenadas.each {
            codigos += it?.codigo
        }

        params.descripcion = params.descripcion.toUpperCase();

        if (params.id) {
            claseObraInstance = ClaseObra.get(params.id)
            if (!claseObraInstance) {
                render "no_Error al guardar la clase de obra"
            }//no existe el objeto
            claseObraInstance.properties = params
        }//es edit
        else {
            claseObraInstance = new ClaseObra(params)
            claseObraInstance.codigo =  (codigos.last() + 1)
        } //es create

        if (!claseObraInstance.save(flush: true)) {
            render "no_Error al guardar la clase de obra"
        }else{
            render "ok_Clase de obra guardada correctamente"
        }
    } //save

    def show_ajax() {
        def claseObraInstance = ClaseObra.get(params.id)
        if (!claseObraInstance) {
            redirect(action: "list")
            return
        }
        [claseObraInstance: claseObraInstance]
    } //show

    def delete() {
        def claseObraInstance = ClaseObra.get(params.id)
        if (!claseObraInstance) {
            render "ok_No se encontró el registro"
            return
        }

        try {
            claseObraInstance.delete(flush: true)
            render "ok_Clase borrada correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar la clase de obra " + claseObraInstance.errors)
           render "no_Error al borrar la clase"
        }
    } //delete
} //fin controller
