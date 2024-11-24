def generar_variables_paginacion(page, per_page, registros):
    total_registros = len(registros)
    total_pages = (total_registros + per_page - 1) // per_page
    page = max(1, min(page, total_pages))
    start = (page - 1) * per_page
    end = start + per_page
    registros_pagina = registros[start:end]
    return registros_pagina, page, total_pages
