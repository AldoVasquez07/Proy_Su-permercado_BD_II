from entity.empleado import EmpleadoEntity
from security.conexion import obtener_conexion


def listar_empleado_service():
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    cursor.execute('SELECT * FROM vw_empleados')
    empleados = []

    for fila in cursor.fetchall():
        empleado = EmpleadoEntity(
            id=fila.id,
            dni=fila.dni,
            codigo=fila.codigo,
            nombre_completo=fila.nombre_completo,
            horas_trabajo=fila.horas_trabajo,
            tipo=fila.tipo,
            supervisor=fila.supervisor,
            descripcion_contrato=fila.descripcion_contrato,
            sector=fila.sector
        )
        empleados.append(empleado)

    cursor.close()
    conexion.close()

    return empleados
