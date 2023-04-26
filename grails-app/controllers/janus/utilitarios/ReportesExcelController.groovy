package janus.utilitarios

import janus.Auxiliar
import janus.Item
import janus.Obra
import org.apache.poi.ss.usermodel.Row
import org.apache.poi.ss.usermodel.Sheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook

class ReportesExcelController {


    def dbConnectionService

    def pppppp() {
//        def cn = dbConnectionService.getConnection()
//        def cn1 = dbConnectionService.getConnection()
//        def cn2 = dbConnectionService.getConnection()
//        def obra = Obra.get(params.id)
//        def lugar = obra.lugar
//        def fecha = obra.fechaPreciosRubros
//        def itemsChofer = [obra.chofer]
//        def itemsVolquete = [obra.volquete]
//        def indi = obra.totales
//        WorkbookSettings workbookSettings = new WorkbookSettings()
//        workbookSettings.locale = Locale.default
//        def file = File.createTempFile('matrizFP' + obra.codigo, '.xlsx')
//        file.deleteOnExit()
//        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
//
//        WritableFont times10Font = new WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false);
//        WritableCellFormat times10format = new WritableCellFormat(times10Font);
//        WritableFont times10Normal = new WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false);
//        WritableCellFormat times10formatNormal = new WritableCellFormat(times10Normal);
//
//        WritableFont times08font = new WritableFont(WritableFont.TIMES, 8, WritableFont.NO_BOLD, false);
//        WritableCellFormat times08format = new WritableCellFormat(times08font);

//        def fila = 12

//        WritableSheet sheet = workbook.createSheet("PAC", 0)

//        sheet.setColumnView(0, 8)
//        sheet.setColumnView(1, 12)
//        sheet.setColumnView(2, 50)
//        sheet.setColumnView(3, 8)
//        sheet.setColumnView(4, 12)
//        sheet.setColumnView(5, 15)
//        sheet.setColumnView(6, 15)
//        sheet.setColumnView(7, 15)
//        sheet.setColumnView(8, 15)
//        sheet.setColumnView(9, 15)
//        sheet.setColumnView(10, 15)
//        sheet.setColumnView(11, 15)
//        sheet.setColumnView(12, 15)  // el resto por defecto..

//        def label = new Label(2, 1, (Auxiliar.get(1)?.titulo ?: '').toUpperCase(), times10format); sheet.addCell(label);

//        label = new Label(2, 2, "${obra?.departamento?.direccion?.nombre}", times10format); sheet.addCell(label);
//        label = new Label(2, 3, "Matriz de la Fórmula Polinómica", times10format); sheet.addCell(label);
//        label = new Label(2, 4, "", times10format); sheet.addCell(label);
//        label = new Label(2, 5, "Obra: ${obra.nombre}", times10format); sheet.addCell(label);
//        label = new Label(2, 6, "Código: ${obra.codigo}", times10format); sheet.addCell(label);
//        label = new Label(2, 7, "Memo Cant. Obra: ${obra.memoCantidadObra}", times10format); sheet.addCell(label);
//        label = new Label(2, 8, "Doc. Referencia: ${obra.oficioIngreso}", times10format); sheet.addCell(label);
//        label = new Label(2, 9, "Fecha: ${printFecha(obra?.fechaCreacionObra)}", times10format); sheet.addCell(label);
//        label = new Label(2, 10, "Fecha Act. Precios: ${printFecha(obra?.fechaPreciosRubros)}", times10format);
//        sheet.addCell(label);

        // crea columnas

//        def sql = "SELECT clmncdgo,clmndscr,clmntipo from mfcl where obra__id = ${obra.id} order by  1"
//        def subSql = ""
//        def sqlVl = ""
//        def clmn = 0
//        def col = ""
//        cn.eachRow(sql.toString()) { r ->
//            col = r[1]
//            if (r[2] != "R") {
//                def parts = r[1].split("_")
//                try {
//                    col = Item.get(parts[0].toLong()).nombre
//                } catch (e) {
//                    println "error: " + e
//                    col = parts[0]
//                }
//                col += " " + parts[1]?.replaceAll("T", " Total")?.replaceAll("U", " Unitario")
//            }
//            label = new Label(clmn++, fila, "${col}", times10formatNormal); sheet.addCell(label);
//        }
//        fila++




//        def sqlRb = "SELECT orden, codigo, rubro, unidad, cantidad from mfrb where obra__id = ${obra.id} order by orden"
//        def number
//        cn.eachRow(sqlRb.toString()) { r ->
//            4.times {
//                label = new Label(it, fila, r[it]?.toString() ?: "", times08format); sheet.addCell(label);
//            }
//            number = new Number(4, fila, r.cantidad?.toDouble()?.round(3) ?: 0, times08format); sheet.addCell(number);
//            fila++
//        }
//
//        fila = 13
//        clmn = 5
//
//        sql = "SELECT clmncdgo, clmntipo from mfcl where obra__id = ${obra.id} order by  1"
//        cn.eachRow(sqlRb.toString()) { rb ->
//            cn1.eachRow(sql.toString()) { r ->
//                if (r.clmntipo != "R") {
//                    subSql = "select valor from mfvl where clmncdgo = ${r.clmncdgo} and codigo='${rb.codigo.trim()}' and " +
//                            "obra__id = ${obra.id}"
//                    cn2.eachRow(subSql.toString()) { v ->
//                        number = new Number(clmn++, fila, v.valor?.toDouble()?.round(5) ?: 0.00000, times08format); sheet.addCell(number);
//                    }
//                }
//            }
//            clmn = 5
//            fila++
//        }
//
//        workbook.write();
//        workbook.close();
//        def output = response.getOutputStream()
//        def header = "attachment; filename=" + "matriz.xlsx";
//        response.setContentType("application/octet-stream")
//        response.setHeader("Content-Disposition", header);
//        output.write(file.getBytes());
    }

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
//        cn.eachRow(sqlRb.toString()) { r ->
//            Row row2 = sheet.createRow(columna1 + 14)
//            4.times {
//                row2.createCell(it).setCellValue(r[it].toString() ?: "")
//            }
//            row2.createCell(4).setCellValue(r?.cantidad?.toDouble()?.round(3) ?: 0)
//            columna1++
//        }

//        sql = "SELECT clmncdgo, clmntipo from mfcl where obra__id = ${obra.id} order by  1"
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

//        def contabilidad = Contabilidad.get(params.cont.toDouble())
//        def cuentas = Cuenta.findAllByEmpresa(empresa, [sort: "numero"])

//        CuentaContable.findAllByContabilidad(contabilidad).each { cc ->
//            if (cuentas.contains(cc.antiguo)) {
//                cuentas.remove(cc.antiguo)
//            }
//        }

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
}
