package janus

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona

class AsignarDirectorController  {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def registroPersonaRol (){
    }

    def getPersonas () {
        def departamento = Departamento.get(params.id)
        def personas = Persona.findAllByDepartamento(departamento)
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
        def funcionDirector = Funcion.findByCodigo('D')
        def dptoDireccion = Departamento.findAllByDireccion(direccion)
        def personalDireccion
        if(dptoDireccion.size() > 0){
            personalDireccion = Persona.findAllByDepartamentoInList(dptoDireccion, [sort: 'nombre'])
        }else{
            personalDireccion = []
        }
        def obtenerDirector
        if(personalDireccion != []){
            obtenerDirector = PersonaRol.findByFuncionAndPersonaInList(funcionDirector, personalDireccion)
        }else {
            obtenerDirector = null
        }
        return [personas: personas, obtenerDirector: obtenerDirector, id: params.id]
    }

    def mensaje () {
        def direccion = Direccion.get(params.id)
        def personas
        def departamentos

        if(direccion){
            departamentos = Departamento.findAllByDireccion(direccion)
        }else{
            departamentos = []
        }

        if(departamentos.size() > 0){
            personas = Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])
        }else{
            personas = []
        }

        def funcionDirector = Funcion.findByCodigo('D')
        def personalDireccion

        if(departamentos.size() > 0){
            personalDireccion = Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])
        }else{
            personalDireccion = []
        }

        def obtenerDirector

        if(personalDireccion != []){
            obtenerDirector = PersonaRol.findByFuncionAndPersonaInList(funcionDirector, personalDireccion)
        }else {
            obtenerDirector = null
        }
        return [personas: personas, obtenerDirector: obtenerDirector, id: params.id]
    }

    def obtenerFuncion (){
        def persona = Persona.get(params.id);
        def rol = PersonaRol.findAllByPersona(persona)
        return [persona: persona, rol: rol]
    }

    def obtenerFuncionDirector () {
        def persona = Persona.get(params.id);
        def funcion = Funcion.findByCodigo('D')
        def rol = PersonaRol.findByPersonaAndFuncion(persona, funcion)
        return [persona: persona, rol: rol]
    }

    def grabarFuncion () {
        def funcion = Funcion.findByCodigo('D')

        if(params.direccion != '-1'){
            def direccion = Direccion.get(params.direccion)
            def departamentos = Departamento.findAllByDireccion(direccion)

            def personas
            def roles
            if(departamentos.size() > 0){
                personas = Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])
            }else{
                personas = []
            }

            if(personas.size() > 0){
                roles = PersonaRol.findAllByPersonaInListAndFuncion(personas, funcion)
            }else{
                roles = null
            }

            if(roles == null){
                render "no_Seleccione una persona"
            }else{
                if(roles.size() > 0){
                    render "no_La dirección ya posee un director asignado"
                    return true
                }else{

                    def personaRol = new PersonaRol()
                    if(params.id){
                        personaRol.persona = Persona.get(params.id)
                    }else{
                        render "no_Seleccione una persona"
                        return true
                    }
                    personaRol.funcion = funcion

                    if (!personaRol.save([flush: true])) {
                        render "no_Error al asignar el director"
                        println "ERROR al asignar el director : "+personaRol.errors
                    } else {
                        render "ok_Asignado correctamente"
                    }
                }
            }
        }else{
            render "no_Seleccione una dirección"
        }
    }


    def delete() {
        def personaRolInstance = PersonaRol.get(params.id)
        if (!personaRolInstance) {
            render "no_No se encontró el registro"
        }

        try {
            personaRolInstance.delete(flush: true)
            render "ok_Borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            render "no_Error al borrar el registro"
        }
    } //delete

    //asignación del director

    def asignarDirector () {
        def listaDireccion = Direccion.list()
        return [listaDireccion: listaDireccion]
    }

} //fin controller