package janus.pac


import jxl.Cell
import jxl.Sheet
import jxl.Workbook
import org.springframework.dao.DataIntegrityViolationException

class CodigoComprasPublicasController {

    def dbConnectionService

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
//        [codigoComprasPublicasInstanceList: CodigoComprasPublicas.list(params), params: params]
    } //list

    def tablaCPC_ajax(){
        println("params " + params)
        def datos;
        def sqlTx = ""
        def listaItems = ['cpacdscr', 'cpacnmro']
        def bsca
        if(params.buscarPor){
            bsca = listaItems[params.buscarPor?.toInteger()-1]
        }else{
            bsca = listaItems[0]
        }

        def select = "select * from cpac"
        def txwh = " where $bsca ilike '%${params.criterio}%'"
        sqlTx = "${select} ${txwh} order by cpacdscr limit 100 ".toString()

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
        [data: datos, tipo: params.tipo]
    }

    def form_ajax() {
        def codigoComprasPublicasInstance = new CodigoComprasPublicas(params)
        if (params.id) {
            codigoComprasPublicasInstance = CodigoComprasPublicas.get(params.id)
            if (!codigoComprasPublicasInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Codigo Compras Publicas con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [codigoComprasPublicasInstance: codigoComprasPublicasInstance]
    } //form_ajax

    def save() {
        def codigoComprasPublicasInstance

        if(params.fecha){
            params.fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        }

        if(params.id){
            codigoComprasPublicasInstance = CodigoComprasPublicas.get(params.id)
        }else{
            codigoComprasPublicasInstance = new CodigoComprasPublicas()
            codigoComprasPublicasInstance.nivel = 9
            codigoComprasPublicasInstance.movimiento = 1
        }

        codigoComprasPublicasInstance.properties = params

        if(!codigoComprasPublicasInstance.save(flush:true)){
            println("Error al guardar el CPC " + codigoComprasPublicasInstance.errors)
            render "no_Error al guardar el CPC"
        }else{
            render "ok_Guardado correctamente"
        }

    } //save

    def show_ajax() {
        def codigoComprasPublicasInstance = CodigoComprasPublicas.get(params.id)
        if (!codigoComprasPublicasInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Codigo Compras Publicas con id " + params.id
            redirect(action: "list")
            return
        }
        [codigoComprasPublicasInstance: codigoComprasPublicasInstance]
    } //show

    def delete() {
        def codigoComprasPublicasInstance = CodigoComprasPublicas.get(params.id)
        if (!codigoComprasPublicasInstance) {
           render "no_No se encontró el registro"
        }

        try {
            codigoComprasPublicasInstance.delete(flush: true)
            render "ok_Borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar el CPC " + codigoComprasPublicasInstance.errors)
            render "no_Error al borrar el registro"
        }
    } //delete



    def cargarCPC () {

    }



    def uploadFile() {
        println("params uf " + params)

        def fecha
        def error = ''

        if (!params.fecha) {
            flash.message = "Ingrese la fecha"
            redirect(action: 'cargarCPC')
        }else{
            fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        }


        def path = "/var/janus/" + "xls/"   //web-app/archivos
        new File(path).mkdirs()

        def f = request.getFile('file')  //archivo = name del input type file


        if (f && !f.empty) {
            def fileName = f.getOriginalFilename() //nombre original del archivo
            def ext

            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                } else {
                    ext = obj
                }
            }



            if (ext == "xls") {

                fileName = "xlsCPC_" + new Date().format("yyyyMMdd_HHmmss")

                def fn = fileName
                fileName = fileName + "." + ext

                def pathFile = path + fileName
                def src = new File(pathFile)

                def i = 1
                while (src.exists()) {
                    pathFile = path + fn + "_" + i + "." + ext
                    src = new File(pathFile)
                    i++
                }

                f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path

                def htmlInfo = "", errores = "", doneHtml = "", done = 0
                def file = new File(pathFile)
                Workbook workbook = Workbook.getWorkbook(file)

                workbook.getNumberOfSheets().times { sheet ->
//                    if (sheet == 0) {
                    Sheet s = workbook.getSheet(sheet)
                    if (!s.getSettings().isHidden()) {
                        println s.getName() + "  " + sheet
                        htmlInfo += "<h2>Hoja " + (sheet + 1) + ": " + s.getName() + "</h2>"
                        errores += "<h2>Hoja " + (sheet + 1) + ": " + s.getName() + "</h2>"
                        Cell[] row = null
                        s.getRows().times { j ->
                            if (j == 0) {
                                errores += "<ol>"
                            }
                            println ">>>>>>>>>>>>>>>" + (j + 1)
                            row = s.getRow(j)
//                            println "row.length: ${row.length}"

                            if(j >= 7){

                                if(row.length == 0){
                                    println("fila no existente")
                                }else{
                                    def codigo = row[0]?.getContents()
                                    def descripcion = row[1]?.getContents()

                                    if(!codigo || !descripcion){
                                        println("en blanco")
                                    }else{
                                        println("cod " + codigo)
                                        println("des " + descripcion)

                                        def bCodigo = CodigoComprasPublicas.findAllByNumero(codigo)
                                        if(bCodigo){
                                            println("codigo existente " + codigo)
                                        }else{
                                            println("codigo NO existente " + codigo)
                                            def nuevo = new CodigoComprasPublicas()
                                            nuevo.numero = codigo
                                            nuevo.descripcion = descripcion
                                            nuevo.fecha = fecha

                                            try{
                                                nuevo.save(flush: true)
                                            }catch(e){
                                                error += e + " - "
                                                println("error al guardar nuevo cpc " + nuevo.errors + " " + e)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                if(error == ''){
                    flash.message = "Registros cargados correctamente"
                    redirect(action: 'cargarCPC')
                }else{
                    flash.message = "Error al cargar los registros"
                    redirect(action: 'cargarCPC')
                }


            }else{
                flash.message = "Seleccione un archivo Excel xls para procesar (archivos xlsx deben ser convertidos a xls primero)"
                redirect(action: 'cargarCPC')
            }

        }

    }


} //fin controller
