package janus.ejecucion


import org.springframework.dao.DataIntegrityViolationException

class TipoFormulaPolinomicaController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [tipoFormulaPolinomicaInstanceList: TipoFormulaPolinomica.list(params), params: params]
    } //list

    def form_ajax() {
        def tipoFormulaPolinomicaInstance = new TipoFormulaPolinomica(params)
        if (params.id) {
            tipoFormulaPolinomicaInstance = TipoFormulaPolinomica.get(params.id)
            if (!tipoFormulaPolinomicaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Tipo Formula Polinomica con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoFormulaPolinomicaInstance: tipoFormulaPolinomicaInstance]
    } //form_ajax

    def save() {
        params.codigo = params.codigo.toUpperCase();

        def existe = TipoFormulaPolinomica.findByCodigo(params.codigo)

        def tipoFormulaPolinomicaInstance
        if (params.id) {
            tipoFormulaPolinomicaInstance = TipoFormulaPolinomica.get(params.id)
            if (!tipoFormulaPolinomicaInstance) {
                render "no_No se encontró el tipo de fórmula polinómica"
            }//no existe el objeto
            tipoFormulaPolinomicaInstance.properties = params
        }//es edit
        else {
            if(!existe){
                tipoFormulaPolinomicaInstance = new TipoFormulaPolinomica(params)
            }else{
                render "no_El código ingresado ya existe"
            }
        } //es create

        if(!tipoFormulaPolinomicaInstance.save(flush: true)) {
            println("error al guardar el tipo de fp " + tipoFormulaPolinomicaInstance.errors)
            render "no_Error al guardar el tipo de fórmula polinómica"
        }else{
            render "ok_Tipo de Fórmula Polinómica guardada correctamente"
        }
    } //save

    def show_ajax() {
        def tipoFormulaPolinomicaInstance = TipoFormulaPolinomica.get(params.id)
        if (!tipoFormulaPolinomicaInstance) {
            redirect(action: "list")
            return
        }
        [tipoFormulaPolinomicaInstance: tipoFormulaPolinomicaInstance]
    } //show

    def delete() {
        def tipoFormulaPolinomicaInstance = TipoFormulaPolinomica.get(params.id)
        if (!tipoFormulaPolinomicaInstance) {
        render "no_No se encontró el tipo de fórmula polinómica"
        }

        try {
            tipoFormulaPolinomicaInstance.delete(flush: true)
            render "ok_Tipo de fórmula polinómica borrada correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar la fp " + tipoFormulaPolinomicaInstance?.errors)
            render "no_Error al borrar el tipo de Fórmula Polinómica"
        }
    } //delete
} //fin controller
