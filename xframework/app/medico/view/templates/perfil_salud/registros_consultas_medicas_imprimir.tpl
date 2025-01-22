{if $listado_consulta}
    <header class="vista-impresion-header">
        <img src="{$IMGS}doctorplus_logo_mobile.png">
    </header>
    {foreach from=$listado_consulta item=consulta}

        <section class="container divider-print">
            <div class="row vista-impresion-divider">
                {include file="perfil_salud/registros_consultas_medicas_imprimir_paciente.tpl"}

                <div class="col-sm-2 vista-impresion-holder col-2-print">
                    {if $consulta.consultaExpress_idconsultaExpress!=""}
                        <div class="vista-impresion-tipo-accion">
                            <div class="consulta-express"><i class="icon-doctorplus-chat"></i></div>
                            <span>{"consulta express"|x_translate}</span>
                        </div>
                    {else}
                        {if $consulta.videoconsulta_idvideoconsulta!=""}
                            <div class="vista-impresion-tipo-accion">
                                <div class="video-consulta"><i class="icon-doctorplus-video-call"></i></div>
                                <span>{"video consulta"|x_translate}</span>
                            </div>
                        {else}
                            <div class="vista-impresion-tipo-accion">
                                <div class="consulta-presencial"><i class="icon-doctorplus-map-add"></i></div>
                                <span>{"consulta presencial"|x_translate}</span>
                            </div>
                        {/if}
                    {/if}


                </div>
            </div>

        </section>
        <section class="container divider-print">
            <div class="row vista-impresion-divider vista-impresion-row-spacer">
                <div class="col-sm-8 col-8-print">
                    <span class="vista-impresion-titulo">{"Consulta Médica"|x_translate}  - {$consulta.titulo_profesional} {$consulta.nombre} {$consulta.apellido}</span>
                </div>
                <div class="col-sm-4 col-4-print text-right">
                    {$consulta.fechaConsulta_format}
                </div>
            </div>
        </section>
        <section class="container">
            {if $consulta.motivoVideoConsulta!=""}
                <div class="row vista-impresion-detalle-row">
                    <div class="col-sm-3 col-3-print">
                        <label class="vista-impresion-detalle-label">{"Motivo"|x_translate}</label>
                    </div>
                    <div class="col-sm-9 col-9-print vista-impresion-detalle-text">
                        <p>{$consulta.motivoVideoConsulta}</p>
                    </div>
                </div>
            {/if}
            {if $consulta.motivoConsultaExpress!=""}
                <div class="row vista-impresion-detalle-row">
                    <div class="col-sm-3 col-3-print">
                        <label class="vista-impresion-detalle-label">{"Motivo"|x_translate}</label>
                    </div>
                    <div class="col-sm-9 col-9-print vista-impresion-detalle-text">
                        <p>{$consulta.motivoConsultaExpress}</p>
                    </div>
                </div>
            {/if}
            {if $otro_profesional!="1"}
                <div class="row vista-impresion-detalle-row">
                    <div class="col-sm-3 col-3-print">
                        <label class="vista-impresion-detalle-label">{"Evolución clinica"|x_translate}</label>
                    </div>
                    <div class="col-sm-9 col-9-print vista-impresion-detalle-text">
                        <p>
                            {$consulta.evolucion_clinica}
                        </p>

                    </div>
                </div>
                <div class="row vista-impresion-detalle-row">
                    <div class="col-sm-3 col-3-print">
                        <label class="vista-impresion-detalle-label">{"Anotaciones"|x_translate}</label>
                    </div>
                    <div class="col-sm-9 col-9-print vista-impresion-detalle-text">
                        <p>
                            {$consulta.anotacion}
                        </p>

                    </div>
                </div>
            {/if}

            <div class="row vista-impresion-detalle-row">
                <div class="col-sm-3 col-3-print">
                    <label class="vista-impresion-detalle-label">{"Diagnóstico"|x_translate}</label>
                </div>
                <div class="col-sm-9 col-9-print vista-impresion-detalle-text">
                    <p>{$consulta.diagnostico}</p>
                </div>
            </div>

            <div class="row vista-impresion-detalle-row">
                <div class="col-sm-3 col-3-print">
                    <label class="vista-impresion-detalle-label">{"Tratamiento"|x_translate}</label>
                </div>
                <div class="col-sm-9 col-9-print vista-impresion-detalle-text">
                    <p>{$consulta.tratamiento}</p>
                </div>
            </div>

        </section>
        {if $consulta.medicacion_list}
            <section class="container">
                <table class="vista-impresion-table">
                    <thead>
                        <tr>
                            <th>{"Medicamento"|x_translate}</th>
                            <th>{"Posología"|x_translate}</th>
                            <th>{"Toma"|x_translate}</th>
                            <th>{"Inicio"|x_translate}</th>
                            <th>{"Fin"|x_translate}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$consulta.medicacion_list item=medicamento }
                            {if $medicamento.tipoTomaMedicamentos_idtipoTomaMedicamentos==1} 

                                <tr>
                                    <td>{$medicamento.nombre_comercial}</td>
                                    <td>{$medicamento.posologia}</td>
                                    <td>{"Única toma"|x_translate}</td>
                                    <td>{$medicamento.fecha_inicio_f}</td>
                                    <td>
                                        {if $medicamento.fecha_fin_f !=""}
                                            {$medicamento.fecha_fin_f}
                                        {elseif $medicamento.tipoTomaMedicamentos_idtipoTomaMedicamentos == 1}
                                            {"Medicación Crónica"|x_translate}
                                        {elseif $medicamento.tipoTomaMedicamentos_idtipoTomaMedicamentos == 2}
                                            {"Temporal"|x_translate}
                                        {/if}
                                    </td>

                                </tr>
                            {/if}

                            {if $medicamento.tipoTomaMedicamentos_idtipoTomaMedicamentos==2} 
                                <tr>
                                    <td>{$medicamento.nombre_comercial}</td>
                                    <td>{$medicamento.posologia}</td>
                                    <td>{"Tratamiento prolongado"|x_translate}</td>
                                    <td>{$medicamento.fecha_inicio_f}</td>
                                    <td>{if $medicamento.fecha_fin_f!=""}{$medicamento.fecha_fin_f}{else}-{/if}</td>
                                </tr>
                            {/if}
                            {if $medicamento.tipoTomaMedicamentos_idtipoTomaMedicamentos==3} 
                                <tr>
                                    <td>{$medicamento.nombre_comercial}</td>
                                    <td>{$medicamento.posologia}</td>
                                    <td>{"Crónica"|x_translate}</td>
                                    <td>{$medicamento.fecha_inicio_f}</td>
                                    <td>{if $medicamento.fecha_fin_f!=""}{$medicamento.fecha_fin_f}{else}-{/if}</td>
                                </tr>
                            {/if}
                            {if $medicamento.tipoTomaMedicamentos_idtipoTomaMedicamentos==4} 
                                <tr>
                                    <td>{$medicamento.nombre_comercial}</td>
                                    <td>{$medicamento.posologia}</td>
                                    <td>{"Temporal"|x_translate}</td>
                                    <td>{$medicamento.fecha_inicio_f}</td>
                                    <td>{if $medicamento.fecha_fin_f!=""}{$medicamento.fecha_fin_f}{else}-{/if}</td>
                                </tr>
                            {/if}



                        {/foreach}

                    </tbody>
                </table>
            </section>
        {/if}
        {if $consulta.estudios_list || $consulta.adjuntos_list}
            <section class="container vista-impresion-table-impresion-spacer">
                <table class="vista-impresion-table vista-impresion-table-archivos">
                    <thead>
                        <tr>
                            <th><i class="fui-clip"></i> {"Estudios e Imágenes"|x_translate}</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>

                        {foreach from=$consulta.estudios_list item=estudio}
                            <tr>
                                <td>{$estudio.titulo}</td>
                                <td>
                                    {foreach from=$estudio.list_imagenes item=imagen}

                                        <span style="margin-right:5px;">
                                            <img src="{$imagen.path_images}" alt="{$imagen.nombre_archivo}" style="width:110px;height:110px" />
                                        </span>

                                    {/foreach}
                                </td>
                            </tr>
                        {/foreach}

                    </tbody>
                </table>
            </section>
        {/if}
        <section class="container vista-impresion-last-container">
            <div class="vista-impresion-spacer"></div>
        </section>
    {/foreach}
    <section class="container vista-impresion-last-container">

        <button class="button vista-impresion-button" onclick="window.print();">{"imprimir"|x_translate}</button>
    </section>

    {literal}
        <script>
            $(function () {
                window.print();
            });
        </script>
    {/literal}


{else}
    <header class="vista-impresion-header">
        <img src="{$IMGS}doctorplus_logo_mobile.png">
    </header>
    <section class="container divider-print">
        <div class="row vista-impresion-divider text-center">

            <h6>{"No se ha podido recuperar la consulta médica"|x_translate}</h6>
        </div>

    </section>

{/if}
