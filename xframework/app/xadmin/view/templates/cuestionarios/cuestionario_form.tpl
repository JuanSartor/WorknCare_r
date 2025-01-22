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
            <div class="text">Cuestionario &raquo; {if $record} Editar cuestionario {else} Nuevo cuestionario{/if}</div>

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;
            {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'cuestionarios'" p2="'cuestionario_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
            &nbsp;

        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />

            <div class="xForm ">


                <form action="{$controller}.php?action=1&modulo=cuestionarios&submodulo=cuestionario_form" method="post" name="f_record" id="f_record">
                    <input type="hidden" name="idcuestionario" id="idcuestionario" value="{$record.idcuestionario}" />
                    <input type="hidden" name="idpago" id="idpago" value="{$pago.idpago_recompensa_encuesta}" />

                    <div class="form_container ">
                        <div class="title">Datos del Cuestionario</div>


                        <ul style="display: inline-block">
                            <li class="wide">
                                <label>Titulo</label>
                                {x_form_input id="titulo" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>
                            <li class="wide">
                                <label>Titulo (en)</label>
                                {x_form_input id="titulo_en" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>

                            <li class="right checkbox-inline">
                                <label class="">{"Visible"|x_translate}</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=$record.visible  name="visible" id="visible"}
                            </li>
                            <li class="left checkbox-inline">
                                <label>Familia</label>
                                <select name="id_familia_cuestionario" id="id_familia_cuestionario" class="">
                                    <option value="">{"Seleccionar"|x_translate}</option>
                                    {if $record}
                                        {html_options options=$familias selected=$record.id_familia_cuestionario}  
                                    {else}                         
                                        {html_options options=$familias selected=1}                      
                                    {/if}
                                </select>  
                            </li>
                            {if $pago.pago_pendiente=='2' || $pago.pago_pendiente=='5'}
                                <li class="clear">&nbsp;</li>
                                <li class="left">
                                    <label>{"PAGO"|x_translate}</label>
                                    <span>MANUAL</span>
                                </li>

                                <li class="right checkbox-inline">
                                    <label class="">{"Transferencia recibida"|x_translate}</label>
                                    {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=5 value_no=2 checked=$pago.pago_pendiente  name="pago_pendiente" id="pago_pendiente"}
                                </li>
                                <li class="clear">&nbsp;</li>

                                <div class="title">Datos empresa</div>
                                <li class="clear">&nbsp;</li>
                                <li class="right">
                                    <label>Empresa</label> 
                                    <input disabled value="{$empresa.empresa}"></input> 
                                </li> 
                                <li class="left">
                                    <label>Factura</label> 
                                    {if $pago.fecha_envio_factura!=''}
                                        <a  href="{$url}xframework/files/entities/facturas_cuestionario/{$pago.empresa_idempresa}/fac-quest-{$pago.idpago_recompensa_encuesta}.pdf" target="_blank">  Factura PDF </a>
                                    {else}
                                        <a  href="{$pago.invoice_pdf}" target="_blank">  Factura PDF </a>
                                    {/if}
                                </li>
                            {/if}
                            <li class="clear">&nbsp;</li>

                            <li class="clear">&nbsp;</li>

                        </ul>


                        {*preguntas*}
                        <div id="container_listado_preguntas" >
                        </div>

                    </div>
                    <div class="clear">&nbsp;</div>


                </form>
            </div>

        </div>
        <div class="end">&nbsp;</div>
    </div>

</div>