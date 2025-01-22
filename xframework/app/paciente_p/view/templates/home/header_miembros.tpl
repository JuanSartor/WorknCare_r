
{if $paciente.cobertura_facturacion_step==4 || $paciente.email==""}
<style>

</style>
<input type="hidden" id="filtro" value="{$header_info.filter_selected}" />
<section class="selector-usr-section" {if $header_info.all_members|@count===1 || ($smarty.request.submodulo!="home" && $smarty.request.submodulo!="home_new" &&$smarty.request.submodulo!="guia_uso")}style="display:none;" {/if}>
         <div class="okm-row selector-usr-menu-row">
        <div class="selector-usr-menu-box">
            <a href="javascript:;" class="selector-usr-slide-arrow left"><i class="icon-doctorplus-left-arrow"></i></a>
            <div class="selector-usr">
                <div class="selector-usr-fix-panel">
                    <a href="{$url}panel-paciente/guia-de-uso/"class="selector-urs-circle float {*}rsp-hidden*}">
                        <figure><i class="icon-doctorplus-manual"></i></figure>
                        <span>{"Guía de uso"|x_translate}</span>
                    </a>
                    {*<a href="javascript:;" class="selector-urs-circle float a_change_member" data-requerimiento="alta_miembro">
                        <figure><i class="icon-doctorplus-user-add-circle"></i></figure>
                        <span>{"Agregar paciente"|x_translate} </span>
                    </a>*}
                    <div class="selector-usr-fix-panel-divider"></div>
                </div>
                <div class="selector-usr-slide-panel">
                    <div class="selector-usr-slide">
                        {foreach from=$header_info.all_members item=miembro} 
                        
                        
                        <a href="javascript:;" {if $miembro.email!=""}id="label_self"{else}id="label_{$miembro.idpaciente}"{/if} class="a_miembro a_change_member selector-urs-circle picture" {if $miembro.email!=""}data-requerimiento="self"{else}data-requerimiento="{$miembro.idpaciente}"{/if} data-id="{$miembro.idpaciente}" title="{$miembro.nombre} {$miembro.apellido}">
                           <figure>
                                {if $miembro.image.perfil != ""}
                                <img src="{$miembro.image.perfil}" alt="{$miembro.nombre}" title="{$miembro.nombre} {$miembro.apellido}"/>
                                {else}
                                <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$miembro.nombre_corto}" title="{$miembro.nombre} {$miembro.apellido}"/>
                                {/if}
                            </figure>
                            {if $miembro.info_extra.cant_total>0}<span class="notificacion">{$miembro.info_extra.cant_total}</span>{/if}
                            <span>{$miembro.nombre}</span>
                            {if $miembro.info_extra.is_permitido==1}
                            <small class="subcircle"><i class="icon-doctorplus-check-thin"></i></small>
                            {else}
                            <small class="subcircle alert"><i class="icon-doctorplus-minus"></i></small>
                            {/if}
                        </a>
                        
                        
                        {/foreach}
                        {if $header_info.all_members|@count>1}
                        <a href="javascript:;"  data-requerimiento="all" class="selector-urs-circle a_change_member">
                            <figure><i class="icon-doctorplus-usr-group"></i></figure>
                            <span>{"Miembros"|x_translate}</span>
                        </a>
                        {/if}
                        
                        
                    </div>
                </div>
            </div>
            <a href="javascript:;" class="selector-usr-slide-arrow right"><i class="icon-doctorplus-right-arrow"></i></a>
            
        </div>
    </div>
    
</section>	


{literal}
<script>
    $(function(){
        
        $(".a_change_member").click(function() {
            var requerimiento = $(this).data("requerimiento");
            var id = $(this).data("id");

            if (requerimiento != "alta_miembro") {
                x_doAjaxCall(
                        'POST',
                BASE_PATH + 'panel-paciente/change_member.do',
                "requerimiento=" + requerimiento + "&id=" + id,
                function(data) {
                    if (data.result) {
                        if (requerimiento != "all") {
                            window.location.href = BASE_PATH + "panel-paciente/home.html";
                        } else {
                            window.location.href = BASE_PATH + "panel-paciente/miembros/";
                        }
                    } else {
                        x_alert(data.msg);
                    }
                }
                        );
            } else {
             
                x_doAjaxCall(
                        'POST',
                BASE_PATH + 'panel-paciente/count_members.do',
                "",
                function(data) {
                    if (data.result) {
                        window.location.href = BASE_PATH + "panel-paciente/alta-miembro-grupo-familiar/";
                    } else {
                        x_alert(data.msg);
                    }
                }
                        );
               
            }
        });
        //los no seleccionados estan inactivos
        $(".a_miembro").not($("#label_" + $("#filtro").val())).addClass("inactive");
        //el seleccionado esta primero
       // $(".a_miembro#label_" + $("#filtro").val()).prependTo($(".a_miembro#label_" + $("#filtro").val()).parent())
        $("#label_" + $("#filtro").val()+" span.notificacion").remove();
         $("#label_" + $("#filtro").val()).addClass("miembro_seleccionado");
        if($('.selector-usr-section').length > 0){
		
            var cantMembers = $('.selector-usr-slide').find('a').length;

            if(cantMembers > 3){
                cantMembers = 3;
            }

            $('.selector-usr-slide').slick({
                centerMode: false,
                dots: false,
                draggable: true,
                focusOnSelect: false,
                infinite:false,
                nextArrow: '.selector-usr-slide-arrow.right',
                prevArrow: '.selector-usr-slide-arrow.left',
                slidesToScroll: cantMembers,
                slidesToShow: cantMembers,
                responsive: [
                    {
                        breakpoint: 640,
                        settings: { slidesToShow: cantMembers,  slidesToScroll: 2,}
                    },
                    {
                        breakpoint: 600,
                        settings: { slidesToShow: cantMembers,  slidesToScroll: 1,}
                    },
                    {
                        breakpoint: 420,
                        settings: {
                            slidesToShow: 3,
                            slidesToScroll: 1,
                            variableWidth: true,
                            centerMode: false,
                            infinite:false,
                            initialSlide: 0
                        }
                    }
                ]
            });
        }
        
        
    })
</script>

{/literal}
{/if}