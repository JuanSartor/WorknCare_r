
<style>
  .mul-mis-servicios {
    padding-bottom: 0px;
}
.form.edit h2 {
    margin-top: 10px;
    margin-bottom: 10px;
}
</style>
<!--configuracion section	-->

<div class="mul-configuracion-box">
    <section class="okm-container mul-mis-servicios">
        <h2>{"Mis servicios"|x_translate}</h2>
        <h3>{"¿A quién desea ofrecer sus servicios?"|x_translate}</h3>

        <div class="mul-card-row">
            <div class="mul-mis-servicios-card-col">
                <div class="mul-mis-servicios-card">
                    <h4>{"Consulta Express"|x_translate}</h4>
                    <figure>
                        <i class="icon-doctorplus-chat"></i>
                    </figure>
                    <form id="pacientesConsultaExpress" name="mul-consulta-express-card">
                        <label class="radio radio-profesional-alert" >
                            {"Solo a mis pacientes"|x_translate}
                            <input type="radio"  {if $medico.planProfesional == 0}disabled data-tooltip_profesional="1"{/if} {if $preferencia.pacientesConsultaExpress=="2"}checked{/if} name="pacientesConsultaExpress" value="2"/>
                        </label>
                        <label class="radio ">
                            {"Todos los pacientes registrados"|x_translate}
                            <input type="radio" {if $preferencia.pacientesConsultaExpress=="1"}checked{/if} name="pacientesConsultaExpress" value="1"/>
                        </label>
                    </form>
                </div>
            </div>

            <div class="mul-mis-servicios-card-col">
                <div class="mul-mis-servicios-card">
                    <h4>{"Video Consulta"|x_translate}</h4>
                    <figure>
                        <i class="icon-doctorplus-video-call"></i>
                    </figure>
                    <form id="pacientesVideoConsulta" name="mul-video-express-card">
                        <label class="radio radio-profesional-alert">
                            {"Solo a mis pacientes"|x_translate}
                            <input type="radio" {if $medico.planProfesional == 0}disabled data-tooltip_profesional="1"{/if} {if $preferencia.pacientesVideoConsulta=="2"}checked{/if} name="pacientesVideoConsulta" value="2"/>
                        </label>
                        <label class="radio">
                            {"Todos los pacientes registrados"|x_translate}
                            <input type="radio" {if $preferencia.pacientesVideoConsulta=="1"}checked{/if} name="pacientesVideoConsulta" value="1"/>
                        </label>
                    </form>
                </div>
            </div>
        </div>

        <div class="okm-row">
            <p class="mul-mis-servicios-disclaimer">{"Ofrecer sus servicios a todos los pacientes registrados en DoctorPlus le dará la posibilidad de que lo contacten y recomienden pacientes nuevos"|x_translate}</p>
        </div>


    </section>							

    <section class="notification-settings form edit white">
        <div class="container">
            <div class="okm-row">
                <h2 class="text-center">{"Notificaciones"|x_translate}</h2>
            </div>	

            <div class="okm-row">	
                <div class="col-md-10 col-md-offset-1 mul-notificaciones">
                    <p>{"¿Por qué canal desea recibir notificaciones del sistema?"|x_translate}<br>{"Por ej. cancelaciones de turnos de sus pacientes, mensajes de otros profesionales, etc"|x_translate}</p>
                    <div class="mul-nosificaciones-list">
                        <label class="checkbox ib" for="sms">
                            <input type="checkbox" id="sms" checked="checked" value="1"  data-toggle="checkbox" disabled="" class="custom-checkbox">
                            
                                   SMS
                        </label>
                       
                        <label class="checkbox ib" for="email">
                            <input type="checkbox" id="email" {if $preferencia.recibirNotificacionSistemaEmail=="1"}checked{/if} data-toggle="checkbox" class="custom-checkbox">
                                   E-mail
                        </label>

                    </div>
                </div>
            </div>


        </div>
    </section>
</div>





{literal}
<script>
    $(document).ready(function () {
     
        $(':radio, :checkbox').radiocheck();
        
    

//metodos al chequear las opciones de notificacion por sms o email
        $("#email").on('change.radiocheck', function () {
            
 
            if ($("#email").is(':checked')) {
                var email = 1;
            } else {
                var email = 0;
            }
             var sms = 1;
            $("body").spin("large");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'registrar_preferencia_notificacion.do',
                    'email=' + email + "&sms=" + sms,
                    function (data) {
                        $("body").spin(false);
                        x_alert(data.msg);

                    });

        });
        //metodos al chequear las opciones de configuracion de servicio de consulta express
        $("#pacientesConsultaExpress :radio").on('change.radiocheck', function () {

            var val = $("#pacientesConsultaExpress :radio:checked").val();
            if (val == "1" || val == "2") {
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'registrar_preferencia_servicios.do',
                        'pacientesConsultaExpress=' + val,
                        function (data) {
                            x_alert(data.msg);
                        });
            }
        });
        //metodos al chequear las opciones de configuracion de servicio de video consulta
        $("#pacientesVideoConsulta :radio").on('change.radiocheck', function () {

            var val = $("#pacientesVideoConsulta :radio:checked").val();
            if (val == "1" || val == "2") {
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'registrar_preferencia_servicios.do',
                        'pacientesVideoConsulta=' + val,
                        function (data) {

                            x_alert(data.msg);

                        });
            }
        });
    //alerta opcion "Solo mis paciente" para cuentas profesionales
     $(".radio-profesional-alert").click(function(){
         if($(this).find("input:radio:disabled").length>0){
              x_alert(x_translate("Necesita suscribir a un abono profesional para personalizar el uso de su cuenta"));
         }
                
             });



    });
</script>
{/literal}
