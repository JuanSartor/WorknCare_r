<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXSelectMedico($this->request["idpaciente"]);
$this->assign("paciente", $paciente);



$cirugia_ocular_list = $this->getManager("ManagerCirugiaOcular")->getList();

$this->assign("cirugia_ocular_list", $cirugia_ocular_list);
//obtenemos el perfil del paciente
$ManagerPerfilSaludControlVisual=$this->getManager("ManagerPerfilSaludControlVisual");
$perfilSaludControlVisual=$ManagerPerfilSaludControlVisual->getByField("paciente_idpaciente",$paciente["idpaciente"]);

//si no existe lo creamos
if(!$perfilSaludControlVisual){
    $idperfilSaludControlVisual=$ManagerPerfilSaludControlVisual->insert(["paciente_idpaciente"=>$paciente["idpaciente"]]);
    $perfilSaludControlVisual=$ManagerPerfilSaludControlVisual->get($idperfilSaludControlVisual);
}
$this->assign("perfilSaludControlVisual",$perfilSaludControlVisual);
//antecedentes de control visual
$ManagerPerfilSaludControlVisualAntecedentes=$this->getManager("ManagerPerfilSaludControlVisualAntecedentes");
$list_antecedentes=$ManagerPerfilSaludControlVisualAntecedentes->getListAntecedentes($perfilSaludControlVisual["idperfilSaludControlVisual"]);
$this->assign("list_antecedentes",$list_antecedentes);
//patologias actuales
$list_patologias_actuales=$ManagerPerfilSaludControlVisualAntecedentes->getListPatologiasActuales($perfilSaludControlVisual["idperfilSaludControlVisual"]);
$this->assign("list_patologias_actuales",$list_patologias_actuales);




//Obtengo los tags INputs
$ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");
$tags = $ManagerPerfilSaludConsulta->getInfoTags($paciente["idpaciente"]);
if ($tags) {
    $this->assign("tags", $tags);
}

$estadoTablero = $this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
$this->assign("estadoTablero", $estadoTablero);

 $info_menu = $ManagerPaciente->getInfoMenu($paciente["idpaciente"]);
                    $this->assign("info_menu_paciente", $info_menu);
