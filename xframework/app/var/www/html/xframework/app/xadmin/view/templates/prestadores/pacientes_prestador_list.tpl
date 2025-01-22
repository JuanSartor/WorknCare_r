
<div id="colRight">

    <div class="block">

        <div class="title_bar">
            <div class="text">
                {$prestador.nombre}  &raquo; Listado de pacientes  
            </div>


            &nbsp;
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}

        </div>
        <div class="top">
            &nbsp;
        </div>
        <div class="contenido">

            <div class="xForm ">

                <div class="form_container ">

                    <input type="hidden" id="list_actual_page_4" value="{$paginate.current_page}" />

                    <div class="clear">&nbsp;</div>  
                    <form action="{$controller}.php?action=1&modulo=prestadores&submodulo=pacientes_prestador_list"  method="post"  name="f_busqueda_paciente" id="f_busqueda_paciente" >
                        <input type="hidden"  id="idprestador" name="idprestador" value="{$smarty.request.idprestador}" />

                        <div class="form_container">
                            <div class="title">
                                Pacientes
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

                    {x_form_html_button id="btnAddPaciente" label="Agregar pacientes" w="100" type="button" class="icon add"}


                </div>         

            </div>

            <div  class="xTable" id="xTable">

                <div class="container">		
                    <table id="list_paciente">
                    </table> 

                    <div id="pager_paciente"></div>
                </div>     

            </div> 

        </div>

    </div>
</div>
