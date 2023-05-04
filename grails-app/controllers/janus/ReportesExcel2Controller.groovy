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
        def ultimaFila

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("VAE")
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

        def fila = 11

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

//      label = new Label(11, 16, "VAE TOTAL", times16format); sheet.addCell(label);
//
//        subPres.each {sp->
//
//            label = new Label(0, filaSub, sp?.descripcion?.toString()); sheet.addCell(label);
//
//            valores.each {val->
//
//                if(val.sbpr__id == sp.id){
//                    number = new Number(0, fila, val.vlobordn); sheet.addCell(number);
//                    label = new Label(1, fila, val.rbrocdgo.toString()); sheet.addCell(label);
//                    label = new Label(2, fila, val?.itemcdes?.toString() ?: ''); sheet.addCell(label);
//                    label = new Label(3, fila, val.rbronmbr.toString()); sheet.addCell(label);
//                    label = new Label(4, fila, val?.vlobdscr?.toString() ?: ''); sheet.addCell(label);
//                    label = new Label(5, fila, val.unddcdgo.toString()); sheet.addCell(label);
//                    number = new Number(6, fila, val.vlobcntd); sheet.addCell(number);
//                    number = new Number(7, fila, val.pcun); sheet.addCell(number);
//                    number = new Number(8, fila, val.totl); sheet.addCell(number);
//                    number = new Number(9, fila, val.relativo); sheet.addCell(number);
//                    if(val.vae_rbro != null){
//                        number = new Number(10, fila, val.vae_rbro); sheet.addCell(number);
//                    }else{
//                        number = new Number(10, fila, 0); sheet.addCell(number);
//                    }
//                    if(val.vae_totl != null){
//                        number = new Number(11, fila, val.vae_totl); sheet.addCell(number);
//                    }else{
//                        number = new Number(11, fila, 0); sheet.addCell(number);
//                    }
//
//
//                    fila++
//                    filaSub++
//                    totales = val.totl
//                    if(val.vae_totl != null){
//                        vaeTotal = val.vae_totl
//                    }else{
//                        vaeTotal = 0
//                    }
//
//                    totalPresupuesto = (total1 += totales);
//                    totalVae = (vaeTotal1 += vaeTotal)
//                    ultimaFila = fila
//
//                }
//            }
//
//            fila++
//            filaSub++
//
//        }

//        label = new Label(7, ultimaFila, "TOTAL ", times16format); sheet.addCell(label);
//        number = new Number(8, ultimaFila, totalPresupuesto); sheet.addCell(number);
//        number = new Number(9, ultimaFila, 100); sheet.addCell(number);
//        number = new Number(11, ultimaFila, totalVae); sheet.addCell(number);
//
//        label = new Label(2, ultimaFila+1, "CONDICIONES DEL CONTRATO ", times16format); sheet.addCell(label);
//        label = new Label(2, ultimaFila+2, "Plazo de Ejecución: ", times16format); sheet.addCell(label);
//        label = new Label(3, ultimaFila+2,  obra?.plazoEjecucionMeses + " mes(meses)", times16format); sheet.addCell(label);
//        label = new Label(2, ultimaFila+3, "Anticipo: ", times16format); sheet.addCell(label);
//        label = new Label(3, ultimaFila+3,  obra?.porcentajeAnticipo + " %", times16format); sheet.addCell(label);
//        label = new Label(2, ultimaFila+4, "Elaboró: ", times16format); sheet.addCell(label);
//        label = new Label(3, ultimaFila+4, (obra?.responsableObra?.titulo ?: '') + (obra?.responsableObra?.nombre ?: '') + ' ' + (obra?.responsableObra?.apellido ?: ''), times16format); sheet.addCell(label);

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "volObraVAE.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

}
