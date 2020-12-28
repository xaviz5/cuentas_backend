USE cobis
GO

CREATE TABLE g2_cuenta_ahorros(
	ca_banco VARCHAR(10) NOT NULL,
	ca_fecha_creacion NVARCHAR(11) NOT NULL,
	ca_fecha_modificacion NVARCHAR(11) NOT NULL,
	ca_cliente INT NOT NULL,
	ca_saldo DECIMAL(12,2) NOT NULL
)

ALTER TABLE g2_cuenta_ahorros ADD PRIMARY KEY (ca_banco)

