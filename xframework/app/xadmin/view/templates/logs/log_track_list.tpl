<style>
    .ui-jqgrid-hdiv{
        display:none !important
    }
    .ui-jqgrid tr.ui-row-ltr td{
        padding-left:10px;
        padding-right:10px;
    }
</style>
<div id="colRight">

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />


    <div class="block">

        <div class="title_bar"><span class="text">Tracking de usuarios</span>

        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=logs&submodulo=log_track_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >

                    <div class="form_container">
                        <div class="title">
                            Búsqueda 
                        </div>

                        <ul>

                            <li class="left">
                                <label>Mail</label> 
                                {x_form_input  id="email" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.track} 
                            </li>


                            <li class="right">
                                <label>Fecha</label> 
                                {x_form_date date_format="%d/%m/%Y"  input_format = "dd/mm/yyyy" input_name="fecha" isRequired="false" value=$paginate.request.fecha|date_format:"%d/%m/%Y"}
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


