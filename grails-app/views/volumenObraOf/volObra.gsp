<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Volumenes de obra
    </title>

    <asset:javascript src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.js"/>
    <asset:stylesheet src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.css"/>
</head>
<body>
<div class="span12">
    <g:if test="${flash.message}">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            ${flash.message}
        </div>
    </g:if>
</div>

<div class="alert alert-info" style="font-size: 14px;">
    Volumen de la obra: ${obra.descripcion + " ("+obra.codigo+")"}
</div>

<div class="col-md-12 btn-group" role="navigation" style="margin-left: 35px;">
    <a href="${g.createLink(controller: 'obraOf', action: 'registroObra', params: [obra: obra?.id])}"
       class="btn btn-info btn-new" id="atras" title="Regresar a la obra">
        <i class="fa fa-arrow-left"></i>
        Regresar
    </a>
    <a href="#" class="btn btn-success btn-new" id="calcular" title="Calcular precios">
        <i class="fa fa-table"></i>
        Calcular
    </a>
</div>

<div id="list-grupo" class="col-md-12" role="main" style="margin-top: 10px;margin-left: 0px">
    <div class="borde_abajo" style="padding-left: 45px;position: relative;">
        <div class="linea" style="height: 98%;"></div>
        <div class="col-md-12" style="margin-left: 0px">
            <div class="col-md-4">
                <b>Memo:</b> ${obra?.memoCantidadObra}
            </div>
            <div class="col-md-4">
                <b>Ubicación:</b> ${obra?.parroquia?.nombre}
            </div>
            <div class="col-md-2" >
                <b style="">Dist. peso:</b> ${obra?.distanciaPeso}
            </div>
            <div class="col-md-2" >
                <b>Dist. volúmen:</b> ${obra?.distanciaVolumen}
            </div>
        </div>
    </div>
    <div class="borde_abajo" style="position: relative;float: left;width: 100%;padding-left: 45px">
        <p class="css-vertical-text">Composición</p>
        <div class="linea" style="height: 98%;"></div>

        <div style="width: 100%;height: 600px;overflow-y: auto;float: right;" id="detalle"></div>
        <div style="width: 100%;height: 30px;overflow-y: auto;float: right;text-align: right" id="total">
            <b>TOTAL:</b> <div id="divTotal" style="width: 150px;float: right;height: 30px;font-weight: bold;font-size: 12px;margin-right: 20px"></div>
        </div>
    </div>
</div>

<script type="text/javascript">


    function cargarTabla(){
        var d = cargarLoader("Cargando...");
        var datos="";
        if($("#subPres_desc").val()*1>0){
            datos = "obra=${obra.id}&sub="+$("#subPres_desc").val()
        }else{
            datos = "obra=${obra.id}"
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
    }
    $(function () {

        cargarTabla();

        $("#vol_id").val("");
        $("#calcular").click(function () {
            if ($(this).hasClass("active")) {
                $(this).removeClass("active");
                $(".col_delete").show();
                $(".col_precio").hide();
                $(".col_total").hide();
                $("#divTotal").html("");
            } else {
                $(this).addClass("active");
                $(".col_delete").hide();
                $(".col_precio").show();
                $(".col_total").show();
                var total =0;
                $(".total").each(function(){
                    total+=parseFloat(str_replace(",","",$(this).html()))
                });
                $("#divTotal").html(number_format(total, 4, ".", " "));
            }
        });


        %{--$("#item_codigo").dblclick(function () {--}%
        %{--    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');--}%
        %{--    $("#modalTitle").html("Lista de rubros");--}%
        %{--    $("#modalFooter").html("").append(btnOk);--}%
        %{--    $("#modal-rubro").modal("show");--}%
        %{--    $("#buscarDialog").unbind("click");--}%
        %{--    $("#buscarDialog").bind("click", enviar);--}%
        %{--});--}%

        %{--$("#item_codigo").blur(function(){--}%
        %{--    if($("#item_id").val()==="" && $("#item_codigo").val()!==""){--}%
        %{--        $.ajax({--}%
        %{--            type : "POST",--}%
        %{--            url : "${g.createLink(controller: 'volumenObra',action:'buscarRubroCodigo')}",--}%
        %{--            data     : "codigo=" + $("#item_codigo").val(),--}%
        %{--            success  : function (msg) {--}%
        %{--                if (msg !=="-1") {--}%
        %{--                    var parts = msg.split("&&");--}%
        %{--                    $("#item_id").val(parts[0]);--}%
        %{--                    $("#item_nombre").val(parts[2])--}%
        %{--                }else{--}%
        %{--                    $("#item_id").val("");--}%
        %{--                    $("#item_nombre").val("");--}%
        %{--                }--}%
        %{--            }--}%
        %{--        });--}%
        %{--    }--}%
        %{--});--}%

        // $("#item_codigo").keydown(function(ev){
        //     if(ev.keyCode*1!=9 && (ev.keyCode*1<37 || ev.keyCode*1>40)){
        //         $("#item_id").val("");
        //         $("#item_nombre").val("")
        //     }else{
        //     }
        // });
    });
</script>
</body>
</html>