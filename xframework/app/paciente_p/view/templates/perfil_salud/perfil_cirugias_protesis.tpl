{include file="perfil_salud/profile_settings.tpl"}

{include file="perfil_salud/menu_perfil_salud.tpl"}

{*<section class="module-header container-fluid">
<div class="row ">
<div class="col-md-12">
<div class="container">
<ol class="breadcrumb">
<li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
<li><a href="{$url}panel-paciente/perfil-salud/">{"Perfil de Salud"|x_translate}</a></li>
<li class="active">{"Cirugias y protesis"|x_translate}</li>
</ol>
</div>
</div>
</div>
</section>*}
<div id="div_cirugias_protesis">
    <input type="hidden" id="idpaciente" value="{$paciente.idpaciente}"/>
    <input type="hidden" id="idperfilSaludCirugiasProtesis" value="{$cirugias_protesis.idperfilSaludCirugiasProtesis}"/>
    <input type="hidden" id="listado_protesis" value="{if !$listado_protesis}0{else}1{/if}"/>
    <input type="hidden" id="listado_cirugias" value="{if !$listado_cirugias}0{else}1{/if}"/>
    <section class="profile patient">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <form id="cirugia_form" action="{$url}save_cirugias.do" method="post"  style="display:none"  onsubmit="return false;">

                    </form>

                    <form id="protesis_form" action="{$url}save_protesis.do" method="post"  style="display:none"  onsubmit="return false;">

                    </form>

                    <section class="data-form health-profile ajustes-panel-paciente" id="health-profile">
                        <h1 class="section-header icon-svg circle surgery text-center">{"Cirugías e intervenciones"|x_translate}</h1>
                        <div class="form patient-file">
                            <div class="row">


                                <div class="col-md-9 col-md-offset-3">
                                    <div class="item-wrapper">
                                        <span class="question small">1. {"Cirugías"|x_translate}</span>
                                        <label class="checkbox" for="check_cirugia_si" style="display:inline">
                                            <input type="checkbox" data-toggle="checkbox" value="1" id="check_cirugia_si" name="posee_cirugia" {if $cirugias_protesis.posee_cirugia=="1"} checked{/if} class="custom-checkbox">
                                            {"Si"|x_translate}
                                        </label>
                                        <label class="checkbox" for="check_cirugia_no" style="display:inline">
                                            <input type="checkbox" data-toggle="checkbox" value="0" id="check_cirugia_no" name="posee_cirugia" {if $cirugias_protesis.posee_cirugia=="0"} checked{/if} class="custom-checkbox">
                                            {"No"|x_translate}
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <form id="cirugia_modificaciones_form" action="{$url}save_modificaciones_cirugias.do" method="post"   onsubmit="return false;">
                                <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}"/>
                                <div id="div_listado_cirugias">
                                    <input type="hidden" id="cantidad_cirugias" value="{$cantidad_cirugias}" />
                                    {foreach from=$listado_cirugias item=cirugia}
                                        <div class="row" id="div_row_{$cirugia.idperfilSaludCirugias}">
                                            <div class="col-md-3">
                                                <div class="form-group item-multiple">
                                                    <input class="input-inline" type="text" name="cirugia[{$cirugia.idperfilSaludCirugias}]"  placeholder='{"Cirugía"|x_translate}' value="{$cirugia.cirugia}" style="margin-top:6px">
                                                </div>
                                            </div>

                                            <input type="hidden" name="idperfilSaludCirugias[{$cirugia.idperfilSaludCirugias}]" value="{$cirugia.idperfilSaludCirugias}"/>
                                            <div class="col-md-9">
                                                <div class="form-group item-multiple">
                                                    <table class="table-responsive">
                                                        <tbody>

                                                            <tr>
                                                                <td><input class="input-inline"  type="text" placeholder='{"¿Cuándo?"|x_translate}' value="{$cirugia.cuando}" name="cuando[{$cirugia.idperfilSaludCirugias}]"></td>
                                                                <td><input class="input-inline"  type="text" placeholder='{"¿Cómo?"|x_translate}' value="{$cirugia.como}" name="como[{$cirugia.idperfilSaludCirugias}]"></td>
                                                                <td><button class="dp-trash delete delete_cirugia" data-id="{$cirugia.idperfilSaludCirugias}"></button></td>
                                                            </tr>
                                                            <tr>
                                                                <td><input class="input-inline"  type="text" placeholder='{"¿Dónde?"|x_translate}' value="{$cirugia.donde}" name="donde[{$cirugia.idperfilSaludCirugias}]"></td>
                                                                <td><input class="input-inline"  type="text" placeholder='{"¿Por Qué?"|x_translate}' value="{$cirugia.porque}" name="porque[{$cirugia.idperfilSaludCirugias}]"></td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td></td>
                                                                <td></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    {/foreach}
                                </div>
                            </form>



                            <p><div class="clearfix"></div></p>

                            <div class="row" id="div_add_cirugia" {if !$listado_cirugias}style="display:none"{/if}>
                                <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}"/>
                                <input type="hidden" name="idperfilSaludCirugiasProtesis" value="{$cirugias_protesis.idperfilSaludCirugiasProtesis}"/>

                                <div class="col-md-3">
                                    <div class="form-group item-multiple">
                                        <input class="input-inline" type="text" placeholder='{"Cirugía"|x_translate}' name="cirugia" id="cirugia_input" style="margin-top:6px">
                                    </div>
                                </div>
                                <div class="col-md-9">
                                    <div class="form-group item-multiple">
                                        <table class="table-responsive">
                                            <tbody>

                                                <tr>
                                                    <td><input class="input-inline" type="text" placeholder='{"¿Cuándo?"|x_translate}' name="cuando" id="cuando_input"></td>
                                                    <td><input class="input-inline" type="text" placeholder='{"¿Cómo?"|x_translate}' name="como" id="como_input"></td>
                                                    <td>{*<button class="dp-trash delete"></button>*}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td><input class="input-inline" type="text" placeholder='{"¿Dónde?"|x_translate}'  name="donde" id="donde_input"></td>
                                                    <td><input class="input-inline" type="text" placeholder='{"¿Por Qué?"|x_translate}'  name="porque" id="porque_input"></td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td><button class="add-item dp-plus btn agregar_cirugias">{"Agregar"|x_translate}</button></td>
                                                    <td></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>



                            <div class="row">
                                <div class="col-md-9 col-md-offset-3">
                                    <div class="item-wrapper">
                                        <span class="question small">2. {"Prótesis"|x_translate}</span>

                                        <label class="checkbox" for="check_protesis_si" style="display:inline">
                                            <input type="checkbox" data-toggle="checkbox" value="1" id="check_protesis_si" name="posee_protesis" {if $cirugias_protesis.posee_protesis=="1"}checked{/if} class="custom-checkbox">
                                            {"Si"|x_translate}
                                        </label>
                                        <label class="checkbox" for="check_protesis_no" style="display:inline">
                                            <input type="checkbox" data-toggle="checkbox" value="0" id="check_protesis_no" name="posee_protesis" {if $cirugias_protesis.posee_protesis=="0"}checked{/if} class="custom-checkbox">
                                            {"No"|x_translate}
                                        </label>


                                    </div>
                                </div>
                            </div>

                            <form id="protesis_modificaciones_form" action="{$url}save_modificaciones_protesis.do" method="post"   onsubmit="return false;">
                                <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}"/>    
                                <div id="div_listado_protesis">
                                    <input type="hidden" id="cantidad_protesis" value="{$cantidad_protesis}" />
                                    {foreach from=$listado_protesis item=protesis}
                                        <div class="row" id="div_row_protesis_{$protesis.idperfilSaludProtesis}">
                                            <div class="col-md-9 col-md-offset-3">
                                                <input type="hidden" name="idperfilSaludProtesis[{$protesis.idperfilSaludProtesis}]" value="{$protesis.idperfilSaludProtesis}"/> 
                                                <div class="form-group item-multiple">
                                                    <table>
                                                        <tbody>
                                                            <tr>
                                                                <td><input class="input-inline" name="tipo_aparato[{$protesis.idperfilSaludProtesis}]" type="text" value="{$protesis.tipo_aparato}" placeholder='{"Tipo de aparato, dónde"|x_translate}'></td>
                                                                <td><input class="input-inline" name="desde_cuando[{$protesis.idperfilSaludProtesis}]" type="text" value="{$protesis.desde_cuando}" placeholder='{"¿Desde Cuándo?"|x_translate}'></td>
                                                                <td><button data-id="{$protesis.idperfilSaludProtesis}" class="dp-trash delete delete_protesis"></button></td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td></td>
                                                                <td></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    {/foreach}
                                </div>
                            </form>

                            <p><div class="clearfix"></div></p>
                            <div class="row" {if !$listado_protesis}style="display:none"{/if} id="div_add_protesis">
                                <div class="col-md-9 col-md-offset-3">
                                    <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}"/> 
                                    <input type="hidden" name="idperfilSaludCirugiasProtesis" value="{$cirugias_protesis.idperfilSaludCirugiasProtesis}"/>


                                    <div class="form-group item-multiple">
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td><input class="input-inline" name="tipo_aparato" type="text" placeholder='{"Tipo de aparato, dónde"|x_translate}'></td>
                                                    <td><input class="input-inline" name="desde_cuando" type="text" placeholder='{"¿Desde Cuándo?"|x_translate}'></td>
                                                    <td>{*<button class="dp-trash delete"></button>*}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td><button class="add-item dp-plus btn agregar_protesis">{"Agregar"|x_translate}</button></td>
                                                    <td></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-12 center">
                                    <button type="submit" id="btnGrabarDatos"  class="submit">{"grabar datos"|x_translate}</button>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </section>


</div>

{x_load_js}