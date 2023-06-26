package janus.ejecucion

import org.springframework.dao.DataIntegrityViolationException

class PeriodosInecController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def migracionService

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        def periodos = PeriodosInec.list([sort: 'fechaInicio', order: 'desc'])
        [periodosInecInstanceList: periodos, params: params]
    } //list

    def form_ajax() {
        def periodosInecInstance = new PeriodosInec(params)
        if(params.id) {
            periodosInecInstance = PeriodosInec.get(params.id)
            if(!periodosInecInstance) {
                flash.clase = "alert-error"
                flash.message =  "No se encontró Periodos Inec con id " + params.id
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [periodosInecInstance: periodosInecInstance]
    } //form_ajax

    def save() {
//        println "save3 "+params
        def periodosInecInstance
        if (params.fechaInicio){
            params.fechaInicio=new Date().parse("dd-MM-yyyy",params.fechaInicio)
        }
        if (params.fechaFin){
            params.fechaFin=new Date().parse("dd-MM-yyyy",params.fechaFin)
        }

        if(params.fechaInicio >= params.fechaFin){
            render "no_No se pudo guardar el Período Inec, la Fecha Fin debe ser mayor a la Fecha Inicio"
            return true
        }else{

            if(params.id) {
                periodosInecInstance = PeriodosInec.get(params.id)
                if(!periodosInecInstance) {
                    render "no_No se encontró el período Inec"
                    return true
                }//no existe el objeto
                periodosInecInstance.properties = params
            }//es edit
            else {
                periodosInecInstance = new PeriodosInec(params)
            } //es create

            if (!periodosInecInstance.save(flush: true)) {
                render "no_Error al guardar el período"
            }else{
                render "ok_Período guardado correctamente"
            }
        }

    } //save

    def show_ajax() {
        def periodosInecInstance = PeriodosInec.get(params.id)
        if (!periodosInecInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Periodos Inec con id " + params.id
            redirect(action: "list")
            return
        }
        [periodosInecInstance: periodosInecInstance]
    } //show

    def delete() {
        def periodosInecInstance = PeriodosInec.get(params.id)
        if (!periodosInecInstance) {
            render ("no_No se encontró el Período Inec")
            return true
        }

        try {
            periodosInecInstance.delete(flush: true)
            render "ok_Se ha eliminado correctamente el Período Inec "
        }
        catch (DataIntegrityViolationException e) {
            println("error al guardar el período inec " + periodosInecInstance.errors)
           render ("no_No se pudo eliminar el Período Inec ")
        }
    } //delete

    def generarIndices(){
        render migracionService.insertRandomIndices()
    }

    def tablaPeriodosIndices_ajax(){
        def periodos = PeriodosInec.list([sort: 'fechaInicio', order: 'desc'])
        return [periodosInecInstanceList: periodos]
    }

} //fin controller
