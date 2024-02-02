package janus

import org.apache.poi.ss.usermodel.HorizontalAlignment
import org.apache.poi.ss.usermodel.Row
import org.apache.poi.ss.usermodel.Sheet
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFCellStyle
import org.apache.poi.xssf.usermodel.XSSFFont
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import seguridad.Persona

class ReportesExcel2Controller {

    def dbConnectionService
    def preciosService
    def reportesService


    def reporteExcelVolObra() {

        def obra = Obra.get(params.id)
        def detalle = VolumenesObra.findAllByObra(obra, [sort: "orden"])
        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()

        def precios = [:]
        def fecha = obra.fechaPreciosRubros
        def dsps = obra.distanciaPeso
        def dsvl = obra.distanciaVolumen
        def lugar = obra.lugar
        def subPre
        preciosService.ac_rbroObra(obra.id)

        def valores

        if (params.sub)
            if (params.sub == '-1') {
                valores = preciosService.rbro_pcun_v2(obra.id)
            } else {
                valores = preciosService.rbro_pcun_v3(obra.id, params.sub)
            }
        else
            valores = preciosService.rbro_pcun_v2(obra.id)

        if (params.sub == '-1' || params.sub == null) {
            subPre = subPres?.descripcion
        } else {
            subPre = SubPresupuesto.get(params.sub).descripcion
        }

        def total1 = 0;
        def totales = 0
        def totalPresupuesto = 0;

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("Volúmenes")
        sheet.setColumnWidth(0, 5 * 256);
        sheet.setColumnWidth(1, 15 * 256);
        sheet.setColumnWidth(2, 15 * 256);
        sheet.setColumnWidth(3, 50 * 256);
        sheet.setColumnWidth(4, 10 * 256);
        sheet.setColumnWidth(5, 10 * 256);
        sheet.setColumnWidth(6, 10 * 256);
        sheet.setColumnWidth(7, 10 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("DGCP - COORDINACIÓN DE FIJACIÓN DE PRECIOS")
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("PRESUPUESTO")
        row2.setRowStyle(style)
        Row rowE = sheet.createRow(4)
        rowE.createCell(1).setCellValue("")
        Row row3 = sheet.createRow(5)
        row3.createCell(1).setCellValue("FECHA: " + obra?.fechaCreacionObra?.format('dd-MM-yyyy'))
        row3.setRowStyle(style)
        Row row4 = sheet.createRow(6)
        row4.createCell(1).setCellValue("FECHA ACT. PRECIOS: " + obra?.fechaPreciosRubros?.format("dd-MM-yyyy"))
        row4.setRowStyle(style)
        Row row5 = sheet.createRow(7)
        row5.createCell(1).setCellValue("NOMBRE: " + obra?.nombre)
        row5.setRowStyle(style)
        Row row6 = sheet.createRow(8)
        row6.createCell(1).setCellValue("DOC. REFERENCIA: " + (obra?.oficioIngreso ?: '') + "  " + (obra?.referencia ?: ''))
        row6.setRowStyle(style)
        Row row7 = sheet.createRow(9)
        row7.createCell(1).setCellValue("MEMO CANT. DE OBRA: " + (obra?.memoCantidadObra ?: ''))
        row7.setRowStyle(style)

        def fila = 11

        def ultimaFila

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("N°")
        rowC1.createCell(1).setCellValue("CÓDIGO")
        rowC1.createCell(2).setCellValue("SUBPRESUPUESTO")
        rowC1.createCell(3).setCellValue("RUBRO")
        rowC1.createCell(4).setCellValue("UNIDAD")
        rowC1.createCell(5).setCellValue("CANTIDAD")
        rowC1.createCell(6).setCellValue("UNITARIO")
        rowC1.createCell(7).setCellValue("C.TOTAL")
        rowC1.setRowStyle(style)
        fila++

        valores.eachWithIndex { p, i->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue("${i + 1}")
            rowF1.createCell(1).setCellValue(p.rbrocdgo ?: '')
            rowF1.createCell(2).setCellValue(p.sbprdscr ?: '')
            rowF1.createCell(3).setCellValue(p.rbronmbr ?: '')
            rowF1.createCell(4).setCellValue(p.unddcdgo ?: '')
            rowF1.createCell(5).setCellValue(p.vlobcntd ?: 0)
            rowF1.createCell(6).setCellValue(p.pcun ?: 0)
            rowF1.createCell(7).setCellValue(p.totl ?: 0)
            fila++
            totales = p.totl
            totalPresupuesto = (total1 += totales);
            ultimaFila = fila
        }

        Row rowT = sheet.createRow(fila)
        rowT.createCell(6).setCellValue("TOTAL")
        rowT.createCell(7).setCellValue(totalPresupuesto)
        rowT.setRowStyle(style)
        fila++

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "volObra.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def reporteVaeExcel () {

        def obra = Obra.get(params.id)
        def detalle = VolumenesObra.findAllByObra(obra, [sort: "orden"])
        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()

        def subPre
        def valores

        if (params.sub) {
            if (params.sub == '-1') {
                valores = preciosService.rbro_pcun_vae(obra?.id)
            } else {
                valores = preciosService.rbro_pcun_vae2(obra?.id, params.sub)
            }
        }
        else {
            valores = preciosService.rbro_pcun_vae(obra.id)
        }

        if (params.sub != '-1'){
            subPre= SubPresupuesto.get(params.sub).descripcion
        }else {
            subPre= -1
        }

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

        def total1 = 0;
        def totales = 0
        def totalPresupuesto = 0;
        def vaeTotal = 0
        def vaeTotal1 = 0
        def totalVae= 0
        def filaSub = 17
        def ultimaFila = 0

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("VAE")
        sheet.setColumnWidth(0, 5 * 256);
        sheet.setColumnWidth(1, 15 * 256);
        sheet.setColumnWidth(2, 25 * 256);
        sheet.setColumnWidth(3, 60 * 256);
        sheet.setColumnWidth(4, 20 * 256);
        sheet.setColumnWidth(5, 10 * 256);
        sheet.setColumnWidth(6, 12 * 256);
        sheet.setColumnWidth(7, 10 * 256);
        sheet.setColumnWidth(8, 15 * 256);
        sheet.setColumnWidth(9, 15 * 256);
        sheet.setColumnWidth(10, 15 * 256);
        sheet.setColumnWidth(11, 15 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("DGCP - COORDINACIÓN DE FIJACIÓN DE PRECIOS")
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("PRESUPUESTO")
        row2.setRowStyle(style)
        Row row25 = sheet.createRow(3)
        row25.createCell(1).setCellValue("REQUIRENTE: " + obra?.departamento?.direccion?.nombre)
        row25.setRowStyle(style)
        Row rowE = sheet.createRow(4)
        rowE.createCell(1).setCellValue("")
        Row row3 = sheet.createRow(5)
        row3.createCell(1).setCellValue("FECHA: " + obra?.fechaCreacionObra?.format('dd-MM-yyyy'))
        row3.setRowStyle(style)
        Row row4 = sheet.createRow(6)
        row4.createCell(1).setCellValue("FECHA Act. P.U: " + obra?.fechaPreciosRubros?.format("dd-MM-yyyy"))
        row4.setRowStyle(style)
        Row row5 = sheet.createRow(7)
        row5.createCell(1).setCellValue("NOMBRE: " + obra?.nombre)
        row5.setRowStyle(style)
        Row row6 = sheet.createRow(8)
        row6.createCell(1).setCellValue("MEMO CANT. DE OBRA: " + (obra?.memoCantidadObra ?: ''))
        row6.setRowStyle(style)
        Row row7 = sheet.createRow(9)
        row7.createCell(1).setCellValue("CÓDIGO OBRA: " + obra?.codigo)
        row7.setRowStyle(style)
        Row row8 = sheet.createRow(10)
        row8.createCell(1).setCellValue("DOC. REFERENCIA: " + (obra?.oficioIngreso ?: '') + "  " + (obra?.referencia ?: ''))
        row8.setRowStyle(style)

        def fila = 12

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("N°")
        rowC1.createCell(1).setCellValue("CÓDIGO")
        rowC1.createCell(2).setCellValue("ESPEC")
        rowC1.createCell(3).setCellValue("RUBRO")
        rowC1.createCell(4).setCellValue("DESCRIPCIÓN")
        rowC1.createCell(5).setCellValue("UNIDAD")
        rowC1.createCell(6).setCellValue("CANTIDAD")
        rowC1.createCell(7).setCellValue("P.U.")
        rowC1.createCell(8).setCellValue("C.TOTAL")
        rowC1.createCell(9).setCellValue("PESO RELATIVO")
        rowC1.createCell(10).setCellValue("VAE RUBRO")
        rowC1.createCell(11).setCellValue("VAE TOTAL")
        rowC1.setRowStyle(style)
        fila++

        subPres.each {sp->

            Row rowC2 = sheet.createRow(fila)
            rowC2.createCell(0).setCellValue("Subpresupuesto: " + sp?.descripcion?.toString())
            rowC2.setRowStyle(style)
            fila++

            valores.each {val->
                if(val.sbpr__id == sp.id){

                    Row rowF1 = sheet.createRow(fila)
                    rowF1.createCell(0).setCellValue(val.vlobordn ?: '')
                    rowF1.createCell(1).setCellValue(val.rbrocdgo.toString() ?: '')
                    rowF1.createCell(2).setCellValue(val?.itemcdes?.toString() ?: '')
                    rowF1.createCell(3).setCellValue(val.rbronmbr.toString() ?: '')
                    rowF1.createCell(4).setCellValue(val?.vlobdscr?.toString() ?: '')
                    rowF1.createCell(5).setCellValue(val.unddcdgo.toString() ?: '')
                    rowF1.createCell(6).setCellValue(val.vlobcntd ?: 0)
                    rowF1.createCell(7).setCellValue(val.pcun ?: 0)
                    rowF1.createCell(8).setCellValue(val.totl ?: 0)
                    rowF1.createCell(9).setCellValue(val.relativo ?: 0)
                    rowF1.createCell(10).setCellValue(val.vae_rbro != null ? val.vae_rbro : 0)
                    rowF1.createCell(11).setCellValue(val.vae_totl != null ? val.vae_totl : 0)

                    fila++
                    filaSub++
                    totales = val.totl
                    if(val.vae_totl != null){
                        vaeTotal = val.vae_totl
                    }else{
                        vaeTotal = 0
                    }

                    totalPresupuesto = (total1 += totales);
                    totalVae = (vaeTotal1 += vaeTotal)
                    ultimaFila = fila
                }
            }

            fila++
            filaSub++
        }

        Row rowT = sheet.createRow(ultimaFila)
        rowT.createCell(7).setCellValue("TOTAL")
        rowT.createCell(8).setCellValue(totalPresupuesto)
        rowT.createCell(9).setCellValue(100)
        rowT.createCell(11).setCellValue(totalVae)
        rowT.setRowStyle(style)

        Row rowT2 = sheet.createRow(ultimaFila + 2)
        rowT2.createCell(1).setCellValue("CONDICIONES DEL CONTRATO")
        rowT2.setRowStyle(style)
        Row rowT3 = sheet.createRow(ultimaFila + 3)
        rowT3.createCell(1).setCellValue("Plazo de Ejecución:")
        rowT3.createCell(2).setCellValue(obra?.plazoEjecucionMeses + " mes(meses)")
        rowT3.setRowStyle(style)
        Row rowT4 = sheet.createRow(ultimaFila + 4)
        rowT4.createCell(1).setCellValue("Anticipo:")
        rowT4.createCell(2).setCellValue(obra?.porcentajeAnticipo + " %")
        rowT4.setRowStyle(style)
        Row rowT5 = sheet.createRow(ultimaFila + 5)
        rowT5.createCell(1).setCellValue("Elaboró: ")
        rowT5.createCell(2).setCellValue((obra?.responsableObra?.titulo ?: '') + (obra?.responsableObra?.nombre ?: '') + ' ' + (obra?.responsableObra?.apellido ?: ''))
        rowT5.setRowStyle(style)

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "volObraVAE.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def reporteDesgloseExcelVolObra() {
        def obra = Obra.get(params.id)
        def detalle
        detalle = VolumenesObra.findAllByObra(obra, [sort: "orden"])
        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()

        def precios = [:]
        def fecha = obra.fechaPreciosRubros
        def dsps = obra.distanciaPeso
        def dsvl = obra.distanciaVolumen
        def lugar = obra.lugar
        def prch = 0
        def prvl = 0
        def subPre

        def parcialEquipo = 0
        def parcialMano = 0
        def parcialMateriales = 0
        def parcialTransporte = 0
        def valorIndirectoObra = obra.totales
        def indirectos = 0

        preciosService.ac_rbroObra(obra.id)

        def valores

        if (params.sub)
            if (params.sub == '-1') {
                valores = preciosService.rbro_pcun_v2(obra.id)
            } else {
                valores = preciosService.rbro_pcun_v3(obra.id, params.sub)
            }
        else
            valores = preciosService.rbro_pcun_v2(obra.id)

        if (params.sub == '-1' || params.sub == null) {
            subPre = subPres?.descripcion
        } else {
            subPre = SubPresupuesto.get(params.sub).descripcion
        }

        def total1 = 0;
        def totales = 0
        def totalPresupuesto = 0;
        def numero = 1;
        def ultimaFila

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("DESGLOSE")
        sheet.setColumnWidth(0, 5 * 256);
        sheet.setColumnWidth(1, 15 * 256);
        sheet.setColumnWidth(2, 25 * 256);
        sheet.setColumnWidth(3, 60 * 256);
        sheet.setColumnWidth(4, 10 * 256);
        sheet.setColumnWidth(5, 10 * 256);
        sheet.setColumnWidth(6, 4 * 256);
        sheet.setColumnWidth(7, 10 * 256);
        sheet.setColumnWidth(8, 15 * 256);
        sheet.setColumnWidth(9, 4 * 256);
        sheet.setColumnWidth(10, 15 * 256);
        sheet.setColumnWidth(11, 15 * 256);
        sheet.setColumnWidth(12, 4 * 256);
        sheet.setColumnWidth(13, 15 * 256);
        sheet.setColumnWidth(14, 15 * 256);
        sheet.setColumnWidth(15, 4 * 256);
        sheet.setColumnWidth(16, 15 * 256);
        sheet.setColumnWidth(17, 15 * 256);
        sheet.setColumnWidth(18, 4 * 256);
        sheet.setColumnWidth(19, 15 * 256);
        sheet.setColumnWidth(20, 4 * 256);
        sheet.setColumnWidth(21, 15 * 256);
        sheet.setColumnWidth(22, 15 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("DGCP - COORDINACIÓN DE FIJACIÓN DE PRECIOS")
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("PRESUPUESTO")
        row2.setRowStyle(style)
        Row rowE = sheet.createRow(4)
        rowE.createCell(1).setCellValue("")
        Row row3 = sheet.createRow(5)
        row3.createCell(1).setCellValue("FECHA: " + obra?.fechaCreacionObra?.format('dd-MM-yyyy'))
        row3.setRowStyle(style)
        Row row4 = sheet.createRow(6)
        row4.createCell(1).setCellValue("FECHA ACT. PRECIOS: " + obra?.fechaPreciosRubros?.format("dd-MM-yyyy"))
        row4.setRowStyle(style)
        Row row5 = sheet.createRow(7)
        row5.createCell(1).setCellValue("NOMBRE: " + obra?.nombre)
        row5.setRowStyle(style)
        Row row6 = sheet.createRow(8)
        row6.createCell(1).setCellValue("DOC. REFERENCIA: " + (obra?.oficioIngreso ?: '') + "  " + (obra?.referencia ?: ''))
        row6.setRowStyle(style)
        Row row7 = sheet.createRow(9)
        row7.createCell(1).setCellValue("MEMO CANT. DE OBRA: " + (obra?.memoCantidadObra ?: ''))
        row7.setRowStyle(style)

        def fila = 11

        Row rowC0 = sheet.createRow(fila)
        rowC0.createCell(7).setCellValue("Mano de Obra")
        rowC0.createCell(10).setCellValue("Equipos")
        rowC0.createCell(13).setCellValue("Materiales")
        rowC0.createCell(16).setCellValue("Transporte")
        rowC0.createCell(21).setCellValue("Totales")
        rowC0.setRowStyle(style)
        fila++

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("N°")
        rowC1.createCell(1).setCellValue("CÓDIGO")
        rowC1.createCell(2).setCellValue("SUBPRESUPUESTO")
        rowC1.createCell(3).setCellValue("RUBRO")
        rowC1.createCell(4).setCellValue("UNIDAD")
        rowC1.createCell(5).setCellValue("CANTIDAD")
        rowC1.createCell(6).setCellValue("")
        rowC1.createCell(7).setCellValue("C.U.")
        rowC1.createCell(8).setCellValue("TOTAL")
        rowC1.createCell(9).setCellValue("")
        rowC1.createCell(10).setCellValue("C.U.")
        rowC1.createCell(11).setCellValue("TOTAL")
        rowC1.createCell(12).setCellValue("")
        rowC1.createCell(13).setCellValue("C.U.")
        rowC1.createCell(14).setCellValue("TOTAL")
        rowC1.createCell(15).setCellValue("")
        rowC1.createCell(16).setCellValue("C.U.")
        rowC1.createCell(17).setCellValue("TOTAL")
        rowC1.createCell(18).setCellValue("")
        rowC1.createCell(19).setCellValue("INDIRECTOS")
        rowC1.createCell(20).setCellValue("")
        rowC1.createCell(21).setCellValue("C.U.")
        rowC1.createCell(22).setCellValue("TOTAL")
        rowC1.setRowStyle(style)
        fila++

        valores.each {

            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(numero++)
            rowF1.createCell(1).setCellValue(it.rbrocdgo.toString() ?: '')
            rowF1.createCell(2).setCellValue(it.sbprdscr.toString() ?: '')
            rowF1.createCell(3).setCellValue(it.rbronmbr.toString() ?: '')
            rowF1.createCell(4).setCellValue(it.unddcdgo.toString() ?: '')
            rowF1.createCell(5).setCellValue(it.vlobcntd ?: '')

            parcialMano = 0
            parcialEquipo = 0
            parcialMateriales = 0

            def res = preciosService.precioUnitarioVolumenObraAsc("*", obra.id, it.item__id)

            res.each{ r->
                if(r.grpocdgo == 3){
                    parcialMano += (r.parcial + r.parcial_t)
                }

                if(r.grpocdgo == 2){
                    parcialEquipo += (r.parcial + r.parcial_t)
                }

                if(r.grpocdgo == 1){
                    parcialMateriales += (r.parcial + r.parcial_t)
                }

                if(r.grpocdgo == 1){
                    parcialTransporte += r.parcial_t
                }
            }

            // mano obra
            rowF1.createCell(7).setCellValue(parcialMano)
            rowF1.createCell(8).setCellValue((parcialMano * it.vlobcntd) ?: '')

            //equipos
            rowF1.createCell(10).setCellValue(parcialEquipo)
            rowF1.createCell(11).setCellValue((parcialEquipo * it.vlobcntd) ?: '')

            //materiales
            rowF1.createCell(13).setCellValue(parcialMateriales)
            rowF1.createCell(14).setCellValue((parcialMateriales * it.vlobcntd) ?: '')

            //transporte
            rowF1.createCell(16).setCellValue(parcialTransporte)
            rowF1.createCell(17).setCellValue((parcialTransporte * it.vlobcntd) ?: '')

            //indirectos

            indirectos = parcialMano + parcialEquipo + parcialMateriales + parcialTransporte
            def totalIndirectos = indirectos?.toDouble() * valorIndirectoObra?.toDouble() / 100
            rowF1.createCell(19).setCellValue(totalIndirectos)

            //totales

            def parcialCuTotal = indirectos + totalIndirectos
            rowF1.createCell(21).setCellValue(parcialCuTotal)
            rowF1.createCell(22).setCellValue(it.totl)

            fila++
            totales = it.totl
            totalPresupuesto = (total1 += totales);
            ultimaFila = fila
        }


        def output = response.getOutputStream()
        def header = "attachment; filename=" + "volObraDesglose.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def reporteExcelComposicion() {

        if (!params.tipo) {
            params.tipo = "-1"
        }

        if (params.tipo == "-1") {
            params.tipo = "1,2,3"
        }

        if (!params.sp) {
            params.sp = '-1'
        }
        def wsp = ""

        if (params.sp.toString() != "-1") {
            wsp = "      AND v.sbpr__id = ${params.sp} \n"
        }

        def obra = Obra.get(params.id)

        def sql = "SELECT\n" +
                "  v.voit__id                            id,\n" +
                "  i.itemcdgo                            codigo,\n" +
                "  i.itemnmbr                            item,\n" +
                "  u.unddcdgo                            unidad,\n" +
                "  v.voitcntd                            cantidad,\n" +
                "  v.voitpcun                            punitario,\n" +
                "  v.voittrnp                            transporte,\n" +
                "  v.voitpcun + v.voittrnp               costo,\n" +
                "  (v.voitpcun + v.voittrnp)*v.voitcntd  total,\n" +
                "  d.dprtdscr                            departamento,\n" +
                "  s.sbgrdscr                            subgrupo,\n" +
                "  g.grpodscr                            grupo,\n" +
                "  g.grpo__id                            grid,\n" +
                "  v.sbpr__id                            sp,\n" +
                "  b.sbprdscr                            subpresupuesto\n" +
                "FROM vlobitem v\n" +
                "LEFT JOIN item i ON v.item__id = i.item__id\n" +
                "LEFT JOIN undd u ON i.undd__id = u.undd__id\n" +
                "LEFT JOIN dprt d ON i.dprt__id = d.dprt__id\n" +
                "LEFT JOIN sbgr s ON d.sbgr__id = s.sbgr__id\n" +
                "LEFT JOIN sbpr b ON v.sbpr__id = b.sbpr__id\n" +
                "LEFT JOIN grpo g ON s.grpo__id = g.grpo__id AND g.grpo__id IN (${params.tipo})\n" +
                "WHERE v.obra__id = ${params.id} \n" + wsp +
                "ORDER BY v.sbpr__id, grid ASC, i.itemnmbr"

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString())

        def totalE = 0;
        def totalM = 0;
        def totalMO = 0;
        def totalEquipo = 0;
        def totalManoObra = 0;
        def totalMaterial = 0;
        def totalDirecto = 0;
        def ultimaFila = 0

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("COMPOSICION")
        sheet.setColumnWidth(0, 15 * 256);
        sheet.setColumnWidth(1, 60 * 256);
        sheet.setColumnWidth(2, 10 * 256);
        sheet.setColumnWidth(3, 15 * 256);
        sheet.setColumnWidth(4, 15 * 256);
        sheet.setColumnWidth(5, 15 * 256);
        sheet.setColumnWidth(6, 20 * 256);
        sheet.setColumnWidth(7, 15 * 256);
        sheet.setColumnWidth(8, 15 * 256);
        sheet.setColumnWidth(9, 25 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("COMPOSICIÓN: " + obra?.nombre)
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("CÓDIGO: " + obra?.codigo)
        row2.setRowStyle(style)
        Row rowE = sheet.createRow(4)
        rowE.createCell(1).setCellValue("")
        Row row3 = sheet.createRow(5)
        row3.createCell(1).setCellValue("FECHA: " + obra?.fechaCreacionObra?.format('dd-MM-yyyy'))
        row3.setRowStyle(style)
        Row row4 = sheet.createRow(6)
        row4.createCell(1).setCellValue("FECHA ACT.PRECIOS: " + obra?.fechaPreciosRubros?.format("dd-MM-yyyy"))
        row4.setRowStyle(style)

        def fila = 8

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("CÓDIGO")
        rowC1.createCell(1).setCellValue("ITEM")
        rowC1.createCell(2).setCellValue("UNIDAD")
        rowC1.createCell(3).setCellValue("CANTIDAD")
        rowC1.createCell(4).setCellValue("P.UNITARIO")
        rowC1.createCell(5).setCellValue("TRANSPORTE")
        rowC1.createCell(6).setCellValue("COSTO")
        rowC1.createCell(7).setCellValue("TOTAL")
        rowC1.createCell(8).setCellValue("TIPO")
        rowC1.createCell(9).setCellValue("SUBPRESUPUESTO")
        rowC1.setRowStyle(style)
        fila++

        if (res.size() > 0) {

            res.each {
                if (it?.item == null) {
                    it?.item = " "
                }
                if (it?.cantidad == null) {
                    it?.cantidad = 0
                }
                if (it?.punitario == null) {
                    it?.punitario = 0
                }
                if (it?.transporte == null) {
                    it?.transporte = 0
                }
                if (it?.costo == null) {
                    it?.costo = 0
                }
                if (it?.total == null) {
                    it?.total = 0
                }

                Row rowF1 = sheet.createRow(fila)
                rowF1.createCell(0).setCellValue(it?.codigo?.toString() ?: '')
                rowF1.createCell(1).setCellValue(it?.item?.toString() ?: '')
                rowF1.createCell(2).setCellValue(it?.unidad ? it?.unidad?.toString() : '')
                rowF1.createCell(3).setCellValue( it?.cantidad?.toDouble() ?: 0)
                rowF1.createCell(4).setCellValue(it?.punitario?.toDouble()?.round(6) ?: 0)
                rowF1.createCell(5).setCellValue(it?.transporte?.toDouble() ?: 0)
                rowF1.createCell(6).setCellValue( it?.costo?.toDouble() ?: 0)
                rowF1.createCell(7).setCellValue(it?.total?.toDouble() ?: 0)
                rowF1.createCell(8).setCellValue(it?.grupo ? it?.grupo?.toString() : "")
                rowF1.createCell(9).setCellValue(it?.subpresupuesto ? it?.subpresupuesto?.toString() : "")
                fila++

                if (it?.grid == 1) {
                    totalMaterial = (totalM += (it?.total ?: 0))
                }
                if (it?.grid == 2) {
                    totalManoObra = (totalMO += (it?.total ?: 0))
                }
                if (it?.grid == 3) {
                    totalEquipo = (totalE += (it?.total ?: 0))
                }
                totalDirecto = totalEquipo + totalManoObra + totalMaterial;
                ultimaFila = fila
            }

            Row rowT = sheet.createRow(ultimaFila)
            rowT.createCell(6).setCellValue("Total Materiales: ")
            rowT.createCell(7).setCellValue(totalMaterial.toDouble()?.round(2) ?: 0)
            rowT.setRowStyle(style)
            Row rowT2 = sheet.createRow(ultimaFila + 1)
            rowT2.createCell(6).setCellValue("Total Mano de Obra: ")
            rowT2.createCell(7).setCellValue(totalManoObra.toDouble()?.round(2) ?: 0)
            rowT2.setRowStyle(style)
            Row rowT3 = sheet.createRow(ultimaFila + 2)
            rowT3.createCell(6).setCellValue("Total Equipos: ")
            rowT3.createCell(7).setCellValue(totalEquipo.toDouble()?.round(2) ?: 0)
            rowT3.setRowStyle(style)
            Row rowT4 = sheet.createRow(ultimaFila + 3)
            rowT4.createCell(6).setCellValue("TOTAL DIRECTO: ")
            rowT4.createCell(7).setCellValue(totalDirecto.toDouble()?.round(2) ?: 0)
            rowT4.setRowStyle(style)
            Row rowT5 = sheet.createRow(ultimaFila + 4)
            rowT5.createCell(6).setCellValue("TOTAL INDIRECTO: ")
            rowT5.createCell(7).setCellValue(obra?.valor ? (obra?.valor - totalDirecto) : 0)
            rowT5.setRowStyle(style)
            Row rowT6 = sheet.createRow(ultimaFila + 5)
            rowT6.createCell(6).setCellValue("TOTAL: ")
            rowT6.createCell(7).setCellValue(obra?.valor?.round(2) ?: 0)
            rowT6.setRowStyle(style)
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "composicion.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def reporteExcelComposicionTotales() {

        if (!params.tipo) {
            params.tipo = "-1"
        }
        if (!params.sp) {
            params.sp = '-1'
        }
        if (params.tipo == "-1") {
            params.tipo = "1,2,3"
        }

        def wsp = ""

        if (params.sp.toString() != "-1") {
            wsp = "      AND v.sbpr__id = ${params.sp} \n"
        }

        def obra = Obra.get(params.id)

        def sql = "SELECT\n" +
                "  i.itemcdgo              codigo,\n" +
                "  i.itemnmbr              item,\n" +
                "  u.unddcdgo              unidad,\n" +
                "  sum(v.voitcntd)         cantidad,\n" +
                "  v.voitpcun              punitario,\n" +
                "  v.voittrnp              transporte,\n" +
                "  v.voitpcun + v.voittrnp costo,\n" +
                "  d.dprtdscr              departamento,\n" +
                "  s.sbgrdscr              subgrupo,\n" +
                "  g.grpodscr              grupo,\n" +
                "  g.grpo__id              grid\n" +
                "FROM vlobitem v\n" +
                "  LEFT JOIN item i ON v.item__id = i.item__id\n" +
                "  LEFT JOIN undd u ON i.undd__id = u.undd__id\n" +
                "  LEFT JOIN dprt d ON i.dprt__id = d.dprt__id\n" +
                "  LEFT JOIN sbgr s ON d.sbgr__id = s.sbgr__id\n" +
                "  LEFT JOIN grpo g ON s.grpo__id = g.grpo__id AND g.grpo__id IN (${params.tipo})\n" +
                "WHERE v.obra__id = ${params.id} \n" +
                "GROUP BY i.itemcdgo, i.itemnmbr, u.unddcdgo, v.voitpcun, v.voittrnp, d.dprtdscr, s.sbgrdscr, g.grpodscr,\n" +
                "  g.grpo__id\n" +
                "ORDER BY grid ASC, i.itemnmbr"


        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString())

        def label
        def number
        def totalE = 0;
        def totalM = 0;
        def totalMO = 0;
        def ultimaFila = 0

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("COMPOSICION")
        sheet.setColumnWidth(0, 15 * 256);
        sheet.setColumnWidth(1, 60 * 256);
        sheet.setColumnWidth(2, 10 * 256);
        sheet.setColumnWidth(3, 15 * 256);
        sheet.setColumnWidth(4, 15 * 256);
        sheet.setColumnWidth(5, 15 * 256);
        sheet.setColumnWidth(6, 20 * 256);
        sheet.setColumnWidth(7, 15 * 256);
        sheet.setColumnWidth(8, 15 * 256);
        sheet.setColumnWidth(9, 25 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("COMPOSICIÓN: " + obra?.nombre)
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue(obra?.departamento?.direccion?.nombre ?: '')
        row2.setRowStyle(style)
        Row row3 = sheet.createRow(4)
        row3.createCell(1).setCellValue("CÓDIGO: " + obra?.codigo)
        row3.setRowStyle(style)
        Row row4 = sheet.createRow(5)
        row4.createCell(1).setCellValue("DOC. REFERENCIA: " + obra?.oficioIngreso)
        row4.setRowStyle(style)
        Row rowE = sheet.createRow(6)
        rowE.createCell(1).setCellValue("")
        Row row5 = sheet.createRow(6)
        row5.createCell(1).setCellValue("FECHA: " + obra?.fechaCreacionObra?.format('dd-MM-yyyy'))
        row5.setRowStyle(style)
        Row row6 = sheet.createRow(7)
        row6.createCell(1).setCellValue("FECHA ACT.PRECIOS: " + obra?.fechaPreciosRubros?.format("dd-MM-yyyy"))
        row6.setRowStyle(style)

        def fila = 9

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("CÓDIGO")
        rowC1.createCell(1).setCellValue("ITEM")
        rowC1.createCell(2).setCellValue("UNIDAD")
        rowC1.createCell(3).setCellValue("CANTIDAD")
        rowC1.createCell(4).setCellValue("C. REDONDEADA")
        rowC1.createCell(5).setCellValue("P.UNITARIO")
        rowC1.createCell(6).setCellValue("TRANSPORTE")
        rowC1.createCell(7).setCellValue("COSTO")
        rowC1.createCell(8).setCellValue("TIPO")
        rowC1.setRowStyle(style)
        fila++

        res.each {
            if (it?.item == null) {
                it?.item = " "
            }
            if (it?.cantidad == null) {
                it?.cantidad = 0
            }
            if (it?.punitario == null) {
                it?.punitario = 0
            }
            if (it?.transporte == null) {
                it?.transporte = 0
            }
            if (it?.costo == null) {
                it?.costo = 0
            }

            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(it?.codigo?.toString() ?: '')
            rowF1.createCell(1).setCellValue(it?.item?.toString() ?: '')
            rowF1.createCell(2).setCellValue(it?.unidad ? it?.unidad?.toString() : '')
            rowF1.createCell(3).setCellValue( it?.cantidad?.toDouble() ?: 0)
            rowF1.createCell(4).setCellValue( 0)
            rowF1.createCell(5).setCellValue(it?.punitario?.toDouble()?.round(6) ?: 0)
            rowF1.createCell(6).setCellValue(it?.transporte?.toDouble() ?: 0)
            rowF1.createCell(7).setCellValue( it?.costo?.toDouble() ?: 0)
            rowF1.createCell(8).setCellValue(it?.grupo ? it?.grupo?.toString() : "")
            fila++

            ultimaFila = fila
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "composicionTotales.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def reportePreciosExcel() {


        println("params " + params)

        def orden = "itemnmbr"
        if (params.orden == "n") {
            orden = "itemcdgo"
        }

        def estado = ''

        if(params.estado == 'true'){
            estado = 'A'
        }else{
            estado = 'B'
        }

        def grupo = Grupo.get(params.grupo.toLong())
        def lugar = Lugar.get(params.lugar.toLong())
        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def items = ""
        def lista = Item.withCriteria {
            eq("tipoItem", TipoItem.findByCodigo("I"))
            eq("estado", estado)
            departamento {
                subgrupo {
                    eq("grupo", grupo)
                }
            }
        }
        lista.id.each {
            if (items != "") {
                items += ","
            }
            items += it
        }
        def res = []
//        println items
        def tmp = preciosService.getPrecioRubroItemOrder(fecha, lugar, items, orden, "asc")
        tmp.each {
            res.add(PrecioRubrosItems.get(it))
        }

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("PRECIOS")
        sheet.setColumnWidth(0, 15 * 256);
        sheet.setColumnWidth(1, 60 * 256);
        sheet.setColumnWidth(2, 10 * 256);
        sheet.setColumnWidth(3, 15 * 256);
        sheet.setColumnWidth(4, 15 * 256);
        sheet.setColumnWidth(5, 15 * 256);
        sheet.setColumnWidth(6, 20 * 256);
        sheet.setColumnWidth(7, 15 * 256);
        sheet.setColumnWidth(8, 15 * 256);
        sheet.setColumnWidth(9, 25 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("REPORTE COSTOS DE: ${grupo.descripcion.toUpperCase()}")
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("LISTA DE PRECIOS: " + lugar?.descripcion)
        row2.setRowStyle(style)
        Row row3 = sheet.createRow(4)
        row3.createCell(1).setCellValue("FECHA DE CONSULTA: " + new Date().format("dd-MM-yyyy"))
        row3.setRowStyle(style)


        def fila = 7;

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("CÓDIGO")
        rowC1.createCell(1).setCellValue(grupo.descripcion.toUpperCase())
        rowC1.createCell(2).setCellValue("UNIDAD")
        if (grupo.id == 1) {
            rowC1.createCell(3).setCellValue("PESO/VOL")
            rowC1.createCell(4).setCellValue("COSTO")
            rowC1.createCell(5).setCellValue("FECHA ACT.")
            rowC1.createCell(6).setCellValue("# RUBROS")
            rowC1.createCell(7).setCellValue("# OBRAS")
        }else{
            rowC1.createCell(3).setCellValue("COSTO")
            rowC1.createCell(4).setCellValue("FECHA ACT.")
            rowC1.createCell(5).setCellValue("# RUBROS")
            rowC1.createCell(6).setCellValue("# OBRAS")
        }
        rowC1.setRowStyle(style)
        fila++

        res.each {

            def sql2 = "select count(*) from vlobitem where item__id = ${it?.item?.id}"
            def cn = dbConnectionService.getConnection()
            def numero = cn.rows(sql2.toString())

            def sql3 = "select count(*) from item it, item rb, rbro where rbro.rbrocdgo = rb.item__id and rbro.item__id = it.item__id and it.item__id = ${it?.item?.id}"
            def cn2 = dbConnectionService.getConnection()
            def rubros = cn2.rows(sql3.toString())

            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue( it?.item?.codigo?.toString() ?: '')
            rowF1.createCell(1).setCellValue(it?.item?.nombre?.toString() ?: '')
            rowF1.createCell(2).setCellValue(it?.item?.unidad?.codigo?.toString()?: '')

            if (grupo.id == 1) {
                rowF1.createCell(3).setCellValue(it?.item?.peso ?: '')
                rowF1.createCell(4).setCellValue(it?.precioUnitario ?: 0)
                rowF1.createCell(5).setCellValue(it?.fecha?.format("dd-MM-yyyy"))
                rowF1.createCell(6).setCellValue(rubros[0].count)
                rowF1.createCell(7).setCellValue(numero[0].count)
            }else{
                rowF1.createCell(3).setCellValue(it?.precioUnitario ?: 0)
                rowF1.createCell(4).setCellValue(it?.fecha?.format("dd-MM-yyyy"))
                rowF1.createCell(5).setCellValue(rubros[0].count)
                rowF1.createCell(6).setCellValue(numero[0].count)
            }

            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "mantenimientoPrecios.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def imprimirRubroExcel() {

        def rubro = Item.get(params.id)
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

        def parametros = "" + rubro.id + ",'" + fecha.format("yyyy-MM-dd") + "'," + listas + "," + params.dsp0 + "," + params.dsp1 + "," + params.dsv0 + "," + params.dsv1 + "," + params.dsv2 + "," + params.chof + "," + params.volq
        preciosService.ac_rbroV2(params.id, fecha.format("yyyy-MM-dd"), params.lugar)
        def res = preciosService.rb_precios(parametros, "order by grpocdgo desc")

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("PRECIOS")
        sheet.setColumnWidth(0, 15 * 256);
        sheet.setColumnWidth(1, 60 * 256);
        sheet.setColumnWidth(2, 10 * 256);
        sheet.setColumnWidth(3, 15 * 256);
        sheet.setColumnWidth(4, 15 * 256);
        sheet.setColumnWidth(5, 15 * 256);
        sheet.setColumnWidth(6, 20 * 256);
        sheet.setColumnWidth(7, 15 * 256);
        sheet.setColumnWidth(8, 15 * 256);
        sheet.setColumnWidth(9, 25 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("DCP - COORDINACIÓN DE RÉGIMEN DE FIJACIÓN DE COSTOS")
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("ANÁLISIS DE PRECIOS UNITARIOS")
        row2.setRowStyle(style)
        Row row3 = sheet.createRow(4)
        row3.createCell(1).setCellValue("")
        Row row4 = sheet.createRow(5)
        row4.createCell(1).setCellValue("Fecha: " + new Date().format("dd-MM-yyyy"))
        row4.sheet.addMergedRegion(new CellRangeAddress(5, 5, 1, 3))
        row4.createCell(5).setCellValue("Fecha Act. P.U: " + fecha?.format("dd-MM-yyyy"))
        row4.sheet.addMergedRegion(new CellRangeAddress(5, 5, 5, 7))
        row4.setRowStyle(style)
        Row row5 = sheet.createRow(6)
        row5.createCell(1).setCellValue("Código: " + rubro.codigo)
        row5.sheet.addMergedRegion(new CellRangeAddress(6, 6, 1, 3))
        row5.createCell(5).setCellValue("Unidad: " + rubro.unidad?.codigo)
        row5.sheet.addMergedRegion(new CellRangeAddress(6, 6, 5, 7))
        row5.setRowStyle(style)
        Row row6 = sheet.createRow(7)
        row6.createCell(1).setCellValue("Descripción: " + rubro.nombre)
        row6.setRowStyle(style)

        def fila = 10;

        Row rowT1 = sheet.createRow(9)
        rowT1.createCell(0).setCellValue("Equipos")
        rowT1.sheet.addMergedRegion(new CellRangeAddress(9, 9, 0, 2))
        rowT1.setRowStyle(style)

        def totalHer = 0
        def totalMan = 0
        def totalMat = 0
        def total = 0
        def band = 0
        def rowsTrans = []
        res.each { r ->
            if (r["grpocdgo"] == 3) {
                if (band == 0) {
                    Row rowC1 = sheet.createRow(fila)
                    rowC1.createCell(0).setCellValue("Código")
                    rowC1.createCell(1).setCellValue("Descripción")
                    rowC1.createCell(2).setCellValue("Cantidad")
                    rowC1.createCell(3).setCellValue("Tarifa(\$/hora)")
                    rowC1.createCell(4).setCellValue("Costo(\$)")
                    rowC1.createCell(5).setCellValue("Rendimiento")
                    rowC1.createCell(6).setCellValue("C.Total(\$)")
                    rowC1.setRowStyle(style)
                    fila++
                }

                band = 1
                Row rowF1 = sheet.createRow(fila)
                rowF1.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                rowF1.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                rowF1.createCell(2).setCellValue(r["rbrocntd"]?.toDouble())
                rowF1.createCell(3).setCellValue(r["rbpcpcun"]?.toDouble())
                rowF1.createCell(4).setCellValue(r["rbpcpcun"] * r["rbrocntd"])
                rowF1.createCell(5).setCellValue(r["rndm"]?.toDouble())
                rowF1.createCell(6).setCellValue(r["parcial"]?.toDouble())
                totalHer += r["parcial"]
                fila++
            }
            if (r["grpocdgo"] == 2) {
                if (band == 1) {
                    Row rowP1 = sheet.createRow(fila)
                    rowP1.createCell(0).setCellValue("SUBTOTAL")
                    rowP1.createCell(6).setCellValue(totalHer)
                    fila++
                }
                if (band != 2) {

                    fila++
                    Row rowT2 = sheet.createRow(fila)
                    rowT2.createCell(0).setCellValue("Mano de obra")
                    rowT2.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
                    rowT2.setRowStyle(style)
                    fila++
                    Row rowC2 = sheet.createRow(fila)
                    rowC2.createCell(0).setCellValue("Código")
                    rowC2.createCell(1).setCellValue("Descripción")
                    rowC2.createCell(2).setCellValue("Cantidad")
                    rowC2.createCell(3).setCellValue("Jornal(\$/hora)")
                    rowC2.createCell(4).setCellValue("Costo(\$)")
                    rowC2.createCell(5).setCellValue("Rendimiento")
                    rowC2.createCell(6).setCellValue("C.Total(\$)")
                    rowC2.setRowStyle(style)
                    fila++
                }

                band = 2
                Row rowF2 = sheet.createRow(fila)
                rowF2.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                rowF2.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                rowF2.createCell(2).setCellValue(r["rbrocntd"]?.toDouble())
                rowF2.createCell(3).setCellValue(r["rbpcpcun"]?.toDouble())
                rowF2.createCell(4).setCellValue(r["rbpcpcun"] * r["rbrocntd"])
                rowF2.createCell(5).setCellValue(r["rndm"]?.toDouble())
                rowF2.createCell(6).setCellValue(r["parcial"]?.toDouble())
                totalMan += r["parcial"]
                fila++
            }
            if (r["grpocdgo"] == 1) {
                if (band == 2) {
                    Row rowP2 = sheet.createRow(fila)
                    rowP2.createCell(0).setCellValue("SUBTOTAL")
                    rowP2.createCell(6).setCellValue(totalMan)
                    fila++
                }
                if (band != 3) {
                    fila++
                    Row rowT3 = sheet.createRow(fila)
                    rowT3.createCell(0).setCellValue("Materiales")
                    rowT3.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
                    rowT3.setRowStyle(style)
                    fila++
                    Row rowC3 = sheet.createRow(fila)
                    rowC3.createCell(0).setCellValue("Código")
                    rowC3.createCell(1).setCellValue("Descripción")
                    rowC3.createCell(2).setCellValue("Unidad")
                    rowC3.createCell(3).setCellValue("Cantidad")
                    rowC3.createCell(5).setCellValue("Unitario")
                    rowC3.createCell(6).setCellValue("C.Total(\$)")
                    rowC3.setRowStyle(style)
                    fila++
                }

                band = 3
                Row rowF3 = sheet.createRow(fila)
                rowF3.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                rowF3.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                rowF3.createCell(2).setCellValue(r["unddcdgo"]?.toString())
                rowF3.createCell(3).setCellValue(r["rbrocntd"]?.toDouble())
                rowF3.createCell(4).setCellValue(r["rbpcpcun"]?.toDouble())
                rowF3.createCell(6).setCellValue(r["parcial"]?.toDouble())
                totalMat += r["parcial"]
                fila++
            }

            if (r["grpocdgo"] ==1) {
                rowsTrans.add(r)
                total += r["parcial_t"]
            }

        }
        if (band == 3) {
            Row rowP3 = sheet.createRow(fila)
            rowP3.createCell(0).setCellValue("SUBTOTAL")
            rowP3.createCell(6).setCellValue(totalMat)
            fila++
        }

        /*Tranporte*/
        if (rowsTrans.size() > 0) {

            fila++
            Row rowT4 = sheet.createRow(fila)
            rowT4.createCell(0).setCellValue("Transporte")
            rowT4.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
            rowT4.setRowStyle(style)
            fila++
            Row rowC4 = sheet.createRow(fila)
            rowC4.createCell(0).setCellValue("Código")
            rowC4.createCell(1).setCellValue("Descripción")
            rowC4.createCell(2).setCellValue("Peso/Vol")
            rowC4.createCell(3).setCellValue("Cantidad")
            rowC4.createCell(4).setCellValue("Distancia")
            rowC4.createCell(5).setCellValue("Unitario")
            rowC4.createCell(6).setCellValue("C.Total(\$)")
            rowC4.setRowStyle(style)
            fila++

            rowsTrans.each { rt ->
                Row rowF4 = sheet.createRow(fila)
                rowF4.createCell(0).setCellValue(rt["itemcdgo"]?.toString())
                rowF4.createCell(1).setCellValue(rt["itemnmbr"]?.toString())
                rowF4.createCell(2).setCellValue(rt["itempeso"]?.toDouble())
                rowF4.createCell(3).setCellValue(rt["rbrocntd"]?.toDouble())
                rowF4.createCell(4).setCellValue(rt["distancia"]?.toDouble())
                rowF4.createCell(5).setCellValue(rt["tarifa"]?.toDouble())
                rowF4.createCell(6).setCellValue(rt["parcial_t"]?.toDouble())
                fila++
            }

            Row rowP4 = sheet.createRow(fila)
            rowP4.createCell(0).setCellValue("SUBTOTAL")
            rowP4.createCell(6).setCellValue(total)
            fila++
        }

        /*indirectos */

        fila++
        Row rowT5 = sheet.createRow(fila)
        rowT5.createCell(0).setCellValue("Costos Indirectos")
        rowT5.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
        rowT5.setRowStyle(style)
        fila++
        Row rowC5 = sheet.createRow(fila)
        rowC5.createCell(0).setCellValue("Descripción")
        rowC5.createCell(5).setCellValue("Porcentaje")
        rowC5.createCell(6).setCellValue("Valor")
        rowC5.setRowStyle(style)
        fila++
        def totalRubro = total + totalHer + totalMan + totalMat
        def totalIndi = totalRubro * indi / 100
        Row rowF5 = sheet.createRow(fila)
        rowF5.createCell(0).setCellValue("Costos indirectos")
        rowF5.createCell(5).setCellValue(indi)
        rowF5.createCell(6).setCellValue(totalIndi)

        /*Totales*/

        fila += 4
        Row rowP6 = sheet.createRow(fila)
        rowP6.createCell(4).setCellValue("Costo unitario directo")
        rowP6.createCell(6).setCellValue(totalRubro)
        rowP6.setRowStyle(style)

        Row rowP7 = sheet.createRow(fila + 1)
        rowP7.createCell(4).setCellValue("Costos indirectos")
        rowP7.createCell(6).setCellValue(totalIndi)
        rowP7.setRowStyle(style)

        Row rowP8 = sheet.createRow(fila + 2)
        rowP8.createCell(4).setCellValue("Costo total del rubro")
        rowP8.createCell(6).setCellValue(totalRubro + totalIndi)
        rowP8.setRowStyle(style)

        Row rowP9 = sheet.createRow(fila + 3)
        rowP9.createCell(4).setCellValue("Precio unitario")
        rowP9.createCell(6).setCellValue((totalRubro + totalIndi).toDouble().round(2))
        rowP9.setRowStyle(style)

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "rubros.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }




    def consolidadoExcel () {

        def parts = params.id.split("_")
        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def parametros = "" + parts[1] + ",'" + fecha.format("yyyy-MM-dd") + "'," + params.lista1 + "," + params.lista2 + "," +
                params.lista3 + "," + params.lista4 + "," + params.lista5 + "," + params.lista6 + "," + params.dsp0 + "," +
                params.dsp1 + "," + params.dsv0 + "," + params.dsv1 + "," + params.dsv2 + "," + params.chof + "," + params.volq +
                "," + params.indi
        def res = preciosService.nv_rubros(parametros)


        def indi = params.indi

        try {
            indi = indi.toDouble()
        } catch (e) {
            println "error parse " + e
            indi = 21.5
        }

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("CONSOLIDADO")
        sheet.setColumnWidth(0, 15 * 256);
        sheet.setColumnWidth(1, 30 * 256);
        sheet.setColumnWidth(2, 50 * 256);
        sheet.setColumnWidth(3, 15 * 256);
        sheet.setColumnWidth(4, 15 * 256);
        sheet.setColumnWidth(5, 15 * 256);
        sheet.setColumnWidth(6, 20 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("GESTIÓN DE PRESUPUESTOS")
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("ANÁLISIS DE PRECIOS UNITARIOS")
        row2.setRowStyle(style)
        Row row3 = sheet.createRow(4)
        row3.createCell(1).setCellValue("")
        Row row4 = sheet.createRow(5)
        row4.createCell(1).setCellValue("Fecha Act. P.U: " + fecha?.format("dd-MM-yyyy"))
        row4.sheet.addMergedRegion(new CellRangeAddress(5, 5, 1, 3))
        row4.createCell(5).setCellValue("% costos indirectos: " + (indi.toDouble().round(2) ?: 0))
        row4.sheet.addMergedRegion(new CellRangeAddress(5, 5, 5, 7))
        row4.setRowStyle(style)
        Row row5 = sheet.createRow(6)
        row5.createCell(1).setCellValue("LISTAS DE PRECIOS Y DISTANCIAS")
        row5.sheet.addMergedRegion(new CellRangeAddress(6, 6, 1, 3))
        row5.setRowStyle(style)
        Row row6 = sheet.createRow(7)
        row6.createCell(1).setCellValue("Mano de Obra y Equipos: " + (Lugar.get(params.lista6).descripcion ?: ''))
        row6.setRowStyle(style)
        Row row7 = sheet.createRow(8)
        row7.createCell(1).setCellValue("Cantón: " + (Lugar.get(params.lista1).descripcion ?: ''))
        row7.sheet.addMergedRegion(new CellRangeAddress(5, 5, 1, 3))
        row7.createCell(5).setCellValue("Distancia: " + params.dsp0)
        row7.sheet.addMergedRegion(new CellRangeAddress(5, 5, 5, 7))
        row7.setRowStyle(style)
        Row row8 = sheet.createRow(9)
        row8.createCell(1).setCellValue("Especial: " + (Lugar.get(params.lista2).descripcion ?: ''))
        row8.sheet.addMergedRegion(new CellRangeAddress(5, 5, 1, 3))
        row8.createCell(5).setCellValue("Distancia: " + params.dsp1)
        row8.sheet.addMergedRegion(new CellRangeAddress(5, 5, 5, 7))
        row8.setRowStyle(style)
        Row row9 = sheet.createRow(10)
        row9.createCell(1).setCellValue("Petreos Hormigones: " + (Lugar.get(params.lista3).descripcion ?: ''))
        row9.sheet.addMergedRegion(new CellRangeAddress(5, 5, 1, 3))
        row9.createCell(5).setCellValue("Distancia: " + params.dsv0)
        row9.sheet.addMergedRegion(new CellRangeAddress(5, 5, 5, 7))
        row9.setRowStyle(style)
        Row row10 = sheet.createRow(11)
        row10.createCell(1).setCellValue("Mejoramiento: " + (Lugar.get(params.lista4).descripcion ?: ''))
        row10.sheet.addMergedRegion(new CellRangeAddress(5, 5, 1, 3))
        row10.createCell(5).setCellValue("Distancia: " + params.dsv1)
        row10.sheet.addMergedRegion(new CellRangeAddress(5, 5, 5, 7))
        row10.setRowStyle(style)
        Row row11 = sheet.createRow(12)
        row11.createCell(1).setCellValue("Carpeta Asfáltica: " + (Lugar.get(params.lista5).descripcion ?: ''))
        row11.sheet.addMergedRegion(new CellRangeAddress(5, 5, 1, 3))
        row11.createCell(5).setCellValue("Distancia: " + params.dsv2)
        row11.sheet.addMergedRegion(new CellRangeAddress(5, 5, 5, 7))
        row11.setRowStyle(style)
        Row row12 = sheet.createRow(13)
        row12.createCell(1).setCellValue("Chofer: " + (Item.get(params.chof).nombre + " (\$ " + params.prch.toDouble().round(2) + ")"))
        row12.sheet.addMergedRegion(new CellRangeAddress(5, 5, 1, 3))
        row12.createCell(5).setCellValue("Volquete: " + (Item.get(params.volq).nombre + " (\$ " + params.prvl.toDouble().round(2) + ")"))
        row12.sheet.addMergedRegion(new CellRangeAddress(5, 5, 5, 7))
        row12.setRowStyle(style)

        def fila = 16;
        def ultimaFila

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("CODIGO")
        rowC1.createCell(1).setCellValue("CODIGO ESP")
        rowC1.createCell(2).setCellValue("NOMBRE")
        rowC1.createCell(3).setCellValue("UNIDAD")
        rowC1.createCell(4).setCellValue("PRECIO")
        rowC1.createCell(5).setCellValue("ESPECIFICACIONES")
        rowC1.createCell(6).setCellValue("PLANO DE DETALLE")
        rowC1.setRowStyle(style)
        fila++

        res.each{ k->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(k?.rbrocdgo)
            rowF1.createCell(1).setCellValue(Item.get(k?.item__id)?.codigoEspecificacion ?: '')
            rowF1.createCell(2).setCellValue(k?.rbronmbr)
            rowF1.createCell(3).setCellValue(k?.unddcdgo)
            rowF1.createCell(4).setCellValue(k?.rbropcun ?: 0)
            rowF1.createCell(5).setCellValue(k?.rbroespc)
            rowF1.createCell(6).setCellValue(k?.rbrofoto)
            fila++
            ultimaFila = fila
        }


        def output = response.getOutputStream()
        def header = "attachment; filename=" + "consolidado.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def reporteExcelMinas (){

        def lista = TipoLista.get(params.lista)
//        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
//
//        def sql = "select itemcdgo, itemnmbr, unddcdgo, " +
//                "itempeso, rbpcpcun, rbpcfcha, lgardscr from item, undd, rbpc r1, " +
//                "lgar where undd.undd__id = item.undd__id and r1.item__id = item.item__id and lgar.tpls__id = ${params.lista} " +
//                "and r1.rbpcfcha >= '${params.fecha}' and lgar.lgar__id = r1.lgar__id order by lgardscr, itemcdgo, rbpcfcha"

        def sql = "select * from rp_minas('${lista.id}')"

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString())

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("MINAS")
        sheet.setColumnWidth(0, 40 * 256);
        sheet.setColumnWidth(1, 15 * 256);
        sheet.setColumnWidth(2, 40 * 256);
        sheet.setColumnWidth(3, 10 * 256);
        sheet.setColumnWidth(4, 10 * 256);
        sheet.setColumnWidth(5, 10 * 256);
        sheet.setColumnWidth(6, 15 * 256);
        sheet.setColumnWidth(7, 15 * 256);
        sheet.setColumnWidth(8, 15 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("REPORTE PRECIOS DE MATERIALES")
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("LISTA DE PRECIOS DE MATERIALES PETREOS A LA FECHA ACTUAL: " + lista.descripcion.toUpperCase())
        row2.setRowStyle(style)
//        Row row3 = sheet.createRow(4)
//        row3.createCell(1).setCellValue("CONSULTA A LA FECHA: " +  fecha?.format("dd-MM-yyyy"))
//        row3.setRowStyle(style)

        def fila = 6

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("LISTA DE PRECIOS")
        rowC1.createCell(1).setCellValue("CODIGO")
        rowC1.createCell(2).setCellValue("NOMBRE")
        rowC1.createCell(3).setCellValue("UNIDAD")
        rowC1.createCell(4).setCellValue("PESO")
        rowC1.createCell(5).setCellValue("PRECIO")
        rowC1.createCell(6).setCellValue("FECHA")
        rowC1.createCell(7).setCellValue("# RUBRO")
        rowC1.createCell(8).setCellValue("# OBRA")
        rowC1.setRowStyle(style)
        fila++

        res.each{ k->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(k?.lgardscr ?: '')
            rowF1.createCell(1).setCellValue(k?.itemcdgo ?: '')
            rowF1.createCell(2).setCellValue(k?.itemnmbr ?: '')
            rowF1.createCell(3).setCellValue(k?.unddcdgo ?: '')
            rowF1.createCell(4).setCellValue(k?.itempeso ?: '')
            rowF1.createCell(5).setCellValue(k?.rbpcpcun ?: 0)
            rowF1.createCell(6).setCellValue(k?.rbpcfcha?.format("dd-MM-yyyy"))
            rowF1.createCell(7).setCellValue(k?.nmrorbro)
            rowF1.createCell(8).setCellValue(k?.nmroobra)
            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "minas.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }


    def imprimirRubroOferentesExcel(){
//        println "imprimir rubro  excel "+params
        def rubro = Item.get(params.id)
        def indi = params.indi
        def obra = Obra.get(params.obra)
        def obra2 = Obra.get(params.obra.toLong())
        def oferente = Persona.get(params.oferente)
        def obraOferente = ObraOferente.findByOferente(oferente)
        def sql = "SELECT * FROM cncr WHERE obra__id=${obraOferente?.idJanus.id}"
        println "sql: $sql"
        def cn = dbConnectionService.getConnection()
        def conc = cn.rows(sql.toString())
        def cncrId

        conc.each {
            cncrId = it?.cncr__id
        }

        try{
            indi=indi.toDouble()
        } catch (e){
            println "error parse "+e
            indi=21.5
        }

        def parametros = ""+rubro.id+","+oferente.id
        preciosService.rubros_oferentes(rubro?.id?.toInteger(), oferente?.id?.toInteger())
        def res = preciosService.rb_preciosV3(parametros)

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("RUBROS")
        sheet.setColumnWidth(0, 20 * 256)
        sheet.setColumnWidth(1, 40 * 256)
        sheet.setColumnWidth(2, 15 * 256)
        sheet.setColumnWidth(3, 15 * 256)
        sheet.setColumnWidth(4, 15 * 256)
        sheet.setColumnWidth(5, 15 * 256)
        sheet.setColumnWidth(6, 15 * 256)
        sheet.setColumnWidth(7, 15 * 256)
        sheet.setColumnWidth(8, 15 * 256)
        sheet.setColumnWidth(9, 15 * 256)
        sheet.setColumnWidth(10, 15 * 256)
        sheet.setColumnWidth(11, 15 * 256)

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue("NOMBRE DEL OFERENTE: " + (oferente?.nombre?.toUpperCase() ?: '') + " " + (oferente?.apellido?.toUpperCase() ?: ''))
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("PROCESO: CONCURSO")
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("ANÁLISIS DE PRECIOS UNITARIOS")
        row2.setRowStyle(style)
        Row row3 = sheet.createRow(4)
        row3.createCell(1).setCellValue("PROYECTO: " + (obra?.nombre?.toUpperCase() ?: ''))
        row3.setRowStyle(style)
        Row row4 = sheet.createRow(5)
        row4.createCell(1).setCellValue("RUBRO: " + (rubro?.nombre ?: ''))
        row4.setRowStyle(style)
        Row row5 = sheet.createRow(6)
        row5.createCell(1).setCellValue("UNIDAD:" + (rubro?.unidad?.codigo ?: ''))
        row5.setRowStyle(style)

        Row rowT1 = sheet.createRow(8)
        rowT1.createCell(0).setCellValue("Herramientas")
        rowT1.setRowStyle(style)

        def fila = 9
        def number
        def totalHer=0
        def totalMan=0
        def totalMat=0
        def total = 0
        def band=0
        def rowsTrans=[]

        res.each {r->
            if(r["grpocdgo"]==3){
                if(band==0){
                    Row rowC1 = sheet.createRow(fila)
                    rowC1.createCell(0).setCellValue("Código")
                    rowC1.createCell(1).setCellValue("Descripción")
                    rowC1.createCell(2).setCellValue("Cantidad")
                    rowC1.createCell(3).setCellValue("Tarifa(\$/hora)")
                    rowC1.createCell(4).setCellValue("Costo(\$)")
                    rowC1.createCell(5).setCellValue("Rendimiento")
                    rowC1.createCell(6).setCellValue("C.Total(\$)")
                    rowC1.setRowStyle(style)
                    fila++
                }
                band=1
                Row rowF1 = sheet.createRow(fila)
                rowF1.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                rowF1.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                rowF1.createCell(2).setCellValue(r["rbrocntd"]?.toDouble())
                rowF1.createCell(3).setCellValue(r["rbpcpcun"]?.toDouble())
                rowF1.createCell(4).setCellValue(r["rbpcpcun"] * r["rbrocntd"])
                rowF1.createCell(5).setCellValue(r["rndm"]?.toDouble())
                rowF1.createCell(6).setCellValue(r["parcial"]?.toDouble())
                totalHer += r["parcial"]
                fila++
            }
            if(r["grpocdgo"]==2){
                if(band==1){
                    Row rowP1 = sheet.createRow(fila)
                    rowP1.createCell(0).setCellValue("SUBTOTAL")
                    rowP1.createCell(6).setCellValue(totalHer)
                    fila++
                }
                if(band!=2){
                    fila++
                    Row rowT2 = sheet.createRow(fila)
                    rowT2.createCell(0).setCellValue("Mano de obra")
                    rowT2.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
                    rowT2.setRowStyle(style)
                    fila++
                    Row rowC2 = sheet.createRow(fila)
                    rowC2.createCell(0).setCellValue("Código")
                    rowC2.createCell(1).setCellValue("Descripción")
                    rowC2.createCell(2).setCellValue("Cantidad")
                    rowC2.createCell(3).setCellValue("Jornal(\$/hora)")
                    rowC2.createCell(4).setCellValue("Costo(\$)")
                    rowC2.createCell(5).setCellValue("Rendimiento")
                    rowC2.createCell(6).setCellValue("C.Total(\$)")
                    rowC2.setRowStyle(style)
                    fila++
                }

                band = 2
                Row rowF2 = sheet.createRow(fila)
                rowF2.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                rowF2.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                rowF2.createCell(2).setCellValue(r["rbrocntd"]?.toDouble())
                rowF2.createCell(3).setCellValue(r["rbpcpcun"]?.toDouble())
                rowF2.createCell(4).setCellValue(r["rbpcpcun"] * r["rbrocntd"])
                rowF2.createCell(5).setCellValue(r["rndm"]?.toDouble())
                rowF2.createCell(6).setCellValue(r["parcial"]?.toDouble())
                totalMan += r["parcial"]
                fila++
            }
            if(r["grpocdgo"]==1){
                if(band==2){
                    Row rowP2 = sheet.createRow(fila)
                    rowP2.createCell(0).setCellValue("SUBTOTAL")
                    rowP2.createCell(6).setCellValue(totalMan)
                    fila++
                }
                if(band!=3){
                    fila++
                    Row rowT3 = sheet.createRow(fila)
                    rowT3.createCell(0).setCellValue("Materiales")
                    rowT3.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
                    rowT3.setRowStyle(style)
                    fila++
                    Row rowC3 = sheet.createRow(fila)
                    rowC3.createCell(0).setCellValue("Código")
                    rowC3.createCell(1).setCellValue("Descripción")
                    rowC3.createCell(2).setCellValue("Cantidad")
                    rowC3.createCell(3).setCellValue("Unitario")
                    rowC3.createCell(4).setCellValue("Unidad")
                    rowC3.createCell(6).setCellValue("C.Total(\$)")
                    rowC3.setRowStyle(style)
                    fila++
                }
                band = 3
                Row rowF3 = sheet.createRow(fila)
                rowF3.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                rowF3.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                rowF3.createCell(2).setCellValue(r["rbrocntd"]?.toDouble())
                rowF3.createCell(3).setCellValue(r["rbpcpcun"]?.toDouble())
                rowF3.createCell(4).setCellValue(r["unddcdgo"]?.toString())
                rowF3.createCell(6).setCellValue(r["parcial"]?.toDouble())
                totalMat += r["parcial"]
                fila++
            }
            if(r["parcial_t"]>0){
                rowsTrans.add(r)
                total+=r["parcial_t"]
            }
        }
        if(band==3){
            Row rowP3 = sheet.createRow(fila)
            rowP3.createCell(0).setCellValue("SUBTOTAL")
            rowP3.createCell(6).setCellValue(totalMat)
            fila++
        }

        /*Tranporte*/
        if (rowsTrans.size()>0){
            fila++
            Row rowT4 = sheet.createRow(fila)
            rowT4.createCell(0).setCellValue("Transporte")
            rowT4.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
            rowT4.setRowStyle(style)
            fila++
            Row rowC4 = sheet.createRow(fila)
            rowC4.createCell(0).setCellValue("Código")
            rowC4.createCell(1).setCellValue("Descripción")
            rowC4.createCell(2).setCellValue("Peso/Vol")
            rowC4.createCell(3).setCellValue("Cantidad")
            rowC4.createCell(4).setCellValue("Distancia")
            rowC4.createCell(5).setCellValue("Unitario")
            rowC4.createCell(6).setCellValue("C.Total(\$)")
            rowC4.setRowStyle(style)
            fila++
            rowsTrans.each {rt->
                Row rowF4 = sheet.createRow(fila)
                rowF4.createCell(0).setCellValue(rt["itemcdgo"]?.toString())
                rowF4.createCell(1).setCellValue(rt["itemnmbr"]?.toString())
                rowF4.createCell(2).setCellValue(rt["itempeso"]?.toDouble())
                rowF4.createCell(3).setCellValue(rt["rbrocntd"]?.toDouble())
                rowF4.createCell(4).setCellValue(rt["distancia"]?.toDouble())
                rowF4.createCell(5).setCellValue(rt["tarifa"]?.toDouble())
                rowF4.createCell(6).setCellValue(rt["parcial_t"]?.toDouble())
                fila++
            }
            Row rowP4 = sheet.createRow(fila)
            rowP4.createCell(0).setCellValue("SUBTOTAL")
            rowP4.createCell(6).setCellValue(total)
            fila++
        }

        /*indirectos */

        fila++
        Row rowT5 = sheet.createRow(fila)
        rowT5.createCell(0).setCellValue("Costos Indirectos")
        rowT5.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
        rowT5.setRowStyle(style)
        fila++
        Row rowC5 = sheet.createRow(fila)
        rowC5.createCell(0).setCellValue("Descripción")
        rowC5.createCell(5).setCellValue("Porcentaje")
        rowC5.createCell(6).setCellValue("Valor")
        rowC5.setRowStyle(style)
        fila++
        def totalRubro = total + totalHer + totalMan + totalMat
        def totalIndi = totalRubro * indi / 100
        Row rowF5 = sheet.createRow(fila)
        rowF5.createCell(0).setCellValue("Costos indirectos")
        rowF5.createCell(5).setCellValue(indi)
        rowF5.createCell(6).setCellValue(totalIndi)

        /*Totales*/

        fila += 4
        Row rowP6 = sheet.createRow(fila)
        rowP6.createCell(4).setCellValue("Costo unitario directo")
        rowP6.createCell(6).setCellValue(totalRubro)
        rowP6.setRowStyle(style)

        Row rowP7 = sheet.createRow(fila + 1)
        rowP7.createCell(4).setCellValue("Costos indirectos")
        rowP7.createCell(6).setCellValue(totalIndi)
        rowP7.setRowStyle(style)

        Row rowP8 = sheet.createRow(fila + 2)
        rowP8.createCell(4).setCellValue("Costo total del rubro")
        rowP8.createCell(6).setCellValue((totalRubro+totalIndi).toDouble().round(5))
        rowP8.setRowStyle(style)

        Row rowP9 = sheet.createRow(fila + 3)
        rowP9.createCell(4).setCellValue("Precio unitario(\$USD)")
        rowP9.createCell(6).setCellValue((totalRubro + totalIndi).toDouble().round(2))
        rowP9.setRowStyle(style)

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "rubrosOferente.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def imprimirRubroOferentesExcelVae(){
        def rubro = Item.get(params.id)
        def indi = params.indi
        def obra = Obra.get(params.obra)
        def obra2 = Obra.get(params.obra.toLong())
        def oferente = Persona.get(params.oferente)
        def obraOferente = ObraOferente.findByOferente(oferente)
        def sql = "SELECT * FROM cncr WHERE obra__id=${obraOferente?.idJanus.id}"

        def cn = dbConnectionService.getConnection()
        def conc = cn.rows(sql.toString())
        def cncrId

        conc.each {
            cncrId = it?.cncr__id
        }
        def concurso = janus.pac.Concurso.get(cncrId)

        try{
            indi=indi.toDouble()
        } catch (e){
            println "error parse "+e
            indi=21.5
        }

        def parametros = ""+rubro.id+","+oferente.id
        preciosService.rubros_oferentes(rubro?.id?.toInteger(), oferente?.id?.toInteger())
        def vae = preciosService.vae_rubros(rubro.id, oferente.id)

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("RUBROS VAE")
        sheet.setColumnWidth(0, 20 * 256)
        sheet.setColumnWidth(1, 15 * 256)
        sheet.setColumnWidth(2, 15 * 256)
        sheet.setColumnWidth(3, 15 * 256)
        sheet.setColumnWidth(4, 15 * 256)
        sheet.setColumnWidth(5, 15 * 256)
        sheet.setColumnWidth(6, 15 * 256)
        sheet.setColumnWidth(7, 15 * 256)
        sheet.setColumnWidth(8, 15 * 256)
        sheet.setColumnWidth(9, 15 * 256)
        sheet.setColumnWidth(10, 15 * 256)
        sheet.setColumnWidth(11, 15 * 256)

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue("NOMBRE DEL OFERENTE: " + (oferente?.nombre?.toUpperCase() ?: '') + " " + (oferente?.apellido?.toUpperCase() ?: ''))
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("PROCESO: CONCURSO")
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("ANÁLISIS DE PRECIOS UNITARIOS")
        row2.setRowStyle(style)
        Row row3 = sheet.createRow(4)
        row3.createCell(1).setCellValue("PROYECTO: " + (obra?.nombre?.toUpperCase() ?: ''))
        row3.setRowStyle(style)
        Row row4 = sheet.createRow(5)
        row4.createCell(1).setCellValue("RUBRO: " + (rubro?.nombre ?: ''))
        row4.setRowStyle(style)
        Row row5 = sheet.createRow(6)
        row5.createCell(1).setCellValue("UNIDAD:" + (rubro?.unidad?.codigo ?: ''))
        row5.setRowStyle(style)


        def fila = 9
        def number
        def totalHer=0
        def totalMan=0
        def totalMat=0
        def total = 0
        def rowsTrans=[]
        def band=25
        def number2
        def totalManRel = 0
        def totalManVae = 0
        def totalMatRel = 0
        def totalMatVae = 0
        def totalHerRel = 0
        def totalHerVae = 0
        def totalTRel = 0
        def totalTVae = 0

        vae.each{r ->
            if(r["grpocdgo"]==3){
                if(band!=0){
                    fila++
                    Row rowT1 = sheet.createRow(8)
                    rowT1.createCell(0).setCellValue("Herramientas")
                    rowT1.setRowStyle(style)
                    fila++
                    Row rowC1 = sheet.createRow(fila)
                    rowC1.createCell(0).setCellValue("Código")
                    rowC1.createCell(1).setCellValue("Descripción")
                    rowC1.createCell(2).setCellValue("Cantidad")
                    rowC1.createCell(3).setCellValue("Tarifa(\$/hora)")
                    rowC1.createCell(4).setCellValue("Costo(\$)")
                    rowC1.createCell(5).setCellValue("Rendimiento")
                    rowC1.createCell(6).setCellValue("C.Total(\$)")
                    rowC1.createCell(7).setCellValue("Peso Relat(%)")
                    rowC1.createCell(8).setCellValue("CPC")
                    rowC1.createCell(9).setCellValue("NP/EP/ND")
                    rowC1.createCell(10).setCellValue("VAE(%)")
                    rowC1.createCell(11).setCellValue("VAE(%) Elemento")
                    rowC1.setRowStyle(style)
                    fila++
                }

                band=0

                Row rowF1 = sheet.createRow(fila)
                rowF1.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                rowF1.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                rowF1.createCell(2).setCellValue(r["rbrocntd"]?.toDouble())
                rowF1.createCell(3).setCellValue(r["rbpcpcun"]?.toDouble())
                rowF1.createCell(4).setCellValue(r["rbpcpcun"] * r["rbrocntd"])
                rowF1.createCell(5).setCellValue(r["rndm"]?.toDouble())
                rowF1.createCell(6).setCellValue(r["parcial"]?.toDouble())
                rowF1.createCell(7).setCellValue(r["relativo"]?.toDouble())
                rowF1.createCell(8).setCellValue("")
                rowF1.createCell(9).setCellValue(r.tpbncdgo)
                rowF1.createCell(10).setCellValue(r["vae"]?.toDouble())
                rowF1.createCell(11).setCellValue(r["vae_vlor"]?.toDouble())

                totalHer += r["parcial"]
                totalHerRel += r["relativo"]
                totalHerVae += r["vae_vlor"]
                fila++
            }

            if(r["grpocdgo"]==2){
                if(band == 1){
                    Row rowP1 = sheet.createRow(fila)
                    rowP1.createCell(5).setCellValue("SUBTOTAL")
                    rowP1.createCell(6).setCellValue(totalHer)
                    rowP1.createCell(7).setCellValue(totalHerRel)
                    rowP1.createCell(11).setCellValue(totalHerVae)
                    fila++
                }
                if(band!=2){
                    fila++
                    Row rowT2 = sheet.createRow(fila)
                    rowT2.createCell(0).setCellValue("Mano de Obra")
                    rowT2.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
                    rowT2.setRowStyle(style)
                    fila++
                    Row rowC2 = sheet.createRow(fila)
                    rowC2.createCell(0).setCellValue("Código")
                    rowC2.createCell(1).setCellValue("Descripción")
                    rowC2.createCell(2).setCellValue("Cantidad")
                    rowC2.createCell(3).setCellValue("Jornal(\$/hora)")
                    rowC2.createCell(4).setCellValue("Costo(\$)")
                    rowC2.createCell(5).setCellValue("Rendimiento")
                    rowC2.createCell(6).setCellValue("C.Total(\$)")
                    rowC2.createCell(7).setCellValue("Peso Relat(%)")
                    rowC2.createCell(8).setCellValue("CPC")
                    rowC2.createCell(9).setCellValue("NP/EP/ND")
                    rowC2.createCell(10).setCellValue("VAE(%)")
                    rowC2.createCell(11).setCellValue("VAE(%) Elemento")
                    rowC2.setRowStyle(style)
                    fila++
                }
                band=2

                Row rowF2 = sheet.createRow(fila)
                rowF2.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                rowF2.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                rowF2.createCell(2).setCellValue(r["rbrocntd"]?.toDouble())
                rowF2.createCell(3).setCellValue(r["rbpcpcun"]?.toDouble())
                rowF2.createCell(4).setCellValue(r["rbpcpcun"] * r["rbrocntd"])
                rowF2.createCell(5).setCellValue(r["rndm"]?.toDouble())
                rowF2.createCell(6).setCellValue(r["parcial"]?.toDouble())
                rowF2.createCell(7).setCellValue(r["relativo"]?.toDouble())
                rowF2.createCell(8).setCellValue("")
                rowF2.createCell(9).setCellValue(r.tpbncdgo)
                rowF2.createCell(10).setCellValue(r["vae"]?.toDouble())
                rowF2.createCell(11).setCellValue(r["vae_vlor"]?.toDouble())

                totalMan += r["parcial"]
                totalManRel += r["relativo"]
                totalManVae += r["vae_vlor"]
                fila++
            }

            if(r["grpocdgo"]==1){
                if(band==2){
                    Row rowP2 = sheet.createRow(fila)
                    rowP2.createCell(5).setCellValue("SUBTOTAL")
                    rowP2.createCell(6).setCellValue(totalMan)
                    rowP2.createCell(7).setCellValue(totalManRel)
                    rowP2.createCell(11).setCellValue(totalManVae)
                    fila++
                }
                if(band!=3){
                    fila++
                    Row rowT3 = sheet.createRow(fila)
                    rowT3.createCell(0).setCellValue("Materiales")
                    rowT3.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
                    rowT3.setRowStyle(style)
                    fila++

                    Row rowC3 = sheet.createRow(fila)
                    rowC3.createCell(0).setCellValue("Código")
                    rowC3.createCell(1).setCellValue("Descripción")
                    rowC3.createCell(2).setCellValue("Cantidad")
                    rowC3.createCell(3).setCellValue("Unitario")
                    rowC3.createCell(4).setCellValue("Unidad")
                    rowC3.createCell(6).setCellValue("C.Total(\$)")
                    rowC3.createCell(7).setCellValue("Peso Relat(%)")
                    rowC3.createCell(8).setCellValue("CPC")
                    rowC3.createCell(9).setCellValue("NP/EP/ND")
                    rowC3.createCell(10).setCellValue("VAE(%)")
                    rowC3.createCell(11).setCellValue("VAE(%) Elemento")
                    rowC3.setRowStyle(style)
                    fila++
                }

                band = 3

                Row rowF3 = sheet.createRow(fila)
                rowF3.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                rowF3.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                rowF3.createCell(2).setCellValue(r["rbrocntd"]?.toDouble())
                rowF3.createCell(3).setCellValue(r["rbpcpcun"]?.toDouble())
                rowF3.createCell(3).setCellValue(r["unddcdgo"]?.toString())
                rowF3.createCell(6).setCellValue(r["parcial"]?.toDouble())
                rowF3.createCell(7).setCellValue(r["relativo"]?.toDouble())
                rowF3.createCell(8).setCellValue("")
                rowF3.createCell(9).setCellValue(r.tpbncdgo)
                rowF3.createCell(10).setCellValue(r["vae"]?.toDouble())
                rowF3.createCell(11).setCellValue(r["vae_vlor"]?.toDouble())

                totalMat += r["parcial"]
                totalMatRel += r["relativo"]
                totalMatVae += r["vae_vlor"]
                fila++

            }
            if(r["parcial_t"]>0){
                rowsTrans.add(r)
                total+=r["parcial_t"]
            }

        }
        if(band==3){
            fila++
            Row rowP3 = sheet.createRow(fila)
            rowP3.createCell(5).setCellValue("SUBTOTAL")
            rowP3.createCell(6).setCellValue(totalMat)
            rowP3.createCell(7).setCellValue(totalMatRel)
            rowP3.createCell(11).setCellValue(totalMatVae)
            fila++
        }

        /*Tranporte*/
        if (rowsTrans.size()>0){
            fila++
            Row rowT3 = sheet.createRow(fila)
            rowT3.createCell(0).setCellValue("Transporte")
            rowT3.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
            rowT3.setRowStyle(style)
            fila++
            Row rowC4 = sheet.createRow(fila)
            rowC4.createCell(0).setCellValue("Código")
            rowC4.createCell(1).setCellValue("Descripción")
            rowC4.createCell(2).setCellValue("Peso/Vol")
            rowC4.createCell(3).setCellValue("Cantidad")
            rowC4.createCell(4).setCellValue("Distancia")
            rowC4.createCell(5).setCellValue("Unitario")
            rowC4.createCell(6).setCellValue("C.Total(\$)")
            rowC4.createCell(7).setCellValue("Peso Relat(%)")
            rowC4.createCell(8).setCellValue("CPC")
            rowC4.createCell(9).setCellValue("NP/EP/ND")
            rowC4.createCell(10).setCellValue("VAE(%)")
            rowC4.createCell(11).setCellValue("VAE(%) Elemento")
            rowC4.setRowStyle(style)
            fila++

            rowsTrans.each {rt->
                Row rowF4 = sheet.createRow(fila)
                rowF4.createCell(0).setCellValue(rt["itemcdgo"]?.toString())
                rowF4.createCell(1).setCellValue(rt["itemnmbr"]?.toString())
                rowF4.createCell(2).setCellValue(rt["itempeso"]?.toDouble())
                rowF4.createCell(3).setCellValue(rt["rbrocntd"]?.toDouble())
                rowF4.createCell(4).setCellValue(rt["distancia"]?.toDouble())
                rowF4.createCell(5).setCellValue(rt["tarifa"]?.toDouble())
                rowF4.createCell(6).setCellValue(rt["parcial_t"]?.toDouble())
                fila++
            }

            Row rowP4 = sheet.createRow(fila)
            rowP4.createCell(0).setCellValue("SUBTOTAL")
            rowP4.createCell(6).setCellValue(total)
            fila++

        }

        /*indirectos */

        fila++
        Row rowT5 = sheet.createRow(fila)
        rowT5.createCell(0).setCellValue("Costos Indirectos")
        rowT5.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
        rowT5.setRowStyle(style)
        fila++
        Row rowC5 = sheet.createRow(fila)
        rowC5.createCell(0).setCellValue("Descripción")
        rowC5.createCell(5).setCellValue("Porcentaje")
        rowC5.createCell(6).setCellValue("Valor")
        rowC5.setRowStyle(style)
        fila++
        def totalRubro=total+totalHer+totalMan+totalMat
        def totalIndi=totalRubro*indi/100
        def totalRelativo = totalHerRel + totalMatRel + totalManRel
        def totalVae = totalHerVae + totalMatVae + totalManVae
        Row rowF5 = sheet.createRow(fila)
        rowF5.createCell(0).setCellValue("Costos indirectos")
        rowF5.createCell(5).setCellValue(indi)
        rowF5.createCell(6).setCellValue(totalIndi)

        /*Totales*/

        fila += 4
        Row rowP6 = sheet.createRow(fila)
        rowP6.createCell(4).setCellValue("Costo unitario directo")
        rowP6.createCell(6).setCellValue(totalRubro)
        rowP6.createCell(7).setCellValue(totalRelativo)
        rowP6.createCell(11).setCellValue(totalVae)
        rowP6.setRowStyle(style)

        Row rowP7 = sheet.createRow(fila + 1)
        rowP7.createCell(4).setCellValue("Costos indirectos")
        rowP7.createCell(6).setCellValue(totalIndi)
        rowP7.createCell(7).setCellValue("TOTAL")
        rowP7.createCell(11).setCellValue("TOTAL")
        rowP7.setRowStyle(style)

        Row rowP8 = sheet.createRow(fila + 2)
        rowP8.createCell(4).setCellValue("Costo total del rubro")
        rowP8.createCell(6).setCellValue(totalRubro + totalIndi)
        rowP8.createCell(7).setCellValue("PESO")
        rowP8.createCell(11).setCellValue("VAE")
        rowP8.setRowStyle(style)

        Row rowP9 = sheet.createRow(fila + 3)
        rowP9.createCell(4).setCellValue("Precio unitario(\$USD)")
        rowP9.createCell(6).setCellValue((totalRubro + totalIndi).toDouble().round(2))
        rowP9.createCell(7).setCellValue("RELATIVO(%)")
        rowP9.createCell(11).setCellValue("(%)")

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "rubrosOferenteVae.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }


    def reporteExcelVolObraOferente() {

        def obra = Obra.get(params.id)
        def oferente = Persona.get(params.oferente)
        def obraOferente = ObraOferente.findByObraAndOferente(obra, oferente)
        def sql = "SELECT * FROM cncr WHERE obra__id=${obra?.id}"

        def cn = dbConnectionService.getConnection()
        def conc = cn.rows(sql.toString())

        def cncrId

        conc.each {
            cncrId = it?.cncr__id
        }

        def concurso = obraOferente.concurso
        def detalle = VolumenObraOferente.findAllByObra(obra, [sort: "orden"])
//        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()

        def precios = [:]

        def indirecto = obra.totales / 100
        def total1 = 0;
        def totales
        def totalPresupuesto = 0;


        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("VOL OBRA")
        sheet.setColumnWidth(0, 20 * 256)
        sheet.setColumnWidth(1, 15 * 256)
        sheet.setColumnWidth(2, 15 * 256)
        sheet.setColumnWidth(3, 15 * 256)
        sheet.setColumnWidth(4, 15 * 256)
        sheet.setColumnWidth(5, 15 * 256)
        sheet.setColumnWidth(6, 15 * 256)
        sheet.setColumnWidth(7, 15 * 256)
        sheet.setColumnWidth(8, 15 * 256)
        sheet.setColumnWidth(9, 15 * 256)
        sheet.setColumnWidth(10, 15 * 256)
        sheet.setColumnWidth(11, 15 * 256)

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue("NOMBRE DEL OFERENTE: " + (oferente?.nombre?.toUpperCase() ?: '') + " " + (oferente?.apellido?.toUpperCase() ?: ''))
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("PROCESO: " + (concurso?.codigo ?: ''))
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("TABLA DE DESCRIPCIÓN DE RUBROS, UNIDADES, CANTIDADES Y PRECIOS")
        row2.setRowStyle(style)
        Row row21 = sheet.createRow(4)
        row21.createCell(1).setCellValue("GOBIERNO AUTÓNOMO DESCENTRALIZADO DE LA PROVINCIA DE PICHINCHA")
        row21.setRowStyle(style)
        Row row3 = sheet.createRow(5)
        row3.createCell(1).setCellValue("NOMBRE DEL PROYECTO: " + (obra?.nombre?.toUpperCase() ?: ''))
        row3.setRowStyle(style)

        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }

        def label
        def number
        def nmro
        def numero = 1;
        def fila = 7;
        def ultimaFila

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("N°")
        rowC1.createCell(1).setCellValue("RUBRO")
        rowC1.createCell(2).setCellValue("SUBPRESUPUESTO")
        rowC1.createCell(3).setCellValue("COMPONENTE DEL PROYECTO/ITEM")
        rowC1.createCell(4).setCellValue("UNIDAD")
        rowC1.createCell(5).setCellValue("CANTIDAD")
        rowC1.createCell(6).setCellValue("UNITARIO")
        rowC1.createCell(7).setCellValue("C.TOTAL")
        rowC1.setRowStyle(style)
        fila++

        detalle.each {

            def res = preciosService.presioUnitarioVolumenObraOferente("sum(parcial)+sum(parcial_t) precio ", it.item.id, obra?.id)
            def precio = 0

            if (res["precio"][0] != null && res["precio"][0] != "null")
                precio = res["precio"][0]
            precios.put(it.id.toString(), (precio + precio * indirecto).toDouble().round(2))

            def precioUnitario = precios[it.id.toString()];
            def subtotal = precios[it.id.toString()] * it.cantidad;

            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(numero++)
            rowF1.createCell(1).setCellValue(it?.item?.codigo?.toString() ?: '')
            rowF1.createCell(2).setCellValue(it?.subPresupuesto?.descripcion?.toString() ?: '')
            rowF1.createCell(3).setCellValue(it?.item?.nombre?.toString() ?: '')
            rowF1.createCell(4).setCellValue(it?.item?.unidad?.codigo?.toString() ?: '')
            rowF1.createCell(5).setCellValue(it?.cantidad ?: 0)
            rowF1.createCell(6).setCellValue(precioUnitario?.toDouble()?.round(2) ?: 0)
            rowF1.createCell(7).setCellValue(subtotal?.toDouble()?.round(2) ?: 0)

            fila++
            totales = precios[it.id.toString()] * it.cantidad
            totalPresupuesto = (total1 += totales);
            ultimaFila = fila
        }

        Row rowT = sheet.createRow(fila)
        rowT.createCell(6).setCellValue("TOTAL")
        rowT.createCell(7).setCellValue(totalPresupuesto?.toDouble()?.round(2) ?: 0)
        rowT.setRowStyle(style)
        fila++

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "volObraExcelOferente.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)

    }

    def reporteExcelItemsComposicion() {

        def obra = Obra.get(params.id)

        def sql = "select distinct vlobitem.itemcdgo, itemnmbr, " +
                "tplsdscr, obradsps, obradsvl, obradses, obradsmj, obradsca from obra, " +
                "vlobitem, item, tpls where obra.obra__id = vlobitem.obra__id and item.item__id = vlobitem.item__id and tpls.tpls__id = item.tpls__id and vlobitem.obra__id = ${obra?.id} " +
                "and item.tpls__id <> 6 order by tplsdscr, itemcdgo;"
//
//        def sql = "SELECT\n" +
//                "  i.itemcdgo              codigo,\n" +
//                "  i.itemnmbr              item,\n" +
//                "  u.unddcdgo              unidad,\n" +
//                "  sum(v.voitcntd)         cantidad,\n" +
//                "  v.voitpcun              punitario,\n" +
//                "  v.voittrnp              transporte,\n" +
//                "  v.voitpcun + v.voittrnp costo,\n" +
//                "  d.dprtdscr              departamento,\n" +
//                "  s.sbgrdscr              subgrupo,\n" +
//                "  g.grpodscr              grupo,\n" +
//                "  g.grpo__id              grid\n" +
//                "FROM vlobitem v\n" +
//                "  LEFT JOIN item i ON v.item__id = i.item__id\n" +
//                "  LEFT JOIN undd u ON i.undd__id = u.undd__id\n" +
//                "  LEFT JOIN dprt d ON i.dprt__id = d.dprt__id\n" +
//                "  LEFT JOIN sbgr s ON d.sbgr__id = s.sbgr__id\n" +
//                "  LEFT JOIN grpo g ON s.grpo__id = g.grpo__id AND g.grpo__id IN (${params.tipo})\n" +
//                "WHERE v.obra__id = ${params.id} \n" +
//                "GROUP BY i.itemcdgo, i.itemnmbr, u.unddcdgo, v.voitpcun, v.voittrnp, d.dprtdscr, s.sbgrdscr, g.grpodscr,\n" +
//                "  g.grpo__id\n" +
//                "ORDER BY grid ASC, i.itemnmbr"


        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString())

        def label
        def number
        def totalE = 0;
        def totalM = 0;
        def totalMO = 0;
        def ultimaFila = 0

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("ITEMS")
        sheet.setColumnWidth(0, 15 * 256);
        sheet.setColumnWidth(1, 60 * 256);
        sheet.setColumnWidth(2, 20 * 256);
        sheet.setColumnWidth(3, 20 * 256);
        sheet.setColumnWidth(4, 20 * 256);
        sheet.setColumnWidth(5, 20 * 256);
        sheet.setColumnWidth(6, 20 * 256);
        sheet.setColumnWidth(7, 20 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("COMPOSICIÓN: " + obra?.nombre)
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue(obra?.departamento?.direccion?.nombre ?: '')
        row2.setRowStyle(style)
        Row row3 = sheet.createRow(4)
        row3.createCell(1).setCellValue("CÓDIGO: " + obra?.codigo)
        row3.setRowStyle(style)
        Row row4 = sheet.createRow(5)
        row4.createCell(1).setCellValue("DOC. REFERENCIA: " + obra?.oficioIngreso)
        row4.setRowStyle(style)
        Row rowE = sheet.createRow(6)
        rowE.createCell(1).setCellValue("")
        Row row5 = sheet.createRow(6)
        row5.createCell(1).setCellValue("FECHA: " + obra?.fechaCreacionObra?.format('dd-MM-yyyy'))
        row5.setRowStyle(style)
        Row row6 = sheet.createRow(7)
        row6.createCell(1).setCellValue("FECHA ACT.PRECIOS: " + obra?.fechaPreciosRubros?.format("dd-MM-yyyy"))
        row6.setRowStyle(style)

        def fila = 9

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("CÓDIGO")
        rowC1.createCell(1).setCellValue("ITEM")
        rowC1.createCell(2).setCellValue("LISTA")
        rowC1.createCell(3).setCellValue("DISTANCIA PESO CANTON")
        rowC1.createCell(4).setCellValue("DISTANCIA VOLUMEN HORMIGONES")
        rowC1.createCell(5).setCellValue("DISTANCIA PESO ESPECIAL")
        rowC1.createCell(6).setCellValue("DISTANCIA VOLUMEN MEJORAMIENTO")
        rowC1.createCell(7).setCellValue("DISTANCIA VOLUMEN CARPETA ASFÁLTICA")
        rowC1.setRowStyle(style)
        fila++

        res.each {
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(it?.itemcdgo?.toString() ?: '')
            rowF1.createCell(1).setCellValue(it?.itemnmbr?.toString() ?: '')
            rowF1.createCell(2).setCellValue(it?.tplsdscr?.toString() ?: '')
            rowF1.createCell(3).setCellValue(it?.obradsps?.toDouble() ?: 0)
            rowF1.createCell(4).setCellValue(it?.obradsvl?.toDouble() ?: 0)
            rowF1.createCell(5).setCellValue(it?.obradses?.toDouble() ?: 0)
            rowF1.createCell(6).setCellValue(it?.obradsmj?.toDouble() ?: 0)
            rowF1.createCell(7).setCellValue(it?.obradsca?.toDouble() ?: 0)
            fila++

            ultimaFila = fila
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "itemsComposicion.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }



}