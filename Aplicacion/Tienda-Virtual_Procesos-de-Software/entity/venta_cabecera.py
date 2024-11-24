class VentaCabeceraEntity:
    def __init__(self, id, fecha, fecha_cancelacion, tarjeta, banco, estado, cliente):
        self.id = id
        self.fecha = fecha
        self.fecha_cancelacion = fecha_cancelacion
        self.tarjeta = tarjeta
        self.banco = banco
        self.estado = estado
        self.cliente = cliente
