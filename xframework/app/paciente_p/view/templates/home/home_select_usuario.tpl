<style>
    #Main {
        min-height: 100%;
        display: flex;
        align-items: center;
    }
</style>
<section class="selector-usr-section okm-container selector-usuario-section">
    <div class="row">
        <div class="col-sm-12">
            <h1>{"Seleccione el beneficiario:"|x_translate}</h1>
        </div>
    </div>
    <div class="selector-usuarios-container">
        {*
        {if $header_info.all_members|@count>1}
        <a href="javascript:;" class="slide-arrow go-left" >
        <i class="icon-doctorplus-left-arrow"></i>
        </a>
        {/if}*}
        <div class="selector-usr selector-usuario">
            <div class="slider  selector-usr-slide selector-usuario-list">
                {foreach from=$header_info.all_members item=miembro} 


                    <a href="javascript:;" {if $miembro.titular==1}id="usuario_self"{else}id="usuario_{$miembro.idpaciente}"{/if} class="seleccionar_usuario selector-urs-circle picture" {if $miembro.email!=""}data-requerimiento="self"{else}data-requerimiento="{$miembro.idpaciente}"{/if} data-id="{$miembro.idpaciente}" title="{$miembro.nombre} {$miembro.apellido}">
                        <figure>
                            {if $miembro.image.usuario != ""}
                                <img src="{$miembro.image.usuario}" alt="{$miembro.nombre}" title="{$miembro.nombre} {$miembro.apellido}"/>
                            {else}
                                {if $miembro.animal=="1"}
                                    <img src="{$IMGS}extranet/noimage-animal.jpg" alt="{$miembro.nombre_corto}" title="{$miembro.nombre} {$miembro.apellido}"/>
                                {else}
                                    <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$miembro.nombre_corto}" title="{$miembro.nombre} {$miembro.apellido}"/>
                                {/if}
                                <small class="nombre-corto">{$miembro.nombre_corto}</small>
                            {/if}
                            {if $miembro.info_extra.cant_total>0}<span class="notificacion">{$miembro.info_extra.cant_total}</span>{/if}
                        </figure>

                        <span class="nombre">{$miembro.nombre}</span>
                    </a>
                {/foreach}

            </div>

        </div>
        {*
        {if $header_info.all_members|@count>1}
        <a href="javascript:;" class="slide-arrow go-right">
        <i class="icon-doctorplus-right-arrow"></i>
        </a>
        {/if}*}


    </div>
    <div class="row">
        <div class="col-xs-12 add-user-container">
            <div class="pul-card-new-user">
                <a class="icon alta_miembro" href="{$url}panel-paciente/alta-miembro-grupo-familiar/" >
                    <figure>
                        <i class="icon-doctorplus-user-add-circle"></i>								
                    </figure>
                    <h3>{"Crear nuevo miembro"|x_translate}</h3>
                </a>

            </div>
            <div class="pul-card-new-user">
                <a class="icon alta_miembro mascota" href="{$url}panel-paciente/alta-mascota-grupo-familiar/" >
                    <figure>
                        <i class="fas fa-dog"></i>								
                    </figure>
                    <h3>{"Agregar animal"|x_translate}</h3>
                </a>

            </div>
        </div>
    </div>
</section>	


{literal}
    <script>
        $(function () {

            $(".seleccionar_usuario").click(function () {

                var id = $(this).data("id");
                var requerimiento = $(this).data("requerimiento");
                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'panel-paciente/change_member.do',
                        "from_home=1&id=" + id + "&requerimiento=" + requerimiento,
                        function (data) {
                            if (data.result) {
                                window.location.href = BASE_PATH + "panel-paciente/home.html";
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );

            });
            let count_members = $(".seleccionar_usuario").length;

            if (count_members > 2) {
                let showSlidesCant = count_members > 3 ? 3 : count_members;
                console.log("count_members:" + count_members);
                /*Inicializar slider usuarios*/
                $('.selector-usuario-list').slick({
                    infinite: true,
                    dragable: true,
                    slidesToShow: showSlidesCant,
                    slidesToScroll: 1,
                    //nextArrow: '.go-right',
                    //prevArrow: '.go-left',
                    responsive: [
                        {
                            breakpoint: 600,
                            settings: {slidesToShow: 2, slidesToScroll: 1}
                        },
                        {
                            breakpoint: 310,
                            settings: {slidesToShow: 1, slidesToScroll: 1}
                        }
                    ]
                });
            }

            //los no seleccionados estan inactivos
            //$(".seleccionar_usuario").not($("#usuario_" + $("#filtro").val())).addClass("inactive");
            //el seleccionado esta primero
            // $(".a_miembro#usuario_" + $("#filtro").val()).prependTo($(".a_miembro#usuario_" + $("#filtro").val()).parent())
            //$("#usuario_" + $("#filtro").val() + " span.notificacion").remove();
            //$("#usuario_" + $("#filtro").val()).addClass("miembro_seleccionado");

        });
    </script>

{/literal}
