<style>
    .agregar_especialidad{
        position: absolute;
        overflow: visible;
        display: inline-block;
        padding: 0.5em 1em;
        border: 1px solid #B80C1D;
        border-radius: 5px;
        margin: 0;
        text-decoration: none;
        text-align: center;
        text-shadow: -1px -1px 0 rgba(0,0,0,0.3);
        font: 11px/normal sans-serif;
        color: #FFF;
        white-space: nowrap;
        cursor: pointer;
        outline: none;
        background-color: #D00D20;
    }
     .delete_especialidad{
        position: relative;
        overflow: visible;
        display: inline-block;
        padding: 0.5em ;
        border-radius: 5px;
        border: 1px solid #B80C1D;
        margin: 0;
        text-decoration: none;
        text-align: center;
        text-shadow: -1px -1px 0 rgba(0,0,0,0.3);
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

        <div class="title_bar"><div class="text">MOTIVO VIDEO CONSULTA &raquo; {if $record} EDITAR {else} NUEVA{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=maestros_genericos&submodulo=motivo_videoconsulta_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idmotivoVideoConsulta" id="idmotivoVideoConsulta" value="{$record.idmotivoVideoConsulta}" />

                    <div class="form_container ">
                        <div class="title">Motivo Video Consulta</div>
                        <ul>
                        	
&nbsp;
                            <li class="wide">
                                <label>Motivo * </label> 
                                {x_form_input  id="motivoVideoConsulta" descriptor="none" isRequired="true" maxChars=100 class="" record=$record} 
                            </li>  
                            

                             <li class="wide">
                                <label>Aplicar a Especialidad</label> 
                                <select name="especialidad_idespecialidad" id="especialidad_idespecialidad" class="">
                                    <option value="">Seleccionar...</option>
                                    
                                    {html_options options=$combo_especialidades}                        
                                </select>  
                                <span class="agregar_especialidad" id="agregar_especialidad" title="Agregar">+ Agregar</span>
                            </li> 
                            

                        </ul>

                        <div class="clear">&nbsp;</div> 
                        <div id="listado_especialidades" {if $listado_especialidades}style="display:block;"{else}style="display:none"{/if}>
                           <div class="title">Especialidades</div>
                            <ul>
                                {foreach from=$listado_especialidades item=especialidad}
                                <li data-id="{$especialidad.idmotivovideoconsulta_especialidad}" data-especialidad="{$especialidad.especialidad_idespecialidad}" class="especialidad"><span class="delete_especialidad" data-id="{$especialidad.idmotivovideoconsulta_especialidad}" title="Eliminar"> X </span> {$especialidad.especialidad} </li>
                                {/foreach}
                            </ul>
                       
                       

                    </div>


                    <div class="clear">&nbsp;</div>


                </form>
            </div> 
        </div>  
        <div class="end">&nbsp;</div> 
    </div>   
</div>