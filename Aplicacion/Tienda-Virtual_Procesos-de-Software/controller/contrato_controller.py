from flask import Blueprint, render_template, request
from service.contrato_service import listar_contrato_service
from utils.methods import generar_variables_paginacion


contrato_bp = Blueprint('contrato', __name__, url_prefix='/contrato')


@contrato_bp.route('/')
def listar_contrato():
    page = request.args.get('page', 1, type=int)
    contratos = listar_contrato_service()
    pagina, page, total_pages = generar_variables_paginacion(page, 15, contratos)

    return render_template('contrato.html', contratos=pagina, page=page, total_pages=total_pages)


@contrato_bp.route('/editar')
def editar_contrato():
    return


@contrato_bp.route('/eliminar')
def eliminar_contrato():
    return
