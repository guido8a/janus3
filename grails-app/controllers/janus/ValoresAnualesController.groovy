package janus

import janus.pac.Anio
import org.springframework.dao.DataIntegrityViolationException

class ValoresAnualesController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [valoresAnualesInstanceList: ValoresAnuales.list(params).sort{it?.anioNuevo?.anio}, params: params]
    } //list

    def form_ajax() {
        def valoresAnualesInstance = new ValoresAnuales(params)
        if (params.id) {
            valoresAnualesInstance = ValoresAnuales.get(params.id)
            if (!valoresAnualesInstance) {
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [valoresAnualesInstance: valoresAnualesInstance]
    } //form_ajax

    def save() {
//        println("params" + params)
        def anioNuevo = Anio.get(params.anioNuevo)
        def existe = ValoresAnuales.findByAnioNuevo(anioNuevo)
        params.anio = anioNuevo.anio
        def valoresAnualesInstance

        if (params.id) {
            valoresAnualesInstance = ValoresAnuales.get(params.id)
            if (!valoresAnualesInstance) {
                render "no_No se encontró el registro"
                return
            }//no existe el objeto
            if(existe){
                if(existe?.id == valoresAnualesInstance?.id ){
                    valoresAnualesInstance.properties = params
                }else{
                    render "no_Ya existen valores anuales para ese año"
                    return
                }
            }else{
                valoresAnualesInstance.properties = params
            }
        }//es edit
        else {
            if(existe){
                render "no_Ya existen valores anuales para ese año"
                return
            }else{
                valoresAnualesInstance = new ValoresAnuales()
                valoresAnualesInstance.properties = params
            }
        } //es create
        if (!valoresAnualesInstance.save(flush: true)) {
            println("error al guardar los valores anuales " + valoresAnualesInstance.errors)
            render"no_Error al guardar los valores anuales"
        }else{
            render "ok_Valores guardados correctamente"
        }

    } //save

    def show_ajax() {
        def valoresAnualesInstance = ValoresAnuales.get(params.id)
        if (!valoresAnualesInstance) {
            redirect(action: "list")
            return
        }
        [valoresAnualesInstance: valoresAnualesInstance]
    } //show

    def delete() {
        def valoresAnualesInstance = ValoresAnuales.get(params.id)
        if (!valoresAnualesInstance) {
            render "no_No se encontró el registro"
            return
        }

        try {
            valoresAnualesInstance.delete(flush: true)
            render "ok_Valores borrados correctamente"
        }
        catch (DataIntegrityViolationException e) {
            render "no_Error al borrar los valores"
        }
    } //delete
} //fin controller
