<?php

ini_set('max_execution_time', 600); //300 seconds = 5 minutes
$hash = $this->request["hash"];


if (isset($_FILES["file_{$hash}"])) {

    $f = $_FILES["file_{$hash}"];

    $dir = path_root("xframework/files/temp/audio");

    $file = $dir . "/{$hash}.mp3";

    if ($f["error"][$k] == 0 && move_uploaded_file($f["tmp_name"], $file)) {
        $return = [
            "msg" => "L`audio a été téléchargé avec succès",
            "result" => true
        ];
    } else {
        $return = [
            "msg" => "Erreur. L`audio n`a pas pu être traité",
            "result" => false
        ];
    }
} else {
    $return = [
        "msg" => "Erreur. L`audio n`a pas pu être traité",
        "result" => false
    ];
}


header('Content-Type: application/json');
echo json_encode($return);
