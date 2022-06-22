--Ex 2
Create or replace trigger F05_EX15
After insert on Livros
for each row
Begin
    update autores
    set GENERO_PREFERIDO = :new.genero
    where :new.codigo_autor = autores.CODIGO_AUTOR;
End;
/

--Ex 3

Create or Replace Function F04_EX14(gen_livros livros.genero%type) return varchar is

Cursor c1 is
  Select titulo
  from livros
  where genero = gen_livros;
Begin
  for r in c1
  loop
    return r.titulo;
  end loop;
  raise_application_error(-20300,'genero inexistente.');
End;
/

Create or Replace Function F04_EX14(gen_livros livros.genero%type) return varchar is
mais_caro varchar;
Begin
  Select titulo into mais_caro
  from (select titulo
        from livros
        where genero = gen_livro and preco_tabela = (select max(preco_tabela)
                                               from livros
                                               where genero = gen_livros)
  Order by data_edicao desc) Where rownum = 1;
  return mais_caro;
  
  exception
  when no_data_found then
  raise_application_error(-20300,'genero inexistente.');
End;
/

--Ex 4
Create table FICHA5(
 num1 number, 
 num2 number, 
 num3 number, 
 num4 number, 
 string1 varchar2(100), 
 string2 varchar2(1000)
);

--Ex 5

Create or Replace PROCEDURE F05_EX09 is
titulo livros.titulo%type;
quant livros.quant_em_stock%type;
total_vendas NUMBER;
mes_venda Number;
diff NUMBER;
Begin
  delete FICHA5;
  
  Insert into FICHA5
    select quant_em_stock,sum(quantidade),MAX(NVL(soma_mes,0)),sum(quantidade * preco_tabela)- sum(quantidade*preco_unitario),titulo,NULL
    from livros l, vendas v, (select sum(quantidade) soma_mes,codigo_livro
                              from vendas v
                              where to_char(sysdate,'YYYYMM') = to_char(add_months(data_venda,1),'YYYYMM')
                              group by codigo_livro) ult
    where l.codigo_livro = v.codigo_livro and l.codigo_livro = ult.codigo_livro (+)
    group by titulo, quant_em_stock,NULL;
    
End;
/

--Ex 6

Create trigger F06_EX20_1
After insert or delete or update on vendas

Begin
  F05_EX09;
End;
/

Create trigger F06_EX20_2
After insert or delete or update on livros

Begin
  F05_EX09;
End;
/

--quiz 
Create trigger nao_permita
before insert on vendas
for each row

Begin
  if ((sysdate - :new.data_edicao) > 30) then
  
    raise_application_error(-20431,'O livro ' || :new.titulo || ' não está disponível para venda');
  
  end if;

End;
/

insert into livros values(90,1,1,'teste',9727221581,'Informática',28,500,10,324,'13.08.02');

select * from livros;


