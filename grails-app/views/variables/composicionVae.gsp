<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">

    <title>Valores del VAE</title>

</head>

<body>
<div class="hoja">
    <div class="span12" style="color: #1a7031; font-size: 18px; margin-bottom: 10px"><strong>Valores del VAE, para la Obra:</strong> ${obra?.descripcion}</div>

    <g:if test="${flash.message}">
        <div class="span12">
            <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                <a class="close" data-dismiss="alert" href="#">×</a>
                <elm:poneHtml textoHtml="${flash.message}"/>
            </div>
        </div>
    </g:if>

    <div class="btn-toolbar" style="margin-top: 15px;">
        <div class="btn-group">
            <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}" class="btn btn-info"
               title="Regresar a la obra">
                <i class="fa fa-arrow-left"></i>
                Regresar
            </a>
        </div>

        <div class="btn-group">
            <g:link action="composicionVae" id="${obra?.id}" params="[tipo: -1]"
                    class="btn btn-info toggle pdf ${tipo.contains(',') ? 'active' : ''} -1">
                <i class="fa fa-cogs"></i>
                Todos
            </g:link>
            <g:link action="composicionVae" id="${obra?.id}" params="[tipo: 1]"
                    class="btn btn-info toggle pdf ${tipo == '1' ? 'active' : ''} 1">
                <i class="fa fa-briefcase"></i>
                Materiales
            </g:link>
            <g:link action="composicionVae" id="${obra?.id}" params="[tipo: 2]"
                    class="btn btn-info toggle pdf ${tipo == '2' ? 'active' : ''} 2">
                <i class="fa fa-users"></i>
                Mano de obra
            </g:link>
            <g:link action="composicionVae" id="${obra?.id}" params="[tipo: 3]"
                    class="btn btn-info toggle pdf ${tipo == '3' ? 'active' : ''} 3">
                <i class="fa fa-truck"></i>
                Equipos
            </g:link>
        </div>

        %{--        <a href="#" class="btn btn-actualizar btn-success"><i class="fa fa-save"></i> Guardar</a>--}%
    </div>

    <div class="body" style="margin-top: 10px">
        <g:if test="${res.size() > 0}">

            <div class="row" style="margin-top:15px">
                <div class="col-md-12">
                    <table class="table table-hover table-bordered table-striped">
                        <thead>
                        <tr>
                            <g:if test="${tipo.contains(",") || tipo == '1'}">
                                <th style="width: 8%;">Código</th>
                                <th style="width: 26%;">Item</th>
                                <th style="width: 4%;">U</th>
                                <th style="width: 8%;">Cantidad</th>
                                <th style="width: 8%;">P. Unitario</th>
                                <th style="width: 8%;">Transporte</th>
                                <th style="width: 10%;">Costo</th>
                                <th style="width: 10%;">Total</th>
                                <g:if test="${tipo.contains(",")}">
                                    <th style="width: 10%;">Tipo</th>
                                </g:if>
                                <th style="width: 10%;">VAE (%)</th>
                            </g:if>
                            <g:elseif test="${tipo == '2'}">
                                <th style="width: 8%;">Código</th>
                                <th style="width: 22%;">Mano de obra</th>
                                <th style="width: 4%;">U</th>
                                <th style="width: 7%;">Horas hombre</th>
                                <th style="width: 7%;">Sal. / hora</th>
                                <th style="width: 9%;">Costo</th>
                                <th style="width: 9%;">Total</th>
                                <th style="width: 9%;">VAE (%)</th>
                            </g:elseif>
                            <g:elseif test="${tipo == '3'}">
                                <th style="width: 8%;">Código</th>
                                <th style="width: 22%;">Equipo</th>
                                <th style="width: 4%;">U</th>
                                <th style="width: 7%;">Cantidad</th>
                                <th style="width: 7%;">Tarifa</th>
                                <th style="width: 9%;">Costo</th>
                                <th style="width: 9%;">Total</th>
                                <th style="width: 9%;">VAE (%)</th>
                            </g:elseif>
                        </tr>
                        </thead>
                    </table>
                </div>
            </div>

            <div class="row-fluid"  style="width: 99.7%;height: 500px;overflow-y: auto;float: right; margin-top: -20px; margin-bottom: 10px">
                <table class="table table-bordered table-condensed table-hover table-striped" id="tbl">
                    <tbody>
                    <g:set var="totalEquipo" value="${0}"/>
                    <g:set var="totalMano" value="${0}"/>
                    <g:set var="totalMaterial" value="${0}"/>
                    <g:set var="sumaVaeEq" value="${0}"/>
                    <g:set var="sumaVaeMt" value="${0}"/>
                    <g:set var="sumaVaeMo" value="${0}"/>
                    <g:each in="${res}" var="r">
                        <tr>
                            <td style="width: 8%;">${r.codigo}</td>
                            <td style="width: 26%;">${r.item}</td>
                            <td style="width: 4%;">${r.unidad}</td>
                            <td class="numero" style="width: 8%;">
                                <g:formatNumber number="${r.cantidad}" minFractionDigits="3" maxFractionDigits="3"
                                                format="##,##0" locale="ec"/>
                            </td>
                            <td class="numero" style="width: 8%;">
                                <g:formatNumber number="${r.punitario}" minFractionDigits="3" maxFractionDigits="3"
                                                format="##,##0" locale="ec"/>
                            </td>
                            <g:if test="${tipo.contains(",") || tipo == '1'}">
                                <td class="numero" style="width: 8%;">
                                    <g:formatNumber number="${r.transporte}" minFractionDigits="4" maxFractionDigits="4"
                                                    format="##,##0" locale="ec"/>
                                </td>
                            </g:if>
                            <td class="numero" style="width: 10%;">
                                <g:formatNumber number="${r.costo}" minFractionDigits="4" maxFractionDigits="4" format="##,##0"
                                                locale="ec"/>
                            </td>
                            <td class="numero" style="width: 10%;">
                                <g:formatNumber number="${r?.total}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/>
                                <g:if test="${r?.grid == 1}">
                                    <g:if test="${r?.total == null}">
                                        <g:set var="totalMaterial" value="${totalMaterial}"/>
                                        <g:set var="sumaVaeMt" value="${sumaVaeMt}"/>
                                    </g:if>
                                    <g:else>
                                        <g:set var="totalMaterial" value="${totalMaterial + r?.total}"/>
                                        <g:set var="sumaVaeMt" value="${sumaVaeMt + r?.total * r?.tpbnpcnt / 100}"/>
                                    </g:else>
                                </g:if>
                                <g:elseif test="${r?.grid == 2}">
                                    <g:if test="${r?.total == null}">
                                        <g:set var="totalMano" value="${totalMano}"/>
                                        <g:set var="sumaVaeMo" value="${sumaVaeMo}"/>
                                    </g:if>
                                    <g:else>
                                        <g:set var="totalMano" value="${totalMano + r?.total}"/>
                                        <g:set var="sumaVaeMo" value="${sumaVaeMo + r?.total * r?.tpbnpcnt / 100}"/>
                                    </g:else>
                                </g:elseif>
                                <g:elseif test="${r?.grid == 3}">
                                    <g:if test="${r?.total == null}">
                                        <g:set var="totalEquipo" value="${totalEquipo}"/>
                                        <g:set var="sumaVaeEq" value="${sumaVaeEq}"/>

                                    </g:if>
                                    <g:else>
                                        <g:set var="totalEquipo" value="${totalEquipo + r?.total}"/>
                                        <g:set var="sumaVaeEq" value="${sumaVaeEq + r?.total * r?.tpbnpcnt / 100}"/>
                                    </g:else>
                                </g:elseif>
                            </td>
                            <g:if test="${tipo.contains(",")}">
                                <td style="width: 10%;">${r?.grupo}</td>
                            </g:if>
                            <td class="editable numero cantidad texto" style="width: 10%;" data-original="${r?.tpbnpcnt}" data-id="${r?.item__id}" data-valor="${r?.tpbnpcnt}">
                                ${r?.tpbnpcnt}
                                <div style="float: right">
                                    <a href="#" class="btn btn-xs btn-success btnEditar" title="Editar valor" data-id="${r?.item__id}" data-obra="${obra?.id}">
                                        <i class="fa fa-edit"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>

            <div style="width:100%;">
                <table class="table table-bordered table-condensed pull-right" style="width: 20%;">
                    <tr>
                        <th>Equipos</th>
                        <td class="numero"><g:formatNumber number="${totalEquipo}" minFractionDigits="2"
                                                           maxFractionDigits="2" format="##,##0" locale="ec"/></td>

                        <td class="numero">
                            <g:if test="${totalEquipo > 0}">
                                <g:formatNumber number="${sumaVaeEq / totalEquipo * 100}" minFractionDigits="2"
                                                maxFractionDigits="2" format="##,##0" locale="ec"/>%

                            </g:if>
                        </td>
                    </tr>
                    <tr>
                        <th>Mano de obra</th>
                        <td class="numero"><g:formatNumber number="${totalMano}" minFractionDigits="2" maxFractionDigits="2"
                                                           format="##,##0" locale="ec"/></td>
                        <td class="numero">
                            <g:if test="${totalMano > 0}">
                                <g:formatNumber number="${sumaVaeMo / totalMano * 100}" minFractionDigits="2"
                                                maxFractionDigits="2" format="##,##0" locale="ec"/>%
                            </g:if>
                        </td>
                    </tr>
                    <tr>
                        <th>Materiales</th>
                        <td class="numero"><g:formatNumber number="${totalMaterial}" minFractionDigits="2"
                                                           maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                        <td class="numero">
                            <g:if test="${totalMaterial > 0}">
                                <g:formatNumber number="${sumaVaeMt / totalMaterial * 100}" minFractionDigits="2"
                                                maxFractionDigits="2" format="##,##0" locale="ec"/>%
                            </g:if>
                        </td>
                    </tr>
                    <tr>
                        <th>TOTAL OBRA</th>
                        <td class="numero"><g:formatNumber number="${totalEquipo + totalMano + totalMaterial}"
                                                           minFractionDigits="2" maxFractionDigits="2" format="##,##0"
                                                           locale="ec"/></td>

                        <td class="numero">
                            <g:if test="${totalEquipo > 0 && totalMano > 0 && totalMaterial > 0}">
                                <g:formatNumber
                                        number="${(sumaVaeEq / totalEquipo + sumaVaeMo / totalMano + sumaVaeMt / totalMaterial) / 3 * 100}"
                                        minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/>%
                            </g:if>
                        </td>

                    </tr>
                </table>
            </div>

%{--            <input type='text' id='txt' style='height:20px;width:110px;margin: 0px;padding: 0px;padding-right:2px;text-align: right !important;display: none;'>--}%
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center"><i class="fa fa-exclamation-triangle text-warning fa-2x"></i> No existe registros</div>
        </g:else>

    </div>
</div>


<script type="text/javascript">


    $(".btnEditar").click(function () {
        var id = $(this).data("id");
        var obra = $(this).data("obra");
        $.ajax({
            type    : "POST",
            url: "${createLink(action:'valorIndice_ajax')}",
            data    : {
                item: id,
                obra: obra
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgEditarIndices",
                    title   : "Editar valor del índice",
                    class   : "modal-sm",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormValorIndices();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });


    function submitFormValorIndices() {
        var $form = $("#frmSave-ValorIndice");
        if ($form.valid()) {
            var data = $form.serialize();
            var dialog = cargarLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : data,
                success : function (msg) {
                    dialog.modal('hide');
                    var parts = msg.split("_");
                    if(parts[0] === 'ok'){
                        log(parts[1], "success");
                        setTimeout(function () {
                            location.reload();
                        }, 800);
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
        } else {
            return false;
        }
    }




    $(function () {

        // $( "#dlgLoad" ).dialog({
        //     autoOpen: false
        // });

        // $('#tbl').dataTable({
        //     sScrollY: "600px",
        //     bPaginate: false,
        //     bScrollCollapse: true,
        //     bFilter: false,
        //     bSort: false,
        //     oLanguage: {
        //         sZeroRecords: "No se encontraron datos",
        //         sInfo: "",
        //         sInfoEmpty: ""
        //     }
        // });

        $(".btn, .sp").click(function () {
            if ($(this).hasClass("active")) {
                return false;
            }
        });


        // function stopEditing() {
        //     var valor = $("#txt").val();
        //     $("#txt").val("");
        //     $("#txt").hide();
        //     var padre = $("td.editando");
        //     padre.addClass("changed");
        //     padre.html(valor);
        //     padre.addClass("texto");
        //     padre.removeClass("editando");
        // }

        // var txt = $("#txt")

        // $(".cantidad").click(function () {
        //     if ($(this).hasClass("texto")) {
        //         stopEditing();
        //         txt.width($(this).innerWidth() - 25);
        //         var valor = $(this).html().trim();
        //         $(this).html("");
        //         txt.val(valor);
        //         $(this).append(txt);
        //         txt.show();
        //         $(this).removeClass("texto");
        //         txt.focus();
        //         $(this).addClass("editando");
        //         txt.keyup(function (ev) {
        //             if (ev.keyCode == 13) {
        //                 stopEditing();
        //             }
        //         });
        //
        //     }
        // });

        $(".btn-actualizar").click(function () {

            // var data = "";
            // var existe = 0
            //
            // $(".editando").each(function () {
            //     existe = 1
            // });
            //
            // if(existe == 0){
            //     $("#dlgLoad").dialog("open");
            //     $(".editable").each(function () {
            //         var id = $(this).data("id");
            //         var valor = $(this).html().trim();
            //         var data1 = $(this).data("original");
            //
            //         if ((parseFloat(data1) != parseFloat(valor))) {
            //             if (data != "") {
            //                 data += "&";
            //             }
            //             var val = valor ? valor : data1;
            //             data += "item=" + id + "_" + valor;
            //         }
            //     });


                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action: 'actualizaVae')}",
                    data    : data + "&obra=" + ${obra.id},
                    success : function (msg) {
                        $("#dlgLoad").dialog("close");
                        var parts = msg.split("_");
                        var ok = parts[0];
                        var no = parts[1];

                        $(ok).each(function () {
                            var $tdChk = $(this).siblings(".chk");
                            var chk = $tdChk.children("input").is(":checked");
                            if (chk) {
                                $tdChk.html('<i class="icon-ok"></i>');
                            }
                        });
                        // doHighlight({elem : $(ok), clase : "ok"});
                        // doHighlight({elem : $(no), clase : "no"});
                    }
                });
            // }else{
            //     bootbox.alert('<i class="fa fa-exclamation-triangle text-warning fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No se puede guardar, primero cierre el campo que se encuentra en edición actualmente! <br> * Use la tecla Enter sobre el campo en edición" + '</strong>');
            // }
        });
    });
</script>

</body>
</html>