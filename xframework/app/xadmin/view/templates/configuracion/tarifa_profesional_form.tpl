<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">Tarifa Profesional</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=configuracion&submodulo=tarifa_profesional_form"  method="post"  name="f_record" id="f_record" >

                    <div class="form_container ">
                        <div class="title">Valor de Tarifa Profesional </div>
                        <ul>

                            <li class="left">
                                <label>Valor($)</label> 
                                {x_form_input  id="valor" descriptor="real" isRequired="true" maxChars=11 class="" value=$valor} 
                            </li>  

                        </ul>

                        <div class="clear">&nbsp;</div> 

                    </div>


                    <div class="clear">&nbsp;</div>


                </form>
            </div> 
        </div>  
        <div class="end">&nbsp;</div> 
    </div>   
</div>

{literal}
<script>
    $(function(){
        x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm(
                $('#f_record'),
                    true,
                    function(data) {
                          x_alert(data.msg);
                            }
        );
  });
$("#back").click(function() {
    x_goTo('home', 'home', '', 'Main', this);
});



        
    })
</script>
{/literal}