% ============================================================
% INTERFAZ GRAFICA - XPCE/PCE  v3.0
% Compatible con SWI-Prolog 7.x
%
% MEJORAS v3.0:
%   - Banner renovado: titulo, autor y curso en fuentes XPCE
%   - Tres botones: Iniciar Diagnostico / Ver Historial / Salir
%   - Colores por boton: verde / naranja / rojo
%   - Area de resultado scrollable (editor solo lectura)
%   - Historial de diagnosticos de la sesion
%   - Auto-carga al consultar main.pl
% ============================================================

% ------------------------------------------------------------
% ICONOS POR CATEGORIA
% Mapea cada categoria a su archivo de imagen en img/
% Si el archivo no existe, mostrar_icono/4 no hace nada (sin error)
% ------------------------------------------------------------
icono_categoria(bienvenida,  'img/auto.png').
icono_categoria(motor,       'img/motor.png').
icono_categoria(suspension,  'img/suspension.png').
icono_categoria(electrico,   'img/electrico.png').
icono_categoria(frenos,      'img/frenos.png').
icono_categoria(computadora, 'img/computadora.png').
icono_categoria(bocinas,     'img/bocinas.png').

% Muestra una imagen si el archivo existe, silencioso si no
mostrar_icono(Ventana, Categoria, X, Y) :-
    icono_categoria(Categoria, Ruta),
    (   exists_file(Ruta)
    ->  new(BM, bitmap(Ruta)),
        send(Ventana, display, BM, point(X, Y))
    ;   true
    ).

% ------------------------------------------------------------
% PANTALLA PRINCIPAL  v3.0
% Identidad: Diego Estrada | Programacion / Inteligencia Artificial
%
% BUG CORREGIDO: guard de re-entrada para objetos globales XPCE.
% new(@nombre, ...) lanza error si el objeto ya existe en el store.
% Se liberan con catch/3 antes de recrearlos.
% ------------------------------------------------------------
iniciar :-
    % --- Liberar globals previos si ya existen (re-entrada segura) ---
    catch(send(@boton,      free), _, true),
    catch(send(@contador,   free), _, true),
    catch(send(@respl,      free), _, true),
    catch(send(@texto,      free), _, true),
    catch(send(@main_window,free), _, true),

    new(@main_window, dialog(
        'Sistema Experto - Diagnostico Automotriz',
        size(860, 680)
    )),
    send(@main_window, background, colour(white)),

    % --- Banner superior con fondo azul oscuro ---
    new(BannerDev, device),
    new(BannerBg, box(818, 95)),
    send(BannerBg, fill_pattern, colour(navy)),
    send(BannerBg, pen, 0),

    new(TituloGrf, text('Sistema Experto de Diagnostico Automotriz')),
    send(TituloGrf, font, font(helvetica, bold, 18)),
    send(TituloGrf, colour, colour(white)),

    new(AutorGrf, text('Autor: Diego Estrada')),
    send(AutorGrf, font, font(helvetica, bold, 11)),
    send(AutorGrf, colour, colour(yellow)),

    new(CursoGrf, text('Curso: Programacion / Inteligencia Artificial')),
    send(CursoGrf, font, font(helvetica, italic, 11)),
    send(CursoGrf, colour, colour(grey)),

    send(BannerDev, display, BannerBg,   point(0,  0)),
    send(BannerDev, display, TituloGrf,  point(55, 10)),
    send(BannerDev, display, AutorGrf,   point(55, 48)),
    send(BannerDev, display, CursoGrf,   point(55, 68)),
    send(@main_window, display, BannerDev, point(20, 10)),

    % --- Imagen de bienvenida (esquina del banner) ---
    mostrar_icono(@main_window, bienvenida, 750, 18),

    % --- Linea separadora ---
    new(Linea, line(0, 0, 818, 0)),
    send(Linea, pen, 2),
    send(Linea, colour, colour(navy)),
    send(@main_window, display, Linea, point(20, 115)),

    % --- Label de estado ---
    new(@texto, label(instruccion,
        'Bienvenido. Presione "Iniciar Diagnostico" para comenzar.')),
    send(@texto, font, font(helvetica, bold, 12)),
    send(@texto, colour, colour(navy)),

    % --- Label titulo area de resultado ---
    new(LblRes, label(lbl_res, 'RESULTADO DEL DIAGNOSTICO:')),
    send(LblRes, font, font(helvetica, bold, 11)),
    send(LblRes, colour, colour(navy)),

    % --- Editor scrollable de resultado (solo lectura) ---
    new(@respl, editor),
    send(@respl, size, size(818, 280)),
    send(@respl, editable, @off),
    send(@respl, font, font(courier, normal, 11)),

    % --- Boton: Iniciar Diagnostico (verde) ---
    new(@boton, button(
        'Iniciar Diagnostico',
        message(@prolog, botones)
    )),
    send(@boton, background, colour(green)),

    % --- Boton: Ver Historial (naranja) ---
    new(BtnHistorial, button(
        'Ver Historial',
        message(@prolog, ver_historial)
    )),
    send(BtnHistorial, background, colour(orange)),

    % --- Boton: Exportar a TXT (azul) ---
    new(BtnExportar, button(
        'Exportar TXT',
        message(@prolog, exportar_historial)
    )),
    send(BtnExportar, background, colour(blue)),

    % --- Boton: Salir (rojo) ---
    new(Salir, button(
        'Salir',
        and(message(@main_window, destroy), message(@main_window, free))
    )),
    send(Salir, background, colour(red)),

    % --- Contador de diagnosticos ---
    new(@contador, label(contador, 'Diagnosticos realizados: 0')),
    send(@contador, font, font(helvetica, bold, 11)),
    send(@contador, colour, colour(darkgreen)),

    % --- Posicionamiento ---
    send(@main_window, display, @texto,       point(30,  127)),
    send(@main_window, display, @contador,    point(600, 127)),
    send(@main_window, display, LblRes,       point(30,  162)),
    send(@main_window, display, @respl,       point(20,  185)),
    send(@main_window, display, @boton,       point(60,  618)),
    send(@main_window, display, BtnHistorial, point(250, 618)),
    send(@main_window, display, BtnExportar,  point(420, 618)),
    send(@main_window, display, Salir,        point(590, 618)),

    send(@main_window, open_centered).


% ------------------------------------------------------------
% PROCESO PRINCIPAL DE DIAGNOSTICO
%
% BUG CORREGIDO: se eliminó send(@boton, free) desde dentro del
% callback del propio boton. En XPCE esto corrompe el event loop
% y aborta la ejecucion antes de llegar a fallas/1, por eso no
% aparecia ninguna ventana emergente.
% ------------------------------------------------------------
botones :-
    catch(lim, _, true),
    fallas(Falla),
    guardar_historial(Falla),
    % --- Actualizar contador (findall+length evita dependencia de library(aggregate)) ---
    findall(_, historial(_), ListaH), length(ListaH, N),
    atomic_list_concat(['Diagnosticos realizados: ', N], LblContador),
    send(@contador, selection, LblContador),
    send(@texto, selection('Diagnostico completado. Puede iniciar uno nuevo.')),
    catch(
        (get(@respl, text_buffer, TB), send(TB, string, Falla)),
        _,
        send(@respl, contents, Falla)
    ),
    limpiar.

% ------------------------------------------------------------
% EXPORTAR HISTORIAL A ARCHIVO TXT
% Guarda todos los diagnosticos de la sesion en historial.txt
% ------------------------------------------------------------
exportar_historial :-
    findall(F, historial(F), Lista),
    (   Lista = []
    ->  send(@main_window, report, inform,
            'No hay diagnosticos para exportar.')
    ;   open('historial.txt', write, Stream),
        write(Stream, 'HISTORIAL DE DIAGNOSTICOS - Sistema Experto Automotriz'),
        nl(Stream),
        write(Stream, '====================================================='),
        nl(Stream), nl(Stream),
        forall(
            nth1(I, Lista, Falla),
            (
                format(Stream, 'DIAGNOSTICO #~w~n', [I]),
                write(Stream, '-------------------------------------'), nl(Stream),
                write(Stream, Falla), nl(Stream), nl(Stream)
            )
        ),
        close(Stream),
        send(@main_window, report, inform,
            'Historial exportado a historial.txt en la carpeta del proyecto.')
    ).

% ------------------------------------------------------------
% VER HISTORIAL
% Muestra todos los diagnosticos realizados en la sesion
% ------------------------------------------------------------
ver_historial :-
    new(DH, dialog('Historial de Diagnosticos', size(650, 470))),
    send(DH, background, colour(white)),

    new(TitH, label(th, 'HISTORIAL DE DIAGNOSTICOS REALIZADOS')),
    send(TitH, font, font(helvetica, bold, 13)),
    send(TitH, colour, colour(navy)),

    new(EdH, editor),
    send(EdH, size, size(608, 350)),
    send(EdH, editable, @off),
    send(EdH, font, font(courier, normal, 10)),

    (   findall(F, historial(F), Lista),
        Lista \= []
    ->  atomic_list_concat(Lista,
            '\n========================================\n',
            Texto)
    ;   Texto = 'No hay diagnosticos registrados en esta sesion.'
    ),

    get(EdH, text_buffer, TB),
    send(TB, string, Texto),

    new(BtnC, button('Cerrar', message(DH, destroy))),
    send(BtnC, background, colour(red)),

    send(DH, display, TitH, point(30,  15)),
    send(DH, display, EdH,  point(20,  45)),
    send(DH, display, BtnC, point(285, 410)),
    send(DH, open_centered).