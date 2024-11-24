from entity.usuario import UsuarioEntity
from security.conexion import obtener_conexion


def listar_usuario_service():
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    cursor.execute('SELECT * FROM vw_usuario')
    usuarios = []

    for fila in cursor.fetchall():
        usuario = UsuarioEntity(
            id=fila.id,
            codigo=fila.codigo,
            dni=fila.dni,
            usuario=fila.usuario,
            correo=fila.correo,
            flag=fila.flag
        )
        usuarios.append(usuario)

    cursor.close()
    conexion.close()

    return usuarios
