package janus.pac

import janus.PersonaRol

import org.springframework.dao.DataIntegrityViolationException

class OfertaController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        def concurso = Concurso.get(params.id)
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def ofertas = Oferta.findAllByConcurso(concurso, params)
        return [concurso: concurso, ofertaInstanceList: ofertas, params: params]
    } //list

    def form_ajax() {
        def ofertaInstance = new Oferta(params)
        def concurso = Concurso.get(params.concurso)
        if (params.id) {
            ofertaInstance = Oferta.get(params.id)
            if (!ofertaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Oferta con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        else {
//            concurso = Concurso.get(params.cncr)
            ofertaInstance.concurso = concurso
        }

        def responsablesProceso = PersonaRol.withCriteria {
            persona {
                eq("activo", 1)
                order("apellido", "asc")
            }
            funcion {
                eq("codigo", "C")
            }
        }.persona

        return [ofertaInstance: ofertaInstance, responsablesProceso: responsablesProceso, concurso: concurso]
    } //form_ajax

    def save() {
        if (params.fechaEntrega) {
            params.fechaEntrega = new Date().parse('dd-MM-yyyy', params.fechaEntrega)
        }
        if (params.monto) {
            params.monto = params.monto.toDouble()
        }

        params.hoja = (params.hoja ?: 0)

        def ofertaInstance
        if (params.id) {
            ofertaInstance = Oferta.get(params.id)
            if (!ofertaInstance) {
               render "no_No se encontró la oferta "
                return
            }//no existe el objeto
            ofertaInstance.properties = params
        }//es edit
        else {
            ofertaInstance = new Oferta(params)
        } //es create

        if (!ofertaInstance.save(flush: true)) {
            println("error " + ofertaInstance.errors)
           render "no_Error al guardar la oferta"
        }else{
            render "ok_Oferta guardada correctamente"
        }
    } //save

    def show_ajax() {
        def ofertaInstance = Oferta.get(params.id)
        if (!ofertaInstance) {
            redirect(action: "list")
            return
        }
        [ofertaInstance: ofertaInstance]
    } //show

    def delete() {
        def ofertaInstance = Oferta.get(params.id)
        if (!ofertaInstance) {
           render "no_No se encontró la oferta"
            return
        }

        try {
            ofertaInstance.delete(flush: true)
            render "ok_Oferta borrada correctamente"
        }
        catch (DataIntegrityViolationException e) {
            render "no_error al borrar la oferta"
        }
    } //delete
} //fin controller
