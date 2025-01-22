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
            <div class="text">Grupo de Salud &raquo; {if $record} Editar Grupo de salud {else} Nuevo Grupo de salud{/if}</div>

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;
            {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'programa_salud'" p2="'programa_salud_grupo_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
            &nbsp;

        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=programa_salud&submodulo=programa_salud_grupo_form" method="post" name="f_record" id="f_record">
                    <input type="hidden" name="idprograma_salud_grupo" id="idprograma_salud_grupo" value="{$record.idprograma_salud_grupo}" />

                    <div class="form_container ">
                        <div class="title">Información del Grupo</div>


                        <ul style="display: inline-block">
                            <li class="wide">
                                <label>Nombre del grupo * </label>
                                {x_form_input id="nombre" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>
                            <li class="wide">
                                <label>Nombre del grupo (EN) </label>
                                {x_form_input id="nombre_en" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>
                            <li class="left">
                                <label>Prioridad</label>
                                {x_form_input id="orden" descriptor="integer" isRequired="true" maxChars=11 class="" record=$record}
                            </li>
                            <li class="right checkbox-inline">
                                <label class="">{"Visible"|x_translate}</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=$record.visible  name="visible" id="visible"}
                            </li>

                        </ul>


                        <div class="clear">&nbsp;</div>
                        {if $record}
                            {*Programas*}
                            <div id="container_listado_programas" class="toggle-listado-programas">
                            </div>
                        {/if}

                    </div>    

                    <div class="clear">&nbsp;</div>

                </form>
            </div>
        </div>
        <div class="end">&nbsp;</div>
    </div>
</div>