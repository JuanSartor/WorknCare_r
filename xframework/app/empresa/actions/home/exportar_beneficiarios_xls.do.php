<?php
//accion para exportar el listado de beneficiarios

$this->getManager("ManagerPacienteEmpresa")->ExportarListadoBeneficiarios($this->request);

