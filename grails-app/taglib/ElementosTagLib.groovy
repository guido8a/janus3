import janus.NumberToLetterConverter
import janus.Obra
import janus.ejecucion.Planilla
import org.springframework.beans.SimpleTypeConverter
import org.springframework.context.MessageSourceResolvable
import org.springframework.web.servlet.support.RequestContextUtils
import seguridad.Persona

import java.text.DecimalFormatSymbols

class ElementosTagLib {

    static namespace = "elm"

    /**
     * crea un div para el not found (con el fantasmita)
     */
    def notFound = { attrs ->
        def elem = attrs.elem ?: "elemento"
        def genero = attrs.genero ?: "o"
        def mensaje = attrs.mensaje ?: "No se encontró ${genero == 'o' ? 'el' : 'la'} ${elem} solicitad${genero}."
        def html = ""
        html += '<div class="text-info text-center not-found">'
        html += '<i class="icon-ghost fa-6x pull-left text-shadow"></i>'
        html += '<p>' + mensaje + '</p>'
        html += '</div>'
        out << html
    }

    /**
     * crea el div para el flash message
     */
    def flashMessage = { attrs, body ->
        def contenido = body()
        if (!contenido) {
            if (attrs.contenido) {
                contenido = attrs.contenido
            }
        }

        if (contenido) {
            def finHtml = "</p></div>"

            def html = "<div class=\"alert ${attrs.tipo?.toLowerCase() == 'error' ? 'alert-danger' : attrs.tipo?.toLowerCase() == 'success' ? 'alert-success' : 'alert-info'} ${attrs.clase}\">"
            if (!attrs.dismissable || attrs.dismissable == true || attrs.dismissable.toString() == "1") {
                html += "<button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-hidden=\"true\">&times;</button>"
            }

            if (attrs.icon) {
                html += "<i class=\"${attrs.icon} fa-2x pull-left iconMargin\"></i> "
            } else {
                if (attrs.tipo?.toLowerCase() == 'error') {
                    html += "<i class=\"fa fa-warning fa-2x pull-left iconMargin\"></i> "
                } else if (attrs.tipo?.toLowerCase() == 'success') {
                    html += "<i class=\"fa fa-check-square fa-2x pull-left iconMargin\"></i> "
                } else if (attrs.tipo?.toLowerCase() == 'notfound') {
                    html += "<i class=\"icon-ghost fa-2x pull-left iconMargin\"></i> "
                }
            }
            html += "<p>"
            out << html << contenido << finHtml
        } else {
            out << ""
        }
    }

    /**
     * pone el favicon
     */
    def favicon = { attrs ->
        def html = "<link rel=\"shortcut icon\" href=\"${assetPath(src: 'favicon.ico')}\" type=\"image/x-icon\">"
        html += "<link rel=\"apple-touch-icon\" href=\"${assetPath(src: 'apple-touch-icon.png')}\">"
        html += "<link rel=\"apple-touch-icon\" sizes=\"114x114\" href=\"${assetPath(src: 'apple-touch-icon-retina.png')}\">"
        out << html
    }


    def bootstrapCss = { attrs ->
        def html = "<link href=\"${resource(dir: 'bootstrap-3.1.1/css', file: 'bootstrap.css')}\" rel=\"stylesheet\">"
        html += "<link href=\"${resource(dir: 'bootstrap-3.1.1/css', file: 'bootstrap-theme.min.css')}\" rel=\"stylesheet\">"
        out << html
    }

    def bootstrapJs = { attrs ->
        def html = "<script src=\"${resource(dir: 'bootstrap-3.1.1/js', file: 'bootstrap.min.js')}\"></script>"
        out << html
    }

    /**
     * marca el texto encontrado en el texto:
     *      se puede usar con o sin body
     *          <elm:textoBusqueda busca="busca">Texto donde buscar "busca"</textoBusqueda>
     *          <elm:textoBusqueda busca="busca" contenido='Texto donde buscar "busca"'/>
     *
     *          params:
     *              busca/search                            el texto a buscar y subrayar si se encuentra
     *              contenido/texto/text/body del tag       el texto donde buscar
     */
    def textoBusqueda = { attrs, body ->
        def texto = body()

        def busca
        if (attrs.search) {
            busca = attrs.search
        } else if (attrs.busca) {
            busca = attrs.busca
        }

        if (!texto) {
            if (attrs.contenido) {
                texto = attrs.contenido
            }
            if (attrs.text) {
                texto = attrs.text
            }
            if (attrs.texto) {
                texto = attrs.texto
            }
        }

        try {
            texto = texto.toString().replaceAll("(?iu)" + busca) {
                "<span class='found'>" + it + "</span>"
            }
        } catch (e) {
            println "textoBusqueda" + e
        }

        out << texto
    }

    /**
     * pone un contenedor vertical u horizontal
     * Ejemplo de como usar en asignacion/asignacionProyectov2
     * @param tipo es el tipo de container, puede ser vertica u horizontal
     * @param border indica si el container debe tener borde
     * @param style cualqueir estilo para el container
     * @param linea indica si debe llevar o no linea bajo el título
     * @param color es el color del título
     * @param titulo un String con el título del container
     */

    def container = { attrs, body ->
        def tipo = attrs.tipo
        def clase = ""
        def titulo = ""

        if (tipo == "vertical") {
            clase = "vertical-container ${attrs.border ? 'bordered ui-corner-all' : ''}"
            titulo = '<div class="css-vertical-text" style="color:' + attrs.color + '">' + attrs.titulo + '</div>'
            if (!attrs.linea) {
                titulo += '<div class="linea"></div>'
            }
        } else {
            clase = "horizontal-container ${attrs.border ? 'bordered ui-corner-all' : ''}"
            titulo = '<div class="titulo-azul"  style="color:' + attrs.color + '">' + attrs.titulo + '</div>'
        }

        def html = ""
        html += '<div class="' + clase + '" style="' + attrs.style + ';padding-bottom: 10px">'
        html += titulo
        out << html << body() + "</div>"
    }


    /**
     * crea un datepicker
     *  attrs:
     *      class           clase
     *      name            name
     *      id              id (opcional, si no existe usa el mismo name)
     *      value           value (groovy Date o String)
     *      format          format para el Date (groovy)
     *      minDate         fecha mínima para el datepicker. cualquier cosa anterior se deshabilita
     *                          ej: +5d para 5 días después de la fecha actual
     *      maxDate         fecha máxima para el datepicker. cualquier cosa posterior se deshabilita
     *      orientation     String. Default: “auto”
     *                               A space-separated string consisting of one or two of “left” or “right”, “top” or “bottom”, and “auto” (may be omitted);
     *                                      for example, “top left”, “bottom” (horizontal orientation will default to “auto”), “right” (vertical orientation will default to “auto”),
     *                                      “auto top”. Allows for fixed placement of the picker popup.
     *                               “orientation” refers to the location of the picker popup’s “anchor”; you can also think of it as the location of the trigger element (input, component, etc)
     *                               relative to the picker.
     *                               “auto” triggers “smart orientation” of the picker.
     *                                  Horizontal orientation will default to “left” and left offset will be tweaked to keep the picker inside the browser viewport;
     *                                  vertical orientation will simply choose “top” or “bottom”, whichever will show more of the picker in the viewport.
     *      autoclose       boolean. default: true cierra automaticamente el datepicker cuando se selecciona una fecha
     *      todayHighlight  boolean. default: true marca la fecha actual
     *      beforeShowDay   funcion. funcion que se ejecuta antes de mostrar el día. se puede utilizar para deshabilitar una fecha en particular
     *                          ej:
     *                               beforeShowDay: function (date){*                                   if (date.getMonth() == (new Date()).getMonth())
     *                                       switch (date.getDate()){*                                           case 4:
     *                                               return {*                                                   tooltip: 'Example tooltip',
     *                                                   classes: 'active'
     *};
     *                                           case 8:
     *                                               return false;
     *                                           case 12:
     *                                               return "green";
     *}*}*                                }
     *      onChangeDate    funcion. funcion q se ejecuta al cambiar una fecha. se manda solo el nombre, sin parentesis, como parametro recibe el datepicker y el objeto
     *                          ej: onChangeDate="miFuncion"
     *                          function miFuncion($elm, e) {*                              console.log($elm); //el objeto jquery del datepicker, el textfield
     *                              console.log(e); //el objeto que pasa el plugin
     *}*      daysOfWeekDisabled  lista de números para deshabilitar ciertos días: 0:domingo, 1:lunes, 2:martes, 3:miercoles, 4:jueves, 5:viernes, 6:sabado
     *      img             imagen del calendario. clase de glyphicons o font awsome
     **/
    def  datepicker = { attrs ->
        def name = attrs.name
        def nameInput = name + "_input"
        def nameHiddenDay = name + "_day"
        def nameHiddenMonth = name + "_month"
        def nameHiddenYear = name + "_year"
        def id = nameInput
        if (attrs.id) {
            id = attrs.id
        }
        def readonly = attrs.readonly ?: true
        def value = attrs.value

        def clase = attrs["class"]

        def extra = attrs.extra ?: ""

        def format = attrs.format ?: "dd-MM-yyyy"
        def formatJS = attrs.formatJS ?: format.replaceAll("M", "m")

        def startDate = attrs.minDate ?: false
        def endDate = attrs.maxDate ?: false

        def orientation = attrs.orientation ?: "top auto"

        def autoclose = attrs.autoclose ?: true
        def todayHighlight = attrs.todayHighlight ?: true

        def beforeShowDay = attrs.beforeShowDay ?: false
        def onChangeDate = attrs.onChangeDate ?: false

        def daysOfWeekDisabled = attrs.daysOfWeekDisabled ?: false

        def img = attrs.img ?: "fa fa-calendar"

        if (value instanceof Date) {
            value = value.format(format)
        }
        if (!value) {
            value = ""
        }

        def valueDay = "", valueMonth = "", valueYear = ""
        if (value != "") {
            def parts = value.split("-")
            valueDay = parts[0]
            valueMonth = parts[1]
            valueYear = parts[2]
        }

        def br = "\n"

        def textfield = "<input type='text' name='${nameInput}' id='${id}' " + (readonly ? "readonly=''" : "") + " value='${value}' class='${clase}' ${extra} />"
        def hiddenDay = "<input type='hidden' name='${nameHiddenDay}' id='${nameHiddenDay}' value='${valueDay}'/>"
        def hiddenMonth = "<input type='hidden' name='${nameHiddenMonth}' id='${nameHiddenMonth}' value='${valueMonth}'/>"
        def hiddenYear = "<input type='hidden' name='${nameHiddenYear}' id='${nameHiddenYear}' value='${valueYear}'/>"
        def hidden = "<input type='hidden' name='${name}' id='${name}' value='date.struct'/>"

        def div = ""
        div += hiddenDay + br
        div += hiddenMonth + br
        div += hiddenYear + br
        div += hidden + br
        div += "<div class='input-group'>" + br
        div += textfield + br
        div += "<span class=\"input-group-addon\"><i class=\"${img}\"></i></span>" + br
        div += "</div>" + br

        def js = "<script type=\"text/javascript\">" + br
        js += '$("#' + id + '").datepicker({' + br
        if (startDate) {
            js += "startDate: '${startDate}'," + br
        }
        if (endDate) {
            js += "endDate: '${endDate}'," + br
        }
        if (daysOfWeekDisabled) {
            js += "daysOfWeekDisabled: '${daysOfWeekDisabled}'," + br
        }
        if (beforeShowDay) {
//            js += "beforeShowDay: function() { ${beforeShowDay}() }," + br
            js += "beforeShowDay: ${beforeShowDay}," + br
        }
        js += 'language: "es",' + br
        js += "format: '${formatJS}'," + br
        js += "orientation: '${orientation}'," + br
        js += "autoclose: ${autoclose}," + br
        js += "todayHighlight: ${todayHighlight}" + br
        js += "}).on('changeDate', function(e) {" + br
        js += "var fecha = e.date;" + br
        js += "if(fecha) {" + br
        js += '$("#' + nameHiddenDay + '").val(fecha.getDate());' + br
        js += '$("#' + nameHiddenMonth + '").val(fecha.getMonth() + 1);' + br
        js += '$("#' + nameHiddenYear + '").val(fecha.getFullYear());' + br
        js += '$(e.currentTarget).parents(".grupo").removeClass("has-error").find("label.help-block").hide();' + br
        js += "}" + br
        if (onChangeDate) {
            js += onChangeDate + "(\$(this), e);"
        }
        js += "});" + br
        js += "</script>" + br

        out << div
        out << js
    }

    /**
     * hace la paginacion para una lista
     *  attrs:
     *          total       la cantidad total que tiene la tabla (el total de todas las páginas)
     *          maxPag      la cantidad máxima de páginas a mostrar. default: 10:       1 2 3 4 5 6 7 8 9 10 11 ... 20
     *          controller  controller para los links (si es diferente al actual)
     *          action      action para los links (si es diferente al actual)
     *          params      los parametros del link
     *                          max         cantidad máxima de registros por página
     *                          offset      el offset
     *                          sort        el ordenamiento
     *                          order       el sentido del ordenamiento
     *
     */
    def pagination = { attrs ->
//        println attrs

        if (attrs.total == null) {
            throwTagError("Tag [paginate] is missing required attribute [total]")
        }

        def maxPag = params.maxPag ?: 10

        def params = attrs.params

        def total = attrs.total
        def max = params.max ? params.max.toInteger() : 10
        def offset = params.offset ? params.offset.toInteger() : 0

        def curPag = (offset / max) + 1

        def paginas = Math.ceil(total / max).toInteger()

        def action = (attrs.action ? attrs.action : (params.action ? params.action : "list"))

        def linkParams = [:]
        if (attrs.params) {
            linkParams.putAll(attrs.params)
        }
//        linkParams.offset = offset - max
        linkParams.max = max
        if (params.sort) {
            linkParams.sort = params.sort
        }
        if (params.order) {
            linkParams.order = params.order
        }

        def linkTagAttrs = [action: action]
        if (attrs.controller) {
            linkTagAttrs.controller = attrs.controller
        }
        if (attrs.id != null) {
            linkTagAttrs.id = attrs.id
        }
        if (attrs.fragment != null) {
            linkTagAttrs.fragment = attrs.fragment
        }
        linkTagAttrs.params = linkParams

        def html = "<div class='row text-center'><ul class='pagination'>"

//        println "total: " + total + " max: " + max + " paginas: " + paginas + " curPag: " + curPag

        def firstPag, lastPag, link

        if (paginas > maxPag + 2) {
            firstPag = (curPag - Math.ceil(maxPag / 2)).toInteger()
            if (firstPag < 2) {
                firstPag = 2
            }
            lastPag = (curPag + Math.ceil(maxPag / 2)).toInteger()
            if (lastPag > paginas - 1) {
                lastPag = paginas - 1
            }
            def t = lastPag - firstPag
            if (t <= maxPag) {
                def extra = maxPag - t - 1
                lastPag += extra
                if (lastPag > paginas - 1) {
                    lastPag = paginas - 1
                }
            }
        } else {
            firstPag = 2
            lastPag = paginas - 1
        }

        def clase = curPag == 1 ? "active" : ""

        if (clase == "") {
//            params.offset = offset - max
//            link = createLink(action: action, params: params)

            linkParams.offset = offset - max
            link = createLink(linkTagAttrs.clone())

            html += "<li><a href='${link}'>&laquo;</a></li>"
        }

        html += "<li class='${clase}'>"
//        params.offset = 0
//        link = createLink(action: action, params: params)
        linkParams.offset = 0
        link = createLink(linkTagAttrs.clone())
        html += clase == 'active' ? "<span>1</span>" : "<a href='${link}'>1</a>"
        html += "</li>"

        if (firstPag > 2) {
            html += "<li class='disabled'><span>...</span></li>"
        }

        for (def i = firstPag; i <= lastPag; i++) {
//            params.offset = (i - 1) * max
//            link = createLink(action: action, params: params)
            linkParams.offset = (i - 1) * max
            link = createLink(linkTagAttrs.clone())
            clase = curPag == i ? "active" : ""
            html += "<li class='${clase}'>"
            html += clase == 'active' ? "<span>${i}</span>" : "<a href='${link}'>${i}</a>"
            html += "</li>"
        }

        if (lastPag < paginas - 1) {
            html += "<li class='disabled'><span>...</span></li>"
        }

        if (paginas > 1) {
            clase = curPag == paginas ? "active" : ""
//            params.offset = (paginas - 1) * max
//            link = createLink(action: action, params: params)
            linkParams.offset = (paginas - 1) * max
            link = createLink(linkTagAttrs.clone())
            html += "<li class='${clase}'>"
            html += clase == 'active' ? "<span>${paginas}</span>" : "<a href='${link}'>${paginas}</a>"
            html += "</li>"
            if (clase == "") {
//                params.offset = offset + max
//                link = createLink(action: action, params: params)
                linkParams.offset = offset + max
                link = createLink(linkTagAttrs.clone())
                html += "<li><a href='${link}'>&raquo;</a></li>"
            }
        }

        html += "</ul></div>"

        out << html
    }

    /**
     * A helper tag for creating HTML selects.<br/>
     *
     * Examples:<br/>
     * &lt;g:select name="user.age" from="${18..65}" value="${age}" /&gt;<br/>
     * &lt;g:select name="user.company.id" from="${Company.list()}" value="${user?.company.id}" optionKey="id" /&gt;<br/>
     *
     * @emptyTag
     *
     * @attr name REQUIRED the select name
     * @attr id the DOM element id - uses the name attribute if not specified
     * @attr from REQUIRED The list or range to select from
     * @attr keys A list of values to be used for the value attribute of each "option" element.
     * @attr optionKey By default value attribute of each &lt;option&gt; element will be the result of a "toString()" call on each element. Setting this allows the value to be a bean property of each element in the list.
     * @attr optionValue By default the body of each &lt;option&gt; element will be the result of a "toString()" call on each element in the "from" attribute list. Setting this allows the value to be a bean property of each element in the list.
     * @attr optionClass permite setear una clase individualmente a cada option
     * @attr value The current selected value that evaluates equals() to true for one of the elements in the from list.
     * @attr multiple boolean value indicating whether the select a multi-select (automatically true if the value is a collection, defaults to false - single-select)
     * @attr valueMessagePrefix By default the value "option" element will be the result of a "toString()" call on each element in the "from" attribute list. Setting this allows the value to be resolved from the I18n messages. The valueMessagePrefix will be suffixed with a dot ('.') and then the value attribute of the option to resolve the message. If the message could not be resolved, the value is presented.
     * @attr noSelection A single-entry map detailing the key and value to use for the "no selection made" choice in the select box. If there is no current selection this will be shown as it is first in the list, and if submitted with this selected, the key that you provide will be submitted. Typically this will be blank - but you can also use 'null' in the case that you're passing the ID of an object
     * @attr disabled boolean value indicating whether the select is disabled or enabled (defaults to false - enabled)
     * @attr readonly boolean value indicating whether the select is read only or editable (defaults to false - editable)
     */
    Closure select = { attrs ->
        if (!attrs.name) {
            throwTagError("Tag [select] is missing required attribute [name]")
        }
        if (!attrs.containsKey('from')) {
            throwTagError("Tag [select] is missing required attribute [from]")
        }
        def messageSource = grailsAttributes.getApplicationContext().getBean("messageSource")
        def locale = RequestContextUtils.getLocale(request)
        def writer = out
        def from = attrs.remove('from')
        def keys = attrs.remove('keys')
        def optionKey = attrs.remove('optionKey')
        def optionValue = attrs.remove('optionValue')
        def optionClass = attrs.remove('optionClass')
        def value = attrs.remove('value')
        if (value instanceof Collection && attrs.multiple == null) {
            attrs.multiple = 'multiple'
        }
        if (value instanceof CharSequence) {
            value = value.toString()
        }
        def valueMessagePrefix = attrs.remove('valueMessagePrefix')
        def classMessagePrefix = attrs.remove('classMessagePrefix')
        def noSelection = attrs.remove('noSelection')
        if (noSelection != null) {
            noSelection = noSelection.entrySet().iterator().next()
        }
        booleanToAttribute(attrs, 'disabled')
        booleanToAttribute(attrs, 'readonly')

        writer << "<select "
        // process remaining attributes
        outputAttributes(attrs, writer, true)

        writer << '>'
        writer.println()

        if (noSelection) {
            renderNoSelectionOptionImpl(writer, noSelection.key, noSelection.value, value)
            writer.println()
        }

        // create options from list
        if (from) {
            from.eachWithIndex { el, i ->
                def keyValue = null
                writer << '<option '
                if (keys) {
                    keyValue = keys[i]
                    writeValueAndCheckIfSelected(keyValue, value, writer)
                } else if (optionKey) {
                    def keyValueObject = null
                    if (optionKey instanceof Closure) {
                        keyValue = optionKey(el)
                    } else if (el != null && optionKey == 'id' && grailsApplication.getArtefact(DomainClassArtefactHandler.TYPE, el.getClass().name)) {
                        keyValue = el.ident()
                        keyValueObject = el
                    } else {
                        keyValue = el[optionKey]
                        keyValueObject = el
                    }
                    writeValueAndCheckIfSelected(keyValue, value, writer, keyValueObject)
                } else {
                    keyValue = el
                    writeValueAndCheckIfSelected(keyValue, value, writer)
                }

                /** **********************************************************************************************************************************************************/
                if (optionClass) {
                    if (optionClass instanceof Closure) {
                        writer << "class='" << optionClass(el).toString().encodeAsHTML() << "'"
                    } else {
                        writer << "class='" << el[optionClass].toString().encodeAsHTML() << "'"
                    }
                } else if (el instanceof MessageSourceResolvable) {
                    writer << "class='" << messageSource.getMessage(el, locale) << "'"
                } else if (classMessagePrefix) {
                    def message = messageSource.getMessage("${classMessagePrefix}.${keyValue}", null, null, locale)
                    if (message != null) {
                        writer << "class='" << message.encodeAsHTML() << "'"
                    } else if (keyValue && keys) {
                        def s = el.toString()
                        if (s) {
                            writer << "class='" << s.encodeAsHTML() << "'"
                        }
                    } else if (keyValue) {
                        writer << "class='" << keyValue.encodeAsHTML() << "'"
                    } else {
                        def s = el.toString()
                        if (s) {
                            writer << "class='" << s.encodeAsHTML() << "'"
                        }
                    }
                } else {
                    def s = el.toString()
                    if (s) {
                        writer << "class='" << s.encodeAsHTML() << "'"
                    }
                }
                /** **********************************************************************************************************************************************************/

                writer << '>'
                if (optionValue) {
                    if (optionValue instanceof Closure) {
                        writer << optionValue(el).toString().encodeAsHTML()
                    } else {
                        writer << el[optionValue].toString().encodeAsHTML()
                    }
                } else if (el instanceof MessageSourceResolvable) {
                    writer << messageSource.getMessage(el, locale)
                } else if (valueMessagePrefix) {
                    def message = messageSource.getMessage("${valueMessagePrefix}.${keyValue}", null, null, locale)
                    if (message != null) {
                        writer << message.encodeAsHTML()
                    } else if (keyValue && keys) {
                        def s = el.toString()
                        if (s) {
                            writer << s.encodeAsHTML()
                        }
                    } else if (keyValue) {
                        writer << keyValue.encodeAsHTML()
                    } else {
                        def s = el.toString()
                        if (s) {
                            writer << s.encodeAsHTML()
                        }
                    }
                } else {
                    def s = el.toString()
                    if (s) {
                        writer << s.encodeAsHTML()
                    }
                }
                writer << '</option>'
                writer.println()
            }
        }
        // close tag
        writer << '</select>'
    }

    /********************************************************* funciones ******************************************************/

    /**
     * renders attributes in HTML compliant fashion returning them in a string
     */
    String renderAttributes(attrs) {
        def ret = ""
        attrs.remove('tagName') // Just in case one is left
        attrs.each { k, v ->
            ret += k
            ret += '="'
            if (v) {
                ret += v.encodeAsHTML()
            } else {
                ret += ""
            }
            ret += '" '
        }
        return ret
    }

    /**
     * Some attributes can be defined as Boolean values, but the html specification
     * mandates the attribute must have the same value as its name. For example,
     * disabled, readonly and checked.
     */
    private void booleanToAttribute(def attrs, String attrName) {
        def attrValue = attrs.remove(attrName)
        // If the value is the same as the name or if it is a boolean value,
        // reintroduce the attribute to the map according to the w3c rules, so it is output later
        if (Boolean.valueOf(attrValue) ||
                (attrValue instanceof String && attrValue?.equalsIgnoreCase(attrName))) {
            attrs.put(attrName, attrName)
        } else if (attrValue instanceof String && !attrValue?.equalsIgnoreCase('false')) {
            // If the value is not the string 'false', then we should just pass it on to
            // keep compatibility with existing code
            attrs.put(attrName, attrValue)
        }
    }

    /**
     * Dump out attributes in HTML compliant fashion.
     */
    void outputAttributes(attrs, writer, boolean useNameAsIdIfIdDoesNotExist = false) {
        attrs.remove('tagName') // Just in case one is left
        attrs.each { k, v ->
            writer << k
            writer << '="'
            writer << v.encodeAsHTML()
            writer << '" '
        }
        if (useNameAsIdIfIdDoesNotExist) {
            outputNameAsIdIfIdDoesNotExist(attrs, writer)
        }
    }

    Closure renderNoSelectionOption = { noSelectionKey, noSelectionValue, value ->
        renderNoSelectionOptionImpl(out, noSelectionKey, noSelectionValue, value)
    }

    def renderNoSelectionOptionImpl(out, noSelectionKey, noSelectionValue, value) {
        // If a label for the '--Please choose--' first item is supplied, write it out
        out << "<option value=\"${(noSelectionKey == null ? '' : noSelectionKey)}\"${noSelectionKey == value ? ' selected="selected"' : ''}>${noSelectionValue.encodeAsHTML()}</option>"
    }

    private outputNameAsIdIfIdDoesNotExist(attrs, out) {
        if (!attrs.containsKey('id') && attrs.containsKey('name')) {
            out << 'id="'
            out << attrs.name?.encodeAsHTML()
            out << '" '
        }
    }


    private writeValueAndCheckIfSelected(keyValue, value, writer) {
        writeValueAndCheckIfSelected(keyValue, value, writer, null)
    }

    private writeValueAndCheckIfSelected(keyValue, value, writer, el) {

        boolean selected = false
        def keyClass = keyValue?.getClass()
        if (keyClass.isInstance(value)) {
            selected = (keyValue == value)
        } else if (value instanceof Collection) {
            // first try keyValue
            selected = value.contains(keyValue)
            if (!selected && el != null) {
                selected = value.contains(el)
            }
        }
        // GRAILS-3596: Make use of Groovy truth to handle GString <-> String
        // and other equivalent types (such as numbers, Integer <-> Long etc.).
        else if (keyValue == value) {
            selected = true
        } else if (keyClass && value != null) {
            try {
                def typeConverter = new SimpleTypeConverter()
                value = typeConverter.convertIfNecessary(value, keyClass)
                selected = (keyValue == value)
            }
            catch (e) {
                // ignore
            }
        }
        writer << "value=\"${keyValue}\" "
        if (selected) {
            writer << 'selected="selected" '
        }
    }

    /**
     * crea el div para el flash message
     */
    def message = { attrs, body ->
        def contenido = body()

        def close = true
        if (attrs.close && (attrs.close == "false" || attrs.close == "0" || attrs.close == false || attrs.close == 0 || attrs.close.toLowerCase() == "n" || attrs.close.toLowerCase() == "no")) {
            close = false
        }

        if (!contenido) {
            if (attrs.contenido) {
                contenido = attrs.contenido
            }
        }

        if (contenido) {
            def finHtml = "</p></div>"

            def icono = ""
            def clase = attrs.clase ?: ""

            if (attrs.icon) {
                icono = attrs.icon
            } else {
                switch (attrs.tipo?.toLowerCase()) {
                    case "error":
                        icono = "fa fa-times"
                        clase += " alert-danger"
                        break;
                    case "success":
                        icono = "fa fa-check"
                        clase += " alert-success"
                        break;
                    case "notfound":
                        icono = "icon-ghost"
                        clase += " alert-info"
                        break;
                    case "warning":
                        icono = "fa fa-exclamation-triangle"
                        clase += " alert-warning"
                        break;
                    case "info":
                        icono = "fa fa-info-circle"
                        clase += " alert-info"
                        break;
                    case "bug":
                        icono = "fa fa-bug"
                        clase += " alert-warning"
                        break;
                    default:
                        clase += " alert-info"
                }
            }
            def html = "<div class=\"alert alert-dismissable ${clase}\">"
            if (close) {
                html += "<button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-hidden=\"true\">&times;</button>"
            }
            html += "<p style='margin-bottom:15px;'>"
            html += "<i class=\"${icono} fa-2x pull-left iconMargin text-shadow\"></i> "
            out << html << contenido << finHtml
        } else {
            out << ""
        }
    }



    def datetimepicker = { attrs ->
        def str = ""
        def clase = attrs.remove("class")
        def name = attrs.remove("name")
        def id = attrs.id ? attrs.remove("id") : name
        if (id.contains(".")) {
            id = id.replaceAll("\\.", "_")
        }

        def value = attrs.remove("value")
        if (value.toString() == 'none') {
            value = null
        } else if (!value) {
            value = null
        }

        def format = attrs.format ? attrs.remove("format") : "dd-MM-yyyy"
        def formatJs = format
        formatJs = formatJs.replaceAll("M", "m")
        formatJs = formatJs.replaceAll("yyyy", "yy")

        def timeFormat = attrs.timeFormat ? attrs.remove("format") : "HH:mm"

        def dateTimeFormat = format + " " + timeFormat

        str += "<input type='text'  autocomplete='off' class='datetimepicker " + clase + "' name='" + name + "' id='" + id + "' value='" + g.formatDate(date: value, format: dateTimeFormat) + "'"
        str += renderAttributes(attrs)
        str += "/>"

        def js = "<script type='text/javascript'>"
        js += '$(function() {'
        js += '$("#' + id + '").datetimepicker({'
        js += 'dateFormat: "' + formatJs + '",'
//        js += 'locale: es,'
        js += 'changeMonth: true,'
        js += 'changeYear: true'
        if (attrs.onClose) {
            js += ','
            js += 'onClose: ' + attrs.onClose
        }
        if (attrs.onSelect) {
            js += ','
            js += 'onSelect: ' + attrs.onSelect
        }
        if (attrs.yearRange) {
            js += ','
//            println attrs.yearRange
            js += 'yearRange: "' + attrs.yearRange + '"'
        }
        if (attrs.minDate) {
            js += ","
            js += "minDate:" + attrs.minDate
        }
        if (attrs.maxDate) {
            js += ","
            js += "maxDate:" + attrs.maxDate
        }
        /* **************** hasta aqui lo de date....ahora lo de time ******************************* */
        if (attrs.controlType) {
            js += ","
            js += "controlType: '${attrs.controlType}'"
        }
        js += ","
        js += "timeFormat: '${timeFormat}',"
        js += "timeText: 'Hora',"
        js += "hourText: 'Horas',"
        js += "minuteText: 'Minutos',"
        js += "secondText: 'Segundos',"
        js += "currentText: 'Hoy',"
        js += "closeText: 'Aceptar'"
        if (attrs.showTime) {
            js += ","
            js += "showTime:" + attrs.showTime
        }
        if (attrs.minHour) {
            js += ","
            js += "hourMin:" + attrs.minHour
        }
        if (attrs.minMin) {
            js += ","
            js += "minuteMin:" + attrs.minMin
        }
        if (attrs.minSec) {
            js += ","
            js += "secondMin:" + attrs.minSec
        }
        if (attrs.maxHour) {
            js += ","
            js += "hourMax:" + attrs.maxHour
        }
        if (attrs.maxMin) {
            js += ","
            js += "minuteMax:" + attrs.maxMin
        }
        if (attrs.maxSec) {
            js += ","
            js += "secondMax:" + attrs.maxSec
        }

        if (attrs.hourGrid) {
            js += ","
            js += "hourGrid:" + attrs.hourGrid
        }

        if (attrs.minuteGrid) {
            js += ","
            js += "minuteGrid:" + attrs.minuteGrid
        }

        if (attrs.secondGrid) {
            js += ","
            js += "secondGrid:" + attrs.secondGrid
        }

        if (attrs.stepHour) {
            js += ","
            js += "stepHour:" + attrs.stepHour
        }

        if (attrs.stepMinute) {
            js += ","
            js += "stepMinute:" + attrs.stepMinute
        }

        if (attrs.stepSecond) {
            js += ","
            js += "stepSecond:" + attrs.stepSecond
        }

        js += '});'
        js += '});'
        js += "</script>"
//       println "js "+js
        out << str
        out << js
    }

/**
 * crea un modal, al modal hay que agregarle el modal-body y el modal-footer
 */
    def modal = { attrs, body ->
        def id = attrs.id
        def html = '<div class="modal fade ' + attrs.clase + ' " id="' + id + '" tabindex="-1" role="dialog" aria-labelledby="myModalLabel' + attrs.id + '" aria-hidden="true" style="' + attrs.style + '">'
        html += '<div class="modal-dialog">\n' +
                '    <div class="modal-content">\n' +
                '      <div class="modal-header">'
        html += ' <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
        html += ' <h4 class="modal-title" id="myModalLabel-' + attrs.id + '">' + attrs.titulo + '</h4></div>'
        out << html << body() << '</div></div></div>'
    }

    def poneHtml = { attrs ->
//        println "funcion: ${attrs.funcion}"
        def html = attrs.textoHtml
        out << html
    }

    /**
     * pone un field segun el standar rapido rapido
     */
    def fieldRapido = { attrs, body ->
        def html = ""
        def claseField = (attrs.claseField ? attrs.claseField : 'col-md-3')
        def claseLabel = (attrs.claseLabel ? attrs.claseLabel : 'col-md-2')
        html += '<div class="form-group keeptogether">'
        html += '<span class="grupo">'
        html += '<label class="' + claseLabel + ' control-label">'
        html += attrs.label
        html += '</label>'
        html += '<div class="' + claseField + '">'
        html += body()
        html += '</div>'
        html += '</span>'
        html += '</div>'
        out << html
    }





    /**
     * Imprime el número del aval o de la solicidud con el formato '003'
     * @param aval (opcional) el id del aval
     * @param solicitud (opcional) el id de la solicitud
     */
    def imprimeNumero = { attrs ->
//        println("imprimeNumero " + attrs)
        def aval = null
        def sol = null
        if (attrs.aval) {
            aval = Aval.get(attrs.aval)
        }
        if (attrs.solicitud) {
            sol = SolicitudAval.get(attrs.solicitud)
        }
        def num = null
        def uno = 1
        def output = ""
        if (aval) {
            num = aval.numeroAval.toString()
        }
        if (sol) {
            num = sol.numero.toString()
        }

        num = num.toString().padLeft(3, '0')
//        println("num1 " + num)
        if (!num || num == "null") {
            num = "000"
        }
        output += num
        out << output
    }

    Closure headerPlanilla = { attrs ->
        def str = ""
        Planilla planilla = attrs.planilla
        Obra obra = planilla.contrato.oferta.concurso.obra

        str += "<div class='alert alert-info' style='height: 160px'>"

        str += "<div class='col-md-12'>"
        str += "<div class='col-md-1'><strong>Obra</strong></div>"
        str += "<div class='col-md-10'>" + obra.nombre + "</div>"
        str += "</div>"

        str += "<div class='col-md-12'>"
        str += "<div class='col-md-1 '><strong>Descripción</strong></div>"
        str += "<div class='col-md-10'>" + obra?.descripcion + "</div>"
        str += "</div>"

        str += "<div class='col-md-12'>"
        str += "<div class='col-md-1 bold'><strong>Lugar</strong></div>"
        str += "<div class='col-md-5'>" + (obra.lugar?.descripcion ?: "") + "</div>"
        str += "<div class='col-md-2 bold'><strong>Planilla</strong></div>"
        str += "<div class='col-md-3'>" + planilla.numero + "</div>"
        str += "</div>"

        str += "<div class='col-md-12'>"
        str += "<div class='col-md-1 bold'><strong>Ubicación</strong></div>"
        str += "<div class='col-md-5'>Parroquia " + obra.parroquia?.nombre + " - Cantón " + obra.parroquia?.canton?.nombre + "</div>"
        str += "<div class='col-md-2 bold'><strong>Monto contrato</strong></div>"
        str += "<div class='col-md-3'>" + formatNumber(number: planilla.contrato.monto, format: "##,##0", locale: "ec", minFractionDigits: 2, maxFractionDigits: 2) + "</div>"
        str += "</div>"

        str += "<div class='col-md-12'>"
        str += "<div class='col-md-1 bold'><strong>Contratista</strong></div>"
        str += "<div class='col-md-5'>" + planilla.contrato.oferta.proveedor.nombre + "</div>"
        str += "<div class='col-md-2 bold'><strong>Periodo</strong></div>"
        str += "<div class='col-md-3'>"
        if (planilla.tipoPlanilla.codigo == "A") {
            str += 'Anticipo (' + planilla?.periodoIndices?.descripcion + ")"
        } else {
            if (planilla.tipoPlanilla.codigo == "L") {
                str += "Liquidación del reajuste (${planilla.fechaPresentacion.format('dd-MM-yyyy')})"
            } else {
                str += 'del ' + planilla?.fechaInicio?.format('dd-MM-yyyy') + ' al ' + planilla?.fechaFin?.format('dd-MM-yyyy')
            }
        }

        str += "</div>"
        str += "</div>"

        str += "<div class='col-md-12'>"
        str += "<div class='col-md-1 bold'><strong>Plazo</strong></div>"
        str += "<div class='col-md-5'>" + formatNumber(number: planilla.contrato.plazo, minFractionDigits: 0, maxFractionDigits: 0, locale: "ec") + " días</div>"
        str += "<div class='col-md-2 bold'><strong>Fecha pres. planilla</strong></div>"
        str += "<div class='col-md-3'>" + planilla.fechaPresentacion.format("dd-MM-yyyy") + "</div>"
        str += "</div>"

        str += "</div>"

        out << str
    }

    Closure numero = { attrs ->
//        println "numero: $attrs"
        if (attrs.debug == "true" || attrs.debug == true) {
            println "AQUI: " + attrs
        }
        if (!attrs.decimales) {
            if (!attrs["format"]) {
                attrs["format"] = "##,##0"
            }
            if (!attrs.minFractionDigits) {
                attrs.minFractionDigits = 2
            }
            if (!attrs.maxFractionDigits) {
                attrs.maxFractionDigits = 2
            }
        } else {
            def dec = attrs.remove("decimales").toInteger()

            attrs["format"] = "##,##0"
            if (dec > 0) {
                attrs["format"] += "."
            }
            dec.times {
                attrs["format"] += "#"
            }

            attrs.maxFractionDigits = dec
            attrs.minFractionDigits = dec
        }
        if (!attrs.locale) {
            attrs.locale = "ec"
        }
        if (attrs.debug == "true" || attrs.debug == true) {
            println attrs
            println g.formatNumber(attrs)
            println g.formatNumber(number: attrs.number, maxFractionDigits: 3, minFractionDigits: 3, format: "##.###", locale: "ec")
            println g.formatNumber(number: attrs.number, maxFractionDigits: 3, minFractionDigits: 3, format: "##,###.###", locale: "ec")
        }
        if (attrs.cero == "false" || attrs.cero == false || attrs.cero == "hide") {
            if (attrs.number) {
                if (attrs.number.toDouble() == 0.toDouble()) {
                    out << ""
                    return
                }
            } else {
                out << ""
                return
            }
        }
        out << g.formatNumber(attrs)
    }

    Closure numberToLetter = {attrs ->
        println "nt" + attrs
        def number = attrs.numero?: 0
        def dolares = attrs.dolares?: false

        try{
            number=number.toDouble()
        }catch (e){
            number=0
        }
        if(dolares){
            out <<   NumberToLetterConverter.convertNumberToLetter(number)
        }  else {
            out <<   NumberToLetterConverter.numberToLetter(number)
        }
    }


}
