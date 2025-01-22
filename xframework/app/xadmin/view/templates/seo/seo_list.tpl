<div id="colRight">	

	<input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />


    <div class="block">

	<div class="title_bar"><span class="text">	SEO &raquo;</span>
    
    {x_form_html_button id="btnNew" label="Nuevo" function_name="x_goTo" w="100" type="button" p1="'seo'" p2="'seo_form'" p3="''" class="icon add" p4="'Main'" p5="this"}&nbsp;

    
    </div>    
		<div class="top">&nbsp;</div>
        <div class="contenido">

<div class="xForm">
                <form action="{$controller}.php?action=1&modulo=seo&submodulo=seo_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >
              
                
                <div class="form_container">
                    <div class="title">
                            Filtro
                    </div>
                    
                    <ul>

                    <li class="left">
                        <label>Seo</label> 
                        {x_form_input  id="recipe" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.seo} 
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


