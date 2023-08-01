package janus



class DescargasController {

    def especificaciones() {
        def nombre = "especificaciones_generales.pdf"
        def path = '/var/janus/manual/' + nombre
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualOferentes() {
        def nombre = "Manual sep-oferentes.pdf"
        def path = '/var/janus/manual/' + nombre
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualIngreso() {
        def nombre = "Ingreso al sistema.pdf"
        def path = '/var/janus/manual/' + nombre
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualAdmnOfrt() {
        def nombre = "Manual oferentes.pdf"
        def path = '/var/janus/manual/' + nombre
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualContratos() {
        def nombre = "Manual contrataciones.pdf"
        def path = '/var/janus/manual/' + nombre
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualObras() {
        def nombre = "Manual obras.pdf"
        def path = '/var/janus/manual/' + nombre
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualFinanciero() {
        def nombre = "Manual financiero.pdf"
        def path = '/var/janus/manual/' + nombre
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualEjec() {
        def nombre = "Manual de ejecución.pdf"
        def path = '/var/janus/manual/' + nombre
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualAPU() {
        def nombre = "Manual APU.pdf"
        def path = '/var/janus/manual/' + nombre
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualRprt() {
        def nombre = "Manual de reportes.pdf"
        def path = '/var/janus/manual/' + nombre
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def manualAdmnDire() {
        def nombre = "Manual administración directa.pdf"
        def path = '/var/janus/manual/' + nombre
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType('pdf')
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


    def materiales() {
        def nombre = "materiales.xlsx"
        def path = '/var/janus/manual/' + nombre
        def file = new File(path)
        def b = file.getBytes()
        response.setContentType("application/excel")
        response.setHeader("Content-disposition", "attachment; filename=" + nombre)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


} //fin controller
