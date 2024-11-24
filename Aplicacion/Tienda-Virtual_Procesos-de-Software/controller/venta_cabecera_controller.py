from flask import Blueprint, render_template, request
from service.venta_cabecera_service import listar_ventas_service
from utils.methods import generar_variables_paginacion


venta_cabecera_bp = Blueprint('ventas', __name__, url_prefix='/ventas')


@venta_cabecera_bp.route('/')
def listar_ventas():
    page = request.args.get('page', 1, type=int)
    ventas = listar_ventas_service()
    pagina, page, total_pages = generar_variables_paginacion(page, 15, ventas)
    return render_template('venta_cabecera.html', usuarios=pagina, page=page, total_pages=total_pages)
