<div class="col-md-12" style="margin-left: 0px; margin-top: 15px; margin-bottom: 10px">
    <div class="col-md-6">
        <div class="col-md-3">
            <b>Subpresupuesto:</b>
        </div>
        <div class="col-md-6">
            <g:select name="subpresupuesto" from="${subPres}" optionKey="id" optionValue="descripcion"
                      style="width: 300px;font-size: 10px" id="subPres_desc" value="${subPre}"
                      noSelection="['-1': 'TODOS']" class="form-control"/>
        </div>
    </div>
    <div class="col-md-5">
        <a href="#" class="btn btn-info " id="imprimir_sub">
            <i class="fa fa-print"></i>
            Imprimir Presupuesto
        </a>
        <a href="#" class="btn  btn-primary" id="imprimir_sub_vae">
            <i class="fa fa-print"></i>
            Subpresupuesto VAE
        </a>
        <a href="#" class="btn  btn-success" id="imprimir_excel" >
            <i class="fa fa-file-excel"></i>
            Excel
        </a>
    </div>
</div>
<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
      <tr>
        <th style="width: 20px;">
            #
        </th>
        <th style="width: 200px;">
            Subpresupuesto
        </th>
        <th style="width: 80px;">
            Código
        </th>
        <th style="width: 400px;">
            Rubro
        </th>
        <th style="width: 60px" class="col_unidad">
            Unidad
        </th>
        <th style="width: 80px">
            Cantidad
        </th>
        <th class="col_precio" style="display: none;">Unitario</th>
        <th class="col_total" style="display: none;">C.Total</th>
        %{--<th style="width: 40px" class="col_delete"></th>--}%
    </tr>
    </thead>
    <tbody id="tabla_material">
    <g:each in="${valores}" var="val" status="j">
    <tr class="item_row" id="${val.item__id}" item="${val}" sub="${val.sbpr__id}">
            <td style="width: 20px" class="orden">${val.vlobordn}</td>
            <td style="width: 200px" class="sub">${val.sbprdscr.trim()}</td>
            <td class="cdgo">${val.rbrocdgo.trim()}</td>
            <td class="nombre">${val.rbronmbr.trim()}</td>
            <td style="width: 60px !important;text-align: center" class="col_unidad">${val.unddcdgo.trim()}</td>
            <td style="text-align: right" class="cant">
                <g:formatNumber number="${val.vlobcntd}" format="##,##0" minFractionDigits="2" maxFractionDigits="2"
                                locale="ec"/>
            </td>
            <td class="col_precio" style="display: none;text-align: right" id="i_${val.item__id}"><g:formatNumber
                    number="${val.pcun}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
            <td class="col_total total" style="display: none;text-align: right">
                <g:formatNumber number="${val.totl}" format="##,##0" minFractionDigits="4"  maxFractionDigits="4"  locale="ec"/>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>
<script type="text/javascript">

    $.contextMenu({
        selector: '.item_row',
        callback: function(key, options) {
            if(key==="edit"){
                $(this).dblclick()
            }
            if(key==="print"){
                var clickImprimir = $(this).attr("id");
                var fechaSalida1 = '${obra.fechaOficioSalida?.format('dd-MM-yyyy')}';
                var datos = "?fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}&id=" + clickImprimir + "&obra=${obra.id}" + "&fechaSalida=" + fechaSalida1+ "&oferente=${session.usuario.id}";
                location.href = "${g.createLink(controller: 'reportes6',action: '_imprimirRubroVolObraOferente')}" + datos
            }
            if(key==="vae"){
                var clickImprimir = $(this).attr("id");
                var fechaSalida1 = '${obra.fechaOficioSalida?.format('dd-MM-yyyy')}';
                var datos = "?fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}&id=" + clickImprimir + "&obra=${obra.id}" + "&fechaSalida=" + fechaSalida1+ "&oferente=${session.usuario.id}"
                location.href = "${g.createLink(controller: 'reportes6',action: '_imprimirRubroVolObraVaeOferente')}" + datos
            }

            %{--if (key === "foto") {--}%
            %{--    var datosFoto = "Wid=" + $(this).attr("item")--}%
            %{--    var child = window.open('${createLink(controller:"rubro", action:"showFoto")}/' + $(this).attr("item") +--}%
            %{--            '?tipo=il', 'GADPP', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');--}%
            %{--    if (child.opener == null)--}%
            %{--        child.opener = self;--}%
            %{--    window.toolbar.visible = false;--}%
            %{--    window.menubar.visible = false;--}%
            %{--}--}%

            %{--if (key === "espc") {--}%
            %{--    var child = window.open('${createLink(controller:"rubro", action:"showFoto")}/' + $(this).attr("item") +--}%
            %{--            '?tipo=dt', 'GADPP', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');--}%
            %{--    if (child.opener == null)--}%
            %{--        child.opener = self;--}%
            %{--    window.toolbar.visible = false;--}%
            %{--    window.menubar.visible = false;--}%
            %{--}--}%
        },
        items: {
//            "edit": {name: "Editar", icon: "edit"},
            "print": {name: "Imprimir", icon: "print"},
            "vae": {name: "Imprimir Vae", icon: "print"},
            // "foto": {name: "Ilustración", icon: "doc"},
            // "espc": {name: "Especificaciones", icon: "doc"}
        }
    });

    $("#imprimir_sub").click(function(){
        if ($("#subPres_desc").val() !== '') {
            location.href = "${g.createLink(controller: 'reportes6',action: '_imprimirTablaSubOferente')}?obra=" + "${obra.id}&sub=" +  $("#subPres_desc").val() + "&oferente=" + ${session.usuario.id};
        } else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un subpresupuesto" + '</strong>');
        }

    });

    $("#imprimir_sub_vae").click(function(){
        if ($("#subPres_desc").val() !== '') {
            location.href = "${g.createLink(controller: 'reportes6',action: '_imprimirTablaSubVaeOferente')}?obra=" + "${obra.id}&sub=" +  $("#subPres_desc").val() + "&oferente=" + ${session.usuario.id};
        } else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un subpresupuesto" + '</strong>');
        }
    });

    $("#imprimir_excel").click(function () {
        location.href = "${g.createLink(controller: 'reportesExcel2',action: 'reporteExcelVolObraOferente')}?id=" + ${obra?.id} + "&sub=" + $("#subPres_desc").val() + "&oferente=" + ${session.usuario.id};
    });


    $("#subPres_desc").change(function () {

        var d = cargarLoader("Cargando...");

        $("#ver_todos").removeClass("active");
        $("#divTotal").html("");
        $("#calcular").removeClass("active");
        var datos = '';

        if($("#subPres_desc").val() === '-1'){
            datos = "obra=${obra.id}"
        } else {
            datos = "obra=${obra.id}&sub=" + $("#subPres_desc").val() + "&ord=" + 1
        }

        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'volumenObraOf',action:'tabla')}",
            data     : datos,
            success  : function (msg) {
                d.modal("hide");
                $("#detalle").html(msg)
            }
        });
    });

    $(".item_row").dblclick(function(){
        $("#calcular").removeClass("active");
        $(".col_precio").hide();
        $(".col_total").hide();
        $("#divTotal").html("");
        $("#vol_id").val($(this).attr("id"));
        $("#item_codigo").val($(this).find(".cdgo").html());
        $("#item_id").val($(this).attr("item"));
        $("#subPres").val($(this).attr("sub"));
        $("#item_nombre").val($(this).find(".nombre").html());
        $("#item_cantidad").val($(this).find(".cant").html().toString().trim());
        $("#item_orden").val($(this).find(".orden").html());

    });


</script>