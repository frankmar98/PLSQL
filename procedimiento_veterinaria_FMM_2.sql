/*Escribir el c�digo de un procedimiento PL/SQL que realice lo siguiente:

Pedir� como entrada el c�digo (nombre) de un doctor de la cl�nica.
Si no existe ning�n doctor con ese c�digo, mostrar� el mensaje �Este doctor no trabaja actualmente en la cl�nica�.
Si por el contrario lo encuentra,  presentar� su especialidad, junto con la relaci�n de consultas que atiende. De cada consulta mostrar� nombre de la cl�nica,el d�a que la atiende, y  el turno.
Si el doctor no tiene consultas asociadas, s�lo mostrar� su especialidad y la frase �Actualmente no tiene consultas asignadas�.

Se muestra a continuaci�n un ejemplo de la ejecuci�n del procedimiento:

>>>EXECUTE ListarConsultasDoctor('Martinez');

Este doctor no trabaja actualmente en la cl�nica

Procedimiento PL/SQL terminado correctamente.



>>>EXECUTE ListarConsultasDoctor('Salas');

Especialidad: Anestesia
-----------------------
Actualmente no tiene consultas asignadas

Procedimiento PL/SQL terminado correctamente.

>>>EXECUTE ListarConsultasDoctor('Castro');

Especialidad: Odontolog�a
---------------------------------
Cl�nica              D�a Turno
---------------------------------
Bigotes              MI  N
Bigotes              Ma  N

Procedimiento PL/SQL terminado correctamente.*/


create or replace procedure pr_entrega_frankmm(nombre in varchar2)
as
esp varchar2(30);
ndoctores number;
nconsultas number;
e_no_existe exception;
e_no_trabaja exception;
begin
  nconsultas:=0;
  select count(*) into ndoctores from doctor where identificador=nombre;
  if ndoctores = 0 then
    raise e_no_existe;
  end if;
  if ndoctores = 1 then
    dbms_output.put_line('Doctor encontrado');
    select especialidad into esp from doctor where identificador=nombre;
    dbms_output.put_line('Especialidad: ' || esp);
    select count(*) into nconsultas from atiende_en
    inner join doctor
    on 
    atiende_en.id_doctor = doctor.identificador
    where doctor.identificador=nombre;
  end if;
  if nconsultas = 0 then
    dbms_output.put_line('Actualmente no tiene consultas asignadas');
  else
  dbms_output.put_line('Si tiene consultas: ' || nconsultas || ' consultas');
  dbms_output.put_line(rpad('Clinica:',20) || rpad('Dia:',20) || rpad('Turno:',20));
  for s in (
  select atiende_en.nombre_consulta, atiende_en.dia, atiende_en.turno from atiende_en
    inner join doctor on
    atiende_en.id_doctor = doctor.identificador
    where doctor.identificador=nombre) 
    loop
    dbms_output.put_line(rpad(s.nombre_consulta,20) || rpad(s.dia,20) || rpad(s.turno,20));
    end loop;
  end if;
  exception
  when e_no_existe then
  dbms_output.put_line('Este doctor no trabaja actualmente en la cl�nica');
  when e_no_trabaja then
  dbms_output.put_line('Actualmente no tiene consultas asignadas');
  when others then
  dbms_output.put_line('Error: ' || sqlerrm);
end;
/

set serveroutput on;

execute pr_entrega_FrankMM('Cabrera');
execute pr_entrega1('Lopez');
execute pr_entrega1('Cabrera');
execute pr_entrega1('Salas');
