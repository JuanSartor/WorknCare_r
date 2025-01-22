<div id="colRight">	

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />


    <div class="block">

        <div class="title_bar"><span class="text">	PREREGISTRO DE M&Eacute;DICOS &raquo; </span>
            <form action="{$controller}.php?action=1&modulo=medicos&submodulo=preregistro_list_export"  target="_blank" method="post" id="f_export" >
                <input type="hidden" name="nombre" id="nombre_export" value="">
                <input type="hidden" name="email" id="email_export" value="">
                <input type="hidden" name="completado" id="completado_export" value="">
            </form>


        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=medicos&submodulo=preregistro_list"  method="post"  name="f_busqueda" id="f_busqueda" >


                    <div class="form_container">
                        <div class="title">
                            Búsqueda
                        </div>

                        <ul>

                            <li class="left">
                                <label>Nombre del profesional</label> 
                                {x_form_input  id="nombre" descriptor="none" isRequired="false" maxChars=50 class="" value=$paginate.request.nombre} 
                            </li>   

                            <li class="right">
                                <label>Email </label> 
                                {x_form_input  id="email" descriptor="none" isRequired="false" maxChars=50 class="" value=$paginate.request.email} 
                            </li>           
                            <li class="left">
                                <label>Completado</label> 
                                <select name="completado" id="completado" class="">
                                    <option value="">Todos</option>
                                    <option value="1">SÍ</option>
                                    <option value="0">NO</option>                           
                                </select>   
                            </li> 
                            <li class="right">
                                <label>Teaser</label> 
                                <select name="teaser" id="teaser" class="">
                                    <option value="">Todos</option>
                                    <option value="1">SÍ</option>
                                    <option value="0">NO</option>                           
                                </select>   
                            </li> 




                            <li class="clear"></li>
                            <li class="wide">           
                                {x_form_html_button id="btnFilter" label="Buscar" class="icon search" w="100" type="button"} 

                                {x_form_html_button id="btnLimpiar" label="Limpiar" class="icon loop" w="100" type="button"} 
                                {x_form_html_button id="btnExportar" label="Exportar" class="icon loop" w="100" type="button"} 

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