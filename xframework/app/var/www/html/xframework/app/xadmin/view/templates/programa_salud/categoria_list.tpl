<div class="block">
    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />

    <div class="top">&nbsp;</div>
    <div class="contenido">

        <div class="xForm">
            <form action="{$controller}.php?action=1&modulo=programa_salud&submodulo=categoria_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >

                <input type="hidden" name="idprograma_salud" value="{$programa_salud.idprograma_salud}" />

                <div class="form_container">
                    <div class="title">
                        <span style="margin-right:20px;">
                            Categorías
                        </span>
                        {x_form_html_button id="btnNew" label="Agregar categoría"  w="100" type="button" class="icon add" }&nbsp;
                    </div>

                </div>
            </form>
            <div  class="xTable" id="xTable">

                <div class="container">		

                    <table id="list">
                    </table> 

                    <div id="pager"></div>

                </div>     


            </div> 
        </div>


    </div>
    <div class="end">&nbsp;</div>
</div> 