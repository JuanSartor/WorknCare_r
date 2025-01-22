<style>
    section .ocultar-tipos-cuenta{
        position: absolute;
        color: #f33243;
        right: 15px;
        font-size: 22px;
        cursor:pointer;
        z-index: 1;

    }
    #div_container_tipos_cuenta{
        position: relative;
    }
</style>
{if $medico.fundador=="1"}
    <section class="account-order">
        <div class="container">
            <h2 class="text-center">  <strong>{"Usted tiene una cuenta de médico socio"|x_translate}  </strong></h2>
        </div>
    </section>
{else}
    <section class="account-order">
        <div class="container">
            <h2 class="text-center">    
                <strong>
                    {if $medico.planProfesional == 0}
                        {"Usted posee una Cuenta Gratuita"|x_translate}
                    {else}
                        {"Usted posee una Cuenta Profesional"|x_translate}
                    {/if}
                </strong>
            </h2>
            <h2 class="text-center">
                {if $medico.planProfesional == 0}
                    {"Subtitulo home medico cuando tiene cuenta basica"|x_translate}
                {else}
                    {"Subtitulo home medico cuando tiene cuenta profesional"|x_translate}
                {/if}
            </h2>
            <div class="row text-center" id="div_container_saber_mas">
                <div class="hom-planes-btn-box">
                    <button id="saber-mas-tipos-cuenta" class="uppercase">{"Saber más"|x_translate}</button>
                </div>
            </div>
            <div class="row" id="div_container_tipos_cuenta" style="display:none;">
                <span class="ocultar-tipos-cuenta"><i class="fa fa-times"></i></span>
                <div class="col-md-4">
                    <img src="{$IMGS}graphic-computer.svg" alt='{"Tipos de cuenta"|x_translate}'>
                </div>
                <div class="col-md-7">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="highlight-box text-center">
                                <small>{"Cuenta Gratuita"|x_translate}</small>
                                <div class="price">
                                    <span>{"Gratis"|x_translate}</span>
                                    <span></span>
                                </div>
                                <a href="{$url}panel-medico/abono-detalle-cuenta-gratuita.html" role="button">{"Ver detalle"|x_translate}</a>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="highlight-box text-center">
                                <small>{"Cuenta Profesional"|x_translate}</small>
                                <div class="price">
                                    <span>&euro;{$MONTO_CUOTA}</span>
                                    <span>{"finales/MES"|x_translate}</span>
                                </div>
                                <a href="{$url}panel-medico/abono-detalle-cuenta-profesional.html" role="button">{"Ver detalle"|x_translate}</a>
                            </div>
                        </div>
                    </div>
                    <div class="hom-planes-btn-box">
                        <button id="compare-btn" class="uppercase">{"Comparar planes"|x_translate}</button>
                    </div>
                </div>
            </div>
            <div id="comparison-table" class="comparison-table">
                <table class="table table-rsp hom-planes-table">
                    <tr>
                        <th>{"Tipo de cuenta"|x_translate}</th>
                        <th><span>{"Cuenta Gratuita"|x_translate}</span></th>
                        <th><span>{"Cuenta Profesional"|x_translate}</span></th>
                    </tr>
                    <tr>
                        <td>{"Agenda de Turnos on line"|x_translate}</td>
                        <td><span class="check"></span></td>
                        <td><span class="check"></span></td>
                    </tr>
                    <tr>
                        <td>{"Recordatorios de turnos por email y sms"|x_translate}</td>
                        <td><span class="check"></span></td>
                        <td><span class="check"></span></td>
                    </tr>
                    <tr>
                        <td>{"Acceso a la Info de Salud de sus pacientes desde cualquier dispositivo"|x_translate}</td>
                        <td><span class="check"></span></td>
                        <td><span class="check"></span></td>
                    </tr>
                    <tr>
                        <td>{"Registro de sus consultas médicas a distancia"|x_translate}</td>
                        <td><span class="check"></span></td>
                        <td><span class="check"></span></td>
                    </tr>
                    <tr>
                        <td>{"Consulta Express"|x_translate}</td>
                        <td><span class="red">{$COMISION_CE}% {"comisión"|x_translate}<sup>(1)</sup></span></td>
                        <td><span class="check"></span></td>
                    </tr>
                    <tr>
                        <td>{"Video Consulta"|x_translate}</td>
                        <td><span class="red">{$COMISION_VC}% {"comisión"|x_translate}<sup>(1)</sup></span></td>
                        <td><span class="check"></span></td>
                    </tr>
                    <tr>
                        <td>{"Gestión de pacientes"|x_translate}</td>
                        <td><span class="check"></span></td>
                        <td><span class="check"></span></td>
                    </tr>
                    <tr>
                        <td>{"Contacto con los médicos frecuentes del paciente"|x_translate}</td>
                        <td><span class="check"></span></td>
                        <td><span class="check"></span></td>
                    </tr>
                    <tr>
                        <td>{"Envío de consejos médicos"|x_translate}</td>
                        <td><span class="check"></span></td>
                        <td><span class="check"></span></td>
                    </tr>
                    <tr>
                        <td>{"50 Pacientes con servicio de CE bonificados"|x_translate}</td>
                        <td><span class="cross"></span></td>
                        <td><span class="check"></span></td>
                    </tr>
                    <tr>
                        <td>{"Soporte Técnico"|x_translate}</td>
                        <td><span class="check"></span></td>
                        <td><span class="check"></span></td>
                    </tr>
                </table>
                <small class="pull-right">
                    <sup>(1)</sup>{"Costes operativos todo incluido. ¡OPTA POR LA SUSCRIPCIÓN DE 10 CONSULTAS POR MES!"|x_translate}<br>
                </small>			
            </div>

        </div>
    </section>
{/if}
{literal}
    <script>
        $(function () {
            //mostrar info tipos de cuenta
            $("#saber-mas-tipos-cuenta").click(function () {
                $("#div_container_saber_mas").slideUp();
                $("#div_container_tipos_cuenta").slideDown();
            });
            //ocultar info tipos de cuenta
            $(".ocultar-tipos-cuenta").click(function () {
                $("#div_container_saber_mas").slideDown();
                $("#div_container_tipos_cuenta").slideUp();
                $("#comparison-table").slideUp();

            });

        });
    </script>
{/literal}