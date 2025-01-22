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
            <div class="text">Familia &raquo; {if $record} Editar Familia {else} Nuevo Familia{/if}</div>

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;
            {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'riesgo'" p2="'familia_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
            &nbsp;

        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />

            <div class="xForm ">


                <form action="{$controller}.php?action=1&modulo=riesgo&submodulo=familia_form" method="post" name="f_record" id="f_record">
                    <input type="hidden" name="idfamilia_riesgo" id="idfamilia_riesgo" value="{$record.idfamilia_riesgo}" />


                    <div class="form_container ">
                        <div class="title">Datos de Familia</div>


                        <ul style="display: inline-block">
                            <li class="wide">
                                <label>Titulo</label>
                                {x_form_input id="titulo" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>
                            <li class="wide">
                                <label>Titulo (en)</label>
                                {x_form_input id="titulo_en" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>
                            <li class="wide">
                                <label>Orden </label>
                                {x_form_input id="orden" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>
                            <li class="right checkbox-inline">
                                <label class="">{"Visible"|x_translate}</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=$record.visible default='1'  name="visible" id="visible"}
                            </li>
                            <li class="left checkbox-inline">
                                <label>Modelo</label>

                                {foreach from=$modelos item=modelo}

                                    {if $modelo.idmodelos_riesgos!='1'}
                                        <label style="display: flex;">{$modelo.nombre}
                                            <span style="position: relative;  bottom: 4px;  left: 10px;">
                                                <input {if $modelo.chck=='1'}checked{/if} type="checkbox"  name="chkk-{$modelo.idmodelos_riesgos}" value="chkk-{$modelo.idmodelos_riesgos}"  data-toggle="checkbox" class="custom-checkbox">


                                            </span>
                                        </label> 

                                    {/if}

                                {/foreach}

                            </li>

                            <li class="clear">&nbsp;</li>

                            <li class="clear">&nbsp;</li>
                            <br>  <br>   <br>  <br>   <br>  <br>
                        </ul>


                        {*items*}
                        <div id="container_listado_items" >
                        </div>

                    </div>
                    <div class="clear">&nbsp;</div>


                </form>
            </div>

        </div>
        <div class="end">&nbsp;</div>
    </div>

</div>