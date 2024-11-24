from flask import Blueprint, render_template, request
from service.usuario_service import listar_usuario_service
from utils.methods import generar_variables_paginacion

usuario_bp = Blueprint('usuario', __name__, url_prefix='/usuarios')

@usuario_bp.route('/')
def listar_usuarios():
    page = request.args.get('page', 1, type=int)
    usuarios = listar_usuario_service()
    pagina, page, total_pages = generar_variables_paginacion(page, 15, usuarios)
    return render_template('usuarios.html', usuarios=pagina, page=page, total_pages=total_pages)


