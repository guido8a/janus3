package seguridad

import audita.Auditable
import janus.Departamento

class Persona implements Auditable{

    Departamento departamento
    String cedula
    String nombre
    String apellido
    Date fechaInicio
    Date fechaFin
    String titulo
    String cargo
    String mail
    String login
    String password
    int activo
    Date fecha
    String telefono
    String sigla
    String autorizacion
    String sexo
    String discapacidad
    String direccion
    String referencia
    String firma
//    String representante = 'N'

    static auditable = true

    static hasMany = [perfiles: Sesn]

    def permisos = []

    static mapping = {
        table 'prsn'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'prsn__id'
            departamento column: 'dpto__id'
            cedula column: 'prsncdla'
            nombre column: 'prsnnmbr'
            apellido column: 'prsnapll'
            fechaInicio column: 'prsnfcin'
            fechaFin column: 'prsnfcfn'
            titulo column: 'prsntitl'
            cargo column: 'prsncrgo'
            mail column: 'prsnmail'
            login column: 'prsnlogn'
            password column: 'prsnpass'
            activo column: 'prsnactv'
            telefono column: 'prsntelf'
            fecha column: 'prsnfcps'
            sigla column: 'prsnsgla'
            autorizacion column: 'prsnatrz'
            sexo column: 'prsnsexo'
            discapacidad column: 'prsndscp'
            direccion column: 'prsndire'
            referencia column: 'prsnrefe'
            firma column: 'prsnfrma'
//            representante column: 'prsnrplg'
        }
    }
    static constraints = {
        departamento(blank: true, nullable: true, attributes: [title: 'departamento'])
        cedula(blank: false, nullable: false)
        nombre(size: 3..31, blank: false)
        apellido(size: 3..31, blank: false)
        fechaInicio(blank: true, nullable: true, attributes: [title: 'Fecha de inicio'])
        fechaFin(blank: true, nullable: true, attributes: [title: 'Fecha de finalización'])
        titulo(size: 0..4, blank: true, nullable: true)
        cargo(blank: true, nullable: true, size: 1..127, attributes: [mensaje: 'Cargo'])
        sexo(inList: ["F", "M"], size: 1..1, blank: false, attributes: ['mensaje': 'Sexo de la persona'])
        mail(size: 3..63, blank: true, nullable: true)
        login(size: 4..15, blank: false, unique: true)
        password(size: 3..63, blank: false, nullable: false)
        fecha(blank: true, nullable: true)
        telefono(size: 0..31, blank: true, nullable: true, attributes: [title: 'teléfono'])
        sigla(size: 0..5, blank: true, nullable: true)
        autorizacion(matches: /^[a-zA-Z0-9ñÑáéíóúÁÉÍÚÓüÜ_-]+$/, blank: true, nullable: true, attributes: [mensaje: 'Contraseña para autorizaciones'])
        activo(blank: false, attributes: [title: 'activo'])
        discapacidad(size: 0..15, blank: true, nullable: true)
        direccion(size: 0..255, blank: true, nullable: true)
        referencia(size: 0..255, blank: true, nullable: true)
        firma(blank: true, nullable: true)
//        representante(blank: true, nullable: true)
    }

    String toString() {
        "${this.id}: ${this.nombre} ${this.apellido}"
    }

    def getEstaActivo() {
        if (this.activo != 1) {
            return false
        }
/*
        def now = new Date()
        println "---> ${this.activo}"
        def accs = Accs.findAllByUsuarioAndAccsFechaFinalGreaterThanEquals(this, now)
        println "accs "+accs?.accsFechaInicial+"  "+accs?.accsFechaFinal
        def res = true
        accs.each {
            if (res) {
                if (it.accsFechaInicial <= now) {
                    res = false
                }
            }
        }
*/
        return true
    }

    def vaciarPermisos() {
        this.permisos = []
    }

    def getNombreCompleto() {
        if(this.titulo) {
            return "${this?.titulo} ${this.nombre} ${this.apellido}"
        } else {
            return "${this.nombre} ${this.apellido}"
        }

    }

}
