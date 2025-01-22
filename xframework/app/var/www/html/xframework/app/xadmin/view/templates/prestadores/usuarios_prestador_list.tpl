

    <input type="hidden" id="list_actual_page_7" value="{$paginate.current_page}" />

         <div class="clear">&nbsp;</div>  
                <form action="{$controller}.php?action=1&modulo=prestadores&submodulo=usuarios_prestador_list"  method="post"  name="f_busqueda_usuario" id="f_busqueda_usuario" >
                <input type="hidden"  id="idprestador_win3" name="idprestador" value="{$smarty.request.idprestador}" />

                    <div class="form_container">
                        <div class="title">
                            Usuarios
                        </div>
                        <ul>
                            <li class="left">
                                <label>BUSQUEDA </label> 
                                {x_form_input  id="busqueda" descriptor="none" isRequired="false" maxChars=50 class="" value=$paginate.request.nombre} 
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
         
        {x_form_html_button id="btnAddUsuario" label="Agregar usuarios" w="100" type="button" class="icon add"}
 
            <div  class="xTable" id="xTable">
                <div class="container">		
                    <table id="list_usuario">
                    </table> 
                    <div id="pager_usuario"></div>
                </div>     
            </div> 
     
      
    </div>         

