
<div class="top">&nbsp;</div>
<div class="contenido">



    <div class="xForm ">

        <form action="{$controller}.php?action=1&modulo=pacientes&submodulo=cargar_credito_form_win"  method="post"  name="f_cargar_credito" id="f_cargar_credito" >
            <input type="hidden" name="idpaciente" id="idpaciente" value="{$smarty.request.id}" />

            <div class="form_container ">
                <div class="title">Cargar/Reembolsar crédito</div>
                <ul>
                    <li class="wide checkbox-inline">
                        <label class="">Tipo</label>
                        {x_form_boolean  label_yes='(+) Carga Credito' label_no='(-) Reembolso' value_yes=1 value_no=0 default=0 name="is_ingreso" id="is_ingreso"}
                    </li>
                    <li class="right">
                        <label>Monto  </label>
                        {x_form_input  id="monto" descriptor="real" isRequired="true" maxChars=50 class=""}
                    </li>

                </ul>


                <div class="clear">&nbsp;</div> 

                <ul>
                    <li class="tools">
                        {x_form_html_button id="back_hs" label="Volver" w="100" type="button" class="icon arrowleft"} &nbsp;
                        {x_form_html_button id="btnGuardarCredito" label="Guardar" w="100" type="button" class="icon save"}
                    </li>

                </ul>

                <div class="clear">&nbsp;</div> 
            </div> 
            <div class="clear">&nbsp;</div>      
        </form>
    </div> 

</div>  

