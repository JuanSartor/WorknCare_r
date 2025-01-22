<style>
    .pcuh-controles {
        background-color: #FFFFFF; 
        padding: 10px;
    }

    .pcuf-controles-slide {
        box-shadow: 2px 2px 10px 0 #666;
        border-radius: 10px;
    }
    .pcuh-slide-sin-controles {
        position: relative;
        height: 150px;
    }
    .pcuh-slide-sin-controles>p {
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
        .pcuh-slide-sin-controles {
            position: relative;
            height: auto;
        }
    }
</style>

<!-- Controles y chequeos-->
<section class="pul-perfil-incompleto">

    <div class="pul-pi-box">

        <div class="okm-row pul-pi-data-box">
            <div class="col-data">
                <figure><i class="icon-doctorplus-corazon-electro"></i></figure>
                <p>{"Controles y Chequeos"|x_translate}</p>
            </div>

            <div class="col-action">
                <a href="javascript:;" class="btn" id="btnMostrarControles">{"ver"|x_translate}</a>
                <a href="javascript:;" class="btn" id="btnOcultarControles" style="display: none;">{"cerrar"|x_translate}</a>
            </div>
        </div>
        <div id="div_listado_controles"  style="display: none;">
            <div  class="pcuh-controles" >
                <div class="pcuf-controles-slide">
                    {foreach from=$listado_controles_chequeos item=control}
                        <div class="pcuh-slide-item">

                            <div class="pcuh-slide-content">

                                <div class="pcuh-slide-content-col">
                                    <a href="{$url}panel-paciente/perfil-salud/controles-chequeos.html" class="pcuh-slide-content-inner pcuh-controles-inner">
                                        <div class="pcuh-slide-content-header">
                                            <div class="pcuh-slide-content-control">
                                                <figure class="pcuh-slide-content-vacuna">
                                                    <i class="icon-doctorplus-jeringa"></i>
                                                </figure>

                                                {if $control.0.idtipoControlChequeo=="1"}
                                                    <h4 class="pcuh-slide-content-vacuna">{$control.0.tipoControlChequeo}</h4>
                                                {else}
                                                    <h4 class="pcuh-slide-content-control">{$control.0.tipoControlChequeo}</h4>
                                                {/if}
                                            </div>
                                            <span class="pcuh-slide-content-fecha">{$control.0.fechaNotificacion|date_format:"%d/%m/%Y"}</span>
                                        </div>
                                        <p class="pcuh-slide-content-bajada">{$control.0.titulo}</p>
                                        <p class="pcuh-slide-content-descripcion">{$control.0.descripcion}</p>
                                    </a>
                                </div>
                                {*si solo tengo un control, como se muestran de a pares, pongo una imagen de relleno*}
                                {if $control|@count==1}
                                    <div class="pcuh-slide-content-col">
                                        <a href="{$url}panel-paciente/busqueda-profesional/" class="pcuh-slide-content-inner">
                                            <div class="pcuh-slide-adv">
                                                <div class="pcuh-slide-adv-content">
                                                    <h4>{"Sus turnos médicos en solo unos clicks!"|x_translate}  </h4>
                                                    <p>{"Además... la comodidad de recibir avisos y recordatorios por mail o en su celular antes de la fecha."|x_translate}</p>
                                                </div>
                                            </div>
                                        </a>
                                    </div>


                                {else}
                                    <div class="pcuh-slide-content-col">
                                        <a href="{$url}panel-paciente/perfil-salud/controles-chequeos.html" class="pcuh-slide-content-inner pcuh-controles-inner">
                                            <div class="pcuh-slide-content-header">
                                                <div class="pcuh-slide-content-control">
                                                    <figure class="pcuh-slide-content-vacuna">
                                                        <i class="icon-doctorplus-jeringa"></i>
                                                    </figure>
                                                    {if $control.1.idtipoControlChequeo=="1"}
                                                        <h4 class="pcuh-slide-content-vacuna">{$control.1.tipoControlChequeo}</h4>
                                                    {else}
                                                        <h4 class="pcuh-slide-content-control">{$control.1.tipoControlChequeo}</h4>
                                                    {/if}
                                                </div>
                                                <span class="pcuh-slide-content-fecha">{$control.1.fechaNotificacion|date_format:"%d/%m/%Y"}</span>
                                            </div>
                                            <p class="pcuh-slide-content-bajada">{$control.1.titulo}</p>
                                            <p class="pcuh-slide-content-descripcion">{$control.1.descripcion}</p>
                                        </a>
                                    </div>
                                {/if}
                            </div>
                        </div>
                    {/foreach}
                    {if $listado_controles_chequeos|@count==0 }
                        <div class="pcuh-slide-item">

                            <div class="pcuh-slide-content">
                                <div class="pcuh-slide-content-col">
                                    <div class="pcuh-slide-sin-controles">
                                        <p>{"Ud. no tiene próximos controles y chequeos"|x_translate}</p>
                                    </div>
                                </div>
                                <div class="pcuh-slide-content-col">
                                    <a href="{$url}panel-paciente/perfil-salud/" class="pcuh-slide-content-inner">
                                        <div class="pcuh-slide-controles-adv">
                                            <div class="pcuh-slide-controles-adv-img-holder">
                                                <img class="hidden-xs" src="{$IMGS}controles-ychequeos-banner.png"/>
                                            </div>
                                            <p>{"Actualice su Perfil de Salud y lo ayudaremos a cuidar mejor de su salud"|x_translate}</p>
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
{literal}
    <script>
        $(function () {

            //Mostrar listado controles
            $("#btnMostrarControles").click(function () {
                //$(window).trigger('resize');//triger widtg slide controles
                $("#btnMostrarControles").hide();
                $("#btnOcultarControles").show();

                $("#div_listado_controles").slideDown();
            });
            //Mostrar listado controles
            $("#btnOcultarControles").click(function () {
                $("#btnOcultarControles").hide();
                $("#btnMostrarControles").show();

                $("#div_listado_controles").slideUp();
            });

            //Si hay controles desplegamos el listado
            if ($("a.pcuh-controles-inner").length > 0) {
                $("#btnMostrarControles").trigger("click");
            }
            /*Mostramos en grupos de 2 - Si hay mas de 2 inicializamos slider*/
            if ($("a.pcuh-controles-inner").length > 2) {
                $('#pcuh-listado-controles').slick({
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

        });
    </script>
{/literal}