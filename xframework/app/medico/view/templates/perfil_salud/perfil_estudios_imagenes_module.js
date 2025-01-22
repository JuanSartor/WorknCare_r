$(document).ready(function() {
    //renderUI2("Main");
    $(':checkbox').radiocheck();
    $('#div_perfil_estudios_imagenes .slider-for').slick({
        slidesToShow: 1,
        slidesToScroll: 1,
        arrows: true,
        centerMode: false,
        fade: true,
        asNavFor: '#div_perfil_estudios_imagenes .slider-nav-carrousel',
        draggable: true
    });

    $('#div_perfil_estudios_imagenes .slider-nav-carrousel').slick({
        slidesToShow: 3,
        slidesToScroll: 1,
        asNavFor: '#div_perfil_estudios_imagenes .slider-for',
        dots: false,
        centerMode: false,
        focusOnSelect: true,
        draggable: true
    });


    $("#view_thumbs").click(function() {
        $("#view_list").removeClass("active");
        $(this).addClass("active");
        $("#div_list_table_thumb").show();
        $("#div_list_table_list").hide();
    });

    $("#view_list").click(function() {
        $("#view_thumbs").removeClass("active");
        $(this).addClass("active");
        $("#div_list_table_thumb").hide();
        $("#div_list_table_list").show();
    });


    $("#btn_compartir_colega").click(function() {

        x_loadModule('perfil_salud',
                'compartir',
                '',
                "div_modal_compartir",
                BASE_PATH + "medico",
                "",
                function() {
                    $("#compartir").modal();
                });
    });


     
    $('.modal-btn').on('click', function() {

        var targetId = '#' + $(this).data('target');
        $(targetId).modal();
    });


});