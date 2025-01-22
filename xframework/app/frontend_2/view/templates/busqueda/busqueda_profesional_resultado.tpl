{include file="home/login.tpl"}
<nav class="paciente-nav">
    <div class="container paciente-nav-container">
        <div class="paciente-nav-logo">
            <a href="{$url}" title="DoctorPlus">
                <img src="{$IMGS}/doctorplus_logo_mobile.png" title="DoctorPlus"/>
            </a>
        </div>
        <div class="paciente-nav-menu">
            <a href="javascript:;" id="hom-nav-rsp-trg" class="paciente-nav-menu-burger"><i class="icon-doctorplus-burger"></i></a>
            <ul class="paciente-nav-menu-rsp"  id="hom-nav-rsp-get">
                <li><a href="{$url}creer-un-compte.html" class="uh-top-lnk btn-signup">{"Crear una cuenta"|x_translate}</a></li>
                <li><a href="JavaScript:void(0)" id="loginbtn" class="uh-top-lnk btn-login" data-toggle="modal" data-target=".login">{"Iniciar sesión"|x_translate}</a></li>
            </ul>
        </div>
    </div>
</nav>
<section class="pbn-section-buscador">
    <div class="okm-container">
        <div class="okm-row pbn-background_not">
            <div class="pbn-buscador-col"><h2>{"Buscador de profesionales"|x_translate}</h2></div>
            <div class="pbn-buscador-btn-col">
                <a href="{$url}" class="btn-oil-square pbn-buscador-btn"><span>{"Nueva búsqueda"|x_translate}</span> <i class="icon-doctorplus-search"></i></a>
            </div>
        </div>
    </div>
</section>
<section class="pbn-section-tags-map">
    <div class="okm-container pbn-tags-map">
        <h3>{$especialidad.especialidad}</h3>
        <p>
            {if $tags_inputs|@count > 0}
                {"Sus filtros de búsqueda"|x_translate}
            {else}
                &nbsp;
            {/if}
        </p>
        <div class="okm-row pbn-tags-row">
            <div class="pbn-tags-holder">
                <div class="tagsinput-primary ceprr-tags pbn-tags">
                    {if $tags_inputs|@count > 0}
                        <input name="tagsinput" id="tagsinput" style="display: none"/>
                    {/if}
                </div>
            </div>

        </div>
        {include file="busqueda/busqueda_profesional_mapa.tpl"}
    </div>
</section>




<div id="modulo_listado_consultorios" class="relative">


</div>

{include file="busqueda/como_funciona.tpl" }
<div id="div_estado_cuenta" class="cs-nc-precios-holder"></div>




<script>
    $("#tagsinput").tagsinput({ldelim}itemValue: 'id', itemText: 'text', freeInput: false{rdelim});
    {foreach from = $tags_inputs item = tag}
        $("#tagsinput").tagsinput('add', {ldelim}"id": '{$tag.id}', "text": '{$tag.name}', "clave": '{$tag.tipo}'{rdelim});
    {/foreach}
            $(".bootstrap-tagsinput > input").hide();
            $(".tagsinput-primary span[data-role='remove']").remove();
</script>
<script>

    $(function () {
        $('#hom-nav-rsp-trg').on('click', function (e) {

            $('#hom-nav-rsp-get').toggleClass('menu-show');

        });
    });

    var menuEl = $('#hom-nav-rsp-get').children('li').children('a');

    menuEl.on('click', function (e) {


        if (typeof $(this).data('lnk') !== 'undefined') {
            var lnkTo = "#" + $(this).data('lnk');
            mulScroll($(lnkTo));
        }


        if ($('#hom-nav-rsp-get').hasClass('menu-show')) {
            $('#hom-nav-rsp-get').removeClass('menu-show');
        }

    });

</script>

{x_load_js}
