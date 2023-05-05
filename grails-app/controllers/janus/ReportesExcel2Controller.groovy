package janus

import org.apache.poi.ss.usermodel.HorizontalAlignment
import org.apache.poi.ss.usermodel.Row
import org.apache.poi.ss.usermodel.Sheet
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFCellStyle
import org.apache.poi.xssf.usermodel.XSSFFont
import org.apache.poi.xssf.usermodel.XSSFWorkbook

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


//        label = new Label(2, 2, (Auxiliar.get(1)?.titulo ?: ''), times16format); sheet.addCell(label);
//        label = new Label(2, 4, "DGCP - COORDINACIÓN DE FIJACIÓN DE PRECIOS", times16format); sheet.addCell(label);
//        label = new Label(2, 6, "PRESUPUESTO", times16format); sheet.addCell(label);
//        label = new Label(2, 8, "FECHA: " + obra?.fechaCreacionObra?.format("dd-MM-yyyy"), times16format);
//        sheet.addCell(label);
//        label = new Label(2, 9, "FECHA ACT. PRECIOS: " + obra?.fechaPreciosRubros?.format("dd-MM-yyyy"), times16format);
//        sheet.addCell(label);
//        label = new Label(2, 10, "NOMBRE: " + obra?.nombre, times16format); sheet.addCell(label);
//        label = new Label(2, 11, "DOC. REFERENCIA: " + (obra?.oficioIngreso ?: '') + "  " + (obra?.referencia ?: ''), times16format); sheet.addCell(label);
//        label = new Label(2, 12, "MEMO CANT. DE OBRA: " + (obra?.memoCantidadObra ?: ''), times16format); sheet.addCell(label);

//        label = new Label(7, 14, "Mano de Obra", times16format); sheet.addCell(label);
//        label = new Label(10, 14, "Equipos", times16format); sheet.addCell(label);
//        label = new Label(13, 14, "Materiales", times16format); sheet.addCell(label);
//        label = new Label(16, 14, "Transporte", times16format); sheet.addCell(label);
//        label = new Label(21, 14, "Totales", times16format); sheet.addCell(label);

//        label = new Label(0, 15, "N°", times16format); sheet.addCell(label);
//        label = new Label(1, 15, "CÓDIGO", times16format); sheet.addCell(label);
//        label = new Label(2, 15, "SUBPRESUPUESTO", times16format); sheet.addCell(label);
//        label = new Label(3, 15, "RUBRO", times16format); sheet.addCell(label);
//        label = new Label(4, 15, "UNIDAD", times16format); sheet.addCell(label);
//        label = new Label(5, 15, "CANTIDAD", times16format); sheet.addCell(label);
//        label = new Label(6, 15, "", times16format); sheet.addCell(label);
//        label = new Label(7, 15, "C.U", times16format); sheet.addCell(label);
//        label = new Label(8, 15, "TOTAL", times16format); sheet.addCell(label);
//        label = new Label(9, 15, "", times16format); sheet.addCell(label);
//
//        label = new Label(10, 15, "C.U", times16format); sheet.addCell(label);
//        label = new Label(11, 15, "TOTAL", times16format); sheet.addCell(label);
//        label = new Label(12, 15, "", times16format); sheet.addCell(label);
//        label = new Label(13, 15, "C.U", times16format); sheet.addCell(label);
//        label = new Label(14, 15, "TOTAL", times16format); sheet.addCell(label);
//        label = new Label(15, 15, "", times16format); sheet.addCell(label);
//        label = new Label(16, 15, "C.U", times16format); sheet.addCell(label);
//        label = new Label(17, 15, "TOTAL", times16format); sheet.addCell(label);
//        label = new Label(18, 15, "", times16format); sheet.addCell(label);
//
//        label = new Label(19, 15, "INDIRECTOS", times16format); sheet.addCell(label);
//        label = new Label(20, 15, "", times16format); sheet.addCell(label);
//        label = new Label(21, 15, "C.U", times16format); sheet.addCell(label);
//        label = new Label(22, 15, "TOTAL", times16format); sheet.addCell(label);

        valores.each {

//            number = new Number(0, fila, numero++); sheet.addCell(number);
//            label = new Label(1, fila, it.rbrocdgo.toString()); sheet.addCell(label);
//            label = new Label(2, fila, it.sbprdscr.toString()); sheet.addCell(label);
//            label = new Label(3, fila, it.rbronmbr.toString()); sheet.addCell(label);
//            label = new Label(4, fila, it.unddcdgo.toString()); sheet.addCell(label);
//            number = new Number(5, fila, it.vlobcntd); sheet.addCell(number);


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
//            number = new Number(13, fila, parcialMateriales); sheet.addCell(number);
//            number = new Number(14, fila, (parcialMateriales * it.vlobcntd)); sheet.addCell(number);

            //transporte
            rowF1.createCell(16).setCellValue(parcialTransporte)
            rowF1.createCell(17).setCellValue((parcialTransporte * it.vlobcntd) ?: '')
//            number = new Number(16, fila, parcialTransporte); sheet.addCell(number);
//            number = new Number(17, fila, (parcialTransporte * it.vlobcntd)); sheet.addCell(number);

            //indirectos

            indirectos = parcialMano + parcialEquipo + parcialMateriales + parcialTransporte
            def totalIndirectos = indirectos?.toDouble() * valorIndirectoObra?.toDouble() / 100
            rowF1.createCell(19).setCellValue(totalIndirectos)
//            number = new Number(19, fila, totalIndirectos); sheet.addCell(number);

            //totales

            def parcialCuTotal = indirectos + totalIndirectos
            rowF1.createCell(21).setCellValue(parcialCuTotal)
            rowF1.createCell(22).setCellValue(it.totl)
//            number = new Number(21, fila, parcialCuTotal); sheet.addCell(number);
//            number = new Number(22, fila, it.totl); sheet.addCell(number);

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

}
