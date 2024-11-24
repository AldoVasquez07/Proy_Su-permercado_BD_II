class UsuarioEntity:
    def __init__(self, id, codigo, dni, usuario, correo, flag):
        self.id = id
        self.codigo = codigo
        self.dni = dni
        self.usuario = usuario
        self.correo = correo
        self.flag = 'Activo' if flag else 'Inactivo'
