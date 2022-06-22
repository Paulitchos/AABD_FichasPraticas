--EX 2

Create table temp(
col1 NUMBER(10),
col2 NUMBER(20),
message varchar2(100)
);

EXEC AABDCHECK('QCODE11BULFOEEF'); 

Drop table temp;

--EX 3

BEGIN
for i in 1..100
loop
  if mod(i,2) = 0 then
    insert into temp
    values(i,i*100,'col1 é par');
  else
    insert into temp
    values(i,i*100,'col1 é impar');
  end if;
  end loop;
END;
/

EXEC AABDCHECK('QCODE12BULFOEEF');

Select *
From temp;

--EX 4
set serveroutput on
DECLARE

cod_livro LIVROS.CODIGO_LIVRO%TYPE;

cod_autor AUTORES.CODIGO_AUTOR%TYPE;

BEGIN

cod_livro := &cod_livro;

IF cod_livro = 5 or cod_livro = 8 or cod_livro = 16 THEN
  Select autores.codigo_autor into cod_autor
  from autores,livros 
  where autores.codigo_autor = livros.codigo_autor and livros.codigo_livro = cod_livro;
  
  IF cod_autor = 17 THEN    
    INSERT into AUTORES
    VALUES (80,'Luis Moreno Campos',23432432,'Lisboa',NULL,'M','Portuguesa','Informatica');
    
    UPDATE LIVROS
    SET codigo_autor = 80
    Where codigo_livro = cod_livro;
  END IF;
ELSE
  DBMS_OUTPUT.PUT_LINE('Código livro não valido para este exercício');

END IF;

END;
/

EXEC AABDCHECK('QCODE13BULFOEEF');

Select *
FROM AUTORES
where codigo_autor = 80;

Select LIvros.CODIGO_LIVRO
FROM AUTORES,LIvros
where AUTORES.CODIGO_AUTOR = LIvros.CODIGO_AUTOR and livros.codigo_autor = 80;

Select *
FROM AUTORES
where codigo_autor = 17;

DElETE from autores
where codigo_autor = 80;

UPDATE LIVROS
SET codigo_autor = 17
Where codigo_livro = 5;

UPDATE LIVROS
SET codigo_autor = 17
Where codigo_livro = 8;

UPDATE LIVROS
SET codigo_autor = 17
Where codigo_livro = 16;

--EX 5


