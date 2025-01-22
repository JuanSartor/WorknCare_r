<div id="colRight">
	
	<input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />


    <div class="block">

	<div class="title_bar"><span class="text">	INFORMACIÓN GEOGRÁFICA &raquo; PAISES  </span>
    
    {x_form_html_button id="btnNew" label="Nuevo" function_name="x_goTo" w="100" type="button" p1="'maestros_localizacion'" p2="'pais_form'" p3="''" class="icon add" p4="'Main'" p5="this"}&nbsp;

    {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'maestros_localizacion'" p2="'index'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
    
    </div>    
		<div class="top">&nbsp;</div>
        <div class="contenido">

<div class="xForm">
                <form action="{$controller}.php?action=1&modulo=maestros_localizacion&submodulo=pais_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >
              
                
                <div class="form_container">
                    <div class="title">
                            Consulta de Paises
                    </div>
                    
                    <ul>

                <li class="left">
                    <label>Descripci&oacute;n</label> 
                    {x_form_input  id="descripcion" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.descripcion} 
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


