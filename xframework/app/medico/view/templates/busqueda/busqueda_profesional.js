$(document).ready(function() {
    //x_runJS();


    renderUI2("busqueda_profesional");



    $(':checkbox').radiocheck();

    /*$("#slider-range").slider({
        range: 'min',
        min: 0,
        max: 300,
        value: 0,
        slide: function(event, ui) {
            $("#amount-min").val(ui.value + " km");
            $("#distancia_ti").val(ui.value);
            var oTop = $('.ui-slider-handle').offset().top;
            var oLeft = $('.ui-slider-handle').offset().left;
            $('.cs-ui-range-values-promedio').offset({top: oTop + 40, left: oLeft - 35});
        }
    });*/
    /*$("#amount-min").val($("#slider-range").slider("values", 0) + " km");
    var oTop = $('.ui-slider-handle').offset().top;
    var oLeft = $('.ui-slider-handle').offset().left;
    $('.cs-ui-range-values-promedio').offset({top: oTop + 2, left: oLeft - 48});
*/


    $("#pbr-btn-advanced-search").on('click', function(e) {
        e.preventDefault();
        $('#pbr-advanced-search').slideToggle();
        $("#btn_buscar_1").hide();
        $("#pbr-btn-advanced-search").hide();
    });

    $("#pbr-cancel-advanced-search").on('click', function(e) {
        e.preventDefault();
        $('#pbr-advanced-search').slideToggle();
        $("#btn_buscar_1").show();
        $("#pbr-btn-advanced-search").show();
    });



    $('.pbr-instrucciones-trigger').on('click', function(e) {
        e.preventDefault();
        $('#pbr-instrucciones').fadeToggle();
        $("#btn_buscar_1").show();
    });



     // Initialize ajax autocomplete:
        $('#as_localidad').autocomplete({
            zIndex: 10000,
            serviceUrl: BASE_PATH + 'medico.php?action=1&modulo=home&submodulo=localidad_autosuggest&pais_idpais=' + $("#pais_idpais").val(),
            onSelect: function (data) {

                $("#idlocalidad").val(data.data);
            
             
            }
        });


  
    
     $("#pais_idpais").change(function () {
            getLocalization();
            $("#idlocalidad, #as_localidad").val("");
            $('#as_localidad').autocomplete('clear');
            $('#as_localidad').autocomplete('setOptions', {serviceUrl: BASE_PATH + 'medico.php?action=1&modulo=home&submodulo=localidad_autosuggest&pais_idpais=' + this.value});
        });


    $("#btn_buscar_1, #btn_buscar_2").click(function() {
        //REalizo validaciones
  
        //if ($("#especialidad_ti").val() == "" && $("#medico_ti").val()=="" && $("#prestador_ti").val()==""&& $("#obraSocial_ti").val()=="" ) {
        if ($("#especialidad_ti").val() == "" && $("#medico_ti").val()==""  ) {
            x_alert(x_translate("Ingrese al menos un parámetro de búsqueda de profesionales"));
            return false;
        }

        $("#f_busqueda_profesionales").submit();
    });


    $('#as_obra_social').autocomplete({
        zIndex: 10000,
        serviceUrl: BASE_PATH + 'obrasocial_autosuggest_m.do',
        onSelect: function(data) {
            $("#obraSocial_ti").val(data.data);
        }
    });
    
    $('#as_prestador').autocomplete({
        zIndex: 10000,
        serviceUrl: BASE_PATH + 'prestador_autosuggest_m.do',
        onSelect: function(data) {
            $("#prestador_ti").val(data.data);
        }
    });
});