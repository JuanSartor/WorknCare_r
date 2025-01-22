<?php

/**
 * 	getcombo.do.php
 * 	Procesa una solicitud y genera un combo mediante box con los resultados obtenidos
 */
$request = $this->getRequest();

$manager = $this->getManager($request["manager"]);
$method = $request["method"];



if (isset($request["texto"]) && $request["texto"] != "") {
    $output = "<option value=''>" . $request["texto"] . "</option>";
} else if ($request["nulo"] == 1) {
    $output = "<option value=''>Todos...</option>";
} elseif ($request["nulo"] == 2) {

    $output = "<option value=''>Seleccionar...</option>";
} else {
    $output = "";
}


if (isset($request["idcaller"]) && $request["idcaller"] >= 0) {
    $combo = $manager->$method($request["idcaller"]);

    foreach ($combo as $key => $value) {

        if (($request["idelement"] == $request["idelement_caller"]) && $key == $request["idcaller"]) {
            $output .= sprintf('<option selected="selected" value="%s">%s</option>', $key, $value);
        } else {
            if ($request["index_element"] == $key) {
                $output .= sprintf('<option selected="selected" value="%s">%s</option>', $key, $value);
            } else {
                $output .= sprintf('<option value="%s">%s</option>', $key, $value);
            }
        }
    }
}



if ($output != "") {
    $result = array("result" => true, "html" => ($output));
} else {
    $result = array("result" => false);
}
echo json_encode($result);
?>
