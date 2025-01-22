<?php

require_once (path_libs_php("stripe-php-7.75.0/init.php"));
/**
 * 	@autor Xinergia
 * 	@version 1.0	2020-01-20
 * 	Manager de empresas
 *
 */

/**
 * @autor Xinergia
 * @version 1.0
 * Class ManagerEmpresa
 * 	
 * Encapsula el manejo de las empresas
 */
class ManagerEmpresa extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "empresa", "idempresa");
        $this->default_paginate = "listado_empresa";
        $this->setImgContainer("empresa");
        $this->addImgType("jpg");
        $this->setFilters("img_pdf");
        $this->addThumbConfig(50, 50, "_perfil");
        $this->addThumbConfig(150, 150, "_usuario");
        $this->addThumbConfig(110, 110, "_list");
        $this->apiKeyPublic_stripe = STRIPE_APIKEY_PUBLIC;
        $this->apiKeySecret_stripe = STRIPE_APIKEY_SECRET;
    }

    /**
     * Metodo que procesa un registro
     * @param array $request
     * @return type
     */
    public function process($request) {

        return parent::process($request);
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     *   Inserta un nuevo usuario generando un status para el xadmin
     *   
     *           
     *   
     *   @param array $request datos enviados por el usuario
     *   @return int|boolean id del usuario creado o false en caso de error
     *
     */

    /**
     *  Transformo las imagenes PNG y JPEG a JPG
     * 
     * @param type $id
     * @return boolean
     */
    public function transformarPNGAJPG($id) {
        if ($id != '') {
            if (is_file(path_entity_files("empresa/$id/$id.png"))) {
                $this->processImagePNG($id);
            }
            $msg = $this->getMsg();
            $msg["imgs"] = $this->getImagenEmpresa($id);
            $this->setMsg($msg);

            return $id;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo registrar la imagen."]);
            return false;
        }
    }

    /**
     *  Método que procesa las imagenes de perfil en formato PNG y JPEG y las convierte a JPG 
     */
    public function processImagePNG($id) {
//obtenemos todos los thumbs que se generaron
        $files[] = "{$id}";
        foreach ($this->thumbs_config as $thumb) {
            $files[] = "{$id}{$thumb["suffix"]}";
        }

//converttimos todos los archivos y thumbs
        foreach ($files as $filename) {
            if (is_file(path_entity_files("empresa/$id/$filename.png"))) {
                $filenamePNG = path_entity_files("empresa/$id/$filename.png");
                $filenameJPG = path_entity_files("empresa/$id/$filename.jpg");
                $image = imagecreatefrompng($filenamePNG);
                $bg = imagecreatetruecolor(imagesx($image), imagesy($image));
                imagefill($bg, 0, 0, imagecolorallocate($bg, 255, 255, 255));
                imagealphablending($bg, TRUE);
                imagecopy($bg, $image, 0, 0, 0, 0, imagesx($image), imagesy($image));
                imagedestroy($image);
                $quality = 70;
                imagejpeg($bg, $filenameJPG, $quality);

//borramos el png original
                imagedestroy($bg);
                unlink($filenamePNG);
            }
        }
    }

    public function insert($request) {
        $required_fields = ["empresa", "plan_idplan", "tipo_cuenta", "fecha_adhesion", "fecha_alta", "dominio_email"];
        foreach ($required_fields as $value) {
            if ($request[$value] == $value) {
                echo $value;
                $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
                return false;
            }
        }


        $plan = $this->getManager("ManagerProgramaSaludPlan")->get($request["plan_idplan"]);
//verificamos si es un plan de PACK para OS y marcamos la empresa como OS
        if ($plan["pack"] == 1) {
//marcamos la empresa como una OS
            $request["obra_social"] = 1;
//verificamos que se ingrese la cant de packs a contratar
            if ($request["cant_empleados"] == "") {
                $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
                return false;
            }
//calculamos el presupuesto maximo: precio*cant
            $request["presupuesto_maximo"] = (int) $plan["precio"] * (int) $request["cant_empleados"];
        } else {
            $request["obra_social"] = 0;
            $request["cant_empleados"] = "";
            $request["presupuesto_maximo"] = "";
        }

        $request["fecha_adhesion"] = $this->sqlDate($request["fecha_adhesion"]);
        $request["fecha_vencimiento"] = strtotime('+12 month', strtotime($request["fecha_adhesion"]));
        $request["codigo_pass"] = $this->getRandomCode();

        $idempresa = parent::insert($request);

        $hash_id = $this->getManager("ManagerUsuarioEmpresa")->getRandomPass(10);
        $hash = sha1($hash_id);
        $hash_encode = base64_encode($hash);
//si se crea correctamente asocio las funcionaldades y si aplica o no
        return parent::update(["hash" => $hash_encode], $idempresa);
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     *   Acutaliza un usuario
     *   
     *   @param array $request datos enviados por el usuario
     *   @param $iduser id del usuario
     *           		
     *   @return int|boolean id del usuario creado o false en caso de error
     *
     */

    public function update($request, $idusuario) {
        if ($request["fecha_adhesion"] != "") {
            $request["fecha_adhesion"] = $this->sqlDate($request["fecha_adhesion"]);
        }

        return parent::update($request, $idusuario);
    }

    /**
     * Metodo que devuelve un registro de la empresa contratante del Pase de Salud
     * @param type $idempresa
     * @return type
     */
    public function get($idempresa) {
        $empresa = parent::get($idempresa);

        if ($empresa["fecha_adhesion"] <= date("Y-m-d")) {
            $empresa["suscripcion_activa"] = 1;
        } else {
            $empresa["suscripcion_activa"] = 2;
        }
// para el icono
        $imagenes = $this->getImagenes($idempresa);
        $empresa["image"] = $imagenes["image"];
//        $empresa["icon"] = $imagenes["icon"];

        return $empresa;
    }

    /**
     * Metodo que devuelve un array con lsa imagenes de la entidad
     * @param type $id
     * @return boolean
     */
    public function getImagenes($id) {

        if (is_file(path_entity_files("{$this->imgContainer}/$id/$id.jpg"))) {


            $imagen["image"] = array(
                "comun" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/{$id}.jpg",
                "perfil" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/{$id}_perfil.jpg",
                "list" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/{$id}_list.jpg",
                "usuario" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/{$id}_usuario.jpg"
            );
        }
//
//        if (is_file(path_entity_files("{$this->imgContainer}/$id/icon.jpg"))) {
//
//
//            $imagen["icon"] = array(
//                "comun" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/icon.jpg",
//                "perfil" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/icon_perfil.jpg",
//                "list" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/icon_list.jpg",
//                "usuario" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/icon_usuario.jpg"
//            );
//        }

        return $imagen;
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     *   Acutaliza un usuario desde el panel adminstrativo de DoctorPlus
     *   
     *   @param array $request datos enviados por el administrador
     *   @param $iduser id del usuario
     *           		
     *   @return int|boolean id del usuario creado o false en caso de error
     *
     */

    public function updateFromAdmin($request, $idusuario) {

// bandera fecha puse porque no se de donde proviene la otra validacion entonces agregue
// esa bandera para que no entre cuando quiero, que es cuando valido la transferencia
// para un pago de un pack que pasa de gratuito a pago
        if ($request["fecha_adhesion"] != "" && $request["bandera_fecha"] != 1) {
            $request["fecha_adhesion"] = $this->sqlDate($request["fecha_adhesion"]);
        }
        if ($request["tipo_cuenta"] == "2") {
            $request["empresa"] = "Particulier";
        }

        $this->getManager("ManagerUsuarioEmpresa")->basic_update($request, $request["idusuario_empresa"]);

        if ($request["estadoPack"] != '') {
            $managerProgramaSaludSuscripcion = $this->getManager("ManagerProgramaSaludSuscripcion");
            $estadoPrevioDelPago = $managerProgramaSaludSuscripcion->get($request["idProgramaSus"]);
            $resultadoUpdate = $managerProgramaSaludSuscripcion->update(["pack_pago_pendiente" => $request["estadoPack"]], $request["idProgramaSus"]);
            if ($resultadoUpdate) {
                if ($request["estadoPack"] == '2' && $estadoPrevioDelPago["pack_pago_pendiente"] != '2') {
                    $hoy = date("Y-m-d");
                    $managerProgramaSaludSuscripcion->update(["fecha_pago_factura" => $hoy], $request["idProgramaSus"]);
                    $managerUsuarioEmpresa = $this->getManager("ManagerUsuarioEmpresa");
                    $managerUsuarioEmpresa->sendEmailConfirmacionPagoSuscripcionManual($request["idusuario_empresa"]);
                }
            } else {
                $this->setMsg(["msg" => "Error al intentar actualizar el registro.", "result" => false]);
                return false;
            }
        }
        return parent::update($request, $idusuario);
    }

    public function basic_update($request, $idusuario) {
        return parent::update($request, $idusuario);
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *
     *   Usuarios 
     */

    public function getEmpresasJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 25);
        }

        $query = new AbstractSql();
        $query->setSelect("DISTINCT e.idempresa,
                u.nombre,
                u.apellido,
                u.email,
                e.empresa,
                psp.nombre as nombre_plan,
                CONCAT (DATE_FORMAT(e.fecha_adhesion,'%d/%m/%Y'),' - ',DATE_FORMAT(e.fecha_vencimiento,'%d/%m/%Y')) as fecha_adhesion,
                IF(e.cancelar_suscripcion=0,
                    IF(CONCAT(e.fecha_adhesion,' ','00:00:00') > SYSDATE(),'Pendiente de inicio','Activa'),
                    IF(e.cancelar_suscripcion=1,'Cancelacion pendiente','Cancelada')
                ) as estado_suscripcion,
                u.fecha_alta,
                IF(u.activo = 1,'Activo','Inactivo') AS activo,
                IF(u.estado = 1,'SI','NO') AS email_confirmado,
                IF(pssus.pack_pago_pendiente = 1,'Pendiente','Verificado') AS pagopendiente,
                IF(e.empresa_test = 0,'Cliente','Test') AS cuenta_empresa");
        $query->setFrom("usuario_empresa u 
                INNER JOIN empresa e ON (e.idempresa=u.empresa_idempresa)
                INNER JOIN programa_salud_plan psp ON (psp.idprograma_salud_plan=e.plan_idplan)
                LEFT  JOIN programa_salud_suscripcion pssus ON (pssus.empresa_idempresa=e.idempresa)");
        $query->setWhere("u.contratante=1");

// Filtro

        if ($request["email"] != "") {

            $email = cleanQuery($request["email"]);

            $query->addAnd("u.email LIKE '%$email%'");
        }

        if ($request["nombre"] != "") {

            $Nombre = cleanQuery($request["nombre"]);

            $query->addAnd("u.nombre LIKE '%$Nombre%'");
        }

        if ($request["apellido"] != "") {

            $apellido = cleanQuery($request["apellido"]);

            $query->addAnd("u.apellido LIKE '%$apellido%'");
        }

        if ($request["empresa"] != "") {

            $empresa = cleanQuery($request["empresa"]);

            $query->addAnd("e.empresa LIKE '%$empresa%'");
        }



        if (isset($request["activo"]) && (int) $request["activo"] >= 0) {

            $Activo = (int) ($request["activo"]);

            $query->addAnd("u.activo = $Activo");
        }


        if (isset($request["plan_idplan"]) && $request["plan_idplan"] != "") {

            $plan_idplan = (int) ($request["plan_idplan"]);

            $query->addAnd("e.plan_idplan = $plan_idplan");
        }

        $data = $this->getJSONList($query, array("nombre", "apellido", "email", "empresa", "nombre_plan", "fecha_adhesion", "estado_suscripcion", "fecha_alta", "activo", "email_confirmado", "pagopendiente", "cuenta_empresa"), $request, $idpaginate);


        return $data;
    }

    /**
     * Metodoso que setea el mensaje personalizado de la empresa para mostrar en la landing de bienvenida al pass
     * @param type $request
     */
    public function setearMensajeComplementario($request) {
        if ($request["id"] == "" || $request["codigo_pass"] == "") {
            $this->setMsg(array("result" => false, "msg" => "Error, no se pudo actualizar el registro"));
            return false;
        }
        if (CONTROLLER == "frontend_2") {
            $captcha = $this->getManager("ManagerUsuarioEmpresa")->validateGReCaptcha($request);

            if (!$captcha && $_SERVER["HTTP_HOST"] != "localhost") {
                $this->setMsg(["msg" => "Error, verificación captcha incorrecta", "result" => false]);
                return false;
            }
        }

        if ($request["mensaje_complementario"] == "") {
            $this->setMsg(array("result" => false, "msg" => "Ingrese el texto del mensaje"));
            return false;
        }
//verificamos que coincida el codigo_pass con el usuario 
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($request["id"]);
        $empresa = parent::getByFieldArray(["idempresa", "codigo_pass"], [$usuario_empresa["empresa_idempresa"], $request["codigo_pass"]]);
        $mensaje = strip_tags($request["mensaje_complementario"]);
// Clean up things like &amp;
        $mensaje = html_entity_decode($mensaje);

        $rdo = parent::update(["mensaje_complementario" => $mensaje], $empresa["idempresa"]);
        if ($rdo) {
            $this->setMsg(array("result" => true, "msg" => "Se ha registrado su mensaje"));
            return true;
        }
        return $rdo;
    }

    /**
     * Metodo que devuelve un numero aleatorio para el codigo del pass de salud
     * @param type $length
     */
    public function getRandomCode() {
        do {
            $num_aleatorio = rand(100000, 999999);
            $exist = $this->getByField("codigo_pass", $num_aleatorio);
        } while ($exist["codigo_pass"] == $num_aleatorio);

        return $num_aleatorio;
    }

    /**
     * Metodo que genera un QR con el link de bienvenida al Pase de salud para el beneficiario
     */
    public function generarQR($id) {
//fix limpiar header, porque no se genera el QR
        foreach (getallheaders() as $name => $value) {
            header_remove($name);
        }
        ob_end_clean();
        $empresa = $this->getByField("hash", $id);
        if ($empresa) {
            $url = URL_ROOT . "beneficiaireworkncare/{$id}.html";
            include(path_libs_php('phpqrcode/qrlib.php'));
            QRcode::png($url, false, QR_ECLEVEL_L, 5, 1);
        }
    }

    /**
     *  Metodo que genera QR y lo guarda en la carpeta TEMP 
     * @param type $id
     */
    public function generarQRinvitacion($id) {
//fix limpiar header, porque no se genera el QR
        foreach (getallheaders() as $name => $value) {
            header_remove($name);
        }
        ob_end_clean();
        $pngAbsoluteFilePath = path_files("temp/qr_invitacion/$id.png");
        $empresa = $this->get($id);

        if ($empresa["hash"]) {
            unlink($pngAbsoluteFilePath);
            $codeContents = URL_ROOT . "beneficiaireworkncare/{$empresa["hash"]}.html";
            include(path_libs_php('phpqrcode/qrlib.php'));
            QRcode::png($codeContents, $pngAbsoluteFilePath);
        }
    }

    public function generarQRCapsula($id) {
//fix limpiar header, porque no se genera el QR
        foreach (getallheaders() as $name => $value) {
            header_remove($name);
        }
        ob_end_clean();
        $Invi = $this->getManager("ManagerEmpresaInvitacionCapsula")->getByField("hash", $id);

        $managaC = $this->getManager("ManagerEmpresaInvitacionCapsula");
        $capsula_lista = $managaC->getCapsulaByHash($id);

        if ($capsula_lista["tipo_capsula"] != '2') {
            if ($Invi["hash"]) {
                $url = URL_ROOT . "capsule/{$Invi["hash"]}.html";
                include(path_libs_php('phpqrcode/qrlib.php'));
                QRcode::png($url, false, QR_ECLEVEL_L, 5, 1);
            }
        } else {
            $linkCapsula = $this->getManager("ManagerLinkCapsula")->getByField("capsula_idcapsula", $capsula_lista["idcapsula"]);
            $url = $linkCapsula["link"];
            include(path_libs_php('phpqrcode/qrlib.php'));
            QRcode::png($url, false, QR_ECLEVEL_L, 5, 1);
        }
    }

    /**
     * Metodo que genera un QR con el link para compartir el cuestionario
     */
    public function generarQRCuestionario($id) {
//fix limpiar header, porque no se genera el QR
        foreach (getallheaders() as $name => $value) {
            header_remove($name);
        }
        ob_end_clean();
        $Invi = $this->getManager("ManagerEmpresaInvitacionCuestionario")->getByField("hash", $id);
        $empresa = $this->get($Invi["empresa_idempresa"]);
        if ($empresa["hash_cuestionario"]) {
            $url = URL_ROOT . "participants/{$empresa["hash_cuestionario"]}.html";
            include(path_libs_php('phpqrcode/qrlib.php'));
            QRcode::png($url, false, QR_ECLEVEL_L, 5, 1);
        }
    }

    public function generarQRCuestionarioTemp($id) {
//fix limpiar header, porque no se genera el QR
        foreach (getallheaders() as $name => $value) {
            header_remove($name);
        }
        ob_end_clean();
        $Invi = $this->getManager("ManagerEmpresaInvitacionCuestionario")->getByField("hash", $id);
        $empresa = $this->get($Invi["empresa_idempresa"]);
        $pngAbsoluteFilePath = path_files("temp/qr_invitacion/$id.png");


        if ($empresa["hash_cuestionario"]) {
            unlink($pngAbsoluteFilePath);
            $codeContents = URL_ROOT . "participants/$id.html";
            include(path_libs_php('phpqrcode/qrlib.php'));
            QRcode::png($codeContents, $pngAbsoluteFilePath);
        }
    }

    public function generarQRCapsulaTemp($id, $capsula) {
//fix limpiar header, porque no se genera el QR
        foreach (getallheaders() as $name => $value) {
            header_remove($name);
        }
        ob_end_clean();
        $Invi = $this->getManager("ManagerEmpresaInvitacionCapsula")->getByField("hash", $id);
        $empresa = $this->get($Invi["empresa_idempresa"]);
        $pngAbsoluteFilePath = path_files("temp/qr_invitacion_capsula/$id.png");



//        if ($id) {
//            unlink($pngAbsoluteFilePath);
//            $codeContents = URL_ROOT . "capsule/$id.html";
//            include(path_libs_php('phpqrcode/qrlib.php'));
//            QRcode::png($codeContents, $pngAbsoluteFilePath);
//        }


        if ($capsula["tipo_capsula"] != '2') {

            unlink($pngAbsoluteFilePath);
            $codeContents = URL_ROOT . "capsule/$id.html";
            include(path_libs_php('phpqrcode/qrlib.php'));
            QRcode::png($codeContents, $pngAbsoluteFilePath);
        } else {
            $linkCapsula = $this->getManager("ManagerLinkCapsula")->getByField("capsula_idcapsula", $capsula["idcapsula"]);
            $url = $linkCapsula["link"];
            include(path_libs_php('phpqrcode/qrlib.php'));
////            QRcode::png($url, false, QR_ECLEVEL_L, 5, 1);
            QRcode::png($url, $pngAbsoluteFilePath);
        }
    }

    /**
     * Metodo que registra la cantidad de empleados que tiene la empresa
     * @param type $request
     * @return boolean
     */
    public function registrar_cantidad_empleados($request) {

        $record["cant_empleados"] = $request["cant_empleados"];
        $record["presupuesto_maximo"] = $request["presupuesto_maximo"];

        if ((int) $record["presupuesto_maximo"] > 0 && (int) $record["cant_empleados"] > 0) {
            $id = parent::update($record, $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
            if ($id > 0) {
                $this->setMsg(array("result" => true, "msg" => "Registro actualizado. Gracias por completar su informacíón."));
                return true;
            } else {
                $this->setMsg(array("result" => false, "msg" => "Se produjo un error en la activación."));
                return false;
            }
        } else {
            $this->setMsg(["msg" => "Error. Verifique los datos.", "result" => false]);
        }
    }

    /**
     * Metodo que genera el hash  y codigo para el link de invitacion de beneficiarios de la empresa
     * @return boolean
     */
    public function generar_hash_invitacion() {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
//verificamos si la suscripcion está cancelada, no se pueden cambiar
        $empresa = parent::get($idempresa);
        if ($empresa["cancelar_suscripcion"] == 2) {
            $this->setMsg(["msg" => "Error. Su suscripción ha sido cancelada", "result" => false]);
            return false;
        }
        $hash_id = $this->getManager("ManagerUsuarioEmpresa")->getRandomPass(10);
        $hash = sha1($hash_id);
        $hash_encode = base64_encode($hash);

        $codigo_pass = $this->getRandomCode();
//guardamos el codigo invitacion anterior para que se pueda seguir usando
        $guardar_hash = $this->getManager("ManagerEmpresaInvitacion")->insert(["hash" => $empresa["hash"], "empresa_idempresa" => $idempresa]);

        $upd = parent::update(["hash" => $hash_encode, "codigo_pass" => $codigo_pass], $idempresa);
        if ($upd && $guardar_hash) {
            $this->setMsg(array("msg" => "Registro actualizado con éxito", "result" => true, "hash" => $hash_encode));
            return true;
        } else {
            $this->setMsg(array("msg" => "Se ha producido un error intente más tarde",
                "result" => false
            ));
            return false;
        }
    }

    /**
     * Metodo que genera el hash  y codigo para el link de invitacion del cuestionario
     * @return boolean
     */
    public function generar_hash_invitacion_cuestionario($idcuestionario) {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
//verificamos si la suscripcion está cancelada, no se pueden cambiar
        $empresa = parent::get($idempresa);

        $hash_id = $this->getManager("ManagerUsuarioEmpresa")->getRandomPass(10);
        $hash = sha1($hash_id);
        $hash_encode = base64_encode($hash);

        $codigo_pass = $this->getRandomCode();
//guardamos el codigo invitacion anterior para que se pueda seguir usando
        $guardar_hash = $this->getManager("ManagerEmpresaInvitacionCuestionario")->insert(["hash" => $hash_encode, "empresa_idempresa" => $idempresa, "cuestionario_idcuestionario" => $idcuestionario]);

        $upd = parent::update(["hash_cuestionario" => $hash_encode, "codigo_cuestionario" => $codigo_pass], $idempresa);
        if ($upd && $guardar_hash) {
            $this->setMsg(array("msg" => "Registro actualizado con éxito", "result" => true, "hash" => $hash_encode));
            return true;
        } else {
            $this->setMsg(array("msg" => "Se ha producido un error intente más tarde",
                "result" => false
            ));
            return false;
        }
    }

    public function generar_hash_invitacion_capsula($idcapsula) {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
//verificamos si la suscripcion está cancelada, no se pueden cambiar

        $hash_id = $this->getManager("ManagerUsuarioEmpresa")->getRandomPass(10);
        $hash = sha1($hash_id);
        $hash_encode = base64_encode($hash);

        //  $codigo_pass = $this->getRandomCode();
//guardamos el codigo invitacion anterior para que se pueda seguir usando
        $guardar_hash = $this->getManager("ManagerEmpresaInvitacionCapsula")->insert(["hash" => $hash_encode, "empresa_idempresa" => $idempresa, "capsula_idcapsula" => $idcapsula]);

        //$upd = parent::update(["hash_cuestionario" => $hash_encode, "codigo_cuestionario" => $codigo_pass], $idempresa);
        if ($guardar_hash) {
            $this->setMsg(array("msg" => "Registro actualizado con éxito", "result" => true, "hash" => $hash_encode));
            return true;
        } else {
            $this->setMsg(array("msg" => "Se ha producido un error intente más tarde",
                "result" => false
            ));
            return false;
        }
    }

    /**
     * Metodo que registra la información de facturacion de la empresa
     * @param type $request
     */
    public function agregarInfoFacturacion($request) {
        $required_fields = ["direccion", "ciudad", "codigo_postal", "pais"];
        foreach ($required_fields as $value) {
            if ($request[$value] == $value) {
                $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
                return false;
            }
        }

        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $empresa = parent::get($idempresa);
        if ($empresa["tipo_cuenta"] == "1") {
            if ($request["siren"] == "") {
                $this->setMsg(["msg" => "Ingrese un numero SIREN válido", "result" => false]);
                return false;
            }
        }

        if ($empresa["tipo_cuenta"] == "1" && $request["empresa"] == "") {
            $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
            return false;
        }
//verificamos si la suscripcion está cancelada, no se pueden cambiar
        if ($empresa["cancelar_suscripcion"] == 2) {
            $this->setMsg(["msg" => "Error. Su suscripción ha sido cancelada", "result" => false]);
            return false;
        }

        if ($empresa["tipo_cuenta"] == "1") {
            $record["siren"] = $request["siren"];
            $record["empresa"] = $request["empresa"];
        }

        $record["direccion"] = $request["direccion"];
        $record["ciudad"] = $request["ciudad"];
        $record["codigo_postal"] = $request["codigo_postal"];
        $record["pais"] = $request["pais"];
        $record["tipo_cuenta"] = $empresa["tipo_cuenta"];
        $upd = parent::update($record, $idempresa);
        if ($upd) {
//seteamos la info factruacion para las cuentas particulares - no empresas
            if ($empresa["tipo_cuenta"] == "2") {
                $request["empresa"] = "Particulier";
                $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByFieldArray(["empresa_idempresa", "contratante"], [$idempresa, 1]);
                $record["nombre"] = $usuario_empresa["nombre"];
                $record["apellido"] = $usuario_empresa["apellido"];
            }

//actualizamos la info de facturacion en Stripe
            $record["pais_iso"] = $this->getManager("ManagerPaisSepa")->get($request["pais"])["iso"];
            $upd_stripe = $this->getManager("ManagerProgramaSaludSuscripcion")->actualizar_direccion_facturas($idempresa, $record);
        }
        return $upd;
    }

    /**
     * Metodo que actualiza una suscripcion del plan de la empresa a un plan superior
     * @param type $request
     */
    public function actualizar_suscripcion($request) {

        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $empresa = parent::get($idempresa);
        $recordHistorial["fecha_activacion"] = $empresa["fecha_adhesion"];
// obtengo el plan contratado
        $managerProSaludPlan = $this->getManager("ManagerProgramaSaludPlan");
        $programSaludPlan = $managerProSaludPlan->get($empresa["plan_idplan"]);

//  if ((int) $request["id"] <= (int) $empresa["plan_idplan"]) {
// banderaGratis es porque viene de cuando pasa del programa Gratis a uno pago
        if ($request["banderaGratis"] != '1') {
            if ((float) $request["precio"] < (float) $programSaludPlan["precio"]) {
                $this->setMsg(["msg" => "Error. No se puede actualizar al plan seleccionado", "result" => false]);
                return false;
            }
        }

//verificamos si la suscripcion está cancelada, no se pueden cambiar
        if ($empresa["cancelar_suscripcion"] == 2) {
            $this->setMsg(["msg" => "Error. Su suscripción ha sido cancelada", "result" => false]);
            return false;
        }

        $calendar = new Calendar();
        $fecha_adhesion_antes = $calendar->isMayor(date("Y-m-d"), $empresa["fecha_adhesion"]);
        if ($fecha_adhesion_antes == 1) {
            $record["fecha_adhesion"] = $empresa["fecha_adhesion"] = date("Y-m-d");
        }
        $empresa["fecha_adhesion_format"] = fechaToString($empresa["fecha_adhesion"]);
        if ($request["banderaGratis"] != '1') {
            $record["plan_idplan"] = $request["id"];
        } else {
            $record["plan_idplan"] = $empresa["plan_idplan_siguiente"];
        }
        if ($request["banderaGratis"] = '1') {
            $record["fecha_vencimiento"] = date("Y-m-d", strtotime($record["fecha_adhesion"] . "+ 1 year"));
        }
        $this->db->StartTrans();
        $rdo = parent::update($record, $idempresa);
        $rdo2 = $this->db->Execute("update paciente_empresa set plan_idplan={$record["plan_idplan"]} where empresa_idempresa={$idempresa}");

        $recordHistorial["programasaludplan_idprograma_salud_plan"] = $empresa["plan_idplan"];
        $recordHistorial["precio"] = $programSaludPlan["precio"];
        $recordHistorial["empresa_idempresa"] = $idempresa;
        $recordHistorial["fecha_finalizacion"] = $record["fecha_adhesion"];

        $rdo3 = $this->getManager("ManagerHistorialProgramaSaludPlanEmpresa")->insert($recordHistorial);


        if ($rdo && $rdo2 && $rdo3) {
            $cambio_stripe = $this->getManager("ManagerProgramaSaludSuscripcion")->cambiar_plan_suscripcion($record["plan_idplan"], $idempresa);
            if (!$cambio_stripe) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se puede actualizar al plan seleccionado", "result" => false]);
                return false;
            }

            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Se ha actualizado su plan. Sus beneficiarios lo podran disfrutar a partir del [[{$empresa["fecha_adhesion_format"]}]]", "result" => true, "home" => 1]);
            return false;
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Error. No se puede actualizar al plan seleccionado", "result" => false]);
            return false;
        }
    }

    /**
     * Método de envío de email cuando se procesa la renovacion de la suscripcion al Pase de Salud
     * @param type $idempresa
     * @return boolean
     */
    public function enviar_mail_renovacion_suscripcion($idempresa) {

        $query = new AbstractSql();
        $query->setSelect("email,nombre,apellido");
        $query->setFrom("usuario_empresa");
        $query->setWhere("estado=1 and empresa_idempresa=$idempresa and (tipo_usuario=1 OR tipo_usuario=3)");
        $usuarios = $this->getList($query);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet localassign
        $mEmail->setPort("587");
        $mEmail->setFromName("Notifications WorknCare");
        $mEmail->setSubject("WorknCare : abonnement renouvelé!");


        $smarty = SmartySingleton::getInstance();



        $mEmail->setBody($smarty->Fetch("email/suscripcion_actualizada_empresa.tpl"));
        if (count($usuarios) > 0) {
            foreach ($usuarios as $usuario) {
                $mEmail->addTo($usuario["email"]);
                $smarty->assign("usuario", $usuario);
            }
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }

//header a todos los comentarios!
        if ($mEmail->send()) {
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }
    }

    /**
     * Método de envío de email cuando se procesa la renovacion de la suscripcion al Pase de Salud
     * @param type $idempresa
     * @return boolean
     */
    public function enviar_mail_maximo_beneficiarios($idempresa) {

        $query = new AbstractSql();
        $query->setSelect("email,nombre,apellido");
        $query->setFrom("usuario_empresa");
        $query->setWhere("estado=1 and empresa_idempresa=$idempresa and (tipo_usuario=1 OR tipo_usuario=3 OR tipo_usuario=4)");
        $usuarios = $this->getList($query);

        $empresa = parent::get($idempresa);

        $envio = false;
        if (count($usuarios) > 0) {
            foreach ($usuarios as $usuario) {
                $mEmail = $this->getManager("ManagerMail");
                $mEmail->setHTML(true);

//ojo solo arnet localassign
                $mEmail->setPort("587");
                $mEmail->setFromName("Notifications WorknCare");
                $mEmail->setSubject("WorknCare : maximum de bénéficiaires atteint!");
                $smarty = SmartySingleton::getInstance();
                $smarty->assign("empresa", $empresa);
                $smarty->assign("usuario_empresa", $usuario);
                $mEmail->setBody($smarty->Fetch("email/maximo_beneficiarios_alcanzado.tpl"));
                $mEmail->addTo($usuario["email"]);
                $envio = $mEmail->send();
            }
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }

//header a todos los comentarios!
        if ($envio) {
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }
    }

    /**
     * Método de envío de email cuando se procesa la cancelacion de la suscripcion al Pase de Salud
     * @param type $idempresa
     * @return boolean
     */
    public function enviar_mail_cancelar_suscripcion($idempresa) {

        $query = new AbstractSql();
        $query->setSelect("email,nombre,apellido");
        $query->setFrom("usuario_empresa");
        $query->setWhere("estado=1 and empresa_idempresa=$idempresa and (tipo_usuario=1 OR tipo_usuario=3)");
        $usuarios = $this->getList($query);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet local
        $mEmail->setPort("587");
        $mEmail->setFromName("Notifications WorknCare");
        $mEmail->setSubject("WorknCare : abonnement annulé!");


        $smarty = SmartySingleton::getInstance();



        $mEmail->setBody($smarty->Fetch("email/suscripcion_cancelada_empresa.tpl"));
        if (count($usuarios) > 0) {
            foreach ($usuarios as $usuario) {
                $mEmail->addTo($usuario["email"]);
                $smarty->assign("usuario", $usuario);
            }
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }

//header a todos los comentarios!
        if ($mEmail->send()) {
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }
    }

    /**
     * Email enviado a la empresa cuando no se puede realizar el debito de la suscripcion al plan de salud
     * @param type $idempresa
     * @param type $suscripcion_data
     * @return boolean
     */
    public function enviar_mail_error_cobro_suscripcion($idempresa, $suscripcion_data) {

        $query = new AbstractSql();
        $query->setSelect("email,nombre,apellido,idioma_predeterminado");
        $query->setFrom("usuario_empresa");
        $query->setWhere("estado=1 and empresa_idempresa=$idempresa and (tipo_usuario=1 OR tipo_usuario=3)");
        $usuarios = $this->getList($query);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet local
        $mEmail->setPort("587");
        $mEmail->setFromName("Notifications WorknCare");
        $mEmail->setSubject("WorknCare : budget mensuel NON  débité !");


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("descargar_pdf", $suscripcion_data->data->object->invoice_pdf);
        $smarty->assign("pagar_link", $suscripcion_data->data->object->hosted_invoice_url);
        $smarty->assign("monto", $suscripcion_data->data->object->amount_due);


        $mEmail->setBody($smarty->Fetch("email/suscripcion_error_cobro.tpl"));
        if (count($usuarios) > 0) {
            foreach ($usuarios as $usuario) {
                $mEmail->addTo($usuario["email"]);
                $smarty->assign("usuario", $usuario);
            }
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }

//header a todos los comentarios!
        if ($mEmail->send()) {
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }
    }

    /**
     * Email enviado a la empresa cuando se realiza el cobro de la suscripcion al plan de salud
     * @param type $idempresa
     * @param type $suscripcion_data
     * @return boolean
     */
    public function enviar_mail_exito_cobro_suscripcion($idempresa, $suscripcion_data) {

        $query = new AbstractSql();
        $query->setSelect("email,nombre,apellido,idioma_predeterminado");
        $query->setFrom("usuario_empresa");
        $query->setWhere("estado=1 and empresa_idempresa=$idempresa and (tipo_usuario=1 OR tipo_usuario=3)");
        $usuarios = $this->getList($query);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet local
        $mEmail->setPort("587");
        $mEmail->setFromName("Notifications WorknCare");
        $mEmail->setSubject("WorknCare : budget mensuel débité !");


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("descargar_pdf", $suscripcion_data->data->object->invoice_pdf);

        $smarty->assign("monto", $suscripcion_data->data->object->amount_due);


        $mEmail->setBody($smarty->Fetch("email/suscripcion_exito_cobro.tpl"));
        if (count($usuarios) > 0) {
            foreach ($usuarios as $usuario) {
                $mEmail->addTo($usuario["email"]);
                $smarty->assign("usuario", $usuario);
            }
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }

//header a todos los comentarios!
        if ($mEmail->send()) {
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
            return false;
        }
    }

    /**
     * Metodo que devuelve un combo de opciones de empresas
     * @return type
     */
    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("idempresa,empresa");
        $query->setFrom("empresa");
        $query->setOrderBy("empresa ASC");

        return $this->getComboBox($query, false);
    }

    /**
     * Metodo que obtiene la cantidad de empresa 
     */
    public function getCantidadEmpresa() {
        $query = new AbstractSql();
        $query->setSelect("COUNT(*) as cantidad");
        $query->setFrom("$this->table");


        $registro = $this->db->GetRow($query->getSql());

        $this->setMsg(["cantidad" => $registro["cantidad"]]);
    }

    /*
     * Metodo que devuelve un array con los meses desde la adhesion de la empresa hasta la fecha para el calculo de estadisticas mensuales
     */

    public function getDatosGraficoMeses() {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $empresa = parent::get($idempresa);
        $mes_inicio = date("Y-m", strtotime($empresa["fecha_alta"]));
        $mes_fin = date("Y-m");
        $labels[] = $mes_inicio;
        $labels_format[] = getNombreCortoMesSMS(date("n", strtotime($mes_inicio)));
        $mes_iterador = $mes_inicio;

        while ($mes_iterador != $mes_fin) {

            $mes_siguiente = date("Y-m", strtotime("+ 1 month", strtotime($mes_iterador)));
            $labels[] = $mes_siguiente;
            $labels_format[] = getNombreCortoMesSMS(date("n", strtotime($mes_siguiente)));
            $mes_iterador = $mes_siguiente;
        }


        return ["meses" => $labels, "meses_format" => $labels_format];
    }

    /**
     *  Metodo que obtiene la tasa de inscripcion de usuarios de la empresa por mes desde la adhesion
     */
    public function getDatosGraficoTasaDeInscripcion() {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $empresa = parent::get($idempresa);
        if ($empresa["cant_empleados"] != "") {
            $labels = $this->getDatosGraficoMeses();

            $valores = [0];

            $inscriptos_acumulados = 0;
            foreach ($labels["meses"] as $date_mes) {
                $query = new AbstractSql();
                $query->setSelect("count(*) as cant");
                $query->setFrom("paciente_empresa pe
                            INNER JOIN paciente p ON ( pe.paciente_idpaciente = p.idpaciente )
                            INNER JOIN usuarioweb uw ON ( p.usuarioweb_idusuarioweb = uw.idusuarioweb ) ");
                $query->setWhere("DATE_FORMAT(uw.fecha_alta,'%Y-%m')='$date_mes' and pe.empresa_idempresa=$idempresa");
                $incriptos_mes = $this->db->getRow($query->getSql())["cant"];
                $inscriptos_acumulados += $incriptos_mes;
                $valores[] = ( $inscriptos_acumulados * 100) / (int) $empresa["cant_empleados"];
            }
        }


        return array("meses" => array_merge([""], $labels["meses_format"]), "valores" => $valores);
    }

    /**
     *  obtengo presupuesto maximo VS usado
     */
    public function getDatosGraficoPresupuestos() {

        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $empresa = parent::get($idempresa);
        $plan = $this->getManager("ManagerProgramaSaludPlan")->get($empresa["plan_idplan"]);
        $labels = $this->getDatosGraficoMeses();
        $labels_aux = [];
        $valores = [];
        $importe_acumulado = 0;

        foreach ($labels["meses"] as $key => $date_mes) {
            $query = new AbstractSql();
            $query->setSelect("count(*) as cant");
            $query->setFrom("paciente_empresa pe");
            $query->setWhere("DATE_FORMAT(pe.fecha_activacion,'%Y-%m')='$date_mes' and pe.empresa_idempresa=$idempresa and pe.estado=1");
            $incriptos_mes = $this->db->getRow($query->getSql())["cant"];
            $importe_mes = (int) $incriptos_mes * (float) $plan["precio"];

            if ($importe_mes != 0) {
//solo seleccionamos los meses en los que hay facturacion
                $importe_acumulado += $importe_mes;
                $valores[] = $importe_mes;
                $labels_aux["meses"][] = $date_mes;
                $labels_aux["meses_format"][] = $labels["meses_format"][$key];
            }
        }

//calculamos el presupuesto restante, quitando el importe gastado al presupuesto definido por la empresa
        if ($empresa["presupuesto_maximo"] != "") {
            $restante = (float) $empresa["presupuesto_maximo"] - (float) $importe_acumulado;
            $valores[] = $restante;
            $labels_aux["meses_format"][] = "Budget restant";
        }


        return array("meses" => $labels_aux["meses_format"], "valores" => $valores);
    }

    /**
     *  Metodo que obtiene el importe facturado a la empresa por los beneficiarios registrados
     */
    public function getDatosGraficoImporte() {

        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $empresa = parent::get($idempresa);
        $plan = $this->getManager("ManagerProgramaSaludPlan")->get($empresa["plan_idplan"]);
        $labels = $this->getDatosGraficoMeses();
        $valores = [];
        $importe_acumulado = 0;

// obtengo el historial si hizo cambio de planes
        $historialPlanes = $this->getManager("ManagerHistorialProgramaSaludPlanEmpresa")->getListByIdEmpresa($idempresa);

        foreach ($labels["meses"] as $date_mes) {
            $query = new AbstractSql();
            $query->setSelect("count(*) as cant");
            $query->setFrom("paciente_empresa pe");
            $query->setWhere("DATE_FORMAT(pe.fecha_activacion,'%Y-%m')<='$date_mes' and pe.empresa_idempresa=$idempresa and pe.estado=1");
            $incriptos_mes = $this->db->getRow($query->getSql())["cant"];
            $bandera = 0;

            if ($historialPlanes != null) {
                foreach ($historialPlanes as $filahistorial) {

                    if (substr($filahistorial["fecha_activacion"], 0, -3) <= $date_mes && substr($filahistorial["fecha_finalizacion"], 0, -3) > $date_mes) {
                        $importe_acumulado = (int) $incriptos_mes * (float) $filahistorial["precio"];
                        $bandera = 1;
                    }
                }
            }
            if ($bandera == 0) {
                $importe_acumulado = (int) $incriptos_mes * (float) $plan["precio"];
            }
            $valores[] = $importe_acumulado;
        }
        return array("meses" => $labels["meses_format"], "valores" => $valores);
    }

    /**
     *  Metodo que obtiene el importe fijo mensual por uso del servicio
     */
    public function getDatosGraficoImporteFijoUsoSistema() {

        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];

        $labels = $this->getDatosGraficoMeses();
        $valores = [];
        $importe_acumulado = 0;
        $importe_fijo_por_beneficiarios = 2;
        foreach ($labels["meses"] as $date_mes) {
            $query = new AbstractSql();
            $query->setSelect("count(*) as cant");
            $query->setFrom("paciente_empresa pe");
            $query->setWhere("DATE_FORMAT(pe.fecha_activacion,'%Y-%m')='$date_mes' and pe.empresa_idempresa=$idempresa and pe.estado=1");
            $incriptos_mes = $this->db->getRow($query->getSql())["cant"];
            $importe_acumulado += (int) $incriptos_mes * (float) $importe_fijo_por_beneficiarios;
            $valores[] = $importe_acumulado;
        }


        return array("meses" => $labels["meses_format"], "valores" => $valores);
    }

    /**
     *  Metodo que obtiene el importe pagado a los profesionales que realizaron las consultas
     */
    public function getDatosGraficoImportePagadoProfesionales() {

        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];

        $query = new AbstractSql();
        $query->setSelect("sum(precio_tarifa) as sum");
        $query->setFrom("(
                SELECT
                    idconsultaExpress AS id, precio_tarifa
                FROM
                    paciente_empresa pe
		INNER JOIN consultaexpress ce ON ( pe.paciente_idpaciente = ce.paciente_idpaciente AND pe.empresa_idempresa = $idempresa )
                    where estadoConsultaExpress_idestadoConsultaExpress=4 and debito_plan_empresa=1
                 UNION
                SELECT
                    idvideoconsulta AS id, precio_tarifa
                FROM
                    paciente_empresa pe
		INNER JOIN videoconsulta vc ON ( pe.paciente_idpaciente = vc.paciente_idpaciente AND pe.empresa_idempresa = $idempresa )
			where estadoVideoConsulta_idestadoVideoConsulta=4 and debito_plan_empresa=1
                UNION
                SELECT r.idReembolso, r.monto AS precio_tarifa 
		FROM paciente_empresa pe, reembolsos r, paciente pa
		where pe.empresa_idempresa = $idempresa and  pe.paciente_idpaciente=pa.idpaciente and
		pa.usuarioweb_idusuarioweb=r.usuarioWeb_idusuarioweb and r.estado=1        
                ) AS T ");

        $importe_consultas = $this->db->getRow($query->getSql())["sum"];

        return (float) $importe_consultas;
    }

    /**
     *  Metodo que obtiene la cantidad de programas utilizados para realizar consultas por los beneficiarios
     */
    public function getDatosGraficoProgramasUtilizados() {

        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $query = new AbstractSql();
        $query->setSelect("count(id) as cant, idprograma_salud,programa_salud ");
        $query->setFrom("(select idconsultaExpress as id, ps.idprograma_salud,ps.programa_salud from paciente_empresa pe inner join consultaexpress ce on (pe.paciente_idpaciente=ce.paciente_idpaciente and pe.empresa_idempresa=$idempresa) inner join programa_categoria pc on (pc.idprograma_categoria=ce.idprograma_categoria) inner join programa_salud ps on (ps.idprograma_salud=pc.programa_salud_idprograma_salud)
                            union
                            select idvideoconsulta as id,  ps.idprograma_salud,ps.programa_salud from paciente_empresa pe inner join videoconsulta vc on (pe.paciente_idpaciente=vc.paciente_idpaciente and pe.empresa_idempresa=$idempresa) inner join programa_categoria pc on (pc.idprograma_categoria=vc.idprograma_categoria) inner join programa_salud ps on (ps.idprograma_salud=pc.programa_salud_idprograma_salud)
                            union
                            select r.idReembolso as id, ps.idprograma_salud, ps.programa_salud from paciente pac, paciente_empresa pace,  programa_salud ps, reembolsos r where (r.estado=1 or r.estado=0) and r.usuarioWeb_idusuarioweb=pac.usuarioweb_idusuarioweb and pac.idpaciente=pace.paciente_idpaciente and pace.empresa_idempresa=$idempresa and ps.idprograma_salud=r.programaSalud_idprogramasalud
) as T");
        $query->setGroupBy("idprograma_salud");
        $query->setOrderBy("1 ASC");
        $query->setLimit("10");
        $listado = $this->getList($query);

        $labelProgramas = [];
        $valores = [];

        foreach ($listado as $programa) {
            $labelProgramas[] = $programa["programa_salud"];
            $valores[] = $programa["cant"];
        }


        return array("labelProgramas" => $labelProgramas, "valores" => $valores);
    }

    /**
     *  Metodo que permite calcular el porcentaje de utilizacion del servicio del Pass por parte de la empresa
     */
    public function getDatosGraficoPorcentajeUso() {

//1:Monto facturado a la empresa por mes
        $importes_facturado_mensual = $this->getDatosGraficoImporte();
//obtememos el ultimo importe acumulado, que es el TOTAL
// $importe_total_facturado = end($importes_facturado_mensual["valores"]);
        $importe_total_facturado = 0;
        foreach ($importes_facturado_mensual["valores"] as $importe) {
            $importe_total_facturado = $importe_total_facturado + $importe;
        }
//2: obtenemos el importe pagado a los beneficiarios por las consultas realizadas de los beneficiarios
        $importe_pagado_profesionales = $this->getDatosGraficoImportePagadoProfesionales();

//3:Monto fijo mensual por beneficiario
        $importes_fijo_mensual = $this->getDatosGraficoImporteFijoUsoSistema();
//obtememos el ultimo importe fijo acumulado

        /**
         * esto lo comento Juan porque cambiaron las politicas de negocio 
         * y no se cobra mas un importe fijo entonces comente la linea y puse 0
         */
//$import_total_fijo = end($importes_fijo_mensual["valores"]);
        $import_total_fijo = 0;
//hacemos el calculo del porcentaje de uso del sistema
//suma de todas las consultas realizadas + Importe fijo) / monto facturado a la empresa
        if ($importe_total_facturado > 0) {
            $tasa_uso = ((float) $importe_pagado_profesionales + (float) $import_total_fijo) / (float) $importe_total_facturado;
        } else {
            $tasa_uso = 0;
        }

        return round($tasa_uso * 100, 0);
    }

    /**
     *  Metodo que suscripcion de forma manual para las obras sociales
     */
    public function crear_suscripcion_forma_manual($request) {

        if ($request["idempresa"] != '') {
            $resultado = parent::update(["contratacion_manual" => 1], $request["idempresa"]);
            if ($resultado) {
                $hoy = date("Y-m-d");
                $programaSaludSus = $this->getManager("ManagerProgramaSaludSuscripcion")->getByField("empresa_idempresa", $request["idempresa"]);
                $this->getManager("ManagerProgramaSaludSuscripcion")->update(["fecha_envio_factura" => $hoy], $programaSaludSus["idprograma_salud_suscripcion"]);

                $empresa = $this->get($request["idempresa"]);
                $stripe = new \Stripe\StripeClient($this->apiKeySecret_stripe);
                $facturas = $stripe->invoices->retrieve($programaSaludSus["invoiceId"]);
                $data_variables["empresa"] = $empresa;
                $data_variables["monto"] = $facturas["amount_due"] / 100;
                $data_variables["programaSaludSus"] = $programaSaludSus;
                $data_variables["plan"] = $this->getManager("ManagerProgramaSaludPlan")->getByField("stripe_priceid", $programaSaludSus["priceId"]);

                $data_variables["factura"] = $facturas;
                $contratante = $this->getManager("ManagerUsuarioEmpresa")->getByFieldArray(["contratante", "empresa_idempresa"], [1, $request["idempresa"]]);
                $data_variables["contratante"] = $contratante;
                if (!file_exists(path_entity_files("facturas_pagopackmanual/{$request["idempresa"]}"))) {
                    mkdir(path_entity_files("facturas_pagopackmanual/{$request["idempresa"]}"), 0777, true);
                }
                $data_variables["file"] = path_files("entities/facturas_pagopackmanual/{$request["idempresa"]}/fac-pay-{$programaSaludSus["idprograma_salud_suscripcion"]}.pdf");

                $PDFFactura = new PDFFacturaTransferenciaPagoPack();
                $PDFFactura->getPDF($data_variables);

                $managerUsuarioEmpresa = $this->getManager("ManagerUsuarioEmpresa");
                $usuario = $managerUsuarioEmpresa->getByFieldArray(["empresa_idempresa", "contratante"], [$request["idempresa"], "1"]);
                $result = $managerUsuarioEmpresa->sendEmailEmpresaNuevaManual($usuario["idusuario_empresa"]);
                if ($result) {
                    $this->setMsg(["msg" => "Suscripcion exitosa.", "result" => true]);
                    return true;
                } else {
                    $this->setMsg(["msg" => "Error al intentar actualizar el registro.", "result" => false]);
                    return false;
                }
            } else {
                $this->setMsg(["msg" => "Error al intentar actualizar el registro.", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "Ha ocurrido un error. Intente nuevamente", "result" => false]);
            return false;
        }
    }

    /**
     * Método que retorna el PDF con el QR de la invitacion al pass bien-etre
     * @param type $request
     */
    public function getInvitacionPassPDF($request) {
        if (CONTROLLER == "empresa") {
            $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
            $empresa = $this->get($idempresa);
        } else if (CONTROLLER == "frontend_2") {
            $empresa = parent::getByField("hash", $request["hash"]);
        } else {
            return false;
        }

        $data_variables["empresa"] = $empresa;
        $this->generarQRinvitacion($empresa["idempresa"]);

// $this->print_r($data_variables);
//die();
//instanciamos la clase que crea los pdf
        $PDFInvitacionPass = new PDFInvitacionPass();

        $PDFInvitacionPass->getPDF($data_variables);
    }

    public function getInvitacionPassFlayer($request) {
        if (CONTROLLER == "empresa") {
            $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
            $empresa = $this->get($idempresa);
        } else if (CONTROLLER == "frontend_2") {
            $empresa = parent::getByField("hash", $request["hash"]);
        } else {
            return false;
        }


        $data_variables["img"] = "/entities/empresa/" . $idempresa . "/" . $idempresa . "_usuario.jpg";

        $data_variables["empresa"] = $empresa;
        $this->generarQRinvitacion($empresa["idempresa"]);

// $this->print_r($data_variables);
//die();
//instanciamos la clase que crea los pdf
        $PDFInvitacionPass = new PDFFlayrInvitacionPass();

        $PDFInvitacionPass->getPDF($data_variables);
    }

    public function getCuestionarioPassFlayer($request) {
        if (CONTROLLER == "empresa") {
            $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
            $empresa = $this->get($idempresa);
        } else if (CONTROLLER == "frontend_2") {
            $empresa = parent::getByField("hash", $request["hash"]);
        } else {
            return false;
        }
        $managerIn = $this->getManager("ManagerEmpresaInvitacionCuestionario");
        $invitacion = $managerIn->getByField("hash", $request["id"]);
        $cuestionario = $this->getManager("ManagerCuestionario")->get($invitacion["cuestionario_idcuestionario"]);
        $data_variables["cuestionario"] = $cuestionario;
        $data_variables["empresa"] = $empresa;
        $data_variables["hashc"] = $request["id"];
        $data_variables["img"] = "/entities/empresa/" . $idempresa . "/" . $idempresa . "_usuario.jpg";
        $this->generarQRCuestionarioTemp($request["id"]);

        $PDFInvitacionPass = new PDFFlayrCuestionarioPass();

        $PDFInvitacionPass->getPDF($data_variables);
    }

    public function getCuestionarioPassFlayerCapsula($request) {
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
        if (CONTROLLER == "empresa") {
            $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
            $empresa = $this->get($idempresa);
        } else if (CONTROLLER == "frontend_2") {
            $empresa = parent::getByField("hash", $request["hash"]);
        } else {
            return false;
        }
        $managerIn = $this->getManager("ManagerEmpresaInvitacionCapsula");
        $invitacion = $managerIn->getByField("hash", $request["id"]);
        $capsula = $this->getManager("ManagerCapsula")->get($invitacion["capsula_idcapsula"]);
        $data_variables["capsula"] = $capsula;
        $data_variables["empresa"] = $empresa;
        $data_variables["usuario"] = $usuario_empresa;
        $data_variables["hashc"] = $request["id"];
        $data_variables["img"] = "/entities/empresa/" . $idempresa . "/" . $idempresa . "_usuario.jpg";
        $data_variables["24"] = $this->getManager("ManagerTextoAuxiliares")->get('24');
        $data_variables["25"] = $this->getManager("ManagerTextoAuxiliares")->get('25');
        $this->generarQRCapsulaTemp($request["id"], $capsula);

        $PDFInvitacionPass = new PDFFlayrCapsulaPass();

        $PDFInvitacionPass->getPDF($data_variables);
    }

    /**
     *  obtengo el ultimo id de la tabla empresa
     * @return type
     */
    public function getUltimoIdEmpresa() {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setOrderBy("idempresa DESC");
        $query->setLimit("1");
        return $this->db->getRow($query->getSql());
    }

    /**
     * Método que retorna la imagen del paciente
     * @param type $idempresa
     * @return boolean
     */
    public function getImagenEmpresa($idempresa = null) {

        if (strpos(URL_ROOT, "extranet") != "") {

            $URL_ROOT = str_replace("extranet/", "", URL_ROOT);
            $path_file = path_entity_files_main("empresa/$idempresa/$idempresa.jpg");
        } else {

            $path_file = path_entity_files("empresa/$idempresa/$idempresa.jpg");
            $URL_ROOT = URL_ROOT;
        }

        if (is_file($path_file)) {

            $empresa = array(
                "original" => $URL_ROOT . "xframework/files/entities/empresa/$idempresa/{$idempresa}.jpg?" . mktime(),
                "perfil" => $URL_ROOT . "xframework/files/entities/empresa/$idempresa/{$idempresa}_perfil.jpg?" . mktime(),
                "list" => $URL_ROOT . "xframework/files/entities/empresa/$idempresa/{$idempresa}_list.jpg?" . mktime(),
                "usuario" => $URL_ROOT . "xframework/files/entities/empresa/$idempresa/{$idempresa}_usuario.jpg?" . mktime(),
            );


            return $empresa;
        } else {

            return false;
        }
    }

    /**
     * Método utilizado para guardar la imagen cortada por la empresa.
     * Utiliza la librería de jQuery "Cropper"
     * @param type $request
     * @return boolean
     */
    public function cropAndChangeImage($request) {


        $idempresa = $request["idempresa"];

        $managerUsuarioEmpresa = $this->getManager("ManagerUsuarioEmpresa");
        $usuario = $managerUsuarioEmpresa->getByFieldArray("empresa_idempresa", $idempresa);

//Obtengo la imagen que voy a modificar.
        $image_to_copy = path_entity_files("empresa/$idempresa/{$idempresa}_copy.jpg");
        $image = path_entity_files("empresa/$idempresa/$idempresa.jpg");



        if (file_exists($image) && (int) $idempresa > 0) {
            $manImg = new Images();

            $grados = (float) $request["grado"] >= 0 ? (float) $request["grado"] : 360 + (float) $request["grado"];

            $grados = 360 - $grados;

            $rdo = $manImg->resizeCropImg($image, $image_to_copy, $request["width"], $request["height"], $request["left"], $request["top"], $grados, 100);



            if ($rdo) {

                $modify = $this->modifyImgResizeThumb($image_to_copy, $idempresa);

                rename($image_to_copy, $image);

                $modificar_cabecera = $usuario["idusuario_empresa"] != "" ? true : false;

                if ($modify) {


                    $this->setMsg(["msg" => "Se modificó el logo", "result" => true, "imgs" => $this->getImagenes($idempresa), "modificar_cabecera" => $modificar_cabecera]);
                    return $idempresa;
                } else {
                    $this->setMsg(["msg" => "Error, no se pudo actualizar el logo", "result" => false]);
                    return false;
                }
            } else {
                $this->setMsg(["msg" => "Error, no se pudo procesar el logo seleccionado", "result" => false]);
                return false;
            }
        }
        $this->setMsg(["msg" => "Error, no se encontró el logo seleccionado", "result" => false]);
        return false;
    }

    public function crear_pago_factura_pago_cuestionario_por_factura($pago) {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $fecha = date("Y-m-d");
        $this->getManager("ManagerPagoRecompensaEncuesta")->update(["fecha_envio_factura" => $fecha], $pago["idpago_recompensa_encuesta"]);
        $empresa = parent::get($idempresa);
        $data_variables["empresa"] = $empresa;
        $cuestionario = $this->getManager("ManagerCuestionario")->get($pago["cuestionario_idcuestionario"]);
        $data_variables["cuestionario"] = $cuestionario;
        $data_variables["pago"] = $pago;
        $contratante = $this->getManager("ManagerUsuarioEmpresa")->getByFieldArray(["contratante", "empresa_idempresa"], [1, $empresa["idempresa"]]);
        $data_variables["contratante"] = $contratante;
        if ($cuestionario["recompensa"] == '1') {
            $monto = 30 * $cuestionario["cantidad"];
            $precioUn = 30;
        } else {
            $monto = 65 * $cuestionario["cantidad"];
            $precioUn = 65;
        }

        $data_variables["monto"] = $monto;
        $data_variables["precioUn"] = $precioUn;

        if (!file_exists(path_entity_files("facturas_cuestionario/{$pago["empresa_idempresa"]}"))) {
            mkdir(path_entity_files("facturas_cuestionario/{$pago["empresa_idempresa"]}"), 0777, true);
        }
        $data_variables["file"] = path_files("entities/facturas_cuestionario/{$pago["empresa_idempresa"]}/fac-quest-{$pago["idpago_recompensa_encuesta"]}.pdf");


        $PDFRecetaElectronica = new PDFFacturaTransferenciaCuestionario();

        $PDFRecetaElectronica->getPDF($data_variables);
    }

}

//END_class 
?>