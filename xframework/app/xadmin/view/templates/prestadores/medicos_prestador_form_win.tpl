<form action="{$controller}.php?action=1&modulo=prestadores&submodulo=medicos_prestador_form_win"  method="post"  id="f_medicos_prestador" >
      <input type="hidden"   name="idprestador" value="{$smarty.request.idprestador}" />

    <input type="hidden"  id="ids_medico" name="ids" value="" />

</form>
<div id="colRight">	

    <input type="hidden" id="list_actual_page_1" value="{$paginate.current_page}" />


    <div class="block">


        <div class="top">&nbsp;</div>


        <div class="xForm">
            <form action="{$controller}.php?action=1&modulo=prestadores&submodulo=medicos_list"  method="post"  id="f_busqueda_medicos" >
                <input type="hidden"  id="idprestador_busqueda_medicos" name="idprestador" value="{$smarty.request.idprestador}" />


                <div class="form_container">
                    <div class="title">
                        M&eacute;dicos
                    </div>

                    <ul>

                        <li class="left">
                            <label>BUSQUEDA </label> 
                            {x_form_input  id="busqueda_medicos" name="busqueda" descriptor="none" isRequired="false" maxChars=50 class="" value=$paginate.request.nombre} 
                        </li>   


                        <li class="clear"></li>
                        <li class="wide">           
                            {x_form_html_button id="btnFilterBusquedaMedicos" label="Buscar" class="icon search" w="100" type="button"} 

                            {x_form_html_button id="btnLimpiarBusquedaMedicos" label="Limpiar" class="icon loop" w="100" type="button"} 

                        </li>
                        <li class="clear"></li>


                    </ul>


                </div>
            </form>
        </div>

            <div  class="xTable" id="xTable">
                <div class="container">		
                    <table id="list_busqueda_medico">
                    </table> 

                    <div id="pager_busqueda_medico"></div>

                </div>     


            </div> 


            {x_form_html_button id="back_hs" label="Volver" w="100" type="button" class="icon arrowleft"} &nbsp;
            {x_form_html_button id="btnGuardarMedicoPrestador" label="Agregar" w="100" type="button" class="icon save"}






    </div> 


</div> 





