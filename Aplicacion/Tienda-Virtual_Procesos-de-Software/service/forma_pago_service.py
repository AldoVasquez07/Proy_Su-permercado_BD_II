from entity.forma_pago import FormaPagoEntidad
from security.conexion import obtener_conexion


def listar_forma_pago_service():
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    cursor.execute('SELECT * FROM ven.forma_pago')
    formas_pago = []

    for fila in cursor.fetchall():
        forma_pago = FormaPagoEntidad(
            id=fila.id,
            forma=fila.forma,
            flag=fila.flag
        )
        formas_pago.append(forma_pago)

    cursor.close()
    conexion.close()

    return formas_pago


def indentificar_forma_pago_service(id):
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    query = f'SELECT * FROM ven.forma_pago WHERE id={id}'
    cursor.execute(query)
    forma_pago = cursor.fetchone()
    cursor.close()
    conexion.close()
    return forma_pago.forma
