package janus.pac

import groovy.json.JsonSlurper
import janus.Contrato

import java.security.MessageDigest


class GarantiaFinancieroController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def conectaGarantias(cntr) {
//        def url = "https://serviciospruebas.pichincha.gob.ec/servicios/api/odoo/garantias/numerocontrato/${cntr}"
        def url = "https://servicios.pichincha.gob.ec/servicios/api/odoo/garantias/numerocontrato/${cntr}"
        def usro = "gochoa"
        def random = 'janus'
        def fecha = new Date()
        def fcha = fecha.format("yyy-MM-dd") + "T" + fecha.format("HH:mm:ss") + "-05:00"
//        def privKey = '808a068b96222be6'
        def privKey = '59e423e9214a1250'
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
//                "'login': '1a93363a83f2a5cfb8ae115d874be5cb'," +
                "'login': '5bdd9a6170161bd492e9eb4c153dce0e'," +
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
                //println(texto.split(',').join('\n'));
                retorna = jsonSlurper.parseText(texto)
                //println "Garantías: ${retorna.listaDatoGarantia.size()}"
                //println "Garantía última: ${retorna.listaDatoGarantia[-1]}"
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

//        println("---> " + retorna)

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
                def existente = GarantiaFinanciero.findByContratoAndIdFinanciero(contrato, it.id)
                def garantia = new GarantiaFinanciero()
                if(existente){
                    garantia = existente
                }else{
                    garantia.idFinanciero = it.id
                    garantia.contrato = contrato
                }

                garantia.numeroGarantia = it.numeroGarantia
                garantia.conceptoGarantia_id = it.conceptoGarantia_id
                garantia.conceptoGarantia = it.conceptoGarantia
                garantia.emisor_id = it.emisor_id
                garantia.emisor = it.emisor
                garantia.tipoGarantia_id = it.tipoGarantia_id
                garantia.tipoGarantia = it.tipoGarantia
                garantia.estado = it.estado
                garantia.fechaGarantia = new Date().parse("yyyy-MM-dd", it.fechaGarantia)
                garantia.desde = new Date().parse("yyyy-MM-dd", it.desde)
                garantia.hasta = new Date().parse("yyyy-MM-dd", it.hasta)
                garantia.monto = it.monto


                if(!garantia.save(flush:true)){
                   println("error al guardar la garantia ")
                }else{
                    println "a grabar: ${garantia}"
                }
            }
        }else{
            println("no existen garantias a guardar")
        }

        return[garantias: resultado?.garantias, contrato: contrato]
    }

    def garantiasContratoFi(){
        def contrato = Contrato.get(params.id)
        def garantias = GarantiaFinanciero.findAllByContrato(contrato)
        return[contrato: contrato, garantias: garantias]
    }
}
