package janus.ejecucion


import org.springframework.dao.DataIntegrityViolationException

class TipoPlanillaController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = 16
        [tipoPlanillaInstanceList: TipoPlanilla.list(params), params: params]
    } //list

    def form_ajax() {
        def tipoPlanillaInstance = new TipoPlanilla(params)
        if(params.id) {
            tipoPlanillaInstance = TipoPlanilla.get(params.id)
            if(!tipoPlanillaInstance) {
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoPlanillaInstance: tipoPlanillaInstance]
    } //form_ajax

    def save() {
        if(params.codigo){
            params.codigo = params.codigo.toUpperCase();
        }
        def tipoPlanillaInstance
        if(params.id) {
            tipoPlanillaInstance = TipoPlanilla.get(params.id)
            if(!tipoPlanillaInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            tipoPlanillaInstance.properties = params
        }//es edit
        else {
            def existe= TipoPlanilla.findByCodigo(params.codigo)
            if(!existe)
                tipoPlanillaInstance = new TipoPlanilla(params)
            else{
                render "no_El código ingresado ya existe"
                return
            }
        } //es create
        if (!tipoPlanillaInstance.save(flush: true)) {
            render "no_Error al guardar el tipo"
        }else{
            render "ok_Tipo guardado correctamente"
        }
    } //save


    def delete() {
        def tipoPlanillaInstance = TipoPlanilla.get(params.id)
        if (!tipoPlanillaInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            tipoPlanillaInstance.delete(flush: true)
            render "ok_Tipo borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            render "no_Error al borrar el tipo"
        }
    } //delete
} //fin controller
