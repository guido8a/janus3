package seguridad

import audita.Auditable


class Sesn implements Auditable {
    static auditable = true
    Persona usuario
    Prfl perfil
    Date fechaInicio
    Date fechaFin
    Prpf permisoPerfil

    static mapping = {
        table 'sesn'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        sort "perfil"
        columns {
            id column: 'sesn__id'
            permisoPerfil column: 'prpf__id'
            perfil column: 'prfl__id'
            usuario column: 'prsn__id'
            fechaInicio column: 'sesnfcin'
            fechaFin column: 'sesnfcfn'
        }
    }

    static constraints = {
        fechaInicio(blank: true, nullable: true)
        fechaFin(blank: true, nullable: true)
        permisoPerfil(blank:true, nullable: true)
    }

    boolean getEstaActivo() {
        def now = new Date()
        if(fechaInicio == null)
            return false
        else
        if (fechaInicio <= now && fechaFin == null) {
//            println "perfil activo "
            return true
        }
        else {
            if (fechaInicio < now && fechaFin > now)
                return true
            else
                return false
        }

    }

    String toString() {
        return "${this.perfil}"
    }

}
