
<legend>Composición</legend>

<div style="margin-bottom: 5px">
    <div class="row">
        <div class="col-md-2 text-info">
            Rubro
        </div>
        <div class="col-md-9">
            ${rubro.codigo} - ${rubro.nombre} (${rubro?.unidad?.encodeAsHTML()?.trim()})
        </div>
    </div>
    <div class="row">
        <div class="col-md-5 text-info">
            Fecha creación:
        </div>
        <div class="col-md-5">
            <g:formatDate date="${rubro?.fecha}" format="dd-MM-yyyy"/>
        </div>
    </div>
    <div class="row">
        <div class="col-md-5 text-info">
            Fecha modificación:
        </div>
        <div class="col-md-5">
            <g:formatDate date="${rubro?.fechaModificacion}" format="dd-MM-yyyy hh:mm"/>
        </div>
    </div>
</div>

<a href="#" id="btnEditarRubro" class="btn btn-success btn-xs">
    <i class="fa fa-edit"></i> Editar
</a>

<div id="list-grupo" role="main">
    <div id="tablas">

        <table class="table table-bordered table-striped table-condensed table-hover" style="margin-top: 10px;">
            <thead>
            <tr>
                <th style="width: 80px;">
                    Código
                </th>
                <th style="width: 600px;">
                    Equipo
                </th>
                <th style="width: 80px;">
                    Cantidad
                </th>
            </tr>
            </thead>
            <tbody id="tabla_equipo">
            <g:each in="${items}" var="rub" status="i">
                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 3}">
                    <tr class="item_row " id="${rub.id}">
                        <td class="cdgo">${rub.item.codigo}</td>
                        <td>${rub.item.nombre}</td>
                        <td style="text-align: right" class="cant">
                            <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"/>
                        </td>
                    </tr>
                </g:if>
            </g:each>
            </tbody>
        </table>
        <table class="table table-bordered table-striped table-condensed table-hover">
            <thead>
            <tr>
                <th style="width: 80px;">
                    Código
                </th>
                <th style="width: 600px;">
                    Mano de obra
                </th>
                <th style="width: 80px">
                    Cantidad
                </th>
            </tr>
            </thead>
            <tbody id="tabla_mano">
            <g:each in="${items}" var="rub" status="i">
                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 2}">
                    <tr class="item_row" id="${rub.id}">
                        <td class="cdgo">${rub.item.codigo}</td>
                        <td>${rub.item.nombre}</td>
                        <td style="text-align: right" class="cant">
                            <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"/>
                        </td>
                    </tr>
                </g:if>
            </g:each>
            </tbody>
        </table>
        <table class="table table-bordered table-striped table-condensed table-hover">
            <thead>
            <tr>
                <th style="width: 80px;">
                    Código
                </th>
                <th style="width: 600px;">
                    Materiales
                </th>
                <th style="width: 60px" class="col_unidad">
                    Unidad
                </th>
                <th style="width: 80px">
                    Cantidad
                </th>
            </tr>
            </thead>
            <tbody id="tabla_material">
            <g:each in="${items}" var="rub" status="i">
                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 1}">
                    <tr class="item_row" id="${rub.id}">
                        <td class="cdgo">${rub.item.codigo}</td>
                        <td>${rub.item.nombre}</td>
                        <td style="width: 60px !important;text-align: center" class="col_unidad">${rub.item.unidad.codigo}</td>
                        <td style="text-align: right" class="cant">
                            <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"/>
                        </td>
                    </tr>
                </g:if>
            </g:each>
            </tbody>
        </table>

        <div id="tabla_transporte"></div>

        <div id="tabla_indi"></div>

        <div id="tabla_costos" style="height: 120px;display: none;float: right;width: 100%;margin-bottom: 10px;"></div>
    </div>
</div>

<script type="text/javascript">

    $("#btnEditarRubro").click(function () {
        location.href="${createLink(controller: 'rubro', action: 'rubroPrincipal')}/${rubro?.id}"
    })

</script>