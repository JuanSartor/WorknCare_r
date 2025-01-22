<div id="colRight">


    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />


    <div class="block">
        <div class="title_bar"><span class="text"> WorknCare &raquo;  </span>
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">


            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=usuarios_empresa&submodulo=usuarios_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" onsubmit="return false;" >


                    <div class="form_container">
                        <div class="title">
                            Consulta de WorknCare
                        </div>

                        <ul>

                            <li class="left">
                                <label>Nombre</label> 
                                {x_form_input  id="nombre" descriptor="none" isRequired="false" maxChars=255 class="" value=$paginate.request.nombre}  
                            </li> 
                            <li class="right">
                                <label>Apellido</label> 
                                {x_form_input  id="apellido" descriptor="none" isRequired="false" maxChars=255 class="" value=$paginate.request.apellido} 
                            </li>
                            <li class="left">
                                <label>Email</label> 
                                {x_form_input  id="email" descriptor="none" isRequired="false" maxChars=255 class="" value=$paginate.request.email}  
                            </li> 
                            <li class="right">
                                <label>Empresa / Particular</label> 
                                {x_form_input  id="empresa" descriptor="none" isRequired="false" maxChars=255 class="" value=$paginate.request.empresa} 
                            </li>

                            <li class="left">
                                <label>Plan</label> 
                                <select name="plan_idplan" id="plan_idplan" class="">
                                    <option value="">Todos</option>
                                    {html_options options=$combo_planes }                           
                                </select>   
                            </li>      
                            <li class="left">
                                <label>Estado</label> 
                                <select name="activo" id="activo" class="">
                                    {html_options options=$estados }                           
                                </select>   
                            </li>      


                            <li class="clear">&nbsp;</li>
                            <li class="wide">           
                                {x_form_html_button id="btnFilter" label="Buscar" w="100" type="button" class="icon search"} 

                                {x_form_html_button id="btnLimpiar" label="Limpiar" w="100" type="button" class="icon loop"} 
                                <a  class="button" href="{$url}xadmin.php?action=1&modulo=usuarios_empresa&submodulo=exportar_usuarios_empresa">
                                    Exportar MailChimp
                                </a> 
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
