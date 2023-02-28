<g:select name="oferta.id" id="ofertas" from="${ofertas}" optionKey="id" optionValue="proveedor" noSelection="['-1': 'Seleccione']" class="required" data-monto="${ofertas.monto}"
          data-plazo="${ofertas.plazo}" optionClass="${{ it.monto + "_" + it.plazo }}"/>

<script type="text/javascript">

    $("#ofertas").change(function () {

        if ($(this).val() !== "-1") {
            var $selected = $("#ofertas option:selected");
            var idOferta = $selected.val();
            $("#contratista").val($selected.text());

            cargarFecha(idOferta);
            cargarIndice(idOferta);

            // var cl = $selected.attr("class");
            // var parts = cl.split("_");
            // var m = parts[0];
            // var p = parts[1];

            var mt = $(this).data("monto");
            var pz = $(this).data("plazo");

            $("#monto").val(mt);
            $("#plazo").val(pz);
            updateAnticipo();
        }
        else {
            $("#contratista").val("");
            $("#fechaPresentacion").val('');
        }
    });

    function  cargarFecha(id) {
        $.ajax({
            type    : "POST",
            url     : "${g.createLink(action:'getFecha')}",
            data    : {
                id : id
            },
            success : function (msg) {
                $("#filaFecha").html(msg);
            }
        });
    }

    function cargarIndice(id) {
        $.ajax({
            type    : "POST",
            url     : "${g.createLink(action:'getIndice')}",
            data    : {
                id : id
            },
            success : function (msg) {
                $("#filaIndice").html(msg);
            }
        });
    }


</script>