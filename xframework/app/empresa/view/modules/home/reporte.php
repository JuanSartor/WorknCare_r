<?php

// obtengo datos de la empresa y el usuario logueado
$ManagerUsuarioEmpresa = $this->getManager("ManagerUsuarioEmpresa");
$idusuario_empresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
$arregloUsuarioEmpresa = $ManagerUsuarioEmpresa->get($idusuario_empresa);

$hoy = fechaToString(date('d/m/Y'));
$this->assign("hoy", $hoy);
$this->assign("empresa", $arregloUsuarioEmpresa["empresa"]);

// obtengo el manager de empresa 
$ManagerEmpresa = $this->getManager("ManagerEmpresa");
// consulta la Tasa de Inscripcion para graficar
$arregloTasaInscripcion = $ManagerEmpresa->getDatosGraficoTasaDeInscripcion();
$this->assign("mesesTasa", json_encode($arregloTasaInscripcion["meses"]));
$this->assign("valoresTasa", json_encode($arregloTasaInscripcion["valores"]));
// consulta para graficar  presupuesto maximo VS utilizado
$arregloPresupuestos = $ManagerEmpresa->getDatosGraficoPresupuestos();
$this->assign("mesesPresupuesto", json_encode($arregloPresupuestos["meses"]));
$this->assign("valoresPresupuesto", json_encode($arregloPresupuestos["valores"]));
// consulta para graficar  importe por beneficiarios registrados
$arregloPImporte = $ManagerEmpresa->getDatosGraficoImporte();
$this->assign("mesesImporte", json_encode($arregloPImporte["meses"]));
$this->assign("valoresImporte", json_encode($arregloPImporte["valores"]));
// consulta para graficar  programas utilizados
$arregloProgramas = $ManagerEmpresa->getDatosGraficoProgramasUtilizados();
$this->assign("labelProgramas", json_encode($arregloProgramas["labelProgramas"]));
$this->assign("valoresProgramas", json_encode($arregloProgramas["valores"]));
// consulta para graficar  porcentaje utilizacion
$porcentajeUso = $ManagerEmpresa->getDatosGraficoPorcentajeUso();
$this->assign("porcentajeUso", $porcentajeUso);

