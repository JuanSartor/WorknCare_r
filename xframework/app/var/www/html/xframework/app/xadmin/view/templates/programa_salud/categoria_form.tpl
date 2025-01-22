<style>
    .agregar_medico {
        position: absolute;
        overflow: visible;
        display: inline-block;
        padding: 0.5em 1em;
        border: 1px solid #B80C1D;
        border-radius: 5px;
        margin: 0;
        text-decoration: none;
        text-align: center;
        text-shadow: -1px -1px 0 rgba(0, 0, 0, 0.3);
        font: 11px/normal sans-serif;
        color: #FFF;
        white-space: nowrap;
        cursor: pointer;
        outline: none;
        background-color: #D00D20;
    }

    .delete_medico {
        position: relative;
        overflow: visible;
        display: inline-block;
        padding: 0.5em;
        border-radius: 5px;
        border: 1px solid #B80C1D;
        margin: 0;
        text-decoration: none;
        text-align: center;
        text-shadow: -1px -1px 0 rgba(0, 0, 0, 0.3);
        font: 11px/normal sans-serif;
        color: #FFF;
        white-space: nowrap;
        cursor: pointer;
        outline: none;
        background-color: #D00D20;
    }
</style>
<div id="colRight">



    <div class="block">

        <div class="title_bar">
            <div class="text">Programas de salud &raquo; {if $programa_salud} {$programa_salud.programa_salud}{/if} &raquo; {if $record} {$record.programa_categoria} &raquo; Editar {else} Agregar categoría{/if}</div>

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=programa_salud&submodulo=categoria_form" method="post" name="f_record" id="f_record">
                    <input type="hidden" name="idprograma_categoria" id="idprograma_categoria" value="{$record.idprograma_categoria}" />
                    <input type="hidden" name="programa_salud_idprograma_salud" id="programa_salud_idprograma_salud" value="{$programa_salud.idprograma_salud}" />

                    <div class="form_container ">
                        <div class="title">Categoría del programa de salud</div>
                        <ul>

                            &nbsp;
                            <li class="wide">
                                <label>Nombre de la categoría * </label>
                                {x_form_input id="programa_categoria" descriptor="none" isRequired="true" maxChars=255 class="" record=$record}
                            </li>
                            <li class="wide">
                                <label>Descripción </label>
                                <textarea id="descripcion" name="descripcion">{$record.descripcion}</textarea>

                            </li>

                        </ul>


                        <div class="clear">&nbsp;</div>
                        {if $record}
                            {*modulo medicos referentes*}
                            <div id="container_listado_medicos_referentes" class="toggle-listado-medicos" data-target="medicos_referentes">

                            </div>

                            <div class="clear">&nbsp;</div>
                            {*modulo medicos complementarios*}
                            <div id="container_listado_medicos_complementarios" class="toggle-listado-medicos" data-target="medicos_complementarios">

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