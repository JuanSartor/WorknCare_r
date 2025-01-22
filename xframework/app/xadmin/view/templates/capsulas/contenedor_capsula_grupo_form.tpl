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
            <div class="text">Contenedor de Capsulas &raquo; {if $record} Editar Contenedor de Capsulas {else} Nuevo Contenedor de Capsulas{/if}</div>

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;
            {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'capsulas'" p2="'contenedor_capsula_grupo_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
            &nbsp;

        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=capsulas&submodulo=contenedor_capsula_grupo_form" method="post" name="f_record" id="f_record">
                    <input type="hidden" name="idcontenedorcapsula" id="idcontenedorcapsula" value="{$record.idcontenedorcapsula}" />


                    <div class="form_container ">
                        <div class="title">Información de Contenedor</div>


                        <ul style="display: inline-block">
                            <li class="wide">
                                <label>Nombre de Contenedor * </label>
                                {x_form_input id="titulo" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>
                            <li class="wide">
                                <label>Nombre de Contenedor (en) </label>
                                {x_form_input id="titulo_en" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>
                            <li class="left checkbox-inline">
                                <label>Familia</label>
                                <select name="familia_capsula_id_familia_capsula" id="familia_capsula_id_familia_capsula" class="">
                                    <option value="">{"Seleccionar"|x_translate}</option>
                                    {if $record}
                                        {html_options options=$familias selected=$record.id_familia_capsula}  
                                    {else}                         
                                        {html_options options=$familias selected=1}                      
                                    {/if}
                                </select>  
                            </li>
                            <li class="right checkbox-inline">
                                <label class="">{"Visible"|x_translate}</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=$record.visible  name="visible" id="visible"}
                            </li>
                            <li class="right checkbox-inline">
                                <label class="">{"Orden"|x_translate}</label> 
                                {x_form_input id="orden" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>

                        </ul>


                        <div class="clear">&nbsp;</div>


                        {*capsulas*}
                        <div id="container_listado_capsulas" >
                        </div>
                    </div>    

                    <div class="clear">&nbsp;</div>

                </form>
            </div>
        </div>
        <div class="end">&nbsp;</div>
    </div>
</div>