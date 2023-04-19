%{--<html>--}%

%{--<body>--}%

<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">

    <thead>
    <tr>
        <th style="background-color: ${colorProv};">Provincia</th>
        <th style="background-color: ${colorCant};">Cantón</th>
        <th style="background-color: ${colorParr};">Parroquia</th>
        <th style="background-color: ${colorComn};">Comunidad</th>
        <th>Seleccionar</th>
    </tr>
    </thead>

    <tbody>

    <g:each in="${comunidades}" var="comn" status="i">
        <tr>
            <td class="provincia" style="width: 10%">${comn.provnmbr}</td>
            <td class="canton">${comn.cntnnmbr}</td>
            <td class="parroquia">${comn.parrnmbr}</td>
            <td class="comunidad">${comn.cmndnmbr}</td>
            <td style="width: 10%; text-align: center">
                <a href="#" class="btn btn-xs btn-success btnpq" title="Seleccionar"  id="reg_${i}" regId="${comn?.cmnd__id}" parroquia="${comn?.parr__id}"
                   parroquiaN="${comn?.parrnmbr}"
                   canton="${comn?.cntn__id}" comN="${comn?.cmndnmbr}" comunidad="${comn?.cmnd__id}"
                   cantN="${comn?.cntnnmbr}">
                    <i class="fa fa-check"></i>
                </a>
            </td>
        </tr>
    </g:each>
    </tbody>

</table>

<script type="text/javascript">

    $(".btnpq").click(function () {
        var parroquia = $(this).attr("parroquia");
        var canton = $(this).attr("canton");
        var comunidad = $(this).attr("comunidad");

        $("#hiddenParroquia").val($(this).attr("parroquia"));
        $("#parrNombre").val($(this).attr("parroquiaN"));
        $("#hiddenComunidad").val($(this).attr("comunidad"));
        $("#comuNombre").val($(this).attr("comN"));
        $("#hiddenCanton").val($(this).attr("canton"));
        $("#cantNombre").val($(this).attr("cantN"));

        $("#busqueda-geo").dialog("close");

        return false;
    });

</script>

%{--</body>--}%
%{--</html>--}%