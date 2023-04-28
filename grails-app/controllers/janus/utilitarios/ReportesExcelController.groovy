package janus.utilitarios

import janus.Auxiliar
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
            row1.createCell(1).setCellValue("DGCP - COORDINACIÓN DE FIJACIÓN DE PRECIOS UNITARIOS")
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
            row6.createCell(1).setCellValue("Descripción: " + rubro.nombre)
            row6.setRowStyle(style)

            Row rowT1 = sheet.createRow(9)
            rowT1.createCell(0).setCellValue("Equipos")
            rowT1.sheet.addMergedRegion(new CellRangeAddress(9, 9, 0, 2));
            rowT1.setRowStyle(style)

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
            row1.createCell(1).setCellValue("DGCP - COORDINACIÓN DE FIJACIÓN DE PRECIOS UNITARIOS")
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
                        rowC1.createCell(2).setCellValue("Cantidad")
                        rowC1.createCell(3).setCellValue("Tarifa")
                        rowC1.createCell(4).setCellValue("Costo")
                        rowC1.createCell(5).setCellValue("Rendimiento")
                        rowC1.createCell(6).setCellValue("C.Total")
                        rowC1.createCell(7).setCellValue("Peso Relat(%)")
                        rowC1.createCell(8).setCellValue("CPC")
                        rowC1.createCell(9).setCellValue("NP/EP/ND")
                        rowC1.createCell(10).setCellValue("VAE(%)")
                        rowC1.createCell(11).setCellValue("VAE(%) Elemento")
                        rowC1.setRowStyle(style)
                        fila++
                    }
                    band = 0

                    Row rowF1 = sheet.createRow(fila)
                    rowF1.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                    rowF1.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                    rowF1.createCell(2).setCellValue(r["rbrocntd"]?.toDouble())
                    rowF1.createCell(3).setCellValue(r["rbpcpcun"]?.toDouble())
                    rowF1.createCell(4).setCellValue(r["rbpcpcun"] * r["rbrocntd"])
                    rowF1.createCell(5).setCellValue(r["rndm"]?.toDouble())
                    rowF1.createCell(6).setCellValue(r["parcial"]?.toDouble())
                    rowF1.createCell(7).setCellValue(r["relativo"]?.toDouble())
                    rowF1.createCell(8).setCellValue(r.itemcpac?.toDouble())
                    rowF1.createCell(9).setCellValue(r.tpbncdgo)
                    rowF1.createCell(10).setCellValue(r["vae"]?.toDouble())
                    rowF1.createCell(11).setCellValue(r["vae_vlor"]?.toDouble())

                    totalHer += r["parcial"]
                    totalHerRel += r["relativo"]
                    totalHerVae += r["vae_vlor"]
                    fila++
                }

                if (r["grpocdgo"] == 2) {
                    if (band == 0) {
                        Row rowP1 = sheet.createRow(fila)
                        rowP1.createCell(0).setCellValue("SUBTOTAL")
                        rowP1.createCell(6).setCellValue(totalHer)
                        rowP1.createCell(7).setCellValue(totalHer)
                        rowP1.createCell(11).setCellValue(totalHer)
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
                        rowC2.createCell(2).setCellValue("Cantidad")
                        rowC2.createCell(3).setCellValue("Jornal")
                        rowC2.createCell(4).setCellValue("Costo")
                        rowC2.createCell(5).setCellValue("Rendimiento")
                        rowC2.createCell(6).setCellValue("C.Total")
                        rowC2.createCell(7).setCellValue("Peso Relat(%)")
                        rowC2.createCell(8).setCellValue("CPC")
                        rowC2.createCell(9).setCellValue("NP/EP/ND")
                        rowC2.createCell(10).setCellValue("VAE(%)")
                        rowC2.createCell(11).setCellValue("VAE(%) Elemento")
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
                    rowF2.createCell(7).setCellValue(r["relativo"]?.toDouble())
                    rowF2.createCell(8).setCellValue(r.itemcpac?.toDouble())
                    rowF2.createCell(9).setCellValue(r.tpbncdgo)
                    rowF2.createCell(10).setCellValue(r["vae"]?.toDouble())
                    rowF2.createCell(11).setCellValue(r["vae_vlor"]?.toDouble())

                    totalMan += r["parcial"]
                    totalManRel += r["relativo"]
                    totalManVae += r["vae_vlor"]
                    fila++
                }

                if(r["grpocdgo"] != 2){
                    if (band == 2) {
                        Row rowP2 = sheet.createRow(fila)
                        rowP2.createCell(0).setCellValue("SUBTOTAL")
                        rowP2.createCell(6).setCellValue(totalMan)
                        rowP2.createCell(7).setCellValue(totalManRel)
                        rowP2.createCell(11).setCellValue(totalManVae)
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
                        rowC3.createCell(2).setCellValue("Cantidad")
                        rowC3.createCell(3).setCellValue("Unitario")
                        rowC3.createCell(6).setCellValue("C.Total")
                        rowC3.createCell(7).setCellValue("Peso Relat(%)")
                        rowC3.createCell(8).setCellValue("CPC")
                        rowC3.createCell(0).setCellValue("NP/EP/ND")
                        rowC3.createCell(10).setCellValue("VAE(%)")
                        rowC3.createCell(11).setCellValue("VAE(%) Elemento")
                        rowC3.setRowStyle(style)
                        fila++
                    }
                    band = 3
                    flag = 1

                    Row rowF3 = sheet.createRow(fila)
                    rowF3.createCell(0).setCellValue(r["itemcdgo"]?.toString())
                    rowF3.createCell(1).setCellValue(r["itemnmbr"]?.toString())
                    rowF3.createCell(2).setCellValue(r["rbrocntd"]?.toDouble())
                    rowF3.createCell(3).setCellValue(r["rbpcpcun"]?.toDouble())
                    rowF3.createCell(6).setCellValue(r["parcial"]?.toDouble())
                    rowF3.createCell(7).setCellValue(r["relativo"]?.toDouble())
                    rowF3.createCell(8).setCellValue(r.itemcpac?.toDouble())
                    rowF3.createCell(9).setCellValue(r.tpbncdgo)
                    rowF3.createCell(10).setCellValue(r["vae"]?.toDouble())
                    rowF3.createCell(11).setCellValue(r["vae_vlor"]?.toDouble())

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
                rowP21.createCell(6).setCellValue(totalMan)
                rowP21.createCell(7).setCellValue(totalManRel)
                rowP21.createCell(11).setCellValue(totalManVae)
                fila++
            }

            if (band == 3) {
                Row rowP3 = sheet.createRow(fila)
                rowP3.createCell(0).setCellValue("SUBTOTAL")
                rowP3.createCell(6).setCellValue(totalMat)
                rowP3.createCell(7).setCellValue(totalMatRel)
                rowP3.createCell(11).setCellValue(totalMatVae)
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
                rowC4.createCell(2).setCellValue("Peso/Vol")
                rowC4.createCell(3).setCellValue("Cantidad")
                rowC4.createCell(4).setCellValue("Distancia")
                rowC4.createCell(5).setCellValue("Unitario")
                rowC4.createCell(6).setCellValue("C.Total")
                rowC4.createCell(7).setCellValue("Peso Relat(%)")
                rowC4.createCell(8).setCellValue("CPC")
                rowC4.createCell(9).setCellValue("NP/EP/ND")
                rowC4.createCell(10).setCellValue("VAE(%)")
                rowC4.createCell(11).setCellValue("VAE(%) Elemento")
                rowC4.setRowStyle(style)
                fila++

                rowsTrans.eachWithIndex { rt, j ->
                    def tra = rt["parcial_t"]
                    def tot = 0
                    if (tra > 0)
                        tot = rt["parcial_t"] / (rt["itempeso"] * rt["rbrocntd"] * rt["distancia"])

                    Row rowF4 = sheet.createRow(fila)
                    rowF4.createCell(0).setCellValue(rt["itemcdgo"]?.toString())
                    rowF4.createCell(1).setCellValue(rt["itemnmbr"]?.toString())
                    rowF4.createCell(2).setCellValue(rt["itempeso"]?.toDouble())
                    rowF4.createCell(3).setCellValue(rt["rbrocntd"]?.toDouble())
                    rowF4.createCell(4).setCellValue(rt["distancia"]?.toDouble())
                    rowF4.createCell(5).setCellValue(tot)
                    rowF4.createCell(6).setCellValue(rt["parcial_t"]?.toDouble())
                    rowF4.createCell(7).setCellValue(rt["relativo_t"]?.toDouble())
                    rowF4.createCell(8).setCellValue(rt["itemcpac"]?.toDouble())
                    rowF4.createCell(9).setCellValue(rt["tpbncdgo"]?.toString())
                    rowF4.createCell(10).setCellValue(rt["vae_t"]?.toDouble())
                    rowF4.createCell(11).setCellValue(rt["vae_vlor_t"]?.toDouble())
                    fila++
                }
                Row rowP4 = sheet.createRow(fila)
                rowP4.createCell(0).setCellValue("SUBTOTAL")
                rowP4.createCell(6).setCellValue(total)
                rowP4.createCell(7).setCellValue(totalTRel)
                rowP4.createCell(11).setCellValue(totalTVae)
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
            def totalRelativo = totalTRel + totalHerRel + totalMatRel + totalManRel
            def totalVae = totalTVae + totalHerVae + totalMatVae + totalManVae
            def totalIndi = totalRubro * indi / 100
            Row rowF5 = sheet.createRow(fila)
            rowF5.createCell(0).setCellValue("Costos indirectos")
            rowF5.createCell(6).setCellValue(indi)
            rowF5.createCell(7).setCellValue(totalIndi)

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
            rowP9.createCell(4).setCellValue("Precio unitario")
            rowP9.createCell(6).setCellValue((totalRubro + totalIndi).toDouble().round(2))
            rowP9.createCell(7).setCellValue("RELATIVO(%)")
            rowP9.createCell(11).setCellValue("(%)")
            rowP9.setRowStyle(style)

        }

        def output = response.getOutputStream()
        def header = "attachment; filename=" + "rubrosVae.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        wb.write(output)
    }
}
