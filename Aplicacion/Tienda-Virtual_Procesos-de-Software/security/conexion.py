import pyodbc


def obtener_conexion():
    parametros = obtener_parametros_conexion()
    conexion_cad = f'DRIVER={{{parametros[0]}}};SERVER={parametros[1]};DATABASE={parametros[2]};Trusted_Connection={parametros[3]};'
    try:
        conexion = pyodbc.connect(conexion_cad)
        return conexion
    except Exception as e:
        print("Error al conectar a la base de datos:", e)
    return


def obtener_parametros_conexion():
    parametros = []
    with open('ambiente.arv', 'r') as file:
        for parametro in file:
            parametro = parametro.strip()
            parametros.append(parametro)
    return parametros
