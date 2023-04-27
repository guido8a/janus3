package janus.utilitarios

import janus.Auxiliar
import janus.Item
import janus.Obra
import janus.VolumenesObra
import org.apache.poi.ss.usermodel.Row
import org.apache.poi.ss.usermodel.Sheet
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFWorkbook

class ReportesExcelController {

    def dbConnectionService
    def preciosService

    def matrizExcel() {

        def cn = dbConnectionService.getConnection()
        def cn1 = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def obra = Obra.get(params.id)

        XSSFWorkbook wb = new XSSFWorkbook()
        Sheet sheet = wb.createSheet("Matriz")

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        Row rowT = sheet.createRow(2)
        rowT.createCell(1).setCellValue("")
        Row rowT3 = sheet.createRow(3)
        rowT3.createCell(1).setCellValue(obra?.departamento?.direccion?.nombre ?: '')
        Row rowT4 = sheet.createRow(4)
        rowT4.createCell(1).setCellValue("Matriz de la Fórmula Polinómica")
        Row rowT5 = sheet.createRow(5)
        rowT5.createCell(1).setCellValue("")
        Row rowT6 = sheet.createRow(6)
        rowT6.createCell(1).setCellValue("Obra: ${obra.nombre ?: ''}")
        Row rowT7 = sheet.createRow(7)
        rowT7.createCell(1).setCellValue("Código: ${obra.codigo ?: ''}")
        Row rowT8 = sheet.createRow(8)
        rowT8.createCell(1).setCellValue("Memo Cant. Obra: ${obra.memoCantidadObra}")
        Row rowT9 = sheet.createRow(9)
        rowT9.createCell(1).setCellValue("Doc. Referencia: ${obra.oficioIngreso}")
        Row rowT10 = sheet.createRow(10)
        rowT10.createCell(1).setCellValue("Fecha: ${obra?.fechaCreacionObra?.format("dd-MM-yyyy")}")
        Row rowT11 = sheet.createRow(11)
        rowT11.createCell(1).setCellValue("Fecha Act. Precios: ${obra?.fechaPreciosRubros?.format("dd-MM-yyyy")}")
        Row rowT12 = sheet.createRow(12)
        rowT12.createCell(1).setCellValue("")

        def sql = "SELECT clmncdgo,clmndscr,clmntipo from mfcl where obra__id = ${obra.id} order by  1"
        def subSql = ""
        def sqlVl = ""
        def clmn = 0
        def col = ""
        def columna = 0
        def columna1 = 0
        def columna2 = 5
        def fila = 0

        Row row1 = sheet.createRow(13)
        cn.eachRow(sql.toString()) { r ->
            col = r[1]
            if (r[2] != "R") {
                def parts = r[1].split("_")
                try {
                    col = Item.get(parts[0].toLong()).nombre
                } catch (e) {
                    println "error: " + e
                    col = parts[0]
                }
                col += " " + parts[1]?.replaceAll("T", " Total")?.replaceAll("U", " Unitario")
            }
            row1.createCell(columna).setCellValue("${col}")
            columna ++
        }

        def sqlRb = "SELECT orden, codigo, rubro, unidad, cantidad from mfrb where obra__id = ${obra.id} order by orden"

        cn.eachRow(sqlRb.toString()) { rb ->
            Row row3 = sheet.createRow(fila + 14)

            4.times {
                row3.createCell(it).setCellValue(rb[it]?.toString() ?: "")
            }
            row3.createCell(4).setCellValue(rb?.cantidad?.toDouble()?.round(3) ?: 0)

            cn1.eachRow(sql.toString()) { r ->
                if (r.clmntipo != "R") {
                    subSql = "select valor from mfvl where clmncdgo = ${r.clmncdgo} and codigo='${rb.codigo.trim()}' and " +
                            "obra__id = ${obra.id}"
                    cn2.eachRow(subSql.toString()) { v ->
                        row3.createCell(columna2++).setCellValue(v.valor?.toDouble()?.round(5) ?: 0.00000)
                    }
                }
            }
            columna2 = 5
            fila++
        }


//        Row row1 = sheet.createRow(3)
//        row1.createCell(1).setCellValue("NÚMERO")
//        row1.createCell(2).setCellValue("PADRE")
//        row1.createCell(3).setCellValue("NIVEL")
//        row1.createCell(4).setCellValue("DESCRIPCIÓN")

//        cuentas.eachWithIndex{cuenta, j->
//            Row row2 = sheet.createRow(j+4)
//            row2.createCell(1).setCellValue(cuenta.numero)
//            row2.createCell(2).setCellValue(cuenta?.padre?.numero)
//            row2.createCell(3).setCellValue(cuenta.nivel.id)
//            row2.createCell(4).setCellValue(cuenta.descripcion)
//        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "matriz.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def imprimirRubrosExcel() {
        def obra = Obra.get(params.obra.toLong())
        def lugar = obra.lugar
        def fecha = obra.fechaPreciosRubros
        def itemsChofer = [obra.chofer]
        def itemsVolquete = [obra.volquete]
        def indi = obra.totales
        preciosService.ac_rbroObra(obra.id)

        XSSFWorkbook wb = new XSSFWorkbook()

        VolumenesObra.findAllByObra(obra, [sort: "orden"]).item.unique().eachWithIndex { rubro, i ->

            def number
            def totalHer = 0
            def totalMan = 0
            def totalMat = 0
            def total = 0
            def band = 0
            def rowsTrans = []
            def fila = 10
            def res = preciosService.presioUnitarioVolumenObra("* ", obra.id, rubro.id)
            Sheet sheet = wb.createSheet(rubro.codigo)
//            rubroAExcel(sheet, res, rubro, fecha, indi)

            Row row = sheet.createRow(0)
            row.createCell(0).setCellValue("")
            Row row0 = sheet.createRow(1)
            row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
            Row row1 = sheet.createRow(2)
            row1.createCell(1).setCellValue("DGCP - COORDINACIÓN DE FIJACIÓN DE PRECIOS UNITARIOS")
            Row row2 = sheet.createRow(3)
            row2.createCell(1).setCellValue("ANÁLISIS DE PRECIOS UNITARIOS")
            Row row3 = sheet.createRow(4)
            row3.createCell(1).setCellValue("")
            Row row4 = sheet.createRow(5)
            row4.createCell(1).setCellValue("Fecha: " + new Date().format("dd-MM-yyyy"))
            row4.sheet.addMergedRegion(new CellRangeAddress(5, 5, 1, 2));
            row4.createCell(4).setCellValue("Fecha Act. P.U: " + fecha?.format("dd-MM-yyyy"))
            row4.sheet.addMergedRegion(new CellRangeAddress(5, 5, 4, 5));
            Row row5 = sheet.createRow(6)
            row5.createCell(1).setCellValue("Código: " + rubro.codigo)
            row5.sheet.addMergedRegion(new CellRangeAddress(6, 6, 1, 2));
            row5.createCell(4).setCellValue("Unidad: " + rubro.unidad?.codigo)
            row5.sheet.addMergedRegion(new CellRangeAddress(6, 6, 4, 5));
            Row row6 = sheet.createRow(7)
            row6.createCell(1).setCellValue("Descripción: " + rubro.nombre)
            row6.sheet.addMergedRegion(new CellRangeAddress(7, 7, 1, 4));

            Row rowT1 = sheet.createRow(9)
            rowT1.createCell(0).setCellValue("Equipos")
            rowT1.sheet.addMergedRegion(new CellRangeAddress(9, 9, 1, 2));

            res.each { r ->
                if (r["grpocdgo"] == 3) {
                    if (band == 0) {
                        Row rowC1 = sheet.createRow(fila)
                        rowC1.createCell(0).setCellValue("Código")
                        rowC1.createCell(1).setCellValue("Descripción")
                        rowC1.createCell(2).setCellValue("Unidad")
                        rowC1.createCell(3).setCellValue("Cantidad")
                        rowC1.createCell(4).setCellValue("Tarifa")
                        rowC1.createCell(5).setCellValue("Costo")
                        rowC1.createCell(6).setCellValue("Rendimiento")
                        rowC1.createCell(7).setCellValue("C.Total")
                        fila++
                    }
                    band = 1
                    Row rowF1 = sheet.createRow(fila)
                    rowF1.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                    rowF1.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                    rowF1.createCell(2).setCellValue(r["unddcdgo"]?.toString())
                    rowF1.createCell(3).setCellValue(r["rbrocntd"]?.toDouble())
                    rowF1.createCell(4).setCellValue(r["rbpcpcun"]?.toDouble())
                    rowF1.createCell(5).setCellValue(r["rbpcpcun"] * r["rbrocntd"])
                    rowF1.createCell(6).setCellValue(r["rndm"]?.toDouble())
                    rowF1.createCell(7).setCellValue(r["parcial"]?.toDouble())
                    totalHer += r["parcial"]
                    fila++
                }
                if (r["grpocdgo"] == 2) {
                    if (band == 1) {
                        Row rowP1 = sheet.createRow(fila)
                        rowP1.createCell(0).setCellValue("SUBTOTAL")
                        rowP1.createCell(7).setCellValue(totalHer)
                        fila++
                    }
                    if (band != 2) {
                        fila++
                        Row rowT2 = sheet.createRow(fila)
                        rowT2.createCell(0).setCellValue("Mano de obra")
                        rowT2.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 1, 2));
                        fila++
                        Row rowC2 = sheet.createRow(fila)
                        rowC2.createCell(0).setCellValue("Código")
                        rowC2.createCell(1).setCellValue("Descripción")
                        rowC2.createCell(2).setCellValue("Unidad")
                        rowC2.createCell(3).setCellValue("Cantidad")
                        rowC2.createCell(4).setCellValue("Jornal")
                        rowC2.createCell(5).setCellValue("Costo")
                        rowC2.createCell(6).setCellValue("Rendimiento")
                        rowC2.createCell(7).setCellValue("C.Total")
                        fila++
                    }
                    band = 2
                    Row rowF2 = sheet.createRow(fila)
                    rowF2.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                    rowF2.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                    rowF2.createCell(2).setCellValue(r["unddcdgo"]?.toString())
                    rowF2.createCell(3).setCellValue(r["rbrocntd"]?.toDouble())
                    rowF2.createCell(4).setCellValue(r["rbpcpcun"]?.toDouble())
                    rowF2.createCell(5).setCellValue(r["rbpcpcun"] * r["rbrocntd"])
                    rowF2.createCell(6).setCellValue(r["rndm"]?.toDouble())
                    rowF2.createCell(7).setCellValue(r["parcial"]?.toDouble())
                    totalMan += r["parcial"]
                    fila++
                }

                if (r["grpocdgo"] == 1) {
                    if (band == 2) {
                        Row rowP2 = sheet.createRow(fila)
                        rowP2.createCell(0).setCellValue("SUBTOTAL")
                        rowP2.createCell(7).setCellValue(totalMan)
                        fila++
                    }
                    if (band != 3) {
                        fila++
                        Row rowT3 = sheet.createRow(fila)
                        rowT3.createCell(0).setCellValue("Materiales")
                        rowT3.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 1, 2));
                        fila++
                        Row rowC3 = sheet.createRow(fila)
                        rowC3.createCell(0).setCellValue("Código")
                        rowC3.createCell(1).setCellValue("Descripción")
                        rowC3.createCell(2).setCellValue("Unidad")
                        rowC3.createCell(3).setCellValue("Cantidad")
                        rowC3.createCell(4).setCellValue("Unitario")
                        rowC3.createCell(7).setCellValue("C.Total")
                        fila++
                    }
                    band = 3
                    Row rowF3 = sheet.createRow(fila)
                    rowF3.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                    rowF3.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                    rowF3.createCell(2).setCellValue(r["unddcdgo"]?.toString())
                    rowF3.createCell(3).setCellValue(r["rbrocntd"]?.toDouble())
                    rowF3.createCell(4).setCellValue(r["rbpcpcun"]?.toDouble())
                    rowF3.createCell(7).setCellValue(r["parcial"]?.toDouble())
                    totalMat += r["parcial"]
                    fila++
                }
                if (r["grpocdgo"] == 1) {
                    rowsTrans.add(r)
                    total += r["parcial_t"]
                }

            }

                if (band == 3) {
                    Row rowP3 = sheet.createRow(fila)
                    rowP3.createCell(0).setCellValue("SUBTOTAL")
                    rowP3.createCell(7).setCellValue(totalMat)
                    fila++
                }

                /*Tranporte*/
                if (rowsTrans.size() > 0) {
                    fila++
                    Row rowT4 = sheet.createRow(fila)
                    rowT4.createCell(0).setCellValue("Transporte")
                    rowT4.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 1, 2));
                    fila++
                    Row rowC4 = sheet.createRow(fila)
                    rowC4.createCell(0).setCellValue("Código")
                    rowC4.createCell(1).setCellValue("Descripción")
                    rowC4.createCell(2).setCellValue("Unidad")
                    rowC4.createCell(3).setCellValue("Peso/Vol")
                    rowC4.createCell(4).setCellValue("Cantidad")
                    rowC4.createCell(5).setCellValue("Distancia")
                    rowC4.createCell(6).setCellValue("Unitario")
                    rowC4.createCell(7).setCellValue("C.Total")
                    fila++
                    rowsTrans.each { rt ->
                        def tra = rt["parcial_t"]
                        def tot = 0
                        if (tra > 0)
                            tot = rt["parcial_t"] / (rt["itempeso"] * rt["rbrocntd"] * rt["distancia"])
                        Row rowF4 = sheet.createRow(fila)
                        rowF4.createCell(0).setCellValue(rt["itemcdgo"]?.toString())
                        rowF4.createCell(1).setCellValue(rt["itemnmbr"]?.toString())
                        rowF4.createCell(2).setCellValue(rt["unddcdgo"]?.toString())
                        rowF4.createCell(3).setCellValue(rt["itempeso"]?.toDouble())
                        rowF4.createCell(4).setCellValue(rt["rbrocntd"]?.toDouble())
                        rowF4.createCell(5).setCellValue(rt["distancia"]?.toDouble())
                        rowF4.createCell(6).setCellValue(tot)
                        rowF4.createCell(7).setCellValue(rt["parcial_t"]?.toDouble())
                        fila++
                    }
                    Row rowP4 = sheet.createRow(fila)
                    rowP4.createCell(0).setCellValue("SUBTOTAL")
                    rowP4.createCell(7).setCellValue(total)
                    fila++
                }

                /*indirectos */
                fila++
                Row rowT5 = sheet.createRow(fila)
                rowT5.createCell(0).setCellValue("Costos Indirectos")
                rowT5.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 1, 2));
                fila++
                Row rowC5 = sheet.createRow(fila)
                rowC5.createCell(0).setCellValue("Descripción")
                rowC5.createCell(6).setCellValue("Porcentaje")
                rowC5.createCell(7).setCellValue("Valor")
                fila++
                def totalRubro = total + totalHer + totalMan + totalMat
                def totalIndi = totalRubro * indi / 100
                Row rowF5 = sheet.createRow(fila)
                rowF5.createCell(0).setCellValue("Costos indirectos")
                rowF5.createCell(6).setCellValue(indi)
                rowF5.createCell(7).setCellValue(totalIndi)

                /*Totales*/
                fila += 4
                Row rowP6 = sheet.createRow(fila)
                rowP6.createCell(4).setCellValue("Costo unitario directo")
                rowP6.createCell(7).setCellValue(totalRubro)

                Row rowP7 = sheet.createRow(fila + 1)
                rowP7.createCell(4).setCellValue("Costos indirectos")
                rowP7.createCell(7).setCellValue(totalIndi)

                Row rowP8 = sheet.createRow(fila + 2)
                rowP8.createCell(4).setCellValue("Costo total del rubro")
                rowP8.createCell(7).setCellValue(totalRubro + totalIndi)

                Row rowP9 = sheet.createRow(fila + 3)
                rowP9.createCell(4).setCellValue("Precio unitario")
                rowP9.createCell(7).setCellValue((totalRubro + totalIndi).toDouble().round(2))

        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "rubros.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }


    def qqqqqq() {
//        def obra = Obra.get(params.obra.toLong())
//        def lugar = obra.lugar
//        def fecha = obra.fechaPreciosRubros
//        def itemsChofer = [obra.chofer]
//        def itemsVolquete = [obra.volquete]
//        def indi = obra.totales
//        WorkbookSettings workbookSettings = new WorkbookSettings()
//        workbookSettings.locale = Locale.default
//        def file = File.createTempFile('myExcelDocument', '.xls')
//        file.deleteOnExit()
//        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
//        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
//        WritableCellFormat formatXls = new WritableCellFormat(font)
//        def row = 0

//        preciosService.ac_rbroObra(obra.id)
//        VolumenesObra.findAllByObra(obra, [sort: "orden"]).item.unique().eachWithIndex { rubro, i ->
//            def res = preciosService.presioUnitarioVolumenObra("* ", obra.id, rubro.id)
//            WritableSheet sheet = workbook.createSheet(rubro.codigo, i)
//            rubroAExcel(sheet, res, rubro, fecha, indi)
//        }
//        workbook.write();
//        workbook.close();
//        def output = response.getOutputStream()
//        def header = "attachment; filename=" + "rubro.xls";
//        response.setContentType("application/octet-stream")
//        response.setHeader("Content-Disposition", header);
//        output.write(file.getBytes());

    }

//    def rubroAExcel(sheet, res, rubro, fecha, indi) {
//        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, false);
//        WritableCellFormat times16format = new WritableCellFormat(times16font);
//        WritableFont times10Font = new WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false);
//        WritableCellFormat times10 = new WritableCellFormat(times10Font);
//        sheet.setColumnView(0, 20)
//        sheet.setColumnView(1, 50)
//        sheet.setColumnView(2, 15)
//        sheet.setColumnView(3, 15)
//        sheet.setColumnView(4, 15)
//        sheet.setColumnView(5, 15)
//        sheet.setColumnView(6, 15)
//
//        def label = new Label(0, 1, (Auxiliar.get(1)?.titulo ?: '').toUpperCase(), times16format); sheet.addCell(label);
//        label = new Label(0, 2, "DGCP - COORDINACIÓN DE FIJACIÓN DE PRECIOS UNITARIOS".toUpperCase(), times16format); sheet.addCell(label);
//        label = new Label(0, 3, "Análisis de precios unitarios".toUpperCase(), times16format); sheet.addCell(label);
//
//        sheet.mergeCells(0, 1, 1, 1)
//        sheet.mergeCells(0, 2, 1, 2)
//        sheet.mergeCells(0, 3, 1, 3)
//        label = new Label(0, 5, "Fecha: " + new Date().format("dd-MM-yyyy"), times16format); sheet.addCell(label);
//        sheet.mergeCells(0, 5, 1, 5)
//        label = new Label(0, 6, "Código: " + rubro.codigo, times16format); sheet.addCell(label);
//        sheet.mergeCells(0, 6, 1, 6)
//        label = new Label(0, 7, "Descripción: " + rubro.nombre, times16format); sheet.addCell(label);
//        sheet.mergeCells(0, 7, 1, 7)
//        label = new Label(5, 5, "Fecha Act. P.U: " + fecha?.format("dd-MM-yyyy"), times16format); sheet.addCell(label);
//        sheet.mergeCells(5, 5, 6, 5)
//        label = new Label(5, 6, "Unidad: " + rubro.unidad?.codigo, times16format); sheet.addCell(label);
//        sheet.mergeCells(5, 6, 6, 6)
//
//        def fila = 9
//        label = new Label(0, fila, "Equipos", times16format); sheet.addCell(label);
//        sheet.mergeCells(0, fila, 1, fila)
//        fila++
//        def number
//        def totalHer = 0
//        def totalMan = 0
//        def totalMat = 0
//        def total = 0
//        def band = 0
//        def rowsTrans = []
//        res.each { r ->
//            if (r["grpocdgo"] == 3) {
//                if (band == 0) {
//                    label = new Label(0, fila, "Código", times16format); sheet.addCell(label);
//                    label = new Label(1, fila, "Descripción", times16format); sheet.addCell(label);
//                    label = new Label(2, fila, "Unidad", times16format); sheet.addCell(label);
//                    label = new Label(3, fila, "Cantidad", times16format); sheet.addCell(label);
//                    label = new Label(5, fila, "Tarifa", times16format); sheet.addCell(label);
//                    label = new Label(5, fila, "Costo", times16format); sheet.addCell(label);
//                    label = new Label(6, fila, "Rendimiento", times16format); sheet.addCell(label);
//                    label = new Label(7, fila, "C.Total", times16format); sheet.addCell(label);
//                    fila++
//                }
//                band = 1
//                label = new Label(0, fila, r["itemcdgo"], times10); sheet.addCell(label);
//                label = new Label(1, fila, r["itemnmbr"], times10); sheet.addCell(label);
//                label = new Label(2, fila, r["unddcdgo"], times10); sheet.addCell(label);
//                number = new Number(3, fila, r["rbrocntd"]); sheet.addCell(number);
//                number = new Number(4, fila, r["rbpcpcun"]); sheet.addCell(number);
//                number = new Number(5, fila, r["rbpcpcun"] * r["rbrocntd"]); sheet.addCell(number);
//                number = new Number(6, fila, r["rndm"]); sheet.addCell(number);
//                number = new Number(7, fila, r["parcial"]); sheet.addCell(number);
//                totalHer += r["parcial"]
//                fila++
//            }
//            if (r["grpocdgo"] == 2) {
//                if (band == 1) {
//                    label = new Label(0, fila, "SUBTOTAL", times10); sheet.addCell(label);
//                    number = new Number(6, fila, totalHer); sheet.addCell(number);
//                    fila++
//                }
//                if (band != 2) {
//                    fila++
//                    label = new Label(0, fila, "Mano de obra", times16format); sheet.addCell(label);
//                    sheet.mergeCells(0, fila, 1, fila)
//                    fila++
//                    label = new Label(0, fila, "Código", times16format); sheet.addCell(label);
//                    label = new Label(1, fila, "Descripción", times16format); sheet.addCell(label);
//                    label = new Label(2, fila, "Unidad", times16format); sheet.addCell(label);
//                    label = new Label(3, fila, "Cantidad", times16format); sheet.addCell(label);
//                    label = new Label(4, fila, "Jornal", times16format); sheet.addCell(label);
//                    label = new Label(5, fila, "Costo", times16format); sheet.addCell(label);
//                    label = new Label(6, fila, "Rendimiento", times16format); sheet.addCell(label);
//                    label = new Label(7, fila, "C.Total", times16format); sheet.addCell(label);
//                    fila++
//                }
//                band = 2
//                label = new Label(0, fila, r["itemcdgo"], times10); sheet.addCell(label);
//                label = new Label(1, fila, r["itemnmbr"], times10); sheet.addCell(label);
//                label = new Label(2, fila, r["unddcdgo"], times10); sheet.addCell(label);
//                number = new Number(3, fila, r["rbrocntd"]); sheet.addCell(number);
//                number = new Number(4, fila, r["rbpcpcun"]); sheet.addCell(number);
//                number = new Number(5, fila, r["rbpcpcun"] * r["rbrocntd"]); sheet.addCell(number);
//                number = new Number(6, fila, r["rndm"]); sheet.addCell(number);
//                number = new Number(7, fila, r["parcial"]); sheet.addCell(number);
//                totalMan += r["parcial"]
//                fila++
//            }
//
//            if (r["grpocdgo"] == 1) {
//                if (band == 2) {
//                    label = new Label(0, fila, "SUBTOTAL", times10); sheet.addCell(label);
//                    number = new Number(6, fila, totalMan); sheet.addCell(number);
//                    fila++
//                }
//                if (band != 3) {
//                    fila++
//                    label = new Label(0, fila, "Materiales", times16format); sheet.addCell(label);
//                    sheet.mergeCells(0, fila, 1, fila)
//                    fila++
//                    label = new Label(0, fila, "Código", times16format); sheet.addCell(label);
//                    label = new Label(1, fila, "Descripción", times16format); sheet.addCell(label);
//                    label = new Label(2, fila, "Unidad", times16format); sheet.addCell(label);
//                    label = new Label(3, fila, "Cantidad", times16format); sheet.addCell(label);
//                    label = new Label(4, fila, "Unitario", times16format); sheet.addCell(label);
//                    label = new Label(7, fila, "C.Total", times16format); sheet.addCell(label);
//                    fila++
//                }
//                band = 3
//                label = new Label(0, fila, r["itemcdgo"], times10); sheet.addCell(label);
//                label = new Label(1, fila, r["itemnmbr"], times10); sheet.addCell(label);
//                label = new Label(2, fila, r["unddcdgo"], times10); sheet.addCell(label);
//                number = new Number(3, fila, r["rbrocntd"]); sheet.addCell(number);
//                number = new Number(4, fila, r["rbpcpcun"]); sheet.addCell(number);
//                number = new Number(7, fila, r["parcial"]); sheet.addCell(number);
//                totalMat += r["parcial"]
//                fila++
//
//            }
//            if (r["grpocdgo"] == 1) {
//                rowsTrans.add(r)
//                total += r["parcial_t"]
//            }
//
//        }
//
//
//        if (band == 3) {
//            label = new Label(0, fila, "SUBTOTAL", times10); sheet.addCell(label);
//            number = new Number(7, fila, totalMat); sheet.addCell(number);
//            fila++
//        }
//
//        /*Tranporte*/
//        if (rowsTrans.size() > 0) {
//            fila++
//            label = new Label(0, fila, "Transporte", times16format); sheet.addCell(label);
//            sheet.mergeCells(0, fila, 1, fila)
//            fila++
//            label = new Label(0, fila, "Código", times16format); sheet.addCell(label);
//            label = new Label(1, fila, "Descripción", times16format); sheet.addCell(label);
//            label = new Label(2, fila, "Unidad", times16format); sheet.addCell(label);
//            label = new Label(3, fila, "Peso/Vol", times16format); sheet.addCell(label);
//            label = new Label(4, fila, "Cantidad", times16format); sheet.addCell(label);
//            label = new Label(5, fila, "Distancia", times16format); sheet.addCell(label);
//            label = new Label(6, fila, "Unitario", times16format); sheet.addCell(label);
//            label = new Label(7, fila, "C.Total", times16format); sheet.addCell(label);
//            fila++
//            rowsTrans.each { rt ->
//                def tra = rt["parcial_t"]
//                def tot = 0
//                if (tra > 0)
//                    tot = rt["parcial_t"] / (rt["itempeso"] * rt["rbrocntd"] * rt["distancia"])
//                label = new Label(0, fila, rt["itemcdgo"], times10); sheet.addCell(label);
//                label = new Label(1, fila, rt["itemnmbr"], times10); sheet.addCell(label);
//                label = new Label(2, fila, rt["unddcdgo"], times10); sheet.addCell(label);
//                number = new Number(3, fila, rt["itempeso"]); sheet.addCell(number);
//                number = new Number(4, fila, rt["rbrocntd"]); sheet.addCell(number);
//                number = new Number(5, fila, rt["distancia"]); sheet.addCell(number);
//                number = new Number(6, fila, tot); sheet.addCell(number);
//                number = new Number(7, fila, rt["parcial_t"]); sheet.addCell(number);
//                fila++
//            }
//            label = new Label(0, fila, "SUBTOTAL", times10); sheet.addCell(label);
//            number = new Number(7, fila, total); sheet.addCell(number);
//            fila++
//            fila++
//        }
//
//        /*indirectos */
//
//        label = new Label(0, fila, "Costos Indirectos", times16format); sheet.addCell(label);
//        sheet.mergeCells(0, fila, 1, fila)
//        fila++
//
//        label = new Label(0, fila, "Descripción", times16format); sheet.addCell(label);
//        sheet.mergeCells(0, fila, 1, fila)
//        label = new Label(5, fila, "Porcentaje", times16format); sheet.addCell(label);
//        label = new Label(6, fila, "Valor", times16format); sheet.addCell(label);
//        fila++
//        def totalRubro = total + totalHer + totalMan + totalMat
//        def totalIndi = totalRubro * indi / 100
//        label = new Label(0, fila, "Costos indirectos", times10); sheet.addCell(label);
//        sheet.mergeCells(0, fila, 1, fila)
//        number = new Number(5, fila, indi); sheet.addCell(number);
//        number = new Number(6, fila, totalIndi); sheet.addCell(number);
//
//        /*Totales*/
//        fila += 4
//        label = new Label(4, fila, "Costo unitario directo", times16format); sheet.addCell(label);
//        sheet.mergeCells(4, fila, 5, fila)
//        label = new Label(4, fila + 1, "Costos indirectos", times16format); sheet.addCell(label);
//        sheet.mergeCells(4, fila + 1, 5, fila + 1)
//        label = new Label(4, fila + 2, "Costo total del rubro", times16format); sheet.addCell(label);
//        sheet.mergeCells(4, fila + 2, 5, fila + 2)
//        label = new Label(4, fila + 3, "Precio unitario", times16format); sheet.addCell(label);
//        sheet.mergeCells(4, fila + 3, 5, fila + 3)
//        number = new Number(7, fila, totalRubro); sheet.addCell(number);
//        number = new Number(7, fila + 1, totalIndi); sheet.addCell(number);
//        number = new Number(7, fila + 2, totalRubro + totalIndi); sheet.addCell(number);
//        number = new Number(7, fila + 3, (totalRubro + totalIndi).toDouble().round(2)); sheet.addCell(number);
//        return sheet
//    }
}
