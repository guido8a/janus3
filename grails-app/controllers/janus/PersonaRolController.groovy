package janus

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona

class PersonaRolController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [personaRolInstanceList: PersonaRol.list(params), personaRolInstanceTotal: PersonaRol.count(), params: params]
    } //list


    def registroPersonaRol (){
        def funciones = Funcion.findAllByCodigoNotLikeAndCodigoNotLike("D","O")
        def listaDireccion = Direccion.list()
        return[funciones: funciones, listaDireccion: listaDireccion]
    }

    def getPersonas () {
//        println("parmas get p " + params)
        def direccion = Direccion.get(params.id)
        def departamentos = Departamento.findAllByDireccion(direccion)
        def personas
        if(departamentos.size() > 0){
            personas = Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])
        }else{
            personas = []
        }
        return [personas : personas]
    }

    def getSeleccionados () {
        def direccion = Direccion.get(params.id)
        def departamentos = Departamento.findAllByDireccion(direccion)
        def personas
        if(departamentos.size() > 0){
            personas = Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])
        }else{
            personas = []
        }
        return [personas: personas]
    }

    def obtenerFuncion (){
        def persona = Persona.get(params.id);
        def rol = PersonaRol.findAllByPersona(persona)
        return [persona: persona, rol: rol]
    }

    def obtenerFuncionDirector () {
        def persona = Persona.get(params.id);
        def funcion = Funcion.get(9)
        def rol = PersonaRol.findByPersonaOrFuncion(persona, funcion)
        return [persona: persona, rol: rol]
    }

    def grabarFuncion () {
        def persona

        if(params.id){
           persona = Persona.get(params.id)
        }else{
            render "no_Seleccione una persona"
            return true
        }

        def rol = Funcion.get(params.rol)

        if(PersonaRol.findAllByPersonaAndFuncion(persona, rol)){
            render "no_La función seleccionada ya ha sido asignada a la persona"
        }else{
            def personaRol = new PersonaRol()
                personaRol.persona = persona
                personaRol.funcion = rol

            if (!personaRol.save([flush: true])) {
                render "NO_Error al asignar la función"
                println "ERROR al guardar rolPersona: "+personaRol.errors
            } else {
                render "OK_Función asignada correctamente"
            }
        }
    }

    def form_ajax() {
        def personaRolInstance = new PersonaRol(params)
        if (params.id) {
            personaRolInstance = PersonaRol.get(params.id)
            if (!personaRolInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró PersonaRol con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [personaRolInstance: personaRolInstance]
    } //form_ajax

    def save() {
        def personaRolInstance
        if (params.id) {
            personaRolInstance = PersonaRol.get(params.id)
            if (!personaRolInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró PersonaRol con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            personaRolInstance.properties = params
        }//es edit
        else {
            personaRolInstance = new PersonaRol(params)
        } //es create
        if (!personaRolInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar PersonaRol " + (personaRolInstance.id ? personaRolInstance.id : "") + "</h4>"

            str += "<ul>"
            personaRolInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(action: 'list')
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente PersonaRol " + personaRolInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente PersonaRol " + personaRolInstance.id
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def personaRolInstance = PersonaRol.get(params.id)
        if (!personaRolInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró PersonaRol con id " + params.id
            redirect(action: "list")
            return
        }
        [personaRolInstance: personaRolInstance]
    } //show

    def delete() {
        def personaRolInstance = PersonaRol.get(params.id)
        if (!personaRolInstance) {
            render "no_No se encontró la función"
        }

        try {
            personaRolInstance.delete(flush: true)
            render "ok_Función borrada correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar la función " + personaRolInstance.errors)
            render "no_Error al borrar la función"
        }
    } //delete


    //asignación del director

    def asignarDirector () {
        def listaDireccion = Direccion.list()
        return [listaDireccion: listaDireccion]
    }

    def sacarFunciones () {
        def direccion = Direccion.get(params.id)
        def departamentos = Departamento.findAllByDireccion(direccion)
        def personas = Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])
        def funcion = Funcion.get(9)
        def roles = PersonaRol.findAllByPersonaInListAndFuncion(personas, funcion )
        render roles.size()
    }

} //fin controller
