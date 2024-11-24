from flask import Blueprint, render_template, request
from service.empleado_service import listar_empleado_service
from utils.methods import generar_variables_paginacion


empleado_bp = Blueprint('empleado', __name__, url_prefix='/empleado')


@empleado_bp.route('/')
def listar_empleado():
    page = request.args.get('page', 1, type=int)
    empleados = listar_empleado_service()
    pagina, page, total_pages = generar_variables_paginacion(page, 15, empleados)

    return render_template('empleado.html', empleados=pagina, page=page, total_pages=total_pages)


@empleado_bp.route('/editar')
def editar_empleado():
    return


@empleado_bp.route('/eliminar')
def eliminar_empleado():
    return
