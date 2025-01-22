$("#btnTodosArchivos").click(function() {
    $("#section_list_images").show();
});

$("ul.slider-menu li a").removeClass("active");
    $("ul.slider-menu li i.fui-clip").parent().addClass("active");

x_loadModule('perfil_salud', 'dropzone_form', '', 'div_dropzone', BASE_PATH + "paciente_p");
