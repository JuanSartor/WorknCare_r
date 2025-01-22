<div id="colRight">	

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />
    
    <div class="block">

        <div class="title_bar"><span class="text">SUSCRIPCIONES MENSUALES &raquo; </span>

            {*x_form_html_button id="btnNew" label="Nuevo" w="100" type="button" class="icon add"*}

        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=contable&submodulo=comprobante_pago_cuenta_profesional" target="_blank"  method="post"  name="f_comprobante" id="f_comprobante" >

                    <div class="form_container">
                        <div class="title">
                            Consulta de suscripciones mensuales de cuentas profesionales
                        </div>

                        <ul>
                            
                            <li class="left">
                                <label>Fecha Desde </label> 
                                {x_form_date date_format="%d/%m/%Y"  input_format = "dd/mm/yyyy" input_name="fecha_desde" isRequired="false" value=$paginate.request.fecha_desde}
                            </li>   
                            <li class="right">
                                <label>Fecha Hasta </label> 
                                {x_form_date date_format="%d/%m/%Y"  input_format = "dd/mm/yyyy" input_name="fecha_hasta" isRequired="false" value=$paginate.request.fecha_hasta}
                            </li>  
                            
                            
                            <li class="left">
                                <label>Médico </label> 
                                {x_form_input  id="nombre_medico" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.nombre_medico} 
                            </li>   
                            
                            <li class="right">
                                <label>Estado </label> 
                                <select name="tipoBanner_idtipoBanner" id="tipoBanner_idtipoBanner" class="">
                                    <option value="1">Facturado</option>  
                                    <option value="0">Pendiente</option>    
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

            <div  class="xTable" id="xTable">
                <div class="container">		
                    <table id="list">
                    </table> 
                    <div id="pager"></div>
                </div>     
            </div> 
        </div>
        <div class="end">&nbsp;</div>
    </div>         
</div>