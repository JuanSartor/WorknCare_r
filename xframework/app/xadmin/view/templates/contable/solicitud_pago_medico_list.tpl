<div id="colRight">	
    
    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />
        
    <div class="block">
        
        <div class="title_bar"><span class="text">SOLICITUDES DE PAGO &raquo; </span>
            
            {*x_form_html_button id="btnNew" label="Nuevo" w="100" type="button" class="icon add"*}
                
        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">
            
            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=contable&submodulo=solicitud_pago_medico_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >
                    
                    <div class="form_container">
                        <div class="title">
                            Consulta de solicitudes de pagos de médicos
                        </div>
                            
                        <ul>
                            
                            <li class="left">
                                <label>Fecha Solicitud </label> 
                                {x_form_date date_format="%d/%m/%Y"  input_format = "dd/mm/yyyy" input_name="fechaSolicitudPago" isRequired="false" value=$paginate.request.fechaSolicitudPago}
                            </li>   
                                
                                
                            <li class="right">
                                <label>Médico </label> 
                                {x_form_input  id="nombre_medico" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.nombre_medico} 
                            </li>   
                                
                            <li class="left">
                                <label>Nombre Banco </label> 
                                {x_form_input  id="nombre_banco" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.nombre_banco} 
                            </li>   
                                
                           <li class="right">
                                <label>Período </label> 
                                 <select name="date_periodo" id="date_periodo" class="">
                                    <option value="">Seleccionar...</option>
                                   {foreach from=$list_periodos item=periodo}
                                      <option value="{$periodo.id}">{$periodo.descripcion}</option>
                                   {/foreach}
                                </select>   
                            </li>   
                             <li class="left">
                                <label>Estado </label> 
                                <select name="estado" id="estado" class="">
                                    <option value="">Seleccionar...</option>
                                 
                                    <option value="0">En proceso</option>   
                                    <option value="1">Pagado</option>   
                                    <option value="2">Retendio</option>   
                                </select>   
                            </li>   
                                
                            <li class="clear"></li>
                            <li class="wide">           
                                {x_form_html_button id="btnFilter" label="Buscar" class="icon search" w="100" type="button"} 
                                    
                                {x_form_html_button id="btnLimpiar" label="Limpiar" class="icon loop" w="100" type="button"} 
                            </li>
                            <li class="clear"></li>
                        </ul>
                    </div>
                </form>
            </div>
            <div class="separator">&nbsp;</div>
    
            <div class="xForm w800 left">
                <div class="form_container w800 left">
                  
                      <div class="title">
                        Total pagado: $ <span id="span_total_pagado"></span>
                    </div>
                    <div class="title">
                        Total pendiente: $ <span id="span_total_pendiente"></span>
                    </div>
                    <div class="title">
                        Total retenido $ <span id="span_total_retenido"></span>
                    </div>
                      <div class="title">
                        Total solicitudes: $ <span id="span_total_solicitudes"></span>
                    </div>
                  
                      <div class="title">
                        Total comisión DP: $ <span id="span_total_comisiones"></span>
                    </div>
                </div>
                 <div class="clear"> </div>  
             </div>
                <div class="clear"> </div>                    
                     
            <div class="separator">&nbsp;</div>
            <div  class="xTable" id="xTable">
                    <div class="container">	
                    
                    <div class="clearfix"></div>
                    <table id="list">
                    </table> 
                    <div id="pager"></div>
                </div>     
            </div> 
        </div>
        <div class="end">&nbsp;</div>
    </div>         
</div>