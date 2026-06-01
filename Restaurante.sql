CREATE DATABASE restaurante
GO

USE restaurante
GO

CREATE TABLE Prato (
	idPrato VARCHAR(6)		NOT NULL,
	nome	VARCHAR(100)	NOT NULL,
	porcao	VARCHAR(20)		NOT NULL,
	valor	DECIMAL(10,2)	NOT NULL,
	tipo	VARCHAR(50)		NOT NULL
PRIMARY KEY (idPrato)
)

CREATE TABLE Ingrediente (
	idIngrediente VARCHAR(6)   NOT NULL,
	nome		  VARCHAR(100) NOT NULL,
	apresentacao  VARCHAR(200) NOT NULL
PRIMARY KEY (idIngrediente)
)

CREATE TABLE Cliente (
	cpf					VARCHAR(11)		NOT NULL,
	nome				VARCHAR(100)	NOT NULL,
	telefone			VARCHAR(14)		NOT NULL,
	logradouro			VARCHAR(100)	NOT NULL,
	numero				INT				NOT NULL,
	cep					VARCHAR(14)		NOT NULL,
	referenciaEntrega	VARCHAR(50)		NOT NULL
PRIMARY KEY (cpf)
)

CREATE TABLE Pedido (
	idPedido	VARCHAR(6) NOT NULL,
	ClienteCpf	VARCHAR(11)			NOT NULL,
	dataRealizacao	DATE	NOT NULL,
	valorTotal		DECIMAL(10, 2)  NOT NULL,
PRIMARY KEY (idPedido),
FOREIGN KEY (ClienteCpf) REFERENCES Cliente (cpf)
)

CREATE TABLE PratoPedido (
	idPrato	VARCHAR(6)	NOT NULL,
	idPedido	VARCHAR(6) NOT NULL,
	quantidade	INT NOT NULL
PRIMARY KEY (idPrato, idPedido),
FOREIGN KEY (idPrato) REFERENCES Prato (idPrato),
FOREIGN KEY (idPedido) REFERENCES Pedido (idPedido)
)

CREATE TABLE PratoIngrediente (
	idPrato VARCHAR(6)	NOT NULL,
	idIngrediente VARCHAR(6) NOT NULL,
	quantidade INT NOT NULL
PRIMARY KEY (idPrato, idIngrediente),
FOREIGN KEY (idPrato) REFERENCES Prato (idPrato),
FOREIGN KEY (idIngrediente) REFERENCES Ingrediente (idIngrediente)
)
GO

CREATE TABLE tb_tipo_prato (
    id_tipo INT IDENTITY(1,1) PRIMARY KEY,
    nome_tipo VARCHAR(50) NOT NULL UNIQUE 
);

GO

CREATE Or ALTER FUNCTION fnListarPratoIngrediente()
RETURNS @Resultado TABLE (
	idPrato VARCHAR(6),
	nome VARCHAR(100),
	porcao VARCHAR(20),
	valor DECIMAL(10, 2),
	tipo VARCHAR(50), 
	ingredientes VARCHAR(MAX)
)
AS
BEGIN
	DECLARE @idPrato VARCHAR(6), @nome VARCHAR(100), @porcao VARCHAR(20), @valor DECIMAL(10,2), @tipo VARCHAR(50)

	DECLARE cursorPratos CURSOR FOR
	SELECT p.idPrato, p.nome, p.porcao, p.valor, t.nome_tipo 
	FROM Prato p
	INNER JOIN tb_tipo_prato t ON p.id_tipo = t.id_tipo

	OPEN cursorPratos

	FETCH NEXT FROM cursorPratos INTO @idPrato, @nome, @porcao, @valor, @tipo

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @ListaIngredientes VARCHAR(MAX) = ''

		SELECT @ListaIngredientes = STRING_AGG(i.nome, ', ')
		FROM PratoIngrediente pi
		JOIN Ingrediente i ON pi.idIngrediente = i.idIngrediente
		WHERE pi.idPrato = @idPrato

		IF @ListaIngredientes IS NULL
			SET @ListaIngredientes = 'Nenhum ingrediente cadastrado'

		INSERT INTO @Resultado
		VALUES (@idPrato, @nome, @porcao, @valor, @tipo, @ListaIngredientes)

		FETCH NEXT FROM cursorPratos INTO @idPrato, @nome, @porcao, @valor, @tipo
	END

	CLOSE cursorPratos
	DEALLOCATE cursorPratos

	RETURN
END
GO

ALTER TABLE Prato ADD id_tipo INT NULL;
GO

INSERT INTO tb_tipo_prato (nome_tipo)
SELECT DISTINCT tipo FROM Prato WHERE tipo IS NOT NULL AND tipo <> '';
GO

UPDATE p
SET p.id_tipo = t.id_tipo
FROM Prato p
INNER JOIN tb_tipo_prato t ON p.tipo = t.nome_tipo;
GO

ALTER TABLE Prato DROP COLUMN tipo;
GO

ALTER TABLE Prato ALTER COLUMN id_tipo INT NOT NULL;
GO

ALTER TABLE Prato ADD CONSTRAINT FK_Prato_Tipo_Novo 
FOREIGN KEY (id_tipo) REFERENCES tb_tipo_prato (id_tipo);
GO

DROP FUNCTION IF EXISTS fnListarPratoIngrediente;
GO

ALTER TABLE Prato DROP CONSTRAINT FK_Prato_Tipo_Novo;
GO
 
DELETE FROM PratoIngrediente;
DELETE FROM PratoPedido;
DELETE FROM Pedido;
DELETE FROM Cliente;
DELETE FROM Prato;
DELETE FROM tb_tipo_prato;
GO
 
DBCC CHECKIDENT ('tb_tipo_prato', RESEED, 0);
GO
 
INSERT INTO tb_tipo_prato (nome_tipo) VALUES ('Grelhado');     
INSERT INTO tb_tipo_prato (nome_tipo) VALUES ('Massa');       
INSERT INTO tb_tipo_prato (nome_tipo) VALUES ('Salada');        
INSERT INTO tb_tipo_prato (nome_tipo) VALUES ('Sobremesa');     
INSERT INTO tb_tipo_prato (nome_tipo) VALUES ('Lanche');       
INSERT INTO tb_tipo_prato (nome_tipo) VALUES ('Frutos do Mar');
INSERT INTO tb_tipo_prato (nome_tipo) VALUES ('Vegano');       
INSERT INTO tb_tipo_prato (nome_tipo) VALUES ('Bebida');        
GO
 
SELECT id_tipo, nome_tipo FROM tb_tipo_prato;
GO
 
ALTER TABLE Prato ADD CONSTRAINT FK_Prato_Tipo_Novo
    FOREIGN KEY (id_tipo) REFERENCES tb_tipo_prato (id_tipo);
GO
 
INSERT INTO Ingrediente (idIngrediente, nome, apresentacao) VALUES
('I00001', 'Frango',             'Peito de frango grelhado fatiado'),
('I00002', 'Carne Bovina',       'Picanha fatiada ao ponto'),
('I00003', 'Camarão',            'Camarão rosa limpo e temperado'),
('I00004', 'Salmão',             'Filé de salmão grelhado'),
('I00005', 'Alface',             'Folhas de alface americana rasgadas'),
('I00006', 'Tomate',             'Tomate italiano fatiado'),
('I00007', 'Cebola',             'Cebola roxa em rodelas finas'),
('I00008', 'Queijo Mussarela',   'Queijo mussarela fatiado'),
('I00009', 'Queijo Parmesão',    'Parmesão ralado fino'),
('I00010', 'Macarrão Espaguete', 'Espaguete cozido al dente'),
('I00011', 'Macarrão Penne',     'Penne cozido al dente'),
('I00012', 'Molho Bolonhesa',    'Molho de carne moída ao tomate'),
('I00013', 'Molho Branco',       'Molho bechamel cremoso'),
('I00014', 'Molho Pesto',        'Pesto de manjericão e pinhão'),
('I00015', 'Bacon',              'Bacon crocante em cubos'),
('I00016', 'Ovo',                'Ovo estrelado ou mexido'),
('I00017', 'Batata Frita',       'Batata palha crocante'),
('I00018', 'Arroz',              'Arroz branco soltinho'),
('I00019', 'Feijão',             'Feijão carioca temperado'),
('I00020', 'Brócolis',           'Brócolis refogado no alho'),
('I00021', 'Cogumelo',           'Cogumelo paris fatiado refogado'),
('I00022', 'Manjericão',         'Folhas frescas de manjericão'),
('I00023', 'Azeite',             'Fio de azeite extra virgem'),
('I00024', 'Limão',              'Suco e raspas de limão siciliano'),
('I00025', 'Cream Cheese',       'Cream cheese cremoso'),
('I00026', 'Chocolate',          'Chocolate 70% derretido'),
('I00027', 'Morango',            'Morangos frescos fatiados'),
('I00028', 'Sorvete Baunilha',   'Bola de sorvete de baunilha'),
('I00029', 'Chantilly',          'Chantilly batido na hora'),
('I00030', 'Pão Brioche',        'Pão brioche tostado na manteiga'),
('I00031', 'Alho',               'Alho picado refogado'),
('I00032', 'Pimentão',           'Pimentão vermelho em tiras'),
('I00033', 'Milho',              'Milho verde cozido'),
('I00034', 'Cenoura',            'Cenoura ralada ou em cubos'),
('I00035', 'Pepino',             'Pepino japonês fatiado'),
('I00036', 'Atum',               'Atum em lascas temperado'),
('I00037', 'Abacaxi',            'Abacaxi grelhado em rodelas'),
('I00038', 'Espinafre',          'Espinafre refogado'),
('I00039', 'Ricota',             'Ricota fresca esfarelada'),
('I00040', 'Mel',                'Mel puro de flor de laranjeira');
GO
 
INSERT INTO Prato (idPrato, nome, porcao, valor, id_tipo) VALUES
('P00001', 'Frango Grelhado Simples',       'PEQUENO',  25.00, 1),
('P00002', 'Frango Grelhado com Ervas',     'MEDIO',    38.00, 1),
('P00003', 'Picanha Grelhada',              'GRANDE',  110.00, 1),
('P00004', 'Contra-filé ao Molho Madeira',  'MEDIO',    75.00, 1),
('P00005', 'Salmão Grelhado com Limão',     'MEDIO',    85.00, 1),
('P00006', 'Espaguete à Bolonhesa',         'MEDIO',    42.00, 2),
('P00007', 'Penne ao Molho Branco',         'MEDIO',    40.00, 2),
('P00008', 'Fettuccine ao Pesto',           'MEDIO',    45.00, 2),
('P00009', 'Lasanha de Carne',              'GRANDE',   55.00, 2),
('P00010', 'Espaguete Carbonara',           'MEDIO',    48.00, 2),
('P00011', 'Salada Caesar',                 'PEQUENO',  32.00, 3),
('P00012', 'Salada Tropical',               'PEQUENO',  28.00, 3),
('P00013', 'Salada Mediterrânea',           'MEDIO',    35.00, 3),
('P00014', 'Salada de Atum',                'PEQUENO',  30.00, 3),
('P00015', 'Salada Verde com Ricota',       'PEQUENO',  27.00, 3),
('P00016', 'Petit Gâteau de Chocolate',     'PEQUENO',  22.00, 4),
('P00017', 'Sorvete com Morango',           'PEQUENO',  18.00, 4),
('P00018', 'Mousse de Maracujá',            'PEQUENO',  20.00, 4),
('P00019', 'Torta de Limão',                'PEQUENO',  24.00, 4),
('P00020', 'Pudim de Leite',                'PEQUENO',  16.00, 4),
('P00021', 'X-Burguer Clássico',            'MEDIO',    35.00, 5),
('P00022', 'X-Bacon',                       'MEDIO',    40.00, 5),
('P00023', 'X-Frango Crocante',             'MEDIO',    38.00, 5),
('P00024', 'Hot Dog Especial',              'MEDIO',    28.00, 5),
('P00025', 'Wrap de Frango',                'PEQUENO',  32.00, 5),
('P00026', 'Camarão na Moranga',            'GRANDE',   95.00, 6),
('P00027', 'Filé de Peixe Grelhado',        'MEDIO',    60.00, 6),
('P00028', 'Moqueca de Camarão',            'GRANDE',   98.00, 6),
('P00029', 'Polvo ao Alho e Óleo',          'MEDIO',    88.00, 6),
('P00030', 'Tilápia Assada com Ervas',      'MEDIO',    55.00, 6),
('P00031', 'Bowl Vegano de Quinoa',         'MEDIO',    38.00, 7),
('P00032', 'Strogonoff de Cogumelos',       'MEDIO',    42.00, 7),
('P00033', 'Wrap Vegano de Espinafre',      'PEQUENO',  30.00, 7),
('P00034', 'Salada de Grão-de-Bico',        'PEQUENO',  26.00, 7),
('P00035', 'Risoto de Legumes',             'MEDIO',    45.00, 7),
('P00036', 'Suco de Laranja Natural',       'PEQUENO',  12.00, 8),
('P00037', 'Vitamina de Morango',           'PEQUENO',  15.00, 8),
('P00038', 'Limonada Suíça',               'PEQUENO',  14.00, 8),
('P00039', 'Água de Coco',                  'PEQUENO',   8.00, 8),
('P00040', 'Smoothie de Abacaxi',           'PEQUENO',  16.00, 8);
GO
 
INSERT INTO Cliente (cpf, nome, telefone, logradouro, numero, cep, referenciaEntrega) VALUES
('00111222333', 'Ana Clara Souza',      '(11)91111-0001', 'Rua das Flores',          10,   '01001000', 'Próximo à padaria Central'),
('00222333444', 'Bruno Lima',           '(11)92222-0002', 'Av. Paulista',            200,  '01310100', 'Em frente ao Parque Trianon'),
('00333444555', 'Carla Mendes',         '(11)93333-0003', 'Rua Augusta',             305,  '01305000', 'Ao lado da farmácia São Paulo'),
('00444555666', 'Diego Ferreira',       '(11)94444-0004', 'Rua da Consolação',       450,  '01301000', 'Portão azul'),
('00555666777', 'Elisa Rocha',          '(11)95555-0005', 'Av. Brasil',              100,  '04062000', 'Condomínio Portal, bloco B'),
('00666777888', 'Felipe Santos',        '(11)96666-0006', 'Rua Vergueiro',           600,  '04102000', 'Próximo ao metrô Vergueiro'),
('00777888999', 'Gabriela Costa',       '(11)97777-0007', 'Rua Tutóia',              88,   '04007000', 'Casa com portão marrom'),
('00888999000', 'Henrique Alves',       '(11)98888-0008', 'Rua Joaquim Távora',      22,   '04015000', 'Sobrado verde'),
('00999000111', 'Isabela Nunes',        '(11)99999-0009', 'Av. Jabaquara',           900,  '04046000', 'Em frente ao supermercado'),
('01000111222', 'João Pedro Silva',     '(11)91010-0010', 'Rua Domingos de Moraes',  77,   '04010000', 'Apartamento 42'),
('01111222333', 'Karina Oliveira',      '(11)91111-0011', 'Rua Funchal',             300,  '04551060', 'Torre A, andar 5'),
('01222333444', 'Leonardo Martins',     '(11)91212-0012', 'Av. Faria Lima',          500,  '04538133', 'Edifício Tempo, recepção'),
('01333444555', 'Mariana Pereira',      '(11)91313-0013', 'Rua Leopoldo Couto',      150,  '04542000', 'Próximo ao Shopping Iguatemi'),
('01444555666', 'Nicolas Carvalho',     '(11)91414-0014', 'Rua Gomes de Carvalho',   90,   '04547005', 'Sobrado branco com jardim'),
('01555666777', 'Olivia Ribeiro',       '(11)91515-0015', 'Av. Santo Amaro',         400,  '04506001', 'Condomínio Alamedas, portaria'),
('01666777888', 'Paulo Nascimento',     '(11)91616-0016', 'Rua Pamplona',            60,   '01405001', 'Apto 101, interfone 2'),
('01777888999', 'Quintina Araújo',      '(11)91717-0017', 'Rua Bela Cintra',         250,  '01415000', 'Portaria 24h'),
('01888999000', 'Rafael Teixeira',      '(11)91818-0018', 'Rua Oscar Freire',        400,  '01426001', 'Ao lado da Livraria Cultura'),
('01999000111', 'Sabrina Barbosa',      '(11)91919-0019', 'Av. Rebouças',            1000, '01310900', 'Próximo ao Shopping Rebouças'),
('02000111222', 'Thiago Moreira',       '(11)92020-0020', 'Rua Haddock Lobo',        35,   '01414001', 'Casa com câmera na porta'),
('02111222333', 'Ursula Cardoso',       '(11)92121-0021', 'Rua da Graça',            80,   '01214000', 'Fundos do prédio'),
('02222333444', 'Vinicius Gomes',       '(11)92222-0022', 'Av. Angélica',            500,  '01227001', 'Bloco C, apartamento 33'),
('02333444555', 'Wanda Freitas',        '(11)92323-0023', 'Rua Peixoto Gomide',      120,  '01409001', 'Em frente à praça'),
('02444555666', 'Xavier Lopes',         '(11)92424-0024', 'Rua Itapeva',             200,  '01332000', 'Prédio comercial, sala 5'),
('02555666777', 'Yasmin Castro',        '(11)92525-0025', 'Av. 9 de Julho',          700,  '01313001', 'Portaria principal'),
('02666777888', 'Zuleica Pinto',        '(11)92626-0026', 'Rua Estados Unidos',      55,   '01427001', 'Jardim com portão automático'),
('02777888999', 'Andre Melo',           '(11)92727-0027', 'Rua França',              30,   '01430010', 'Casa amarela'),
('02888999000', 'Beatriz Cruz',         '(11)92828-0028', 'Rua México',              65,   '20031144', 'Próximo ao consulado'),
('02999000111', 'Cesar Dias',           '(11)92929-0029', 'Rua Chile',               90,   '20031170', 'Edifício Atlântico, 3 andar'),
('03000111222', 'Diana Fonseca',        '(11)93030-0030', 'Av. Rio Branco',          150,  '20040006', 'Recepção do prédio'),
('03111222333', 'Eduardo Cavalcanti',   '(11)93131-0031', 'Rua Primeiro de Março',   10,   '20010000', 'Ao lado do banco'),
('03222333444', 'Flavia Monteiro',      '(11)93232-0032', 'Rua do Ouvidor',          40,   '20040030', 'Loja no térreo'),
('03333444555', 'Gustavo Borges',       '(11)93333-0033', 'Av. Presidente Vargas',   800,  '20071003', 'Torre Sul, 10 andar'),
('03444555666', 'Helena Tavares',       '(11)93434-0034', 'Rua Uruguaiana',          60,   '20050090', 'Mercadinho na esquina'),
('03555666777', 'Igor Rezende',         '(11)93535-0035', 'Rua da Carioca',          20,   '20051100', 'Sobrado cinza'),
('03666777888', 'Juliana Azevedo',      '(11)93636-0036', 'Av. Atlântica',           1000, '22021001', 'Frente à praia'),
('03777888999', 'Klaus Werner',         '(11)93737-0037', 'Rua Visconde de Piraja',  200,  '22410002', 'Próximo ao metrô Ipanema'),
('03888999000', 'Laura Campos',         '(11)93838-0038', 'Rua Garcia d''Avila',     80,   '22421010', 'Boutique no térreo'),
('03999000111', 'Marcelo Viana',        '(11)93939-0039', 'Av. Vieira Souto',        500,  '22420002', 'Cobertura, último andar'),
('04000111222', 'Natalia Drummond',     '(11)94040-0040', 'Rua Farme de Amoedo',     30,   '22420020', 'Casa de esquina com varanda');
GO
 
INSERT INTO Pedido (idPedido, ClienteCpf, dataRealizacao, valorTotal) VALUES
('D00001', '00111222333', '2024-01-05',  25.00),
('D00002', '00222333444', '2024-01-06',  38.00),
('D00003', '00333444555', '2024-01-07', 110.00),
('D00004', '00444555666', '2024-01-08',  75.00),
('D00005', '00555666777', '2024-01-09',  85.00),
('D00006', '00666777888', '2024-01-10',  84.00),
('D00007', '00777888999', '2024-01-11',  55.00),
('D00008', '00888999000', '2024-01-12',  40.00),
('D00009', '00999000111', '2024-01-13',  95.00),
('D00010', '01000111222', '2024-01-14',  48.00),
('D00011', '01111222333', '2024-01-15',  32.00),
('D00012', '01222333444', '2024-01-16',  98.00),
('D00013', '01333444555', '2024-01-17',  35.00),
('D00014', '01444555666', '2024-01-18',  60.00),
('D00015', '01555666777', '2024-01-19',  38.00),
('D00016', '01666777888', '2024-01-20',  22.00),
('D00017', '01777888999', '2024-01-21',  88.00),
('D00018', '01888999000', '2024-01-22',  45.00),
('D00019', '01999000111', '2024-01-23',  30.00),
('D00020', '02000111222', '2024-01-24',  35.00),
('D00021', '02111222333', '2024-01-25',  38.00),
('D00022', '02222333444', '2024-01-26',  75.00),
('D00023', '02333444555', '2024-01-27',  42.00),
('D00024', '02444555666', '2024-01-28',  55.00),
('D00025', '02555666777', '2024-01-29',  28.00),
('D00026', '02666777888', '2024-01-30',  95.00),
('D00027', '02777888999', '2024-02-01',  85.00),
('D00028', '02888999000', '2024-02-02',  40.00),
('D00029', '02999000111', '2024-02-03',  38.00),
('D00030', '03000111222', '2024-02-04',  60.00),
('D00031', '03111222333', '2024-02-05',  42.00),
('D00032', '03222333444', '2024-02-06',  32.00),
('D00033', '03333444555', '2024-02-07',  45.00),
('D00034', '03444555666', '2024-02-08',  98.00),
('D00035', '03555666777', '2024-02-09',  55.00),
('D00036', '03666777888', '2024-02-10',  26.00),
('D00037', '03777888999', '2024-02-11',  85.00),
('D00038', '03888999000', '2024-02-12',  38.00),
('D00039', '03999000111', '2024-02-13',  75.00),
('D00040', '04000111222', '2024-02-14',  48.00);
GO
 
INSERT INTO PratoPedido (idPrato, idPedido, quantidade) VALUES
('P00001', 'D00001', 1),
('P00002', 'D00002', 1),
('P00003', 'D00003', 1),
('P00004', 'D00004', 1),
('P00005', 'D00005', 1),
('P00006', 'D00006', 2),
('P00007', 'D00007', 1),
('P00008', 'D00008', 1),
('P00009', 'D00009', 1),
('P00010', 'D00010', 1),
('P00011', 'D00011', 1),
('P00012', 'D00012', 1),
('P00013', 'D00013', 1),
('P00014', 'D00014', 2),
('P00015', 'D00015', 1),
('P00016', 'D00016', 1),
('P00017', 'D00017', 1),
('P00018', 'D00018', 1),
('P00019', 'D00019', 1),
('P00020', 'D00020', 1),
('P00021', 'D00021', 1),
('P00022', 'D00022', 1),
('P00023', 'D00023', 1),
('P00024', 'D00024', 1),
('P00025', 'D00025', 1),
('P00026', 'D00026', 1),
('P00027', 'D00027', 1),
('P00028', 'D00028', 1),
('P00029', 'D00029', 1),
('P00030', 'D00030', 1),
('P00031', 'D00031', 1),
('P00032', 'D00032', 1),
('P00033', 'D00033', 1),
('P00034', 'D00034', 1),
('P00035', 'D00035', 1),
('P00036', 'D00036', 1),
('P00037', 'D00037', 1),
('P00038', 'D00038', 1),
('P00039', 'D00039', 1),
('P00040', 'D00040', 1);
GO
 
INSERT INTO PratoIngrediente (idPrato, idIngrediente, quantidade) VALUES
('P00001', 'I00001', 1),
('P00002', 'I00001', 1),
('P00003', 'I00002', 1),
('P00004', 'I00002', 1),
('P00005', 'I00004', 1),
('P00006', 'I00010', 2),
('P00007', 'I00011', 2),
('P00008', 'I00010', 2),
('P00009', 'I00010', 2),
('P00010', 'I00010', 2),
('P00011', 'I00005', 1),
('P00012', 'I00005', 1),
('P00013', 'I00005', 1),
('P00014', 'I00036', 1),
('P00015', 'I00039', 1),
('P00016', 'I00026', 2),
('P00017', 'I00028', 1),
('P00018', 'I00029', 1),
('P00019', 'I00024', 1),
('P00020', 'I00040', 1),
('P00021', 'I00030', 1),
('P00022', 'I00015', 1),
('P00023', 'I00001', 1),
('P00024', 'I00030', 1),
('P00025', 'I00001', 1),
('P00026', 'I00003', 2),
('P00027', 'I00004', 1),
('P00028', 'I00003', 2),
('P00029', 'I00031', 1),
('P00030', 'I00004', 1),
('P00031', 'I00020', 1),
('P00032', 'I00021', 2),
('P00033', 'I00038', 1),
('P00034', 'I00005', 1),
('P00035', 'I00020', 1),
('P00036', 'I00024', 2),
('P00037', 'I00027', 1),
('P00038', 'I00024', 2),
('P00039', 'I00040', 1),
('P00040', 'I00037', 1);
GO