<?php

/**
 *  Planes de las Obras Sociales / Prepaga >>  Alta
 *
 * */

$managerEspecialidades = $this -> getManager("ManagerEspecialidades");
$especialidad = $managerEspecialidades -> get($this -> request["especialidad_idespecialidad"]);
$this -> assign("especialidad", $especialidad);


if (isset($this -> request["id"]) && $this -> request["id"] > 0) {
	$manager = $this -> getManager("ManagerSubEspecialidades");
	$record = $manager -> get($this -> request["id"]);

	$this -> assign("record", $record);
}
?>