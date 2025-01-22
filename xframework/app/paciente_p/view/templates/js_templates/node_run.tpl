<script>
    var modulo = "{$smarty.request.modulo}";
    var submodulo = "{$smarty.request.submodulo}";
</script> 

{literal}
    <script language="javascript" type="text/javascript" >

        /**Metodo que verifica si el evento entrante corresponde al paciente seleccionado,
         *  sino marca una alerta intermitente
         * 
         * 
         * @param {type} idpaciente
         * @returns {undefined}
         */
        function alertar_notificacion_paciente_no_seleccionado(requerimiento) {
            
            if ($("#filtro").val() == requerimiento) {

                return false;
            } else {

                var idpaciente = $(".a_miembro[data-requerimiento='" + requerimiento + "']").data("id");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "get_notificaciones_menu_p.do",
                        "idpaciente=" + idpaciente,
                        function (data) {

                            if (data.cant_total > 0) {
                                if ($("#header_miembros_select .a_miembro[data-id='" + idpaciente + "']").find("span.notificacion").length > 0) {
                                    $("#header_miembros_select .a_miembro[data-id='" + idpaciente + "']").find("span.notificacion").html(data.cant_total);
                                } else {
                                    $("#header_miembros_select .a_miembro[data-id='" + idpaciente + "']").find("figure").after($("<span class='notificacion'>" + data.cant_total + "</span>"));
                                }
                            } else {
                                $("#header_miembros_select .a_miembro[data-id='" + idpaciente + "']").find("span.notificacion").remove();
                            }
                            //ocultamos el icono de notificacion flotante
                            if ($("#header_miembros_select .perfil-dropdown .a_miembro a").not(".miembro_seleccionado").find("span.notificacion").length > 0) {
                                $("#paciente-gotmsg").slideDown();
                            } else {
                                $("#paciente-gotmsg").slideUp();
                            }

                        }
                );

                return true;
            }
        }

        /**Funcion que envia un mensaje al socket del servidor solicitando la cantidad de notificacion
         * 
         * @param {type} data
         * @returns {undefined}
         */
        function actualizar_notificaciones(id) {

            if (typeof id == "undefined") {

                var id_paciente = account.idpaciente;
            } else {

                var id_paciente = id;
            }

            //enviamos el evento al socket 
            socket.emit('actualizar_notificaciones', {tipo_usuario: 'paciente', idpaciente: id_paciente});

        }

        /**Metodo recibido para notificiarle a los usuarios un evento mediante una noificacion emergente
         *
         */
        socket.on('show_notify', function (data) {

            console.log("notify");
            console.log("data", data);
            notify({title: data.title, text: data.text, style: data.style, type: data.type, id: data.id});
        });

        /**Recepcion del mensaje de cantidad de notificaciones
         * Respuesta a:get_cantidad_notificaciones
         * 
         * @param {type} data
         * @returns {undefined}
         */
        socket.on('notificaciones', function (data) {

            console.log("Notificaciones:", data);
            if (alertar_notificacion_paciente_no_seleccionado(data.idpaciente)) {
                return true;

            } else {



                if ($("#div_shorcuts_cant_notificaciones").length > 0) {
                    if (parseInt(data.rows[0].cant_notificaciones) > 0) {
                        $("#div_shorcuts_cant_notificaciones").html("<span>" + data.rows[0].cant_notificaciones + "</span>");
                        $("#paciente-nav-menu-burger #menu-gotmsg").show();
                        //si estamos en la home - actualizamos icono notificaciones
                        if ($("#div_home_cant_notificaciones").length > 0) {
                            $("#div_home_cant_notificaciones").html("<span>" + data.rows[0].cant_notificaciones + "</span>");
                        }

                    } else {
                        $("#div_shorcuts_cant_notificaciones").html("");
                        //quitamos el alerta del menu si no hay mas notificacion
                        if ($("#div_shorcuts_cant_consultaexpress span").length === 0 && $("#div_shorcuts_cant_videoconsulta span").length === 0) {
                            $("#paciente-nav-menu-burger #menu-gotmsg").hide();
                        }
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
            console.log("nueva_notificacion", data);
            if (alertar_notificacion_paciente_no_seleccionado(data.idpaciente)) {
                return true;
            }
            //actualizamos el contador de notificaciones de los accesos directos
            if ($("#div_shorcuts_cant_notificaciones").length > 0) {

                $("#paciente-nav-menu-burger #menu-gotmsg").show();
                if ($("#div_shorcuts_cant_notificaciones span").length == 0) {
                    $("#div_shorcuts_cant_notificaciones ").html("<span>1</span>");
                    //si estamos en la home - actualizamos icono notificaciones
                    if ($("#div_home_cant_notificaciones").length > 0) {
                        $("#div_home_cant_notificaciones ").html("<span>1</span>");
                    }
                } else {
                    var cant = parseInt($("#div_shorcuts_cant_notificaciones span").html());
                    $("#div_shorcuts_cant_notificaciones span").html(cant + 1);
                    //si estamos en la home - actualizamos icono notificaciones
                    if ($("#div_home_cant_notificaciones").length > 0) {
                        $("#div_home_cant_notificaciones span").html(cant + 1);
                    }

                }
            }


            if ($("#div_shorcuts_cant_notificaciones").length > 0) {
                if ($("#div_shorcuts_cant_notificaciones span").length == 0) {
                    $("#div_shorcuts_cant_notificaciones ").append("<span>1</span>");
                } else {
                    var cant = parseInt($("#div_shorcuts_cant_notificaciones span").html());
                    $("#div_shorcuts_cant_notificaciones span").html(cant + 1);
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

        /**Mensaje recibido cuando se cambia el estado a una de sus consultas express
         * Se acutualiza el contador de notificaciones
         * @param {type} data
         * @returns {undefined}
         */
        socket.on('cambio_estado_consultaexpress', function (data) {
            console.log(data);
            console.log("cambio_estado_consultaexpress");
            if (alertar_notificacion_paciente_no_seleccionado(data.idpaciente)) {
                return true;
            }


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

            //si estamos en el modulo de consulta expres, actualizamos los contadores
            if (modulo == "consultaexpress" && submodulo == "bandeja_entrada") {


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

                if (data.abiertas_total != cant_anterior) {
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
                    $("#div_consultasexpress_rechazadas").spin("large");
                    x_loadModule("consultaexpress", "consultaexpress_rechazadas", '', "div_consultasexpress_rechazadas").then(function () {
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

                if (data.vencidas_total != cant_anterior && submodulo == "consultaexpress_vencidas") {
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



        /**Mensaje recibido cuando se crea una nueva video consulta al medico o se cambia el estado a una de sus consultas
         * Se acutualiza el contador de notificaciones
         * @param {type} data
         * @returns {undefined}
         */
        socket.on('cambio_estado_videoconsulta', function (data) {
            console.log(data);
            console.log("cambio_estado_videoconsulta");
            if (alertar_notificacion_paciente_no_seleccionado(data.idpaciente)) {
                return true;
            }

            //actualizamos el contador de consultas express de los accesos directos

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
                    if ($("#div_bandeja_entrada_videoconsulta #div_abiertas span:not(.mvc-entrar-sala)").length > 0) {
                        $("#div_bandeja_entrada_videoconsulta #div_abiertas span:not(.mvc-entrar-sala)").html(data.abiertas_total);
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
         * o cuando se ha cambiado el estado y deja de estar disponible el consultorio virtual para desmarcarlo
         * 
         * @param {type} data
         * @returns {undefined}
         */
        socket.on('habilitar_consultorio_virtual', function (data) {
            console.log("habilitar_consultorio_virtual");
            if (alertar_notificacion_paciente_no_seleccionado(data.idpaciente)) {
                return true;
            }
            console.log(data);
            if ($("#div_bandeja_entrada_videoconsulta").length > 0 || $("#home-iconos-container").length > 0) {
                if (data.mostrar == 1) {
                    $(".mvc-entrar-sala").show();
                } else {
                    $(".mvc-entrar-sala").hide();
                }

            }
        });

    </script>
{/literal}

{if $smarty.request.modulo=="home" && $smarty.request.submodulo=="home_new"}
    {literal}
        <script language="javascript" type="text/javascript" >
            /**Mensaje recibido cuando se confirma un nuevo turno al paciente
             * Se acutualiza el contador de turnos en la home_new y se recarga el listado de turnos
             * @param {type} data
             * @returns {undefined}
             */
            socket.on('cambio_estado_turno', function (data) {
                console.log("cambio_estado_turno");
                if (alertar_notificacion_paciente_no_seleccionado(data.idpaciente)) {
                    return true;
                }
                //actualizamos el contador de turnos de home_new
                if ($("#cant_turnos_home_new").length > 0) {
                    if (parseInt(data.rows[0].cant) > 0) {
                        if ($("#cant_turnos_home_new span").length == 0) {
                            $("#cant_turnos_home_new ").append("<span>" + data.rows[0].cant + "</span>");
                        } else {
                            var cant = parseInt($("#cant_turnos_home_new span").html());
                            $("#cant_turnos_home_new span").html(data.rows[0].cant);
                        }
                    } else {
                        $("#cant_turnos_home_new span").remove();
                    }

                }
                $("#div_listado_turnos").spin("large");
                x_loadModule('home', 'home_new_turnos', '', 'div_listado_turnos', BASE_PATH + 'paciente_p').then(function () {
                    renderUI2();
                });


            });
        </script>
    {/literal}
{/if}
