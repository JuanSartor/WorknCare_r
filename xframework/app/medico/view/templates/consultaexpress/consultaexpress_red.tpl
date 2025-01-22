<div id="div_consultasexpress_red">
    {include file="consultaexpress/consultaexpress_settings.tpl"}

    <input type="hidden" id="notificacion_consultaexpress" value="{$notificacion_general}">
    <div class="cs-nc-section-holder">
        <div class="container">
            <ol class="breadcrum">
                <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                <li><a href="{$url}panel-medico/consultaexpress/">{"Consulta Express"|x_translate}</a></li>
                    {*<li class="active">{"En la Red"|x_translate}</li>*}

            </ol>
        </div>
        <section class="container ceprr-header">
            <div class="cs-nc-p2-header">
                <figure>
                    <i class="icon-doctorplus-people-add"></i>
                </figure>
                <h2>{"Consultas en la red"|x_translate}</h2>
                {*<p class="text-center">{$especialidad.especialidad}</p>*}
                {*<div class="ceprr-filtro-menu">
                <ul>
                <li><a href="javascript:;" class="ceprr-todas-trigger"><i class="fui-list-small-thumbnails"></i><span>{"Todas"|x_translate}</span></a></li>
                <li><a href="{$url}panel-medico/consultaexpress/red.html" class="ceprr-especialidad-trigger {if $smarty.request.from_filtro!="1"}active{/if}"><i class="fui-list-numbered"></i><span>{"Mi especialidad"|x_translate}</span></a></li>
                </ul>
                </div>
                *}
            </div>
        </section>
        {*
        <div id="div_consultaexpress_red_contador" class="relative">
        <!--aqui cargamos el contador con las cantidades de las consultas express en la red-->

        </div>
        *}
        <div class="ceprr-accordion-section-holder"  style="display: block;">	

            {*
            <section class="container ceprr-buscador-con-filtros">
            <div id="div-especialidad-tags" class="ceprr-filtros-btn-holder">
            <div class="ceprr-accordion-header">


            <div class="ceprr-mi-especialidad-header" data-idespecialidad="{$especialidad.idespecialidad}">
            {if $smarty.request.from_filtro!=""}
            <a href="{$url}panel-medico/consultaexpress/red.html" class="ceprr-tags-back"><i class="icon-doctorplus-left-arrow"></i></a>
            <div id="tags-filtro" class="tagsinput-primary ceprr-tags">
            <input name="tagsinput" style="display:none;" />
            </div>
            {else}
            <a href="{$url}panel-medico/consultaexpress/"><i class="icon-doctorplus-left-arrow"></i></a>

            {if $especialidad.cantidad>0} <figure>{$especialidad.cantidad}</figure>{/if}
            {$especialidad.especialidad}
            {/if}
            </div>

            </div>


            <a href="javascript:;" class="ceprr-filtros-btn-trigger"><i class="icon-doctorplus-search"></i>{"Buscador con filtros"|x_translate}</a>
            </div>
            <div class="ceprr-filtros-holder">
            <div class="ceprr-filtros-holder-inner">
            <form name="f_busqueda_red" id="f_busqueda_red" >
            <input type="hidden" id="rango_maximo" name="rango_maximo" value="{$smarty.request.rango_maximo}">
            <input type="hidden" id="rango_minimo" name="rango_minimo" value="{$smarty.request.rango_minimo}">
            </form>
            <form name="cs-nc-p2-profesionales-en-la-red" id="cs-nc-p2-profesionales-en-la-red">


            <div class="container-fluid">
            <div class="row cs-nc-p2-row-divider">
            <div class="col-sm-4">
            <div class="cs-nc-p2-input-holder cs-nc-p2-input-text-holder">
            <select id="especialidad_idespecialidad" name="especialidad_idespecialidad" class="form-control select select-primary select-block mbl">
            <option value="">{"Especialidad"|x_translate}</option>
            {html_options options=$combo_especialidades }
            </select>
            </div>
            </div>


            <div class="ceprr-tags-row">
            <div class="col-sm-12 ceprr-tags-cell">
            <div id="tags-div" class="tagsinput-primary ceprr-tags">
            <input name="tagsinput" style="display:none;" />
            </div>
            </div>
            </div>
            </div>

            <div class="row cs-nc-p2-row-divider">
            <div class="col-sm-12">
            <div class="cs-nc-p2-range-holder cprr-slidebar">
            <div class="cs-nc-p2-bg-bars">
            <ul>
            {foreach from=$rango_precios.precios item=precio}
            {math assign="h" equation='0+10*i/j' i=$precio j=$rango_precios.cantidad_max} 
            {math assign="w" equation='100/j' j=$rango_precios.intervalos} 
            <li style="height: {$h}px; width:{$w}%; "></li>
            {/foreach}
            </ul>
            </div>
            <div class="cs-nc-p2-range">
            <div id="slider-range" class="cs-ui-range"></div>

            <div class="cs-ui-range-values">

            <input type="text" id="amount-min" class="cs-ui-range-value min" readonly>
            {math assign="position" equation='ancho*((j/10)-5)' ancho=0.6849 j=$preferencia.valorPinesConsultaExpress} 
            <div class="cs-ui-range-values-promedio" style="left:{$position}%; top:-17px;">

            <div class="cs-ui-range-values-promedio-box">
            <span>{"Su tarifa"|x_translate}: &euro;{$preferencia.valorPinesConsultaExpress} </span>
            <div class="cs-ui-range-values-promedio-arrow"></div>
            </div>

            </div>

            <input type="text" id="amount-max" class="cs-ui-range-value max" readonly>
            </div>
            </div>
            </div></div>
            </div>
            </div>
            </form>
            </div>
            <div class="ceprr-filtros-action-holder">
            <a href="javascript:;" id="btnCancelar" class="cancelar">{"Cancelar"|x_translate}</a>
            <a href="javascript:;" id="btnAplicarFiltro" class="aplicar">{"Aplicar filtros"|x_translate}</a>
            </div>
            </div>
            </section>
            *}
            <!-- Cargamos el listado -->
            <div id="div_consultasexpress_red_listado" class="relative">

            </div>

        </div>


    </div>



    <script>
        var PRECIO_MINIMO_CE = {$PRECIO_MINIMO_CE};
        var PRECIO_MAXIMO_CE = {$PRECIO_MAXIMO_CE};

    </script>


    {literal}
        <script>


            $(function () {
                $("body").spin();
                x_loadModule('consultaexpress', 'consultaexpress_red_listado', 'do_reset=1&{$query_string}', 'div_consultasexpress_red_listado', BASE_PATH + "medico").then(function () {
                    $("body").spin(false);
                });

                //mostrar contador de todas las consultas
                $('.ceprr-todas-trigger').on('click', function (e) {
                    e.preventDefault();
                    if ($('.ceprr-todas').is(':hidden')) {
                        $('.ceprr-todas').stop().slideDown();
                    } else if ($('.ceprr-todas').is(':visible')) {
                        $('.ceprr-todas').stop().slideUp();
                    }
                    $("a.ceprr-todas-trigger").addClass("active");
                    $("a.ceprr-especialidad-trigger").removeClass("active");

                });





                //mostrar fuiltros
                $('.ceprr-filtros-btn-trigger').on('click', function (e) {
                    e.preventDefault();
                    $("#div-especialidad-tags").hide();
                    if ($(this).parent().siblings('.ceprr-filtros-holder').is(':hidden')) {
                        $(this).parent().siblings('.ceprr-filtros-holder').stop().slideDown();
                    } else if ($(this).parent().siblings('.ceprr-filtros-holder').is(':visible')) {
                        $(this).parent().siblings('.ceprr-filtros-holder').stop().slideUp();
                    }
                });




                $("#btnCancelar").on("click", function () {
                    $("#div-especialidad-tags").fadeIn();

                    $(".ceprr-buscador-con-filtros .ceprr-filtros-holder").slideUp();

                });

                //slide range

                $("#slider-range").slider({
                    range: true,
                    min: PRECIO_MINIMO_CE,
                    max: PRECIO_MINIMO_CE,
                    step: 5,
        {/literal}
                    values: [{if $smarty.request.rango_minimo!=""}{$smarty.request.rango_minimo}{else}{$PRECIO_MINIMO_CE}{/if}, {if $smarty.request.rango_maximo!=""}{$smarty.request.rango_maximo}{else}{$PRECIO_MAXIMO_CE}{/if}],
        {literal}
                    slide: function (event, ui) {
                        $("#amount-min").val("€ " + ui.values[0]);
                        $("#amount-max").val("€ " + ui.values[1]);
                        $("#rango_minimo").val(ui.values[0]);
                        $("#rango_maximo").val(ui.values[1]);
                    }
                });
                $("#amount-min").val("€ " + $("#slider-range").slider("values", 0));
                $("#amount-max").val("€ " + $("#slider-range").slider("values", 1));
                $("#rango_minimo").val($("#slider-range").slider("values", 0));
                $("#rango_maximo").val($("#slider-range").slider("values", 1));




                //////////////////filtros de busqueda ////////////////////////////////////////////////
                //manejo de tags input
                elt = $('#tags-div  input');
                elt.tagsinput({itemValue: 'id',
                    itemText: 'text'
                });







                $("#especialidad_idespecialidad").change(function () {
                    var id = $("#especialidad_idespecialidad option:selected").val();
                    var txt = $("#especialidad_idespecialidad option:selected").html();

                    elt.tagsinput('removeAll');
                    elt.tagsinput('add', {"id": id, "text": txt, "clave": "idespecialidad"});
                });


                $("#btnAplicarFiltro").click(function () {
                    var tags = elt.tagsinput('items');
                    $.each(tags, function (i, e) {

                        $("#f_busqueda_red").append("<input type='hidden' name='" + e.clave + "[]' value='" + e.id + "'/>");

                    });

                    //si ingreso algun filtro seteado recarga
                    window.location.href = BASE_PATH + "panel-medico/consultaexpress/red.html?from_filtro=1&" + $("#f_busqueda_red").serialize();



                });






            });

        </script>


    {/literal}


    {*si viene de una busqueda con filtros*}

    {if $smarty.request.from_filtro=="1"}
        <script>
            $(function (){ldelim}

                    //filros del header
                    tags_filtro = $('#tags-filtro  input');
                    tags_filtro.tagsinput({ldelim}itemValue: 'id',
                                itemText: 'text',

            {rdelim});


            {foreach from=$tags_filtros item=tag}


                    tags_filtro.tagsinput('add', {ldelim}"id": '{$tag.id}', "text": '{$tag.text}', "clave": '{$tag.clave}'{rdelim});
                            elt.tagsinput('add', {ldelim}"id": '{$tag.id}', "text": '{$tag.text}', "clave": '{$tag.clave}'{rdelim});
            {/foreach}

                                    if ({$smarty.request.rango_minimo} != PRECIO_MINIMO_CE || {$smarty.request.rango_maximo} != PRECIO_MAXIMO_CE){ldelim}
                                                tags_filtro.tagsinput('add', {ldelim}"id": 'filtro-rango', "text": 'EUR {$smarty.request.rango_minimo}  - EUR {$smarty.request.rango_maximo}', "clave": 'filtro-rango'{rdelim});
            {rdelim}

            {literal}

                    //funcionaiento al remover un tags de filtro

                    //armamos el form sin el filtro que se elimina y recargamos
                    tags_filtro.on('itemRemoved', function (event) {

                        var tags = tags_filtro.tagsinput('items');
                        $.each(tags, function (i, e) {
                            $("#f_busqueda_red").append("<input type='hidden' name='" + e.clave + "[]' value='" + e.id + "'/>");

                        });
                        //si eliminamos el tag de rango-precio seteamos por defecto el rango min y max: 
                        if (event.item.id = "filtro-rango") {
                            $("#rango_maximo").val(PRECIO_MAXIMO_CE);
                            $("#rango_minimo").val(PRECIO_MINIMO_CE);
                        }

                        window.location.href = BASE_PATH + "panel-medico/consultaexpress/red.html?from_filtro=1&" + $("#f_busqueda_red").serialize();

                    });
                    //ocultamos el componente tagsinput renderizado porque sino se muestra un cursor 
                    $(".bootstrap-tagsinput > input").hide();


            {/literal}
            {rdelim});

        </script>
    {/if}

</div>