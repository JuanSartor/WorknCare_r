{if $account.medico.acceso_perfil_salud=="1"}
    <style>
        @media (max-width: 767px){
            .fold {
                display: none;
            }
        }
        #info-pacientes .container .detalles-paciente {
            padding: 0 25px;
            border-bottom: 1px solid #78909c;
            margin-bottom: 5px;
        }

        #info-pacientes .container {
            padding: 25px;
            position: relative;
            width:auto !important;
        }
        #info-pacientes a.toggle-ver {
            display: inline;
            color: #455a64;
            text-decoration: underline;
            font-size: 14px;
            background: #f7f7f7;
            padding: 5px;
        }
        #info-pacientes a.toggle-ver.ocultar{
            bottom:0px !important;
        }
        #info-pacientes .paciente-info figure,#info-pacientes .paciente-info  .nombre-paciente{
            display: inline-block;
            text-align: left;
        }
        #info-pacientes .paciente-info img {
            border-radius: 50%;
            width: 55px;
            height: auto;
            vertical-align: text-bottom;
            margin-right: 10px;
        }
        .tablero-box .slider-menu .slick-track{
            float:none !important;
            margin: auto !important ;
        } 
        .tablero-box .slider-menu li a {
            margin:auto;
        }
        .tablero-box .slider-menu li span{
            font-size: 14px;
            color: #fff;
            font-weight: 500;
        }



    </style>

    <nav class="tablero-box">

        <div class="container-fluid ">
            <div class="row">
                <div class="col-xs-1 visible-xs">
                    <a href="javascript:;" class="slider-arrow slider-menu-prev"></a>
                </div>	
                <div class="col-xs-10 col-sm-12">
                    {if $account.medico.tipo_especialidad==2}
                        {include file="perfil_salud_menu/menu_no_medicos.tpl"}
                    {else}
                        {if $account.medico.idespecialidad==32}
                            {include file="perfil_salud_menu/menu_generalista.tpl"}
                        {else if  $account.medico.idespecialidad==54}
                            {include file="perfil_salud_menu/menu_pediatra.tpl"}
                        {else if $paciente.sexo==0 && ($account.medico.idespecialidad==23 || $account.medico.idespecialidad==24)}
                            {include file="perfil_salud_menu/menu_ginecologia.tpl"}
                        {else if  $account.medico.idespecialidad==47}
                            {include file="perfil_salud_menu/menu_oftalmologia.tpl"}
                        {else if  $account.medico.idespecialidad|in_array:[8,9,10,11,12,13,14,15,16]}
                            {include file="perfil_salud_menu/menu_cirugia.tpl"}
                        {else if  $account.medico.idespecialidad==18}
                            {include file="perfil_salud_menu/menu_dermatologia.tpl"}
                        {else}
                            {include file="perfil_salud_menu/menu_default.tpl"}
                        {/if} 
                    {/if}
                </div>
                <div class="col-xs-1 visible-xs">
                    <a href="javascript:;" class="slider-arrow slider-menu-next"></a>
                </div>				

            </div>	
        </div>
    </nav>


    <section class="container-fluid" id="info-pacientes">
        <div class="container">
            <div class="fold">
                <div class="detalles-paciente">
                    <ul>
                        <li class="pad-top-5 paciente-info">
                            <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/">
                                <figure>
                                    {if $paciente.image.perfil != ""}
                                        <img src="{$paciente.image.perfil}" alt="{$paciente.nombre} {$paciente.apellido}">
                                    {else}
                                        <img src="{$IMGS}extranet/noimage-paciente.jpg " alt="{$paciente.nombre} {$paciente.apellido}">
                                    {/if}
                                </figure>
                                <div class="nombre-paciente">
                                    {$paciente.nombre} {$paciente.apellido} 
                                    <span>
                                        DN {if $paciente.fechaNacimiento != ""}{$paciente.fechaNacimiento|date_format:"%d/%m/%Y"}{else} - {/if}
                                    </span>
                                </div>
                            </a>
                        </li>
                        {if $paciente.animal!=1}
                            <li class="pad-top-5">
                                <figure class="usr-icon"><i class="icon-doctorplus-ficha-tecnica"></i></figure>

                                {if $paciente.pais_idpais==1 || $paciente.pais_idpais_trabajo==1 }
                                    {if $paciente.imagenes_tarjeta.vitale.path!=""}
                                        <a href="{$paciente.imagenes_tarjeta.vitale.path}" target="_blank">
                                            <small>{"Ver"|x_translate} {"Tarjeta Vitale"|x_translate}:</small>
                                            <span class="sub-line">Nº {$paciente.tarjeta_vitale}</span>
                                        </a>
                                    {else}
                                        <small>{"Tarjeta Vitale"|x_translate}:</small>
                                        <span class="sub-line">Nº {$paciente.tarjeta_vitale}</span>
                                    {/if}
                                {/if}

                                {if $paciente.pais_idpais==2 || $paciente.pais_idpais_trabajo==2 }
                                    {if $paciente.imagenes_tarjeta.cns.path!=""}
                                        <a href="{$paciente.imagenes_tarjeta.cns.path}" target="_blank">
                                            <small>{"Ver"|x_translate} {"Tarjeta CNS"|x_translate}:</small>
                                            <span class="sub-line">Nº {$paciente.tarjeta_cns}</span>
                                        </a>
                                    {else}
                                        <small>{"Tarjeta CNS"|x_translate}:</small>
                                        <span class="sub-line">Nº {$paciente.tarjeta_cns}</span>
                                    {/if}
                                {/if}

                                {if $paciente.pais_idpais==3}
                                    {if $paciente.imagenes_tarjeta.eID.path!=""}
                                        <a href="{$paciente.imagenes_tarjeta.eID.path}" target="_blank">
                                            <small>{"Ver"|x_translate} {"Tarjeta eID"|x_translate}:</small>
                                            <span class="sub-line">Nº {$paciente.tarjeta_eID}</span>
                                        </a>
                                    {else}
                                        <small>{"Tarjeta eID"|x_translate}:</small>
                                        <span class="sub-line">Nº {$paciente.tarjeta_eID}</span>
                                    {/if}
                                {/if}
                                {if $paciente.pais_idpais==4}
                                    {if $paciente.imagenes_tarjeta.pasaporte.path!=""}
                                        <a href="{$paciente.imagenes_tarjeta.pasaporte.path}" target="_blank">
                                            <small>{"Ver"|x_translate} {"Pasaporte"|x_translate}:</small>
                                            <span class="sub-line">Nº {$paciente.tarjeta_pasaporte}</span>
                                        </a>
                                    {else}
                                        <small>{"Pasaporte"|x_translate}:</small>
                                        <span class="sub-line">Nº {$paciente.tarjeta_pasaporte}</span>
                                    {/if}
                                {/if}
                            </li>

                            <li>
                                <figure class="usr-icon"><i class="dpp-consulta"></i></figure>
                                <small>{"Médico de cabecera"|x_translate}:</small>
                                {if $paciente.medico_cabecera!=""}
                                    <span class="sub-line">{$paciente.tituloprofesional} {$paciente.nombre} {$paciente.apellido}</span>
                                {else}
                                    <span class="sub-line">{"No infomado"|x_translate}</span>
                                {/if}
                            </li>
                        {/if}
                        <li><a id="btnImpresionPerfilSalud" href="?print=1" target="_blank"><figure class="usr-icon"><i class="icon-doctorplus-print"></i></figure><small>{"Imprimir"|x_translate}</small></a></li>
                    </ul>
                </div>

                <div class="tagsinput-primary">
                    <input name="tagsinput" class="tagsinput" data-role="tagsinput" value="{$tags}" />

                </div>
            </div>
            <a href="javascript:;" class="toggle-ver toggle-info-box mostrar"><i class="fa fa-plus"></i> &nbsp;<span>{"Mostrar datos del paciente"|x_translate}</span></a>	
        </div>
    </section>	
    {literal}
        <script type="text/javascript">
            $(document).ready(function () {
                actualizar_menu_status_perfilsalud();
                if ($("#item_menu").val() != "") {
                    $(".menu.list.board-switcher").find(".icon-svg.circle." + $("#item_menu").val()).addClass("active");
                }
                if ($(".slider-menu").length) {
                    $('.slider-menu').slick({
                        centerMode: false,
                        dots: false,
                        draggable: true,
                        focusOnSelect: false,
                        infinite: true,
                        nextArrow: '.slider-menu-next',
                        prevArrow: '.slider-menu-prev',
                        slidesToScroll: 11,
                        slidesToShow: 11,
                        touchMove: false,
                        responsive: [
                            {
                                breakpoint: 1024,
                                settings: {slidesToShow: 6, slidesToScroll: 6}
                            },
                            {
                                breakpoint: 768,
                                settings: {slidesToShow: 4, slidesToScroll: 4}
                            },
                            {
                                breakpoint: 600,
                                settings: {slidesToShow: 3, slidesToScroll: 3}
                            },
                            {
                                breakpoint: 480,
                                settings: {slidesToShow: 2, slidesToScroll: 2}
                            }
                        ]
                    });
                }
                $('.toggle-info-box').on('click', function () {
                    $('#info-pacientes .fold').slideToggle();

                    if ($('.toggle-info-box').hasClass("ocultar")) {
                        $('.toggle-info-box').find("span").html(x_translate('Mostrar datos del paciente'));
                        $('.toggle-info-box').find("i").addClass("fa-plus");
                        $('.toggle-info-box').find("i").removeClass("fa-minus");
                        $('.toggle-info-box').addClass('info-position');
                        $('.toggle-info-box').addClass("mostrar");
                        $('.toggle-info-box').removeClass("ocultar");


                        if (window.sessionStorage) {
                            window.sessionStorage.setItem("mostrar_inputs", "0");
                        }
                    } else {
                        $('.toggle-info-box').find("span").html(x_translate('Ocultar datos del paciente'));
                        $('.toggle-info-box').find("i").addClass("fa-minus");
                        $('.toggle-info-box').find("i").removeClass("fa-plus");
                        $('.toggle-info-box').removeClass('info-position');
                        $('.toggle-info-box').removeClass('mostrar');
                        $('.toggle-info-box').addClass('ocultar');

                        if (window.sessionStorage) {
                            window.sessionStorage.setItem("mostrar_inputs", "1");
                        }
                    }
                    return false;

                });

                if ($(window).width() < 768) {
                    $('#info-pacientes .fold').hide();
                    $('.toggle-info-box').find("span").html(x_translate('Mostrar datos del paciente'));
                    $('.toggle-info-box').find("i").removeClass("fa-minus");
                    $('.toggle-info-box').find("i").addClass("fa-plus");
                    $('.toggle-info-box').addClass('info-position', 'mostrar');
                    $('.toggle-info-box').removeClass("ocultar");
                } else {
                    if (window.sessionStorage && window.sessionStorage.getItem("mostrar_inputs") == "0") {
                        $('#info-pacientes .fold').slideToggle();
                        $('.toggle-info-box').find("span").html(x_translate('Mostrar datos del paciente'));
                        $('.toggle-info-box').find("i").removeClass("fa-minus");
                        $('.toggle-info-box').find("i").addClass("fa-plus");
                        $('.toggle-info-box').addClass('info-position');
                        $('.toggle-info-box').addClass('mostrar');
                        $('.toggle-info-box').removeClass("ocultar");
                    } else {
                        $('.toggle-info-box').find("span").html(x_translate('Ocultar datos del paciente'));
                        $('.toggle-info-box').find("i").removeClass("fa-plus");
                        $('.toggle-info-box').find("i").addClass("fa-minus");
                        $('.toggle-info-box').removeClass('info-position');
                        $('.toggle-info-box').removeClass('mostrar');
                        $('.toggle-info-box').addClass('ocultar');
                    }
                }

                $('[data-toggle="tooltip"]').tooltip();

                $("#info-pacientes span[data-role='remove']").remove();

            });
        </script>
    {/literal}
{/if}