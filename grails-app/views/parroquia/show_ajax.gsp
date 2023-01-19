
<style type="text/css">
.tama {
    font-size: 14px;
}
</style>

<div id="show-parroquia" class="span5 tama" role="main">

    <form class="form-horizontal">

        <g:if test="${parroquiaInstance?.canton}">
            <div class="row">
                <div class="col-md-2 text-info">
                    Cantón
                </div>
                <div class="col-md-8">
                    ${parroquiaInstance?.canton?.nombre}
                </div>
            </div>
        </g:if>

        <g:if test="${parroquiaInstance?.codigo}">
            <div class="row">
                <div class="col-md-2 text-info">
                    Código
                </div>
                <div class="col-md-3">
                    <g:fieldValue bean="${parroquiaInstance}" field="codigo"/>
                </div>
            </div>
        </g:if>

        <g:if test="${parroquiaInstance?.nombre}">
            <div class="row">
                <div class="col-md-2 text-info">
                    Nombre
                </div>
                <div class="col-md-8">
                    <g:fieldValue bean="${parroquiaInstance}" field="nombre"/>
                </div>
            </div>
        </g:if>

        <g:if test="${parroquiaInstance?.latitud}">
            <div class="row">
                <div class="col-md-2 text-info">
                    Latitud
                </div>
                <div class="col-md-3">
                    <g:fieldValue bean="${parroquiaInstance}" field="latitud"/>
                </div>
            </div>
        </g:if>

        <g:if test="${parroquiaInstance?.longitud}">
            <div class="row">
                <div class="col-md-2 text-info">
                    Longitud
                </div>
                <div class="col-md-3">
            <g:fieldValue bean="${parroquiaInstance}" field="longitud"/>
            </div>
        </g:if>

    </form>
</div>
