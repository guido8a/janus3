package seguridad

import groovy.json.JsonSlurper
import janus.Parametros
import java.security.MessageDigest

class LoginController {

    def mail

    def dbConnectionService

    def index() {
        redirect(controller: 'login', action: 'login')
    }

    private int borrarAlertas() {
//        def esTriangulo = session.usuario.esTriangulo()
        def fecha = new Date() - 3

        def fechaStr = fecha.format("yyyy-MM-dd")

        def sqlDeleteRecibidos = ""
        def sqlDeleteAntiguos = ""

        def cn = dbConnectionService.getConnection()
        cn.execute(sqlDeleteRecibidos.toString())
        cn.execute(sqlDeleteAntiguos.toString())
        cn.close()

//        return Alerta.withCriteria {
//            if (esTriangulo) {
//                eq("departamento", session.departamento)
//            } else {
//                eq("persona", session.usuario)
//            }
//            isNull("fechaRecibido")
//        }.size()

        0  //retorna zona de alertas

    }

    def conecta(user, pass) {

        def prmt = Parametros.findAll()[0]

        def connect = true
        try {
            /**conecta al servicio */
//            conectaRest('gochoa', 'GADPP/*1406')
            conectaRest()
            println "ingresa..${user.login}"

        } catch (e) {
            println "no conecta ${user.login} error: " + e
            connect = false
        }
        return connect
    }

    def cambiarPass() {
        def usu = Persona.get(session.usuario.id)
        return [usu: usu]
    }

    def validarPass() {
//        println params
        render "No puede ingresar este valor"
    }

    def guardarPass() {
        def usu = Persona.get(params.id)
        usu.password = params.pass.toString().encodeAsMD5()
        usu.fechaCambioPass = new Date() + 30
        if (!usu.save(flush: true)) {
            println "Error: guardarPass " + usu.errors
            flash.message = "Ha ocurrido un error al guardar su nuevo password"
            flash.tipo = "error"
            redirect(action: 'cambiarPass')
        } else {
//            redirect(controller: "inicio", action: "index")
            redirect(controller: "provincia", action: "mapa", id: 1)
        }
    }

    def validarSesion() {
        println "sesion creada el:" + new Date(session.getCreationTime()) + " hora actual: " + new Date()
        println "último acceso:" + new Date(session.getLastAccessedTime()) + " hora actual: " + new Date()

        println session.usuario
        if (session.usuario) {
            render "OK"
        } else {
            flash.message = "Su sesión ha caducado, por favor ingrese nuevamente."
            render "NO"
        }
    }

    def olvidoPass() {
        def mail = params.email
        def personas = Persona.findAllByMail(mail)
        def msg
        if (personas.size() == 0) {
            flash.message = "No se encontró un usuario con ese email"
        } else if (personas.size() > 1) {
            flash.message = "Ha ocurrido un error grave (n)"
        } else {
            def persona = personas[0]

            def random = new Random()
            def chars = []
            ['A'..'Z', 'a'..'z', '0'..'9', ('!@$%^&*' as String[]).toList()].each { chars += it }
            def newPass = (1..8).collect { chars[random.nextInt(chars.size())] }.join()

            persona.password = newPass.encodeAsMD5()
            if (persona.save(flush: true)) {
                sendMail {
                    to mail
                    subject "Recuperación de contraseña"
                    body 'Hola ' + persona.login + ", tu nueva contraseña es " + newPass + "."
                }
                msg = "OK*Se ha enviado un email a la dirección " + mail + " con una nueva contraseña."
            } else {
                msg = "NO*Ha ocurrido un error al crear la nueva contraseña. Por favor vuelva a intentar."
            }
        }
        redirect(action: 'login')
    }


    def conectaRest(usro, pass) {
//    def conectaRest() {
//        def url = "https://serviciospruebas.pichincha.gob.ec/servicios/api/directorioactivo/autenticar/uid/${usro}"
        def url = "https://servicios.pichincha.gob.ec/servicios/api/directorioactivo/autenticar/uid/${usro}"
//        def usro = "gochoa"
        def random = 'janus'
        def fecha = new Date()
        def fcha = fecha.format("yyy-MM-dd") + "T" + fecha.format("HH:mm:ss") + "-05:00"
//        def privKey = '808a068b96222be6'
        def privKey = '59e423e9214a1250'
        def random64 = Base64.getEncoder().encodeToString(random.getBytes())
//        def clave = Base64.getEncoder().encodeToString('GADPP/*1406'.getBytes())
        def clave = Base64.getEncoder().encodeToString(pass.toString().getBytes())
        println "usuario: $usro, pass: $pass"
        println "rand: $random64, clave: $clave"
        def passp = random + fcha + privKey
        MessageDigest ms_sha1 = MessageDigest.getInstance("SHA1")

        byte[] digest = ms_sha1.digest(passp.getBytes())
        def key = digest.encodeBase64()
        println "key: ${digest.encodeBase64()}"

        def post = new URL(url).openConnection();
//        def message = "{'identidadWs':  {" +
//                "'login': '1a93363a83f2a5cfb8ae115d874be5cb'," +
//                "'currentTime': '${fcha}'," +
//                "'random': 'amFudXM='," +
//                "'key': '${key}'," +
//                "'user': '${usro}'," +
//                "'moduleCode': 'SEP-P01'}," +
//                "'clave': '${clave}'}"
        def message = "{'identidadWs':  {" +
                "'login': '5bdd9a6170161bd492e9eb4c153dce0e'," +
                "'currentTime': '${fcha}'," +
                "'random': 'amFudXM='," +
                "'key': '${key}'," +
                "'user': '${usro}'," +
                "'moduleCode': 'SEP-P01'}," +
                "'clave': '${clave}'}"
        def conecta = false

        message = message.replace("'", '"')
        println "json: $message"
        try {
            post.setRequestMethod("POST")
            post.setDoOutput(true)
            post.setRequestProperty("Content-Type", "application/json")
            post.getOutputStream().write(message.getBytes("UTF-8"));
            def postRC = post.getResponseCode();

            println "responde: ${postRC}"
            println "responde2: ${post.getResponseMessage()}"

            def jsonSlurper = new JsonSlurper()
            if (postRC.equals(200)) {
                def texto = post.getInputStream().getText()
                println(texto);
                def retorna = jsonSlurper.parseText(texto)
                println "autorizado: ${retorna.autorizado}"
                conecta = retorna.autorizado
            }
        } catch (e) {
            println "no conecta ${usro} error: " + e
        }

        return conecta
//        render("ok")
    }


    def login() {
//        def usro = session.usuario
//        def cn = "inicio"
//        def an = "index"
//        if (usro) {
//            redirect(controller: cn, action: an)
//        }
        def empr = Parametros.get(1)
        [empr: empr]
    }

    def validar() {
        println "valida " + params
        def usaServicio = Parametros.get(1).servicio == 'S'
        def user = Persona.withCriteria {
            eq("login", params.login, [ignoreCase: true])
            eq("activo", 1)
        }
        println "usuario: ${user.nombre} pass: ${user.password}"

        if (user.size() == 0) {
            flash.message = "No se ha encontrado el usuario"
            flash.tipo = "error"
        } else if (user.size() > 1) {
            flash.message = "Ha ocurrido un error grave"
            flash.tipo = "error"
        } else {
            user = user[0]

            println "está activo " + user.estaActivo

            if (!user.estaActivo) {
                flash.message = "El usuario ingresado no esta activo."
                flash.tipo = "error"
                redirect(controller: 'login', action: "login")
                return
            } else {
                session.usuario = user
//                session.usuarioKerberos = user.login
                session.time = new Date()
//                session.unidad = user.unidadEjecutora

//                println "pone valores " + session.usuario

                def perf = Sesn.findAllByUsuario(user)
                println "perfiles: $perf"
                def perfiles = []
                perf.each { p ->
                    println "añade a perfiles $p activo:${p.estaActivo}"
                    if (p.estaActivo) {
                        perfiles.add(p)
                    }
                }

                if (perfiles.size() == 0) {
                    flash.message = "No puede ingresar porque no tiene ningun perfil asignado a su usuario. Comuníquese con el administrador."
                    flash.tipo = "error"
                    flash.icon = "icon-warning"
                    session.usuario = null
                } else {

//                    println "el md5 del pass: ${params.pass} es ${params.pass.encodeAsMD5()} contraseña: ${user.password}"
//                    if (params.pass.encodeAsMD5() != user.password) {
//                            flash.message = "Contraseña incorrecta"
//                            flash.tipo = "error"
//                            flash.icon = "icon-warning"
//                            session.usuario = null
//                            session.departamento = null
//                            redirect(controller: 'login', action: "login")
//                            return
//                    }

                    // registra sesion activa ------------------------------
                    //                println  "sesion ingreso: $session.id  desde ip: ${request.getRemoteAddr()}"  //activo
                    def activo = new SesionActiva()
                    activo.idSesion = session.id
                    activo.fechaInicio = new Date()
                    activo.activo = 'S'
                    activo.dirIP = request.getRemoteAddr()
                    activo.login = user.login
                    activo.save()
                    // pone X en las no .... cerradas del mismo login e ip
                    def abiertas = SesionActiva.findAllByLoginAndDirIPAndFechaFinIsNullAndIdSesionNotEqual(session.usuario.login,
                            request.getRemoteAddr(), session.id)
                    if (abiertas.size() > 0) {
                        abiertas.each { sa ->
                            sa.fechaFin = new Date()
                            sa.activo = 'X'
                            sa.save()
                        }
                    }
                    // ------------------fin de sesion activa --------------

                    println "****dpto --> ${user.departamento.id}"
                    println "****usaServicio: $usaServicio es oferente --> ${user.departamento.id == 13}"
                    if ((user.departamento.id == 13)){
                        if (params.pass.encodeAsMD5() != user.password) {
                            flash.message = "Contraseña incorrecta"
                            flash.tipo = "error"
                            flash.icon = "icon-warning"
                            session.usuario = null
                            session.departamento = null
                            redirect(controller: 'login', action: "login")
                            return
                        }
                    } else if (usaServicio) {
                        println "*** si usa servicio"
                        if (!conectaRest(params.login, params.pass)) {
                            flash.message = "No se pudo validar la información ingresada con el servicio web, " +
                                    "contraseña incorrecta o usuario no registrado"
                            flash.tipo = "error"
                            flash.icon = "icon-warning"
                            session.usuario = null
                            session.departamento = null
                            redirect(controller: 'login', action: "login")
                            return
                        }

                        println "ingresa..${user.login} ${new Date().format('dd HH:mm')}"
                    }  else {
                        println "*** no usa servicio"
                        if (params.pass.encodeAsMD5() != user.password) {
                            flash.message = "Contraseña incorrecta"
                            flash.tipo = "error"
                            flash.icon = "icon-warning"
                            session.usuario = null
                            session.departamento = null
                            redirect(controller: 'login', action: "login")
                            return
                        }
                    }


                    if (perfiles.size() == 1) {
                        session.usuario.vaciarPermisos()
                        session.perfil = perfiles.first().perfil
                        cargarPermisos()

                        def permisos = Prpf.findAllByPerfil(session.perfil)
                        permisos.each {
                            def perm = PermisoUsuario.findAllByPersonaAndPermisoTramite(session.usuario, it.permiso)
                            perm.each { pr ->
                                if (pr.estaActivo) {
                                    session.usuario.permisos.add(pr.permisoTramite)
                                }
                            }
                        }

                        def count = borrarAlertas()
                        if (count > 0) {
                            redirect(controller: 'alertas', action: 'list')
                        } else if (perfiles.first().perfil.descripcion != 'Oferente') {// llama a reporte
                            redirect(controller: 'inicio', action: 'index', id: 1)
                        } else {
                            redirect(controller: 'inicio', action: 'indexOf', id: 1)
                        }

                        return

                    } else {
                        session.usuario.vaciarPermisos()
                        redirect(action: "perfiles")
                        return
                    }
                }
            }
        }
        redirect(controller: 'login', action: "login")
    }

    def perfiles() {
        def usuarioLog = session.usuario
        def perfilesUsr = Sesn.findAllByUsuario(usuarioLog, [sort: 'perfil'])
        def perfiles = []
        perfilesUsr.each { p ->
            if (p.estaActivo) {
                perfiles.add(p)
            }
        }
        println "---- perfiles ----"
        return [perfilesUsr: perfiles.sort { it.perfil.descripcion }]
    }

    def savePer() {
        println("entro save" + params)
        def sesn = Sesn.get(params.prfl)
        def perf = sesn.perfil

        if (perf) {

            def permisos = Prpf.findAllByPerfil(perf)
//            println "perfil "+perf.descripcion+"  "+perf.codigo
            permisos.each {
//                println "perm "+it.permiso+"  "+it.permiso.codigo
                def perm = PermisoUsuario.findAllByPersonaAndPermisoTramite(session.usuario, it.permiso)
//                println "***************************** " + perm
                perm.each { pr ->
//                    println pr.permisoTramite.descripcion + "  fechas " + pr.fechaInicio + "  " + pr.fechaFin + " " + pr.id + " " + pr.estaActivo
                    if (pr.estaActivo) {
                        session.usuario.permisos.add(pr.permisoTramite)
                    }
                }

            }
//            println "permisos " + session.usuario.permisos.id + "  " + session.usuario.permisos
//            println "add " + session.usuario.permisos
//            println "puede recibir " + session.usuario.getPuedeRecibir()
//            println "puede getPuedeVer " + session.usuario.getPuedeVer()
//            println "puede getPuedeAdmin " + session.usuario.getPuedeAdmin()
//            println "puede getPuedeJefe " + session.usuario.getPuedeJefe()
//            println "puede getPuedeDirector " + session.usuario.getPuedeDirector()
//            println "puede getPuedeExternos " + session.usuario.getPuedeExternos()
//            println "puede getPuedeAnular " + session.usuario.getPuedeAnular()
//            println "puede getPuedeTramitar " + session.usuario.getPuedeTramitar()
            session.perfil = perf
            cargarPermisos()
//            if (session.an && session.cn) {
//                if (session.an.toString().contains("ajax")) {
//                    redirect(controller: "inicio", action: "index")
//                } else {
//                    redirect(controller: session.cn, action: session.an, params: session.pr)
//                }
//            } else {
//            def count = 0
//            if (session.usuario.esTriangulo()) {
//                count = Alerta.countByDepartamentoAndFechaRecibidoIsNull(session.departamento)
//            } else {
//                count = Alerta.countByPersonaAndFechaRecibidoIsNull(session.usuario)
//            }

            def count = borrarAlertas()
            if (count > 0) {
                println("entro 1")
                redirect(controller: 'alertas', action: 'list')
            } else {
                println("entro 2")
//                if (session.usuario.getPuedeDirector() || session.usuario.getPuedeJefe()) {
//
//                    redirect(controller: "retrasadosWeb", action: "reporteRetrasadosConsolidadoDir", params: [dpto: Persona.get(session.usuario.id).departamento.id, inicio: "1", dir: "1"])
//                } else {
//                    if (session.usuario.getPuedeJefe()) {
//                        redirect(controller: "retrasadosWeb", action: "reporteRetrasadosConsolidado", params: [dpto: Persona.get(session.usuario.id).departamento.id, inicio: "1"])
//                    } else {
                redirect(controller: "inicio", action: "index")
//                    }

//                }
            }
//            }
        } else {
            redirect(action: "login")
        }
    }

    def logout() {

        // registra fin de sesion activa --------------
        def activo = SesionActiva.findByIdSesion(session.id)
//        println "sesion out: $session.id, activo: $activo"  //activo
        if (activo) {
            activo.fechaFin = new Date()
            activo.activo = 'N'
            activo.save(flush: true)
//            println "grabando... ${activo.fechaFin}"
        }
        // -------------- fin -------------------------

        session.usuario = null
        session.perfil = null
        session.permisos = null
        session.menu = null
        session.an = null
        session.cn = null
        session.invalidate()

        redirect(controller: 'login', action: 'login')
//        redirect uri: '/'

    }

    def finDeSesion() {

    }

    def cargarPermisos() {
        def permisos = Prms.findAllByPerfil(session.perfil)
//        println "CARGAR PERMISOS  perfil: " + session.perfil + "  " + session.perfil.id
//        println "Permisos:    " + permisos
        def hp = [:]
        permisos.each {
//                println(it.accion.accnNombre+ " " + it.accion.control.ctrlNombre)
            if (hp[it.accion.control.ctrlNombre.toLowerCase()]) {
                hp[it.accion.control.ctrlNombre.toLowerCase()].add(it.accion.accnNombre.toLowerCase())
            } else {
                hp.put(it.accion.control.ctrlNombre.toLowerCase(), [it.accion.accnNombre.toLowerCase()])
            }

        }
        session.permisos = hp
//        println "permisos menu " + session.permisos
    }


    def conectaGarantias(cntr) {
        def url = "https://serviciospruebas.pichincha.gob.ec/servicios/api/odoo/garantias/numerocontrato/${cntr}"
//        def url = "https://servicios.pichincha.gob.ec/servicios/api/odoo/garantias/numerocontrato/${cntr}"
        def usro = "gochoa"
        def random = 'janus'
        def fecha = new Date()
        def fcha = fecha.format("yyy-MM-dd") + "T" + fecha.format("HH:mm:ss") + "-05:00"
        def privKey = '808a068b96222be6'
//        def privKey = '59e423e9214a1250'
        def random64 = Base64.getEncoder().encodeToString(random.getBytes())
        def clave = Base64.getEncoder().encodeToString('GADPP/*1406'.getBytes())
        println "rand: $random64, clave: $clave"
        def passp = random + fcha + privKey
        MessageDigest ms_sha1 = MessageDigest.getInstance("SHA1")

        byte[] digest = ms_sha1.digest(passp.getBytes())
        def key = digest.encodeBase64()
        println "key: ${digest.encodeBase64()}"

        def conecta = false
        def retorna = ""
        def post = new URL(url).openConnection();
        def message = "{'identidadWs':  {" +
                "'login': '1a93363a83f2a5cfb8ae115d874be5cb'," +
                "'currentTime': '${fcha}'," +
                "'random': 'amFudXM='," +
                "'key': '${key}'," +
                "'user': '${usro}'," +
                "'moduleCode': 'SEP-P02'}}"
//        def message = "{'identidadWs':  {" +
//                "'login': '5bdd9a6170161bd492e9eb4c153dce0e'," +
//                "'currentTime': '${fcha}'," +
//                "'random': 'amFudXM='," +
//                "'key': '${key}'," +
//                "'user': '${usro}'," +
//                "'moduleCode': 'SEP-P02'}}"

        message = message.replace("'", '"')
        println "$message"
        try {
            post.setRequestMethod("POST")
            post.setDoOutput(true)
            post.setRequestProperty("Content-Type", "application/json")
            post.getOutputStream().write(message.getBytes("UTF-8"));
            def postRC = post.getResponseCode();

            println "responde: ${postRC}"
            println "responde2: ${post.getResponseMessage()}"

            def jsonSlurper = new JsonSlurper()
            if (postRC.equals(200)) {
                def texto = post.getInputStream().getText()
                println(texto.split(',').join('\n'));
                retorna = jsonSlurper.parseText(texto)
                println "Garantías: ${retorna.listaDatoGarantia.size()}"
                println "Garantía última: ${retorna.listaDatoGarantia[-1]}"
                conecta = retorna.autorizado

                render("Existen: ${retorna.listaDatoGarantia.size()} garatías, <br>" +
                        "Garantías: ${retorna.listaDatoGarantia}")
                return
            }
        } catch (e) {
            println "no conecta ${usro} error: " + e
        }

//        return conecta
        render("<hr>Error - No existen datos de garantías del contrato $cntr")

    }

    def llamaGarantias() {
        conectaGarantias("44-DCP-2022")
        conectaGarantias("39-DGCP-2022") //--> Bad Request
    }

}