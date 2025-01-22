<div id="colRight">	

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />


    <div class="block">

        <div class="title_bar"><span class="text">	PINES PACIENTE &raquo; </span>

            {x_form_html_button id="btnNew" label="Nuevo" w="100" type="button" class="icon add"}&nbsp;


        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">

           
                <form action="{$controller}.php?action=1&modulo=configuracion&submodulo=pinesPaciente_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >



                </form>
           

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