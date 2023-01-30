<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 27/09/21
  Time: 11:32
--%>


<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 10%">Código</th>
        <th style="width: 72%">Descripción</th>
        <th style="width: 8%">Unidad</th>
        <th style="width: 8%">Seleccionar</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 420px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:each in="${data}" var="dt" status="i">
            <tr>
                <td style="width: 9%">${dt.itemcdgo}</td>
                <td style="width: 71%">${dt.itemnmbr}</td>
                <td style="width: 8%">
                    ${dt.unddcdgo}
                </td>
                <td style="width: 8%">
                    <div style="text-align: center" class="selecciona" id="reg_${i}"
                         regNmbr="${dt?.itemnmbr}" regCdgo="${dt?.itemcdgo}"
                         regUn="${dt?.unddcdgo}" data-id="${dt?.item__id}">
                        <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                    </div></td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">
    %{--$(".selecciona").click(function () {--}%
        %{--var ad = $(this).data("id");--}%
        %{--$("#listaRbro").dialog("close");--}%
        %{--$("#spinner").removeClass("hide");--}%
        %{--location.href = "${g.createLink(controller: 'volumenObra', action: 'volObra')}/" + ad--}%
    %{--});--}%
    $(".selecciona").click(function () {
        $("#item_id").val($(this).data("id"));
        $("#item_codigo").val($(this).attr("regCdgo"));
        $("#item_nombre").val($(this).attr("regNmbr"));
        $("#item_unidad").val($(this).attr("regUn"));
        $("#item_cantidad").val(1);
        $("#listaRbro").dialog("close");
    });
</script>