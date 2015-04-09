
% старт сборки кубика
collect(
	F1, F2, F3, F4, 
	B1, B2, B3, B4,
	L1, L2, L3, L4,
	R1, R2, R3, R4,
	U1, U2, U3, U4,
	D1, D2, D3, D4) :- 
		clear_steps,
		collect_cube(F1, F2, F3, F4, 
			B1, B2, B3, B4,
			L1, L2, L3, L4,
			R1, R2, R3, R4,
			U1, U2, U3, U4,
			D1, D2, D3, D4, 0),
		print_steps,
		write('\n'),
		print_condensed_form, !.

% если кубик собран, вывести цвета граней
collect_cube(
	F1, F2, F3, F4, 
	B1, B2, B3, B4,
	L1, L2, L3, L4,
	R1, R2, R3, R4,
	U1, U2, U3, U4,
	D1, D2, D3, D4, StepCount) :- 
		check_cube(
			F1, F2, F3, F4, 
			B1, B2, B3, B4,
			L1, L2, L3, L4,
			R1, R2, R3, R4,
			U1, U2, U3, U4,
			D1, D2, D3, D4), 
		print_step(
			F1, F2, F3, F4, 
			B1, B2, B3, B4,
			L1, L2, L3, L4,
			R1, R2, R3, R4,
			U1, U2, U3, U4,
			D1, D2, D3, D4, StepCount), !.

% если не собран, делаем следующий ход
collect_cube(
	F1, F2, F3, F4, 
	B1, B2, B3, B4,
	L1, L2, L3, L4,
	R1, R2, R3, R4,
	U1, U2, U3, U4,
	D1, D2, D3, D4, StepCount) :- 
		not(check_cube(
			F1, F2, F3, F4, 
			B1, B2, B3, B4,
			L1, L2, L3, L4,
			R1, R2, R3, R4,
			U1, U2, U3, U4,
			D1, D2, D3, D4)), 
		check_and_rotate(
			F1, F2, F3, F4, 
			B1, B2, B3, B4,
			L1, L2, L3, L4,
			R1, R2, R3, R4,
			U1, U2, U3, U4,
			D1, D2, D3, D4, StepCount), !.

% добавить элемент в список
incl(H, T, [H | T]).

% создает пустой список шагов
clear_steps :-
	retractall(steps(_)),
	assert(steps([])).

% добавить шаг к формуле
insert_step(S) :- 
	clause(steps(Steps), _),
	incl(S, Steps, StepsS),
	retractall(steps(_)),
	assert(steps(StepsS)).

% вывести содержимое списка на экран через пробел
print_list([]).
print_list([H]) :- write(H).
print_list([H|T]) :- 
	write(H), write(' '),
	print_list(T).

% сокращённая формула сборки
condensed_form([]).
condensed_form([H|T]) :- condensed_form(H, T), !.
condensed_form([H|T]) :- concat(H, ' ', S), write(S), condensed_form(T).
condensed_form(A, [H|T]) :- A == H, condensed_form(A, H, T).
condensed_form(A, B, [H|T]) :- A == B, B == H, condensed_form(A, B, H, T).
condensed_form(A, B, C, [H|T]) :- A == B, B == C, concat(A, ''' ', S), write(S), condensed_form([H|T]).
condensed_form(A, B, C, []) :- A == B, B == C, concat(A, ''' ', S), write(S).

print_condensed_form :-
	write('Сокращённая форма:\n'),
	clause(steps(Steps), _),
	condensed_form(Steps), !.

% вывести список шагов для сборки кубика
print_steps :- 
	write('Формула для сборки:\n'),
	clause(steps(Steps), _),
	print_list(Steps), !.

% распечатывает конфигурацию кубика
print_step(
	F1, F2, F3, F4, 
	B1, B2, B3, B4,
	L1, L2, L3, L4,
	R1, R2, R3, R4,
	U1, U2, U3, U4,
	D1, D2, D3, D4, StepCount) :- 
		writeln('Результат сборки:'),
		print_list(['[ front = ', F1, F2, F3, F4, ' ]\n']),
		print_list(['[ bottom = ', B1, B2, B3, B4, ' ]\n']),
		print_list(['[ left = ', L1, L2, L3, L4, ' ]\n']),
		print_list(['[ right = ', R1, R2, R3, R4, ' ]\n']),
		print_list(['[ up = ', U1, U2, U3, U4, ' ]\n']),
		print_list(['[ down = ', D1, D2, D3, D4, ' ]\n']),
		write('Количество ходов = '), writeln(StepCount).

% проверяет количество сделанных шагов
% если возможен ещё один шаг - делает его
% если кубик оказался собран - выводит список поворотов, начиная с последнего
check_and_rotate(
	F1, F2, F3, F4, 
	B1, B2, B3, B4,
	L1, L2, L3, L4,
	R1, R2, R3, R4,
	U1, U2, U3, U4,
	D1, D2, D3, D4, StepCount) :- 
		check_step(StepCount), 
		IncStepCount is StepCount + 1,
		rotate(
			F1, F2, F3, F4, 
			B1, B2, B3, B4,
			L1, L2, L3, L4,
			R1, R2, R3, R4,
			U1, U2, U3, U4,
			D1, D2, D3, D4, IncStepCount). 

% проверяет, что количество шагов не превышено. Если перевалит за 14, то false
check_step(StepCount) :- StepCount =< 14.

% поворот передней грани на 90 градусов по часовой стрелке
rotate(
	F1, F2, F3, F4, 
	B1, B2, B3, B4,
	L1, L2, L3, L4,
	R1, R2, R3, R4,
	U1, U2, U3, U4,
	D1, D2, D3, D4, StepCount) :- 
		collect_cube(
			F4, F1, F2, F3, 
			B1, B2, B3, B4,
			L1, D1, D2, L4,
			U4, R2, R3, U3,
			U1, U2, L2, L3,
			R4, R1, D3, D4, StepCount),
		insert_step('F').

% поворот правой грани на 90 градусов по часовой стрелке
rotate(
	F1, F2, F3, F4, 
	B1, B2, B3, B4,
	L1, L2, L3, L4,
	R1, R2, R3, R4,
	U1, U2, U3, U4,
	D1, D2, D3, D4, StepCount) :- 
		collect_cube(
			F1, D2, D3, F4, 
			U3, B2, B3, U2,
			L1, L2, L3, L4,
			R4, R1, R2, R3,
			U1, F2, F3, U4,
			D1, B4, B1, D4, StepCount),
		insert_step('R').

% поворот верхней грани на 90 градусов по часовой стрелке
rotate(
	F1, F2, F3, F4, 
	B1, B2, B3, B4,
	L1, L2, L3, L4,
	R1, R2, R3, R4,
	U1, U2, U3, U4,
	D1, D2, D3, D4, StepCount) :- 
		collect_cube(
			R1, R2, F3, F4, 
			L1, L2, B3, B4,
			F1, F2, L3, L4,
			B1, B2, R3, R4,
			U4, U1, U2, U3,
			D1, D2, D3, D4, StepCount),
		insert_step('U').

% проверка граней кубика на равенство
check_cube(
	F1, F2, F3, F4, 
	B1, B2, B3, B4,
	L1, L2, L3, L4,
	R1, R2, R3, R4,
	U1, U2, U3, U4,
	D1, D2, D3, D4) :- 
		check_side(F1, F2, F3, F4),
		check_side(B1, B2, B3, B4),
		check_side(L1, L2, L3, L4),
		check_side(R1, R2, R3, R4),
		check_side(U1, U2, U3, U4),
		check_side(D1, D2, D3, D4).

% проверяет, совпадают ли цвета грани
check_side(W, X, Y, Z) :- W == X, X == Y, Y == Z.  

% примеры создания кубиков

% сейчас у меня такой кубик
init :-
	collect(
		red, orange, white, orange,
		blue, green, red, white,
		orange, yellow, blue, white,
		green, yellow, blue, red,
		yellow, red, white, green,
		yellow, green, orange, blue).

%  собранный кубик
init_correct :-
	collect(
		red, red, red, red,
		blue, blue, blue, blue,
		orange, orange, orange, orange,
		green, green, green, green,
		yellow, yellow, yellow, yellow,
		white, white, white, white).

%  почти собранный кубик
init_correct_2 :-
	collect(
		red, red, red, red,
		blue, blue, blue, blue,
		orange, white, white, orange,
		yellow, green, green, yellow,
		yellow, yellow, orange, orange,
		green, green, white, white).