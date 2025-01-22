<div id="colRight">
    
    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />
    
    
    <div class="block">
        
        <div class="title_bar"><span class="text">	INFORMACIÓN GEOGRÁFICA &raquo; {$pais.pais|strtoupper} &raquo; LOCALIDADES  </span>
            
            {x_form_html_button id="btnNew" label="Nuevo"  w="100" type="button" class="icon add" }&nbsp;
            
            {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'maestros_localizacion'" p2="'pais_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
            
        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">
            
            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=maestros_localizacion&submodulo=localidad_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >
                    
                    <input type="hidden" name="pais_idpais" id="pais_idpais" value="{$smarty.request.pais_idpais}" />
                    
                    <div class="form_container">
                        <div class="title">
                            Consulta de Localidades
                        </div>
                        
                        <ul>
                            
                            <li class="right">
                                <label>Localidad</label> 
                                {x_form_input  id="localidad" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.localidad} 
                            </li> 
                            
                            <li class="left">
                                <label>C&oacute;digo postal</label> 
                                {x_form_input  id="cpa" descriptor="none" isRequired="false" maxChars=45 class="" record=$paginate.request}
                            </li>                              
                            
                            <li class="clear"></li>
                            <li class="wide">           
                                {x_form_html_button id="btnFilter" label="Buscar" class="icon search" w="100" type="button"} 
                                
                                {x_form_html_button id="btnLimpiar" label="Limpiar" class="reload" w="100" type="button"} 
                                
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
    
    
