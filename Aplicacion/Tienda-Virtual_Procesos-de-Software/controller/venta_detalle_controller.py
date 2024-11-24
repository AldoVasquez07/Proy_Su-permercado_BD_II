from flask import Blueprint, render_template
from service.venta_detalle_service import listar_venta_detalle_service

venta_detalle_bp = Blueprint('venta_detalle', __name__, url_prefix='/venta_detalle')


@venta_detalle_bp.route('/<int:id_venta_cabecera>')
def listar_detalle_venta(id_venta_cabecera):
    ventas = listar_venta_detalle_service(id_venta_cabecera)

    total = 0

    for venta in ventas:
        total += venta.precio

    return render_template('venta_detalle.html', ventas=ventas, total=total)
