package janus.utilitarios

import janus.Auxiliar
import janus.Departamento
import janus.Item
import janus.Obra
import janus.VolumenesObra
import org.apache.poi.ss.usermodel.HorizontalAlignment
import org.apache.poi.ss.usermodel.Row
import org.apache.poi.ss.usermodel.Sheet
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFCellStyle
import org.apache.poi.xssf.usermodel.XSSFFont
import org.apache.poi.xssf.usermodel.XSSFWorkbook

class ReportesExcelController {

    def dbConnectionService
    def preciosService
    def reportesService

    def matrizExcel() {

        def cn = dbConnectionService.getConnection()
        def cn1 = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def obra = Obra.get(params.id)

        XSSFWorkbook wb = new XSSFWorkbook()
        Sheet sheet = wb.createSheet("Matriz")
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row rowT = sheet.createRow(2)
        rowT.createCell(1).setCellValue("")
        Row rowT3 = sheet.createRow(3)
        rowT3.createCell(1).setCellValue(obra?.departamento?.direccion?.nombre ?: '')
        rowT3.setRowStyle(style)
        Row rowT4 = sheet.createRow(4)
        rowT4.createCell(1).setCellValue("Matriz de la Fórmula Polinómica")
        rowT4.setRowStyle(style)
        Row rowT5 = sheet.createRow(5)
        rowT5.createCell(1).setCellValue("")
        Row rowT6 = sheet.createRow(6)
        rowT6.createCell(1).setCellValue("Obra: ${obra.nombre ?: ''}")
        rowT6.setRowStyle(style)
        Row rowT7 = sheet.createRow(7)
        rowT7.createCell(1).setCellValue("Código: ${obra.codigo ?: ''}")
        rowT7.setRowStyle(style)
        Row rowT8 = sheet.createRow(8)
        rowT8.createCell(1).setCellValue("Memo Cant. Obra: ${obra.memoCantidadObra ?: ''}")
        rowT8.setRowStyle(style)
        Row rowT9 = sheet.createRow(9)
        rowT9.createCell(1).setCellValue("Doc. Referencia: ${obra.oficioIngreso ?: ''}")
        rowT9.setRowStyle(style)
        Row rowT10 = sheet.createRow(10)
        rowT10.createCell(1).setCellValue("Fecha: ${obra?.fechaCreacionObra?.format("dd-MM-yyyy")}")
        rowT10.setRowStyle(style)
        Row rowT11 = sheet.createRow(11)
        rowT11.createCell(1).setCellValue("Fecha Act. Precios: ${obra?.fechaPreciosRubros?.format("dd-MM-yyyy")}")
        rowT11.setRowStyle(style)
        Row rowT12 = sheet.createRow(12)
        rowT12.createCell(1).setCellValue("")
        rowT12.setRowStyle(style)

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
            row1.setRowStyle(style)
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
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

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
            sheet.setColumnWidth(1, 40 * 256)
            sheet.setColumnWidth(3, 15 * 256)
            sheet.setColumnWidth(4, 15 * 256)
            sheet.setColumnWidth(5, 15 * 256)
            sheet.setColumnWidth(6, 15 * 256)
            sheet.setColumnWidth(7, 15 * 256)

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

//            Row rowT1 = sheet.createRow(9)
//            rowT1.createCell(0).setCellValue("Equipos")
//            rowT1.sheet.addMergedRegion(new CellRangeAddress(9, 9, 0, 2))
//            rowT1.setRowStyle(style)

//            res.each { r ->
//                if (r["grpocdgo"] == 3) {
//                    if (band == 0) {
//                        Row rowC1 = sheet.createRow(fila)
//                        rowC1.createCell(0).setCellValue("Código")
//                        rowC1.createCell(1).setCellValue("Descripción")
//                        rowC1.createCell(2).setCellValue("Unidad")
//                        rowC1.createCell(3).setCellValue("Cantidad")
//                        rowC1.createCell(4).setCellValue("Tarifa")
//                        rowC1.createCell(5).setCellValue("Costo")
//                        rowC1.createCell(6).setCellValue("Rendimiento")
//                        rowC1.createCell(7).setCellValue("C.Total")
//                        rowC1.setRowStyle(style)
//                        fila++
//                    }
//                    band = 1
//                    Row rowF1 = sheet.createRow(fila)
//                    rowF1.createCell(0).setCellValue(r["itemcdgo"]?.toString())
//                    rowF1.createCell(1).setCellValue(r["itemnmbr"]?.toString())
//                    rowF1.createCell(2).setCellValue(r["unddcdgo"]?.toString())
//                    rowF1.createCell(3).setCellValue(r["rbrocntd"]?.toDouble())
//                    rowF1.createCell(4).setCellValue(r["rbpcpcun"]?.toDouble())
//                    rowF1.createCell(5).setCellValue(r["rbpcpcun"] * r["rbrocntd"])
//                    rowF1.createCell(6).setCellValue(r["rndm"]?.toDouble())
//                    rowF1.createCell(7).setCellValue(r["parcial"]?.toDouble())
//                    totalHer += r["parcial"]
//                    fila++
//                }
//
//                if (r["grpocdgo"] == 2) {
//                    if (band == 1) {
//                        Row rowP1 = sheet.createRow(fila)
//                        rowP1.createCell(0).setCellValue("SUBTOTAL")
//                        rowP1.createCell(7).setCellValue(totalHer)
//                        fila++
//                    }
//                    if (band != 2) {
//                        fila++
//                        Row rowT2 = sheet.createRow(fila)
//                        rowT2.createCell(0).setCellValue("Mano de obra")
//                        rowT2.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
//                        rowT2.setRowStyle(style)
//                        fila++
//                        Row rowC2 = sheet.createRow(fila)
//                        rowC2.createCell(0).setCellValue("Código")
//                        rowC2.createCell(1).setCellValue("Descripción")
//                        rowC2.createCell(2).setCellValue("Unidad")
//                        rowC2.createCell(3).setCellValue("Cantidad")
//                        rowC2.createCell(4).setCellValue("Jornal")
//                        rowC2.createCell(5).setCellValue("Costo")
//                        rowC2.createCell(6).setCellValue("Rendimiento")
//                        rowC2.createCell(7).setCellValue("C.Total")
//                        rowC2.setRowStyle(style)
//                        fila++
//                    }
//                    band = 2
//                    Row rowF2 = sheet.createRow(fila)
//                    rowF2.createCell(0).setCellValue(r["itemcdgo"]?.toString())
//                    rowF2.createCell(1).setCellValue(r["itemnmbr"]?.toString())
//                    rowF2.createCell(2).setCellValue(r["unddcdgo"]?.toString())
//                    rowF2.createCell(3).setCellValue(r["rbrocntd"]?.toDouble())
//                    rowF2.createCell(4).setCellValue(r["rbpcpcun"]?.toDouble())
//                    rowF2.createCell(5).setCellValue(r["rbpcpcun"] * r["rbrocntd"])
//                    rowF2.createCell(6).setCellValue(r["rndm"]?.toDouble())
//                    rowF2.createCell(7).setCellValue(r["parcial"]?.toDouble())
//                    totalMan += r["parcial"]
//                    fila++
//                }
//
//                if (r["grpocdgo"] == 1) {
//                    if (band == 2) {
//                        Row rowP2 = sheet.createRow(fila)
//                        rowP2.createCell(0).setCellValue("SUBTOTAL")
//                        rowP2.createCell(7).setCellValue(totalMan)
//                        fila++
//                    }
//                    if (band != 3) {
//                        fila++
//                        Row rowT3 = sheet.createRow(fila)
//                        rowT3.createCell(0).setCellValue("Materiales")
//                        rowT3.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
//                        rowT3.setRowStyle(style)
//                        fila++
//                        Row rowC3 = sheet.createRow(fila)
//                        rowC3.createCell(0).setCellValue("Código")
//                        rowC3.createCell(1).setCellValue("Descripción")
//                        rowC3.createCell(2).setCellValue("Unidad")
//                        rowC3.createCell(3).setCellValue("Cantidad")
//                        rowC3.createCell(4).setCellValue("Unitario")
//                        rowC3.createCell(7).setCellValue("C.Total")
//                        rowC3.setRowStyle(style)
//                        fila++
//                    }
//                    band = 3
//                    Row rowF3 = sheet.createRow(fila)
//                    rowF3.createCell(0).setCellValue(r["itemcdgo"]?.toString())
//                    rowF3.createCell(1).setCellValue(r["itemnmbr"]?.toString())
//                    rowF3.createCell(2).setCellValue(r["unddcdgo"]?.toString())
//                    rowF3.createCell(3).setCellValue(r["rbrocntd"]?.toDouble())
//                    rowF3.createCell(4).setCellValue(r["rbpcpcun"]?.toDouble())
//                    rowF3.createCell(7).setCellValue(r["parcial"]?.toDouble())
//                    totalMat += r["parcial"]
//                    fila++
//                }
//                if (r["grpocdgo"] == 1) {
//                    rowsTrans.add(r)
//                    total += r["parcial_t"]
//                }
//            }


            def imprimirEquipos = {
                res.each { r ->
                    if (r["grpocdgo"] == 3) {
                        if (band == 0) {
                            Row rowT1 = sheet.createRow(9)
                            rowT1.createCell(0).setCellValue("Equipos")
                            rowT1.sheet.addMergedRegion(new CellRangeAddress(9, 9, 0, 2))
                            rowT1.setRowStyle(style)
                            Row rowC1 = sheet.createRow(fila)
                            rowC1.createCell(0).setCellValue("Código")
                            rowC1.createCell(1).setCellValue("Descripción")
                            rowC1.createCell(2).setCellValue("Unidad")
                            rowC1.createCell(3).setCellValue("Cantidad")
                            rowC1.createCell(4).setCellValue("Tarifa")
                            rowC1.createCell(5).setCellValue("Costo")
                            rowC1.createCell(6).setCellValue("Rendimiento")
                            rowC1.createCell(7).setCellValue("C.Total")
                            rowC1.setRowStyle(style)
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
                }
                if(band == 1) {
                    Row rowP1 = sheet.createRow(fila)
                    rowP1.createCell(0).setCellValue("SUBTOTAL")
                    rowP1.createCell(7).setCellValue(totalHer)
                    fila++
                }
            }


            def imprimirMano = {
                res.each { r ->
                    if (r["grpocdgo"] == 2) {
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
                            rowC2.createCell(2).setCellValue("Unidad")
                            rowC2.createCell(3).setCellValue("Cantidad")
                            rowC2.createCell(4).setCellValue("Jornal")
                            rowC2.createCell(5).setCellValue("Costo")
                            rowC2.createCell(6).setCellValue("Rendimiento")
                            rowC2.createCell(7).setCellValue("C.Total")
                            rowC2.setRowStyle(style)
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
                }
                if(band == 2){
                Row rowP2 = sheet.createRow(fila)
                rowP2.createCell(0).setCellValue("SUBTOTAL")
                rowP2.createCell(7).setCellValue(totalMan)
                fila++
                }
            }


            def imprimirMateriales = {
                res.each { r ->
                    if (r["grpocdgo"] == 1) {
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
                            rowC3.createCell(4).setCellValue("Unitario")
                            rowC3.createCell(7).setCellValue("C.Total")
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
                        rowF3.createCell(7).setCellValue(r["parcial"]?.toDouble())
                        totalMat += r["parcial"]
                        fila++
                    }
                    if (r["grpocdgo"] == 1) {
                        rowsTrans.add(r)
                        total += r["parcial_t"]
                    }
                }

                if(band == 3){
                    Row rowP3 = sheet.createRow(fila)
                    rowP3.createCell(0).setCellValue("SUBTOTAL")
                    rowP3.createCell(7).setCellValue(totalMat)
                    fila++
                }
            }


            imprimirEquipos();
            imprimirMano();
            imprimirMateriales();

//            if (band == 3) {
//            Row rowP3 = sheet.createRow(fila)
//            rowP3.createCell(0).setCellValue("SUBTOTAL M")
//            rowP3.createCell(7).setCellValue(totalMat)
//            fila++
//            }

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
                rowC4.createCell(2).setCellValue("Unidad")
                rowC4.createCell(3).setCellValue("Peso/Vol")
                rowC4.createCell(4).setCellValue("Cantidad")
                rowC4.createCell(5).setCellValue("Distancia")
                rowC4.createCell(6).setCellValue("Unitario")
                rowC4.createCell(7).setCellValue("C.Total")
                rowC4.setRowStyle(style)
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
            rowT5.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
            rowT5.setRowStyle(style)
            fila++
            Row rowC5 = sheet.createRow(fila)
            rowC5.createCell(0).setCellValue("Descripción")
            rowC5.createCell(6).setCellValue("Porcentaje")
            rowC5.createCell(7).setCellValue("Valor")
            rowC5.setRowStyle(style)
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
            rowP6.setRowStyle(style)

            Row rowP7 = sheet.createRow(fila + 1)
            rowP7.createCell(4).setCellValue("Costos indirectos")
            rowP7.createCell(7).setCellValue(totalIndi)
            rowP7.setRowStyle(style)

            Row rowP8 = sheet.createRow(fila + 2)
            rowP8.createCell(4).setCellValue("Costo total del rubro")
            rowP8.createCell(7).setCellValue(totalRubro + totalIndi)
            rowP8.setRowStyle(style)

            Row rowP9 = sheet.createRow(fila + 3)
            rowP9.createCell(4).setCellValue("Precio unitario")
            rowP9.createCell(7).setCellValue((totalRubro + totalIndi).toDouble().round(2))
            rowP9.setRowStyle(style)

        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "rubros.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }



    def imprimirRubrosVaeExcel () {
        println "imprimirRubrosVaeExcel --> "
        def obra = Obra.get(params.obra.toLong())
        def lugar = obra.lugar
        def fecha = obra.fechaPreciosRubros
        def itemsChofer = [obra?.chofer]
        def itemsVolquete = [obra?.volquete]
        def indi = obra.totales
        preciosService.ac_rbroObra(obra.id)

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        XSSFCellStyle style2 = wb.createCellStyle();
        XSSFFont font2 = wb.createFont();
        font2.setBold(true);
        style2.setFont(font2);
        style2.setAlignment(HorizontalAlignment.CENTER);


        VolumenesObra.findAllByObra(obra, [sort: "orden"]).item.unique().eachWithIndex { rubro, i ->
            def res = preciosService.presioUnitarioVolumenObra("* ", obra.id, rubro.id)
            def vae = preciosService.vae_rb(obra.id,rubro.id)

            def fila = 10
            def number
            def number2
            def totalHer = 0
            def totalMan = 0
            def totalManRel = 0
            def totalManVae = 0
            def totalMat = 0
            def totalMatRel = 0
            def totalMatVae = 0
            def totalHerRel = 0
            def totalHerVae = 0
            def totalTRel = 0
            def totalTVae = 0
            def total = 0
            def band = 25
            def flag = 0
            def rowsTrans = []

            Sheet sheet = wb.createSheet(rubro.codigo)
            sheet.setColumnWidth(1, 40 * 256);
            sheet.setColumnWidth(3, 15 * 256);
            sheet.setColumnWidth(4, 15 * 256);
            sheet.setColumnWidth(5, 15 * 256);
            sheet.setColumnWidth(6, 15 * 256);
            sheet.setColumnWidth(7, 15 * 256);

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
            row4.sheet.addMergedRegion(new CellRangeAddress(5, 5, 1, 3));
            row4.createCell(5).setCellValue("Fecha Act. P.U: " + fecha?.format("dd-MM-yyyy"))
            row4.sheet.addMergedRegion(new CellRangeAddress(5, 5, 5, 7));
            row4.setRowStyle(style)
            Row row5 = sheet.createRow(6)
            row5.createCell(1).setCellValue("Código: " + rubro.codigo)
            row5.sheet.addMergedRegion(new CellRangeAddress(6, 6, 1, 3));
            row5.createCell(5).setCellValue("Unidad: " + rubro.unidad?.codigo)
            row5.sheet.addMergedRegion(new CellRangeAddress(6, 6, 5, 7));
            row5.setRowStyle(style)
            Row row6 = sheet.createRow(7)
            row6.createCell(1).setCellValue("Código Especificación: " + (rubro?.codigoEspecificacion ?: ''))
            row6.setRowStyle(style)
            Row row7 = sheet.createRow(8)
            row7.createCell(1).setCellValue("Descripción: " + rubro.nombre)
            row7.setRowStyle(style)

            vae.eachWithIndex { r, j ->

                if (r["grpocdgo"] == 3) {
                    if (band != 0) {
                        fila++
                        Row rowT1 = sheet.createRow(fila)
                        rowT1.createCell(0).setCellValue("Equipos")
                        rowT1.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
                        rowT1.setRowStyle(style)
                        fila++

                        Row rowC1 = sheet.createRow(fila)
                        rowC1.createCell(0).setCellValue("Código")
                        rowC1.createCell(1).setCellValue("Descripción")
                        rowC1.createCell(2).setCellValue("Unidad")
                        rowC1.createCell(3).setCellValue("Cantidad")
                        rowC1.createCell(4).setCellValue("Tarifa")
                        rowC1.createCell(5).setCellValue("Costo")
                        rowC1.createCell(6).setCellValue("Rendimiento")
                        rowC1.createCell(7).setCellValue("C.Total")
                        rowC1.createCell(8).setCellValue("Peso Relat(%)")
                        rowC1.createCell(9).setCellValue("CPC")
                        rowC1.createCell(10).setCellValue("NP/EP/ND")
                        rowC1.createCell(11).setCellValue("VAE(%)")
                        rowC1.createCell(12).setCellValue("VAE(%) Elemento")
                        rowC1.setRowStyle(style)
                        fila++
                    }
                    band = 0

                    Row rowF1 = sheet.createRow(fila)
                    rowF1.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                    rowF1.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                    rowF1.createCell(2).setCellValue(r["unddcdgo"]?.toString())
                    rowF1.createCell(3).setCellValue(r["rbrocntd"]?.toDouble())
                    rowF1.createCell(4).setCellValue(r["rbpcpcun"]?.toDouble())
                    rowF1.createCell(5).setCellValue(r["rbpcpcun"] * r["rbrocntd"])
                    rowF1.createCell(6).setCellValue(r["rndm"]?.toDouble())
                    rowF1.createCell(7).setCellValue(r["parcial"]?.toDouble())
                    rowF1.createCell(8).setCellValue(r["relativo"]?.toDouble())
                    rowF1.createCell(9).setCellValue(r.itemcpac?.toDouble())
                    rowF1.createCell(10).setCellValue(r.tpbncdgo)
                    rowF1.createCell(11).setCellValue(r["vae"]?.toDouble())
                    rowF1.createCell(12).setCellValue(r["vae_vlor"]?.toDouble())

                    totalHer += r["parcial"]
                    totalHerRel += r["relativo"]
                    totalHerVae += r["vae_vlor"]
                    fila++
                }

                if (r["grpocdgo"] == 2) {
                    if (band == 0) {
                        Row rowP1 = sheet.createRow(fila)
                        rowP1.createCell(0).setCellValue("SUBTOTAL")
                        rowP1.createCell(7).setCellValue(totalHer)
                        rowP1.createCell(8).setCellValue(totalHerRel)
                        rowP1.createCell(12).setCellValue(totalHerVae)
                        fila++
                    }

                    if (band != 2) {
                        fila++
                        Row rowT2 = sheet.createRow(fila)
                        rowT2.createCell(0).setCellValue("Mano de Obra")
                        rowT2.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
                        rowT2.setRowStyle(style)
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
                        rowC2.createCell(8).setCellValue("Peso Relat(%)")
                        rowC2.createCell(9).setCellValue("CPC")
                        rowC2.createCell(10).setCellValue("NP/EP/ND")
                        rowC2.createCell(11).setCellValue("VAE(%)")
                        rowC2.createCell(12).setCellValue("VAE(%) Elemento")
                        rowC2.setRowStyle(style)
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
                    rowF2.createCell(8).setCellValue(r["relativo"]?.toDouble())
                    rowF2.createCell(9).setCellValue(r.itemcpac?.toDouble())
                    rowF2.createCell(10).setCellValue(r.tpbncdgo)
                    rowF2.createCell(11).setCellValue(r["vae"]?.toDouble())
                    rowF2.createCell(12).setCellValue(r["vae_vlor"]?.toDouble())

                    totalMan += r["parcial"]
                    totalManRel += r["relativo"]
                    totalManVae += r["vae_vlor"]
                    fila++
                }

                if(r["grpocdgo"] != 2){
                    if (band == 2) {
                        Row rowP2 = sheet.createRow(fila)
                        rowP2.createCell(0).setCellValue("SUBTOTAL")
                        rowP2.createCell(7).setCellValue(totalMan)
                        rowP2.createCell(8).setCellValue(totalManRel)
                        rowP2.createCell(12).setCellValue(totalManVae)
                        fila++
                    }
                }

                if (r["grpocdgo"] == 1) {
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
                        rowC3.createCell(4).setCellValue("Unitario")
                        rowC3.createCell(7).setCellValue("C.Total")
                        rowC3.createCell(8).setCellValue("Peso Relat(%)")
                        rowC3.createCell(9).setCellValue("CPC")
                        rowC3.createCell(0).setCellValue("NP/EP/ND")
                        rowC3.createCell(11).setCellValue("VAE(%)")
                        rowC3.createCell(12).setCellValue("VAE(%) Elemento")
                        rowC3.setRowStyle(style)
                        fila++
                    }
                    band = 3
                    flag = 1

                    Row rowF3 = sheet.createRow(fila)
                    rowF3.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                    rowF3.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                    rowF3.createCell(2).setCellValue(r["unddcdgo"]?.toString())
                    rowF3.createCell(3).setCellValue(r["rbrocntd"]?.toDouble())
                    rowF3.createCell(4).setCellValue(r["rbpcpcun"]?.toDouble())
                    rowF3.createCell(7).setCellValue(r["parcial"]?.toDouble())
                    rowF3.createCell(8).setCellValue(r["relativo"]?.toDouble())
                    rowF3.createCell(9).setCellValue(r.itemcpac?.toDouble())
                    rowF3.createCell(10).setCellValue(r.tpbncdgo)
                    rowF3.createCell(11).setCellValue(r["vae"]?.toDouble())
                    rowF3.createCell(12).setCellValue(r["vae_vlor"]?.toDouble())

                    totalMat += r["parcial"]
                    totalMatRel += r["relativo"]
                    totalMatVae += r["vae_vlor"]
                    fila++

                }

                if (r["grpocdgo"] == 1) {
                    rowsTrans.add(r)
                    total += r["parcial_t"]
                    totalTRel += r["relativo_t"]
                    totalTVae += r["vae_vlor_t"]
                }
            }

            if (band == 2 && flag != 1) {
                Row rowP21 = sheet.createRow(fila)
                rowP21.createCell(0).setCellValue("SUBTOTAL")
                rowP21.createCell(7).setCellValue(totalMan)
                rowP21.createCell(8).setCellValue(totalManRel)
                rowP21.createCell(12).setCellValue(totalManVae)
                fila++
            }

            if (band == 3) {
                Row rowP3 = sheet.createRow(fila)
                rowP3.createCell(0).setCellValue("SUBTOTAL")
                rowP3.createCell(7).setCellValue(totalMat)
                rowP3.createCell(8).setCellValue(totalMatRel)
                rowP3.createCell(12).setCellValue(totalMatVae)
                fila++
            }


            /*Tranporte*/
            if (rowsTrans.size() > 0) {
                fila++
                Row rowT3 = sheet.createRow(fila)
                rowT3.createCell(0).setCellValue("Transporte")
                rowT3.sheet.addMergedRegion(new CellRangeAddress(fila, fila, 0, 2));
                rowT3.setRowStyle(style)
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
                rowC4.createCell(8).setCellValue("Peso Relat(%)")
                rowC4.createCell(9).setCellValue("CPC")
                rowC4.createCell(10).setCellValue("NP/EP/ND")
                rowC4.createCell(11).setCellValue("VAE(%)")
                rowC4.createCell(12).setCellValue("VAE(%) Elemento")
                rowC4.setRowStyle(style)
                fila++

                def totalVaeT = 0

                rowsTrans.eachWithIndex { rt, j ->
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
                    rowF4.createCell(8).setCellValue(rt["relativo_t"]?.toDouble())
                    rowF4.createCell(9).setCellValue(rt["itemcpac"]?.toDouble())
                    rowF4.createCell(10).setCellValue(rt["tpbncdgo"]?.toString())
//                    rowF4.createCell(11).setCellValue(rt["vae_t"]?.toDouble())
                    rowF4.createCell(11).setCellValue(Item.findByCodigo(rt["itemcdgo"])?.transporteValor?.toDouble())
//                    rowF4.createCell(12).setCellValue(rt["vae_vlor_t"]?.toDouble())
                    rowF4.createCell(12).setCellValue((Item.findByCodigo(rt["itemcdgo"])?.transporteValor * rt["relativo_t"]).toDouble())
                    totalVaeT += (Item.findByCodigo(rt["itemcdgo"])?.transporteValor * rt["relativo_t"])
                    fila++
                }
                Row rowP4 = sheet.createRow(fila)
                rowP4.createCell(0).setCellValue("SUBTOTAL")
                rowP4.createCell(7).setCellValue(total)
                rowP4.createCell(8).setCellValue(totalTRel)
//                rowP4.createCell(12).setCellValue(totalTVae)
                rowP4.createCell(12).setCellValue(totalVaeT)
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
            rowC5.createCell(7).setCellValue("Porcentaje")
            rowC5.createCell(8).setCellValue("Valor")
            rowC5.setRowStyle(style)
            fila++
            def totalRubro = total + totalHer + totalMan + totalMat
            def totalRelativo = totalTRel + totalHerRel + totalMatRel + totalManRel
//            def totalVae = totalTVae + totalHerVae + totalMatVae + totalManVae
            def totalVae = 0 + totalHerVae + totalMatVae + totalManVae
                        

            def totalIndi = totalRubro * indi / 100
            Row rowF5 = sheet.createRow(fila)
            rowF5.createCell(0).setCellValue("Costos indirectos")
            rowF5.createCell(7).setCellValue(indi)
            rowF5.createCell(8).setCellValue(totalIndi)

            /*Totales*/
            fila += 4
            Row rowP6 = sheet.createRow(fila)
            rowP6.createCell(5).setCellValue("Costo unitario directo")
            rowP6.createCell(7).setCellValue(totalRubro)
            rowP6.createCell(8).setCellValue(totalRelativo)
            rowP6.createCell(12).setCellValue(totalVae)
            rowP6.setRowStyle(style)

            Row rowP7 = sheet.createRow(fila + 1)
            rowP7.createCell(5).setCellValue("Costos indirectos")
            rowP7.createCell(7).setCellValue(totalIndi)
            rowP7.createCell(8).setCellValue("TOTAL")
            rowP7.createCell(12).setCellValue("TOTAL")
            rowP7.setRowStyle(style)

            Row rowP8 = sheet.createRow(fila + 2)
            rowP8.createCell(5).setCellValue("Costo total del rubro")
            rowP8.createCell(7).setCellValue(totalRubro + totalIndi)
            rowP8.createCell(8).setCellValue("PESO")
            rowP8.createCell(12).setCellValue("VAE")
            rowP8.setRowStyle(style)

            Row rowP9 = sheet.createRow(fila + 3)
            rowP9.createCell(5).setCellValue("Precio unitario")
            rowP9.createCell(7).setCellValue((totalRubro + totalIndi).toDouble().round(2))
            rowP9.createCell(8).setCellValue("RELATIVO(%)")
            rowP9.createCell(12).setCellValue("(%)")
            rowP9.setRowStyle(style)

        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "rubrosVae.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def contratoFechas () {

        def cn = dbConnectionService.getConnection()
        def sql = "select * from rp_contrato()"
        def res =  cn.rows(sql.toString())

        def fila = 5;

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("Fechas")
        sheet.setColumnWidth(0, 20 * 256);
        sheet.setColumnWidth(1, 15 * 256);
        sheet.setColumnWidth(2, 20 * 256);
        sheet.setColumnWidth(3, 20 * 256);
        sheet.setColumnWidth(4, 10 * 256);
        sheet.setColumnWidth(5, 20 * 256);
        sheet.setColumnWidth(6, 50 * 256);
        sheet.setColumnWidth(7, 20 * 256);
        sheet.setColumnWidth(8, 20 * 256);
        sheet.setColumnWidth(9, 20 * 256);
        sheet.setColumnWidth(10, 20 * 256);
        sheet.setColumnWidth(11, 20 * 256);
        sheet.setColumnWidth(12, 20 * 256);
        sheet.setColumnWidth(13, 20 * 256);
        sheet.setColumnWidth(14, 20 * 256);
        sheet.setColumnWidth(15, 20 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("FISCALIZACIÓN")
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("CONTRATOS")
        row2.setRowStyle(style)
        fila++

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("CÓDIGO CONTRATO")
        rowC1.createCell(1).setCellValue("MONTO")
        rowC1.createCell(2).setCellValue("ANTICIPO PAGADO")
        rowC1.createCell(3).setCellValue("TOTAL PLANILLADO")
        rowC1.createCell(4).setCellValue("PLAZO")
        rowC1.createCell(5).setCellValue("CÓDIGO OBRA")
        rowC1.createCell(6).setCellValue("NOMBRE OBRA")
        rowC1.createCell(7).setCellValue("CANTÓN")
        rowC1.createCell(8).setCellValue("PARROQUIA")
        rowC1.createCell(9).setCellValue("FECHA DE SUBSCRIPCIÓN")
        rowC1.createCell(10).setCellValue("FECHA INICIO OBRA")
        rowC1.createCell(11).setCellValue("F ADMINISTRADOR")
        rowC1.createCell(12).setCellValue("F PIDE PAGO ANTC")
        rowC1.createCell(13).setCellValue("FECHA FINALIZACIÓN")
        rowC1.createCell(14).setCellValue("FECHA ACTA PROVISIONAL")
        rowC1.createCell(15).setCellValue("FECHA ACTA DEFINITIVA")
        rowC1.setRowStyle(style)
        fila++

        res.each{ contrato->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(contrato.cntrcdgo.toString() ?: '')
            rowF1.createCell(1).setCellValue(contrato.cntrmnto ?: 0)
            rowF1.createCell(2).setCellValue(contrato.cntrantc ?: 0)
            rowF1.createCell(3).setCellValue(contrato.plnltotl ?: 0)
            rowF1.createCell(4).setCellValue(contrato.cntrplzo ?: 0)
            rowF1.createCell(5).setCellValue(contrato?.obracdgo?.toString() ?: '')
            rowF1.createCell(6).setCellValue(contrato?.obranmbr?.toString() ?: '')
            rowF1.createCell(7).setCellValue(contrato?.cntnnmbr?.toString() ?: '')
            rowF1.createCell(8).setCellValue(contrato?.parrnmbr?.toString() ?: '')
            rowF1.createCell(9).setCellValue(contrato?.cntrfcsb?.toString() ?: '')
            rowF1.createCell(10).setCellValue(contrato?.obrafcin?.toString() ?: '')
            rowF1.createCell(11).setCellValue(contrato?.fchaadmn?.toString() ?: '')
            rowF1.createCell(12).setCellValue(contrato?.fchapdpg?.toString() ?: '')
            rowF1.createCell(13).setCellValue(contrato?.cntrfcfs?.toString() ?: '')
            rowF1.createCell(14).setCellValue(contrato?.acprfcha?.toString() ?: '')
            rowF1.createCell(15).setCellValue(contrato?.acdffcha?.toString() ?: '')
            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "contratoFechas.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def reporteExcelObrasFinalizadas () {

        def cn = dbConnectionService.getConnection()
        def campos = ['obracdgo', 'obranmbr', 'obradscr',
                      'obrasito', 'parrnmbr', 'cmndnmbr', 'diredscr']
        def sql = "select obracdgo, obranmbr, diredscr||' - '||dptodscr direccion, obrafcha, obrasito, parrnmbr, " +
                "cmndnmbr, obrafcin, obrafcfn from obra, dpto, dire, parr, cmnd " +
                "where dpto.dpto__id = obra.dpto__id and dire.dire__id = dpto.dire__id and " +
                "parr.parr__id = obra.parr__Id and cmnd.cmnd__id = obra.cmnd__id and " +
                "obrafcin is not null and " +
                "${campos[params.buscador.toInteger()]} ilike '%${params.criterio}%' " +
                "order by obrafcin desc"
        def obras = cn.rows(sql)

        def fila = 5;

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("ObrasFin")
        sheet.setColumnWidth(0, 20 * 256);
        sheet.setColumnWidth(1, 50 * 256);
        sheet.setColumnWidth(2, 50 * 256);
        sheet.setColumnWidth(3, 15 * 256);
        sheet.setColumnWidth(4, 30 * 256);
        sheet.setColumnWidth(5, 30 * 256);
        sheet.setColumnWidth(6, 15 * 256);
        sheet.setColumnWidth(7, 15 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("REPORTE EXCEL DE OBRAS FINALIZADAS")
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("CONTRATOS")
        row2.setRowStyle(style)
        fila++

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("Código")
        rowC1.createCell(1).setCellValue("Nombre")
        rowC1.createCell(2).setCellValue("Dirección")
        rowC1.createCell(3).setCellValue("Fecha Registro")
        rowC1.createCell(4).setCellValue("Sitio")
        rowC1.createCell(5).setCellValue("Parroquia - Comunidad")
        rowC1.createCell(6).setCellValue("Fecha Inicio")
        rowC1.createCell(7).setCellValue("Fecha Fin")
        rowC1.setRowStyle(style)
        fila++

        obras.eachWithIndex {i, j->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(i.obracdgo.toString() ?: '')
            rowF1.createCell(1).setCellValue(i.obranmbr.toString() ?: '')
            rowF1.createCell(2).setCellValue(i.direccion.toString() ?: '')
            rowF1.createCell(3).setCellValue(i?.obrafcha?.format("dd-MM-yyyy")?.toString() ?: '')
            rowF1.createCell(4).setCellValue(i?.obrasito?.toString() ?: '')
            rowF1.createCell(5).setCellValue(i?.parrnmbr?.toString() ?: '')
            rowF1.createCell(6).setCellValue(i?.obrafcin?.format("dd-MM-yyyy")?.toString() ?: '')
            rowF1.createCell(7).setCellValue(i?.obrafcfn?.format("dd-MM-yyyy")?.toString() ?: '')
            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "obrasFinalizadas.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def reporteExcelAvance () {

        def cn = dbConnectionService.getConnection()
        def campos = reportesService.obrasAvance()
        params.old = params.criterio
        params.criterio = reportesService.limpiaCriterio(params.criterio)
        def sql = armaSqlAvance(params)
        def obras = cn.rows(sql)
        params.criterio = params.old

        def fila = 4;

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("Avance")
        sheet.setColumnWidth(0, 20 * 256);
        sheet.setColumnWidth(1, 50 * 256);
        sheet.setColumnWidth(2, 30 * 256);
        sheet.setColumnWidth(3, 15 * 256);
        sheet.setColumnWidth(4, 30 * 256);
        sheet.setColumnWidth(5, 15 * 256);
        sheet.setColumnWidth(6, 15 * 256);
        sheet.setColumnWidth(7, 10 * 256);
        sheet.setColumnWidth(8, 15 * 256);
        sheet.setColumnWidth(9, 15 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("REPORTE EXCEL AVANCE DE OBRAS")
        row1.setRowStyle(style)
        fila++

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("Código")
        rowC1.createCell(1).setCellValue("Nombre")
        rowC1.createCell(2).setCellValue("Cantón-Parroquia-Comunidad")
        rowC1.createCell(3).setCellValue("Num. Contrato")
        rowC1.createCell(4).setCellValue("Contratista")
        rowC1.createCell(5).setCellValue("Monto")
        rowC1.createCell(6).setCellValue("Fecha suscripción")
        rowC1.createCell(7).setCellValue("Plazo")
        rowC1.createCell(8).setCellValue("% Avance")
        rowC1.createCell(9).setCellValue("Avance Físico")
        rowC1.setRowStyle(style)
        fila++

        obras.eachWithIndex {i, j->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(i.obracdgo.toString() ?: '')
            rowF1.createCell(1).setCellValue(i?.obranmbr?.toString() ?: '')
            rowF1.createCell(2).setCellValue(i?.cntnnmbr?.toString() + " " + i?.parrnmbr?.toString() + " " + i?.cmndnmbr?.toString())
            rowF1.createCell(3).setCellValue(i?.cntrcdgo?.toString() ?: '')
            rowF1.createCell(4).setCellValue(i?.prvenmbr?.toString() ?: '')
            rowF1.createCell(5).setCellValue( i.cntrmnto ?: 0)
            rowF1.createCell(6).setCellValue( i?.cntrfcsb?.toString() ?: '')
            rowF1.createCell(7).setCellValue(i.cntrplzo?.toString() ?: '')
            rowF1.createCell(8).setCellValue((i.av_economico * 100) ?: 0)
            rowF1.createCell(9).setCellValue((i.av_fisico * 100) ?: 0)
            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "avanceObras.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def armaSqlAvance(params){
        def campos = reportesService.obrasAvance()
        def operador = reportesService.operadores()

        def sqlSelect = "select obra.obra__id, obracdgo, obranmbr, cntnnmbr, parrnmbr, cmndnmbr, c.cntrcdgo, " +
                "c.cntrmnto, c.cntrfcsb, prvenmbr, c.cntrplzo, obrafcin, cntrfcfs," +
                "(select(coalesce(sum(plnlmnto), 0)) / cntrmnto av_economico " +
                "from plnl where cntr__id = c.cntr__id and tppl__id > 1), " +
                "(select(coalesce(max(plnlavfs), 0)) av_fisico " +
                "from plnl where cntr__id = c.cntr__id and tppl__id > 1) " +  // no cuenta el anticipo
                "from obra, cntn, parr, cmnd, cncr, ofrt, cntr c, dpto, prve "
        def sqlWhere = "where cmnd.cmnd__id = obra.cmnd__id and " +
                "parr.parr__id = obra.parr__id and cntn.cntn__id = parr.cntn__id and " +
                "cncr.obra__id = obra.obra__id and ofrt.cncr__id = cncr.cncr__id and " +
                "c.ofrt__id = ofrt.ofrt__id and dpto.dpto__id = obra.dpto__id and " +
                "prve.prve__id = c.prve__id"
        def sqlOrder = "order by obracdgo"

        params.nombre = "Código"
        if(campos.find {it.campo == params.buscador}?.size() > 0) {
            def op = operador.find {it.valor == params.operador}
            sqlWhere += " and ${params.buscador} ${op.operador} ${op.strInicio}${params.criterio}${op.strFin}";
        }
        "$sqlSelect $sqlWhere $sqlOrder".toString()
    }

    def reporteExcelGarantias() {

        def sql
        def res
        def cn

        def sqlBase =  "SELECT\n" +
                "  g.grnt__id    id,\n" +
                "  g.grntcdgo    codigo, \n" +
                "  g.grntnmrv    renovacion,\n" +
                "  c.cntrcdgo    codigocontrato,\n" +
                "  t.tpgrdscr    tipogarantia,\n" +
                "  q.tdgrdscr    documento,\n" +
                "  a.asgrnmbr    aseguradora,\n" +
                "  s.prvenmbr    contratista,\n" +
                "  g.grntetdo    estado,\n" +
                "  g.grntmnto    monto,\n" +
                "  m.mndacdgo    moneda,\n" +
                "  g.grntfcin    emision,\n" +
                "  g.grntfcfn    vencimiento,\n" +
                "  g.grntdias    dias\n" +
                "FROM grnt g\n" +
                "  LEFT JOIN cntr c ON g.cntr__id = c.cntr__id\n" +
                "  LEFT JOIN ofrt o ON c.ofrt__id = o.ofrt__id\n" +
                "  LEFT JOIN tpgr t ON g.tpgr__id = t.tpgr__id\n" +
                "  LEFT JOIN tdgr q ON g.tdgr__id = q.tdgr__id\n" +
                "  LEFT JOIN asgr a ON g.asgr__id = a.asgr__id\n" +
                "  LEFT JOIN prve s ON o.prve__id = s.prve__id\n" +
                "  LEFT JOIN mnda m ON g.mnda__id = m.mnda__id\n"


        def filtroBuscador = ""
        def buscador = ""

        params.criterio = params.criterio.trim();

        switch (params.buscador) {
            case "cdgo":
            case "etdo":
            case "mnto":
            case "dias":
                buscador = "grnt"+params.buscador
                filtroBuscador =" where ${buscador} ILIKE ('%${params.criterio}%') "
                break;
            case "contrato":
                filtroBuscador = " where c.cntrcdgo ILIKE ('%${params.criterio}%') "
                break;
            case "tpgr":
                filtroBuscador = " where t.tpgrdscr ILIKE ('%${params.criterio}%') "
                break;
            case "tdgr":
                filtroBuscador = " where q.tdgrdscr ILIKE ('%${params.criterio}%') "
                break;
            case "aseguradora":
                filtroBuscador = " where a.asgrnmbr ILIKE ('%${params.criterio}%') "
                break;
            case "cont":
                filtroBuscador = " where s.prvenmbr ILIKE ('%${params.criterio}%') "
                break;
            case "nmrv":
                if(!params.criterio){
                    params.criterio=0
                }
                filtroBuscador =" where g.grntnmrv = ${params.criterio} "
                break;
            case "mnda":
                filtroBuscador = " where m.mndacdgo ILIKE ('%${params.criterio}%') "
                break;
            case "fcin":
            case "fcfn":
                break;

        }

        sql = sqlBase + filtroBuscador
        cn = dbConnectionService.getConnection()
        res = cn.rows(sql.toString())

        def fila = 4;

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle()
        XSSFFont font = wb.createFont()
        font.setBold(true)
        style.setFont(font)

        Sheet sheet = wb.createSheet("Garantias")
        sheet.setColumnWidth(0, 15 * 256)
        sheet.setColumnWidth(1, 35 * 256)
        sheet.setColumnWidth(2, 20 * 256)
        sheet.setColumnWidth(3, 15 * 256)
        sheet.setColumnWidth(4, 10 * 256)
        sheet.setColumnWidth(5, 30 * 256)
        sheet.setColumnWidth(6, 10 * 256)
        sheet.setColumnWidth(7, 10 * 256)
        sheet.setColumnWidth(8, 15 * 256)
        sheet.setColumnWidth(9, 15 * 256)
        sheet.setColumnWidth(10, 15 * 256)
        sheet.setColumnWidth(11, 15 * 256)
        sheet.setColumnWidth(12, 10 * 256)

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("REPORTE EXCEL GARANTÍAS REGISTRADAS")
        row1.setRowStyle(style)

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("N° Contrato")
        rowC1.createCell(1).setCellValue("Contratista")
        rowC1.createCell(2).setCellValue("Tipo de Garantía")
        rowC1.createCell(3).setCellValue("N° Garantía")
        rowC1.createCell(4).setCellValue("Rnov")
        rowC1.createCell(5).setCellValue("Aseguradora")
        rowC1.createCell(6).setCellValue("Documento")
        rowC1.createCell(7).setCellValue("Estado")
        rowC1.createCell(8).setCellValue("Monto")
        rowC1.createCell(9).setCellValue("Emisión")
        rowC1.createCell(10).setCellValue("Vencimiento")
        rowC1.createCell(11).setCellValue("Cancelación")
        rowC1.createCell(12).setCellValue("Moneda")
        rowC1.setRowStyle(style)
        fila++

        res.eachWithIndex {i, j->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(i?.codigocontrato?.toString() ?: '')
            rowF1.createCell(1).setCellValue( i?.contratista ?: '')
            rowF1.createCell(2).setCellValue(i.tipogarantia.toString() ?: '')
            rowF1.createCell(3).setCellValue(i?.codigo?.toString() ?: '')
            rowF1.createCell(4).setCellValue(i.renovacion ?: 0)
            rowF1.createCell(5).setCellValue(i?.aseguradora?.toString() ?: '')
            rowF1.createCell(6).setCellValue(i?.documento?.toString() ?: '')
            rowF1.createCell(7).setCellValue(i?.estado?.toString() ?: '')
            rowF1.createCell(8).setCellValue(i.monto ?: 0)
            rowF1.createCell(9).setCellValue(i?.emision?.format("dd-MM-yyy")?.toString() ?: '')
            rowF1.createCell(10).setCellValue(i?.vencimiento?.format("dd-MM-yyy")?.toString() ?: '')
            rowF1.createCell(11).setCellValue(i.dias ?: 0)
            rowF1.createCell(12).setCellValue(i?.moneda?.toString() ?: '')
            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "garantias.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def reporteExcelAseguradoras() {

        def sql
        def cn
        def res

        def sqlBase =  "SELECT\n" +
                "  a.asgr__id    id,\n" +
                "  a.asgrfaxx    fax, \n" +
                "  a.asgrtelf    telefono,\n" +
                "  a.asgrnmbr    nombre,\n" +
                "  a.asgrdire    direccion,\n" +
                "  a.asgrrspn    contacto,\n" +
                "  a.asgrobsr    observaciones,\n" +
                "  a.asgrfeccn    fecha,\n" +
                "  t.tpasdscr    tipoaseguradora\n" +
                "FROM asgr a\n" +
                "  LEFT JOIN tpas t ON a.tpas__id = t.tpas__id\n"

        def filtroBuscador = ""
        def buscador=""

        params.criterio = params.criterio.trim();

        switch (params.buscador) {
            case "nmbr":
            case "telf":
            case "faxx":
            case "rspn":
            case "dire":
                buscador = "asgr"+params.buscador
                filtroBuscador =" where ${buscador} ILIKE ('%${params.criterio}%') "
                break;
            case "tipo":
                filtroBuscador = " where t.tpasdscr ILIKE ('%${params.criterio}%') "
                break;
        }

        sql = sqlBase + filtroBuscador
        cn = dbConnectionService.getConnection()
        res = cn.rows(sql.toString())

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle()
        XSSFFont font = wb.createFont()
        font.setBold(true)
        style.setFont(font)

        Sheet sheet = wb.createSheet("Aseguradoras")
        sheet.setColumnWidth(0, 10 * 256)
        sheet.setColumnWidth(1, 30 * 256)
        sheet.setColumnWidth(2, 30 * 256)
        sheet.setColumnWidth(3, 15 * 256)
        sheet.setColumnWidth(4, 25 * 256)
        sheet.setColumnWidth(5, 15 * 256)
        sheet.setColumnWidth(6, 30 * 256)

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("REPORTE EXCEL ASEGURADORAS")
        row1.setRowStyle(style)

        def fila = 4;

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("Tipo")
        rowC1.createCell(1).setCellValue("Nombre")
        rowC1.createCell(2).setCellValue("Dirección")
        rowC1.createCell(3).setCellValue("Teléfono")
        rowC1.createCell(4).setCellValue("Contacto")
        rowC1.createCell(5).setCellValue("Fecha Contacto")
        rowC1.createCell(6).setCellValue("Observaciones")
        rowC1.setRowStyle(style)
        fila++

        res.eachWithIndex {i, j->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(i?.tipoaseguradora?.toString() ?: '')
            rowF1.createCell(1).setCellValue(i?.nombre?.toString() ?: '')
            rowF1.createCell(2).setCellValue(i?.direccion?.toString() ?: '')
            rowF1.createCell(3).setCellValue(i?.telefono?.toString() ?: '')
            rowF1.createCell(4).setCellValue(i?.contacto?.toString() ?: '')
            rowF1.createCell(5).setCellValue(i?.fecha?.format("dd-MM-yyyy")?.toString() ?: '')
            rowF1.createCell(6).setCellValue(i?.observaciones?.toString() ?: '')
            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "aseguradoras.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def reporteExcelContratistas() {

        def sql
        def cn
        def res

        def sqlBase =  "SELECT\n" +
                "  p.prve__id    id,\n" +
                "  p.prve_ruc    ruc, \n" +
                "  p.prvesgla    sigla,\n" +
                "  p.prvettlr    titulo,\n" +
                "  p.prvenmbr    nombre,\n" +
                "  e.espcdscr    especialidad,\n" +
                "  p.prvecmra    camara,\n" +
                "  p.prvedire    direccion,\n" +
                "  p.prvetelf    telefono,\n" +
                "  p.prvefaxx    fax,\n" +
                "  p.prvegrnt    garante,\n" +
                "  p.prvenbct    nombrecon,\n" +
                "  p.prveapct    apellidocon,\n" +
                "  p.prvefccn    fecha,\n" +
                "  f.cntrfcsb    fechacontrato\n" +
                "FROM prve p\n" +
                "  LEFT JOIN espc e ON p.espc__id = e.espc__id\n"+
                "  LEFT JOIN ofrt o ON p.prve__id = o.prve__id\n"+
                "  LEFT JOIN cntr f ON o.ofrt__id = f.ofrt__id\n"

        def filtroBuscador = ""
        def buscador=""

        params.criterio = params.criterio.trim();

        switch (params.buscador) {
            case "cdgo":
            case "nmbr":
            case "_ruc":
                buscador = "prve"+params.buscador
                filtroBuscador =" where ${buscador} ILIKE ('%${params.criterio}%') "
                break;
            case "espe":
                filtroBuscador = " where e.espcdscr ILIKE ('%${params.criterio}%') "
                break;
        }

        sql = sqlBase + filtroBuscador
        cn = dbConnectionService.getConnection()
        res = cn.rows(sql.toString())

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle()
        XSSFFont font = wb.createFont()
        font.setBold(true)
        style.setFont(font)

        Sheet sheet = wb.createSheet("Contratistas")
        sheet.setColumnWidth(0, 30 * 256)
        sheet.setColumnWidth(1, 15 * 256)
        sheet.setColumnWidth(2, 10 * 256)
        sheet.setColumnWidth(3, 10 * 256)
        sheet.setColumnWidth(4, 30 * 256)
        sheet.setColumnWidth(5, 30 * 256)
        sheet.setColumnWidth(6, 10 * 256)
        sheet.setColumnWidth(7, 25 * 256)
        sheet.setColumnWidth(8, 15 * 256)
        sheet.setColumnWidth(9, 15 * 256)

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("REPORTE EXCEL CONTRATISTAS")
        row1.setRowStyle(style)

        def fila = 4;

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("Nombre")
        rowC1.createCell(1).setCellValue("Cédula/RUC")
        rowC1.createCell(2).setCellValue("Título")
        rowC1.createCell(3).setCellValue("Especialidad")
        rowC1.createCell(4).setCellValue("Contacto")
        rowC1.createCell(5).setCellValue("Dirección")
        rowC1.createCell(6).setCellValue("Teléfono")
        rowC1.createCell(7).setCellValue("Garante")
        rowC1.createCell(8).setCellValue("Fecha Cont.")
        rowC1.createCell(9).setCellValue("Fecha Contrato")
        rowC1.setRowStyle(style)
        fila++

        res.eachWithIndex {i, j->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(i.nombre.toString() ?: '')
            rowF1.createCell(1).setCellValue(i?.ruc?.toString() ?: '')
            rowF1.createCell(2).setCellValue(i?.titulo?.toString() ?: '')
            rowF1.createCell(3).setCellValue(i?.especialidad?.toString() ?: '')
            rowF1.createCell(4).setCellValue(i?.nombrecon?.toString() + " " + i?.apellidocon?.toString())
            rowF1.createCell(5).setCellValue(i?.direccion?.toString() ?: '')
            rowF1.createCell(6).setCellValue(i?.telefono?.toString() ?: '')
            rowF1.createCell(7).setCellValue(i?.garante?.toString() ?: '')
            rowF1.createCell(8).setCellValue(i?.fecha?.format("dd-MM-yyyy")?.toString() ?: '')
            rowF1.createCell(9).setCellValue(i?.fechacontrato?.format("dd-MM-yyyy")?.toString() ?: '')
            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "contratistas.xlsx"
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header)
        wb.write(output)
    }

    def reporteExcelContratos () {

        def sql
        def cn
        def res

        def sqlBase =  "SELECT\n" +
                "  c.cntr__id    id,\n" +
                "  c.cntrcdgo    codigo, \n" +
                "  c.cntrmemo    memo,\n" +
                "  c.cntrfcsb    fechasu,\n" +
                "  r.cncrcdgo    concurso,\n" +
                "  o.obracdgo    obracodigo,\n" +
                "  o.obranmbr    obranombre,\n" +
                "  n.cntnnmbr    canton,\n" +
                "  p.parrnmbr    parroquia,\n" +
                "  t.tpobdscr    tipoobra,\n" +
                "  e.tpcrdscr    tipocontrato,\n" +
                "  c.cntrmnto    monto,\n" +
                "  c.cntrpcan    porcentaje,\n" +
                "  c.cntrantc    anticipo,\n" +
                "  g.prvenmbr    nombrecontra,\n" +
                "  b.prinfcin    fechainicio,\n" +
                "  b.prinfcfn    fechafin,\n" +
                "  z.tppzdscr    plazo\n" +
                "FROM cntr c\n" +
                "  LEFT JOIN ofrt f ON c.ofrt__id = f.ofrt__id\n" +
                "  LEFT JOIN cncr r ON f.cncr__id = r.cncr__id\n" +
                "  LEFT JOIN obra o ON r.obra__id = o.obra__id\n" +
                "  LEFT JOIN cmnd d ON o.cmnd__id = d.cmnd__id\n" +
                "  LEFT JOIN parr p ON o.parr__id = p.parr__id\n" +
                "  LEFT JOIN cntn n ON p.cntn__id = n.cntn__id\n" +
                "  LEFT JOIN tpcr e ON c.tpcr__id = e.tpcr__id\n" +
                "  LEFT JOIN tpob t ON o.tpob__id = t.tpob__id\n" +
                "  LEFT JOIN prin b ON c.prin__id = b.prin__id\n" +
                "  LEFT JOIN tppz z ON c.tppz__id = z.tppz__id\n" +
                "  LEFT JOIN prve g ON f.prve__id = g.prve__id\n"

        def filtroBuscador = ""

        def buscador = ""

        params.criterio = params.criterio.trim();

        switch (params.buscador) {
            case "cdgo":
            case "memo":
            case "ofsl":
            case "mnto":
                buscador = "cntr"+params.buscador
                filtroBuscador =" where ${buscador} ILIKE ('%${params.criterio}%') "
                break;
            case "cncr":
                filtroBuscador = " where r.cncrcdgo ILIKE ('%${params.criterio}%') "
                break
            case "parr":
                filtroBuscador = " where p.parrnmbr ILIKE ('%${params.criterio}%') "
                break
            case "cntn":
                filtroBuscador = " where n.cntnnmbr ILIKE ('%${params.criterio}%') "
                break
            case "obra":
                filtroBuscador = " where o.obracdgo ILIKE ('%${params.criterio}%') "
                break
            case "clas":
                filtroBuscador = " where t.tpodscr ILIKE ('%${params.criterio}%') "
                break
            case "nmbr":
                filtroBuscador = " where o.obranmbr ILIKE ('%${params.criterio}%') "
                break
            case "tipo":
                filtroBuscador = " where e.tpcrdscr ILIKE ('%${params.criterio}%') "
                break
            case "cont":
                filtroBuscador = " where g.prvenmbr ILIKE ('%${params.criterio}%') "
                break
            case "tppz":
                filtroBuscador = " where z.tppzdscr ILIKE ('%${params.criterio}%') "
                break
            case "inic":
            case "fin":
            case "fcsb":
                break

        }

        sql = sqlBase + filtroBuscador
        cn = dbConnectionService.getConnection()
        res = cn.rows(sql.toString())

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle()
        XSSFFont font = wb.createFont()
        font.setBold(true)
        style.setFont(font)

        Sheet sheet = wb.createSheet("Contratos")
        sheet.setColumnWidth(0, 15 * 256)
        sheet.setColumnWidth(1, 15 * 256)
        sheet.setColumnWidth(2, 20 * 256)
        sheet.setColumnWidth(3, 20 * 256)
        sheet.setColumnWidth(4, 50 * 256)
        sheet.setColumnWidth(5, 30 * 256)
        sheet.setColumnWidth(6, 25 * 256)
        sheet.setColumnWidth(7, 20 * 256)
        sheet.setColumnWidth(8, 35 * 256)
        sheet.setColumnWidth(9, 15 * 256)
        sheet.setColumnWidth(10, 10 * 256)
        sheet.setColumnWidth(11, 20 * 256)
        sheet.setColumnWidth(12, 10 * 256)
        sheet.setColumnWidth(13, 10 * 256)
        sheet.setColumnWidth(14, 10 * 256)

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("REPORTE EXCEL CONTRATOS")
        row1.setRowStyle(style)

        def fila = 4;

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("N° Contrato")
        rowC1.createCell(1).setCellValue("Fecha Suscripción")
        rowC1.createCell(2).setCellValue("Memo")
        rowC1.createCell(3).setCellValue("Obra")
        rowC1.createCell(4).setCellValue("Nombre de la Obra")
        rowC1.createCell(5).setCellValue("Cantón-Parroquia-Comunidad")
        rowC1.createCell(6).setCellValue("Clase de Obra")
        rowC1.createCell(7).setCellValue("Tipo de Obra")
        rowC1.createCell(8).setCellValue("Contratista")
        rowC1.createCell(9).setCellValue("Monto")
        rowC1.createCell(10).setCellValue("% Anticipo")
        rowC1.createCell(11).setCellValue("Anticipo")
        rowC1.createCell(12).setCellValue("Fecha Inicio")
        rowC1.createCell(13).setCellValue("Fecha Fin")
        rowC1.createCell(14).setCellValue("Plazo")
        rowC1.setRowStyle(style)
        fila++

        res.eachWithIndex {i, j->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(i?.codigo?.toString() ?: '')
            rowF1.createCell(1).setCellValue(i?.fechasu?.format("dd-MM-yyyy")?.toString() ?: '')
            rowF1.createCell(2).setCellValue(i.concurso.toString() ?: '')
            rowF1.createCell(3).setCellValue(i?.obracodigo?.toString() ?: '')
            rowF1.createCell(4).setCellValue(i?.obranombre?.toString() ?: '')
            rowF1.createCell(5).setCellValue(i?.canton?.toString() + " " + i?.parroquia?.toString())
            rowF1.createCell(6).setCellValue(i?.tipoobra?.toString() ?: '')
            rowF1.createCell(7).setCellValue(i?.tipocontrato?.toString() ?: '')
            rowF1.createCell(8).setCellValue(i?.nombrecontra?.toString() ?: '')
            rowF1.createCell(9).setCellValue(i.monto ?: '')
            rowF1.createCell(10).setCellValue(i.porcentaje ?: '')
            rowF1.createCell(11).setCellValue(i.anticipo ?: '')
            rowF1.createCell(12).setCellValue(i?.fechainicio?.format("dd-MM-yyyy")?.toString() ?: '')
            rowF1.createCell(13).setCellValue(i?.fechafin?.format("dd-MM-yyyy")?.toString() ?: '')
            rowF1.createCell(14).setCellValue(i?.plazo ?: '')
            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "contratos.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }

    def reporteExcelContratadas () {

        def cn = dbConnectionService.getConnection()

        params.old = params.criterio
        params.criterio = reportesService.limpiaCriterio(params.criterio)
        def sql2 = armaSqlContratadas(params)
        def nuevoRes = cn.rows(sql2)
        params.criterio = params.old

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle()
        XSSFFont font = wb.createFont()
        font.setBold(true)
        style.setFont(font)

        Sheet sheet = wb.createSheet("Contratadas")
        sheet.setColumnWidth(0, 20 * 256)
        sheet.setColumnWidth(1, 50 * 256)
        sheet.setColumnWidth(2, 30 * 256)
        sheet.setColumnWidth(3, 35 * 256)
        sheet.setColumnWidth(4, 15 * 256)
        sheet.setColumnWidth(5, 15 * 256)
        sheet.setColumnWidth(6, 35 * 256)
        sheet.setColumnWidth(7, 20 * 256)

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("REPORTE EXCEL OBRAS CONTRATADAS")
        row1.setRowStyle(style)

        def fila = 4

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("Código")
        rowC1.createCell(1).setCellValue("Nombre")
        rowC1.createCell(2).setCellValue("Tipo")
        rowC1.createCell(3).setCellValue("Cantón-Parroquia-Comunidad")
        rowC1.createCell(4).setCellValue("Valor")
        rowC1.createCell(5).setCellValue("Fecha Contrato")
        rowC1.createCell(6).setCellValue("Coordinación")
        rowC1.createCell(7).setCellValue("Contrato")
        rowC1.setRowStyle(style)
        fila++

        nuevoRes.eachWithIndex {i, j->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(i.obracdgo.toString() ?: '')
            rowF1.createCell(1).setCellValue(i?.obranmbr?.toString() ?: '')
            rowF1.createCell(2).setCellValue(i?.tpobdscr?.toString() ?: '')
            rowF1.createCell(3).setCellValue(i?.cntnnmbr?.toString() + " " + i?.parrnmbr?.toString() + " " + i?.cmndnmbr?.toString())
            rowF1.createCell(4).setCellValue(i.cntrmnto ?: '')
            rowF1.createCell(5).setCellValue(i?.obrafcha?.format("dd-MM-yyyy")?.toString() ?: '')
            rowF1.createCell(6).setCellValue(i?.dptodscr?.toString() ?: '')
            rowF1.createCell(7).setCellValue(i.cntrcdgo?.toString() ?: '')
            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "obrasContratadas.xlsx"
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header)
        wb.write(output)
    }

    def armaSqlContratadas(params){
        def campos = reportesService.obrasContratadas()
        def operador = reportesService.operadores()

        def sqlSelect = "select obra.obra__id, obracdgo, obranmbr, tpobdscr, obrafcha, cntnnmbr, parrnmbr, cmndnmbr, " +
                "cntrmnto, dptodscr, cntrcdgo " +
                "from obra, tpob, cntn, parr, cmnd, cncr, ofrt, cntr, dpto "
        def sqlWhere = "where tpob.tpob__id = obra.tpob__id and cmnd.cmnd__id = obra.cmnd__id and " +
                "parr.parr__id = obra.parr__id and cntn.cntn__id = parr.cntn__id  and " +
                "cncr.obra__id = obra.obra__id and ofrt.cncr__id = cncr.cncr__id and " +
                "cntr.ofrt__id = ofrt.ofrt__id and dpto.dpto__id = obra.dpto__id "

        def sqlOrder = "order by obracdgo"

        params.nombre = "Código"
        if(campos.find {it.campo == params.buscador}?.size() > 0) {
            def op = operador.find {it.valor == params.operador}
            sqlWhere += " and ${params.buscador} ${op.operador} ${op.strInicio}${params.criterio}${op.strFin}";
        }

        "$sqlSelect $sqlWhere $sqlOrder".toString()
    }


    def reporteExcelProcesosContratacion () {

        def cn = dbConnectionService.getConnection()

        def campos = ['cncrcdgo', 'cncrobjt', 'obranmbr', 'cncrnmct']
        def sql = "select cncrcdgo, cncrobjt, obracdgo, obranmbr, cncrprrf, cncretdo, cncrnmct, cncrfcad " +
                "from cncr, obra where obra.obra__id = cncr.obra__id and " +
                "${campos[params.buscador.toInteger()]} ilike '%${params.criterio}%' " +
                "order by cncr__id desc"
        def obras = cn.rows(sql)

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle()
        XSSFFont font = wb.createFont()
        font.setBold(true)
        style.setFont(font)

        Sheet sheet = wb.createSheet("Procesos")
        sheet.setColumnWidth(0, 20 * 256)
        sheet.setColumnWidth(1, 15 * 256)
        sheet.setColumnWidth(2, 50 * 256)
        sheet.setColumnWidth(3, 50 * 256)
        sheet.setColumnWidth(4, 15 * 256)
        sheet.setColumnWidth(5, 10 * 256)
        sheet.setColumnWidth(6, 10 * 256)
        sheet.setColumnWidth(7, 10 * 256)

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("REPORTE EXCEL DE PROCESOS DE CONTRATACIÓN")
        row1.setRowStyle(style)

        def fila = 4

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("Código")
        rowC1.createCell(1).setCellValue("Fecha de Adjudicación")
        rowC1.createCell(2).setCellValue("Objeto")
        rowC1.createCell(3).setCellValue("Obra")
        rowC1.createCell(4).setCellValue("Código Obra")
        rowC1.createCell(5).setCellValue("Monto")
        rowC1.createCell(6).setCellValue("Estado")
        rowC1.createCell(7).setCellValue("Certificación Presupuestaria")
        rowC1.setRowStyle(style)
        fila++

        obras.eachWithIndex {i, j->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(i.cncrcdgo.toString() ?: '')
            rowF1.createCell(1).setCellValue(i?.cncrfcad?.format("dd-MM-yyyy")?.toString() ?: '')
            rowF1.createCell(2).setCellValue(i?.cncrobjt?.toString() ?: '')
            rowF1.createCell(3).setCellValue(i?.obranmbr?.toString() ?: '')
            rowF1.createCell(4).setCellValue(i?.obracdgo?.toString() ?: '')
            rowF1.createCell(5).setCellValue(i.cncrprrf ?: '')
            rowF1.createCell(6).setCellValue(i?.cncretdo?.toString() ?: '')
            rowF1.createCell(7).setCellValue(i?.cncrnmct?.toString() ?: '')
            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "procesosContratacion.xlsx"
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header)
        wb.write(output)
    }

    def reporteExcelPresupuestadas () {

        def cn = dbConnectionService.getConnection()
        def campos = reportesService.obrasPresupuestadas()

        params.old = params.criterio
        params.criterio = reportesService.limpiaCriterio(params.criterio)

        def sql = armaSqlPresupuestadas(params)
        def obras = cn.rows(sql)

        params.criterio = params.old

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle()
        XSSFFont font = wb.createFont()
        font.setBold(true)
        style.setFont(font)

        Sheet sheet = wb.createSheet("Presupuestadas")
        sheet.setColumnWidth(0, 20 * 256)
        sheet.setColumnWidth(1, 60 * 256)
        sheet.setColumnWidth(2, 30 * 256)
        sheet.setColumnWidth(3, 10 * 256)
        sheet.setColumnWidth(4, 35 * 256)
        sheet.setColumnWidth(5, 15 * 256)
        sheet.setColumnWidth(6, 30 * 256)
        sheet.setColumnWidth(7, 30 * 256)
        sheet.setColumnWidth(8, 10 * 256)

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("REPORTE EXCEL DE OBRAS PRESUPUESTADAS")
        row1.setRowStyle(style)

        def fila = 4

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("Código")
        rowC1.createCell(1).setCellValue("Nombre")
        rowC1.createCell(2).setCellValue("Tipo")
        rowC1.createCell(3).setCellValue("Fecha Reg.")
        rowC1.createCell(4).setCellValue("Cantón-Parroquia-Comunidad")
        rowC1.createCell(5).setCellValue("Valor")
        rowC1.createCell(6).setCellValue("Requirente")
        rowC1.createCell(7).setCellValue("Doc. Referencia")
        rowC1.createCell(8).setCellValue("Estado")
        rowC1.setRowStyle(style)
        fila++

        obras.eachWithIndex {i, j->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(i.obracdgo.toString() ?: '')
            rowF1.createCell(1).setCellValue(i.obranmbr.toString() ?: '')
            rowF1.createCell(2).setCellValue(i?.tpobdscr?.toString() ?: '')
            rowF1.createCell(3).setCellValue(i?.obrafcha?.format("dd-MM-yyyy")?.toString() ?: '')
            rowF1.createCell(4).setCellValue(i?.cntnnmbr?.toString() + " " + i?.parrnmbr?.toString() + " " + i?.cmndnmbr?.toString())
            rowF1.createCell(5).setCellValue(i.obravlor ?: '')
            rowF1.createCell(6).setCellValue(i?.dptodscr?.toString() ?: '')
            rowF1.createCell(7).setCellValue(i?.obrarefe?.toString() ?: '')
            rowF1.createCell(8).setCellValue(i.estado.toString() ?: '')
            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "obrasPresupuestadas.xlsx"
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header)
        wb.write(output)
    }

    def armaSqlPresupuestadas(params){
        def campos = reportesService.obrasPresupuestadas()
        def operador = reportesService.operadores()

        def sqlSelect = "select obra.obra__id, obracdgo, obranmbr, tpobdscr, obrafcha, cntnnmbr, parrnmbr, cmndnmbr, " +
                "dptodscr, obrarefe, obravlor, case when obraetdo = 'R' THEN 'Registrada' end estado " +
                "from obra, tpob, cntn, parr, cmnd, dpto "
        def sqlWhere = "where tpob.tpob__id = obra.tpob__id and cmnd.cmnd__id = obra.cmnd__id and " +
                "parr.parr__id = obra.parr__id and cntn.cntn__id = parr.cntn__id  and " +
                "dpto.dpto__id = obra.dpto__id and obraetdo = 'R'"

        def sqlOrder = "order by obracdgo"

        params.nombre = "Código"
        if(campos.find {it.campo == params.buscador}?.size() > 0) {
            def op = operador.find {it.valor == params.operador}
            sqlWhere += " and ${params.buscador} ${op.operador} ${op.strInicio}${params.criterio}${op.strFin}";
        }
        "$sqlSelect $sqlWhere $sqlOrder".toString()
    }

    def reporteRegistradasExcel () {

        def cn = dbConnectionService.getConnection()
        def campos = reportesService.obrasPresupuestadas()

        params.old = params.criterio
        params.criterio = reportesService.limpiaCriterio(params.criterio)

        def sql = armaSqlRegistradas(params)
        def obras = cn.rows(sql)

        params.criterio = params.old

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle()
        XSSFFont font = wb.createFont()
        font.setBold(true)
        style.setFont(font)

        Sheet sheet = wb.createSheet("Presupuestadas")
        sheet.setColumnWidth(0, 20 * 256)
        sheet.setColumnWidth(1, 60 * 256)
        sheet.setColumnWidth(2, 30 * 256)
        sheet.setColumnWidth(3, 10 * 256)
        sheet.setColumnWidth(4, 35 * 256)
        sheet.setColumnWidth(5, 15 * 256)
        sheet.setColumnWidth(6, 30 * 256)
        sheet.setColumnWidth(7, 30 * 256)
        sheet.setColumnWidth(8, 10 * 256)

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("REPORTE EXCEL DE OBRAS INGRESADAS")
        row1.setRowStyle(style)

        def fila = 4

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("Código")
        rowC1.createCell(1).setCellValue("Nombre")
        rowC1.createCell(2).setCellValue("Tipo")
        rowC1.createCell(3).setCellValue("Fecha Reg.")
        rowC1.createCell(4).setCellValue("Cantón-Parroquia-Comunidad")
        rowC1.createCell(5).setCellValue("Valor")
        rowC1.createCell(6).setCellValue("Requirente")
        rowC1.createCell(7).setCellValue("Doc. Referencia")
        rowC1.createCell(8).setCellValue("Estado")
        rowC1.setRowStyle(style)
        fila++

        obras.eachWithIndex {i, j->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue(i.obracdgo.toString() ?: '')
            rowF1.createCell(1).setCellValue(i.obranmbr.toString() ?: '')
            rowF1.createCell(2).setCellValue(i?.tpobdscr?.toString() ?: '')
            rowF1.createCell(3).setCellValue(i?.obrafcha?.format("dd-MM-yyyy")?.toString() ?: '')
            rowF1.createCell(4).setCellValue(i?.cntnnmbr?.toString() + " " + i?.parrnmbr?.toString() + " " + i?.cmndnmbr?.toString())
            rowF1.createCell(5).setCellValue(i.obravlor ?: '')
            rowF1.createCell(6).setCellValue(i?.dptodscr?.toString() ?: '')
            rowF1.createCell(7).setCellValue(i?.obrarefe?.toString() ?: '')
            rowF1.createCell(8).setCellValue(i.estado.toString() ?: '')
            fila++
        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "obrasIngresadas.xlsx"
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header)
        wb.write(output)

    }

    def armaSqlRegistradas(params){
        def campos = reportesService.obrasPresupuestadas()
        def operador = reportesService.operadores()

        def sqlSelect = "select obra.obra__id, obracdgo, obranmbr, tpobdscr, obrafcha, cntnnmbr, parrnmbr, cmndnmbr, " +
                "dptodscr, obrarefe, obravlor, case when obraetdo = 'N' THEN 'No registrada' end estado " +
                "from obra, tpob, cntn, parr, cmnd, dpto "
        def sqlWhere = "where tpob.tpob__id = obra.tpob__id and cmnd.cmnd__id = obra.cmnd__id and " +
                "parr.parr__id = obra.parr__id and cntn.cntn__id = parr.cntn__id  and " +
                "dpto.dpto__id = obra.dpto__id and obraetdo = 'N'"

        def sqlOrder = "order by obracdgo"

        println "llega params: $params"
        params.nombre = "Código"
        if(campos.find {it.campo == params.buscador}?.size() > 0) {
            def op = operador.find {it.valor == params.operador}
            sqlWhere += " and ${params.buscador} ${op.operador} ${op.strInicio}${params.criterio}${op.strFin}";
        }

        "$sqlSelect $sqlWhere $sqlOrder".toString()
    }

    def pacExcel() {

        def pac
        def dep
        def anio
        if (!params.todos) {
            anio = janus.pac.Anio.get(params.anio)
            if (params.dpto) {
                dep = Departamento.get(params.dpto)
                pac = janus.pac.Pac.findAllByDepartamentoAndAnio(dep, anio, [sort: "id"])
                dep = dep.descripcion
                anio = anio.anio
            } else {
                pac = janus.pac.Pac.findAllByAnio(janus.pac.Anio.get(params.anio), [sort: "id"])
                dep = "Todos"
                anio = anio.anio
            }
        } else {
            dep = "Todos"
            anio = "Todos"
            pac = janus.pac.Pac.list([sort: "id"])
        }

        XSSFWorkbook wb = new XSSFWorkbook()
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        style.setFont(font);

        Sheet sheet = wb.createSheet("PAC")
        sheet.setColumnWidth(0, 5 * 256);
        sheet.setColumnWidth(1, 8 * 256);
        sheet.setColumnWidth(2, 40 * 256);
        sheet.setColumnWidth(3, 10 * 256);
        sheet.setColumnWidth(4, 15 * 256);
        sheet.setColumnWidth(5, 45 * 256);
        sheet.setColumnWidth(6, 10 * 256);
        sheet.setColumnWidth(7, 10 * 256);
        sheet.setColumnWidth(8, 15 * 256);
        sheet.setColumnWidth(9, 15 * 256);
        sheet.setColumnWidth(10, 10 * 256);
        sheet.setColumnWidth(11, 10 * 256);
        sheet.setColumnWidth(12, 10 * 256);

        Row row = sheet.createRow(0)
        row.createCell(0).setCellValue("")
        Row row0 = sheet.createRow(1)
        row0.createCell(1).setCellValue(Auxiliar.get(1)?.titulo ?: '')
        row0.setRowStyle(style)
        Row row1 = sheet.createRow(2)
        row1.createCell(1).setCellValue("Departamento de compras públicas")
        row1.setRowStyle(style)
        Row row2 = sheet.createRow(3)
        row2.createCell(1).setCellValue("Plan anual de compras")
        row2.setRowStyle(style)
        Row row3 = sheet.createRow(4)
        row3.createCell(1).setCellValue("Departamento: ${dep}")
        row3.setRowStyle(style)
        Row row4 = sheet.createRow(5)
        row4.createCell(1).setCellValue("Año: ${anio}")
        row4.setRowStyle(style)

        def fila = 7

        Row rowC1 = sheet.createRow(fila)
        rowC1.createCell(0).setCellValue("#")
        rowC1.createCell(1).setCellValue("Año")
        rowC1.createCell(2).setCellValue("Partida")
        rowC1.createCell(3).setCellValue("CPP")
        rowC1.createCell(4).setCellValue("Tipo compra")
        rowC1.createCell(5).setCellValue("Descripción")
        rowC1.createCell(6).setCellValue("Cantidad")
        rowC1.createCell(7).setCellValue("Unidad")
        rowC1.createCell(8).setCellValue("Unitario")
        rowC1.createCell(9).setCellValue("Total")
        rowC1.createCell(10).setCellValue("C1")
        rowC1.createCell(11).setCellValue("C2")
        rowC1.createCell(12).setCellValue("C3")
        rowC1.setRowStyle(style)
        fila++

        def total = 0

        pac.eachWithIndex { p, i ->
            Row rowF1 = sheet.createRow(fila)
            rowF1.createCell(0).setCellValue("${i + 1}")
            rowF1.createCell(1).setCellValue(p.anio.anio ?: '')
            rowF1.createCell(2).setCellValue(p.presupuesto.numero ?: '')
            rowF1.createCell(3).setCellValue(p.cpp?.numero ?: '')
            rowF1.createCell(4).setCellValue(p.tipoCompra.descripcion ?: '')
            rowF1.createCell(5).setCellValue( p.descripcion ?: '')
            rowF1.createCell(6).setCellValue(p.cantidad ?: 0)
            rowF1.createCell(7).setCellValue(p.unidad.codigo ?: '')
            rowF1.createCell(8).setCellValue(p.costo ?: 0)
            rowF1.createCell(9).setCellValue(p.cantidad * p.costo ?: 0)
            rowF1.createCell(10).setCellValue(p.c1 ?: '')
            rowF1.createCell(11).setCellValue(p.c2 ?: '')
            rowF1.createCell(12).setCellValue(p.c3 ?: '')
            total += p.cantidad * p.costo
            fila++
        }

        Row rowT = sheet.createRow(fila)
        rowT.createCell(8).setCellValue("TOTAL")
        rowT.createCell(9).setCellValue(total)
        rowT.setRowStyle(style)
        fila++

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "pac.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }


}