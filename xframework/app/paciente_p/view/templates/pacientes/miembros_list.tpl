<style>
    .pul-privacidad-box {
        position: absolute;
        padding-right: 0px;
        width: 100%;
    }
</style>
<section class="section-header section-header profile filter-table-header filter-table-header-paciente">
    <div class="container">
        <div class="user-select pull-left">

            <h1 class="section-name"><i class="icon-doctorplus-usr-group"></i> {"Miembros"|x_translate}</h1>
        </div>
    </div>
</section> 
<div id="div_agregar_miembros" >
    <div class="cs-nc-section-holder">
        <section class="container cs-nc-p2">
            <div class="cs-ca-consultas-holder">
                <div class="row">
                    <div class="pul-list-holder">
                        <!--list item-->
                        {foreach from=$all_members item=miembro}
                            {if $miembro.idpaciente!=$paciente_titular.idpaciente}    
                                <div class="pul-card relative">
                                    <div class="pul-card-content">
                                        <div class="pul-header-close">
                                            <div class="pul-privacidad-box {if $miembro.idpaciente==$paciente_titular.idpaciente}pul-privacidad-box-usr-fijo{/if}">
                                                <div class="pul-privacidad-select">
                                                    <select name="plan" id="privacidad_perfil_salud" class="form-control select select-primary select-block pul-np-dis ">
                                                        <option data-lock="1" data-privacidad="0" data-idpaciente="{$miembro.idpaciente}" {if $miembro.privacidad_perfil_salud=="0"}selected{/if} value="0">{"Nadie"|x_translate}</option>
                                                        <option data-lock="1" data-privacidad="1" data-idpaciente="{$miembro.idpaciente}" {if $miembro.privacidad_perfil_salud=="1"}selected{/if} value="1">{"Profesionales frecuentes"|x_translate}</option>
                                                        <option data-lock="0" data-privacidad="2" data-idpaciente="{$miembro.idpaciente}" {if $miembro.privacidad_perfil_salud=="2"}selected{/if} value="2">{"Todos los profesionales"|x_translate}</option>
                                                    </select>

                                                </div>
                                            </div>
                                            <div class="pul-lock"><i class="icon-doctorplus-lock"></i></div>

                                            <a href="javascript:;"  class="a_eliminar_paciente" data-id="{$miembro.idpaciente}" title='{"Eliminar"|x_translate}' data-nombre="{$miembro.nombre} {$miembro.apellido}"><i class="icon-doctorplus-cruz"></i></a> 

                                        </div>
                                        <a href="javascript:;" class="a_miembro" title="{$miembro.nombre} {$miembro.apellido}"  {if $miembro.email!=""} data-requerimiento="self"{else} data-requerimiento="{$miembro.idpaciente}"{/if}>
                                            <div class="pul-avatar-holder">
                                                {if $miembro.image.list}
                                                    <img src="{$miembro.image.list}"  width="110" height="110" alt="{$miembro.nombre} {$miembro.apellido}" class="img-circle">
                                                {else}
                                                    <img src="{$IMGS}extranet/noimage_nuevomiembro.jpg" width="110" height="110"  alt="{$miembro.nombre} {$miembro.apellido}" class="img-circle">
                                                {/if}

                                            </div>

                                            <div class="pcu-data-holder">
                                                <span class="pcu-name">{$miembro.nombre} {$miembro.apellido}</span>
                                                <span class="pcu-fn">
                                                    {if $miembro.sexo==0}
                                                        <i class="icon-doctorplus-fem-symbol"></i> 
                                                    {else}
                                                        <i class="icon-doctorplus-masc-symbol"></i> 
                                                    {/if}
                                                    DN {$miembro.fechaNacimiento_format}
                                                </span>
                                            </div>
                                        </a>
                                        <div class="pcu-action-holder">
                                            <ul>
                                                <li>
                                                    <a href="{$url}panel-paciente/home.html#listado-turnos" {if $miembro.email!=""} data-requerimiento="self"{else} data-requerimiento="{$miembro.idpaciente}"{/if}>
                                                        <figure><i class="icon-doctorplus-calendar-time"></i></figure>
                                                            {if $miembro.info_extra.cantidad_turnos > 0}
                                                            <span>{$miembro.info_extra.cantidad_turnos}</span>
                                                        {/if}
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="{$url}panel-paciente/consultaexpress/"  {if $miembro.email!=""} data-requerimiento="self"{else} data-requerimiento="{$miembro.idpaciente}"{/if}">
                                                        <figure><i class="icon-doctorplus-chat"></i></figure>
                                                            {if $miembro.info_extra.cant_consultaexpress > 0}
                                                            <span>{$miembro.info_extra.cant_consultaexpress}</span>
                                                        {/if}
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="{$url}panel-paciente/videoconsulta/" {if $miembro.email!=""} data-requerimiento="self"{else} data-requerimiento="{$miembro.idpaciente}"{/if}">
                                                        <figure><i class="icon-doctorplus-video-call"></i></figure>
                                                            {if $miembro.info_extra.cant_videoconsulta > 0}
                                                            <span>{$miembro.info_extra.cant_videoconsulta}</span>
                                                        {/if}
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="{$url}panel-paciente/notificaciones/"  {if $miembro.email!=""} data-requerimiento="self"{else} data-requerimiento="{$miembro.idpaciente}"{/if}">
                                                        <figure><i class="fa fa-bell-o"></i></figure>
                                                            {if $miembro.info_extra.cant_notificaciones > 0}
                                                            <span>{$miembro.info_extra.cant_notificaciones}</span>
                                                        {/if}
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            {/if}
                        {/foreach}

                        <div class="pul-card">
                            <div class="pul-card-content pul-card-new-user">
                                <a class="icon" href="{$url}panel-paciente/alta-miembro-grupo-familiar/">
                                    <figure>
                                        <i class="icon-doctorplus-user-add-circle"></i>								
                                    </figure>
                                    <h3>{"Agregar miembro de grupo familiar"|x_translate}</h3>
                                </a>
                                <div class="content">
                                    <p align="center">
                                        {"Puedes agregar a tu cuenta personas de tu grupo familiar o no autorizadas a crear cuentas propias (por ejemplo menores de edad o personas con alguna discapacidad) Si deseas solicitar alguna excepción especial,"|x_translate} <br>
                                        <a href="mailto:soporte@workncare.io?subject=Excepción en cuenta">{"Solicítala aqui"|x_translate}</a>								
                                    </p>
                                </div>


                            </div>
                        </div>

                        <div class="pul-card">
                            <div class="pul-card-content pul-card-new-user">
                                <a class="icon" href="{$url}panel-paciente/alta-mascota-grupo-familiar/">
                                    <figure>
                                        <i class="fas fa-dog mascota"></i>								
                                    </figure>
                                    <h3>{"Agregar miembro mascota"|x_translate}</h3>
                                </a>
                                <div class="content">
                                    <p align="center">
                                        {"Puedes agregar a tu cuenta mascotas para consultar con nuestros especialistas"|x_translate} <br>
                                    							
                                    </p>
                                </div>


                            </div>
                        </div>
                        <!--@list item-->		
                    </div>
                </div>
            </div>
        </section>
        <!-- Modal elimine miembro-->
        <div class="modal fade bs-example-modal modal-perfil-completo pse-cancelar-consulta-mdl modal-pcu-borrar-usuario" tabindex="-1" role="dialog" aria-labelledby="" id="modal_eliminar_paciente">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">

                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <p>{"Está por eliminar a"|x_translate} <span id="span_nombre_paciente"></span></p>
                        <span class="pcu-modal-confirmar-txt">{"¿Desea continuar?"|x_translate}</span>
                        <div class="modal-perfil-completo-action-holder">
                            <button class="pcu-modal-btn-cancelar" data-dismiss="modal">{"Cancelar"|x_translate}</button>
                            <button data-id="" data-nombre="" id="btnEliminarMiembro">{"Confirmar"|x_translate}</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    {literal}
        <script>

            $(function () {
                $(".pul-privacidad-box").data("title", x_translate("¿Quién puede ver el Perfil de Salud?")).tooltip();
                //btn ir a home del paciente seleccionado
                $(".a_miembro").click(function () {
                    var requerimiento = $(this).data("requerimiento");
                    //id del paciente



                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'panel-paciente/change_member.do',
                            "requerimiento=" + requerimiento,
                            function (data) {
                                if (data.result) {
                                    window.location.href = BASE_PATH + "panel-paciente/home.html";
                                } else {
                                    x_alert(data.msg);
                                }
                            }
                    );
                });

                //eliminar un paciente
                $(".a_eliminar_paciente").click(function () {
                    var $this = $(this);

                    if (parseInt($this.data("id")) > 0) {
                        $("#span_nombre_paciente").html($this.data("nombre"));

                        $("#btnEliminarMiembro").data("nombre", $this.data("nombre"));
                        $("#btnEliminarMiembro").data("id", $this.data("id"));
                        $("#modal_eliminar_paciente").modal("show");
                    }
                });

                //iconos de accesos directo de cada miembro, setea el paciente en sesion y se dirige a la seccion correspondiente
                $(".pcu-action-holder a").click(function (e) {
                    e.preventDefault();
                    //id del paciente
                    var requerimiento = $(this).data("requerimiento");

                    var url = $(this).attr("href");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'panel-paciente/change_member.do',
                            "requerimiento=" + requerimiento,
                            function (data) {
                                if (data.result) {
                                    window.location.href = url;
                                } else {
                                    x_alert(data.msg);
                                }
                            }
                    );
                });

                $("#btnEliminarMiembro").click(function () {

                    var id = $(this).data("id");
                    var nombre = $(this).data("nombre");

                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'panel-paciente/dropMiembro.do',
                            "pacienteGrupo=" + id,
                            function (data) {
                                $("#modal_eliminar_paciente").modal("toggle");
                                x_alert(data.msg);

                                if (data.result) {
                                    window.location.href = BASE_PATH + "panel-paciente/miembros/";
                                }
                            }
                    );
                });
                //Select cambio privacidad 
                $('[data-tooltip="1"]').tooltip();

                function changeLock(lockIcon, lock) {
                    if (lock == 1) {
                        if (lockIcon.hasClass('icon-doctorplus-unlock')) {
                            lockIcon.removeClass('icon-doctorplus-unlock')
                                    .addClass('icon-doctorplus-lock');
                        }
                    } else if (lock == 0) {
                        if (lockIcon.hasClass('icon-doctorplus-lock')) {
                            lockIcon.removeClass('icon-doctorplus-lock')
                                    .addClass('icon-doctorplus-unlock');
                        }
                    }
                }

                var initLock = $('.pul-privacidad-select > select');

                initLock.each(function (i, el) {

                    initState = $(this).find('option:selected').data('lock');
                    initEl = $(this).closest('.pul-privacidad-box').siblings('.pul-lock').children('i');

                    changeLock(initEl, initState);
                });

                //Evento al cambiar los select de privacidad de cada paciente
                $('.pul-privacidad-select > select').change(function (e) {
                    var $card = $(this).closest($(".pul-card"));
                    var dataLock = $(this).find('option:selected').data('lock');
                    var lockIcon = $(this).closest('.pul-privacidad-box').siblings('.pul-lock').children('i');
                    var idpaciente = $(this).find('option:selected').data('idpaciente');
                    var value = $(this).find('option:selected').data('privacidad');
                    if (parseInt(idpaciente) > 0) {
                        $card.spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'save_privacidad.do',
                                'idpaciente=' + idpaciente + '&perfil-privado=' + value,
                                function (data) {
                                    $card.spin(false);
                                    if (data.result) {
                                        changeLock(lockIcon, dataLock);
                                    } else {
                                        x_alert(data.msg);
                                    }
                                });
                    }


                });



            });
        </script>

    {/literal}
