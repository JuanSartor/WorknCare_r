{include file="perfil_salud/profile_settings.tpl"}

{include file="perfil_salud/menu_perfil_salud.tpl"}
{*<section class="module-header container-fluid">
<div class="row ">
<div class="col-md-12">
<div class="container">
<ol class="breadcrumb">
<li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
<li><a href="{$url}panel-paciente/perfil-salud/">{"Perfil de Salud"|x_translate}</a></li>
<li class="active">{"Estilo de vida"|x_translate}</li>
</ol>
</div>
</div>
</div>
</section>*}

{if $paciente}
    <section class="module-header container ajustes-panel-paciente">
        <figure class="circle-icon-images icon-estilo-vida"></figure>
        <h1>{"Estilo de Vida"|x_translate}</h1>
    </section>
    <!-- /main header -->

    <form id="perfil_estilo_vida_form" action="{$url}save_estilo_vida_form.do" method="post" onsubmit="return false;">
        <input type="hidden" name="paciente_idpaciente" id="paciente_idpaciente" value="{$paciente.idpaciente}" />
        <input type="hidden" name="idperfilSaludEstiloVida" id="idperfilSaludEstiloVida" value="{$record.idperfilSaludEstiloVida}" />
        <input type="hidden" name="actividad_fisica" id="actividad_fisica" value="{$record.actividad_fisica}" />
        <input type="hidden" name="consumo_tabaco" id="consumo_tabaco" value="{$record.consumo_tabaco}" />
        <input type="hidden" name="consumo_azucares_grasas" id="consumo_azucares_grasas" value="{$record.consumo_azucares_grasas}" />
        <input type="hidden" name="consumo_sal" id="consumo_sal" value="{$record.consumo_sal}" />
        <input type="hidden" name="consumo_alcohol" id="consumo_alcohol" value="{$record.consumo_alcohol}" />
    </form>


    <section class="data-form container" id="estilo-de-vida">
        <div class="row">

            <article class="col-md-6 " id="article_actividad_fisica">
                <div class="card card-green">
                    <div class="card-header">
                        <h1 class="card-title">{"Actividad Física"|x_translate}</h1>
                    </div>
                    <div class="card-body">
                        <ul>
                            <li><label class="checkbox" for="2-7"><input type="checkbox" value="0" id="2-7">{"De  2 a 7 veces por semana"|x_translate}</label></li>
                            <li><label class="checkbox" for="1-w"><input type="checkbox" value="1" id="1-w">{"1 vez por semana"|x_translate}</label></li>
                            <li><label class="checkbox" for="1-wh"><input type="checkbox" value="2" id="1-wh">{"De vez en cuando"|x_translate}</label></li>
                            <li><label class="checkbox" for="0-n"><input type="checkbox" value="3" id="0-n" >{"No hace actividad física"|x_translate}</label></li>
                        </ul>	
                    </div>
                </div>
            </article>					
            <!-- /Actividad F�sica -->

            <article class="col-md-6 " id="article_consumo_tabaco">
                <div class="card card-brown">
                    <div class="card-header">
                        <h1 class="card-title">{"Consumo de tabaco"|x_translate}</h1>
                    </div>
                    <div class="card-body">
                        <ul>
                            <li><label class="checkbox" for="s-0"><input value="0" type="checkbox" id="s-0">{"No fuma"|x_translate}</label></li>
                            <li><label class="checkbox" for="s-w"><input value="1" type="checkbox" id="s-w">{"De vez en cuando"|x_translate}</label></li>
                            <li><label class="checkbox" for="s1-7d"><input value="2" type="checkbox" id="s1-7d">{"De 1 a 7 cigarrillos diarios"|x_translate}</label></li>
                            <li><label class="checkbox" for="s7-p"><input value="3" type="checkbox" id="s7-p">{"Más  de 7 cigarrillos diarios"|x_translate}</label>
                            </li>
                        </ul>
                    </div>
                </div>
            </article>					
            <!-- /Consumo de tabaco -->

            <article class="col-md-6 ">
                <div class="card card-blue-light" id="article_consumo_azucares">
                    <div class="card-header">
                        <h1 class="card-title">{"Consumo de azúcares y grasas"|x_translate}</h1>
                    </div>
                    <div class="card-body">
                        <ul>
                            <li><label class="checkbox" for="reg-m"><input value="0" type="checkbox" id="reg-m" data-toggle="checkbox" class="custom-checkbox">{"Regularmente en pocas cantidades"|x_translate}</label></li>
                            <li><label class="checkbox" for="ow-m"><input value="1" type="checkbox" id="ow-m" data-toggle="checkbox" class="custom-checkbox">{"De vez en cuando en pocas cantidades"|x_translate}</label></li>
                            <li><label class="checkbox" for="ow-p"><input value="2" type="checkbox" id="ow-p" data-toggle="checkbox" class="custom-checkbox">{"De vez en cuando en grandes cantidades"|x_translate}</label></li>
                            <li><label class="checkbox" for="reg-p"><input value="3" type="checkbox" id="reg-p" data-toggle="checkbox" class="custom-checkbox">{"Regularmente en grandes cantidades"|x_translate}</label></li>
                        </ul>						
                    </div>
                </div>
            </article>					
            <!-- /Consumo de az�cares y grasas -->				

            <article class="col-md-6 " id="article_consumo_sal">
                <div class="card card-yellow-dark">
                    <div class="card-header">
                        <h1 class="card-title">{"Consumo de sal"|x_translate}</h1>
                    </div>
                    <div class="card-body">
                        <ul>
                            <li><label class="checkbox" for="0.5d"><input value="0" type="checkbox" id="0.5d">{"Menos de 0,5 g. diarios"|x_translate}</label></li>
                            <li><label class="checkbox" for="0.5-5d"><input value="1" type="checkbox" id="0.5-5d">{"Entre 0,5 y 5 g. diarios"|x_translate}</label></li>
                            <li><label class="checkbox" for="5-12d"><input value="2" type="checkbox" id="5-12d">{"Entre 5 a 12 g. diarios"|x_translate}</label></li>
                            <li><label class="checkbox" for="m-12d"><input value="3" type="checkbox" id="m-12d">{"Más  de 12 g. diarios"|x_translate}</label></li>
                            <li style="font-size:12px; padding-left:32px;">{"5 g. de sal equivalen a una cucharadita llena o dos sobrecitos y medio"|x_translate}</li>
                        </ul>
                    </div>
                </div>
            </article>					
            <!-- /Consumo de sal -->

            <article class="col-md-6 " id="article_consumo_alcohol">
                <div class="card card-red">
                    <div class="card-header">
                        <h1 class="card-title">{"Consumo de alcohol"|x_translate}</h1>
                    </div>
                    <div class="card-body">							
                        <ul>
                            <li><label class="checkbox" for="a-0"><input value="0" type="checkbox" id="a-0">{"No toma alcohol"|x_translate}</label></li>
                            <li><label class="checkbox" for="a-ow"><input value="1" type="checkbox" id="a-ow">{"Una copa de vez en cuando"|x_translate}</label></li>
                            <li><label class="checkbox" for="a-1d"><input value="2" type="checkbox" id="a-1d">{"Una copa por día"|x_translate}</label></li>
                            <li><label class="checkbox" for="a-2d"><input value="3" type="checkbox" id="a-2d">{"Dos copas diarias"|x_translate}</label></li>
                            <li><label class="checkbox" for="a-2p"><input value="4" type="checkbox" id="a-2p">{"Más de dos copas diarias"|x_translate}</label></li>
                        </ul>
                    </div>
                </div>
            </article>					
            <!-- /Consumo de alcohol -->

        </div>
    </section>

    {*
    
    <section class="container">
    <div class="row">
    <article class="col-md-6 ">
    <div class="card card-white estilo-de-vida">
    <div class="card-header">
    <h1 class="card-title">{"Estilo de vida"|x_translate}</h1>
    </div>

    <div class="card-body">
    <div class="indices-porcentaje">
    <ul>
    <li>0%</li>
    <li>{"Recomendable"|x_translate}</li>
    <li>100%</li>
    </ul>
    <span class="line"></span>
    </div>
    <table>
    <tbody>
    <tr class="row-ac">
    <td><span></span>{"Actividad física"|x_translate}</td>
    <td><span class="progreso" style="width:{$info_estilo_vida.porc_actividad_fisica}%"></span></td>
    </tr>
    <tr class="row-ct">
    <td><span></span>{"Consumo de tabaco"|x_translate}</td>
    <td><span class="progreso" style="width:{$info_estilo_vida.porc_consumo_tabaco}%"></span></td>
    </tr>
    <tr class="row-ca">
    <td><span></span>{"Consumo de alcohol"|x_translate}</td>
    <td><span class="progreso" style="width:{$info_estilo_vida.porc_consumo_alcohol}%"></span></td>
    </tr>
    <tr class="row-cag">
    <td><span></span>{"Consumo de azúcares y grasas"|x_translate}</td>
    <td><span class="progreso" style="width:{$info_estilo_vida.porc_consumo_azucares_grasas}%"></span></td>
    </tr>
    <tr class="row-cs">
    <td><span></span>{"Consumo de sal"|x_translate}</td>
    <td><span class="progreso" style="width:{$info_estilo_vida.porc_consumo_sal}%"></span></td>
    </tr>	
    </tbody>					
    </table>

    <p>{"Valores recomendables por la OMS"|x_translate}</p>
    </div>
    </div>
    </article>					
    <!-- estilo de vida -->		
    </div>
    </section>
    *}

    {literal}

        <script>
            $(document).ready(function () {
                $("ul.slider-menu li a").removeClass("active");
                $("ul.slider-menu li i.dpp-sonrisa").parent().addClass("active");

                //Inicialización de los checkbox
                if ($("#actividad_fisica").val() != "") {
                    $("#article_actividad_fisica input[type='checkbox'][value=" + $("#actividad_fisica").val() + "]").prop('checked', true);
                }
                if ($("#consumo_tabaco").val() != "") {
                    $("#article_consumo_tabaco input[type='checkbox'][value=" + $("#consumo_tabaco").val() + "]").prop('checked', true);
                }
                if ($("#consumo_alcohol").val() != "") {
                    $("#article_consumo_alcohol input[type='checkbox'][value=" + $("#consumo_alcohol").val() + "]").prop('checked', true);
                }
                if ($("#consumo_sal").val() != "") {
                    $("#article_consumo_sal input[type='checkbox'][value=" + $("#consumo_sal").val() + "]").prop('checked', true);
                }
                if ($("#consumo_azucares_grasas").val() != "") {
                    $("#article_consumo_azucares input[type='checkbox'][value=" + $("#consumo_azucares_grasas").val() + "]").prop('checked', true);
                }


                var send_form_estilo_vida = function () {
                    x_sendForm($('#perfil_estilo_vida_form'), true,
                            function (data) {
                                actualizar_menu_status_perfilsalud();
                                x_alert(data.msg);

                            });
                };


                $("#article_actividad_fisica input[type='checkbox']").change(function () {
                    var valor = $(this).val();

                    $("#actividad_fisica").val($(this).is(":checked") ? valor : "");

                    $("#article_actividad_fisica input[type='checkbox']").each(function (index, value) {
                        if ($(this).is(":checked") && $(this).val() != valor) {
                            $(this).prop('checked', false);
                        }
                    });
                    send_form_estilo_vida();
                });

                $("#article_consumo_tabaco input[type='checkbox']").change(function () {
                    var valor = $(this).val();
                    $("#consumo_tabaco").val($(this).is(":checked") ? valor : "");


                    $("#article_consumo_tabaco input[type='checkbox']").each(function (index, value) {
                        if ($(this).is(":checked") && $(this).val() != valor) {
                            $(this).prop('checked', false);
                        }
                    });
                    send_form_estilo_vida();
                });

                $("#article_consumo_alcohol input[type='checkbox']").change(function () {
                    var valor = $(this).val();

                    $("#consumo_alcohol").val($(this).is(":checked") ? valor : "");

                    $("#article_consumo_alcohol input[type='checkbox']").each(function (index, value) {
                        if ($(this).is(":checked") && $(this).val() != valor) {
                            $(this).prop('checked', false);
                        }
                    });
                    send_form_estilo_vida();
                });

                $("#article_consumo_sal input[type='checkbox']").change(function () {
                    var valor = $(this).val();

                    $("#consumo_sal").val($(this).is(":checked") ? valor : "");

                    $("#article_consumo_sal input[type='checkbox']").each(function (index, value) {
                        if ($(this).is(":checked") && $(this).val() != valor) {
                            $(this).prop('checked', false);
                        }
                    });
                    send_form_estilo_vida();
                });

                $("#article_consumo_azucares input[type='checkbox']").change(function () {
                    var valor = $(this).val();
                    $("#consumo_azucares_grasas").val($(this).is(":checked") ? valor : "");


                    $("#article_consumo_azucares input[type='checkbox']").each(function (index, value) {
                        if ($(this).is(":checked") && $(this).val() != valor) {
                            $(this).prop('checked', false);
                        }
                    });
                    send_form_estilo_vida();
                });


            });

        </script>
    {/literal}
{/if}