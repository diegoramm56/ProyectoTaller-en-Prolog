% ============================================================
% MOTOR DE INFERENCIA
% Manejo de preguntas Si/No con memoizacion
%
% LOGICA:
%   - preguntar/1 : Abre dialogo PCE y guarda la respuesta
%   - pregunta/1  : Consulta memoizada (no repregunta)
%   - limpiar/0   : Borra todos los hechos de sesion
%   - lim/0       : Limpia el editor de resultado en pantalla
% ============================================================

:- dynamic si/1, no/1.
:- dynamic historial/1.

% ------------------------------------------------------------
% guardar_historial(+Falla)
% Almacena cada diagnostico realizado en la sesion
% ------------------------------------------------------------
guardar_historial(Falla) :-
    assert(historial(Falla)).

% ------------------------------------------------------------
% preguntar(+Problema)
% Abre un dialogo modal con botones SI / NO.
% Si el usuario responde SI -> assert(si(Problema))
% Si el usuario responde NO -> assert(no(Problema)), fail
% ------------------------------------------------------------
preguntar(Problema) :-
    new(Di, dialog('DIAGNOSTICO MECANICO AUTOMOTRIZ')),
    send(Di, background, colour(white)),
    % --- Encabezado del dialogo ---
    new(L_titulo, label(titulo, 'RESPONDE LA SIGUIENTE PREGUNTA:')),
    send(L_titulo, font, font(helvetica, bold, 13)),
    send(L_titulo, colour, colour(navy)),
    % --- Texto de la pregunta ---
    new(L_preg, label(pregunta, Problema)),
    send(L_preg, font, font(helvetica, normal, 12)),
    % --- Botones SI (verde) y NO (rojo) ---
    new(B_si, button(si, and(message(Di, return, si)))),
    new(B_no, button(no, and(message(Di, return, no)))),
    send(B_si, background, colour(green)),
    send(B_no, background, colour(red)),
    send(Di, append, L_titulo),
    send(Di, append, L_preg),
    send(Di, append, B_si),
    send(Di, append, B_no),
    send(Di, default_button, si),
    send(Di, open_centered),
    get(Di, confirm, Answer),
    send(Di, destroy),
    (   Answer == si
    ->  assert(si(Problema))
    ;   assert(no(Problema)), fail
    ).

% ------------------------------------------------------------
% pregunta(+S)
% Si ya se respondio SI  -> tiene exito sin preguntar
% Si ya se respondio NO  -> falla sin preguntar
% Si nunca se pregunto   -> llama a preguntar/1
% ------------------------------------------------------------
pregunta(S) :-
    (   si(S) -> true
    ;   no(S) -> fail
    ;   preguntar(S)
    ).

% ------------------------------------------------------------
% limpiar/0
% Retracta todos los hechos si/1 y no/1 acumulados
% Usa el patron clasico: retract + fail para barrer todo
% ------------------------------------------------------------
limpiar :- retract(si(_)), fail.
limpiar :- retract(no(_)), fail.
limpiar.

% ------------------------------------------------------------
% lim/0
% Limpia el editor de resultado en la ventana principal.
% Envuelto en catch para que nunca falle y bloquee botones/0.
% ------------------------------------------------------------
lim :-
    catch(
        (get(@respl, text_buffer, TB), send(TB, string, '')),
        _,
        true
    ).
