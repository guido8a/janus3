<%@ page import="janus.ValoresAnuales" %>


<g:if test="${valoresAnualesInstance?.anioNuevo}">
    <div class="row">
        <div class="col-md-3 text-info">
            Año
        </div>
        <div class="col-md-6">
            ${valoresAnualesInstance?.anioNuevo?.anio}
        </div>
    </div>
</g:if>
<g:if test="${valoresAnualesInstance?.costoDiesel}">
    <div class="row">
        <div class="col-md-3 text-info">
            Costo Diesel
        </div>
        <div class="col-md-6">
            ${valoresAnualesInstance?.costoDiesel}
        </div>
    </div>
</g:if>
<g:if test="${valoresAnualesInstance?.costoGrasa}">
    <div class="row">
        <div class="col-md-3 text-info">
            Costo Grasa
        </div>
        <div class="col-md-6">
            ${valoresAnualesInstance?.costoGrasa}
        </div>
    </div>
</g:if>
<g:if test="${valoresAnualesInstance?.costoLubricante}">
    <div class="row">
        <div class="col-md-3 text-info">
            Costo Lubricante
        </div>
        <div class="col-md-6">
            ${valoresAnualesInstance?.costoLubricante}
        </div>
    </div>
</g:if>
<g:if test="${valoresAnualesInstance?.factorCostoRepuestosReparaciones}">
    <div class="row">
        <div class="col-md-3 text-info">
            Factor CRR
        </div>
        <div class="col-md-6">
            ${valoresAnualesInstance?.factorCostoRepuestosReparaciones}
        </div>
    </div>
</g:if>
<g:if test="${valoresAnualesInstance?.sueldoBasicoUnificado}">
    <div class="row">
        <div class="col-md-3 text-info">
            Sueldo Básico Unificado
        </div>
        <div class="col-md-6">
            ${valoresAnualesInstance?.sueldoBasicoUnificado}
        </div>
    </div>
</g:if>
<g:if test="${valoresAnualesInstance?.tasaInteresAnual}">
    <div class="row">
        <div class="col-md-3 text-info">
            Tasa Interés Anual
        </div>
        <div class="col-md-6">
            ${valoresAnualesInstance?.tasaInteresAnual}
        </div>
    </div>
</g:if>
<g:if test="${valoresAnualesInstance?.seguro}">
    <div class="row">
        <div class="col-md-3 text-info">
            Seguro
        </div>
        <div class="col-md-6">
            ${valoresAnualesInstance?.seguro}
        </div>
    </div>
</g:if>
<g:if test="${valoresAnualesInstance?.inflacion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Inflación
        </div>
        <div class="col-md-6">
            ${valoresAnualesInstance?.inflacion}
        </div>
    </div>
</g:if>