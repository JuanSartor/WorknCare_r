<div id="colRight">	
    <form action="{$controller}.php?action=1&modulo=contable&submodulo=resumen_periodo_pdf"  target="_blank" method="post" id="f_pdf" >
         <input type="hidden" name="idperiodoPago" id="idperiodoPago" value="">
    </form>
    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />
        
    <div class="block">
        
        <div class="title_bar"><span class="text">RECAUDACIONES &raquo; </span>
            
         
                
        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">
            
            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=contable&submodulo=recaudaciones_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >
                    
                    <div class="form_container">
                        <div class="title">
                           Recaudaciones de médicos
                        </div>
                            
                        <ul>
  
                            <li class="left">
                                <label>Médico </label> 
                                {x_form_input  id="nombre_medico" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.nombre_medico} 
                            </li>   

                            
                            <li class="right">
                                <label>Estado </label> 
                                <select name="estado" id="estado" class="">
                                    <option value="">Seleccionar...</option>
                                    <option value="-1">Pendiente</option>       
                                    <option value="0">En proceso</option>   
                                    <option value="1">Pagado</option>   
                                    <option value="2">Retendio</option>   
                                </select>   
                            </li>
                            <li class="left">
                                <label>Período desde</label> 
                                 <select name="date_periodo_desde" id="date_periodo_desde" class="">
                                    <option value="">Seleccionar...</option>
                                    {foreach from=$list_periodos item=periodo}
                                      <option value="{$periodo.id}">{$periodo.descripcion}</option>
                                   {/foreach}                  
                                </select>   
                            </li>   
                            <li class="right">
                                <label>Período hasta</label> 
                                 <select name="date_periodo_hasta" id="date_periodo_hasta" class="">
                                    <option value="">Seleccionar...</option>
                                    {foreach from=$list_periodos item=periodo}
                                      <option value="{$periodo.id}">{$periodo.descripcion}</option>
                                   {/foreach}                  
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
                        Total recaudación: $ <span id="span_total_recaudacion"></span>
                    </div>
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