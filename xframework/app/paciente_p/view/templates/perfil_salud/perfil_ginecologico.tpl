{include file="perfil_salud/profile_settings.tpl"}

{include file="perfil_salud/menu_perfil_salud.tpl"}
{*<section class="module-header container-fluid">
    <div class="row ">
        <div class="col-md-12">
            <div class="container">
                <ol class="breadcrumb">
                    <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
                    <li><a href="{$url}panel-paciente/perfil-salud/">{"Perfil de Salud"|x_translate}</a></li>
                    <li class="active">{"Ginecología y obstetricia"|x_translate}</li>
                </ol>
            </div>
        </div>
    </div>
</section>*}

<section class="module-header nueva-consulta-header container-fluid">
    <div class="row">
        <figure class="circle-icon-ginecology"></figure>
        <h1>{"Ginecología y obstetricia"|x_translate}</h1>
    </div>
</section>	

<section class="antecedentes-ginecologicos container">
<div class="antecedentes-ginecologicos-holder">
            <form id="antecedentes_ginecologicos_form3" action="{$url}save_perfil_ginecologico.do" method="post"  onsubmit="return false;">
                <input type="hidden" name="idperfilSaludGinecologico" class="paciente_idpaciente" value="{$record.idperfilSaludGinecologico}"/>
                <input type="hidden" name="paciente_idpaciente" id="paciente_idpaciente" value="{$paciente.idpaciente}"/>
       <input type="hidden" name="from_embarazo" value="1"/>
  
                
                        <h2>{"Embarazo / Antecedentes obstétricos"|x_translate}</h2>
                   
              
               <div class="row input-row">
				<div class="col-sm-4">
					<label for="actualmente-embarazada" >{"¿Actualmente se encuentra embarazada?"|x_translate}</label>
				</div>
				<div class="col-sm-8" id="is_embarazada">
					<div class="check-holder">
						<label class="checkbox" for="is_embarazada_si">
                                    <input type="radio" value="1" id="is_embarazada_si" name="is_embarazada" {if $record.is_embarazada=="1"} checked {/if} >{"Si"|x_translate}
						</label>
						<label class="checkbox" for="is_embarazada_no">
                                    <input type="radio" value="0" id="is_embarazada_no" name="is_embarazada"  {if $record.is_embarazada=="0"} checked {/if} >{"No"|x_translate}
						</label>
					</div>
				</div>
			</div>
               
                    <div class="row input-row">
				<div class="col-sm-6 col-sm-offset-2">						
                        <div class="row">
                                    <div class="col-sm-12 col-md-3">
                                            <label title='{"Fecha última menstruación"|x_translate}' class="right">{"FUM"|x_translate}</label>
                                    </div>
                                <div class="col-sm-12 col-md-9">
                                <div class="select-style">
                                    <select name="fum_dia">
                                        <option value="">{"Dia"|x_translate}</option>
                                        {html_options options=$combo_dias selected=$record.split_fum.dia}
                                    </select>
                                </div>
                                <div class="select-style">
                                    <select name="fum_mes">
                                        <option value="">{"Mes"|x_translate}</option>
                                        {html_options options=$combo_meses selected=$record.split_fum.mes}
                                    </select>
                                </div>
                                <div class="select-style">
                                    <select name="fum_anio" >
                                        <option value="">{"Año"|x_translate}</option>
                                        {html_options options=$combo_anios selected=$record.split_fum.anio}
                                    </select>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                        
                        <div class="row input-row">
				<div class="col-sm-4 col-xs-9">
					<label>{"Embarazos llevados a término"|x_translate}</label>
				</div>
				<div class="col-sm-8 col-xs-3">
                                <input type="number" id="embarazos_a_terminos"  name="embarazos_a_terminos" placeholder="" value="{$record.embarazos_a_terminos}">
				</div>
			</div>
           
                        <div class="row input-row">
				<div class="col-sm-4 col-xs-6">
					<label >{"Cesáreas"|x_translate}</label>
				</div>
				<div class="col-sm-2 col-xs-6">
                                <input type="number" id="cesareas" name="cesareas"  class="input-small" placeholder="" value="{$record.cesareas}">			
                                </div>
				<div class="clearfix visible-xs"></div>
				<div class="col-sm-2 col-xs-6">
					<label class="right">{"Abortos"|x_translate}</label>
				</div>
				<div class="col-sm-3 col-xs-6">
                                <input type="number" id="abortos" name="abortos"  class="input-small" placeholder="" value="{$record.abortos}">
				</div>
			</div>

                



                <div class="row">
                    <div class="col-md-12">
                        <button class="btn btn-md btn-inverse" id="save_3">{"grabar datos"|x_translate}</button>
                    </div>
                </div>

            </form>
       
    </div>
</section>


<section class="antecedentes-ginecologicos container">
    <div class="row">
        <div class="antecedentes-ginecologicos-holder controles-holder">
            <form id="antecedentes_ginecologicos_form2" action="{$url}save_perfil_ginecologico.do" method="post"  onsubmit="return false;">
                <input type="hidden" name="idperfilSaludGinecologico" value="{$record.idperfilSaludGinecologico}"/>
                <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}"/>
                <input type="hidden" name="from_controles" value="1"/>
                
                <div class="row">
                    <div class="col-sm-12">
                        <h2>{"Controles"|x_translate}</h2>
                    </div>
                </div>

                <div class="row input-row">
                    <div class="col-sm-12 col-md-4">
                        <label class="right">{"Fecha último PAP"|x_translate}</label>
                    </div>
                    <div class="col-sm-6 col-md-5" id="div_pap">

                      
                        <div class="select-style50">
                            <select name="pap_mes">
                                <option value="">{"Mes"|x_translate}</option>
                                {html_options options=$combo_meses selected=$record.split_pap.mes}
                            </select>
                        </div>
                        <div class="select-style50">
                            <select name="pap_anio">
                                <option value="">{"Año"|x_translate}</option>
                                {html_options options=$combo_anios selected=$record.split_pap.anio}
                            </select>
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-3">
                        <label class="checkbox" for="pap-nunca-ralizo">
                            <input type="checkbox" value="1" id="pap-nunca-ralizo" name="no_pap" data-toggle="checkbox" {if $record.no_pap == "1"} checked {/if}>
                                   {"Nunca se realizó"|x_translate}
                        </label>
                    </div>
                </div>

                <div class="row input-row">
                    <div class="col-sm-12 col-md-4">
                        <label class="right">{"Fecha última mamografía"|x_translate}</label>
                    </div>
                    <div class="col-sm-6 col-md-5" id="div_mam">

                        
                        <div class="select-style">
                            <select name="mam_mes">
                                <option value="">{"Mes"|x_translate}</option>
                                {html_options options=$combo_meses selected=$record.split_mam.mes}
                            </select>
                        </div>
                        <div class="select-style">
                            <select name="mam_anio">
                                <option value="">{"Año"|x_translate}</option>
                                {html_options options=$combo_anios selected=$record.split_mam.anio}
                            </select>
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-3">
                        <label class="checkbox" for="mamografia-nunca-realizo">
                            <input type="checkbox" value="1" id="mamografia-nunca-realizo" name="no_mam" data-toggle="checkbox" {if $record.no_mam == "1"} checked {/if}>
                                   {"Nunca se realizó"|x_translate}
                        </label>
                    </div>
                </div>

                <div class="row input-row">
                    <div class="col-sm-12 col-md-4">
                        <label class="right">{"VPH"|x_translate}</label>
                    </div>
                    <div class="col-sm-12 col-md-8">
                        <div class="check-holder" id="check_VPH">
                            <label class="checkbox" for="VPH-si">
                                <input type="radio" value="1" name="VPH" id="VPH-si" data-toggle="checkbox" {if $record.VPH == "1"}checked{/if}>
                                       {"Si"|x_translate}
                            </label>
                            <label class="checkbox" for="VPH-no">
                                <input type="radio" value="0" name="VPH" id="VPH-no" data-toggle="checkbox" {if $record.VPH == "0"}checked{/if}>
                                       {"No"|x_translate}
                            </label>
                            <label class="checkbox" for="VPH-vacuna">
                                <input type="radio" value="2" name="VPH" id="VPH-vacuna" data-toggle="checkbox" {if $record.VPH == "2"}checked{/if}>
                                       {"Vacuna"|x_translate}
                            </label>
                        </div>
                    </div>
                </div>	

                <div class="row">
                    <div class="col-md-12">
                        <button class="btn btn-md btn-inverse" id="save_2">{"grabar datos"|x_translate}</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</section>

<section class="antecedentes-ginecologicos container">
    <div class="antecedentes-ginecologicos-holder">
        <form id="antecedentes_ginecologicos_form1" action="{$url}save_perfil_ginecologico.do" method="post" onsubmit="return false;">
            <input type="hidden" name="idperfilSaludGinecologico" value="{$record.idperfilSaludGinecologico}"/>
            <input type="hidden" name="paciente_idpaciente"  value="{$paciente.idpaciente}"/>
                   <input type="hidden" name="from_antecedentes" value="1"/>
            <div class="row">
                <div class="col-sm-12">
                    <h2>{"Antecedentes ginecológicos"|x_translate}</h2>
                </div>
            </div>
            <div class="row input-row" id="div_menarca_cont">
                <div class="col-sm-2">
                    <label>{"Menarca"|x_translate}</label>
                </div>
                <div class="check-holder" >
                    <div class="col-sm-4 col-xs-6">
                        <label for="posee_menarca_si" class="checkbox"><input type="radio" value="1"  name="posee_menarca" id="posee_menarca_si" {if $record.posee_menarca == "1"}checked{/if}> {"Si"|x_translate}</label>
                        <input type="text" name="menarca" id="menarca" placeholder='{"¿A qué edad?"|x_translate}' value="{$record.menarca}" style="width:100px">						
                    </div>
                    <div class="col-sm-3 col-xs-6">
                        <label for="posee_menarca_no" class="checkbox"><input type="radio" name="posee_menarca" value="0" id="posee_menarca_no" {if $record.posee_menarca == "0"}checked{/if} > {"No"|x_translate}</label>
                    </div>
                </div>


            </div>


            <div class="row input-row">
                <div class="col-sm-2 col-xs-4">
                    <label>{"Ritmo"|x_translate}</label>
                </div>
                <div class="col-sm-4 col-xs-8">
                    <input type="number" id="ritmo" name="ritmo" placeholder='{"Cada cuántos días"|x_translate}' value="{$record.ritmo}">
                </div>
                <div class="clearfix visible-xs"></div>
                <div class="col-sm-2 col-xs-4">
                    <label>{"Perioricidad"|x_translate}</label>
                </div>
                <div class="col-sm-4 col-xs-8">
                    <input type="number" name="perioricidad" placeholder='{"Cuánto dura"|x_translate}' value="{$record.perioricidad}">
                </div>
            </div>





            <div class="row input-row">
                <div class="col-sm-2">
                    <label>{"Inicio vida sexual activa"|x_translate}</label>
                </div>
                <div  id="div_inicio_vida_sexual">
                    <div class="check-holder">
                        <div class="col-sm-4 col-xs-6">
                            <label class="checkbox" for="inicio-vida-sexual-activa-si">
                                <input type="radio" value="1" id="inicio-vida-sexual-activa-si" name="vida_sexual_activa" data-toggle="checkbox" {if $record.vida_sexual_activa == "1"}checked{/if}>{"Si"|x_translate}
                            </label>
                        </div>
                        <div class="col-sm-6 col-xs-6">
                            <label class="checkbox" for="inicio-vida-sexual-activa-no">
                                <input type="radio" value="0" id="inicio-vida-sexual-activa-no" name="vida_sexual_activa"  data-toggle="checkbox" {if $record.vida_sexual_activa === "0"}checked{/if}>{"No"|x_translate}
                            </label>
                        </div>
                    </div>
                </div>
            </div>


            <div class="row">
                <div class="col-md-12">
                    <button class="btn btn-md btn-inverse" id="save_1">{"grabar datos"|x_translate}</button>
                </div>
            </div>
        </form>

    </div>
</section>


{x_load_js}