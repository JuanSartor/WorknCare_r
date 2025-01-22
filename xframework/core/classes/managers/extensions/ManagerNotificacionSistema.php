<?php

  /**
   * 	@autor Xinergia
   * 	@version 1.0	29/05/2014
   * 	Manager de los packs de SMS del Médico
   *
   */
  class ManagerNotificacionSistema extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "notificacionsistema", "idnotificacionSistema");
      }

      public function insert($request) {
          $request["fechaCreacion"] = date("Y-m-d");
          return parent::insert($request);
      }

      public function process($request) {

          $rdo = parent::process($request);

          if ($rdo) {
              $ManagerNotificacion = $this->getManager("ManagerNotificacion");
              $request[$this->id] = $rdo;
              if (isset($request["is_notificacion_medico"]) && (int) $request["is_notificacion_medico"] == 1) {
                  $rdo_notificacion = $ManagerNotificacion->processNotificacionSistemaMedico($request);
              } else {
                  $rdo_notificacion = $ManagerNotificacion->processNotificacionSistemaPaciente($request);
              }

              if ($rdo_notificacion) {
                  $this->setMsg([                        "result" => true,                        "msg" => "Se procesó con éxito la notificacion del sistema y se envió el mensaje a los usuarios seleccionados"      ]);
                  return $rdo;
              } else {
                  $this->setMsg([                        "result" => true,                        "msg" => "Se procesó la notificacion del sistema pero no se enviaron los mensajes a los usuarios seleccionados"                  ]);
                  return false;
              }
          } else {
              $this->setMsg([                    "result" => false,                    "msg" => "Error. No se pudo procesar la notificación"              ]);
              return false;
          }
      }

      /**
       * Método que retorna un listado en formato JSON 
       * @param type $request
       * @param type $idpaginate
       * @return type
       */
      public function getListadoNotificacionesSistemaJSON($request, $idpaginate = NULL) {

          if (!is_null($idpaginate)) {
              $this->paginate($idpaginate, 50);
          }

          $query = new AbstractSql();

          $query->setSelect("nsp.*, DATE_FORMAT(nsp.fechaCreacion, '%d/%m/%Y') as fechaCreacion_format");

          $query->setFrom("
                $this->table nsp
            ");


          if (isset($request["is_notificacion_medico"]) && (int) $request["is_notificacion_medico"] == 1) {
              $query->setWhere("nsp.is_notificacion_medico = 1");
          } else {
              $query->setWhere("nsp.is_notificacion_medico = 0");
          }


          // Filtro
          if ($request["texto"] != "") {
              $nombre = cleanQuery($request["descripcion"]);

              $query->addAnd("nsp.descripcion LIKE '%$nombre%'");
          }

          // Filtro
          if ($request["fechaCreacion"] != "") {
              $fecha = $this->sqlDate($request["fechaCreacion"]);

              $query->addAnd("nsp.fechaCreacion = '$fecha'");
          }

          $data = $this->getJSONList($query, array("titulo", "fechaCreacion_format", "descripcion", "url"), $request, $idpaginate);

          return $data;
      }

      /**
       * Método que retorna un listado en formato JSON 
       * @param type $request
       * @param type $idpaginate
       * @return type
       */
      public function getListadoFormNotificacionMedicoJSON($request, $idpaginate = NULL) {

          $idnotificacionSistema = $request["idnotificacionSistema"];
          if ((int) $idnotificacionSistema > 0) {
              $idpaginate = $this->getDefaultPaginate() . "_{$idnotificacionSistema}";
          }

          if (!is_null($idpaginate)) {
              $this->paginate($idpaginate, 50);
          }

          $query = new AbstractSql();

          $query->setSelect("*");

          $query->setFrom("
                            medico m 
                                 INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                            ");


          if ((int) $idnotificacionSistema > 0) {
              $query->setWhere("m.idmedico NOT IN (
                                        SELECT n.medico_idmedico
                                        FROM notificacion n
                                        WHERE n.notificacionSistema_idnotificacionSistema = $idnotificacionSistema
                    )");
          }
          $query->addAnd("uw.active = 1");

          if ($request["nombre"] != "") {
              $query->addAnd("uw.nombre LIKE '%" . $request["nombre"] . "%'");
          }

          if ($request["apellido"] != "") {
              $query->addAnd("uw.apellido LIKE '%" . $request["apellido"] . "%'");
          }

          $data = $this->getManager("ManagerMedico")->getJSONList($query, array("email", "nombre", "apellido", "numeroCelular"), $request, $idpaginate);

          return $data;
      }

      /**
       * Método que retorna un listado en formato JSON 
       * @param type $request
       * @param type $idpaginate
       * @return type
       */
      public function getListadoFormNotificacionPacienteJSON($request, $idpaginate = NULL) {

          $idnotificacionSistema = $request["idnotificacionSistema"];
          if ((int) $idnotificacionSistema > 0) {
              $idpaginate = $this->getDefaultPaginate() . "_{$idnotificacionSistema}";
          }

          if (!is_null($idpaginate)) {
              $this->paginate($idpaginate, 50);
          }

          $query = new AbstractSql();

          $query->setSelect("*");

          $query->setFrom("
                            paciente p 
                                 INNER JOIN usuarioweb uw ON (p.usuarioweb_idusuarioweb = uw.idusuarioweb)
                            ");


          if ((int) $idnotificacionSistema > 0) {
              $query->setWhere("p.idpaciente NOT IN (
                                        SELECT n.paciente_idpaciente
                                        FROM notificacion n
                                        WHERE n.notificacionSistema_idnotificacionSistema = $idnotificacionSistema
                    )");
          }
          $query->addAnd("uw.active = 1");

          if ($request["nombre"] != "") {
              $query->addAnd("uw.nombre LIKE '%" . $request["nombre"] . "%'");
          }

          if ($request["apellido"] != "") {
              $query->addAnd("uw.apellido LIKE '%" . $request["apellido"] . "%'");
          }

          $data = $this->getManager("ManagerPaciente")->getJSONList($query, array("email", "nombre", "apellido", "numeroCelular"), $request, $idpaginate);

          return $data;
      }

  }

?>