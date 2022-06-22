set serveroutput on;
--Ex 2

Create table erros(
cod_error NUMBER(10),
message varchar2(250),
data_erro date
);

--Ex3 e Ex4

Create or REPLACE PROCEDURE F03_EX04(CODL livros.codigo_livro%type) is
--Declare
  CODA NUMBER; 
  CODE NUMBER;
  MSG erros.message%type;
BEGIN
      SELECT CODIGO_AUTOR INTO CODA
      FROM LIVROS
      WHERE CODIGO_LIVRO = CODL;
      
      IF CODA = 17 THEN
        
        BEGIN
        
          INSERT INTO AUTORES VALUES (80, 'Luis Moreno Campos', 23432432, 'Lisboa', NULL,'M','Portuguesa','Informática');
          
        EXCEPTION     
          WHEN DUP_VAL_ON_INDEX THEN
            CODE:= SQLCODE;
            MSG := SQLERRM;
            INSERT INTO ERROS VALUES (CODE,MSG,SYSDATE);
        END;
        
      UPDATE LIVROS SET CODIGO_AUTOR = 80 WHERE CODIGO_LIVRO = CODL;
      
    END IF;
    
EXCEPTION
  WHEN NO_DATA_FOUND THEN
   CODE:= SQLCODE;
   MSG := SQLERRM;
   INSERT INTO ERROS VALUES (CODE,MSG,SYSDATE);
END;
/

EXEC F03_EX04(8);

Select *
from erros;

--Ex 5

Create PROCEDURE F03_EX06(quantidade NUMBER) is
  CURSOR c1 is
    Select preco_tabela,titulo,quant_em_stock
    From livros
    Where quant_em_stock > quantidade;   
Begin
  FOR r in c1
  LOOP
    INSERT INTO TEMP VALUES(r.preco_tabela,r.quant_em_stock,r.titulo);
  END LOOP;
END;
/

EXEC F03_EX06(10);

Select *
from temp;

--Ex 6

Create or Replace Function F03_EX07(codLivro NUMBER) RETURN NUMBER IS
  preco livros.preco_tabela%type;
Begin
  Select preco_tabela into preco
  From livros
  where codigo_livro = codlivro;
  
  return preco;
  
EXCEPTION
WHEN NO_DATA_FOUND THEN
  raise_application_error(-20301,'Código de livro inexistente');
End;
/

--Ex 7

Create Function F03_EX08(codAutor autores.codigo_autor%type) return VARCHAR2 is
  nome autores.nome%type;
Begin
  Select substr(autores.nome,1,instr(nome,' ')-1) into nome
  from autores
  where codigo_autor = codAutor;
  
  return nome;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  raise_application_error(-20301,'Código de autor inexistente');
End;
/

Select substr(autores.nome,1,instr(nome,' ')-1) 
from autores;

--Ex 8

Create Function F03_EX09(codAutor autores.codigo_autor%type) return NUMBER is
  numero NUMBER;
Begin
  Select count(*) into numero
  from autores,livros
  where livros.CODIGO_AUTOR = autores.codigo_autor and livros.codigo_autor = codAutor;
  
  return numero;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  raise_application_error(-20304,'O autor com o código' || codAutor || 'não escreveu livros');
End;
/

Select count(*) 
from autores,livros
where livros.CODIGO_AUTOR = autores.codigo_autor and livros.codigo_autor = 2;













