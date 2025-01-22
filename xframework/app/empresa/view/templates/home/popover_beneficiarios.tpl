<div id="popover-beneficiarios" class="gpopover popover-beneficiarios">
    <button class="close-popover pull-right" title='{"cerrar"|x_translate}'><i class="fa fa-times"></i></button>  
    <div class="text-center popover-header">
        <i class="fa fa-info-circle"></i>
    </div>
    <div class="row-popover">
        <button  class=" btn btn-xs btn-default" >
            <i class="fa fa-check"></i>
            {"Activar"|x_translate}
        </button>
        <label>{"Active los beneficiarios para que empiecen a utilizar los beneficios del WorknCare. Se le facturará por cada beneficiario registrado activado al final de cada mes"|x_translate}</label>
    </div>
    <div class="row-popover">
        <button class=" btn btn-xs btn-yellow"  >
            <i class="fa fa-pause"></i>
            {"Suspender"|x_translate}
        </button>
        <label>{"Suspenda el acceso del beneficiario a la cuenta. Seguirá en su lista de beneficiarios registrado y podrá volver a activarlo luego. Se le facturará por cada beneficiario que ya ha activado aunque suspenda su acceso"|x_translate}</label>
    </div>
    <div class="row-popover">
        <button  class=" btn btn-xs btn-alert" >
            <i class="fa fa-trash-o"></i>
            {"Eliminar"|x_translate}
        </button>
        <label>{"Puede eliminar un beneficiario del listado si esté aún no ha comenzado a utilizar las consultas disponibles en su WorknCare"|x_translate}</label>
    </div>
</div>
{literal}
    <script>
        $(function () {
            if (localStorage.getItem('popover-beneficiarios-hide') !== '1') {


                $('.listado-beneficiarios tbody tr:first td').data("popover", "popover-beneficiarios");
                $('.listado-beneficiarios tbody tr:first td').gpopover({
                    preventHide: true, width: 'auto'
                }).trigger("click");
            }
            $("#popover-beneficiarios .close-popover").click(function () {
                $("#popover-beneficiarios").slideUp();
                $("#popover-beneficiarios").remove();
                localStorage.setItem('popover-beneficiarios-hide', '1');
            });
        });
    </script>
{/literal}