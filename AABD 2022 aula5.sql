--Ex 2

CREATE TABLE livros_removidos
   (	"CODIGO_LIVRO" NUMBER(4,0) NOT NULL ENABLE, 
	"TITULO" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"ISBN" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"GENERO" VARCHAR2(20 BYTE), 
	"PRECO_TABELA" NUMBER(6,0), 
	"PAGINAS" NUMBER(6,0), 
	"QUANT_EM_STOCK" NUMBER(9,0), 
	"UNIDADES_VENDIDAS" NUMBER(9,0), 
	"DATA_EDICAO" DATE, 
	 CONSTRAINT "PK_ID_LIVRO_removido" PRIMARY KEY ("CODIGO_LIVRO")
   );
   
--Ex 3

Create trigger F05_EX03
AFter DELETE ON Livros
For each row

Begin
  INSERT INTO LIVROS_removidos Values
  (
    :old.CODIGO_LIVRO,
    :old.TITULO,
    :old.ISBN,
    :old.GENERO,
    :old.PRECO_TABELA,
    :old.PAGINAS,
    :old.QUANT_EM_STOCK,
    :old.UNIDADES_VENDIDAS,
    :old.DATA_EDICAO
  );
End;
/

--Ex 4

Alter table Livros_removidos
add (UTILIZADOR VARCHAR(40), DATA DATE);

--Ex 5

Create or replace trigger F05_EX03
AFter DELETE ON Livros
For each row

Begin
  INSERT INTO LIVROS_removidos Values
  (
    :old.CODIGO_LIVRO,
    :old.TITULO,
    :old.ISBN,
    :old.GENERO,
    :old.PRECO_TABELA,
    :old.PAGINAS,
    :old.QUANT_EM_STOCK,
    :old.UNIDADES_VENDIDAS,
    :old.DATA_EDICAO,USER,SYSDATE
  );
End;
/

--Ex 6

Alter table editoras
add (nlivros_editados Number(5));

Update editoras set nlivros_editados = (
Select count(*) 
from livros
Where editoras.codigo_editora = livros.codigo_editora);

--Ex 7

Create or Replace trigger F05_EX07
After INSERT or DELETE OR UPDATE OF CODIGO_EDITORA
ON LIVROS
For each row

BEGIN

  IF INSERTING or UPDATING THEN
    Update editoras set nlivros_editados = nlivros_editados + 1
    Where editoras.codigo_editora = :new.codigo_editora;
  END IF;
  
  IF DELETING or UPDATING THEN
    Update editoras set nlivros_editados = nlivros_editados - 1
    Where editoras.codigo_editora = :old.codigo_editora;
  END IF;
END;
/

--Ex 10

Create sequence SEQ_VENDAS START WITH 20;

CREATE trigger F05_EX10
Before insert on vendas
FOR each row

BEGIN
  :new.DATA_venda := sysdate;
  Select preco_tabela into :new.preco_unitario
  from livros
  where codigo_livro = :new.codigo_livro;
  
  if not to_char(sysdate,'MM-DD') < '12-28' and to_char(sysdate,'MM-DD') > '02-28' then
    :new.preco_unitario := :new.preco_unitario * 0.6;
  end if;
  
  :new.TOTAL_venda := :new.quantidade * :new.preco_unitario;
  
  Select seq_vendas.nextval into :new.codigo_venda from dual;
  
  
END;
/

--Quiz da aula

Create or REPLACE PROCEDURE compra_livros(gen_livros livros.genero%type) is

--Declare

  cursor c1 is
  select preco_tabela,data_edicao,titulo,quant_em_stock
  from livros
  where lower(genero) = lower(gen_livros) and to_char(data_edicao,'YYYY') = to_char(sysdate,'YYYY')
  order by 1 desc;
  
  numero_livros Number := 0;
  
BEGIN
  for r in c1
  loop
  
    if ((numero_livros + r.quant_em_stock) < 80) then
      numero_livros := numero_livros + r.quant_em_stock;
      insert into temp values(r.preco_tabela,r.quant_em_stock,r.titulo);
    else
      numero_livros := 80 - numero_livros;
      insert into temp values(r.preco_tabela,numero_livros,r.titulo);
    end if;
      
  end loop;
  
  if (numero_livros < 80) then

    raise_application_error(-20417,'Não existe em stock a quantidade total pretendida de livros do género ' || gen_livros);
  
  end if;
END;
/

exec compra_livros('aventura');

select preco_tabela,data_edicao,titulo,quant_em_stock
  from livros
  where genero = 'Informática' and to_char(data_edicao,'YYYY') = to_char(sysdate,'YYYY')
  order by 1 desc;