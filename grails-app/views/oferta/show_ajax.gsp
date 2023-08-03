
<%@ page import="janus.pac.Oferta" %>

<div id="show-oferta" class="span5" role="main">

    <form class="form-horizontal">

        <g:if test="${ofertaInstance?.concurso?.objeto}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Proceso
                    </label>
                    <span class="col-md-8">
                        ${ofertaInstance?.concurso?.objeto}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${ofertaInstance?.proveedor}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Proveedor
                    </label>
                    <span class="col-md-8">
                        ${ofertaInstance?.proveedor?.nombre}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${ofertaInstance?.descripcion}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Descripción
                    </label>
                    <span class="col-md-8">
                        ${ofertaInstance?.descripcion}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${ofertaInstance?.monto}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Monto
                    </label>
                    <span class="col-md-8">
                        ${ofertaInstance?.monto}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${ofertaInstance?.fechaEntrega}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Fecha Entrega
                    </label>
                    <span class="col-md-8">
                        <g:formatDate date="${ofertaInstance?.fechaEntrega}" format="dd-MM-yyyy"/>
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${ofertaInstance?.plazo}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Plazo
                    </label>
                    <span class="col-md-8">
                        ${ofertaInstance?.plazo}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${ofertaInstance?.calificado}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Plazo
                    </label>
                    <span class="col-md-8">
                        ${ofertaInstance?.calificado}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${ofertaInstance?.hoja}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Hoja
                    </label>
                    <span class="col-md-8">
                        ${ofertaInstance?.hoja}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${ofertaInstance?.subsecretario}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Subsecretario
                    </label>
                    <span class="col-md-8">
                        ${ofertaInstance?.subsecretario}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${ofertaInstance?.garantia}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Garantía
                    </label>
                    <span class="col-md-8">
                        ${ofertaInstance?.garantia == 1 ? 'Con garantía' : 'Sin ganrantía'}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${ofertaInstance?.estado}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Estado
                    </label>
                    <span class="col-md-8">
                        ${ofertaInstance?.estado}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${ofertaInstance?.observaciones}">

            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Observaciones
                    </label>
                    <span class="col-md-8">
                        ${ofertaInstance?.observaciones}
                    </span>
                </span>
            </div>
        </g:if>

    </form>
</div>
