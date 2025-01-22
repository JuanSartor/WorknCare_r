<?php

/**
 *  Planes de las Obras Sociales / Prepaga >>  Alta
 *
 * */

$managerObraSocial = $this -> getManager("ManagerObrasSociales");
$obraSocial = $managerObraSocial -> get($this -> request["obraSocial_idobraSocial"]);
$this -> assign("obraSocial", $obraSocial);


if (isset($this -> request["id"]) && $this -> request["id"] > 0) {
	$manager = $this -> getManager("ManagerPlanesObrasSociales");
	$record = $manager -> get($this -> request["id"]);

	$this -> assign("record", $record);
}
?>