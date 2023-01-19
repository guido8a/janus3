package janus

class RolTramiteController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [rolTramiteInstanceList: RolTramite.list(params), rolTramiteInstanceTotal: RolTramite.count(), params: params]
    } //list

    def form_ajax() {
        def rolTramiteInstance = new RolTramite(params)
        if (params.id) {
            rolTramiteInstance = RolTramite.get(params.id)
            if (!rolTramiteInstance) {
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [rolTramiteInstance: rolTramiteInstance]
    } //form_ajax

    def saveRolTramite_ajax() {

        def rol
        def texto = params.id ? 'actualizado' : 'creado'

        if(params.id){
            rol = RolTramite.get(params.id)
            if(!rol){
                render "no_Error al guardar el rol"
            }
        }else{
            if(RolTramite.findAllByCodigo(params.codigo.toUpperCase())){
                render "no_El código ya se encuentra ingresado"
                return
            }else{
                rol = new RolTramite()
            }
        }

        params.codigo = params.codigo.toUpperCase();
        rol.properties = params

        if(!rol.save(flush:true)){
            println("error al guardar el rol " + rol.errors)
            render "no_Error al guardar el rol"
        }else{
            render "ok_Rol ${texto} correctamente"
        }

    } //save

    def show_ajax() {
        def rolTramiteInstance = RolTramite.get(params.id)
        if (!rolTramiteInstance) {
            redirect(action: "list")
            return
        }
        [rolTramiteInstance: rolTramiteInstance]
    } //show

    def delete() {
        def rolTramiteInstance = RolTramite.get(params.id)
        if(!rolTramiteInstance){
            render "no_Error al borrar el rol"
        }else{
            try {
                rolTramiteInstance.delete(flush: true)
                render "ok_Rol borrado correctamente"
            }catch(e){
                println("error al borrar el rol " + rolTramiteInstance.errors)
                render "no_Error al borrar el rol"
            }
        }

    } //delete
} //fin controller
