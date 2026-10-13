def test_apache_installed(host):
    """Verifica se o apache está instalado"""
    apache = host.package("apache2")
    assert apache.is_installed
    assert apache.version.startswith("2.")

def test_apache_running_and_enabled(host):
    """Assegura que o apache está sendo executado"""
    service = host.service("apache2")
    assert service.is_running
    assert service.is_enabled

def test_apache_listening(host):
    """Verifica se o Apache escuta na porta 80 (IPv4 ou IPv6)."""
    ipv4 = host.socket("tcp://0.0.0.0:80").is_listening
    ipv6 = host.socket("tcp://:::80").is_listening
    assert ipv4 or ipv6

def test_index_page(host):
    """Assegura que o index.html tenha sido copiado"""
    cmd = host.run("curl -s http://localhost")
    assert cmd.rc == 0
    assert "Home" in cmd.stdout
