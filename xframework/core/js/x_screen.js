


var getWinY = function () {
 
    var myWidth = 0, myHeight = 0;
    if (typeof (window.innerWidth) == 'number') {
        //Non-IE
        myWidth = window.innerWidth;
        myHeight = window.innerHeight;
    } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
        //IE 6+ in 'standards compliant mode'
        myWidth = document.documentElement.clientWidth;
        myHeight = document.documentElement.clientHeight;
    } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
        //IE 4 compatible
        myWidth = document.body.clientWidth;
        myHeight = document.body.clientHeight;
    }

    return myHeight;
}
/**	Centra el login Box		
 */
var centerDiv = function (id) {

    if (!!(window.attachEvent && !window.opera)) {
        // IE
        var window_width = document.body.offsetWidth;
        var window_height = getWinY();

    } else {
        var window_width = window.innerWidth;
        var window_height = window.innerHeight;
    }

    //Alto para el content: Alto total  - ancho footer - margen superior
    var margin_top = height_content = parseInt(window_height - $("#" + id).height() / 2);

    // Cargamos entonces los anchos y altos de los elmentos
    // Main Content & Sections
    $(id).css("top", margin_top + 'px');

    $(id).css("left", parseInt(window_width / 2) - parseInt($("#" + id).width() / 2) + 'px');

}





function getScrollBarWidth() {
    var inner = document.createElement('p');
    inner.style.width = "100%";
    inner.style.height = "200px";

    var outer = document.createElement('div');
    outer.style.position = "absolute";
    outer.style.top = "0px";
    outer.style.left = "0px";
    outer.style.visibility = "hidden";
    outer.style.width = "200px";
    outer.style.height = "150px";
    outer.style.overflow = "hidden";
    outer.appendChild(inner);

    document.body.appendChild(outer);
    var w1 = inner.offsetWidth;
    outer.style.overflow = 'scroll';
    var w2 = inner.offsetWidth;
    if (w1 == w2)
        w2 = outer.clientWidth;

    document.body.removeChild(outer);

    return (w1 - w2);
}
;

// Add by seba. Función para trackear todo el tiempo el tamaño de la pantalla
var MAX = 0;
var actual_h = 0;
var actual_w = 0;
var mapa_inicializado = false;
var resize = function () {

    var window_height = getWinY();
    window_height -= 155;
    actual_w = $(window).width();//-getScrollBarWidth();
    actual_h = window_height;

}		