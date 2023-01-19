package janus


import org.springframework.dao.DataIntegrityViolationException

class TransporteController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [transporteInstanceList: Transporte.list(params), transporteInstanceTotal: Transporte.count(), params: params]
    } //list

    def form_ajax() {
        def transporteInstance = new Transporte(params)
        if (params.id) {
            transporteInstance = Transporte.get(params.id)
            if (!transporteInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Transporte con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [transporteInstance: transporteInstance]
    } //form_ajax

    def saveTransporte_ajax() {

        def transporte
        def texto = params.id ? 'actualizado' : 'creado'

        if(params.id){
            transporte = Transporte.get(params.id)
            if(!transporte){
                render "no_Error al guardar el transporte"
            }
        }else{
            if(Transporte.findAllByCodigo(params.codigo.toUpperCase())){
                render "no_El código ya se encuentra ingresado"
                return
            }else{
                transporte = new Transporte()
            }
        }

        params.codigo = params.codigo.toUpperCase();
        params.descripcion = params.descripcion.toUpperCase();
        transporte.properties = params

        if(!transporte.save(flush:true)){
            println("error al guardar el transporte " + transporte.errors)
            render "no_Error al guardar el transporte"
        }else{
            render "ok_Transporte ${texto} correctamente"
        }

    } //save

    def show_ajax() {
        def transporteInstance = Transporte.get(params.id)
        [transporteInstance: transporteInstance]
    } //show

    def delete_ajax() {
        def transporteInstance = Transporte.get(params.id)
        if(!transporteInstance){
            render "no_Error al borrar el transporte"
        }else{
            try {
                transporteInstance.delete(flush: true)
                render "ok_Transporte borrado correctamente"
            }catch(e){
                println("error al borrar el transporte " + transporteInstance.errors)
                render "no_Error al borrar el transporte"
            }
        }
    } //delete
} //fin controller
