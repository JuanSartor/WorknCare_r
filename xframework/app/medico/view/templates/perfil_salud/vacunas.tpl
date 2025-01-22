
{if $smarty.request.print==1}
{include file="perfil_salud/header_perfil_salud_imprimir.tpl"}
{else}
{include file="perfil_salud/menu_perfil_salud.tpl"}
<section class="container-fluid">
    <div class="row ">
        <div class="col-md-12">
            <div class="container">
                <ol class="breadcrumb">
                    <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                    <li><a href="{$url}panel-medico/mis-pacientes/">{"Mis Pacientes"|x_translate}</a></li>
                    <li><a  class="nombre_paciente"  href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/">{$paciente.nombre} {$paciente.apellido}</a></li>
                    <li class="active">{"Vacunas"|x_translate}</li>
                </ol>
            </div>
        </div>
    </div>
</section>
{/if}
        <!--Link modal sugerencia usabilidad horizontal-->
<a href="javascript:;" class="modal-btn" data-target="usabilidad-modal" id="active_modal_usabilidad" role="button"></a>


{*<section class="module-header container">
    <figure class="circle-icon-images icon-vacuna"></figure>
    <h1>Vacunas</h1>
    <p class="notice text-primary">{"Calendario Nacional de Vacunación"|x_translate}</p>
</section>*}
<!-- /main header -->

<section class="container vacunas-leyendas">
    <ul>
        <li class="va-unica-dosis"><span>{"Única dosis"|x_translate}</span></li>
        <li class="va-primer-dosis"><span>1&deg; {"dosis"|x_translate}</span></li>
        <li class="va-segunda-dosis"><span>2&deg; {"dosis"|x_translate}</span></li>
        <li class="va-tercera-dosis"><span>3&deg; {"dosis"|x_translate}</span></li>
        <li class="va-cuarta-dosis"><span>4&deg; {"dosis"|x_translate}</span></li>
        <li class="va-refuerzo"><span>{"Refuerzo"|x_translate}</span></li>
        <li class="va-esquema"><span>{"Iniciar o completar esquema"|x_translate}</span></li>
        <li class="va-anual-dosis"><span>{"Dosis anual"|x_translate}</span></li>
    </ul>
</section>


<section class="container calendario-vacunas" >
    <div class="row">

        <ul class="col-edad">
            <li>{"Edad"|x_translate}</li>
            <li>DN</li>
            <li>{"2M"|x_translate}</li>
            <li>{"4M"|x_translate}</li>
            <li>{"6M"|x_translate}</li>
            <li>{"12M"|x_translate}</li>
            <li>{"15M"|x_translate}</li>
            <li>{"15-18M"|x_translate}</li>
            <li>{"18M"|x_translate}</li>
            <li>{"24M"|x_translate}</li>
            <li>{"5-6A"|x_translate}</li>
            <li>{"11A"|x_translate}</li>
            <li class="two-lines">{"A partir de los  15 A"|x_translate}</li>
            <li>{"Adultos"|x_translate}</li>
            <li>{"Embarazadas"|x_translate}</li>
            <li>{"Puerperio"|x_translate}</li>
            <li class="two-lines">{"Personal de la Salud"|x_translate}</li>
        </ul> 

        <a href="javascript:;" class="slider-arrow slider-prev"><span class="fui-arrow-left"></span></a>


        <div id="slider-vacunas-container">
            <div class="slider-vacunas">
                {foreach from=$listado item=vacuna}
                <ul>
                    <li>{$vacuna.vacuna}</li>
                    {foreach from=$vacuna.vacunaedad item=vacunaedad}
                    {if $vacunaedad.vacuna_vacunaedad.clase != ""}
                    <li data-id="{$vacunaedad.vacuna_vacunaedad.idvacuna_vacunaEdad}" class="{$vacunaedad.vacuna_vacunaedad.clase}">
                        {if $vacunaedad.vacuna_vacunaedad.ref_num != ""}<span class="ref-num">{$vacunaedad.vacuna_vacunaedad.ref_num}</span>{/if}
                        {if $vacunaedad.vacuna_vacunaedad.paciente_idpaciente == $paciente.idpaciente}<span class="fui-check"></span>{/if}
                    </li>
                    {else}                        
                    <li></li>
                    {/if}
                    {/foreach}
                </ul>
                {/foreach}
            </div>		
        </div>		

        <a href="javascript:;" class="slider-arrow slider-next"><span class="fui-arrow-right"></span></a>

    </div>
</section>
<!-- /Calendario VACUNAS -->



<section class="container vacunas-notas" >
    <div class="row">		
        <div class="col-md-12">
            <h3>{"APLICACIÓN"|x_translate}</h3>
            <p>
                {"(1)	Se inicia esquema: 3 dosis (0-1-6 meses)"|x_translate} <br>
                {"(2)	Niños desde 6 meses hasta 24 meses de edad."|x_translate} <br>
                {"(3)	En cualquier trimestre de la gestación."|x_translate} <br>
                {"(4)	Madres de niños menores de 6 meses (si no la hubieran recibido durante el embarazo)"|x_translate} <br>
                {"(5)	Se indica 1 dosis a partir de la semana 20 de gestación"|x_translate} <br>
                {"(6)	Se indica 1 dosis a quienes atienden a niños menores de 1 año."|x_translate} <br>
                {"(7)	Se indica refuerzo cada 10 años."|x_translate} <br>
                {"(8)	Niñas de 11 años de edad: 3 dosis (0-1-6 meses o 0-2-6 meses)"|x_translate} <br>
                {"(9)	Si no hubiera recibido 2 dosis de Triple Viral o 1 dosis de Doble Viral"|x_translate} <br>
                {"(10)	Residentes en zonas de riesgo"|x_translate} <br>
                {"(11) 	Residentes en zonas de riesgo. Unico refuerzo a los 10 años de la 1º dosis"|x_translate}
            </p>
        </div>  

        <div class="col-md-6">		
            <h3>{"VACUNAS"|x_translate}</h3>
            <p>
                {"BCG: Tuberculosis (formas invasivas)"|x_translate} <br>
                {"Hepatitis B"|x_translate} <br>
                {"Neumococo Conjugada: Previene la Meningitis, Neumonía y Sepsis por Neumococo."|x_translate} <br>
                {"Pentavalente/Quíntuple: Difteria, Tétanos, Tos Convulsa, Hepatitis B, Haemophilus Influenzae tipo b."|x_translate} <br>
                {"Rotavirus"|x_translate} <br>
                {"Cuádruple Pentavalente: Difteria, Tétanos, Tos Convulsa, Hepatitis B, Haemophilus Influenzae tipo b."|x_translate}  <br>
                {"Sabin: Vacuna contra la Poliomielitis."|x_translate} <br>
                {"Triple Viral: Sarampión, Rubeóla, Paperas."|x_translate} <br>
                {"Gripe"|x_translate} <br>
                {"Hepatitis A"|x_translate} <br>
                {"Varicela"|x_translate} <br>
                {"Triple Bacteriana Acelular: Difteria, Tétanos, Tos Convulsa."|x_translate} <br>
                {"Doble Bacteriana: Difteria, Tétanos."|x_translate} <br>
                {"VHP: Virus Papiloma Humano, causante del 100% de los casos de cáncer de cuello de útero."|x_translate} <br>
                {"Doble Viral: Sarampión, Rubeóla."|x_translate}
            </p>
        </div>	
        <div class="col-md-6">		
            <h3>{"VACUNAS PARA RESIDENTES EN ZONAS DE RIESGO"|x_translate}</h3>
            <p>
                {"Fiebre Amarilla"|x_translate} <br>
                {"Fiebre Hemorrágica Argentina"|x_translate}
            </p>
        </div>
    </div>  

    <!--</div>-->
</section>


<div class="modal fade modal-type-2" id="vacuna-aplicada">
    <div class="modal-dialog">
        <div class="modal-content" id="div_modal_vacuna_aplicada">

        </div>
    </div>
</div>		

{literal}
<script>
    $(document).ready(function() {
        
        	
	$("ul.slider-menu li a").removeClass("active");
    $("ul.slider-menu li i.dpp-vacuna").parent().addClass("active");
    
           if ($("#check_window_orientation").css("display") == "block") {
                
                $("#usabilidad-modal").modal("toggle");
            }
            else {
                $("#usabilidad-modal").modal("hide");
            }
           

        $('.slider-vacunas').slick({
            centerMode: false,
            dots: false,
            draggable: false,
            focusOnSelect: false,
            infinite: true,
            nextArrow: '.slider-next',
            prevArrow: '.slider-prev',
            slidesToScroll: 9,
            slidesToShow: 9,
            touchMove: false,
            responsive: [
                {
                    breakpoint: 1024,
                    settings: {
                        slidesToShow: 4,
                        slidesToScroll: 4
                    }
                },
                {
                    breakpoint: 600,
                    settings: {
                        slidesToShow: 2,
                        slidesToScroll: 2
                    }
                },
                {
                    breakpoint: 480,
                    settings: {
                        slidesToShow: 1,
                        slidesToScroll: 1
                    }
                }
            ]
        });

        $('.slider-vacunas li').on('click', function() {
            if ($(this).data("id") != "") {
                //console.log($(this).data("id"));
                x_loadModule('perfil_salud',
                        'vacunas_modal_form',
                        'id=' + $(this).data("id"),
                        "div_modal_vacuna_aplicada",
                        BASE_PATH + "medico",
                        "",
                        function() {
                            $("#vacuna-aplicada").modal();
                        });
            }
            //$("#vacuna-aplicada").modal();
        });
    });
</script>
{/literal}

