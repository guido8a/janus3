<%@ page import="utilitarios.reportesService" %>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:each in="${obras}" var="obra" status="j">
            <tr class="obra_row" id="${obra.obra__id}">
                <td>${obra.obracdgo}</td>
                <td>${obra.obranmbr}</td>
                <td>${obra.tpobdscr}</td>
                <td><g:formatDate date="${obra.obrafcha}" format="dd-MM-yyyy"/></td>
                <td>${obra.cntnnmbr} - ${obra.parrnmbr} - ${obra.cmndnmbr}</td>
                <td>${obra.obravlor}</td>
                <td>${obra.dptodscr}</td>
                <td>${obra.obrarefe}</td>
                <td>${obra.estado}</td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">

    var checkeados = [];

    $("#buscar").click(function(){
        var c = cargarLoader("Cargando...");
        var datos = "si=${"si"}&buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() +
            "&operador=" + $("#oprd").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4',action:'tablaPresupuestadas')}",
            data     : datos,
            success  : function (msg) {
                c.modal("hide");
                $("#detalle").html(msg)
            }
        });
    });

    $("#regresar").click(function () {
        location.href = "${g.createLink(controller: 'reportes', action: 'index')}"
    });

    $("#imprimir").click(function () {
        location.href = "${g.createLink(controller: 'reportes4', action:'reportePresupuestadas' )}?buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() + "&operador=" + $("#oprd").val()
    });

    $("#excel").click(function () {
        location.href = "${g.createLink(controller: 'reportesExcel', action:'reporteExcelPresupuestadas' )}?buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() + "&operador=" + $("#oprd").val()
    });

    $("#buscador_con").change(function(){
        var anterior = "${params.operador}";
        var opciones = $(this).find("option:selected").attr("class").split(",");
        poneOperadores(opciones);
        /* regresa a la opción seleccionada */
        // $("#oprd option[value=" + anterior + "]").prop('selected', true);
    });


    function poneOperadores (opcn) {
        var $sel = $("<select name='operador' id='oprd' style='width: 160px'}>");
        for(var i=0; i<opcn.length; i++) {
            var opt = opcn[i].split(":");
            var $opt = $("<option value='"+opt[0]+"'>"+opt[1]+"</option>");
            $sel.append($opt);
        }
        $("#selOpt").html($sel);
    }

    /* inicializa el select de oprd con la primea opción de busacdor */
    $( document ).ready(function() {
        $("#buscador_con").change();
    });

    $.contextMenu({
        selector: '.obra_row',
        callback: function (key, options) {

            var m = "clicked: " + $(this).attr("id");
            var idFila = $(this).attr("id");

            if(key === "registro"){
                location.href = "${g.createLink(controller: 'obra', action: 'registroObra')}" + "?obra=" + idFila;
            }
        },
        items: {
            "registro": {name: "Ir al Registro de esta Obra", icon:"info"}
        }
    });

</script>