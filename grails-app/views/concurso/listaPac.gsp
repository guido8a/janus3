<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 32%">Descripción</th>
        <th style="width: 30%">Departamento</th>
        <th style="width: 30%">Presupuesto</th>
        <th style="width: 7%"></th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 420px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:each in="${data}" var="dt" status="i">
            <tr>
                <td style="width: 32%">${dt.pacpdscr}</td>
                <td style="width: 30%">${dt.dptodscr}</td>
                <td style="width: 30%">${dt.prspdscr}</td>
                <td style="width: 8%">
                    <div style="text-align: center" class="selecciona" data-id="${dt.pacp__id}">
                        <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                    </div></td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">
    $(".selecciona").click(function () {
        var id = $(this).data("id");
        $("#modal-pac").dialog("close");
        var url = "${g.createLink(controller: 'concurso', action: 'nuevoProceso')}/" + id
        location.href = url;
    });

</script>