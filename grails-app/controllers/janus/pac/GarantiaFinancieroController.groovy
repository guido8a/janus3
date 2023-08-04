package janus.pac

import groovy.json.JsonSlurper
import janus.Contrato

import java.security.MessageDigest


class GarantiaFinancieroController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def conectaGarantias(cntr) {
        def url = "https://serviciospruebas.pichincha.gob.ec/servicios/api/odoo/garantias/numerocontrato/${cntr}"
        def usro = "gochoa"
        def random = 'janus'
        def fecha = new Date()
        def fcha = fecha.format("yyy-MM-dd") + "T" + fecha.format("HH:mm:ss") + "-05:00"
        def privKey = '808a068b96222be6'
        def random64 = Base64.getEncoder().encodeToString(random.getBytes())
        def clave = Base64.getEncoder().encodeToString('GADPP/*1406'.getBytes())
        println "rand: $random64, clave: $clave"
        def passp = random + fcha + privKey
        MessageDigest ms_sha1 = MessageDigest.getInstance("SHA1")

        byte[] digest = ms_sha1.digest(passp.getBytes())
        def key = digest.encodeBase64()
        println "key: ${digest.encodeBase64()}"

        def conecta = false
        def retorna = ""
        def post = new URL(url).openConnection();
        def message = "{'identidadWs':  {" +
                "'login': '1a93363a83f2a5cfb8ae115d874be5cb'," +
                "'currentTime': '${fcha}'," +
                "'random': 'amFudXM='," +
                "'key': '${key}'," +
                "'user': '${usro}'," +
                "'moduleCode': 'SEP-P02'}}"

        message = message.replace("'", '"')
        println "$message"
        try {
            post.setRequestMethod("POST")
            post.setDoOutput(true)
            post.setRequestProperty("Content-Type", "application/json")
            post.getOutputStream().write(message.getBytes("UTF-8"));
            def postRC = post.getResponseCode();

            println "responde: ${postRC}"
            println "responde2: ${post.getResponseMessage()}"

            def jsonSlurper = new JsonSlurper()
            if (postRC.equals(200)) {
                def texto = post.getInputStream().getText()
                println(texto.split(',').join('\n'));
                retorna = jsonSlurper.parseText(texto)
                println "Garantías: ${retorna.listaDatoGarantia.size()}"
                println "Garantía última: ${retorna.listaDatoGarantia[-1]}"
                conecta = retorna.autorizado

//                render("Existen: ${retorna.listaDatoGarantia.size()} garatías, <br>" +
//                        "Garantías: ${retorna.listaDatoGarantia}")
//                render(${retorna.listaDatoGarantia})
//                return
            }
        } catch (e) {
            println "no conecta ${usro} error: " + e
        }

//        return conecta
//        render("<hr>Error - No existen datos de garantías del contrato $cntr")
//        render "no_No existen datos de garantías del contrato $cntr"

        println("---> " + retorna)

        return[garantias : (retorna ?  retorna?.listaDatoGarantia : null)]

    }

    def garantia_ajax () {
        def contrato = Contrato.get(params.contrato)
//        def resultado = conectaGarantias("39-DCP-2022")
        def resultado = conectaGarantias(contrato.codigo)

        if(resultado?.garantias?.size() > 0){
//            println("garantias " + resultado?.garantias)

            resultado?.garantias?.each{
//                println("--> " + it)
                def existente = GarantiaFinanciero.findById(it.id)
                if(existente){
                    try{
                        existente.delete(flush:true)
                    }catch(e){
                        println("error al borrar la garantia existente " + existente.errors)
                    }
                }

                def garantia = new GarantiaFinanciero()
                garantia.id = it.id
                garantia.contrato = contrato.id.toInteger()
                garantia.numeroGarantia = it.numeroGarantia
                garantia.conceptoGarantia_id = it.conceptoGarantia_id
                garantia.conceptoGarantia = it.conceptoGarantia
                garantia.emisor_id = it.emisor_id
                garantia.emisor = it.emisor
                garantia.tipoGarantia_id = it.tipoGarantia_id
                garantia.tipoGarantia = it.tipoGarantia
                garantia.estado = it.estado
                garantia.fechaGarantia = new Date().parse("dd-MM-yyyy",it.fechaGarantia)
                garantia.desde = new Date().parse("dd-MM-yyyy",it.desde)
                garantia.hasta = new Date().parse("dd-MM-yyyy",it.hasta)
                garantia.monto = it.monto

                try{
                    garantia.save(flush:true)
                }catch(e){
                    println("error al guardar la garantia existente " + garantia.errors)
                }

//                if(!garantia.save(flush: true)){
//                    println("error al guardar la nueva garantia " + garantia.errors)
//                }else{
//                    println("garantia ${it.id} guardada correctamente")
//                }

            }
        }else{
            println("no existen garantias a guardar")
        }

        return[garantias: resultado?.garantias, contrato: contrato]
    }
}
