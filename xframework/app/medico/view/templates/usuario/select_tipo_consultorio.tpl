<div id="container_modal">
    <div class="modal-add-branch" id="select_tipo_consultorio">
        <div class="add-branch">

            <h2>{"Agregar Consultorio"|x_translate}</h2>
            <p>&nbsp;</p>
            <div class="clearfix"></div>
            <div class="col-xs-6 text-center">
                <a href="javascript:;" id="btnConsultorioFisico"><br />{"Consultorio Físico"|x_translate}</a>
            </div>
            <div class="col-xs-6 text-center">
                <a href="javascript:;" id="btnConsultorioVirtual"><br />{"Consultorio Virtual"|x_translate}</a>
            </div>
            <p>&nbsp;</p>
            <div class="col-xs-12">
                <p class="text-center">
                    {"Ud. podrá crear un Consultorio Virtual con días y horarios definidos en donde podrá atender a sus pacientes a distancia a través del servicio de Video Consulta"|x_translate}
                </p>
            </div>
            <form class="form" id="frmRegistroConsultorio" role="form" action="{$url}consultorio-virtual-medico.do" method="post" onsubmit="return false" >
                
            </form>


            <div class="clearfix"></div>
        </div>
    </div>
    {literal}
    <script language="javascript">

        $(document).ready(function() {

            renderUI2("select_tipo_consultorio");

            $("#btnConsultorioVirtual").click(function() {
                x_sendForm($('#frmRegistroConsultorio'), true, function(data) {
                    
                    if (data.result) {
                        $("#winModal").modal('hide');
                        x_alert(data.msg,recargar);
                    }else{
                        x_alert(data.msg);
                    }
                });
            });

            $("#btnConsultorioFisico").click(function() {
                x_loadModule('usuario', 'consultorio_form', '', 'container_modal');
            });
        });
    </script>
    {/literal}
</div>
