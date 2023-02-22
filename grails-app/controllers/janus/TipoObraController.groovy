package janus

import org.springframework.dao.DataIntegrityViolationException

class TipoObraController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [tipoObraInstanceList: TipoObra.list(params), tipoObraInstanceTotal: TipoObra.count(), params: params]
    } //list

    def form_ajax() {
        def tipoObraInstance = new TipoObra(params)
        if(params.id) {
            tipoObraInstance = TipoObra.get(params.id)
            if(!tipoObraInstance) {
                flash.clase = "alert-error"
                flash.message =  "No se encontró Tipo Obra con id " + params.id
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoObraInstance: tipoObraInstance]
    } //form_ajax

    def save() {
        def tipoObraInstance
        def texto = params.id ? 'actualizado' : 'creado'

        if(params.id){
            tipoObraInstance = TipoObra.get(params.id)
            if(!tipoObraInstance){
                render "no_Error al guardar el tipo de obra"
            }
        }else{
            tipoObraInstance = new TipoObra()
        }

        params.codigo = params.codigo.toUpperCase()
        params.descripcion = params.descripcion.toUpperCase()
        tipoObraInstance.properties = params

        if(!tipoObraInstance.save(flush:true)){
            println("error al guardar  el tipo de obra " + tipoObraInstance.errors)
            render "no_Error al guardar el tipo de obra"
        }else{
            render "ok_Tipo de obra ${texto} correctamente"
        }

    } //save

    def saveTipoObra () {

        def tipoObraInstance

        def grupo = Grupo.get(params."grupo.id")
        params.grupo = grupo
        params.codigo = params.codigo.toUpperCase();
        params.descripcion = params.descripcion.toUpperCase();

        def existe = TipoObra.findByCodigo(params.codigo)

        if(params.id) {
            tipoObraInstance = TipoObra.get(params.id)
            if(!tipoObraInstance) {
                render "no_No se encontró el tipo de obra"
            }//no existe el objeto
        }else {
            if(!existe){
                tipoObraInstance = new TipoObra(params)
            }else{
                render 'No_Ya existe un tipo de obra con ese código'
                return
            }
        } //es create

        tipoObraInstance.properties = params

        if(!tipoObraInstance.save(flush: true)) {
                println("error al guardar el tipo de obra" + tipoObraInstance.errors)
            render "no_Error al guardar el tipo de obra"
        }else{
            render "ok_Tipo de obra guardada correctamente"
        }
    } //save

    def show_ajax() {
        def tipoObraInstance = TipoObra.get(params.id)
        [tipoObraInstance: tipoObraInstance]
    } //show

    def delete() {
        def tipoObraInstance = TipoObra.get(params.id)

        try{
            tipoObraInstance.delete(flush:true)
            render "ok_Registro borrado correctamente"
        }catch(e){
            render "no_Error al borrar el registro"
        }
    } //delete
} //fin controller
