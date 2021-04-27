/*Escribir el código de un procedimiento PL/SQL que realice lo siguiente:

Pedirá como entrada el código (nombre) de un doctor de la clínica.
Si no existe ningún doctor con ese código, mostrará el mensaje “Este doctor no trabaja actualmente en la clínica”.
Si por el contrario lo encuentra,  presentará su especialidad, junto con la relación de consultas que atiende. De cada consulta mostrará nombre de la clínica,el día que la atiende, y  el turno.
Si el doctor no tiene consultas asociadas, sólo mostrará su especialidad y la frase “Actualmente no tiene consultas asignadas”.

Se muestra a continuación un ejemplo de la ejecución del procedimiento:

>>>EXECUTE ListarConsultasDoctor('Martinez');

Este doctor no trabaja actualmente en la clínica

Procedimiento PL/SQL terminado correctamente.



>>>EXECUTE ListarConsultasDoctor('Salas');

Especialidad: Anestesia
-----------------------
Actualmente no tiene consultas asignadas

Procedimiento PL/SQL terminado correctamente.

>>>EXECUTE ListarConsultasDoctor('Castro');

Especialidad: Odontología
---------------------------------
Clínica              Día Turno
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
  dbms_output.put_line('Este doctor no trabaja actualmente en la clínica');
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
