<div id="colRight">

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />


    <div class="block">

        <div class="title_bar"><span class="text">	LOG DE SMS  </span>




        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=logs&submodulo=log_sms_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >

                    <div class="form_container">
                        <div class="title">
                            Búsqueda 
                        </div>

                        <ul>

                            <li class="left">
                                <label>Nombre usuario</label> 
                                {x_form_input  id="nombre_usuario" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.usuario} 
                            </li>
                            <li class="right">
                                <label>Texto</label> 
                                {x_form_input  id="texto" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.texto} 
                            </li>
                            
                            <li class="left">
                                <label>Celular</label> 
                                {x_form_input  id="numeroCelular" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.numeroCelular} 
                            </li>
                            <li class="right">
                                <label>Fecha</label> 
                                    {x_form_date date_format="%d/%m/%Y"  input_format = "dd/mm/yyyy" input_name="fecha" isRequired="false" value=$paginate.request.fecha|date_format:"%d/%m/%Y"}
                            </li>
                            <li class="left">
                                <label>Tipo usuario</label> 
                                <select name="tipo_usuario"  class="">
                                    <option value="">Seleccionar...</option>  
                                    <option value="P" {if $smarty.request.tipo=="P"}selected{/if}>Paciente</option>  
                                    <option value="M" {if $smarty.request.tipo=="M"}selected{/if}>Médico</option>    


                                </select>                             
                            </li>   
                            <li class="right">
                                <label>Status</label> 
                                <select name="estado" class="">
                                    <option value="">Todos</option>  
                                    <option value="1" >Enviados</option>    
                                    <option value="0" >Pendientes</option>  
                                    <option value="99" >NO enviar</option>  

                                </select>                             
                            </li>   

                            <li class="clear"></li>
                            <li class="wide">           
                                {x_form_html_button id="btnFilter" label="Buscar" class="icon search" w="100" type="button"} 

                                {x_form_html_button id="btnLimpiar" label="Limpiar" class="reload" w="100" type="button"} 

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


