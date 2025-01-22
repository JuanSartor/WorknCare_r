<style>
    .pcuh-slide-item{
        min-height: fit-content;
    }
    .pcuh-slide-header {
        margin-top: 0px;
        margin-bottom: 0px;
    }
    .pcuh-slide-content .pcuh-slide-content-inner,.pcuh-slide-content .pcuh-slide-content-inner.pcuh-turnos-inner {
        min-height: 170px;
    }
    #listado-turnos .pcuh-tunos-footer .mdl-cancelar-turno{
        color: #FFF;
        margin-top: 5px;

    }
    .pcuh-slide-content p.pcuh-tunos-descripcion {
        padding-top: 5px;
        margin: 0px;
    }
    .pcuh-slide-content span.pcuh-tunos-date {
        display: block;
        color: #cd3845;
        font-size: 20px;
    }
    .pcuh-slide-content p.pcuh-tunos-tipo {
        color: #415b70;
        font-size: 14px;
        line-height: 16px;
        padding-top: 0px;
    }
    .pcuh-slide-content p.pcuh-tunos-tipo i{
        margin-right:4px; 
        font-size: 18px;
    }
    .pcuh-slide-content p.pcuh-tunos-descripcion i{
        margin-right:4px; 
    }
    .pcuh-slide-content p.pcuh-tunos-descripcion.especialidad{
        padding-top: 0px;
        margin-bottom: 10px;
    }   
    .pcuh-tunos-descripcion.estado .confirmado{
        color:#0ec2a1;
    }

    .pcuh-tunos-descripcion.estado .pendiente{
        color:#f6a800;
    }
    .pcuh-slide-header {
        margin-top: 0px;
        margin-bottom: 0px;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .pcuh-slide-header>figure {
        margin: 0;
        margin-right:10px;
    }
    .pcuh-turnos {
        background-color: #FFFFFF; 
        padding: 10px;
    }

    .pcuf-controles-slide {
        box-shadow: 2px 2px 10px 0 #666;
        border-radius: 10px;
    }
    .pcuh-slide-sin-turnos {
        position: relative;
        height: 150px;
    }
    .pcuh-slide-sin-turnos>p {
        display: block;
        position: relative;
        text-align: center;
        top: 50%;
        bottom: auto;
        margin-bottom: 0px;
        font-weight: 600;
        transform: none;
        font-size: 18px;
        color: #F23243;
    }
    @media(max-width:600px){
        .pcuh-slide-sin-turnos {
            position: relative;
            height: auto;
        }
        .pcuf-controles-slide.slick-initialized.slick-slider{
            min-height: 550px
        }
    }
    @media(min-width:700px){
        .btn-cancelar-ajuste{
            padding: 12px 7px;
            width: 140.1px;
        }
        .ajuste-texto{
            position: relative;
            top: 180px;
        }
        .ajuste-padding-left{
            padding-left: 0px;
        }
        .ajuste-btn-fermer{
            padding: 0px !important;
        }
    }

</style>
<section class="pul-perfil-incompleto">
    <div class="pul-pi-box">
        <div class="okm-row pul-pi-data-box turnos-banner {if $empresa_beneficiario!='Particulier' &&  $empresa_beneficiario!=''} contenedores-con-reembolso{/if}">

            <figure><i class="fas fa-calendar-alt icono"></i></figure>
            <p class="texto margin-left-texto-turnos">{"Turnos"|x_translate}</p>
            <div class="col-action  btn-turno-mobile" id="col-act-fermer">
                <a href="javascript:;"  style="box-shadow: none;" class="btn boton {if $empresa_beneficiario!='Particulier' &&   $empresa_beneficiario!=''} btn-reembolso-turno-margen {/if}" {if $empresa_beneficiario!='Particulier' &&   $empresa_beneficiario!=''} data-fermer='1' {/if} id="btnMostrarTurnos">{"ver"|x_translate}</a>
                <a href="javascript:;" class="btn boton {if $empresa_beneficiario!='Particulier' &&   $empresa_beneficiario!=''} btn-reembolso-turno-margen {/if}" id="btnOcultarTurnos" style="display: none; box-shadow: none;">{"cerrar"|x_translate}</a>
            </div>
        </div>

        <div id="listado-turnos"  style="display: none;">
            <div class="pcuh-turnos">
                <div id="pcuh-listado-turnos" class="pcuf-controles-slide">
                    {foreach from=$listado_turnos item=turno}
                        <div class="pcuh-slide-item">
                            <div class="pcuh-slide-content">

                                <div class="pcuh-slide-content-col">
                                    <a href="{$url}panel-paciente/detalle-turno.html?idturno={$turno.0.idturno}" class="pcuh-slide-content-inner pcuh-turnos-inner">
                                        <span class="pcuh-tunos-date">{$turno.0.fecha|date_format:"%d/%m/%Y"}  {$turno.0.horarioInicio|date_format:"%H:%M"}hs</span>
                                        <p class="pcuh-tunos-tipo">
                                            {if $turno.0.is_virtual=="1"}
                                                <i class="icon-doctorplus-video-call"></i>&nbsp;{"Video Consulta"|x_translate}
                                            {else}
                                                <i class="icon-doctorplus-ficha-check"></i>&nbsp;{"Consulta presencial"|x_translate}
                                            {/if}
                                        </p>
                                        <span class="pcuh-tunos-profesional">{$turno.0.medico.titulo_profesional.titulo_profesional} {$turno.0.medico.nombre} {$turno.0.medico.apellido}</span>
                                        <p class="pcuh-tunos-descripcion especialidad">{$turno.0.medico.mis_especialidades.0.especialidad}</p>
                                        <p class="pcuh-tunos-descripcion estado">
                                            {if $turno.0.estado!="1"}
                                                <em class="pendiente"> <i class="icon-doctorplus-pendiente"></i>&nbsp;{"Turno pendiente de confirmación"|x_translate}</em>
                                            {else}
                                                <em class="confirmado"> <i class="icon-doctorplus-check-circle"></i>&nbsp;{"Turno confirmado"|x_translate}</em>
                                            {/if}
                                        </p>
                                    </a>
                                    <div class="pcuh-tunos-footer">

                                        {if $turno.0.pasado!="1"}
                                            <a style="border-radius:8px;" href="{$url}panel-paciente/detalle-turno.html?idturno={$turno.0.idturno}&reprogramar={$turno.0.idturno}" data-idturno="{$turno.0.idturno}" class="btn btn-xs btn-green">{"Reprogramar"|x_translate}</a>
                                            <a style="border-radius:8px;" href="javascript:;" data-idturno="{$turno.0.idturno}" class="btn btn-alert btn-xs mdl-cancelar-turno  btn-cancelar-ajuste">{"Cancelar turno"|x_translate}</a>
                                        {/if} 
                                    </div>
                                </div>
                                {*si solo tengo un turno, como se muestran de a pares, pongo una imagen de relleno*}
                                {if $turno|@count==1}
                                    <div class="pcuh-slide-content-col">
                                        <a href="{$url}panel-paciente/busqueda-profesional/" class="pcuh-slide-content-inner">
                                            <div class="pcuh-slide-adv {if $empresa_beneficiario!='Particulier' &&  $empresa_beneficiario!=''} ajuste-padding-left{/if} ">
                                                <div class="pcuh-slide-adv-content {if $empresa_beneficiario!='Particulier' &&  $empresa_beneficiario!=''} ajuste-texto{/if}">
                                                    <h4>{"Sus turnos médicos en solo unos clicks!"|x_translate}</h4>
                                                    <p>{"Además... la comodidad de recibir avisos y recordatorios por mail o en su celular antes de la fecha."|x_translate}</p>
                                                </div>
                                            </div>
                                        </a>

                                    </div>
                                {else}
                                    <div class="pcuh-slide-content-col">
                                        <a href="{$url}panel-paciente/detalle-turno.html?idturno={$turno.1.idturno}" class="pcuh-slide-content-inner pcuh-turnos-inner">
                                            <span class="pcuh-tunos-date">{$turno.1.fecha|date_format:"%d/%m/%Y"} {$turno.1.horarioInicio|date_format:"%H:%M"}hs</span>
                                            <p class="pcuh-tunos-tipo">
                                                {if $turno.1.is_virtual=="1"}
                                                    <i class="icon-doctorplus-video-call"></i>&nbsp;{"Video Consulta"|x_translate}
                                                {else}
                                                    <i class="icon-doctorplus-ficha-check"></i>&nbsp;{"Consulta presencial"|x_translate}
                                                {/if}
                                            </p>
                                            <span class="pcuh-tunos-profesional">{$turno.1.medico.titulo_profesional.titulo_profesional} {$turno.1.medico.nombre} {$turno.1.medico.apellido}</span>
                                            <p class="pcuh-tunos-descripcion especialidad">{$turno.1.medico.mis_especialidades.0.especialidad}</p>

                                            <p class="pcuh-tunos-descripcion estado">
                                                {if $turno.1.estado!="1"}
                                                    <em class="pendiente"> <i class="icon-doctorplus-pendiente"></i>&nbsp;{"Turno pendiente de confirmación"|x_translate}</em>
                                                {else}
                                                    <em class="confirmado"> <i class="icon-doctorplus-check-circle"></i>&nbsp;{"Turno confirmado"|x_translate}</em>
                                                {/if}
                                            </p>

                                        </a>
                                        <div class="pcuh-tunos-footer">
                                            {if $turno.1.pasado!="1"}
                                                <a style="border-radius:8px;" href="{$url}panel-paciente/detalle-turno.html?idturno={$turno.1.idturno}&reprogramar={$turno.1.idturno}" data-idturno="{$turno.1.idturno}" class="btn btn-xs btn-green">{"Reprogramar"|x_translate}</a>
                                                <a style="border-radius:8px;" href="javascript:;" data-idturno="{$turno.1.idturno}" class="btn btn-alert btn-xs mdl-cancelar-turno btn-cancelar-ajuste">{"Cancelar turno"|x_translate}</a>
                                            {/if}
                                        </div>
                                    </div>

                                {/if}
                            </div>
                        </div>
                    {/foreach}
                    {if $listado_turnos|@count==0 }
                        <div class="pcuh-slide-item">
                            <div class="pcuh-slide-content">
                                <div class="pcuh-slide-content-row">
                                    <div class="pcuh-slide-sin-turnos">
                                        <p>{"Usted no registra proximos turnos"|x_translate}</p>
                                    </div>
                                </div>
                                <div class="pcuh-slide-content-row">
                                    <a href="{$url}panel-paciente/busqueda-profesional/" class="pcuh-slide-content-inner">
                                        <div class="pcuh-slide-adv">
                                            <div class="pcuh-slide-adv-content">
                                                <h4>{"Sus turnos médicos en solo unos clicks!"|x_translate}  </h4>
                                                <p>{"Además... la comodidad de recibir avisos y recordatorios por mail o en su celular antes de la fecha."|x_translate}</p>
                                            </div>
                                        </div>
                                    </a>

                                </div>

                            </div>
                        </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Modal cancelar turno -->
<div id="modal-cancelar-turno" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
    <div class="modal-dialog modal-action-bool-sm">
        <div class="modal-content">
            <form  role="form" action="{$url}cancelar_turno.do" id="send_cancelacion_turno" >
                <input type="hidden" name="id" id="idturnoCancelacion" value="" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <p>{"¿Está seguro que desea cancelar el turno?"|x_translate}</p>
                    <div class="modal-cancelar-turno-textarea">
                        <textarea id="mensaje_cancelacion_turno" name="mensaje_cancelacion_turno" placeholder='{"Indicar motivo"|x_translate}'></textarea>
                    </div>
                </div>
            </form>
            <div class="modal-action-holder">
                <a href="javascript:;" data-dismiss="modal" class="modal-action-close">{"Volver"|x_translate}</a>
                <a href="javascript:;" id="a_confirmar_cancelar" class="modal-action" style="background: #ff6f6f">{"Cancelar turno"|x_translate}</a>
            </div>
        </div>
    </div>
</div>

{literal}
    <script>
        $(function () {
            //Mostrar listado controles
            $("#btnMostrarTurnos").click(function () {
                //$(window).trigger('resize');//triger widtg slide controles
                $("#btnMostrarTurnos").hide();
                $("#btnOcultarTurnos").show();
                $("#listado-turnos").slideDown();
                if ($(this).data("fermer") == '1') {
                    $("#col-act-fermer").addClass('ajuste-btn-fermer');
                }

            });
            //Mostrar listado controles
            $("#btnOcultarTurnos").click(function () {
                $("#btnOcultarTurnos").hide();
                $("#btnMostrarTurnos").show();
                $("#listado-turnos").slideUp();
            });
            //Si hay turnos desplegamos el listado
            if ($("a.pcuh-turnos-inner").length > 0) {
                $("#btnMostrarTurnos").trigger("click");
            }
            /*Mostramos en grupos de 2 - Si hay mas de 2 inicializamos slider*/
            if ($("a.pcuh-turnos-inner").length > 2) {
                $('#pcuh-listado-turnos').slick({
                    dots: false,
                    infinite: true,
                    draggable: true,
                    speed: 300,
                    autoplay: true,
                    autoplaySpeed: 12000,
                    slidesToShow: 1,
                    adaptiveHeight: true
                });
            }

            $("#div_listado_turnos").spin(false);
            //cancelar turno modal
            $('.mdl-cancelar-turno').on('click', function (e) {
                $this = $(this);
                var id = parseInt($this.data("idturno"));
                if (id > 0) {
                    $("#idturnoCancelacion").val(id);
                    e.preventDefault();
                    $('#modal-cancelar-turno').modal('show');
                }
            });
        });

        $("#a_confirmar_cancelar").on('click', function () {
            if ($("#mensaje_cancelacion_turno").val() === "") {
                x_alert(x_translate("Indique el motivo por el que desea cancelar el turno"));
            } else {
                $("#Main").spin("large");
                x_sendForm(
                        $('#send_cancelacion_turno'),
                        true,
                        function (data) {
                            $(".modal-backdrop.fade.in").remove();
                            $('#modal-cancelar-turno').modal('hide');
                            $("#Main").spin(false);
                            if (data.result) {
                                x_alert(x_translate("Cita cancelada, se le ha reintegrado su consulta."), recargar);
                            } else {
                                x_alert(data.msg);
                            }

                        }
                );
            }
        });
    </script>
{/literal}
