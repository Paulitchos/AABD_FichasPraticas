set serveroutput on;
set serveroutput off;
--Ex 2
Create or Replace Function F03_EX08(codAutor autores.codigo_autor%type) return VARCHAR2 is
  nome autores.nome%type;
Begin
  Select substr(autores.nome,1,instr(nome,' ')-1) into nome
  from autores
  where codigo_autor = codAutor;
  
  return nome;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  raise_application_error(-20302,'Código de autor inexistente');
End;
/

--Ex 3
Create or Replace Function F03_EX09(codAutor autores.codigo_autor%type) return NUMBER is
  numero NUMBER;
Begin
  Select count(*) into numero
  from autores,livros
  where livros.CODIGO_AUTOR = autores.codigo_autor and livros.codigo_autor = codAutor; 
  
  if numero = 0 then
    raise_application_error(-20304,'O autor com o código' || codAutor || 'não escreveu livros');
  end if; 
  
  return numero;
End;
/

--Ex 4

Create or Replace PROCEDURE F03_EX10(codAutorx autores.codigo_autor%type,codAutory autores.codigo_autor%type)is
    EX_codAutor EXCEPTION;
    PRAGMA EXCEPTION_INIT (EX_codAutor, -20302);
    EX_notwrite EXCEPTION;
    PRAGMA EXCEPTION_INIT (EX_notwrite, -20304);
    
Begin
  for r in codAutorx .. codAutory
  loop
    Begin
      Insert into temp values (r,F03_EX09(r),F03_EX08(r));
    EXCEPTION
      When EX_codAutor then DBMS_OUTPUT.PUT_LINE('Não tem Autores');
      When EX_notwrite then DBMS_OUTPUT.PUT_LINE('Não tem Livros');
      When others then DBMS_OUTPUT.PUT_LINE('Apanhou exceção');
    End;
  end loop;
End;
/

EXEC F03_EX10(1,5);

select *
from temp;

--Ex 4

Create or Replace PROCEDURE F03_EX11 is
nlivros NUMBER;
preco_total NUMBER;

Begin
  Delete temp;
  insert into temp (col1,col2,message)
    select sum(preco_tabela),count(*),genero
    from livros
    group by genero; 
End;
/

select count(*), sum(preco_tabela),genero
from livros
group by genero;

exec F03_EX11();

select *
from temp;

--Ex 5

Create or Replace TRIGGER F03_EX12
After Insert or Delete or Update OF GENERO, PRECO_TABELA 
on livros
For each row
Begin
  if updating ('PRECO_TABELA') then
     UPDATE TEMP set 
      col1 = col1 - :OLD.preco_tabela + :new.preco_tabela
    where message = :OLD.genero;
  else
    if deleting  or updating then
      UPDATE TEMP set 
        col2 = col2 - 1,
        col1 = col1 - :OLD.preco_tabela
      where message = :OLD.genero;
    end if;
    
    if inserting or updating then
       UPDATE TEMP set 
        col2 = col2 + 1,
        col1 = col1 + :new.preco_tabela
      where message = :new.genero;
    end if;
  end if;
End;
/
select *
from temp;

delete from livros where codigo_livro > 18;
rollback;




