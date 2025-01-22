<?php

/*
 * path.config.php
 *
 * Modulo de configuracion lo las rutas que utilizara el sistema
 * TODO: ver ed eliminar lo de OS ya que los path son indistintos
 *
 */

if ($_SERVER["HTTP_HOST"] != "localhost") {
    if (PHP_SAPI == "cli") {
        $server_ip = getHostByName(getHostName());
        switch ($server_ip) {
            case "182.31.32.151": // PROD
                $url_root = "https://www.workncare.io/";
                $subfolder = "";
                break;
            case "172.31.22.58": // FR
                $url_root = "https://test.doctorplus.eu/";
                $subfolder = "";
                break;
        }
    } else {
        $url_root = "https://" . $_SERVER["HTTP_HOST"] . "/";
        $subfolder = "";
    }
} else {
    $url_root = "http://localhost/doctorplus_francia_v2/";
    $subfolder = "doctorplus_francia_v2/";
}


if (!defined('SUB_FOLDER')) {
    define('SUB_FOLDER', $subfolder, true);
}

if (!defined('URL_ROOT')) {
    define('URL_ROOT', $url_root, true);
}

if (!defined('MONTO_CUOTA')) {
    define('MONTO_CUOTA', 350, true);
}

// Definimos el path raiz
if (!defined('PATH_ROOT')) {
    define('PATH_ROOT', realpath("./"), true);
}

if (!defined('OS'))
    define('OS', "LINUX", true);

require_once(PATH_ROOT . "/xframework/xFramework.php");
?>
