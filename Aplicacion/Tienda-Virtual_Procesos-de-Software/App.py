from collections import defaultdict
from flask import Flask, render_template
from security.conexion import obtener_conexion
import matplotlib.pyplot as plt
import io
import base64

from analyser.graphics import graphic_ventas_sucursales, graphic_empleados_sucursales, graphic_empresas_sucursales

app = Flask(__name__)


@app.route('/')
def menu():
    ventas_graph_url = graphic_ventas_sucursales()
    empleados_graph_url = graphic_empleados_sucursales()
    empresas_graph_url = graphic_empresas_sucursales()

    return render_template('menu_supermercado.html',
                           ventas_graph_url=ventas_graph_url,
                           empleados_graph_url=empleados_graph_url,
                           empresas_graph_url=empresas_graph_url)


if __name__ == '__main__':
    app.run(debug=True)
