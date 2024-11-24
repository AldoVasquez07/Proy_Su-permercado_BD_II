from entity.motivo_contrato import MotivoContratoEntity
from security.conexion import obtener_conexion


def listar_motivo_contrato_service():
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    cursor.execute('SELECT * FROM adm.motivo_contrato')
    motivo_contratos = []

    for fila in cursor.fetchall():
        motivos = MotivoContratoEntity(
            id=fila.id,
            motivo=fila.motivo,
            estado=fila.estado
        )
        motivo_contratos.append(motivos)

    cursor.close()
    conexion.close()

    return motivo_contratos


def indentificar_motivo_contrato_service(id):
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    query = f'SELECT * FROM adm.motivo_contrato WHERE id={id}'
    cursor.execute(query)
    motivo_contrato = cursor.fetchone()
    cursor.close()
    conexion.close()
    return motivo_contrato.motivo
