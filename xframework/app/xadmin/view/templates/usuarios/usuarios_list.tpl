<div id="colRight">


    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />


    <div class="block">
        <div class="title_bar"><span class="text">USUARIOS &raquo;  </span>
            {x_form_html_button id="btnNew" label="Nuevo" function_name="x_goTo" w="100" type="button" p1="'usuarios'" p2="'usuarios_form'" p3="''" p4="'Main'" p5="this" class="icon add"}&nbsp;

        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">


            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=usuarios&submodulo=usuarios_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" onsubmit="return false;" >


                    <div class="form_container">
                        <div class="title">
                            Consulta de Usuarios
                        </div>

                        <ul>

                            <li class="left">
                                <label>Apellido</label> 
                                {x_form_input  id="apellido" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.apellido} 
                            </li>

                            <li class="right">
                                <label>Nombre</label> 
                                {x_form_input  id="nombre" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.nombre}  
                            </li> 

                            <li class="left">
                                <label>Usuario</label> 
                                {x_form_input  id="userame" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.username} 
                            </li>
                            <li class="right">
                                <label>Email</label> 
                                {x_form_input  id="email" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.email}  
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
