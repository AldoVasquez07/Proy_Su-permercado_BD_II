from entity.venta_detalle import VentaDetalleEntity
from security.conexion import obtener_conexion


def listar_venta_detalle_service(id_venta_cabecera):
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    query = f'SELECT * FROM vw_venta_detalle WHERE id_venta_cabecera={id_venta_cabecera}'
    cursor.execute(query)
    detalles = []

    for fila in cursor.fetchall():
        detalle = VentaDetalleEntity(
            id_venta_cabecera=fila.id_venta_cabecera,
            nombre=fila.nombre,
            descripcion=fila.descripcion,
            precio=fila.precio
        )
        detalles.append(detalle)

    cursor.close()
    conexion.close()

    return detalles
