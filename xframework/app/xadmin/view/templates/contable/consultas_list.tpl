<div id="colRight">	

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />

    <div class="block">

        <div class="title_bar"><span class="text">LISTADO DE CONSULTAS &raquo; </span>



        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=contable&submodulo=consultas_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >

                    <div class="form_container">
                        <div class="title">
                            Consultas 
                        </div>

                        <ul>

                            <li class="left">
                                <label>Médico </label> 
                                {x_form_input  id="nombre_medico" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.nombre_medico} 
                            </li>   
                            <li class="left">
                                <label>Paciente </label> 
                                {x_form_input  id="nombre_paciente" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.nombre_paciente} 
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
                            <li class="right">
                                <label>Tipo Consulta </label> 
                                <select name="tipo_consulta" id="tipo_consulta" class="">
                                    <option value="">Seleccionar...</option>
                                    <option value="1">Consulta Express</option>       
                                    <option value="2">Video Consulta</option>   

                                </select>   
                            </li>
                            <li class="right">
                                <label>Estado </label> 
                                <select name="estado" id="estado" class="">
                                    <option value="">Seleccionar...</option>
                                    <option value="1">Pendientes</option>
                                    <option value="2">Abiertas</option>
                                    <option value="3">Rechazadas</option>
                                    <option value="4">Finalizadas</option>
                                    <option value="5">Vencidas</option>
                                    <option value="8">Pendiente Finalización </option>
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