
<script src="{$url}xframework/core/libs/libs_js/DetectRTC/DetectRTC.min.js"></script>
<div class="top-verde-centrado">
    <h1><i class="fa fa-check-circle-o"></i> {"Chequeo de compatibilidad para Video Consultas"|x_translate}</h1>
</div>

<section class="pul-datos-paciente container">

    <div class="row">
        <div class="col-xs-12">
    
            <ul class="checkRTC">
                <li id="isWebRTCSupported" class="">
                    <h5>{"Soporte para RTC en su explorador"|x_translate}
                        <span class="icon-ok"><i class="fa fa-check"></i> {"correcto"|x_translate}</span>
                        <span class="icon-ko"><i class="fa fa-remove"></i> {"incorrecto"|x_translate}</span>
                    </h5>
                    <p>{"Su explorador está desactualizado o no es compatible con la tecnología WebRTC requerida para inicial la consulta. Recomentamos que utilice Chrome, Firefox, Opera o Safari en sus últimas versiones. Si está utilizando MAC asegúrese de tener el sistema operativo actualizado"|x_translate}</p>
                </li>
                <li id="hasWebcam" class="">
                    <h5>{"Su dispositivo posee cámara"|x_translate}
                    <span class="icon-ok"><i class="fa fa-check"></i> {"correcto"|x_translate}</span>
                    <span class="icon-ko"><i class="fa fa-remove"></i> {"incorrecto"|x_translate}</span>
                    </h5>
                    
                    <p>{"No hemos detectado que su dispositivo posea cámara. Es necesario para que su médico pueda verlo en el momento de la consulta. Asegúrese de tener una cámara instalada o correctamente configurada en su explorador."|x_translate}</p>
                </li>
                <li id="hasMicrophone" class="">
                    <h5>{"Su dispositivo posee micrófono"|x_translate}
                    <span class="icon-ok"><i class="fa fa-check"></i> {"correcto"|x_translate}</span>
                    <span class="icon-ko"><i class="fa fa-remove"></i> {"incorrecto"|x_translate}</span>
                    </h5>
                    <p>{"No hemos detectado que su dispositivo posea micrófono. Es necesario para que su médico pueda escucharlo en el momento de la consulta. Asegúrese de tener un micrófono instalada o correctamente configurado en su explorador."|x_translate}</p>
                </li>
                <li id="hasSpeakers" class="">
                    <h5>{"Su dispositivo puede reproducir sonido"|x_translate}
                    <span class="icon-ok"><i class="fa fa-check"></i> {"correcto"|x_translate}</span>
                    <span class="icon-ko"><i class="fa fa-remove"></i> {"incorrecto"|x_translate}</span>
                    </h5>
                    <p>{"No hemos detectado que su dispositivo posea parlantes. Es necesario para que pueda oir a su médico durante la consulta.  Asegúrese de tener parlantes o auriculares correctamente configuradas en su explorador."|x_translate}</p>
                </li>
                <li id="isWebsiteHasWebcamPermissions" class="">
                    <h5>{"Permisos para que DoctorPlus utilice su cámara"|x_translate}
                    <span class="icon-ok"><i class="fa fa-check"></i> {"correcto"|x_translate}</span>
                    <span class="icon-ko"><i class="fa fa-remove"></i> {"incorrecto"|x_translate}</span>
                    </h5>
                    <p>{"En la configuración de su sitio web no se han otorgado permisos al sitio web www.doctorplus.com.ar para utilizar el recurso Cámara. Por favor asegurese de tener habilitado dichos permisos."|x_translate}</p>
                </li>
                <li id="isWebsiteHasMicrophonePermissions" class="">
                    <h5>{"Permisos para que DoctorPlus utilice su micrófono"|x_translate}
                    <span class="icon-ok"><i class="fa fa-check"></i> {"correcto"|x_translate}</span>
                    <span class="icon-ko"><i class="fa fa-remove"></i> {"incorrecto"|x_translate}</span>
                    </h5>
                                <p>{"En la configuración de su sitio web no se han otorgado permisos al sitio web www.doctorplus.com.ar para utilizar el recurso Micrófono. Por favor asegurese de tener habilitado dichos permisos."|x_translate}</p>
                </li>                    
            </ul>
        
        </div>
    </div>
    
</section>

{literal}
<script>
    $(document).ready(function () {
    
navigator.mediaDevices.getUserMedia({audio: true, video: true }).then(function(stream) {
                var temp = document.createElement('video');
                temp.srcObject = stream;
                temp.volume = 0;
                temp.play();        
                DetectRTC.load(function() {

                    //alert("DetectRTC.isWebRTCSupported: " + DetectRTC.isWebRTCSupported);

                    if (DetectRTC.isWebRTCSupported === false) {
                        //alert('WebRTC No está soportado por el explorador');
                        $("#isWebRTCSupported").addClass("ko");
                    }  else {
                        $("#isWebRTCSupported").addClass("ok");
                        
                    }

                    //alert(DetectRTC.hasWebcam);
                    if ("DetectRTC.hasWebcam: " + DetectRTC.hasWebcam === false) {
                        //alert('No se ha detectado webcam.');
                        $("#hasWebcam").addClass("ko");
                    }  else {
                        $("#hasWebcam").addClass("ok");
                        
                    }
                    
                    //alert("DetectRTC.hasMicrophone: " + DetectRTC.hasMicrophone);
                    if (DetectRTC.hasMicrophone === false) {
                      //  alert('NO se ha detectado micrófono.');
                        $("#hasMicrophone").addClass("ko");
                    }  else {
                        $("#hasMicrophone").addClass("ok");
                        
                    }
                    
                    //alert("DetectRTC.hasSpeakers: " + DetectRTC.hasSpeakers);
                    if (DetectRTC.hasSpeakers === false && (DetectRTC.browser.name === 'Chrome' || DetectRTC.browser.name === 'Edge')) {
                      //  alert('No se han detecatado speakers para reproducir audio de la VideoConsulta.');
                        $("#hasSpeakers").addClass("ko");
                    }  else {
                        $("#hasSpeakers").addClass("ok");
                        
                    }
                    
        
                    var isWebsiteHasWebcamPermissions = DetectRTC.isWebsiteHasWebcamPermissions;
                      //alert("DetectRTC.isWebsiteHasWebcamPermissions: " + isWebsiteHasWebcamPermissions);
                     if (isWebsiteHasWebcamPermissions === false) {
                        //alert('El sitio web no tiene permiso de acceder a la camara web.');
                        $("#isWebsiteHasWebcamPermissions").addClass("ko");
                        
                        console.log("isWebsiteHasWebcamPermissions false");
                    }  else {
                        $("#isWebsiteHasWebcamPermissions").addClass("ok");
                        console.log("isWebsiteHasWebcamPermissions true");
                        
                    }

                    var isWebsiteHasMicrophonePermissions = DetectRTC.isWebsiteHasMicrophonePermissions;
                        //alert("DetectRTC.isWebsiteHasMicrophonePermissions " + isWebsiteHasMicrophonePermissions);
                     if (isWebsiteHasMicrophonePermissions == false) {
                      //  alert('El sitio web no tiene permiso de acceder a la camara web.');
                        $("#isWebsiteHasMicrophonePermissions").addClass("ko");
                        console.log("isWebsiteHasMicrophonePermissions false");
                    }  else {
                        $("#isWebsiteHasMicrophonePermissions").addClass("ok");
                        console.log("isWebsiteHasMicrophonePermissions true");
                        
                    }

                    $(".checkRTC").show();

                });
            });
});




    
</script>
{/literal}    

{x_load_js}


