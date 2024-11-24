class EmpleadoEntity:
    def __init__(self, id, dni, codigo, nombre_completo, horas_trabajo, tipo, supervisor, descripcion_contrato, sector):
        self.id = id
        self.dni = dni
        self.codigo = codigo
        self.nombre_completo = nombre_completo
        self.horas_trabajo = horas_trabajo
        self.tipo = tipo
        self.supervisor = supervisor if supervisor else 'Ninguno'
        self.descripcion_contrato = descripcion_contrato
        self.sector = sector
