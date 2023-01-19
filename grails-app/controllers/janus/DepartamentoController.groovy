package janus


import org.springframework.dao.DataIntegrityViolationException

class DepartamentoController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [departamentoInstanceList: Departamento.list(params).sort{it.descripcion}, departamentoInstanceTotal: Departamento.count(),  params: params]
    } //list

    def form_ajax() {
        def departamentoInstance = new Departamento(params)
        if(params.id) {
            departamentoInstance = Departamento.get(params.id)
            if(!departamentoInstance) {
                flash.clase = "alert-error"
                flash.message =  "No se encontró el Departamento con id " + params.id
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [departamentoInstance: departamentoInstance]
    } //form_ajax

    def saveDepartamento_ajax() {
        def departamento
        def texto = params.id ? 'actualizado' : 'creado'

        if(params.id){
            departamento = Departamento.get(params.id)
            if(!departamento){
                render "no_Error al guardar el departamento"
            }
        }else{
            if(Departamento.findAllByCodigo(params.codigo.toUpperCase())){
                render "no_El código ya se encuentra ingresado"
                return
            }else{
                departamento = new Departamento()
            }
        }

        params.descripcion = params.descripcion.toUpperCase();
        params.codigo = params.codigo.toUpperCase();
        departamento.properties = params

        if(!departamento.save(flush:true)){
            println("error al guardar el departamento " + departamento.errors)
            render "no_Error al guardar el departamento"
        }else{
            render "ok_Departamento ${texto} correctamente"
        }
    } //save

    def show_ajax() {
        def departamentoInstance = Departamento.get(params.id)
        [departamentoInstance: departamentoInstance]
    } //show

    def delete_ajax() {
        def departamentoInstance = Departamento.get(params.id)
        if(!departamentoInstance){
            render "no_Error al borrar el departamento"
        }else{
            try {
                departamentoInstance.delete(flush: true)
                render "ok_Departamento borrado correctamente"
            }catch(e){
                println("error al borrar el departamento " + departamentoInstance.errors)
                render "no_Error al borrar el departamento"
            }
        }

    } //delete
} //fin controller
