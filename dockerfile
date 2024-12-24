FROM odoo:17

USER root

# Instalamos dependencias necesarias
RUN apt-get update && apt-get install -y \
    emacs\
    htop\
    mc\
    git \
    build-essential \
    libssl-dev \
    python3-dev \
    python3-pip \
    python3-venv \
    swig \
    && rm -rf /var/lib/apt/lists/*

# Creamos un entorno virtual para Python e instalamos Elpy y sus dependencias
RUN python3 -m venv /opt/elpy_env && \
    /opt/elpy_env/bin/pip install --no-cache-dir elpy jedi black flake8 autopep8 rope pyOpenSSL httplib2>=0.7 git+https://github.com/reingart/pyafipws

# Configuramos Emacs para usar MELPA y habilitar Elpy
RUN mkdir -p /root/.emacs.d && \
    echo "(require 'package)" >> /root/.emacs.d/init.el && \
    echo "(add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\"))" >> /root/.emacs.d/init.el && \
    echo "(package-initialize)" >> /root/.emacs.d/init.el && \
    echo "(unless package-archive-contents (package-refresh-contents))" >> /root/.emacs.d/init.el && \
    echo "(package-install 'elpy)" >> /root/.emacs.d/init.el && \
    echo "(elpy-enable)" >> /root/.emacs.d/init.el && \
    echo "(setq python-shell-interpreter \"/opt/elpy_env/bin/python3\")" >> /root/.emacs.d/init.el



# Copia el archivo odoo.conf al contenedor
COPY odoo.conf /etc/odoo/

# Cambiar permisos para el usuario odoo
RUN chown odoo:odoo /etc/odoo/odoo.conf




# Regresamos al usuario odoo por seguridad
USER odoo
