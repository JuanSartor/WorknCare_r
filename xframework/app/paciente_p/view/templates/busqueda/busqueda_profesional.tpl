<style>
    @media (min-width:600px){
        .pbr-img-back{
            min-height: 370px;
        }
    }
</style>

<div id="busqueda_profesional">

    <section class="pbr-background">

        <form name="f_busqueda_profesionales" id="f_busqueda_profesionales" action="{$url}panel-paciente/busqueda-profesional/resultado/">

            <div class="container pbr-container pbr-img-back pbr-container">
                <div class="pbr-holder">
                    <div class="pbr-form-holder">
                        <div class="okm-row">
                            <div class="pbr-buscador-title">
                                <h1>{"Buscador de profesionales"|x_translate}</h1>
                            </div>
                        </div>

                        <div class="okm-row" >

                            <div class="pbr-form-col-left opacity-col">
                                <div class="pbr-form-item pbr-select">
                                    <div class="cs-nc-p2-input-holder">

                                        <input type="hidden" id="idprograma_categoria" name="idprograma_categoria" value="">
                                        <input type="hidden" id="idprograma_salud" name="idprograma_salud" value="">
                                        <div class="dropdown dropdown-programas-container select2-container form-control select select-primary select-block mbl">
                                            <a class="select2-choice" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                                                <span class="label-default"> {"Seleccione un programa de salud"|x_translate}</span>
                                                <span class="item-seleccionado" style="display: none;"></span>
                                                <span class="select2-arrow" role="presentation"><b role="presentation"></b></span>
                                            </a>
                                            <ul class="select2-results dropdown-menu dropdown-programas" aria-labelledby="dropdownMenu1">
                                                {foreach from=$combo_programas item=programa}
                                                    {if $programa.propio == 0}
                                                        <li>
                                                            <a href="javascript:;" class="select-programa" data-idprograma="{$programa.idprograma_salud}">
                                                                <i class="fa fa-chevron-right"></i> 
                                                                <strong class="nombre-programa" data-idprograma="{$programa.idprograma_salud}">{$programa.programa_salud}:</strong>
                                                                <span class="tag-container" >
                                                                    <div class="programa-destacado-tag" data-id="{$programa.idprograma_salud}">
                                                                        <span class="content">
                                                                            {"Gratuita"|x_translate}
                                                                        </span>
                                                                    </div>
                                                                </span>
                                                            </a>
                                                            <ul class="dropdown-submenu">
                                                                {foreach from=$programa.programa_categoria item=categoria}
                                                                    <li class="select-categoria" data-idprograma="{$programa.idprograma_salud}" data-idcategoria="{$categoria.idprograma_categoria}" >
                                                                        - <span class="nombre-categoria" data-idcategoria="{$categoria.idprograma_categoria}">&nbsp;{$categoria.programa_categoria}</span>
                                                                    </li>
                                                                {/foreach}
                                                            </ul>
                                                        </li>
                                                    {/if}
                                                {/foreach}
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="pbr-form-col-right opacity-col">
                                <div class="pbr-form-item pbr-select">
                                    <select name="especialidad_ti" id="especialidad_ti" class="form-control select select-primary select-block">
                                        <option value="">{"Especialidad"|x_translate}</option>
                                        {html_options options=$combo_especialidades }
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="okm-row" >
                            <div class="pbr-form-col-left opacity-col">
                                <input type="hidden" id="pais_ti" name="pais_ti" value="1" >
                                <div class="pbr-form-item okm-input-icon">                           
                                    <input type=text name="medico_ti" id="medico_ti" placeholder='{"Busca por nombre"|x_translate}'/>
                                    <i class="icon-doctorplus-search"></i>           
                                </div>
                            </div>
                            <div class="pbr-form-col-right opacity-col pbr-advanced-search-row">
                                <div class="pbr-form-item" >
                                    <input type="submit" id="btn_buscar_1" value='{"Buscar"|x_translate}'>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

        </form>
    </section>
    <script>
        var ids_excepciones_programa = "{$ids_excepciones_programa}";
    </script>
    {include file="busqueda/como_funciona.tpl" }
    {x_load_js}

</div>