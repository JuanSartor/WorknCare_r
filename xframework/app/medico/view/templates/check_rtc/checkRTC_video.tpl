<video autoplay="true" id="videoElement" webkit-playsinline="true" playsinline="true">
</video>
{literal}
    <script>
        $(function () {
            /*Obtenemos el video*/
            var now = Date.now();
            var video = document.querySelector("#videoElement");
            if (navigator.mediaDevices.getUserMedia) {
                navigator.mediaDevices.getUserMedia({video: true})
                        .then(function (stream) {
                            testCamFinished = true;
                            testCam = true;
                            //mostramos el contenedor
                            $("#isWebsiteHasWebcamPermissions .media").show();
                            $("#isWebsiteHasWebcamPermissions .running-test").hide();
                            $("#isWebsiteHasWebcamPermissions .resultOK").fadeIn();
                            //isWebsiteHasWebcamPermissions = true;
                            video.srcObject = stream;
                            show_results();
                        })
                        .catch(function (error) {
                            testCamFinished = true;
                            testCam = false;
                            console.log("El sitio web no tiene permiso de acceder a la camara web.", error);
                            //alert('El sitio web no tiene permiso de acceder a la camara web.');
                            $("#isWebsiteHasWebcamPermissions .running-test").hide();
                            $("#isWebsiteHasWebcamPermissions .resultOK").hide();
                            $("#isWebsiteHasWebcamPermissions .resultKO").fadeIn();
                            $("#isWebsitePermissions_error").show();
                            //show test results
                            show_results();
                        });
            } else {
                testCamFinished = true;
                testCam = false;
                console.log('El sitio web no tiene permiso de acceder a la camara web.');
                $("#isWebsiteHasWebcamPermissions .running-test").hide();
                $("#isWebsiteHasWebcamPermissions .resultOK").hide();
                $("#isWebsiteHasWebcamPermissions .resultKO").fadeIn();
                $("#isWebsitePermissions_error").show();
                //show test results
                show_results();
            }
        });
    </script>
{/literal}