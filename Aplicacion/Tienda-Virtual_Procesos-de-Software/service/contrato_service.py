from entity.contrato import ContratoEntity
from security.conexion import obtener_conexion


def listar_contrato_service():
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    cursor.execute('SELECT * FROM vw_contrato')
    contratos = []

    for fila in cursor.fetchall():
        contrato = ContratoEntity(
            id=fila.id,
            fecha_inicio=fila.fecha_inicio,
            fecha_finalizacion=fila.fecha_finalizacion,
            descripcion=fila.descripcion,
            monto=fila.monto,
            id_forma_pago=fila.forma,
            id_motivo_contrato=fila.motivo,
            flag=fila.flag
        )
        contratos.append(contrato)

    cursor.close()
    conexion.close()

    return contratos


"""def indentificar_motivo_contrato_service(id):
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    query = f'SELECT * FROM adm.motivo_contrato WHERE id={id}'
    cursor.execute(query)
    motivo_contrato = cursor.fetchone()
    cursor.close()
    conexion.close()
    return motivo_contrato.motivo
"""