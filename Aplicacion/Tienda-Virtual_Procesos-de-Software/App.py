from collections import defaultdict
from flask import Flask, render_template
from security.conexion import obtener_conexion
import matplotlib.pyplot as plt
import io
import base64
from analyser.graphics import graphic_ventas_sucursales, graphic_empleados_sucursales, graphic_empresas_sucursales
from controller.empleado_controller import empleado_bp
from controller.contrato_controller import contrato_bp
from controller.forma_pago_controller import forma_pago_bp
from controller.motivo_contrato_controller import motivo_contrato_bp
from controller.usuario_controller import usuario_bp
from controller.venta_cabecera_controller import venta_cabecera_bp
from controller.venta_detalle_controller import venta_detalle_bp


app = Flask(__name__)
app.register_blueprint(empleado_bp)
app.register_blueprint(contrato_bp)
app.register_blueprint(forma_pago_bp)
app.register_blueprint(motivo_contrato_bp)
app.register_blueprint(usuario_bp)
app.register_blueprint(venta_cabecera_bp)
app.register_blueprint(venta_detalle_bp)



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
