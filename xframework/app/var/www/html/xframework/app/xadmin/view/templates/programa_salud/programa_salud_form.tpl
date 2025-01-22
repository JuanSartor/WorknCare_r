<div id="colRight">

    <div class="block">

        <div class="title_bar">
            <div class="text">Programas de Salud &raquo; {if $record} Editar programa {else} Nuevo programa{/if}</div>

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;
            {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'programa_salud'" p2="'programa_salud_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=programa_salud&submodulo=programa_salud_form" method="post" name="f_record" id="f_record">
                    <input type="hidden" name="idprograma_salud" id="idprograma_salud" value="{$record.idprograma_salud}" />

                    <div class="form_container ">
                        <div class="title">Datos del Programa de salud</div>
                        <ul>
                            <li class="wide">
                                <label>Nombre</label>
                                {x_form_input id="programa_salud" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>
                            <li class="right checkbox-inline">
                                <label class="">{"Visible"|x_translate}</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=$record.visible  name="visible" id="visible"}
                            </li>
                            <li class="wide">
                                <label>URL Video</label>
                                {x_form_input id="url_video" descriptor="none" isRequired="false" maxChars=255 class="" record=$record}
                            </li>
                            <li class="wide">
                                <label>Descripción</label>
                                <textarea id="descripcion" name="descripcion">{$record.descripcion}</textarea>
                            </li>

                            <li class="clear">&nbsp;</li>

                        </ul>
                    </div>

                    <div class="clear">&nbsp;</div>

                </form>
            </div>
        </div>
        <div class="end">&nbsp;</div>
    </div>
    <div id="categorias_list_container"></div>
</div>







