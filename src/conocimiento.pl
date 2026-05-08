% ============================================================
% BASE DE CONOCIMIENTO
% Fallas automotrices, soluciones y reglas de diagnostico
%
% ESTRUCTURA:
%   fallas/1             -> Solucion para cada categoria (con !)
%   aceite/0 ... sonido/0-> Reglas de diagnostico (conjuncion de preguntas)
%   cambio_aceite/0 ...  -> Identificadores de entrada por categoria
% ============================================================

% ------------------------------------------------------------
% SOLUCIONES
% Cada clausula retorna el texto de solucion si su condicion
% tiene exito. El corte (!) evita backtracking hacia otras.
% ------------------------------------------------------------

fallas('REALIZAR CAMBIO DE ACEITE:

  1. Abra el capo del automovil.
  2. Retire el tapon del motor.
  3. Ubique la valvula de purgacion debajo del motor.
  4. Coloque un deposito debajo del motor.
  5. Abra la valvula y drene el aceite antiguo.
  6. Cierre la valvula.
  7. Introduzca el aceite nuevo y coloque el tapon.
  8. Listo. Felicitaciones!') :- aceite, !.

fallas('REALIZAR ALINEACION Y BALANCEO:

  1. Lleve el automovil a un taller especializado.
  2. Solicite el servicio de alineacion y balanceo.
  3. Se recomienda hacerlo cada 10,000 km.') :- suspension, !.

fallas('REVISAR LA BATERIA:

  1. Abra el capo del automovil.
  2. Ubique la bateria.
  3. Verifique que los bornes esten bien conectados.
  4. Trate de arrancar el auto.
  5. Si no arranca, lleve la bateria a un centro de carga.
  6. Si aun no arranca, reemplace la bateria.') :- electronico, !.

fallas('REPARACION DEL SISTEMA DE FRENOS:

  1. Detecte ruidos anormales al frenar.
  2. Revise las pastillas de frenos.
  3. Si estan desgastadas, proceda a cambiarlas.
  4. Retire las pastillas viejas y coloque las nuevas.
  5. Si no puede realizar el cambio usted mismo,
     lleve el auto a un taller especializado.') :- frenos, !.

fallas('REVISION DE LA COMPUTADORA DEL AUTOMOVIL:

  1. Lleve el automovil a un taller especializado.
  2. Solicite un diagnostico con scanner OBD.
  3. Anote los codigos de error que aparezcan.
  4. Decida reparar o reemplazar segun el costo.') :- computadora, !.

fallas('REVISION O CAMBIO DE BOCINAS:

  1. Ubique la o las bocinas que no funcionan.
  2. Retire el protector de la bocina.
  3. Revise que los conectores esten bien colocados.
  4. Reemplace cables danados.
  5. Si aun no funciona, reemplace la bocina.') :- sonido, !.

fallas('SIN RESULTADOS.
No se identifico la falla con las respuestas proporcionadas.
Consulte a un mecanico especializado.').


% ------------------------------------------------------------
% REGLAS DE DIAGNOSTICO
% Cada predicado representa una categoria de falla.
% Primero valida el identificador de entrada, luego hace
% preguntas especificas. Todas deben responderse SI.
% ------------------------------------------------------------

aceite :-
    cambio_aceite,
    pregunta('TU MOTOR ESTA FALLANDO?'),
    pregunta('ESTA GASTANDO DEMASIADO COMBUSTIBLE?'),
    pregunta('RUIDOS ANOMALOS EN EL MOTOR?'),
    pregunta('PROBLEMAS AL ARRANCAR EL AUTO EN FRIO?'),
    pregunta('PERDIDA DE FUERZA DEL MOTOR?').

suspension :-
    alineacion_direccion,
    pregunta('CREE TENER PROBLEMAS DE SUSPENSION?'),
    pregunta('SU VEHICULO GIRA AUNQUE EL TIMON ESTE DERECHO?'),
    pregunta('SUS LLANTAS SE DESGASTAN DE UN SOLO LADO?'),
    pregunta('SIENTE QUE SU TIMON VIBRA MUCHO?').

electronico :-
    bateria_agotada,
    pregunta('CREE TENER PROBLEMAS ELECTRICOS?'),
    pregunta('SUS LUCES ALUMBRAN DEMASIADO BAJO?'),
    pregunta('EL RADIO DE SU AUTO NO ENCIENDE?'),
    pregunta('AL DAR SWITCH SOLO ESCUCHA UN RUIDO?'),
    pregunta('EL AUTO NO ENCIENDE?'),
    pregunta('SU BATERIA ES MUY ANTIGUA?').

frenos :-
    cambio_frenos,
    pregunta('CREE TENER PROBLEMAS EN LOS FRENOS DE SU AUTO?'),
    pregunta('AL FRENAR ESCUCHA RUIDOS O RECHINIDOS?'),
    pregunta('SU AUTO TARDA EN FRENAR?').

computadora :-
    check_engine,
    pregunta('EL AUTO PRESENTA TIRONES O JALONES AL ACELERAR?'),
    pregunta('LA LUZ ENGINE SE MANTIENE ENCENDIDA?').

sonido :-
    cambio_bocina,
    pregunta('CREE TENER PROBLEMAS CON LAS BOCINAS DE SU AUTO?'),
    pregunta('LAS BOCINAS NO SE ESCUCHAN?'),
    pregunta('LA BATERIA TIENE SUFICIENTE CARGA?').


% ------------------------------------------------------------
% IDENTIFICADORES DE ENTRADA
% Pregunta inicial que determina la categoria a evaluar.
% BUG CORREGIDO: texto consistente entre identificador y
% primera pregunta de la regla (usaban textos distintos).
% BUG CORREGIDO: cambio_bocina y check_engine incluyen '?'
% ------------------------------------------------------------

cambio_aceite       :- pregunta('PROBLEMAS DE MOTOR?'), !.
alineacion_direccion :- pregunta('PROBLEMAS DE SUSPENSION?'), !.
bateria_agotada     :- pregunta('PROBLEMAS ELECTRICOS?'), !.
cambio_frenos       :- pregunta('PROBLEMAS DE FRENOS?'), !.
cambio_bocina       :- pregunta('PROBLEMAS DE BOCINAS?'), !.
check_engine        :- pregunta('LA LUZ CHECK ENGINE SE ENCENDIO?'), !.
