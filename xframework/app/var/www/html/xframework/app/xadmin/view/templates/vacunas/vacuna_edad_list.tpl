<div id="colRight">	

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />

    <div class="block">

        <div class="title_bar"><span class="text">VACUNA POR EDAD&raquo; </span>

            {x_form_html_button id="btnNew" label="Nuevo" w="100" type="button" class="icon add"}&nbsp;

        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">
            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=vacunas&submodulo=vacuna_edad_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >
                    <div class="form_container">
                        <div class="title">
                            Consulta de Vacunas por Edad / Grupo
                        </div>

                        <ul>

                            <li class="left">
                                <label>Nombre </label> 
                                {x_form_input  id="vacuna" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.vacuna} 
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