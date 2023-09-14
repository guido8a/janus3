package janus.pac

import janus.EspecialidadProveedor
import seguridad.Persona

import org.springframework.dao.DataIntegrityViolationException

class ProveedorController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def dbConnectionService

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [proveedorInstanceList: Proveedor.list(params).sort{it.nombre}, params: params]
    } //list

    def form_ajax() {
        def proveedorInstance = new Proveedor(params)
        if (params.id) {
            proveedorInstance = Proveedor.get(params.id)
            if (!proveedorInstance) {
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [proveedorInstance: proveedorInstance]
    } //form_ajax

    def form() {
        def proveedorInstance = new Proveedor(params)
        if (params.id) {
            proveedorInstance = Proveedor.get(params.id)
            if (!proveedorInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Proveedor con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [proveedorInstance: proveedorInstance]
    } //form_ajax

    def form_ajax_fo() {
        def proveedorInstance = new Proveedor(params)
        if (params.id) {
            proveedorInstance = Proveedor.get(params.id)
            if (!proveedorInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Proveedor con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [proveedorInstance: proveedorInstance]
    } //form_ajax

    def saveFo() {
        if (params.fechaContacto) {
            params.fechaContacto = new Date().parse('dd-MM-yyyy', params.fechaContacto)
        }
        def proveedorInstance
        if (params.id) {
            proveedorInstance = Proveedor.get(params.id)
            if (!proveedorInstance) {
                println "nop"
                render "NO"
                return
            }//no existe el objeto
            proveedorInstance.properties = params
        }//es edit
        else {
            proveedorInstance = new Proveedor(params)
        } //es create
        if (!proveedorInstance.save(flush: true)) {
            println "error: " + proveedorInstance.errors
            render "NO"
            return
        }
        def sel = g.select(id: "proveedor", name: 'proveedor.id', from: Proveedor.list([sort: 'nombre']), optionKey: "id", optionValue: "nombre", "class": "many-to-one", value: proveedorInstance.id, noSelection: ['null': ''])
        render sel
    }

    def save() {

        def proveedorInstance
        if (params.id) {
            proveedorInstance = Proveedor.get(params.id)
            if (!proveedorInstance) {
                render "no_No se encontró el proveedor"
                return
            }//no existe el objeto

            proveedorInstance.properties = params
        }//es edit
        else {
            params.fechaContacto = new Date()
            proveedorInstance = new Proveedor(params)
        } //es create

        if (!proveedorInstance.save(flush: true)) {
            println("error al guardar el proveedor " + proveedorInstance.errors)
            render "no_Error al guardar el proveedor"
        }else{
            render "ok_Proveedor guardado correctamente"
        }
    } //save

    def show_ajax() {
        def proveedorInstance = Proveedor.get(params.id)
        if (!proveedorInstance) {
            redirect(action: "list")
            return
        }
        [proveedorInstance: proveedorInstance]
    } //show

    def delete() {
        def proveedorInstance = Proveedor.get(params.id)
        if (!proveedorInstance) {
            render "no_Error al borrar el proveedor"
            return
        }

        try {
            proveedorInstance.delete(flush: true)
            render "ok_Proveedor borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            render "no_Error al borrar el proveedor"
        }
    } //delete


    def proveedor(){
        println("params " + params)
        return[adquisicion: params.id]
    }

    def tablaProveedores_ajax(){
        def usuario = Persona.get(session.usuario.id)
        def empresa = usuario.empresa

        println("emrpesa " + empresa.id)

        def tipo = params.campo
        def parametro = ''

        switch(tipo){
            case "1":
                parametro = 'nombre'
                break;
            case "2":
                parametro = 'apellidoContacto'
                break;
            case "3":
                parametro = 'ruc'
                break;
        }

        def data = Proveedor.withCriteria {
            eq("empresa", empresa)

            if(params.busqueda != ''){
                or{
                    ilike(parametro, '%' + params.busqueda + '%')
                }
            }

            order("nombre")
        }

        return[proveedores: data]
    }


    def saveProveedor_ajax(){
        println("params " + params)
        def usuario = Persona.get(session.usuario.id)
        def empresa = usuario.empresa
        def especialidad = EspecialidadProveedor.get(params."especialidad.id")
        def proveedor

        if(params.id){
            proveedor = Proveedor.get(params.id)
        }else{
            proveedor = new Proveedor()
            proveedor.empresa = empresa
            proveedor.fechaContacto = new Date()
        }

        proveedor.especialidad = especialidad
        proveedor.tipo = params."tipo.id"
        proveedor.properties = params

        if(!proveedor.save(flush:true)){
            println("error al guardar el proveedor " + proveedor.errors)
            render "no"
        }else{
            render "ok"
        }
    }

    def borrarProveedor_ajax(){
        def proveedor = Proveedor.get(params.id)

        try{
            proveedor.delete(flush:true)
            render "ok"
        }catch(e){
            println("error al borrar el proveedor " + proveedor.errors)
            render "no"
        }
    }

    def tablaProveedores2_ajax(){
        def listaItems = ['prve_ruc', 'prvenmbr']
        def bsca
        def sqlTx = ""

        if(params.buscarPor){
            bsca = listaItems[params.buscarPor?.toInteger()-1]
        }else{
            bsca = listaItems[0]
        }
        def select = "select * from prve "
        def txwh = " where prve__id  is not null and " +
                " $bsca ilike '%${params.criterio}%' "
        sqlTx = "${select} ${txwh} order by prvenmbr ".toString()
//        println "sql: $sqlTx"
        def cn = dbConnectionService.getConnection()
        def datos = cn.rows(sqlTx)

        [datos: datos]
    }



} //fin controller
