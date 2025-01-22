<?php

/**
 * 	function.path.php
 *
 * 	Funciones que gestionan las Rutas y el Sistema Operativo
 * 	Se Posee una Funcion par cada path necesario
 *
 * 	@author Sebastian Balestrini <sbalestrini@gmail.com>
 * 	@version 1.0 
 *
 */
function path_root($element = "") {

    return PATH_ROOT . endDir() . $element;
}

function path_app($element = "") {

    return path_root() . "xframework/app" . endDir() . $element;
}

function path_my_app($element = "") {

    return path_root() . "xframework/app/" . CONTROLLER . endDir() . $element;
}

function path_classes($element = "") {

    return path_root() . "xframework/core/classes" . endDir() . $element;
}

function path_helpers($element = "") {

    return path_classes("helpers" . endDir() . $element);
}

function path_managers($element = "") {

    return path_classes("managers" . endDir() . $element);
}

function path_controllers($element = "") {

    return path_root() . "xframework/core/controllers" . endDir() . $element;
}

function path_php_modules($element = "") {

    return path_root() . "view" . separator() . CONTROLLER . separator() . "php_modules" . endDir() . $element;
}

function path_libs($element = "") {

    return path_root() . "xframework/core/libs" . endDir() . $element;
}

function path_libs_php($element = "") {

    return path_root() . "xframework/core/libs/libs_php" . endDir() . $element;
}

function path_libs_js($element = "") {

    return path_root() . "xframework/core/libs/libs_js" . endDir() . $element;
}

function path_functions($element = "") {

    return path_root() . "xframework/core/functions" . endDir() . $element;
}

/* * * */

function path_config($element = "") {

    return path_root() . "xframework/config" . endDir() . $element;
}

function path_themes($element = "") {
    return path_root() . "xframework/app/themes/" . THEME . "/" . $element;
}

function path_view($element = "") {

    return path_root() . "xframework/app/" . CONTROLLER . separator() . "view" . endDir() . $element;
}

function path_css($element = "") {

    return path_root() . separator() . "xframework/app/" . CONTROLLER . separator() . "view/css" . endDir() . $element;
}

function path_smarty_templates($element = "") {

    return path_root() . "xframework/app/" . CONTROLLER . separator() . "view/templates" . endDir() . $element;
}

function path_smarty_templates_c($element = "") {

    return path_root() . "xframework/files/temp/" . CONTROLLER . separator() . "smarty_compiled" . endDir() . $element;
}

function path_smarty_cache($element = "") {

    return path_root() . "xframework/files/temp/" . CONTROLLER . separator() . "smarty_cached" . endDir() . $element;
}

function path_smarty_configs($element = "") {

    // return path_root()."xframework/app/".CONTROLLER.separator()."view/lang".separator(). LANG .endDir().$element ;	
}

// ToDo: Esto debe reestructurarse
function path_xtempates($element = "") {

    return path_root() . "xframework/core/x_templates" . endDir() . $element;
}

function path_xcomponents($element = "") {

    return path_xtempates("x_components" . endDir() . $element);
}

function path_xforms($element = "") {

    return path_xtempates("x_forms" . endDir() . $element);
}

// <-- End ToDo: Esto debe reestructurarse

function path_files($element = "") {

    return PATH_ROOT . separator() . "xframework/files" . endDir() . $element;
}

function path_entity_files($element = "") {

    return path_files("entities/" . $element);
}

function path_entity_files_main($element = "") {

    return path_files_main("entities/" . $element);
}

function path_files_main($element = "") {

    return PATH_MAIN . separator() . "xframework/files" . endDir() . $element;
}

/**
 *
 * paths con respecto al cliente, url
 * 	 
 */
// Cambiamos mediane HTACCESS. Todo lo que sea IMGS, CSs, etc. se va a acceder como URL desde view/
function url_css($element = "") {

    return URL_ROOT . "xframework/app/" . CONTROLLER . "/view/css/$element";
}

function url_imgs($element = "") {

    return URL_ROOT . "xframework/app/" . CONTROLLER . "/view/imgs/$element";
}

function url_templates($element = "") {

    return URL_ROOT . "xframework/app/" . CONTROLLER . "/view/templates/$element";
}

function url_files($element = "") {

    return URL_ROOT . "xframework/files/" . $element;
}

function url_entity_files($element = "") {

    return URL_ROOT . "xframework/files/entities/" . $element;
}

function url_core($element = "") {

    return URL_ROOT . "xframework/core/" . $element;
}

function url_app($element = "") {

    return URL_ROOT . "xframework/app/" . $element;
}

function url_my_app($element = "") {

    return URL_ROOT . "xframework/app/" . CONTROLLER . "/" . $element;
}

function url_web($element = "") {

    return URL_ROOT . $element;
}

function url_x_templates($element = "") {

    return URL_ROOT . "/xframework/core/x_templates/" . $element;
}

function endDir() {


    if (OS == "WINDOWS")
        return "\\";
    else
        return "/";
}

function separator() {

    if (OS == "WINDOWS")
        return "\\";
    else
        return "/";
}

?>
