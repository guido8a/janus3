package janus

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona

class AdministradorContratoController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def addAdmin() {
//        println params

        def contrato = Contrato.get(params.contrato)
        def persona = Persona.get(params.admin)
        def desde = new Date().parse("dd-MM-yyyy", params.desde)

        if(!persona){
            render "NO_Seleccione una persona"
            return
        }

        def nuevo = new AdministradorContrato([
                contrato: contrato,
                administrador: persona,
                fechaInicio: desde
        ])
        def admins = AdministradorContrato.findAllByContrato(contrato, [sort: 'fechaInicio', order: "desc"])

        if (admins.size() > 0) {
            def newest = admins.first()

            if (newest.id) {

                if (newest.fechaInicio < desde) {
                    newest.fechaFin = desde - 1
                    if (!newest.save(flush: true)) {
                        println "error al poner fecha fin de newest " + newest + " " + newest.errors
                    }
                } else {

                    def overlap = AdministradorContrato.withCriteria {
                        eq("contrato", contrato)
                        le("fechaInicio", desde)
                        or {
                            ge("fechaFin", desde)
                            isNull("fechaFin")
                        }
                    }

                    if (overlap.size() > 0) {
                        render "NO_No puede asignar con esa fecha de inicio"
                        return
                    }
                    nuevo.fechaFin = newest.fechaInicio - 1
                }
            }
        }
        if (!nuevo.save(flush: true)) {
            println "error al crear nuevo admin: " + nuevo.errors
            render "NO_Error al crear el nuevo administrador"
        }else{
            render "OK"
        }

    }

    def tabla() {
        def contrato = Contrato.get(params.contrato)
        def lista = AdministradorContrato.findAllByContrato(contrato, [sort: "fechaInicio", order: "desc"])
        [administradorContratoInstanceList: lista, params: params]
    }

    def list_ext() {
//        println "parametros .." + params
//        def dptoDireccion = Departamento.findAllByDireccion(janus.Contrato.get(params.contrato).oferta.concurso.obra.departamento.direccion)
        def dptoDireccion = Departamento.findAllByDireccion(janus.Contrato.get(params.contrato).depAdministrador.direccion)
//        println "departamentos... a listar:" + dptoDireccion
        def personal = Persona.findAllByActivoAndDepartamentoInList(1, dptoDireccion, [sort: 'apellido'])
//        println "Personal:" + personal

        [administradorContratoInstanceList: AdministradorContrato.list(params), params: params, personal: personal]
    } //list

    def adminContrato () {
        def contrato = Contrato.get(params.contrato)
        def dptoDireccion = Departamento.get(contrato?.depAdministrador?.id)
        def dptos = Departamento.findAllByDireccion(Direccion.get(dptoDireccion.direccion.id))
//        def personal = Persona.findAllByActivoAndDepartamento(1, dptoDireccion, [sort: 'apellido'])
        def personal = Persona.findAllByActivoAndDepartamentoInList(1, dptos, [sort: 'apellido'])

        [administradorContratoInstanceList: AdministradorContrato.list(params), params: params, personal: personal, contrato: contrato]
    }


    def list() {
        [administradorContratoInstanceList: AdministradorContrato.list(params), params: params]
    } //list

    def form_ajax() {
        def administradorContratoInstance = new AdministradorContrato(params)
        if (params.id) {
            administradorContratoInstance = AdministradorContrato.get(params.id)
            if (!administradorContratoInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Administrador Contrato con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [administradorContratoInstance: administradorContratoInstance]
    } //form_ajax

    def save() {
        def administradorContratoInstance
        if (params.id) {
            administradorContratoInstance = AdministradorContrato.get(params.id)
            if (!administradorContratoInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Administrador Contrato con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            administradorContratoInstance.properties = params
        }//es edit
        else {
            administradorContratoInstance = new AdministradorContrato(params)
        } //es create
        if (!administradorContratoInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Administrador Contrato " + (administradorContratoInstance.id ? administradorContratoInstance.id : "") + "</h4>"

            str += "<ul>"
            administradorContratoInstance.errors.allErrors.each { err ->
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

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Administrador Contrato " + administradorContratoInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Administrador Contrato " + administradorContratoInstance.id
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def administradorContratoInstance = AdministradorContrato.get(params.id)
        if (!administradorContratoInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Administrador Contrato con id " + params.id
            redirect(action: "list")
            return
        }
        [administradorContratoInstance: administradorContratoInstance]
    } //show

    def delete() {
        def administradorContratoInstance = AdministradorContrato.get(params.id)
        if (!administradorContratoInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Administrador Contrato con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            administradorContratoInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Administrador Contrato " + administradorContratoInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Administrador Contrato " + (administradorContratoInstance.id ? administradorContratoInstance.id : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller
