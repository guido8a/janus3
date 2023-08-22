package janus

import seguridad.Prfl
import seguridad.Sesn
import seguridad.Persona

import org.springframework.dao.DataIntegrityViolationException

class PersonaController_2 {

    def dbConnectionService

    def checkUniqueUser() {
//        println params
        if (params.id) {
//            println "EDIT"
            def user = Persona.get(params.id)
            if (user.login.trim() == params.login.trim()) {
//                println "1"
                render true
            } else {
                def users = Persona.countByLogin(params.login.trim())
                if (users == 0) {
//                    println "2"
                    render true
                } else {
//                    println "3"
                    render false
                }
            }
        } else {
//            println "CREATE"
            def users = Persona.countByLogin(params.login.trim())
            if (users == 0) {
//                println "4"
                render true
            } else {
//                println "5"
                render false
            }
        }
    }

    def checkUniqueCi() {
//        println params
        if (params.id) {
//            println "EDIT"
            def user = Persona.get(params.id)
            if (user.cedula.trim() == params.cedula.trim()) {
//                println "1"
                render true
            } else {
                def users = Persona.countByCedula(params.cedula.trim())
                if (users == 0) {
//                    println "2"
                    render true
                } else {
//                    println "3"
                    render false
                }
            }
        } else {
//            println "CREATE"
            def users = Persona.countByCedula(params.cedula.trim())
            if (users == 0) {
//                println "4"
                render true
            } else {
//                println "5"
                render false
            }
        }
    }

    def checkUserPass() {
        if (params.id) {
            def user = Persona.get(params.id)
            if (user.password == params.passwordAct.trim().encodeAsMD5()) {
                render true
            } else {
                render false
            }
        } else {
            render false
        }
    }

    def checkUserAuth() {
//        println params
        if (params.id) {
//            println "EDIT"
            def user = Persona.get(params.id)
            if (user.autorizacion == params.autorizacionAct.trim().encodeAsMD5()) {
//                println "1"
                render true
            } else {
                render false
            }
        } else {
            render false
        }
    }

    def pass_ajax() {
        def usroInstance = Persona.get(params.id)
        if (!usroInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Persona con id " + params.id
            redirect(action: "list")
            return
        }
        [usroInstance: usroInstance]
    } //pass

    def passOferente() {
        def usroInstance = Persona.get(params.id)
        if (!usroInstance) {
            redirect(action: "listOferente")
            return
        }
        [usroInstance: usroInstance]
    }

    def savePass() {
//        println params

        def user = Persona.get(params.id)

        if (params.password.trim() != "") {
            user.password = params.password.trim().encodeAsMD5()
        }

        if(!user.save(flush: true)) {
            println("error al actualizar el password de oferentes " + user.errors)
            render "no_Error al actualizar el password del oferente"
        } else {
          render "ok_Guardado correctamente"
        }
    }

    def index() {
        redirect(action: "list", params: params)
    } //index


    def cambiarEstado() {
        def persona = Persona.get(params.id)

        if (persona.activo == 0) {
            persona.activo = 1
        } else {
            persona.activo = 0
        }

        if (!persona.save(flush: true)) {
            println("Error al cambiar el estado del oferente " + persona.errors)
            render "no_Error al cambiar el estado del oferente"
        } else {
            render "ok_Estado cambiando correctamente"
        }
    }

    def list() {
        println("params list " + params)
        /* departamento de OFERENTES: id = 13 */
        def departamento = Departamento.get(13)
        def personaList = Persona.findAllByDepartamentoNotEqual(departamento,[sort: 'apellido'])

        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [personaInstanceList: Persona.list(params), personaInstanceCount: personaList.size(), params: params]
    } //list

    def listOferente() {
        def perfil = Prfl.findByCodigo("OFRT")
        [params: params, sesion: Sesn.findAllByPerfil(perfil).sort{it.usuario.apellido}]
    }

    def form_ajax() {

        def perfilOferente = Prfl.get(4);

        def personaInstance = new Persona(params)
        if (params.id) {
            personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Persona con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [personaInstance: personaInstance, perfilOferente: perfilOferente]
    } //form_ajax

    def formUsuario_ajax() {
        def personaInstance = new Persona(params)
        if (params.id) {
            personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                notFound_ajax()
                return
            }
        }
        return [personaInstance: personaInstance]
    }


    def formOferente() {
        println "....123"
        def personaInstance = new Persona(params)
        if (params.id) {
            personaInstance = Persona.get(params.id)
            if (!personaInstance) {

                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [personaInstance: personaInstance]
    }


    def save() {
//        println "params "+params
//        println("password:-->>" + params.password)
//        println("password2:-->>" + params.password.encodeAsMD5())
//        println("password3:-->>" + Persona.get(params.id).password)

        def personaInstance

        if (params.fechaInicio) {
            params.fechaInicio = new Date().parse("dd-MM-yyyy", params.fechaInicio)
        }
        if (params.fechaFin) {
            params.fechaFin = new Date().parse("dd-MM-yyyy", params.fechaFin)
        }
        if (params.fechaNacimiento) {
            params.fechaNacimiento = new Date().parse("dd-MM-yyyy", params.fechaNacimiento)
        }
        if (params.fechaPass) {
            params.fechaPass = new Date().parse("dd-MM-yyyy", params.fechaPass)
        }

        if (params.password && params.id) {

//            println(params.password.encodeAsMD5())
//            println(Persona.get(params.id).password)

            if ((params.password) == Persona.get(params.id).password) {

                params.password = Persona.get(params.id).password

//                println("entro")
            } else {

                params.password = params.password.encodeAsMD5()
//                println("entro1")
            }
        } else {

            params.password = params.password.encodeAsMD5()

        }



        if (params.autorizacion) {
            params.autorizacion = params.autorizacion.encodeAsMD5()
        }




        if (params.id) {
            personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Persona con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            personaInstance.properties = params
        }//es edit
        else {
            personaInstance = new Persona(params)
        } //es create
        if (!personaInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Persona " + (personaInstance.id ? personaInstance.nombre + " " + personaInstance.apellido : "") + "</h4>"

            str += "<ul>"
            personaInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex { arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(action: 'list')
            return
        }

        //perfiles q llegaron como parametro
        def perfilesNue = params.perfiles


        if (perfilesNue) {

            if (perfilesNue.class == java.lang.String) {

                perfilesNue = [perfilesNue]

            }


        }
        def perfiles = Sesn.findAllByUsuario(personaInstance)
//        println "perfile nue "+perfilesNue
//        println "!!!  "+perfiles.perfil.id


        def borrar = true


        perfilesNue.each {
            def perfil = seguridad.Prfl.get(it)
            def ses = seguridad.Sesn.findByUsuarioAndPerfil(personaInstance, perfil)
            if (!ses) {
                ses = new seguridad.Sesn([usuario: personaInstance, perfil: perfil])
                println "grabando " + it
                ses.save(flush: true)
            }

        }
        for (int i = perfiles.size() - 1; i > -1; i--) {
            perfilesNue.each { pn ->
                println "pn " + pn + "   " + perfiles[i].perfil.id.toInteger()
                if (pn.toInteger() == perfiles[i].perfil.id.toInteger()) {
                    borrar = false
                }
            }
            if (borrar) {
                println "borrando " + perfiles[i]
                def per = perfiles[i]
                perfiles.remove(i)
                per.delete(flush: true)

            } else {
                borrar = true
            }
//            if(!perfilesNue.contains(perfiles[i].perfil.id.toString())) {
//                println "borrando "+perfiles[i]
//                perfiles[i].delete(flush: true)
//            }
        }




        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Persona " + personaInstance.nombre + " " + personaInstance.apellido
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Persona " + personaInstance.nombre + " " + personaInstance.apellido
        }
        redirect(action: 'list')
    } //save


    def saveOferente() {
//        println "Save oferente: " + params
        if (params.fechaInicio) {
            params.fechaInicio = new Date().parse("dd-MM-yyyy", params.fechaInicio)
        }
        if (params.fechaFin) {
            params.fechaFin = new Date().parse("dd-MM-yyyy", params.fechaFin)
        }

        if (params.password) {
            params.password = params.password.encodeAsMD5()
        }
        if (params.autorizacion) {
            params.autorizacion = params.autorizacion.encodeAsMD5()
        }
        params.sexo="M"
        def personaInstance


        if (params.id) {
            personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                render "no_No se encontró la persona"
                return
            }//no existe el objeto
        }//es edit
        else {
            personaInstance = new Persona(params)
            personaInstance.departamento = Departamento.get(13);
        } //es create

        personaInstance.properties = params


        if (!personaInstance.save(flush: true)) {
            println("error al guardar el oferente " + personaInstance.errors)
            render "no_Error al guardar el oferente"
        }else{
            //le asigna perfil oferente si no tiene perfil
            def perfilOferente = Prfl.findByCodigo("OFRT")
            def sesiones = Sesn.findAllByUsuario(personaInstance)
            if (sesiones.size() == 0) {
                def sesn = new Sesn()
                sesn.perfil = perfilOferente
                sesn.usuario = personaInstance
                if (!sesn.save(flush: true)) {
                    println "error al grabar sesn perfil: " + perfilOferente + " persona " + personaInstance.id
                    render "no_Error al guardar el perfil de oferente"
                } else {
                    println "Asignacion OK"
                    render "ok_Oferente guardado correctamente"
                }
            }else{
                render "ok_Oferente guardado correctamente"
            }
        }
    } //save


    def show_ajax() {
        def personaInstance = Persona.get(params.id)
        if (!personaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Persona con id " + params.id
            redirect(action: "list")
            return
        }
        [personaInstance: personaInstance]
    } //show


    def showOferente() {
        def personaInstance = Persona.get(params.id)
        if (!personaInstance) {
            redirect(action: "listOferente")
            return
        }
        [personaInstance: personaInstance]
    }

    def delete() {
        def personaInstance = Persona.get(params.id)
        if (!personaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Persona con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            personaInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Persona " + personaInstance.nombre + " " + personaInstance.apellido
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Persona " + (personaInstance.id ? personaInstance.nombre + " " + personaInstance.apellido : "")
            redirect(action: "list")
        }
    } //delete

    def tablaUsuarios_ajax(){
        println "tablaUsuarios_ajax params $params"
        def datos;
        def sqlTx = ""
        def listaItems = ['prsnlogn', 'prsnnmbr', 'prsnapll' ]
        def estados = ['%', '1', '0']
        def bsca
        def perfil = params.perfil == 'null'? '%' : params.perfil
        def dpto = params.departamento == 'null'? '%' : params.departamento

        if(params.buscarPor){
            bsca = listaItems[params.buscarPor?.toInteger()-1]
        }else{
            bsca = listaItems[0]
        }

        def select = "select distinct prsn.* from prsn, sesn"
        def txwh = " where dpto__id != 13 and prsn.dpto__id::text ilike '${dpto}' and " +
                "sesn.prfl__id::text ilike '${perfil}' and sesn.prsn__id = prsn.prsn__id and " +
                " $bsca ilike '%${params.criterio}%' and prsnactv::text ilike '${estados[params.estado.toInteger()-1]}' and " +
                "sesnfcfn is null "
        sqlTx = "${select} ${txwh} order by prsnapll limit 50 ".toString()
        println "sql: $sqlTx"
        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
        [data: datos, tipo: params.tipo]
    }

} //fin controller
