<style type="text/css">
fieldset {
    margin-bottom : 15px;
}
/*.bootstrap-datetimepicker-widget {*/
/*    position: static;*/
/*    z-index: 1000 !important;*/

/*}*/
</style>

<div class="tituloTree">${grupo.descripcion}</div>
<g:form controller="reportes2" action="reportePrecios">
    <fieldset>
        <legend>Columnas a imprimir</legend>

        <div class="btn-group" data-toggle="buttons-checkbox">
            <g:if test="${grupo.id == 1}">
                <a href="#" id="t" class="col btn">
                    Transporte
                </a>
            </g:if>
            <a href="#" id="u" class="col btn active">
                Unidad
            </a>
            <a href="#" id="p" class="col btn active">
                Precio
            </a>
            <a href="#" id="f" class="col btn">
                Fecha de Act.
            </a>
            <a href="#" id="r" class="col btn">
                Rubros
            </a>
            <a href="#" id="o" class="col btn">
                Obras
            </a>
        </div>
    </fieldset>
    <fieldset>
        <legend>Orden de impresión - Activos/Inactivos</legend>

        <div class="btn-group col-md-12" data-toggle="buttons-radio">
            <div class="col-md-5">
                <a href="#" id="a" class="orden btn active">
                    Alfabético
                </a>
                <a href="#" id="n" class="orden btn">
                    Numérico
                </a>
                %{--            <input class="form-check-input revisar" type="checkbox" value="option1" checked="checked">--}%
            </div>
            <div class="col-md-4">
                <g:select name="revisar" class="form-control col-md-2" from="${[true: 'Activos', false : 'Inactivos']}" optionKey="key" optionValue="value"/>
            </div>
        </div>

    </fieldset>
    <fieldset class="form-inline">
        <legend>Lugar y fecha de referencia</legend>
        <g:set var="tipoMQ" value="${janus.TipoLista.findAllByCodigo('MQ')}"/>

        <g:if test="${grupo.id == 1}">
            <g:select name="lugarRep" from="${janus.Lugar.findAllByTipoListaNotInList(tipoMQ, [sort: 'descripcion'])}" optionKey="id" optionValue="descripcion"/>
        </g:if>
        <g:else>
            <g:select name="lugarRep" from="${janus.Lugar.findAllByTipoListaInList(tipoMQ, [sort: 'descripcion'])}" optionKey="id" optionValue="descripcion"/>
        </g:else>

        <input aria-label="" name="fechaRep" id='fechaRep' type='text' class="form-control" value="${new Date().format("dd-MM-yyyy")}" />

    </fieldset>
</g:form>

<script type="text/javascript">

    // $.switcher('input[type=checkbox]');

    $('#fechaRep').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

</script>