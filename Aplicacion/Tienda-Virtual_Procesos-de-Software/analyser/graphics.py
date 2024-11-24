from collections import defaultdict
from security.conexion import obtener_conexion
import matplotlib.pyplot as plt
import io
import base64


def data_cubos(query):
    con = obtener_conexion()
    cursor = con.cursor()
    try:
        cursor.execute(query)
        data = cursor.fetchall()
    except Exception as e:
        print(f"Error ejecutando la consulta: {e}")
        return "Error: No se pudo ejecutar la consulta"
    finally:
        con.close()

    if not data:
        print("La consulta no devolvió resultados.")
        return "Error: La consulta no devolvió resultados."

    return data


def graphic_ventas_sucursales():
    data = data_cubos('SELECT sucusal, sector, cantidad_ventas FROM vw_sucursal_sector_ventas')
    try:
        ventas_por_sucursal = defaultdict(int)

        for row in data:
            sucursal = row[0]
            ventas_por_sucursal[sucursal] += row[2]

        sucursales = list(ventas_por_sucursal.keys())
        cantidades_ventas = list(ventas_por_sucursal.values())

    except IndexError as e:
        print(f"Error procesando los datos: {e}")
        return "Error: Problema con la estructura de los datos"

    # Crear gráfico
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.bar(sucursales, cantidades_ventas, color='blue', alpha=0.7)

    ax.set_xlabel('Sucursales')
    ax.set_ylabel('Cantidad de Ventas')
    ax.set_title('Cantidad de Ventas por Sucursal')

    ax.set_xticklabels([])

    img = io.BytesIO()
    plt.tight_layout()
    plt.savefig(img, format='png')
    img.seek(0)
    graph_url = base64.b64encode(img.getvalue()).decode('utf8')
    plt.close(fig)

    return graph_url


def graphic_empleados_sucursales():
    data = data_cubos('SELECT sucursal, cantidad_empleados FROM vw_sucursal_empleados')

    try:
        empleados_por_sucursal = defaultdict(int)

        for row in data:
            sucursal = row[0]  # Nombre de la sucursal
            empleados_por_sucursal[sucursal] += row[1]  # Sumar cantidad de empleados

        sucursales = list(empleados_por_sucursal.keys())
        cantidades_empleados = list(empleados_por_sucursal.values())

    except IndexError as e:
        print(f"Error procesando los datos: {e}")
        return "Error: Problema con la estructura de los datos"

    # Crear gráfico
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.bar(sucursales, cantidades_empleados, color='green', alpha=0.7)

    # Personalizar gráfico
    ax.set_xlabel('Sucursales')
    ax.set_ylabel('Cantidad de Empleados')
    ax.set_title('Cantidad de Empleados por Sucursal')

    # Eliminar etiquetas de sucursales del eje X
    ax.set_xticklabels([])

    # Guardar gráfico en memoria
    img = io.BytesIO()
    plt.tight_layout()
    plt.savefig(img, format='png')
    img.seek(0)
    graph_url = base64.b64encode(img.getvalue()).decode('utf8')
    plt.close(fig)

    return graph_url


def graphic_empresas_sucursales():
    data = data_cubos('SELECT sucursal, cantidad_empresas FROM vw_sucursal_empresas')

    try:
        empresas_por_sucursal = defaultdict(int)

        for row in data:
            sucursal = row[0]  # Nombre de la sucursal
            empresas_por_sucursal[sucursal] += row[1]  # Sumar cantidad de empresas

        sucursales = list(empresas_por_sucursal.keys())
        cantidades_empresas = list(empresas_por_sucursal.values())

    except IndexError as e:
        print(f"Error procesando los datos: {e}")
        return "Error: Problema con la estructura de los datos"

    # Crear gráfico
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.bar(sucursales, cantidades_empresas, color='orange', alpha=0.7)

    # Personalizar gráfico
    ax.set_xlabel('Sucursales')
    ax.set_ylabel('Cantidad de Empresas')
    ax.set_title('Cantidad de Empresas por Sucursal')

    # Eliminar etiquetas de sucursales del eje X
    ax.set_xticklabels([])

    # Guardar gráfico en memoria
    img = io.BytesIO()
    plt.tight_layout()
    plt.savefig(img, format='png')
    img.seek(0)
    graph_url = base64.b64encode(img.getvalue()).decode('utf8')
    plt.close(fig)

    return graph_url

