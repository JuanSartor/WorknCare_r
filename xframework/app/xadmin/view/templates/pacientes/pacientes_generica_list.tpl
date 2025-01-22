<div id="colRight">	

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />

    <form action="{$controller}.php?action=1&modulo=pacientes&submodulo=pacientes_list_export"  target="_blank" method="post" id="f_export" >
        <input type="hidden" name="nombre" id="nombre_export" value="">
        <input type="hidden" name="apellido" id="apellido_export" value="">
        <input type="hidden" name="DNI" id="DNI_export" value="">
        <input type="hidden" name="sexo" id="sexo_export" value="">


    </form>
    <div class="block">

        <div class="title_bar"><span class="text">	PACIENTES &raquo; </span>

        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=pacientes&submodulo=pacientes_generica_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >


                    <div class="form_container">
                        <div class="title">
                            Consulta de Pacientes
                        </div>

                        <ul>

                            <li class="left">
                                <label>Nombre </label> 
                                {x_form_input  id="nombre" descriptor="none" isRequired="false" maxChars=50 class="" value=$paginate.request.nombre} 
                            </li>   


                            <li class="right">
                                <label>Email </label> 
                                {x_form_input  id="email" descriptor="none" isRequired="false" maxChars=255 class="" value=$paginate.request.email} 
                            </li>
                            <li class="left">
                                <label>Sexo</label> 
                                <select name="sexo" id="sexo" class="">
                                    <option value="">Seleccione...</option>
                                    <option value="1">Masculino</option>
                                    <option value="0">Femenino</option>                           
                                </select>   
                            </li> 
                            <li class="right">
                                <label>Estado</label> 
                                <select name="estado" id="estado" class="">
                                    <option value="">Seleccione...</option>
                                    <option value="1">Activo</option>
                                    <option value="0">Inactivo</option>                           
                                </select>   
                            </li> 



                            <li class="clear"></li>
                            <li class="wide">           
                                {x_form_html_button id="btnFilter" label="Buscar" class="icon search" w="100" type="button"} 
                                {x_form_html_button id="btnLimpiar" label="Limpiar" class="icon loop" w="100" type="button"} 
                                {x_form_html_button id="btnExportar" label="Exportar" class="icon loop" w="100" type="button"} 
                                <a  class="button" href="{$url}xadmin.php?action=1&modulo=pacientes&submodulo=exportar_beneficiarios">
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


</div>