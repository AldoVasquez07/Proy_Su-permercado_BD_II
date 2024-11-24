from entity.venta_cabecera import VentaCabeceraEntity
from security.conexion import obtener_conexion


def listar_ventas_service():
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    cursor.execute('SELECT * FROM vw_ventas_cabecera')
    venta_cabecera = []

    for fila in cursor.fetchall():
        venta = VentaCabeceraEntity(
            id=fila.id,
            fecha=fila.fecha,
            fecha_cancelacion=fila.fecha_cancelacion,
            tarjeta=fila.tarjeta,
            banco=fila.banco,
            flag=fila.flag,
            cliente=fila.cliente
        )
        venta_cabecera.append(venta)

    cursor.close()
    conexion.close()

    return venta_cabecera
