from flask import Blueprint, render_template, request
from service.forma_pago_service import listar_forma_pago_service
from utils.methods import generar_variables_paginacion

forma_pago_bp = Blueprint('forma_pago', __name__, url_prefix='/forma_pago')


@forma_pago_bp.route('/')
def listar_forma_pago():
    page = request.args.get('page', 1, type=int)
    forma_pago = listar_forma_pago_service()
    pagina, page, total_pages = generar_variables_paginacion(page, 15, forma_pago)
    return render_template('forma_pago.html', forma_pago=pagina, page=page, total_pages=total_pages)


@forma_pago_bp.route('/editar')
def editar_forma_pago():
    return


@forma_pago_bp.route('/eliminar')
def eliminar_forma_pago():
    return
