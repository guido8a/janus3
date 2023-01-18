package janus

class TipoItemController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [tipoItemInstanceList: TipoItem.list(params), tipoItemInstanceTotal: TipoItem.count(), params: params]
    } //list

    def form_ajax() {
        def tipoItemInstance = new TipoItem(params)
        if (params.id) {
            tipoItemInstance = TipoItem.get(params.id)
            if (!tipoItemInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró TipoItem con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoItemInstance: tipoItemInstance]
    } //form_ajax

    def saveTipoItem_ajax() {

        def tipoItem
        def texto = params.id ? 'actualizado' : 'creado'

        if(params.id){
            tipoItem = TipoItem.get(params.id)
            if(!tipoItem){
                render "no_Error al guardar el tipo de item"
            }
        }else{
            tipoItem = new TipoItem()
        }

        params.codigo = params.codigo.toUpperCase();
        params.descripcion = params.descripcion.toUpperCase();
        tipoItem.properties = params

        if(!tipoItem.save(flush:true)){
            println("error al guardar el tipo de item " + tipoItem.errors)
            render "no_Error al guardar el tipo de item"
        }else{
            render "ok_Tipo de item ${texto} correctamente"
        }

    } //save

    def show_ajax() {
        def tipoItemInstance = TipoItem.get(params.id)
        [tipoItemInstance: tipoItemInstance]
    } //show

    def delete_ajax() {
        def tipoItemInstance = TipoItem.get(params.id)
        if(!tipoItemInstance){
            render "no_Error al borrar el tipo de item"
        }else{
            try {
                tipoItemInstance.delete(flush: true)
                render "ok_Tipo de Item borrado correctamente"
            }catch(e){
                println("error al borrar el tipo de item " + tipoItemInstance.errors)
                render "no_Error al borrar el tipo de item"
            }
        }
    } //delete
} //fin controller
