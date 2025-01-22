<div id="colRight">

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />

    <div class="block">


        <div class="title_bar"><div class="text">SOLICITUD PAGO M&Eacute;DICO &raquo; {if $record} EDITAR {else} NUEVO{/if}</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=contable&submodulo=solicitud_pago_medico_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idsolicitudPagoMedico" id="idsolicitudPagoMedico" value="{$record.idsolicitudPagoMedico}" />
                    <input type="hidden" name="medico_idmedico" id="medico_idmedico" value="{$record.periodo_pago.medico_idmedico}" />
                    <input type="hidden" name="idmedicoFactura" id="idmedicoFactura" value="{$record.medico_factura.idmedicoFactura}" />

                    <div class="form_container ">
                        <div class="title">Datos del periodo de pago</div>
                        <ul>
                            <li class="left">
                                <label>Período Pago</label> 
                                <span class="lbl">{$record.periodo_pago.mes|@getNombreMes} {$record.periodo_pago.anio} </span>
                            </li>
                            <li class="right">
                                <label>Fecha Solicitud Pago</label> 
                                <span class="lbl">{$record.fechaSolicitudPago|date_format:"%d/%m/%Y"}</span>
                            </li>
                            <li class="left">
                                <label>Estado Pago</label> 
                                <select name="estado" id="estado" class="">
                                    {html_options options=$combo_estado_solicitud_pago_medico selected=$record.estado}                           
                                </select>                 
                            </li>
                            <li class="right">
                                <label>Fecha Pago</label> 
                                {x_form_date date_format="%d/%m/%Y"  input_format = "dd/mm/yyyy" input_name="fechaPago" isRequired="false" value=$record.fechaPago|date_format:"%d/%m/%Y"}
                            </li>
                             <li class="left">
                                <label>Total a pagar</label> 
                                <span class="lbl">${$record.periodo_pago.importePeriodo}</span>
                            </li>
                             <li class="right">
                                <label>Comisión DoctorPlus</label> 
                                <span class="lbl">${$record.periodo_pago.importe_comisiones}</span>
                            </li>
                            <li class="left" style="height:100px;">
                                 <label>Comprante de pago PDF</label> 
                                {x_component_upload  type="*" max_size=90000000000 id=$record.idsolicitudPagoMedico  manager="ManagerSolicitudPagoMedico" w=450 filter="*.pdf" h=100}                 
                            </li>


                            {if $record.posee_file == 1}
                            <li class="wide">
                             
                                <a target="_blank" href="{$url}xframework/files/entities/comisiones_solicitud_pago/{$record.idsolicitudPagoMedico}/{$record.idsolicitudPagoMedico}.pdf">Descargar comprobante
                                    <img src="xframework/app/themes/admin/imgs/action_ico_pdf.png" />
                                </a>
                            </li>
                            {/if}     
                         

                        </ul>
                        <div class="clear">&nbsp;</div> 
                        <div class="title">Datos de la cuenta del médico</div>
                        <ul>


                            <li class="wide">
                                <label>Beneficiario</label> 
                                <span class="lbl">{$record.informacion_comercial.nombre_beneficiario}</span>
                            </li>  

                          
                            <li class="wide">
                                <label>IBAN</label> 
                                <span class="lbl">{$record.informacion_comercial.iban}</span>
                            </li>

                            <li class="wide">
                                <label>Nombre Banco</label> 
                                <span class="lbl">{$record.banco.nombre_banco}</span>
                            </li>

                        </ul>

                        <div class="clear">&nbsp;</div> 

                    </div>

                </form>
            </div> 
            <div class="clear">&nbsp;</div>


        </div>  
        <div class="end">&nbsp;</div> 
    </div>   
</div>