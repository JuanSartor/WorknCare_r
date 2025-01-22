<div id="colRight">	

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />


    <div class="block">

        <div class="title_bar"><span class="text">	M&Eacute;DICOS &raquo; </span>


            <form action="{$controller}.php?action=1&modulo=medicos&submodulo=medicos_list_export"  target="_blank" method="post" id="f_export" >
                <input type="hidden" name="nombre" id="nombre_export" value="">
                <input type="hidden" name="apellido" id="apellido_export" value="">
                <input type="hidden" name="especialidad_idespecialidad" id="especialidad_idespecialidad_export" value="">
                <input type="hidden" name="email" id="email_export" value="">
                <input type="hidden" name="validado" id="validado_export" value="">
                <input type="hidden" name="active" id="active_export" value="">

            </form>

        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=medicos&submodulo=medicos_generica_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >


                    <div class="form_container">
                        <div class="title">
                            Consulta de Médicos
                        </div>

                        <ul>

                            <li class="left">
                                <label>Nombre </label> 
                                {x_form_input  id="nombre" descriptor="none" isRequired="false" maxChars=50 class="" value=$paginate.request.nombre} 
                            </li>   

                            <li class="right">
                                <label>Apellido </label> 
                                {x_form_input  id="apellido" descriptor="none" isRequired="false" maxChars=50 class="" value=$paginate.request.apellido} 
                            </li>

                            <li class="left">
                                <label>Especialidad</label> 
                                <select name="especialidad_idespecialidad" id="especialidad_idespecialidad" class="">
                                    <option value="">Seleccionar...</option>
                                    {html_options options=$combo_especialidades}                        
                                </select>   
                            </li> 
                            <li class="left">
                                <label>Email</label> 
                                {x_form_input  id="email" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.email} 
                            </li> 

                            <li class="right">
                                <label>Validado</label> 
                                <select name="validado" id="validado" class="">
                                    <option value="">Seleccionar...</option>
                                    <option value="1">SÍ</option>
                                    <option value="0">NO</option>                           
                                </select>   
                            </li> 

                            <li class="left">
                                <label>Activo</label> 
                                <select name="active" id="active" class="">
                                    <option value="">Seleccionar...</option>
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