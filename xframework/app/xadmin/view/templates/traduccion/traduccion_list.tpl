<div id="colRight">

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />


    <div class="block">

        <div class="title_bar"><span class="text">	TRADUCCIONES  </span>

            {x_form_html_button id="btnNew" label="Nuevo" w="100" type="button" class="icon add" }&nbsp;

            {x_form_html_button id="btnBucarTraduccionesSistema" label="1: Bucar Traducciones Sistema" w="100" type="button" class="icon search"}&nbsp;
            {x_form_html_button id="btnCompilarTraducciones" label="Generar archivo de traduccion" w="100" type="button" class="icon reload" }&nbsp;



        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=traduccion&submodulo=traduccion_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >

                    <div class="form_container">
                        <div class="title">
                            Búsqueda de traducciones
                        </div>

                        <ul>

                            <li class="left">
                                <label>Original</label> 
                                {x_form_input  id="original" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.original} 
                            </li>
                            <li class="right">
                                <label>Traducción</label> 
                                {x_form_input  id="traduccion" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.traduccion} 
                            </li>
                            <li class="left">
                                <label>Tipo</label> 
                                <select name="tipo"  class="">
                                    <option value="">Seleccionar...</option>  
                                    <option value="1" {if $smarty.request.tipo==1}selected{/if}>Mensajes de alerta</option>  
                                    <option value="2" {if $smarty.request.tipo==2}selected{/if}>Página  web (HTML)</option>    
                                    <option value="3" {if $smarty.request.tipo==3}selected{/if}>Página  web (JS)</option>    

                                </select>                             
                            </li>   
                            <li class="right">
                                <label>Status</label> 
                                <select name="estado" class="">
                                    <option value="">Todas</option>  
                                    <option value="1" >Pendientes</option>  
                                    <option value="2" >Traducidas</option>    
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


            <div class="xForm" id="div_progreso" style="display:none;">
                <div class="form_container">
                    <li class="clear"></li>
                    <li class="wide">
                        <label>Progreso</label> 
                        <span id="span_progreso">%</span>
                    </li>
                    <li class="clear"></li>
                </div>
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


