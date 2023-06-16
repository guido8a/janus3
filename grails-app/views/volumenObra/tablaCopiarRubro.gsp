%{--<g:if test="${flash.message}">--}%
%{--    <div class="col-md-12" style="height: 35px;margin-bottom: 10px; margin-left: -25px">--}%
%{--        <div class="alert ${flash.clase ?: 'alert-info'}" role="status" style="text-align: center">--}%
%{--            <a class="close" data-dismiss="alert" href="#">×</a>--}%
%{--            ${flash.message}--}%
%{--        </div>--}%
%{--    </div>--}%
%{--</g:if>--}%

%{--<div class="col-md-12">--}%
%{--    <a href="#" class="btn" id="regresar">--}%
%{--        <i class="fa fa-arrow-left"></i>--}%
%{--        Regresar--}%
%{--    </a>--}%
%{--</div>--}%

%{--<div class="btn-group" style="margin-left: 0px; margin-top: 20px">--}%
%{--    <div class="col-md-5" style="width: 550px">--}%
%{--        <b>Subpresupuesto de origen:</b>--}%
%{--        <g:select name="subpresupuestoOrg" from="${subPres}" optionKey="id" optionValue="descripcion"--}%
%{--                  noSelection="['' : ' - Seleccione un subpresupuesto - ']"--}%
%{--                  style="width: 300px;font-size: 10px; margin-left: 50px" id="subPres_desc" value="${subPre}" />--}%
%{--    </div>--}%
%{--    <div class="col-md-5" style="width: 550px">--}%
%{--        <b>Subpresupuesto de destino:</b>--}%
%{--        <g:select name="subpresupuestoDes" from="${janus.SubPresupuesto.list([sort: 'descripcion'])}" optionKey="id"--}%
%{--                  optionValue="descripcion" style="width: 300px;font-size: 10px; margin-left: 45px" id="subPres_destino"--}%
%{--                  noSelection="['' : ' - Seleccione un subpresupuesto - ']" />--}%
%{--    </div>--}%
%{--</div>--}%
%{--<div class="col-md-6" style="margin-top: 20px; margin-bottom: 10px">--}%
%{--        <a href="#" class="btn  " id="copiar_todos">--}%
%{--            <i class="icon-copy"></i>--}%
%{--            Copiar Todos los Rubros--}%
%{--        </a>--}%
%{--        <a href="#" class="btn  " id="copiar_sel">--}%
%{--            <i class="icon-copy"></i>--}%
%{--            Copiar rubros seleccionados--}%
%{--        </a>--}%
%{--</div>--}%


<table class="table table-bordered table-striped table-condensed table-hover">
    %{--    <thead>--}%
    %{--    <tr>--}%
    %{--        <th style="width: 10px;">--}%
    %{--            *--}%
    %{--        </th>--}%
    %{--        <th style="width: 20px;">--}%
    %{--            #--}%
    %{--        </th>--}%
    %{--        <th style="width: 200px;">--}%
    %{--            Subpresupuesto--}%
    %{--        </th>--}%
    %{--        <th style="width: 80px;">--}%
    %{--            Código--}%
    %{--        </th>--}%
    %{--        <th style="width: 400px;">--}%
    %{--            Rubro--}%
    %{--        </th>--}%
    %{--        <th style="width: 60px" class="col_unidad">--}%
    %{--            Unidad--}%
    %{--        </th>--}%
    %{--        <th style="width: 80px">--}%
    %{--            Cantidad--}%
    %{--        </th>--}%
    %{--        <th class="col_precio" style="display: none;">Unitario</th>--}%
    %{--        <th class="col_total" style="display: none;">C.Total</th>--}%
    %{--    </tr>--}%
    %{--    </thead>--}%


    <tbody id="tabla_material">

    <g:each in="${valores}" var="val" status="">
        <tr class="item_row" id="${val.item__id}" item="${val}" sub="${val.sbpr__id}" ord="${val.vlobordn}" cant="${val.vlobcntd}">
            <td style="width: 10px" class="sel"><g:checkBox class="chec" name="selec" checked="false" id="seleccionar1" value="${val.item__id}"/></td>
            <td style="width: 20px" class="orden">${val.vlobordn}</td>
            <td style="width: 200px" class="sub">${val.sbprdscr.trim()}</td>
            <td class="cdgo">${val.rbrocdgo.trim()}</td>
            <td class="nombre">${val.rbronmbr.trim()}</td>
            <td style="width: 60px !important;text-align: center" class="col_unidad">${val.unddcdgo.trim()}</td>
            <td style="text-align: right" class="cant">
                <g:formatNumber number="${val.vlobcntd}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
            </td>
            <td class="col_precio" style="display: none;text-align: right" id="i_${val.item__id}"><g:formatNumber number="${val.pcun}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
            <td class="col_total total" style="display: none;text-align: right"><g:formatNumber number="${val.totl}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
        </tr>
    </g:each>

    </tbody>
</table>


%{--<div id="faltaOrigenDialog">--}%
%{--    <div class="col-md-12">--}%
%{--        Es necesario elegir los subpresupuesto de Origen y de Destino--}%
%{--    </div>--}%
%{--</div>--}%


<script type="text/javascript">

    var checkeados = [];

    %{--$("#subPres_desc").change(function(){--}%

    %{--    var datos = "obra=${obra.id}&sub="+$("#subPres_desc").val()--}%
    %{--    var interval = loading("detalle")--}%
    %{--    $.ajax({type : "POST", url : "${g.createLink(controller: 'volumenObra',action:'tablaCopiarRubro')}",--}%
    %{--        data     : datos,--}%
    %{--        success  : function (msg) {--}%
    %{--            clearInterval(interval)--}%
    %{--            $("#detalle").html(msg)--}%
    %{--        }--}%
    %{--    });--}%
    %{--});--}%


    $("#copiar_todos").click(function () {

        var tbody = $("#tabla_material");
        var datos
        var subPresDest = $("#subPres_destino").val()
        var subPre = $("#subPres_desc").val()

        if(subPre == "" || subPresDest == ""){
            $("#faltaOrigenDialog").dialog("open")
            $(".ui-dialog-titlebar-close").html("x")
        } else {

            tbody.children("tr").each(function () {

                var trId = $(this).attr("id")

                datos ="rubro=" + trId + "&subDest=" + subPresDest + "&obra=" + ${obra.id} + "&sub=" + subPre

                $.ajax({type : "POST", url : "${g.createLink(controller: 'volumenObra',action:'copiarItem')}",
                    data     : datos,
                    success  : function (msg) {
                        $("#detalle").html(msg)

                    }
                });


            });
        }

    });

    function copiar() {
        var d = cargarLoader("Copiando...");
        var tbody = $("#tabla_material");
        var datos;
        var subPresDest = $("#subPres_destino option:selected").val();
        var subPre = $("#subPres_desc option:selected").val();

        if (subPresDest === '') {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-warning fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un subpresupuesto de destino" + '</strong>');
        } else {
            if (subPresDest === subPre) {
                bootbox.alert('<i class="fa fa-exclamation-triangle text-warning fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un subpresupuesto diferente al de origen" + '</strong>');
            } else {
                tbody.children("tr").each(function () {
                    if (($(this).children("td").children().get(1).checked) === true) {
                        var trId = $(this).attr("id");
                        var ord = $(this).attr("ord");
                        var canti = $(this).attr("cant");

                        datos = "&rubro=" + trId + "&subDest=" + subPresDest + "&obra=" + ${obra.id} +"&sub=" + subPre + "&orden=" + ord + "&canti=" + canti;

                        $.ajax({
                            type: "POST",
                            url: "${g.createLink(controller: 'volumenObra',action:'copiarItem')}",
                            data: datos,
                            success: function (msg) {
                                d.modal("hide");
                                var parts = msg.split("_");
                                if (parts[0] === 'ok') {
                                    log(parts[1], "success");
                                } else {
                                    bootbox.alert('<i class="fa fa-exclamation-triangle text-warning fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                                }
                            }
                        });

                    } else {

                    }
                });
            }
        }
    }
</script>