{if $smarty.request.fromajax!="1"}
    <link rel="stylesheet" href="{$url}xframework/app/themes/dp02/css/checkrtc.css">
{/if}
<div class="top-verde-centrado">
    <h1>
        <i class="fa fa-wrench"></i> {"Chequeo de compatibilidad para Video Consultas"|x_translate}
    </h1>
</div>

<section class="container-fluid testEnvironment" id="testEnvironment">
    <div class="text-center test-in-course">
        <label><em>{"test en curso"|x_translate}</em><span class="recording-label"></span></label>
    </div>
    <div class="test-item-container">
        <div class="testItem" id="isWebsiteHasWebcamPermissions">     
            <div class="test-progress">
                {include file="check_rtc/checkRTC_progress.tpl"}
                <img src="{$url}xframework/app/themes/dp02/imgs/checkrtc/camOk.png">
                <h2>{"Permisos para que DoctorPlus utilice su cámara"|x_translate}</h2>
            </div>
            <div class="media" id="video_container" >

            </div>
        </div>			


        <div class="testItem" id="isWebsiteHasMicrophonePermissions">     
            <div class="test-progress">
                {include file="check_rtc/checkRTC_progress.tpl"}
                <img src="{$url}xframework/app/themes/dp02/imgs/checkrtc/micOk.png">
                <h2>{"Permisos para que DoctorPlus utilice su micrófono"|x_translate}</h2>
            </div>
            <div class="media" id="mic_container">

            </div>
        </div>
        {*
        <div class="testItem" id="isConnectionquality">     
        <div class="test-progress">
        {include file="check_rtc/checkRTC_progress.tpl"}	
        <img src="{$url}xframework/app/themes/dp02/imgs/checkrtc/wifi.png">
        <h2>{"Velocidad de Conexión"|x_translate}</h2>
        </div>
        <div class="media">
        <p class="conexion-status pobre" style="display:none">{"Conexión baja"|x_translate}</p>
        <p class="conexion-status buena" style="display:none">{"Conexión buena"|x_translate}</p>
        </div>
        </div>
        *}
    </div>

</section>

<section id="testResults" class="testResults" style="display:none">
    <div class="container-fluid exito" style="display:none" id="resultOK">
        {include file="check_rtc/checkRTC_result_ok.tpl"}	
    </div>
    <div class="container-fluid errorMessage"  style="display:none"  id="resultKO">
        {include file="check_rtc/checkRTC_result_ko.tpl"}	
    </div>
</section>
<script src="https://cdnjs.cloudflare.com/ajax/libs/webrtc-adapter/6.4.0/adapter.js" type="text/javascript"></script>

{if $smarty.request.fromajax!="1"}
    <script type="text/javascript" src="https://static.opentok.com/v2/js/opentok.min.js"></script>
    <script src="{$url}xframework/files/session_conectividad.js"></script>
    <script src="{$url}xframework/core/libs/libs_js/bundle_test_conectividad_2.js"></script>
{/if}
<script src="{$url}xframework/app/medico/view/templates/check_rtc/volume-meter.js"></script>

{literal}
    <script>
        /*Test Flags*/
        testMic = false;
        testCam = false;
        testMicFinished = false;
        testCamFinished = false;
    </script>
    <!-- AUDIO -->

    <script>
        var initializeMicCapture = function () {
            x_loadModule("check_rtc", "checkRTC_mic", "", "mic_container", BASE_PATH + "medico");
        };
    </script>
    <!-- VIDEO -->
    <script>
        var initializeVideoCapture = function () {
            x_loadModule("check_rtc", "checkRTC_video", "", "video_container", BASE_PATH + "medico");
        };
    </script>
{/literal}

{literal}
    <!-- TEST -->
    <script>

        var browser = function () {
            var test = function (regexp) {
                return regexp.test(window.navigator.userAgent);
            };
            switch (true) {
                case test(/edg/i):
                    return "Microsoft Edge";
                case test(/trident/i):
                    return "Microsoft Internet Explorer";
                case test(/firefox|fxios/i):
                    return "Mozilla Firefox";
                case test(/opr\//i):
                    return "Opera";
                case test(/ucbrowser/i):
                    return "UC Browser";
                case test(/samsungbrowser/i):
                    return "Samsung Browser";
                case test(/chrome|chromium|crios/i):
                    return "Google Chrome";
                case test(/safari/i):
                    return "Apple Safari";
                default:
                    return "Other";
            }
        };

        function mobileAndTabletCheck() {
            let check = false;
            (function (a) {
                if (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino|android|ipad|playbook|silk/i.test(a) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0, 4)))
                    check = true;
            })(navigator.userAgent || navigator.vendor || window.opera);
            return check;
        }

        function iOS() {
            return [
                'iPad Simulator',
                'iPhone Simulator',
                'iPod Simulator',
                'iPad',
                'iPhone',
                'iPod'
            ].includes(navigator.platform)
                    // iPad on iOS 13 detection
                    || (navigator.userAgent.includes("Mac") && "ontouchend" in document);
        }
        function iOS_Safari() {
            return (/(iPad|iPhone|iPod)/gi).test(navigator.userAgent) &&
                    !(/CriOS/).test(navigator.userAgent) &&
                    !(/FxiOS/).test(navigator.userAgent) &&
                    !(/OPiOS/).test(navigator.userAgent) &&
                    !(/mercury/).test(navigator.userAgent);
        }

        function testRTC() {
            console.log("iniciando test...");

            initializeMicCapture();
            initializeVideoCapture();


            /*
             //si luego de un tiempo no se completo el test por problemas lo cancelamos
             var checkRTC_timeout = setTimeout(function () {
             console.log("CheckRTC: Timeout");
             $(".test-in-course").hide();
             $("#isWebsiteHasWebcamPermissions .running-test").hide();
             $("#isWebsiteHasWebcamPermissions .resultKO").fadeIn();
             $("#isWebsiteHasMicrophonePermissions .running-test").hide();
             $("#isWebsiteHasMicrophonePermissions .resultKO").fadeIn();
             $("#isConnectionquality .running-test").hide();
             $("#isConnectionquality .resultKO").fadeIn();
             $("#timeout_error").show();
             $('.testResults').fadeIn();
             $("#resultKO").show();
             }, 120000);
             startTest(tokSession)
             .then(function (DetectRTC) {
             
             console.log("Resultado:");
             console.log(DetectRTC);
             clearTimeout(checkRTC_timeout);
             //initializeVideoCapture();
             //initializeMicCapture();
             var resultado = 0;
             //isWebRTCSupported: true, isWebsiteHasWebcamPermissions: false, isWebsiteHasMicrophonePermissions: true, quality_audio: 4.049152070124364, quality_video: 0}
             
             // $('.testResults').delay(15500).fadeIn(1500);
             
             if (DetectRTC.isWebRTCSupported === false) {
             //alert('WebRTC No está soportado por el explorador');
             $("#isWebRTCSupported_error").show();
             resultado++;
             }
             
             if (DetectRTC.isWebsiteHasWebcamPermissions === false) {
             //alert('El sitio web no tiene permiso de acceder a la camara web.');
             $("#isWebsiteHasWebcamPermissions .running-test").hide();
             $("#isWebsiteHasWebcamPermissions .resultOK").hide();
             $("#isWebsiteHasWebcamPermissions .resultKO").fadeIn();
             $("#isWebsitePermissions_error").show();
             resultado++;
             } else {
             $("#isWebsiteHasWebcamPermissions .running-test").hide();
             $("#isWebsiteHasWebcamPermissions .resultKO").hide();
             $("#isWebsiteHasWebcamPermissions .resultOK").fadeIn();
             }
             
             if (DetectRTC.isWebsiteHasMicrophonePermissions === false) {
             
             //  alert('El sitio web no tiene permiso de acceder a la camara web.');
             $("#isWebsiteHasMicrophonePermissions .running-test").hide();
             $("#isWebsiteHasMicrophonePermissions .resultOK").hide();
             $("#isWebsiteHasMicrophonePermissions .resultKO").fadeIn();
             $("#isWebsitePermissions_error").show();
             resultado++;
             } else {
             $("#isWebsiteHasMicrophonePermissions .running-test").hide();
             $("#isWebsiteHasMicrophonePermissions .resultKO").hide();
             $("#isWebsiteHasMicrophonePermissions .resultOK").fadeIn();
             }
             
             
             // Nuevo check para ver si hay conexion ok (calidad de la conexión)
             
             //Si no se realiza el test de audio o video porque no tiene permisos, marcamos error en la conexion tambien
             // > 3.8 Excelente; > 3.1 Roog; >2.4 Minimun >1.7 POOR
             var hasPermission = true;
             if (!DetectRTC.isWebsiteHasWebcamPermissions || !DetectRTC.isWebsiteHasMicrophonePermissions) {
             console.log("no video/audio permission");
             hasPermission = false;
             } else {
             // > 3.8 Excelente; > 3.1 Roog; >2.4 Minimun >1.7 POOR
             console.log("has video/audio permission");
             var isConnectionquality = true;
             if (DetectRTC.audio.mos < 1.7 || DetectRTC.video.mos < 1.7) {
             isConnectionquality = false;
             }
             
             }
             
             
             //Si no tiene permisos no ejecutamos el test de velocidad
             if (hasPermission === false) {
             console.log("noPermission ");
             //  alert('El sitio web no tiene permiso de acceder a la camara web.');
             $("#isConnectionquality .running-test").hide();
             $("#isConnectionquality .resultKO").fadeIn();
             $("#KO_message").text(x_translate("No se puede acceder a la cámara"));
             } else {
             $("#isConnectionquality .running-test").hide();
             $("#isConnectionquality .resultKO").hide();
             $("#isConnectionquality .resultOK").fadeIn();
             if (isConnectionquality === false) {
             console.log("isConnectionquality low");
             //  alert('El sitio web no tiene permiso de acceder a la camara web.');
             $("#isConnectionquality .resultOK").addClass("regular");
             $("#isConnectionquality .conexion-status.pobre").fadeIn();
             } else {
             $("#isConnectionquality .conexion-status.buena").fadeIn();
             
             }
             }
             
             // Controles según los resultados
             $('.testResults').fadeIn();
             if (resultado > 0) {
             $(".test-in-course").hide();
             $("#resultKO").show();
             localStorage.setItem('hide_checkrtc_modal', 0);
             //$('.testEnvironment').fadeOut(1500);
             } else {
             $(".test-in-course").hide();
             
             $("#resultOK").show();
             localStorage.setItem('hide_checkrtc_modal', 1);
             // $('.testEnvironment').fadeOut(1500);
             
             }
             
             }).catch(function (e) {
             x_alert(e);
             });*/
        }
        var show_results = function () {
            if (testMicFinished && testCamFinished) {
                $(".test-in-course").hide();
                $('.testResults').fadeIn();
                if (testMic === true && testCam === true) {
                    console.log("success");
                    $("#resultOK").show();
                    localStorage.setItem('hide_checkrtc_modal', 1);
                    //$('.testEnvironment').fadeOut(1500);
                } else {
                    console.log("fail");
                    $("#resultKO").show();
                    localStorage.setItem('hide_checkrtc_modal', 0);
                    // $('.testEnvironment').fadeOut(1500);
                }
            }
        };

        $(function () {
            console.log(browser());
            //x_alert("iOS_Safari():" + iOS_Safari() + "-navigator:" + navigator.userAgent.toLowerCase());
            //verificamos si se ingresa en un celular Iphone
            if (iOS()) {
                if (iOS_Safari()) {
                    testRTC();
                } else {
                    //si no se ejecuta Safari en IOS mostramos error de incompatibilidad
                    $(".test-in-course").hide();
                    $("#isWebsiteHasWebcamPermissions .running-test").hide();
                    $("#isWebsiteHasWebcamPermissions .resultKO").fadeIn();
                    $("#isWebsiteHasMicrophonePermissions .running-test").hide();
                    $("#isWebsiteHasMicrophonePermissions .resultKO").fadeIn();
                    $("#isConnectionquality .running-test").hide();
                    $("#isConnectionquality .resultKO").fadeIn();
                    $("#isChromeIOS_error").show();
                    $("#KO_message").text(x_translate("Navegador no compatible"));
                    $('.testResults').fadeIn();
                    $("#resultKO").show();
                }
            } else {
                testRTC();
            }


        });
    </script>
{/literal}    

{x_load_js}


