% ============================================================
% SISTEMA EXPERTO - DIAGNOSTICO DE FALLAS AUTOMOTRICES
% Universidad - Noveno Semestre - Inteligencia Artificial
% Autor: Diego Estrada
% Version: 3.0
% ============================================================
%
% COMO EJECUTAR:
%   Opcion 1 (automatico): doble clic en main.pl -> se abre solo
%   Opcion 2 (manual)    : ?- [main].  luego  ?- iniciar.
%
% ESTRUCTURA DEL PROYECTO:
%   main.pl              -> Punto de entrada
%   src/motor.pl         -> Motor de inferencia (pregunta/1, memoizacion)
%   src/conocimiento.pl  -> Base de conocimiento (fallas, reglas)
%   src/gui.pl           -> Interfaz grafica PCE
%   img/                 -> Imagenes e iconos (ver img/IMAGENES.txt)
% ============================================================

:- use_module(library(pce)).
:- use_module(library(pce_style_item)).

:- consult('src/motor').
:- consult('src/conocimiento').
:- consult('src/gui').

% Auto-ejecutar al cargar el archivo
:- iniciar.
