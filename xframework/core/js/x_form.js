
/**
 * Se realiza la actualizaciÃ³n y el control de la carga de los tags inputs
 
 * @param {type} id_load: id de lo que se va a cargar
 * @param {type} id_entity: id de la entidad a la que se le va a asociar el load
 * @param {type} id_tags_input: id del componente de tag input, 
 * @param {type} manager: manager donde se encuentra el metodo
 * @param {type} metodo: metodo que se va a llamar.
 * @param {type} event: informaciÃ³n que contiene el tag input, cuando ocurre un evento.
 * @returns {undefined}
 */
var updateTagInput = function (id_load, id_entity, id_tags_input, manager, metodo, event) {

    var params;
    var remove = false;
    if (event != "") {
        var item = event.item;
        params = 'id_entity=' + $("#" + id_entity).val() + '&id_load=' + item.value +
                '&manager=' + manager + '&metodo=' + metodo;

        //es remove, porque viene el evento!
        remove = true;
    } else {
        params = 'id_entity=' + $("#" + id_entity).val() + '&id_load=' + $("#" + id_load).val() +
                '&manager=' + manager + '&metodo=' + metodo;
    }


    //Me fijo que lo que se va a cargar no sea nulo
    if ($("#" + id_load).val() != "") {
        //Si el id de la entity es vaciÃ³ que no haya llamada a ajax
        if ($("#" + id_entity).val() == "") {
            //Lo agrego al inputcrm_categories_tag_input
            $("#" + id_tags_input + "_tag_input").tagsinput('add', {"value": $("#" + id_load).val(), "text": $("#" + id_load + " option:selected").html()});
        } else {
            x_doAjaxCall({
                url: 'common.php?action=1&modulo=common&submodulo=updateTagInput',
                params: params,
                callback: function (data) {
                    if (data.result) {
                        if (remove == false) {//Si no es remove el evento, que agregue
                            $("#" + id_tags_input + "_tag_input").tagsinput('add', {"value": $("#" + id_load).val(), "text": $("#" + id_load + " option:selected").html()});
                        }
                    }
                }
            });
        }
    }
};

/**
 *
 * Finaliza la actualizacion de los ComboBox aplicando los atributos originales en los nuevos recien generados
 *
 */
var doUpdateComboBoxSelect2 = function (data, idelement) {

    $("#" + idelement + " option").empty().prop("disabled", false);

    if (data.result) {
        $("#" + idelement).html(data.html);
        $("#" + idelement).prop("selectedIndex", 0);
    }

    $("#" + idelement + ":not(.not-select2)").select2({
        minimumResultsForSearch: -1
    });

}

var updateComboBoxSelect2 = function (caller, idelement, manager, metodo, nulo, texto, callback) {

    var id_selected = $(caller).val();

    /*if (nulo > 0) {
     nulo = nulo;
     } else {
     nulo = 0;
     }*/

    // Armamos el string de parametros para la llamada AJAX
    var params = 'action=1&modulo=common&submodulo=getcombo&manager=' + manager + '&method=' + metodo + '&idcaller=' + id_selected + '&nulo=' + nulo + '&';

    if (typeof texto !== "undefined") {
        params += '&texto=' + texto;
    }

    $("#" + idelement + " option").empty().prop("disabled", true);

    var func_callback = doUpdateComboBox;
    if (typeof callback !== "undefined" && callback != "") {
        func_callback = callback;
    }

    // Hacemos la llamada ajax para actualizar el contenido del combo
    x_doAjaxCall('get', "common.php", params, function (data, idelement) {

        $("#" + idelement + " option").empty().prop("disabled", false);
        $("#" + idelement).prop("disabled", false);
        if (data.result) {
            $("#" + idelement).html(data.html);
            $("#" + idelement).prop("selectedIndex", 0);
        }

        $("#" + idelement + ":not(.not-select2)").select2({
            minimumResultsForSearch: -1
        });

    }, idelement, '', true, false);
    //x_doAjaxCall('get', "common.php", params, doUpdateComboBoxFlatUI, idelement, '', true, false);
};

//nulo 1=Todas , 2=Seleccionar	
var updateComboBox = function (caller, idelement, manager, metodo, nulo, texto, callback) {

    var id_selected = $(caller).val();

    /*if (nulo > 0) {
     nulo = nulo;
     } else {
     nulo = 0;
     }*/

    // Armamos el string de parametros para la llamada AJAX
    var params = 'action=1&modulo=common&submodulo=getcombo&manager=' + manager + '&method=' + metodo + '&idcaller=' + id_selected + '&nulo=' + nulo + '&';

    if (typeof texto !== "undefined") {
        params += '&texto=' + texto;
    }

    $("#" + idelement + " option").empty().prop("disabled", true);

    var func_callback = doUpdateComboBox;
    if (typeof callback !== "undefined" && callback != "") {
        func_callback = callback;
    }

    // Hacemos la llamada ajax para actualizar el contenido del combo
    x_doAjaxCall('get', "common.php", params, func_callback, idelement, '', true, false);
    //x_doAjaxCall('get', "common.php", params, doUpdateComboBoxFlatUI, idelement, '', true, false);
}

/**
 * Realiza el Update del combobox, para los componentes del FLAT UI, ya que hay que aplicarles un render una vez modificados los valores
 * del selected option
 * @param {type} caller
 * @param {type} idelement
 * @param {type} manager
 * @param {type} metodo
 * @param {type} nulo
 * @param {type} texto: Texto es el valor que se va a poner como primer alternativa.
 * @returns {undefined}
 */
var updateComboBoxFlatUI = function (caller, idelement, manager, metodo, nulo, texto) {

    var id_selected = $(caller).val();

    /*if (nulo > 0) {
     nulo = nulo;
     } else {
     nulo = 0;
     }*/

    // Armamos el string de parametros para la llamada AJAX
    var params = 'action=1&modulo=common&submodulo=getcombo&manager=' + manager + '&method=' + metodo + '&idcaller=' + id_selected + '&nulo=' + nulo;
    if (texto != "") {
        params += '&texto=' + texto;
    }


    $("#" + idelement + " option").empty().prop("disabled", true);


    // Hacemos la llamada ajax para actualizar el contenido del combo
    //Esta actualización de contenido es diferente, ya que hay que aplicarle el render al componente.
    x_doAjaxCall('get', "common.php", params, doUpdateComboBoxFlatUI, idelement, '', true, false);
}

/**
 *
 * Finaliza la actualizacion de los ComboBox aplicando los atributos originales en los nuevos recien generados
 *
 */
var doUpdateComboBox = function (data, idelement) {

    $("#" + idelement + " option").empty().prop("disabled", false);

    if (data.result) {
        $("#" + idelement).html(data.html);
        $("#" + idelement).prop("selectedIndex", 0);
    }

    //uniform
    if ($.uniform) {
        $.uniform.update("#" + idelement);
    }

}


/**
 *
 * Finaliza la actualizacion de los ComboBox para componentes de FLAT UI aplicando los atributos originales en los nuevos recien generados
 *
 */
//var doUpdateComboBoxFlatUI = function(data, param) {
var doUpdateComboBoxFlatUI = function (data, idelement) {
    $("#" + idelement + " option").empty().prop("disabled", false);

    if (data.result) {
        $("#" + idelement).html(data.html);
        $("#" + idelement).prop("selectedIndex", 0);
    }

    //uniform
    if ($.uniform) {
        $.uniform.update("#" + idelement);
    }
    /*   var param = param.split("-");
     var idelement = param[0];
     var texto = param[1];
     
     $("#" + idelement + " option").empty().prop("disabled", false);
     
     if (data.result) {
     $("#" + idelement).html(data.html);
     $("#" + idelement).prop("selectedIndex", 0);
     }
     
     //uniform
     if ($.uniform) {
     $.uniform.update("#" + idelement);
     }
     
     //text = new String(utf8s, texto);
     $("#" + idelement + " option[value='']").text(texto);
     $("#" + idelement + " option[value='']").selectpicker('render');
     */
}



/**
 *  Deshabilita un determinado grupo de inputs segul el parametro state
 *
 * 	@author Xinergia <info@e-xinergia.com>
 *
 */
var x_disableInupts = function (TypeInput) {
    $(':' + TypeInput).prop("disabled", true);
}
/**
 *  Habilita un determinado grupo de inputs segul el parametro state
 *
 * 	@author Xinergia <info@e-xinergia.com>
 *
 */
var x_enableInupts = function (TypeInput) {
    $(':' + TypeInput).prop("disabled", false);
}


/**
 *  Crea los elementos de formulario q se encuentran en el documento.
 *  o en un contenedor determinado. Tambien inicializa los editores wysiwyg
 * 	
 *
 */
var x_runJS = function (container) {

    if (typeof container == "undefined") {
        var elements = $(".js_code");
    } else {
        var elements = $("#" + container + " .js_code");
    }


    var code = "";
    var parent = ""

    code = ""

    elements.each(function () {
        code += $(this).html().replace(/&amp;/gi, "&");

    }).remove();


    try {
        eval(code);
    } catch (err) {
        alert(code);
        alert(err.message);
    }

}


/**
 *  Actualiza los textareas de los editores para q viajen correctamente mediante
 *  una llamada ajax
 * 	
 *
 */
var updateTextAreas = function (idTextArea) {


    if (typeof Xinha != "undefined") {
        var editor = Xinha.getEditor(idTextArea);
        var html = editor.getEditorContent();
        $("#" + idTextArea).val(html);
        return true;
    } else {
        return false;
    }

}

/**
 * Selecciona todos los checks de los listados
 *
 *
 *
 */
var x_CheckAll = function (contentId, chkclass) {

    //$("#"+contentId+" :checkbox."+chkclass).prop("checked",true);

    $.uniform.update($("#" + contentId + " :checkbox." + chkclass).prop("checked", true));
}

/**
 * Deselecciona todos los checks de los listados
 *
 *
 *
 */
var x_UncheckAll = function (contentId, chkclass) {

    $.uniform.update($("#" + contentId + " :checkbox." + chkclass).prop("checked", false));
}


var x_CheckUncheckAll = function (contentId, chkclass, check) {


    if (typeof (check) == "undefined") {
        check = $('#checkuncheck');
    } else {
        check = $(check);
    }

    if (check.prop("checked")) {

        x_CheckAll(contentId, chkclass);

        //$.uniform.update("#checkuncheck :checkbox."+chkclass);
        $.uniform.update("#" + contentId + " :checkbox." + chkclass);

    } else {
        x_UncheckAll(contentId, chkclass);
        $.uniform.update("#" + contentId + " :checkbox." + chkclass);
    }
};



var renderUI2 = function (contentId) {

    // Desplegables
    //$("select").select2({dropdownCssClass: 'dropdown-inverse'});

    if (typeof (contentId) == "undefined") {
        $("select:not(.not-select2)").select2({
            minimumResultsForSearch: -1
        });
    } else {
        $("#" + contentId + " select:not(.not-select2)").select2({
            minimumResultsForSearch: -1
        });
    }



    //$('#' + contentId + " select").selectpicker({menuStyle: 'dropdown-inverse'});

    //checkbox y radio
    (function () {
        $(":checkbox:not([data-toggle='switch'])").each(function () {
            var $checkbox = $(this);
            $checkbox.radiocheck();
        });

        $(':radio').each(function () {
            var $radio = $(this);
            $radio.radiocheck();
        });
    })();



    // anteriores
    /*	$('#'+ contentId+" select").selectpicker({menuStyle: 'dropdown-inverse'});
     
     // Tooltips
     $("[data-toggle=tooltip]").tooltip("show");
     
     // Focus state for append/prepend inputs
     $('#'+ contentId+' .input-group').on('focus', '.form-control', function () {
     $(this).closest('.input-group, .form-group').addClass('focus');
     }).on('blur', '.form-control', function () {
     $(this).closest('.input-group, .form-group').removeClass('focus');
     });
     
     $("#"+ contentId+" .btn-group").on('click', "a", function() {
     $(this).siblings().removeClass("active").end().addClass("active");
     });
     */
}

var renderUI = function (contentId) {

    // Todo list
    //$("#"+ contentId+" .todo").on('click', 'li', function() {
    /*$("#"+ contentId).on('click', 'li', function() {
     $(this).toggleClass("todo-done");
     });*/

    // Custom Selects
//   	$('#'+ contentId+" select:not(.btn-default)").selectpicker({style: 'btn-primary', menuStyle: 'dropdown-inverse'});
    $('#' + contentId + " select").selectpicker({menuStyle: 'dropdown-inverse'});

    // Tooltips
    $("[data-toggle=tooltip]").tooltip("show");

    // Tags Input
    //$("#"+ contentId+" .tagsinput").tagsInput();
    //$("#"+ contentId).tagsInput();

    // jQuery UI Sliders
    /*var $slider = $("#slider");
     if ($slider.length) {
     $slider.slider({
     min: 1,
     max: 5,
     value: 2,
     orientation: "horizontal",
     range: "min"
     }).addSliderSegments($slider.slider("option").max);
     }
     
     var $verticalSlider = $("#vertical-slider");
     if ($verticalSlider.length) {
     $verticalSlider.slider({
     min: 1,
     max: 5,
     value: 3,
     orientation: "vertical",
     range: "min"
     }).addSliderSegments($verticalSlider.slider("option").max, "vertical");
     }  */

    // Placeholders for input/textarea
    //$("#"+ contentId+" :text, textarea").placeholder();

    // Focus state for append/prepend inputs
    $('#' + contentId + ' .input-group').on('focus', '.form-control', function () {
        $(this).closest('.input-group, .form-group').addClass('focus');
    }).on('blur', '.form-control', function () {
        $(this).closest('.input-group, .form-group').removeClass('focus');
    });

    // Make pagination demo work
    /*  $("#"+ contentId+" .pagination").on('click', "a", function() {
     $(this).parent().siblings("li").removeClass("active").end().addClass("active");
     });   */

    $("#" + contentId + " .btn-group").on('click', "a", function () {
        $(this).siblings().removeClass("active").end().addClass("active");
    });

    //checkbox y radio

    (function () {
        $(":checkbox:not([data-toggle='switch'])").each(function () {
            var $checkbox = $(this);
            $checkbox.checkbox();
        });

        $(':radio').each(function () {
            var $radio = $(this);
            $radio.radio();
        });

    })();

}