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
    .none{
        display: none;
    }



</style>
<div id="colRight">

    <div class="block">

        <div class="title_bar">
            <div class="text">Capsula &raquo; {if $record} Editar capsula {else} Nuevo capsula{/if}</div>


            &nbsp;
            {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'capsulas'" p2="'capsula_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
            &nbsp;

        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />

            <div class="xForm ">


                <input type="hidden" name="idcapsula" id="idcapsula" value="{$record.idcapsula}" />


                <div class="form_container ">
                    <div class="title">Datos del Capsula</div>


                    <ul style="display: inline-block">

                        {if $record.idcapsula ==''}
                            <li class="left checkbox-inline">
                                <label>Tipo Capsula:</label>
                                <select name="tipoCapsula" id="tipoCapsula" class="">
                                    <option selected="true" value="1">{"File"|x_translate}</option>
                                    <option value="2">{"Link"|x_translate}</option>
                                    <option value="3">{"Video"|x_translate}</option>
                                </select>  
                            </li>
                        {/if}
                        <li class="left checkbox-inline">
                            <label>Contenedor</label>
                            <select name="idcontenedorcapsula" id="idcontenedorcapsula" class="">
                                <option value="">{"Seleccionar"|x_translate}</option>
                                {if $record}
                                    {html_options options=$familias selected=$record.contenedorcapsula_idcontenedorcapsula}  
                                {else}                         
                                    {html_options options=$familias selected=1}                      
                                {/if}
                            </select>  
                        </li>
                        <li class="wide">
                            <label>Titulo</label>
                            <input  name="tituloGeneral" id="tituloGeneral" value="{$record.titulo}" />

                        </li>
                        <li class="clear">&nbsp;</li>

                        <li class="clear">&nbsp;</li>

                        {** file **}
                        <div  class="file " id="filediv">
                            {include file="capsulas/file.tpl"}
                        </div>
                        {** termina file **}
                        {** link **}                            
                        <div class="link none" id="linkdiv">
                            {include file="capsulas/link.tpl"}
                        </div>
                        {** termina link **}

                        {** video **}
                        <div class="video none" id="videodiv">
                            {include file="capsulas/video.tpl"}
                        </div>
                        {** termina video **}



                    </ul>




                </div>
                <div class="clear">&nbsp;</div>



            </div>

        </div>
        <div class="end">&nbsp;</div>
    </div>

</div>