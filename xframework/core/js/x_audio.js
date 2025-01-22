
/**
 * Método que convierte una cantidad de bytes a lo que se desee
 * @param {type} bytes
 * @returns {String}
 */
function bytesToSize(bytes) {
    var k = 1000;
    var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    if (bytes === 0)
        return '0 Bytes';
    var i = parseInt(Math.floor(Math.log(bytes) / Math.log(k)), 10);
    return (bytes / Math.pow(k, i)).toPrecision(3) + ' ' + sizes[i];
}

function onMediaError(e) {
    console.error('media error', e);
     
}

/**
 * Método que inicializa el user media 
 * @param {type} mediaConstraints
 * @param {type} successCallback
 * @param {type} errorCallback
 * @returns {undefined}
 */
function captureUserMedia(mediaConstraints, successCallback, errorCallback) {
    navigator.mediaDevices.getUserMedia(mediaConstraints).then(successCallback).catch(errorCallback);
}

var mediaConstraints = {
    audio: true
};

