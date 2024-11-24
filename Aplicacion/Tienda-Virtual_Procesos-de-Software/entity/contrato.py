class ContratoEntity:
    def __init__(self, id, fecha_inicio, fecha_finalizacion, descripcion, monto,
                 id_forma_pago, id_motivo_contrato, estado):
        self.id = id
        self.fecha_inicio = fecha_inicio.strftime('%d/%m/%Y')
        self.fecha_finalizacion = fecha_finalizacion.strftime('%d/%m/%Y')
        self.descripcion = descripcion
        self.monto = monto
        # self.forma_pago = indentificar_forma_pago_service(id_forma_pago)
        self.forma_pago = id_forma_pago
        # self.motivo_contrato = indentificar_motivo_contrato_service(id_motivo_contrato)
        self.motivo_contrato = id_motivo_contrato
        self.estado = estado
