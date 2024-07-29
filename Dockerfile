FROM reyesoft/php-mysql56

# 替换为合适的源列表（如果需要）
COPY sources.list /etc/apt/sources.list

# 安装必要的软件包并添加 PHP 源
RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y apache2 libapache2-mod-php7.1 libapache2-mod-security2 \
    && rm -rf /var/www/html/* \
    && a2enmod rewrite \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 复制应用程序和配置文件
COPY dump.sql /dump.sql
COPY source /var/www/html
COPY flag /flag
COPY start.sh /start.sh
COPY php.ini /etc/php/7.1/apache2/php.ini
COPY default.conf /etc/apache2/sites-available/000-default.conf
COPY my.cnf /etc/mysql/conf.d/mysql.cnf
COPY rm.sh /root/rm.sh

# 确保启动脚本可执行
RUN chmod +x /start.sh

# 设置工作目录
WORKDIR /var/www/html

# 定义容器启动时执行的命令
ENTRYPOINT ["/start.sh"]
