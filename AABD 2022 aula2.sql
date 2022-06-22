--Ex 4

DECLARE

cod_livro LIVROS.CODIGO_LIVRO%TYPE;

cod_autor AUTORES.CODIGO_AUTOR%TYPE;

BEGIN

cod_livro := &cod_livro;

  Select livros.codigo_autor into cod_autor
  from livros 
  where livros.codigo_livro = cod_livro;
  
  IF cod_autor = 17 THEN    
    INSERT into AUTORES
    VALUES (80,'Luis Moreno Campos',23432432,'Lisboa',NULL,'M','Portuguesa','Informatica');
    
    UPDATE LIVROS
    SET codigo_autor = 80
    Where codigo_livro = cod_livro;

  END IF;

END;
/

EXEC AABDCHECK('QCODE13BULFOEEF');
EXEC AABDCHECK('QCODE14BULFOEEF'); 
EXEC AABDCHECK('QCODE15BULFOEEF');

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

--Ex 3

DECLARE
  CODL NUMBER := &CODIGO_LIVRO;
  CODA NUMBER; n NUMBER;

BEGIN
    SELECT COUNT(*) INTO N
    FROM LIVROS
    WHERE CODIGO_LIVRO = CODL;
    IF N > 0 THEN 
      SELECT CODIGO_AUTOR INTO CODA
      FROM LIVROS
      WHERE CODIGO_LIVRO = CODL;
      IF CODA = 17 THEN
      --SE EXISTIR O 80
        SELECT COUNT(*) INTO N  
        FROM AUTORES WHERE CODIGO_AUTOR = 80;
        IF N = 0 THEN
          INSERT INTO AUTORES VALUES (80, 'Luis Moreno Campos', 23432432, 'Lisboa', NULL,'M','Portuguesa','Informática');
        END IF;
      UPDATE LIVROS SET CODIGO_AUTOR = 80 WHERE CODIGO_LIVRO = CODL;
      END IF;
    END IF;
END;
/

EXEC AABDCHECK('QCODE15BULFOEEF');

--Ex 6

DECLARE
  CURSOR C2 is
    Select codigo_autor,nome,genero_preferido
    From Autores
    Where codigo_autor between 8 and 14;
    
  nlivros NUMBER;
  nlivrospref NUMBER;
BEGIN
  FOR R IN C2
  LOOP
    Select count(*) into nlivros
    From livros
    Where codigo_autor = r.codigo_autor;
    
    Select count(*) into nlivrospref
    From livros
    Where codigo_autor = r.codigo_autor and genero = r.genero_preferido;
    
    INSERT into TEMP VALUES(nlivros,nlivrospref,substr(r.nome,instr(r.nome,' ',-1)+1));
  END LOOP;
END;
/

Select *
From Temp;

--Ex 7

DECLARE
  preco_total NUMBER;
  preco_sup20 NUMBER;
  numpag_sup400 NUMBER;
  valormed NUMBER;
BEGIN
  Select sum(preco_tabela)into preco_total
  from livros
  where lower(genero) = 'aventura';
  
  Select count(*) into preco_sup20
  from livros
  where lower(genero) = 'aventura' and preco_tabela > 20;
  
  Select count(*) into numpag_sup400
  from livros
  where lower(genero) = 'aventura' and paginas > 400;
  
  Select avg(preco_tabela) into valormed
  from livros
  where lower(genero) = 'aventura';
  
  INSERT into TEMP VALUES(preco_sup20,numpag_sup400,'Média do preço dos livros de Aventura =' || valormed);
  
END;
/
--EX 8
DECLARE

  preco_parametro livros.preco_tabela%type := &preco_parametro;
  
  cursor c1 is
    SELECT titulo,quant_em_stock,preco_tabela
    FROM livros
    WHERE preco_tabela < preco_parametro;


BEGIN
  FOR r in c1
  LOOP
  INSERT into TEMP VALUES(r.quant_em_stock,r.preco_tabela,r.titulo);
  END LOOP;
END;
/

Select *
from temp;


--EX 9

DECLARE
  --v_codigo_livro livros.codigo_livro%type;
	--v_preco livros.preco_tabela%type;
	cursor c1 is
		select codigo_livro,preco_tabela
		from livros
		where genero in ('Policial','Romance') and preco_tabela<=60
		for update of preco_tabela;
BEGIN
  FOR r in c1
  LOOP
  IF  r.preco_tabela <=30 then
			update livros set preco_tabela=preco_tabela*1.08 
			where current of c1;
		else
			update livros set preco_tabela=preco_tabela*1.05 
			where current of c1;
		end if;
    
  END LOOP;
END;
/

--EX 10
DECLARE
  
  cursor c1 is
    SELECT codigo_livro,preco_tabela,titulo
    FROM livros
    Order by 2 desc;


BEGIN
  FOR r in c1
  LOOP
  INSERT into TEMP VALUES(r.codigo_livro,r.preco_tabela,r.titulo);
  EXIT When c1%rowcount = 6;
  END LOOP;
END;
/

--EX 11

DECLARE
  GEN livros.genero%type := '&genero_a_testar';
  SOMA NUMBER;
  CURSOR CX is
    Select codigo_livro,preco_tabela
    From livros
    Where lower(genero) = lower(GEN)
    order by 2;
BEGIN
  Select sum(preco_tabela)
  From livros
  Where lower(genero) = lower(GEN);
  
  IF SOMA < 160 THEN
    FOR r in CX
    LOOP
      SOMA := SOMA + r.PRECO_TABELA * 0.15
      EXIT WHEN SOMA > 160;
      UPDATE LIVROS SET PRECO_Tabela = PRECO_tabela * 1.15
      WHERE CODIGO_LIVRO = r.CODIGO_LIVRO;
    
    END LOOP;
  END IF;
END;
/

--EX 12
DECLARE
  
  cursor c1 is
    Select autores.codigo_autor,count(*) as numero ,nome
    From livros,autores
    Where livros.codigo_autor = autores.codigo_autor and lower(genero) = 'aventura'
    group by autores.codigo_autor,nome;


BEGIN
  FOR r in c1
  LOOP
  INSERT into TEMP VALUES(r.codigo_autor,r.numero,reverse(r.nome));
  END LOOP;
END;
/

Select autores.codigo_autor,count(*),nome
From livros,autores
Where livros.codigo_autor = autores.codigo_autor and lower(genero) = 'aventura'
group by autores.codigo_autor,nome;

Select count(*)
From livros,autores
Where livros.codigo_autor = autores.codigo_autor and lower(genero) = 'aventura' and autores.NOME = 'Fernando Tavares';

--EX 13

DECLARE
  
  cursor c1 is
    Select codigo_autor,nome,genero_preferido
    From Autores;

nlivrospref NUMBER;
livroseditado NUMBER;
BEGIN
  FOR r in c1
  LOOP
    Select count(*) into nlivrospref
    From livros
    Where codigo_autor = r.codigo_autor;
    
    Select count(*) into livroseditado
    From livros
    Where codigo_autor = r.codigo_autor;
    
  INSERT into TEMP VALUES(r.codigo_autor,nlivrospref,substr(r.nome,instr(r.nome,' ',-1)+1));
  END LOOP;
END;
/

Select count(*)
From livros,editoras,autores
where livros.codigo_autor = autores.codigo_autor and livros.codigo_editora = editoras.codigo_editora and autores.codigo_autor = 2;

Select *
from temp;


delete from temp where col1 in (select col1 from (select col1, rownum r from temp) where r >120);