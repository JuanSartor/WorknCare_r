$(document).ready(function() {
    //renderUI2("Main");
    $(':checkbox').radiocheck();
    $("ul.slider-menu li a").removeClass("active");
    $("ul.slider-menu li i.fui-clip").parent().addClass("active");

    

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


//    $("#btn_compartir_colega").click(function() {
//
//        x_loadModule('perfil_salud',
//                'compartir',
//                '',
//                "div_modal_compartir",
//                BASE_PATH + "medico",
//                "",
//                function() {
//                    $("#compartir").modal();
//                });
//    });
});