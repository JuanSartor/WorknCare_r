<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">ESPECIALIDAD &raquo; {if $record} EDITAR {else} NUEVA{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=maestros_especialidades&submodulo=maestros_especialidades_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idespecialidad" id="idobraSocial" value="{$record.idespecialidad}" />

                    <div class="form_container ">
                        <div class="title">Datos de la Especialidad</div>
                        <ul>

                            &nbsp;
                            <li class="wide">
                                <label>Nombre Especialidad * </label> 
                                {x_form_input  id="especialidad" descriptor="none" isRequired="true" maxChars=45 class="" record=$record} 
                            </li>  
                            <li class="left">
                                <label>Tipo </label> 
                                <select name="tipo" id="tipo" class="">
                                    <option value="1" {if $record.tipo==1}selected{/if}>Especialidad médica</option>                    
                                    <option value="2" {if $record.tipo==2}selected{/if}>Profesional de la salud (no médica)</option>   
                                </select>                 
                            </li>  
                            <li class="right checkbox-inline">
                                <label>Tipo de identificación</label> 
                                <select name="tipo_identificacion" id="tipo_identificacion" class="">
                                    <option value="0" {if $record.tipo_identificacion=="0"}selected{/if}>RPPS</option>   
                                    <option value="1" {if $record.tipo_identificacion=="1"}selected{/if}>ADELI</option>                    
                                    <option value="2" {if $record.tipo_identificacion=="2"}selected{/if}>Otra</option>     
                                </select>     
                            </li> 
                            <li class="left checkbox-inline">
                                <label>Requiere número AM</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 default=$record.requiere_numero_am name="requiere_numero_am" id="requiere_numero_am"}
                            </li> 
                            <li class="right checkbox-inline">
                                <label>Requiere Sector</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 default=$record.requiere_sector name="requiere_sector" id="requiere_sector"}
                            </li> 

                            <li class="left checkbox-inline">
                                <label>Médico especialista de acceso directo</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 default=$record.acceso_directo name="acceso_directo" id="acceso_directo"}
                            </li> 
                            <li class="right checkbox-inline">
                                <label>Requiere Modo Facturacion teleconsulta</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 default=$record.requiere_modo_facturacion name="requiere_modo_facturacion" id="requiere_modo_facturacion"}
                            </li> 
                            <li class="left">
                                <label> Max VC Turno (€) </label> 
                                {x_form_input  id="max_vc_turno" descriptor="real" isRequired="true" class="" record=$record} 
                            </li> 
                            <li class="right checkbox-inline">
                                <label>Acceso Perfil de Salud</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 default=$record.acceso_perfil_salud name="acceso_perfil_salud" id="acceso_perfil_salud"}
                            </li> 

                        </ul>

                        <div class="clear">&nbsp;</div>
                        <div class="clear">&nbsp;</div> 
                        {if $record}
                            <div id="listado_motivos_ce" class="toggle-listado-motivos" data-target="motivos_ce">
                                <div class="title" style="cursor:pointer">Motivos de Consulta Express</div>
                                <div id="motivos_ce"  style="padding-left: 15px; display:none;">
                                    {foreach from=$listado_motivos_ce item=motivo}
                                        <div class="motivo">
                                            {$motivo}
                                        </div>
                                    {/foreach}
                                </div>
                            </div>
                            <div id="listado_motivos_vc" class="toggle-listado-motivos" data-target="motivos_vc">
                                <div class="title" style="cursor:pointer">Motivos de Video Consulta</div>
                                <div id="motivos_vc"  style="padding-left: 15px; display:none;">
                                    {foreach from=$listado_motivos_vc item=motivo}
                                        <div class="motivo">
                                            {$motivo}
                                        </div>
                                    {/foreach}
                                </div>
                            </div>

                            <div id="listado_motivos_visita" class="toggle-listado-motivos" data-target="motivos_visita">
                                <div class="title" style="cursor:pointer">Motivos de Visita Presencial</div>
                                <div id="motivos_visita"  style="padding-left: 15px; display:none;">
                                    {foreach from=$listado_motivos_visita item=motivo}
                                        <div class="motivo">
                                            {$motivo}
                                        </div>
                                    {/foreach}
                                </div>
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