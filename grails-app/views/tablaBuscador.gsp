<g:if test="${lista?.size() > 0}">
    <div id="divBuscadorTabla">
        <div url="${url}" style="max-width: 200%;${(width) ? 'width:' + width + 'px' : ''}">
            <table id="tablaBuscador" class="table table-bordered table-striped table-condensed table-hover" style="max-width: 100%;width: 100%">
                <thead>
                <g:set var="planilla" value="${["OBRA", "CONTRATO", "DECRIPCION", "FECHA PRESENTACION", "MEMO PAGO", "MONTO"]}"/>
                <g:set var="titulos" value="${listaTitulos}"/>

                <th style="width: 40px"></th>
                <g:each in="${listaTitulos}">
                    <th>${it}</th>
                </g:each>

                </thead>
                <tbody id="paginate">
                <g:each var="reg" in="${lista}" status="i">
                    <g:set var="propiedades" value=""/>
                    <tr style="font-size: 10px !important;">
                        <td style="text-align: right;width: 50px">
                            <g:if test="${planilla != titulos}">
                                <a class="ok btn btn-small btn-success btn-ajax" href="#" rel="tooltip" style="margin-right: 5px"
                                   title="Seleccionar" id="reg_${i}" regId="${reg?.id}" txtReg="${reg.toString()}" ${propiedades}>
                                    <i class="icon-share"></i>
                                </a>
                            </g:if>
                        </td>
                        %{--<elm:ponePropiedades campos="${listaCampos}" objeto="${reg}"/>--}%
                        %{--<g:set var="propiedades" value="${elm.ponePropiedades([campos: listaCampos, objeto: reg])}"/>--}%

                        <g:each in="${listaCampos}" var="nombre" status="j">
                            <g:set var="propiedades" value="${propiedades += " prop_" + nombre + "=" + reg.properties[nombre]}"/>

                            <g:if test="${funciones}">
                                <g:if test="${funciones[j]}">
                                    <g:set var="prop" value="${bsc.operacion(propiedad: nombre, funcion: funciones[j], registro: reg)}"/>
                                </g:if>
                                <g:else>
                                    <g:set var="prop" value="${reg.properties[nombre]}"/>
                                </g:else>
                            </g:if>
                            <g:else>
                                <g:set var="prop" value="${reg.properties[nombre]}"/>
                            </g:else>
                            <td>
                                ${prop}
                            </td>
                        </g:each>
                        <elm:poneSelector campos="${listaCampos}" objeto="${reg}"/>
                        %{--<input type="hidden" class="props" ${propiedades}>--}%
                        <script type="text/javascript">
                            $("#reg_${i}")
                        </script>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>

    <script type="text/javascript">

        var $cont = $("#divBuscadorTabla");
        var $parent = $cont.parents(".modal-body");
        var h = $parent.height();
        var w = $parent.width();
        var oldH = $cont.height();
        var oldW = $cont.width();
        if (oldH > h - 190) {
            $cont.css({
                maxHeight : h - 160,
                overflow  : "auto"
            });
        }
        if (oldW > w - 60) {
            $cont.css({
                maxWidth : w - 50,
                overflow : "auto"
            });
        }

        <g:if test="${funcionJs}">
        <elm:funcionOk funcion="${funcionJs}"/>
        </g:if>
        <g:else>
        $(".ok").click(function () {
            var idReg = $(this).attr("regId");
            var txtReg = $(this).attr("txtReg");
            $("#hidVal").val(idReg);
            $("#txtValor").val(txtReg);
            $(".buscador").dialog("close");

        });
        </g:else>

        function paginar(id, mostrar) {

            var tbody = $("#" + id)
            var num = mostrar
            var rows = tbody.find("tr")
            var cant = rows.size()
            var paginas = Math.ceil(cant / num)
            var i = 0
            var fila
            var padre
            var show = function () {
                var pag = $(this).html()
                var body = $("#" + $(this).attr("body"))
                body.find("tr").addClass("hiden")
                body.find("." + pag).removeClass("hiden").show()
                $(".paginateButon").css("background", "none")
                $(".b" + pag).css("background", "#B2D1FF")
                $(".hiden").hide()

            }

            rows.each(function (i) {
                if (i >= num) {
                    $(this).hide().addClass("hiden " + (Math.ceil((i + 1) / num)))
                } else {
                    $(this).addClass("1")
                }

            });

            padre = tbody.parent().parent()
            fila = $("<div>")
            fila.width(tbody.parent().width() - 10)
            fila.height(20)
            fila.css("padding-left", 5).css("padding-rigth", 5).css("padding-top", 2).css("marginBottom", 15)

            for (i = 0; i < paginas; i++) {
                var boton = $("<div>")
                boton.css({
                    cursor      : "pointer",
                    width       : 15,
                    height      : 20,
                    float       : "left",
                    marginLeft  : 5,
                    border      : "1px solid black",
                    lineHeight  : "20px",
                    paddingLeft : "7px"

                }).html(i + 1).bind("click", show).attr("body", id).addClass("b" + (i + 1) + " paginateButon");
                if (i == 0)
                    boton.css("background", "#B2D1FF")
                fila.append(boton)
            }

            padre.append(fila)

        }

        paginar("paginate", ${(paginas)?paginas:10})

    </script>
</g:if>
<g:else>
    <div class="message" style="margin-left: 40px;width: 85%;margin-bottom: 15px">
        No se encontraron datos. Si está buscando por fechas utilice el formato: dd/MM/aaaa.
    </div>
</g:else>

