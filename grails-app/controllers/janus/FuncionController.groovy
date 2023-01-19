package janus


class FuncionController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [funcionInstanceList: Funcion.list(params), funcionInstanceTotal: Funcion.count(), params: params]
    } //list

    def form_ajax() {
        def funcionInstance = new Funcion(params)
        if (params.id) {
            funcionInstance = Funcion.get(params.id)
            if (!funcionInstance) {
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [funcionInstance: funcionInstance]
    } //form_ajax

    def saveFuncion_ajax() {
        def funcion
        def texto = params.id ? 'actualizada' : 'creada'

        if(params.id){
            funcion = Funcion.get(params.id)
            if(!funcion){
                render "no_Error al guardar la función"
            }
        }else{
            if(Funcion.findAllByCodigo(params.codigo.toUpperCase())){
                render "no_El código ya se encuentra ingresado"
                return
            }else{
                funcion = new Funcion()
            }
        }

        params.descripcion = params.descripcion.toUpperCase();
        params.codigo = params.codigo.toUpperCase();
        funcion.properties = params

        if(!funcion.save(flush:true)){
            println("error al guardar la función " + funcion.errors)
            render "no_Error al guardar la función"
        }else{
            render "ok_Función ${texto} correctamente"
        }
    } //save

    def show_ajax() {
        def funcionInstance = Funcion.get(params.id)
        [funcionInstance: funcionInstance]
    } //show

    def delete_ajax() {
        def funcionInstance = Funcion.get(params.id)
        if(!funcionInstance){
            render "no_Error al borrar la función"
        }else{
            try {
                funcionInstance.delete(flush: true)
                render "ok_Función borrada correctamente"
            }catch(e){
                println("error al borrar la función " + funcionInstance.errors)
                render "no_Error al borrar la función"
            }
        }
    } //delete
} //fin controller
