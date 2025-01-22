<div id="colRight">

    <div class="block">

        <div class="title_bar">
            <div class="text">{"Banners de promoción"|x_translate}  &raquo; {if $record}  &raquo; Editar {else} Agregar Banner{/if}</div>

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;
            {x_form_html_button id="back" label="Volver" function_name="x_goTo" w="100" type="button" p1="'maestros_genericos'" p2="'banner_promocion_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=maestros_genericos&submodulo=banner_promocion_form" method="post" name="f_record" id="f_record">
                    <input type="hidden" name="idbanner_promocion" id="idbanner_promocion" value="{$record.idbanner_promocion}" />

                    <div class="form_container ">
                        <div class="title">{"Banners de promoción"|x_translate}</div>
                        <div style="display: inline-block; float: left;">
                            {include file="maestros_genericos/foto_banner.tpl"}
                        </div>

                        <ul style="display: inline-block">
                            <li class="wide">
                                <label>Título *</label>
                                {x_form_input id="nombre" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>

                            <li class="wide">
                                <label>URL *</label>
                                {x_form_input id="url" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>
                            <li class="wide">
                                <label>Código descuento </label>
                                {x_form_input id="codigo_descuento" descriptor="none" isRequired="false" maxChars=255 class="" record=$record}
                            </li>
                            <li class="left">
                                <label>Prioridad *</label>
                                {x_form_input id="orden" descriptor="integer" isRequired="true" maxChars=11 class="" record=$record}
                            </li>
                            <li class="right checkbox-inline">
                                <label class="">{"Visible"|x_translate}</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=$record.visible  name="visible" id="visible"}
                            </li>

                        </ul>

                        <div class="clear">&nbsp;</div>
                    </div>
                </form>
            </div>
        </div>
        <div class="end">&nbsp;</div>
    </div>
</div>