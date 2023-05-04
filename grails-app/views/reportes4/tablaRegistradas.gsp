<style type="text/css">
table {
    table-layout: fixed;
    overflow-x: scroll;
}
th, td {
    overflow: hidden;
    text-overflow: ellipsis;
    word-wrap: break-word;
}
</style>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">

        <g:each in="${obras}" var="obra" status="j">
            <tr class="obra_row" id="${obra.obra__id}">
                <td style="width: 10% !important;">${obra.obracdgo}</td>
                <td style="width: 25% !important;">${obra.obranmbr}</td>
                <td style="width: 13% !important;">${obra.tpobdscr}</td>
                <td style="width: 8% !important;"><g:formatDate date="${obra.obrafcha}" format="dd-MM-yyyy"/></td>
                <td style="width: 21% !important;">${obra.cntnnmbr} - ${obra.parrnmbr} - ${obra.cmndnmbr}</td>
                <td style="text-align: right; width: 9% !important;">${obra.obravlor}</td>
                <td style="width: 16% !important;">${obra.dptodscr}</td>
                <td style="width: 11% !important;">${obra.obrarefe}</td>
                <g:if test="${obras?.size() < 9}">
                    <td style="width: 9% !important;">${obra.estado}</td>
                    <td style="width: 1%"></td>
                </g:if>
                <g:else>
                    <td style="width: 10% !important;">${obra.estado}</td>
                </g:else>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">

    var checkeados = [];

    $("#buscar").click(function(){
        var datos = "si=${"si"}&buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() +
            "&operador=" + $("#oprd").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4',action:'tablaRegistradas')}",
            data     : datos,
            success  : function (msg) {
                $("#detalle").html(msg);
            }
        });
    });

    $("#regresar").click(function () {
        location.href = "${g.createLink(controller: 'reportes', action: 'index')}"
    });

    $("#imprimir").click(function () {
        location.href = "${g.createLink(controller: 'reportes4', action:'reporteRegistradas' )}?buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() + "&operador=" + $("#oprd").val()
    });

    $("#excel").click(function () {
        location.href = "${g.createLink(controller: 'reportesExcel', action:'reporteRegistradasExcel' )}?buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() + "&operador=" + $("#oprd").val()
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

            if (key === "print") {
                var datos = "?obra="+idFila+"&sub="+${-1};
                location.href = "${g.createLink(controller: 'reportes3',action: '_imprimirTablaSub' )}" + datos;
            }
        },
        items: {
            "registro": {name: "Ir al Registro de esta Obra", icon:"info"},
            "print": {name: "Imprimir Subpresupuesto", icon: "print"
            }
        }

    });

</script>