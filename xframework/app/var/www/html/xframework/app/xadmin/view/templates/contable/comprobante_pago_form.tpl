
<div class="top">&nbsp;</div>
<div class="contenido">



    <div class="xForm ">

        <form action="{$controller}.php?action=1&modulo=contable&submodulo=comprobante_pago_form"  method="post"  name="f_record_pdf" id="f_record_pdf" >
            <input type="hidden" name="idcuota" id="idcuota" value="{$record.idcuota}" />

            <div class="form_container ">
                <div class="title">Cargar Factura</div>
                <ul>
                    <li class="wide">
                        <label>Facturada</label> 
                        {x_form_boolean  label_yes='Sí' label_no='No' value_yes=1 value_no=0 default=$record.facturada name="facturada" id="facturada"}
                    </li>


                    <li class="wide" style="height:100px;">
                        {x_component_upload  type="*" max_size=90000000000 id=$record.idcuota  manager="ManagerCuota" w=450 filter="*.pdf" h=100}                 
                    </li>

                    {if $record.posee_file == 1}
                    <li class="wide" style="height:100px;">
                        <a target="_blank" href="{$url}xframework/files/entities/cuotas/{$record.idcuota}/{$record.idcuota}.pdf">Descargar archivo
                            <img src="xframework/app/themes/admin/imgs/action_ico_pdf.png" />
                        </a>
                    </li>
                    {/if}
                </ul>

                <div class="clear">&nbsp;</div> 
                <ul>
                    <li class="wide">
                        *Se requiere el plugin de <a href="https://get.adobe.com/es/flashplayer/">Adobe Flash Player </a>para su funcionamiento
                    </li>
                </ul>
                <ul>
                    <li class="tools">
                        {x_form_html_button id="back_hs" label="Volver" w="100" type="button" class="icon arrowleft"} &nbsp;
                        {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
                    </li>

                </ul>

                <div class="clear">&nbsp;</div> 
            </div> 
            <div class="clear">&nbsp;</div>      
        </form>
    </div> 

</div>  

