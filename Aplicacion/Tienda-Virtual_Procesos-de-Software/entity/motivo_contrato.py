class MotivoContratoEntity:
    def __init__(self, id, motivo, flag):
        self.id = id
        self.motivo = motivo
        self.flag = 'Activo' if flag else 'Inactivo'
