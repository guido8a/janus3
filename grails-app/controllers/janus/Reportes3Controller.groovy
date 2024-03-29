package janus

import com.lowagie.text.Document
import com.lowagie.text.Element
import com.lowagie.text.PageSize
import com.lowagie.text.Paragraph
import com.lowagie.text.Font
import com.lowagie.text.pdf.PdfPCell
import com.lowagie.text.pdf.PdfPTable
import com.lowagie.text.pdf.PdfWriter
import janus.actas.Acta
import janus.pac.EstadoGarantia
import janus.pac.Garantia
import jxl.Workbook
import jxl.WorkbookSettings
import jxl.write.*

import java.awt.*
import java.text.DecimalFormat

//import java.awt.Font
//import java.awt.*
class Reportes3Controller {

    def preciosService


    def meses = ['', "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]

    private String printFecha(Date fecha) {
        if (fecha) {
            return (fecha.format("dd")+' de '+ meses[fecha.format("MM").toInteger()]+' de '+fecha.format("yyyy")).toUpperCase()
        } else {
            return "Error: no hay fecha que mostrar"
        }
    }

    def index() {}

    def test() {
        return [params: params]
    }

    def _imprimirTablaSub() {
//        println "imprimir tabla sub "+params
        def obra = Obra.get(params.obra)
        def detalle
        def valores
        def subPre
        def fechaNueva = obra?.fechaCreacionObra?.format("dd-MM-yyyy");
        def fechaPU = (obra?.fechaPreciosRubros?.format("dd-MM-yyyy"));
        def auxiliar = Auxiliar.get(1);

        if (params.sub != '-1'){
            subPre= SubPresupuesto.get(params.sub).descripcion
        }else {
            subPre= -1
        }

        if (params.sub)
            if (params.sub == '-1'){
                valores = preciosService.rbro_pcun_v2(obra?.id)
            }else {
               valores = preciosService.rbro_pcun_v3(obra?.id, params.sub)
            }
        else
            valores = preciosService.rbro_pcun_v2(obra.id)

        def nombres = []
        def corregidos = []
        def prueba = []
        valores.each {
            nombres += it.rbronmbr
        }

        nombres.each {
            def text = (it ?: '')
            text = text.decodeHTML()
            text = text.replaceAll(/</, /&lt;/);
            text = text.replaceAll(/>/, /&gt;/);
            text = text.replaceAll(/"/, /&quot;/);
             corregidos += text
        }

        valores.eachWithIndex{ j,i->
            j.rbronmbr = corregidos[i]
        }

        valores.each {
            prueba += it.rbronmbr
        }

        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
        def precios = [:]
        def indirecto = obra.totales / 100
        preciosService.ac_rbroObra(obra.id)

        renderPdf(template:'/reportes3/imprimirTablaSub', model: [detalle: detalle, precios: precios, subPres: subPres, subPre: subPre, obra: obra, indirectos: indirecto * 100, valores: valores, fechaNueva: fechaNueva, fechaPU: fechaPU, corregidos: corregidos, auxiliar: auxiliar], filename: 'subpresupuesto.pdf')
    }

    def _imprimirTablaSubVae () {
        def obra = Obra.get(params.obra)

        def detalle
        def valores
        def subPre
        def fechaNueva = obra?.fechaCreacionObra?.format("dd-MM-yyyy");
        def fechaPU = (obra?.fechaPreciosRubros?.format("dd-MM-yyyy"));

        if (params.sub != '-1'){
            subPre= SubPresupuesto.get(params.sub).descripcion
        }else {
            subPre= -1
        }

        if (params.sub)
            if (params.sub == '-1'){
                valores = preciosService.rbro_pcun_vae(obra?.id)
            }else {
                valores = preciosService.rbro_pcun_vae2(obra?.id, params.sub)
            }
        else
            valores = preciosService.rbro_pcun_vae(obra.id)

        def nombres = []
        def corregidos = []
        def prueba = []
        valores.each {
            nombres += it.rbronmbr
        }

        nombres.each {
            def text = (it ?: '')
            text = text.decodeHTML()
            text = text.replaceAll(/</, /&lt;/);
            text = text.replaceAll(/>/, /&gt;/);
            text = text.replaceAll(/"/, /&quot;/);
            corregidos += text
        }


        valores.eachWithIndex{ j,i->
            j.rbronmbr = corregidos[i]
        }

        valores.each {
            prueba += it.rbronmbr
        }

        println("valores " + valores)

        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
        def precios = [:]
        def indirecto = obra.totales / 100
        preciosService.ac_rbroObra(obra.id)

        renderPdf(template:'/reportes3/imprimirTablaSubVae', model: [detalle: detalle, precios: precios, subPres: subPres, subPre: subPre, obra: obra, indirectos: indirecto * 100, valores: valores, fechaNueva: fechaNueva, fechaPU: fechaPU, corregidos: corregidos], filename: 'subpresupuestoVae.pdf')


    }

    def imprimirRubroVolObra() {

        def obra = Obra.get(params.obra)
        def fecha1
        def fecha2

        if(params.fecha){
            fecha1 = new Date().parse("dd-MM-yyyy", params.fecha)
        }else {
        }

        if(params.fechaSalida){
            fecha2 = new Date().parse("dd-MM-yyyy", params.fechaSalida)
        }else {
        }

        def fechaPal = printFecha(new Date());
        def vol1 = VolumenesObra.get(params.id)
        def rubro = Item.get(vol1.item.id)
        def indi = obra.totales

        try {
            indi = indi.toDouble()
        } catch (e) {
            println "error parse " + e
            indi = 21.5
        }

        preciosService.ac_rbroObra(obra.id)
        def res = preciosService.precioUnitarioVolumenObraAsc("*", obra.id, rubro.id)
//        def vae = preciosService.vae_rb(obra.id,rubro.id)
//        println("vae " + vae)
        def tablaHer = '<table class=""> '
        def tablaMano = '<table class=""> '
        def tablaMat = '<table class=""> '
        def tablaTrans = '<table class=""> '
        def tablaIndi = '<table class="marginTop"> '
        def tablaMat2 = '<table class="marginTop"> '
        def tablaTrans2 = '<table class="marginTop"> '

        def total = 0, totalHer = 0, totalMan = 0, totalMat = 0, totalHerRel = 0, totalHerVae = 0, totalManRel = 0, totalManVae = 0, totalMatRel = 0, totalMatVae = 0, totalTRel=0, totalTVae=0
        def band = 0
        def bandMat = 0
        def bandTrans = params.desglose

        tablaHer += "<thead><tr><th colspan='7' class='tituloHeader'>EQUIPOS</th></tr><tr><th colspan='7' class='theader'></th></tr><tr><th style='width: 80px' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>CANTIDAD</th><th style='width:70px'>TARIFA(\$/H)</th><th>COSTO(\$)</th><th>RENDIMIENTO</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='7' class='theaderup'></th></tr> </thead><tbody>"
        tablaMano += "<thead><tr><th colspan='7' class='tituloHeader'>MANO DE OBRA</th></tr><tr><th colspan='7' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>CANTIDAD</th><th style='width:70px'>JORNAL(\$/H)</th><th>COSTO(\$)</th><th>RENDIMIENTO</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='7' class='theaderup'></th></tr> </thead><tbody>"
        if(params.desglose == '1'){
            tablaMat += "<thead><tr><th colspan='6' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='6' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>CANTIDAD</th><th>UNITARIO(\$)</th><th>C.TOTAL(\$)</th></tr> <tr><th colspan='6' class='theaderup'></th></tr> </thead><tbody>"
        } else {
            tablaMat += "<thead><tr><th colspan='6' class='tituloHeader'>MATERIALES INCLUIDO TRANSPORTE</th></tr><tr><th colspan='6' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>CANTIDAD</th><th>UNITARIO(\$)</th><th>C.TOTAL(\$)</th></tr> <tr><th colspan='6' class='theaderup'></th></tr> </thead><tbody>"
        }
        tablaTrans += "<thead><tr><th colspan='8' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='8' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>PES/VOL</th><th>CANTIDAD</th><th>DISTANCIA</th><th>TARIFA</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='8' class='theaderup'></th></tr> </thead><tbody>"
        tablaTrans2 += "<thead><tr><th colspan='8' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='8' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>PES/VOL</th><th>CANTIDAD</th><th>DISTANCIA</th><th>TARIFA</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='8' class='theaderup'></th></tr> </thead><tbody>"
        tablaMat2 += "<thead><tr><th colspan='6' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='6' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>CANTIDAD</th><th>UNITARIO(\$)</th><th>C.TOTAL(\$)</th></tr> <tr><th colspan='6' class='theaderup'></th></tr> </thead><tbody>"

        res.eachWithIndex { r, i ->
            def tx = r.itemnmbr
            tx = tx.replaceAll(/&QUOT/, /&quot/)

            if (r["grpocdgo"] == 3) {
                tablaHer += "<tr>"
                tablaHer += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                tablaHer += "<td>" + r["itemnmbr"] + "</td>"
                tablaHer += "<td>" + tx + "</td>"
                tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                totalHer += r["parcial"]
                tablaHer += "</tr>"
            }
            if (r["grpocdgo"] == 2) {
                tablaMano += "<tr>"
                tablaMano += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                tablaMano += "<td>" + r["itemnmbr"] + "</td>"
                tablaMano += "<td>" + tx + "</td>"
                tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                totalMan += r["parcial"]
                tablaMano += "</tr>"
            }
            if (r["grpocdgo"] == 1) {
                bandMat=1
                if (params.desglose == '1') {
                    tablaMat += "<tr>"
                    tablaMat += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                    tablaMat += "<td>" + r["itemnmbr"] + "</td>"
                    tablaMat += "<td>" + tx + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + r["unddcdgo"] + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + r["parcial"] + "</td>"
                    totalMat += r["parcial"]
                    tablaMat += "</tr>"
                }
//                if (params.desglose != '1') {
                else{
                    tablaMat += "<tr>"
                    tablaMat += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                    tablaMat += "<td>" + r["itemnmbr"] + "</td>"
                    tablaMat += "<td>" + tx + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + r["unddcdgo"] + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: (r["rbpcpcun"] + r["parcial_t"] / r["rbrocntd"]), format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: (r["parcial"] + r["parcial_t"]), format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                     totalMat += (r["parcial"] + r["parcial_t"])
                    tablaMat += "</tr>"
                }
            }
            if (r["grpocdgo"] == 1 && params.desglose == "1") {
                tablaTrans += "<tr>"
                tablaTrans += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                tablaTrans += "<td>" + r["itemnmbr"] + "</td>"
                tablaTrans += "<td>" + tx + "</td>"
                if(r["tplscdgo"].trim() =='P' || r["tplscdgo"].trim() =='P1' ){
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + "ton-km" + "</td>"
                } else{
                    if(r["tplscdgo"].trim() =='V' || r["tplscdgo"].trim() =='V1' || r["tplscdgo"].trim() =='V2'){
                        tablaTrans += "<td style='width: 50px;text-align: right'>" + "m3-km" + "</td>"
                    }
                    else {
                        tablaTrans += "<td style='width: 50px;text-align: right'>" + r["unddcdgo"] + "</td>"
                    }
                }
                tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["itempeso"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["distancia"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["tarifa"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial_t"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                total += r["parcial_t"]
                tablaTrans += "</tr>"
            }
            else {
            }
        }
        tablaTrans += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: total, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
        tablaTrans += "</tbody></table>"
        tablaHer += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalHer, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
        tablaHer += "</tbody></table>"
        tablaMano += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMan, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
        tablaMano += "</tbody></table>"
        tablaMat += "<tr><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMat, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
        tablaMat += "</tbody></table>"
        tablaTrans2 += "</tbody></table>"
        tablaMat2 += "</tbody></table>"


        def totalRubro = total + totalHer + totalMan + totalMat
        totalRubro = totalRubro.toDouble().round(5)

        band = total

        def totalIndi = totalRubro * indi / 100
        totalIndi = totalIndi.toDouble().round(5)
        tablaIndi += "<thead><tr><th class='tituloHeader'>COSTOS INDIRECTOS</th></tr><tr><th colspan='3' class='theader'></th></tr><tr><th style='width:550px' class='padTopBot'>DESCRIPCIÓN</th><th style='width:130px'>PORCENTAJE</th><th>VALOR</th></tr>    <tr><th colspan='3' class='theaderup'></th></tr>  </thead>"
        tablaIndi += "<tbody><tr><td>COSTOS INDIRECTOS</td><td style='text-align:center'>${indi}%</td><td style='text-align:right'>${g.formatNumber(number: totalIndi, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5")}</td></tr></tbody>"
        tablaIndi += "</table>"


        if (total == 0)
            tablaTrans = ""
//        if (totalHer == 0)
//            tablaHer = ""
        if (totalMan == 0)
            tablaMano = ""
        if (totalMat == 0)
            tablaMat = ""
//        println "fin reporte rubro"
        [rubro: rubro, fechaPrecios: fecha1, tablaTrans: tablaTrans, tablaTrans2: tablaTrans2, band:  band, tablaMat2: tablaMat2, bandMat: bandMat,
                bandTrans: bandTrans, tablaHer: tablaHer, tablaMano: tablaMano, tablaMat: tablaMat, tablaIndi: tablaIndi, totalRubro: totalRubro, totalIndi: totalIndi, fechPal: fechaPal, fechaSalida: fecha2, obra: obra]


    }



    def imprimirRubroVolObraVae() {

        def obra = Obra.get(params.obra)

        def fecha1
        def fecha2

        if(params.fecha){
            fecha1 = new Date().parse("dd-MM-yyyy", params.fecha)
        }else {
        }

        if(params.fechaSalida){
            fecha2 = new Date().parse("dd-MM-yyyy", params.fechaSalida)
        }else {
        }

        def fechaPal = printFecha(new Date());
        def vol1 = VolumenesObra.get(params.id)
        def rubro = Item.get(vol1.item.id)
        def indi = obra.totales

        try {
            indi = indi.toDouble()
        } catch (e) {
            println "error parse " + e
            indi = 21.5
        }

        preciosService.ac_rbroObra(obra.id)
        def res = preciosService.precioUnitarioVolumenObraAsc("*", obra.id, rubro.id)
        def vae = preciosService.vae_rb(obra.id,rubro.id)

//        println("vae " + vae)

        def tablaHer = '<table style="width:950px" class=""> '
        def tablaMano = '<table style="width:950px" class=""> '
        def tablaMat = '<table style="width:950px" class=""> '
        def tablaTrans = '<table style="width:950px" class=""> '
        def tablaIndi = '<table class="marginTop" style="width:663px"> '

        def tablaMat2 = '<table style="width:950px" class="marginTop"> '
        def tablaTrans2 = '<table style="width:950px" class="marginTop"> '


        def total = 0, totalHer = 0, totalMan = 0, totalMat = 0, totalHerRel = 0, totalHerVae = 0, totalManRel = 0, totalManVae = 0, totalMatRel = 0, totalMatVae = 0, totalTRel=0, totalTVae=0
        def band = 0
        def bandMat = 0
        def bandTrans = params.desglose

        tablaHer += "<thead><tr><th colspan='12' class='tituloHeader'>EQUIPOS</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th> <th style='width:60px'>CANTIDAD</th><th style='width:60px'>TARIFA(\$/H)</th><th style='width:60px'>COSTO(\$)</th><th style='width:60x'>RENDIMIENTO</th><th style='width:50px'>C.TOTAL(\$)</th><th style='width:60px;text-align: center'>PESO RELAT(%)</th><th style='width:60px; text-align: center'>CPC</th><th style='width:45px;text-align: center'>NP/EP/  ND</th><th style='width:60px;text-align: right'>VAE(%)</th><th style='width:60px; text-align: center'>VAE(%) ELEMENTO</th></tr>  <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
        tablaMano += "<thead><tr><th colspan='12' class='tituloHeader'>MANO DE OBRA</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width:60px'>CANTIDAD</th><th style='width:60px'>JORNAL(\$/H)</th><th style='width:60px'>COSTO(\$)</th><th style='width:60px'>RENDIMIENTO</th><th style='width:50px'>C.TOTAL(\$)</th><th style='width:60px; text-align: center'>PESO RELAT(%)</th><th style='width:60px; text-align: center'>CPC</th><th style='width:45px;text-align: center'>NP/EP/  ND</th><th style='width:60px;text-align: right'>VAE(%)</th><th style='width:60px; text-align: center'>VAE(%) ELEMENTO</th></tr>  <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"

        if(params.desglose == '1'){
            tablaMat += "<thead><tr><th colspan='12' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width: 60px;'></th><th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>UNITARIO(\$)</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px; text-align: center'>PESO RELAT(%)</th><th style='width: 60px; text-align: center'>CPC</th><th style='width: 15px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width:45px;text-align: center'>VAE(%) ELEMENTO</th></tr>  <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
        } else {
            tablaMat += "<thead><tr><th colspan='12' class='tituloHeader'>MATERIALES INCLUIDO TRANSPORTE</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th></th> <th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>UNITARIO(\$)</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;text-align: center'>PESO RELAT(%)</th><th style='width: 60px; text-align: center'>CPC</th><th style='width: 15px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px; text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
        }
        tablaTrans += "<thead><tr><th colspan='13' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='13' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>PES/VOL</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>DISTANCIA</th><th style='width: 60px;'>TARIFA</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;text-align: center'>PESO RELAT(%)</th><th style='width: 60px; text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px; text-align: right'>VAE(%)</th><th style='width: 45px;  text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='13' class='theaderup'></th></tr> </thead><tbody>"
        tablaTrans2 += "<thead><tr><th colspan='13' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='13' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>PES/VOL</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>DISTANCIA</th><th style='width: 60px;'>TARIFA</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;text-align: center'>PESO RELAT(%)</th><th style='width: 60px; text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px; text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='13' class='theaderup'></th></tr> </thead><tbody>"
        tablaMat2 += "<thead><tr><th colspan='12' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th></th><th style='width: 45px;'>UNIDAD</th><th style='width: 45px;'>CANTIDAD</th><th style='width: 45px;'>UNITARIO(\$)</th><th style='width: 45px;'>C.TOTAL(\$)</th><th style='width: 45px;text-align: center'>PESO RELAT(%)</th><th style='width: 45px; text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px; text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='12' class='theaderup'></th></tr></thead><tbody>"

//        println "rends "+rendimientos
//        println "res "+res

        vae.eachWithIndex { r, i ->
            def tx = r.itemnmbr
            tx = tx.replaceAll(/&QUOT/, /&quot/)

            if (r["grpocdgo"] == 3) {
                tablaHer += "<tr>"
                tablaHer += "<td style='width: 120px;'>" + r["itemcdgo"] + "</td>"
//                tablaHer += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                tablaHer += "<td style='width: 420px;'>" + tx + "</td>"
                tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 65px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: '') + "</td>"
                tablaHer += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                totalHer += r["parcial"]
                totalHerRel += r["relativo"]
                totalHerVae += r["vae_vlor"]
                tablaHer += "</tr>"
            }
            if (r["grpocdgo"] == 2) {
                tablaMano += "<tr>"
                tablaMano += "<td style='width: 140px;'>" + r["itemcdgo"] + "</td>"
//                tablaMano += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                tablaMano += "<td style='width: 420px;'>" + tx + "</td>"
                tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 65px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: '') + "</td>"
                tablaMano += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                totalMan += r["parcial"]
                totalManRel += r["relativo"]
                totalManVae += r["vae_vlor"]
                tablaMano += "</tr>"
            }
            if (r["grpocdgo"] == 1) {
                bandMat=1
                if (params.desglose == '1') {
                    tablaMat += "<tr>"
                    tablaMat += "<td style='width: 120px;'>" + r["itemcdgo"] + "</td>"
//                    tablaMat += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                    tablaMat += "<td style='width: 420px;'>" + tx + "</td>"
                    tablaMat += "<td style='width: 50px;'>" + '' +  "</td>"
                    tablaMat += "<td style='width: 65px;text-align: right'>" + r["unddcdgo"] + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + r["parcial"] + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: '') + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    totalMat += r["parcial"]
                    totalMatRel += r["relativo"]
                    totalMatVae += r["vae_vlor"]
                    tablaMat += "</tr>"
                }
                else{
                    tablaMat += "<tr>"
                    tablaMat += "<td style='width: 120px;'>" + r["itemcdgo"] + "</td>"
//                    tablaMat += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                    tablaMat += "<td style='width: 420px;'>" + tx + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'></td>"
                    tablaMat += "<td style='width: 65px;text-align: right'>" + r["unddcdgo"] + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["rbpcpcun"] + r["parcial_t"] / r["rbrocntd"]), format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["parcial"] + r["parcial_t"]), format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["relativo"] + r["relativo_t"]), format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: '') + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: center'>"  + r["tpbncdgo"] + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number:  r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["vae_vlor"] + r["vae_vlor_t"]), format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    totalMat += (r["parcial"] + r["parcial_t"])
                    totalMatRel += (r["relativo"] + r["relativo_t"])
                    totalMatVae += (r["vae_vlor"]+ r["vae_vlor_t"])
                    tablaMat += "</tr>"
                }
            }
            if (r["grpocdgo"] == 1 && params.desglose == "1") {

                tablaTrans += "<tr>"
                tablaTrans += "<td style='width: 140px;'>" + r["itemcdgo"] + "</td>"
//                tablaTrans += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                tablaTrans += "<td style='width: 420px;'>" + tx + "</td>"
                if(r["tplscdgo"].trim() =='P' || r["tplscdgo"].trim() =='P1' ){
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + "ton-km" + "</td>"
                } else{
                    if(r["tplscdgo"].trim() =='V' || r["tplscdgo"].trim() =='V1' || r["tplscdgo"].trim() =='V2'){
                        tablaTrans += "<td style='width: 50px;text-align: right'>" + "m3-km" + "</td>"
                    }
                    else {
                        tablaTrans += "<td style='width: 50px;text-align: right'>" + r["unddcdgo"] + "</td>"
                    }
                }
                tablaTrans += "<td style='width: 65px;text-align: right'>" + g.formatNumber(number: r["itempeso"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["distancia"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["tarifa"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["parcial_t"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo_t"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: '') + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: center'>"+ r["tpbncdgo"] + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_t"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor_t"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                total += r["parcial_t"]
                totalTRel += r["relativo_t"]
                totalTVae += r["vae_vlor_t"]
                tablaTrans += "</tr>"
            }
            else {

                tablaTrans2 += "<tr>"
                tablaTrans2 += "<td style='width: 140px;'></td>"
                tablaTrans2 += "<td style='width: 420px;'></td>"
                tablaTrans2 += "<td style='width: 50px;'></td>"
                tablaTrans2 += "<td style='width: 65px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "</tr>"

            }

        }
        tablaTrans += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: total, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td> <td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalTRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalTVae, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
        tablaTrans += "</tbody></table>"
        tablaHer += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalHer, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalHerRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalHerVae, format: "##,#####0", minFractionDigit1s: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
        tablaHer += "</tbody></table>"
        tablaMano += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMan, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalManRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalManVae, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
        tablaMano += "</tbody></table>"
        tablaMat += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMat, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalMatRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalMatVae, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
        tablaMat += "</tbody></table>"
        tablaTrans2 += "</tbody></table>"
        tablaMat2 += "</tbody></table>"


        def totalRubro = total + totalHer + totalMan + totalMat
        def totalRelativo = totalTRel + totalHerRel + totalMatRel + totalManRel
        def totalVae = totalTVae + totalHerVae + totalMatVae + totalManVae
        totalRubro = totalRubro.toDouble().round(5)

        band = total

        def totalIndi = totalRubro * indi / 100
        totalIndi = totalIndi.toDouble().round(5)
        tablaIndi += "<thead><tr><th class='tituloHeader'>COSTOS INDIRECTOS</th></tr>" +
                "<tr><th colspan='3' class='theader'></th></tr><tr><th style='width:550px' class='padTopBot'>DESCRIPCIÓN</th><th style='width:130px'>PORCENTAJE</th><th>VALOR</th></tr><tr><th colspan='3' class='theaderup'></th></tr>  </thead>"
        tablaIndi += "<tbody><tr><td>COSTOS INDIRECTOS</td><td style='text-align:center'>${indi}%</td><td style='text-align:right'>${g.formatNumber(number: totalIndi, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5")}</td></tr></tbody>"
        tablaIndi += "</table>"


        if (total == 0)
            tablaTrans = ""
        if (totalMan == 0)
            tablaMano = ""
        if (totalMat == 0)
            tablaMat = ""
//        println "fin reporte rubro"
        [rubro: rubro, fechaPrecios: fecha1, tablaTrans: tablaTrans, tablaTrans2: tablaTrans2, band:  band, tablaMat2: tablaMat2, bandMat: bandMat,
         bandTrans: bandTrans, tablaHer: tablaHer, tablaMano: tablaMano, tablaMat: tablaMat, tablaIndi: tablaIndi, totalRubro: totalRubro, totalIndi: totalIndi, fechPal: fechaPal, fechaSalida: fecha2, obra: obra, totalRelativo: totalRelativo, totalVae: totalVae]


    }

    def imprimirRubro() {
        println "imprimir rubro "+params

        def rubro = Item.get(params.id)
        def corregido
        def text = (rubro.nombre ?: '')
        text = text.decodeHTML()
        text = text.replaceAll(/</, /&lt;/);
        text = text.replaceAll(/>/, /&gt;/);
        text = text.replaceAll(/"/, /&quot;/);
        rubro.nombre = text

        def fecha
        def fecha1

        if(params.fecha){
            fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        }else {

        }

        if(params.fechaSalida){
            fecha1 = new Date().parse("dd-MM-yyyy", params.fechaSalida)
        }else {
        }

        def lugar = params.lugar
        def indi = params.indi
        def listas = params.listas

        try {
            indi = indi.toDouble()
        } catch (e) {
            println "error parse " + e
            indi = 21.5
        }
        def obra
        if (params.obra) {
            obra = Obra.get(params.obra)
        }

        def parametros = "" + rubro.id + ",'" + fecha.format("yyyy-MM-dd") + "'," + listas + "," + params.dsp0 + "," + params.dsp1 + "," + params.dsv0 + "," + params.dsv1 + "," + params.dsv2 + "," + params.chof + "," + params.volq
        preciosService.ac_rbroV2(params.id, fecha.format("yyyy-MM-dd"), params.lugar)
        def res = preciosService.rb_preciosAsc(parametros, "")
        def tablaHer = '<table class=""> '
        def tablaMano = '<table class=""> '
        def tablaMat = '<table class=""> '
        def tablaMat2 = '<table class="marginTop"> '
        def tablaTrans = '<table class=""> '
        def tablaTrans2 = '<table class="marginTop"> '
        def tablaIndi = '<table class="marginTop"> '
        def total = 0, totalHer = 0, totalMan = 0, totalMat = 0
        def band = 0
        def bandMat = 0
        def bandTrans = params.trans

        tablaTrans += "<thead><tr><th colspan='8' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='8' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot' >CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>PES/VOL</th><th>CANTIDAD</th><th>DISTANCIA</th><th>TARIFA</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='8' class='theaderup'></th></tr> </thead><tbody>"
        tablaHer += "<thead><tr><th colspan='7' class='tituloHeader'>EQUIPOS</th></tr><tr><th colspan='7' class='theader'></th></tr><tr><th style='width: 80px' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>CANTIDAD</th><th style='width:70px'>TARIFA(\$/H)</th><th>COSTO(\$)</th><th>RENDIMIENTO</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='7' class='theaderup'></th></tr> </thead><tbody>"
        tablaMano += "<thead><tr><th colspan='7' class='tituloHeader'>MANO DE OBRA</th></tr><tr><th colspan='7' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>CANTIDAD</th><th style='width:70px'>JORNAL(\$/H)</th><th>COSTO(\$)</th><th>RENDIMIENTO</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='7' class='theaderup'></th></tr> </thead><tbody>"

        if(params.trans == 'no'){
            tablaMat += "<thead><tr><th colspan='6' class='tituloHeader'>MATERIALES INCLUIDO TRANSPORTE</th></tr><tr><th colspan='6' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>CANTIDAD</th><th>UNITARIO(\$)</th><th>C.TOTAL(\$)</th></tr> <tr><th colspan='6' class='theaderup'></th></tr> </thead><tbody>"

        }else {
            tablaMat += "<thead><tr><th colspan='6' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='6' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>CANTIDAD</th><th>UNITARIO(\$)</th><th>C.TOTAL(\$)</th></tr> <tr><th colspan='6' class='theaderup'></th></tr> </thead><tbody>"
        }
        tablaMat2 += "<thead><tr><th colspan='6' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='6' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>CANTIDAD</th><th>UNITARIO(\$)</th><th>C.TOTAL(\$)</th></tr> <tr><th colspan='6' class='theaderup'></th></tr> </thead><tbody>"
        tablaTrans2 += "<thead><tr><th colspan='8' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='8' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>PES/VOL</th><th>CANTIDAD</th><th>DISTANCIA</th><th>TARIFA</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='8' class='theaderup'></th></tr> </thead><tbody>"


        res.each { r ->
//            println "res "+res
            def tx = r.itemnmbr
            tx = tx.replaceAll(/&QUOT/, /&quot/)

            if (r["grpocdgo"] == 3) {
                tablaHer += "<tr>"
                tablaHer += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                tablaHer += "<td>" + r["itemnmbr"] + "</td>"
                tablaHer += "<td>" + tx + "</td>"
                tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                totalHer += r["parcial"]
                tablaHer += "</tr>"
            }
            if (r["grpocdgo"] == 2) {
                tablaMano += "<tr>"
                tablaMano += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                tablaMano += "<td>" + r["itemnmbr"] + "</td>"
                tablaMano += "<td>" + tx + "</td>"
                tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                totalMan += r["parcial"]
                tablaMano += "</tr>"
            }
            if (r["grpocdgo"] == 1) {

                bandMat = 1

                tablaMat += "<tr>"
                if (params.trans != 'no') {
                    tablaMat += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                    tablaMat += "<td>" + r["itemnmbr"] + "</td>"
                    tablaMat += "<td>" + tx + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: center'>${r['unddcdgo']}</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + r["parcial"] + "</td>"
                    totalMat += r["parcial"]
                } else {

                }
                if(params.trans == 'no'){

                    tablaMat += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                    tablaMat += "<td>" + r["itemnmbr"] + "</td>"
                    tablaMat += "<td>" + tx + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: center'>${r['unddcdgo']}</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: (r["rbpcpcun"] + r["parcial_t"] / r["rbrocntd"]), format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: (r["parcial"] + r["parcial_t"]), format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"

                    totalMat += r["parcial"] + r["parcial_t"]
                }
                tablaMat += "</tr>"
            }
            if (r["grpocdgo"]== 1 && params.trans != 'no') {
                tablaTrans += "<tr>"
                tablaTrans += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                tablaTrans += "<td>" + r["itemnmbr"] + "</td>"
                tablaTrans += "<td>" + tx + "</td>"
                if(r["tplscdgo"].trim() =='P' || r["tplscdgo"].trim() =='P1' ){
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + "ton-km" + "</td>"
                } else{
                    if(r["tplscdgo"].trim() =='V' || r["tplscdgo"].trim() =='V1' || r["tplscdgo"].trim() =='V2'){
                        tablaTrans += "<td style='width: 50px;text-align: right'>" + "m3-km" + "</td>"
                    }
                    else {
                        tablaTrans += "<td style='width: 50px;text-align: right'>" + r["unddcdgo"] + "</td>"
                    }

                }
                tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["itempeso"], format: "##,##0", minFractionDigits: "6", maxFractionDigits: "6", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["distancia"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["tarifa"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial_t"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                total += r["parcial_t"]
                tablaTrans += "</tr>"
            }
            else {
            }

        }
        tablaTrans += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: total, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
        tablaTrans += "</tbody></table>"
        tablaHer += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalHer, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
        tablaHer += "</tbody></table>"
        tablaMano += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMan, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
        tablaMano += "</tbody></table>"
        tablaMat += "<tr><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMat, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
        tablaMat += "</tbody></table>"
        tablaTrans2 += "</tbody></table>"
        tablaMat2 += "</tbody></table>"

        def totalRubro = 0
        if (!params.trans) {
            totalRubro = total + totalHer + totalMan + totalMat
        } else {
            totalRubro = totalHer + totalMan + totalMat
        }

        band = total

        def totalIndi = totalRubro * indi / 100
        tablaIndi += "<thead><tr><th class='tituloHeader'>COSTOS INDIRECTOS</th></tr><tr><th colspan='3' class='theader'></th></tr><tr><th style='width:550px' class='padTopBot'>DESCRIPCIÓN</th><th style='width:130px'>PORCENTAJE</th><th>VALOR</th></tr>    <tr><th colspan='3' class='theaderup'></th></tr>  </thead>"
        tablaIndi += "<tbody><tr><td>COSTOS INDIRECTOS</td><td style='text-align:center'>${indi}%</td><td style='text-align:right'>${g.formatNumber(number: totalIndi, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5")}</td></tr></tbody>"
        tablaIndi += "</table>"

        if (total == 0 || params.trans == "no")
            tablaTrans = ""

        [rubro: rubro, fechaPrecios: fecha, tablaTrans: tablaTrans, tablaTrans2: tablaTrans2, band: band, tablaMat2: tablaMat2, bandMat: bandMat, bandTrans: bandTrans , tablaHer: tablaHer, tablaMano: tablaMano, tablaMat: tablaMat,
                tablaIndi: tablaIndi, totalRubro: totalRubro, totalIndi: totalIndi, obra: obra, fechaPala: fecha1]

//        renderPdf(template:'/reportes3/imprimirRubro', model: [rubro: rubro, fechaPrecios: fecha, tablaTrans: tablaTrans, tablaTrans2: tablaTrans2, band: band, tablaMat2: tablaMat2, bandMat: bandMat, bandTrans: bandTrans , tablaHer: tablaHer, tablaMano: tablaMano, tablaMat: tablaMat,
//                                                                  tablaIndi: tablaIndi, totalRubro: totalRubro, totalIndi: totalIndi, obra: obra, fechaPala: fecha1], filename: 'rubrosOferentes.pdf')
    }

    //VAE

    def imprimirRubroVae() {
        println "imprimir rubro "+params

        def rubro = Item.get(params.id)
        def corregido
        def text = (rubro.nombre ?: '')
        text = text.decodeHTML()
        text = text.replaceAll(/</, /&lt;/);
        text = text.replaceAll(/>/, /&gt;/);
        text = text.replaceAll(/"/, /&quot;/);
        rubro.nombre = text

        def fecha
        def fecha1

        if(params.fecha){
            fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        }else {
        }

        if(params.fechaSalida){
            fecha1 = new Date().parse("dd-MM-yyyy", params.fechaSalida)
        }else {
        }

        def lugar = params.lugar
        def indi = params.indi
        def listas = params.listas

        try {
            indi = indi.toDouble()
        } catch (e) {
            println "error parse " + e
            indi = 21.5
        }
        def obra
        if (params.obra) {
            obra = Obra.get(params.obra)
        }

        def parametros = "" + rubro.id + ",'" + fecha.format("yyyy-MM-dd") + "'," + listas + "," + params.dsp0 + "," + params.dsp1 + "," + params.dsv0 + "," + params.dsv1 + "," + params.dsv2 + "," + params.chof + "," + params.volq

        preciosService.ac_rbroV2(params.id, fecha.format("yyyy-MM-dd"), params.lugar)
        def res = preciosService.rb_preciosAsc(parametros, "")
        def vae = preciosService.rb_preciosVae(parametros, "")

        def tablaHer = '<table class=""> '
        def tablaMano = '<table class=""> '
        def tablaMat = '<table class=""> '
        def tablaMat2 = '<table class="marginTop"> '
        def tablaTrans = '<table class=""> '
        def tablaTrans2 = '<table class="marginTop"> '
        def tablaIndi = '<table class="marginTop"> '
        def total = 0, totalHer = 0, totalMan = 0, totalMat = 0, totalHerRel = 0, totalHerVae = 0, totalManRel = 0, totalManVae = 0, totalMatRel = 0, totalMatVae = 0, totalTRel=0, totalTVae=0

        def band = 0
        def bandMat = 0
        def bandTrans = params.trans
        tablaTrans += "<thead><tr><th colspan='13' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='13' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>PES/VOL</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>DISTANCIA</th><th style='width: 60px;'>TARIFA</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;text-align: center'>PESO RELAT(%)</th><th style='width: 60px;text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px;text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='13' class='theaderup'></th></tr> </thead><tbody>"
        tablaHer += "<thead><tr><th colspan='12' class='tituloHeader'>EQUIPOS</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th> <th style='width:60px'>CANTIDAD</th><th style='width:60px'>TARIFA(\$/H)</th><th style='width:60px'>COSTO(\$)</th><th style='width:60x'>RENDIMIENTO</th><th style='width:50px'>C.TOTAL(\$)</th><th style='width:60px;text-align: center'>PESO RELAT(%)</th><th style='width:60px;text-align: center'>CPC</th><th style='width:45px;text-align: center'>NP/EP/  ND</th><th style='width:60px;text-align: right'>VAE(%)</th><th style='width:60px;text-align: center'>VAE(%) ELEMENTO</th></tr>  <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
        tablaMano += "<thead><tr><th colspan='12' class='tituloHeader'>MANO DE OBRA</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width:60px'>CANTIDAD</th><th style='width:60px'>JORNAL(\$/H)</th><th style='width:60px'>COSTO(\$)</th><th style='width:60px'>RENDIMIENTO</th><th style='width:50px'>C.TOTAL(\$)</th><th style='width:60px;text-align: center'>PESO RELAT(%)</th><th style='width:60px;text-align: center'>CPC</th><th style='width:45px;text-align: center'>NP/EP/  ND</th><th style='width:60px;text-align: right'>VAE(%)</th><th style='width:60px;text-align: center'>VAE(%) ELEMENTO</th></tr>  <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
        if(params.trans == 'no'){
            tablaMat += "<thead><tr><th colspan='12' class='tituloHeader'>MATERIALES INCLUIDO TRANSPORTE</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th></th> <th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>UNITARIO(\$)</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;text-align: center'>PESO RELAT(%)</th><th style='width: 60px;text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px; text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
        }else {
            tablaMat += "<thead><tr><th colspan='12' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width: 60px;'></th><th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>UNITARIO(\$)</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;text-align: center'>PESO RELAT(%)</th><th style='width: 60px;text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width:45px; text-align: center'>VAE(%) ELEMENTO</th></tr>  <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
        }
        tablaTrans2 += "<thead><tr><th colspan='13' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='13' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>PES/VOL</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>DISTANCIA</th><th style='width: 60px;'>TARIFA</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;text-align: center'>PESO RELAT(%)</th><th style='width: 60px;text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px; text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='13' class='theaderup'></th></tr> </thead><tbody>"
        tablaMat2 += "<thead><tr><th colspan='12' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th></th><th style='width: 45px;'>UNIDAD</th><th style='width: 45px;'>CANTIDAD</th><th style='width: 45px;'>UNITARIO(\$)</th><th style='width: 45px;'>C.TOTAL(\$)</th><th style='width: 45px;text-align: center'>PESO RELAT(%)</th><th style='width: 45px;text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px; text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='12' class='theaderup'></th></tr></thead><tbody>"


        vae.eachWithIndex { r, i ->
//            println "res "+res
            def tx = r.itemnmbr
            tx = tx.replaceAll(/&QUOT/, /&quot/)
//            println "..nombre ${r} cambia a $tx"
//            println "..nombre ${r}"

            if (r["grpocdgo"] == 3) {
                tablaHer += "<tr>"
                tablaHer += "<td style='width: 120px;'>" + r["itemcdgo"] + "</td>"
//                tablaHer += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                tablaHer += "<td style='width: 420px;'>" + tx + "</td>"
                tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 65px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: ' ') + "</td>"
                tablaHer += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                totalHer += r["parcial"]
                totalHerRel += r["relativo"]
                totalHerVae += r["vae_vlor"]
                tablaHer += "</tr>"

            }
            if (r["grpocdgo"] == 2) {
                tablaMano += "<tr>"
                tablaMano += "<td style='width: 140px;'>" + r["itemcdgo"] + "</td>"
//                tablaMano += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                tablaMano += "<td style='width: 420px;'>" + tx + "</td>"
                tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 65px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: ' ') + "</td>"
                tablaMano += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                totalMan += r["parcial"]
                totalManRel += r["relativo"]
                totalManVae += r["vae_vlor"]
                tablaMano += "</tr>"
            }
            if (r["grpocdgo"] == 1) {
                bandMat = 1
                tablaMat += "<tr>"
                if (params.trans != 'no') {
                    tablaMat += "<td style='width: 120px;'>" + r["itemcdgo"] + "</td>"
//                    tablaMat += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                    tablaMat += "<td style='width: 420px;'>" + tx + "</td>"

                    tablaMat += "<td style='width: 50px;'>" + '' +  "</td>"
                    tablaMat += "<td style='width: 65px;text-align: right'>" + r["unddcdgo"] + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + r["parcial"] + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: ' ') + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    totalMat += r["parcial"]
                    totalMatRel += r["relativo"]
                    totalMatVae += r["vae_vlor"]

                } else {

                }
                if(params.trans == 'no'){
                    tablaMat += "<td style='width: 120px;'>" + r["itemcdgo"] + "</td>"
//                    tablaMat += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                    tablaMat += "<td style='width: 420px;'>" + tx + "</td>"
                    tablaMat += "<td style='width: 50px;text-align: right'></td>"
                    tablaMat += "<td style='width: 65px;text-align: right'>" + r["unddcdgo"] + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["rbpcpcun"] + r["parcial_t"] / r["rbrocntd"]), format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["parcial"] + r["parcial_t"]), format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["relativo"] + r["relativo_t"]), format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: ' ') + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["vae_vlor"] + r["vae_vlor_t"]), format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    totalMat += (r["parcial"] + r["parcial_t"])
                    totalMatRel += (r["relativo"] + r["relativo_t"])
                    totalMatVae += (r["vae_vlor"] + r["vae_vlor_t"])
                }
                tablaMat += "</tr>"
            }
            if (r["grpocdgo"]== 1 && params.trans != 'no') {
                tablaTrans += "<tr>"
                tablaTrans += "<td style='width: 140px;'>" + r["itemcdgo"] + "</td>"
//                tablaTrans += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                tablaTrans += "<td style='width: 420px;'>" + tx + "</td>"
                if(r["tplscdgo"].trim() =='P' || r["tplscdgo"].trim() =='P1' ){
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + "ton-km" + "</td>"
                } else{
                    if(r["tplscdgo"].trim() =='V' || r["tplscdgo"].trim() =='V1' || r["tplscdgo"].trim() =='V2'){
                        tablaTrans += "<td style='width: 50px;text-align: right'>" + "m3-km" + "</td>"
                    }
                    else {
                        tablaTrans += "<td style='width: 50px;text-align: right'>" + r["unddcdgo"] + "</td>"
                    }
                }
                tablaTrans += "<td style='width: 65px;text-align: right'>" + g.formatNumber(number: r["itempeso"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["distancia"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["tarifa"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["parcial_t"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo_t"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: ' ') + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: center'>"  + r["tpbncdgo"] + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_t"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor_t"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                total += r["parcial_t"]
                totalTRel += r["relativo_t"]
                totalTVae += r["vae_vlor_t"]
                tablaTrans += "</tr>"

            }
            else {

                tablaTrans2 += "<tr>"
                tablaTrans2 += "<td style='width: 140px;'></td>"
                tablaTrans2 += "<td style='width: 420px;'></td>"
                tablaTrans2 += "<td style='width: 50px;'></td>"
                tablaTrans2 += "<td style='width: 65px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                tablaTrans2 += "</tr>"
            }
        }

        tablaTrans += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: total, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td> <td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalTRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalTVae, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
        tablaTrans += "</tbody></table>"
        tablaHer += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalHer, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalHerRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalHerVae, format: "##,#####0", minFractionDigit1s: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
        tablaHer += "</tbody></table>"
        tablaMano += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMan, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalManRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalManVae, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
        tablaMano += "</tbody></table>"
        tablaMat += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMat, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalMatRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                "<b>${g.formatNumber(number: totalMatVae, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
        tablaMat += "</tbody></table>"
        tablaTrans2 += "</tbody></table>"
        tablaMat2 += "</tbody></table>"

        def totalRubro = total + totalHer + totalMan + totalMat
        def totalRelativo = totalTRel + totalHerRel + totalMatRel + totalManRel
        def totalVae = totalTVae + totalHerVae + totalMatVae + totalManVae
        totalRubro = totalRubro.toDouble().round(5)
        band = total
        def totalIndi = totalRubro * indi / 100
        totalIndi = totalIndi.toDouble().round(5)
        tablaIndi += "<thead><tr><th class='tituloHeader'>COSTOS INDIRECTOS</th></tr>" +
                "<tr><th colspan='3' class='theader'></th></tr><tr><th style='width:550px' class='padTopBot'>DESCRIPCIÓN</th><th style='width:130px'>PORCENTAJE</th><th>VALOR</th></tr><tr><th colspan='3' class='theaderup'></th></tr>  </thead>"
        tablaIndi += "<tbody><tr><td>COSTOS INDIRECTOS</td><td style='text-align:center'>${indi}%</td><td style='text-align:right'>${g.formatNumber(number: totalIndi, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5")}</td></tr></tbody>"
        tablaIndi += "</table>"

        if (total == 0 || params.trans == "no")
            tablaTrans = ""
        [rubro: rubro, fechaPrecios: fecha, tablaTrans: tablaTrans, tablaTrans2: tablaTrans2, band: band, tablaMat2: tablaMat2, bandMat: bandMat, bandTrans: bandTrans , tablaHer: tablaHer, tablaMano: tablaMano, tablaMat: tablaMat,
         tablaIndi: tablaIndi, totalRubro: totalRubro, totalIndi: totalIndi, obra: obra, fechaPala: fecha1, totalRelativo: totalRelativo, totalVae: totalVae]
    }


    def imprimirRubros() {
        println "imprimir rubros " + params

        def rubros = []

        def parts = params.id.split("_")

        switch (parts[0]) {
            case "sg":
                def departamentos = DepartamentoItem.findAllBySubgrupo(SubgrupoItems.get(parts[1].toLong()))
                rubros = Item.findAllByDepartamentoInList(departamentos)
                break;
            case "dp":
                rubros = Item.findAllByDepartamento(DepartamentoItem.get(parts[1].toLong()))
                break;
            case "rb":
                rubros = [Item.get(parts[1].toLong())]
                break;
        }

        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def lugar = params.lugar
        def indi = params.indi
        def listas = params.listas
        try {
            indi = indi.toDouble()
        } catch (e) {
            println "error parse " + e
            indi = 21.5
        }

        def html = ""

        def nombresTodos = []
        def corregidos = []

//        println("rubros" + rubros)

        rubros.each { rubro->
            nombresTodos += rubro?.nombre
        }
            nombresTodos.each {
                def text = (it ?: '')

                text = text.decodeHTML()
                text = text.replaceAll(/</, /&lt;/);
                text = text.replaceAll(/>/, /&gt;/);
                text = text.replaceAll(/"/, /&quot;/);
                corregidos += text
            }


        rubros.eachWithIndex{ j,i->
            j.nombre = corregidos[i]
        }

        rubros.each { rubro ->
            def header, tablas, footer, nota
            def tablaHer, tablaMano, tablaMat, tablaTrans, tablaIndi

            header =
                    "  <div class=\"tituloPdf\">\n" +
                            "                <p style=\"font-size: 18px\">\n" +
                            "                    <b>G.A.D. PROVINCIA DE PICHINCHA</b>\n" +
                            "                </p>\n" +
                            "\n" +
                            "                <p style=\"font-size: 14px\">\n" +
                            "                    DCP - COORDINACIÓN DE RÉGIMEN DE FIJACIÓN DE COSTOS\n" +
                            "                </p>\n" +
                            "\n" +
                            "                <p style=\"font-size: 14px\">\n" +
                            "                    ANÁLISIS DE PRECIOS UNITARIOS\n" +
                            "                </p>\n" +
                            "\n" +
                            "            </div>\n " +
                    " <div style=\"margin-top: 20px\">\n" +
                    "                <div class=\"row-fluid\">\n" +
                    "                    <div class=\"span3\" style=\"margin-right: 195px !important;\">\n" +
                    "                        <b>Fecha:</b> ${new Date().format("dd-MM-yyyy")}\n" +
                    "                    </div>\n" +
                    "\n" +
                    "                    <div class=\"span4\">\n" +
                    "                        <b>Fecha Act. P.U:</b> ${fecha.format("dd-MM-yyyy")}\n" +
                    "                    </div>\n" +
                    "                </div>\n" +
                    "\n" +
                    "                <div class=\"row-fluid\">\n" +
                    "                    <div class=\"span3\" style=\"margin-right: 0px !important; width: 180px\">\n" +
                    "                        <b>Código:</b> ${rubro.codigo}\n" +
                    "                    </div>\n" +
                    "\n" +
                    "                <div class=\"span3\" style=\"margin-right: 0px !important; width: 200px\">\n" +
                    "                <b>Código de especificación:</b> ${rubro?.codigoEspecificacion ?: ''}\n" +
                    "                </div>\n" +
                    "\n" +
                    "                    <div class=\"span3\">\n" +
                    "                        <b>Unidad:</b> ${rubro.unidad.codigo}\n" +
                    "                    </div>\n" +
                    "                </div>\n" +
                    "\n" +
                    "                <div class=\"row-fluid\">\n" +
                    "                    <div class=\"span12\">\n" +
//                    "                        <b>Descripción:</b> ${nombre}\n" +
                    "                        <b>Descripción:</b> ${rubro.nombre}\n" +
                    "                    </div>\n" +
                    "                </div>\n" +
                    "            </div>"



            def parametros = "" + rubro.id + ",'" + fecha.format("yyyy-MM-dd") + "'," + listas + "," + params.dsp0 + "," + params.dsp1 + "," + params.dsv0 + "," + params.dsv1 + "," + params.dsv2 + "," + params.chof + "," + params.volq
            preciosService.ac_rbroV2(rubro.id, fecha.format("yyyy-MM-dd"), params.lugar)
            def res = preciosService.rb_precios(parametros, "")

            tablaHer = '<table class=""> '
            tablaMano = '<table class=""> '
            tablaMat = '<table class=""> '
            tablaTrans = '<table class=""> '
            tablaIndi = '<table class=""> '
            def tablaMat2 = '<table class="marginTop"> '
            def tablaTrans2 = '<table class="marginTop"> '
            def total = 0, totalHer = 0, totalMan = 0, totalMat = 0
            def band = 0
            def bandMat = 0
            def obra
            def bandTrans = params.trans
            if (params.obra) {
                obra = Obra.get(params.obra)
            }

            tablaTrans += "<thead><tr><th colspan='8' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='8' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot' >CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>PES/VOL</th><th>CANTIDAD</th><th>DISTANCIA</th><th>TARIFA</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='8' class='theaderup'></th></tr> </thead><tbody>"
            tablaHer += "<thead><tr><th colspan='7' class='tituloHeader'>EQUIPOS</th></tr><tr><th colspan='7' class='theader'></th></tr><tr><th style='width: 80px' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>CANTIDAD</th><th style='width:70px'>TARIFA(\$/H)</th><th>COSTO(\$)</th><th>RENDIMIENTO</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='7' class='theaderup'></th></tr> </thead><tbody>"
            tablaMano += "<thead><tr><th colspan='7' class='tituloHeader'>MANO DE OBRA</th></tr><tr><th colspan='7' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>CANTIDAD</th><th style='width:70px'>JORNAL(\$/H)</th><th>COSTO(\$)</th><th>RENDIMIENTO</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='7' class='theaderup'></th></tr> </thead><tbody>"

            if(params.trans == 'no'){
                tablaMat += "<thead><tr><th colspan='6' class='tituloHeader'>MATERIALES INCLUIDO TRANSPORTE</th></tr><tr><th colspan='6' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>CANTIDAD</th><th>UNITARIO(\$)</th><th>C.TOTAL(\$)</th></tr> <tr><th colspan='6' class='theaderup'></th></tr> </thead><tbody>"
            }else{
                tablaMat += "<thead><tr><th colspan='6' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='6' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>CANTIDAD</th><th>UNITARIO(\$)</th><th>C.TOTAL(\$)</th></tr> <tr><th colspan='6' class='theaderup'></th></tr> </thead><tbody>"
            }
            tablaMat2 += "<thead><tr><th colspan='6' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='6' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>CANTIDAD</th><th>UNITARIO(\$)</th><th>C.TOTAL(\$)</th></tr> <tr><th colspan='6' class='theaderup'></th></tr> </thead><tbody>"
            tablaTrans2 += "<thead><tr><th colspan='8' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='8' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>PES/VOL</th><th>CANTIDAD</th><th>DISTANCIA</th><th>TARIFA</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='8' class='theaderup'></th></tr> </thead><tbody>"

            res.each { r ->
                if (r["grpocdgo"] == 3) {
                    tablaHer += "<tr>"
                    tablaHer += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
                    tablaHer += "<td>" + r["itemnmbr"] + "</td>"
                    tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    totalHer += r["parcial"]
                    tablaHer += "</tr>"
                }
                if (r["grpocdgo"] == 2) {
                    tablaMano += "<tr>"
                    tablaMano += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
                    tablaMano += "<td>" + r["itemnmbr"] + "</td>"
                    tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    totalMan += r["parcial"]
                    tablaMano += "</tr>"
                }
                if (r["grpocdgo"] == 1) {

                    bandMat = 1

                    tablaMat += "<tr>"
                    if (params.trans != 'no') {
                        tablaMat += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
                        tablaMat += "<td>" + r["itemnmbr"] + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: center'>${r['unddcdgo']}</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'>" + r["parcial"] + "</td>"
                        totalMat += r["parcial"]
                    }
                    if(params.trans == 'no'){
                        tablaMat += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
                        tablaMat += "<td>" + r["itemnmbr"] + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: center'>${r['unddcdgo']}</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: (r["rbpcpcun"] + r["parcial_t"] / r["rbrocntd"]), format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: (r["parcial"] + r["parcial_t"]), format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        totalMat += r["parcial"] + r["parcial_t"]
                    }
                    tablaMat += "</tr>"
                }
                if (r["grpocdgo"]== 1 && params.trans != 'no') {
                    tablaTrans += "<tr>"
                    tablaTrans += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
                    tablaTrans += "<td>" + r["itemnmbr"] + "</td>"
                    if(r["tplscdgo"].trim() =='P' || r["tplscdgo"].trim() =='P1' ){
                        tablaTrans += "<td style='width: 50px;text-align: right'>" + "ton-km" + "</td>"
                    } else{
                        if(r["tplscdgo"].trim() =='V' || r["tplscdgo"].trim() =='V1' || r["tplscdgo"].trim() =='V2'){
                            tablaTrans += "<td style='width: 50px;text-align: right'>" + "m3-km" + "</td>"
                        }
                        else {
                            tablaTrans += "<td style='width: 50px;text-align: right'>" + r["unddcdgo"] + "</td>"
                        }
                    }
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["itempeso"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["distancia"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["tarifa"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial_t"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    total += r["parcial_t"]
                    tablaTrans += "</tr>"
                }
                else {
                }
            }

            tablaTrans += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: total, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
            tablaTrans += "</tbody></table>"
            tablaHer += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalHer, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
            tablaHer += "</tbody></table>"
            tablaMano += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMan, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
            tablaMano += "</tbody></table>"
            tablaMat += "<tr><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMat, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
            tablaMat += "</tbody></table>"
            tablaTrans2 += "</tbody></table>"
            tablaMat2 += "</tbody></table>"

            def totalRubro = 0
            if (!params.trans) {
                totalRubro = total + totalHer + totalMan + totalMat
            } else {
                totalRubro = totalHer + totalMan + totalMat
            }
            def totalIndi = totalRubro * indi / 100

            tablaIndi += "<thead><tr><th class='tituloHeader'>COSTOS INDIRECTOS</th></tr><tr><th colspan='3' class='theader'></th></tr><tr><th style='width:550px' class='padTopBot'>DESCRIPCIÓN</th><th style='width:130px'>PORCENTAJE</th><th>VALOR</th></tr>    <tr><th colspan='3' class='theaderup'></th></tr>  </thead>"
            tablaIndi += "<tbody><tr><td>COSTOS INDIRECTOS</td><td style='text-align:center'>${indi}%</td><td style='text-align:right'>${g.formatNumber(number: totalIndi, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5")}</td></tr></tbody>"
            tablaIndi += "</table>"
            tablas = "<div style=\"width: 100%;margin-top: 10px;\">"

            if (params.trans == 'no'){
                tablas += tablaHer + tablaMano + tablaMat + tablaIndi
            }else {
                tablas += tablaHer + tablaMano + tablaMat + tablaTrans + tablaIndi
            }

            tablas += "</div>"
            footer = " <table class=\"table table-bordered table-striped table-condensed table-hover\" style=\"margin-top: 20px;width: 50%;float: right;  border-top: 1px solid #000000;  border-bottom: 1px solid #000000\">\n" +
                    "                    <tbody>\n" +
                    "                        <tr>\n" +
                    "                            <td style=\"width: 350px;\">\n" +
                    "                                <b>COSTO UNITARIO DIRECTO</b>\n" +
                    "                            </td>\n" +
                    "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalRubro, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                    "                            </b></td>\n" +
                    "                        </tr>\n" +
                    "                        <tr>\n" +
                    "                            <td>\n" +
                    "                                <b>COSTOS INDIRECTOS</b>\n" +
                    "                            </td>\n" +
                    "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalIndi, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                    "                            </b></td>\n" +
                    "                        </tr>\n" +
                    "                        <tr>\n" +
                    "                            <td>\n" +
                    "                                <b>COSTO TOTAL DEL RUBRO</b>\n" +
                    "                            </td>\n" +
                    "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalRubro + totalIndi, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                    "                            </b></td>\n" +
                    "                        </tr>\n" +
                    "                        <tr>\n" +
                    "                            <td>\n" +
                    "                                <b>PRECIO UNITARIO (\$USD)</b>\n" +
                    "                            </td>\n" +
                    "                            <td style=\"text-align: right\"><b>"+ g.formatNumber(number: totalRubro + totalIndi, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                    "\n" +
                    "                            </b></td>\n" +
                    "                        </tr>\n" +
                    "\n" +
                    "                    </tbody>\n" +
                    "                </table>"

            nota = "                <div style=\"width: 100%;float: left;height: 20px;margin-top: 10px;text-align: left\">\n" +
                    "                        <b>Nota:</b> Los cálculos se hacen con todos los decimales y el resultado final se lo redondea a dos decimales\n" +
                    "                    </div>"


            html += "<div class='divRubro'>" + header + tablas + footer + nota + "</div>"

        }

        [html: html]
    }


    def imprimirRubrosVae () {

        def rubros = []
        def parts = params.id.split("_")
        switch (parts[0]) {
            case "sg":
                def departamentos = DepartamentoItem.findAllBySubgrupo(SubgrupoItems.get(parts[1].toLong()))
                rubros = Item.findAllByDepartamentoInList(departamentos)
                break;
            case "dp":
                rubros = Item.findAllByDepartamento(DepartamentoItem.get(parts[1].toLong()))
                break;
            case "rb":
                rubros = [Item.get(parts[1].toLong())]
                break;
        }

        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def lugar = params.lugar
        def indi = params.indi
        def listas = params.listas
        try {
            indi = indi.toDouble()
        } catch (e) {
            println "error parse " + e
            indi = 21.5
        }

        def html = ""
        def nombresTodos = []
        def corregidos = []
        rubros.each { rubro->
            nombresTodos += rubro?.nombre
        }
        nombresTodos.each {
            def text = (it ?: '')
            text = text.decodeHTML()
            text = text.replaceAll(/</, /&lt;/);
            text = text.replaceAll(/>/, /&gt;/);
            text = text.replaceAll(/"/, /&quot;/);
            corregidos += text
        }

        rubros.eachWithIndex{ j,i->
            j.nombre = corregidos[i]
        }

        rubros.each { rubro ->
            def header, tablas, footer, nota
            def tablaHer, tablaMano, tablaMat, tablaTrans, tablaIndi
            header =
                    "  <div class=\"tituloPdf tituloHeader\">\n" +
                            "                <p style=\"font-size: 18px\">\n" +
                            "                    <b>G.A.D. PROVINCIA DE PICHINCHA</b>\n" +
                            "                </p>\n" +
                            "\n" +
                            "                <p style=\"font-size: 14px\">\n" +
                            "                   <b>DCP - COORDINACIÓN DE RÉGIMEN DE FIJACIÓN DE COSTOS</b><br/>\n" +
                            "                   <b>ANÁLISIS DE PRECIOS UNITARIOS</b>" +
                            "                </p>\n" +
                            "\n" +
                            "            </div>\n " +
                            " <div style=\"margin-top: 20px\">\n" +
                            "                <div class=\"row-fluid\">\n" +
                            "                    <div class=\"span3\" style=\"margin-right: 195px !important; width: 500px\">\n" +
                            "                        <b>Fecha:</b> ${new Date().format("dd-MM-yyyy")}\n" +
                            "                    </div>\n" +
                            "\n" +
                            "                    <div class=\"span3\" style=\"width: 200px\">\n" +
                            "                        <b>Fecha Act. P.U:</b> ${fecha.format("dd-MM-yyyy")}\n" +
                            "                    </div>\n" +
                            "                </div>\n" +
                            "\n" +
                            "                <div class=\"row-fluid\" >\n" +
                            "                    <div class=\"span3\" style=\"margin-right: 0px !important; width: 400px\">\n" +
                            "                        <b>Código de rubro:</b> ${rubro.codigo}\n" +
                            "                    </div>\n" +
                            "\n" +
                            "                <div class=\"span3\" style=\"margin-right: 0px !important; width: 300px\">\n" +
                            "                <b>Código de especificación:</b> ${rubro?.codigoEspecificacion ?: ''}\n" +
                            "                </div>\n" +
                            "\n" +
                            "                    <div class=\"span3\" style=\"width: 100px\">\n" +
                            "                        <b>Unidad:</b> ${rubro.unidad.codigo}\n" +
                            "                    </div>\n" +
                            "                </div>\n" +
                            "\n" +
                            "                <div class=\"row-fluid\">\n" +
                            "                    <div class=\"span12\">\n" +
                            "                        <b>Descripción:</b> ${rubro.nombre}\n" +
                            "                    </div>\n" +
                            "                </div>\n" +
                            "            </div>"



            def parametros = "" + rubro.id + ",'" + fecha.format("yyyy-MM-dd") + "'," + listas + "," + params.dsp0 + "," + params.dsp1 + "," + params.dsv0 + "," + params.dsv1 + "," + params.dsv2 + "," + params.chof + "," + params.volq
            preciosService.ac_rbroV2(rubro.id, fecha.format("yyyy-MM-dd"), params.lugar)
            def res = preciosService.rb_precios(parametros, "")
            def vae = preciosService.rb_preciosVae(parametros, "")

            tablaHer = '<table class="" style="width:950px"> '
            tablaMano = '<table class="" style="width:950px"> '
            tablaMat = '<table class="" style="width:950px"> '
            tablaTrans = '<table class="" style="width:950px"> '
            tablaIndi = '<table class="marginTop" style="width:663px"> '

            def tablaMat2 = '<table class="marginTop" style="width:950px"> '
            def tablaTrans2 = '<table class="marginTop" style="width:950px"> '
            def total = 0, totalHer = 0, totalMan = 0, totalMat = 0, totalHerRel = 0, totalHerVae = 0, totalManRel = 0, totalManVae = 0, totalMatRel = 0, totalMatVae = 0, totalTRel=0, totalTVae=0

            def band = 0
            def bandMat = 0
            def obra
            def bandTrans = params.trans
            if (params.obra) {
                obra = Obra.get(params.obra)
            }

            tablaTrans += "<thead><tr><th colspan='13' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='13' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>PES/VOL</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>DISTANCIA</th><th style='width: 60px;'>TARIFA</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;text-align: center'>PESO RELATI(%)</th><th style='width: 60px;text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px;text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='13' class='theaderup'></th></tr> </thead><tbody>"
            tablaHer += "<thead><tr><th colspan='12' class='tituloHeader'>EQUIPOS</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th> <th style='width:60px'>CANTIDAD</th><th style='width:60px'>TARIFA(\$/H)</th><th style='width:60px'>COSTO(\$)</th><th style='width:60x'>RENDIMIENTO</th><th style='width:50px'>C.TOTAL(\$)</th><th style='width:60px;text-align: center'>PESO RELAT(%)</th><th style='width:60px;text-align: center'>CPC</th><th style='width:45px;text-align: center'>NP/EP/  ND</th><th style='width:60px; text-align: right'>VAE(%)</th><th style='width:60px;text-align: center'>VAE(%) ELEMENTO</th></tr>  <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
            tablaMano += "<thead><tr><th colspan='12' class='tituloHeader'>MANO DE OBRA</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width:60px'>CANTIDAD</th><th style='width:60px'>JORNAL(\$/H)</th><th style='width:60px'>COSTO(\$)</th><th style='width:60px'>RENDIMIENTO</th><th style='width:50px'>C.TOTAL(\$)</th><th style='width:60px;text-align: center'>PESO RELAT(%)</th><th style='width:60px;text-align: center'>CPC</th><th style='width:45px;text-align: center'>NP/EP/  ND</th><th style='width:60px;text-align: right'>VAE(%)</th><th style='width:60px;text-align: center'>VAE(%) ELEMENTO</th></tr>  <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
            if(params.trans == 'no'){
                tablaMat += "<thead><tr><th colspan='12' class='tituloHeader'>MATERIALES INCLUIDO TRANSPORTE</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th></th> <th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>UNITARIO(\$)</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;'>PESO RELAT(%)</th><th style='width: 60px;text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px;text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
            }else{
                tablaMat += "<thead><tr><th colspan='12' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width: 60px;'></th><th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>UNITARIO(\$)</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;'>PESO RELAT(%)</th><th style='width: 60px;text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width:45px;text-align: center'>VAE(%) ELEMENTO</th></tr>  <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
            }
            tablaTrans2 += "<thead><tr><th colspan='13' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='13' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>PES/VOL</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>DISTANCIA</th><th style='width: 60px;'>TARIFA</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;'>PESO RELAT(%)</th><th style='width: 60px;text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px;text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='13' class='theaderup'></th></tr> </thead><tbody>"
            tablaMat2 += "<thead><tr><th colspan='12' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th></th><th style='width: 45px;'>UNIDAD</th><th style='width: 45px;'>CANTIDAD</th><th style='width: 45px;'>UNITARIO(\$)</th><th style='width: 45px;'>C.TOTAL(\$)</th><th style='width: 45px;'>PESO RELAT(%)</th><th style='width: 45px;text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px;text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='12' class='theaderup'></th></tr></thead><tbody>"

            vae.eachWithIndex { r, i ->
                if (r["grpocdgo"] == 3) {
                    tablaHer += "<tr>"
                    tablaHer += "<td style='width: 120px;'>" + r["itemcdgo"] + "</td>"
                    tablaHer += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                    tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 65px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: ' ') + "</td>"
                    tablaHer += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                    tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    totalHer += r["parcial"]
                    totalHerRel += r["relativo"]
                    totalHerVae += r["vae_vlor"]
                    tablaHer += "</tr>"
                }
                if (r["grpocdgo"] == 2) {

                    tablaMano += "<tr>"
                    tablaMano += "<td style='width: 140px;'>" + r["itemcdgo"] + "</td>"
                    tablaMano += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                    tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 65px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: ' ') + "</td>"
                    tablaMano += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                    tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number:  r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    totalMan += r["parcial"]
                    totalManRel += r["relativo"]
                    totalManVae += r["vae_vlor"]
                    tablaMano += "</tr>"
                }
                if (r["grpocdgo"] == 1) {

                    bandMat = 1
                    tablaMat += "<tr>"
                    if (params.trans != 'no') {

                        tablaMat += "<td style='width: 120px;'>" + r["itemcdgo"] + "</td>"
                        tablaMat += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                        tablaMat += "<td style='width: 50px;'>" + '' +  "</td>"
                        tablaMat += "<td style='width: 65px;text-align: right'>" + r["unddcdgo"] + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + r["parcial"] + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: ' ') + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        totalMat += r["parcial"]
                        totalMatRel += r["relativo"]
                        totalMatVae += r["vae_vlor"]
                    }
                    if(params.trans == 'no'){


                        tablaMat += "<td style='width: 120px;'>" + r["itemcdgo"] + "</td>"
                        tablaMat += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'></td>"
                        tablaMat += "<td style='width: 65px;text-align: right'>" + r["unddcdgo"] + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["rbpcpcun"] + r["parcial_t"] / r["rbrocntd"]), format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["parcial"] + r["parcial_t"]), format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["relativo"] + r["relativo_t"]), format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: ' ') + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: center'>"  + r["tpbncdgo"] + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["vae_vlor"]+ r["vae_vlor_t"]), format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        totalMat += (r["parcial"] + r["parcial_t"])
                        totalMatRel += (r["relativo"] + r["relativo_t"])
                        totalMatVae += (r["vae_vlor"] + r["vae_vlor_t"])
                    }
                    tablaMat += "</tr>"
                }
                if (r["grpocdgo"]== 1 && params.trans != 'no') {
                    tablaTrans += "<tr>"
                    tablaTrans += "<td style='width: 140px;'>" + r["itemcdgo"] + "</td>"
                    tablaTrans += "<td style='width: 420px;'>" + r["itemnmbr"] + "</td>"
                    if(r["tplscdgo"].trim() =='P' || r["tplscdgo"].trim() =='P1' ){
                        tablaTrans += "<td style='width: 50px;text-align: right'>" + "ton-km" + "</td>"
                    } else{
                        if(r["tplscdgo"].trim() =='V' || r["tplscdgo"].trim() =='V1' || r["tplscdgo"].trim() =='V2'){
                            tablaTrans += "<td style='width: 50px;text-align: right'>" + "m3-km" + "</td>"
                        }
                        else {
                            tablaTrans += "<td style='width: 50px;text-align: right'>" + r["unddcdgo"] + "</td>"
                        }
                    }
                    tablaTrans += "<td style='width: 65px;text-align: right'>" + g.formatNumber(number: r["itempeso"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["distancia"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["tarifa"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["parcial_t"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo_t"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: ' ') + "</td>"
                    tablaTrans += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                    tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_t"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor_t"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                    total += r["parcial_t"]
                    totalTRel += r["relativo_t"]
                    totalTVae += r["vae_vlor_t"]
                    tablaTrans += "</tr>"
                }
                else {
                    tablaTrans2 += "<tr>"
                    tablaTrans2 += "<td style='width: 140px;'></td>"
                    tablaTrans2 += "<td style='width: 420px;'></td>"
                    tablaTrans2 += "<td style='width: 50px;'></td>"
                    tablaTrans2 += "<td style='width: 65px;text-align: right'></td>"
                    tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                    tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                    tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                    tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                    tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                    tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                    tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                    tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                    tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                    tablaTrans2 += "</tr>"
                }
            }

            tablaTrans += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: total, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td> <td style='width: 50px;text-align: right'>" +
                    "<b>${g.formatNumber(number: totalTRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                    "<b>${g.formatNumber(number: totalTVae, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
            tablaTrans += "</tbody></table>"
            tablaHer += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalHer, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td><td style='width: 50px;text-align: right'>" +
                    "<b>${g.formatNumber(number: totalHerRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                    "<b>${g.formatNumber(number: totalHerVae, format: "##,#####0", minFractionDigit1s: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
            tablaHer += "</tbody></table>"
            tablaMano += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMan, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td><td style='width: 50px;text-align: right'>" +
                    "<b>${g.formatNumber(number: totalManRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                    "<b>${g.formatNumber(number: totalManVae, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
            tablaMano += "</tbody></table>"
            tablaMat += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMat, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td><td style='width: 50px;text-align: right'>" +
                    "<b>${g.formatNumber(number: totalMatRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                    "<b>${g.formatNumber(number: totalMatVae, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
            tablaMat += "</tbody></table>"
            tablaTrans2 += "</tbody></table>"
            tablaMat2 += "</tbody></table>"


            def totalRubro = total + totalHer + totalMan + totalMat
            def totalRelativo = totalTRel + totalHerRel + totalMatRel + totalManRel
            def totalVae = totalTVae + totalHerVae + totalMatVae + totalManVae
            totalRubro = totalRubro.toDouble().round(5)
            band = total

            def totalIndi = totalRubro * indi / 100
            totalIndi = totalIndi.toDouble().round(5)
            tablaIndi += "<thead><tr><th class='tituloHeader'>COSTOS INDIRECTOS</th></tr>" +
                    "<tr><th colspan='3' class='theader'></th></tr><tr><th style='width:550px' class='padTopBot'>DESCRIPCIÓN</th><th style='width:130px'>PORCENTAJE</th><th>VALOR</th></tr><tr><th colspan='3' class='theaderup'></th></tr>  </thead>"
            tablaIndi += "<tbody><tr><td>COSTOS INDIRECTOS</td><td style='text-align:center'>${indi}%</td><td style='text-align:right'>${g.formatNumber(number: totalIndi, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5")}</td></tr></tbody>"
            tablaIndi += "</table>"

            if (total == 0 || params.trans == 'no')
                tablaTrans = ""
            if (totalHer == 0)
                tablaHer = ""
            if (totalMan == 0)
                tablaMano = ""
            if (totalMat == 0)
                tablaMat = ""

            tablas = "<div style=\"width: 100%;margin-top: 10px;\">"

            if (params.trans == 'no'){
                tablas += tablaHer + tablaMano + tablaMat + tablaIndi
            }else {
                tablas += tablaHer + tablaMano + tablaMat + tablaTrans + tablaIndi
            }

            tablas += "</div>"
            footer = " <table class=\"table table-bordered table-striped table-condensed table-hover\" style=\"margin-top: 20px;width: 50%;float: right;  border-top: 1px solid #000000;  border-bottom: 1px solid #000000\">\n" +
                    "                    <tbody>\n" +
                    "                        <tr>\n" +
                    "                            <td style=\"width: 350px;\">\n" +
                    "                                <b>COSTO UNITARIO DIRECTO</b>\n" +
                    "                            </td>\n" +
                    "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalRubro, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                    "                            </b></td>\n" +
                    "                            <td style=\"width: 120px; text-align: center\">\n" +
                    "                            <b>" + g.formatNumber (number: totalRelativo, format:"##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale:"ec") + "</b>\n" +
                    "                            </td>\n" +
                    "                            <td style=\"width: 100px\">\n" +
                    "                            </td>\n" +
                    "                            <td style=\"text-align: right; width: 40px;\">\n" +
                    "                            <b>" + g.formatNumber (number:totalVae, format:"##,##0", minFractionDigits:2, maxFractionDigits:2, locale:"ec") + "</b>\n" +
                    "                            </td>\n" +
                    "                        </tr>\n" +
                    "                        <tr>\n" +
                    "                            <td>\n" +
                    "                                <b>COSTOS INDIRECTOS</b>\n" +
                    "                            </td>\n" +
                    "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalIndi, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                    "                            </b></td>\n" +
                    "                            <td style=\"text-align: center\"><b>TOTAL</b></td>\n" +
                    "                            <td></td>\n" +
                    "                            <td style=\"text-align: center\">\n" +
                    "                            <b>TOTAL</b>\n" +
                    "                            </td>\n" +
                    "                        </tr>\n" +
                    "                        <tr>\n" +
                    "                            <td>\n" +
                    "                                <b>COSTO TOTAL DEL RUBRO</b>\n" +
                    "                            </td>\n" +
                    "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalRubro + totalIndi, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                    "                            </b></td>\n" +
                    "                            <td style=\"text-align: center\">\n" +
                    "                            <b>PESO</b>\n" +
                    "                            </td>\n" +
                    "                            <td> </td>\n" +
                    "                            <td style=\"text-align: center\">\n" +
                    "                            <b>VAE</b>\n" +
                    "                            </td>\n" +
                    "                        </tr>\n" +
                    "                        <tr>\n" +
                    "                            <td>\n" +
                    "                                <b>PRECIO UNITARIO (\$USD)</b>\n" +
                    "                            </td>\n" +
                    "                            <td style=\"text-align: right\"><b>"+ g.formatNumber(number: totalRubro + totalIndi, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                    "\n" +
                    "                            </b></td>\n" +
                    "                            <td style=\"text-align: center\">\n" +
                    "                            <b>RELATIVO (%)</b>\n" +
                    "                            </td>\n" +
                    "                            <td> </td>\n" +
                    "                            <td style=\"text-align: center\">\n" +
                    "                            <b>(%)</b>\n" +
                    "                            </td>\n" +
                    "                        </tr>\n" +
                    "\n" +
                    "                    </tbody>\n" +
                    "                </table>"

            nota = "                <div style=\"width: 100%;float: left;height: 20px;margin-top: 10px;text-align: left\">\n" +
                    "                        <b>Nota:</b> Los cálculos se hacen con todos los decimales y el resultado final se lo redondea a dos decimales\n" +
                    "                    </div>"


            html += "<div class='divRubro'>" + header + tablas + footer + nota + "</div>"

        }

        [html: html]
    }

    static arregloEnteros(array) {
        int[] ia = new int[array.size()]
        array.eachWithIndex { it, i ->
            ia[i] = it.toInteger()
        }

        return ia
    }


    def addCellTabla(PdfPTable table, Paragraph paragraph, params) {
        PdfPCell cell = new PdfPCell(paragraph);
//        println "params "+params
        cell.setBorderColor(Color.BLACK);
        if (params.border) {
            if(!params.bordeBot)
                if(!params.bordeTop)
                    cell.setBorderColor(params.border);
        }
        if (params.bg) {
            cell.setBackgroundColor(params.bg);
        }
        if (params.colspan) {
            cell.setColspan(params.colspan);
        }
        if (params.align) {
            cell.setHorizontalAlignment(params.align);
        }
        if (params.valign) {
            cell.setVerticalAlignment(params.valign);
        }
        if (params.w) {
            cell.setBorderWidth(params.w);
        }
        if(params.bordeTop){
            cell.setBorderWidthTop(0.5)
            cell.setBorderWidthLeft(0)
            cell.setBorderWidthRight(0)
            cell.setBorderWidthBottom(0)
        }
        if(params.bordeBot){
            cell.setBorderWidthBottom(0.5)
            cell.setBorderWidthLeft(0)
            cell.setBorderWidthRight(0)
            if(!params.bordeTop){
                cell.setBorderWidthTop(0)
            }
        }
        table.addCell(cell);
    }

    def imprimirCalculoValor () {

        def anio = new Date().format("yyyy").toInteger()
        def u = ValoresAnuales.findByAnio(anio).sueldoBasicoUnificado
        def c = params.valor.toDouble()
        def ap = c * 12 * 0.1215
        ap = new DecimalFormat("#.##").format(ap).toDouble()
        def ta = 14 * c + u + ap
        def jr = ta / 235

        def nuevoCosto = jr / 8
        nuevoCosto = new DecimalFormat("#.##").format(nuevoCosto).toDouble()

        def fecha1 = new Date().parse("dd-MM-yyyy", params.fechaCalculo)
        def fechaCalculo = printFecha(fecha1)

        def item = Item.get(params.id)
        def obra = Obra.get(params.id)
        def auxiliar = Auxiliar.get(1)
        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead2 = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellRight2 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft2 = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE, align: Element.ALIGN_LEFT]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2,
                prmsCellRight: prmsCellRight, prmsCellHead2: prmsCellHead2, prmsCellLeft2: prmsCellLeft2]

        def baos = new ByteArrayOutputStream()
        def name = "calculoValorHoraManoObra_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times10normal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Registro " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        headers.setAlignment(Element.ALIGN_CENTER);

        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("CÁLCULO DEL VALOR POR HORA DE MANO DE OBRA", times14bold ))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("Quito, " + fechaCalculo, times12bold));
        headers.add(new Paragraph(" ", times10bold));
        headers.add(new Paragraph(item.nombre, times12bold));
        headers.add(new Paragraph(" ", times10bold));
        document.add(headers)
        PdfPTable table = new PdfPTable(7);
        table.setWidthPercentage(90);
        table.setWidths(arregloEnteros([25,8,5,15,10,30,5]))

        addCellTabla(table, new Paragraph("Sueldo Unificado", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Su)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: c, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Su", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Décimo Tercer", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Su)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: c, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Su", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Décimo Cuarto", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(SBU)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: u, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("S.B.U", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Aporte Patronal", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(AP)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: ap, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Su*12*0.1215", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Fondo Reserva", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Fr)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: u, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Su", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Total Anual", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Ta)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: ta, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Su*13)+SBU+AP+Fr", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Jornal Real", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Jr)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: jr, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Ta/235", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Costo Horario", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Ch)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: nuevoCosto, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Jr/8", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        document.add(table)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def imprimirValorHoraEquipos () {

        def item = Item.get(params.id)
        def obra = Obra.get(params.id)
        def auxiliar = Auxiliar.get(1)
        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead2 = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellRight2 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft2 = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE, align: Element.ALIGN_LEFT]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2,
                prmsCellRight: prmsCellRight, prmsCellHead2: prmsCellHead2, prmsCellLeft2: prmsCellLeft2]

        def baos = new ByteArrayOutputStream()
        def name = "calculoValorHoraEquipos_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times10normal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)

        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Registro " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        headers.setAlignment(Element.ALIGN_CENTER);

        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''),times18bold ))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("CÁLCULO DEL VALOR POR HORA DE EQUIPOS", times14bold))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("Quito, " + printFecha(new Date()), times12bold));
        headers.add(new Paragraph(" ", times10bold));
        headers.add(new Paragraph("Equipo:" + item.nombre, times12bold));
        headers.add(new Paragraph(" ", times10bold));

        document.add(headers)

        PdfPTable table = new PdfPTable(7);
        table.setWidthPercentage(90);
        table.setWidths(arregloEnteros([25,8,5,15,10,30,5]))

        addCellTabla(table, new Paragraph("Valor Equipo Nuevo", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Vc)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.vc, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Dato", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Precio de las llantas", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Vll)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.vll, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Dato", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Valor de adquisicion del Equipo", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Va)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.va, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Dato", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Años de Vida", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Av)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.av, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Hv/Ha ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Valor de rescate", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Vr)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.vr, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("72.47 /(Av^0.32)*Va/100 ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Depreciación del equipo", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(D)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.d, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Va - Vr)/Hv", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Costo del dinero", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(i)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.ci, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Valor Anual", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Factor de recuperación de capital", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(frc)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.frc, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("1/Av + (Av +1)/(2*Av)*1 ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Intereses", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(I)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.i, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Va*frc*i/Hv", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Seguros", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(s)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.cs, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Valor Anual", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Costo de Seguros", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(S)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.s, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Va + Vr)*s/(2*Ha)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Matrícula", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(m)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.m, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(1/1000)*(Va-Vr)*Av/Hv", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Factor de costo de repuestos y reparaciones", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(k)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.k, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Valor Anual", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Costo de Repuestos", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(R)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.r, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("0.7425*D*k", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Costo M.O. Reparaciones", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(MOR)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.mor, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("0.23*D*k", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Costo Diesel - Combustibles", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Di)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.di, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Valor Anual", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Costo Diesel", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(CD)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.cd, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("0.04*Di*HP", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Aceite Lubricante", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Ac)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.ac, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Valor Anual", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Costo Lubricante", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(CL)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.cl, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("0.00035*Ac*HP", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Grasa", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Gr)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.gr, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("Valor Anual", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Costo Grasa", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(CG)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.cg, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("0.001*Gr*HP ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Precio de las llantas", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Vll)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.vll, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Horas de Vida útil de las llantas", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Hll)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.hll, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Costo Horario por llantas", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(LL)", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.cll, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph("VLL/HLL", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        addCellTabla(table, new Paragraph("Costo Total de la hora", times10bold), prmsCellLeft2)
        addCellTabla(table, new Paragraph("(Ch)", times10bold), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" : ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(g.formatNumber(number: params.ch, minFractionDigits: 2, maxFractionDigits:2, format: "##,##0", locale: "ec"), times8bold), prmsCellRight2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)
        addCellTabla(table, new Paragraph(" ", times10normal), prmsCellLeft2)

        document.add(table)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteGarantias () {

        def garantias =  janus.pac.Garantia.list();

        def auxiliar = Auxiliar.get(1)
        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead4 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellHead5 = [border: Color.WHITE,
                             align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellRight2 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft2 = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE, align: Element.ALIGN_LEFT]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2,
                prmsCellRight: prmsCellRight, prmsCellHead2: prmsCellHead2, prmsCellLeft2: prmsCellLeft2]

        def baos = new ByteArrayOutputStream()
        def name = "garantias_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times10normal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal]

        Document document
        document = new Document(PageSize.A4.rotate());
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Garantias " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();

        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("REPORTE DE GARANTÍAS", times14bold ))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("Quito, " + printFecha(new Date()), times12bold));
        headers.add(new Paragraph(" ", times10bold));

        PdfPTable tablaGarantia = new PdfPTable(13);
        tablaGarantia.setWidthPercentage(100);
        tablaGarantia.setWidths(arregloEnteros([10,15,10,10,5,10,10,10,10,10,10,10,10]))

        addCellTabla(tablaGarantia, new Paragraph("N° Contrato", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Contratista", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Tipo de Garantía", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("N° Garantía", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Rnov", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Original", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Aseguradora", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Documento", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Estado", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Monto", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Emisión", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Vencimiento", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Cancelación", times8bold), prmsCellHead2)

        garantias.each {
            addCellTabla(tablaGarantia, new Paragraph(it?.contrato?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.contrato?.oferta?.proveedor?.nombre, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.tipoGarantia?.descripcion, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(g.formatNumber(number: it?.numeroRenovaciones, format: "###,###", locale: "ec", maxFractionDigits: 0, minFractionDigits: 0), times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.padre?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.aseguradora?.nombre, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.tipoDocumentoGarantia?.descripcion, times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.estado?.descripcion, times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(g.formatNumber(number: it?.monto, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8normal), prmsCellHead5)
            addCellTabla(tablaGarantia, new Paragraph(it?.fechaInicio.format("dd-MM-yyyy"), times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.fechaFinalizacion.format("dd-MM-yyyy"), times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.cancelada?.format("dd-MM-yyyy"), times8normal), prmsCellHead3)
        }

        document.add(headers)
        document.add(tablaGarantia)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }



    def reporteGarantiasVenceran () {

        def fechaHasta = new Date().parse("dd-MM-yyyy",params.hasta)
        def fechaDesde = new Date().parse("dd-MM-yyyy",params.desde)
        def estado = EstadoGarantia.get(1)

        def garantias =  Garantia.withCriteria {
            eq("estado", estado)
            gt("fechaInicio", fechaDesde)
            lt("fechaFinalizacion", fechaHasta)
        }

        def auxiliar = Auxiliar.get(1)
        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead4 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellHead5 = [border: Color.WHITE,
                             align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellRight2 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft2 = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE, align: Element.ALIGN_LEFT]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2,
                    prmsCellRight: prmsCellRight, prmsCellHead2: prmsCellHead2, prmsCellLeft2: prmsCellLeft2]

        def baos = new ByteArrayOutputStream()
        def name = "garantias_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times10normal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal]

        Document document
        document = new Document(PageSize.A4.rotate());
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Garantias " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();

        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("REPORTE DE GARANTÍAS QUE VENCERÁN", times14bold ))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("Quito, " + printFecha(new Date()), times12bold));
        headers.add(new Paragraph(" ", times10bold));

        PdfPTable tablaGarantia = new PdfPTable(10);
        tablaGarantia.setWidthPercentage(100);
        tablaGarantia.setWidths(arregloEnteros([10,15,10,8,5,14,6,10,10,10]))

        addCellTabla(tablaGarantia, new Paragraph("N° Contrato", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Contratista", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Tipo de Garantía", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("N° Garantía", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Original", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Aseguradora", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Documento", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Monto", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Emisión", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Vencimiento", times8bold), prmsCellHead2)

        garantias.each {
            addCellTabla(tablaGarantia, new Paragraph(it?.contrato?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.contrato?.oferta?.proveedor?.nombre, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.tipoGarantia?.descripcion, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.padre?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.aseguradora?.nombre, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.tipoDocumentoGarantia?.descripcion, times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(g.formatNumber(number: it?.monto, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8normal), prmsCellHead5)
            addCellTabla(tablaGarantia, new Paragraph(it?.fechaInicio.format("dd-MM-yyyy"), times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.fechaFinalizacion.format("dd-MM-yyyy"), times8normal), prmsCellHead3)
        }

        document.add(headers)
        document.add(tablaGarantia)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteGarantiasDevueltas () {

        def estado = EstadoGarantia.get(3)
        def contratos = Acta.findAllByTipo("D").contrato.id
        def fil = Contrato.list().id - contratos
        def filtrados = Contrato.findAllByIdInList(fil)

        def garantias = Garantia.findAllByContratoInListAndEstado(filtrados, estado)

        def auxiliar = Auxiliar.get(1)
        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead4 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellHead5 = [border: Color.WHITE,
                             align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellRight2 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft2 = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE, align: Element.ALIGN_LEFT]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2,
                    prmsCellRight: prmsCellRight, prmsCellHead2: prmsCellHead2, prmsCellLeft2: prmsCellLeft2]

        def baos = new ByteArrayOutputStream()
        def name = "garantias_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times10normal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal]

        Document document
        document = new Document(PageSize.A4.rotate());
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Garantias " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();

        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("REPORTE DE GARANTÍAS DEVUELTAS", times14bold ))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("Quito, " + printFecha(new Date()), times12bold));
        headers.add(new Paragraph(" ", times10bold));

        PdfPTable tablaGarantia = new PdfPTable(10);
        tablaGarantia.setWidthPercentage(100);
        tablaGarantia.setWidths(arregloEnteros([10,15,10,9,10,8,7,10,10,40]))

        addCellTabla(tablaGarantia, new Paragraph("N° Contrato", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Contratista", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Tipo de Garantía", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("N° Garantía", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Aseguradora", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Documento", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Monto", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Emisión", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Vencimiento", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Observaciones", times8bold), prmsCellHead2)

        garantias.each {
            addCellTabla(tablaGarantia, new Paragraph(it?.contrato?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.contrato?.oferta?.proveedor?.nombre, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.tipoGarantia?.descripcion, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.aseguradora?.nombre, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.tipoDocumentoGarantia?.descripcion, times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(g.formatNumber(number: it?.monto, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8normal), prmsCellHead5)
            addCellTabla(tablaGarantia, new Paragraph(it?.fechaInicio.format("dd-MM-yyyy"), times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.fechaFinalizacion.format("dd-MM-yyyy"), times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.observaciones, times8normal), prmsCellHead4)
        }

        document.add(headers)
        document.add(tablaGarantia)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def reporteGarantiasVencidas () {

        def estadoRev = EstadoGarantia.get(3)
        def estadoDev = EstadoGarantia.get(6)
        def contratos = Acta.findAllByTipo("D").contrato.id
        def fil = Contrato.list().id - contratos
        def filtrados = Contrato.findAllByIdInList(fil)
        def hoy = new Date()

        def garantias = Garantia.findAllByContratoInListAndFechaFinalizacionLessThanAndEstadoNotEqualAndEstadoNotEqual(filtrados, hoy, estadoRev, estadoDev)

        def auxiliar = Auxiliar.get(1)
        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead4 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellHead5 = [border: Color.WHITE,
                             align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellRight2 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft2 = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE, align: Element.ALIGN_LEFT]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2,
                    prmsCellRight: prmsCellRight, prmsCellHead2: prmsCellHead2, prmsCellLeft2: prmsCellLeft2]

        def baos = new ByteArrayOutputStream()
        def name = "garantias_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times10normal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal]

        Document document
        document = new Document(PageSize.A4.rotate());
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Garantias " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();

        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("REPORTE DE GARANTÍAS VENCIDAS", times14bold ))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("Quito, " + printFecha(new Date()), times12bold));
        headers.add(new Paragraph(" ", times10bold));

        PdfPTable tablaGarantia = new PdfPTable(12);
        tablaGarantia.setWidthPercentage(100);
        tablaGarantia.setWidths(arregloEnteros([10,15,10,10,5,10,10,10,10,10,10,10]))

        addCellTabla(tablaGarantia, new Paragraph("N° Contrato", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Contratista", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Tipo de Garantía", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("N° Garantía", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Rnov", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Original", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Aseguradora", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Documento", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Estado", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Monto", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Emisión", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Vencimiento", times8bold), prmsCellHead2)

        garantias.each {
            addCellTabla(tablaGarantia, new Paragraph(it?.contrato?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.contrato?.oferta?.proveedor?.nombre, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.tipoGarantia?.descripcion, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(g.formatNumber(number: it?.numeroRenovaciones, format: "###,###", locale: "ec", maxFractionDigits: 0, minFractionDigits: 0), times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.padre?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.aseguradora?.nombre, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.tipoDocumentoGarantia?.descripcion, times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.estado?.descripcion, times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(g.formatNumber(number: it?.monto, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8normal), prmsCellHead5)
            addCellTabla(tablaGarantia, new Paragraph(it?.fechaInicio.format("dd-MM-yyyy"), times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.fechaFinalizacion.format("dd-MM-yyyy"), times8normal), prmsCellHead3)
        }

        document.add(headers)
        document.add(tablaGarantia)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def reporteRubrosVaeReg () {

//        println "----->>>>" + params
//        def rubro = Item.get(params.id)
            def obra = Obra.get(params.obra)

            def fecha1
            def fecha2

            if (obra?.fechaPreciosRubros) {
                fecha1 = obra?.fechaPreciosRubros
            } else {
            }

            if (obra?.fechaOficioSalida) {
                fecha2 = obra?.fechaOficioSalida
            } else {
            }

            def rubros = []

            def lugar = obra?.lugar
            def indi = obra?.totales

            try {
                indi = indi.toDouble()
            } catch (e) {
                println "error parse " + e
                indi = 21.5
            }

            def html = ""

            rubros = VolumenesObra.findAllByObra(obra, [sort: "orden"]).item.unique()
            rubros.eachWithIndex {rubro, indice ->
                def nombre = rubro.nombre.decodeHTML()

                nombre = nombre.replaceAll(/</, /&lt;/)
                nombre = nombre.replaceAll(/&/, /&amp;/)
                nombre = nombre.replaceAll(/'/, /&apos;/)
                nombre = nombre.replaceAll(/"/, /&quot;/)
                nombre = nombre.replaceAll(/>/, /&gt;/)


                def header, tablas, footer, nota, salto
                def tablaHer, tablaMano, tablaMat, tablaTrans, tablaIndi

                header =
                        "  <div class=\"tituloPdf tituloHeader\" >\n" +
                                "                <p style=\"font-size: 18px\">\n" +
                                "                    <b>G.A.D. PROVINCIA DE PICHINCHA</b>\n" +
                                "                </p>\n" +
                                "\n" +
                                "                <p style=\"font-size: 14px\">\n" +
                                "                    <b>DCP - COORDINACIÓN DE RÉGIMEN DE FIJACIÓN DE COSTOS</b><br/>\n" +
                                "                    <b>ANÁLISIS DE PRECIOS UNITARIOS</b>\n" +
                                "                </p>\n" +
                                "\n" +
                                "            </div>\n " +
                                " <div style=\"margin-top: 20px\">\n" +
                                "                <div class=\"row-fluid\">\n" +
                                " <div class=\"span3\" style=\"margin-right: 195px !important; width:500px\">\n"
                if (fecha2) {
                    header += "                            <b>Fecha:</b> ${fecha2.format("dd-MM-yyyy")}\n"
                } else {
                    header += "                             <b>Fecha:</b>\n"
                }

                header += "                    </div>\n" +

                        "  <div class=\"span4\">\n"
                if (fecha1) {

                    header += "                         <b>Fecha Act. P.U:</b> ${fecha1.format("dd-MM-yyyy")}\n"
                } else {
                    header += "                            <b>Fecha Act. P.U:</b>\n"
                }

                header += "                    </div>\n" +
                        "                </div>\n" +
                        "\n" +
                        "  <div class=\"row-fluid\">\n" +
                        "                    <div class=\"span12\">\n" +
                        "\n" +
                        "                        <b>Código Obra:</b> ${obra?.codigo}\n" +
                        "                    </div>\n" +
                        "                </div>\n" +
                        "\n" +
                        "               <div class=\"row-fluid\">\n" +
                        "                    <div class=\"span12\">\n" +
                        "\n" +
                        "                        <b>Presupuesto:</b> ${obra?.nombre.decodeHTML()}\n" +
                        "                    </div>\n" +
                        "                </div>\n" +
                        "                <div class=\"row-fluid\">\n" +
                        "                    <div class=\"span3\" style=\"margin-right: 0px !important; width: 400px\">\n" +
                        "                        <b>Código de rubro:</b> ${rubro.codigo}\n" +
                        "                    </div>\n" +
                        "\n" +
                        "                <div class=\"span3\" style=\"margin-right: 0px !important; width: 300px\">\n" +
                        "                <b>Código de especificación:</b> ${rubro?.codigoEspecificacion ?: ''}\n" +
                        "                </div>\n" +
                        "\n" +
                        "                    <div class=\"span3\" style=\"width: 100px\">\n" +
                        "                        <b>Unidad:</b> ${rubro.unidad.codigo}\n" +
                        "                    </div>\n" +
                        "                </div>\n" +
                        "\n" +
                        "                <div class=\"row-fluid\">\n" +
                        "                    <div class=\"span12\">\n" +
                        "                        <b>Descripción:</b> ${nombre}\n" +
                        "                    </div>\n" +
                        "                </div>\n" +


                        "            </div>"

                preciosService.ac_rbroObra(obra.id)
                def res = preciosService.precioUnitarioVolumenObraAsc("*", obra.id, rubro.id)
                def vae = preciosService.vae_rb(obra.id,rubro.id)

                tablaHer = '<table style="width:950px" class=""> '
                tablaMano = '<table style="width:950px" class=""> '
                tablaMat = '<table style="width:950px" class=""> '
                tablaTrans = '<table class="" style="width:950px" > '
                tablaIndi = '<table class="" style="width:663px"> '
                def tablaMat2 = '<table style="width:950px" class="marginTop"> '
                def tablaTrans2 = '<table style="width:950px" class="marginTop"> '
                def total = 0, totalHer = 0, totalMan = 0, totalMat = 0, totalHerRel = 0, totalHerVae = 0, totalManRel = 0, totalManVae = 0, totalMatRel = 0, totalMatVae = 0, totalTRel=0, totalTVae=0
                def band = 0
                def bandMat = 0
                def bandTrans = params.desglose

                tablaHer += "<thead><tr><th colspan='12' class='tituloHeader'>EQUIPOS</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th> <th style='width:60px'>CANTIDAD</th><th style='width:60px'>TARIFA(\$/H)</th><th style='width:60px'>COSTO(\$)</th><th style='width:60x'>RENDIMIENTO</th><th style='width:50px'>C.TOTAL(\$)</th><th style='width:60px;text-align: center'>PESO RELAT(%)</th><th style='width:60px; text-align: center'>CPC</th><th style='width:45px;text-align: center'>NP/EP/  ND</th><th style='width:60px;text-align: right'>VAE(%)</th><th style='width:60px; text-align: center'>VAE(%) ELEMENTO</th></tr>  <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
                tablaMano += "<thead><tr><th colspan='12' class='tituloHeader'>MANO DE OBRA</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width:60px'>CANTIDAD</th><th style='width:60px'>JORNAL(\$/H)</th><th style='width:60px'>COSTO(\$)</th><th style='width:60px'>RENDIMIENTO</th><th style='width:50px'>C.TOTAL(\$)</th><th style='width:60px; text-align: center'>PESO RELAT(%)</th><th style='width:60px; text-align: center'>CPC</th><th style='width:45px;text-align: center'>NP/EP/  ND</th><th style='width:60px;text-align: right'>VAE(%)</th><th style='width:60px; text-align: center'>VAE(%) ELEMENTO</th></tr>  <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"

                if(params.desglose == '1'){
                    tablaMat += "<thead><tr><th colspan='12' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width: 60px;'></th><th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>UNITARIO(\$)</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px; text-align: center'>PESO RELAT(%)</th><th style='width: 60px; text-align: center'>CPC</th><th style='width: 15px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width:45px;text-align: center'>VAE(%) ELEMENTO</th></tr>  <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
                } else {
                    tablaMat += "<thead><tr><th colspan='12' class='tituloHeader'>MATERIALES INCLUIDO TRANSPORTE</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th></th> <th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>UNITARIO(\$)</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;text-align: center'>PESO RELAT(%)</th><th style='width: 60px; text-align: center'>CPC</th><th style='width: 15px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px; text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='12' class='theaderup'></th></tr> </thead><tbody>"
                }
                tablaTrans += "<thead><tr><th colspan='13' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='13' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>PES/VOL</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>DISTANCIA</th><th style='width: 60px;'>TARIFA</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;text-align: center'>PESO RELAT(%)</th><th style='width: 60px; text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px; text-align: right'>VAE(%)</th><th style='width: 45px;  text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='13' class='theaderup'></th></tr> </thead><tbody>"
                tablaTrans2 += "<thead><tr><th colspan='13' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='13' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th style='width: 60px;'>UNIDAD</th><th style='width: 60px;'>PES/VOL</th><th style='width: 60px;'>CANTIDAD</th><th style='width: 60px;'>DISTANCIA</th><th style='width: 60px;'>TARIFA</th><th style='width: 50px;'>C.TOTAL(\$)</th><th style='width: 60px;text-align: center'>PESO RELAT(%)</th><th style='width: 60px; text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px; text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='13' class='theaderup'></th></tr> </thead><tbody>"
                tablaMat2 += "<thead><tr><th colspan='12' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='12' class='theader'></th></tr><tr><th style='width: 100px;' class='padTopBot'>CÓDIGO</th><th style='width:420px'>DESCRIPCIÓN</th><th></th><th style='width: 45px;'>UNIDAD</th><th style='width: 45px;'>CANTIDAD</th><th style='width: 45px;'>UNITARIO(\$)</th><th style='width: 45px;'>C.TOTAL(\$)</th><th style='width: 45px;text-align: center'>PESO RELAT(%)</th><th style='width: 45px; text-align: center'>CPC</th><th style='width: 45px;text-align: center'>NP/EP/  ND</th><th style='width: 45px;text-align: right'>VAE(%)</th><th style='width: 45px; text-align: center'>VAE(%) ELEMENTO</th></tr> <tr><th colspan='12' class='theaderup'></th></tr></thead><tbody>"

                vae.eachWithIndex { r, i ->

                    if (r["grpocdgo"] == 3) {

                        def nombreVaeH = r["itemnmbr"].decodeHTML()
                        nombreVaeH = nombreVaeH.replaceAll(/</, /&lt;/)
                        nombreVaeH = nombreVaeH.replaceAll(/&/, /&amp;/)
                        nombreVaeH = nombreVaeH.replaceAll(/'/, /&apos;/)
                        nombreVaeH = nombreVaeH.replaceAll(/"/, /&quot;/)
                        nombreVaeH = nombreVaeH.replaceAll(/>/, /&gt;/)

                        tablaHer += "<tr>"
                        tablaHer += "<td style='width: 120px;'>" + r["itemcdgo"] + "</td>"
                        tablaHer += "<td style='width: 420px;'>" + nombreVaeH + "</td>"
                        tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaHer += "<td style='width: 65px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        tablaHer += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: '')+ "</td>"
                        tablaHer += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                        tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        tablaHer += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        totalHer += r["parcial"]
                        totalHerRel += r["relativo"]
                        totalHerVae += r["vae_vlor"]
                        tablaHer += "</tr>"
                    }
                    if (r["grpocdgo"] == 2) {

                        def nombreVaeM = r["itemnmbr"].decodeHTML()
                        nombreVaeM = nombreVaeM.replaceAll(/</, /&lt;/)
                        nombreVaeM = nombreVaeM.replaceAll(/&/, /&amp;/)
                        nombreVaeM = nombreVaeM.replaceAll(/'/, /&apos;/)
                        nombreVaeM = nombreVaeM.replaceAll(/"/, /&quot;/)
                        nombreVaeM = nombreVaeM.replaceAll(/>/, /&gt;/)

                        tablaMano += "<tr>"
                        tablaMano += "<td style='width: 140px;'>" + r["itemcdgo"] + "</td>"
                        tablaMano += "<td style='width: 420px;'>" + nombreVaeM  + "</td>"
                        tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMano += "<td style='width: 65px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        tablaMano += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: '') + "</td>"
                        tablaMano += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                        tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        tablaMano += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        totalMan += r["parcial"]
                        totalManRel += r["relativo"]
                        totalManVae += r["vae_vlor"]
                        tablaMano += "</tr>"
                    }
                    if (r["grpocdgo"] == 1) {

                        def nombreVae = r["itemnmbr"].decodeHTML()
                        nombreVae = nombreVae.replaceAll(/</, /&lt;/)
                        nombreVae = nombreVae.replaceAll(/&/, /&amp;/)
                        nombreVae = nombreVae.replaceAll(/'/, /&apos;/)
                        nombreVae = nombreVae.replaceAll(/"/, /&quot;/)
                        nombreVae = nombreVae.replaceAll(/>/, /&gt;/)

                        bandMat = 1

                        tablaMat += "<tr>"
                        if (params.desglose != '0') {
                            tablaMat += "<td style='width: 120px;'>" + r["itemcdgo"] + "</td>"
                            tablaMat += "<td style='width: 420px;'>" + nombreVae + "</td>"
                            tablaMat += "<td style='width: 50px;'>" + '' +  "</td>"
                            tablaMat += "<td style='width: 65px;text-align: center'>" + r["unddcdgo"] + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + r["parcial"] + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: '') + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                            totalMat += r["parcial"]
                            totalMatRel += r["relativo"]
                            totalMatVae += r["vae_vlor"]
                        }
                        if (params.desglose == '0') {
                            def nombreVaeZ = r["itemnmbr"].decodeHTML()

                            nombreVaeZ = nombreVaeZ.replaceAll(/</, /&lt;/)
                            nombreVaeZ = nombreVaeZ.replaceAll(/&/, /&amp;/)
                            nombreVaeZ = nombreVaeZ.replaceAll(/'/, /&apos;/)
                            nombreVaeZ = nombreVaeZ.replaceAll(/"/, /&quot;/)
                            nombreVaeZ = nombreVaeZ.replaceAll(/>/, /&gt;/)

                            tablaMat += "<td style='width: 120px;'>" + r["itemcdgo"] + "</td>"
                            tablaMat += "<td style='width: 420px;'>" + nombreVaeZ + "</td>"
                            tablaMat += "<td style='width: 50px;text-align: right'></td>"
                            tablaMat += "<td style='width: 65px;text-align: center'>" + r["unddcdgo"] + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["rbpcpcun"] + r["parcial_t"] / r["rbrocntd"]), format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["parcial"] + r["parcial_t"]), format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["relativo"] + r["relativo_t"]), format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: '') + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                            tablaMat += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: (r["vae_vlor"]+ r["vae_vlor_t"]), format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                            totalMat += (r["parcial"] + r["parcial_t"])
                            totalMatRel += (r["relativo"] + r["relativo_t"])
                            totalMatVae += (r["vae_vlor"] + r["vae_vlor_t"])
                        }
                        tablaMat += "</tr>"
                    }
                    if (r["grpocdgo"] == 1 && params.desglose != '0') {

                        def nombreVaeT = r["itemnmbr"].decodeHTML()

                        nombreVaeT = nombreVaeT.replaceAll(/</, /&lt;/)
                        nombreVaeT = nombreVaeT.replaceAll(/&/, /&amp;/)
                        nombreVaeT = nombreVaeT.replaceAll(/'/, /&apos;/)
                        nombreVaeT = nombreVaeT.replaceAll(/"/, /&quot;/)
                        nombreVaeT = nombreVaeT.replaceAll(/>/, /&gt;/)

                        tablaTrans += "<tr>"
                        tablaTrans += "<td style='width: 140px;'>" + r["itemcdgo"] + "</td>"
                        tablaTrans += "<td style='width: 420px;'>" + nombreVaeT +"</td>"

                        if(r["tplscdgo"].trim() =='P' || r["tplscdgo"].trim() =='P1' ){
                            tablaTrans += "<td style='width: 50px;text-align: right'>" + "ton-km" + "</td>"
                        } else{
                            if(r["tplscdgo"].trim() =='V' || r["tplscdgo"].trim() =='V1' || r["tplscdgo"].trim() =='V2'){
                                tablaTrans += "<td style='width: 50px;text-align: right'>" + "m3-km" + "</td>"
                            }
                            else {
                                tablaTrans += "<td style='width: 50px;text-align: right'>" + r["unddcdgo"] + "</td>"
                            }
                        }
                        tablaTrans += "<td style='width: 65px;text-align: right'>" + g.formatNumber(number: r["itempeso"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["distancia"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["tarifa"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["parcial_t"], format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["relativo_t"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        tablaTrans += "<td style='width: 45px;text-align: right'>" + (r["itemcpac"] ?: '') + "</td>"
                        tablaTrans += "<td style='width: 45px;text-align: center'>" + r["tpbncdgo"] + "</td>"
                        tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_t"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        tablaTrans += "<td style='width: 45px;text-align: right'>" + g.formatNumber(number: r["vae_vlor_t"], format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec") + "</td>"
                        total += r["parcial_t"]
                        totalTRel += r["relativo_t"]
                        totalTVae += r["vae_vlor_t"]
                        tablaTrans += "</tr>"
                    } else {
                        tablaTrans2 += "<tr>"
                        tablaTrans2 += "<td style='width: 140px;'></td>"
                        tablaTrans2 += "<td style='width: 420px;'></td>"
                        tablaTrans2 += "<td style='width: 50px;'></td>"
                        tablaTrans2 += "<td style='width: 65px;text-align: right'></td>"
                        tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                        tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                        tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                        tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                        tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                        tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                        tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                        tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                        tablaTrans2 += "<td style='width: 45px;text-align: right'></td>"
                        tablaTrans2 += "</tr>"
                    }
                }

                tablaTrans += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: total, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td> <td style='width: 50px;text-align: right'>" +
                        "<b>${g.formatNumber(number: totalTRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                        "<b>${g.formatNumber(number: totalTVae, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
                tablaTrans += "</tbody></table>"
                tablaHer += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalHer, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td><td style='width: 50px;text-align: right'>" +
                        "<b>${g.formatNumber(number: totalHerRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                        "<b>${g.formatNumber(number: totalHerVae, format: "##,#####0", minFractionDigit1s: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
                tablaHer += "</tbody></table>"
                tablaMano += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMan, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td><td style='width: 50px;text-align: right'>" +
                        "<b>${g.formatNumber(number: totalManRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                        "<b>${g.formatNumber(number: totalManVae, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
                tablaMano += "</tbody></table>"
                tablaMat += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMat, format: "##,#####0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td><td style='width: 50px;text-align: right'>" +
                        "<b>${g.formatNumber(number: totalMatRel, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td><td></td><td></td><td></td><td style='width: 50px;text-align: right'>" +
                        "<b>${g.formatNumber(number: totalMatVae, format: "##,#####0", minFractionDigits: "2", maxFractionDigits: "2", locale: "ec")}</b></td></tr>"
                tablaMat += "</tbody></table>"
                tablaTrans2 += "</tbody></table>"
                tablaMat2 += "</tbody></table>"

                def totalRubro = 0
                totalRubro = total + totalHer + totalMan + totalMat
                def totalRelativo = totalTRel + totalHerRel + totalMatRel + totalManRel
                def totalVae = totalTVae + totalHerVae + totalMatVae + totalManVae

                def totalIndi = totalRubro * indi / 100
                tablaIndi += "<thead><tr><th class='tituloHeader'>COSTOS INDIRECTOS</th></tr><tr><th colspan='3' class='theader'></th></tr><tr><th style='width:550px' class='padTopBot'>DESCRIPCIÓN</th><th style='width:130px'>PORCENTAJE</th><th>VALOR</th></tr>    <tr><th colspan='3' class='theaderup'></th></tr>  </thead>"
                tablaIndi += "<tbody><tr><td>COSTOS INDIRECTOS</td><td style='text-align:center'>${indi}%</td><td style='text-align:right'>${g.formatNumber(number: totalIndi, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5")}</td></tr></tbody>"
                tablaIndi += "</table>"

                tablas = "<div style=\"width: 100%;margin-top: 10px;\">"

                if (params.desglose == '0') {
                    tablas += tablaHer + tablaMano + tablaMat + tablaIndi
                } else {
                    tablas += tablaHer + tablaMano + tablaMat + tablaTrans + tablaIndi
                }

                tablas += "</div>"

                footer =
                        " <table style='border-top: 1px solid #000000; border-bottom:1px solid #000000; float:right; margin-top:15px'>\n" +
                                "                    <tbody>\n" +
                                "                        <tr>\n" +
                                "                            <td style=\"width: 240px;\">\n" +
                                "                                <b>COSTO UNITARIO DIRECTO</b>\n" +
                                "                            </td>\n" +
                                "                            <td style=\"text-align: right; width:90px\"><b>" + g.formatNumber(number: totalRubro, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                                "                            </b></td>\n" +
                                "                            <td style=\"width: 120px; text-align: center\">\n" +
                                "                            <b>" + g.formatNumber (number: totalRelativo, format:"##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale:"ec") + "</b>\n" +
                                "                            </td>\n" +
                                "                            <td style=\"width: 100px\">\n" +
                                "                            </td>\n" +
                                "                            <td style=\"text-align: right; width: 40px;\">\n" +
                                "                            <b>" + g.formatNumber (number:totalVae, format:"##,##0", minFractionDigits:2, maxFractionDigits:2, locale:"ec") + "</b>\n" +
                                "                            </td>\n" +
                                "                        </tr>\n" +
                                "                        <tr>\n" +
                                "                            <td>\n" +
                                "                                <b>COSTOS INDIRECTOS</b>\n" +
                                "                            </td>\n" +
                                "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalIndi, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                                "                            </b></td>\n" +
                                "                            <td style=\"text-align: center\"><b>TOTAL</b></td>\n" +
                                "                            <td></td>\n" +
                                "                            <td style=\"text-align: center\">\n" +
                                "                            <b>TOTAL</b>\n" +
                                "                            </td>\n" +
                                "                        </tr>\n" +
                                "                        <tr>\n" +
                                "                            <td>\n" +
                                "                                <b>COSTO TOTAL DEL RUBRO</b>\n" +
                                "                            </td>\n" +
                                "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalRubro + totalIndi, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                                "                            </b></td>\n" +
                                "                            <td style=\"text-align: center\">\n" +
                                "                            <b>PESO</b>\n" +
                                "                            </td>\n" +
                                "                            <td> </td>\n" +
                                "                            <td style=\"text-align: center\">\n" +
                                "                            <b>VAE</b>\n" +
                                "                            </td>\n" +
                                "                        </tr>\n" +
                                "                        <tr>\n" +
                                "                            <td>\n" +
                                "                                <b>PRECIO UNITARIO (\$USD)</b>\n" +
                                "                            </td>\n" +
                                "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalRubro + totalIndi, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                                "\n" +
                                "                            </b></td>\n" +
                                "                            <td style=\"text-align: center\">\n" +
                                "                            <b>RELATIVO (%)</b>\n" +
                                "                            </td>\n" +
                                "                            <td> </td>\n" +
                                "                            <td style=\"text-align: center\">\n" +
                                "                            <b>(%)</b>\n" +
                                "                            </td>\n" +
                                "                        </tr>\n" +
                                "                    </tbody>\n" +

                                "</table>\n"
                if(rubro?.codigo.split('-')[0] == 'TR') {
                    footer += "<div style='margin-top:40px'><strong>Distancia General de Transporte:</strong> D= ${obra?.distanciaDesalojo} km</div>"
                    footer += "<div><b>Nota:</b> Los cálculos se hacen con todos los decimales y el resultado final se lo redondea a dos decimales</div>"
                } else {
                    footer += "<div style='margin-top:40px'><b>Nota:</b> Los cálculos se hacen con todos los decimales y el resultado final se lo redondea a dos decimales</div>"
                }

                html += "<div class='divRubro'>" + header + tablas + footer + "</div>"
            }
            [html: html]
    }

    def reporteGarantiasVigentes () {

        def estadoRev = EstadoGarantia.get(3)
        def estadoDev = EstadoGarantia.get(6)
        def hoy = new Date()
        def garantias =  Garantia.withCriteria {
            ne("estado", estadoRev)
            ne("estado", estadoDev)
            lt("fechaFinalizacion", hoy)
        }

        def auxiliar = Auxiliar.get(1)
        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead4 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellHead5 = [border: Color.WHITE,
                             align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellRight2 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft2 = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE, align: Element.ALIGN_LEFT]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2,
                    prmsCellRight: prmsCellRight, prmsCellHead2: prmsCellHead2, prmsCellLeft2: prmsCellLeft2]

        def baos = new ByteArrayOutputStream()
        def name = "garantias_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times10normal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal]

        Document document
        document = new Document(PageSize.A4.rotate());
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Garantias " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();

        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("REPORTE DE GARANTÍAS VENCIDAS", times14bold ))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("Quito, " + printFecha(new Date()), times12bold));
        headers.add(new Paragraph(" ", times10bold));

        PdfPTable tablaGarantia = new PdfPTable(12);
        tablaGarantia.setWidthPercentage(100);
        tablaGarantia.setWidths(arregloEnteros([10,15,10,10,5,10,10,10,10,10,10,10]))

        addCellTabla(tablaGarantia, new Paragraph("N° Contrato", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Contratista", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Tipo de Garantía", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("N° Garantía", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Rnov", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Original", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Aseguradora", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Documento", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Estado", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Monto", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Emisión", times8bold), prmsCellHead2)
        addCellTabla(tablaGarantia, new Paragraph("Vencimiento", times8bold), prmsCellHead2)

        garantias.each {
            addCellTabla(tablaGarantia, new Paragraph(it?.contrato?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.contrato?.oferta?.proveedor?.nombre, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.tipoGarantia?.descripcion, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(g.formatNumber(number: it?.numeroRenovaciones, format: "###,###", locale: "ec", maxFractionDigits: 0, minFractionDigits: 0), times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.padre?.codigo, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.aseguradora?.nombre, times8normal), prmsCellHead4)
            addCellTabla(tablaGarantia, new Paragraph(it?.tipoDocumentoGarantia?.descripcion, times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.estado?.descripcion, times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(g.formatNumber(number: it?.monto, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8normal), prmsCellHead5)
            addCellTabla(tablaGarantia, new Paragraph(it?.fechaInicio.format("dd-MM-yyyy"), times8normal), prmsCellHead3)
            addCellTabla(tablaGarantia, new Paragraph(it?.fechaFinalizacion.format("dd-MM-yyyy"), times8normal), prmsCellHead3)
        }

        document.add(headers)
        document.add(tablaGarantia)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

}