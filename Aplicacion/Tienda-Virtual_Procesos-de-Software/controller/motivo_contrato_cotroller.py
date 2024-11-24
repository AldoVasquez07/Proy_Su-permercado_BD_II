from flask import Blueprint, render_template, request
from service.motivo_contrato_service import listar_motivo_contrato_service

motivo_contrato_bp = Blueprint('motivo_contrato', __name__, url_prefix='/motivo_contrato')


@motivo_contrato_bp.route('/')
def listar_motivo_contrato():
    page = request.args.get('page', 1, type=int)
    per_page = 15

    motivos = listar_motivo_contrato_service()

    total_contratos = len(motivos)
    total_pages = (total_contratos + per_page - 1) // per_page

    start = (page - 1) * per_page
    end = start + per_page
    motivo_contrato = motivos[start:end]

    return render_template('motivo_contrato.html', motivo_contrato=motivo_contrato, page=page, total_pages=total_pages)


@motivo_contrato_bp.route('/editar')
def editar_motivo_contrato():
    return


@motivo_contrato_bp.route('/eliminar')
def eliminar_motivo_contrato():
    return
