<%@ page import="janus.pac.Concurso" %>


<g:if test="${concursoInstance?.obra}">
    <div class="row">
        <div class="col-md-3 text-info">
            Obra
        </div>
        <div class="col-md-8">
            ${concursoInstance?.obra}
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.administracion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Administración
        </div>
        <div class="col-md-8">
            ${concursoInstance?.administracion}
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.pac}">
    <div class="row">
        <div class="col-md-3 text-info">
            Pac
        </div>
        <div class="col-md-8">
            ${concursoInstance?.pac?.descripcion}
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.codigo}">
    <div class="row">
        <div class="col-md-3 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${concursoInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.objeto}">
    <div class="row">
        <div class="col-md-3 text-info">
            Objeto
        </div>
        <div class="col-md-8">
            ${concursoInstance?.objeto}
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.costoBases}">
    <div class="row">
        <div class="col-md-3 text-info">
            Costo Base
        </div>
        <div class="col-md-6">
            ${concursoInstance?.costoBases}
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.fechaInicio}">
    <div class="row">
        <div class="col-md-3 text-info">
           Fecha Inicio
        </div>
        <div class="col-md-6">
            <g:formatDate date="${concursoInstance?.fechaInicio}" format="dd-MM-yyyy HH:mm"/>
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.fechaPublicacion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Publicación
        </div>
        <div class="col-md-6">
            <g:formatDate date="${concursoInstance?.fechaPublicacion}" format="dd-MM-yyyy HH:mm"/>
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.fechaLimitePreguntas}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Límite Preguntas
        </div>
        <div class="col-md-6">
            <g:formatDate date="${concursoInstance?.fechaLimitePreguntas}" format="dd-MM-yyyy HH:mm"/>
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.fechaLimiteRespuestas}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Límite Respuestas
        </div>
        <div class="col-md-6">
            <g:formatDate date="${concursoInstance?.fechaLimiteRespuestas}" format="dd-MM-yyyy HH:mm"/>
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.fechaLimiteEntregaOfertas}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Límite Entrega Ofertas
        </div>
        <div class="col-md-6">
            <g:formatDate date="${concursoInstance?.fechaLimiteEntregaOfertas}" format="dd-MM-yyyy HH:mm"/>
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.fechaLimiteSolicitarConvalidacion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Límite Solicitar Convalidación
        </div>
        <div class="col-md-6">
            <g:formatDate date="${concursoInstance?.fechaLimiteSolicitarConvalidacion}" format="dd-MM-yyyy HH:mm"/>
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.fechaLimiteRespuestaConvalidacion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Límite Respuesta Convalidación
        </div>
        <div class="col-md-6">
            <g:formatDate date="${concursoInstance?.fechaLimiteRespuestaConvalidacion}" format="dd-MM-yyyy HH:mm"/>
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.fechaCalificacion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Calificación
        </div>
        <div class="col-md-6">
            <g:formatDate date="${concursoInstance?.fechaCalificacion}" format="dd-MM-yyyy HH:mm"/>
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.fechaInicioPuja}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Inicio Puja
        </div>
        <div class="col-md-6">
            <g:formatDate date="${concursoInstance?.fechaInicioPuja}" format="dd-MM-yyyy HH:mm"/>
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.fechaFinPuja}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Fin Puja
        </div>
        <div class="col-md-6">
            <g:formatDate date="${concursoInstance?.fechaFinPuja}" format="dd-MM-yyyy HH:mm"/>
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.fechaAdjudicacion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Adjudicacion
        </div>
        <div class="col-md-6">
            <g:formatDate date="${concursoInstance?.fechaAdjudicacion}" format="dd-MM-yyyy HH:mm"/>
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.estado}">
    <div class="row">
        <div class="col-md-3 text-info">
            Estado
        </div>
        <div class="col-md-6">
            ${concursoInstance?.estado == 'R' ? 'Registrado' : 'No registrado'}
        </div>
    </div>
</g:if>

<g:if test="${concursoInstance?.observaciones}">
    <div class="row">
        <div class="col-md-3 text-info">
            Observaciones
        </div>
        <div class="col-md-8">
            ${concursoInstance?.observaciones}
        </div>
    </div>
</g:if>
