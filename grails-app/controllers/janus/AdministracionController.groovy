package janus

class AdministracionController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [administracionInstanceList: Administracion.list(params), administracionInstanceTotal: Administracion.count(), params: params]
    } //list

    def form_ajax() {
        def administracionInstance = new Administracion(params)
        if (params.id) {
            administracionInstance = Administracion.get(params.id)
            if (!administracionInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Administracion con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [administracionInstance: administracionInstance]
    } //form_ajax

    def saveAdministracion_ajax() {

        def administracion
        def texto = params.id ? 'actualizada' : 'creada'

        if(params.fechaInicio){
            params.fechaInicio = new Date().parse("dd-MM-yyyy", params.fechaInicio)
        }
        if(params.fechaFin){
            params.fechaFin = new Date().parse("dd-MM-yyyy", params.fechaFin)
        }

        if(params.fechaInicio >= params.fechaFin){
            render "no_La Fecha de Inicio debe ser menor a la Fecha Fin"
        }else{

            if(params.id){
                administracion = Administracion.get(params.id)
                if(!administracion){
                    render "no_Error al guardar la administración"
                }
            }else{
                administracion = new Administracion()
            }

            administracion.properties = params

            if(!administracion.save(flush:true)){
                println("error al guardar la administracion " + administracion.errors)
                render "no_Error al guardar los datos de administración"
            }else{
                render "ok_Administración ${texto} correctamente"
            }
        }
    } //save

    def show_ajax() {
        def administracionInstance = Administracion.get(params.id)
        [administracionInstance: administracionInstance]
    } //show

    def delete_ajax() {
        def administracionInstance = Administracion.get(params.id)
        if(!administracionInstance){
            render "no_Error al borrar el registro"
        }else{
            try {
              administracionInstance.delete(flush: true)
              render "ok_Registro borrado correctamente"
            }catch(e){
                println("error al borrar el registro de administracion " + administracionInstance.errors)
                render "no_Error al borrar el registro"
            }
        }
    } //delete

} //fin controller
