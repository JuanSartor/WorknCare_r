<script>
    var modulo = "{$smarty.request.modulo}";
    var submodulo = "{$smarty.request.submodulo}";
</script> 

{literal}
    <script>
        /**Metodo recibido para notificiarle al médico que el paciente está en el consultorio
         *
         */
        socket.on('notificar_paciente_consultorio', function (data) {

            console.log("Ingreso consultorio", data);
            //si estamos en la sala, colocamos alerta en la consulta
            if (submodulo == "videoconsulta_sala_espera") {
                if (data.evento == "ingreso") {
                    $(".paciente-offline").filter("[data-idpaciente=" + data.idpaciente + "]").filter("[data-idvideoconsulta=" + data.idvideoconsulta + "]").hide();
                    $(".paciente-online").filter("[data-idpaciente=" + data.idpaciente + "]").filter("[data-idvideoconsulta=" + data.idvideoconsulta + "]").slideDown();
                    //mostramos notify
                } else {
                    $(".paciente-online").filter("[data-idpaciente=" + data.idpaciente + "]").filter("[data-idvideoconsulta=" + data.idvideoconsulta + "]").hide();
                    $(".paciente-offline").filter("[data-idpaciente=" + data.idpaciente + "]").filter("[data-idvideoconsulta=" + data.idvideoconsulta + "]").slideDown();
                }

            }

            notify({title: data.paciente + " - " + x_translate("Consultorio virtual"), text: x_translate("¡El paciente te está esperando en la sala!"), style: "video-consulta", type: "paciente_consultorio", id: data.idvideoconsulta});


        });


        /**Metodo recibido para notificiarle a los usuarios un evento mediante una noificacion emergente
         *
         */
        socket.on('show_notify', function (data) {
            notify({title: data.title, text: data.text, style: data.style, type: data.type, id: data.id});
        });

        /**Funcion que envia un mensaje al socket del servidor solicitando la cantidad de notificacion
         * 
         * @param {type} data
         * @returns {undefined}
         */
        function actualizar_notificaciones() {
            console.log("actualizar notificaciones");
            //enviamos el evento al socket 
            socket.emit('actualizar_notificaciones', {tipo_usuario: 'medico', idmedico: account.idmedico});

        }
        /** 
         * Metodo que emite un evento al servidor de websockets para obtener el contador de cantidades de consultas
         * @returns {undefined}
         */
        function obtener_contador_videoconsultas_socket() {
            console.log("obtener contador videoconsultas socket");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'panel-medico/obtener_contador_videoconsultas_socket.do',
                    "",
                    function (data) {

                    }
            );

        }

        /** 
         * Metodo que emite un evento al servidor de websockets para obtener el contador de cantidades de consultas
         * @returns {undefined}
         */
        function obtener_contador_consultasexpress_socket() {
            console.log("obtener contador consultasexpress socket");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'panel-medico/obtener_contador_consultasexpress_socket.do',
                    "",
                    function (data) {

                    }
            );

        }


        /**Recepcion del mensaje de cantidad de notificaciones
         * Respuesta a:get_cantidad_notificaciones
         * 
         * @param {type} data
         * @returns {undefined}
         */
        socket.on('notificaciones', function (data) {
            console.log("Notificaciones:", data);
            //actualizamos el contador de notificaciones de los accesos directos
            if ($("#div_shorcuts_cant_notificaciones").length > 0) {
                if (parseInt(data.rows[0].cant_notificaciones) > 0) {
                    $("#paciente-nav-menu-burger #menu-gotmsg").show();
                    $("#div_shorcuts_cant_notificaciones").html("<span>" + data.rows[0].cant_notificaciones + "</span>");

                    //si estamos en la home - actualizamos icono notificaciones
                    if ($("#div_home_cant_notificaciones").length > 0) {
                        $("#div_home_cant_notificaciones").html("<span>" + data.rows[0].cant_notificaciones + "</span>");
                    }

                } else {
                    $("#div_shorcuts_cant_notificaciones").html("");
                    //si estamos en la home - actualizamos icono notificaciones
                    if ($("#div_home_cant_notificaciones").length > 0) {
                        $("#div_home_cant_notificaciones").html("");
                    }
                    //quitamos el alerta del menu si no hay mas notificacion
                    if ($("#div_shorcuts_cant_consultaexpress span").length === 0 && $("#div_shorcuts_cant_videoconsulta span").length === 0) {
                        $("#paciente-nav-menu-burger #menu-gotmsg").hide();
                    }

                }
            }

        });

        /**Mensaje recibido cuando se genera una nueva notificacion hacia el usuario
         * Se acutualiza el contador de notificaciones
         * @param {type} data
         * @returns {undefined}
         */
        socket.on('nueva_notificacion', function (data) {
            console.log("nueva notificacion", data);
            //actualizamos el contador de notificaciones de los accesos directos
            if ($("#div_shorcuts_cant_notificaciones").length > 0) {
                if ($("#div_shorcuts_cant_notificaciones span").length == 0) {
                    $("#paciente-nav-menu-burger #menu-gotmsg").show();
                    $("#div_shorcuts_cant_notificaciones ").html("<span>1</span>");

                    //si estamos en la home - actualizamos icono notificaciones
                    if ($("#div_home_cant_notificaciones").length > 0) {
                        $("#div_home_cant_notificaciones ").html("<span>1</span>");
                    }
                } else {
                    var cant = parseInt($("#div_shorcuts_cant_notificaciones span").html());
                    $("#div_shorcuts_cant_notificaciones span").html(cant + 1);
                    $("#paciente-nav-menu-burger #menu-gotmsg").show();
                    //si estamos en la home - actualizamos icono notificaciones
                    if ($("#div_home_cant_notificaciones").length > 0) {
                        $("#div_home_cant_notificaciones span").html(cant + 1);
                    }
                }
            }

            //si estamos en el modulo de notificaciones actualizamos los listados
            if (modulo == "notificaciones") {
                $("#Main").spin("large");
                x_loadModule("notificaciones", "notificaciones", '', "Main").then(function () {
                    renderUI2();
                });
            }


        });

        //-------------------------------------------------------------------------------------------------------------------------
        //EVENTOS CONSULTA EXPRESS
        //-------------------------------------------------------------------------------------------------------------------------    
        /**Mensaje recibido cuando se crea una nueva consulta express al medico o se cambia el estado a una de sus consultas
         * Se acutualiza el contador de notificaciones
         * @param {type} data
         * @returns {undefined}
         */
        socket.on('cambio_estado_consultaexpress', function (data) {
            console.log('cambio estado consultaexpress', data);
            //actualizamos el contador de consultas express de los accesos directos

            if ($("#div_shorcuts_cant_consultaexpress").length > 0) {
                if (parseInt(data.notificacion_general) > 0) {
                    $("#div_shorcuts_cant_consultaexpress").html("<span>" + data.notificacion_general + "</span>");
                    $("#paciente-nav-menu-burger #menu-gotmsg").show();
                } else {
                    $("#div_shorcuts_cant_consultaexpress").html("");
                    //quitamos el alerta del menu si no hay mas notificacion
                    if ($("#div_shorcuts_cant_videoconsulta span").length === 0 && $("#div_shorcuts_cant_notificaciones span").length === 0) {
                        $("#paciente-nav-menu-burger #menu-gotmsg").hide();
                    }
                }
            }

            //si estamos en la home - actualizamos icono consulta express
            if ($("#div_home_cant_consultaexpress").length > 0) {
                if (parseInt(data.notificacion_general) > 0) {
                    $("#div_home_cant_consultaexpress").html("<span>" + data.notificacion_general + "</span>");
                } else {
                    $("#div_home_cant_consultaexpress").html("");
                }
            }



            //actualizamos la bandeja de entradas de consulta express si se encuentra aqui
            if ($("#div_bandeja_entrada_consultaexpress").length > 0) {
                //abiertas
                if (parseInt(data.abiertas_total) > 0) {
                    if ($("#div_bandeja_entrada_consultaexpress #div_abiertas span").length > 0) {
                        $("#div_bandeja_entrada_consultaexpress #div_abiertas span").html(data.abiertas_total);
                    } else {
                        $("#div_bandeja_entrada_consultaexpress #div_abiertas").append("<span>" + data.abiertas_total + "</span>");
                    }
                } else {
                    $("#div_bandeja_entrada_consultaexpress #div_abiertas span").remove();
                }
                //pendientes
                if (parseInt(data.pendientes) > 0) {
                    if ($("#div_bandeja_entrada_consultaexpress #div_pendientes span").length > 0) {
                        $("#div_bandeja_entrada_consultaexpress #div_pendientes span").html(data.pendientes);
                    } else {
                        $("#div_bandeja_entrada_consultaexpress #div_pendientes").append("<span>" + data.pendientes + "</span>");
                    }
                } else {
                    $("#div_bandeja_entrada_consultaexpress #div_pendientes span").remove();
                }
                //red
                if (parseInt(data.red) > 0) {
                    if ($("#div_bandeja_entrada_consultaexpress #div_red span").length > 0) {
                        $("#div_bandeja_entrada_consultaexpress #div_red span").html(data.red);
                    } else {
                        $("#div_bandeja_entrada_consultaexpress #div_red").append("<span>" + data.red + "</span>");
                    }
                } else {
                    $("#div_bandeja_entrada_consultaexpress #div_red span").remove();
                }
                //finalizadas
                if (parseInt(data.finalizadas) > 0) {
                    if ($("#div_bandeja_entrada_consultaexpress #div_finalizadas span").length > 0) {
                        $("#div_bandeja_entrada_consultaexpress #div_finalizadas span").html(data.finalizadas);
                    } else {
                        $("#div_bandeja_entrada_consultaexpress #div_finalizadas").append("<span>" + data.finalizadas + "</span>");
                    }
                } else {
                    $("#div_bandeja_entrada_consultaexpress #div_finalizadas span").remove();
                }
                //rechazadas
                if (parseInt(data.rechazadas) > 0) {
                    if ($("#div_bandeja_entrada_consultaexpress #div_rechazadas span").length > 0) {
                        $("#div_bandeja_entrada_consultaexpress #div_rechazadas span").html(data.rechazadas);
                    } else {
                        $("#div_bandeja_entrada_consultaexpress #div_rechazadas").append("<span>" + data.rechazadas + "</span>");
                    }
                } else {
                    $("#div_bandeja_entrada_consultaexpress #div_rechazadas span").remove();
                }
                //vencidas
                if (parseInt(data.vencidas) > 0) {
                    if ($("#div_bandeja_entrada_consultaexpress #div_vencidas span").length > 0) {
                        $("#div_bandeja_entrada_consultaexpress #div_vencidas span").html(data.vencidas);
                    } else {
                        $("#div_bandeja_entrada_consultaexpress #div_vencidas").append("<span>" + data.vencidas + "</span>");
                    }
                } else {
                    $("#div_bandeja_entrada_consultaexpress #div_vencidas span").remove();
                }

                var cant_anterior_pendientes_finalizacion = $("#div_pendientes_finalizacion .consultas-finalizadas").length;

                if (data.pendientes_finalizacion != cant_anterior_pendientes_finalizacion) {
                    x_loadModule("consultaexpress", "consultaexpress_pendientes_finalizacion", '', "div_pendientes_finalizacion").then(function () {
                        renderUI2();
                    });

                }
            }

            //MODULO CONSULTAS ABIERTAS
            if (modulo == "consultaexpress" && (submodulo == "consultaexpress_abiertas" || submodulo == "consultaexpress_abiertas_detalle")) {
                console.log(data);
                //si existe el elemento obtengo el numero de consultas que habia antes
                if ($("#cant_consulta_abiertas_total").length > 0) {
                    var cant_anterior = parseInt($("#cant_consulta_abiertas_total").val());
                } else {
                    var cant_anterior = 0;
                }


                if (data.abiertas_total != cant_anterior && submodulo == "consultaexpress_abiertas") {
                    $("#div_consultasexpress_abiertas").spin("large");
                    x_loadModule("consultaexpress", "consultaexpress_abiertas", '', "div_consultasexpress_abiertas").then(function () {
                        renderUI2();
                    });
                }

                //abiertas
                if (parseInt(data.abiertas_total) > 0) {
                    if ($(".ce-ca-consultas-abiertas span").length > 0) {
                        $(".ce-ca-consultas-abiertas span").html(data.abiertas_total);
                    } else {
                        $(".ce-ca-consultas-abiertas").append("<span>" + data.abiertas_total + "</span>");
                    }
                } else {
                    $(".ce-ca-consultas-abiertas span").remove();
                }
            }

            //MODULO CONSULTAS PENDIENTES
            if (modulo == "consultaexpress" && submodulo == "consultaexpress_pendientes") {
                console.log(data);
                //si existe el elemento obtengo el numero de consultas que habia antes
                if ($(".ce-ca-consultas-abiertas span").length > 0) {
                    var cant_anterior = parseInt($(".ce-ca-consultas-abiertas span").html());
                } else {
                    var cant_anterior = 0;
                }

                if (data.pendientes != cant_anterior) {
                    $("#div_consultasexpress_pendientes").spin("large");
                    x_loadModule("consultaexpress", "consultaexpress_pendientes", '', "div_consultasexpress_pendientes").then(function () {
                        renderUI2();
                    });
                }
                //pendientes
                if (parseInt(data.pendientes) > 0) {
                    if ($(".ce-ca-consultas-abiertas span").length > 0) {
                        $(".ce-ca-consultas-abiertas span").html(data.pendientes);
                    } else {
                        $(".ce-ca-consultas-abiertas").append("<span>" + data.pendientes + "</span>");
                    }
                } else {
                    $(".ce-ca-consultas-abiertas span").remove();
                }
            }

            //MODULO CONSULTAS RECHAZADAS
            if (modulo == "consultaexpress" && submodulo == "consultaexpress_rechazadas") {

                //si existe el elemento obtengo el numero de consultas que habia antes
                if ($("#cant_consulta_rechazadas_total").length > 0) {
                    var cant_anterior = parseInt($("#cant_consulta_rechazadas_total").val());
                } else {
                    var cant_anterior = 0;
                }

                if (data.rechazadas_total != cant_anterior) {
                    $("#div_consultasexpress_abiertas").spin("large");
                    x_loadModule("consultaexpress", "consultaexpress_abiertas", '', "div_consultasexpress_abiertas").then(function () {
                        renderUI2();
                    });
                }
                //rechazadas
                if (parseInt(data.rechazadas) > 0) {
                    if ($(".ce-ca-consultas-abiertas span").length > 0) {
                        $(".ce-ca-consultas-abiertas span").html(data.rechazadas);
                    } else {
                        $(".ce-ca-consultas-abiertas").append("<span>" + data.rechazadas + "</span>");
                    }
                } else {
                    $(".ce-ca-consultas-abiertas span").remove();
                }
            }

            //MODULO CONSULTAS FINALZADAS
            if (modulo == "consultaexpress" && submodulo == "consultaexpress_finalizadas") {

                //si existe el elemento obtengo el numero de consultas que habia antes
                if ($("#cant_consulta_finalizadas_total").length > 0) {
                    var cant_anterior = parseInt($("#cant_consulta_finalizadas_total").val());
                } else {
                    var cant_anterior = 0;
                }

                if (data.finalizadas_total != cant_anterior) {
                    $("#div_consultasexpress_finalizadas").spin("large");
                    x_loadModule("consultaexpress", "consultaexpress_finalizadas", '', "div_consultasexpress_finalizadas").then(function () {
                        renderUI2();
                    });
                }
                //finalizadas
                if (parseInt(data.finalizadas) > 0) {
                    if ($(".ce-ca-consultas-abiertas span").length > 0) {
                        $(".ce-ca-consultas-abiertas span").html(data.finalizadas);
                    } else {
                        $(".ce-ca-consultas-abiertas").append("<span>" + data.finalizadas + "</span>");
                    }
                } else {
                    $(".ce-ca-consultas-abiertas span").remove();
                }
            }

            //MODULO CONSULTAS VENCIDAS
            if (modulo == "consultaexpress" && (submodulo == "consultaexpress_vencidas" || submodulo == "consultaexpress_vencidas_detalle")) {

                //si existe el elemento obtengo el numero de consultas que habia antes
                if ($("#cant_consulta_vencidas_total").length > 0) {
                    var cant_anterior = parseInt($("#cant_consulta_vencidas_total").val());
                } else {
                    var cant_anterior = 0;
                }

                if (data.vencidas_total != cant_anterior) {
                    $("#div_consultasexpress_vencidas").spin("large");
                    x_loadModule("consultaexpress", "consultaexpress_vencidas", '', "div_consultasexpress_vencidas").then(function () {
                        renderUI2();
                    });
                }
                //abiertas
                if (parseInt(data.vencidas) > 0) {
                    if ($(".ce-ca-consultas-abiertas span").length > 0) {
                        $(".ce-ca-consultas-abiertas span").html(data.vencidas);
                    } else {
                        $(".ce-ca-consultas-abiertas").append("<span>" + data.vencidas + "</span>");
                    }
                } else {
                    $(".ce-ca-consultas-abiertas span").remove();
                }
            }




        });

        /**Mensaje recibido cuando se crea una nueva consulta express de la especialiad del medico
         *  o se cambia el estado a una de las consulta en la red
         * Se acutualiza el contador de notificaciones
         * @param {type} data
         * @returns {undefined}
         */
        socket.on('cambio_estado_consultaexpress_red', function (data) {
            console.log('cambio estado consultaexpress red', data);
            //si la consulta es de mi especialidad, actualizo el contador si estoy en la bandeja de entrada
            if (data.idespecialidad == account.idespecialidad) {
                //si es de mi especialidad actualizo el contador
                obtener_contador_consultasexpress_socket();

                if (modulo == "consultaexpress" && submodulo == "bandeja_entrada") {

                    if (parseInt(data.cantidad) > 0) {
                        if ($("#div_red span").length > 0) {
                            $("#div_red span").html(data.cantidad);
                        } else {
                            $("#div_red").append("<span>" + data.cantidad + "</span>");
                        }
                    } else {
                        $("#div_red span").remove();
                    }
                }

            }
            if (modulo == "consultaexpress" && submodulo == "consultaexpress_red") {
                //verificamos si estoy en el modulos de consultas de la especialidad de la nueva consulta
                if ($(".ceprr-mi-especialidad-header").data("idespecialidad") == data.idespecialidad) {
                    var idespecialidad_seleccionada = parseInt($(".ceprr-mi-especialidad-header").data("idespecialidad"));

                    if ($(".ceprr-mi-especialidad-header figure").length == 0) {
                        var cant_consultas_seleccionada = 0;
                    } else {
                        var cant_consultas_seleccionada = parseInt($(".ceprr-mi-especialidad-header figure").html());
                    }


                    //si cambian las cantidades actualizo el contador

                    if (cant_consultas_seleccionada != data.cantidad) {

                        //si no existia el contador lo inserto
                        if (cant_consultas_seleccionada == 0) {
                            $(".ceprr-mi-especialidad-header a:last").after($("<figure>" + data.cantidad + "</figure>"));
                        } else {
                            //sino actualizo su valor
                            $("#div-especialidad-tags figure").html(data.cantidad);
                        }

                    }

                    //si hay una nueva actualizo el listado
                    if (parseInt(data.cantidad) != cant_consultas_seleccionada) {
                        $("#div_consultasexpress_red").spin("large");
                        x_loadModule("consultaexpress", "consultaexpress_red", '', "div_consultasexpress_red").then(function () {
                            renderUI2();
                        });

                    }

                }

                //actualizamos el modulo del contador
                $("#div_consultaexpress_red_contador").spin("large");
                x_loadModule("consultaexpress", "consultaexpress_red_contador", "", "div_consultaexpress_red_contador", BASE_PATH + "medico").then(function () {
                    renderUI2();
                });

            }
        });
        //-------------------------------------------------------------------------------------------------------------------------
        //EVENTOS VIDEOCONSULTA
        //-------------------------------------------------------------------------------------------------------------------------

        /**Mensaje recibido cuando se crea una nueva video consulta al medico o se cambia el estado a una de sus consultas
         * Se acutualiza el contador de notificaciones
         * @param {type} data
         * @returns {undefined}
         */
        socket.on('cambio_estado_videoconsulta', function (data) {
            console.log("cambio estado videoconsulta", data);
            //actualizamos el contador de videoconsulta de los accesos directos
            if ($("#div_shorcuts_cant_videoconsulta").length > 0) {
                if (parseInt(data.notificacion_general) > 0) {
                    $("#div_shorcuts_cant_videoconsulta").html("<span>" + data.notificacion_general + "</span>");
                    $("#paciente-nav-menu-burger #menu-gotmsg").show();
                } else {
                    $("#div_shorcuts_cant_videoconsulta").html("");
                    //quitamos el alerta del menu si no hay mas notificacion
                    if ($("#div_shorcuts_cant_consultaexpress span").length === 0 && $("#div_shorcuts_cant_notificaciones span").length === 0) {
                        $("#paciente-nav-menu-burger #menu-gotmsg").hide();
                    }
                }
            }
            //si estamos en la home - actualizamos icono notificaciones
            if ($("#div_home_cant_videoconsulta").length > 0) {
                if (parseInt(data.notificacion_general) > 0) {
                    $("#div_home_cant_videoconsulta").html("<span>" + data.notificacion_general + "</span>");
                } else {
                    $("#div_home_cant_videoconsulta").html("");
                }
            }


            //actualizamos la bandeja de entradas de video consulta si se encuentra aqui
            if ($("#div_bandeja_entrada_videoconsulta").length > 0) {
                //abiertas
                if (parseInt(data.abiertas_total) > 0) {
                    if ($("#div_bandeja_entrada_videoconsulta #div_abiertas span").length > 0) {
                        $("#div_bandeja_entrada_videoconsulta #div_abiertas span").html(data.abiertas_total);
                    } else {
                        $("#div_bandeja_entrada_videoconsulta #div_abiertas").append("<span>" + data.abiertas_total + "</span>");
                    }
                } else {
                    $("#div_bandeja_entrada_videoconsulta #div_abiertas span").remove();
                }
                //pendientes
                if (parseInt(data.pendientes) > 0) {
                    if ($("#div_bandeja_entrada_videoconsulta #div_pendientes span").length > 0) {
                        $("#div_bandeja_entrada_videoconsulta #div_pendientes span").html(data.pendientes);
                    } else {
                        $("#div_bandeja_entrada_videoconsulta #div_pendientes").append("<span>" + data.pendientes + "</span>");
                    }
                } else {
                    $("#div_bandeja_entrada_videoconsulta #div_pendientes span").remove();
                }
                //red
                if (parseInt(data.red) > 0) {
                    if ($("#div_bandeja_entrada_videoconsulta #div_red span").length > 0) {
                        $("#div_bandeja_entrada_videoconsulta #div_red span").html(data.red);
                    } else {
                        $("#div_bandeja_entrada_videoconsulta #div_red").append("<span>" + data.red + "</span>");
                    }
                } else {
                    $("#div_bandeja_entrada_videoconsulta #div_red span").remove();
                }
                //finalizadas
                if (parseInt(data.finalizadas) > 0) {
                    if ($("#div_bandeja_entrada_videoconsulta #div_finalizadas span").length > 0) {
                        $("#div_bandeja_entrada_videoconsulta #div_finalizadas span").html(data.finalizadas);
                    } else {
                        $("#div_bandeja_entrada_videoconsulta #div_finalizadas").append("<span>" + data.finalizadas + "</span>");
                    }
                } else {
                    $("#div_bandeja_entrada_videoconsulta #div_finalizadas span").remove();
                }
                //rechazadas
                if (parseInt(data.rechazadas) > 0) {
                    if ($("#div_bandeja_entrada_videoconsulta #div_rechazadas span").length > 0) {
                        $("#div_bandeja_entrada_videoconsulta #div_rechazadas span").html(data.rechazadas);
                    } else {
                        $("#div_bandeja_entrada_videoconsulta #div_rechazadas").append("<span>" + data.rechazadas + "</span>");
                    }
                } else {
                    $("#div_bandeja_entrada_videoconsulta #div_rechazadas span").remove();
                }
                //vencidas
                if (parseInt(data.vencidas) > 0) {
                    if ($("#div_bandeja_entrada_videoconsulta #div_vencidas span").length > 0) {
                        $("#div_bandeja_entrada_videoconsulta #div_vencidas span").html(data.vencidas);
                    } else {
                        $("#div_bandeja_entrada_videoconsulta #div_vencidas").append("<span>" + data.vencidas + "</span>");
                    }
                } else {
                    $("#div_bandeja_entrada_videoconsulta #div_vencidas span").remove();
                }

                //

                var cant_anterior_pendientes_finalizacion = $("#div_pendientes_finalizacion .consultas-finalizadas").length;

                if (data.pendientes_finalizacion != cant_anterior_pendientes_finalizacion) {
                    x_loadModule("videoconsulta", "videoconsulta_pendientes_finalizacion", '', "div_pendientes_finalizacion").then(function () {
                        renderUI2();
                    });
                    x_loadModule("videoconsulta", "videoconsulta_interrumpidas", '', "div_interrumpidas").then(function () {
                        renderUI2();
                    });

                }
            }

            //MODULO CONSULTAS SALA ESPERA
            if (modulo == "videoconsulta" && (submodulo == "videoconsulta_sala_espera")) {

                //si existe el elemento obtengo el numero de consultas que habia antes
                if ($("#cant_consulta_abiertas_total").length > 0) {
                    var cant_anterior = parseInt($("#cant_consulta_abiertas_total").val());
                } else {
                    var cant_anterior = 0;
                }

                if (data.abiertas_total != cant_anterior) {
                    $("#div_videoconsulta_espera").spin("large");
                    x_loadModule("videoconsulta", "videoconsulta_sala_espera", '', "div_videoconsulta_espera").then(function () {
                        renderUI2();
                    });

                }
                //abiertas
                if (parseInt(data.abiertas_total) > 0) {
                    if ($(".ce-ca-consultas-abiertas span").length > 0) {
                        $(".ce-ca-consultas-abiertas span").html(data.abiertas_total);
                    } else {
                        $(".ce-ca-consultas-abiertas").append("<span>" + data.abiertas_total + "</span>");
                    }
                } else {
                    $(".ce-ca-consultas-abiertas span").remove();
                }
            }

            //MODULO CONSULTAS PENDIENTES
            if (modulo == "videoconsulta" && submodulo == "videoconsulta_pendientes") {

                //si existe el elemento obtengo el numero de consultas que habia antes
                if ($(".ce-ca-consultas-abiertas span").length > 0) {
                    var cant_anterior = parseInt($(".ce-ca-consultas-abiertas span").html());
                } else {
                    var cant_anterior = 0;
                }

                if (data.pendientes != cant_anterior) {
                    $("#div_videoconsulta_pendientes").spin("large");
                    x_loadModule("videoconsulta", "videoconsulta_pendientes", '', "div_videoconsulta_pendientes").then(function () {
                        renderUI2();
                    });
                }
                //pendientes
                if (parseInt(data.pendientes) > 0) {
                    if ($(".ce-ca-consultas-abiertas span").length > 0) {
                        $(".ce-ca-consultas-abiertas span").html(data.pendientes);
                    } else {
                        $(".ce-ca-consultas-abiertas").append("<span>" + data.pendientes + "</span>");
                    }
                } else {
                    $(".ce-ca-consultas-abiertas span").remove();
                }
            }

            //MODULO CONSULTAS RECHAZADAS
            if (modulo == "videoconsulta" && submodulo == "videoconsulta_rechazadas") {

                //si existe el elemento obtengo el numero de consultas que habia antes
                if ($("#cant_consulta_rechazadas_total").length > 0) {
                    var cant_anterior = parseInt($("#cant_consulta_rechazadas_total").val());
                } else {
                    var cant_anterior = 0;
                }

                if (data.rechazadas_total != cant_anterior) {
                    $("#div_videoconsulta_rechazadas").spin("large");
                    x_loadModule("videoconsulta", "videoconsulta_rechazadas", '', "div_videoconsulta_rechazadas").then(function () {
                        renderUI2();
                    });
                }
                //rechazadas
                if (parseInt(data.rechazadas) > 0) {
                    if ($(".ce-ca-consultas-abiertas span").length > 0) {
                        $(".ce-ca-consultas-abiertas span").html(data.rechazadas);
                    } else {
                        $(".ce-ca-consultas-abiertas").append("<span>" + data.rechazadas + "</span>");
                    }
                } else {
                    $(".ce-ca-consultas-abiertas span").remove();
                }
            }

            //MODULO CONSULTAS FINALZADAS
            if (modulo == "videoconsulta" && submodulo == "videoconsulta_finalizadas") {

                //si existe el elemento obtengo el numero de consultas que habia antes
                if ($("#cant_consulta_finalizadas_total").length > 0) {
                    var cant_anterior = parseInt($("#cant_consulta_finalizadas_total").val());
                } else {
                    var cant_anterior = 0;
                }

                if (data.finalizadas_total != cant_anterior) {
                    $("#div_videoconsulta_finalizadas").spin("large");
                    x_loadModule("videoconsulta", "videoconsulta_finalizadas", '', "div_videoconsulta_finalizadas").then(function () {
                        renderUI2();
                    });
                }
                //finalizadas
                if (parseInt(data.finalizadas) > 0) {
                    if ($(".ce-ca-consultas-abiertas span").length > 0) {
                        $(".ce-ca-consultas-abiertas span").html(data.finalizadas);
                    } else {
                        $(".ce-ca-consultas-abiertas").append("<span>" + data.finalizadas + "</span>");
                    }
                } else {
                    $(".ce-ca-consultas-abiertas span").remove();
                }
            }

            //MODULO CONSULTAS VENCIDAS
            if (modulo == "videoconsulta" && (submodulo == "videoconsulta_vencidas")) {

                //si existe el elemento obtengo el numero de consultas que habia antes
                if ($("#cant_consulta_vencidas_total").length > 0) {
                    var cant_anterior = parseInt($("#cant_consulta_vencidas_total").val());
                } else {
                    var cant_anterior = 0;
                }

                if (data.vencidas_total != cant_anterior) {
                    $("#div_videoconsulta_vencidas").spin("large");
                    x_loadModule("videoconsulta", "videoconsulta_vencidas", '', "div_videoconsulta_vencidas").then(function () {
                        renderUI2();
                    });
                }
                //abiertas
                if (parseInt(data.vencidas) > 0) {
                    if ($(".ce-ca-consultas-abiertas span").length > 0) {
                        $(".ce-ca-consultas-abiertas span").html(data.vencidas);
                    } else {
                        $(".ce-ca-consultas-abiertas").append("<span>" + data.vencidas + "</span>");
                    }
                } else {
                    $(".ce-ca-consultas-abiertas span").remove();
                }
            }




        });
        /**Evento recibido del servidor cuando se acepta una videoconsulta o inicia la sala, para marcar el consultorio virtual activo
         * 
         * @param {type} data
         * @returns {undefined}
         */
        socket.on('habilitar_consultorio_virtual', function (data) {
            console.log(data);
            if ($("#div_bandeja_entrada_videoconsulta").length > 0 || $("#home-iconos-container").length > 0) {
                if (data.mostrar == 1) {
                    $(".mvc-entrar-sala").show();
                } else {
                    $(".mvc-entrar-sala").hide();
                }

            }
        });


        /**Mensaje recibido cuando se crea una nueva consulta express de la especialiad del medico
         *  o se cambia el estado a una de las consulta en la red
         * Se acutualiza el contador de notificaciones
         * @param {type} data
         * @returns {undefined}
         */
        socket.on('cambio_estado_videoconsulta_red', function (data) {
            console.log("cambio estado videoconsulta red:", data);
            //si la consulta es de mi especialidad, actualizo el contador si estoy en la bandeja de entrada
            if (data.idespecialidad == account.idespecialidad) {

                //si es de mi especialidad actualizo el contador
                obtener_contador_videoconsultas_socket();

                if (modulo == "videoconsulta" && submodulo == "bandeja_entrada") {

                    if (parseInt(data.cantidad) > 0) {
                        if ($("#div_red span").length > 0) {
                            $("#div_red span").html(data.cantidad);
                        } else {
                            $("#div_red").append("<span>" + data.cantidad + "</span>");
                        }
                    } else {
                        $("#div_red span").remove();
                    }
                }
            }
            if (modulo == "videoconsulta" && submodulo == "videoconsulta_red") {
                //verificamos si estoy en el modulos de consultas de la especialidad de la nueva consulta
                if ($(".ceprr-mi-especialidad-header").data("idespecialidad") == data.idespecialidad) {
                    var idespecialidad_seleccionada = parseInt($(".ceprr-mi-especialidad-header").data("idespecialidad"));

                    if ($(".ceprr-mi-especialidad-header figure").length == 0) {
                        var cant_consultas_seleccionada = 0;
                    } else {
                        var cant_consultas_seleccionada = parseInt($(".ceprr-mi-especialidad-header figure").html());
                    }


                    //si cambian las cantidades actualizo el contador

                    if (cant_consultas_seleccionada != data.cantidad) {

                        //si no existia el contador lo inserto
                        if (cant_consultas_seleccionada == 0) {
                            $(".ceprr-mi-especialidad-header a:last").after($("<figure>" + data.cantidad + "</figure>"));
                        } else {
                            //sino actualizo su valor
                            $("#div-especialidad-tags figure").html(data.cantidad);
                        }

                    }

                    //si hay una nueva actualizo el listado
                    if (parseInt(data.cantidad) != cant_consultas_seleccionada) {
                        $("#div_videoconsulta_red").spin("large");
                        x_loadModule("videoconsulta", "videoconsulta_red", '', "div_videoconsulta_red").then(function () {
                            renderUI2();
                        });

                    }

                }

                //actualizamos el modulo del contador
                $("#div_videoconsulta_red_contador").spin("large");
                x_loadModule("videoconsulta", "videoconsulta_red_contador", "", "div_videoconsulta_red_contador", BASE_PATH + "medico").then(function () {
                    renderUI2();
                });

            }
        });

    </script>
{/literal}