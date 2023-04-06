package janus

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona

class AsignarCoordinadorController {

    def index() {}

    def getDepartamento () {
        def direccion = Direccion.get(params.id)
        def departamento = Departamento.findAllByDireccion(direccion)
        return[departamento: departamento, id: params.id]
    }

    def asignarCoordinador () {
    }

    def getPersonas () {
        def departamento = Departamento.get(params.id)
        def personas

        if (departamento != null ){
            personas = Persona.findAllByDepartamento(departamento)
        }else {
            personas = []
        }
        return [personas: personas]
    }

    def sacarFunciones () {
        def departamento = Departamento.get(params.id)
        def personas = Persona.findAllByDepartamento(departamento, [sort: 'nombre'])
        def funcion = Funcion.get(10)
        def roles = PersonaRol.findAllByPersonaInListAndFuncion(personas, funcion )
        render roles.size()
    }

    def grabarFuncion () {
//        println("params " + params)

        def funcion = Funcion.get(10)

        if(params.direccion != '-1'){
            if(params.departamento){
                if(params.id){
                    def departamento = Departamento.get(params.departamento)
                    def persona = Persona.get(params.id)
                    def personasDepartamento = Persona.findAllByDepartamento(departamento)
                    def existeCoordinador

                    if(personasDepartamento.size() > 0){
                        existeCoordinador  = PersonaRol.findAllByPersonaInListAndFuncion(personasDepartamento, funcion)
                    }else{
                        existeCoordinador = []
                    }

                    if(existeCoordinador.size() > 0){
                        render "no_El departamento ya posee un coordinador asignado"
                        return true
                    }else{

                        def personaRol = new PersonaRol()
                        personaRol.persona = Persona.get(params.id)
                        personaRol.funcion = funcion

                        if (!personaRol.save([flush: true])) {
                            render "no_Error al asignar el coordinador"
                            println "ERROR al asignar el coordinador : "+personaRol.errors
                        } else {
                            render "ok_Asignado correctamente"
                        }
                    }

                }else{
                    render "no_Seleccione una persona"
                }
            }else{
                render "no_Seleccione un departamento"
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

    def obtenerFuncionCoor () {
        def persona = Persona.get(params.id);
        def funcion = Funcion.get(10)
        def rol = PersonaRol.findByPersonaAndFuncion(persona, funcion)
        return [persona: persona, rol: rol]
    }

    def mensajeCoordinador () {
        def departamento = Departamento.get(params.id)
        def personas

        if(departamento != null){
            personas = Persona.findAllByDepartamento(departamento)
        }else{
            personas = []
        }

        def funcionCoor = Funcion.get(10)

        def getCoordinador

        if(personas != []){
            getCoordinador = PersonaRol.findByFuncionAndPersonaInList(funcionCoor, personas)
        }else {
            getCoordinador = null
        }

        return [personas: personas, getCoordinador: getCoordinador, id: params.id]
    }

}