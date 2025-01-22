<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<style>
    .form_container.descripcion label, .form_container.descripcion .descripcion-container, .form_container.descripcion textarea {
        width:100%
    }
    .form_container.descripcion .note-editable,.form_container.descripcion .note-editable p{
        font-size: 14px;
        font-family: 'Oxygen', sans-serif;
        font-weight: normal;
        padding: 2px;
        color: #777;
        margin:5px 0;

    }
    .form_container.descripcion .note-editable li {
        margin-left: 10px;
        list-style: circle;
    }


</style>
<div id="colRight">

    <div class="block">

        <div class="title_bar">
            <div class="text">Programas de Salud &raquo; {if $record} Editar programa {else} Nuevo programa{/if}</div>

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;
            {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'programa_salud'" p2="'programa_salud_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
            &nbsp;
            {x_form_html_button id="btnExportar" label="Exportar programas" class="icon loop" w="100" type="button"} 

        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=programa_salud&submodulo=programas_list_export"  target="_blank" method="post" id="f_export" >           
                    <input type="hidden" name="idprograma_salud" id="idprograma_salud" value="{$record.idprograma_salud}" />

                </form>

                <form action="{$controller}.php?action=1&modulo=programa_salud&submodulo=programa_salud_form" method="post" name="f_record" id="f_record">
                    <input type="hidden" name="idprograma_salud" id="idprograma_salud" value="{$record.idprograma_salud}" />

                    <div class="form_container ">
                        <div class="title">Datos del Programa de salud</div>
                        <div style="display: inline-block; float: left;">
                            {include file="programa_salud/foto_programa_salud.tpl"}
                        </div>

                        <ul style="display: inline-block">
                            <li class="wide">
                                <label>Nombre</label>
                                {x_form_input id="programa_salud" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>
                            <li class="left">
                                <label>Prioridad</label>
                                {x_form_input id="orden" descriptor="integer" isRequired="true" maxChars=11 class="" record=$record}
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
                                <label>URL Web</label>
                                {x_form_input id="url_web" descriptor="none" isRequired="false" maxChars=255 class="" record=$record}
                            </li>
                            <li class="left checkbox-inline">
                                <label class="">{"Propio"|x_translate}</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=0 value_no=1 checked=$record.propio  name="propio" id="propio"}
                            </li>



                            <li class="clear">&nbsp;</li>

                        </ul>

                    </div>
                    <div class="clear">&nbsp;</div>
                    <div class="form_container descripcion">
                        <div class="row">
                            <label>Descripción corta</label>
                            <div class="descripcion-container">
                                <textarea id="descripcion" name="descripcion">{$record.descripcion}</textarea>
                            </div>
                        </div>
                        <div class="clear">&nbsp;</div>
                        <div class="row">
                            <label>Descripción larga</label>
                        </div>
                        <div class="row">
                            <div class="clear">&nbsp;</div>
                            <div class="descripcion-container">
                                <textarea id="descripcion_larga" name="descripcion_larga">{$record.descripcion_larga}</textarea>
                                <div class="clear">&nbsp;</div>
                            </div>

                        </div>
                        <div class="clear">&nbsp;</div>
                        <div class="row">
                            <label>Descripción larga Mini Start</label>
                        </div>
                        <div class="row">
                            <div class="clear">&nbsp;</div>
                            <div class="descripcion-container">
                                <textarea id="descripcion_larga_mini_start" name="descripcion_larga_mini_start">{$record.descripcion_larga_mini_start}</textarea>
                                <div class="clear">&nbsp;</div>
                            </div>

                        </div>

                    </div>



                </form>
            </div>
        </div>
        <div class="end">&nbsp;</div>
    </div>
    <div id="categorias_list_container"></div>
</div>







