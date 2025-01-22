<canvas id="meter" width="100" height="20"></canvas>

{literal}
    <script>

        var audioContext = null;
        var meter = null;
        var canvasContext = null;
        var WIDTH = 100;
        var HEIGHT = 20;
        var rafID = null;
        // grab our canvas
        canvasContext = document.getElementById("meter").getContext("2d");
        // monkeypatch Web Audio
        window.AudioContext = window.AudioContext || window.webkitAudioContext;
        // grab an audio context
        audioContext = new AudioContext();
        // Attempt to get audio input
        try {
            // monkeypatch getUserMedia
            navigator.getUserMedia =
                    navigator.getUserMedia ||
                    navigator.webkitGetUserMedia ||
                    navigator.mozGetUserMedia ||
                    navigator.mediaDevices.getUserMedia;
            // ask for an audio input
            navigator.getUserMedia(
                    {
                        "audio": {
                            "mandatory": {
                                "googEchoCancellation": "false",
                                "googAutoGainControl": "false",
                                "googNoiseSuppression": "false",
                                "googHighpassFilter": "false"
                            },
                            "optional": []
                           }
                    }, onMicrophoneGranted, onMicrophoneDenied);
        } catch (e) {
            testMicFinished = true;
            testMic = false;
            console.log("El sitio web no tiene permiso de acceder al micrófono", e);
            $("#isWebsiteHasMicrophonePermissions .running-test").hide();
            $("#isWebsiteHasMicrophonePermissions .resultOK").hide();
            $("#isWebsiteHasMicrophonePermissions .resultKO").fadeIn();
            $("#isWebsitePermissions_error").show();
            //show test results
            show_results();
        }


        function onMicrophoneDenied() {
            testMicFinished = true;
            testMic = false;
            console.log("El sitio web no tiene permiso de acceder al micrófono.");
            $("#isWebsiteHasMicrophonePermissions .running-test").hide();
            $("#isWebsiteHasMicrophonePermissions .resultOK").hide();
            $("#isWebsiteHasMicrophonePermissions .resultKO").fadeIn();
            $("#isWebsitePermissions_error").show();
            //show test results
            show_results();
        }

        var mediaStreamSource = null;
        function onMicrophoneGranted(stream) {
            testMicFinished = true;
            testMic = true;
            //mostramos el contenedor
            $("#isWebsiteHasMicrophonePermissions .media").show();
            $("#isWebsiteHasMicrophonePermissions .running-test").hide();
            $("#isWebsiteHasMicrophonePermissions .resultOK").fadeIn();


            // Create an AudioNode from the stream.
            mediaStreamSource = audioContext.createMediaStreamSource(stream);
            // Create a new volume meter and connect it.
            meter = createAudioMeter(audioContext);
            mediaStreamSource.connect(meter);
            // kick off the visual updating
            onLevelChange();
            //show test results
            show_results();
        }

        function onLevelChange(time) {
            // clear the background
            canvasContext.clearRect(0, 0, WIDTH, HEIGHT);
            // check if we're currently clipping
            if (meter.checkClipping())
                canvasContext.fillStyle = "red";
            else
                canvasContext.fillStyle = "green";

            // draw a bar based on the current volume
            canvasContext.fillRect(0, 0, meter.volume * WIDTH * 10, HEIGHT);
            // set up the next visual callback
            rafID = window.requestAnimationFrame(onLevelChange);
        }

    </script>
{/literal}