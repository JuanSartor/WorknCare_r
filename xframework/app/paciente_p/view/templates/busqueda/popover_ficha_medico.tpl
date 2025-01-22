<div id="popover-ficha-medico" class="gpopover popover-ficha-medico">
    <button class="close-popover pull-right" title='{"cerrar"|x_translate}'><i class="fa fa-times"></i></button>  
    <div class="text-center popover-header">
        <i class="icon-doctorplus-ficha-tecnica"></i>
    </div>
    <div class="row-popover">
        <p><small>{"Puede visualizar toda la ficha de información del profesional haciendo click sobre su fotografia."|x_translate}</small></p>
    </div>
</div>
{literal}
    <script>
        $(function () {
            if (localStorage.getItem('popover-ficha-medico-hide') !== '1') {

                $("#busqueda_resultado .gnlist-usr-avatar:first").addClass("selected");
                $('#busqueda_resultado .proximo-turno-disponible-holder:first span').data("popover", "popover-ficha-medico");
                $('#busqueda_resultado .proximo-turno-disponible-holder:first span').gpopover({
                    preventHide: true, width: '300px'
                }).trigger("click");
            }
            $("#popover-ficha-medico .close-popover").click(function () {
                $("#popover-ficha-medico").slideUp();
                $("#popover-ficha-medico").remove();
                localStorage.setItem('popover-ficha-medico-hide', '1');
                $("#busqueda_resultado .gnlist-usr-avatar.selected").removeClass("selected");
            });
        });
    </script>
{/literal}