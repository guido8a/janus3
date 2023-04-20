<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <g:if test="${rend == 'screen'}">
            <meta name="layout" content="main">
            <asset:javascript src="/jquery/plugins/DataTables-1.9.4/media/js/jquery.dataTables.min.js"/>
            %{--<asset:javascript src="/jquery/plugins/DataTables-1.9.4/media/css/jquery.dataTables.css"/>--}%
            %{--<script src="${resource(dir: 'js/jquery/plugins/DataTables-1.9.4/media/js', file: 'jquery.dataTables.min.js')}"></script>--}%
            %{--<link href="${resource(dir: 'js/jquery/plugins/DataTables-1.9.4/media/css', file: 'jquery.dataTables.css')}" rel="stylesheet">--}%
        </g:if>
        <title>Composición de la obra</title>

            <style type="text/css">

            .activo{
                color: #ffffaf !important;
                background-color: #5a81c6 !important;
                font-weight: bold;
            }

            </style>

    </head>

    <body>
        <div class="hoja">
            %{--<div class="tituloChevere">Composición de la obra: ${obra?.descripcion}</div>--}%
            <div class="span12" style="color: #1a7031; font-size: 18px; margin-bottom: 10px"><strong>Composición de la obra:</strong> ${obra?.descripcion}</div>

            <g:if test="${flash.message}">
                <div class="span12">
                    <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                        <a class="close" data-dismiss="alert" href="#">×</a>
                        ${flash.message}
                    </div>
                </div>
            </g:if>

            <g:if test="${rend == 'screen'}">
                <div class="btn-toolbar" style="margin-top: 15px;">
                    <div class="btn-group">
                        <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}"
                           class="btn " title="Regresar a la obra">
                            <i class="fa fa-arrow-left"></i>
                            Regresar
                        </a>
                        <g:link action="validacion" id="${obra?.id}" controller="composicion" class="btn"
                                title="Cantidades reales de Materiales, M.O. y Equipos">
                            <i class="fa fa-list"></i>
                            Adm. Directa
                        </g:link>
                    </div>

                    <div class="btn-group" style="margin-left: 80px">
                        <a href="#" id="btnTodos" class="btn btn-info ${tipo.toString().contains(",") ? 'active' : ''} -1">
                            <i class="fa fa-cogs"></i>
                            Todos
                        </a>
                        <a href="#" id="btnMateriales" class="btn btn-info ${tipo.toString() == '1' ? 'active' : ''} 1">
                            <i class="fa fa-briefcase"></i>
                            Materiales
                        </a>
                        <a href="#" id="btnManoObra" class="btn btn-info ${tipo.toString() == '2' ? 'active' : ''} 2">
                            <i class="fa fa-users"></i>
                            Mano de obra
                        </a>
                        <a href="#" id="btnEquipos" class="btn btn-info ${tipo.toString() == '3' ? 'active' : ''} 3">
                            <i class="fa fa-truck"></i>
                            Equipos
                        </a>
                    </div>

                    <div class="btn-group">
                        <a class="btn btn-info dropdown-toggle" data-toggle="dropdown" href="#">
                            <g:if test="${spsel.toString() == '-1'}">
                                Todos los subpresupuestos
                            </g:if>
                            <g:else>
                                ${sp.find { it.id.toString() == spsel.toString() }.dsc}
                            </g:else>
                            <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="sp ${spsel.toString() == '-1' ? 'activo' : ''}">
                                <g:link action="composicion" id="${obra?.id}" params="[tipo: tipo, sp: -1]">
                                    <g:if test="${spsel.toString() == '-1'}">
                                        <i class="fa fa-chevron-right"></i>
                                    </g:if>
                                    Todos los subpresupuestos
                                </g:link>
                            </li>
                            <g:each in="${sp}" var="s">
                                <li class="sp ${spsel.toString() == s.id.toString() ? 'activo' : ''}">
                                    <g:link action="composicion" id="${obra?.id}" params="[tipo: tipo, sp: s.id]">
                                        <g:if test="${spsel.toString() == s.id.toString()}">
                                            <i class="fa fa-chevron-right"></i>
                                        </g:if>
                                        ${s.dsc}
                                    </g:link>
                                </li>
                            </g:each>
                        </ul>
                    </div>

                    <div class="btn-group">
                        <a href="#" class="btn  btn-info" id="imprimirPdf">
                            <i class="fa fa-print"></i>
                            PDF
                        </a>
                        <g:link controller="reportes2" action="reporteExcelComposicion" class="btn btn-print btnExcel" id="${obra?.id}" params="[sp: sub, tipo: tipo]">
                            <i class="fa fa-file-excel"></i> Excel
                        </g:link>
                        <g:link controller="reportes2" action="reporteExcelComposicionTotales" class="btn btn-print btnExcel" id="${obra?.id}" params="[sp: sub, tipo: tipo]" title="Exportar a excel para definir las cantidades reales de Materiales, M.O. y Equipos">
                            <i class="icon-table"></i> Adm. Directa
                        </g:link>
                    </div>
                </div>
            </g:if>

            <div class="body" style="margin-top: 5px">
                <table class="table table-bordered table-condensed table-hover table-striped" id="tbl">
                    <thead>
                        <tr>
                            <g:if test="${tipo.contains(",") || tipo == '1'}">
                                <th>Código</th>
                                <th>Item</th>
                                <th>U</th>
                                <th>Cantidad</th>
                                <th>P. Unitario</th>
                                <th>Transporte</th>
                                <th>Costo</th>
                                <th>Total</th>
                                <g:if test="${tipo.contains(",")}">
                                    <th>Tipo</th>
                                </g:if>
                            </g:if>
                            <g:elseif test="${tipo == '2'}">
                                <th>Código</th>
                                <th>Mano de obra</th>
                                <th>U</th>
                                <th>Horas hombre</th>
                                <th>Sal. / hora</th>
                                <th>Costo</th>
                                <th>Total</th>
                            </g:elseif>
                            <g:elseif test="${tipo == '3'}">
                                <th>Código</th>
                                <th>Equipo</th>
                                <th>U</th>
                                <th>Cantidad</th>
                                <th>Tarifa</th>
                                <th>Costo</th>
                                <th>Total</th>
                            </g:elseif>

                        </tr>
                    </thead>
                    <tbody>
                        <g:set var="totalEquipo" value="${0}"/>
                        <g:set var="totalMano" value="${0}"/>
                        <g:set var="totalMaterial" value="${0}"/>
                        <g:each in="${res}" var="r">
                            <tr>
                                <td class="">${r.codigo}</td>
                                <td class="">${r.item}</td>
                                <td>${r.unidad}</td>
                                <td class="numero">
                                    <g:formatNumber number="${r.cantidad}" minFractionDigits="3" maxFractionDigits="3" format="##,##0" locale="ec"/>
                                </td>
                                <td class="numero">
                                    <g:formatNumber number="${r.punitario}" minFractionDigits="3" maxFractionDigits="3" format="##,##0" locale="ec"/>
                                </td>
                                <g:if test="${tipo.contains(",") || tipo == '1'}">
                                    <td class="numero">
                                        <g:formatNumber number="${r.transporte}" minFractionDigits="4" maxFractionDigits="4" format="##,##0" locale="ec"/>
                                    </td>
                                </g:if>
                                <td class="numero">
                                    <g:formatNumber number="${r.costo}" minFractionDigits="4" maxFractionDigits="4" format="##,##0" locale="ec"/>
                                </td>
                                <td class="numero">
                                    <g:formatNumber number="${r?.total}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/>

                                    <g:if test="${r?.grid == 1}">

                                        <g:if test="${r?.total == null}">

                                            <g:set var="totalMaterial" value="${totalMaterial}"/>

                                        </g:if>
                                        <g:else>

                                            <g:set var="totalMaterial" value="${totalMaterial + r?.total}"/>
                                        </g:else>

                                    </g:if>
                                    <g:elseif test="${r?.grid == 2}">
                                        <g:if test="${r?.total == null}">
                                            <g:set var="totalMano" value="${totalMano}"/>
                                        </g:if>
                                        <g:else>
                                            <g:set var="totalMano" value="${totalMano + r?.total}"/>
                                        </g:else>
                                    </g:elseif>
                                    <g:elseif test="${r?.grid == 3}">
                                        <g:if test="${r?.total == null}">
                                            <g:set var="totalEquipo" value="${totalEquipo}"/>

                                        </g:if>
                                        <g:else>
                                            <g:set var="totalEquipo" value="${totalEquipo + r?.total}"/>

                                        </g:else>

                                    </g:elseif>

                                </td>
                                <g:if test="${tipo.contains(",")}">
                                    <td>${r?.grupo}</td>
                                </g:if>
                            </tr>
                        </g:each>
                    </tbody>
                </table>

                <div style="width:100%;">
                    <table class="table table-bordered table-condensed pull-right" style="width: 20%;">
                        <thead style="text-align: right">
                        <tr>
                            <th>Equipos</th>
                            <td class="numero"><g:formatNumber number="${totalEquipo}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                        </tr>
                        <tr>
                            <th>Mano de obra</th>
                            <td class="numero"><g:formatNumber number="${totalMano}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                        </tr>
                        <tr>
                            <th>Materiales</th>
                            <td class="numero"><g:formatNumber number="${totalMaterial}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                        </tr>
                        <tr>
                            <th>TOTAL DIRECTO</th>
                            <td class="numero"><g:formatNumber number="${totalEquipo + totalMano + totalMaterial}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                        </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>

        <g:if test="${rend == 'screen'}">
            <script type="text/javascript">
                $(function () {
                    $('#tbl').dataTable({
                        sScrollY        : "600px",
                        bPaginate       : false,
                        bScrollCollapse : true,
                        bFilter         : false,
                        bSort           : false,
                        oLanguage       : {
                            sZeroRecords : "No se encontraron datos",
                            sInfo        : "",
                            sInfoEmpty   : ""
                        }
                    });

                    $(".btn, .sp").click(function () {
                        if ($(this).hasClass("activo")) {
                            return false;
                        }
                    });

                    $("#imprimirPdf").click(function () {

//                       console.log("-->" + $(".pdf.activo").attr("class"))
//                       console.log("-->" + $(".pdf.activo").hasClass('2'))

                        if ($(".pdf.activo").hasClass("1") == true) {

                            location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteComposicionMat',id: obra?.id)}?sp=${sub}"
                        } else {
                        }
                        if ($(".pdf.activo").hasClass("2") == true) {
                            location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteComposicionMano',id: obra?.id)}?sp=${sub}"
                        } else {

                        }
                        if ($(".pdf.activo").hasClass("3") == true) {
                            location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteComposicionEq',id: obra?.id)}?sp=${sub}"

                        } else {

                        }
                        if ($(".pdf.activo").hasClass("-1") == true) {

                            location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteComposicion',id: obra?.id)}?sp=${sub}"
                        }
                    });

                });

                $("#btnTodos").click(function () {
                    location.href = "${g.createLink(controller: 'variables', action: 'composicion', params: [id: obra?.id, tipo: -1, sp: spsel])}"
                });

                $("#btnMateriales").click(function () {
                    location.href = "${g.createLink(controller: 'variables', action: 'composicion', params: [id: obra?.id, tipo: 1, sp: spsel])}"
                });

                $("#btnManoObra").click(function () {
                    location.href = "${g.createLink(controller: 'variables', action: 'composicion', params: [id: obra?.id, tipo: 2, sp: spsel])}"
                });

                $("#btnEquipos").click(function () {
                    location.href = "${g.createLink(controller: 'variables', action: 'composicion', params: [id: obra?.id, tipo: 3, sp: spsel])}"
                });

            </script>
        </g:if>




    </body>
</html>